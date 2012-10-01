set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set hlsearch
set number
set ruler
set nowrap
set smarttab
set showcmd

runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

" Not sure I want to default to a given directory now...
" lcd ~/Code

" Display a status line for [0-n] windows.
set laststatus=2

" Ignore certain types of files...
set wildignore=*.o,*.obj,*.git,*.class

" Hide the buffers instead of deleting.... Allows multiple unsaved
" buffers to be opened.
set hidden

set ofu=syntaxcomplete#Complete

syntax enable
set background=dark

let g:solarized_termcolors=256
let g:solarized_termtrans=1

colorscheme solarized

let mapleader = "-"
let maplocalleader = "\\"

nnoremap <leader>f :Find<space>

" Clipboard shortcuts
nnoremap <leader>y "+yy
vnoremap <leader>c "+y

" Insert clipboard contents
nnoremap <leader>iP "+P
nnoremap <leader>ip "+p

"Copy contents of entire buffer to clipboard.
nnoremap <leader>A ggVG"+y
nnoremap <leader>a ggVG

" BufExplorer Plugin Settings
" ===========================
" Requires BufExplorer plugin to be installed.
" http://www.vim.org/scripts/script.php?script_id=42
nnoremap <leader>B :BufExplorer<return>

let g:bufExplorerShowDirectories=0   " Don't show directories.
let g:bufExplorerSortBy='name'       " Sort by the buffer's name.

" Find file in current directory and edit it.
function! Find(name)
	let l:list=system("find . -name '".a:name."' | perl -ne 'print \"$.\\t$_\"'")
	let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))
	if l:num < 1
		echo "'".a:name."' not found"
		return
	endif
	if l:num != 1
		echo l:list
		let l:input=input("Which ? (CR=nothing)\n")
		if strlen(l:input)==0
			return
		endif
		if strlen(substitute(l:input, "[0-9]", "", "g"))>0
			echo "Not a number"
			return
		endif
		if l:input<1 || l:input>l:num
			echo "Out of range"
			return
		endif
		let l:line=matchstr("\n".l:list, "\n".l:input."\t[^\n]*")
	else
		let l:line=l:list
	endif

	let l:line=substitute(l:line, "^[^\t]*\t./", "", "")
	execute ":e ".l:line
endfunction
command! -nargs=1 Find :call Find("<args>")

