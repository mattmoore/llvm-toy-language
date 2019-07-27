LLVM_FLAGS := $(llvm-config-8 --cxxflags)

all:
	export LDFLAGS="-L/usr/local/opt/llvm/lib"
	export CPPFLAGS="-I/usr/local/opt/llvm/include"
	flex tokens.l
	bison -d -o parser.cpp parser.y
	lex -o tokens.cpp tokens.l
	g++ \
		-o parser \
		-std=c++0x \
		-I/usr/local/opt/llvm/include \
		-L/usr/local/opt/llvm/lib \
		parser.cpp tokens.cpp main.cpp
