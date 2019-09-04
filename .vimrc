" ┌───────────────────────────────────┐
" │      VimFiles by Lucas Caton      │
" ├───────────────────────────────────┤
" │ http://lucascaton.com.br/         │
" │ http://blog.lucascaton.com.br/    │
" │ http://www.twitter.com/lucascaton │
" └───────────────────────────────────┘


" ┌───────────────────────────────────┐
" │              Vundle               │
" └───────────────────────────────────┘

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/vundle'

Plugin 'vim-airline/vim-airline'
" Plugin 'chriskempson/base16-vim'
" Plugin 'danro/rename.vim'
Plugin 'godlygeek/tabular'
Plugin 'gorkunov/smartpairs.vim'
Plugin 'henrik/vim-ruby-runner'
Plugin 'int3/vim-extradite'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdcommenter'

" It colorizes CSS codes.
Plugin 'lilydjwg/colorizer'

" BEGIN: snippet plugins
" Plugin 'MarcWeber/vim-addon-mw-utils'
" Plugin 'tomtom/tlib_vim'
" Plugin 'msanders/snipmate.vim'
" Plugin 'honza/vim-snippets'
" END: snippet plugins


Plugin 'rking/ag.vim'
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
" Plugin 'terryma/vim-multiple-cursors'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-endwise'
Plugin 'godlygeek/csapprox'
Plugin 'tpope/vim-fugitive'
Plugin 'shumphrey/fugitive-gitlab.vim'
Plugin 'tpope/vim-rhubarb'
Plugin 'tpope/vim-rails'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-bundler'
" Plugin 'tpope/vim-rake'
Plugin 'tpope/vim-projectionist'
Plugin 'tpope/vim-cucumber'
Plugin 'vim-scripts/matchit.zip'
" Plugin 'Peeja/vim-cdo'
Plugin 'tpope/vim-surround'
Plugin 'vim-scripts/ctags.vim'
Plugin 'Shougo/neocomplete'
Plugin 'Shougo/neosnippet'
Plugin 'Shougo/neosnippet-snippets'
Plugin 'Shougo/context_filetype.vim'
Plugin 'chrisbra/csv.vim'
Plugin 'flazz/vim-colorschemes'
Plugin 'jlanzarotta/bufexplorer'
" Plugin 'blueyed/vim-diminactive'
Plugin 'wesQ3/vim-windowswap'
"Plugin 'rhysd/vim-crystal'
Plugin 'dhruvasagar/vim-table-mode'
Plugin 'vim-python/python-syntax'
Plugin 'Yggdroot/indentLine'
call vundle#end()

filetype plugin indent on

set tags=./tags,tags

let mapleader="\\"


" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" Switch between last two buffers
map <leader><leader> <C-^>

" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins

" ┌───────────────────────────────────┐
" │       Plugins customizations      │
" └───────────────────────────────────┘

" ┌───────────────────────────────────┐
" │   Neocomplete autocomplete        │
" └───────────────────────────────────┘

source ~/.vimrc.hexmode
source ~/.vimrc.functions
source ~/.vimrc.windows
source ~/.vimrc.python
source ~/.vimrc.indentline

" NERDTree
nmap <c-e> :NERDTreeToggle<CR>:vertical res 40<CR><C-w>=
let NERDTreeHighlightCursorline=1
let NERDTreeQuitOnOpen=1
let NERDTreeIgnore = ['tmp', '.yardoc', 'pkg']
let NERDTreeCascadeSingleChildDir = 0
map <leader>ff :NERDTreeFind<cr>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" NERDTree Commenter toggle \cc
map <Leader>cc <Plug>NERDCommenterToggle

" Tabular
inoremap <silent> <Bar> <Bar><Esc>:call <SID>align()<CR>a

colorscheme Tomorrow-Night-Bright

set foldmethod=indent
set cursorline
set modelines=0
set shiftwidth=2

" keep history when switching buffers
set hidden

" Allow copying between clipboards
set clipboard=unnamed
set clipboard+=unnamed

