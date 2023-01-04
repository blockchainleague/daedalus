{ inputs
, nodeImplementation ? "cardano"
, system
}:

let
  sources = import ./sources.nix;
  nixpkgs = inputs.nixpkgs.legacyPackages.${system};
  # TODO: can we use the filter in cardano-wallet instead?
  cleanSourceFilter = with pkgs.stdenv;
    name: type: let baseName = baseNameOf (toString name); in ! (
      # Filter out .git repo
      (type == "directory" && baseName == ".git") ||
      # Filter out editor backup / swap files.
      lib.hasSuffix "~" baseName ||
      builtins.match "^\\.sw[a-z]$" baseName != null ||
      builtins.match "^\\..*\\.sw[a-z]$" baseName != null ||

      # Filter out locally generated/downloaded things.
      baseName == "dist" ||
      baseName == "node_modules" ||

      # Filter out the files which I'm editing often.
      lib.hasSuffix ".nix" baseName ||
      lib.hasSuffix ".hs" baseName ||
      # Filter out nix-build result symlinks
      (type == "symlink" && lib.hasPrefix "result" baseName)
    );
  isDaedalus = name: false;
  pkgs = nixpkgs.pkgs;
  lib = pkgs.lib;
in
lib // {
  inherit sources pkgs isDaedalus cleanSourceFilter;
}
