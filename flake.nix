{
  description = "My neovim configuration for Nix using Nixvim.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = {
    nixpkgs,
    nixvim,
    ...
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: {
      default = nixvim.legacyPackages.${system}.makeNixvim {
        colorschemes.catppuccin = {
          enable = true;
          settings.flavour = "mocha";
        };
      };
    });
  };
}
