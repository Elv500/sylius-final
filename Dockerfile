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
    && docker-php-ext-enable apcu

# -----------------------------
# Instalar Composer
# -----------------------------
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER=1

# -----------------------------
# Instalar Node.js y Yarn (para assets)
# -----------------------------
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install --global yarn

# -----------------------------
# Directorio de trabajo
# -----------------------------
WORKDIR /app

# -----------------------------
# Copiar todo el proyecto
# -----------------------------
COPY . .

# -----------------------------
# Instalar dependencias PHP y assets
# -----------------------------
# Composer con memoria ilimitada y sin prompts
RUN php -d memory_limit=-1 /usr/bin/composer install \
    --no-dev --optimize-autoloader --no-scripts --prefer-dist --no-interaction

# Instalar y construir assets
RUN yarn install && yarn build || true

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
