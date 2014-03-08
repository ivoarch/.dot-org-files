#!/bin/sh

function clone_repo() {
DOT_ORG_DIR=$HOME/.dot-org-files

if [ -e $DOT_ORG_DIR ] ; then
    echo "Updating .dot-org-files..."
    cd $DOT_ORG_DIR
    git pull
else
    echo "Cloning .dot-org-files..."
    git clone https://github.com/ivoarch/.dot-org-files.git $DOT_ORG_DIR
    cd $DOT_ORG_DIR
fi
}

#function install_deps() {
#    echo "Installing depends..."
#    makepkg --syncdeps --clean
#    rm -rf .dot-org-files
#}

function tangle_files() {
    echo "Tangle config files with org-mode..."
    DIR=`pwd`
    FILES=""

    # wrap each argument in the code required to call tangle on it
    #for i in $@; do
    for i in `ls | grep \.org`; do
        FILES="$FILES \"$i\""
    done

    emacs -Q --batch \
        --eval \
        "(progn
        (require 'org)(require 'ob)(require 'ob-tangle)
        (mapc (lambda (file)
        (find-file (expand-file-name file \"$DIR\"))
        (org-babel-tangle)
        (kill-buffer)) '($FILES)))"
    #2>&1 | grep Tangled
}

# Clone repo
clone_repo

# Install depends
#install_deps

# tangle config files
tangle_files

exit 0
