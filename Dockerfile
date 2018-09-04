FROM phusion/baseimage:0.9.16

# Set correct environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV WINEARCH win32
ENV DISPLAY :0
ENV WINE_MONO_VERSION 4.5.6
ENV WINEPREFIX /home/xclient/.wine
ENV WINEARCH win32
ENV HOME /home/xclient/

# Updating and upgrading a bit.
	# Install vnc, window manager and basic tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends  language-pack-zh-hant  && \
    apt-get install -y x11vnc xdotool supervisor fluxbox git unzip && \
	dpkg --add-architecture i386 && \

# We need software-properties-common to add ppas.
	apt-get install -y --no-install-recommends software-properties-common && \
        add-apt-repository ppa:ubuntu-wine/ppa && \
	apt-get update && \
apt-get install -y --no-install-recommends wine1.8 cabextract unzip p7zip zenity xvfb && \
	curl -SL -k https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks  -o /usr/local/bin/winetricks && \
    chmod a+x /usr/local/bin/winetricks  && \
# Installation of winbind to stop ntlm error messages.
	apt-get install -y --no-install-recommends winbind && \
# Get latest version of mono for wine
    mkdir -p /usr/share/wine/mono && \
	curl -SL -k 'http://sourceforge.net/projects/wine/files/Wine%20Mono/$WINE_MONO_VERSION/wine-mono-$WINE_MONO_VERSION.msi/download' -o /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi && \
    chmod +x /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi && \
    mkdir -p /usr/share/wine/gecko && \
    curl -SL -k 'http://dl.winehq.org/wine/wine-gecko/2.40/wine_gecko-2.40-x86.msi' -o /usr/share/wine/gecko/wine_gecko-2.40-x86.msi && \
    # Add Simplified Chinese Fonts
    mkdir -p /usr/share/fonts/TTF/ && \
    curl -SL -k https://github.com/adobe-fonts/source-han-sans/raw/release/OTF/SimplifiedChinese/SourceHanSansSC-Regular.otf -o /usr/share/fonts/TTF/SourceHanSansSC-Regular.otf && \
    curl -SL -k https://github.com/adobe-fonts/source-han-sans/raw/release/OTF/SimplifiedChinese/SourceHanSansSC-Bold.otf -o /usr/share/fonts/TTF/SourceHanSansSC-Bold.otf && \
    # Add pan-download:
    curl http://dl.pandownload.com/download/PanDownload_v2.0.1.zip -o /home/wine/.cache/pandownload.zip && \
    unzip /home/wine/.cache/pandownload.zip -d /home/wine/ && \
# Create user for ssh
    adduser \
            --home /home/xclient \
            --disabled-password \
            --shell /bin/bash \
            --gecos "user for running an xclient application" \
            --quiet \
            xclient && \
    echo "xclient:123456" | chpasswd && \
    # Clone noVNC
    git clone https://github.com/novnc/noVNC.git /home/xclient/novnc && \
    # Clone websockify for noVNC
    git clone https://github.com/kanaka/websockify /home/xclient/novnc/utils/websockify && \
    ln -s /home/xclient/novnc/vnc.html /home/xclient/novnc/index.html && \
    chown xclient -R /home/xclient/novnc && \
# Cleaning up.
    apt-get autoremove -y --purge software-properties-common && \
    apt-get autoremove -y --purge && \
    apt-get clean -y && \
    rm -rf /home/wine/.cache && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add supervisor conf
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add entrypoint.sh
ADD entrypoint.sh /etc/entrypoint.sh


## Add novnc
ENTRYPOINT ["/bin/bash","/etc/entrypoint.sh"]
# Expose Port
EXPOSE 8080 22
