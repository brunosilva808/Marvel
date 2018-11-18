//
//  Service.swift
//  Marvel
//
//  Created by Bruno Silva on 16/11/2018.
//

import Foundation

enum APIConstant {

    static var baseUrl = "https://gateway.marvel.com:443/v1/public"
    
    enum Header {
        static let contentType = "Content-Type"
    }
    
    enum Parameter {
        static let timeStamp = "ts="
        static let apiKey = "apikey="
    }
    
    enum Value {
        static let timeStamp = "1"
        static var publicKey = "2b78d362481839c76e3df81e3b13d6e5"
        static var privateKey = "a1b0fc8354dee2423349c6d1453dbc91a7716bc6"
    }
    
//    enum Portrait {
//        static let small = "/portrait_small"
//        static let medium = "/portrait_medium"
//        static let xlarge = "/portrait_xlarge"
//        static let fantastic = "/portrait_fantastic"
//    }

    enum Portrait {
        case small
        case medium
        case xlarge
        case fantastic
        case uncanny
        case incredible
        case Void()
    }
    
    //portrait_small    50x75px
    //portrait_medium    100x150px
    //portrait_xlarge    150x225px
    //portrait_fantastic    168x252px
    //portrait_uncanny    300x450px
    //portrait_incredible    216x324px
}

struct APIEndpoint {
    static var comics = "/comics?"
}

enum Endpoint {
    case comic
}

enum Filter {
    case cover
    case format
}

extension Service {
    
    private var timeStamp: String {
        return APIConstant.Parameter.timeStamp + APIConstant.Value.timeStamp
    }
    
    private var apiKey: String {
        return APIConstant.Parameter.apiKey + APIConstant.Value.publicKey
    }
    
    private var md5Digest: String {
        let digest = APIConstant.Value.timeStamp +
                APIConstant.Value.privateKey +
                APIConstant.Value.publicKey
            
        return "hash=" + "\(digest.utf8.md5)"
    }
    
    private func url(endpoint: Endpoint, filters: [Filter]? = []) -> URL {
        var urlString = APIConstant.baseUrl
        
        switch endpoint {
        case .comic:
            urlString += APIEndpoint.comics
            break
        }
        
        return URL(string: addParameters(urlString: urlString, filters: filters))!
    }
    
    private func addParameters(urlString: String, filters: [Filter]? = []) -> String {

        var parametersArray = [timeStamp, apiKey, md5Digest]
        
        if let array = filters {
            for filter in array {
                switch filter {
                case .cover:
                    parametersArray.append("format=hardcover")
                    break
                case .format:
                    parametersArray.append("formatType=comic")
                    break
                }
            }

        }
        
        return urlString + parametersArray.joined(separator: "&")
    }
    
    private var requestHTTPHeaders: [String : String] {
        let headers = [APIConstant.Header.contentType: "application/json"]
        return headers
    }
    
    private func request(endpoint: Endpoint, filters: [Filter]? = []) -> URLRequest {
        var request = URLRequest(url: url(endpoint: .comic, filters: filters))
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = requestHTTPHeaders
        
        return request
    }
    
    
    
}

class Service {
    
    static var shared = Service()
    
    typealias APISuccessCallback<T> = (_ response: T) -> ()
    typealias APIErrorCallback = () -> ()
    
    func getComics(filters: [Filter]? = [], onSuccess: @escaping APISuccessCallback<Comic>, onError: @escaping APIErrorCallback) {
        URLSession.shared.dataTask(with: request(endpoint: .comic, filters: filters)) { (data, response, error) in
            guard let data = data else { return }
            let comics = try? JSONDecoder().decode(Comic.self, from: data)
            
            switch comics?.code {
            case 200:
                onSuccess(comics!)
                break
            default:
                onError()
                break;
            }
            
        }.resume()
    }
    
    func getImageUrl(thumbnail: Thumbnail, size: APIConstant.Portrait) -> String {
        var urlString = thumbnail.path
        
        switch size {
        case .small:
            urlString += "/portrait_small"
            break
        case .medium:
            urlString += "/portrait_medium"
            break
        case .xlarge:
            urlString += "/portrait_xlarge"
            break
        case .fantastic:
            urlString += "/portrait_fantastic"
            break
        case .uncanny:
            urlString += "/portrait_uncanny"
            break
        case .incredible:
            urlString += "/portrait_incredible"
            break
        default:
            break
        }
        
        urlString += "." + thumbnail.thumbnailExtension.rawValue
        
        return urlString
    }
    
}
