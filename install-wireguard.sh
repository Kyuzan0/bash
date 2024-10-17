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

cat <<EOL > /etc/wireguard/wg0.conf
[Interface]
PrivateKey = $wg_privatekey
Address = 10.0.0.1/24
ListenPort = 52024

# Forward traffic
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

EOL

chmod 600 /etc/wireguard/wg0.conf

systemctl enable wg-quick@wg0
systemctl start wg-quick@wg0
echo "=== Instalasi selesai ==="

