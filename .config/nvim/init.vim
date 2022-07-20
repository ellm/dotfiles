set encoding=utf-8               " default encoding
set number                       " show number lines
set numberwidth=5                " set width of number lines
set tabstop=2                    "  
set shiftwidth=2                 " set number of space characters inserted for indentation  
set textwidth=80                 " show me 80 characters mark
set colorcolumn=80               " show me 80 characters mark
set cursorline                   " hightlight current line
let &t_SI = "\e[6 q"             " change cursor while in insert mode.
let &t_EI = "\e[2 q"
set mouse=a                      " allow mouse
set noshowmode                   " hide the default mode text (lualine replaces it)
set nobackup                     " disable backups
set nowritebackup                " disable backups
set noswapfile                   " disable swapfile
set clipboard+=unnamedplus     " use y and p with system clipboard
set list                         " display tabs and trailing spaces visually
set listchars=tab:\│\ ,nbsp:.,extends:>,precedes:<
set termguicolors " for theme color correctness

nnoremap <SPACE><Nop>           " remove any mapping for spacebar
let mapleader = " "              " map leader to spacebar
nnoremap <C-J> <C-W><C-J>        " map spilt navigation Ctrl+J (up)
nnoremap <C-K> <C-W><C-K>        " map split navigation Ctrl+K (down)
nnoremap <C-L> <C-W><C-L>        " map split navigation Ctrl+L (right)
nnoremap <C-H> <C-W><C-H>        " map split navigation Ctrl+H (left)


call plug#begin()
Plug 'mhartington/oceanic-next'

Plug 'windwp/nvim-autopairs'
Plug 'windwp/nvim-ts-autotag'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'sheerun/vim-polyglot'
Plug 'BurntSushi/ripgrep'
Plug 'nvim-lua/plenary.nvim'
Plug 'kyazdani42/nvim-web-devicons'

Plug 'nvim-telescope/telescope.nvim'
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

Plug 'kyazdani42/nvim-tree.lua'
nnoremap <Leader>\ :NvimTreeToggle<CR> 

Plug 'tpope/vim-commentary'

Plug 'editorconfig/editorconfig-vim'

Plug 'nvim-lualine/lualine.nvim'

Plug 'neovim/nvim-lspconfig'

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'

Plug 'lewis6991/gitsigns.nvim'

Plug 'sbdchd/neoformat'

Plug 'mhinz/vim-startify'

call plug#end()

" Theme 
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1
colorscheme OceanicNext
set background=dark

" Eslint...
autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll

" Startify
" Update session automatically as you exit vim
let g:startify_session_persistence = 1

lua << EOF

-- todo - configure toggle mapping
require("nvim-tree").setup({
  update_focused_file = {
    enable = true,
  },
  view = {
    adaptive_size = true,
    centralize_selection = true,
    mappings = {
      list = {
        { key = "v", action ="vsplit" },
        { key = "s", action ="split" },
        { key = "a", action ="create" },
        { key = "d", action ="remove" },
      },
    },
  },
})

require('gitsigns').setup()

require('telescope').setup{ defaults = { file_ignore_patterns = {"node_modules"} } }

require("nvim-autopairs").setup({
  check_ts = true,
  ts_config = {
    lua = {'string'},-- it will not add a pair on that treesitter node
    javascript = {'template_string'},
    java = false,-- don't check treesitter on java
  },
  disable_filetype = { "TelescopePrompt" },
   fast_wrap = {
    map = '<M-e>',
    chars = { '{', '[', '(', '"', "'" },
    pattern = [=[[%'%"%)%>%]%)%}%,]]=],
    end_key = '$',
    keys = 'qwertyuiopzxcvbnmasdfghjkl',
    check_comma = true,
    highlight = 'Search',
    highlight_grey='Comment'
  },
})

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable= true,
    disable ={},
  },
  indent = {
    enable = true,
    disable = { "go", "python" },
  },
  autotag = { enable = true },
  -- A list of parser names, or "all"
  ensure_installed = { "javascript", "jsdoc", "html", "css", "scss", "php", "vim", "lua" },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = true,
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'OceanicNext',
    component_separators = { left = ' ', right = ' '},
    section_separators = { left = ' ', right = ' '},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {
      {
        'filename',
        file_status = true,
        path = 1,
      }
    },
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
require('lspconfig')['tsserver'].setup{
  capabilities= capabilities,
  on_attach = function()
    vim.keymap.set("n","K", vim.lsp.buf.hover, {buffer=0})
    vim.keymap.set("n","gd", vim.lsp.buf.definition, {buffer=0})
  end,
}

-- Needed for Php intelephense
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#intelephense
require'lspconfig'.intelephense.setup{
  capabilities= capabilities,
  on_attach = function()
    vim.keymap.set("n","K", vim.lsp.buf.hover, {buffer=0})
    vim.keymap.set("n","gd", vim.lsp.buf.definition, {buffer=0})
  end,
  settings = {
    intelephense = {
      stubs = {
        "Core",
        "FFI",
        "PDO",
        "Phar",
        "Reflection",
        "SPL",
        "SimpleXML",
        "Zend OPcache",
        "apache",
        "bcmath",
        "bz2",
        "calendar",
        "com_dotnet",
        "ctype",
        "curl",
        "date",
        "dba",
        "dom",
        "enchant",
        "exif",
        "fileinfo",
        "filter",
        "fpm",
        "ftp",
        "gd",
        "gettext",
        "gmp",
        "hash",
        "iconv",
        "imap",
        "intl",
        "json",
        "ldap",
        "libxml",
        "mbstring",
        "meta",
        "mysqli",
        "oci8",
        "odbc",
        "openssl",
        "pcntl",
        "pcre",
        "pdo_ibm",
        "pdo_mysql",
        "pdo_pgsql",
        "pdo_sqlite",
        "pgsql",
        "posix",
        "pspell",
        "readline",
        "session",
        "shmop",
        "snmp",
        "soap",
        "sockets",
        "sodium",
        "sqlite3",
        "standard",
        "superglobals",
        "sysvmsg",
        "sysvsem",
        "sysvshm",
        "tidy",
        "tokenizer",
        "wordpress",
        "wordpress-globals",
        "wp-cli",
        "xml",
        "xmlreader",
        "xmlrpc",
        "xmlwriter",
        "xsl",
        "zip",
        "zlib",
      }
    }
  }
}

-- Needed for eslint 
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#eslint
require'lspconfig'.eslint.setup{}


vim.opt.completeopt={"menu","menuone","noselect"}

-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
  }, {
    { name = 'buffer' },
  })
})
EOF
