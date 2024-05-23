#!/bin/sh

USERNAME=rcarvalh
FIRSTNAME=rodrigo

DB_HOST=mariadb
DB_NAME=wordpress
DB_ROOT=rootpass
DB_USER=wpuser
DB_PASS=wppass

ADM_WP_NAME=${USERNAME}@42.fr
ADM_WP_PASS=${USERNAME}
ADM_WP_EMAIL=${USERNAME}@42.fr

WP_USERNAME=${FIRSTNAME}@42.fr
WP_USEREMAIL=${FIRSTNAME}@42.fr
WP_USERPASS=${FIRSTNAME}

ENV_CONTENT="# Domain:\n\
DOMAIN_NAME=${USERNAME}.42.fr\n\
\n\
# Certificates:\n\
CERT_=./requirements/nginx/tools/${USERNAME}.42.fr\n\
KEY_=./requirements/nginx/tools/${USERNAME}.42.fr\n\
\n\
# Database:\n\
DB_NAME=${DB_NAME}\n\
DB_ROOT=${DB_ROOT}\n\
DB_USER=${DB_USER}\n\
DB_PASS=${DB_PASS}\n\
DB_HOST=${DB_HOST}\n\
\n\
# Wordpress\n\
WP_TITLE=${USERNAME}\n\
WP_HOST=${USERNAME}.42.fr\n\
\n\
ADM_WP_NAME=${USERNAME}@42.fr\n\
ADM_WP_PASS=${USERNAME}\n\
ADM_WP_EMAIL=${USERNAME}@42.fr\n\
\n\
WP_USERNAME=${FIRSTNAME}@42.fr\n\
WP_USEREMAIL=${FIRSTNAME}@42.fr\n\
WP_USERPASS=${FIRSTNAME}\n\
\n\
# FTP\n\
FTP_USR=ftpuser\n\
FTP_PWD=ftppass"

echo ${USERNAME}
echo ${ENV_CONTENT} > srcs/.env
echo "File .env generated."