set synmaxcol=128
set ttyscroll=10
set encoding=utf-8
set nowrap
set nowritebackup
set noswapfile
set nobackup
set hlsearch
set ignorecase
set smartcase
set backspace=2  " allow backspace key to erase previously entered characters,

" Relative line numbers in normal mode
set rnu
au InsertEnter * :set nu
au InsertLeave * :set rnu
au FocusLost * :set nu
au FocusGained * :set rnu

function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_working_path_mode = ''
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = 'node_modules\|coverage'
map <Leader>p :CtrlPClearAllCaches<CR>

" vim-airline
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline_section_b = ''
let g:airline_section_x = ''
let g:airline_section_y = ''
" ┌───────────────────────────────────┐
" │             Settings              │
" └───────────────────────────────────┘

" Completion
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType python     set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html       set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css        set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml        set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php        set omnifunc=phpcomplete#CompletePHP
autocmd FileType c          set omnifunc=ccomplete#Complete

autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1

" Remove trailing spaces on save
autocmd BufWritePre * :%s/\s\+$//e

" Include all files below where we start; for vim-rails gf to work.
set path+=*/*

" Autoindent with two spaces, always expand tabs
set tabstop=2
set shiftwidth=2
set expandtab
" autocmd BufRead,BufWritePre * normal gg=G

" Folding settings
" set foldmethod=indent   " fold based on indent
" set foldnestmax=10      " deepest fold is 3 levels
set nofoldenable        " dont fold by default
" set foldlevel=1

set wildmode=list:longest " make cmdline tab completion similar to bash
set wildmenu " enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ " stuff to ignore when tab completing

" Vertical / horizontal scroll off settings
set scrolloff=3
set sidescrolloff=7
set sidescroll=1

set cf " Enable error files & error jumping.
set clipboard+=unnamed " Yanks go on clipboard instead.
set history=256 " Number of things to remember in history.
set autowrite " Writes on make/shell commands
set ruler " Ruler on
set nu " Line numbers on
set wrap " Line wrapping on
set timeoutlen=250 " Time to wait after ESC (default causes an annoying delay)

" Highlight all search results
set incsearch

" %% Expands to current file folder
cnoremap %% <C-R>=expand('%:h').'/'<cr>
au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null
au BufRead,BufNewFile *.cap set filetype=ruby
au BufReadPost *.md set syntax=html

" Maps Alt-[h,j,k,l] to resizing a window split
map <silent> <C-h> 2<C-w><
map <silent> <C-j> 2<C-W>-
map <silent> <C-k> 2<C-W>+
map <silent> <C-l> 2<C-w>>

" Resize window
noremap ff :resize 100 <cr> <bar> :vertical resize 220<cr>
noremap fm <C-w>=

" copy / paste clipboard
noremap <leader>yy "+y
noremap <leader>pp "+p

" Format JSON
map <Leader>fj :%!underscore print <CR>

" format the entire file
nmap <leader>fef ggVG=

" Forcing the use of hjkl keys to navigate
" noremap <Up> <nop>
" noremap <Down> <nop>
" noremap <Left> <nop>
" noremap <Right> <nop>
" inoremap <Up> <nop>
" inoremap <Down> <nop>
" inoremap <Left> <nop>
" inoremap <Right> <nop>

" Highlight long lines
" let w:m2=matchadd('Search',   '\%>80v.\+', -1)
" let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)

" Open splits at right side (and below)
set splitright
set splitbelow

" Never ever let Vim write a backup file! They did that in the 70’s.
" Use modern ways for tracking your changes (like git), for God’s sake
set nobackup
set noswapfile

" Syntastic configs
let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
let g:syntastic_mode_map={ 'mode': 'active',
      \ 'active_filetypes': ['ruby', 'javascript'],
      \ 'passive_filetypes': ['html'] }

" ┌───────────────────────────────────┐
" │               Theme               │
" └───────────────────────────────────┘

" Fonts for Linux
" set guifont=Bitstream\ Vera\ Sans\ Mono\ 9
" set guifont=Monospace\ 10

" Fonts for Mac
set guifont=Monaco\ for\ Powerline:h15
" set guifont=Anonymous\ Pro:h17
" set guifont=Inconsolata-dz:h17

" Don't show the top bar
set guioptions-=T

" Syntax on
syntax on

if has("gui_running")
  set lines=57
  set columns=237

  " Highlight the line and the column of the current position of cursor
  set cursorline
  set cursorcolumn
  hi CursorLine guibg=#222222
  hi CursorColumn guibg=#222222
endif

if has("gui_running") || $TERM == "xterm-256color"
  set t_Co=256
  set background=dark " light
  let base16colorspace=256 " Access colors present in 256 colorspace
  " colorscheme base16-default
  colorscheme badwolf
else
  let g:CSApprox_loaded = 0
endif

" ┌───────────────────────────────────┐
" │             Functions             │
" └───────────────────────────────────┘

set list listchars=tab:»·,trail:·

" Collapse multiple blank lines (regardless of quantity) into a single blank line.
"function CollapseMultipleBlankLines()
"g/^\_$\n\_^$/d
"''
":endfunction
"map <leader>- :call CollapseMultipleBlankLines()<CR>
"map! <leader>- :call CollapseMultipleBlankLines()<CR>

" Invert lines
"function InvertLines()
"g/^/m0
"''
":endfunction
"nnoremap <D-i> :call InvertLines()<cr>

" Convert Ruby 1.8 to 1.9 Hash Syntax - http://robots.thoughtbot.com/convert-ruby-1-8-to-1-9-hash-syntax
"function ConvertRubyHashSyntax()
"%s/:\([^ ]*\)\(\s*\)=>/\1:/g
"''
":endfunction
"nnoremap <leader>h :call ConvertRubyHashSyntax()<cr>

"autocmd BufWritePre * :%s/\s\+$//e

" Bind A (backward slash) to Ag shortcut
map <leader>a :Ag -i<SPACE>

" Bind K to search for the word under cursor
nnoremap K :Ag "\b<C-R><C-W>\b"<CR>:cw<CR>

" Paste but keep original in buffer
vnoremap <S-P> "_dP

" Auto complete
let g:stop_autocomplete=0

" RSpec focus
function! s:Preserve(command)
  " Save cursor position
  let l = line(".")
  let c = col(".")

  " Do the business
  execute a:command

  " Restore cursor position
  call cursor(l, c)
  " Remove search history pollution and restore last search
  call histdel("search", -1)
  let @/ = histget("search", -1)
endfunction

"function! s:AddFocusTag()
"call s:Preserve("normal! ^ / do\<cr>C, focus: true do\<esc>")
"endfunction
":nnoremap <leader>a :AddFocusTag<CR>
"command! -nargs=0 AddFocusTag call s:AddFocusTag()

"function! s:RemoveAllFocusTags()
"call s:Preserve("%s/, focus: true//e")
"endfunction
":nnoremap <leader>d :RemoveAllFocusTags<CR>
"command! -nargs=0 RemoveAllFocusTags call s:RemoveAllFocusTags()

function! OpenGemfile()
  if filereadable("Gemfile")
    execute ":tab drop Gemfile"
  end
endfunction
map <Leader>g :call OpenGemfile()<CR>

function! OpenRoutes()
  if filereadable("config/routes.rb")
    execute ":tab drop config/routes.rb"
  end
endfunction
map <Leader>r :call OpenRoutes()<CR>

function! OpenSpecHelper()
  if filereadable("spec/spec_helper.rb")
    execute ":tab drop spec/spec_helper.rb"
  end
endfunction
map <Leader>s :call OpenSpecHelper()<CR>

function! OpenFactoryFile()
  if filereadable("spec/support/factories.rb")
    execute ":tab drop spec/support/factories.rb"
  else
    if filereadable("spec/factories.rb")
      execute ":tab drop spec/factories.rb"
    end
  end
endfunction
map <Leader>f :call OpenFactoryFile()<CR>

" Search and replace selected text (http://stackoverflow.com/questions/676600/vim-search-and-replace-selected-text)
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" Mapping Y to yank from current cursor position till end of line
noremap Y y$


" ┌───────────────────────────────────┐
" │             Shortcuts             │
" └───────────────────────────────────┘

" Ctrl+R reloads the ~/.vimrc file
nnoremap <F12> :source ~/.vimrc

" Ctrl+L clear the highlight as well as redraw
" nnoremap <C-L> :nohls<CR><C-L>

" Improve 'n' command (for searches)
nmap n nzz
nmap N Nzz

" Mappings to move lines: http://vim.wikia.com/wiki/Moving_lines_up_or_down
nnoremap <D-j> :m .+1<CR>==
nnoremap <D-k> :m .-2<CR>==
inoremap <D-j> <Esc>:m .+1<CR>==gi
inoremap <D-k> <Esc>:m .-2<CR>==gi
vnoremap <D-j> :m '>+1<CR>gv=gv
vnoremap <D-k> :m '<-2<CR>gv=gv

" A trick for when you forgot to sudo before editing a file that requires root privileges (typically /etc/hosts).
" This lets you use w!! to do that after you opened the file already:
cmap w!! w !sudo tee % >/dev/null

" ┌───────────────────────────────────┐
" │     Shortcuts for Linux (Gvim)    │
" └───────────────────────────────────┘

" Ctrl+C to copy and Ctrl+P to paste
" vnoremap <C-C> "+y
" inoremap <C-P> <ESC>"+pa
" nnoremap <C-P> "+p

" Ctrl+S to save the current file
nmap <c-s> :w<CR>
imap <c-s> <Esc>:w<CR>

" Management tabs
nnoremap <C-t> :tabnew<cr>
nnoremap <C-T> :tabnew<cr>
nnoremap <A-w> :q<cr>
nnoremap <A-W> :q<cr>
nnoremap <C-n> :tabn<cr>


" ┌───────────────────────────────────┐
" │              Aliases              │
" └───────────────────────────────────┘

cab W w
cab Q q
cab Wq wq
cab wQ wq
cab WQ wq
cab tabe tab drop
cab Tabe tab drop
cab E e

" ┌───────────────────────────────────┐
" │        Syntax Highlighting        │
" └───────────────────────────────────┘

au BufNewFile,BufRead *.thor       set filetype=ruby
au BufNewFile,BufRead Guardfile    set filetype=ruby
au BufNewFile,BufRead .pryrc       set filetype=ruby
au BufNewFile,BufRead Vagrantfile  set filetype=ruby
au BufNewFile,BufRead *.pp         set filetype=ruby
au BufNewFile,BufRead *.prawn      set filetype=ruby
au BufNewFile,BufRead Appraisals   set filetype=ruby
au BufNewFile,BufRead .psqlrc      set filetype=sql
au BufNewFile,BufRead *.less       set filetype=css
au BufNewFile,BufRead bash_profile set filetype=sh
au BufNewFile,BufRead Capfile      set filetype=ruby
au BufNewFile,BufRead *.hbs        set filetype=html
au BufNewFile,BufRead *.jsx.erb    set filetype=javascript

" ┌───────────────────────────────────┐
" │        VIM CSV Highlighting       │
" └───────────────────────────────────┘
hi CSVColumnEven term=bold ctermbg=4 guibg=DarkBlue
hi CSVColumnOdd  term=bold ctermbg=5 guibg=DarkMagenta
hi CSVColumnHeaderEven term=bold,standout ctermbg=5
hi CSVColumnHeaderOdd  term=bold,standout ctermbg=White ctermfg=5

"Plugin key-mappings.
"Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

"SuperTab like snippets behavior.
"Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
imap <expr><TAB>
      \ pumvisible() ? "\<C-n>" :
      \ neosnippet#expandable_or_jumpable() ?
      \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
let g:neosnippet#snippets_directory='~/.vim/bundle/neosnippet-snippets/neosnippets,~/.vim/snippets'

source ~/.vimrc.neocomplete

" F6 will call Ctrl-P with the current word as the arg
map <F6> <C-P><C-\>w
