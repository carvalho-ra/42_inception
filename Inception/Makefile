name = inception

.DEFAULT_GOAL = all

USERNAME = rcarvalh
FIRSTNAME = rodrigo

setup: docker certs env
	@echo "Base Setup installed. System will reboot in 5s..."
	@sleep 5 && sudo reboot now

sudoers:
	@sudo echo -ne "Checking Sudo... " || exit 1 && echo OK!
	@echo "$(USER) ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$(USER)-permissions

docker: sudoers
	@sleep 3
	@echo "Installing Docker..."
	
	@echo "Adding Docker's official GPG key..."
	@sudo apt update
	@sudo apt install -y ca-certificates curl
	@sudo install -m 0755 -d /etc/apt/keyrings
	@sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
	@sudo chmod a+r /etc/apt/keyrings/docker.asc

	@echo "Creating Docker repository file..."
	@echo "deb [arch=$$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $$(. /etc/os-release && echo $$VERSION_CODENAME) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

	@echo "Installing Docker packages..."
	@sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	@sudo usermod -aG docker $(USER)
	@echo "Docker installed successfully!"
	@echo "User $(USER) added to Docker group."

	@echo "Installing Filezilla..."
	@sudo apt install -y filezilla
	@echo "Filezilla installed successfully!"
	
	@sudo apt autoremove -y

certs:
	@sleep 3
	@echo "Downloading and installing mkcert..."
	@sudo apt install libnss3-tools mkcert -y
	@echo "mkcert installed successfully."
	@echo "Updating packages..."
	@sudo apt-get update
	@mkcert -key-file srcs/requirements/nginx/tools/$(USERNAME).42.fr.key -cert-file srcs/requirements/nginx/tools/$(USERNAME).42.fr.crt https://$(USERNAME).42.fr
	@echo "Certificates created successfully."
	@echo "\n# Inception Routes\n127.0.0.1       $(USERNAME).42.fr\n$(cat /etc/hosts)" | sudo tee -a /etc/hosts
	@echo "Routes created successfully."
	
env:
	../create_env.sh
	
info:
	../info.sh

all:
	@printf "Launching ${name}...\n"
	@bash srcs/requirements/wordpress/tools/make_dir.sh
	@docker compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d --build
	@sudo chmod -R 777 ~/data

build:
	@printf "Building  ${name}...\n"
	@bash srcs/requirements/wordpress/tools/make_dir.sh
	@docker compose -f ./srcs/docker-compose.yml --env-file srcs/.env build
	@sudo chmod -R 777 ~/data

down:
	@printf "Stopping ${name}...\n"
	@docker compose -f ./srcs/docker-compose.yml --env-file srcs/.env down

re: fclean env certs
	@printf "Rebuilding  ${name}...\n"
	@bash srcs/requirements/wordpress/tools/make_dir.sh
	@docker compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d --build
	@sudo chmod -R 777 ~/data

clean: down
	@printf "Cleaning  ${name}...\n"
	@docker compose -f ./srcs/docker-compose.yml --env-file srcs/.env down --volumes
	@docker container prune --force
	@docker image prune --force
	@sudo rm -rf ~/data/mariadb/*
	@sudo rm -rf ~/data/wordpress/*

fclean: down
	@printf "Clean of all docker configs\n"
	@docker compose -f ./srcs/docker-compose.yml --env-file srcs/.env down --volumes
	@docker image prune --all --force
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force
	@rm srcs/.env srcs/requirements/nginx/tools/*
	@sudo rm -rf ~/data

remove_sudoers:
	@sudo rm /etc/sudoers.d/$(USER)-permissions
	@echo "Removed sudoers configuration for $(USER)"
	
.PHONY	: all build down re clean fclean sudoers docker info certs env setup remove_sudoers
