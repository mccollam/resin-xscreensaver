#!/bin/bash

# Set up attached display framebuffer
if [ ! -c /dev/fb1 ]; then
  modprobe spi-bcm2708
  modprobe fbtft_device name=pitft verbose=0 rotate=0

  sleep 1

  mknod /dev/fb1 c $(cat /sys/class/graphics/fb1/dev | tr ':' ' ')
fi

FRAMEBUFFER=/dev/fb1 X &
sleep 2

if [ -z ${screensaver+x} ]
then
	screensavers=(/usr/lib/xscreensaver/*)
	screensaver=$(basename ${screensavers[$RANDOM % ${#screensavers[@]} ]})
fi

# Disable screen blanking
DISPLAY=:0 xset s off
DISPLAY=:0 xset dpms 0 0 0
DISPLAY=:0 xset -dpms

DISPLAY=:0 /usr/lib/xscreensaver/$screensaver -root $screensaveropts
