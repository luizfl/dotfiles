setopt autocd autolist cdablevars extendedglob nobeep noclobber print_eight_bit\
  autoresume dotglob longlistjobs pushdsilent rcquotes recexact
unsetopt autoparamslash bgnice correctall

ZDOTDIR="$HOME/.zsh"

#{{{ Exports
PATHS=(
  $HOME/bin
  /bin
  /sbin
  /usr/bin
  /usr/bin/core_perl
  /usr/bin/site_perl
  /usr/bin/vendor_perl
  /usr/local/bin
)
export PATH=${(j_:_)PATHS}

export SHELL="/bin/zsh"
export EDITOR="/usr/bin/nvim"
export SUDO_EDITOR="$EDITOR"
export PAGER="/bin/less"
export BROWSER="/usr/bin/chromium"

[[ $XDG_CACHE_HOME ]] || export XDG_CACHE_HOME="$HOME/.cache"
[[ $XDG_CONFIG_HOME ]] || export XDG_CONFIG_HOME="$HOME/.config"
[[ $XDG_DATA_HOME ]] || export XDG_DATA_HOME="$HOME/.local/share"

export _JAVA_OPTIONS='-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dawt.useSystemAAFontSettings=true'
export JAVA_FONTS=/usr/share/fonts/TTF

# man colors
export LESS_TERMCAP_mb=$'\E[0;103m' # begin blinking
export LESS_TERMCAP_md=$'\E[0;93m' # begin bold
export LESS_TERMCAP_me=$'\E[0m' # end mode
export LESS_TERMCAP_se=$'\E[0m' # end standout-mode
export LESS_TERMCAP_so=$(tput bold; tput setaf 15; tput setab 0) # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m' # end underline
export LESS_TERMCAP_us=$'\E[04;32m' # begin underline
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)
#}}}

#{{{ History
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE="$ZDOTDIR/history"

setopt inc_append_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt promptsubst
#}}}

#{{{ Aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias ls='ls --color=auto --group-directories-first'
alias la='ls --color=auto --group-directories-first -a'
alias ll='ls --color=auto --group-directories-first -lh'
alias lal='ls --color=auto --group-directories-first -lah'

alias grep='grep --color=auto'
alias pg='pgrep -l'
alias df='df -h'
alias du='du -sh'
alias free='free -m'
alias cp='cp -rv'
alias rm='rm -rv'
alias mv='mv -v'
alias mkdir='mkdir -pv'

alias S='sudo pacman -S'
alias Ss='pacsearch'
alias Syu='sudo pacman -Syu'
alias R='sudo pacman -R'
alias Rs='sudo pacman -Rs'
alias Rsn='sudo pacman -Rsn `pacman -Qdtq`'
alias Scc='sudo pacman -Scc'
alias pS='packer -S'
alias pSs='packer -Ss'
alias pSyu='packer -Syu'
alias aur='pacman -Qm'

alias vim='nvim' # always forget about this one, must be muscle memory
alias pong='ping -c 3 www.google.com'
#}}}

#{{{ Functions
function cd()
{
  builtin cd "$@"; ls
}

function mkcd()
{
  mkdir -p "$@"; cd "$_"
}

function chars()
{
  echo "
  A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
  a b c d e f g h i j k l m n o p q r s t u v w x y z
                  0 1 2 3 4 5 6 7 8 9
            | + * ! . , ; : ' \" ^ ~ ? & = \`
            \ - ( ) [ ] { } @ # $ % _ < > ´
  "
}

function psgrep()
{
  ps axuf | grep -v grep | grep "$@" -i
}

function conf()
{
  case "$1" in
    bspwm)
      nvim "$HOME/.config/bspwm/bspwmrc"
      ;;
    sxhkd)
      nvim "$HOME/.config/bspwm/sxhkdrc"
      ;;
    vim|nvim)
      nvim "$HOME/.config/nvim/init.vim"
      ;;
    compton)
      nvim "$HOME/.config/compton.conf"
      ;;
    tmux)
      nvim "$HOME/.tmux.conf"
      ;;
    xinit)
      nvim "$HOME/.xinitrc"
      ;;
    xre)
      nvim "$HOME/.Xresources"
      ;;
    gtk2)
      nvim "$HOME/.gtkrc-2.0"
      ;;
    gtk3)
      nvim "$HOME/.config/gtk-3.0/settings.ini"
      ;;
    termite)
      nvim "$HOME/.config/termite/config"
      ;;
    ncmpcpp)
      nvim "$HOME/.config/ncmpcpp/config"
      ;;
    mpd)
      nvim "$HOME/.config/mpd/mpd.conf"
      ;;
    mpv)
      nvim "$HOME/.config/mpv/mpv.conf"
      ;;
    ranger)
      case "$2" in
        rc)
          nvim "$HOME/.config/ranger/rc.conf"
          ;;
        rifle)
          nvim "$HOME/.config/ranger/rifle.conf"
          ;;
        scope)
          nvim "$HOME/.config/ranger/scope.sh"
          ;;
        *)
          return 1
          ;;
      esac
      ;;
    pacman)
      sudoedit "/etc/pacman.conf"
      ;;
    fstab)
      sudoedit "/etc/fstab"
      ;;
    zsh)
      nvim "$HOME/.zshrc"
      ;;
    *)
      return 1
      ;;
  esac
}

