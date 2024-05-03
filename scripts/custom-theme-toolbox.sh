#!/bin/bash

clear -x
echo "Custom Theme Toolbox script started!"
echo 'This will allow you to actually USE that fancy "Install"'
echo "button on the Pling website and any of its derivatives."
echo "In addition, I've included an installer for a QT settings tool"
echo "To automatically make QT apps follow the system theme."
sleep 3

grep -v 'export QT_QPA_PLATFORMTHEME="gtk2"' ~/.profile >/tmp/.profile && mv /tmp/.profile ~/.profile #nuke the old bad config if it's found

echo "Installing tools for management of QT settings and to build the theme installer..."
# check out /etc/X11/Xsession.d/99qt5ct after installing QT5CT for info on how environment variables are set up - the environment variable doesn't apply on Plasma, maybe disable it manually on LXQT?
case "$__os_id" in
Raspbian | Debian | Ubuntu)
  if [[ $(echo $XDG_CURRENT_DESKTOP) = 'Unity:Unity7:ubuntu' ]]; then
    sudo apt install unity-tweak-tool indicator-bluetooth indicator-sound hud -y
  elif echo $XDG_CURRENT_DESKTOP | grep -q 'GNOME'; then #multiple gnome variants exist out there, hence the different syntax - this'll also work on DEs like Budgie
    sudo apt install gnome-tweaks -y
    #elif echo $XDG_CURRENT_DESKTOP | grep -q 'whatever it is for the Mate desktop'; then
    #        sudo apt install mate-control-center -y
  else
    echo "Not using a DE with a known theme manager, skipping theme manager install..." #plasma comes with this built in, but need to add lxappearance for corresponding DEs
    # maybe check if Unity is installed here as a fallback - CLI installs won't detect ANY desktop using the above methods
  fi

  sudo apt install -y build-essential qt5ct git qt5-qmake make qml-module-qtquick-controls qtdeclarative5-dev libqt5svg5-dev libcanberra-gtk-module xdg-desktop-portal xdg-utils python3-dbus

  sudo apt install -y
  if package_available qt5-default ; then
    sudo apt install -y qt5-default || error "Failed to install dependencies"
  fi

  if package_available qt6ct ; then
    echo "Installing QT6CT for management of QT6 settings..."
    sudo apt install -y qt6ct qt6-xdgdesktopportal-platformtheme || error "Failed to install QT6 settings!"
  else
    echo "Compiling QT6CT for management of QT6 settings..."
    # use Owen Kirby's QT6 PPA when testing this
    #add if statement for supported versions on next line?
    case "$__os_codename" in
    bionic | focal | impish)
      ubuntu_ppa_installer "okirby/qt6-backports" || error "PPA failed to install"
      ;;
    esac

    sudo apt install -y qt6-base-dev libqt6svg6-dev qt6-tools-dev libgtk2.0-dev qt6-base-private-dev qt6-l10n-tools || error "Failed to install dependencies!" #this is definitely missing dependencies, add more

    #theme selection tool for QT6
    cd /tmp
    git clone --depth=1 https://github.com/trialuser02/qt6ct
    cd qt6ct || error_user "Failed to download source code from GitHub!"
    qmake6 . || error "qmake failed!"
    make -j$(nproc) || error "make failed!"
    sudo make install || error "make install failed!"
    cd ..
    rm -rf /tmp/qt6ct
  fi

  if package_available qt6-gtk2-platformtheme ; then
    if ! package_installed qt6-gtk2-platformtheme ; then
      sudo apt install qt6-gtk2-platformtheme -y || error "Failed to install QT6 GTK2 Platform theme"
    fi
  else
    #GTK support for QT6
    cd /tmp
    rm -rf qt6gtk2
    git clone --depth=1 https://github.com/trialuser02/qt6gtk2
    cd qt6gtk2 || error_user "Failed to download source code from GitHub!"
    qmake6 . || error "qmake failed!"
    make -j$(nproc) || error "make failed!"
    sudo make install || error "make install failed!"
    cd ..
    rm -rf /tmp/qt6gtk2
  fi

  ;;
Fedora | Nobara)
  if echo $XDG_CURRENT_DESKTOP | grep -q 'GNOME'; then #multiple gnome variants exist out there, hence the different syntax - this'll also work on DEs like Budgie
    sudo dnf install gnome-tweaks -y
    #elif echo $XDG_CURRENT_DESKTOP | grep -q 'whatever it is for the Mate desktop'; then
    #        sudo dnf install mate-control-center -y
  else
    echo "Not using a DE with a known theme manager, skipping theme manager install..." #plasma comes with this built in, but need to add lxappearance for corresponding DEs
    # maybe check if Unity is installed here as a fallback - CLI installs won't detect ANY desktop using the above methods
  fi

  sudo dnf install -y qt5ct qt6ct qt5-qtbase-devel qt6-qtbase-devel qt5-qt3d qt5-qtdeclarative-devel qt5-qtsvg-devel qt5-qtquickcontrols2-devel qt5-qtstyleplugins gtk2-devel || error "Failed to install dependencies!" # untested dep list, please run this script on Fedora and use the automatic error reporter!

    #GTK support for QT6
    cd ~
    git clone https://github.com/trialuser02/qt6gtk2
    cd qt6gtk2 || error_user "Failed to download source code from GitHub!"
    git pull
    qmake6 . || error "qmake failed!"
    make -j$(nproc) || error "make failed!"
    sudo make install || error "make install failed!"
    cd ~

  ;;
