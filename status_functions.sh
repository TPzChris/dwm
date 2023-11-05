#!/bin/bash

print_date() {
	echo " $(date +'%d/%m/%Y')"
}

print_time() {
	echo " $(date +'%R:%S')"
}

print_volume() {
	echo " $(pactl list sinks | grep -e Volume: | awk '(NR==1) {print $5}')"
	#pactl list sinks | grep -e Volume: | awk '(NR==2) {print $5}')
}

print_mem() {
	echo " $(free -h | awk '(NR==2){ print $3 }')/$(free -h | awk '(NR==2){ print $2 }')"
}

print_storage() {
	echo " $(df -H | awk '(NR==5){ print $3 }')/$(df -H | awk '(NR==5){ print $2 }')($(df -H | awk '(NR==5){ print $5 }'))"
}

print_keyboard() {
	echo " $(localectl status | awk '(NR==1) {print $3}' | cut -c 6-)($(setxkbmap -query | grep layout | awk '{print $2}'))"
}

print_battery() {
	STATUS="$(upower -i /org/freedesktop/UPower/devices/battery_BAT0| grep -E "state" | awk '{print $2}')"
	PERCENT_NUMBER=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0| grep -E "percentage" | awk '{print $2}' | rev | cut -c 2- | rev)
	#PERCENT_NUMBER=$(($PERCENT | cut -c 1-2))
	if [ "$PERCENT_NUMBER" -ge 85 ]; then
		BATTERY_ICON=""
	elif [ "$PERCENT_NUMBER" -ge 60 ]; then
		BATTERY_ICON=""
	elif [ "$PERCENT_NUMBER" -ge 40 ]; then
		BATTERY_ICON=""
	elif [ "$PERCENT_NUMBER" -ge 20 ]; then
		BATTERY_ICON=""
	elif [ "$PERCENT_NUMBER" -lt 20 ]; then
		BATTERY_ICON=""
	fi

	if [ "$STATUS" = "fully-charged" ]; then
		STATUS_ICON=""
	elif [ "$STATUS" = "charging" ]; then
		STATUS_ICON=""
	else
		STATUS_ICON=""
	fi

	echo "$BATTERY_ICON $PERCENT_NUMBER%$([ "$STATUS_ICON" != "" ] && echo "($STATUS_ICON)")"
}

print_connection() {
	WIFI_CON="$(nmcli dev wifi | grep "[*]")"
	#WIRED_CON="$(ethtool eth0 | less)"
	WIRED_CON_NAME=$(lspci | grep Ethernet | awk '{for(i=4;i<7;i++) {print $i}}' ORS=' ')
	WIRED_SPEED=$(ethtool enp0s3 | grep "Speed" | awk '{print $2}')

	if [ "$WIFI_CON" != "" ]; then
		ICON=""
		MSG="$ICON $($WIFI_CON | awk '{printf('%s', '%s', '%s', '%s', $3, $6, $9, $10}')"
	elif [ "$WIRED_CON_NAME" != "" ]; then 
		ICON=""
		MSG="$ICON $WIRED_SPEED" #$WIRED_CON_NAME 
	else
		ICON=""
		MSG="$ICON No Internet Connection"
	fi

	echo "$MSG"
}

while true; do
  FONT_SIZE=$(cat ./dwm/font_size.txt);
  if [ "$FONT_SIZE" -lt "14" ]; then
	  xsetroot -name "|$(print_connection)|$(print_battery)|$(print_keyboard)|$(print_volume)|$(print_mem)|$(print_storage)|$(print_time)|$(print_date)|"
	elif [ "$FONT_SIZE" -lt "24" ]; then
	  xsetroot -name "|$(print_battery)|$(print_volume)|$(print_mem)|$(print_time)|$(print_date)|"
	else
	  xsetroot -name "|$(print_battery)|$(print_time)|$(print_date)|"
  fi
	sleep 1
done
