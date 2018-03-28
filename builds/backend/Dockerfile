FROM php:7.1-fpm

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libz-dev \
    libmemcached-dev \
    python-setuptools

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/London /etc/localtime
RUN "date"

RUN docker-php-ext-install pdo pdo_mysql bcmath zip

RUN pecl install xdebug
RUN pecl install memcached

RUN easy_install supervisor

ADD ./supervisord.conf /etc/supervisord.conf
RUN mkdir -p /etc/supervisord

RUN docker-php-ext-enable xdebug

RUN echo extension=memcached.so >> /usr/local/etc/php/conf.d/memcached.ini
RUN echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "display_startup_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.idekey=\"PHPSTORM\"" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

WORKDIR /var/www/flex-spa/backend-app
