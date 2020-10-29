FROM php:7.4.10-cli-buster

# Install NodeJS and NPM
RUN curl -sSL https://deb.nodesource.com/setup_12.x | bash \
    && apt-get update \
    && apt-get install --fix-missing -y nodejs unzip libicu-dev libpq-dev zlib1g-dev libpng-dev

# Install PHP Extensions
RUN docker-php-ext-install intl pdo_pgsql gd

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
RUN wget https://github.com/clue/phar-composer/releases/download/v1.1.0/phar-composer-1.1.0.phar \
    && chmod +x phar-composer-1.1.0.phar \
    && mv phar-composer-1.1.0.phar /usr/local/bin/phar-composer

## PHPUnit install
RUN wget https://phar.phpunit.de/phpunit-7.0.3.phar \
    && chmod +x phpunit-7.0.3.phar \
    && mv phpunit-7.0.3.phar /usr/local/bin/phpunit

# Allow to create phars
# RUN echo 'phar.readonly="0"' >> /etc/php/7.4/cli/conf.d/ci.ini
RUN echo 'phar.readonly=0' >> /usr/local/etc/php/conf.d/docker-php-phar-readonly.ini

# Clean
RUN apt autoremove --purge \
    && apt clean

# test PHP
RUN php -v \
    && composer -v \
    && phpunit --version \
    && node -v \
    && npm -v \
    && phar-composer --version
