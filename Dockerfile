FROM archlinux:latest

RUN pacman -Syu --noconfirm base-devel git ca-certificates
RUN useradd -m builduser

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

USER builduser
WORKDIR /home/builduser

RUN git clone https://aur.archlinux.org/paru-bin.git && \
    cd paru-bin && \
    makepkg -s --noconfirm 

USER root 
RUN cd /home/builduser/paru-bin && \
    pacman -U --noconfirm paru-bin-*.pkg.tar.zst && \
    rm -rf /home/builduser/paru-bin 

USER builduser
WORKDIR /pkg

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]