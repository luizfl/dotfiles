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

xset r rate 250 50
xset +fp "$HOME/.fonts"
xset fp rehash
xrdb -load "$HOME/.Xresources"
xsetroot -cursor_name left_ptr
setxkbmap -option terminate:ctrl_alt_bksp

compton -b
urxvtd -q                 &
#sh ~/.fehbg               &
hsetroot -solid "#DDB169" &
unclutter -idle 2         &

#exec bspwm
exec 2bwm
