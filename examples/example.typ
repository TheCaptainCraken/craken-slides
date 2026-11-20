#import "@local/craken-slides:0.1.0": *

#show: craken-slides.with(
  title: [Divide and conquer, gently],
  subtitle: [From sorting eight cards to the master theorem, one small example at a time.],
  author: "Pietro Agnoli",
  date: [November 2026],
  event: [MIRI seminar · UPC],
  // "paper" by default; `typst compile --input theme=lantern` for a dark room.
  theme: sys.inputs.at("theme", default: "paper"),
  // logo: image("captain-craken.png"),
)

#title-slide()

#outline-slide()

// ───────────────────────────────────────────────────────────────── 1 ──

#section-slide(
  [A tiny example first],
  lede: [Before any formula, let's sort eight cards by hand and watch where the work goes.],
)

#slide(
  title: [Sorting eight cards],
  aside: [
    #note[Von Neumann described merge sort in 1945, for one of the first stored-program computers.]
    #note[A pile of one card is already sorted. That's the base case.]
  ],
)[
  Split the pile in half, sort each half, then merge the two sorted piles by repeatedly taking the smaller top card.

  - Splitting is free: we only point at the middle.
  - Merging piles of sizes $a$ and $b$ takes at most $a + b - 1$ comparisons.
  - Each half is sorted the same way, by calling `merge_sort` again.
]

