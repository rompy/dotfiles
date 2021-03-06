#!/bin/bash

# If not running interactively, don't do anything
case "$-" in
  *i*) ;;
  *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
export HISTCONTROL=ignoreboth:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# reedit a history substitution line if it failed
shopt -s histreedit

# edit a recalled history line before executing
shopt -s histverify

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# Ignore the ls command as well
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls:cd:ll:pwd:bg:fg:history'

_bash_history_sync() {
  # Append the command just entered to history file
  builtin history -a
  # Truncate file if needed
  HISTFILESIZE=$HISTSIZE
  # Clear the history of the running session
  builtin history -c
  # Reload the history
  builtin history -r
}

history() {
  _bash_history_sync
  builtin history "$@"
}

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  *-256*color*) color_prompt=yes;;
  eterm-color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

export PROMPT_DIRTRIM=4
PROMPT_COMMAND=_bash_history_sync

if ! type -t __git_ps1 >/dev/null 2>&1; then
  function __git_ps1 {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
  }
fi

if [ -d /usr/share/cmake/completions ]; then
  for cmakefile in /usr/share/cmake/completions/*; do
    source "$cmakefile"
  done
fi

export GIT_PS1_SHOWUPSTREAM=verbose
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWCOLORHINTS=1

if [ "$color_prompt" = yes ]; then
  case "$TERM" in
    xterm*|rxvt*|tmux*|screen*|eterm*|st*)
      if [ "$USERNAME" = root ]; then
        export PS1="\[\033[38;5;1m\]\u\033[0;10m @ \033[0;10m"
      else
        export PS1=
      fi

      export PS1=$PS1"\[\033[38;5;12m\]\w\033[0;10m\[\033[38;5;15m\]\033[0;10m\$(__git_ps1 ' (%s)')\[\033[38;5;1m\] >\033[0;10m\[\033[38;5;15m\] \033[0;10m"

      ;;
    *)
      PS1='\u@\h:\w\$ '
      ;;
  esac
else
  PS1='\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

[[ -f ~/.bash_env ]] && source ~/.bash_env
[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -f ~/.bash_functions ]] && source ~/.bash_functions

[[ -f ~/.bash_priv ]] && source ~/.bash_priv

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
# if ! shopt -oq posix; then
#   if [ -f /usr/share/bash-completion/bash_completion ]; then
#     . /usr/share/bash-completion/bash_completion
#     for f in /usr/share/bash-completion/completions/*
#     do
#         . $f
#     done
#   fi

#   if [ -f /etc/bash_completion ]; then
#     . /etc/bash_completion
#   fi
# fi

# typing '/etc' is the same as 'cd /etc'
shopt -s autocd

# small corrections to cd
shopt -s cdspell

# don't exit with running jobs (unless you force it)
shopt -s checkjobs

# same as cd but in more commands
shopt -s dirspell

# include . files in *
shopt -s dotglob

# ** pattern
shopt -s globstar

# [a-z] patterns
if shopt | grep -q globasciiranges ; then
  shopt -s globasciiranges
fi

# pipe input to read
shopt -s lastpipe

# don't complete on empty
shopt -s no_empty_cmd_completion

# Qute characters that are needed
if shopt | grep -q complete_fullquote ; then
  shopt -s complete_fullquote
fi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# FZF options
if  [ -x /usr/bin/fzf ]; then
  export FZF_TMUX=1

  if [ -f /usr/share/fzf/key-bindings.bash ]; then
    . /usr/share/fzf/key-bindings.bash
  fi

  if [ -f /usr/share/fzf/completion.bash ]; then
    . /usr/share/fzf/completion.bash
  fi
fi
