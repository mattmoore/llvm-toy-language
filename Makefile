all: parser

clean:
	rm parser.cpp parser.hpp parser tokens.cpp

parser.cpp: parser.y
	bison -d -o $@ $^
    
parser.hpp: parser.cpp

tokens.cpp: tokens.l parser.hpp
	lex -o $@ $^

# parser: parser.cpp codegen.cpp main.cpp tokens.cpp
# 	g++ -o $@ `llvm-config-8 --libs core native --cxxflags --ldflags` *.cpp
# 	g++ -o $@ -I/usr/lib/llvm8/include -L/usr/lib/llvm-8/lib *.cpp

# LLVM_FLAGS := $(llvm-config-8 --cxxflags)
# 
# all:
# 	g++ -o parser `llvm-config --libs core jit native --cxxflags --ldflags` *.cpp

parser: parser.cpp codegen.cpp main.cpp tokens.cpp
	flex tokens.l
	bison -d -o parser.cpp parser.y
	lex -o tokens.cpp tokens.l
	g++ \
		-o parser \
		-std=c++0x \
		-I/usr/lib/llvm-8/include \
		-I/usr/local/opt/llvm/include \
		-L/usr/lib/llvm-8/lib \
		-L/usr/local/opt/llvm/lib \
		parser.cpp tokens.cpp main.cpp
