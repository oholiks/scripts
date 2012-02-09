#!/bin/sh
xrdb -nocpp -override $HOME/.Xdefaults
setxkbmap -layout us,se -option ctrl:nocaps,grp:menu_toggle,grp_led:scroll
PPP=$(xinput list | grep -iv 'wacom' | egrep "slave.*pointer" | grep -v XTEST | sed -e 's/^.*id=//' -e 's/\s.*$//')
xinput set-button-map $PPP 1 2 3 5 4 6 7 8 9 10 11 12
xset q|grep -q $LOGNAME || xset +fp "/home/$LOGNAME/.fonts"
xset m 4/3
xset fp rehash
xsetroot -cursor_name left_ptr
eval `cat ~/.fehbg`
pidof conky || (conky -d)
pidof gkrellm || (gkrellm &)
pidof xscreensaver || (xscreensaver -nosplash &)
