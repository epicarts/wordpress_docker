#!/bin/bash

# autoindex on/off
sed -i "s/AUTO_INDEX_ENV;/${AUTO_INDEX};/g" /etc/nginx/sites-available/default

service mysql start

mysqladmin -uroot -p' ' password $DB_ROOT_PASSWORD
mysql -u root -p$DB_ROOT_PASSWORD -e "CREATE USER '$DB_USER'@'localhost' identified by '$DB_PASSWORD';" ;
mysql -u root -p$DB_ROOT_PASSWORD -e "CREATE DATABASE $DB_NAME;";
mysql -u root -p$DB_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';" ;
mysql -u root -p$DB_ROOT_PASSWORD -e "FLUSH PRIVILEGES;" ;

service nginx start
service php$PHP_VER start

#nginx -t
#service php7.3-fpm start
#service php7.3-fpm status 


echo "========================="
echo "all server start"
echo "========================="

/bin/bash
