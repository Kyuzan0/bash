#!/bin/bash

clear

echo "Downloading chr-7.15.2.img"
echo ""
sudo curl -L "https://drive.usercontent.google.com/download?id=1iDPyOLPPXRlb9blGTsVSoLMHKlRjG_IL&export=download&authuser=1&confirm=t&uuid=bab66514-f7f6-4542-b0e4-c5a4591e29ca&at=APZUnTXEU5DVX9k0_u6dhFubr6Uq:1721045107400" > chr.img

sudo fdisk -l chr.img

echo "Mount chr file to /mnt"
echo ""
mount -o loop,offset=512 chr.img /mnt

sudo ls /mnt/rw/

echo "Setup ip and gateway for mikrotik"
IP=$(hostname -I | awk ' {print $1}')

echo "IP Adress= $IP"

GW=$(ip route | grep default | awk '{print $3}')

echo "Gateway= $GW"

echo "/ip address add address=$IP interface[/interface ethernet find where name=eth0] \ /ip route add gateway$GW" /mnt/rw/autorun.scr

echo "show configuration autorun.scr"
cat /mnt/rw/autorun.scr

echo "Umount /mnt"
umount /mnt

echo u > /proc/sysrq-trigger

sudo fdisk -l 

