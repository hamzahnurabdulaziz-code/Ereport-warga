#!/bin/sh
set -e

# Ensure writable directories exist in /tmp for Vercel's read-only serverless filesystem
mkdir -p /tmp/caddy/config \
         /tmp/caddy/data \
         /tmp/views \
         /tmp/storage/framework/cache/data \
         /tmp/storage/framework/sessions \
         /tmp/storage/framework/views \
         /tmp/storage/logs \
         /tmp/storage/app/public \
         /tmp/storage/app/private/livewire-tmp

# Optional: Run database migrations on container startup if requested
if [ "$AUTO_MIGRATE" = "true" ] || [ "$AUTO_MIGRATE" = "1" ]; then
    echo "Running database migrations..."
    php /app/artisan migrate --force || echo "Warning: Migration failed, check database connection."
fi

exec "$@"
