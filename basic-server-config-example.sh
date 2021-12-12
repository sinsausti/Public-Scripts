#!/bin/bash

### BASIC SERVER CONFIGURATIONS - EXAMPLE ###
#@author	Sebastian Insausti <sinsausti.uy@gmail.com>
#@since		2021-12-11

#HOSTS
for i in $(seq 1 254)
do
        echo 10.10.10.$i       $i >> /etc/hosts
done

#MASKS
echo 'umask 002' >> /etc/profile
echo 'export HISTCONTROL=ignoreboth' >> /etc/profile
echo 'export HISTSIZE=5000' >> /etc/profile
echo 'export HISTFILESIZE=1000' >> /etc/profile
echo 'export HISTIGNORE=clear:su:pwd:history:htpasswd' >> /etc/profile
echo 'export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S > "' >> /etc/profile

#BASH
sed -i "s#SHELL=/bin/sh#SHELL=/bin/bash#" /etc/default/useradd

#USERS AND GROUPS
groupadd admin -g1001; useradd -m admin -u1001 -g1001
groupadd dba -g1002; useradd -m dba -u1002 -g1002

adduser www-data admin

#DIRECTORIES
mkdir -p /data/dir1

ln -s /data/dir1 /dir1

chown -R admin:admin /data/dir1

#BASIC SOFTWARE
apt update
apt install wget net-tools screen curl
