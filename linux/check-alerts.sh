#!/bin/bash

STATUS_FILE="$HOME/devops-lab/linux/current-status.txt"

echo "======================================"
echo "          CURRENT ALERT CHECK"
echo "======================================"

if [ ! -f "$STATUS_FILE" ]; then
    echo "ERROR: No current status file found."
    exit 2
fi

OVERALL_STATUS=$(awk -F': ' '/Overall status:/ {print $2}' "$STATUS_FILE")

echo
echo "Current system status: $OVERALL_STATUS"

if [ "$OVERALL_STATUS" = "CRITICAL" ]; then
    echo "ALERT: Critical condition detected."
    exit 2
elif [ "$OVERALL_STATUS" = "WARNING" ]; then
    echo "ALERT: Warning condition detected."
    exit 1
elif [ "$OVERALL_STATUS" = "OK" ]; then
    echo "SYSTEM OK: No active alerts."
    exit 0
else
    echo "ERROR: Unknown system status."
    exit 2
fi
