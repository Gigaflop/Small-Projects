#Austin McKay
#CSE 3500 Problem Set 8, Problem 3
#N choose K, with various Dynamic Programming implementations.


#Bottom-up implementation with memoization. Almost always the most effective.
def bottomup(n,k):
    final = {}      #A set to hold the results.
    
    def setup(n,k):     #Helper function to set up the lower-level nCk's, since their values are always known to be 1 or 0.
        for i in range(n+1):
            for j in range(k+1):
                final[(i,j)] = 0
            final[(i,0)] = 1

    def choose(n,k):        #Nested method to perform the actual nCk operation.
        setup(n,k)
        operations = 0      #Counter for the number of total operations performed.
        for i in range(1,n+1):      
            for j in range(1,k+1):
                final[(i,j)] = final[(i-1,j)] + final[(i-1,j-1)]
                operations+=1
                
        print("\tOperations: ", operations)
        print("\t", n, " choose ", k, ": ", final[(n,k)])

    choose(n,k)

#A basic recursive implementation. Often runs out of memory at larger imputs. Least efficient method.
def recursive(n,k):
    operations = [0]        #Counter for the number of toal operations performed.
    operations[0] = 0
    
    def choose(n,k):        #Recursive nCk method.
        operations[0] += 1
        if (n < 0) or (k < 0):
            return 0
        elif n == k:
            return 1
        elif n < k:
            return 0
        return (choose(n-1,k) + choose(n-1, k-1))
    
    result = choose(n,k)
    print("\tOperations: ", operations[0])
    print("\t", n, " choose ", k, ": ", result)

#Top-Down method with memoization. Middle-of-the-road for efficiency, but beats out bottom-up at 5c3 and some other small inputs.
def topdown(n,k):
    operations = [0]        #Track the number of operations. An integer didn't work for some reason.
    results = {}            #A set to hold previously calculated values.

    def choose(n,k):        #Top-Down nCk method.
        operations[0]+=1
        if (n,k) not in results:
            if (n < 0) or (k < 0):
                return 0
            elif n < k:
                results[(n,k)] = 0
                return 0
            elif n==k:
                results[(n,k)] = 1
                return 1
            elif k == 0:
                results[(n,k)] = 1
                return 1
            elif k < n:
                results[(n,k)] = choose(n-1, k) + choose(n-1, k-1)
                return results[(n,k)]
        else:
            return results[(n,k)]
    choose(n,k)
    print("\tOperations: ", operations[0])
    print("\t", n, " choose ", k, ": ", results[(n,k)])
            
#~~~~~~~~~~~~~~~~~~~~~
#Equivalent of main(...){....}:
n = int(input("n? "))
k = int(input("k? "))

if (n >= 0) and (k >= 0):
    print("Bottom-up method: ")
    bottomup(n,k)

    print("Top-Down with memoization: ")
    topdown(n,k)

    print("Basic Recursive: ")
    recursive(n,k)
else:
    print("Negative numbers are invalid input.")

