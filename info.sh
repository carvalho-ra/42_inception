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

FTP_USR=ftpuser
FTP_PWD=ftppass

echo "Wordpress: https://${USERNAME}.42.fr"
echo "           https://${USERNAME}.42.fr/wp-login.php"
echo "    User: ${WP_USERNAME}"
echo "    Email: ${WP_USEREMAIL}"
echo "    Password: ${WP_USERPASS}"
echo "    Admin: ${ADM_WP_NAME}"
echo "    Email: ${ADM_WP_EMAIL}"
echo "    Password: ${ADM_WP_PASS}"
echo "Portainer: https://${USERNAME}.42.fr:9443"
echo "Website: http://localhost http://${USERNAME}.42.fr"
echo "Redis run-check: docker exec -it redis redis-cli monitor"
echo "Adminer DB: http://localhost:8080"
echo "    System: MySQL"
echo "    Server: ${DB_HOST}"
echo "    User: ${DB_USER}"
echo "    Password: ${DB_PASS}"
echo "    Database: ${DB_NAME}"
echo "Vsftpd: FileZilla"
echo "    Host: ${USERNAME}.42.fr"
echo "    Username: ${FTP_USR}"
echo "    Password: ${FTP_PWD}"
echo "    Port: none"
