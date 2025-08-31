# Imagen base con PHP 8.3 y extensiones necesarias
FROM php:8.3-fpm

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git unzip libicu-dev libpq-dev libxml2-dev libzip-dev libonig-dev libpng-dev \
    && docker-php-ext-install intl pdo pdo_mysql pdo_pgsql zip opcache gd \
    && pecl install apcu \
    && docker-php-ext-enable apcu

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Setea el directorio de trabajo
WORKDIR /app

# Copia los archivos del proyecto
COPY . .

# Instalar dependencias PHP
RUN composer install --no-dev --optimize-autoloader

# Build assets (si usas webpack encore)
RUN yarn install && yarn build || true

# Variables de entorno de Symfony
ENV APP_ENV=prod
ENV APP_DEBUG=0

# Expone puerto
EXPOSE 8000

# Comando de arranque
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]
