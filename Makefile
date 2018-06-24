empty :=
space := $(empty) $(empty)
comma := ,

NAME = pokemon
SRC = $(shell find ./src -name "*.cpp")
SRC += main.cpp
OBJ = $(subst .cpp,.o,$(SRC))

CXX = g++
INCS = 	. src vendor/Simple-WebSocket-Server
CXXFLAGS += -pthread -std=c++11 -Wsign-conversion $(foreach inc, $(INCS),-I $(inc))
LDFLAGS += -lboost_system -lcrypto

all: $(NAME)
	make $(NAME)
	$$SHELL -c "cd client; . .fish_config; build"

$(NAME): $(OBJ)
	$(CXX) $(CXXFLAGS) -o $(NAME) $^ $(LDFLAGS)

clean:
	rm -rf $(OBJ)

fclean: clean
	rm -rf $(NAME)

re: fclean all

install:
	mkdir -p vendor
	if test ! -d vendor/websocketpp ; then git clone https://github.com/zaphoyd/websocketpp.git vendor/websocketpp ; fi
	(cd vendor/websocketpp ; cmake . ; make)

ssl:
	openssl genrsa -des3 -out server.key 1024
	openssl req -new -key server.key -out server.csr
	openssl x509 -req -days 3650 -in server.csr -signkey server.key -out server.crt
	# cp server.key server.key.secure
	# openssl rsa -in server.key.secure -out server.key
	# openssl dhparam -out dh512.pem 512
