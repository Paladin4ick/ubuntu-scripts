#!/bin/bash

set -e

echo ">>> Обновление списка пакетов..."
sudo apt update -y

echo ">>> Установка зависимостей..."
sudo apt install -y software-properties-common wget build-essential

echo ">>> Добавляем PPA для Python 3.13..."
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt update -y

echo ">>> Установка Python 3.13..."
sudo apt install -y python3.13 python3.13-venv python3.13-dev python3.13-distutils

echo ">>> Настраиваем update-alternatives для python3..."
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.13 2
sudo update-alternatives --config python3

echo "✅ Установка Python 3.13 завершена!"
python3.13 --version
pip3 --version
