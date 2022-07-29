FROM php:7.4-apache
COPY index.php /var/www/html/
COPY images /var/www/html/images
EXPOSE 80
