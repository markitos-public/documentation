#!/bin/bash

# Markitos DevSecOps Kulture - El camino del artesan@
# Marco Antonio - markitos
# markitos.es.info@gmail.com
# https://github.com/markitos-es
# https://discord.com/invite/YZWm2cYF

# Variables personales
MY_PASSWORD="xxxxxxxxxxxxxxxxx"
MY_USERNAME="xxxxxxxxxxxxxxxxx"
MY_HOSTNAME="xxxxxxxxxxxxxxxxx"
MY_NAME="Your Name"       # Nombre para clave SSH
MY_EMAIL="your_email@example.com"  # Email para clave SSH

# Función para generar clave SSH
generate_ssh_key() {
    echo "Generando clave SSH para GitHub..."
    ssh-keygen -t rsa -b 4096 -C "$MY_EMAIL" -f ~/.ssh/github -N "" || { echo "Error al generar clave SSH"; exit 1; }
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/github
    echo "Clave SSH generada correctamente:"
    cat ~/.ssh/github.pub
}

# Actualizar e instalar paquetes básicos
install_packages() {
    echo "Actualizando sistema e instalando paquetes básicos..."
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y \
        ccze software-properties-common nano git sshpass make progress \
        docker-compose-v2 docker.io btop curl apt-transport-https \
        ca-certificates net-tools wget locate && \
    sudo updatedb
        
}

# Configurar hostname
configure_hostname() {
    echo "Configurando hostname..."
    echo "$MY_USERNAME    ALL = (ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
    sudo hostnamectl set-hostname "$MY_HOSTNAME"
}

# Configurar archivo hosts
configure_hosts_file() {
    echo "Configurando archivo /etc/hosts..."
    sudo bash -c 'cat >> /etc/hosts <<EOF

#:{.'.'}>----- ${MY_HOSTNAME} network -----
192.168.1.200 prometeo1
192.168.1.250 titan1
192.168.1.251 titan2
192.168.1.252 titan3
#:{.'.'}>----- ${MY_HOSTNAME} network -----
EOF'
}

# Añadir alias y configuraciones a bashrc
configure_bashrc() {
    echo "Añadiendo configuraciones a bashrc..."
    sudo bash -c 'cat >> /etc/bash.bashrc <<EOF

# Alias de SSH
alias prometeo1="sshpass -p ${MY_PASSWORD} ssh ${MY_USERNAME}@prometeo1"
alias titan1="sshpass -p ${MY_PASSWORD} ssh ${MY_USERNAME}@titan1"
alias titan2="sshpass -p ${MY_PASSWORD} ssh ${MY_USERNAME}@titan2"
alias titan3="sshpass -p ${MY_PASSWORD} ssh ${MY_USERNAME}@titan3"

# Misc
export LANG=es_ES.UTF-8
export EDITOR="nano"
EOF'
}

# Configurar permisos para Docker
configure_docker() {
    echo "Configurando permisos para Docker..."
    sudo usermod -aG docker $USER
    sudo chown $USER /var/run/docker.sock
}

# Instalar OBS Studio
install_obs_studio() {
    echo "Instalando OBS Studio..."
    sudo add-apt-repository ppa:obsproject/obs-studio -y
    sudo apt update
    sudo apt install obs-studio -y
}

# Instalar Visual Studio Code
install_vscode() {
    echo "Instalando Visual Studio Code..."
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
    rm -f packages.microsoft.gpg
    sudo apt update
    sudo apt install code -y
}

# Instalar Google Chrome
install_chrome() {
    echo "Instalando Google Chrome..."
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb || sudo apt install -f -y
    rm google-chrome-stable_current_amd64.deb
}

# Instalar Postman
install_postman() {
    echo "Instalando Postman..."
    wget https://dl.pstmn.io/download/latest/linux_64 -O postman.tar.gz
    sudo tar -xzf postman.tar.gz -C /opt
    sudo ln -s /opt/Postman/Postman /usr/bin/postman
    rm postman.tar.gz
}

# Instalar Go
install_go() {
    echo "Instalando Go..."
    wget https://go.dev/dl/go1.24.1.linux-amd64.tar.gz -O go.tar.gz
    sudo tar xvfz go.tar.gz -C /usr/local/
    echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee -a /etc/bash.bashrc
    rm go.tar.gz
}

# Instalar Node.js con NVM
install_nodejs() {
    echo "Instalando Node.js con NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
    source ~/.bashrc
    nvm install v20.17.0
}

# Instalar Oh My Bash
install_oh_my_bash() {
    echo "Instalando Oh My Bash..."
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
}

# Actualizar base de datos de ubicaciones
update_database() {
    sudo updatedb
    echo "Instalación completada. Reinicia tu terminal o PC para aplicar todos los cambios."
}

# Ejecutar funciones
install_packages
configure_hostname
configure_hosts_file
configure_bashrc
configure_docker
install_obs_studio
install_vscode
install_chrome
install_postman
install_go
install_nodejs
install_oh_my_bash
generate_ssh_key
update_database
