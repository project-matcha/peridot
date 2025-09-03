# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image
FROM ghcr.io/tulilirockz/opensuse-bootc:latest

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    zypper install -y -t pattern gnome_basic && zypper install -y gnome-terminal gdm && \
    systemctl set-default graphical.target && \
    /ctx/build.sh

# Necessary labels
LABEL containers.bootc 1
