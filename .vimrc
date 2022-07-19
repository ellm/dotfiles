" ------- General Settings -------

set nocompatible                 " be iMproved, required
filetype off                     " required for Vundle

set number                       " show number lines
set numberwidth=5                " set width of number lines
set backspace=indent,eol,start   " backspace deletes like most programs in insert mode
set ruler                        " show the cursor position all the time
set laststatus=2                 " always display the status line
set tabstop=2                    " number of visual spaces per tab
set shiftwidth=2                 " set number of space characters inserted for indentation
set noexpandtab                  " expand tab
set smartindent                  " smart indent the next line
set foldenable                   " enable code folding
set nobackup                     " disable backups
set nowritebackup                " disable backups
set noswapfile                   " disable swapfile
set encoding=utf-8               " default encoding
set textwidth=80                 " show me 80 characters mark
set colorcolumn=80               " show me 80 characters mark
set list                         " display tabs and trailing spaces visually
set listchars=tab:\│\ ,nbsp:.,extends:>,precedes:<
set nowrap                       " disable wordwrap
set sidescroll=1                 " incrementally scroll one character at a time
set history=1000                 " remember more commands and search history
set undolevels=1000              " use many levels of undo
autocmd BufWritePre * %s/\s\+$//e " auto remove trailing whitespace on save
set clipboard=unnamed            " use system clipboard by default
set updatetime=100
set showmatch                    " highlight matching [{()}]
set incsearch                    " do incremental searching
set hlsearch                     " highlight matches
set ignorecase                   " ignore case when searching
set smartcase                    " ignore case if search pattern is all lowercase, case-sensitive otherwise
set noshowmode                   " hide the default mode text (powerline replaces it)
set splitbelow                   " open new split panes to bottom
set splitright                   " open new split panes to right

if has("gui_macvim")
" set macligatures                 " enable font ligatures
set guifont=Menlo:h12           " set a pretty font
set linespace=4                  " line height (for MacVim)
set guioptions-=R                " get rid of right macvim scrollbar
set guioptions-=L                " get rid of left macvim scrollbar
set guioptions-=r                " get rid of right macvim scrollbar
set guioptions-=l                " get rid of left macvim scrollbar
set guioptions-=m                " get rid of menu bar
set guioptions-=T                " get rid of toolbar
endif

set cursorline " hightlight current line
let &t_SI = "\e[6 q" " change cursor while in insert mode.
let &t_EI = "\e[2 q"

set mouse=a " allow mouse

" ------- Custom Mappings -------

nnoremap <SPACE> <Nop>                  " remove any mapping for spacebar
let mapleader = " "                     " map leader to spacebar
" disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
nnoremap <CR> :nohlsearch<cr>           " redraw screen / remove search highlighting
nnoremap <Leader>w :bd<CR>              " delete buffer
nnoremap <leader>t :enew<cr>            " open a new empty buffer
nnoremap <leader>] :bn<CR>              " go to next buffer
nnoremap <leader>[ :bp<CR>              " go to previous buffer
nnoremap <leader>i *                    " search for current word in file
nnoremap <leader>k :m .-2<CR>==         " move current line up
nnoremap <leader>j :m .+1<CR>==         " move current line down
nmap <leader>v :split $MYVIMRC<CR>      " edit vimrc in a split.
nnoremap <C-J> <C-W><C-J>               " map spilt navigation Ctrl+J (up)
nnoremap <C-K> <C-W><C-K>               " map split navigation Ctrl+K (down)
nnoremap <C-L> <C-W><C-L>               " map split navigation Ctrl+L (right)
nnoremap <C-H> <C-W><C-H>               " map split navigation Ctrl+H (left)

" ------- Plugin Settings -------
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'lifepillar/vim-solarized8'

Plugin 'scrooloose/nerdtree'
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.DS_Store', '\~$', '\.swp']
let NERDTreeWinSize=50
let NERDTreeAutoDeleteBuffer = 1 " auto delete the buffer of file deleted
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
nnoremap <Leader>\ :NERDTreeToggle<CR>  " open NerdTree

Plugin 'kien/ctrlp.vim'
let g:ctrlp_switch_buffer = 0 " always open files in a new buffer
let g:ctrlp_working_path_mode = 0 " start search in directory vim started
let g:ctrlp_custom_ignore = {
\ 'dir': 'build\|static\|node_modules\|DS_Store\|git',
\ 'file': 'tags',
\ }
let g:ctrlp_use_caching=0 " update without having to reload
nnoremap <Leader>p :CtrlP<CR>           " fire CtrlP fuzzy finder

Plugin 'airblade/vim-gitgutter'
nnoremap <leader>a :GitGutterPreviousHunk  " GitGutter previous hunk.
nnoremap <leader>x :GitGutterNextHunk   " GitGutter next hunk.
nnoremap <leader>z :GitGutterUndoHunk   " GitGutter undo change.

Plugin 'vim-airline/vim-airline'
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#branch#enabled=1

Plugin 'mileszs/ack.vim'
cnoreabbrev Ack Ack!
nnoremap <Leader>f :Ack!<Space>

Plugin 'w0rp/ale'
let g:ale_sign_error = '●' " Less aggressive than the default '>>'
let g:ale_sign_warning = '.'
let g:ale_lint_on_enter = 0 " Less distracting when opening a new file
let g:ale_lint_on_save = 1
let g:ale_use_global_executables = 1
let g:ale_linters_explicit = 1
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'php': ['php', 'phpcs'],
\   'scss': ['stylelint'],
\}
let g:ale_scss_stylelint_options = '--config client/config/stylelint.config.js'
let g:ale_javascript_eslint_options = '--config ./.eslintrc'
" let g:ale_php_phpcs_executable = '~/broadway/bin/phpcs'
" let g:ale_php_phpcs_standard = 'WordPress'

" Plugin 'prettier/vim-prettier'
" let g:prettier#config#single_quote = 'true'

Plugin 'pangloss/vim-javascript'
let g:javascript_plugin_jsdoc = 1 " enable jsdoc

Plugin 'mxw/vim-jsx'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-haml'
Plugin 'tpope/vim-obsession'
Plugin 'dhruvasagar/vim-prosession'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'mattn/emmet-vim'

Plugin 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-n>"
let g:SuperTabLongestEnhanced = 1
let g:SuperTabLongestHighlight = 1

Plugin 'ap/vim-css-color'

" All Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" ------- Theme/Syntax Settings -------
syntax enable
if (has("termguicolors"))
set termguicolors
endif
set background=dark
colorscheme solarized8
" Disable visual bell and flash
set noerrorbells visualbell t_vb=
if has('autocmd')
autocmd GUIEnter * set visualbell t_vb=
endif

" ------- Preferences per filetype -------
autocmd FileType css,scss setlocal omnifunc=csscomplete#CompleteCSS smartindent shiftwidth=2 softtabstop=2 tabstop=2 expandtab
autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP smartindent shiftwidth=2 softtabstop=2 tabstop=2 noexpandtab
autocmd FileType javascript,json,javascript.jsx setlocal omnifunc=javascriptcomplete#CompleteJS smartindent shiftwidth=2 softtabstop=2 tabstop=2 expandtab
