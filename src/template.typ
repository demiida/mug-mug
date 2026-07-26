#import "@preview/physica:0.9.8": *
#import "@preview/codelst:2.0.2"
#import "@preview/pillar:0.3.3"
#import "@preview/unify:0.7.1": *
#import table: cell, header, hline, vline

// 数式ブロックの後に使う
#let no-parbreak = {
  context v(-par.spacing / 2, weak: true)
  linebreak()
}

// アラインメント
#let no-indent-align(alignment, body) = {
  align(alignment, par(body, first-line-indent: 0em))
}

#let sourcecode(..args) = codelst.sourcecode(showlines: true, ..args)
#let sourcefile(file-path, ..args) = codelst.sourcefile(read(file-path), file: file-path, showlines: true, ..args)

#let dx = $dd(x)$
#let dy = $dd(y)$
#let dz = $dd(z)$
#let dt = $dd(t)$
#let df = $dd(f)$
#let FT = $op(cal(F))$
#let invFT = $op(cal(F)^(-1))$
#let LT = $op(cal(L))$
#let invLT = $op(cal(L)^(-1))$
#let trans(A, tl-small-symbol: false) = {
  if tl-small-symbol { $thin attach(#A, tl: t)$ } else { $#A^TT thin$ }
}

// 装飾
#let wrap-rect(body, header: none, ..args) = {
  align(
    center,
    context rect(
      width: 100% + measure(counter(math.equation).display()).width,
      inset: 1em,
      align(left, {
        parbreak()
        if header != none {
          h(
            if type(par.first-line-indent) == dictionary {
              -par.first-line-indent.amount
            } else {
              -par.first-line-indent
            },
          )
          strong(header)
          h(1em, weak: true)
        }
        body
      }),
      ..args,
    ),
  )
}

// `heading` の `numbering` を設定したあとに使う
// ```
// #set heading(numbering: "1.")
// #show: set-numbering("1")
// ```
#let set-numbering(
  section-numbering,
  figure-kinds: (image, table, raw),
) = document => {
  // 章が変わったとき、数式・図表の番号をリセット
  let counter-keys = (math.equation, figure-kinds.map(kind => figure.where(kind: kind))).flatten()
  show heading.where(level: 1): it => it + for key in counter-keys { counter(key).update(0) }

  let get-section-number() = {
    let section-number = counter(heading).get().first()
    numbering(section-numbering, section-number)
  }
  let get-numbers(..args) = {
    let section-number = get-section-number()
    let numbers = args.pos().map(str)
    if section-number == none {
      numbers.join([--])
    } else {
      (section-number, numbers).flatten().join([--])
    }
  }

  set math.equation(numbering: (..args) => "(" + get-numbers(..args) + ")")
  set figure(numbering: get-numbers)

  document
}

#let template(
  document,
  text-font: (
    gothic: "Yu Gothic",
    mincho: "Yu Mincho",
  ),
  equation-font: "Cambria Math",
  raw-font: "UDEV Gothic NF",
  first-line-indent: true,
) = {
  set text(
    lang: "ja",
    font: if type(text-font) == dictionary { text-font.mincho } else { text-font },
  )
  show (strong, heading, title).reduce(selector.or): set text(
    font: if type(text-font) == dictionary { text-font.gothic } else { text-font },
  )
  set par(
    justify: true,
    spacing: 1em,
    first-line-indent: if first-line-indent { (amount: 1em, all: true) } else { 0em },
  )

  show regex("[、。，．]"): it => it + h(0pt, weak: true)
  show regex("[（「]"): it => h(-0.25em, weak: true) + it
  show regex("[）」]"): it => it + h(-0.25em, weak: true)

  // 数式
  show math.equation: set text(font: equation-font)

  // ソースコード
  show raw: set text(font: raw-font)
  show figure.where(kind: raw): set block(breakable: true)

  // 図表
  show (table, raw).map(kind => figure.where(kind: kind)).reduce(selector.or): set figure.caption(position: top)

  // 参照
  show ref: it => {
    let space = h(1pt, weak: true)
    space + underline(it, stroke: 0.5pt) + space
  }

  document
}

#let replace-punctuations(document) = {
  show "、": "，"
  show "。": "．"
  document
}
