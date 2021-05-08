FROM ubuntu:18.04 AS download-files

RUN apt-get update && apt-get install -y \
    wget

WORKDIR /src

RUN wget -O jlisting.sty.bz2 'https://osdn.net/frs/redir.php?m=jaist&f=mytexpert%2F26068%2Fjlisting.sty.bz2'
RUN bunzip2 jlisting.sty.bz2

FROM paperist/alpine-texlive-ja

COPY --from=download-files /src/jlisting.sty /usr/local/texlive/2020/texmf-dist/tex/latex/listings/
RUN set -x \
    && apk update && apk --no-cache add --virtual .install-deps wget \
    && curl -O 'https://ctan.math.washington.edu/tex-archive/systems/texlive/tlnet/update-tlmgr-latest.sh' \
    && chmod +x update-tlmgr-latest.sh \
    && ./update-tlmgr-latest.sh \
    && tlmgr update --self --all \
    && tlmgr install siunitx \
    && apk del .install-deps \
    && mktexlsr

COPY .latexmkrc /root/

ENTRYPOINT [ "latexmk" ]
