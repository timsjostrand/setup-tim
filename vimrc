"
" Important settings.
"
set nocompatible                    " Disable vi compatibility mode.
set encoding=utf-8                  " This is probably what I want.
scriptencoding utf-8

"
" Vundle plugin manager.
"
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'              " Plugin manager manages self.
Plugin 'morhetz/gruvbox.git'            " Colorscheme.
Plugin 'scrooloose/nerdtree'            " File explorer.
Plugin 'sudar/vim-arduino-syntax'       " Arduino syntax highlighting.
Plugin 'scrooloose/syntastic'           " Syntax checking.
Plugin 'ntpeters/vim-better-whitespace' " Whitespace highlighting.
Plugin 'xolox/vim-misc'                 " Dependency for vim-session.
Plugin 'xolox/vim-session'              " Session manager.
Plugin 'gcmt/taboo.vim'                 " Tab manager.
Plugin 'kien/ctrlp.vim'                 " Fuzzy file search.
Plugin 'Rip-Rip/clang_complete'         " Auto-complete with clang.
Plugin 'mhinz/vim-startify'             " Startup screen.
call vundle#end()

"
" Settings.
"
syntax on                           " Syntax highlighting.
set hlsearch                        " Highlight search results.
set incsearch                       " Search as characters are entered.
colorscheme gruvbox                 " Colorscheme.
set background=dark                 " Dark background
set cursorline                      " Highlight current line.
set number                          " Display row numbers in editor.
set ruler                           " Display row and column numbers in ruler.
set backspace=indent,eol,start      " Make backspace work as expected.
set nolist                          " Hide special whitespace characters.
set visualbell                      " Do not make audible error sounds.
set showcmd                         " Visually display command being entered.
"set exrc                            " Project-specific settings.
set colorcolumn=+40                 " Display gutter column.

"
" Indentation.
"
filetype plugin indent on
set autoindent
set ts=4
set sw=4
set sts=4
set expandtab                       " Expand tabs for all languages...
autocmd FileType c set noexpandtab  " ... except c, because Linux.
autocmd FileType c set textwidth=80
autocmd FileType cmake set expandtab

"
" Custom syntax highlighting.
"
let c_space_errors=1                            " C: Highlight space errors.
autocmd Syntax c syn match cSpaceError /    /   " C: Highlight four spaces.
autocmd Syntax c syn match cType /\w\+_t\ze\W/  " C: Highlight typedefs named *_t.

"
" Shortcuts:
" F2    Toggle file explorer.
" F3    Open code dir.
" F4    Open Dropbox.
" ö     Go back in edit list.
" ä     Go forward in edit list.
"
nnoremap <silent> <F2> :NERDTreeToggle<CR>
nnoremap <silent> <F3> :NERDTree F:\Code<CR>
nnoremap <silent> <F4> :NERDTree F:\Dokument\Dropbox\Codez<CR>
nnoremap <silent> ö g;
nnoremap <silent> ä g,

"
" NERDTree settings.
"
let NERDTreeWinSize=50
let NERDTreeShowBookmarks=1

"
" Ctrl-P excludes:
" - build/ directories (large and mostly generated files)
" - .o-files
"
set wildignore+=*/build/*,*\\build\\*,*.o

"
" MACRO: F6: Language specific "run code" functions.
"
nnoremap <silent> <F6> :<CR>
command! Py w !python
autocmd FileType python nnoremap <silent> <F6> :Py<CR>
autocmd FileType c nnoremap <silent> <F6> :make<CR>

function! CheckTimBuild()
    if filereadable("build/mingw/Debug/Makefile")
        let t:MINGW_BUILD_DIR = getcwd() . "/build/mingw/Debug/"
        nnoremap <silent> <F7> :execute ":! cd " . t:MINGW_BUILD_DIR . " && mingw32-make run && pause" <cr>
    elseif filereadable("Makefile")
        nnoremap <silent> <F7> :make <cr>
    endif
endfunction

"
" MACRO: F7-F8: Per project run settings.
"
if has("gui_running")
  if has("gui_macvim")          " OSX
  elseif has("gui_win32")       " Windows
    autocmd BufNewFile,BufRead * call CheckTimBuild()
  endif
endif

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
" clang_complete: autocomplete settings
"
if has("win32")
    let g:clang_debug=1
    let g:clang_library_path = 'F:\Tools\LLVM\bin\libclang.dll'
endif
let g:clang_use_library=1                       " Use libclang to improve completion speed.
let g:clang_auto_select=1                       " Automatically select and insert the first match
let g:clang_complete_auto=1                     " Auto complete after '->', '.' and '::'.
let g:clang_snippets=1                          " Insert arguments.
let g:clang_conceal_snippets=1
let g:clang_close_preview=1                     " Close preview window after completion.
set completeopt=menu,menuone                    " Hide preview scratch window,
set pumheight=20                                " Limit popup window height.
" Autocomplete with Ctrl-Space.
inoremap <silent> <C-Space> <C-x><C-u>

"
" GVIM: Settings.
"
if has("gui_running")
  set directory=.,$TEMP                         " Windows GVIM bug fix
  set guicursor+=a:blinkon0                     " Disable cursor blinking
  set guioptions-=m                             " Disable menubar
  set guioptions-=T                             " Disable toolbar
  set guioptions-=L                             " Disable left scrollbar
  set guioptions-=l                             " Disable left scrollbar
  set guioptions-=R                             " Disable right scrollbar
  set guioptions-=r                             " Disable right scrollbar
  set guioptions-=b                             " Disable bottom scrollbar
  set guioptions-=h                             " Disable horizontal scrollbar
  set guioptions-=e                             " Disable GUI tab bars for :tabnew
  autocmd InsertEnter,InsertLeave * set cul!    " Highlight cursor after opening buffer.
  set autochdir
endif

"
" GVIM: Remember session.
"
set sessionoptions-=folds       " Do not store folds
set sessionoptions-=buffers     " Do not store closed buffers
set sessionoptions+=tabpages    " Required for Taboo remembering tab names
set sessionoptions+=globals     " Required for Taboo remembering tab names

"
" Match startify sessions with session plugin.
"
let g:startify_session_dir = "~\\vimfiles\\sessions"
let g:startify_list_order = ['sessions', 'files', 'dir', 'bookmarks', 'commands']
let g:startify_custom_header = [
            \ '                                 ________  __ __',
            \ '            __                  /\_____  \/\ \\ \',
            \ '    __  __ /\_\    ___ ___      \/___//''/''\ \ \\ \',
            \ '   /\ \/\ \\/\ \ /'' __` __`\        /'' /''  \ \ \\ \_',
            \ '   \ \ \_/ |\ \ \/\ \/\ \/\ \      /'' /''__  \ \__ ,__\',
            \ '    \ \___/  \ \_\ \_\ \_\ \_\    /\_/ /\_\  \/_/\_\_/',
            \ '     \/__/    \/_/\/_/\/_/\/_/    \//  \/_/     \/_/',
            \ ]

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

set secure
