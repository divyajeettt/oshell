all: makedir compile

makedir:
	mkdir -p ./bin

compile:
	gcc ./src/main.c -o ./bin/main
	gcc ./src/cat.c -o ./bin/cat
	gcc ./src/date.c -o ./bin/date
	gcc ./src/ls.c -o ./bin/ls
	gcc ./src/mkdir.c -o ./bin/mkdir
	gcc ./src/rm.c -o ./bin/rm
	gcc ./src/clear.c -o ./bin/clear

clean:
	rm -rf ./bin
