/*
 * Copyright Siemens AG, 2019. Part of the SW360 Portal Project.
 *
 * SPDX-License-Identifier: EPL-1.0
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 */
package org.eclipse.sw360.portal.tags;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.SimpleTagSupport;

import com.google.common.base.Strings;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.util.ResourceBundleUtil;

import org.apache.commons.lang.StringEscapeUtils;

import java.io.IOException;
import java.util.ResourceBundle;

public class Icon extends SimpleTagSupport {

    private String icon = "";
    private String title = "";
    private String className = "";
    
    public void setIcon(String icon) {
        this.icon = icon;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public void doTag() throws JspException, IOException {   
        
        PageContext pageContext = (PageContext) getJspContext();  
        HttpServletRequest request = (HttpServletRequest) pageContext.getRequest();   
        ResourceBundle resourceBundle = ResourceBundleUtil.getBundle("content.Language", request.getLocale(), getClass());
        String tag = "<svg class=\"lexicon-icon " + className + "\">";
        
        if(!Strings.isNullOrEmpty(title)) {
            tag += "<title>" + StringEscapeUtils.escapeHtml(LanguageUtil.get(resourceBundle, title)) + "</title>";
        }
        tag += "<use href=\"" + ((PageContext) getJspContext()).getServletContext().getContextPath() + "/images/icons.svg#" + icon + "\"/>";

        tag += "</svg>";
        getJspContext().getOut().print(tag);
    }
}
