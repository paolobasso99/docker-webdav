#!/usr/bin/with-contenv bash

# timeouts
if [ "x$TIMEOUTS_S" != "x" ]; then
    # Replace commas with spaces
    sed -i "s/3600/$TIMEOUTS_S/g" /etc/nginx/nginx.conf
fi

# max upload
if [ "x$CLIENT_MAX_BODY_SIZE" != "x" ]; then
    # Replace commas with spaces
    sed -i "s/10G/$CLIENT_MAX_BODY_SIZE/g" /etc/nginx/nginx.conf
fi