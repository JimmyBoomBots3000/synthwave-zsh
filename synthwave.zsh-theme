# Synthwave: sunset orange, hot pink, electric cyan, and ultraviolet nights.
# Enable with ZSH_THEME="synthwave" in ~/.zshrc, then restart your shell.
# Uses standard Unicode characters; no Powerline or Nerd Font required.
# Colors use the 256-color palette for broad terminal support.

setopt prompt_subst

# Let the theme place Python virtual environments inside the prompt frame.
export VIRTUAL_ENV_DISABLE_PROMPT=1

_synthwave_virtualenv() {
  [[ -n ${VIRTUAL_ENV-} ]] || return 0
  local name=${VIRTUAL_ENV:t}
  # Environment names are text, even when they contain prompt escapes.
  printf ' %%F{93}[%%F{141}venv: %s%%F{93}]%%f' "${name//\%/%%}"
}

# Request a whole-terminal midnight-purple background with OSC 11.
# Set SYNTHWAVE_BACKGROUND='#201030' before loading Oh My Zsh to customize,
# or set it to an empty string to keep the terminal profile's background.
# Requires terminal support for OSC 11; this color persists after shell exit.
if [[ -o interactive && -t 1 && ${TERM-} != dumb ]]; then
  if [[ ${SYNTHWAVE_BACKGROUND-'#160D26'} == \#[[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]] ]]; then
    printf '\033]11;%s\007' "${SYNTHWAVE_BACKGROUND-'#160D26'}"
  fi
fi

# Oh My Zsh handles branch names, detached HEADs, and dirty worktrees.
ZSH_THEME_GIT_PROMPT_PREFIX=' %F{93}─[ %F{199}'
ZSH_THEME_GIT_PROMPT_SUFFIX=' %F{93}]%f'
ZSH_THEME_GIT_PROMPT_DIRTY=' %F{214}●%f'
ZSH_THEME_GIT_PROMPT_CLEAN=' %F{87}○%f'

# Keep the host visible over SSH; local sessions show just the username.
typeset -g _synthwave_identity='%n'
if [[ -n ${SSH_CONNECTION-}${SSH_CLIENT-}${SSH_TTY-} ]]; then
  _synthwave_identity='%n%F{93}@%F{207}%m'
fi

# Two lines keep the command entry point fixed even in deep directories.
# Failed commands show their exit code; background jobs show only when present.
# Sunset stripes fade into the violet frame; cyan keeps the path readable.
PROMPT='%F{93}╭─%F{220}▰%F{214}▰%F{208}▰%F{202}▰%F{199}▰%F{129}▰ %F{207}${_synthwave_identity} %F{93}// %B%F{51}%3~%b%f$(_synthwave_virtualenv)$(git_prompt_info) %(1j.%F{141}[%j jobs]%f .)%(?..%F{203}[exit %?]%f)
%F{93}╰────%B%(?.%F{214}.%F{203})❯%F{208}❯%F{199}❯%b%f '

# Time commands between execution and the next prompt, excluding idle time.
zmodload zsh/datetime
autoload -Uz add-zsh-hook
typeset -g _synthwave_elapsed=''
unset _synthwave_started

_synthwave_preexec() {
  typeset -g _synthwave_started=$EPOCHREALTIME
}

_synthwave_precmd() {
  if [[ -n ${_synthwave_started-} ]]; then
    local -F 6 elapsed=$(( EPOCHREALTIME - _synthwave_started ))
    printf -v _synthwave_elapsed '%.2fs' "$elapsed"
    unset _synthwave_started
  fi
}

# add-zsh-hook avoids duplicate registrations when the theme is reloaded.
add-zsh-hook preexec _synthwave_preexec
add-zsh-hook precmd _synthwave_precmd

# Right prompt stays on the input line and disappears as you type into it.
RPROMPT='%F{93}[ %F{214}${_synthwave_elapsed:+${_synthwave_elapsed} / }%F{207}%D{%H:%M}%F{93} ]%f'
PROMPT2='%F{93}     %F{214}❯%F{208}❯%F{199}❯%f '
