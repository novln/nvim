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
set fileformats=unix,dos,mac

let mapleader = ' '

let b:cache_directory = $HOME . '/.cache/nvim'

" Helpers

  " http://stackoverflow.com/a/3879737/1071486
  function! SetupCommandAlias(from, to)
    exec 'cnoreabbrev <expr> '.a:from
    \ . ' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
    \ . '? ("'.a:to.'") : ("'.a:from.'"))'
  endfunction

  " Echap will close vim-plug buffer
  autocmd FileType vim-plug call s:on_vimplug_buffer()
  function! s:on_vimplug_buffer()
    nnoremap <silent><buffer> <Esc> <C-w>q
  endfunction

  " Open help vertically
  call SetupCommandAlias('help', 'vertical help')
  autocmd FileType help call s:on_help_buffer()
  function! s:on_help_buffer()
    nmap <silent><buffer> <Esc> <C-w>q
  endfunction

" Plugins

  call plug#begin('~/.config/nvim/bundle')

    Plug 'tomasr/molokai'
      let g:molokai_original=1

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
      let g:ctrlp_cmd = 'CtrlPMixed' " search anything (in files, buffers and MRU files at the same time.)
      let g:ctrlp_working_path_mode = 'a' " search for nearest ancestor like .git, .hg, and the directory of the current file
      let g:ctrlp_match_window_bottom = 1 " show the match window at the top of the screen
      let g:ctrlp_by_filename = 1
      let g:ctrlp_max_height = 10 " maximum height of match window
      let g:ctrlp_switch_buffer = 'et' " jump to a file if it's open already
      let g:ctrlp_use_caching = 1 " enable caching
      let g:ctrlp_cache_dir = b:cache_directory . '/ctrlp' " define cache path
      let g:ctrlp_clear_cache_on_exit = 0 " speed up by not removing clearing cache everytime
      let g:ctrlp_mruf_max = 250 " number of recently opened files
      nnoremap <silent> <Leader>p :<C-u>CtrlP<CR>

    Plug 'vim-scripts/BufOnly.vim', { 'on': [ 'BufOnly' ] }
      nnoremap <silent> <Leader>k :<C-u>BufOnly!<CR>

    Plug 'airblade/vim-gitgutter'
      let g:gitgutter_map_keys = 0
      let g:gitgutter_sign_column_always = 1

    Plug 'tpope/vim-fugitive'

    Plug 'vim-airline/vim-airline-themes' | Plug 'vim-airline/vim-airline'
      let g:airline#extensions#disable_rtp_load = 1
      let g:airline_extensions = [ 'branch', 'tabline' ]
      let g:airline_exclude_preview = 1 " remove airline from preview window
      let g:airline_section_z = '%p%% %l:%c' " rearrange percentage/col/line section
      let g:airline_theme = 'badwolf'
      let g:airline_powerline_fonts = 1
      let g:bufferline_echo = 0
      set noshowmode " hide the duplicate mode in bottom status bar

    Plug 'raimondi/delimitmate'
      let g:delimitMate_expand_cr = 1
      let g:delimitMate_expand_space = 1

    "Plug 'Shougo/deoplete.vim'

    "Plug 'ensime/ensime-vim'

    "Plug 'docker/docker'

    Plug 'derekwyatt/vim-scala', { 'for': [ 'scala' ] }

    Plug 'elzr/vim-json', { 'for': [ 'json' ] }

    Plug 'tpope/vim-markdown', { 'for': [ 'md' ] }
      let g:markdown_fenced_languages = ['json', 'bash=sh', 'go']
      autocmd BufNewFile,BufReadPost *.md set filetype=markdown

    Plug 'pangloss/vim-javascript', { 'for': [ 'javascript' ] }
      let javascript_enable_domhtmlcss = 1 " enable HTML/CSS highlighting

  call plug#end()

" Leader mappings

  " [s]ave the current buffer
  nnoremap <silent> <Leader>s :<C-u>write!<CR>

  " [q]uit the current window
  nnoremap <silent> <Leader>q :<C-u>quit!<CR>

" Settings

  " Encoding
  set encoding=utf-8 " ensure proper encoding
  set fileencodings=utf-8 " ensure proper encoding

  " Performance
  set lazyredraw " only redraw when needed
  if exists('&ttyfast') | set ttyfast | endif " if we have a fast terminal

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

  " Identation
  set autoindent " auto-indentation
  set backspace=2 " fix backspace (on some OS/terminals)
  set expandtab " replace tabs by spaces
  set shiftwidth=4 " n spaces when using <Tab>
  set smarttab " insert `shiftwidth` spaces instead of tabs
  set softtabstop=4 " n spaces when using <Tab>
  set tabstop=4 " n spaces when using <Tab>

  " Mouse
  if has('mouse')
    set mouse=a
  endif

  " Spell checking
  if has('spell')
    " set spell
  endif
