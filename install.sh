#!/bin/bash
BASE=$(cd "$(dirname $0)"; pwd)

case `uname` in
  Darwin*)
    function update() {
      if [[ -n "$(dirname $2)" ]]; then
        mkdir -p "$(dirname $2)"
      fi
      ln -s -F -h $1 $2
    }
    ;;
  *)
    function update() {
      if [[ -n "$(dirname $2)" ]]; then
        mkdir -p "$(dirname $2)"
      fi
      ln -s --force --no-dereference $1 $2
    }
esac

mkdir -p $HOME/.vim-data/undo
mkdir -p $HOME/.vim-data/rcs

update $BASE/bash_completion $HOME/.bash_completion
update $BASE/bash_interactive $HOME/.bash_interactive
update $BASE/config/nvim $HOME/.config/nvim
update $BASE/fonts $HOME/.fonts
update $BASE/gdbinit $HOME/.gdbinit
update $BASE/gitconfig $HOME/.gitconfig
update $BASE/inputrc $HOME/.inputrc
update $BASE/tmux.conf $HOME/.tmux.conf
update $BASE/vimrc $HOME/.vimrc
update $BASE/Xmodmap $HOME/.Xmodmap
