#!/bin/bash
#Fun fact, the original version of this script had an aprox 50 more lines of code

cd
clear -x
status "SRB2 script started!"
status "Downloading the files, removing old files and installing needed dependencies..."
sleep 2
sudo rm -r /usr/share/SRB2
cd ~/.srb2
rm config.cfg
cd /usr/share/applications
sudo rm "Sonic Robo Blast 2.desktop"
cd ~/RetroPie/roms/ports
rm SRB2_retropie.sh
cd

case "$__os_id" in
Raspbian | Debian | LinuxMint | Linuxmint | Ubuntu | [Nn]eon | Pop | Zorin | [eE]lementary | [jJ]ing[Oo][sS])
  sudo apt install gcc g++ wget libsdl2-dev libsdl2-mixer-dev cmake extra-cmake-modules subversion libupnp-dev libgme-dev libopenmpt-dev curl libcurl4-gnutls-dev libpng-dev freepats libgles2-mesa-dev -y || error "Dependency installs failed"
  ;;
Fedora)
  sudo dnf install -y wget cmake unzip git SDL2-devel SDL2_mixer-devel libcurl-devel libopenmpt-devel game-music-emu-devel libpng-devel zlib-devel || error "Dependency installs failed"
  ;;
*)
  echo -e "\\e[91mUnknown distro detected - this script should work, but please press Ctrl+C now and install necessary dependencies yourself following https://wiki.dolphin-emu.org/index.php?title=Building_Dolphin_on_Linux if you haven't already...\\e[39m"
  sleep 5
  ;;
esac

rm -rf master.zip SRB2 SRB2-master SRB2-Data.zip
wget https://github.com/STJr/SRB2/archive/master.zip --progress=bar:force:noscroll
wget $(curl --silent "https://api.github.com/repos/STJr/SRB2/releases/latest" | grep "SRB2" | grep "Full" | cut -c 31- | cut -d '"' -f 2) -O SRB2-Data.zip
mkdir -p ~/SRB2-A
cd ~/SRB2-A
wget https://github.com/cobalt2727/L4T-Megascript/raw/master/assets/SRB2-A/SRB2.sh
wget https://github.com/cobalt2727/L4T-Megascript/raw/master/assets/SRB2-A/SRB2Icon.png
wget https://github.com/cobalt2727/L4T-Megascript/raw/master/assets/SRB2-A/Sonic%20Robo%20Blast%202.desktop
wget https://github.com/cobalt2727/L4T-Megascript/raw/master/assets/SRB2-A/config.cfg
cd
mkdir -p SRB2
cd
unzip master.zip
mkdir -p SRB2-DT
mv SRB2-Data.zip -t ~/SRB2-DT
cd ~/SRB2-DT
unzip SRB2-Data.zip
rm SRB2-Data.zip*
cd ~/SRB2-master/assets
mkdir -p installer
cd ..
mkdir -p build
cd ~
mkdir -p .srb2
cd ~/SRB2-A
chmod 777 SRB2.sh
mv config.cfg -t ~/.srb2
mv SRB2.sh SRB2Icon.png -t ~/SRB2
sudo mv "Sonic Robo Blast 2.desktop" -t /usr/share/applications
cd ~
rm master.zip*
rm -rf SRB2-A
cd ~/SRB2-DT
mv music.dta patch.pk3 patch_music.pk3 player.dta srb2.pk3 zones.pk3 -t ~/SRB2-master/assets/installer
cd ~/SRB2-master/build
status "Compiling the game..."
cmake ..
make -j$(nproc) || error "Compilation failed"
status_green "Game compiled!"
status "Erasing temporary build files to save space..."
cd ~/SRB2-master
mv assets build -t ~/SRB2
cd ~
rm -rf SRB2-DT
rm -rf SRB2-master
sudo mv SRB2 -t /usr/share
status_green "Game installed!"
warning "[NOTE] Remember NOT to move the SRB2 folder or any file inside it or the game will stop working."
warning "If the game icon doesn't appear inmediately, restart the system."
status "This message will close in 10 seconds."
sleep 10
echo
status "Sending you back to the main menu..."
