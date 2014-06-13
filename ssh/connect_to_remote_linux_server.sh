#!/usr/bin/bash

host="<remote_ip_address>"
keys="<key_dir>"
keyfile="privatekey.pem"
username="devuser1"

command="ssh -i $keys/$keyfile $username@$host"
echo $command
$command
