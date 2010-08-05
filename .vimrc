set nocp
set ai to shell=/bin/bash terse nowarn sm ruler redraw sw=4 ts=4
"set noremap
set hls
set bs=2
set bg=dark
set showmode
set incsearch
"set background=dark
syntax enable
"set ignorecase
set smartcase
set expandtab smarttab

" this conflicts with snipMate
"function! Mosh_Tab_Or_Complete()
"    if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
"        return "\<C-N>"
"    else
"        return "\<Tab>"
"endfunction
"
"inoremap <Tab> <C-R>=Mosh_Tab_Or_Complete()<CR>

" perl syntax check
nmap <C-c><C-c> :!perl -Wc %<CR>

" from http://github.com/adamhjk/adam-vim
" nicer status line
"set laststatus=2
"set statusline=
"set statusline+=%-3.3n\ " buffer number
"set statusline+=%f\ " filename
"set statusline+=%h%m%r%w " status flags
"set statusline+=\[%{strlen(&ft)?&ft:'none'}] " file type
"set statusline+=%= " right align remainder
"set statusline+=0x%-8B " character value
"set statusline+=%-14(%l,%c%V%) " line, character
"set statusline+=%<%P " file position

" http://stackoverflow.com/questions/54255/in-vim-is-there-a-way-to-delete-without-putting-text-in-the-register
" replaces whatever is visually highlighted with what's in the paste buffer
vmap r "_dP

" custom surroundings for confluence editing
" 'l' for literal
let g:surround_108 = "{{\r}}"
" 'n' for noformat
let g:surround_110 = "{noformat}\r{noformat}"

" use command-[jk$0^] to move thorough wrapped lines
" http://vimcasts.org/episodes/soft-wrapping-text/
" vmap for visual, nmap for normal mode
vmap <D-j> gj
vmap <D-k> gk
vmap <D-4> g$
vmap <D-6> g^
vmap <D-0> g^
nmap <D-j> gj
nmap <D-k> gk
nmap <D-4> g$
nmap <D-6> g^
nmap <D-0> g^

" always show 5 lines of context
set scrolloff=5

" the famous leader character
let mapleader = ','

set wildmenu

" scroll up and down the page a little faster
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" alias for quit all
map <leader>d :qa<CR>

" for editing files next to the open one
" http://vimcasts.org/episodes/the-edit-command/
noremap <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>
noremap <leader>es :sp <C-R>=expand("%:p:h") . "/" <CR>
noremap <leader>ev :vsp <C-R>=expand("%:p:h") . "/" <CR>
noremap <leader>et :tabe <C-R>=expand("%:p:h") . "/" <CR>

filetype on
filetype plugin on
filetype indent on

map <F2> :map<CR>
map <F5> :BufExplorer<CR>
map <F6> :NERDTreeToggle<CR>
map <F7> :call ToggleSyntax()<CR>
map <F8> :set paste!<CR>
map <F9> :call PerlTidy()<CR>
map <F10> :diffu<CR>
map <F11> :echo 'Current change: ' . changenr()<CR>
map <F12> :noh<CR>

" Testing aliases
map ,tv :!./Build test --verbose 1 --test-files %<CR>

" function to perl tidy
function PerlTidy()
    let ptline = line('.')
    if filereadable('/usr/bin/perltidy') || filereadable('/Users/nate/perl5/bin/perltidy')
        %! perltidy -pbp
    endif
    exe ptline
endfunction

function! ToggleSyntax()
   if exists("g:syntax_on")
      syntax off
   else
      syntax enable
   endif
endfunction

"let perl_fold = 1

runtime macros/matchit.vim

set foldmethod=marker
highlight Folded ctermbg=black ctermfg=blue

" printing options
set popt=paper:letter
set printdevice=dev_np24
function LineIt()
	exe ":s/^/".line(".")."/"
endfunction

au BufNewFile,BufRead *.rhtml set sw=2 ts=2 bs=2 et smarttab
au BufNewFile,BufRead *.rb set sw=2 ts=2 bs=2 et smarttab

" .t files are perl
au BufNewFile,BufRead *.t set filetype=perl

" tt and mt files are tt2html
au BufNewFile,BufRead *.tt set filetype=tt2html
au BufNewFile,BufRead *.mt set filetype=tt2html

map ,pt :call PerlTidy()<CR>
map ,cp :%w ! pbcopy<CR>

" older versions of this file contain helpers for HTML, JSP and Java

" originally (aka inspired by) http://www.slideshare.net/c9s/perlhacksonvim
fun! GetCursorModName()
  let cw=substitute( expand("<cWORD>"), '.\{-}\(\(\w\+\)\(::\w\+\)*\).*$', '\1', '')
  return cw
endfunction

fun! TranslateModName(n)
  return substitute( a:n, '::', '/', 'g') . '.pm'
endfunction

fun! GetPerlIncs()
  let out = system( "perl -e 'print join \"\\n\", @INC'" )
  let paths = split( out, "\n" )
  return paths
endfunction

fun! FindMod()
  let paths = GetPerlIncs()
  let fname = TranslateModName( GetCursorModName() )

  if filereadable('lib/' . fname)
    split 'lib/' . fname
    return
  endif

  for p in paths
    let fullpath = p . '/' . fname
    if filereadable(fullpath)
      exec 'split ' . fullpath
      return
    endif
  endfor
endfunction

nmap <Leader>fm :call FindMod()<cr>

" fuzzy finder textmate
noremap <leader>ff :FuzzyFinderTextMate<CR>
noremap <leader>fr :FuzzyFinderMruFile<CR>