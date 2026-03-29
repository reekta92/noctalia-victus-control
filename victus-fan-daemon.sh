#!/bin/bash

# A world-writable file so your user-level shell can change the mode
STATE_FILE="/var/tmp/victus_fan_mode"
touch "$STATE_FILE"
chmod 666 "$STATE_FILE"
echo "AUTO" > "$STATE_FILE"

# Log file for tracking bypass events
LOG_FILE="/var/log/victus_fan_daemon.log"
touch "$LOG_FILE"

LAST_MODE="AUTO"

# Function to force HP firmware to override manual settings immediately
force_bios_control() {
    echo "$(date): Attempting instant bypass to AUTO mode..." >> "$LOG_FILE"
    
    # 1. Zero out targets to signal the driver
    local FAN_PATHS=$(find /sys/devices/platform/hp-wmi/hwmon/hwmon*/ -name "fan*_target" 2>/dev/null)
    for f in $FAN_PATHS; do 
        echo 0 > "$f" 2>/dev/null
    done

    # 2. Toggle platform profile to trigger an ACPI thermal re-evaluation
    local PROFILE="/sys/firmware/acpi/platform_profile"
    if [[ -f "$PROFILE" ]]; then
        local CURRENT=$(cat "$PROFILE")
        # Quick toggle to break the manual lock by forcing a state change
        if [[ "$CURRENT" == "performance" ]]; then
            echo "balanced" > "$PROFILE" && echo "performance" > "$PROFILE"
        else
            echo "performance" > "$PROFILE" && echo "$CURRENT" > "$PROFILE"
        fi
        echo "$(date): Platform profile toggled to reset thermal controller." >> "$LOG_FILE"
    fi
}

while true; do
    # Read the desired mode from the state file
    MODE=$(cat "$STATE_FILE")

    # If the mode has changed, handle the transition
    if [[ "$MODE" != "$LAST_MODE" ]]; then
        echo "$(date): Mode changed from $LAST_MODE to $MODE" >> "$LOG_FILE"
        
        if [[ "$MODE" == "AUTO" ]]; then
            force_bios_control
        fi
        LAST_MODE="$MODE"
    fi

    # Apply/Re-apply manual targets if NOT in AUTO to prevent BIOS watchdog timeout
    if [[ "$MODE" == "MEDIUM" ]]; then
        find /sys/devices/platform/hp-wmi/hwmon/hwmon*/ -name "fan1_target" -exec sh -c 'echo 3000 > "$1"' _ {} \; 2>/dev/null
        find /sys/devices/platform/hp-wmi/hwmon/hwmon*/ -name "fan2_target" -exec sh -c 'echo 3000 > "$1"' _ {} \; 2>/dev/null
    elif [[ "$MODE" == "MAX" ]]; then
        find /sys/devices/platform/hp-wmi/hwmon/hwmon*/ -name "fan1_target" -exec sh -c 'echo 5500 > "$1"' _ {} \; 2>/dev/null
        find /sys/devices/platform/hp-wmi/hwmon/hwmon*/ -name "fan2_target" -exec sh -c 'echo 5200 > "$1"' _ {} \; 2>/dev/null
    fi

    # 1-second sleep ensures near-instant response to user input
    sleep 1
done
