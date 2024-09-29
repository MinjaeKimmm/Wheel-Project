#!/bin/bash

set -e  

echo "Starting certificate renewal process..."

# Test mode
if [ "$1" == "--test" ]; then
    echo "Running in test mode (forcing renewal)"
    ADDITIONAL_ARGS="--force-renewal"
else
    ADDITIONAL_ARGS=""
fi

# Renew certificates
sudo certbot renew $ADDITIONAL_ARGS --verbose \
    --pre-hook "echo 'Stopping Docker containers...'; docker compose down" \
    --post-hook "echo 'Starting Docker containers...'; docker compose up -d"

echo "Certificate renewal process completed."
