# this assumes generator matrices are k x n, i.e. encodeing is wG
# and parity-check matrices are (n-k) x n, i.e. checking is Px

def gen2par(G):
	# is also par2gen
	R = G.rref() # vs .echelon_form()?

	k = G.nrows()
	n = G.ncols()
	i = 0
	non_leading_columns = []

	ei = vector(GF(2), [0]*i + [1] + [0]*(k-i-1))
	for j in range(n):
		if R.column(j) != ei:
			non_leading_columns.append(j)
		else:
			i += 1
			if i == k:
				for jj in range(j+1, n):
					non_leading_columns.append(jj)
				break
			ei = vector(GF(2), [0]*i + [1] + [0]*(k-i-1))

	At = R.matrix_from_columns(non_leading_columns).transpose()
	P_cols = []

	i = 0
	non_leading_columns_ind = 0
	for j in range(n):
		if non_leading_columns_ind < len(non_leading_columns) and j == non_leading_columns[non_leading_columns_ind]:
			P_cols.append(vector(GF(2), [0]*non_leading_columns_ind + [1] + [0]*(n-k-non_leading_columns_ind-1)))
			non_leading_columns_ind += 1
		else:
			P_cols.append(-At.column(i))
			i += 1
	return matrix(P_cols).transpose()


def print_from_parity(P):
	res = []
	n = P.ncols()
	for i in range(2**n):
		w = bin(i)[2:]
		w = vector(GF(2), [0]*(n-len(w))+list(w))
		if P*w == 0:
			res.append(w)
	for r in sorted(res):
		print(r)

def print_from_generator(G):
	res = []
	k = G.nrows()
	for i in range(2**k):
		w = bin(i)[2:]
		w = vector(GF(2), [0]*(k-len(w))+list(w))
		res.append(w*G)
	for r in sorted(res):
		print(r)



G = MatrixSpace(GF(2), 4, 7)([
[0,1,1,0,0,0,1],
[1,1,1,1,1,1,1],
[1,0,0,0,1,0,1],
[1,1,0,0,0,1,0]
])

G2 = MatrixSpace(GF(2), 2, 3)([
[1, 1, 0],
[0, 0, 1]
])

Had = MatrixSpace(GF(2), 3, 7)([
[0, 0, 0, 1, 1, 1, 1],
[0, 1, 1, 0, 0, 1, 1],
[1, 0, 1, 0, 1, 0, 1]
])

P = gen2par(G)

print_from_generator(G)
print('')
print_from_parity(P)

