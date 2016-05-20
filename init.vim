" Author: Thomas LE ROUX <thomas@november-eleven.fr>
" Github: @november-eleven/nvim

if exists('&compatible') | set nocompatible | endif " 21st century

if has('syntax')
  syntax enable
endif

if has('autocmd')
  filetype plugin indent on
endif

set number

let mapleader = ' '

" Helpers

  " http://stackoverflow.com/a/3879737/1071486
  function! SetupCommandAlias(from, to)
    exec 'cnoreabbrev <expr> '.a:from
    \ . ' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
    \ . '? ("'.a:to.'") : ("'.a:from.'"))'
  endfunction

" Plugins

  call plug#begin('~/.config/nvim/bundle')

    Plug 'tomasr/molokai'

    Plug 'editorconfig/editorconfig-vim'

    Plug 'scrooloose/nerdtree'
      let g:NERDTreeDirArrowExpandable = '▸'
      let g:NERDTreeDirArrowCollapsible = '▾'
      let g:NERDTreeShowHidden = 1
      let g:NERDTreeMinimalUI = 1
      let g:NERDTreeWinSize = 35
      let g:NERDTreeRespectWildIgnore = 1
      let g:NERDTreeMouseMode = 2
      autocmd StdinReadPre * let s:std_in=1
      autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
      autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
      nnoremap <silent> <Leader>m :<C-u>NERDTreeToggle<CR>

    Plug 'ctrlpvim/ctrlp.vim'

    Plug 'vim-scripts/BufOnly.vim', { 'on': [ 'BufOnly' ] }
      nnoremap <silent> <Leader>k :<C-u>BufOnly!<CR>

    "Plug 'Shougo/deoplete.vim'

    "Plug 'ensime/ensime-vim'

    "Plug 'docker/docker'

    Plug 'derekwyatt/vim-scala', { 'for': [ 'scala' ] }

    Plug 'elzr/vim-json', { 'for': [ 'json' ] }

    Plug 'pangloss/vim-javascript', { 'for': [ 'javascript' ] }
      let javascript_enable_domhtmlcss = 1 " enable HTML/CSS highlighting

  call plug#end()

" Leader mappings
  
  " [w]rite the current buffer
  nnoremap <silent> <Leader>w :<C-u>write!<CR>

  " [q]uit the current window
  nnoremap <silent> <Leader>q :<C-u>quit!<CR>

" Settings

  " Encoding
  set encoding=utf-8 " ensure proper encoding
  set fileencodings=utf-8 " ensure proper encoding

  " Performance
  set lazyredraw " only redraw when needed
  set ttyfast " we have a fast terminal

  " UI/UX
  set autoread " watch for file changes by other programs
  set nostartofline " leave my cursor position alone!
  set scrolloff=8 " keep at least 8 lines after the cursor when scrolling
  "set shell=zsh " shell for :sh
  set textwidth=120 " 120 characters line

  " VIM
  set nobackup " disable backup files
  set noswapfile " disable swap files
  set secure " protect the configuration files
  set nofoldenable " disable folding

  " Theme
  colorscheme molokai
  set background=dark
  set colorcolumn=+1 " relative to text-width
  set t_Co=256 " 256 colors

  " Mouse
  if has('mouse')
    set mouse=a
  endif

  " Spell checking
  if has('spell')
    " set spell
  endif

  " Avoid configuration files modification by autocmd, shell and write
  
