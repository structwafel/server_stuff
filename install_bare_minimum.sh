#!/bin/bash

# Install zsh
sudo apt-get update
sudo apt-get install zsh -y

# Install necessary zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions /usr/share/zsh/plugins/zsh-autosuggestions
git clone https://github.com/zdharma/fast-syntax-highlighting.git /usr/share/zsh/plugins/fast-syntax-highlighting
git clone https://github.com/hlissner/zsh-autopair.git /usr/share/zsh/plugins/zsh-autopair

# Install other necessary tools
sudo apt-get install ssh -y
sudo apt-get install golang-go -y
sudo apt-get install fzf -y
sudo apt-get install tree -y
curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh | sh
curl -sS https://starship.rs/install.sh | sh

# Create .zshrc file
cat << 'EOF' > ~/.zshrc
# ssh agent
if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval "$(ssh-agent -s)" > /dev/null
fi

# paths
export PATH=$PATH:$HOME/go/bin

# plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
zle_highlight=('paste:none')
source /usr/share/zsh/plugins/zsh-autopair/zsh-autopair.plugin.zsh

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY

# keybindings
source  /home/lgx/.zsh-keybindings.zsh

# Load zsh completion.
autoload -Uz compinit && compinit
# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
# partial completion suggestions
zstyle ':completion:*' list-suffixeszstyle ':completion:*' expand prefix suffix

# Auto fix small errors
setopt nocaseglob # ignore case
setopt correct # correct spelling mistakes

# automatically cd into directory without typing cd
setopt auto_cd

# export CARGO_TARGET_DIR="$HOME/.cargo/shared-target"

# aliases
alias clr="clear"
alias ls="eza"
alias ll="eza -l"
alias lll="eza -la"
alias -- -='cd -'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias python='python3'
alias pip='pip3'

# exports
export TERM=xterm-256color
export PATH=/home/lgx/bin:$PATH
export DOCKER_HOST=unix:///run/user/1000/docker.sock

# functions
# create and cd into directory
take () {
    mkdir -p "$1" && cd "$1"
}

jj () {
    cd "${1:-.}/$(find . -maxdepth 5 -type d -name .git | sed 's|/.git$||' | fzf --preview 'tree -L 2 ./{}')"
}
jjp () {
    cd "${1:-.}/$(find . -maxdepth 5 -type d -name .git -not -path '*/.cache/*' | sed 's|/.git$||' | fzf --preview 'tree -L 2 ./{}')"
}


eval "$(atuin init zsh)"

# starship <3

eval "$(starship init zsh)"
EOF

# Source .zshrc
source ~/.zshrc