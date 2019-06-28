#!/bin/bash
# Made by Mattyfaz (https://github.com/Mattyfaz/WG-AutoSetup)
echo -e "Please enter the domain that is pointing to this Server.\nFor example, if the domain is https://www.wireguard.server.com \nSimple enter: wireguard.server.com"
read -p "Domain: " domain
echo "Please enter the UDP Port you have forwarded for Wireguard (e.g. 1635)"
read -p "Port: " port
echo "Will be using: $domain:$port for this instance"
echo "Script starting in:\n\n"
for i in {5..0}; do echo -n $i... && sleep 1; done
add-apt-repository ppa:wireguard/wireguard -y
apt update && DEBIAN_FRONTEND=noninteractive apt upgrade -y && apt autoremove -y && apt autoclean -y
apt install openresolv wireguard qrencode -y

ufw allow $port/udp
ufw allow ssh
yes | ufw enable

umask 077 /etc/wireguard/

wg genkey | tee /etc/wireguard/client1_privatekey | wg pubkey > /etc/wireguard/client1_publickey
wg genkey | tee /etc/wireguard/server_privatekey | wg pubkey > /etc/wireguard/server_publickey
serverPublicKey="$(cat /etc/wireguard/server_publickey)"
serverPrivateKey="$(cat /etc/wireguard/server_privatekey)"
client1PublicKey="$(cat /etc/wireguard/client1_publickey)"
client1PrivateKay="$(cat /etc/wireguard/client1_privatekey)"

cat > /etc/wireguard/wg0.conf << ENDOFFILE
[Interface]
Address = 10.9.0.1/24
ListenPort = $port
PrivateKey = ${serverPrivateKey}
SaveConfig = true

PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o ens3 -j MASQUERADE; ip6tables -A FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -A POSTROUTING -o ens3 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o ens3 -j MASQUERADE; ip6tables -D FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -D POSTROUTING -o ens3 -j MASQUERADE

[Peer]
#Client1
PublicKey = ${client1PublicKey}
AllowedIPs = 10.9.0.2/32
#PersistentkeepAlive = 60
ENDOFFILE

cat > /etc/wireguard/client1.conf << ENDOFFILE
[Interface]
Address = 10.9.0.2/32
PrivateKey = ${client1PrivateKay}
DNS = 1.1.1.1

[Peer]
PublicKey = ${serverPublicKey} 
Endpoint = $domain:$port
AllowedIPs = 0.0.0.0/0
#PersistentkeepAlive = 60 
ENDOFFILE

cat << EOF >> /etc/sysctl.conf
net.ipv4.ip_forward=1
net.ipv6.conf.all.forwarding=1
EOF

systemctl enable wg-quick@wg0
chown -R root:root /etc/wireguard/
chmod -R og-rwx /etc/wireguard/*
wg-quick up wg0
qrencode -t ansiutf8 < /etc/wireguard/client1.conf
echo -e "++++++++++++++++++++++++++\nCompleted Setup\n++++++++++++++++++++++++++\nPlease ensure you reboot after scanning the QR Code! Once Server has rebooted you will be able to connect."