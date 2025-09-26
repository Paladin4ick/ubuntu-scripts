#!/usr/bin/env bash
set -e

echo "Обновление системы и установка zsh..."
sudo apt-get update && sudo apt-get install -y zsh git curl

# Проверка, установлен ли zsh
if ! command -v zsh &> /dev/null; then
    echo "Ошибка: zsh не установлен"
    exit 1
fi

echo "Установка oh-my-zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "oh-my-zsh уже установлен"
fi

echo "Установка темы powerlevel10k..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "${ZSH_CUSTOM}/themes/powerlevel10k"
else
    echo "powerlevel10k уже установлен"
fi

echo "Установка плагина zsh-syntax-highlighting..."
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
else
    echo "zsh-syntax-highlighting уже установлен"
fi

ZSHRC="$HOME/.zshrc"
if [ -f "$ZSHRC" ]; then
    # Создание резервной копии .zshrc
    cp "$ZSHRC" "${ZSHRC}.backup-$(date +%F_%H-%M-%S)"
    
    # Проверка и обновление ZSH_THEME
    if grep -q "^ZSH_THEME=" "$ZSHRC"; then
        sed -i 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' "$ZSHRC"
    else
        echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> "$ZSHRC"
    fi

    # Проверка и обновление plugins
    if grep -q "^plugins=" "$ZSHRC"; then
        sed -i 's|^plugins=.*|plugins=(git docker docker-compose python ssh-agent zsh-syntax-highlighting)|' "$ZSHRC"
    else
        echo 'plugins=(git docker docker-compose python ssh-agent zsh-syntax-highlighting)' >> "$ZSHRC"
    fi
else
    echo "Файл .zshrc не найден"
    exit 1
fi

# Проверка и установка zsh как оболочки по умолчанию
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Установка zsh как оболочки по умолчанию..."
    chsh -s "$(which zsh)" "$USER"
fi

echo "Установка завершена. Перезапусти терминал или выполни 'exec zsh'"
