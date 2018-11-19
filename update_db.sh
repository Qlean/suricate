#!/bin/bash
curl -q -o  /app/maxminddb/GeoLite2-City.mmdb http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz \
&& echo  "$(date) file /app/maxminddb/GeoLite2-City.mmdb Updated" || echo "$(date) Failed to update /app/maxminddb/GeoLite2-City.mmdb"
