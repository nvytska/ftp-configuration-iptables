#!/bin/bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <ip1,ip2,ip3>"
    exit 1
fi

IPLIST="$1"
IFS=',' read -ra ALLOWED_IPS <<< "$IPLIST"

sudo apt update -y
sudo apt install -y iptables socat vsftpd

sudo iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
sudo iptables -A INPUT -p tcp --dport 21 -j DROP

for ip in ${ALLOWED_IPS[@]}; do
    sudo iptables -A INPUT -s $ip -p tcp --dport 21 -j ACCEPT
    sudo iptables -A INPUT -s $ip -p tcp --sport 20 -j ACCEPT
done

sudo adduser --disabled-password --gecos "FTP USER,69,404-404,200-200,Other" ftp_user
echo "ftp_user:MyFTPPass!" | sudo chpasswd

echo "Hello, World!" >> /home/ftp_user/file1.txt
echo "Hello, World!" >> /home/ftp_user/file2.txt
chmod 755 /home/ftp_user
chown -R ftp_user:ftp_user /home/ftp_user/file*.txt


mkdir -p /etc/authServer
cp ./credentials.txt /etc/authServer/
cp ./authServer.sh /usr/bin/
chmod +x /usr/bin/authServer.sh
cp ./authServer.service /etc/systemd/system/

sudo systemctl daemon-reload
sudo systemctl enable authServer.service
sudo systemctl start authServer.service
sudo systemctl status authServer.service --no-pager


