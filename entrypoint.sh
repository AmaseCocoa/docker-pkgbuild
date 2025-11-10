#!/bin/bash

if [ -n "$AUR_DEPS" ]; then
    paru -S --needed --noconfirm --skipreview $AUR_DEPS
    
    if [ $? -ne 0 ]; then
        exit 1
    fi
fi

makepkg -s --noconfirm --cleanbuild

if [ $? -ne 0 ]; then
    exit 1
fi