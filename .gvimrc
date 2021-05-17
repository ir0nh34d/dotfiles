" Last Modified: 2020-10-19 11:38:27

set selectmode=
set lines=40
set columns=140
set guioptions=Lte
set guicursor=a:blinkon0
if has("gui_gtk2")
    set guifont=Luxi\ Mono\ 11
elseif has("x11")
    set guifont=-*-*-medium-r-normal-*-18-*-*-*-c-*-*-*
elseif has("gui_win32")
    set guifont=Consolas:h11:cDEFAULT
elseif has("gui_macvim")
    set guifont=monaco:h14
    " Set :sh to execute in fullwindow
    set guioptions+=!
    " Temporary fix to correct an issue in MacVim where encoding is not set
    " properly - no longer needed - see https://github.com/macvim-dev/macvim/issues/1033
    " let $LANG='en_CA.UTF-8'
endif
set guitablabel=%m\ %t
set guioptions+=e
if has("transparency")
    au FocusLost * set transparency=10
    au FocusGained * set transparency=0
endif
