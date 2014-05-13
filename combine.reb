REBOL[
    Title: "Combine"
    Author: "Boleslav Březovský"
    Version: 0.0.3
    Date: 13-5-2014
]

combine: function [
    "Reduces and joins a block of values."
    block [block!] "Values to reduce and join"
    /only "Do not reduce"
    /with "Add delimiter between values"
        delimiter
] [
	block: either only [block] [reduce block]
    if empty? block [return block]
    trim block
    if with [
        last-val: last block
        block: map-each value block [join value delimiter]
        change back tail block last-val
    ]
    to string! block
]
