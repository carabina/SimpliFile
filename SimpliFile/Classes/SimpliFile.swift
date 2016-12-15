import Foundation
#if os(Linux)
    import Glibc
#endif



//Files

public enum FileError : Error{
    case FILE_CREATION_ERROR
    case FILE_READING_ERROR
    case FILE_WRITING_ERROR
}

public class File{
    internal var file: URL
    
    #if !os(Linux)
    public init(directory: FileManager.SearchPathDirectory, domainMask:FileManager.SearchPathDomainMask,
                  subDirectories: String, fileName: String) throws{
        
        do {
            let libraryDirectory:URL = FileManager.default.urls(for: directory, in: domainMask).first!
            let path:URL = libraryDirectory.appendingPathComponent(subDirectories)
            try FileManager.default.createDirectory(atPath: path.path, withIntermediateDirectories: true, attributes: nil)
            
            file = path.appendingPathComponent(fileName)
            
            if(!FileManager.default.fileExists(atPath: file.path)){
                if(!FileManager.default.createFile(atPath: file.path, contents: nil)){
                    throw FileError.FILE_CREATION_ERROR
                }
            }
            
        }
        catch{
            throw FileError.FILE_CREATION_ERROR
        }
    }
    
    public convenience init(directory: FileManager.SearchPathDirectory, subDirectories: String, fileName: String) throws{
        try self.init(directory: directory, domainMask: .userDomainMask, subDirectories: subDirectories, fileName: fileName)
    }
    #endif
    
    private func initAbsolutePath(absolutePathToDirectory: String, fileName: String) throws{
        do{
            let path:URL = URL(fileURLWithPath: absolutePathToDirectory)
            try FileManager.default.createDirectory(atPath: path.path, withIntermediateDirectories: true, attributes: nil)
            
            file = path.appendingPathComponent(fileName)
            if(!FileManager.default.fileExists(atPath: file.path)){
                if(!FileManager.default.createFile(atPath: file.path, contents: nil)){
                    throw FileError.FILE_CREATION_ERROR
                }
            }
        }
        catch{
            throw FileError.FILE_CREATION_ERROR
        }
        
    }
    
    public init(pathToDirectory: String, fileName: String) throws{
        var pathToDirectory:String = pathToDirectory;
        file = URL(fileURLWithPath: "")
        
        if(pathToDirectory.substring(from:0, to:1) == "~"){
            pathToDirectory = NSString(string: pathToDirectory).expandingTildeInPath
        }
        
        if(pathToDirectory.substring(from:0, to:1) == "/"){             //Poss de rediriger vers init av absolutePath
            try initAbsolutePath(absolutePathToDirectory: pathToDirectory, fileName: fileName)
        }
        else{
            let filemgr:FileManager = FileManager.default
            var path:URL = URL(fileURLWithPath: filemgr.currentDirectoryPath)   //String
            
            do{
                path = path.appendingPathComponent(pathToDirectory)
                try FileManager.default.createDirectory(atPath: path.path, withIntermediateDirectories: true, attributes: nil)
                
                file = path.appendingPathComponent(fileName)
                if(!FileManager.default.fileExists(atPath: file.path)){
                    if(!FileManager.default.createFile(atPath: file.path, contents: nil)){
                        throw FileError.FILE_CREATION_ERROR
                    }
                }
            }
            catch{
                throw FileError.FILE_CREATION_ERROR
            }
        }
        
    }
    
    public init(fileName: String) throws{
        let filemgr:FileManager = FileManager.default
        let path:URL = URL(fileURLWithPath: filemgr.currentDirectoryPath)   //String
        
        do{
            file = path.appendingPathComponent(fileName)
            if(!FileManager.default.fileExists(atPath: file.path)){
                if(!FileManager.default.createFile(atPath: file.path, contents: nil)){
                    throw FileError.FILE_CREATION_ERROR
                }
            }
        }
        catch{
            throw FileError.FILE_CREATION_ERROR
        }
        
    }
}


public class FileReader : File{
    private var fileContent: [String]?
    private var lineIndex: Int
    
    #if !os(Linux)
    public override init(directory: FileManager.SearchPathDirectory, domainMask:FileManager.SearchPathDomainMask,
                         subDirectories: String, fileName: String) throws{
        fileContent = nil
        lineIndex = -1
        try super.init(directory: directory, domainMask:domainMask, subDirectories: subDirectories, fileName: fileName)
    }
    
