BASE		= ..

ifeq ($(OS),Darwin)
LDFLAGS 	+= -Wl,-dead_strip
else
LDFLAGS 	+= -Wl,--gc-sections
endif

TOOLS		= ./src/tools
VALGRIND	= ../valgrind
SRC 		= ./src
LIBRARY 	= $(OBJ)/libFLAC.a $(OBJ)/libshine.a
DEFINES 	= -DHAIRTUNES_STANDALONE -DHTTP_PARSER_STRICT=0 -D_POSIX_PTHREAD_SEMANTICS -D_REENTRANT -DMDNS_SVC -DNDEBUG -D_GNU_SOURCE 

TINYMDNS	= $(BASE)/tinysvcmdns

vpath %.c $(TOOLS):$(SRC):$(TINYMDNS)

INCLUDE = -I. \
		  -I$(BASE)/shine/src/lib \
		  -I$(VALGRIND)/memcheck -I$(VALGRIND)/include \
		  -I$(TINYMDNS) \
		  -I$(SRC) \
		  -I$(TOOLS) \
		  -I$(BASE)/flac/include

SOURCES = alac.c hairtunes.c main.c \
		  mdns.c mdnsd.c tinysvcmdns.c \
		  log_util.c util.c
		
OBJECTS = $(patsubst %.c,$(OBJ)/%.o,$(SOURCES)) 

all: $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(OBJECTS) $(LIBRARY) $(LDFLAGS) -o $@

$(OBJECTS): | bin $(OBJ)

$(OBJ):
	@mkdir -p $@
	
bin:	
	@mkdir -p bin

$(OBJ)/%.o : %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INCLUDE) $< -c -o $@
	
clean:
	rm -f $(OBJECTS) $(EXECUTABLE) 

