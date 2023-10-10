export PATH="$PATH:${$(find ~/.local/bin -type d -printf %p:)%%:}"
export PATH="$PATH:/home/alzr7th/.ghcup/bin"
export EDITOR="nvim"
export TERMINAL="st"
export BROWSER="firefox"

eval "$(zoxide init zsh)"

#################################################################################################################################################################

# Enable colors and change prompt:
autoload -U colors && colors    # Load colors
# Find and set branch name var if in git repository.
function git_branch_name() {
  branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
  if [[ $branch == "" ]]; then
    :
  else
    echo '  '$branch''
  fi
}

function cmd_duration {
  cmd_start_time=$(date +%s.%N)
  eval "$1"
  cmd_end_time=$(date +%s.%N)
  cmd_duration=$(echo "scale=0; ($cmd_end_time - $cmd_start_time) * 1000 / 1" | bc)
  echo "${cmd_duration}ms"
}
# Enable substitution in the prompt.
setopt prompt_subst
# Mengatur prompt PS1
# PS1=$'%F{%(#.blue.green)}┌────(%B%F{%(#.red.blue)}%n%(#.💀.💀)%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]$(git_branch_name)  $(date "+%H:%M") $(cmd_duration)\n└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
PS1=$'%F{%(#.blue.green)}┌────(%B%F{%(#.red.blue)}%n%(#.💀.💀)%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]$(git_branch_name)  $(date "+%H:%M") %ftook %F{green}$(cmd_duration)%f\n%F{green}└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '


################################################################################################################################################################

setopt autocd       # Automatically cd into typed directory.
stty stop undef     # Disable ctrl-s to freeze terminal.
setopt interactive_comments

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"


source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)       # Include hidden files.

# Enable vi mode
bindkey -v
bindkey '^?' backward-delete-char

# Function to switch from insert mode to normal mode when pressing 'jk' in sequence
function jk-to-normal-mode() {
    emulate -L zsh
    zle vi-cmd-mode
    zle .self-insert
}
zle -N jk-to-normal-mode

# Bind the jk-to-normal-mode function to the 'jk' key sequence in insert mode
bindkey -M viins 'jk' jk-to-normal-mode

# Bind the 'jk' key sequence to switch to normal mode directly in insert mode
bindkey -M viins 'jk' vi-cmd-mode

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char


# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp -uq)"
    trap 'rm -f $tmp >/dev/null 2>&1 && trap - HUP INT QUIT TERM PWR EXIT' HUP INT QUIT TERM PWR EXIT
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

bindkey -s '^o' '^ulfcd\n'

bindkey -s '^a' '^ubc -lq\n'

bindkey -s '^f' '^ucd "$(dirname "$(fzf)")"\n'

bindkey '^[[P' delete-char

# bindkey -s ^f "tmuxz\n"
# bindkey -s ^z "tmuxwz\n"
# bindkey -s ^i "tmux-cht\n"

# Colorize commands when possible.
alias \
	ls="ls -hN --color=auto --group-directories-first" \
	lsa="ls -al -hN --color=auto --group-directories-first" \
	grep="grep --color=auto" \
	diff="diff --color=auto" \
	ccat="highlight --out-format=ansi" \
	ip="ip -color=auto" \
  vi="nvim" \
  n="neofetch" \
  ra="ranger" \
  q="exit" \
  c="clear"


#auto startx
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    startx
fi

export _JAVA_AWT_WM_NONREPARENTING=1.


