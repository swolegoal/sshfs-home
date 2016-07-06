#!/bin/bash

#function create_key {

#}

if [ "$(whoami)" != "root" ] ; then
        echo -e "This command can only be run as root\n"
	exit
fi

read -p 'Enter the IP address of the remote server: ' ip
sed -i '5s/.*/remote_ip=\"'$ip'\"/' sshfs-home
