
FROM alpine:3.12.0
# Upgrade existing packages in the base image
RUN apk update && apk --no-cache upgrade
RUN apk add --no-cache openrc apache2 php7-apache2 libmcrypt-dev php7 php7-fpm php7-opcache php7-pdo_mysql php7-xml \
    php7-xmlrpc php7-json php7-soap php7-mbstring php7-pecl-mcrypt php7-pecl-memcache php7-mysqli php7-ctype
RUN rc-update add php-fpm7 default
# Apache2 config file (Allow ovverride + mod_rewrite enable)
RUN sed -i '265s/AllowOverride None/AllowOverride All/g' /etc/apache2/httpd.conf 
RUN sed -i "s%#LoadModule rewrite_module%LoadModule rewrite_module%g" /etc/apache2/httpd.conf
# Copy backend files
RUN mkdir /var/www/localhost/htdocs/dtapi
COPY ./ /var/www/localhost/htdocs/dtapi
# Acess for web users
RUN chown apache. -R /var/www/localhost/htdocs/
# Run httpd in foreground so that the container does not quit
CMD ["-D","FOREGROUND"]
# Start httpd when container runs
ENTRYPOINT ["/usr/sbin/httpd"]