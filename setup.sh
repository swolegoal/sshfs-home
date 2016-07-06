#!/bin/bash


if [ "$(whoami)" != "root" ] ; then
        echo -e "This command can only be run as root\n"
	exit
fi



