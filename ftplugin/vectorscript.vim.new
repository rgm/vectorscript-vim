" Vim filetype plugin file
" Language:	Pascal
" Maintainer:	Zhou Yi Chao <broken.zhou@gmail.com>
" Last Changed: 2011 March 27
" URL:	        http://code.google.com/p/new-vim-pascal-indent-file/

if exists("b:did_ftplugin") 
    finish 
endif
let b:did_ftplugin = 1

let b:match_ignorecase = 1

if exists("loaded_matchit")
    let b:match_words = '\<\%(begin\|case\|record\|class\|object\|try\|asm\)\>'
    let b:match_words .= ':\<\%(except\|finally\)\>:\<end\>'
    let b:match_words .= ',\<repeat\>:\<until\>'
    let b:match_words .= ',\<if\>:\<else\>'
endif

" Undo the stuff we changed.
let b:undo_ftplugin = "unlet! b:match_words"
