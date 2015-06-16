#!/bin/sh
path=`pwd`
rm -rf ~/.emacs.d
ln -s $path/emacs ~/.emacs
ln -s $path/emacs.d ~/.emacs.d
ln -s $path/stardict ~/.stardict
