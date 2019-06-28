# WG-AutoSetup

Script will install and setup [WireGuard](https://www.wireguard.com/) as well as 1x WireGuard Client on Ubuntu 18.04 LTS. 
# Prerequisites

* UDP Port that you intend to use for WireGuard forwarded through your Firewall
* Domain pointing at the Server that will be running WireGuard
* Ubuntu 18.04 LTS installed and logged in

# Installation
Once logged into Ubuntu as root, enter the following into the Terminal:

1. ```wget https://raw.githubusercontent.com/Mattyfaz/WG-AutoSetup/master/WG-AutoSetup.sh```
2. ```chmod +x WG-AutoSetup.sh```
3. ```./WG-AutoSetup.sh```

Follow the prompts, once complete the Terminal will display a QR code to be Scanned via the WireGuard Mobiel App ([Android](https://play.google.com/store/apps/details?id=com.wireguard.android&hl=en_AU) or [iOS](https://apps.apple.com/au/app/wireguard/id1441195209)

4. Scan QR Code on Mobile App
5. Restart Ubuntu (mandatory)

Once Ubuntu has restarted your WireGuard VPN should be active and can be connected to.
