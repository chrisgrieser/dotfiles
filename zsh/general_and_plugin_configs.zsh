# shellcheck disable=SC2190

#-------------------------------------------------------------
# zsh syntax highlighting
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern regexp root)
typeset -A ZSH_HIGHLIGHT_PATTERNS # https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/pattern.md
ZSH_HIGHLIGHT_PATTERNS+=('rm -r?f' 'fg=white,bold,bg=red') # `rm -f` in red
ZSH_HIGHLIGHT_PATTERNS+=('rm -f' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('git reset' 'fg=white,bold,bg=red') # `git reset` in red

# shellcheck disable=SC2034,SC2154
ZSH_HIGHLIGHT_STYLES[root]='bg=red' # highlight red when currently root

# # https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/regexp.md
typeset -A ZSH_HIGHLIGHT_REGEXP
ZSH_HIGHLIGHT_REGEXP+=('^(git commit -m|acp|amend) .{50,}' 'fg=white,bold,bg=red') # commit msgs too long
ZSH_HIGHLIGHT_REGEXP+=('(git reset|rm -r?f) .*' 'fg=white,bold,bg=red') # dangerous stuff

#-------------------------------------------------------------

export BAT_THEME='Sublime Snazzy'

export ZSH_AUTOSUGGEST_HISTORY_IGNORE="?(#c50,)" # ignores long history items
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

export FZF_DEFAULT_COMMAND='fd --hidden'
export FZF_DEFAULT_OPTS='-0 --pointer=⟐ --prompt="❱ "'

export MAGIC_ENTER_GIT_COMMAND="git status"
export MAGIC_ENTER_OTHER_COMMAND="exa"

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

# OPTIONS --- (`man zshoptions` to see all options)
setopt AUTO_CD # pure directory = cd into it
setopt INTERACTIVE_COMMENTS # comments in interactive mode (useful für copypasting)

export EDITOR='subl --new-window --wait'
#-------------------------------------------------------------------------------
# COMPLETIONS
# case insensitive path-completion, see https://scriptingosx.com/2019/07/moving-to-zsh-part-5-completions/
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 

# highlight selected completion item
zstyle ':completion:*' menu select

# Use vim keys in tab complete menu
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
# bindkey -M menuselect ' ' accept-line

six-down () {
   zle vi-down-line-or-history
   zle vi-down-line-or-history
   zle vi-down-line-or-history
   zle vi-down-line-or-history
   zle vi-down-line-or-history
   zle vi-down-line-or-history
}
zle -N six-down
