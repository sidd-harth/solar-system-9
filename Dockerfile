FROM php:7.4-apache
COPY index.php images /var/www/html
EXPOSE 80
