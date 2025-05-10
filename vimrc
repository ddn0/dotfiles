call plug#begin('~/.vim/bundle')
Plug 'neovim/nvim-lspconfig'
Plug 'chrisbra/unicode.vim'    " unicode
Plug 'michaeljsmith/vim-indent-object'  " text objects based on indents
Plug 'liuchengxu/vista.vim', { 'on': 'Vista' } " tagbar replacement
Plug 'christoomey/vim-tmux-navigator'  " tmux integration
Plug 'melonmanchan/vim-tmux-resizer'   " tmux integration
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tpope/vim-abolish'        " word substitution (hint: cr)
Plug 'tpope/vim-dispatch'       " asynchronous make
Plug 'tpope/vim-fugitive'       " git commands
Plug 'tpope/vim-sensible'       " sensible defaults
Plug 'tpope/vim-unimpaired'     " paired commands
Plug 'tpope/vim-rhubarb'        " github integration
Plug 'vim-scripts/rcsvers.vim'  " backups
Plug 'jpalardy/vim-slime'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'         " search everywhere
Plug 'agude/vim-eldar'          " color theme
Plug 'leafOfTree/vim-svelte-plugin'

" organized lsp diagnostics
Plug 'folke/trouble.nvim', has('nvim') ? { }: { 'on': [] }
Plug 'kosayoda/nvim-lightbulb'

Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets'

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-nvim-lsp-document-symbol'
call plug#end()

" enable file type detection and load indent files
filetype plugin indent on

set completeopt=menu,menuone,preview,noselect
"set completeopt+=preview

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
if has('nvim')
  set undodir=~/.vim-data/nvim-undo
else
  set undodir=~/.vim-data/undo
endif
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

" Operations on unnamed register use the system clipboard
if has("unnamedplus")
    set clipboard=unnamedplus
else
    set clipboard=unnamed
endif

set comments^="#,"

" enable autospell check
autocmd filetype tex setlocal spell spelllang=en_us
autocmd filetype mail setlocal spell spelllang=en_us
autocmd filetype doc setlocal spell spelllang=en_us
autocmd filetype gitcommit setlocal spell textwidth=72
" disable spellcheck for CMakeLists.txt
autocmd filetype cmake setlocal nospell

autocmd Filetype c,cpp,h,hpp setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,bO:///,O://

" automatically jump to mark when file is opened
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

" define macro that expands to current directory of opened file
if has("unix")
  cmap %/ <C-R>=fnameescape(expand("%:p:h")) . '/'<CR>
else
  cmap %/ <C-R>=fnameescape(expand("%:p:h")) . '\'<CR>
endif

" terminal: Esc also returns to normal mode
tnoremap <Esc> <C-\><C-n>

" ******************************************
" Plugin options
" ******************************************

" ------------------------------------------
" vim-vsnip
" ------------------------------------------
" NOTE: You can use other key to expand snippet.
" Expand
"imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
"smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
" See https://github.com/hrsh7th/vim-vsnip/pull/50
nmap        s   <Plug>(vsnip-select-text)
xmap        s   <Plug>(vsnip-select-text)
nmap        S   <Plug>(vsnip-cut-text)
xmap        S   <Plug>(vsnip-cut-text)

" If you want to use snippet for multiple filetypes, you can `g:vsnip_filetypes` for it.
let g:vsnip_filetypes = {}
let g:vsnip_filetypes.svelte = ['javascript']
let g:vsnip_filetypes.svelte = ['typescript']

" ------------------------------------------
" rcsvers.vim
" ------------------------------------------
" save RCS files to a common directory
let g:rvSaveDirectoryType = 1
let g:rvSaveDirectoryName = $HOME . '/.vim-data/rcs/'

" ------------------------------------------
" NERD_tree.vim
" ------------------------------------------
if $LC_ALL == 'C'
  let g:NERDTreeDirArrows=0
endif
let NERDTreeWinPos = 'right'

" ------------------------------------------
" go
" ------------------------------------------
autocmd FileType go setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=0 textwidth=80

" ------------------------------------------
" python
" ------------------------------------------
autocmd FileType python setlocal makeprg=pyright nospell

" ------------------------------------------
" js/ts
" ------------------------------------------
autocmd FileType javascript,typescript,svelte,typescriptreact setlocal
      \  noexpandtab shiftwidth=2 tabstop=2 softtabstop=0 textwidth=120
autocmd FileType javascript,typescript,svelte,typescriptreact setlocal makeprg=npm\ run\ $*
" Decoding errorformat:
"   %E          begin multiline error message
"    %f:%l:%c   filename:line:col
"    ,%Z        continuation of multiline error message
"    %m         message
autocmd FileType javascript,typescript,svelte,typescriptreact setlocal errorformat=%E%f:%l:%c,%Z%m

" ------------------------------------------
" vista
" ------------------------------------------
let g:vista_default_executive = 'nvim_lsp'
let g:vista_fzf_preview = ['right:50%']
let g:vista_executive_for = {
  \ 'svelte': 'nvim_lsp',
  \ 'ts': 'nvim_lsp',
  \ }

