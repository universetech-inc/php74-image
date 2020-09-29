# Set the base image for subsequent instructions
FROM php:7.4
ENV TZ=Asia/Taipei
# Update packages
RUN apt-get clean && apt-get -y update
# Install PHP and composer dependencies
RUN apt-get install -qq git curl libmcrypt-dev libjpeg-dev libpng-dev libfreetype6-dev libbz2-dev libzip-dev \
    libonig-dev libcurl4-openssl-dev autoconf
# Install Docker
RUN apt-get install -y docker.io
# Clear out the local repository of retrieved package files
RUN apt-get remove -y --purge software-properties-common \
	&& apt-get -y autoremove \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# install composer
RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer
# Install needed extensions
# Here you can install any other extension that you need during the test and deployment process
RUN docker-php-ext-install pdo_mysql zip gd bcmath mbstring curl pcntl
# install mongodb ext
RUN pecl install mongodb \
    && docker-php-ext-enable mongodb
# install redis
RUN pecl install redis && docker-php-ext-enable redis
# install grpc
RUN pecl install grpc && docker-php-ext-enable grpc
CMD service docker start