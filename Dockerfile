FROM php7.2 

# Copy composer.lock and composer.json
#COPY composer.lock composer.json /var/www/

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get update  && apt-get install -y \
    build-essential \
    libfreetype6-dev \
    locales \
    zip \
    vim \
    unzip \
    git \
    curl \
    nodejs \
    #php7.2 \
    apache2 \
    #apache2-utils\


# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*


# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
RUN docker-php-ext-install gd

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --fileckname=composer

# Login To Docker
#RUN dossh root@192.168.1.248 
#apt-get update

# Copy existing application directory contents
COPY . /var/www

# Copy existing application directory permissions
COPY --chown=www:www . /var/www

# Change current user to www
USER www

# Expose port 8000 and start php-fpm server
EXPOSE 8000
ENTRYPOINT [ "/usr/sbin/apache2ctl" ]#Define default command
CMD ["php-fpm","-D", "FOREGROUND"]