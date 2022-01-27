# dotfiles
my dotfiles

# Requires:

```
zsh
oh-my-zsh
vim
vimx
fzf
rg (ripgrep)
highlight
```

Copy ``./bin`` to ``~/bin``

# Install auto-completion for rust and python:

```
$ git clone https://github.com/rust-analyzer/rust-analyzer.git && cd rust-analyzer
$ cargo xtask install --server
```

Copy ``coc-settings.json`` to ``.vim`` directory

## On vim
```
:CocInstall coc-rust-analyzer
:CocInstall coc-pyright
```
