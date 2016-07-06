# sshfs-home

Requirements
------
- openssh
- sshfs

Getting Started
------

`cd` into your the code directory

`cd sshfs-home`

Run the setup.sh script as root to setup and install this daemon.

`sudo ./setup.sh`

Caveats
-------
- In order for this daemon to work properly, the target user must exist on
	both machines with the same UID and GID.
- Certain applications with lock files in `$HOME` will refuse to work with
	default arguments (e.g. Chromium, et al.)

