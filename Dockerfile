FROM debian:buster

# use docker build 
ARG PHP_VER=7.3-fpm
ARG WORDPRESS_VER=latest
ARG PHP_MYADMIN_VER=5.1.0

# default index. if you want 'on', use docker run -e option
ENV AUTO_INDEX=off
ENV PHP_VER=$PHP_VER
ENV WORDPRESS_VER=$WORDPRESS_VER
ENV PHP_MYADMIN_VER=$PHP_MYADMIN_VER

RUN apt-get update -y && apt-get upgrade -y && apt-get -y install \ 
	nginx \
	openssl \
	php${PHP_VER} \
	mariadb-server \
	wget \
	php-mysql \
	php-mbstring

# wordpress config
RUN wget https://wordpress.org/${WORDPRESS_VER}.tar.gz && \
	tar -xvf ${WORDPRESS_VER}.tar.gz && \
	rm ${WORDPRESS_VER}.tar.gz && \
	mv /wordpress/ /var/www/html/ && \
	chown -R www-data:www-data /var/www/html/wordpress
COPY ./srcs/wordpress/wp-config.php /var/www/html/wordpress/wp-config.php

RUN wget https://files.phpmyadmin.net/phpMyAdmin/${PHP_MYADMIN_VER}/phpMyAdmin-${PHP_MYADMIN_VER}-all-languages.tar.gz && \
	tar -xvf phpMyAdmin-${PHP_MYADMIN_VER}-all-languages.tar.gz && \
	rm phpMyAdmin-${PHP_MYADMIN_VER}-all-languages.tar.gz && \
	mv phpMyAdmin-${PHP_MYADMIN_VER}-all-languages phpmyadmin && \
	mv phpmyadmin /var/www/html/ && \
	cp -rp var/www/html/phpmyadmin/config.sample.inc.php var/www/html/phpmyadmin/config.inc.php 

# ssl config
COPY ./srcs/openssl/ openssl/
RUN /openssl/set_crt.sh > dev/null && rm -rf openssl/

# nginx config
COPY ./srcs/nginx/default.conf /etc/nginx/sites-available/default

EXPOSE 80 443

# start server
COPY ./srcs/entrypoint.sh ./
ENTRYPOINT ./entrypoint.sh
