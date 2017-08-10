sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

pacman-key --populate && pacman-key --refresh-keys
pacman -Sy --noprogressbar --noconfirm
pacman -S --force openssl --noconfirm
pacman -S pacman --noprogressbar --noconfirm
pacman-db-upgrade
pacman -Syyu --noprogressbar --noconfirm
pacman -S --force --needed --noconfirm \
     base base-devel openssh git sudo zsh make cmake gvim gdb python-pip tmux unzip rxvt-unicode-terminfo
yes | pacman -S gcc-multilib valgrind-multilib

pip3 install retdec-python keystone-engine unicorn capstone ropper

systemctl enable sshd

sudo -u vagrant curl -Ls https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz | sudo -u vagrant tar -xvz
cd package-query && sudo -u vagrant makepkg -si --noconfirm
cd ..
sudo -u vagrant curl -Ls https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz | sudo -u vagrant tar -xvz
cd yaourt && sudo -u vagrant makepkg -si --noconfirm
cd .. && rm -rf package-query yaourt

sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#AllowAgentForwarding/AllowAgentForwarding/' /etc/ssh/sshd_config

cd /home/vagrant/.ssh
sudo -u vagrant curl -s -L https://github.com/{cgundogan.keys} -o "/home/vagrant/.ssh/#1"
rm -f /home/vagrant/.ssh/authorized_keys
sudo -u vagrant cat /home/vagrant/.ssh/*.keys | sudo -u vagrant tee -a /home/vagrant/.ssh/authorized_keys
sudo -u vagrant chmod 600 authorized_keys

sudo -u vagrant git clone https://github.com/hugsy/gef.git /home/vagrant/gef
sudo -u vagrant echo "source ~/gef/gef.py" | sudo -u vagrant tee /home/vagrant/.gdbinit

sudo -u vagrant git clone --recursive https://github.com/cgundogan/TaZSHa /home/vagrant/.ztazsha
sudo -u vagrant echo 'ZDOTDIR="/home/vagrant/.ztazsha"' | sudo -u vagrant tee -a /home/vagrant/.zshenv
sudo -u vagrant echo 'source "$ZDOTDIR/.zshenv"' | sudo -u vagrant tee -a /home/vagrant/.zshenv

chsh -s $(which zsh) vagrant

systemctl restart sshd
