from random import randrange

def gen2par(G, F = GF(2)):
	# is also par2gen

	# Assumes G is not deficient, i.e., is of rank equal to its height.
	# If this is not the case, rref it and stip off excess rows.
	R = G.rref() # vs .echelon_form()?

	k = G.nrows()
	n = G.ncols()
	i = 0
	non_leading_columns = []

	ei = vector(F, [0]*i + [1] + [0]*(k-i-1))
	for j in range(n):
		if R.column(j) != ei:
			non_leading_columns.append(j)
		else:
			i += 1
			if i == k:
				for jj in range(j+1, n):
					non_leading_columns.append(jj)
				break
			ei = vector(F, [0]*i + [1] + [0]*(k-i-1))

	At = R.matrix_from_columns(non_leading_columns).transpose()
	P_cols = []

	i = 0
	for j in range(n):
		if i < len(non_leading_columns) and j == non_leading_columns[i]:
			P_cols.append(vector(F, [0]*i + [1] + [0]*(n-k-i-1)))
			i += 1
		else:
			P_cols.append(-At.column(j-i))
	return matrix(P_cols).transpose() # transpose because matrix() takes a list of rows







def to_bits(n, d):
	w = bin(d)[2:]
	return [[0]*(n-len(w)) + list(int(b) for b in w)]

class Had:
  def __init__(self, k):
  	self.k = k
  	self.d = 2**(k-1)

  	cols = []
  	for i in range(0, 2**k):
  		cols += to_bits(k, i)
  	self.G = matrix(GF(2), cols).transpose()
  	print(self.G)

  	self.P = gen2par(self.G)

  def encode(self, w):
  	t = vector(GF(2), reversed(w)) * self.G
  	return t

  def decode(self, w):
  	x = []
  	for i in range(self.k):
  		ones = 0
  		for j in range(2**self.k):
	  		k = j ^^ (2**i)
	  		if w[j] + w[k] == 1:
	  			ones += 1
	  	x.append(1 if ones >= 2**(self.k - 1) else 0)
  	return vector(GF(2), x)

  def nearest_codeword(self, w):
  	return self.encode(self.decode(w))

H = Had(4)
x = H.encode([1, 0, 1, 1])
print(x)
# d = H.decode(x)
# print(d)
# print(H.encode(d))
y = x + vector(GF(2), ([1]*3 + [0]*((2**4)-3)))
d = H.nearest_codeword(y)
print(d)

