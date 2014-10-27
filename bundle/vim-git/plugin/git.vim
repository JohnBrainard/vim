function! GitStatus()
	call s:ShowInBuffer('Git Status', system('git status -s'))
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

function! ShowGitHistory(cmd)
	let name = s:GetBufferTitle('Git History')
	let content = system(a:cmd)

	call s:ShowInBuffer(name, content)
	nmap <buffer> l :call GitShowCommitLog()<CR>
	nmap <buffer> <CR> :call GitShowCommitLog()<CR>
endfunction

function! GitHistory()
	let cmdstr='git log --pretty=format:"%h | %ad | %s%d [%an]" --graph --date=short '
	call ShowGitHistory(cmdstr)
endfunction

function! GitFileHistory()
	let cmdstr='git log --pretty=format:"%h | %ad | %s%d [%an]" --graph --date=short ' . expand('%')
	call ShowGitHistory(cmdstr)
	"let content = system(cmdstr)
	"let name = s:GetBufferTitle('Git History')

	"call s:ShowInBuffer(name, content)
	"nmap <buffer> l :call GitShowCommitLog()<CR>
	"nmap <buffer> <CR> :call GitShowCommitLog()<CR>
endfunction

function! GitAuthorHistory(author)
	let cmdstr='git log --pretty=format:"%h | %ad | %s%d [%an]" --graph --date=short --author=' . a:author . ' ' . expand('%')
	call ShowGitHistory(cmdstr)
	"let content = system(cmdstr)
	"let title = 'Git History: ' . a:author
	"let name = s:GetBufferTitle(title)

	"call s:ShowInBuffer(name, content)
	"nmap <buffer> l :call GitShowCommitLog()<CR>
endfunction

function! GitGrepSelection()
	let text = s:VisualSelection()

	call GitGrep(text)
endfunction

function! GitGrep(text)
	let cmdstr='git grep --line-number -i '.a:text
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

"TODO:Load git configuration and parse 'remote.origin.url' value for repository path...
function! GitShowCommitLogBrowser()
	let hash = expand("<cword>")
	let cmdstr = '!open "http://git/Logos/DigitalLibrary/commit/"' . hash
	silent exec cmdstr
endfunction

function! GitSearchCommitLog(query)
	let cmdstr='git log --pretty=format:"%h | %ad | %s%d [%an]" --graph --date=short --grep="' . a:query . '"'
	let content = system(cmdstr)
	let name = s:GetBufferTitle('Git Log Search')

	call s:ShowInBuffer(name, content)
	nmap <buffer> l :call GitShowCommitLog()<CR>
	nmap <buffer> <CR> :call GitShowCommitLog()<CR>
	nmap <buffer> o :call GitShowCommitLogBrowser()<CR>
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

nnoremap <leader>gS :GitLogSearch<space>"
nnoremap <leader>gs :call GitStatus()<CR>
nnoremap <leader>gb :call GitBlame()<CR>
nnoremap <leader>gh :call GitFileHistory()<CR>
nnoremap <leader>gd :call GitDiff()<CR>
vnoremap <leader>gl :call GitShowCommitLog()<CR>

vnoremap <leader>gb :call GitBlameLines()<CR>
vnoremap <leader>gg :call GitGrepSelection()<CR>

command! GitBlame :call GitBlame()
command! GitDiff :call GitDiff()
command! GitHistory :call GitHistory()
command! GitFileHistory :call GitFileHistory()
command! GitFileAuthorHistory :call GitFileAuthorHistory(<f-args>)
command! GitStage :!git stage %
command! GitStatus :call GitStatus()
command! GitLogSearch :call GitSearchCommitLog(<f-args>)
command! -nargs=? GitGrep :call GitGrep(<f-args>)

command! -range -nargs=* GitBlame <line1>,<line2> call GitBlameLines()
command! -range -nargs=* GitShowCommitLog <line1><line2> call GitShowCommitLog()

