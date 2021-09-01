# Intro

This is a kdb/q binding for POSIX.2 regular expressions including extended REs and obsolate (legacy) REs. Please refer to [regex(7)](https://man7.org/linux/man-pages/man7/regex.7.html) and [regex(3)](https://man7.org/linux/man-pages/man3/regex.3.html).

The q api is similar to [like](https://code.kx.com/q/ref/like/) and it works with enums and mapped types as well.

## Examples
```
q)\l regex.q
q)s where (s:200?`3) rmatch "[a-d][e-h][i-l]|[i-k][e-h][a-d]"
`cfl`iec`kfd`bfk`cfi`cek`cei`kgd`jec
q)n:"(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])"
q)ip:re"^",n,"\\.",n,"\\.",n,"\\.",n,"$"
q)ip
foreign
q)"192.168.1.999" rmatch ip
0b
q)"192.168.1.100" rmatch ip
1b
q)"192.168.1.100" rmatches ip
"192.168.1.100"
"192"
"168"
,"1"
"100"
q)"192.168.1.100" irmatches ip
0  13
0  3
4  7
8  9
10 13
```

# Build & Install

This repo contains **regex.so** for Linux but you can also build it with make/gcc.
```
$ make
```
Then you can copy **regex.so** into **$QHOME/l64/** or you can copy it into the folder of your q application.

# Import

You can load *regex.q*, that will add the c functons to the .q namespace. If you don't like that, you can add them to the namespace of your liking, eg. to add them to .regex, you can
```
q)`.regex upsert (`:regex 2:`api,1)[];
```
The rest of this document assumes the .q namespace.

# The API

## re

Compile a regular expression with
```
re eregex
re (regex;flags)
```
where
 * eregex is Posix.2 extended RE string
 * regex is Posix.2 extended RE or obsolate (legacy) RE string
 * flags is a symbol or simbol vector of
   * *`ext* : if regex is in extended RE format (see [REG_EXTENDED](https://man7.org/linux/man-pages/man3/regex.3.html#DESCRIPTION))
   * *`icase*: to ignore case (see [REG_ICASE](https://man7.org/linux/man-pages/man3/regex.3.html#DESCRIPTION))
   * *`nl*: to match (^) and ($) after/before new line (see [REG_NEWLINE](https://man7.org/linux/man-pages/man3/regex.3.html#DESCRIPTION))

The result of the compilation is a 112h type foreign object.
## rmatch

Whether text matches a pattern, similar to like
```
x rmatch y
```
where
 * x is a symbol (-11h) or string (10h), symbol vector (11h) or list of strings or a dictionary with them as values
 * y is a compiled regex or the argment to function *re*

## rmatches

Subexpression matches
```
x rmatches y
```
where
 * x is a symbol (-11h) or string (10h)
 * y is a compiled regex or the argment to function *re*
 
Returns at most 256 substrings of x starting with the matching substring and followed by up to 255 subexpression matches.

## irmatches

Same as rmatches except it returns a list of (start;end+1) positions of the matching substring and subexpression matches.