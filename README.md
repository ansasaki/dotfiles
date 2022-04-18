# dotfiles
my dotfiles

# Requires:

```
clangd
zsh
oh-my-zsh
vim
vimx
fzf
rg (ripgrep)
highlight
autopep8
```

Copy ``./bin`` to ``~/bin``

# Install auto-completion:

```
$ git clone https://github.com/rust-analyzer/rust-analyzer.git && cd rust-analyzer
$ cargo xtask install --server
```

Copy ``coc-settings.json`` to ``.vim`` directory

## On vim
```
:CocInstall coc-rust-analyzer
:CocInstall coc-pyright
:CocInstall coc-clangd
:CocInstall coc-tsserver
```
