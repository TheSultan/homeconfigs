if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export PATH="/usr/local/opt/mysql@5.5/bin:$PATH"
export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"
