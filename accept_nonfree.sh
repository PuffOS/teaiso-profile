# https://github.com/Whonix/whonix-legacy/blob/master/debian/whonix-legacy.preinst#L49
echo b43-fwcutter b43-fwcutter/cut_firmware boolean true | debconf-set-selections
echo firmware-ipw2x00 firmware-ipw2x00/license/accepted boolean true | debconf-set-selections
echo firmware-iwlwifi firmware-iwlwifi/license/accepted boolean true | debconf-set-selections
echo firmware-ralink firmware-ralink/license/accepted boolean true | debconf-set-selections