function xfont()
{
  xrdb -query | grep font | head -1 | cut -f 2
}

function ext()
{
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)
        tar xvjf "$1"
        ;;
      *.tar.gz)
        tar xvzf "$1"
        ;;
      *.tar.xz)
        tar xvJf "$1"
        ;;
      *.bz2)
        bunzip2 "$1"
        ;;
      *.rar)
        unrar x "$1"
        ;;
      *.gz)
        gunzip "$1"
        ;;
      *.tar)
        tar xvf "$1"
        ;;
      *.tbz2)
        tar xvjf "$1"
        ;;
      *.tgz)
        tar xvzf "$1";;
      *.zip)
        unzip "$1"
        ;;
      *.Z)
        uncompress "$1"
        ;;
      *.7z)
        7z x "$1"
        ;;
      *.xz)
        unxz "$1"
        ;;
      *.exe)
        cabextract "$1"
        ;;
      *)
        echo "\`"$1"': unrecognized file compression"
        ;;
    esac
  else
    echo "\`"$1"' is not a valid file"
  fi
}

function open()
{
  xdg-open "$1" &> /dev/null &disown
}
#}}}

#{{{ Completion
autoload -Uz compinit && compinit

zstyle ":completion::complete:*"          use-cache 1
zstyle ':completion:*:functions'          ignored-patterns '_*'
zstyle ':completion:*'                    matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*'                    completer _complete _correct _approximate
zstyle ':completion:*'                    expand prefix suffix
zstyle ':completion:*'                    completer _expand_alias _complete _approximate
zstyle ':completion:*'                    menu select
zstyle ':completion:*'                    file-sort name
zstyle ':completion:*'                    list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*:processes'          command 'ps -axw --forest'
zstyle ':completion:*:processes-names'    command 'ps -awxho command'

# cd
zstyle ':completion:*'                    squeeze-slashes true
zstyle ':completion:*:cd:*'               ignore-parents parent pwd
zstyle ':completion:*:*:(cd):*:*files'    ignored-patterns '*~' file-sort access
zstyle ':completion:*:*:(cd):*'           file-sort access
zstyle ':completion:*:*:(cd):*'           menu select
zstyle ':completion:*:*:(cd):*'           completer _history

# kill menu
zstyle ':completion:*:*:kill:*'           menu yes select
zstyle ':completion:*:kill:*'             force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=36=31"
#}}}

#{{{ Keybindings
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init () {
    printf '%s' "${terminfo[smkx]}"
  }
  function zle-line-finish () {
    printf '%s' "${terminfo[rmkx]}"
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi
#}}}

#{{{ Prompt
function precmd()
{
  MIN=1
  MAX=6
  RANDOM_COLOR="$(( ${MIN}+(`od -An -N2 -i /dev/random` )%(${MAX}-${MIN}+1) ))"
  PROMPT="%F{$RANDOM_COLOR}────%f "

  #DIR=`pwd|sed -e "s|$HOME|~|"`;
  #if [ ${#DIR} -gt 30 ]; then
  #  CWD="${DIR:0:12}...${DIR:${#DIR}-15}"
  #else
  #  CWD="$DIR"
  #fi
  #RPROMPT="%F{8}$CWD"

  print -Pn "\e]0;%n@%M:%~\a" ]
}

#}}}

#{{{ Misc
# dircolors
eval $( dircolors -b $HOME/.dir_colors )

# command not found
source "/usr/share/doc/pkgfile/command-not-found.zsh"
#}}}

#{{{ zsh-syntax-highlighting
source "$ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[command]="fg=blue,bold"
ZSH_HIGHLIGHT_STYLES[hashed-command]="fg=blue,bold"
ZSH_HIGHLIGHT_STYLES[builtin]="fg=yellow,bold"

ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=black,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('sudo' 'fg=black,bg=red')
#}}}

#{{{ zsh-history-substring-search
source "$ZDOTDIR/zsh-history-substring-search/zsh-history-substring-search.zsh"

# bind UP and DOWN arrow keys
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# bind P and N for EMACS mode
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
#}}}
