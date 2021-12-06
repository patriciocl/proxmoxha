#!/bin/bash
# Version 0
# t.me/proxmoxha

if (whiptail --title "README" --yesno "Script Install Basic packages for nut" 8 78); then
    echo "User selected Yes, exit status was $?."
else
    echo "User selected No, exit status was $?."
    exit 0
fi

if (whiptail --title "README" --yesno "Only Support 1 UPS and Regenerate config file" 8 78); then
    echo "User selected Yes, exit status was $?."
else
    echo "User selected No, exit status was $?."
    exit 0
fi




io=$(whiptail --title "Supported UPS" --radiolist "Choose Option\n\nSpacebar Select\nTab Change Value" 30 78 2 \
"salicru" "hola" ON \
"apc" "chao" OFF \
3>&1 1>&2 2>&3)

echo "$io"



systemctl stop nut-server nut-client
apt-get update
apt-get install nut-server nut-client pwgen  -y 


NUT=/etc/nut
systemctl stop nut-server nut-client
#apt-get update
#apt-get install nut-server nut-client pwgen  -y

PASSWDHAMON=$(pwgen -A 20 1)
PASSWDADMIN=$(pwgen -s 40 1)

echo $PASSHAMON - $PASSADMIN

echo "Write nut.conf"
cat << EOF > $NUT/nut.conf
MODE=netserver
EOF

echo "Write ups.conf" 
cat << EOF > $NUT/ups.conf

maxretry = 3
[ups]
    driver = usbhid-ups
    port = auto
    desc = "Server UPS"
    vendorid = "051D"
EOF

echo "Write upsd.conf" 
cat << EOF >  $NUT/upsd.conf
LISTEN 0.0.0.0 3493
EOF

echo "Write upsd.users"
cat << EOF > $NUT/upsd.users
	[admin]
	password = $PASSADMIN
	actions = SET
	instcmds = ALL

	[hamon]
	password  = $PASSHAMON
	upsmon slave
EOF

echo "Write upsmon.conf"
cat << EOF > $NUT/upsmon.conf
MINSUPPLIES 1
SHUTDOWNCMD "/sbin/shutdown -h +0"
POLLFREQ 5
POLLFREQALERT 5
HOSTSYNC 15
DEADTIME 15
POWERDOWNFLAG /etc/killpower
RBWARNTIME 43200
NOCOMMWARNTIME 300
FINALDELAY 5
EOF


echo "Write upssched.conf"
cat << EOF > $NUT/upssched.conf
CMDSCRIPT /bin/upssched-cmd
EOF

echo "Write upsset.conf"
cat << EOF > $NUT/upsset.conf
#
EOF


echo "follow domotic"

