# Valou's dotfiles

My dotfiles, managed by [Dotbot](https://github.com/anishathalye/dotbot).

## Installation

```bash
git clone --recursive https://github.com/vbriand/dotfiles
```

For installing a predefined profile:

```bash
./install-profile.sh <profile> [<configs...>]
# See meta/profiles/ for available profiles
```

For installing single configurations:

```bash
./install-standalone.sh <configs...>
# See meta/configs/ for available configurations
```

The installation scripts are idempotent and can therefore be executed safely multiple times.

## Inspiration (thanks!)

- [magicmonty](https://github.com/magicmonty/dotfiles_dotbot), [vsund](https://github.com/vsund/dotfiles) and [vbrandl](https://github.com/vbrandl/dotfiles) for their repository structure
- [mathiasbynens](https://github.com/mathiasbynens/dotfiles) for his `.macos`
