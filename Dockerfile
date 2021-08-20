FROM python:3.9

RUN apt update && apt install -y git libgmp-dev pkg-config opam python3-tk kicad dos2unix coreutils zenity bc
RUN pip install pygubu python_dateutil tk

# Initialize Opam
RUN opam init --disable-sandboxing -y && opam switch create 4.09.1 && opam switch 4.09.1 && eval $(opam env)

COPY . /kdiff
# Install plotkicadsch
RUN cd /kdiff/plotkicadsch \
    && opam pin add -y kicadsch . \
    && opam pin add -y plotkicadsch . \
    && opam update \
    && opam install -y plotkicadsch

# Set PATH 
ENV PATH $PATH:/kdiff/KiCad-Diff:/kdiff

WORKDIR /build

ENTRYPOINT ["/kdiff/kdiff"]
CMD [ "*.pro" ]
