#!/usr/bin/env bash
set -e

if command -v dos2unix >/dev/null 2>&1; then
    dos2unix "$0" >/dev/null 2>&1
fi

sudo apt-get update && sudo apt-get install -y zsh git curl

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "${ZSH_CUSTOM}/themes/powerlevel10k"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git \
        "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting" ]; then
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting"
fi

ZSHRC="$HOME/.zshrc"
if [ -f "$ZSHRC" ]; then
    cp "$ZSHRC" "${ZSHRC}.backup-$(date +%F_%H-%M-%S)"
    
    if grep -q "^ZSH_THEME=" "$ZSHRC"; then
        sed -i 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' "$ZSHRC"
    else
        echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> "$ZSHRC"
    fi

    if grep -q "^plugins=" "$ZSHRC"; then
        sed -i 's|^plugins=.*|plugins=(git docker docker-compose python ssh-agent zsh-syntax-highlighting zsh-autosuggestions fast-syntax-highlighting)|' "$ZSHRC"
    else
        echo 'plugins=(git docker docker-compose python ssh-agent zsh-syntax-highlighting zsh-autosuggestions fast-syntax-highlighting)' >> "$ZSHRC"
    fi
fi

if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)" "$USER"
fi

echo "✅ Zsh and oh-my-zsh installed successfully. Restart your terminal or run 'exec zsh'."