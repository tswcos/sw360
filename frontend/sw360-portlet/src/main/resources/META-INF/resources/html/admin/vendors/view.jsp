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
<%@ page import="javax.portlet.PortletRequest" %>
<%@ page import="com.liferay.portal.kernel.portlet.PortletURLFactoryUtil" %>

<%@ include file="/html/init.jsp" %>
<%-- the following is needed by liferay to display error messages--%>
<%@ include file="/html/utils/includes/errorKeyToMessage.jspf"%>

<portlet:defineObjects/>
<liferay-theme:defineObjects/>

<portlet:resourceURL var="exportVendorsURL">
    <portlet:param name="<%=PortalConstants.ACTION%>" value="<%=PortalConstants.EXPORT_TO_EXCEL%>"/>
</portlet:resourceURL>

<portlet:resourceURL var="deleteAjaxURL">
    <portlet:param name="<%=PortalConstants.ACTION%>" value='<%=PortalConstants.REMOVE_VENDOR%>'/>
</portlet:resourceURL>

<portlet:renderURL var="addVendorURL">
    <portlet:param name="<%=PortalConstants.PAGENAME%>" value="<%=PortalConstants.PAGENAME_EDIT%>" />
</portlet:renderURL>

<jsp:useBean id="vendorList" type="java.util.List<org.eclipse.sw360.datahandler.thrift.vendors.Vendor>"  scope="request"/>

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
							<button type="button" class="btn btn-primary" onclick="window.location.href='<%=addVendorURL%>'"><liferay-ui:message key="add.vendor" /></button>
						</div>
						<div class="btn-group" role="group">
							<button type="button" class="btn btn-secondary" onclick="window.location.href='<%=exportVendorsURL%>'"><liferay-ui:message key="export.spreadsheet" /></button>
						</div>
					</div>
				</div>
                <div class="col portlet-title text-truncate" title="<liferay-ui:message key="vendors" /> (${vendorList.size()})">
					<liferay-ui:message key="vendors" /> (<span id="vendorCounter">${vendorList.size()}</span>)
				</div>
            </div>

            <div class="row">
                <div class="col">
			        <table id="vendorsTable" class="table table-bordered"></table>
                </div>
            </div>

		</div>
	</div>
</div>

<div class="dialogs auto-dialogs"></div>

