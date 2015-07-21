"
" Important settings.
"
set nocompatible                " Disable vi compatibility mode.

"
" Vundle plugin manager.
"
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'      " Plugin manager manages self.
Plugin 'morhetz/gruvbox.git'    " Colorscheme.
Plugin 'davidhalter/jedi-vim'   " Python autocompletion.
call vundle#end()

"
" Settings.
"
syntax on                       " Syntax highlighting.
set hlsearch                    " Highlight search results.
colorscheme gruvbox             " Colorscheme.
set background=dark             " Dark background
set ruler                       " Display row and column numbers.
set backspace=indent,eol,start  " Make backspace work as expected.

"
" Indentation.
"
filetype plugin indent on
set autoindent
set ts=4
set sw=4
set sts=4
set expandtab

"
" Shortcuts:
" F2    Open code dir
" F3    Open Dropbox
"
nnoremap <silent> <F2> :Ex F:\Code<CR>
nnoremap <silent> <F3> :Ex F:\Dokument\Dropbox\Codez<CR>

"
" MACRO: Run python from buffer.
"
command Py w !python
nnoremap <silent> <F6> :Py<CR>

"
" MACRO: Rename variable at cursor.
"
" Local replace
nnoremap gr gd[{V%::s/<C-R>///gc<left><left><left>
" Global replace
nnoremap gR gD:%s/<C-R>///gc<left><left><left>

"
" GVIM: Settings.
"
if has("gui_running")
  " Windows fix
  set directory=.,$TEMP
  set guioptions-=m
  set guioptions-=T
  set guicursor+=a:blinkon0
  autocmd InsertEnter,InsertLeave * set cul!
  set autochdir
endif

"
" GVIM: Remember session.
"
if has("gui_running")
" set sessionoptions-=blank,buffers,curdir,folds,help,options,tabpages
  set sessionoptions-=blank,curdir,folds,help,options,tabpages
  set sessionoptions+=buffers,winsize,resize,winpos
  autocmd VIMEnter * :source ~\.vim_session
  autocmd VIMLeave * :mksession! ~\.vim_session
endif

"
" GVIM: Set font.
"
if has("gui_running")
  if has("gui_gtk2")
"    set guifont=Inconsolata\ 12
  elseif has("gui_macvim")
"    set guifont=Menlo\ Regular:h14
  elseif has("gui_win32")
    set guifont=Consolas:h10
  endif
endif
