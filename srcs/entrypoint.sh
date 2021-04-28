#!/bin/bash

# autoindex on/off
sed -i "s/AUTO_INDEX_ENV;/${AUTO_INDEX};/g" /etc/nginx/sites-available/default

# wp-config env injection
WP_PATH=/var/www/html/wordpress/wp-config.php
sed -i "s/getenv('DB_USER')/'${DB_USER}'/g" $WP_PATH
sed -i "s/getenv('DB_PASSWORD')/'${DB_PASSWORD}'/g" $WP_PATH
sed -i "s/getenv('DB_NAME')/'${DB_NAME}'/g" $WP_PATH

# mysql config
service mysql start

mysqladmin -uroot -p' ' password $DB_ROOT_PASSWORD
mysql -u root -p$DB_ROOT_PASSWORD -e "CREATE USER '$DB_USER'@'localhost' identified by '$DB_PASSWORD';" ;
mysql -u root -p$DB_ROOT_PASSWORD -e "CREATE DATABASE $DB_NAME;";
mysql -u root -p$DB_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';" ;
mysql -u root -p$DB_ROOT_PASSWORD -e "FLUSH PRIVILEGES;" ;

# phpmyadmin config
mysql -u root -p$DB_ROOT_PASSWORD < /var/www/html/phpmyadmin/sql/create_tables.sql

service php$PHP_VER start

echo "========================="
echo "all server start"
echo "========================="

#docker does not exit
nginx -g 'daemon off;'