#slide(title: [The whole algorithm fits on a slide])[
  #code(title: [merge_sort.py], numbers: true)[```python
  def merge_sort(xs):
      if len(xs) <= 1:          # one card: already sorted
          return xs
      m = len(xs) // 2
      return merge(merge_sort(xs[:m]), merge_sort(xs[m:]))
  ```]
  We trust each recursive call like a friend: hand it a smaller pile, get a sorted one back.
]

#idea-slide[Split the problem, solve the halves, and pay only for the _merge_.]

// ───────────────────────────────────────────────────────────────── 2 ──

#section-slide(
  [Counting the work],
  lede: [We write the cost as a recurrence, then draw it as a tree.],
)

#slide(title: [Writing the cost down])[
  #definition[A #dfn[recurrence] describes a quantity in terms of smaller copies of itself.]

  For merge sort on $n$ cards, two half-size sorts plus a linear merge give

  $ T(n) = 2 thin T(n/2) + n, quad T(1) = 0. $ <eq-merge>

  We'll solve @eq-merge twice: once by drawing it, once with a theorem.
]

#slide(
  title: [Every level costs the same],
  aside: [
    #note[Read the tree row by row. The sizes halve, the number of nodes doubles, and the product stays $n$.]
  ],
)[
  #figure(
    canvas(
      width: 450,
      height: 176,
      node(190, 18, $n$, w: 72, h: 36),
      node(95, 88, $n slash 2$, w: 72, h: 36),
      node(285, 88, $n slash 2$, w: 72, h: 36),
      node(45, 158, $n slash 4$, w: 66, h: 36, fill: "paper-warm"),
      node(145, 158, $n slash 4$, w: 66, h: 36, fill: "paper-warm"),
      node(235, 158, $n slash 4$, w: 66, h: 36, fill: "paper-warm"),
      node(335, 158, $n slash 4$, w: 66, h: 36, fill: "paper-warm"),
      edge((172, 36), (112, 70), pad: 2),
      edge((208, 36), (268, 70), pad: 2),
      edge((80, 106), (57, 140), pad: 2),
      edge((110, 106), (133, 140), pad: 2),
      edge((270, 106), (247, 140), pad: 2),
      edge((300, 106), (323, 140), pad: 2),
      ..(18, 88, 158).map(y => tag(400, y, [$= n$])),
    ),
    caption: [The recursion tree of @eq-merge. Each of its $log_2 n$ levels costs $n$.],
  )
]

#slide(title: [Why $n log n$ is worth the trouble])[
  #figure(
    plot(
      width: 600,
      height: 170,
      x: (1, 64),
      y: (0, 640),
      series: (
        (label: [$n^2$], f: x => x * x),
        (label: [$n log_2 n$], f: x => x * calc.log(x, base: 2)),
        (label: [$n$], f: x => x),
      ),
      x-label: [input size $n$],
      y-label: [steps],
    ),
    caption: [Steps against input size. The quadratic curve leaves the chart before $n = 26$.],
  )
]

// ───────────────────────────────────────────────────────────────── 3 ──

#section-slide(
  [The master theorem],
  lede: [One statement that solves a whole family of recurrences at once.],
)

#slide(title: [One theorem for a whole family])[
  #theorem(name: [Master theorem])[
    Let $a >= 1$, $b > 1$, $d >= 0$ and $T(n) = a thin T(n slash b) + Theta(n^d)$. Then
    $ T(n) = cases(
      Theta(n^d) & quad "if" d > log_b a,
      Theta(n^d log n) & quad "if" d = log_b a,
      Theta(n^(log_b a)) & quad "if" d < log_b a.
    ) $
  ] <thm-master>

  For @eq-merge, $a = b = 2$ and $d = 1 = log_2 2$: the middle case, so $T(n) = Theta(n log n)$.
]

#slide(title: [Why the middle case holds])[
  #proof[
    At depth $j$ there are $a^j$ subproblems of size $n slash b^j$, so that level costs $a^j (n slash b^j)^d = n^d (a slash b^d)^j$. When $d = log_b a$ the ratio $a slash b^d$ is $1$: each of the $log_b n + 1$ levels costs $n^d$, and the total is $Theta(n^d log n)$.
  ]

  #section-break()

  The other two cases are geometric series: either the root or the leaves carry almost all the work.
]

#slide(title: [Three cases at a glance])[
  #table(
    columns: (auto, auto, auto, 1fr),
    [Recurrence], [$a, b, d$], [Who wins], [Solution],
    [$T(n) = 2T(n slash 2) + n$], [2, 2, 1], [Balanced], [$Theta(n log n)$],
    [$T(n) = 2T(n slash 2) + n^2$], [2, 2, 2], [The root], [$Theta(n^2)$],
    [$T(n) = 8T(n slash 2) + n^2$], [8, 2, 2], [The leaves], [$Theta(n^3)$],
  )

  Read across each row: whichever of $d$ and $log_b a$ is bigger decides who wins.
]

#slide(title: [A quick check])[
  Every recurrence we've met so far splits into at least two pieces. Here's one that doesn't.

  #question[Binary search satisfies $T(n) = T(n slash 2) + 1$. Which case is it in?]
]

// ───────────────────────────────────────────────────────────────── 4 ──

#section-slide(
  [Your turn],
  lede: [Two exercises, then a famous surprise from 1969.],
)

#slide(title: [Practice])[
  #exercises[
    #exercise(difficulty: 1)[Solve $T(n) = 4 thin T(n slash 2) + n$.]
    #exercise(difficulty: 2)[Karatsuba multiplication: $T(n) = 3 thin T(n slash 2) + O(n)$. How fast is it?]
  ]
  #try-this[Sketch the tree for Exercise 4.1 before you reach for @thm-master.]
]

#reveal-slide(title: [Strassen's question])[
  Strassen multiplies two $n times n$ matrices with seven half-size products instead of eight, plus $Theta(n^2)$ additions. What does that buy us?
][
  Here $a = 7$, $b = 2$ and $d = 2$. Since $log_2 7 approx 2.81 > 2$, the leaves win:
  $ T(n) = Theta(n^(log_2 7)) approx Theta(n^(2.81)), $
  which beats the $Theta(n^3)$ of the schoolbook method.
]

#closing-slide[
  Questions are very welcome. Slides and notes live at #link("https://pietroagnoli.com")[pietroagnoli.com].
]
