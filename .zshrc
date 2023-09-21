clear
autoload -Uz vcs_info
preexec() {
  timer=${timer:-$SECONDS}
}

precmd() {
  vcs_info
  if [ $timer ]; then
    timer_show=$(($SECONDS - $timer))
    export RPROMPT='%F{83}${vcs_info_msg_0_}%f %F{87}%*%f %F{208}${timer_show}s%f '
    unset timer
  fi
}
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
export PROMPT='%B%F{9}[%n%b%f%F{207}@%m] %1~ :3%f '
export RPROMPT='%F{83}${vcs_info_msg_0_}%f %F{87}%*%f %F{9}%f'

# My T7-specific features
if [ -f /Volumes/Dingus/.zsh-marker ]; then
    echo '\e[3m/Volumes/Dingus is \e[32maccessible\e[0m\e[3m to this shell.\e[0m'
else
    echo '\e[3m/Volumes/Dingus is \e[31mnot accessible\e[0m\e[3m to this shell.\e[0m'
fi

# PATH variable
if [ -f /Volumes/Dingus/.zsh-marker ]; then
    export PATH=/Volumes/Dingus/usr/bin:/opt/homebrew/opt/llvm/bin:/opt/homebrew/opt/libusbmuxd/bin:/opt/homebrew/opt/idevicerestore/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:$HOME/.local/bin:$PATH
else
    export PATH=/opt/homebrew/opt/llvm/bin:/opt/homebrew/opt/libusbmuxd/bin:/opt/homebrew/opt/idevicerestore/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:$HOME/.local/bin:$PATH
fi

# Exports
export GPG_TTY=$(tty)
export EDITOR="nano"
export VISUAL="nano"
export MTL_HUD_ENABLED=1

# Brew shit
# TODO: Autorun based on active arch
alias armbrew='eval "$(/opt/homebrew/bin/brew shellenv)"' 
alias x86brew='eval "$(/usr/local/bin/brew shellenv)"'
if [ "$(arch)" = "arm64" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
    echo "\e[3m$(uname -m) shell session detected, will use $(uname -m) Homebrew!"
fi

# Game Porting Toolkit
if [ -f /Volumes/Dingus/.zsh-marker ]; then
    alias gptk='MTL_HUD_ENABLED=1 WINEESYNC=1 WINEPREFIX=/Volumes/Dingus/GayPortingToolshit2 `/usr/local/bin/brew --prefix game-porting-toolkit`/bin/wine64'
    alias gptk-no-esync='MTL_HUD_ENABLED=1 WINEPREFIX=/Volumes/Dingus/GayPortingToolshit2 `/usr/local/bin/brew --prefix game-porting-toolkit`/bin/wine64'
    alias gptk-no-hud='WINEESYNC=1 WINEPREFIX=/Volumes/Dingus/GayPortingToolshit2 `/usr/local/bin/brew --prefix game-porting-toolkit`/bin/wine64'
    alias gptk-no-nothing='WINEPREFIX=/Volumes/Dingus/GayPortingToolshit2 `/usr/local/bin/brew --prefix game-porting-toolkit`/bin/wine64'
fi

# Misc
alias ln='ln -sv'
alias ls='ls -AGhlO'
alias cp="cp -iv"
alias rm="rm -iv"
alias mv="mv -iv"
alias shitel='arch -x86_64'
alias asi='arch -arm64'
alias please=sudo
alias ~='cd ~'
alias ..='cd ..'
alias java_home=/usr/libexec/java_home
alias unfruity='sudo sysctl net.inet.ip.ttl=64'
alias killallwine='killall -9 wineserver && killall -9 wine64-preloader'
alias iwantnvm='export NVM_DIR="$HOME/.nvm" && [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh" && [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"'

fruity () {
   num=${1:-5}
   sudo sysctl net.inet.ip.ttl=$num
}

createinstallmedia () {
   version=${1}
   mount=${2}
   sudo "/Volumes/Dingus/macOS Installers/Install macOS $version.app/Contents/Resources/createinstallmedia" --volume $mount
}

# Shorthands
alias build-pojav='gmake -j10 package SIGNING_TEAMID=H9UFLHHUZ5 TEAMID=FBT742498U PROVISIONING=/Users/evaluna/Library/MobileDevice/Provisioning\ Profiles/WildcardProvisioning.mobileprovision'
alias fix-low-data-mode='while true; do if [ $(pgrep -n nsurlsessiond) ]; then please killall nsurlsessiond; fi; done'
alias palera1n='/usr/local/bin/palera1n -k /Users/evaluna/Pongo.bin -K /Users/evaluna/checkra1n-kpf-pongo -v -V'
alias remotexpc='sudo python3 -m pymobiledevice3 remote start-quic-tunnel'
alias remotexpc-launch='pymobiledevice3 developer dvt launch'

# Homebrew Update Module
if [[ ! -e ~/.zshrcbrewupdated ]]; then
    echo "This zshrc uses a file named .zshrcbrewupdated to determine when to update\nHomebrew packages."
    echo "This file doesn't exist yet so it will be created now, and a complete Homebrew\nupdate + upgrade will be run as well."
    date +%d > ~/.zshrcbrewupdated
    echo
    brew update
    brew upgrade
else
    todaysdate=$(date +%d)
    brewlastupdateday=$(cat ~/.zshrcbrewupdated)
    # is the last update day the same as today
    if [[ $brewlastupdateday = $todaysdate ]]; then
        # if yes then skip
        # echo "Already updated Homebrew packages today, skipping."
    else
        # if not then update and update the date
        echo "Running Homebrew update..."
        echo "(You may now open another shell if you want to get to work immediately)"
        date +%d > ~/.zshrcbrewupdated
        brew update
    fi
fi

# Third-party zsh shit
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

