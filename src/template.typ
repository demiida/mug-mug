#import "@preview/physica:0.9.5": *
#import "@preview/codelst:2.0.2": *
#import "@preview/pillar:0.3.1"
#import "@preview/unify:0.7.1": *
#import table: cell, header, hline, vline

// 数式ブロックの後に使う
#let no-parbreak = {
  context v(-par.spacing * 1.5)
  linebreak()
}

// アラインメント
#let no-indent-align(alignment, body) = {
  align(alignment, par(body, first-line-indent: 0em))
}

// 全角分のスペース
#let hs(count: 1) = h(1em * count, weak: true)

#let sourcecode = sourcecode.with(showlines: true)
#let sourcefile = sourcefile.with(showlines: true)

#let thick2 = $thick thick$
#let wide2 = $wide wide$
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
  align(center, context rect(
    width: 100% + measure(counter(math.equation).display()).width,
    inset: 1em,
    align(left, {
      parbreak()
      if header != none {
        h(-par.first-line-indent.amount)
        strong(header)
        hs()
      }
      body
    }),
    ..args,
  ))
}

#let template(
  document,
  text-font: (
    gothic: "Yu Gothic",
    mincho: "Yu Mincho",
  ),
  equation-font: "Cambria Math",
  first-line-indent: true,
) = {
  set text(lang: "ja", size: 10pt, font: if type(text-font) == dictionary { text-font.mincho } else { text-font })
  show (strong, heading).reduce(selector.or): it => {
    set text(font: if type(text-font) == dictionary { text-font.gothic } else { text-font })
    it
  }
  set par(
    justify: true,
    spacing: 10.5pt,
    first-line-indent: if first-line-indent { (amount: 1em, all: true) } else { 0em },
  )

  // 数式
  show math.equation: set text(font: equation-font)
  set math.equation(numbering: "(1)")

  // ソースコード
  show raw: set text(font: "UDEV Gothic NF")
  show figure.where(kind: raw): set block(breakable: true)

  // 図表
  set figure(numbering: "1 ")
  show (table, raw).map(kind => figure.where(kind: kind)).reduce(selector.or): it => {
    set figure.caption(position: top)
    it
  }

  // 参照
  show ref: it => {
    let el = it.element
    if el != none and el.func() == math.equation {
      link(
        el.location(),
        {
          el.supplement
          numbering(
            el.numbering,
            ..counter(
              el.func(),
            ).at(el.location()),
          )
        },
      )
    } else {
      it
    }
  }

  document
}

#let replace-punctuations(document) = {
  show "、": "，"
  show "。": "．"
  document
}
