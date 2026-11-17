# Stage 1: Build frontend assets with Vite
FROM node:22-bookworm-slim AS frontend
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --prefer-offline --no-audit
COPY . .
RUN npm run build

# Stage 2: Base PHP image with FrankenPHP & extensions
FROM dunglas/frankenphp:1-php8.4-bookworm AS base
RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    && install-php-extensions \
        pdo_mysql \
        intl \
        zip \
        bcmath \
        gd \
        opcache \
        pcntl
WORKDIR /app

# Stage 3: Composer dependencies & asset integration
FROM base AS dependencies
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY composer.json composer.lock ./
RUN composer install \
    --no-dev \
    --no-interaction \
    --no-progress \
    --no-scripts \
    --optimize-autoloader \
    --prefer-dist

COPY . .

# Copy production frontend build from Stage 1
COPY --from=frontend /app/public/build ./public/build

RUN mkdir -p \
    storage/framework/cache \
    storage/framework/sessions \
    storage/framework/views \
    storage/app/public/laporan \
    storage/app/public/profil \
    bootstrap/cache \
    && composer dump-autoload --no-dev --classmap-authoritative

# Stage 4: Production Runtime
FROM base AS runtime
COPY --from=dependencies --chown=www-data:www-data /app /app
COPY --chown=www-data:www-data Caddyfile /etc/frankenphp/Caddyfile

# Ensure public/storage symlink exists
RUN ln -sf /app/storage/app/public /app/public/storage

RUN setcap CAP_NET_BIND_SERVICE=+eip /usr/local/bin/frankenphp \
    && chown -R www-data:www-data /config/caddy /data/caddy /app/storage /app/bootstrap/cache

ENV PORT=80 \
    APP_ENV=production \
    APP_DEBUG=false \
    LOG_CHANNEL=stderr \
    CACHE_STORE=database \
    SESSION_DRIVER=database \
    QUEUE_CONNECTION=sync \
    VIEW_COMPILED_PATH=/tmp/views

USER www-data
CMD ["frankenphp", "run", "--config", "/etc/frankenphp/Caddyfile"]
