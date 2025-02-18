.PHONY: help
.DEFAULT_GOAL = help

dc = docker compose
de = $(dc) exec
composer = $(de) php memory_limit=1 /usr/local/bin/composer

## —— Docker 🐳  ———————————————————————————————————————————————————————————————
.PHONY: install
install:	## Installation du projet
	$(dc) up -d
	$(de) php bash -c 'composer install'
	$(de) php bash -c 'npm i && npm run dev'
	$(de) php bash -c 'php bin/console key-generate'


.PHONY: ps
ps:
	$(dc) ps -a
	@echo

	$(eval APP_ID := $(shell bin/docker-compose ps -q $(APP_SERVICE_NAME) 2> /dev/null))
	$(eval APP_PORT := $(shell docker inspect $(APP_ID) --format='{{json (index (index .NetworkSettings.Ports "8080/tcp") 0).HostPort}}' 2> /dev/null))

.PHONY: build
build:	## Lancer les containers docker au start du projet
	$(dc) up -d
	$(dc) exec php bash -c 'composer install'
	$(dc) exec php bash -c 'npm install && npm run build'
	$(dc) exec php bash -c 'php bin/console d:m:m && php bin/console d:f:l'

.PHONY: dev
dev:	## start container
	$(dc) up -d

.PHONY: dcexec
dcexec:	## connexion container php
	$(de) php bash

.PHONY: delete
delete:	## delete container
	$(dc) down
	$(dc) kill
	$(dc) rm

## —— Quality Assurance 🛠️️ ———————————————————————————————————————————————————————————————
.PHONY: phpstan
phpstan:  ## phpstan
	vendor/bin/phpstan analyse --memory-limit=2G

.PHONY: phpcs
phpcs: ## PHP_CodeSnifer Geolid flavoured (https://github.com/Geolid/phpcs)
	vendor/bin/phpcs
	vendor/bin/php-cs-fixer fix --dry-run --diff

.PHONY: phpcs-fix
phpcs-fix: ## Automatically correct coding standard violations
	vendor/bin/php-cs-fixer fix

.PHONY: twigcs
twigcs: ## Twigcs (https://github.com/allocine/twigcs)
	vendor/bin/twigcs templates

.PHONY: prettier
prettier: ## Format code
	npx prettier --check 'assets/**/*.{js,css}' '.prettierrc.json' 'composer.json' 'package.json'

.PHONY: prettier-fix
prettier-fix: ## Format code
	npx prettier --write 'assets/**/*.{js,css}' '.prettierrc.json' 'composer.json' 'package.json'

## —— Others 🛠️️ ———————————————————————————————————————————————————————————————
help: ## listing command
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
