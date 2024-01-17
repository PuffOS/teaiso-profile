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

# install packages
cd /tmp/
wget https://github.com/PuffOS/base-files/releases/download/v1/base-files_9999-noupdate_amd64.deb
wget https://github.com/PuffOS/desktop-base/releases/download/1/desktop-base_9999-noupdate_all.deb
wget https://github.com/PuffOS/17g-installer/releases/download/current/17g-installer_1.0_all.deb
#wget https://github.com/PuffOS/deb-packages/raw/main/gnome-session-bin_9999_all.deb
#wget https://github.com/PuffOS/deb-packages/raw/main/gnome-session-common_9999_all.deb
#wget https://github.com/PuffOS/deb-packages/raw/main/gnome-session_9999_all.deb
apt install ./*.deb -yq --allow-downgrades
rm -f *.deb
# remove broken sessions (FIXME)
#rm -f /usr/share/wayland-sessions/*
rm -f /usr/share/xsessions/lightdm-xsession.desktop

#### fix eudev sed bug about usrmerge shit
# install busybox into /bin as symlink
apt install busybox-static -yq 
$(which busybox) --install -s /bin
ln -s /usr/bin/kmod /sbin/modprobe

# Purge shitty display manager.
apt purge gdm3 -yq
apt autoremove -yq
rm -f /bin/sh
ln -s bash /bin/sh

# Remove sudo
export SUDO_FORCE_REMOVE=yes
apt purge sudo -yq
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
