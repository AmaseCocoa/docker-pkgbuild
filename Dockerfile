FROM archlinux/base

RUN pacman -Syu --noconfirm base-devel git ca-certificates

RUN useradd -m builduser
USER builduser
WORKDIR /home/builduser

RUN git clone https://aur.archlinux.org/paru-bin.git && \
    cd paru-bin && \
    makepkg -si --noconfirm && \
    rm -rf ../paru-bin

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /pkg
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]