FROM php:7.0-apache

ENV TERM xterm

COPY docker/production/000-default.conf /etc/apache2/sites-enabled/000-default.conf
RUN apt-get update && apt-get install -y \
        libmcrypt-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev git \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install mysqli mcrypt pdo pdo_mysql
RUN a2enmod rewrite
RUN mkdir -p /var/www/html
# Install composer
RUN apt-get install -y bash wget unzip
RUN bash -c "wget http://getcomposer.org/composer.phar && chmod +x composer.phar && mv composer.phar /usr/local/bin/composer"

WORKDIR /var/www/html/