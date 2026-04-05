{ config, pkgs, ... }:

{
  home.username = "tientn";
  home.homeDirectory = "/home/tientn";

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";

    GOPATH = "${config.home.homeDirectory}/go";
    #ZDOTDIR = "${config.home.homeDirectory}/.config/zsh";

    # npm global user dir
    NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";

    # Codex / OpenCode tiện dùng trong WSL
    OPENCODE_EDITOR = "nvim";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/go/bin"
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.npm-global/bin"
  ];

  home.packages = with pkgs; [
    # Core tools
    curl
    wget
    jq
    unzip
    zip
    gnutar
    gzip
    xz
    tree
    fd
    ripgrep
    eza

    # Build / CLI
    gcc
    gnumake
    pkg-config

    # Languages
    go
    nodejs_22
    pnpm
    yarn
    bun
    python3
    python3Packages.pip
    python3Packages.virtualenv
    uv

    # JS / TS ecosystem helpers
    typescript
    typescript-language-server
    vscode-langservers-extracted
    nodePackages.prettier
    nodePackages.eslint

    # Go tools
    gopls
    delve
    gotools
    gofumpt

    # Python tools
    pyright
    ruff
    black
    basedpyright

    # Neovim / NvChad requirements
    tree-sitter
    lua-language-server
    stylua
    nil
    nixfmt-rfc-style

    # Clipboard
    xclip
    luarocks
    python3Packages.pynvim
    nodePackages.neovim
    bubblewrap

    lazygit
    lazydocker
    delta

    tmux
  ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "eza -la";
      v = "nvim";
      gs = "git status";
      hm = "home-manager switch --flake ~/nix-config#tientn";
      cx = "codex";
      oc = "opencode";
      ld = "lazydocker";
      lg = "lazygit";
      t = "tmux";
      ta = "tmux attach";
      tn = "tmux new -s dev";
    };
    initContent = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      # load config nếu có
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
      export PATH="$HOME/.local/bin:$HOME/go/bin:$PATH"
      export PATH=/home/tientn/.opencode/bin:$PATH
    '';
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "eza -la";
      v = "nvim";
      gs = "git status";
      hm = "home-manager switch --flake ~/nix-config#tientn";
      cx = "codex";
      oc = "opencode";
      ld = "lazydocker";
      lg = "lazygit";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Tran Tien";
      user.email = "trannhattien.284@gmail.com";
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";

      delta = {
        navigate = true;
        light = false;
        side-by-side = true;
        line-numbers = true;
        syntax-theme = "Dracula";
      };
    };
  };

  programs.lazygit = {
    enable = true;

    settings = {
      git = {
        pagers = [
          {
            colorArg = "always";
            pager = ''delta --dark --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format="lazygit-edit://{path}:{line}"'';
          }
        ];
      };
    };
  };
  programs.fzf.enable = true;
  programs.bat.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}
