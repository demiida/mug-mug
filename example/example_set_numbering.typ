#import "../src/template.typ": *
#show: template.with(first-line-indent: false)
#set page(columns: 2)

#let example = {
  math.equation($e^(j theta) = cos theta + j sin theta$, block: true)
  math.equation($e^(j 2 pi) = 1$, block: true)
  figure(caption: [caption], rect(inset: 2pt, outset: 0pt)[body])
}

#let reset-counter = {
  counter(heading).update(0)
  counter(math.equation).update(0)
  counter(figure.where(kind: image)).update(0)
  let description = [reset counter]
  let horizontal-line = line(length: 100%)
  pad(y: 1em, horizontal-line + align(center, description) + horizontal-line)
}

#[
  #reset-counter
  #set heading(numbering: "1.")
  #show: set-numbering("1")

  #example

  = マグカップ
  #example

  = タンブラー
  #example
]

#[
  #reset-counter
  #set heading(numbering: "1.")

  #example

  #show: set-numbering("1")

  = マグカップ
  #example

  = タンブラー
  #example
]

#[
  #reset-counter
  #set heading(numbering: "A.")
  #show: set-numbering("A")

  #example

  = マグカップ
  #example

  = タンブラー
  #example
]

#[
  #reset-counter
  #set heading(numbering: "A.")
  #show: set-numbering(_ => none)

  #example

  #show: set-numbering("A")

  = マグカップ
  #example

  = タンブラー
  #example
]
