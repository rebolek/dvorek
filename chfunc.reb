REBOL[]

chfunc: func [
	"Make function with more checks"
	spec [block!]
	body [block!]
	/local word type val vals
] [
	local: make block! length? spec
	parse spec [
		some [
			set word [word! | 'lit-word! | 'get-word!]
			(type: none)
			opt into [
				set type word! ; it's not reduced, so it's word! and not datatype!
				opt into [
					(vals: make block! 10)
					some [
						'< set val number! (insert body compose/deep [assert [(word) > (val)]])
					|	'| set val number! (insert body compose/deep [assert [(word) >= (val)]])
					|	set val number! '> (insert body compose/deep [assert [(word) < (val)]])
					|	set val number! '| (insert body compose/deep [assert [(word) <= (val)]])
					|	'= some [set val number! (append vals val)] (insert body compose/deep [assert [ find [(vals)] (word)]])
					]
				]
			]
			(repend local [word either type [reduce [type]][]])
		]
	]
	make function! copy/deep reduce [local body]
]
