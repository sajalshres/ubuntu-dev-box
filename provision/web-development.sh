#!/bin/sh
set +ex

# Add NodeJS repository
curl -sL https://deb.nodesource.com/setup_13.x | bash -
# Update package index
apt-get update
# Install Node.js
apt-get install -y nodejs
# npm global default directory to default user
runuser -l vagrant -c "mkdir ~/.npm-global"
runuser -l vagrant -c "npm config set prefix '~/.npm-global'"
runuser -l vagrant -c "echo '' >> ~/.profile"
runuser -l vagrant -c "echo '# npm global added to path' >> ~/.profile"
runuser -l vagrant -c "echo 'export PATH=~/.npm-global/bin:\$PATH' >> ~/.profile"
# Install eslint
npm install -g eslint
# Install webpack
npm install -g webpack
# Install webpack cli
npm install -g webpack-cli
# Install nvm as default vagrant user
runuser -l vagrant -c "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash"
