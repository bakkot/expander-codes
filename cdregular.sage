from random import shuffle

def cdregular(c, d, n):
	left = []
	for k in range(n):
		left += [k]*d
	right = []
	for k in range((d/c)*n):
		right += [n+k]*c
	shuffle(left)
	shuffle(right)
	edges = set()
	for l, r in zip(left, right):
		edges.add((l, r))
	g = BipartiteGraph(Graph(list(edges)))
	A, B = g.bipartition()

	not_done = True
	while not_done:
		left_misses = []
		for v in A:
			if g.degree(v) < 5:
				left_misses.append(v)
		right_misses = []
		for v in B:
			if g.degree(v) < 3:
				right_misses.append(v)

		if (len(left_misses) != len(right_misses)):
			raise 'mismatch'
		shuffle(left_misses)
		shuffle(right_misses)
		g.add_edges(zip(left_misses, right_misses))

		not_done = False
		for v in A:
			if g.degree(v) != 5:
				not_done = True
				break
		for v in B:
			if g.degree(v) != 3:
				not_done = True
				break
	return g



 # (d/c)*n should be an integer

print(repr(dumps(cdregular(3, 5, 600))))
