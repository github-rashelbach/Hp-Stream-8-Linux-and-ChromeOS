
Auto rotate screen & touchpad


#!/bin/bash
# Auto rotate touch screen based on device orientation.
#
#   Based on chadm's script at https://linuxappfinder.com/blog/auto_screen_rotation_in_ubuntu.

# Receives input from monitor-sensor (part of iio-sensor-proxy package) and sets the touchscreen
# orientation based on the accellerometer positionn. We assume that the display rotation is 
# handled by Linux Mint 18.1, Cinnamon 3.2.7. If this is not the case, add the appropriate
# xrandr command into each case block.

# This script should be added to startup applications for the user.

# Kill any existing monitor-sensor instance, for example if manually invoking
# from a terminal for testing.
killall monitor-sensor

# Launch monitor-sensor and store the output in a RAM based file that can be checked by the rest of the script.
# We use the RAM based file system to save wear where an SSD is being used.
monitor-sensor > /dev/shm/sensor.log 2>&1 &

# Configure these to match your hardware (names taken from `xinput` output).
TOUCHPAD=8  #'Goodix Capacitive TouchScreen'
TOUCHSCREEN=13 #'Goodix Capacitive TouchScreen'
TRANSFORM='Coordinate Transformation Matrix'



function do_rotate
{
  xrandr --output $1 --rotate $2

  TRANSFORM='Coordinate Transformation Matrix'

  case "$2" in
    normal)
      [ ! -z "$TOUCHPAD" ]    && xinput set-prop "$TOUCHPAD"    "$TRANSFORM" 1 0 0 0 1 0 0 0 1
      [ ! -z "$TOUCHSCREEN" ] && xinput set-prop "$TOUCHSCREEN" "$TRANSFORM" 1 0 0 0 1 0 0 0 1
      ;;
    inverted)
      [ ! -z "$TOUCHPAD" ]    && xinput set-prop "$TOUCHPAD"    "$TRANSFORM" -1 0 1 0 -1 1 0 0 1
      [ ! -z "$TOUCHSCREEN" ] && xinput set-prop "$TOUCHSCREEN" "$TRANSFORM" -1 0 1 0 -1 1 0 0 1
      ;;
    left)
      [ ! -z "$TOUCHPAD" ]    && xinput set-prop "$TOUCHPAD"    "$TRANSFORM" 0 -1 1 1 0 0 0 0 1
      [ ! -z "$TOUCHSCREEN" ] && xinput set-prop "$TOUCHSCREEN" "$TRANSFORM" 0 -1 1 1 0 0 0 0 1
      ;;
    right)
      [ ! -z "$TOUCHPAD" ]    && xinput set-prop "$TOUCHPAD"    "$TRANSFORM" 0 1 0 -1 0 1 0 0 1
      [ ! -z "$TOUCHSCREEN" ] && xinput set-prop "$TOUCHSCREEN" "$TRANSFORM" 0 1 0 -1 0 1 0 0 1
      ;;
  esac
}

# Initialise display orientation to 'normal'
# Without this, the display often starts in 'inverted' (or 'bottom-up') mode!

XDISPLAY=`xrandr --current | grep primary | sed -e 's/ .*//g'`
XROT=`xrandr --current --verbose | grep primary | egrep -o ' (normal|left|inverted|right) '`



 do_rotate $XDISPLAY normal




# xrandr --output DSI-1 --rotate normal
# xinput set-prop 11 'Coordinate Transformation Matrix' 1 0 0 0 1 0 0 0 1

# Parse output of monitor sensor to get the new orientation whenever the log file is updated
# Possibles are: normal, bottom-up, right-up, left-up
# Light data will be ignored
while inotifywait -e modify /dev/shm/sensor.log; do

# Read the last few lines that were added to the file and get the last orientation line.
ORIENTATION=$(tail /dev/shm/sensor.log | grep 'orientation' | tail -1 | grep -oE '[^ ]+$')

# Set the actions to be taken for each possible orientation
case "$ORIENTATION" in
bottom-up)
   do_rotate $XDISPLAY inverted ;;
normal)
   do_rotate $XDISPLAY normal ;;
right-up)
      do_rotate $XDISPLAY right ;;
left-up)
      do_rotate $XDISPLAY left ;;
esac
done

# On stopping this script, don't forget that "monitor-sensor" is still running - hence the "killall" !
