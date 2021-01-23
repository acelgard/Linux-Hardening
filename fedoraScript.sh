#1/14/2021
#script to harden Linux operating systems (RHEL)
echo "Begining hardening script ..."
sudo yum install vim aide tmux iptables ntpdate -y
sudo yum install iptables-services -y
aide --init
mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz

touch /var/fedoscriptlog.txt

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
iptables -A INPUT -p udp --dport 123 -j ACCEPT
iptables -A INPUT -p tcp --dport 123 -j ACCEPT

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

echo "creating NTP server ..."
systemctl stop chronyd
systemctl disable chronyd
systemctl start ntpd
systemctl enable ntpd
echo "# For more information about this file, see the ntp.conf(5) man page.

# Record the frequency of the system clock.
driftfile /var/lib/ntp/drift

# Permit time synchronization with our time source, but do not
# permit the source to query or modify the service on this system.
restrict default nomodify notrap nopeer noepeer noquery

# Permit association with pool servers.
restrict source nomodify notrap noepeer noquery

# Permit all access over the loopback interface.  This could
# be tightened as well, but to do so would effect some of
# the administrative functions.
restrict 127.0.0.1 
restrict ::1

# Hosts on local network are less restricted.
#restrict 192.168.1.0 mask 255.255.255.0 nomodify notrap
restrict 172.20.240.0 mask 255.255.255.0 nomodify notrap limited
restrict 172.20.241.0 mask 255.255.255.0 nomodify notrap limited
restrict 172.20.242.0 mask 255.255.255.0 nomodify notrap limited

# Use public servers from the pool.ntp.org project.
# Please consider joining the pool (http://www.pool.ntp.org/join.html).
   server 0.north-america.pool.ntp.org iburst
   server 1.north-america.pool.ntp.org iburst
   server 2.north-america.pool.ntp.org iburst
   server 3.north-america.pool.ntp.org iburst

# Reduce the maximum number of servers used from the pool.
tos maxclock 5

# Enable public key cryptography.
#crypto

includefile /etc/ntp/crypto/pw

# Key file containing the keys and key identifiers used when operating
# with symmetric key cryptography. 
keys /etc/ntp/keys

# Specify the key identifiers which are trusted.
#trustedkey 4 8 42

# Specify the key identifier to use with the ntpdc utility.
#requestkey 8

# Specify the key identifier to use with the ntpq utility.
#controlkey 8

# Enable writing of statistics records.
#statistics clockstats cryptostats loopstats peerstats" > /etc/ntp.conf

#################################################
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
# Don't forget to add or adjust IP restrictions #
#################################################
systemctl restart ntpd
systemctl status ntpd >> /var/fedoscriptlog.txt
#check to see if ip addr changed from 172.20.2**.**
#if they did adjust /etc/ntp.conf

#status readouts
ntpq -p >> /var/fedoscriptlog.txt
ntpq -p
iptables -L -v
iptables -L -v >> /var/fedoscriptlog.txt
systemctl status iptables
systemctl status iptables >> /var/fedoscriptlog.txt
echo "saving iptable rules"
/sbin/iptables-save > /etc/sysconfig/iptables
echo "testing if selinux is online"
sestatus >> /var/fedoscriptlog.txt
sestatus
getenforce >> /var/fedoscriptlog.txt
getenforce
ntpdate -u 127.0.0.1


