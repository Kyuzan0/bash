#!/bin/bash

if [ "$EUID" -ne 0]
	then echo "Jalankan menggunakan sebagai root"
	exit
fi

clear

echo "=== install wireguard ==="

echo "=== Update package ==="
sudo apt update 

clear

echo "=== install requirements ==="
sudo apt install iptables net-tools -y

#enable ip forward for ipv4
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

echo "=== install wireguard ==="
sudo apt install wireguard wireguard-tools -y

mkdir -p /etc/wireguard
cd /etc/wireguard

#create privatekey and publickey
wg genkey | tee wg_privatekey.key | wg pubkey > wg_publickey.key

wg_privatekey=$(cat wg_privatekey.key)
wg_publickey=$(cat wg_publickey.key)
echo "Kunci private wireguard: $wg_privatekey"
echo "Kunci public wireguard: $wg_publickey"

