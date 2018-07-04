" Vundle Plugins
set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'mileszs/ack.vim'
Plugin 'w0rp/ale'
Plugin 'ervandew/supertab'
Plugin 'pangloss/vim-javascript'
Plugin 'tpope/vim-sleuth'
Plugin 'tpope/vim-fugitive'
Plugin 'alvan/vim-closetag'
Plugin 'jiangmiao/auto-pairs'
" All Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" Disable backups (Git takes care of that)
set nobackup
set nowritebackup
set noswapfile
" Theme and Syntax
" set term=screen-256color     " make vim look nice in tmux on macOS/iTerm
syntax enable
set encoding=utf-8
set background=dark
colorscheme solarized
set omnifunc=syntaxcomplete#Complete " enable autocomplete
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#branch#enabled=1
" NerdTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.DS_Store', '\~$', '\.swp', '\.git']
" Editor
set mouse=a       " Allow mouse
set number        " Show number lines
" set relativenumber " Show relative number lines
set numberwidth=5 " Set width of number lines
set backspace=2   " Backspace deletes like most programs in insert mode
set ruler         " Show the cursor position all the time
set showcmd       " Display incomplete commands
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands
set autoread      " Automatically refresh changed files
" Editor - Indentation (using tpope/sleuth)
set tabstop=2     " Number of visual spaces per TAB
set shiftwidth=2  " Set number of space characters inserted for indentation
" set smarttab      " Insert tabs on the start of a line according to shiftwidth, not tabstop
" set shiftround    " Use multiple of shiftwidth when indenting with '<' and '>'
" set expandtab     " Tabs are spaces
" set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set cursorline    " highlight current line
" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=80
" Display tabs and trailing spaces visually
" set listchars=eol:↲,tab:▶▹,nbsp:␣,extends:…,trail:•
" other characters: ↩ ↵ ↲ ␣ • … → » ∎ ¶ ▶ ▸ ▷ ▹
" set list listchars=tab:▹·,trail:·,nbsp:␣
set history=1000  " remember more commands and search history
set undolevels=1000  " use many levels of undo
autocmd BufWritePre * %s/\s\+$//e " auto remove trailing whitespace on save
" Search
set showmatch     " highlight matching [{()}]
set incsearch     " Do incremental searching
set hlsearch      " highlight matches
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase, case-sensitive otherwise
" CtrlP
let g:ctrlp_working_path_mode = 0 " start search in directory vim started
let g:ctrlp_custom_ignore = 'static\|node_modules\|DS_Store\|git' " don't search these directories
" Mappings - Normal Mode
let mapleader = ";"                     " map leader to semi-colon
" Disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
nnoremap <Leader>\ :NERDTreeToggle<CR>
nnoremap <Leader>p :CtrlP<CR>           " fire CtrlP fuzzy finder
nnoremap <Leader>w :w<CR>               " Save file
nnoremap <Leader>l :nohl<CR><C-l>       " redraw screen / remove search highlighting
nnoremap <leader>] :bn<CR>              " go to next buffer
nnoremap <leader>[ :bp<CR>              " go to previous buffer
nnoremap <leader>i *                    " search for current word in file
nnoremap <leader>f :Ack<CR>             " search for current word in folder
nnoremap <leader>k :m .-2<CR>==         " move current line up
nnoremap <leader>j :m .+1<CR>==         " move current line down
" Splits
nnoremap <C-J> <C-W><C-J>               " map spilt navigation Ctrl+J (up)
nnoremap <C-K> <C-W><C-K>               " map split navigation Ctrl+K (down)
nnoremap <C-L> <C-W><C-L>               " map split navigation Ctrl+L (right)
nnoremap <C-H> <C-W><C-H>               " map split navigation Ctrl+H (left)
set splitbelow                          " Open new split panes to bottom
set splitright                          " Open new split panes to right
autocmd BufNewFile,BufRead *.scss set ft=scss.css " Treat SCSS like CSS