    public convenience init(directory: FileManager.SearchPathDirectory, subDirectories: String, fileName: String) throws{
        try self.init(directory: directory, domainMask: .userDomainMask, subDirectories: subDirectories, fileName: fileName)
    }
    #endif
    
    public override init(pathToDirectory: String, fileName: String) throws{
        fileContent = nil
        lineIndex = -1
        try super.init(pathToDirectory: pathToDirectory, fileName: fileName)
    }
    
    public override init(fileName: String) throws{
        fileContent = nil
        lineIndex = -1
        try super.init(fileName: fileName)
    }
    
    public func read() throws -> String{
        var entireFileContent:String
        do{
            entireFileContent = try String(contentsOf: file, encoding: String.Encoding.utf8)
        }
        catch{
            throw FileError.FILE_READING_ERROR
        }
        
        return entireFileContent
    }
    
    public func readLine() throws -> String?{
        if(fileContent == nil){
            do{
                fileContent = try String(contentsOf: file, encoding: String.Encoding.utf8).components(separatedBy: "\n")
                lineIndex = 0
            }
            catch{
                throw FileError.FILE_READING_ERROR
            }
        }
        
        if(!eof()){
            lineIndex += 1
            return fileContent![lineIndex - 1]
        }
        else{
            return nil
        }
    }
    
    public func isEmptyFile() throws -> Bool{
        let attr:[FileAttributeKey : Any]
        do{
            attr = try FileManager.default.attributesOfItem(atPath: file.path)
        }
        catch{
            throw FileError.FILE_READING_ERROR
        }
        
        return (attr[FileAttributeKey.size] as! NSNumber).int8Value == 0
    }
    
    public func eof() ->Bool{
        if(lineIndex != -1 && lineIndex >= fileContent!.count){
            return true
        }
        return false
    }
}

public class FileWriter : File{
    private var appendTextToFile: Bool
    private var outputStream: OutputStream?
    
    
    #if !os(Linux)
    public init(directory: FileManager.SearchPathDirectory, domainMask:FileManager.SearchPathDomainMask, subDirectories: String, fileName: String, append: Bool) throws{
        appendTextToFile = append
        outputStream = nil
        try super.init(directory: directory, domainMask:domainMask, subDirectories: subDirectories, fileName: fileName)
        try openOutputStream()
    }
    
    public convenience init(directory: FileManager.SearchPathDirectory, subDirectories: String, fileName: String, append: Bool) throws{
        try self.init(directory: directory, domainMask: .userDomainMask, subDirectories: subDirectories, fileName: fileName, append: append)
    }
    #endif
    
    public init(pathToDirectory: String, fileName: String, append: Bool) throws{
        appendTextToFile = append
        outputStream = nil
        try super.init(pathToDirectory: pathToDirectory, fileName: fileName)
        try openOutputStream()
    }
    
    public init(fileName: String, append: Bool) throws{
        appendTextToFile = append
        outputStream = nil
        try super.init(fileName: fileName)
        try openOutputStream()
    }
    
    public func write(text: String) throws{
        let bytesWritten:Int = outputStream!.write(text, maxLength: text.characters.count)
        if bytesWritten != text.characters.count{
            throw FileError.FILE_WRITING_ERROR
        }
    }
    
    public func newLine() throws{
        let bytesWritten:Int = outputStream!.write("\n", maxLength: 1)
        if bytesWritten != 1{
            throw FileError.FILE_WRITING_ERROR
        }
    }
    
    public func flushAndClose(){
        outputStream!.close()
        outputStream = nil
    }
    
    private func openOutputStream() throws{
        outputStream = OutputStream(url: file, append: appendTextToFile)
        if(outputStream == nil){
            throw FileError.FILE_CREATION_ERROR
        }
        
        outputStream!.open()
    }
}




//String functions

extension String {
    public func substring(from: Int, to: Int) -> String{
        let indexFrom:String.Index = index(startIndex, offsetBy: from)
        let indexTo:String.Index = index(startIndex, offsetBy: to)
        return substring(with: indexFrom ..< indexTo)
    }
}

