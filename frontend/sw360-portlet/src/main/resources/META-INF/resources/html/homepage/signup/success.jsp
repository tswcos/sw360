<%--
  ~ Copyright Siemens AG, 2013-2016, 2019. Part of the SW360 Portal Project.
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


<div class="jumbotron">
	<h1 class="display-4"><liferay-ui:message key="welcome.to.sw360" /></h1>
	<p class="lead">
		<liferay-ui:message key="sw360.is.an.open.source.software.project.that.provides.both.a.web.application.and.a.repository.to.collect.organize.and.make.available.information.about.software.components.it.establishes.a.central.hub.for.software.components.in.an.organization" />
	</p>
	<hr class="my-4">
	<div class="alert alert-success" role="alert">
		<liferay-ui:message key="your.account.has.been.created.but.it.is.still.inactive.an.administrator.will.review.it.and.activate.it" />
		<liferay-ui:message key="you.will.be.notified" />
	</div>
	<div class="buttons">
		<span class="sign-in"><a class="btn btn-primary btn-lg" href="${ themeDisplay.getURLSignIn() }" role="button"><liferay-ui:message key="sign.in" /></a></span>
	</div>
</div>
