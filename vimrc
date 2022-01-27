" Set encoding
if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=ucs-bom,utf-8,latin1
endif

set nocompatible	" Use Vim defaults (much better!)

" Allow backspacing over everything in insert mode
set bs=indent,eol,start

" Read/write a .viminfo file, store 50 lines of registers
set viminfo='20,\"50

" Set history to 50 lines
set history=50

" Show the cursor position all the time
set ruler

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Keep backup file
" set backup		" keep a backup file

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  "set signcolumn=number
  set signcolumn=auto
else
  set signcolumn=yes
endif

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

" Set dark background
set background=dark

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
nmap gw :tabprevious<CR>

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

    " Install colorschemes
    Plug 'flazz/vim-colorschemes'

    " Show changes when in a git repository
    Plug 'mhinz/vim-signify'

    " Code completion with coc
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

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

" Set colorscheme (colorschemes come from plugins, thus needs to be after plugin
" loading)
colorscheme gruvbox

" Use <c-space> to trigger completion.
if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . " " . expand('<cword>')
    endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

