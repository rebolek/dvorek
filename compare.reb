REBOL[
	Title: "Compare - block comparison dialect"
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
a: [1 2 3 4 5 6 7 8 9]
b: [2 4 6]
c: [10 20 30]
d: [5 10 15]

>> compare a d [some b > one d] 
== true

>> compare a b [some a = some b]
== true

>> compare a c [every a < every c]
== true

>> compare a c [no a > every c]
== true

>> compare a d [one a = one d]
== true
	}
]

compare: func [
	"Compare two blocks with simple dialect"
	block1 "First block"
	block2 "Second block"
	rules [block!] "Compare rules"
	/local 
		keyword1 keyword2 comparator
		result inner outer kill-inner kill-outer
][
	if not parse rules [
		set keyword1 word!
		set var1 word!
		set comparator word!
		set keyword2 word!
		set var2 word!
		(
			block1: get :block1
			block2: get :block2
			outer:
			kill-outer: false
			forall block1 [
				inner:
				kill-inner: false
				forall block2 [
					result: do reduce [block1/1 comparator block2/1]
					switch/default keyword2 [
						no [either result [inner: false break][inner: true]]
						one [if result [if kill-inner [inner: false break] inner: kill-inner: true]]
						some [if result [inner: true break]]
						every [either result [inner: true][inner: false break]]
					][return make error! "Unknown second keyword!"]
				]
				switch/default keyword1 [
					no [if inner [outer: false break]]
					one [if inner [if kill-outer [outer: false break] outer: kill-outer: true]]
					some [if inner [outer: true break]]
					every [either inner [outer: true][outer: false break]]
				][return make error! "Unknown first keyword!"]
			]
		)		
	][return make error! "Invalid rules"]
	outer
]

sort-by: func [
	"Apply something as sorting method"
	block [block!] "Block to sort"
	'method  "Method to use"
	/local fn
][
	method: append copy [] method
	fn: func [a b] compose [(to paren! append copy method 'a) <  (to paren! append copy method 'b)]
	sort/compare block :fn
]

;>> sort-by ["noha" "au" "slovo" "prso" "kladivo"] length?
;== ["au" "noha" "prso" "slovo" "kladivo"]
