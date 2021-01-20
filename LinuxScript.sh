#1/14/2021
#script to harden Linux operating systems
echo "Begining harding script ..."
@echo off
sudo yum install aide tmux iptables
sudo yum install iptables-services -y

#systemctl stop firewalld
#systemctl disable firewalld
#systemctl start iptables
#systemctl status iptables


rm /etc/issue
echo -e "WARNING! Access to this device is restricted to those individuals with specific
Permissions. If you are not an authorized user, disconnect now.
Any attempts to gain unauthorized access will be prosecuted to
the fullest extent of the law" >> /etc/issue
