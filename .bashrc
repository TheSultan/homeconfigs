EC2_HOME=/usr/local
#EC2_JVM_ARGS="-Dhttp.proxyHost=web-proxy -Dhttp.proxyPort=8088
#-Dhttps.proxyHost=web-proxy -Dhttps.proxyPort=8088"
#EC2_PRIVATE_KEY=/home/slo/.ec2/rabsdatadrone.pem
#EC2_CERT=~/.ec2/certificate.pem
#set -l path = ( $path $EC2_HOME/bin )

PATH=$PATH:/System/Library/Frameworks/JavaVM.framework/Versions/Current
PATH=$PATH:/usr/local/android-sdk-macosx/tools:/usr/local/apache-maven-3.0.x/bin
PATH=$PATH:/usr/local/bin/scala-2.9.2/bin
PATH=$PATH:$EC2_HOME/bin

export JAVA_HOME=`/usr/libexec/java_home -v 1.8`

pushd()
{
  if [ $# -eq 0 ]; then
    DIR="${HOME}"
  else
    DIR="$1"
  fi

  builtin pushd "${DIR}" > /dev/null
  echo -n "DIRSTACK: "
  dirs
}

pushd_builtin()
{
  builtin pushd > /dev/null
  echo -n "DIRSTACK: "
  dirs
}

popd()
{
  builtin popd > /dev/null
  echo -n "DIRSTACK: "
  dirs
}

alias cd='pushd'
alias back='popd'
alias flip='pushd_builtin'
alias ls='ls -Gph'
alias ll='ls -GphFl'

# add android tools
export ANDROID_HOME=/usr/local/android-sdk-macosx/
PATH=${PATH}:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools
#alias adb='/usr/local/android-sdk-macosx/platform-tools/adb'
#alias fastboot='/usr/local/android-sdk-macosx/platform-tools/fastboot'

alias flushdns="sudo killall -HUP mDNSResponder"

# Homebrew happiness: Ensure /usr/local/bin preceds /usr/bin
PATH=/usr/local/bin:/usr/local/sbin:~/bin:$PATH

### Added by the Heroku Toolbelt
PATH="/usr/local/heroku/bin:$PATH"


export EDITOR=/usr/bin/vim
export EC2_HOME
export SCALA_HOME=/usr/local/Cellar/scala/2.10.3/libexec
export ANT_HOME=/usr/share/ant

export PATH

export PS1="\u@\h \t> "

# Keeps the Terminal title as user@host on every prompt, with whatever
# `title` set (TITLE_OVERRIDE) appended. `title` with no args clears it.
_auto_title()
{
  if [ -n "$TITLE_OVERRIDE" ]; then
    printf '\033]0;%s@%s: %s\007' "$USER" "$HOSTNAME" "$TITLE_OVERRIDE"
  else
    printf '\033]0;%s@%s\007' "$USER" "$HOSTNAME"
  fi
}
case ";$PROMPT_COMMAND;" in
  *";_auto_title;"*) ;;
  *) export PROMPT_COMMAND="_auto_title;$PROMPT_COMMAND" ;;
esac

title()
{
  if [ $# -gt 1 ]; then
    echo "Usage: title [\"custom title\"]  (no argument clears it)"
    return 1
  fi
  TITLE_OVERRIDE="$1"
  _auto_title
}
#TODO: Fix root prompt setting, not working
#export SUDO_PS1="\[\e[33;1;41m\][\u] \w \$\[\e[0m\] "

alias watch="~/bin/watch.sh"

alias gateway="netstat -nr | grep '^default'"
alias fixcamera="sudo killall VDCAssistant;sudo killall AppleCameraAssistant" 
alias fixaudio="sudo killall coreaudiod"
alias tunnelproddbread="ssh -f prodwww -L 3309:navyaproddb-read.c251koyvnaar.ap-southeast-1.rds.amazonaws.com:3306 -N"
alias tunnelpreproddbread="ssh -f preprod -L 3310:pre-production.c251koyvnaar.ap-southeast-1.rds.amazonaws.com:3306 -N"
alias dockerstopall="docker stop \$(docker ps -a -q)"
alias dockerrmall="docker rm \$(docker ps -a -q)"
alias dockerstats="docker stats \$(docker ps | awk '{if(NR>1) print \$NF}')"

#Python virtual env
source ~/bin/python/dev2/bin/activate

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm use 9.3.0
export AWS_PROFILE=misentropic
alias gs="git status"
export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"

# Disable bracketed paste in interactive shells
if [[ $- == *i* ]]; then
  printf '\e[?2004l'
fi
export PATH="$HOME/.local/bin:$PATH"

alias obsidian='open -a Obsidian'

export PATH="/usr/local/Caskroom/android-platform-tools/37.0.1/platform-tools:$PATH"

ssh() {
    command ssh "$@"
		# Turn off tmux mouse mode in case it was left on
    printf '\033[?1000l\033[?1002l\033[?1003l\033[?1006l'
}
