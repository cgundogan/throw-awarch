USER=dev

sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

pacman-key --populate && pacman-key --refresh-keys
pacman -Sy --noprogressbar --noconfirm
pacman -S --force openssl --noconfirm
pacman -S pacman --noprogressbar --noconfirm
pacman-db-upgrade
pacman -Syyu --noprogressbar --noconfirm
pacman -S --force --needed --noconfirm \
     base base-devel openssh git sudo zsh make cmake vim gdb python-pip \
     tmux unzip rxvt-unicode-terminfo bridge-utils ccache wireshark-cli rsync
yes | pacman -S gcc-multilib valgrind-multilib

pip3 install retdec-python keystone-engine unicorn capstone ropper

systemctl enable sshd

useradd ${USER} -m -s $(which zsh) -G wheel wireshark
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

cd /home/${USER}
sudo -u ${USER} mkdir .ssh
sudo -u ${USER} chmod 700 .ssh

sudo -u ${USER} curl -Ls https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz | sudo -u ${USER} tar -xvz
cd package-query && sudo -u ${USER} makepkg -si --noconfirm --noprogressbar
cd ..
sudo -u ${USER} curl -Ls https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz | sudo -u ${USER} tar -xvz
cd yaourt && sudo -u ${USER} makepkg -si --noconfirm --noprogressbar
cd .. && rm -rf package-query yaourt

sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#AllowAgentForwarding/AllowAgentForwarding/' /etc/ssh/sshd_config

cd /home/${USER}/.ssh
sudo -u ${USER} curl -s -L https://github.com/{cgundogan.keys} -o "/home/${USER}/.ssh/#1"
sudo -u ${USER} cat /home/${USER}/.ssh/*.keys | sudo -u ${USER} tee /home/${USER}/.ssh/authorized_keys
sudo -u ${USER} chmod 600 authorized_keys

sudo -u ${USER} git clone https://github.com/hugsy/gef.git /home/${USER}/gef
sudo -u ${USER} echo "source ~/gef/gef.py" | sudo -u ${USER} tee /home/${USER}/.gdbinit

sudo -u ${USER} git clone --recursive https://github.com/cgundogan/TaZSHa /home/${USER}/.ztazsha
sudo -u ${USER} echo 'ZDOTDIR="/home/${USER}/.ztazsha"' | sudo -u ${USER} tee -a /home/${USER}/.zshenv
sudo -u ${USER} echo 'source "$ZDOTDIR/.zshenv"' | sudo -u ${USER} tee -a /home/${USER}/.zshenv

systemctl restart sshd
