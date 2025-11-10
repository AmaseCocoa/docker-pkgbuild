FROM archlinux:latest

RUN pacman -Syu --noconfirm base-devel git ca-certificates gnupg

RUN useradd -m builduser
RUN echo "builduser ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/builduser-nopasswd

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

USER builduser
WORKDIR /home/builduser

RUN git clone https://aur.archlinux.org/paru-bin.git && \
    cd paru-bin && \
    makepkg -s --noconfirm 

RUN cd paru-bin && \
    sudo pacman -U --noconfirm paru-bin-*.pkg.tar.zst && \
    cd .. && \
    rm -rf paru-bin

USER builduser
WORKDIR /pkg

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]