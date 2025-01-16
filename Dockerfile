FROM ghcr.io/paperist/texlive-ja:latest@sha256:4c76f75916fbab1d9b6a0528be37cf4967ed993beb9906908c390632ca7db153

RUN set -x \
    && apt-get update && apt-get install -y \
        wget \
        bzip2 \
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
