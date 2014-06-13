#!/bin/bash

clear

shell="/bin/bash"

this=`basename $0`
args=($@)
numargs=$#
EXPECTED_ARGS=3

#echo "this = $this"
#echo "arg0: ${args[0]}"
#echo "arg1: ${args[1]}"
#echo "arg2: ${args[2]}"
#echo "args total: $numargs"

#
#for example, these values will pass in from the command line
#
#environment="dev_env_key"
#username="devuser1"
#friendlyname="Test DevUser1"

environment="${args[0]}"
username="${args[1]}"
friendlyname="${args[2]}"

if [ $numargs -ne $EXPECTED_ARGS ]
    then
        echo ""
        echo "#############################################################################"
        echo "#"
        echo "# Usage: "
        echo "#         ./$this <environment> <username> <friendly_name> "
        echo "#"
        echo "#############################################################################"
        echo ""
        exit;
fi

echo "#########################################################################"
echo "# Create user ( $username ) on host ( $HOSTNAME )"
echo "#########################################################################"

#echo "environment: $environment"
#echo "username: $username"
#echo "friendlyname: $friendlyname"

useradd -c "${friendlyname}" -s $shell -m $username

userhome="/home/${username}"
mkdir $userhome/.ssh

chmod 700 ${userhome}/.ssh
chown ${username}:${username} ${userhome}/.ssh

cd ${userhome}/.ssh

keyname="${environment}_${username}"

pwd
ssh-keygen -b 2048 -f $keyname -t rsa

cat ${userhome}/.ssh/${keyname}.pub >> ${userhome}/.ssh/authorized_keys
chmod 600 ${userhome}/.ssh/authorized_keys
chown ${username}:${username} ${userhome}/.ssh/authorized_keys

echo "##############################################################################"
echo "From the client side, perform these steps:"
echo "copy private ssh key, ${userhome}/.ssh/${keyname} , to your client machine"
echo ""
echo "##############################################################################"
echo "then, connect from client machine to ec2 instance.  For example: "
echo ""
host="sample-aws-ec2-host.com"
echo "ssh -i ${keyname} ${username}@$host"
echo ""

