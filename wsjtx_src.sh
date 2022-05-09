
#!/bin/bash
#########################################################
# Created by W7SVT Nov 2021 #############################
# Updated by W7SVT APR 2022 #############################
#########################################################
#########################################################
#  __      ___________  _____________   _______________ #
# /  \    /  \______  \/   _____/\   \ /   /\__    ___/ #
# \   \/\/   /   /    /\_____  \  \   Y   /   |    |    #
#  \        /   /    / /        \  \     /    |    |    #
#   \__/\  /   /____/ /_______  /   \___/     |____|    #
#        \/                   \/                        #
#########################################################

cd $HOME/Downloads
mkdir wsjtx

echo "###################################################" 
echo "# Downloading WSJT-X Source                       #"
echo "###################################################" 

wsjtx_dl=$(curl -s https://physics.princeton.edu/pulsar/k1jt/wsjtx.html | \
    tac | \
    grep .tgz | \
    grep -v rc | \
    awk -F'"' '$0=$2'
)

cd $HOME/Downloads/wsjtx

wget -t 5 https://physics.princeton.edu/pulsar/k1jt/$wsjtx_dl -O - | tar -xz
mkdir WSJTX_BLD_DIR


echo "###################################################"
echo "# Prepping WSXJ-X build & prereqs                 #"
echo "###################################################"

sudo apt install -y \
	asciidoc \
  	asciidoctor \
	texinfo \
  	libfftw3-dev \
  	qtmultimedia5-dev \
  	qttools5-dev \
  	qttools5-dev-tools \
  	libqt5serialport5-dev \
	libqt5websockets5-dev \
	libqt5multimedia5 \
	libqt5multimedia5-plugins \
	qtmultimedia5-dev \
	libboost-dev \
	libboost-all-dev


sudo mkdir /usr/local/stow/wsjtx

echo "###################################################"
echo "# Installing WSXJ-X in stow                       #"
echo "# to remove run 'sudo stow --delete wsjtx'        #"
echo "###################################################"

cmake -D CMAKE_INSTALL_PREFIX=/usr/local/stow/wsjtx "${wsjtx_dl%.*}"
cmake -DWSJT_GENERATE_DOCS=OFF -DWSJT_SKIP_MANPAGES=ON "${wsjtx_dl%.*}"

cd WSJTX_BLD_DIR
cmake "../${wsjtx_dl%.*}"
cd ../

cmake --build WSJTX_BLD_DIR
sudo cmake --build WSJTX_BLD_DIR --target install -j4
cd /usr/local/stow/ && sudo stow wsjtx

echo "###################################################"
echo "# get CALLSIGN & Grid                             #"
echo "###################################################"


if [ -n "$CALLSIGN" ]; then
cp -f /baconTelegraph/files/WSJT-X.ini $HOME/.config
sed -i "s/NOCALL/$CALLSIGN/g" $HOME/.config/WSJT-X.ini
sed -i "s/NOGRID/$GRID" $HOME/.config/WSJT-X.ini
else
  echo "Please (re)run install.sh and set your GRID and CALLSIGN" \
fi
