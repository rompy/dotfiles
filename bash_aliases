#!/bin/bash

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls -hAF --group-directories-first -v --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
else
  alias ls='ls -hAF'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# standard ones
alias mv='mv -v'
alias cp='cp -r'
alias du='du -h'
alias path='echo -e ${PATH//:/\\n}'
alias mounts='mount | column -t'
alias wget='wget -c'
alias df='df -h'
alias cls='printf "\033c"'
alias tmux="tmux -2"

# And now for new ones
alias gs='git status'
alias gl='git l -100'
alias gh='show_git_head'
alias gc='git checkout'
alias gcd='git checkout devel'
alias gcm='git checkout master'
alias gf='git flow'
alias gd='git diff'

alias down-mp3='youtube-dl --restrict-filenames -x -f bestaudio --audio-format mp3 --audio-quality 0 -o "%(title)s.%(ext)s" -i'
alias down-list='youtube-dl --restrict-filenames -x -f bestaudio --audio-format mp3 --audio-quality 0 -o "%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" -i'

alias gdb='gdb -q'
alias e=$EDITOR
alias ec=$EMACS_CLIENT
alias ecd='emacs --daemon'
alias eck='emacsclient -e "(kill-emacs)"'
alias magit='emacs -nw --eval "(magit-status \"$(git rev-parse --show-toplevel)\")"'

alias dns='ipconfig.exe /all | grep -Eoz "DNS Servers[^\r\n]+[\r\n]+(?(?=   )\s+[^\r\n]+[\r\n]+|)+" | grep -Eoz "([0-9]{1,3}\.){3}[0-9]{1,3}" | xclip && sudo vim /etc/resolv.conf'
alias mounts='mount | column -t -N name,location,type,opts -H2,4'

alias icat='kitty +kitten icat'
alias kitdiff='kitty +kitten diff'
