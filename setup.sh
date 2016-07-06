#!/bin/bash

function copy_key {
	echo "Copying public key to server..."
	cat /root/.ssh/id_rsa.pub | ssh $2@$1 \
		'cat >> .ssh/authorized_keys'

	echo "Ensuring secure ~/.ssh permissions on the server..."
	ssh $2@$1 "chmod 700 .ssh; chmod 640 .ssh/authorized_keys"

	ssh $2@$1 'echo "SSH configuration complete."'
}

function create_key {
	if [ ! -f /root/.ssh/id_rsa ] ; then
		echo "Creating key..."
		echo "Please note that this program currently does not support"\
			"keys with passwords.  Please leave the id_rsa in the"\
			"default location \"/root/.ssh/id_rsa\"."
		ssh-keygen -t rsa -b 4096

		copy_key $1 $2
	else
		ssh -i /root/.ssh/id_rsa $2@$1 'echo "KEY test"'
		status=$?

		if [ $status -ne 0 ] ; then
			copy_key $1 $2
		else
			echo 'Key exists on remote server!'
		fi
	fi
}

echo 'PLEASE NOTE: In order for this daemon to work properly, the target user'\
	'must exist on both machines with the same UID and GID.'

if [ "$(whoami)" != "root" ] ; then
        echo -e "This command can only be run as root\n"
	exit
fi

read -p 'Enter the IP address of the remote server: ' ip
sed -i '5s/.*/remote_ip=\"'$ip'\"/' sshfs-home

read -p 'Enter the target username: ' un
sed -i '6s/.*/remote_ip=\"'$un'\"/' sshfs-home

create_key $ip $un

sed -i '9s/.*/id_file=\"/root/.ssh/id_rsa\"/' sshfs-home

uid=$(id -u $un)
gid=$(id -g $un)

sed -i '7s/.*/uid=\"'$uid'\"/' sshfs-home
sed -i '8s/.*/gid=\"'$gid'\"/' sshfs-home

if [ -d /home/$un ] ; then
	mv /home/$un /home/$un.bak
	mkdir /home/$un
	chown -R $un /home/$un
	chown $un /home/$un
else 
	mkdir /home/$un
	chown -R $un /home/$un
	chown $un /home/$un
fi

sed -i '4s/.*/remote_path=\"/home/'$un'\"/' sshfs-home
