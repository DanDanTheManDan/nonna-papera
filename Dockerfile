# Tiny static-site image. Final image is ~25 MB.
FROM nginx:1.27-alpine

# Replace the default nginx config with one tuned for a static SPA-ish site.
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the app.
COPY public/ /usr/share/nginx/html/

EXPOSE 80

# Healthcheck so docker / compose can tell when the app is actually serving.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1
