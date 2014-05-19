REBOL[
	Title: "Serie - numerical series creation dialect"
	Author: "Boleslav Brezovsky"
	Email: rebolek@gmail.com
	Date: 6-1-2010
	Version: 0.0.4
	History: [
		19-5-2014 "Put on GitHub"
		4-1-2010 "ADDED support for words in dialect (right now not everywhere)"
		3-1-2010 "ADDED support for x: 5 serie [1 .. x] == [1 2 3 4 5]"
	]
	ToDo: {
		fix bug: serie [etc [1 7 12 16 .. 50]]
		(not a bug exactly, but missing pattern)
	}
	Examples: {See on web}
	Notes: "Inspired by SWYM - see: http://www.chalicegames.com/swym/SwymWebIntro.html"
]

etc: func [ "Create block from example values"
	[catch]
	example [block!] "Example values"
	condition [integer! block!] "Length of block or condition for block end (e.g.: (< 1000))"
	/local out diff val length tmp code
][
	if 3 > length? example [
		return make error! "Example block is too short"
		;throw make error! "Example block is too short"
	]
	length: 1000
	either integer? condition [
		length: condition
		condition: [(length? out) < length]
	][
		condition: head insert head condition 'val
	]
	out: make block! length
	val: example/1
	code: case [
		equal? example/4 example/3 + (example/3 - example/2) + ((example/3 - example/2) - (example/2 - example/1)) [
			tmp: example/2 - example/1
			[
				val: val + tmp
				tmp: tmp + (example/3 - example/2) - (example/2 - example/1)
			]
		]
		equal? example/4 example/3 + example/2 [
			[val: val + first back back tail out]
		]
		all [
			3 = length? 
			example equal? example/3 - example/2 diff: example/2 - example/1
		][
			[val: val + diff]
		]
		all [
			3 = length? example 
			equal? example/3 / example/2 diff: example/2 / example/1
		][
			[val: val * diff]
		]
	]
	either none? code [out: make error! "Unable to extrapolate sequence"][
		while condition [
			append out val
			do code
		]
	]
	out
]

serie: func [
	"Create block form example values"
	block [block!] "Example block" ;it's not 'example' - find better word
	/local out val start-val end-val tmp step from cond
][
	out: make block! 100
	parse block [
		some [
			(step: from: 1) ;repeat and cycle seem interchangable to me
		;	'repeat set value integer! set length integer! opt 'times (loop length [append out value])
			['repeat | 'cycle] set value [block! | integer!] opt 'length set length integer! (
				tmp: make block! length
				while [length > length? tmp][
					append tmp value
				]
				append out copy/part tmp length
			)
		|	'iterate set value block! some [
				[set length integer! opt 'times] 
			|	['from set from integer!]
			] (
				var: to word! first value
				tmp: make block! length
				use reduce [var] compose/deep [
					(to set-word! first value) (from)
					append tmp (var)
					while [length > length? tmp][
						append tmp (value)
					]
				]
				append out tmp
			)
		|	'etc (value: make block! 4)
			some [set tmp number! (append value tmp)]
			set cond word!
			set length [block! | integer!]
			(
				cond: switch cond [
					.. 		[quote <=]
					to 		[quote <]
					thru 	[quote <=]
				]
				if not find [x length] cond [length: reduce [cond length]]
				append out do reduce ['etc value length]
			)
		|	set start-val [word! | integer!] set cond [ '.. | 'to  | 'thru ] set end-val [word! | integer!] opt ['step set step integer!](
				if word? start-val [start-val: get start-val]
				if word? end-val [end-val: get end-val]
				end-val: switch cond [
					.. 		[end-val]
					to 		[end-val - 1]
					thru 	[end-val]
				]
				for i start-val end-val either start-val > end-val [negate step][step] [append out i]
			)
		|	set val integer! (append out val)
		]
	]
	out
]

