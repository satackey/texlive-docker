FROM ghcr.io/paperist/texlive-ja:latest@sha256:9f4cd0d2ae035ddd6c62e5ffc3b1fd27fb280174c848ba3d85e48976034cec7c

RUN set -x \
    && apt-get update && apt-get install -y \
        wget \
        bzip2 \
        git \
    && mkdir /tmp/texlive \
    && wget -O jlisting.sty.bz2 --no-check-certificate 'https://osdn.net/frs/redir.php?m=jaist&f=mytexpert%2F26068%2Fjlisting.sty.bz2' \
    && wget --no-check-certificate -O update-tlmgr-latest 'https://ctan.math.washington.edu/tex-archive/systems/texlive/tlnet/update-tlmgr-latest.sh' \
    && bunzip2 jlisting.sty.bz2 \
    && chmod +x update-tlmgr-latest \
    && mv jlisting.sty "$(kpsewhich -var-value TEXMFDIST)/tex/latex/listings/" \
    && mv update-tlmgr-latest /usr/local/bin/ \
    && update-tlmgr-latest \
    && tlmgr update --self --all \
    && tlmgr install siunitx \
    && apt-get remove -y \
        wget \
        bzip2 \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/texlive

COPY .latexmkrc /root/

ENTRYPOINT [ "latexmk" ]
