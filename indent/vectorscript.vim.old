" Vim indent file
" Language:     Vectorscript
" Maintainer:   Ryan McCuaig <ryan@ryanmccuaig.net>
" Created:      2012 Apr 30
" Last Change:  2012 Apr 30

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetVectorscriptIndent(v:lnum)

if exists("*GetVectorscriptIndent")
  finish
endif

function! s:GetPrevNonCommentLineNum( line_num )

  Skip lines starting with a comment
  let SKIP_LINES = '^\s*\(\((\*\)\|\(\*\  \)\|\(\*)\)\|{\|}\)'

  let nline = a:line_num
  while nline > 0
    let nline = prevnonblank(nline-1)
    if getline(nline) !~? SKIP_LINES
      break
    endif
  endwhile

  return nline
endfunction

function! GetVectorscriptIndent( line_num )
  " Line 0 always at 0
  if a:line_num == 0
    return 0
  endif

  let this_codeline     = getline( a:line_num )
  let prev_codeline_num = s:GetPrevNonCommentLineNum( a:line_num )
  let prev_codeline     = getline( prev_codeline_num )

  if this_codeline =~ '^\s*\<\(PROCEDURE\|FUNCTION\|END\)\>'
    return 0
  endif

  let indnt = indent( prev_codeline_num )

  if prev_codeline =~ '^\s*\<\(PROCEDURE\|FUNCTION\|END\)\>'
    let indnt = indnt + &shiftwidth
  endif

  return indnt

endfunction
