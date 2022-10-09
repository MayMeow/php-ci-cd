:warning: THis repository is no longer maintained, Use **SDK** image from [MayMeow/php](https://github.com/MayMeow/php)

# 📦 PHP CI/CD container image

This is docker image for ci/cd which i using in almost all my projects.

## What is included?

* PHP 7.4.0 based on official [PHP's docker image](https://hub.docker.com/_/php)
* PHP extensions: intl, pdo_pgsql, gd and zip
* Pecl extensions: redis
* Node and NPM from [Nodesource](https://github.com/nodesource/distributions) distribution
* Yarn
* Composer [HomePage](https://getcomposer.org/)
* PHPUnit [HomePage](https://phpunit.de/)
* Phar composer [Repository](https://github.com/clue/phar-composer)
* Wget

## PHP's changed config

* Enable to create phar files

## ⚙ Used in Actions

* [MayMeowHQ/PHPUnit-Test-Action](https://github.com/MayMeowHQ/PHPUnit-Test-Action)

## 🐳 Docker image

If you want you can use image which can be found on docker hub [maymeow/php-ci-cd](https://hub.docker.com/repository/docker/maymeow/php-ci-cd)
