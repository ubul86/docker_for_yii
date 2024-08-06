.PHONY: help \
build \
upd \
up \
down \
stop \
composer \
npm \
npm-dev \
init \
database \
writables

.DEFAULT_GOAL := help

# Set dir of Makefile to a variable to use later
MAKEPATH := $(abspath $(lastword $(MAKEFILE_LIST)))
PWD := $(dir $(MAKEPATH))

#USER_ID=$(shell id -u)
#GROUP_ID=$(shell id -g)

USER_ID=root
GROUP_ID=root

DOCKER_COMPOSE_YML=.docker/config/docker-compose.yml

help: ## * Show help (Default task)
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Step 1. Build services
	CURRENT_UID=$(USER_ID):$(GROUP_ID) docker-compose --file $(DOCKER_COMPOSE_YML) -p project build

upd: ## Step 2. Run containers in the background (This is in the setup process)
	CURRENT_UID=$(USER_ID):$(GROUP_ID) docker-compose --file $(DOCKER_COMPOSE_YML) -p project up -d --remove-orphans

up: ## Step 2. Run containers in the foreground
	CURRENT_UID=$(USER_ID):$(GROUP_ID) docker-compose --file $(DOCKER_COMPOSE_YML) -p project up --remove-orphans

down: ## Shut down containers and remove orphans
	CURRENT_UID=$(USER_ID):$(GROUP_ID) docker-compose --file $(DOCKER_COMPOSE_YML) -p project down --remove-orphans

stop: ## Stops containers
	CURRENT_UID=$(USER_ID):$(GROUP_ID) docker-compose --file $(DOCKER_COMPOSE_YML) -p project stop

composer: ## Install php dependencies
	docker exec $(if $(INIT_SCRIPT),-i,$(if $(INIT_SCRIPT),-i,-ti)) -w /www/local project-php72-fpm composer install --ignore-platform-reqs

init: ## Initialize the environment
	docker exec $(if $(INIT_SCRIPT),-i,$(if $(INIT_SCRIPT),-i,-ti)) -w /www/local project-php72-fpm php init --env=dev --overwrite=All

npm: ## Install npm packages
	docker exec $(if $(INIT_SCRIPT),-i,$(if $(INIT_SCRIPT),-i,-ti)) -w /www/local project-php72-fpm npm install

writables: ## Set writable directories
	docker exec $(if $(INIT_SCRIPT),-i,-ti) -w /www/local project-php72-fpm chmod -R 777 frontend/web
	docker exec $(if $(INIT_SCRIPT),-i,-ti) -w /www/local project-php72-fpm chmod -R 777 backend/web
	docker exec $(if $(INIT_SCRIPT),-i,-ti) -w /www/local project-php72-fpm chmod -R 777 api/web
	docker exec $(if $(INIT_SCRIPT),-i,-ti) -w /www/local project-php72-fpm chmod -R 777 console/runtime
	docker exec $(if $(INIT_SCRIPT),-i,-ti) -w /www/local project-php72-fpm chmod -R 777 backend/runtime
	docker exec $(if $(INIT_SCRIPT),-i,-ti) -w /www/local project-php72-fpm chmod -R 777 api/runtime
	docker exec $(if $(INIT_SCRIPT),-i,-ti) -w /www/local project-php72-fpm chmod -R 777 common/config/main-local.php
	docker exec $(if $(INIT_SCRIPT),-i,-ti) -w /www/local project-php72-fpm chmod -R 777 common/config/params-local.php
	docker exec $(if $(INIT_SCRIPT),-i,-ti) -w /www/local project-php72-fpm chmod -R 777 vendor/

migration: ## Run migration
	docker exec $(if $(INIT_SCRIPT),-i,$(if $(INIT_SCRIPT),-i,-ti)) -w /www/local project-php72-fpm php yii migrate --interactive=0

uninstall: down ## Shut down containers and do additional cleanup (prune volumes, containers and images)
	docker volume prune -f
	docker container prune -f
	docker image prune -f

cli-php: ## Enters to the project-php72-fpm container with bash prompt
	docker exec $(if $(INIT_SCRIPT),-i,-ti) -w /www/local project-php72-fpm bash

## Start containers and setup the development environment
all: down build upd composer init npm writables
