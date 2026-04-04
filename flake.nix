{
  description = "My neovim configuration for Nix using Nixvim.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = {
    self,
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
          settings = {
            flavour = "mocha";
            integrations = {
              cmp = false;
              gitsigns = true;
              nvimtree = false;
              treesitter = false;
              notify = false;
            };
          };
        };
        lsp.servers = {
          # BASED (FP chads)
          hls.enable = true; # Haskell, the pinnacle
          elmls.enable = false; # Elm, pure and correct
          nixd.enable = true; # Nix, functional deity
          ocamllsp.enable = false; # OCaml, Haskell's more employable cousin
          elixirls.enable = false; # Elixir, Erlang but you actually enjoy it
          clojure_lsp.enable = false; # Clojure, lisp galaxy brain
          fsautocomplete.enable = false; # F#, based but Microsoft tainted
          metals.enable = false; # Scala, FP on a JVM cope machine
          rust_analyzer.enable = true; # Rust, honorary FP, based af
          # unison.enable = true;                       # Unison, too ahead of its time for NixVim

          # NECESSARY EVILS
          ts_ls.enable = true; # TypeScript / JavaScript, it has map() so we allow it
          tailwindcss.enable = true; # Tailwind, utility class sorcery
          taplo.enable = true; # TOML, your Cargo.toml sherpa
          sqls.enable = true; # SQL, ancient and humbling
          jsonls.enable = true; # JSON, at least its not XML
          cssls.enable = true; # CSS, declarative so we tolerate it
          html.enable = true; # HTML, not even a language but ok
          docker_compose_language_service.enable = true; # Docker Compose, yaml suffering
          docker_language_server.enable = true; # Dockerfile, more yaml suffering

          # INFERIOR (OOP/imperative degenerates)
          clangd.enable = true; # C / C++, you enjoy pain
          ruby_lsp.enable = false; # Ruby, made for humans
          yamlls.enable = false; # YAML, suffering in schema form
          lua_ls.enable = false; # Lua, for when you miss Neovim configs
          gopls.enable = false; # Go, no generics for 10 years
          pyright.enable = false; # Python, god forbid
          kotlin_language_server.enable = false; # Kotlin, Java but with lip gloss
          jdtls.enable = false; # Java, the original sin
        };

        plugins = {
          lspconfig.enable = true;
          lsp-format.enable = true;
        };
      };
    });
  };
}
