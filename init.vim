call plug#begin('~/.config/nvim/plugged')
Plug 'neovim/nvim-lspconfig'
Plug 'anott03/nvim-lspinstall'
Plug 'nvim-lua/completion-nvim'
Plug 'hrsh7th/nvim-compe'
Plug 'ray-x/lsp_signature.nvim'
Plug 'glepnir/lspsaga.nvim'

"Git and FZF
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive' "fugitive.vim: A Git wrapper so awesome, it should be illegal
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim' " fuzzy find files

" telescope requirements
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" prettier
Plug 'sbdchd/neoformat'

"Auto pairs
Plug 'jiangmiao/auto-pairs'

"Teste multiplos cursores
Plug 'terryma/vim-multiple-cursors'

" post install (yarn install | npm install) then load plugin only for editing supported files
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

"syntax highlight
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

"Rename in current file
Plug 'nvim-treesitter/nvim-treesitter-refactor'

"Themes
Plug 'morhetz/gruvbox'
"Plug 'itchyny/lightline.vim'

Plug 'vim-airline/vim-airline-themes' "A collection of themes for vim-airline
Plug 'vim-airline/vim-airline'
call plug#end()

lua << EOF
local saga = require 'lspsaga'
saga.init_lsp_saga {
  error_sign = '',
  warn_sign = '',
  hint_sign = '',
  infor_sign = '',
  border_style = "round",
}

  require'lspconfig'.tsserver.setup {
    on_attach=require'completion'.on_attach,
    capabilities = capabilities,
  }
    cmd = { "typescript-language-server", "--stdio" }
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx"
    }

  --Enable (broadcasting) snippet capability for completion
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  require'lspconfig'.html.setup {
    capabilities = capabilities,
  }

  require'nvim-treesitter.configs'.setup { highlight = { enable = true } }

  local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  --buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  --buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', 'gtt', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', 'gt', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', 'gf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

local servers = { 'tsserver','html' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 50,
    }
  }
end

EOF

let g:gruvbox_contrast_dark = 'hard'
  if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif

let g:gruvbox_invert_selection='0'
colorscheme gruvbox
set background=dark

set completeopt=menuone,noselect
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

".:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:.
"telescope key Thanks ThePrimeagen
let mapleader = " "
nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Search:")})<CR>

nnoremap <Leader>+ :vertical resize +25<CR>
nnoremap <Leader>- :vertical resize -25<CR>
nnoremap <Leader>gzq :resize 100<CR>
inoremap <silent> <C-k> <Cmd>Lspsaga signature_help<CR>
nnoremap <silent>K :Lspsaga hover_doc<CR>

".:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:.
"Remove WhiteSpaces Thanks ThePrimeagen
fun! TrimWhiteSpaces()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfun

augroup THE_PRIMEAGEN
  autocmd!
  autocmd BufWritePre * :call TrimWhiteSpaces()
augroup END
".:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:.
"Prettier configs indentation
let g:standard_prettier_settings = {
      \ 'exe': 'prettier',
      \ 'args': ['--stdin', '--stdin-filepath', '%:p', '--single-quote'],
      \ 'stdin': 1,
      \ }

let g:nvim_typescript#javascript_support=1
let g:neoformat_javascript_prettier = g:standard_prettier_settings
let g:neoformat_typescriptreact_prettier = g:standard_prettier_settings
let g:neoformat_try_formatprg = 1
let g:neoformat_enabled_javascript = ['prettier']
let g:neoformat_enabled_typescript = ['prettier']

augroup NeoformatAutoFormat
  autocmd!
  autocmd FileType javascript,javascript.jsx,typescript.tsx setlocal formatprg=prettier\
        \--stdin\
        \--print-width\ 80\
        \--single-quote\
        \--trailing-comma\ es5
  autocmd BufWritePre *.js,*.jsx,*.tsx,*.json Neoformat
augroup END

" my Settings VIM start
".:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:.
set smarttab
set cindent
set wrap
set termguicolors " enable true colors support
set tabstop=2 "Tamanho da indentacao"

set guicursor=n-v:blinkon1 "Finaly cursor blink mode, thanks https://github.com/wez/wezterm/issues/1073"

"identifica o tipo de arquivo e auto indenta o mesmo"
filetype plugin indent on
syntax on
set shiftwidth=2 "Deixar coerente a identacao com o tamnaho de Tab"
set backspace=2 "comportamento usual do backspace"
set number "esse comando serve para numerar as linhas"
set relativenumber "faz o calculo da distancia das linhas"
set hlsearch "destaque nos resultados"
set incsearch "busca incremental - traz feedback enquanto busco"

"Atalho do Emmet
let g:user_emmet_leader_key=','

"usar space no lugar de Tab
set expandtab

"backspace respeitar identacao
set softtabstop=2

"vertical bar limit
set colorcolumn=110

"Necessário p/ manter vários buffers abertos
set hidden

"open vertical split right
set splitright

set laststatus=2 "always show statusline

set noshowmode "dont show insert,visual ...

" Ignore show files
set wildignore+=*_build/*
set wildignore+=**/node_modules/*
set wildignore+=**/.git/*

set updatetime=50

"set statusline+=%{exists('g:loaded_fugitive')?fugitive#statusline():''}
"define the set of names to be displayed instead of a specific filetypes
set statusline+=%{airline#util#wrap(airline#extensions#branch#get_head(),50)}

set listchars=tab:\ \ ,eol:¬

set autoindent

set smartindent

set ruler

set cursorline

".:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:.

let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.resolve_timeout = 800
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.vsnip = v:true
let g:compe.source.ultisnips = v:true
let g:compe.source.luasnip = v:true
let g:compe.source.emoji = v:true

"Teste multiplos cursores
let g:multi_cursor_use_default_mapping=0

" Default mapping
let g:multi_cursor_start_word_key      = '<C-n>'
let g:multi_cursor_select_all_word_key = '<A-n>'
let g:multi_cursor_start_key           = 'g<C-n>'
let g:multi_cursor_select_all_key      = 'g<A-n>'
let g:multi_cursor_next_key            = '<C-n>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'

"NERDTree maps
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

let g:airline_theme='google_light'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_section_y=0 " dont show encondig infos"

let g:airline#extensions#zoomwintab#enabled = 1

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '   '
let g:airline_symbols.maxlinenr = ' ⚡ '
let g:airline_symbols.dirty='⚡'