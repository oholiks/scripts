#!/bin/sh
xrdb -nocpp -override $HOME/.Xdefaults
setxkbmap -layout us,se -option ctrl:nocaps,grp:menu_toggle,grp_led:scroll
xset q|grep -q $LOGNAME || xset +fp "/home/$LOGNAME/.fonts"
xset m 4/3
xset fp rehash
eval `cat ~/.fehbg`
pidof conky || (conky -d)
pidof gkrellm || (gkrellm &)
pidof xscreensaver || (xscreensaver -nosplash &)
