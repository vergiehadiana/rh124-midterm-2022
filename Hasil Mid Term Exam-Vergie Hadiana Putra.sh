#!/bin/bash
## Author: Vergie Hadiana Putra
## Nomor Registrasi DTS PROA LINUX 4D: 152361164101-385 
## Linkedln: https://www.linkedin.com/in/vergiehadiana/
## PurPose: Answer Mid Term Exam Shell Script (Must Run on ROOT User)
## Date Created: 08 Oct 2022 - Due Date 09 Oct 2022 23:59 
## Link Google Class: https://classroom.google.com/c/NTQ3NzUxNDEwODgy/a/NTAyNTMxNDk2NTQy/details

if [[ "${UID}" -ne 0 ]]; then
    echo " You need to run this script as root on Server A"
    exit 1
fi

echo 'Shell Running Started...'
echo 'Answer for SERVER A...'
#ssh root@servera

#echo 'Running Prerequites Script...'
#curl -k https://deploy.benyamin.xyz/rha/exam.sh -o exam.sh; chmod +x exam.sh; sudo ./exam.sh

echo -ne '\n'
echo -ne '	                     		(0%)\r'
echo -ne '\n'
# Nomor 1 - Create a New Groups, named consultant, with group id 1100
groupadd -g 1100 consultant
cat << EOF > /etc/sudoers.d/consultant
%consultant  ALL=(ALL) ALL
EOF
echo -ne '#                     		(4%)\r'
sleep 1
echo -ne '\n'

# Nomor 2 - Create a new user consultantl, consultant2, and consultant3, then assign their secondary group to consultant. 
# 			For user consultantl, please assign user id 1100. Use their username as their password!
useradd -aG consultant consultant1
useradd -aG consultant consultant2
useradd -aG consultant consultant3

echo "consultant1" | passwd consultant1 --stdin
echo "consultant2" | passwd consultant2 --stdin
echo "consultant3" | passwd consultant3 --stdin

echo -ne '##			             	(8%)\r'
sleep 1
echo -ne '\n'

# Nomor 3 - Please troubleshoot why consultantl can't access /data/consultant1 folder, even it's owned by consultantl. Please fix that folder.
ls -lah /data/consultant1
chown consultant1:consultant /data/consultant1
chmod 2770 /data/consultant1
echo "consultant1" | sudo -u consultant1 -S touch /data/consultant1/testfile
ls -lah /data/consultant1

echo -ne '###			             	(12%)\r'
sleep 1
echo -ne '\n'

# Nomor 4 - These consultant account, need to be expired at 2022-11-10 20:00, please set this expiration to these user.
chage -E 2022-11-10 consultant1
chage -l consultant1
chage -E 2022-11-10 consultant2
chage -l consultant2
chage -E 2022-11-10 consultant3
chage -l consultant3

echo -ne '####			             	(16%)\r'
sleep 1
echo -ne '\n'

# Nomor 5 - Force all consultant user to change their password when first time they login
chage -d 0 consultant1
chage -d 0 consultant2
chage -d 0 consultant3

echo -ne '#####			             	(20%)\r'
sleep 1
echo -ne '\n'

# Nomor 6 - Filter line that contains "ssh" from /var/log/messages to /tmp/log/ssh-filter.txt
mkdir -p /tmp/log/
cat << EOF > /etc/rsyslog.d/ssh-filter.conf
auth.info	/tmp/log/ssh-filter.txt
EOF
systemctl restart rsyslog
logger -p auth.info "test sshd logger masuk..."
tail /tmp/log/ssh-filter.txt

echo -ne '######			            (24%)\r'
sleep 1
echo -ne '\n'

# Nomor 7 - Install apache2 server, and make sure the httpd service run each time when boot
sudo yum install httpd -y
systemctl enable httpd
systemctl start httpd
systemctl status httpd

firewall-cmd --zone=public --permanent --add-service=http
firewall-cmd --reload

echo "Apache2 on RHEL 9.0 by Vergie" > /var/www/html/index.html
curl localhost

echo -ne '#######			            (28%)\r'
sleep 1
echo -ne '\n'

# Nomor 8 - Set server A time region to Asia/Jakarta, don't forget to restart rsyslog service
timedatectl set-timezone Asia/Jakarta
systemctl restart rsyslog
timedatectl

echo -ne '########			            (32%)\r'
sleep 1
echo -ne '\n'

# Nomor 9 - Disable root ssh login, then Kill process that contain name consultant-process from memory (ASAP!!!)
sed -i 's/#\?\(PermitRootLogin\s*\).*$/\1 no/' /etc/ssh/sshd_config
if [[ "${?}" -ne 0 ]]; then
   echo "The sshd_config file was not modified successfully"
   exit 1
fi
systemctl restart sshd.service
systemctl status sshd.service

ps -aux | grep consultant
pkill -9 -f consultant-process
ps -aux | grep consultant

echo -ne '#########			            (36%)\r'
sleep 1
echo -ne '\n'

# Nomor 10 - Mount /tmp/loop0 to /data/share, then mount /tmp/loop1 to /data/share/backup.
mkdir -p /data/share/backup
mount /tmp/loop0 /data/share/
mount /tmp/loop1 /data/share/backup
lsblk -fp

echo -ne '##########			     	(40%)\r'
sleep 1
echo -ne '\n'

# Nomor 11 - Run disk space information command, and put the log into /data/share/disk.log
df -h > /data/share/disk.log
cat /data/share/disk.log

echo -ne '###########			     	(44%)\r'
sleep 1
echo -ne '\n'

# Nomor 12 - Set server A hostname to servera.stts.edu
hostnamectl set-hostname servera.stts.edu
hostnamectl

echo -ne '############			     	(48%)\r'
sleep 1
echo -ne '\n'

