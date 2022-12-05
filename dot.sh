#! /usr/bin/sh

dot() {
    $(which git) --git-dir="$HOME"/.dotfiles/ --work-tree="$HOME" "$@"
}

dot_install() {
    git clone --bare "$1" "$HOME"/.dotfiles > /dev/null

    if dot checkout > /dev/null; then
        echo "Dotfiles cloned";
    else
        echo "Backing up pre-existing dot files.";
        mkdir -p "$HOME"/.dotfiles-backup
        dot checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | xargs -I{} mv {} "$HOME"/.dotfiles-backup/{}


        if dot checkout > /dev/null; then
            echo "Dotfiles cloned";
        else
            echo "Can not clone dotfiles";
	        exit 1
        fi;
    fi;

    dot config status.showUntrackedFiles no
}
