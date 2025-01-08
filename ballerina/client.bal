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

import ballerina/http;

public isolated client class Client {
    final http:Client clientEp;
    final readonly & ApiKeysConfig? apiKeyConfig;
    # Gets invoked to initialize the `connector`.
    #
    # + config - The configurations to be used when initializing the `connector` 
    # + serviceUrl - URL of the target service 
    # + return - An error if connector initialization failed 
    public isolated function init(ConnectionConfig config, string serviceUrl = "https://api.hubapi.com") returns error? {
        http:ClientConfiguration httpClientConfig = {httpVersion: config.httpVersion, timeout: config.timeout, forwarded: config.forwarded, poolConfig: config.poolConfig, compression: config.compression, circuitBreaker: config.circuitBreaker, retryConfig: config.retryConfig, validation: config.validation};
        do {
            if config.http1Settings is ClientHttp1Settings {
                ClientHttp1Settings settings = check config.http1Settings.ensureType(ClientHttp1Settings);
                httpClientConfig.http1Settings = {...settings};
            }
            if config.http2Settings is http:ClientHttp2Settings {
                httpClientConfig.http2Settings = check config.http2Settings.ensureType(http:ClientHttp2Settings);
            }
            if config.cache is http:CacheConfig {
                httpClientConfig.cache = check config.cache.ensureType(http:CacheConfig);
            }
            if config.responseLimits is http:ResponseLimitConfigs {
                httpClientConfig.responseLimits = check config.responseLimits.ensureType(http:ResponseLimitConfigs);
            }
            if config.secureSocket is http:ClientSecureSocket {
                httpClientConfig.secureSocket = check config.secureSocket.ensureType(http:ClientSecureSocket);
            }
            if config.proxy is http:ProxyConfig {
                httpClientConfig.proxy = check config.proxy.ensureType(http:ProxyConfig);
            }
        }
        if config.auth is ApiKeysConfig {
            self.apiKeyConfig = (<ApiKeysConfig>config.auth).cloneReadOnly();
        } else {
            httpClientConfig.auth = <http:BearerTokenConfig|OAuth2RefreshTokenGrantConfig>config.auth;
            self.apiKeyConfig = ();
        }
        http:Client httpEp = check new (serviceUrl, httpClientConfig);
        self.clientEp = httpEp;
        return;
    }

    # Archive
    #
    # + headers - Headers to be sent with the request 
    # + return - No content 
    resource isolated function delete crm/v3/objects/feedback_submissions/[string feedbackSubmissionId](map<string|string[]> headers = {}) returns http:Response|error {
        string resourcePath = string `/crm/v3/objects/feedback_submissions/${getEncodedUri(feedbackSubmissionId)}`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app-legacy"] = self.apiKeyConfig?.private\-app\-legacy;
        }
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        return self.clientEp->delete(resourcePath, headers = httpHeaders);
    }

    # List
    #
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    resource isolated function get crm/v3/objects/feedback_submissions(map<string|string[]> headers = {}, *GetCrmV3ObjectsFeedback_submissions_getpageQueries queries) returns CollectionResponseSimplePublicObjectWithAssociationsForwardPaging|error {
        string resourcePath = string `/crm/v3/objects/feedback_submissions`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app-legacy"] = self.apiKeyConfig?.private\-app\-legacy;
        }
        map<Encoding> queryParamEncoding = {"properties": {style: FORM, explode: true}, "propertiesWithHistory": {style: FORM, explode: true}, "associations": {style: FORM, explode: true}};
        resourcePath = resourcePath + check getPathForQueryParam(queries, queryParamEncoding);
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        return self.clientEp->get(resourcePath, httpHeaders);
    }

    # Read
    #
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    resource isolated function get crm/v3/objects/feedback_submissions/[string feedbackSubmissionId](map<string|string[]> headers = {}, *GetCrmV3ObjectsFeedback_submissionsFeedbacksubmissionid_getbyidQueries queries) returns SimplePublicObjectWithAssociations|error {
        string resourcePath = string `/crm/v3/objects/feedback_submissions/${getEncodedUri(feedbackSubmissionId)}`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app-legacy"] = self.apiKeyConfig?.private\-app\-legacy;
        }
        map<Encoding> queryParamEncoding = {"properties": {style: FORM, explode: true}, "propertiesWithHistory": {style: FORM, explode: true}, "associations": {style: FORM, explode: true}};
        resourcePath = resourcePath + check getPathForQueryParam(queries, queryParamEncoding);
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        return self.clientEp->get(resourcePath, httpHeaders);
    }

    # Update
    #
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    resource isolated function patch crm/v3/objects/feedback_submissions/[string feedbackSubmissionId](SimplePublicObjectInput payload, map<string|string[]> headers = {}, *PatchCrmV3ObjectsFeedback_submissionsFeedbacksubmissionidQueries queries) returns SimplePublicObject|error {
        string resourcePath = string `/crm/v3/objects/feedback_submissions/${getEncodedUri(feedbackSubmissionId)}`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app-legacy"] = self.apiKeyConfig?.private\-app\-legacy;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->patch(resourcePath, request, httpHeaders);
    }

    # Create
    #
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function post crm/v3/objects/feedback_submissions(SimplePublicObjectInputForCreate payload, map<string|string[]> headers = {}) returns SimplePublicObject|error {
        string resourcePath = string `/crm/v3/objects/feedback_submissions`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app-legacy"] = self.apiKeyConfig?.private\-app\-legacy;
        }
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }

    # Archive a batch of feedback submissions by ID
    #
    # + headers - Headers to be sent with the request 
    # + return - No content 
    resource isolated function post crm/v3/objects/feedback_submissions/batch/archive(BatchInputSimplePublicObjectId payload, map<string|string[]> headers = {}) returns http:Response|error {
        string resourcePath = string `/crm/v3/objects/feedback_submissions/batch/archive`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app-legacy"] = self.apiKeyConfig?.private\-app\-legacy;
        }
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }

    # Create a batch of feedback submissions
    #
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function post crm/v3/objects/feedback_submissions/batch/create(BatchInputSimplePublicObjectInputForCreate payload, map<string|string[]> headers = {}) returns BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors|error {
        string resourcePath = string `/crm/v3/objects/feedback_submissions/batch/create`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app-legacy"] = self.apiKeyConfig?.private\-app\-legacy;
        }
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }

    # Read a batch of feedback submissions by internal ID, or unique property values
    #
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    resource isolated function post crm/v3/objects/feedback_submissions/batch/read(BatchReadInputSimplePublicObjectId payload, map<string|string[]> headers = {}, *PostCrmV3ObjectsFeedback_submissionsBatchRead_readQueries queries) returns BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors|error {
        string resourcePath = string `/crm/v3/objects/feedback_submissions/batch/read`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app-legacy"] = self.apiKeyConfig?.private\-app\-legacy;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }

    # Update a batch of feedback submissions
    #
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function post crm/v3/objects/feedback_submissions/batch/update(BatchInputSimplePublicObjectBatchInput payload, map<string|string[]> headers = {}) returns BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors|error {
        string resourcePath = string `/crm/v3/objects/feedback_submissions/batch/update`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app-legacy"] = self.apiKeyConfig?.private\-app\-legacy;
        }
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }

    # Create or update a batch of feedback submissions by unique property values
    #
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function post crm/v3/objects/feedback_submissions/batch/upsert(BatchInputSimplePublicObjectBatchInputUpsert payload, map<string|string[]> headers = {}) returns BatchResponseSimplePublicUpsertObject|BatchResponseSimplePublicUpsertObjectWithErrors|error {
        string resourcePath = string `/crm/v3/objects/feedback_submissions/batch/upsert`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app-legacy"] = self.apiKeyConfig?.private\-app\-legacy;
        }
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }

    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function post crm/v3/objects/feedback_submissions/search(PublicObjectSearchRequest payload, map<string|string[]> headers = {}) returns CollectionResponseWithTotalSimplePublicObjectForwardPaging|error {
        string resourcePath = string `/crm/v3/objects/feedback_submissions/search`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app-legacy"] = self.apiKeyConfig?.private\-app\-legacy;
        }
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }
}
