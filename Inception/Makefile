name = inception

.DEFAULT_GOAL = all

USERNAME = rcarvalh
FIRSTNAME = rodrigo

DB_HOST = mariadb
DB_NAME = wordpress
DB_ROOT = rootpass
DB_USER = wpuser
DB_PASS = wppass

ADM_WP_NAME=$(USERNAME)@42.fr
ADM_WP_PASS=$(USERNAME)
ADM_WP_EMAIL=$(USERNAME)@42.fr

WP_USERNAME=$(FIRSTNAME)@42.fr
WP_USEREMAIL=$(FIRSTNAME)@42.fr
WP_USERPASS=$(FIRSTNAME)

ENV_CONTENT = "\# Domain:\n\
DOMAIN_NAME=$(USERNAME).42.fr\n\
\n\
\# Certificates:\n\
CERT_=./requirements/nginx/tools/$(USERNAME).42.fr\n\
KEY_=./requirements/nginx/tools/$(USERNAME).42.fr\n\
\n\
\# Database:\n\
DB_NAME=$(DB_NAME)\n\
DB_ROOT=$(DB_ROOT)\n\
DB_USER=$(DB_USER)\n\
DB_PASS=$(DB_PASS)\n\
DB_HOST=$(DB_HOST)\n\
\n\
\# Wordpress\n\
WP_TITLE=$(USERNAME)\n\
WP_HOST=$(USERNAME).42.fr\n\
\n\
ADM_WP_NAME=$(USERNAME)@42.fr\n\
ADM_WP_PASS=$(USERNAME)\n\
ADM_WP_EMAIL=$(USERNAME)@42.fr\n\
\n\
WP_USERNAME=$(FIRSTNAME)@42.fr\n\
WP_USEREMAIL=$(FIRSTNAME)@42.fr\n\
WP_USERPASS=$(FIRSTNAME)\n\
\n\
\# FTP\n\
FTP_USR=ftpuser\n\
FTP_PWD=ftppasss"

setup: docker certs env
	@echo "Base Setup installed. System will reboot in 5s..."
	@sleep 5 && sudo reboot now

sudoers:
	@sudo echo -ne "Checking Sudo... " || exit 1 && echo OK!

docker: sudoers
	@sleep 3
	@echo "\nInstalling Docker..."
	sudo apt install -y docker docker-compose filezilla
	sudo usermod -aG docker $(USER)
	@echo "\nDocker installed successfully!"
	@echo "User $(USERNAME) added to Docker group."
	
certs:
	@sleep 3
	@echo "\nDownloading and installing mkcert..."
	sudo apt install libnss3-tools mkcert -y
	@echo "\nmkcert installed successfully."
	@echo "Updating packages..."
	sudo apt-get update
	mkcert -key-file srcs/requirements/nginx/tools/$(USERNAME).42.fr.key -cert-file srcs/requirements/nginx/tools/$(USERNAME).42.fr.crt https://$(USERNAME).42.fr
	@echo "\nCertificates created successfully."
	@echo "\n# Inception Routes\n127.0.0.1       $(USERNAME).42.fr\n$(cat /etc/hosts)" | sudo tee -a /etc/hosts
	@echo "\nRoutes created successfully."
	
env:
	@sleep 1
	@echo $(ENV_CONTENT) > srcs/.env
	@echo "\nFile .env generated."
	
info:
	@echo "Wordpress Login: https://$(USERNAME).42.fr https://$(USERNAME).42.fr/wp-login.php"
	@echo "    User: $(WP_USERNAME)"
	@echo "    Email: $(WP_USEREMAIL)"
	@echo "    Password: $(WP_USERPASS)"
	@echo "    Admin: $(ADM_WP_NAME)"
	@echo "    Email: $(ADM_WP_EMAIL)"
	@echo "    Password: $(ADM_WP_PASS)"
	@echo "Portainer: https://$(USERNAME).42.fr:9443"
	@echo "Website: http://localhost http://$(USERNAME).42.fr"
	@echo "Redis run-check: docker exec -it redis redis-cli monitor"
	@echo "Adminer DB: http://localhost:8080"
	@echo "    System: MySQL"
	@echo "    Server: $(DB_HOST)"
	@echo "    User: $(DB_USER)"
	@echo "    Password: $(DB_PASS)"
	@echo "    Database: $(DB_NAME)"
	@echo "Vsftpd: FileZilla"
	@echo "    Host: ftp://$(USERNAME).42.fr"
	@echo "    Username: $(DB_USER)"
	@echo "    Password: $(DB_PASS)"
	@echo "    Port: 443"

all:
	@printf "Launching ${name}...\n"
	@bash srcs/requirements/wordpress/tools/make_dir.sh
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d

build:
	@printf "Building  ${name}...\n"
	@bash srcs/requirements/wordpress/tools/make_dir.sh
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d --build

down:
	@printf "Stopping ${name}...\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env down

re: fclean env certs
	@printf "Rebuilding  ${name}...\n"
	@bash srcs/requirements/wordpress/tools/make_dir.sh
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d --build

clean: down
	@printf "Cleaning  ${name}...\n"
	@docker container prune --force
	@docker image prune --force
	@sudo rm -rf ~/data/mariadb/*
	@sudo rm -rf ~/data/wordpress/*

fclean: down
	@printf "Total clean of all docker config\n"
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force
	rm srcs/.env srcs/requirements/nginx/tools/*
	@sudo rm -rf ~/data
	
.PHONY	: all build down re clean fclean sudoers docker info certs env setup
