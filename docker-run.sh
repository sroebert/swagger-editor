#! /bin/sh

set -e

BASE_URL=${BASE_URL:-/}
NGINX_ROOT=/usr/share/nginx/html
INDEX_FILE=$NGINX_ROOT/index.html
NGINX_CONF=/etc/nginx/nginx.conf

if [[ "${BASE_URL}" != "/" ]]; then
  sed -i "s|location / {|location $BASE_URL {|g" $NGINX_CONF
fi

## Adding env var support for swagger file (json or yaml)
sed -i "s|SwaggerEditorBundle({|SwaggerEditorBundle({\n      url: '$SWAGGER_URL',|g" $INDEX_FILE

# Gzip after replacements
find /usr/share/nginx/html/ -type f -regex ".*\.\(html\|js\|css\)" -exec sh -c "gzip < {} > {}.gz" \;

exec nginx -g 'daemon off;'
