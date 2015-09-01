"
" Important settings.
"
set nocompatible                    " Disable vi compatibility mode.

"
" Vundle plugin manager.
"
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'          " Plugin manager manages self.
Plugin 'morhetz/gruvbox.git'        " Colorscheme.
Plugin 'davidhalter/jedi-vim'       " Python autocompletion.
Plugin 'scrooloose/nerdtree'        " File explorer.
Plugin 'sudar/vim-arduino-syntax'   " Arduino syntax highlighting.
Plugin 'scrooloose/syntastic'       " Syntax checking.
call vundle#end()

"
" Settings.
"
syntax on                           " Syntax highlighting.
set hlsearch                        " Highlight search results.
colorscheme gruvbox                 " Colorscheme.
set background=dark                 " Dark background
set cursorline                      " Highlight current line.
set number                          " Display row numbers in editor.
set ruler                           " Display row and column numbers in ruler.
set backspace=indent,eol,start      " Make backspace work as expected.
set nolist                          " Hide special whitespace characters.
set visualbell                      " Do not make audible error sounds.
set showcmd                         " Visually display command being entered.

"
" Indentation.
"
filetype plugin indent on
set autoindent
set ts=4
set sw=4
set sts=4
set expandtab                       " Expand tabs for all languages...
"autocmd FileType c set noexpandtab  " ... except c, because Linux.

"
" Shortcuts:
" F2    Toggle file explorer.
" F3    Open code dir.
" F4    Open Dropbox.
"
nnoremap <silent> <F2> :NERDTreeToggle<CR>
nnoremap <silent> <F3> :NERDTree F:\Code<CR>
nnoremap <silent> <F4> :NERDTree F:\Dokument\Dropbox\Codez<CR>

"
" NERDTree settings.
"
let NERDTreeWinSize=50

"
" MACRO: F6: Language specific "run code" functions.
"
nnoremap <silent> <F6> :<CR>
command! Py w !python
autocmd FileType python nnoremap <silent> <F6> :Py<CR>
autocmd FileType c nnoremap <silent> <F6> :make<CR>

"
" MACRO: Rename variable at cursor.
"
" Local replace.
"nnoremap gr gd[{V%::s/<C-R>///gc<left><left><left>
autocmd FileType c nnoremap <silent> gr vi{:s/<C-r><C-w>//gc<left><left><left><Space><Backspace>
" Global replace.
nnoremap gR :%s/\<<C-r><C-w>\>//gc<left><left><left><Space><Backspace>

"
" QUIRK: Arduino syntax is not applied correctly.
"
au BufRead,BufNewFile *.pde set filetype=arduino
au BufRead,BufNewFile *.ino set filetype=arduino
autocmd FileType arduino setlocal ts=2 sts=2 sw=2   " Indent 2 spaces as per the Arduino IDE defaults.

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
" GVIM: OS-specific settings.
"
if has("gui_running")
  if has("gui_gtk2")
"    set guifont=Inconsolata\ 12        " Set font.
  elseif has("gui_macvim")
"    set guifont=Menlo\ Regular:h14     " Set font.
  elseif has("gui_win32")
    set guifont=Consolas:h10            " Set font.
    au GUIEnter * simalt ~x             " Maximize GVim on startup.
  endif
endif

"
" Reload:
" :so %
"
