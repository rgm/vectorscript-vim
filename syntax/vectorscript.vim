if exists ("b:current_syntax")
  finish
endif

syn keyword vsKeywords PROCEDURE FUNCTION BEGIN END
syn keyword vsKeywords CONST VAR STRUCTURE CASE FOR WHILE DO OF TYPE
syn keyword vsKeywords IF THEN ELSE
syn keyword vsType BOOLEAN STRING HANDLE REAL LONGINT POINT INTEGER
syn keyword vsBooleans TRUE FALSE
syn keyword vsCompilerDirective contained $INCLUDE $DEBUG

syn keyword vsBuiltinFunction Run PushAttrs TextJust vsoGetEventInfo LNewObj GetCustomObjectInfo HHeight SetTextWrap CreateText TextVerticalAlign HMoveBackward PopAttrs SetObjectVariableBoolean Rect SetTextWidth
syn match vsGlobal '\<g\w\+'
syn match vsConstant '\<k\w\+'
syn match vsParameter '\<p[A-Z_][A-Za-z_]\+'
syn region vsString start="'" end="'"
syn region vsComment start="{" end="}" contains=vsCompilerDirective

let b:current_syntax = "vectorscript"

hi def link vsKeywords Statement
hi def link vsType Type
hi def link vsBuiltinFunction Function
hi def link vsConstant Constant
hi def link vsBooleans Statement
"hi def link vsGlobal Identifier
hi def link vsParameter Constant
hi def link vsString String
hi def link vsComment Comment
hi def link vsCompilerDirective PreProc

