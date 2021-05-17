" Last Modified: 2021-01-26 09:04:59
scriptencoding utf-8

" include the default runtime files installed by Cygwin
set rtp^=/usr/share/vim/vimfiles

" Enable syntax highlighting
syntax enable

function! OpenMarkdownPreview() abort
    if exists("s:markdown_job") && job_status(s:markdown_job) ==# 'run'
        call job_stop(s:markdown_job)
        unlet s:markdown_job
    endif
    let s:markdown_job = job_start('grip ' . expand('%:p'))
    if job_status(s:markdown_job) !=# 'run'
        return 0
    endif
    sleep 500m
    silent call system('open http://localhost:6419')
endfunction

function! Grep(pattern, location)
    exe "noautocmd vimgrep /" . a:pattern . "/gj " . a:location
    if (!empty(getqflist()))
        silent exe 'copen'
    endif
endfunction

" Update the Last Modified date for a file
function! UpdateLastModified()
    let last_change_anchor='\(" Last Modified:\s\+\)\d\{4}-\d\{2}-\d\{2} \d\{2}:\d\{2}:\d\{2}'
    let last_change_line=search('\%^\_.\{-}\(^\zs' . last_change_anchor . '\)', 'n')
    if last_change_line != 0
        let last_change_time=strftime('%Y-%m-%d %H:%M:%S', localtime())
        let last_change_text=substitute(getline(last_change_line), '^' . last_change_anchor, '\1', '') . last_change_time
        call setline(last_change_line, last_change_text)
    endif
endfunction

" << Settings >>
if has("multi_byte")
    if &termencoding == ""
        let &termencoding = &encoding
    endif
    set encoding=utf-8
    set fileencodings=ucs-bom,utf-8,latin1
endif
set nocompatible
set list listchars=tab:¤\ ,trail:·,extends:»,precedes:«
set expandtab
set tabstop=2
set nobk
set nu
set title
set statusline=%F%m%r%h%w\ \(%{&ff}\)\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set laststatus=2
set shiftwidth=4
set cmdheight=2
set nowrap
set sidescroll=5
set so=5
set history=50
set ruler
set showcmd
set incsearch
set hlsearch
set backspace=indent,eol,start
set autoindent
set wildmenu wildmode=full
set textwidth=0
set foldmethod=syntax
set autoread
if exists ("+autochdir")
    set autochdir
endif
if (v:version >= 703)
    set colorcolumn=80
endif
let mapleader='\'
if has("win32unix")
    set mouse=a
endif
if has('persistent_undo')
    set undofile " Enable persistent undo
    set undodir=~/.vim/undo/ " Store undofiles in a tmp dir
endif
" Not sure what the intent of these 2 lines were:
"let &t_AF="\e[38;5;%dm"
"let &t_AB="\e[48;5;%dm"

set background=dark
set cursorline
colo gruvbox8

if (v:version >= 740)
    set completeopt=menu,menuone,preview,longest,noselect,noinsert

    set showtabline=2
    set spelllang=en_ca
    set switchbuf=useopen,usetab
endif

if (v:version >= 802)
  set mouse=a
  set signcolumn=number
  set completeopt=menu,menuone,popup,noselect,noinsert
  set completepopup=align:menu,border:off,highlight:Pmenu
  set spelloptions=camel
endif

" << Mappings >>

" Break undo cycle
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

" Cycle through tabs
nnoremap <leader>] :tabn<CR>
nnoremap <leader>[ :tabp<CR>

" Toggle search highlighting
nnoremap <leader>h :set invhlsearch<CR>

" Open files in tabs based on extension or name under cursor
nnoremap <leader>to <C-W>gf

" Open files based on extension or name under cursor
nnoremap <leader>o gf

" Get the syntax id for the item under the cursor
nnoremap <leader>y :echo synIDattr(synID(line("."), col("."), 1), "name")<CR>

" View as hex
nnoremap <leader>x :%!xxd<CR>

if has("win32unix")
    nnoremap <silent> <leader>e :!cygstart explorer .<CR>
elseif has("win32")
    nnoremap <silent> <leader>e :!start explorer .<CR>
endif

nnoremap <silent> <leader>g :call Grep(expand("<cword>"), "%:p")<CR>

nnoremap <silent> <leader>m :call OpenMarkdownPreview()<CR>

if (v:version >= 700)
    nnoremap <leader>s :set spell! spell?<CR>
endif

vnoremap <Up> k
vnoremap <Down> j
vnoremap <Left> h
vnoremap <Right> l

" << Commands >>
com! -nargs=+ Grep :call Grep(<f-args>)

" << Autocommands >>

if has("autocmd")
    " enable filetype plugin and set indent
    filetype plugin indent on

    " Don't spellcheck CamelCase words
    "au Syntax * syn match CamelCase "\<\%(\u\l*\)\{2,}\>" transparent containedin=.*Comment.* contains=@NoSpell contained

    " When editing a file, always jump to the last known cursor position.
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

    " Open a quickfix window with grep
    au QuickFixCmdPost *grep* cwindow

    " Enable spell check by default for text and markdown files
    au FileType text,markdown setlocal spell

    augroup vimrc
        au!

        " Update the Last Modified time for vim and cpp files
        au BufWritePre *vimrc,*.vim call UpdateLastModified()

        " Reload .vimrc/.gvimrc when it's been edited
        au BufWritePost .vimrc source ~/.vimrc
        au BufWritePost .gvimrc source ~/.gvimrc
    augroup END
endif

" ALE settings
"let g:ale_completion_enabled = 1
"let g:ale_completion_autoimport = 1

"let g:ale_linters = {}
"let g:ale_linters.elixir = ['elixir-ls']
"let g:ale_linters.go = ['gopls']
"let g:ale_linters.javascript = ['tsserver']
"let g:ale_linters.javascript = ['eslint', 'tsserver']
"let g:ale_linters.javascript = ['flow-language-server']
"
"let g:ale_fixers = {'*': ['remove_trailing_lines', 'trim_whitespace']}
"let g:ale_fixers.elixir = ['mix_format']
"let g:ale_fixers.go = ['gofmt']
"let g:ale_fixers.javascript = ['eslint']
"
"let g:ale_go_gopls_executable = '/Users/csutclif/go/bin/gopls'
"let g:ale_elixir_elixir_ls_release = '/Users/csutclif/Documents/Code/elixir-ls/release'
"let g:ale_sign_column_always = 1
"set omnifunc=ale#completion#OmniFunc
"
"nnoremap <silent> K :ALEHover<CR>

" << Colour Setting >>

" Set the cursor to match the same behaviour as GVim from within MinTTY
if has("win32unix") && &term =~ "xterm"
    set t_Co=256

    " Disable bold font
    set t_md=

    " mintty specific method that remaps escape
    let &t_SI.="\e[5 q"
    let &t_EI.="\e[1 q"
    let &t_ti.="\e[1 q\e[?7727h"
    let &t_te.="\e[0 q\e[?7727l"
    noremap <Esc>O[ <Esc>
    noremap! <Esc>O[ <C-c>
endif

" Set the cursor to match the same behaviour as GVim from within iTerm2
if has("mac") && $TERM_PROGRAM =~ "iTerm.app"
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_SR = "\<Esc>]50;CursorShape=2\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL

