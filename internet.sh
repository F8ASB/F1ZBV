#!/bin/bash
# Reboot Router01/2021 F8ASB.COM

if : >/dev/tcp/8.8.8.8/53; then
  echo 'Internet available.'
else
  echo 'Offline.'
  echo 1 > /sys/class/gpio/gpio20/value
  echo "Reboot web [`date`]" >> /var/log/netcheck
  sleep 10
  echo 0 > /sys/class/gpio/gpio20/value
fi
