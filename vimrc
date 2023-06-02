" Override default python with the one in our path. This allows us to pick
" up on python virtual environments.
let g:python_host_prog = exepath("python")
let g:python3_host_prog = exepath("python3")

let g:coc_disable_startup_warning = 1

" polyglot
let g:polyglot_disabled = ['go', 'python', 'cpp']

call plug#begin('~/.vim/bundle')
" Plug 'SirVer/ultisnips         " snippets
Plug 'neoclide/coc.nvim', has('nvim') ? {'branch': 'release' } : { 'on': [] }
Plug 'chrisbra/unicode.vim'    " unicode
Plug 'ctrlpvim/ctrlp.vim'      " file browser
Plug 'tacahiroy/ctrlp-funky'   " ctrlp with symbols
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" Plug 'jlanzarotta/bufexplorer'  " browse buffers
Plug 'michaeljsmith/vim-indent-object'  " text objects based on indents
" Plug 'junegunn/gv.vim', { 'on': 'GV' }  " git log
Plug 'majutsushi/tagbar', { 'on': 'Tagbar' }  " browse symbols
Plug 'liuchengxu/vista.vim', { 'on': 'Vista' }
Plug 'christoomey/vim-tmux-navigator'  " tmux integration
Plug 'melonmanchan/vim-tmux-resizer'   " tmux integration
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'sheerun/vim-polyglot'     " general syntax hilighting
Plug 'tpope/vim-abolish'        " word substitution
Plug 'tpope/vim-dispatch'       " asynchronous make
Plug 'tpope/vim-fugitive'       " git commands
Plug 'tpope/vim-sensible'       " sensible defaults
Plug 'tpope/vim-unimpaired'     " paired commands
Plug 'tpope/vim-rhubarb'        " github integration
Plug 'vim-scripts/rcsvers.vim'  " backups
Plug 'python/black', {'tag': '19.10b0' }
Plug 'jpalardy/vim-slime'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'agude/vim-eldar'
call plug#end()

" enable file type detection and load indent files
filetype plugin indent on

set cmdheight=2
set completeopt+=preview
set dir=~/tmp,/var/tmp,/tmp,.  " prefer swapfiles on local directories to avoid NFS problems
set expandtab           " tabs are spaces
set formatoptions+=nr   " n: try to recongnize lists, r: insert comment leader
set foldmethod=indent   " fold based on indent
set foldnestmax=3       " set deepest fold
set guioptions-=T       " no tool bar in GUI
set guioptions-=m       " no menu bar in GUI
set hidden              " hide abandoned buffers instead of closing them
set hlsearch            " highlight last search pattern
set ignorecase          " ignore case for searches
set noequalalways       " don't make splits equal sizes
set noerrorbells        " no noise
set nofoldenable        " don't fold by default
set nomodeline          " security
set noshowmode          " hide mode display
set shiftwidth=2 softtabstop=2 tabstop=8
set shortmess+=I        " disable startup messge
set shortmess+=c        " disable ins-completion-menu messages
set showmatch
set smartcase           " case sensitive search if term is mixed case
set signcolumn=yes      " always show signcolumn otherwise text shifts on load
set ttimeout
set ttimeoutlen=50
set ttyfast
set undodir=~/.vim-data/undo
set undofile
set updatetime=300      " default is 4000
set viminfo=%,'50       " save buffers, 50 marks
set visualbell          " just blink screen instead
set whichwrap=b,s,<,>,[,] " let us move between lines in insert mode
set wildignorecase
set wildmode=longest,full  " when doing tab completion act like bash/emacs
set termguicolors
set nojoinspaces        " one space after period when joining text lines
let mapleader="\<space>"

" switch syntax highlighting on, when term has colors
if &t_Co > 2 || has("gui_running")
  syntax on
  colorscheme torte
  highlight Pmenu ctermbg=gray guibg=gray
  highlight CocErrorSign ctermfg=DarkRed cterm=bold guifg=DarkRed gui=bold
endif

set comments^="#,"

" enable autospell check
autocmd filetype tex setlocal spell spelllang=en_us
autocmd filetype mail setlocal spell spelllang=en_us
autocmd filetype doc setlocal spell spelllang=en_us
autocmd filetype gitcommit setlocal spell textwidth=72
" disable spellcheck for CMakeLists.txt
autocmd filetype cmake setlocal nospell

autocmd Filetype c,cpp,h,hpp set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,bO:///,O://

" automatically jump to mark when file is opened
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

" define macro that expands to current directory of opened file
if has("unix")
  cmap %/ <C-R>=expand("%:p:h") . '/'<CR>
else
  cmap %/ <C-R>=expand("%:p:h") . '\'<CR>
endif

autocmd BufReadPost quickfix set modifiable

" ******************************************
" Plugin options
" ******************************************

" coc
function! CheckBackSpace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Insert <tab> when previous text is space, refresh completion if not.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackSpace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gn <Plug>(coc-rename)
nmap <silent> ga <Plug>(coc-codeaction)
nmap <silent> gf <Plug>(coc-fix-current)

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Use K for show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

" rcsvers.vim
" save RCS files to a common directory
let g:rvSaveDirectoryType = 1
let g:rvSaveDirectoryName = $HOME . '/.vim-data/rcs/'

" NERD_tree.vim
if $LC_ALL == 'C'
  let g:NERDTreeDirArrows=0
endif
let NERDTreeWinPos = 'right'

" cltlp
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_working_path_mode = 'ra'

" go
autocmd FileType go setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=0 textwidth=80

" python
" set line length manually because vim-black does not read from pyproject.toml
" like cli-black does.
let g:black_linelength = 120

" tagbar + vim-go
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

" UltiSnips
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<s-c-j>"

" fzf
nmap <Leader>fb :Buffers<CR>
nmap <Leader>fw :Windows<CR>
nmap <Leader>fl :Lines<CR>
nmap <Leader>ff :Files<CR>
nmap <Leader>fh :History:<CR>

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }


" vim-slime
let g:slime_no_mappings = 1
let g:slime_target = "tmux"
xmap <leader>tt <Plug>SlimeRegionSend
nmap <leader>tp <Plug>SlimeParagraphSend
nmap <leader>tc <Plug>SlimeConfig

" terminal: Esc also returns to normal mode
tnoremap <Esc> <C-\><C-n>
