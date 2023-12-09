#!/bin/bash

clear -x
echo "SuperTux2 script started!"
echo "Downloading the files and installing needed dependencies..."
sleep 3
cd ~
cd ~/RetroPie/roms/ports
rm -r supertux2.sh
cd ~/.local/share/supertux2
mv profile1 -t ~/
cd
case "$__os_codename" in
bionic)
  sudo apt install -y gcc-8 g++-8 || error "Failed to install dependencies!"
;;
esac
sudo apt install git build-essential libfreetype* libsdl2-2.0-0 libsdl2-dev libsdl2-image-2.0-0 libsdl2-image-dev curl libcurl4 libcurl4-openssl-dev libvorbis-dev libogg-dev cmake extra-cmake-modules libopenal-dev libglew-dev libgles2-mesa-dev libboost-dev libboost-all-dev libglm-dev subversion libpng-dev libpng++-dev -y || error "Failed to install dependencies!"
git clone --recursive https://github.com/SuperTux/supertux
svn export https://github.com/$repository_username/L4T-Megascript/trunk/assets/ST2
cd
cd ~/supertux/data/images/engine/menu
rm logo_dev.png
mv logo.png logo_dev.png
cd ~/supertux
mkdir -p build && cd build
echo
echo "Compiling the game..."
sleep 1
echo
case "$__os_codename" in
bionic)
  cmake .. -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_C_COMPILER=gcc-8 -DCMAKE_CXX_COMPILER=g++-8
  ;;
*)
  cmake .. -DCMAKE_BUILD_TYPE=RELEASE
  ;;
esac
make -j$(nproc)
echo
echo "Game compiled!"
sleep 1
echo "Installing game...."
sudo make install || error "Make install failed"
echo "Erasing temporary build files to save space..."
sleep 2
echo
cd ~/.local/share && mkdir -p supertux2
cd ~/ST2
mv config -t ~/.local/share/supertux2
cd ~
sudo rm -r supertux
rm -r ST2
mv profile1 -t ~/.local/share/supertux2
echo
echo "Game installed!"
echo
echo
echo "[NOTE] Remember NOT to move the SuperTux2 folder or any file inside it or the game will stop working."
echo "If the game icon doesn't appear inmediately, restart the system."
echo "This message will close in 10 seconds."
sleep 10
echo
echo "Sending you back to the main menu..."
sleep 1