# Nomor 13 - find all files owned by consultant1 in /tmp/c1-files/, and put the output result into /tmp/c1-list.txt
find /tmp/c1-files -user consultant1 -ls > /tmp/c1-list.txt
cat /tmp/c1-list.txt

echo -ne '#############			     	(52%)\r'
sleep 1
echo -ne '\n'

# Nomor 14 - find all files in / that file name contain .target and list those files location into /data/shared/target-list.txt
mkdir -p /data/shared
updatedb
locate *.target > /data/shared/target-list.txt
cat /data/shared/target-list.txt

echo -ne '##############			    (56%)\r'
sleep 1
echo -ne '\n'

# Nomor 15 - Backup the /etc/ folder, and put the backup into server b, with name etc-back.tar.gz in /tmp/servera
mkdir -p /tmp/servera/
env GZIP=-9 tar cvzf /tmp/servera/etc-back.tar.gz /etc/
ls -lah /tmp/servera/

echo -ne '###############			    (60%)\r'
sleep 1
echo -ne '\n'

echo 'Answer for SERVER B...'
#ssh root@serverb

if [[ "${UID}" -ne 0 ]]; then
    echo " You need to run this script as root on Server B"
    exit 1
fi

# Nomor 16 - Disable root login in sshd service at server b, so people only can use
sed -i 's/#\?\(PermitRootLogin\s*\).*$/\1 no/' /etc/ssh/sshd_config
if [[ "${?}" -ne 0 ]]; then
   echo "The sshd_config file was not modified successfully"
   exit 1
fi
systemctl restart sshd.service
systemctl status sshd.service

echo -ne '################			    (64%)\r'
sleep 1
echo -ne '\n'

# Nomor 17 - Disable firewalld service at server b, but enable and autostart cockpit service on server
firewall-cmd --state
systemctl stop firewalld
systemctl disable firewalld
firewall-cmd --state

yum install cockpit -y
systemctl enable --now cockpit.socket
systemctl status cockpit.socket
firewall-cmd --add-service=cockpit --permanent
firewall-cmd --reload

curl -k https://localhost:9090

echo -ne '#################			    (68%)\r'
sleep 1
echo -ne '\n'

# Nomor 18 - Rename server b hostname to server.stts.edu, and export diagnostic report from serverb into /home/student/sos.tar.gz
hostnamectl set-hostname server.stts.edu
hostnamectl

yum update sos -y
sos report --batch --tmp-dir /home/student/
ls -lah /home/student/

echo -ne '##################		    (72%)\r'
sleep 1
echo -ne '\n'

# Nomor 19 - Install mysql server using dnf, and make sure the mysqld service is running and enabled on boot!
dnf install mysql -y
systemctl start mysqld.service
systemctl enable mysqld.service
systemctl status mysqld.service
mysql --version

echo -ne '####################		    (76%)\r'
sleep 1
echo -ne '\n'

# Nomor 20 - Create a folder in /tmp/shared, owned by student, and any files created inside the folder, the group always owned by student group. 
#			 Make sure only the owner/creator of the files that can delete the file inside the folder. 
#			 Don't forget to link the folder into /home/student/shared!
mkdir -p /tmp/shared
chown student:student /tmp/shared
chmod 2770 /tmp/shared
ln -s /tmp/shared /home/student/shared
ln -lah /home/student/shared

echo -ne '#####################		    (80%)\r'
sleep 1
echo -ne '\n'

# Nomor 21 - Change NTP server of serverb to id.pool.ntp.org. Make sure using dnf, that the chronyd already installed, please check, if it's hasn't please install!
yum install chrony -y
systemctl enable chronyd
systemctl start chronyd

sed -i '/^server/a\pool id.pool.ntp.org iburst prefered' /etc/chrony.conf
systemctl restart chronyd
systemctl status chronyd

chronyc makestep
chronyc ntpdata
timedatectl set-ntp yes
chronyc sources -v
chronyc tracking

sudo firewall-cmd --add-service=ntp --permanent
sudo firewall-cmd --reload

echo -ne '#####################		 	(84%)\r'
sleep 1
echo -ne '\n'

# Nomor 22 - Get the NTP from chrony source output into /tmp/chrony-debug.log
chronyc sources -v > /tmp/chrony-debug.log
ls -lah /tmp/chrony-debug.log

echo -ne '######################	 	(88%)\r'
sleep 1
echo -ne '\n'

# Nomor 23 - Add search domain stts.edu into network configuration, don't forget to reload!
nmcli connection modify "Wired connection 1" ipv4.dns-search "stts.edu" 
nmcli connection reload "Wired connection 1"

sed 's/search.*/search stts.edu/' /etc/resolv.conf > /etc/resolv.conf.new
mv -f /etc/resolv.conf.new /etc/resolv.conf

systemctl restart NetworkManager
systemctl status NetworkManager
nmcli -o
nslookup stts.edu

echo -ne '#######################	 	(92%)\r'
sleep 1
echo -ne '\n'

# Nomor 24 - Create a new user name mssql-server, that can't login or have no shell, don't set password to the user!
adduser mssql-server --system --no-create-home --shell=/sbin/nologin

yum install https://rpmfind.net/linux/fedora/linux/development/rawhide/Everything/x86_64/os/Packages/f/finger-0.17-73.fc37.x86_64.rpm -y
finger mssql-server

userdel mssql-server

echo -ne '########################	 	(96%)\r'
sleep 1
echo -ne '\n'

# Nomor 25 - Create a folder at /var/mssql/ owned by mssql-server, and applied special permission to group and other to that folder.
mkdir -p /var/mssql
chown -c mssql-server /var/mssql
chmod 2770 /var/mssql

echo -ne '#########################		(100%)\r'
echo -ne '\n'
echo 'Script Ended...'
exit 0