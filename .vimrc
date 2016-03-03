" basic  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set number
set title
set ambiwidth=double
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smartindent
set autoindent
set backspace=indent,eol,start
set noswapfile
set nobackup
set noundofile
set cursorline
set formatoptions-=ro
hi clear CursorLine
hi CursorLineNr term=bold cterm=NONE ctermfg=228 ctermbg=NONE

" command completion setting """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set wildmenu
set wildmode=longest:full,full

augroup vimrc
  autocmd! FileType java setlocal shiftwidth=4 tabstop=4 softtabstop=4
augroup END

" set encoding & filetype """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set encoding=utf-8
set fileencodings=utf-8,cp932,sjis,euc-jp,iso-2022-jp
set fileformat=unix
set fileformats=unix,dos,mac

" confirm fileformat to unix """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:set_fileformat()
  if &filetype != "dosbatch" && &fileformat != "unix" && input("setlocal fileformat=unix?[y/n]") == "y"
    try
      setlocal fileformat=unix
    catch
    endtry
  endif
endfunction
autocmd BufWritePre * :call <SID>set_fileformat()

" parenthese complete """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
inoremap { {}<Left>
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap ( ()<ESC>i
inoremap (<Enter> ()<Left><CR><ESC><S-o>

""" NeoBundle """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('vim_starting')
  set nocompatible
  set runtimepath+=~/.vim/bundle/neobundle.vim
endif

call neobundle#begin(expand('~/.vim/bundle'))
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'othree/javascript-libraries-syntax.vim'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'scrooloose/nerdtree'

call neobundle#end()

NeoBundleCheck

""" Eclim """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
filetype plugin indent on

augroup EclimAu
  autocmd!
  autocmd FileType java nnoremap <silent> <buffer> <leader>i :JavaImport<cr>
  autocmd FileType java nnoremap <silent> <buffer> <cr> :JavaSearchContext<cr>
  autocmd FileType java let g:EclimJavaSearchSingleResult = 'edit'
augroup END

set completeopt=longest,menuone
set completeopt-=preview
" Either get lost...
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1

if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.java =
    \ '\%(\h\w*\|)\)\.\w*'

""" neosnippet """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:neocomplete#enable_at_startup = 1

imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

augroup conceal_setting
  autocmd!
  autocmd Filetype json setl conceallevel=0
augroup END


""" javascript-libraries-syntax """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup JavaScript Syntax
  autocmd!
  autocmd BufReadPre *.js let b:javascript_lib_use_jquery = 0
  autocmd BufReadPre *.js let b:javascript_lib_use_angularjs = 1
augroup END                                                          

""" Color Scheme """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
set background=dark
if isdirectory(expand('~/.vim/bundle/vim-hybrid'))
  colorscheme hybrid
endif

""" auto make directory """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrc-auto-mkdir  " {{{
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  function! s:auto_mkdir(dir, force)  " {{{
    if !isdirectory(a:dir) && (a:force ||
    \    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction  " }}}
augroup END  " }}}

""" tab(tc, tx, tn, tp, tn(n=1,2,3,,,,)) """""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable(expand('~/.vimrc_tab'))
  source ~/.vimrc_tab
endif

""" key bind """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <C-U><C-B> :Unite buffer<CR>
noremap <C-N><C-T> :NERDTreeToggle<CR>

""" command """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! XmlFormat :%!xmllint --format -

""" ime controll """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set t_SI+=[<r
set t_EI+=[<s[<0t
set t_te+=[<0t[<s
set ttimeoutlen=100

""" paste setting """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup paste-setting
  autocmd!
  autocmd InsertLeave * set nopaste
augroup END
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

