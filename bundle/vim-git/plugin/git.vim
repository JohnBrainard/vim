function! GitStatus()
	call s:ShowInBuffer('Git Status', system('git status'))
endfunction

function! GitBlame()
	let [buf, line, col, off] = getpos('.')
	call s:ShowInBuffer('Git Blame', system('git blame '.expand('%')))
	call setpos('.', [0, line, 0, 0])
endfunction

function! GitBlameLines() range
	let cmdstr='git blame -L ' . a:firstline . ',' . a:lastline . ' ' . expand('%')
	call s:ShowInBuffer('Git Blame', system(l:cmdstr))
endfunction

function! GitDiff()
	let cmdstr='git diff '.expand('%')
	let content=system(cmdstr)
	let name=s:GetBufferTitle('Git Diff')

	call s:ShowInBuffer(name, content)
	setlocal filetype=diff
endfunction

function! GitFileHistory()
	let cmdstr='git log --pretty=format:"%h | %ad | %s%d [%an]" --graph --date=short ' . expand('%')
	let content = system(cmdstr)
	let name = s:GetBufferTitle('Git History')

	call s:ShowInBuffer(name, content)
	nmap <buffer> l :call GitShowCommitLog()<CR>
	nmap <buffer> <CR> :call GitShowCommitLog()<CR>
endfunction

function! GitGrepSelection()
	let text = s:VisualSelection()

	call GitGrep(text)
endfunction

function! GitGrep(text)
	let cmdstr='git grep --line-number '.a:text
	let content=system(cmdstr)
	let name=s:GetBufferTitle('Git Grep')

	call s:ShowInBuffer(name, content)
endfunction

function! GitShowCommitLog()
	let hash = expand("<cword>")
	let cmdstr='git show '.hash
	let content = system(cmdstr)
	let name = s:GetBufferTitle('Git Commit Log')

	call s:ShowInBuffer(name, content)
	setlocal filetype=diff
endfunction

function! s:GetBufferTitle(name)
	return a:name.':'.expand('%:t')
endfunction

function! s:ShowInBuffer(name, contents)
	enew
	setlocal buftype=nofile

	"Allow for quick/easy closing of buffer...
	map <buffer> q :bdelete<CR>

	let failed = append(0, split(a:contents, '\n'))
	call setpos('.', [0, 0, 0, 0])
endfunction

function! s:VisualSelection()
  try
    let a_save = @a
    normal! gv"ay
    return @a
  finally
    let @a = a_save
  endtry
endfunction

nnoremap <leader>gs :call GitStatus()<CR>
nnoremap <leader>gb :call GitBlame()<CR>
nnoremap <leader>gh :call GitFileHistory()<CR>
nnoremap <leader>gd :call GitDiff()<CR>

vnoremap <leader>gb :call GitBlameLines()<CR>
vnoremap <leader>gg :call GitGrepSelection()<CR>

command! GitBlame :call GitBlame()
command! GitDiff :call GitDiff()
command! GitFileHistory :call GitFileHistory()
command! GitStage :!git stage %
command! GitStatus :call GitStatus()
command! -nargs=? GitGrep :call GitGrep(<f-args>)

command! -range -nargs=* GitBlame <line1>,<line2> call GitBlameLines()
command! -range -nargs=* GitShowCommitLog <line1><line2> call GitShowCommitLog()

