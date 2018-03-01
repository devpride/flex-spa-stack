FROM php:7.1-apache-jessie

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libz-dev \
    libmemcached-dev

ADD phpmemadmin.dev.conf /etc/apache2/sites-available/
ADD composer.json /var/www/phpmemadmin/
RUN a2ensite phpmemadmin.dev

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/London /etc/localtime
RUN "date"

RUN pecl install memcached

WORKDIR /var/www/phpmemadmin
