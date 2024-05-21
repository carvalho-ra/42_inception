name = inception

.DEFAULT_GOAL := all

USERNAME = rcarvalh
FIRSTNAME = Rodrigo

ENV_CONTENT = " DOMAIN_NAME=$(USERNAME).42.fr			\n\
CERT_=./requirements/tools/$(USERNAME).42.fr			\n\
KEY_=./requirements/tools/$(USERNAME).42.fr			\n\
DB_NAME=wordpress						\n\
DB_ROOT=rootpass						\n\
DB_USER=wpuser							\n\
DB_PASS=wppass							\n\
DB_HOST=mariadb							\n\
WP_TITLE=Teste							\n\
ADM_WP_NAME=$(USERNAME)@42.fr					\n\
ADM_WP_PASS=$(USERNAME)						\n\
ADM_WP_EMAIL=$(USERNAME)@42.fr					\n\
WP_USERNAME=$(FIRSTNAME)@42.fr					\n\
WP_USEREMAIL=$(FIRSTNAME)@42.fr					\n\
WP_USERPASS=$(FIRSTNAME)					\n\
WP_HOST=$(USERNAME).42.fr					\n\
FTP_USR=ftpuser							\n\
FTP_PWD=ftppasss"

setup: docker certs env
	@echo "Base Setup installed. System will reboot in 5s..."
	@sleep 5 && sudo reboot now

sudoers:
	@sudo echo -ne "Checking Sudo... " || exit 1 && echo OK!

docker: sudoers
	@sleep 3
	@echo "\nInstalling Docker..."
	sudo apt install -y ufw docker docker-compose openbox xinit kitty filezilla firefox-esr
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
	@echo "Pontainer: https://$(USERNAME).42.fr:9443"
	@echo "Wordpress Login: https://$(USERNAME).42.fr/wp-login.php"
	@echo "Redis run-check: docker exec -it redis redis-cli monitor"
	@echo "Adminer DB: localhost:8080"

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

re:
	@printf "Rebuilding  ${name}...\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d --build

clean: down
	@printf "Cleaning  ${name}...\n"
	@docker system prune -a
	@sudo rm -rf ~/data/wordpress/*
	@sudo rm -rf ~/data/mariadb/*

fclean:
	@printf "Total clean of all docker config\n"
	@docker stop $$(docker ps -qa)
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force
	@sudo rm -rf ~/data/wordpress/*
	@sudo rm -rf ~/data/mariadb/*
	
.PHONY	: all build down re clean fclean sudoers docker info certs env setup
