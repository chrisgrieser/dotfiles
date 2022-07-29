bindkey "^P" copyLocation
bindkey "^B" copyBuffer
bindkey "^A" beginning-of-buffer-or-history
bindkey "^E" end-of-buffer-or-history

bindkey "^Z" undo
bindkey "^Y" redo
bindkey "^K" kill-line
bindkey "^U" vi-kill-line

# [alt+arrow] - move word forward or backward (like on Mac)
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

# zsh-autosuggest
bindkey '^X' autosuggest-execute # e[x]ecute
bindkey '^F' autosuggest-accept # [f]orward completion

#-------------------------------------------------------------------------------
# `bindkey -M main` to show existing keybinds
# there `^[` usually means escape
# some bindings with '^' are reserved (^M=enter, ^I=tab, ^[[Z = shift+tab)
#-------------------------------------------------------------------------------

copyLocation () {
	pwd | pbcopy
}
zle -N copyLocation

# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/copybuffer/copybuffer.plugin.zsh
copyBuffer () {
	printf "%s" "$BUFFER" | pbcopy
}
zle -N copyBuffer
