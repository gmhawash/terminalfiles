echo Executing $BASH_ARGV

# Allows you to navigate to dirs in ~/src/rpace or ~/src/dlm
if test “${PS1+set}”; then export CDPATH=.:~/src/dlm:~/src/dlm/beehive/workers/v2:~/src:self; fi

alias startpg='pg_ctl -D /usr/local/var/postgres -l logfile start'
alias ll='ls -alG'
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias tips='vim ~/tips.txt'
alias mux='tmuxinator'
alias muxrails='mux start rails'
alias muxbee='mux start beehive'
alias muxbasic='mux start basic'


#[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.
# Bash completion
if [[ `uname` == 'Darwin' ]]; then
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
  fi
fi

c_cyan=`tput setf 6`
c_red=`tput setf 1`
c_green=`tput setf 2`
c_sgr0=`tput sgr0`

parse_git_branch ()
{
  if git rev-parse --git-dir >/dev/null 2>&1
  then
    gitver=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
  else
    return 0
  fi
  echo -e $gitver
}

branch_color ()
{
  if git rev-parse --git-dir >/dev/null 2>&1
  then
    color=""
    if git diff --quiet 2>/dev/null >&2
    then
      color="${c_green}"
    else
      color=${c_red}
    fi
  else
    return 0
  fi
  echo -ne $color
}

PS1='[\[$(branch_color)\]$(parse_git_branch)\[${c_sgr0}\]]\n\h:\u@\[${c_red}\]\w\[${c_sgr0}\]: '
cd .

#source ~/.git-completion.sh
export LANG='en_us.UTF-8'

export PROMPT_COMMAND='echo -ne "\033]0;${PWD##*/}\007"'

### TMUX settings
export TERM=screen-256color-bce

source ~/.bash_functions

