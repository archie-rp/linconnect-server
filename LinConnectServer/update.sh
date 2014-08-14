#!/bin/sh 
cd $HOME/.linconnect
git fetch --all
git reset --hard origin/master
chmod +x LinConnectServer/update.sh
cd LinConnectServer/main/
python2 linconnect_server.py

