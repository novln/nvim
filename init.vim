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

    if has('nvim') && has('python3')

      function! DoNvimPluginUpdate(arg)
        UpdateRemotePlugins
      endfunction

      function! BuildDeopleteGo(arg)
        :echom "install/update github.com/nsf/gocode"
        :silent !go get -u github.com/nsf/gocode
        :silent !make
      endfunction

      Plug 'derekwyatt/vim-scala' | Plug 'ensime/ensime-vim', { 'for': [ 'scala', 'sbt' ], 'do': function('DoNvimPluginUpdate') }
        let g:scala_sort_across_groups = 1 " split import in three groups
        let g:scala_first_party_namespaces = '\(actions\|controllers\|components\|services\|views\|models\)'
        let g:scala_use_default_keymappings = 0
        autocmd BufEnter,BufWritePost *.scala :EnTypeCheck
        autocmd BufWritePost *.scala call FormatScala()
        function! FormatScala()
          :SortScalaImports
          "TODO: Use scalariform
        endfunction
        autocmd FileType scala call s:define_scala_leader_mappings()
        function! s:define_scala_leader_mappings()

          " [o] Organize imports
          nnoremap <silent> <Leader>o :<C-u>EnOrganizeImports<CR>

          " [i] Suggest imports
          nnoremap <silent> <Leader>i :<C-u>EnSuggestImport<CR>

        endfunction

      Plug 'Shougo/deoplete.nvim', { 'do': function('DoNvimPluginUpdate') }
        let g:deoplete#enable_at_startup = 1 " enable at startup
        let g:deoplete#max_abbr_width = 0 " no width limit
        let g:deoplete#max_menu_width = 0 " no width limit
        let g:deoplete#enable_smart_case = 1 " enable smart case
        "let g:deoplete#file#enable_buffer_path = 1
        set completeopt=menuone,noinsert
        inoremap <silent><expr> <TAB> pumvisible() ? "\<C-y>" : "\<TAB>"

      Plug 'zchee/deoplete-go', { 'for': [ 'go' ], 'do': function('BuildDeopleteGo') }
        let g:deoplete#sources#go#gocode_binary = $GOPATH . '/bin/gocode'
        let g:deoplete#sources#go#use_cache = 1
        let g:deoplete#sources#go#json_directory = b:cache_directory . '/deoplete-go'

    endif

    function! BuildVimGo(arg)
      :echom "install/update github.com/nsf/gocode"
      :silent !go get -u github.com/nsf/gocode
      :echom "install/update github.com/alecthomas/gometalinter"
      :silent !go get -u github.com/alecthomas/gometalinter
      :echom  "install/update golang.org/x/tools/cmd/goimports"
      :silent !go get -u golang.org/x/tools/cmd/goimports
      :echom "install/update golang.org/x/tools/cmd/guru"
      :silent !go get -u golang.org/x/tools/cmd/guru
      :echom "install/update golang.org/x/tools/cmd/gorename"
      :silent !go get -u golang.org/x/tools/cmd/gorename
      :echom "install/update github.com/golang/lint/golint"
      :silent !go get -u github.com/golang/lint/golint
      :echom "install/update github.com/kisielk/errcheck"
      :silent !go get -u github.com/kisielk/errcheck
      :echom "install/update github.com/jstemmer/gotags"
      :silent !go get -u github.com/jstemmer/gotags
      :echom "install/update github.com/klauspost/asmfmt/cmd/asmfmt"
      :silent !go get -u github.com/klauspost/asmfmt/cmd/asmfmt
      :echom "install/update github.com/fatih/motion"
      :silent !go get -u github.com/fatih/motion
      :echom "install/update github.com/zmb3/gogetdoc"
      :silent !go get -u github.com/zmb3/gogetdoc
      :echom "install/update github.com/josharian/impl"
      :silent !go get -u github.com/josharian/impl
    endfunction

    Plug 'fatih/vim-go', { 'for': [ 'go' ], 'do': function('BuildVimGo') }
      let g:go_highlight_functions = 1
      let g:go_highlight_methods = 1
      let g:go_highlight_structs = 1
      let g:go_highlight_interfaces = 1
      let g:go_highlight_operators = 1
      let g:go_highlight_build_constraints = 1
      let g:go_term_enabled = 1
      autocmd FileType go call s:define_go_leader_mappings()
      function! s:define_go_leader_mappings()

        " [r] Run go application
        nnoremap <silent> <Leader>r :<C-u>GoRun<CR>

        " [b] Build go application
        nnoremap <silent> <Leader>b :<C-u>GoBuild<CR>

      endfunction

    Plug 'elzr/vim-json', { 'for': [ 'json' ] }

    Plug 'tpope/vim-markdown', { 'for': [ 'md' ] }
      let g:markdown_fenced_languages = ['json', 'bash=sh', 'go']
      autocmd BufNewFile,BufReadPost *.md set filetype=markdown

    Plug 'pangloss/vim-javascript', { 'for': [ 'javascript' ] }
      let javascript_enable_domhtmlcss = 1 " enable HTML/CSS highlighting

  call plug#end()

