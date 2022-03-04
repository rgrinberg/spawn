INSTALL_ARGS := $(if $(PREFIX),--prefix $(PREFIX),)

# Default rule
default:
	dune build @install

install:
	dune install $(INSTALL_ARGS)

uninstall:
	dune uninstall $(INSTALL_ARGS)

reinstall: uninstall reinstall

all-supported-ocaml-versions:
	dune build @install @runtest --workspace dune-workspace.dev

clean:
	dune clean

test:
	dune runtest

promote:
	dune promote

fmt:
	dune build @fmt --auto-promote

.PHONY: nix/opam-selection.nix
nix/opam-selection.nix:
	nix-shell -A resolve default.nix

.PHONY: default install uninstall reinstall clean test
