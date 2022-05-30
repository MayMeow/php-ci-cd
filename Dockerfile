FROM php:8.1.6-cli-buster

# Install NodeJS and NPM
RUN curl -sSL https://deb.nodesource.com/setup_12.x | bash \
    && apt-get update \
    && apt-get install --fix-missing -y nodejs unzip libicu-dev libpq-dev zlib1g-dev libpng-dev libzip-dev git

# Install PHP Extensions
RUN docker-php-ext-install intl pdo_pgsql gd zip pdo_mysql

# PHP Pecl Redis extensions
RUN pecl install redis
RUN docker-php-ext-enable redis

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt update \
    && apt -y install yarn

# Install wget
RUN apt update \
    && apt install -y wget

# Composer install
RUN curl -sSL https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer 

# Add Phar composer
RUN wget https://github.com/clue/phar-composer/releases/download/v1.4.0/phar-composer-1.4.0.phar \
    && chmod +x phar-composer-1.4.0.phar \
    && mv phar-composer-1.4.0.phar /usr/local/bin/phar-composer

# Codesniffer
RUN wget https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar \
    && chmod +x phpcs.phar \
    && mv phpcs.phar /usr/local/bin/phpcs

RUN wget https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar \
    && chmod +x phpcbf.phar \
    && mv phpcbf.phar /usr/local/bin/phpcbf

RUN wget https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.8.0/php-cs-fixer.phar \
    && chmod +x php-cs-fixer.phar \
    && mv php-cs-fixer.phar /usr/local/bin/php-cs-fixer

## PSALM

RUN wget https://github.com/vimeo/psalm/releases/download/4.23.0/psalm.phar \
    && chmod +x psalm.phar \
    && mv psalm.phar /usr/local/bin/psalm

## PHPUnit install
RUN wget https://phar.phpunit.de/phpunit-9.5.20.phar \
    && chmod +x phpunit-9.5.20.phar \
    && mv phpunit-9.5.20.phar /usr/local/bin/phpunit
    
RUN pecl install xdebug \ 
    && docker-php-ext-enable xdebug \
    # && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    # && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    # && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.mode=coverage" >> /usr/local/etc/php/conf.d/xdebug.ini

# Allow to create phars
# RUN echo 'phar.readonly="0"' >> /etc/php/7.4/cli/conf.d/ci.ini
RUN echo 'phar.readonly=0' >> /usr/local/etc/php/conf.d/docker-php-phar-readonly.ini
RUN echo "memory_limit=1024M" >> /usr/local/etc/php/conf.d/docker-php-memory-limit.ini

# Clean
RUN apt autoremove --purge \
    && apt clean

# test PHP
RUN php -v \
    && composer -v \
    && phpunit --version \
    && node -v \
    && npm -v \
    && phar-composer --version \
    && psalm --version
