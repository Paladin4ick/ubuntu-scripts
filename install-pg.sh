#!/bin/bash

set -e

echo "Обновление системы..."
sudo apt update && sudo apt upgrade -y

echo "Установка PostgreSQL..."
sudo apt install -y postgresql postgresql-contrib curl ca-certificates gnupg lsb-release

echo "Запуск и включение PostgreSQL..."
sudo systemctl enable postgresql
sudo systemctl start postgresql

echo "Добавление репозитория pgAdmin..."
curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo tee /etc/apt/trusted.gpg.d/pgadmin.gpg > /dev/null

sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list'

sudo apt update

echo "Установка pgAdmin 4 (Web + Desktop)..."
sudo apt install -y pgadmin4-web

echo "Настройка pgAdmin..."
sudo /usr/pgadmin4/bin/setup-web.sh

echo "PostgreSQL и pgAdmin установлены и готовы к использованию."
echo "Откройте браузер и перейдите по адресу: http://localhost/pgadmin4"
