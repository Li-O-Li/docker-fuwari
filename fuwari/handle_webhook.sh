#!/bin/sh
# Read request head while ignore body.
while read line; do
    [ "$line" = $'\r' ] && break
done

# Give simple response.
echo -e "HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nOK"

# Start pull and build.
/usr/local/bin/auto_pull_and_build.sh > /proc/1/fd/1 2>&1

# Auto deploy if applicable.
if [ "${WILL_DEPLOY}" = "1" ]; then
    /usr/local/bin/auto_deploy.sh > /proc/1/fd/1 2>&1
fi