<%--for javascript library loading --%>
<%@ include file="/html/utils/includes/requirejs.jspf" %>
<script>
    AUI().use('liferay-portlet-url', function () {
        var PortletURL = Liferay.PortletURL;

        require(['jquery', 'bridges/datatables', 'modules/dialog', 'utils/includes/quickfilter' ], function($, datatables, dialog, quickfilter) {
            var vendorsTable,
                vendorIdInURL = '<%=PortalConstants.VENDOR_ID%>',
                pageName = '<%=PortalConstants.PAGENAME%>';
                pageEdit = '<%=PortalConstants.PAGENAME_EDIT%>';
                pageMerge = '<%=PortalConstants.PAGENAME_MERGE_VENDOR%>';
                baseUrl = '<%= PortletURLFactoryUtil.create(request, portletDisplay.getId(), themeDisplay.getPlid(), PortletRequest.RENDER_PHASE) %>';

            // initializing
            vendorsTable = createVendorsTable();
            quickfilter.addTable(vendorsTable);

            // register event handlers
            $('#vendorsTable').on('click', 'svg.delete', function (event) {
                var data = $(event.currentTarget).data();
                deleteVendor(data.vendorId, data.vendorName);
            });
            $('#vendorsTable').on('click', 'svg.edit', function (event) {
                var data = $(event.currentTarget).data();
                window.location.href = createDetailURLfromVendorId(data.vendorId);
            });
            $('#vendorsTable').on('click', 'svg.merge', function (event) {
                var data = $(event.currentTarget).data();
                window.location.href = createMergeURLfromVendorId(data.vendorId);
            });

            // helper functions
            function createDetailURLfromVendorId (paramVal) {
                var portletURL = PortletURL.createURL( baseUrl ).setParameter(pageName, pageEdit).setParameter(vendorIdInURL, paramVal);
                return portletURL.toString();
            }

            function createMergeURLfromVendorId (paramVal) {
                var portletURL = PortletURL.createURL( baseUrl ).setParameter(pageName, pageMerge).setParameter(vendorIdInURL, paramVal);
                return portletURL.toString();
            }

            // catch ctrl+p and print dataTable
            $(document).on('keydown', function(e){
                if(e.ctrlKey && e.which === 80){
                    e.preventDefault();
                    vendorsTable.buttons('.custom-print-button').trigger();
                }
            });

            function createVendorsTable() {
                var vendorsTable,
                    result = [];

                <core_rt:forEach items="${vendorList}" var="vendor">
                    result.push({
                        "DT_RowId": "${vendor.id}",
                        "0": "<a href='" + createDetailURLfromVendorId('${vendor.id}') + "' target='_self'><sw360:out value="${vendor.fullname}"/></a>",
                        "1": "<sw360:out value="${vendor.shortname}"/>",
                        "2": "<sw360:out value="${vendor.url}"/>",
                        "3":  '<div class="actions">'
                            +   '<svg class="edit lexicon-icon" data-vendor-id="${vendor.id}"><title><liferay-ui:message key="edit" /></title><use href="/o/org.eclipse.sw360.liferay-theme/images/clay/icons.svg#pencil"/></svg>'
                            +   '<svg class="merge lexicon-icon" data-vendor-id="${vendor.id}"><title><liferay-ui:message key="merge" /></title><use href="/o/org.eclipse.sw360.liferay-theme/images/clay/icons.svg#merge"/></svg>'
                            +   '<svg class="delete lexicon-icon" data-vendor-id="${vendor.id}" data-vendor-name="<sw360:out value="${vendor.fullname}"/>"><title><liferay-ui:message key="delete" /></title><use href="/o/org.eclipse.sw360.liferay-theme/images/clay/icons.svg#trash"/></svg>'
                            + '</div>'

                    });
                </core_rt:forEach>

                vendorsTable = datatables.create('#vendorsTable', {
                    data: result,
                    columns: [
                        {"title": "<liferay-ui:message key="full.name" />"},
                        {"title": "<liferay-ui:message key="short.name" />"},
                        {"title": "<liferay-ui:message key="url" />"},
                        {"title": "<liferay-ui:message key="actions" />", className: "three actions" }
                    ],
                    searching: true,
                    language: {
                        paginate: {
                            previous: "<liferay-ui:message key="previous" />",
                            next: "<liferay-ui:message key="next" />"
                        },
                        emptyTable: "<liferay-ui:message key="no.vendors.found" />",
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
                }, [0, 1, 2], [3]);

                return vendorsTable;
            }

            function deleteVendor(id, name) {
                var $dialog;

                function deleteVendorInternal(callback) {
                    jQuery.ajax({
                        type: 'POST',
                        url: '<%=deleteAjaxURL%>',
                        cache: false,
                        data: {
                            <portlet:namespace/>vendorId: id
                        },
                        success: function (data) {
                            callback();

                            if(data.result == 'SUCCESS') {
                                vendorsTable.row('#' + id).remove().draw(false);
                                $('#vendorCounter').text(parseInt($('#vendorCounter').text()) - 1);
                                $('#vendorCounter').parent().attr('title', $('#vendorCounter').parent().text());
                                $dialog.close();
                            } else {
                                $dialog.alert("<liferay-ui:message key="i.could.not.delete.the.vendor" />");
                            }
                        },
                        error: function () {
                            callback();
                            $dialog.alert("<liferay-ui:message key="i.could.not.delete.the.vendor" />");
                        }
                    });
                }

                $dialog = dialog.confirm(
                    'danger',
                    'question-circle',
                    '<liferay-ui:message key="delete.vendor" /> ?',
                    '<p><liferay-ui:message key="do.you.really.want.to.delete.the.vendor.x" />?</p>',
                    '<liferay-ui:message key="delete.vendor" />',
                    {
                        name: name,
                    },
                    function(submit, callback) {
                        deleteVendorInternal(callback);
                    }
                );
            }
        });
    });
</script>
