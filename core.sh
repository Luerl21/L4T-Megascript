clear
echo "These are here because I'm a lazy coder and i want an easy reference for text formatting in the menu - if you're able to read this inside the program, something is very wrong."
echo -e "\e[30mBlack Text\e[0m"
echo -e "\e[31mRed Text\e[0m"
echo -e "\e[32mGreen Text\e[0m"
echo -e "\e[33mBrown Text\e[0m"
echo -e "\e[34mBlue Text\e[0m"
echo -e "\e[35mPurple Text\e[0m"
echo -e "\e[36mCyan Text\e[0m"
echo -e "\e[37mLight Gray Text\e[0m"

echo -e "\e[1mbold\e[0m"
echo -e "\e[3mitalic\e[0m"
echo -e "\e[3m\e[1mbold italic\e[0m"
echo -e "\e[4munderline\e[0m"
echo -e "\e[9mstrikethrough\e[0m"
echo -e "\e[31mHello World\e[0m"
echo -e "\x1B[31mHello World\e[0m"
#echo "create a desktop file for the script on this line"

while true
do
cd ~
available_space=$(df -PH . | awk 'NR==2 {print $4"B"}')
clear
echo "Welcome back to the main menu of the L4T Megascript, $USER. This isn't quite finished yet - we'll be ready eventually!"
echo
echo "Enter a number from the choices below and then press ENTER to configure the specified program."
#echo -e "\x1B[31mKeep in mind how much storage you have left on your SD card!\e[0m"
echo -e "\x1B[31mYou have $available_space of space left on your SD card! Make sure you don't use too much!\e[0m"

sleep 2
#echo "note to self: get lakka firmware files and put in /lib/firmware - see L4T gbatemp release thread about that"
echo
echo
echo "0...............***WIP***Initial setup - swapfile, joycon mouse, Bluetooth audio, USB controller support, 2.0 GHz overclock, etc (2 GB of open space required for the swapfile!)"
echo "1...............Update your programs - download and install updates from the repos (check this at least once daily!)"
echo "2...............Update L4T Megascript autoconfigs for games (very helpful, [FILESIZE] download size though)"
echo "3...............Dolphin - Gamecube and Wii emulator, latest development version"
#echo "4...............RetroArch - Not quite working yet, I don't have a collection of working cores"
#echo "5...............Minecraft - automatically install Luke Chambers's MCSwitchTools (https://gitlab.com/devluke/mcswitchtools)"
echo "6...............moonlight-qt - stream games from your PC as long as it has an Nvidia GPU!"
#echo "7...............Discord setup - not the actual program, but the web app"
#echo "8...............Kodi - media center"
#echo "9...............Development IDEs - write code on your Switch!"
#echo "10..............Video Settings - Is your display going past the edges of your TV?"
#echo "11..............Citra - 3DS emulator, this probably is completely broken"
echo "12...............FlightGear - Free, open source flight simulator (3 GB DOWNLOAD)"
#echo "starwars........Watch Episode IV entirely in this terminal window!"
echo "13...............CSE2 - An enhanced version of Cave Story. 60 FPS and other soundtracks support"
echo "14...............SRB2 - A 3D open-source Sonic the Hedgehog fangame built using a modified version of Doom"
echo "15...............RetroPie - Powerful frontend for both emulators and native programs alike"
echo "X................Close L4T Megascript, view credits and source code, and get Discord support server link"
echo 
echo
read -p "Make a selection: " userInput

echo "you have chosen $userInput"
if [[ $userInput == 0 || $userInput == setup ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/scripts/init.sh)"
  
elif [[ $userInput == 1 || $userInput == update ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/scripts/apt.sh)"

elif [[ $userInput == 2 ]]; then
  sudo apt install subversion
  clear
  echo "needs to be fixed!"
  sleep 4
  #something something svn

elif [[ $userInput == 3 || $userInput == dolphin ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/scripts/dolphin/main.sh)"

elif [[ $userInput == 6 || $userInput == moonlight ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/scripts/moonlight.sh)"

elif [[ $userInput == 12 || $userInput == flightgear ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/scripts/flightgear.sh)"

elif [[ $userInput == 13 || $userInput == CSE2 ]]; then 
  bash -c "$(curl -s https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/scripts/CSE2.sh)"
  
elif [[ $userInput == 14 || $userInput == SRB2 ]]; then 
  bash -c "$(curl -s https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/scripts/SRB2.sh)"

elif [[ $userInput == 15 || $userInput == RetroPie ]]; then 
  bash -c "$(curl -s https://raw.githubusercontent.com/theofficialgman/RetroPie-Setup/master/auto_install.sh)"

elif [[ $userInput == starwars ]]; then
  sudo apt install telnet -y
  clear
  echo "The script will now run the command \e[32mtelnet towel.blinkenlights.nl\e[0m"
  echo "For more info on what this is and how"
  echo "it works, Ctrl+click the following links:"
  echo "http://www.blinkenlights.nl/thereg/"
  echo "http://www.asciimation.co.nz/"
  echo "This message will close in 30 seconds,"
  echo "and the movie will start. Press Ctrl + C"
  echo "or click the X on the terminal window to cancel"
  echo "at any time. Enjoy!"
  sleep 30
  telnet towel.blinkenlights.nl

elif [[ $userInput == x || $userInput == X ]]; then
echo "Thank you for using the L4T Megascript!"
sleep 2
clear
echo "Credits:"
echo "CTRL + CLICK ON A LINK TO OPEN IT"
echo
echo -e "\e[34mCobalt - Manager/Lead Developer\e[0m"
echo -e "Lugsole - Contributor/GUI Manager"
echo -e "\e[35mLang Kasempo - Contributor/Beta Tester/did a lot of the standalone game scripts\e[0m"
#echo "put other people that helped me write this here later if anyone gives some suggestions
echo "the Switchroot L4T Ubuntu team (https://switchroot.org/) - making the actual OS you're running right now"

echo ""
echo -e 'Thank you for using the L4T Megascript! Stop by our \e[36mDiscord\e[0m server at https://tinyurl.com/L4TScript for support.'
echo 'If that link is down for whatever reason, use https://discord.gg/UYsUFCY.'
echo 'Source code is available here: https://github.com/cobalt2727/L4T-Megascript/'

exit 0
else
  echo ""
fi

done