*)
  echo -e "\\e[91mUnknown distro detected - please press Ctrl+C now, then manually install QT5CT (and QT6CT if possible) via your package manager.\\e[39m"
  sleep 10
  ;;
esac

  ##### only uncomment the following line if it's discovered that the Debian package doesn't auto set this in an env var like the Ubuntu package does
  # same goes for the Fedora package, of course
  # grep -qxF 'export QT_QPA_PLATFORMTHEME=qt5ct' ~/.profile || echo 'export QT_QPA_PLATFORMTHEME=qt5ct' | sudo tee --append ~/.profile


echo "Setting QT themes to automatically follow GTK themes when NOT running on KDE Plasma..."
mkdir -p ~/.config/qt5ct
mkdir -p ~/.config/qt6ct
touch ~/.config/qt5ct/qt5ct.conf
touch ~/.config/qt6ct/qt6ct.conf
tee ~/.config/qt5ct/qt5ct.conf <<'EOF' >>/dev/null
[Appearance]
standard_dialogs=gtk2
style=gtk2
EOF
tee ~/.config/qt6ct/qt6ct.conf <<'EOF' >>/dev/null
[Appearance]
standard_dialogs=gtk2
style=gtk2
EOF
# the previously mentioned env var - when set to "qt5ct" - is compatible qt6ct too

echo ""
echo "Please reboot or log out then back in to see QT applications match the (GTK) system theme!"
sleep 5

cd /tmp
rm -rf /tmp/ocs-url/
rm -rf ~/ocs-url #if you're reading this, it's probably been long enough since February 23 that this line should be removed.
##using my fork because the original maintainer will likely never merge my changes to fix manual builds
git clone https://www.opencode.net/cobalt2727/ocs-url

cd ocs-url || error_user "Failed to download source code from opencode.net!"

##switch over to my commits
git checkout patch-1

./scripts/prepare

case "$__os_id" in
Raspbian | Debian | Ubuntu)
  #this line is broken on Debian 10, but with the proper PREFIX path (that I don't remember currently) this script WILL run correctly
  #version detection may be needed if Debian 11 hasn't fixed the qmake setup, but I haven't checked that
  #works on every Ubuntu version I've tested though -Cobalt
  qmake PREFIX=/usr || error "qmake failed!"
  ;;
Fedora | Nobara)
  qmake-qt5 PREFIX=/usr || error "qmake failed!"
  ;;
*)
  qmake PREFIX=/usr || error "qmake AND distro detection failed!" #if you're hitting this line uh... good luck
  ;;
esac

make -j$(nproc)

sudo make install || error "Make install failed"

cd ~
rm -rf ocs-url/

echo "Done!"

if [[ $DISPLAY ]]; then
  echo "Find a theme you like and install it - enjoy!"
  sleep 3

  if [[ $(echo $XDG_CURRENT_DESKTOP) = 'Unity:Unity7:ubuntu' ]]; then
    unity-tweak-tool
  elif echo $XDG_CURRENT_DESKTOP | grep -q 'GNOME'; then #multiple gnome variants exist out there, hence the different syntax - this'll also work on DEs like Budgie
    xdg-open 'https://www.gnome-look.org/browse?ord=rating'
    gnome-tweaks
    #elif echo $XDG_CURRENT_DESKTOP | grep -q 'whatever it is for the Mate desktop'; then
    #xdg-open 'https://www.mate-look.org/browse?ord=rating'
    #mate-appearance-properties -y
    #elif echo $XDG_CURRENT_DESKTOP | grep -q 'whatever it is for xfce'; then
    #xdg-open 'https://www.xfce-look.org/browse?ord=rating'
    #command for theme chooser
    #elif echo $XDG_CURRENT_DESKTOP | grep -q 'whatever it is for xfce'; then
    #xdg-open 'https://www.xfce-look.org/browse?ord=rating'
    #command for theme chooser
  else
    echo "Not using a DE with a known theme manager, not launching tweak tool..."
    #open up the default web browser
    xdg-open 'https://www.pling.com/browse/cat/381/ord/rating/'
  fi

else

  echo "Open up https://www.pling.com on your device"
  echo "and find a theme you like - enjoy!"
  sleep 4
fi
