set number                       " show number lines
set numberwidth=5                " set width of number lines
set tabstop=2                    " display tabs as 2 spaces wide
set shiftwidth=2                 " set number of space characters inserted for indentation
set expandtab                    " insert spaces when pressing Tab
set textwidth=0                  " don't hard-wrap lines while typing
set nowrap                       " don't soft-wrap long lines
set colorcolumn=80               " show me 80 characters mark
set cursorline                   " hightlight current line
set signcolumn=yes               " always show the sign column so text doesn't shift
set ignorecase                   " case-insensitive search...
set smartcase                    " ...unless the search contains a capital letter
set splitright                   " open vertical splits to the right
set splitbelow                   " open horizontal splits below
set mouse=a                      " allow mouse
set noshowmode                   " hide the default mode text (lualine replaces it)
set nowritebackup                " disable backups
set noswapfile                   " disable swapfile
set clipboard+=unnamedplus     " use y and p with system clipboard
set list                         " display non-breaking spaces and offscreen text markers
set listchars=tab:\ \ ,nbsp:.,extends:>,precedes:<

" remove any mapping for spacebar
nnoremap <Space> <Nop>
let mapleader = " "              " map leader to spacebar

" split navigation with Ctrl+J/K/L/H (down/up/right/left)
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>


call plug#begin()
Plug 'maxmx03/solarized.nvim'
Plug 'f-person/auto-dark-mode.nvim'

Plug 'windwp/nvim-autopairs'
Plug 'windwp/nvim-ts-autotag'
Plug 'nvim-treesitter/nvim-treesitter', {'branch': 'main', 'do': ':TSUpdate'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-tree/nvim-web-devicons'

Plug 'nvim-telescope/telescope.nvim'
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

Plug 'nvim-tree/nvim-tree.lua'
nnoremap <Leader>\ :NvimTreeToggle<CR>

Plug 'nvim-lualine/lualine.nvim'

Plug 'akinsho/bufferline.nvim'
nnoremap <S-l> <cmd>BufferLineCycleNext<cr>
nnoremap <S-h> <cmd>BufferLineCyclePrev<cr>

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'

Plug 'mason-org/mason.nvim'
Plug 'neovim/nvim-lspconfig'

Plug 'lewis6991/gitsigns.nvim'

Plug 'lukas-reineke/indent-blankline.nvim'

Plug 'sbdchd/neoformat'

Plug 'folke/persistence.nvim'

call plug#end()

" Theme (background is set by auto-dark-mode to follow the macOS appearance)
colorscheme solarized

lua << EOF

-- Follow the macOS light/dark appearance; changing 'background' reloads solarized
require('auto-dark-mode').setup({
  set_dark_mode = function()
    vim.api.nvim_set_option_value('background', 'dark', {})
  end,
  set_light_mode = function()
    vim.api.nvim_set_option_value('background', 'light', {})
  end,
})

-- Save the session for the current directory on exit and restore it when
-- nvim is started there with no arguments or a single directory (`nvim .`).
-- One session per directory, shared across git branches.
require('persistence').setup({ branch = false })
local session_dir = vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 and vim.fn.argv(0) or nil
local use_session = vim.fn.argc() == 0 or session_dir ~= nil
if not use_session then
  -- don't let a quick `nvim somefile` overwrite the saved session
  require('persistence').stop()
end

vim.api.nvim_create_autocmd('User', {
  pattern = 'PersistenceSavePre',
  callback = function()
    -- a restored nvim-tree window comes back as an empty buffer
    pcall(vim.cmd, 'NvimTreeClose')
  end,
})

vim.api.nvim_create_autocmd('VimEnter', {
  nested = true,
  callback = function()
    if not use_session then
      return
    end
    if session_dir then
      -- replace the directory buffer from `nvim <dir>` with that dir's session
      vim.cmd.cd(vim.fn.fnameescape(session_dir))
      local dir_buf = vim.api.nvim_get_current_buf()
      vim.cmd('silent! %argdelete')
      require('persistence').load()
      if vim.api.nvim_buf_is_valid(dir_buf) and vim.fn.isdirectory(vim.api.nvim_buf_get_name(dir_buf)) == 1
        and #vim.fn.getbufinfo({ buflisted = 1 }) > 1 then
        pcall(vim.api.nvim_buf_delete, dir_buf, { force = true })
      end
    else
      require('persistence').load()
    end
  end,
})

require("nvim-tree").setup({
  update_focused_file = {
    enable = true,
    update_root = { enable = true },
  },
  view = {
    width = {}, -- grow to fit the longest file name
    centralize_selection = true,
  },
  renderer = {
    root_folder_label = false,
  },
  on_attach = function(bufnr)
    local api = require("nvim-tree.api")
    api.config.mappings.default_on_attach(bufnr)

    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
    vim.keymap.set("n", "s", api.node.open.horizontal, opts("Open: Horizontal Split"))
    vim.keymap.set("n", "a", api.fs.create, opts("Create"))
    vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
  end,
})

-- VS Code-style tabs for open buffers
-- close a buffer without closing its window (keeps the split/nvim-tree layout)
local function close_buffer(bufnr)
  if bufnr == nil or bufnr == 0 then bufnr = vim.api.nvim_get_current_buf() end
  -- ignore special windows like nvim-tree
  if not vim.bo[bufnr].buflisted then return end
  if vim.bo[bufnr].modified then
    local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':t')
    local choice = vim.fn.confirm('Save changes to ' .. (name ~= '' and name or '[No Name]') .. '?', "&Save\n&Don't Save\n&Cancel")
    if choice == 1 then
      local ok = pcall(vim.api.nvim_buf_call, bufnr, function() vim.cmd('write') end)
      if not ok then return end
    elseif choice ~= 2 then
      return
    end
  end
  for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
    vim.api.nvim_win_call(win, function()
      vim.cmd('bprevious')
      if vim.api.nvim_get_current_buf() == bufnr then vim.cmd('enew') end
    end)
  end
  if vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end
