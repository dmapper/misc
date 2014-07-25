#!/bin/sh

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
apt-get install nodejs redis-server mongodb-org nginx
npm install -g forever grunt-cli

# Generate keys
su ubuntu -c 'ssh-keygen'
cat id_rsa.pub > known_hosts
