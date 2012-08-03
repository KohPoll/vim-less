" Vim syntax fle
" Language: Less
" Author: Kohpoll (http://www.cnblogs.com/kohpoll/)
" Inspired by the syntax files of scss and css.
" Licensed under MIT.
" Last Modified: 2012-08-03

if exists("b:current_syntax") && b:current_syntax == "less"
  finish
endif

" use the css syntax and then enhance it.>.<
runtime! syntax/css.vim

syn case ignore

" css props and attrs
syn cluster lessCssProperties contains=css.*Prop
syn cluster lessCssAttributes contains=css.*Attr,cssValue.*,cssColor,cssURL,cssImportant,cssErr,cssStringQ,cssStringQQ,lessComment

syn region lessDefinition matchgroup=cssBraces start='{' end='}' contains=TOP

" less props (contain in less definition)
" (?<=[{};]\s*|^\s*)([\w-])+\s*:
syn match lessProperty "\%([{};]\s*\|^\s*\)\@<=\%([[:alnum:]-]\)\+\s*:" contains=@lessCssProperties skipwhite nextgroup=lessAttribute contained containedin=lessDefinition

" less attrs (contains all the css attr, less variable, less functinos, less string interpolation)
" ([^{};])* 
syn match lessAttribute "\%([^{};]\)*" contained contains=@lessCssAttributes,lessVariable,lessFunction,lessInterpolation

" variable:    @variable-name: variable-value
syn match lessVariable "@\{1,2}[[:alnum:]_-]\+"
" (?<=@{1,2}[\w_-]+\s*):
syn match lessVariableAssignment "\%(@\{1,2}[[:alnum:]_-]\+\s*\)\@<=:" nextgroup=lessAttribute skipwhite
hi def link lessVariable Identifier

" mixin:    .mixin (arguments) when (condition)
syn match lessMixin "\.[[:alnum:]_-]\+" skipwhite nextgroup=lessMixinArguments 
syn match lessMixinArguments "([^)]*)" contained contains=lessAttribute skipwhite nextgroup=lessMixinWhen
syn match lessMixinWhen "when" contained nextgroup=lessMixinGuard skipwhite
syn match lessMixinGuard "([^)]*)" contained contains=lessAttribute skipwhite nextgroup=lessDefinition 
hi def link lessMixin Statement
" FIXME: can not highlight `when`... why? = =
hi def link lessMixinWhen Identifier

" & syntax
syn match lessAmpersand "&"
hi def link lessAmpersand Character

" include
" me=e-1 means the last char of the match does not highlighted.(i.e the ';')
" me: match end
syn region lessInclude start="@import" end=";\|$"me=e-1 contains=lessComment,cssStringQ,cssStringQQ,cssURL,cssUnicodeEscape,cssMediaType
hi def link lessInclude Include

" string interpolation
" @{variable-name}
syn region lessInterpolation matchgroup=lessInterpolationDelimiter start="@{" end="}" contains=@lessCssAttributes containedin=cssStringQ,cssStringQQ
" %("xxxxx", varialble-a, variable-b)
syn region lessInterpolation matchgroup=lessInterpolationDelimiter start="%(" end=")" contains=@lessCssAttributes,lessVariable,cssStringQ,cssStringQQ
hi def link lessInterpolationDelimiter Constant

" functions
syn keyword lessFunction lighten darken saturate desaturate fadein fadeout fade mix spin hsl hue saturation lightness contained 
syn keyword lessFunction round ceil floor percentage contained
syn keyword lessFunction iscolor isnumber isstring iskeyword isurl ispixel ispercentage isem contained
hi def link lessFunction Function

" comments 
" TODO: well~ taken from sass syntax file, I can not understand it now. >.<
" pattern\@! => (?!pattern), \%(pattern\) => (?:pattern)
syn keyword lessTodo        FIXME NOTE TODO OPTIMIZE XXX contained
syn region  lessComment     start="^\z(\s*\)//"  end="^\%(\z1 \)\@!" contains=lessTodo,@Spell
syn region  lessCssComment  start="^\z(\s*\)/\*" end="^\%(\z1 \)\@!" contains=lessTodo,@Spell
hi def link lessCssComment lessComment
hi def link lessComment Comment
hi def link lessTodo Todo


if !exists("b:current_syntax")
  let b:current_syntax = "less"
endif
