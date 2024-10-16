#!/bin/bash

# Menambahkan konfigurasi untuk menonaktifkan IPv6 ke dalam /etc/sysctl.conf
echo "net.ipv6.conf.all.disable_ipv6=1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6=1" >> /etc/sysctl.conf
echo "net.ipv6.conf.lo.disable_ipv6=1" >> /etc/sysctl.conf

# Memuat ulang konfigurasi sysctl
sysctl -p
