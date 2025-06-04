#!/bin/sh
# listen port 9000 using socat，invoke handle_webhook.sh when receiving a request.
echo "[`date`] Starting socat on port 9000"
socat TCP4-LISTEN:9000,fork,reuseaddr SYSTEM:"/usr/local/bin/handle_webhook.sh"
