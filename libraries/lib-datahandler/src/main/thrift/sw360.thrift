/*
 * Copyright Siemens AG, 2014-2017, 2019. Part of the SW360 Portal Project.
 * With contributions by Bosch Software Innovations GmbH, 2016.
 *
 * This program and the accompanying materials are made
 * available under the terms of the Eclipse Public License 2.0
 * which is available at https://www.eclipse.org/legal/epl-2.0/
 *
 * SPDX-License-Identifier: EPL-2.0
 */

namespace java org.eclipse.sw360.datahandler.thrift
namespace php sw360.thrift

enum Ternary {
    UNDEFINED = 0,
    NO = 1,
    YES = 2,
}

enum RequestStatus {
    SUCCESS = 0,
    SENT_TO_MODERATOR = 1,
    FAILURE = 2,
    IN_USE = 3,
    FAILED_SANITY_CHECK = 4,
    DUPLICATE = 5,
    DUPLICATE_ATTACHMENT = 6,
    ACCESS_DENIED = 7,
    CLOSED_UPDATE_NOT_ALLOWED = 8,
    INVALID_INPUT = 9,
    PROCESSING = 10,
    NAMINGERROR = 11,
    NAMINGNOTMATCH = 12
}

enum RemoveModeratorRequestStatus {
    SUCCESS = 0,
    LAST_MODERATOR = 1,
    FAILURE = 2,
}

enum AddDocumentRequestStatus {
    SUCCESS = 0,
    DUPLICATE = 1,
    FAILURE = 2,
    NAMINGERROR = 3,
    INVALID_INPUT = 4,
    NAMINGNOTMATCH = 5
}

exception SW360Exception {
    1: required string why,
    2: optional i32 errorCode,
}

enum ModerationState {
    PENDING = 0,
    APPROVED = 1,
    REJECTED = 2,
    INPROGRESS = 3,
}

enum ClearingRequestState {
    NEW = 0,
    ACCEPTED = 1,
    REJECTED = 2,
    IN_QUEUE = 3,
    IN_PROGRESS = 4,
    CLOSED = 5
}

enum Visibility {
    PRIVATE = 0,
    ME_AND_MODERATORS = 1,
    BUISNESSUNIT_AND_MODERATORS = 2,
    EVERYONE = 3
}

enum VerificationState {
    NOT_CHECKED = 0,
    CHECKED = 1,
    INCORRECT = 2,
}

enum ReleaseRelationship {
    CONTAINED = 0,
    REFERRED = 1,
    UNKNOWN = 2,
    DYNAMICALLY_LINKED = 3,
    STATICALLY_LINKED = 4,
    SIDE_BY_SIDE = 5,
    STANDALONE = 6,
    INTERNAL_USE = 7,
    OPTIONAL = 8,
    TO_BE_REPLACED = 9,
    CODE_SNIPPET = 10,
}

enum MainlineState {
    OPEN = 0,
    MAINLINE = 1,
    SPECIFIC = 2,
    PHASEOUT = 3,
    DENIED = 4,
}

enum ConfigFor {
    FOSSOLOGY_REST = 0,
}

enum ObligationStatus {
    OPEN = 0,
    FULFILLED = 1,
    IN_PROGRESS = 2,
    NOT_APPLICABLE = 3,
    TO_BE_FULFILLED_BY_PARENT_PROJECT = 4,
}

enum ClearingRequestEmailTemplate {
    NEW = 0,
    UPDATED = 1,
    PROJECT_UPDATED = 2,
}

struct ConfigContainer {
    1: optional string id,
    2: optional string revision,
    3: required ConfigFor configFor,
    4: required map<string, set<string>> configKeyToValues,
}

struct ProjectReleaseRelationship {
    1: required ReleaseRelationship releaseRelation,
    2: required MainlineState mainlineState,
}

struct VerificationStateInfo {
  1: required string checkedOn,
  2: required string checkedBy,
  3: optional string comment,
  4: required VerificationState verificationState,
}

struct DocumentState {
  1: required bool isOriginalDocument;
  2: optional ModerationState moderationState;
}

struct RequestSummary {
  1: required RequestStatus requestStatus;
  2: optional i32 totalAffectedElements;
  3: optional i32 totalElements;
  4: optional string message;
}

struct AddDocumentRequestSummary {
    1: optional AddDocumentRequestStatus requestStatus;
    2: optional string id;
    3: optional string message;
}

struct CustomProperties {
    1: optional string id,
    2: optional string revision,
    3: optional string type = "customproperties",
    4: optional string documentType,
    5: map<string, set<string>> propertyToValues;
}

struct RequestStatusWithBoolean {
  1: required RequestStatus requestStatus;
  2: optional bool answerPositive;
}

struct Comment {
    1: required string text,
    2: required string commentedBy,
    3: optional i64 commentedOn // timestamp of comment
}

/**
 * May be used to identify a source where the source can be of type project, component or release.
 * Using this type over a string allows the user to see which type of source the id is.
 */
union Source {
  1: string projectId
  2: string componentId
  3: string releaseId
}
