#!/bin/bash

# A world-writable file so your user-level Noctalia shell can change the mode
STATE_FILE="/var/tmp/victus_fan_mode"
touch "$STATE_FILE"
chmod 666 "$STATE_FILE"
echo "AUTO" > "$STATE_FILE"

while true; do
    MODE=$(cat "$STATE_FILE")
    
    # We resolve the wildcard path inside the loop in case hwmon numbers change on reboot
    if [[ "$MODE" == "MEDIUM" ]]; then
        for f1 in /sys/devices/platform/hp-wmi/hwmon/hwmon*/fan1_target; do echo 3000 > "$f1" 2>/dev/null; done
        for f2 in /sys/devices/platform/hp-wmi/hwmon/hwmon*/fan2_target; do echo 3000 > "$f2" 2>/dev/null; done
    elif [[ "$MODE" == "MAX" ]]; then
        for f1 in /sys/devices/platform/hp-wmi/hwmon/hwmon*/fan1_target; do echo 5500 > "$f1" 2>/dev/null; done
        for f2 in /sys/devices/platform/hp-wmi/hwmon/hwmon*/fan2_target; do echo 5200 > "$f2" 2>/dev/null; done
    fi
    # If AUTO, we intentionally do nothing. The HP hardware watchdog will expire 
    # within 120 seconds and naturally return control to the BIOS.
    
    sleep 90
done
