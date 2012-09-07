" Pascal indent file
" Language:     Pascal
" Maintainer:   Zhou Yi Chao <broken.zhou@gmail.com>
" Last Change:  2011 Mar 09
" URL:          http://code.google.com/p/new-vim-pascal-indent-file/

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

" Some of the indentexpr might be useless. I'm just too tired. Adding them
" won't be wrong.
setlocal indentexpr=GetPascalIndent(v:lnum)
setlocal indentkeys+==~program,=~uses,=~const,=~type,=~var
setlocal indentkeys+==~function,=~procedure,=~operator
setlocal indentkeys+==~object,=~private,=~record
setlocal indentkeys+==~if,=~else,=~for,=~while,=~repeat,=~case
setlocal indentkeys+==~end,=~do,=~begin,=~until

" Check if syntax is available. So we can use synID to check the syntax.
let s:indent_use_syntax = has("syntax")

" Check if line lnum is completely a comment line.
function! CheckPascalComment(lnum)
    if s:indent_use_syntax
        let syn = synIDattr(synID(a:lnum,1+indent(a:lnum),1),'name')
        if syn == 'pascalComment'
            return 1
        else
            return 0
        endif
    else
        return getline(a:lnum) =~? '^\s*\({\|\*\|(\*\|\/\/\)'
    endif
endfunction

" Get the previous line which isn't a comment.
function! GetPrevNonCommentLineNum(lnum)
    let lnum = a:lnum
    while lnum > 0
        let lnum = prevnonblank(lnum-1)
        if !CheckPascalComment(lnum)
            return lnum
        endif
    endwhile
    return 0
endfunction

" main procedure.
function! GetPascalIndent(lnum)
    let clnum = a:lnum
    let lnum = GetPrevNonCommentLineNum(clnum)
    " well first line, indent = 0
    if lnum == 0 || clnum == 0
        return 0
    endif

    " get line and indent
    let ind = indent(lnum)
    let line = getline(lnum)
    let cline = getline(clnum)

    " Comment? Just believe the user.
    if CheckPascalComment(clnum)
        return indent(clnum)
    endif

    " Well, you should unindent while current line is end or until.
    " Of course there may be some special situation, we will deal with them
    " later.
    let det = 0
    if cline =~? '^\s*\<\(end\|until\)\>'
        let det = -&sw
    endif

    " indent of these keywords if zero
    if cline =~? '^\s*\<\(unit\|program\|uses\|const\|type\|var\)\>'
        return 0
    endif

    " If the previous line is start with func/proc don't indent.  Otherwise if
    " last line end with ";", we think this is the main procedure, unindent
    " it.  Otherwise the begin must is a part of if/while etc., retain the
    " indent.
    if cline =~? '^\s*\<begin\>'
        if line =~? '^\s*\<\(function\|procedure\|operator\)\>'
            return ind
        elseif line =~? ';$'
            return ind - &sw
        endif
        return ind
    endif

    " Guess what it is. If it is a definition (first case) return 0
    " Otherwise retain the indent.
    if cline =~? '^\s*\<\(function\|procedure\|operator\)\>'
        if ind <= &sw && line !~? '\<\(object\|record\)\>$'
            return 0
        endif
        if line =~? ';$'
            return ind
        endif
        return ind + &sw
    endif

    " Something you should add a shiftwidth
    if line =~? '^\s*\<\(unit\|uses\|const\|type\|var\|case\)\>'
        return ind + det + &sw
    endif
    if line =~? '\<\(begin\|record\|object\|do\|repeat\|then\)\>$'
        return ind + det + &sw
    endif
    if line =~? '\<else\>$' && cline !~? '^\s*\<\(else\|end\)\>'
        return ind + det + &sw
    endif
    if line =~? '\:$'
        return ind + det + &sw
    endif

    " handle if/while without begin correctly
    let nest = 0
    if line =~? '^\s*\<end\>' || line =~? '^\s*\<until\>'
        let nest += 1
    endif

    " match if & else
    if cline =~? '^\s*\<else\>'
        let nif = 1
        if line =~? '^\s*\(\<else\>\)\?\s*if'
            let nif -= 1
        endif
        if line =~? '^\s*\<else\>'
            let nif += 1
        endif
    endif

    " Try to find the indent. Find the last line which ends in ";" then use
    " the minIndent as result. Of course there are many special cases. They
    " are hard to explain. Just read the code.
    let minIndent = ind
    while lnum > 0
        let lnum = GetPrevNonCommentLineNum(lnum)
        if lnum = 0
            return ind + det
        endif
        let ind = indent(lnum)
        let line = getline(lnum)
        let minIndent = min([minIndent, ind])

        if line =~? '^\s*\<\(until\|end\)\>'
            let nest += 1
        endif

        if nest == 0 && line =~? '^\s*\(\<else\>\)\?\s*if'
            let nif -= 1
        endif

        if nest == 0
            if cline =~? '^\s*\<else\>'
                if line =~? '^\s*\<case\>'
                    return ind + &sw
                endif
                if nif == 0
                    return ind
                endif
            else
                if line =~? '^\s*\<\(unit\|program\|uses\|const\|type\|var\)\>'
                    return ind + det + &sw
                endif
                if line =~? '\<\(begin\|record\|object\|repeat\)\>$'
                    return ind + det + &sw
                endif
                if line =~? '^\s*\<case\>'
                    return ind + det + &sw
                endif
                if line =~? ';$'
                    return minIndent + det
                endif
            endif
        endif

        if line =~? '\<\(begin\|record\|object\|repeat\)\>$'
                    \ || line =~? '^\s*\<case\>'
            let nest -= 1
        endif
        if nest == 0 && line =~? '^\s*\<else\>'
            let nif += 1
        endif
    endwhile
    " Just in case
    return ind + det

endfunction
