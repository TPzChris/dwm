#!/bin/bash

print_date(){
    echo "| $(date +'%d/%m/%Y')"
}

print_time(){
	echo "| $(date +'%R:%S')"
}

print_volume(){
	echo "| $(pactl list sinks | grep -e Volume: | awk '(NR==1) {print $5}')"
	#pactl list sinks | grep -e Volume: | awk '(NR==2) {print $5}')
}

print_mem(){
	echo "| $(free -h | awk '(NR==2){ print $3 }')/$(free -h | awk '(NR==2){ print $2 }')"
}

while true;
do
	xsetroot -name "$(print_volume)$(print_mem)$(print_time)$(print_date)"
	sleep 0.5
done
