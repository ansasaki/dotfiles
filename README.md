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
autopep8 (python3-autopep8)
powerlevel10k
nodejs
```

Copy ``./bin`` to ``~/bin``

# Install zsh
```
$ sudo dnf install zsh
$ sudo dnf install zsh-syntax-highlighting
$ sudo dnf install zsh-autosuggestions
$ touch ~/.aliases
```

# Install ohmyzsh
```
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

# Install powerlevel10k
```
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

# Install auto-completion:

```
$ git clone https://github.com/rust-analyzer/rust-analyzer.git && cd rust-analyzer
$ cargo xtask install --server
```

# Install vim-plug plugin management
```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Copy ``coc-settings.json`` to ``.vim`` directory

## On vim
```
:CocInstall coc-rust-analyzer
:CocInstall coc-pyright
:CocInstall coc-clangd
:CocInstall coc-tsserver
```
