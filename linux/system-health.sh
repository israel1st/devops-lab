#!/bin/bash

LOG_FILE="$HOME/devops-lab/linux/health-check.log"
STATUS_FILE="$HOME/devops-lab/linux/current-status.txt"

echo "======================================"
echo "       LINUX SYSTEM HEALTH CHECK"
echo "======================================"

echo
echo "SYSTEM INFORMATION"
echo "--------------------------------------"
echo "Hostname: $(hostname)"
echo "User: $(whoami)"
echo "Date: $(date)"
echo "Uptime: $(uptime -p 2>/dev/null || uptime)"

echo
echo "STORAGE"
echo "--------------------------------------"

STORAGE_USAGE=$(df -P "$HOME" | awk 'NR==2 {print $5}' | tr -d '%')
STORAGE_AVAILABLE=$(df -h "$HOME" | awk 'NR==2 {print $4}')

echo "Storage used: ${STORAGE_USAGE}%"
echo "Storage available: ${STORAGE_AVAILABLE}"

if [ "$STORAGE_USAGE" -lt 80 ]; then
    STORAGE_STATUS="OK"
elif [ "$STORAGE_USAGE" -lt 90 ]; then
    STORAGE_STATUS="WARNING"
else
    STORAGE_STATUS="CRITICAL"
fi

echo "Storage status: $STORAGE_STATUS"

echo
echo "MEMORY"
echo "--------------------------------------"

if command -v free >/dev/null 2>&1; then
    MEMORY_USAGE=$(free | awk '/Mem:/ {printf "%.0f", ($3/$2)*100}')
    MEMORY_AVAILABLE=$(free -h | awk '/Mem:/ {print $7}')

    echo "Memory used: ${MEMORY_USAGE}%"
    echo "Memory available: ${MEMORY_AVAILABLE}"

    if [ "$MEMORY_USAGE" -lt 80 ]; then
        MEMORY_STATUS="OK"
    elif [ "$MEMORY_USAGE" -lt 90 ]; then
        MEMORY_STATUS="WARNING"
    else
        MEMORY_STATUS="CRITICAL"
    fi

    echo "Memory status: $MEMORY_STATUS"
else
    MEMORY_STATUS="UNKNOWN"
    MEMORY_AVAILABLE="unknown"
    echo "Memory information unavailable"
fi

echo
echo "SYSTEM HEALTH"
echo "--------------------------------------"

if [ "$STORAGE_STATUS" = "CRITICAL" ] || [ "$MEMORY_STATUS" = "CRITICAL" ]; then
    OVERALL_STATUS="CRITICAL"
elif [ "$STORAGE_STATUS" = "WARNING" ] || [ "$MEMORY_STATUS" = "WARNING" ]; then
    OVERALL_STATUS="WARNING"
else
    OVERALL_STATUS="OK"
fi

echo "Overall status: $OVERALL_STATUS"

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Save historical record
echo "$TIMESTAMP | Storage: ${STORAGE_USAGE}% | Memory: ${MEMORY_USAGE}% | Status: ${OVERALL_STATUS}" >> "$LOG_FILE"

# Save current state
cat > "$STATUS_FILE" <<STATUS
Timestamp: $TIMESTAMP
Storage: ${STORAGE_USAGE}%
Storage available: ${STORAGE_AVAILABLE}
Memory: ${MEMORY_USAGE}%
Memory available: ${MEMORY_AVAILABLE}
Storage status: ${STORAGE_STATUS}
Memory status: ${MEMORY_STATUS}
Overall status: ${OVERALL_STATUS}
STATUS

echo
echo "Log saved to: $LOG_FILE"
echo "Current status saved to: $STATUS_FILE"

echo
echo "======================================"
echo "          HEALTH CHECK COMPLETE"
echo "======================================"

if [ "$OVERALL_STATUS" = "CRITICAL" ]; then
    exit 2
elif [ "$OVERALL_STATUS" = "WARNING" ]; then
    exit 1
else
    exit 0
fi