" ------------------------------------------
" fzf
" ------------------------------------------
nmap <Leader>fb :Buffers<CR>
nmap <Leader>fg :GF?<CR>
nmap <Leader>fr :RG<CR>
nmap <Leader>ff :Files<CR>
nmap <Leader>fv :Vista finder fzf:nvim_lsp<CR>

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! BD call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
\ }))

" ------------------------------------------
" vim-slime
" ------------------------------------------
let g:slime_no_mappings = 1
let g:slime_target = "tmux"
xmap <leader>tt <Plug>SlimeRegionSend
nmap <leader>tp <Plug>SlimeParagraphSend
nmap <leader>tc <Plug>SlimeConfig

if !has('nvim')
  finish
endif

lua <<EOF

-- ----------------------------------------
-- Utility function
-- ----------------------------------------
local path = require('lspconfig/util').path

local function get_python_path(workspace)
  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
  end

  -- Find and use virtualenv from pipenv in workspace directory.
  local match = vim.fn.glob(path.join(workspace, 'Pipfile'))
  if match ~= '' then
    local venv = vim.fn.trim(vim.fn.system('PIPENV_PIPFILE=' .. match .. ' pipenv --venv'))
    return path.join(venv, 'bin', 'python')
  end

  -- Fallback to system Python.
  return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
end

-- ----------------------------------------
-- nvim-cmp
-- ----------------------------------------
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  completion = {
    -- autocomplete = false,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<Tab>'] = function(fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end,
    ['<S-Tab>'] = function(fallback) if cmp.visible() then cmp.select_prev_item() else fallback() end end
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'nvim_lsp_signature_help' }, 
  }, {
    { name = 'buffer' },
  })
})

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    -- { name = 'git' },
  }, {
    { name = 'buffer' },
  })
})

cmp.setup.cmdline({ '/', '?' }, {
  -- Setting mapping breaks completion in command mode. In the meanwhile, show completions but
  -- do not support any mappings like tab.
  --   https://github.com/hrsh7th/nvim-cmp/issues/1511
  --mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'nvim_lsp_document_symbol' }
  }, {
    { name = 'buffer' }
  })
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
--cmp.setup.cmdline(':', {
--  mapping = cmp.mapping.preset.cmdline(),
--  sources = cmp.config.sources({
--    { name = 'path' }
--  }, {
--    { name = 'cmdline' }
--  })
--})

-- ----------------------------------------
-- lspconfig
-- ----------------------------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

require'lspconfig'.ts_ls.setup{
-- https://github.com/neovim/neovim/issues/26483#issuecomment-1848332363
-- capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
  capabilities = capabilities,
  --on_init = function(client)
  --  client.workspace.didChangeWatchedFiles.dynamicRegistration = false
  --end,
}
require'lspconfig'.svelte.setup{
  capabilities = capabilities
}
require'lspconfig'.pyright.setup{
  --capabilities = capabilities,
  on_init = function(client)
      client.config.settings.python.pythonPath = get_python_path(client.config.root_dir)
  end,
}
require'lspconfig'.rust_analyzer.setup{
  capabilities = capabilities
}
require('lspconfig').ruff.setup {
  on_attach = on_attach,
}
require'lspconfig'.eslint.setup{
  capabilities = capabilities
}

require'lspconfig'.lua_ls.setup{
  --capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        checkThirdParty = false,
        -- Tells lua_ls where to find all the Lua files that you have loaded
        -- for your neovim configuration.
        library = {
          '${3rd}/luv/library',
          unpack(vim.api.nvim_get_runtime_file('', true)),
        },
        -- If lua_ls is really slow on your computer, you can try this instead:
        -- library = { vim.env.VIMRUNTIME },
      },
      completion = {
        callSnippet = 'Replace',
      },
      -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
    },
  },
}

-- ----------------------------------------
-- Trouble
-- ----------------------------------------
require'Trouble'.setup{
    icons = false,
    fold_open = "v", -- icon used for open folds
    fold_closed = ">", -- icon used for closed folds
    indent_lines = false, -- add an indent guide below the fold icons
    signs = {
        -- icons / text used for a diagnostic
        error = "error",
        warning = "warn",
        hint = "hint",
        information = "info"
    },
    use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
}

-- ----------------------------------------
-- nvim-lightbulb
-- ----------------------------------------
require("nvim-lightbulb").setup({
  autocmd = { enabled = true }
})

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>d', vim.diagnostic.setloclist)
--vim.keymap.set('n', '<space>d', ':TroubleToggle<CR>')

-- Disable line diagnostics in favor of Trouble.vim
vim.diagnostic.config({
  virtual_text = false,
})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    --vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gt', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gT', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    --vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    --vim.keymap.set('n', 'KK', vim.lsp.buf.signature_help, opts)
    --vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    --vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>cr', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<space>cf', function()
      vim.lsp.buf.format { async = true }
    end, opts)
    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = ev.buf,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = ev.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})
EOF
