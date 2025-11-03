#!/bin/bash
set -euo pipefail

CREDENTIALS="/etc/authServer/credentials.txt"
IP="$SOCAT_PEERADDR"

echo "Your IP: "$IP""
echo "Enter your authorization key: "
read KEY
KEY=$(echo "$KEY" | tr -d '\r\n')

iptables -D INPUT -p tcp --dport 21 -s "$IP" -j ACCEPT 2>/dev/null || true
iptables -D INPUT -p tcp --dport 21 -s "$IP" -j DROP 2>/dev/null || true

if grep -Eq "^${IP}[[:space:]]+${KEY}$" "$CREDENTIALS"; then
    iptables -I INPUT -p tcp --dport 21 -s "$IP" -j ACCEPT
    iptables -I INPUT -p tcp --sport 20 -s "$IP" -j ACCEPT
    echo "Congratilations! Access granted!"
else
    echo "Access denied. Invalid key"
    iptables -I INPUT -p tcp --dport 21 -s "$IP" -j DROP
fi