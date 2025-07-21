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

  # Source code
  source = ./.;

  # JetBrains Mono font for local font provision
  jetbrains-mono = pkgs.google-fonts.override {fonts = ["JetBrainsMono"];};
in
  pkgs.stdenv.mkDerivation {
    pname = manifest.name;
    version = manifest.version;

    # Sauce
    src = source;

    nativeBuildInputs = [
      pkgs.nodejs_22
      pkgs.pnpm.configHook
    ];

    # Override when necessary
    NEXT_PUBLIC_SITE_URL = "https://gate.oss.uzinfocom.uz";

    buildPhase = ''
      # Copy necessary fonts
      cp                                                                 \
        "${jetbrains-mono}/share/fonts/truetype/JetBrainsMono[wght].ttf" \
        ./src/app/JetBrainsMono.ttf

      # Build the package
      pnpm build
    '';

    installPhase = ''
      # Create output directory
      mkdir -p $out

      # Move all contents
      cp -r ./out $out
    '';

    pnpmDeps = pkgs.pnpm.fetchDeps {
      pname = manifest.name;
      version = manifest.version;
      src = source;
      hash = "sha256-BDnJWgVMaLo5m4SCpbkfSwqxewRXzCxz7OIv1mK7rQg=";
    };

    meta = with pkgs.lib; {
      homepage = "https://gate.oss.uzinfocom.uz";
      mainProgram = "${manifest.name}-start";
      description = "Gate Website for OSS Uzinfocom";
      license = with licenses; [cc0];
      platforms = with platforms; linux ++ darwin;
      maintainers = with maintainers; [orzklv];
    };
  }
