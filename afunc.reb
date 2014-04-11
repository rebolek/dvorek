REBOL[]

chfunc: func [
	"Make function with more checks"
	spec [block!]
	body [block!]
	/local word desc type symbol val
] [
	local: make block! length? spec
	parse spec [
		some [
			set word [word! | 'lit-word! | 'get-word!]
			(type: desc: none)
			any [
				set desc string!
			|	opt into [
					set type word! ; it's not reduced, so it's word! and not datatype!
					any [	
						set symbol ['< | '> | '<= | '>=] set val number!
						(insert body compose/deep [assert [(word) (symbol) (val)]]) 
					]
				]
			]
			(repend local [word reduce [type] desc])
		]
	]
	remove-each word local [none? word]
	make function! copy/deep reduce [local body]
]
