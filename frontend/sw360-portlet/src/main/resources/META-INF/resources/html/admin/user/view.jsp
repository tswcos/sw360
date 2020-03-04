<%--
  ~ Copyright Siemens AG, 2013-2017, 2019. Part of the SW360 Portal Project.
  ~
  ~ SPDX-License-Identifier: EPL-1.0
  ~
  ~ All rights reserved. This program and the accompanying materials
  ~ are made available under the terms of the Eclipse Public License v1.0
  ~ which accompanies this distribution, and is available at
  ~ http://www.eclipse.org/legal/epl-v10.html
  --%>
<%@ page import="org.eclipse.sw360.portal.common.PortalConstants" %>

<%@ include file="/html/init.jsp" %>
<%-- the following is needed by liferay to display error messages--%>
<%@ include file="/html/utils/includes/errorKeyToMessage.jspf"%>

<portlet:defineObjects/>
<liferay-theme:defineObjects/>

<jsp:useBean id="userList" type="java.util.List<com.liferay.portal.kernel.model.User>" scope="request"/>
<jsp:useBean id="missingUserList" type="java.util.List<org.eclipse.sw360.datahandler.thrift.users.User>"
             scope="request"/>
<portlet:actionURL var="updateLifeRayUsers" name="updateUsers">
</portlet:actionURL>

<div class="container">
	<div class="row">
		<div class="col-3 sidebar">
			<div class="card-deck">
                <%@ include file="/html/utils/includes/quickfilter.jspf" %>
            </div>
		</div>
		<div class="col">
            <div class="row portlet-toolbar">
				<div class="col-auto">
					<div class="btn-toolbar" role="toolbar">
						<div class="btn-group" role="group">
							<button type="button" class="btn btn-primary"
                              onclick="window.location.href='<portlet:resourceURL><portlet:param name="<%=PortalConstants.ACTION%>" value='<%=PortalConstants.USER_LIST%>'/></portlet:resourceURL>'">
                                <liferay-ui:message key="download.liferay.users" />
                            </button>
						</div>
					</div>
				</div>
                <div class="col portlet-title text-truncate" title="<liferay-ui:message key="liferay.users" /> (${userList.size()})">
					<liferay-ui:message key="liferay.users" /> (${userList.size()})
				</div>
            </div>

            <div class="row">
                <div class="col">
                    <h4 class="mt-4"><liferay-ui:message key="users.already.in.liferay" /></h4>
			        <table id="userTable" class="table table-bordered">
                        <thead>
                            <tr>
                                <th><liferay-ui:message key="given.name" /></th>
                                <th><liferay-ui:message key="last.name" /></th>
                                <th><liferay-ui:message key="department" /></th>
                                <th><liferay-ui:message key="user.role" /></th>
                            </tr>
                        </thead>
                        <tbody>
                            <core_rt:forEach var="user" items="${userList}">
                                <tr>
                                    <td><sw360:out value="${user.firstName}"/></td>
                                    <td><sw360:out value="${user.lastName}"/></td>
                                    <td><sw360:out value="${user.getOrganizations(false).get(0).getName()}"/></td>
                                    <td>
                                        <core_rt:forEach var="role" items="${user.roles}" varStatus="loop">
                                            <sw360:out value="${role.getName()}"/>,
                                        </core_rt:forEach>
                                    </td>
                                </tr>
                            </core_rt:forEach>
                        </tbody>
                    </table>

                    <h4 class="mt-4"><liferay-ui:message key="users.not.in.liferay" /></h4>
                    <table id="userMissingTable" class="table table-bordered">
                        <thead>
                            <tr>
                                <th><liferay-ui:message key="given.name" /></th>
                                <th><liferay-ui:message key="last.name" /></th>
                            </tr>
                        </thead>
                        <tbody>
                            <core_rt:forEach var="user" items="${missingUserList}">
                                <tr>
                                    <td><sw360:out value="${user.givenname}"/></td>
                                    <td><sw360:out value="${user.lastname}"/></td>
                                </tr>
                            </core_rt:forEach>
                        </tbody>
                    </table>

                    <h4 class="mt-4"><liferay-ui:message key="upload.users" /></h4>
                    <form id="usersForm" class="form needs-validation" name="usersForm" action="<%=updateLifeRayUsers%>" method="POST" enctype="multipart/form-data" novalidate>
                        <div class="form-row">
                            <div class="col">
                                <div class="form-group">
                                    <input type="file" class="form-control-file" id="<portlet:namespace/>userFileUploadInput" name="<portlet:namespace/>file" required>
                                    <div class="invalid-feedback">
                                        <liferay-ui:message key="please.select.a.file" />
                                    </div>
                                </div>
                            </div>
                            <div class="col-2">
                                <button type="submit" class="btn btn-secondary btn-block" id="<portlet:namespace/>userCSV-Submit"><liferay-ui:message key="upload.users" /></button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
		</div>
	</div>
</div>

<%--for javascript library loading --%>
<%@ include file="/html/utils/includes/requirejs.jspf" %>
<script>
    AUI().use('liferay-portlet-url', function () {
        var PortletURL = Liferay.PortletURL;

        require(['jquery', 'bridges/datatables', 'utils/includes/quickfilter'], function($, datatables, quickfilter) {
            var usersTable,
                usersMissingTable;

            // initializing
            usersTable = createUserTable('#userTable');
            usersMissingTable = createUserTable('#userMissingTable');

            quickfilter.addTable(usersTable);
            quickfilter.addTable(usersMissingTable);

            // register event handlers
            $('#<portlet:namespace/>userFileUploadInput').on('change', function (event) {
                if ($(event.currentTarget).val()) {
                    $("#<portlet:namespace/>userCSV-Submit").prop('disabled', false);
                }
            });

            function createUserTable(tableSelector){
                return datatables.create(tableSelector, {
                    language: {
                        paginate: {
                            previous: "<liferay-ui:message key="previous" />",
                            next: "<liferay-ui:message key="next" />"
                        },
                        emptyTable: "<liferay-ui:message key="no.data.available.in.table" />",
                        info: "<liferay-ui:message key="showing" />",
                        infoEmpty: "<liferay-ui:message key="infoempty" />",
                        lengthMenu: '<liferay-ui:message key="show" /> <select>'+
                        '<option value="10">10</option>'+
                        '<option value="25">25</option>'+
                        '<option value="50">50</option>'+
                        '<option value="100">100</option>'+
                        '<option value="-1"><liferay-ui:message key="all" /></option>'+
                        '</select> <liferay-ui:message key="entries" />',
                        infoFiltered: "<liferay-ui:message key="filtered.from.max.total.entries" />",
                        zeroRecords: "<liferay-ui:message key="no.matching.records.found" />"
                    },
                    searching: true
                });
            }
        });
    });
</script>
