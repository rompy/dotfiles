#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
alias ls='ls -hAF --group-directories-first -v --color=auto'
alias tmux="tmux -2"
alias gdb='gdb -q'
alias cls='printf "\033c"'

# Own git
alias g='git'
alias gs='git status'
alias gl='git l -100'
alias gh='show_git_head'
alias gc='git checkout'
alias gcd='git checkout devel'
alias gcm='git checkout master'
alias gf='git flow'
alias gd='git diff'

alias v='vim'

alias down-mp3='youtube-dl --restrict-filenames -x -f bestaudio --audio-format mp3 --audio-quality 0 -o "%(title)s.%(ext)s" -i'
alias down-list='youtube-dl --restrict-filenames -x -f bestaudio --audio-format mp3 --audio-quality 0 -o "%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" -i'

alias temps="paste <(cat /sys/class/thermal/thermal_zone*/type) <(cat /sys/class/thermal/thermal_zone*/temp) | column -s $'\t' -t | sed 's/...$/.0°C/'"