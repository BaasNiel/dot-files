bplist00�_WebMainResource�	
_WebResourceMIMEType_WebResourceTextEncodingName^WebResourceURL_WebResourceFrameName_WebResourceDataZtext/plainUUTF-8_\https://raw.githubusercontent.com/A-Helberg/dot-files/master/themes/agnostercustom.zsh-themePOZ<html><head></head><body><pre style="word-wrap: break-word; white-space: pre-wrap;"># vim:ft=zsh ts=2 sw=2 sts=2
#
# agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for ZSH
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://github.com/Lokaltog/powerline-fonts).
#
# In addition, I recommend the
# [Solarized theme](https://github.com/altercation/solarized/) and, if you're
# using it on Mac OS X, [iTerm 2](http://www.iterm2.com/) over Terminal.app -
# it has significantly better color fidelity.
#
# # Goals
#
# The aim of this theme is to only show you *relevant* information. Like most
# prompts, it will only show git information when in a git working directory.
# However, it goes a step further: everything from the current user and
# hostname to whether the last call exited with an error to whether background
# jobs are running in this shell will all be displayed automatically when
# appropriate.

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

CURRENT_BG='NONE'
SEGMENT_SEPARATOR=''
SEGMENT_RSEPARATOR=''

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] &amp;&amp; bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] &amp;&amp; fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' &amp;&amp; $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] &amp;&amp; echo -n $3
}

# Begin a reverse segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_reverse_segment() {
  local bg fg
  [[ -n $1 ]] &amp;&amp; bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] &amp;&amp; fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' &amp;&amp; $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_RSEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] &amp;&amp; echo -n $3
}

# Dir: current working directory
prompt_dir() {
  prompt_segment 6 0 '%c'
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

# End the prompt, closing any open segments
prompt_reverse_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_RSEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
  local user=`whoami`

  if [[ -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)$user@%m"
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  local ref dirty mode repo_path
  repo_path=$(git rev-parse --git-dir 2&gt;/dev/null)

  if $(git rev-parse --is-inside-work-tree &gt;/dev/null 2&gt;&amp;1); then
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2&gt; /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2&gt; /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment yellow black
    else
      prompt_segment green black
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" &lt;B&gt;"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" &gt;M&lt;"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" &gt;R&gt;"
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:git:*' unstagedstr '●'
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats ' %u%c'
    vcs_info
    echo -n "${ref/refs\/heads\// }${vcs_info_msg_0_%% }${mode}"
  fi
}

prompt_hg() {
  local rev status
  if $(hg id &gt;/dev/null 2&gt;&amp;1); then
    if $(hg prompt &gt;/dev/null 2&gt;&amp;1); then
      if [[ $(hg prompt "{status|unknown}") = "?" ]]; then
        # if files are not added
        prompt_segment red white
        st='±'
      elif [[ -n $(hg prompt "{status|modified}") ]]; then
        # if any modification
        prompt_segment yellow black
        st='±'
      else
        # if working copy is clean
        prompt_segment green black
      fi
      echo -n $(hg prompt "☿ {rev}@{branch}") $st
    else
      st=""
      rev=$(hg id -n 2&gt;/dev/null | sed 's/[^-0-9]//g')
      branch=$(hg id -b 2&gt;/dev/null)
      if `hg st | grep -Eq "^\?"`; then
        prompt_segment red black
        st='±'
      elif `hg st | grep -Eq "^(M|A)"`; then
        prompt_segment yellow black
        st='±'
      else
        prompt_segment green black
      fi
      echo -n "☿ $rev@$branch" $st
    fi
  fi
}


# Virtualenv: current working virtualenv
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path ]]; then
    prompt_reverse_segment blue black "`basename $virtualenv_path`"
  fi
}

function _ruby_version() {
  if {echo $fpath | grep -q "plugins/rvm"}; then
    echo "%{$fg[grey]%}$(rvm_prompt_info)%{$reset_color%}"
  fi
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] &amp;&amp; symbols+="%{%F{red}%}✘"
  [[ $UID -eq 0 ]] &amp;&amp; symbols+="%{%F{yellow}%}⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] &amp;&amp; symbols+="%{%F{cyan}%}⚙"

  [[ -n "$symbols" ]] &amp;&amp; prompt_segment black default "$symbols"
}

## Main prompt
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_context
  prompt_dir
  prompt_git
  prompt_hg
  prompt_end
}

build_rprompt() {
 RETVAL=$?
 prompt_virtualenv
}

PROMPT='%{%f%b%k%}$(build_prompt) '
RPROMPT='$(build_rprompt) '
</pre></body></html>    ( > \ k � � � �                           c