<p align="center">
    <img src=".github/assets/header.png" alt="Uzinfocom's {Gate}">
</p>

<p align="center">
    <h3 align="center">Just a static website to scare off curious mamkin hackers.</h3>
</p>

<p align="center">
    <img align="center" src="https://img.shields.io/github/languages/top/uzinfocom-org/gate?style=flat&logo=rust&logoColor=ffffff&labelColor=242424&color=242424" alt="Top Used Language">
    <a href="https://github.com/uzinfocom-org/gate/actions/workflows/test.yml"><img align="center" src="https://img.shields.io/github/actions/workflow/status/uzinfocom-org/gate/test.yml?style=flat&logo=github&logoColor=ffffff&labelColor=242424&color=242424" alt="Test CI"></a>
</p>

## About

Shits happend and sometimes we get unwanted guests in our website. In that case, we decided to develop a special web page to scare off crows from our lands.

## Features

- 3D aNiMaTeD
- Woah cool website
- Scaaaaarry...

## Development

The project has `shell.nix` which has development environment preconfigured already for you. Just open your
terminal and at the root of this project:

```bash
# Open in bash by default
nix develop

# If you want other shell
nix develop -c $SHELL

# Upon entering development environment for the first
# time, you'll be asked for your development telegram
# bot token, it will be written to .env file for more
# convenient dev env startups. Token is saved at .env
# file at the root of this project. You can change it
# whenever you want!

# After entering development environment, inside the
# env, you can open your editor, so your editor will
# read all $PATH and environmental variables, also
# your terminal inside your editor will adopt all
# variables, so, you can close terminal.

# Neovim
vim .

# VSCode
code .

# Zed Editor
zed .
```

The development environment has whatever you may need already, but feel free to add or remove whatever
inside `shell.nix`.

## Building

Well, there are two ways of building your project. You can either go with classic `pnpm build` way, but before that, make sure to enter development environment to have pnpm and all nodejs toolchain available in your PATH, you may do like that:

```bash
# Entering development environment
nix develop -c $SHELL

# Compile the project
pnpm build
```

Or, you can build your project via nix which will do all the dirty work for you. Just, in your terminal:

```bash
# Build in nix environment
nix build

# Static website contents are here:
ls -lah ./result
```

## Deploying (works only for flake based NixOS)

You have 2 ways of making use of this website.

### Referring directly to packages

Import the flake in your configuration via inputs:

```nix
{
  inputs = {
    # ...

    gate.url = "github:uzinfocom-org/gate";
  };
}
```

and then directly refer to any arch platform via any part of your configuration:

```nix
virtualHosts = {
  "example.com" = {
    forceSSL = true;
    enableACME = true;
    root = "${inputs.gate.packages.${pkgs.stdenv.hostPlatform}}";
  };
};
```

### Injecting via overlays

Also, you can inject this flake's package outputs into your nixpkgs packages via `overlays` and then make use of it as shown above!

## FAQ

### Why not use default.nix for devShell?

There's been cases when I wanted to reproduce totally different behaviors in development environment and
production build. This occurs quite a lot lately for some reason and because of that, I tend to keep
both shell.nix and default.nix to don't mix things up.

## Thanks

- [Orzklv](https://github.com/orzklv) - For making this happen

## License

This project is licensed under the MIT License - see the [LICENSE](license) file for details.

<p align="center">
    <img src=".github/assets/footer.png" alt="Uzinfocom's {Gate}">
</p>
