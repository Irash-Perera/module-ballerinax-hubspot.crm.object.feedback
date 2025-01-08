// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

// import ballerina/http;
import ballerina/test;
import ballerina/oauth2;

// configurable http:BearerTokenConfig & readonly authConfig = ?;
configurable string & readonly clientId = ?;
configurable string & readonly clientSecret = ?;
configurable string & readonly refreshToken = ?;
OAuth2RefreshTokenGrantConfig authConfig = {
    clientId: clientId,
    clientSecret: clientSecret,
    refreshToken: refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER 
};

ConnectionConfig config = {auth : authConfig};
final Client baseClient = check new Client(config);
final string testFeedbackSubmissionId = "392813793683";
final string testFeedbackProperty = "this_is_for_testing_purpose_";

@test:Config {}
isolated function getPageOfFeedbackSubmissions() returns error? {
    CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = check baseClient->/feedback_submissions;
    test:assertTrue(response?.results.length()>=0);
}

@test:Config {}
isolated function  getFeedbackSubmissionById() returns error? { 
    SimplePublicObjectWithAssociations response = check baseClient->/feedback_submissions/[testFeedbackSubmissionId];
    test:assertEquals(response?.properties,
            {   
                "hs_createdate": "2024-12-22T07:28:21.099Z",
                "hs_lastmodifieddate": "2024-12-22T07:28:21.328Z",
                "hs_object_id": "392813793683"
            }   
        );
}

@test:Config {}
isolated function  searchFeedbackSubmissions() returns error?{
    CollectionResponseWithTotalSimplePublicObjectForwardPaging response = check baseClient->/feedback_submissions/search.post(
        payload = {
            "filterGroups": [
                {"filters": [
                    {
                    "propertyName": "hs_createdate",
                    "value": "2024-12-22T07:26:59.374Z",
                    "operator": "EQ"
                    }
                ]}],
            "limit": 3
        }
    );
    test:assertTrue(response?.results.length() <= 3);      
}


@test:Config {}
isolated function  readBacthOfFeedback() returns error?{
    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors response = check baseClient->/feedback_submissions/batch/read.post(
        payload = {
            "propertiesWithHistory": [
                testFeedbackProperty
            ],
            "inputs": [
                {
                "id": testFeedbackSubmissionId
                }
            ],
            "properties": [
                testFeedbackProperty
            ]
        }
    );

    test:assertTrue(response?.status == "COMPLETE");
    test:assertEquals(response?.results[0].properties,
        {
            "hs_createdate": "2024-12-22T07:28:21.099Z",
            "hs_lastmodifieddate": "2024-12-22T07:28:21.328Z",
            "hs_object_id": "392813793683",
            "this_is_for_testing_purpose_": "2"
        });   
}