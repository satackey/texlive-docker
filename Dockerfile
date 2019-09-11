FROM paperist/alpine-texlive-ja


RUN tlmgr update --self --all \
    && tlmgr install siunitx
RUN apk --no-cache add libxaw-dev

COPY .latexmkrc /root/

CMD [ "latexmk" ]
