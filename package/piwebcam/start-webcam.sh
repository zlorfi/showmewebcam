#!/bin/sh

/opt/uvc-webcam/multi-gadget.sh
/usr/bin/v4l2-ctl -c auto_exposure_bias=3
/usr/bin/v4l2-ctl -c video_bitrate=25000000

CONFIG_FILE="/boot/camera.txt"
LOGGER_TAG="piwebcam"

if [ -f "$CONFIG_FILE" ] ; then
  logger -t "$LOGGER_TAG" "Found camera.txt, applying settings"
  #shellcheck disable=SC2002
  cat "$CONFIG_FILE" | sed "s/ //g" | grep "\S" | grep -vE "^\#" | while read -r line
  do
    KEY=$(echo "$line" | cut -d= -f1)
    VAL=$(echo "$line" | cut -d= -f2)
    logger -t "$LOGGER_TAG" "Setting $KEY -> $VAL"
    /usr/bin/v4l2-ctl -c "$KEY"="$VAL"
  done
else
  logger -t "$LOGGER_TAG" "No camera.txt found in boot"
fi

/opt/uvc-webcam/uvc-gadget -f1 -u /dev/video1 -v /dev/video0
