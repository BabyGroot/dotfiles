fpath=(~/zsh-completions/src $fpath)

# Load Zsh tools for syntax highlighting and autosuggestions
source /Users/martinleepan/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

plugins=( 
    # other plugins...
    zsh-autosuggestions
)

[[ -f ~/.zsh/aliases.zsh ]] && source ~/.zsh/aliases.zsh
[[ -f ~/.zsh/functions.zsh ]] && source ~/.zsh/functions.zsh
[[ -f ~/.zsh/starship.zsh ]] && source ~/.zsh/starship.zsh


eval $(/opt/homebrew/bin/brew shellenv)

export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
export PATH="/opt/homebrew/opt/openssl@1.1/bin:$PATH";
export LDFLAGS="-L/opt/homebrew/opt/openssl@1.1/lib":
export CPPFLAGS="-I/opt/homebrew/opt/openssl@1.1/include"
export PATH="/Users/leandromaciel/.asdf/shims:$PATH";
export PATH="/opt/homebrew/opt/openssl@1.0/bin:$PATH"

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"


### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
# export PATH="/Users/martinleepan/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
