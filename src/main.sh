
# File paths
# shellcheck disable=SC2154
flatpak_programs="$file_directory/resource/flatpak.txt"
apt_programs="$file_directory/resource/apt.txt"

install_apps(){
  install_apt
  install_flatpak
  install_nvm
  install_docker
  init_postgres_container
}

install_apt(){
  echo "Installing apt packages..."
  sudo apt update -y
  sleep 1
  while IFS= read -r line || [[ -n "$line" ]]; do
      sudo apt install $line -y
  done < "$apt_programs"

  echo "Apt packages installed."
}

install_flatpak(){
  echo "Installing flatpak packages..."
  while IFS= read -r line || [[ -n "$line" ]]; do
    sudo flatpak install -y $package
  done < "$flatpak_programs"
  echo "Flatpak packages installed."
}

install_nvm(){
  echo "Installing NVM..."
  sudo wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  sleep 1
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  sleep 1
  echo "NVM has been installed."
}

install_docker(){
  echo "Installing Docker..."
  sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
  sleep 1
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sleep 1
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y
  sleep 1
  sudo apt update -y
  sleep 1
  sudo apt install docker-ce -y
  sleep 1
  echo "Docker has been installed."
}

init_postgres_container(){
  echo "Initializing Postgres container..."
  sudo docker run --name postgres -e POSTGRES_PASSWORD=postgres -d -p 5432:5432 postgres
  echo "Postgres container initialized."
}


install_apps
