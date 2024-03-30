#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

# fake dummy systemctl command
touch /usr/bin/systemctl
chmod +x /usr/bin/systemctl

#### Remove useless files after package installation by default
cat > /etc/apt/apt.conf.d/02cleanup << EOF
DPkg::Post-Invoke {"rm -rf /usr/share/man || true";};
DPkg::Post-Invoke {"rm -rf /usr/share/help || true";};
DPkg::Post-Invoke {"rm -rf /usr/share/doc || true";};
DPkg::Post-Invoke {"rm -rf /usr/share/info || true";};
EOF

apt install wget -yq 

# install packages
cd /tmp/
wget https://github.com/PuffOS/base-files/releases/download/v1/base-files_9999-noupdate_amd64.deb
wget https://github.com/PuffOS/desktop-base/releases/download/1/desktop-base_9999-noupdate_all.deb
wget https://github.com/PuffOS/17g-installer/releases/download/current/17g-installer_1.0_all.deb
#wget https://github.com/PuffOS/deb-packages/raw/main/gnome-session-bin_9999_all.deb
#wget https://github.com/PuffOS/deb-packages/raw/main/gnome-session-common_9999_all.deb
#wget https://github.com/PuffOS/deb-packages/raw/main/gnome-session_9999_all.deb
yes | apt install ./*.deb -yq --allow-downgrades
rm -f *.deb
# remove broken sessions (FIXME)
#rm -f /usr/share/wayland-sessions/*
rm -f /usr/share/xsessions/lightdm-xsession.desktop

#### non-usrmerge broken
yes | apt install usrmerge --reinstall -y

# Purge shitty display manager.
yes | apt purge gdm3 -yq
yes | apt autoremove -yq
rm -f /bin/sh
ln -s bash /bin/sh

# Remove sudo
export SUDO_FORCE_REMOVE=yes
yes | apt purge sudo -yq
pass="live"
echo -e "$pass\n$pass\n" | passwd

#### Disable recommends by default
cat > /etc/apt/apt.conf.d/01norecommend << EOF
APT::Install-Recommends "0";
APT::Install-Suggests "0";
EOF

#### Remove kernel update hooks
rm -f /etc/kernel/*/* || true

### Remove gnome-tracker daemons
rm -f /usr/libexec/tracker-* || true

### update initramfs
for dir in $(ls /lib/modules) ; do
    update-initramfs -u -k $dir
done
