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
set scrolloff=15
set cursorline
set cursorcolumn
set noswapfile

set nobomb "Disable writing the byte order mark at the beginning of files...

" Pathogen Initialization....
" ===========================
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

colorscheme koehler

let mapleader = "-"
let maplocalleader = "\\"

nnoremap <leader>f :Find<space>
nnoremap <leader>n :NewScratchBuffer<CR>

vnoremap <leader>f gvy :Find<space><ctrl-r>"

" NERDTree....
nnoremap <leader>E :NERDTreeToggle<CR>

" Clipboard shortcuts
nnoremap <leader>y "+yy
vnoremap <leader>c "+y

" Insert clipboard contents
nnoremap <leader>iP "+P
nnoremap <leader>ip "+p

"Copy contents of entire buffer to clipboard.
nnoremap <leader>A ggVG"+y
nnoremap <leader>a ggVG

" GitGrep....
nnoremap <leader>G :GitGrep<space>

" Remap 'Search' key to mark all instances only. Use n and N to navigate to results.
nnoremap * :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>


"CoffeScript plugin...
au BufRead *.coffee compiler coffee
" au BufWritePost *.coffee silent CoffeeMakee!

" EasyGrep Settings..........
" ===========================
let g:EasyGrepMode=2
let g:EasyGrepCommand=0
let g:EasyGrepRecursive=1
let g:EasyGrepIgnoreCase=1

" TagList Settings...........
" ===========================
let tlist_objc_settings = 'objc;i:interface;c:class;m:method;p:property'

" BufExplorer Plugin Settings
" ===========================
" Requires BufExplorer plugin to be installed.
" http://www.vim.org/scripts/script.php?script_id=42
nnoremap <leader>B :BufExplorer<return>

let g:bufExplorerShowDirectories=0   " Don't show directories.
let g:bufExplorerSortBy='name'       " Sort by the buffer's name.

"Open file under cursor
map <C-i> :call OpenVariableUnderCursor(expand("<cword>"))<CR>
map <Leader>h :call FindSubClasses(expand("<cword>"))<CR>

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

function! SendToCommand(UserCommand) range
    " Get a list of lines containing the selected range
    let SelectedLines = getline(a:firstline,a:lastline)
    " Convert to a single string suitable for passing to the command
    let ScriptInput = join(SelectedLines, "\n") . "\n"
    " Run the command
    let result = system(a:UserCommand, ScriptInput)
    " Echo the result (could just do "echo system(....)")
    echo result
endfunction
command! -range -nargs=1 SendToCommand <line1>,<line2>call SendToCommand(<q-args>) 

function! OpenVariableUnderCursor(varName)
    let filename = substitute(a:varName,'\(\<\w\+\>\)', '\u\1', 'g')
    :call OpenFileUnderCursor(filename)
endfunction

function! OpenFileUnderCursor(filename)
   let ext = fnamemodify(expand("%:p"), ":t:e")
   execute ":find " . a:filename . "." . ext
endfunction

function! FindSubClasses(filename)
    execute ":Grep \\(implements\\|extends\\) " . a:filename
endfunction

function! NewScratchBuffer(title)
	enew
	setlocal buftype=nofile

	"Allow for quick/easy closing of buffer...
	map <buffer> q :bdelete<CR>
endfunction
command! NewScratchBuffer :call NewScratchBuffer("<args>")
