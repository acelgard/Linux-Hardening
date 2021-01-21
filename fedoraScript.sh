#1/14/2021
#script to harden Linux operating systems
echo "Begining hardening script ..."
sudo yum install vim aide tmux iptables -y
sudo yum install iptables-services -y
aide -init
mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz

#setup firewall
systemctl stop firewalld
systemctl disable firewalld
systemctl start iptables
systemctl enable iptables
systemctl stop ip6tables
systemctl disable ip6tables
#firewall rule chain
iptables -P INPUT ACCEPT
iptables -F
iptables -A INPUT -i lo -j ACCEPT 
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 110 -j ACCEPT
iptables -A INPUT -p tcp --dport 143 -j ACCEPT
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT


#stop ssh
systemctl stop sshd.service
systemctl disable sshd.service

rm /etc/issue
echo -e "WARNING! Access to this device is restricted to those individuals with specific
Permissions. If you are not an authorized user, disconnect now.
Any attempts to gain unauthorized access will be prosecuted to
the fullest extent of the law" >> /etc/issue

iptables -L -v
systemctl status iptables
echo "saving iptable rules"
/sbin/iptables-save > /etc/sysconfig/iptables
echo "testing if selinux is online"
sestatus
getenforce




