//
//  Constants.swift
//  PostsApp
//

import Foundation
import AWSCore
import AWSAppSync

//let CognitoIdentityPoolId = ""
//let CognitoIdentityRegion: AWSRegionType = .USEast2
//let AppSyncRegion: AWSRegionType = .USWest2
//let AppSyncEndpointURL: URL = URL(string: "https://yourendpoint.us-west-2.amazonaws.com/graphql")!
//let database_name = "appsync-local-db"

// The API Key for authorization
let StaticAPIKey = "da2-tv7eyhbu3veo3iheopcblazsmi"
// The Endpoint URL for AppSync
let AppSyncEndpointURL: URL = URL(string: "https://rrmdpg6g4ze3pjzjrefi722sky.appsync-api.us-east-2.amazonaws.com/graphql")!
let AppSyncRegion: AWSRegionType = AWSRegionType.USEast2
let database_name = "appsync-local-db"


class APIKeyAuthProvider: AWSAPIKeyAuthProvider {
    func getAPIKey() -> String {
        // This function could dynamicall fetch the API Key if required and return it to AppSync client.
        return StaticAPIKey
    }
}
