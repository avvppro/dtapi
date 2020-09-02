
FROM alpine:3.12.0
RUN apk update && apk --no-cache upgrade
RUN apk add --no-cache openrc apache2 php7-apache2 libmcrypt-dev php7 php7-fpm php7-opcache php7-pdo_mysql php7-xml \
    php7-xmlrpc php7-json php7-soap php7-mbstring php7-pecl-mcrypt php7-pecl-memcache php7-mysqli php7-ctype
RUN rc-update add php-fpm7 default
RUN sed -i '265s/AllowOverride none/AllowOverride All/g' /etc/apache2/httpd.conf 
RUN sed -i "s%#LoadModule rewrite_module%LoadModule rewrite_module%g" /etc/apache2/httpd.conf
RUN mkdir /var/www/localhost/htdocs/dtapi
COPY ./ /var/www/localhost/htdocs/dtapi
RUN chown apache. -R /var/www/localhost/htdocs/
CMD ["-D","FOREGROUND"]
ENTRYPOINT ["/usr/sbin/httpd"]