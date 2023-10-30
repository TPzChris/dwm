#!/bin/bash

function set_keyboard(){

    declare -A layouts;
    curr=$(setxkbmap -query | grep "layout" | awk '{print $2}')
    layouts+=(["us"]="" ["ro"]="std" ["gr"]="");
    echo $curr;

    flag=1
    while true; do
        for layout in ${!layouts[@]}; do

            echo $layout;
            echo ${layouts[${layout}]}
            if [ $flag -eq 0 ]; then
                exec setxkbmap $layout ${layouts[${layout}]};
                break 2;
            fi

            if [ "$curr" = "$layout" ]; then
                flag=0
            fi
        done
    done
}

$(set_keyboard)
