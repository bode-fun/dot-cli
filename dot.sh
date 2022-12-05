#! /usr/bin/sh

DOT_WORKING_TREE="$HOME"
DOT_GIT_DIR="$HOME"/.dotfiles
DOT_BACKUP_DIR="$HOME"/.dotfiles-backup

dot() {
    $(which git) --git-dir="$DOT_GIT_DIR"/ --work-tree="$DOT_WORKING_TREE" "$@"
}

dot_install() { 
    git clone --bare "$1" "$DOT_GIT_DIR"
    if dot checkout; then
        echo "Dotfiles cloned"
    else
        echo "Backing up pre-existing dot files."
        mkdir -p "$DOT_BACKUP_DIR"
        dot checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | xargs -I{} mv {} "$DOT_BACKUP_DIR"/{}
        if dot checkout; then
            echo "Dotfiles cloned"
        else
            echo "Can not clone dotfiles"
	    exit 1
        fi
    fi
    dot config status.showUntrackedFiles no
}
