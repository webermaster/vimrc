#!/bin/sh

#make may for fresh install
BREWDIR=~/Developer/homebrew
mv ~/.profile ~/.profile.old
mv ~/.vim ~/.vim.old
mv ~/.vimrc ~/.vimrc.old
mv ~/.tmux.conf ~/.tmux.conf.old
rm -rf $BREWDIR

#install Homebrew
mkdir -p $BREWDIR && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C $BREWDIR

#install brew cask
BREW=~/Developer/homebrew/bin/brew

#java
$BREW install java
sudo ln -sfn ~/Developer/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
$BREW install maven

#install kegs
$BREW install vim
$BREW install tmux
$BREW install watch
$BREW install go
$BREW install --HEAD universal-ctags/universal-ctags/universal-ctags
$BREW install kubectl
$BREW install docker
$BREW install awscli
$BREW install kubernetes-helm
$BREW install terraform
$BREW install minikube
$BREW install hyperkit
$BREW install k9s

#install casks
$BREW install --cask google-chrome
$BREW install --cask google-backup-and-sync
$BREW install --cask android-messages
$BREW install --cask slack
$BREW install --cask intellij-idea-ce


#setup environment installed by brew
CELLAR=$BREWDIR/Cellar
GOP=`cd $CELLAR/go/* && echo "${PWD##*/}"`

cat << EOF >> ~/.profile

#ALIASES
alias ls='ls -lFGh'
alias brewup='brew update; brew prune; brew cleanup; brew doctor'
alias mssh='ssh -i ~/.minikube/machines/minikube/id_rsa docker@$(minikube ip)'

#CREATE ENVIRONMENT VARIABLES
export JAVA_HOME=`/usr/libexec/java_home`
export GOPATH=~/Documents/go
export GOROOT=$CELLAR/go/$GOP
export GO111MODULE=on
export BASH_SILENCE_DEPRECATION_WARNING=1
export EDITOR=vim

export BREW_HOME=~/Developer/homebrew
CELLAR=\$BREW_HOME/Cellar

#ADD ENVIRONMENT VARIABLES TO THE PATH
export PATH=\$BREW_HOME/bin:\$PATH:\\
\$GOROOT/bin:\\
\$GOPATH/bin

EOF

#symlink .vimrc
ln -s "$(cd "$(dirname "$0")"; pwd -P )"/vimrc ~/.vimrc

#symlink .tmux.conf
ln -s "$(cd "$(dirname "$0")"; pwd -P )"/tmux.conf ~/.tmux.conf

#install Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

#install TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

#get plugins
vim -c 'PluginInstall' -c 'GoInstallBinaries' -c 'qa!'

minikube config set driver hyperkit

#setup go workspace
mkdir -p ~/Documents/go/src
mkdir -p ~/Documents/go/bin
mkdir -p ~/Documents/go/pkg

#set git diff tool
git config --global merge.tool vimdiff
git config --global merge.conflictstyle diff3
