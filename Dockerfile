# -----------------------------
# Dockerfile para Sylius en Render
# -----------------------------

# Imagen base con PHP 8.3 FPM
FROM php:8.3-fpm

# -----------------------------
# Instalar dependencias del sistema y extensiones PHP
# -----------------------------
RUN apt-get update && apt-get install -y \
    git unzip curl libicu-dev libpq-dev libxml2-dev libzip-dev libonig-dev libpng-dev libjpeg-dev libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install intl pdo pdo_mysql pdo_pgsql zip opcache gd exif mbstring \
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    && rm -rf /var/lib/apt/lists/*

# -----------------------------
# Instalar Composer
# -----------------------------
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER=1

# -----------------------------
# Instalar Node.js y Yarn
# -----------------------------
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install --global yarn

# -----------------------------
# Directorio de trabajo
# -----------------------------
WORKDIR /app
COPY . .

# -----------------------------
# Instalar dependencias PHP y assets
# -----------------------------
RUN php -d memory_limit=-1 /usr/bin/composer install --no-dev --optimize-autoloader --no-scripts
RUN yarn install && yarn build || true

# -----------------------------
# Ejecutar migraciones, fixtures y cache de Symfony
# -----------------------------
RUN php bin/console doctrine:migrations:migrate --no-interaction
RUN php bin/console sylius:fixtures:load --no-interaction
RUN php bin/console cache:clear --env=prod
RUN php bin/console cache:warmup --env=prod

# -----------------------------
# Variables de entorno por defecto
# -----------------------------
ENV APP_ENV=prod
ENV APP_DEBUG=0

# -----------------------------
# Exponer puerto
# -----------------------------
EXPOSE 8000

# -----------------------------
# Comando para arrancar Symfony
# -----------------------------
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]
