#!/bin/sh
# Script to setup an Ubuntu VPS/cloud server to be ready for use with Derby.js
# Should be run on a newly created server under root.
# Configuration used for testing: Ubuntu 14.04 x64 of Digital Ocean
# Author: Pavel Zhukov <cray0000@gmail.com>

# Add 'ubuntu' user and allow it to run 'sudo' with no password
adduser ubuntu
echo "ubuntu  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

apt-get update
apt-get dist-upgrade -y
apt-get install software-properties-common python-software-properties

# Redis
add-apt-repository ppa:chris-lea/redis-server

# Node.js
add-apt-repository ppa:chris-lea/node.js

# Mongodb
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list

# Nginx
add-apt-repository ppa:nginx/stable

# Install everything
apt-get update
apt-get install git nodejs redis-server mongodb-org nginx
npm install -g forever grunt-cli

# Generate keys
su ubuntu -c 'ssh-keygen'
su ubuntu -c 'cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys'

# Prevent users from logging in with password. Allow only private keys auth.
echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config

# Print private key to connect to the server
echo ''
echo '/----------------------------------------------------\'
echo '|   !! Save the following key into MY_SERVER.pem !!  |'
echo '\----------------------------------------------------/
echo ''
cat /home/ubuntu/.ssh/id_rsa
echo ''
echo 'Installation finished! Next steps:'
echo '1. Copy-paste the private key printed higher into MY_SERVER.pem on your computer'
echo "2. You'll be able to ssh into server with:"
echo '   $ ssh -i /path/to/MY_SERVER.pem ubuntu@SERVER_IP'
echo "3. You can run root commands with 'sudo' when you need (doesn't require password)."
echo "4. If you want to become root, run:"
echo '   $ sudo -i'
echo "5. Now reboot the server with 'reboot',"
echo "   wait a while until it reboots,"
echo "   then ssh into it as told in item 2 of this list"
echo "   and continue to setting it up for deployment."
