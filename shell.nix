let
  pkgs = (import <nixpkgs> { });
  local = (import ./default.nix { });
  inherit (pkgs) stdenv lib;
  ocamlformat =
    let
      ocamlformat_version =
        let
          lists = pkgs.lib.lists;
          strings = pkgs.lib.strings;
          ocamlformat_config = strings.splitString "\n" (builtins.readFile ./.ocamlformat);
          prefix = "version=";
          ocamlformat_version_pred = line: strings.hasPrefix prefix line;
          version_line = lists.findFirst ocamlformat_version_pred "not_found" ocamlformat_config;
          version = strings.removePrefix prefix version_line;
        in
        builtins.replaceStrings ["."] ["_"] version;
    in builtins.getAttr ("ocamlformat_" + ocamlformat_version) pkgs;
in with local;

pkgs.mkShell {
  inputsFrom = [ spawn ];
  buildInputs = (with pkgs; [
    ocaml-ng.ocamlPackages_4_13.ocaml-lsp
  ]) ++ [ocamlformat] ++ (with opam; [
    # test
    ppx_expect
  ]);
}
