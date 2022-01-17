#!/usr/bin/env bash

cd /tmp/
wget https://github.com/PuffOS/base-files/releases/download/v1/base-files_9999-noupdate_amd64.deb
wget https://github.com/PuffOS/desktop-base/releases/download/1/desktop-base_9999-noupdate_all.deb
wget https://github.com/PuffOS/17g-installer/releases/download/4.3/17g-installer_1.0_all.deb
apt install ./*.deb -yq --allow-downgrades
rm -f *.deb
apt purge gdm3 -yq
apt autoremove -yq
