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

  # All source codes
  source = ./.;
in
  pkgs.mkYarnPackage {
    name = manifest.name;
    version = manifest.version;

    # Sauce
    src = source;

    # Yarn lock evals
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    yarnNix = ./yarn.nix;

    # Override when necessary
    NEXT_PUBLIC_SITE_URL = "https://gate.oss.uzinfocom.uz";

    preBuildPhase = ''
      cp "${
        pkgs.google-fonts.override {fonts = ["JetBrainsMono"];}
      }/share/fonts/truetype/JetBrainsMono[wght].ttf" ./src/app/JetBrainsMono.ttf
    '';

    buildPhase = ''
      yarn build
    '';

    installPhase = ''
      cp -r ./out $out
    '';

    meta = with pkgs.lib; {
      homepage = "https://gate.oss.uzinfocom.uz";
      mainProgram = "${manifest.name}-start";
      description = "Gate Website for OSS Uzinfocom";
      license = with licenses; [cc0];
      platforms = with platforms; linux ++ darwin;
      maintainers = with maintainers; [orzklv];
    };
  }
