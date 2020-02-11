<%--
  ~ Copyright Siemens AG, 2013-2017, 2019. Part of the SW360 Portal Project.
  ~ With contributions by Siemens Healthcare Diagnostics Inc, 2018.
  ~
  ~ SPDX-License-Identifier: EPL-1.0
  ~
  ~ All rights reserved. This program and the accompanying materials
  ~ are made available under the terms of the Eclipse Public License v1.0
  ~ which accompanies this distribution, and is available at
  ~ http://www.eclipse.org/legal/epl-v10.html
  --%>

<%@include file="/html/init.jsp" %>

<portlet:defineObjects/>
<liferay-theme:defineObjects/>

<%@ page import="org.eclipse.sw360.portal.common.PortalConstants" %>

<portlet:resourceURL var="loadProjectsURL">
    <portlet:param name="<%=PortalConstants.ACTION%>" value='<%=PortalConstants.LOAD_PROJECT_LIST%>'/>
</portlet:resourceURL>

<section id="my-projects">
    <h4 class="actions"><liferay-ui:message key="my.projects" /> <span title="<liferay-ui:message key="reload" />"><clay:icon symbol="reload"/></span></h4>
    <div class="row">
        <div class="col">
            <table id="myProjectsTable" class="table table-bordered table-lowspace" data-load-url="<%=loadProjectsURL%>">
                <colgroup>
                    <col style="width: 40%;"/>
                    <col style="width: 30%;"/>
                    <col style="width: 30%;"/>
                </colgroup>
            </table>
        </div>
    </div>
</section>

<%@ include file="/html/utils/includes/requirejs.jspf" %>
<script>
    require(['jquery', 'bridges/datatables', 'utils/link' ], function($, datatables, link, event) {
        var table;
        $('#my-projects h4 svg')
            .attr('data-action', 'reload-my-projects')
            .addClass('spinning disabled');

        $('#my-projects').on('click', 'svg[data-action="reload-my-projects"]:not(.disabled)', reloadTable);

        $(document).off('pageshow.my-projects');
        $(document).on('pageshow.my-projects', function() {
            reloadTable();
        });

        table = datatables.create('#myProjectsTable', {
            // the following parameter must not be removed, otherwise it won't work anymore (probably due to datatable plugins)
            bServerSide: false,
            // the following parameter must not be converted to 'ajax', otherwise it won't work anymore (probably due to datatable plugins)
            sAjaxSource: $('#myProjectsTable').data().loadUrl,

            dom:
				"<'row'<'col-sm-12'tr>>" +
				"<'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>",
            columns: [
                {"title": "<liferay-ui:message key="project.name" />", data: 'name', render: renderProjectNameLink },
                {"title": "<liferay-ui:message key="description" />", data: 'description', render: $.fn.dataTable.render.ellipsis },
                {"title": "<liferay-ui:message key="approved.releases" />", data: 'releaseClearingState', render: renderReleaseClearingState},
            ],
            language: {
				paginate: {
                  previous: "<liferay-ui:message key="previous" />",
                  next: "<liferay-ui:message key="next" />"
                },
                emptyTable: '<liferay-ui:message key="you.do.not.own.any.projects" />',
				info: "<liferay-ui:message key="showing" />",
				infoEmpty: "<liferay-ui:message key="infoempty" />"
            },
            initComplete: function() {
                $('#my-projects h4 svg').removeClass('spinning disabled');
            }
        });

        function renderProjectNameLink(name, type, row) {
            return $('<a/>', {
                'class': 'text-truncate',
                title: name,
                href: link.to('project', 'show', row.id)
            }).text(name)[0].outerHTML;
        }

        function renderReleaseClearingState(state) {
            return $('<span/>', {
                title: '<liferay-ui:message key="approved.releases.total.number.of.releases" />'
            }).text(state)[0].outerHTML;
        }

        function reloadTable() {
            $('#my-projects h4 svg').addClass('spinning disabled');
            table.ajax.reload(function() {
                $('#my-projects h4 svg').removeClass('spinning disabled');
            }, false );
        }
    });
</script>
