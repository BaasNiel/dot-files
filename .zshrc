# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$HOME/.composer/vendor/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/nielsarvari/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnostercustom"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias dphp="docker-compose exec php php"
alias art="php artisan"
alias gcob="git checkout -b"
alias gfo="git fetch origin"
alias test="php artisan test"
alias testf="php artisan test --filter"
alias tinker="php artisan tinker"
alias php7="docker exec -it app php"
alias sail='[ -f sail ] && bash sail || bash vendor/bin/sail'
alias php71="brew unlink php@7.1 && brew unlink php && brew link --overwrite --force shivammathur/php/php@7.1"
alias php81="brew unlink php && brew link --overwrite --force php"
# alias unlink71="brew unlink shivammathur/php/php@7.1"
alias mad="cd ~/Documents/projects/gigadat/mad"
alias hyperlink="cd ~/Documents/projects/gigadat/hyperlink-dashboard"

function git-branch-current {
  echo $(git rev-parse --abbrev-ref HEAD)
}

# Default git push to current branch
function gpoc {
  echo Pushing "$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
  git push origin "$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
}

# Default git pull from current branch
function gploc {
  echo Pulling "$(git-branch-current 2> /dev/null)"
  git pull origin "$(git-branch-current 2> /dev/null)"
}

# Open a MR to ComplyWorks repo
function glmr {
  echo Opening GitLab pull request for "$(git-branch-current 2> /dev/null)"
  repo=`git remote -v | ag "origin.+push" | sed "s/origin//" | cut -c2-999 | sed "s/\.git\/ (push)//"`
  echo REPO: $repo
  branch="$(git-branch-current 2> /dev/null)"
  echo BRANCH: $branch
  open "$repo/-/merge_requests/new/diffs?merge_request[source_branch]=$branch&view=parallel"
}

listening() {
    if [ $# -eq 0 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P
    elif [ $# -eq 1 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
    else
        echo "Usage: listening [pattern]"
    fi
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
eval "$(rbenv init - zsh)"
#export PATH="/usr/local/opt/php@7.4/bin:$PATH"
#export PATH="/usr/local/opt/php@7.4/sbin:$PATH"

eval $(thefuck --alias)
