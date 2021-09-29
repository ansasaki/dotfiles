" Set encoding
if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=ucs-bom,utf-8,latin1
endif

set nocompatible	" Use Vim defaults (much better!)

" Allow backspacing over everything in insert mode
set bs=indent,eol,start

" Keep backup file
set backup		" keep a backup file

" Read/write a .viminfo file, store 50 lines of registers
set viminfo='20,\"50

" Set history to 50 lines
set history=50

" Show the cursor position all the time
set ruler

" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup fedora
  autocmd!
  " In text files, always limit the width of text to 80 characters
  autocmd BufRead *.txt set tw=80
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  " don't write swapfile on most commonly used directories for NFS mounts or USB sticks
  autocmd BufNewFile,BufReadPre /media/*,/run/media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp
  " start with spec file template
  autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec
  augroup END
endif

" If cscope is available, load the file and set mappings
if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add $PWD/cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb

   " cscope search:
   "
   "   's'   symbol: find all references to the token under cursor
   "   'g'   global: find global definition(s) of the token under cursor
   "   'c'   calls:  find all calls to the function name under cursor
   "   't'   text:   find all instances of the text under cursor
   "   'e'   egrep:  egrep search for the word under cursor
   "   'f'   file:   open the filename under cursor
   "   'i'   includes: find files that include the filename under cursor
   "   'd'   called: find functions that function under cursor calls
   "   'S'   struct: find struct definition under cursor

   " Map ctrl + space to start cscope search
   nmap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>
   nmap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>
   nmap <C-@>c :cs find c <C-R>=expand("<cword>")<CR><CR>
   nmap <C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR>
   nmap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>
   nmap <C-@>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
   nmap <C-@>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
   nmap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>
   nmap <C-@>S :cs find t struct <C-R>=expand("<cword>")<CR> {<CR>

endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Detect file type and load plugin for syntax highlight
filetype plugin on

if &term=="xterm"
     set t_Co=8
     set t_Sb=[4%dm
     set t_Sf=[3%dm
endif

" Don't wake up system with blinking cursor:
" http://www.linuxpowertop.org/known.php
let &guicursor = &guicursor . ",a:blinkon0"

" Show numbers
set nu

" Set mouse support
set mouse=a

" Set tab to appear 4-spaces wide
set tabstop=4

" Set indentation to 4 spaces
set shiftwidth=4

" Replace tab with spaces
set expandtab

" Automatically indent when editting
set autoindent

" Limit the text to 80 characters
set textwidth=80

" To display invisible trailing whitespaces
if has("syntax") && (&t_Co > 2 || has("gui_running"))
    syntax on
    function! ActivateInvisibleCharIndicator()
        syntax match TrailingSpace "[ \t]\+$" display containedin=ALL
        highlight TrailingSpace ctermbg=Red
    endf
    autocmd BufNewFile,BufRead * call ActivateInvisibleCharIndicator()
endif
" Show tabs, trailing whitespace, and continued lines visually
set list listchars=tab:»·,trail:·,extends:…

" highlight overly long lines same as TODOs.
autocmd BufNewFile,BufRead *.c,*.h exec 'match Todo /\%>' . &textwidth . 'v.\+/'

" Crete new tab
nmap <leader>t :tabnew<CR>

" Move current tab left
nmap <leader>H :-tabmove<CR>

" Move current tab right
nmap <leader>L :+tabmove<CR>

" Move to previous tab
nmap gr :tabprevious<CR>

" YouCompleteMe GoTo command
nmap <leader>g :YcmCompleter GoTo<CR>

" FZF configuration
let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore-vcs --hidden'
noremap <leader>o :Files<CR>
noremap <leader>oh :Files ~<CR>
noremap <leader>or :FZF --reverse<CR>
noremap <leader>og :GFiles<CR>
noremap <leader>b :Buffers<CR>

" Folding settings
set foldmethod=syntax
set foldnestmax=10
set nofoldenable
set foldlevel=2

" Set view settings (what is saved)
set viewoptions=cursor,folds,slash,unix
" let g:skipview_files = ['*\.vim'] 

" Using plugin manager: https://github.com/junegunn/vim-plug
" Plugins are stored in ~/.vim/plugged
" Reload .vimrc and :PlugInstall to install plugins.
call plug#begin('~/.vim/plugged')

    " Show changes when in a git repository
    Plug 'mhinz/vim-signify'

    " Code completion engine
    Plug 'ycm-core/YouCompleteMe'

    " Pretty status
    Plug 'vim-airline/vim-airline'

    " Fuzzy search files
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    " Automatically loads/stores vim views (e.g. folding)
    Plug 'vim-scripts/restore_view.vim'

    " Git integration
    Plug 'tpope/vim-fugitive'

    " Doxygen documentation generation helper
    Plug 'vim-scripts/DoxygenToolkit.vim'

    " Allow merging tabs back to splits
    Plug 'vim-scripts/Tabmerge'

    " Markdown syntax highlight
    Plug 'plasticboy/vim-markdown'

    " Markdown preview
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

    " Quickly align matching pattern
    " e.g. To align '=' in assignment sequence
    " :Tabularize /=
    " Match next character after ':'
    " :Tabularize /:\zs
    Plug 'godlygeek/tabular'

call plug#end()
