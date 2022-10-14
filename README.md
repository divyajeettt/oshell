# oshell

## About oshell

oshell is an interactive [Shell](https://en.wikipedia.org/wiki/Shell_(computing)) created to mimic some functionalities of the Artix [Linux](https://en.wikipedia.org/wiki/Linux) Shell. It is a command-line based project developed as a Project Assignment for the course [<b>CSE231: *Operating Systems*</b>](http://techtree.iiitd.edu.in/viewDescription/filename?=CSE231).

*<b>Note:</b> oshell can only run on Linux-based systems (developed on [Artix Linux](https://artixlinux.org/))*

## Some Key Features

### Functionalities

oshell completely mirrors the functionality of the implemented commands on the Linux Shell (at least with respect to the handled options). From the prompt showing the current directory to name of the root user, to the number of spaces in outputs produced by `cat`, oshell (almost) completely mimics the Linux Shell experience.

### Flexibility

Options (aka flags) can be passed anywhere in the command (according to the syntax allowed by the Linux Shell). For example,

```console
[dvgt@oshell Assignment-1]$ rm -rv ./dir1/dir2
```

is equivalent to

```console
[dvgt@oshell Assignment-1]$ rm -v ./dir1/dir2 -r
```

### Edge Cases and Checks against vulnerabilities

The following errors and edge cases are handled by oshell:

- Invalid command passed to the shell
- Invalid option passed to ANY command
- Extra options passed to ANY command
- Extra arguments passed to ANY command
- Missing required arguments by ANY command
- File-Not-Found/Directory-Not-Found or File-Exisits/Directory-Exists types of errors
- Errors arising at run-time due to `fork()`, `execv()`, and/or `pthread_create()` are reported through `perror()`

The following possibilities of vulnerabilities are also handled:

- Protected against input [buffer overflows](https://en.wikipedia.org/wiki/Buffer_overflow).
- Only the mentioned list of commands can be executed through the `system()` API call, to protect the system against injection-related vulnerabilities.
- Protected against EOF Errors, i.e. when the input stream is forcefully shut down (for example, CTRL+D). In that case, oshell logs out just like the Artix Linux Terminal.

## Supported commands

### Internal commands

These commands are written and handled in the `main.c` file itself. These include:

#### cd

The `cd` command allows the user to change the current working directory of the Shell. It supports the following options:

- `-L`: Forces symbolic links to be followed (default)
- `-P`: Use the physical directory structure without following symbolic links

#### echo

The `echo` command writes its arguments to standard output followed by a newline. It supports the following options:

- `-n`: Does not append a trailing newline
- `-e`: Enables interpretation of backslash-escapes

*<b>Assumption:</b> The options given to the `echo` command (if any) will ONLY be given as the first argument. All subsequent options will be treated as text literals.*

#### pwd

The `pwd` command simply displays the current working directory of the Shell. It supports the following options:

- `-L`: Print the value of `$PWD` if it names the current working directory (default)
- `-P`: Print the physical directory without any symbolic links

#### type

The `type` command is used to check how a command is interpreted by the shell, i.e., whether a command is an internal or external command.

*<b>Assumption:</b> Some external commands like `mkdir` and `rm` are displayed as 'hashed' to more accurately "mimic" the Linux Shell's behaviour. In reality, these files are simple executables located in the `./bin` directory.*

#### exit

The `exit` command simply stops the execution of the Shell, i.e., exits it.

### External commands

These commands are written and handled in separate executables (named according to the respective command). If an `&t` follows the command and its arguments/options, the command is executed using the POSIX Pthread family of functions, i.e. `pthread_create()` and `pthread_join()`, and `system()` API calls. Otheriwse, the same command is executed using the `fork()` and `execv()` syscalls.

#### ls

The `ls` command displays a space-separated list of files and directories in the current working directory. Mentioning multiple directories with `ls` will list down the items in each directory. It supports the following options:

- `-a`: Lists down *all* files and directories, i.e., do not ignore entries starting with `.`
- `-1`: Separate the list with newlines instead of spaces

*<b>Assumption:</b> The output order of ls is not sorted by default.*

#### cat

The `cat` command is used to read, concatenate, and write to `stdout`, the contents of files. If no arguments are given, it reads from `stdin` and writes to `stdout` until `EOF` is encountered. It supports the following options:

- `-n`: Enumerate all output lines
- `-E`: Write `$` at the end of each line

#### date

The `date` command is used to display the current system date and time. By defualt, it displays the localtime. It supports the following options:

- `-I`: Output date in ISO-8601 format
- `-R`: Output date in RFC-5322 format
- `-u`: Output the Coordinated Universal Time (UTC)

#### rm

The `rm` command is used to remove files from the system. Mentioning multiple items with `rm` will remove all listed items from the system. It supports the following options:

- `-r`: Remove directories and their contents recursively
- `-v`: Output a message for each deleted file/directory

#### mkdir

The `mdkir` command is used to create directories. Mentioning multiple items with `mdkir` will create all mentioned directories. It supports the following options:

- `-p`: Does not produce an error if the directory exists, and make parent directories as needed
- `-v`: Output a message for each created directory

#### clear

The `clear` command clears the Shell screen. It does not support any options.

#### help

The `help` command displays some help text for the specified command, along with the options it supports.

#### Hidden command

A (hidden) easter-egg command has also been coded into oshell. *For the keen minds, it is a word that I use very often!*

## Run

To use, clone the repository on your device, navigate to the folder, and execute:

```
make
./bin/main
```

## Future Plans

Implement the following interesting command-options (among others):

- `ls -R`
- `cd -`

## References

- [<b>CSE231</b> Lecture Slides: *Dr Sambuddho Chakravarty*](https://drive.google.com/file/d/15927VKp8q1xwLvs28I4lgDyLF0XGcrXk/view)
- [Manual Page: `fork()`](https://man7.org/linux/man-pages/man2/fork.2.html)
- [Manual Page: `exec()`](https://man7.org/linux/man-pages/man3/exec.3.html)
- [Manual Page: `wait()`](https://man7.org/linux/man-pages/man2/waitpid.2.html)
- [Manual Page: `pthread_create()`](https://man7.org/linux/man-pages/man3/pthread_create.3.html)
- [Manual Page: `pthread_join()`](https://man7.org/linux/man-pages/man3/pthread_join.3.html)
- [Manual Page: `system()`](https://man7.org/linux/man-pages/man3/system.3.html)
