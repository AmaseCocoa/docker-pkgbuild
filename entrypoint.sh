#!/bin/bash

if [ -n "$AUR_DEPS" ]; then
    paru -S --needed --noconfirm --skipreview $AUR_DEPS
    
    if [ $? -ne 0 ]; then
        exit 1
    fi
fi

if [ -n "$GPG_KEY" ]; then
    echo "$GPG_KEY" | gpg --import
    if [ $? -ne 0 ]; then
        echo "GPG key import failed." >&2
        exit 1
    fi

    if [ -n "$GPG_PASSPHRASE" ]; then
        # Use here-string to pass passphrase to stdin for gpg
        makepkg -s --noconfirm --cleanbuild --sign --gpg-args "--pinentry-mode loopback --passphrase-fd 0" <<< "$GPG_PASSPHRASE"
    else
        # No passphrase, but ensure no interactive prompt
        makepkg -s --noconfirm --cleanbuild --sign --gpg-args "--pinentry-mode loopback"
    fi
else
    makepkg -s --noconfirm --cleanbuild
fi

if [ $? -ne 0 ]; then
    exit 1
fi