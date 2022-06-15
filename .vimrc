noremap <silent> <leader>om :call OpenMarkdownPreview()<cr>
autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')

cnoreabbrev crs CocRestart
cnoreabbrev <expr> asdf getcmdtype() == ":" && getcmdline() == 'asdf' ? ':w <BAR> :CocRestart' : 'asdf'


set noeol

let g:coc_node_path = '/opt/homebrew/bin/node'

function! OpenMarkdownPreview() abort
if exists('s:markdown_job_id') && s:markdown_job_id > 0
  call jobstop(s:markdown_job_id)
  unlet s:markdown_job_id
endif
let available_port = system(
  \ "lsof -s tcp:listen -i :40500-40800 | awk -F ' *|:' '{ print $10 }' | sort -n | tail -n1"
  \ ) + 1
if available_port == 1 | let available_port = 40500 | endif
let s:markdown_job_id = jobstart('grip ' . shellescape(expand('%:p')) . ' :' . available_port)
if s:markdown_job_id <= 0 | return | endif
call system('open http://localhost:' . available_port)
endfunction

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction



" Simple re-format for minified Javascript
command! UnMinify call UnMinify()
function! UnMinify()
    %s/{\ze[^\r\n]/{\r/g
    %s/){/) {/g
    %s/};\?\ze[^\r\n]/\0\r/g
    %s/;\ze[^\r\n]/;\r/g
    %s/[^\s]\zs[=&|]\+\ze[^\s]/ \0 /g
    normal ggVG=
endfunction
set list lcs=tab:\|\
set number
let &t_ut=''
set clipboard=unnamed
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
"Mode Settings
"
let &t_SI.="\e[4 q" "SI = INSERT mode
let &t_SR.="\e[6 q" "SR = REPLACE mode
let &t_EI.="\e[3 q" "EI = NORMAL mode (ELSE)
"
""Cursor settings:

"  1 -> blinking block
"  "  2 -> solid block 
"  "  3 -> blinking underscore
"  "  4 -> solid underscore
"  "  5 -> blinking vertical bar
"  "  6 -> solid vertical bar




set nocompatible           " Vim defaults rather than vi ones. Keep at top.
filetype plugin indent on  " Enable filetype-specific settings.
syntax on                  " Enable syntax highlighting.
set backspace=2            " Make the backspace behave as most applications.
set autoindent             " Use current indent for new lines.
set display=lastline       " Show as much of the line as will fit.
set wildmenu               " Better tab completion in the commandline.
set wildmode=list:longest  " List all matches and complete to the longest match.
set showcmd                " Show (partial) command in bottom-right.
set expandtab              " Use spaces instead of tabs for indentation.
set smarttab               " Backspace removes 'shiftwidth' worth of spaces.
set laststatus=2           " Always show the statusline.
set ruler                  " Show the ruler in the statusline.
set incsearch              " Jump to search match while typing.
set ignorecase             " Searching with / is case-insensitive.
set smartcase              " Disable 'ignorecase' if the term contains upper-case.
set nrformats-=octal       " Remove octal support from 'nrformats'.
set tabstop=2              " Size of a Tab character.
set shiftwidth=2           " Use same value as 'tabstop'.
set softtabstop=-1         " Use same value as 'shiftwidth'.

" Persist undo history between Vim sessions.
if has('persistent_undo')
	set undodir=$HOME/.vim/tmp/undo
	if !isdirectory(&undodir) | call mkdir(&undodir, 'p', 0700) | endif
endif

set path+=**

function! StatusLine()
    return '%#Crystalline# %f%h%w%m%r %#CrystallineFill#'
        \ . '%=%#Crystalline# %{&ft}[%{&fenc!=#""?&fenc:&enc}][%{&ff}] %l/%L %c%V %P '
endfunction
set statusline=%!StatusLine()
let g:crystalline_theme = 'jellybeans'
set laststatus=2
function! TabLine()
  return crystalline#bufferline(0, 0, 1)
endfunction
" let g:crystalline_tabline_fn = 'TabLine'
" set showtabline=2
" let g:crystalline_enable_sep = 1

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')


" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-master branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Unmanaged plugin (manually installed and updated)
Plug '~/my-prototype-plugin'
Plug 'rbong/vim-crystalline'
Plug 'prabirshrestha/vim-lsp'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'arzg/vim-colors-xcode'
Plug 'tpope/vim-eunuch'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ahmadie/workspace.vim'
Plug 'tomlion/vim-solidity'
if !has('nvim')
    Plug 'roxma/vim-hug-neovim-rpc'
endif

" Initialize plugin system
call plug#end()
au User lsp_setup call lsp#register_server({                                    
     \ 'name': 'php-language-server',                                            
     \ 'cmd': {server_info->['php', expand('~/.vim/plugged/php-language-server/bin/php-language-server.php')]},
     \ 'whitelist': ['php'],                                                     
     \ })
colorscheme cyberpunk-neon
colorscheme xcodewwdc
set termguicolors

" let g:workspace#vim#airline#enable = 1
let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#show_tabs = 0
" let g:airline#extensions#tabline#show_tab_count = 0
