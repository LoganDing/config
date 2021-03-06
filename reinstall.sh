#!/bin/bash

if [ ! -d $HOME/config ] ; then
  echo "Put those things into ~/config !"
  exit 1
fi

function symlink {
  [ ! -L $2 ] && ln -v -s $1 $2
}

#set -x
cd $HOME
symlink config/elisp/emacs.el .emacs
symlink config/elisp/viper.el .viper
mkdir -p .config/matplotlib
symlink ../../config/matplotlibrc .config/matplotlib/matplotlibrc

for i in vimrc gvimrc vim cvsrc Xresources fluxbox gitconfig gitignore wmii-3.5 pylintrc wcalc_preload; do
  test -r config/$i || echo config/$i does not exist
  symlink config/$i .$i
done

if [ -d scripts/.svn ] ; then
    echo 'Move ~/scripts out of the way!'
fi
symlink config/scripts scripts

# xmodmap fvwm2rc

echo "Symlinks done."

xrdb -merge .Xresources >/dev/null 2>&1
#xrdb .Xresources >/dev/null 2>&1

if ! grep bashrc.common ~/.bashrc >/dev/null; then
    echo "source ~/config/bashrc.common" >> ~/.bashrc
fi
perl -p -i -e 's/bash_completion /bash_completion_disabled /g' ~/.bashrc

test -h .Xdefaults && rm .Xdefaults # replaced by Xresources
test -h .inputrc && rm .inputrc # use system-wide file

mkdir -p .config/git
ln -s ../../config/gitignore .config/git/ignore

echo 
echo "Done. Maybe need to change email in ~/.gitconfig"


