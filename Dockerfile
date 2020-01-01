FROM ubuntu:18.04 AS download-files

RUN apt-get update && apt-get install -y \
    wget

WORKDIR /src

RUN wget -O jlisting.sty.bz2 'https://osdn.net/frs/redir.php?m=jaist&f=mytexpert%2F26068%2Fjlisting.sty.bz2'
RUN bunzip2 jlisting.sty.bz2

FROM paperist/alpine-texlive-ja

RUN apk update && apk --no-cache add --virtual .install-deps \
        # libxaw-dev \
        wget \
    && tlmgr update --self --all \
    && tlmgr install siunitx \
    && apk del .install-deps

COPY --from=download-files /src/jlisting.sty /usr/local/texlive/2019/texmf-dist/tex/latex/listings/
COPY .latexmkrc /root/

ENTRYPOINT [ "latexmk" ]
