#!/bin/bash
set -e
read -p "Install LinConnect server? [Y/N]" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

clear
echo "Install dependencies automatically:" 
echo "1) Arch-Linux"
echo "2) Debian (Distros)"
echo "3) Fedora distros"
echo    # (optional) move to a new line
read -p "Option:" -n 1 -r
case "$REPLY" in
	1)
		clear
		read -p "Install dependencies automatically (for Arch Linux) [Y/N]" -n 1 -r
	    if [[ ! $REPLY = ^[Yy]$ ]]
	    then
			echo "Please manually install the following:"
			echo "* extra/python2"
			echo "* extra/python-pip"
			echo "* extra/python-gobject"
			echo "* extra/avahi"
			echo "* community/python-cherrypy (python package)"
			echo "* community/python2-pybonjour (python package)"
			echo "* community/notify-osd (Notification package)"
		else
			echo "Installing dependencies..."
			sudo pacman -S -y python2 python-pip python-gobject git avahi notify-osd
			echo "Installing Python dependencies..."
			sudo pacman -S python-cherrypy python2-pybonjour 
			clear
	    fi
	    
	;;
	2)
		clear
		read -p "Install dependencies automatically (for Debian distros) [Y/N]" -n 1 -r
	    if [[ ! $REPLY =~ ^[Yy]$ ]]
	    then
		    echo "Please manually install the following:"
			echo "* python2"
			echo "* python-pip"
			echo "* python-gobject"
			echo "* libavahi-compat-libdnssd1"
			echo "* cherrypy (python package)"
			echo "* pybonjour (python package)"
	    else
			echo "Installing dependencies..."
			sudo apt-get install -y python-pip python-gobject git libavahi-compat-libdnssd1 gir1.2-notify-0.7
			echo "Installing Python dependencies..."
			sudo pip install --allow-external pybonjour --allow-unverified pybonjour pybonjour
			sudo pip install cherrypy
			clear
		fi
	;;
	3)
		clear
	    read -p "Install dependencies automatically (for Fedora distros) [Y/N]" -n 1 -r
	    if [[ ! $REPLY =~ ^[Yy]$ ]]
	    then
			echo "Please manually install the following:"
			echo "* python2"
			echo "* python-pip"
			echo "* python-gobject"
			echo "* libavahi-compat-libdnssd1"
			echo "* cherrypy (python package)"
			echo "* pybonjour (python package)"
	    else
			echo "Installing dependencies..."
			sudo yum install -y python2 python-pip pygobject2 git avahi-compat-libdns_sd
			echo "Installing Python dependencies..."
			sudo pip install cherrypy pybonjour
			clear
	    fi
	;;
	*) 
	echo "Option Invalid!" ;;
esac

read -p "Press any key to continue..." -n 1 -r
clear 

echo "Installing LinConnect..."
git clone -q https://github.com/hauckwill/linconnect-server.git ~/.linconnect
cd ~/.linconnect
echo "Setting up LinConnect..."
git remote add upstream https://github.com/hauckwill/linconnect-server.git

echo -e "Autostart LinConnect server on boot..." 
if [[ ! -e /etc/arch-release ]]; then # check if not is Arch linux
	clear
	echo -e "Making for (debian | Fedora)"
    mkdir -p ~/.config/autostart/
	printf '[Desktop Entry]\nVersion=1.0\nType=Application\nHidden=false\nTerminal=false\nIcon=phone\nName=LinConnect\nExec=%s/.linconnect/LinConnectServer/update.sh\nPath=%s/.linconnect/LinConnectServer' $HOME $HOME > ~/.config/autostart/linconnect-server.desktop
	chmod +x ~/.config/autostart/linconnect-server.desktop
else
	clear
	echo -e "Your system is Arch Linux."
	echo -e "Add this line on .xinitrc file Autostart LinConnect server on boot." 
	echo    # (optional) move to a new line
	echo -e "#Starting LinConnectServer" 
	echo -e "exec ~/.linconnect/LinConnectServer/update.sh"
fi	
read -p "Press any key to continue..." -n 1 -r

chmod +x ~/.linconnect/LinConnectServer/update.sh

read -p "Install complete. Start LinConnect server now? [Y/N]" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    ~/.linconnect/LinConnectServer/update.sh
fi

