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
              treesitter = true;
              notify = true;
              telescope = true;
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
          #lsp
          lspconfig.enable = true;
          lsp-format.enable = true;

          #ui
          lualine = {
            enable = true;
            settings = {
              options.theme = "onedark"; # NOTE: dracula | gruvbox | onedark | catppuccin
              sections.lualine_x = [
                {
                  __raw = ''
                    function()
                      local clients = vim.lsp.get_clients({ bufnr = 0 })
                      if #clients == 0 then return "" end
                      return "󰒍 " .. table.concat(vim.tbl_map(function(c) return c.name end, clients), ", ")
                    end
                  '';
                }
                "encoding"
                "fileformat"
                "filetype"
              ];
            };
          };
          web-devicons.enable = true;
          blink-indent.enable = true;
          colorizer.enable = true;
          notify.enable = true;
          barbecue.enable = true;
          illuminate.enable = true;
          colorful-menu.enable = true;

          #git
          lazygit.enable = true;
          gitsigns.enable = true;

          #nav
          harpoon = {
            enable = true;
            enableTelescope = true;
          };
          telescope = {
            enable = true;
            settings = {
              defaults = {
                sorting_strategy = "ascending";
                layout_config = {
                  prompt_position = "top";
                };
              };
            };
            keymaps = {
              "<leader>ff" = "find_files";
              "<leader>fg" = "live_grep";
              "<leader>fb" = "buffers";
              "<leader>fh" = "help_tags";
            };
          };
          neo-tree.enable = true;
          undotree.enable = true;
          comfy-line-numbers.enable = true;

          #editor
          friendly-snippets.enable = true;
          blink-cmp = {
            enable = true;
            settings = {
              sources.default = ["lsp" "path" "snippets" "buffer"];
              keymap = {
                preset = "none";
                "<Tab>" = ["select_next" "fallback"];
                "<S-Tab>" = ["select_prev" "fallback"];
                "<CR>" = ["accept" "fallback"];
                "<C-Space>" = ["show" "fallback"];
                "<C-e>" = ["cancel" "fallback"];
              };
            };
          };
          blink-cmp-copilot.enable = false;
          blink-pairs.enable = true;

          #debug

          #misc
          treesitter = {
            enable = true;
            settings = {
              highlight.enable = true;
              indent.enable = true;
            };
          };
          todo-comments.enable = true;
          leetcode.enable = true;
          neocord.enable = true;
        };

        globals.mapleader = " ";
        opts = {
          smartindent = true;
          autoindent = true;
          backup = false;
          clipboard = "unnamedplus";
          cmdheight = 1;
          conceallevel = 0;
          fileencoding = "utf-8";
          foldmethod = "manual";
          foldexpr = "";
          guifont = "monospace:h17";
          hidden = true;
          hlsearch = true;
          ignorecase = true;
          mouse = "a";
          pumheight = 10;
          showmode = false;
          smartcase = true;
          splitbelow = true;
          splitright = true;
          swapfile = false;
          termguicolors = true;
          timeoutlen = 1000;
          title = true;
          undofile = true;
          updatetime = 100;
          writebackup = false;
          expandtab = true;
          shiftwidth = 2;
          tabstop = 2;
          cursorline = true;
          number = true;
          numberwidth = 4;
          signcolumn = "yes";
          wrap = false;
          scrolloff = 8;
          sidescrolloff = 8;
          showcmd = false;
          ruler = false;
          relativenumber = true;
          laststatus = 3;
        };
        keymaps = [
          {
            key = "<C-s>";
            mode = "n";
            action = ":w<CR>";
            options.silent = false;
          }
          {
            key = "<C-l>";
            mode = "i";
            action = "<Right>";
            options.silent = false;
          }
          {
            key = "<M-o>";
            mode = "n";
            action = ":normal! o<CR>";
            options.silent = false;
          }
          {
            key = "<M-O>";
            mode = "n";
            action = ":normal! O<CR>";
            options.silent = false;
          }
          {
            key = "<leader>n";
            mode = "n";
            action = ":set relativenumber!<CR>";
            options.silent = false;
          }
          {
            key = "<leader>gg";
            mode = "n";
            action = ":LazyGit<CR>";
            options.silent = true;
          }
          {
            key = "<Leader>lsp";
            mode = "n";
            action = ":LspInfo<CR>";
            options.silent = false;
          }
          {
            key = "<leader>rn";
            mode = "n";
            action = "<cmd>lua vim.lsp.buf.rename()<CR>";
            options.silent = false;
          }
          {
            key = "<leader>d";
            mode = "n";
            action = "<cmd>lua vim.diagnostic.open_float()<cr>";
            options.silent = false;
          }
          {
            key = "<leader>E";
            mode = "n";
            action = ":e!<cr>";
            options.silent = false;
          }
          {
            key = "<M-j>";
            mode = "n";
            action = ":m '>+1<CR>gv=gv";
            options.silent = false;
          }
          {
            key = "<M-k>";
            mode = "n";
            action = ":m '<-2<CR>gv=gv";
            options.silent = false;
          }
          {
            key = "J";
            mode = "n";
            action = "mzJ`z";
            options.silent = false;
          }
          {
            key = "<C-d>";
            mode = "n";
            action = "<C-d>zz";
            options.silent = false;
          }
          {
            key = "<C-u>";
            mode = "n";
            action = "<C-u>zz";
            options.silent = false;
          }
          {
            key = "n";
            mode = "n";
            action = "nzzzv";
            options.silent = false;
          }
          {
            key = "N";
            mode = "n";
            action = "Nzzzv";
            options.silent = false;
          }
          {
            key = "Q";
            mode = "n";
            action = "<nop>";
            options.silent = false;
          }
          {
            key = "<leader>s";
            mode = "n";
            action = ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>";
            options.silent = false;
          }
          {
            key = "<leader>e";
            mode = "n";
            action = ":Neotree left<CR>";
            options.silent = true;
          }
          {
            key = "<F5>";
            mode = "n";
            action = ":UndotreeToggle<CR>";
            options.silent = true;
          }
          # harpoon
          {
            key = "<leader>a";
            mode = "n";
            action.__raw = "function() require('harpoon'):list():add() end";
            options.silent = true;
            options.desc = "Harpoon: Add file";
          }
          {
            key = "<C-e>";
            mode = "n";
            action.__raw = "function() local h = require('harpoon'); h.ui:toggle_quick_menu(h:list()) end";
            options.silent = true;
            options.desc = "Harpoon: Toggle menu";
          }
          {
            key = "<C-h>";
            mode = "n";
            action.__raw = "function() require('harpoon'):list():select(1) end";
            options.silent = true;
            options.desc = "Harpoon: File 1";
          }
          {
            key = "<C-j>";
            mode = "n";
            action.__raw = "function() require('harpoon'):list():select(2) end";
            options.silent = true;
            options.desc = "Harpoon: File 2";
          }
          {
            key = "<C-k>";
            mode = "n";
            action.__raw = "function() require('harpoon'):list():select(3) end";
            options.silent = true;
            options.desc = "Harpoon: File 3";
          }
          {
            key = "<C-l>";
            mode = "n";
            action.__raw = "function() require('harpoon'):list():select(4) end";
            options.silent = true;
            options.desc = "Harpoon: File 4";
          }
        ];
      };
    });
  };
}
