#!/bin/bash

# Set timezone
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/${TZ} /etc/localtime
echo "${TZ}" > /etc/timezone
sed -i "s|;*date.timezone =.*|date.timezone = ${TZ}|i" /etc/php7/conf.d/custom.ini

# Again set the right permissions (needed when mounting from a volume)
set +e
chown -Rf www-data.www-data /var/www
set -e

#start up supervisor (php, ngnix, cron)
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf