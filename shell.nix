{
  pkgs ? let
    lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
    nixpkgs = fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    };
  in
    import nixpkgs {overlays = [];},
  ...
}: let
  # Manifest data
  manifest = pkgs.lib.importJSON ./package.json;

  jetbrains-mono = pkgs.google-fonts.override {fonts = ["JetBrainsMono"];};
in
  pkgs.stdenv.mkDerivation {
    name = "${manifest.name}-shell";

    buildInputs = with pkgs; [
      # Package managers
      yarn
      yarn2nix

      # Runtime engines
      nodejs_22

      # Nextjs dependencies
      vips

      # Nix
      nixd
      statix
      deadnix
      alejandra
    ];

    # For local development
    NEXT_PUBLIC_SITE_URL = "http://localhost:3000";

    shellHook = ''
      printf "Installing pnpm dependencies\n"
      yarn install

      printf "Adding node_modules to PATH\n"
      export PATH="$PWD/node_modules/.bin/:$PATH"

      printf "Adding necessary aliases\n"
      alias scripts='jq ".scripts" package.json'

      printf "Copying necessary fonts\n"
      cp                                                                 \
        "${jetbrains-mono}/share/fonts/truetype/JetBrainsMono[wght].ttf" \
        ./src/app/JetBrainsMono.ttf
    '';
  }
