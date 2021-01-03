# Exit immediately on failure
set -e

# Print the commands as they are executed
set -x

# Set the VM Name
echo 'workstation-cm' > /etc/hostname

# Authorize Vagrant's insecure public SSH key
mkdir /home/vagrant/.ssh/
chmod 700 /home/vagrant/.ssh/
wget https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant: /home/vagrant/.ssh/

# Set root password to "vagrant"
echo root:vagrant | chpasswd

# Passwordless sudo
echo '\nvagrant ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers


# Do not bother with interactive UI while upgrading
export DEBIAN_FRONTEND=noninteractive

# Update/upgrade
apt-get update
apt-get full-upgrade -y

################################################################################
# Workstation Customisation
#
# This process will install any publicly available ressource needed to
# simplify the Vagrant provisionning
################################################################################

#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====
# UI toolset
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
# Gnome Tweaks
apt-get install -y gnome-tweak-tool
#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====
# French support
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#language pack
apt-get install -y $(check-language-support -l fr)
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#locale
locale-gen fr_FR.UTF-8
update-locale LANG=fr_FR.UTF-8
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#keyboard
mv /etc/default/keyboard /etc/default/keyboard.orig
sed -e 's,"us","fr,fr",' /etc/default/keyboard.orig | sed -e 's,XKBVARIANT="",XKBVARIANT=",bepo",' | sed -e 's,XKBOPTIONS="",XKBOPTIONS="grp:alt_shift_toggle",' > /etc/default/keyboard
udevadm trigger --subsystem-match=input --action=change
#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====
# Network toolset
apt-get install -y wget curl gnupg2 cntlm
#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====
# Apt toolset
apt-get install -y apt-transport-https
#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====
# Bash user rc files
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
# Retrieve rc files setup
wget -O /etc/skel/.bash_aliases https://raw.githubusercontent.com/sporniket/sporniket-workstation/master/src-deb/1-second-stage/bash-rc/usr/share/bash-rc/bash_aliases
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
# Preinit folders
[ ! -d "/etc/skel/.bashrc.d/available" ] && mkdir -p /etc/skel/.bashrc.d/available
[ ! -d "/etc/skel/.bashrc.d/enabled" ] && mkdir -p /etc/skel/.bashrc.d/enabled
#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====
# Git
apt-get install -y git
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
# Default settings
wget -O /etc/gitconfig https://raw.githubusercontent.com/sporniket/sporniket-workstation/master/src-deb/1-second-stage/git-extras/etc/gitconfig
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
# Git prompt
[ ! -d /usr/share/git-extras ] && mkdir -p /usr/share/git-extras
wget -O /usr/share/git-extras/git-prompt.sh https://github.com/git/git/raw/master/contrib/completion/git-prompt.sh
wget -O /etc/skel/.bashrc.d/available/90-git-prompt https://raw.githubusercontent.com/sporniket/sporniket-workstation/master/src-deb/1-second-stage/git-extras/usr/share/git-extras/bashrc.append
#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====
# Java development toolset
apt-get install -y openjdk-8-jdk maven
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
# Eclipse and plugins
ECLIPSE_INSTALL_DIR="/opt"
[ ! -d "${ECLIPSE_INSTALL_DIR}" ] && mkdir -p ${ECLIPSE_INSTALL_DIR}
cd ${ECLIPSE_INSTALL_DIR}
wget -O eclipse.tar.gz 'http://ftp.halifax.rwth-aachen.de/eclipse/technology/epp/downloads/release/2020-03/R/eclipse-jee-2020-03-R-incubation-linux-gtk-x86_64.tar.gz'
tar xzf eclipse.tar.gz
cd eclipse

# remove 'UseStringDeduplication' option
mv eclipse.ini eclipse.ini.orig
cat eclipse.ini.orig | sed -e "s,-XX:+UseStringDeduplication,,"> eclipse.ini

