REBOL[
	Title: "Filter - block filtering dialect"
	Author: "Boleslav Brezovsky"
	Email: rebolek@gmail.com
	Date: 6-1-2010
	Version: 0.0.4
	History: [
		19-5-2014 "Put on GitHub"
		4-1-2010 "ADDED support for words in dialect (right now not everywhere)"
		3-1-2010 "ADDED support for x: 5 serie [1 .. x] == [1 2 3 4 5]"
	]
	Examples: {
>> filter serie [iterate [x: x + 1] 10 ] [[x > 2] [x < 5]]
== [3 4]

>> filter etc [3 6 9] 100 [x > 250] 
== [252 255 258 261 264 267 270 273 276 279 282 285 288 291 294 297 300]

>> filter serie [1 .. 10] [[x > 5][zero? x // 2]] 
== [6 8 10]
	}
]

filter: func [
	"Filter block according to condition(s)"
	block [block!] "Block to filter"
	cond [number! block!] "Condition or block of conditions" ;condition must always return logic! - so anyone can use anything
	/with "Specify local word or words to be used" ;I think one is enough, but let's wait and see
		words [word! block!] "Word or block of words to be used as local"
	/local remove? conds
][
	if word? words [words: append copy [] words]
	conds: copy []
	if number? cond [cond: reduce ['= cond]]
	if not block? first cond [cond: append/only copy [] cond]
	append conds cond
	remove-each it block [
		remove?: false
		foreach cond conds [
			if not with [
				words: copy []
				forall cond [if not value? cond/1 [append words cond/1]]
				if not equal? 1 length? words [remove-each word words [all [value? word not none? get word ]]]
			]
			; if there's only one word in filter suppose it's local
			; otherwise filter words to find which is local
			if zero? length? words [print "ERROR: zero length" throw make error! "Cannot determine which word to use as local."]
			use words compose [
				(to set-word! first words) (it)
				remove?: remove? or not (cond)
			]
		]
		remove?
	]
	block
]

