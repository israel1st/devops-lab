#!/bin/bash

echo "======================================"
echo "          DEVOPS MONITOR"
echo "======================================"

echo
echo "Running system health check..."
echo

./system-health.sh

HEALTH_EXIT_CODE=$?

echo
echo "Running alert checker..."
echo

./check-alerts.sh

ALERT_EXIT_CODE=$?

echo
echo "======================================"
echo "             SUMMARY"
echo "======================================"

echo "Health check exit code: $HEALTH_EXIT_CODE"
echo "Alert checker exit code: $ALERT_EXIT_CODE"

if [ "$ALERT_EXIT_CODE" -eq 2 ]; then
    echo "RESULT: CRITICAL"
elif [ "$ALERT_EXIT_CODE" -eq 1 ]; then
    echo "RESULT: WARNING"
else
    echo "RESULT: OK"
fi

echo "======================================"
