#!/bin/bash

sudo pacman -S yay --noconfirm --needed
sudo pacman -S jq --noconfirm --needed

# install all gnome shell extensions
extensions=(
pano@elhan.io 
lockkeys@vaina.lt 
netspeedsimplified@prateekmedia.extension 
just-perfection-desktop@just-perfection 
Vitals@CoreCoding.com 
ddterm@amezin.github.com 
drive-menu@gnome-shell-extensions.gcampax.github.com 
caffeine@patapon.info 
autohide-battery@sitnik.ru
arcmenu@arcmenu.com
legacyschemeautoswitcher@joshimukul29.gmail.com
user-theme@gnome-shell-extensions.gcampax.github.com
x11gestures@joseexposito.github.io
color-picker@tuberry.arc)
GN_CMD_OUTPUT=$(gnome-shell --version)
GN_SHELL=${GN_CMD_OUTPUT:12:2}
for i in "${extensions[@]}"
do
    VERSION_LIST_TAG=$(curl -Lfs "https://extensions.gnome.org/extension-query/?search=${i}" | jq '.extensions[] | select(.uuid=="'"${i}"'")') 
    VERSION_TAG="$(echo "$VERSION_LIST_TAG" | jq '.shell_version_map |."'"${GN_SHELL}"'" | ."pk"')"
    wget -q -O "${i}".zip "https://extensions.gnome.org/download-extension/${i}.shell-extension.zip?version_tag=$VERSION_TAG"
    gnome-extensions install --force "${i}".zip
    rm ${i}.zip
done

# configure dash-to-panel
dconf load /org/gnome/shell/extensions/dash-to-panel/ < .dash-to-panel
#configure arc-menu
dconf load /org/gnome/shell/extensions/ArcMenu/ < .arc-menu

# install packages
yay -S visual-studio-code-bin --needed --noconfirm
yay -S google-chrome --needed --noconfirm
yay -S anki --needed --noconfirm
yay -S obsidian --needed --noconfirm
yay -S dolphin --needed --noconfirm
yay -S gradience-git --needed --noconfirm

# setup gradience
gradience-cli flatpak-overrides -e both
gradience-cli download -n "Catppuccin Mocha"
gradience-cli apply -n "Catppuccin Mocha" --gtk both

# install my version of the Marble Shell Theme
cd ~/
mkdir src
cd src
mkdir theme
cd themes
git clone https://github.com/Papweer/Marble-shell-theme.git
cd Marble-shell-theme
python install.py --filled --blue --mode=dark

# install Marble Shell Theme for gdm
sudo python install.py -gdm --filled --blue --mode=dark
sudo systemctl restart gdm