" Inlined plugins

  " highlight search matches (except while being in insert mode)
  autocmd VimEnter,InsertLeave * set hlsearch
  autocmd InsertEnter * setl nohlsearch

  " highlight cursor line (except while being in insert mode)
  autocmd VimEnter,InsertLeave,BufEnter * set cursorline
  autocmd InsertEnter * setl nocursorline

  " Automatically remove trailing whitespace when saving
  autocmd BufWritePre * :%s/\s\+$//e

" Enhanced mappings

  " Better `j` and `k`
  nnoremap <silent> j gj
  vnoremap <silent> j gj
  nnoremap <silent> k gk
  vnoremap <silent> k gk

  " Copy from the cursor to the end of line using Y (matches D behavior)
  nnoremap <silent> Y y$

  " Disable annoying mappings
  noremap  <silent> <C-c>  <Nop>
  noremap  <silent> <C-w>f <Nop>
  noremap  <silent> <Del>  <Nop>
  noremap  <silent> <F1>   <Nop>
  noremap  <silent> q:     <Nop>

  " reselect visual block after indent
  vnoremap <silent> < <gv
  vnoremap <silent> > >gv

" Leader mappings

  " [s] Save the current buffer
  nnoremap <silent> <Leader>s :<C-u>write!<CR>

  " [q] Quit the current window
  nnoremap <silent> <Leader>q :<C-u>quit<CR>

  " [z] Undo modification
  nnoremap <silent> <Leader>z  :<C-u>undo<CR>

  " [y] Redo modification
  nnoremap <silent> <Leader>y :<C-u>redo<CR>

  " [c] Copy selection in clipboard
  vmap <silent> <Leader>c y

  " [x] Cut selection in clipboard
  vmap <silent> <Leader>x d

  " [v] Paste content from clipboard
  nmap <silent> <Leader>v p
  vmap <silent> <Leader>v p

" Settings

  " Cursor
  set nostartofline " leave my cursor alone
  set scrolloff=10 " keep at least 10 lines after the cursor when scrolling
  set sidescrolloff=10 " (same as `scrolloff` about columns during side scrolling)
  set virtualedit=block " allow the cursor to go in to virtual places

  " Encoding
  set encoding=utf-8 " ensure proper encoding
  set fileencodings=utf-8 " ensure proper encoding

  " Performance
  set lazyredraw " only redraw when needed
  if exists('&ttyfast') | set ttyfast | endif " if we have a fast terminal
  set updatetime=750 " reduce vim delay clock

  " Buffer
  set autoread " watch for file changes by other programs
  set autowrite " automatically save before :next and :make
  set hidden " when a tab is closed, do not delete the buffer

  " UI/UX
  "set shell=zsh " shell for :sh
  set textwidth=120 " 120 characters line
  set showmatch " highlight matching bracket, braces, etc...

  " VIM
  set nobackup " disable backup files
  set noswapfile " disable swap files
  set secure " protect the configuration files
  set nofoldenable " disable folding
  set history=1000 " increase history size

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
  set listchars=tab:▒░ " define invisible char
  set list " print invisible char

  " Search 'n Replace
  set ignorecase " ignore case when searching
  set smartcase " smarter search case

  " Undo
  if has('persistent_undo')
    set undofile
    set undolevels=1000
    set undoreload=10000
    let &undodir = b:cache_directory. '/undo'
  endif

  " Mouse
  if has('mouse')
    set mouse=a
  endif

  " Spell checking
  if has('spell')
    " set spell
  endif
