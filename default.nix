{
  pkgs ?
    let
      lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
      nixpkgs = fetchTarball {
        url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
        sha256 = lock.narHash;
      };
    in
    import nixpkgs { overlays = [ ]; },
  ...
}:
let
  # Manifest data
  manifest = pkgs.lib.importJSON ./package.json;

  # Source code
  source = ./.;
in
pkgs.stdenv.mkDerivation {
  pname = manifest.name;
  version = manifest.version;

  # Sauce
  src = source;

  nativeBuildInputs = with pkgs; [
    nodejs_22
    pnpmConfigHook
    pnpm
    vips
  ];

  buildPhase = ''
    # Build the package
    pnpm build
  '';

  installPhase = ''
    # Create output directory
    mkdir -p $out

    # Move all contents
    cp -r ./dist/* $out
  '';

  pnpmDeps = pkgs.fetchPnpmDeps {
    pname = manifest.name;
    version = manifest.version;
    src = source;
    fetcherVersion = 3;
    hash = "sha256-3s3hoMIlM/97wPfKwW3HBToZzftcq6sg5wZ4BOs4NI0=";
  };

  meta = with pkgs.lib; {
    homepage = "https://gate.oss.uzinfocom.uz";
    mainProgram = "${manifest.name}-start";
    description = "Gate Website for OSS Uzinfocom";
    license = with licenses; [ cc0 ];
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ orzklv ];
  };
}
