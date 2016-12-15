# SimpliFile

[![CI Status](http://img.shields.io/travis/florian/SimpliFile.svg?style=flat)](https://travis-ci.org/florian/SimpliFile)
[![Version](https://img.shields.io/cocoapods/v/SimpliFile.svg?style=flat)](http://cocoapods.org/pods/SimpliFile)
[![License](https://img.shields.io/cocoapods/l/SimpliFile.svg?style=flat)](http://cocoapods.org/pods/SimpliFile)
[![Platform](https://img.shields.io/cocoapods/p/SimpliFile.svg?style=flat)](http://cocoapods.org/pods/SimpliFile)

Two classes for Swift3 to read and write in files more easily (inspired of Java)

It can be used in Ubuntu

#Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Author](#author)
- [License](#license)


##Installation

To use SimpliFile in your xcode project :
* run "sudo gem install cocoapods"
* run "pod init" in your project directory
* add " pod ‘SimpliFile’ " in the Podfile
* run "pod install"
* open your project with the .xcworkspace file

To use SimpliFile in a commandline project (OSX or Ubuntu) :
* copy the source file on https://github.com/FlPe/SimpliFile


##Usage

* Create the reader / the writer
* Write
* Read


#####Create the reader / the writer

In the creation of a reader or a writer, a FileError.FILE_CREATION_ERROR can be thrown.

When a FileReader or a FileWriter is creating with success, the file and all of the subdirectories are created if they don't exist.

For the FileWriter, the append parameter specify if we append text to the file, or if we clear the file before writing.

```swift
import SimpliFile
```

*Available for all platforms :

The pathToDirectory parameter can be a absolute or a relative path.

If we don't specify the pathToDirectory parameter, it will use the current directory

```swift
let writer : FileWriter = try! FileWriter(pathToDirectory: "../textFiles", fileName: "file.txt", append:true)
let reader: FileReader = try! FileReader(pathToDirectory: "../textFiles", fileName: "file.txt")
```

*Available for OSX (not for Ubuntu) :

The directory parameter can take all of the FileManager.SearchPathDirectory values (https://developer.apple.com/reference/foundation/filemanager.searchpathdirectory)

The domainMask parameter can take all of the FileManager.SearchPathDomainMask values (https://developer.apple.com/reference/foundation/filemanager.searchpathdomainmask)

The default value of domainMask is .userDomainMask

```swift
let writer:FileWriter = try! FileWriter(directory: .libraryDirectory, domainMask: .userDomainMask, subDirectories: "application/textFiles", fileName: "text.txt", append: false)     //will use the file "/Users/<login>/Library/application/textFiles/text.txt"

let reader: FileReader =  try! FileReader(directory: .libraryDirectory, domainMask: .userDomainMask, subDirectories: "application/textFiles", fileName: "text.txt")
```


#####Write

a FileError.FILE_WRITING_ERROR can be thrown when you write in a file

```swift
try! writer.write(text: "string1")    //a FileError.FILE_WRITING_ERROR can be thrown
try! writer.newLine()
try! writer.write(text: "string2")
writer.flushAndClose()
```

#####Read

a FileError.FILE_READING_ERROR can be thrown when you read the file

```swift
var isEmpty:Bool = try! reader.isEmptyFile())    //return true if the file is empty

//With the following methods, a FileError.FILE_READING_ERROR can be thrown
var string:String = try! reader.read()    //get all of the content of the file

var ligne: String?
while(!reader.eof()){
ligne = try! reader.readLine()     //Reading by line
}
```


##Author

SimpliFile is owned and maintained by [Fl Pe](fp051888@gmail.com)
You can send him an email if you want to report a bug / talk to him about this module.

## License

SimpliFile is available under the MIT license. See the LICENSE file for more info.