end
vim.keymap.set('n', '<leader>x', function() close_buffer(0) end, { desc = 'Close buffer' })

require('bufferline').setup({
  options = {
    mode = 'buffers',
    close_command = close_buffer,
    right_mouse_command = close_buffer,
    separator_style = 'thin',
    modified_icon = '●',
    show_buffer_close_icons = true,
    show_close_icon = false,
    always_show_bufferline = true,
    offsets = {
      { filetype = 'NvimTree', text = 'Explorer', text_align = 'left', separator = true },
    },
  },
})

-- Language servers, installed with :MasonInstall intelephense typescript-language-server
require('mason').setup()

vim.lsp.config('intelephense', {
  settings = {
    intelephense = {
      -- intelephense's default stubs plus WordPress
      stubs = {
        'apache', 'bcmath', 'bz2', 'calendar', 'com_dotnet', 'Core', 'ctype', 'curl', 'date', 'dba',
        'dom', 'enchant', 'exif', 'FFI', 'fileinfo', 'filter', 'fpm', 'ftp', 'gd', 'gettext', 'gmp',
        'hash', 'iconv', 'imap', 'intl', 'json', 'ldap', 'libxml', 'mbstring', 'meta', 'mysqli', 'oci8',
        'odbc', 'openssl', 'pcntl', 'pcre', 'PDO', 'pgsql', 'Phar', 'posix', 'pspell', 'random',
        'readline', 'Reflection', 'session', 'shmop', 'SimpleXML', 'snmp', 'soap', 'sockets', 'sodium',
        'SPL', 'sqlite3', 'standard', 'superglobals', 'sysvmsg', 'sysvsem', 'sysvshm', 'tidy',
        'tokenizer', 'uri', 'xml', 'xmlreader', 'xmlrpc', 'xmlwriter', 'xsl', 'Zend OPcache', 'zip',
        'zlib', 'wordpress',
      },
    },
  },
})
vim.lsp.enable({ 'intelephense', 'ts_ls' })

-- gd jumps to the definition (<C-o> jumps back); grr, K and the other gr* maps are Neovim defaults
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = args.buf, desc = 'Go to definition' })
  end,
})

-- Open the current file at the cursor line (or selected lines) on GitHub
local function open_on_github()
  local file = vim.api.nvim_buf_get_name(0)
  local root = file ~= '' and vim.fs.root(file, '.git')
  if not root then
    vim.notify('Not a file in a git repo', vim.log.levels.WARN)
    return
  end

  local first, last = vim.fn.line('v'), vim.fn.line('.')
  if first > last then
    first, last = last, first
  end
  local location = vim.fs.relpath(root, file) .. ':' .. first .. (first ~= last and '-' .. last or '')
  local args = { 'gh', 'browse', location }

  -- use the current branch once it has been pushed, otherwise gh uses the default branch
  local upstream = vim.system({ 'git', 'rev-parse', '--symbolic-full-name', '@{upstream}' }, { cwd = root, text = true }):wait()
  if upstream.code == 0 then
    local branch = vim.trim(upstream.stdout):gsub('^refs/remotes/[^/]+/', '')
    vim.list_extend(args, { '--branch', branch })
  end

  vim.system(args, { cwd = root, text = true }, function(result)
    if result.code ~= 0 then
      vim.schedule(function()
        vim.notify('gh browse failed: ' .. vim.trim(result.stderr), vim.log.levels.ERROR)
      end)
    end
  end)
end
vim.keymap.set({ 'n', 'x' }, '<leader>go', open_on_github, { desc = 'Open file on GitHub' })

require('gitsigns').setup({
  current_line_blame = true, -- show inline blame for the current line, like GitLens
  current_line_blame_opts = {
    delay = 500,
  },
})

-- Indent guides, with the current block's guide highlighted like VS Code
require('ibl').setup({
  indent = { char = '│', tab_char = '│' },
  scope = { show_start = false, show_end = false },
})

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

-- Parsers to install (a no-op once they are installed)
require('nvim-treesitter').install({
  'javascript', 'typescript', 'tsx', 'jsdoc', 'html', 'css', 'scss', 'php',
  'vim', 'lua', 'markdown', 'markdown_inline', 'bash',
})

-- Highlight ```shell and ```zsh code blocks in markdown with the bash parser
vim.treesitter.language.register('bash', { 'shell', 'zsh' })

-- Enable treesitter highlighting and indentation for any filetype with a parser
local ts_indent_disabled = { go = true, python = true, javascript = true, javascriptreact = true }
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    if not pcall(vim.treesitter.start, args.buf) then
      return
    end
    if not ts_indent_disabled[args.match] then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

require('nvim-ts-autotag').setup()

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = ' ', right = ' '},
    section_separators = { left = ' ', right = ' '},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = true,
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
  extensions = { 'nvim-tree' }
}

vim.opt.completeopt={"menu","menuone","noselect"}

-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'buffer' },
  })
})
EOF
