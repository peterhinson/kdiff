FROM ocaml/opam:debian-10-ocaml-4.09 AS ocaml-base
RUN sudo apt update && sudo apt install -y pkg-config libgmp-dev
WORKDIR /plotkicadsch
COPY ./plotkicadsch .
RUN eval $(opam env) \
  && opam pin add -y kicadsch . \
  && opam pin add -y plotkicadsch . \
  && opam update \
  && opam install --destdir=./build -y plotkicadsch


FROM python:3.7-slim-buster as app
RUN apt update && apt install -y --no-install-recommends git python-tk kicad dos2unix coreutils bc 
RUN pip install --no-cache-dir pygubu python_dateutil tk
WORKDIR /kdiff
COPY . .
COPY --from=ocaml-base /plotkicadsch/build/bin /kdiff/bin

# remove the plotkicadsch repo and copy the binaries from the build stage
RUN rm -rf /kdiff/plotkicadsch

# Set PATH 
ENV PATH $PATH:/kdiff/KiCad-Diff:/kdiff:/kdiff/bin

WORKDIR /build

ENTRYPOINT ["/kdiff/kdiff"]
CMD [ "*.pro" ]
