#!/bin/sh
#sed Database credentials for Backend
sed -i "s%RewriteBase /%RewriteBase /dtapi/%g" /var/www/localhost/htdocs/dtapi/.htaccess
sed -i "s%'base_url'   => '/'%'base_url'   => '/dtapi/'%g" /var/www/localhost/htdocs/dtapi/application/bootstrap.php
sed -i "s/PDO_MySQL/PDO/g" /var/www/localhost/htdocs/dtapi/application/config/database.php
sed -i "s/mysql:host=localhost/mysql:host=$DB_IP/g" /var/www/localhost/htdocs/dtapi/application/config/database.php
sed -i "s/'username'   => 'dtapi'/'username'   => '$DB_USER'/g" /var/www/localhost/htdocs/dtapi/application/config/database.php
sed -i "s/'password'   => 'dtapi'/'password'   => '$DB_USER_PASS'/g" /var/www/localhost/htdocs/dtapi/application/config/database.php
# This will exec the CMD (apache2 start) from Dockerfile.
exec "$@"