#1/14/2021
#script to harden Linux operating systems
echo "Begining harding script ..."
@echo off
sudo yum install aide tmux iptables
sudo yum install iptables-services -y

systemctl stop firewalld
systemctl disable firewalld
systemctl start iptables
systemctl status iptables


