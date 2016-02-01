#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

#if [[ ! "`pgrep pulseaudio`" ]]; then
#  pulseaudio --start
#fi

if [[ ! "`pgrep mpd`" ]]; then
  mpd
fi

xset +fp "$HOME/.fonts"
xset fp rehash
xset r rate 250 50
setxkbmap -option terminate:ctrl_alt_bksp
xrdb -load "$HOME/.Xresources"
xsetroot -cursor_name left_ptr

#compton -b
urxvtd -q &
setroot --restore &
unclutter -noevents -idle 2 &
autocutsel -fork &
autocutsel -selection PRIMARY -fork &

exec bspwm
#exec 2bwm
