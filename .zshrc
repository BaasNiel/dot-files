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
export PATH="/home/baasniel/.config/composer/vendor/bin:$PATH"

# Default git push to current branch
function gpoc {
  echo Pushing "$(git-branch-current 2> /dev/null)"
  git push origin "$(git-branch-current 2> /dev/null)"
}

# Default git pull from current branch
function gploc {
  echo Pulling "$(git-branch-current 2> /dev/null)"
  git pull origin "$(git-branch-current 2> /dev/null)"
}

# Open a MR to repo
function glmr {
  echo Opening GitLab pull request for "$(git-branch-current 2> /dev/null)"
  repo=`git remote -v | ag "origin.+push" | sed "s/git@gitlab.com://" | sed "s,https://gitlab.com/,," | cut -c8-999 | s$
  echo REPO: $repo
  branch="$(git-branch-current 2> /dev/null)"
  echo BRANCH: $branch

  xdg-open "$repo/merge_requests/new/diffs?merge_request[source_branch]=$branch&merge_request[target_project_id]=37&mer$
}

alias gst="git status"
alias gcob="git checkout -b "
alias gco="git checkout "
alias vpnstart="sudo service openvpn start"
alias vpnstop="sudo service openvpn stop"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
