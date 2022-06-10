# Dockerfile #
# nginx      #
##############
FROM nginx:latest

COPY http.conf /etc/nginx/conf.d/default.conf
COPY cert.pem /etc/nginx/keys/cert.pem
COPY key.pem /etc/nginx/keys/key.pem

EXPOSE 443