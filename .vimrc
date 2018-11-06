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
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'tpope/vim-sleuth'
Plugin 'tpope/vim-fugitive'
Plugin 'alvan/vim-closetag'
Plugin 'jiangmiao/auto-pairs'
Plugin 'tpope/vim-haml'
Plugin 'tpope/vim-obsession'
Plugin 'dhruvasagar/vim-prosession'
Plugin 'tpope/vim-commentary'
Plugin 'ludovicchabant/vim-gutentags'
Plugin 'chriskempson/base16-vim'
Plugin 'SirVer/ultisnips'
Plugin 'valloric/youcompleteme'
Plugin 'shawncplus/phpcomplete.vim'
" All Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" Disable backups (Git takes care of that)
set nobackup
set nowritebackup
set noswapfile
" == Theme and Syntax
syntax enable
set encoding=utf-8
set background=dark
colorscheme base16-default-dark
set omnifunc=syntaxcomplete#Complete " enable autocomplete
let g:airline_theme='base16'
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#tabline#enabled = 1
" == NerdTree
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.DS_Store', '\~$', '\.swp', '\.git']
let NERDTreeWinSize=50
" let NERDTreeQuitOnOpen = 1 " auto close upon opening a file.
let NERDTreeAutoDeleteBuffer = 1 " auto delete the buffer of file deleted
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
" == Snippets
let g:UltiSnipsSnippetsDir="~/.vim/ultisnips"
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsEditSplit="vertical"
" == Editor
set gfn=Monaco:h12 " Set font
set linespace=3   " Line height (for MacVim)
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
" indentation (using tpope/sleuth)
set tabstop=2     " Number of visual spaces per TAB
set shiftwidth=2  " Set number of space characters inserted for indentation
" set smarttab      " Insert tabs on the start of a line according to shiftwidth, not tabstop
" set shiftround    " Use multiple of shiftwidth when indenting with '<' and '>'
" set expandtab     " Tabs are spaces
" set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
" set cursorline    " highlight current line
" make it obvious where 80 characters is
set textwidth=80
set colorcolumn=80
" display tabs and trailing spaces visually
set list
set listchars=tab:▸\ ,nbsp:.,extends:>,precedes:<
set wrap! " disable wordwrap
set sidescroll=5
" other characters: ↩ ↵ ↲ ␣ • … → » ∎ ¶ ▶ ▸ ▷ ▹
set history=1000  " remember more commands and search history
set undolevels=1000  " use many levels of undo
autocmd BufWritePre * %s/\s\+$//e " auto remove trailing whitespace on save
set clipboard=unnamed " use system clipboard by default
set updatetime=100
" == Search
set showmatch     " highlight matching [{()}]
set incsearch     " Do incremental searching
set hlsearch      " highlight matches
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase, case-sensitive otherwise
" == CtrlP
let g:ctrlp_switch_buffer = 0 " always open files in a new buffer
let g:ctrlp_working_path_mode = 0 " start search in directory vim started
let g:ctrlp_custom_ignore = 'build\|static\|node_modules\|DS_Store\|git' " don't search these directories
let g:ctrlp_use_caching=0 " update without having to reload
" == Mappings - Normal Mode
let mapleader = ";"                     " map leader to semi-colon
" disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
nnoremap <Leader>\ :NERDTreeToggle<CR>
nnoremap <Leader>p :CtrlP<CR>           " fire CtrlP fuzzy finder
nnoremap <Leader>s :w<CR>               " Save file
nnoremap <Leader>l :nohl<CR><C-l>       " redraw screen / remove search highlighting
nnoremap <Leader>w :bd<CR>              " delete buffer
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