# plugins provisionning
./eclipse -application org.eclipse.equinox.p2.director -noSplash -repository "http://download.jboss.org/jbosstools/photon/stable/updates/" -installIUs "org.jboss.ide.eclipse.as.feature.feature.group"
#./eclipse -application org.eclipse.equinox.p2.director -noSplash -repository "http://update.eclemma.org/" -installIUs "org.eclipse.eclemma.feature.feature.group"
./eclipse -application org.eclipse.equinox.p2.director -noSplash -repository "https://build.se.informatik.uni-kiel.de/eus/qa/snapshot/" -installIUs "qa.eclipse.plugin.pmd.feature.group,qa.eclipse.plugin.checkstyle.feature.group"
./eclipse -application org.eclipse.equinox.p2.director -noSplash -repository "https://spotbugs.github.io/eclipse/" -installIUs "com.github.spotbugs.plugin.eclipse.feature.group"
./eclipse -application org.eclipse.equinox.p2.director -noSplash -repository "http://ucdetector.sourceforge.net/update" -installIUs "org.ucdetector.feature.feature.group"
./eclipse -application org.eclipse.equinox.p2.director -noSplash -repository "http://andrei.gmxhome.de/eclipse/" -installIUs "de.loskutov.BytecodeOutline.feature.feature.group"
./eclipse -application org.eclipse.equinox.p2.director -noSplash -repository "https://dl.bintray.com/de-jcup/yamleditor" -installIUs "de.jcup.yamleditor.feature.group"

# Desktop shortcut
wget -O /usr/share/applications/workstation-cm--eclipse.desktop https://raw.githubusercontent.com/sporniket/sporniket-workstation/master/src-deb/1-second-stage/eclipse/usr/share/applications/eclipse-from-download.desktop
#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====
# Atom text editor
curl -fsSL https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main"
apt-get update
apt-get install -y atom
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
# Preinstall packages
## general purpose
apm install duplicate-line-or-selection file-icons highlight-selected hyperclick sort-lines sublime-style-column-selection

## general development
apm install atom-beautify editorconfig related toggle-quotes docblockr tree-view-copy-relative-path

## javascript/html development
apm install atom-ternjs atom-wrap-in-tag autocomplete-modules linter-eslint atom-ide-ui ide-typescript

#put in user template
cp -Rf ~/.atom /etc/skel
#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====
# nvm
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
# Install
[ ! -d /etc/skel/opt ] && mkdir -p /etc/skel/opt
cd /etc/skel/opt
git clone https://github.com/creationix/nvm.git
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
# Add to bash sourcing
echo '#!/bin/bash

#setup nvm
export NVM_DIR="$HOME/opt/nvm"

# Loads nvm
[ -z "$(command -v nvm)" ] && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
'>/etc/skel/.bashrc.d/available/50-nvm
#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====
# Docker and docker-compose
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
# Docker CE
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

#To do in a next release : fail if the following sequence don't give '1' as a result.
#apt-key fingerprint 0EBFCD88 | grep "Key fingerprint = 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88" | wc -l

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

apt-get update
apt-get install -y docker-ce
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
# Docker-compose
curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# bash completion
curl -L https://raw.githubusercontent.com/docker/compose/1.21.2/contrib/completion/bash/docker-compose
#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====
# Backup tools
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
# Sporniket Backup
wget -O /usr/bin/sporniket-backup https://raw.githubusercontent.com/sporniket/sporniket-backup/master/sporniket-backup.sh
chmod 755 /usr/bin/sporniket-backup
#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====
# Augment file watcher number
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
echo "fs.inotify.max_user_watches=32000" >> /etc/sysctl.conf
#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====
# Title
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
# SubTitle
#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====

################################################################################

# Delete stuff
apt-get --purge -y autoremove
apt-get -y clean

rm -rf /var/log/*
rm -rf /home/vagrant/.cache/*
rm -rf /root/.cache/*
rm -rf /var/cache/*
rm -rf /var/tmp/*
rm -rf /tmp/*

# Clear recent bash history
cat /dev/null > /home/vagrant/.bash_history
cat /dev/null > /root/.bash_history

# Fill empty space with zeroes
# This should allow for a smaller archive of the disk
#set +e
# This is supposed to crash with an error message:
#   "dd: error writing 'zerofile': No space left on device"
#dd if=/dev/zero of=zerofile bs=1M
#set -e
#
#rm -f zerofile
sync
