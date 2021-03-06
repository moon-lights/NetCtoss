﻿<%@ page import="com.zwy.work.entity.Admin" %>
<%@ page import="java.util.List" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>达内－NetCTOSS</title>
    <link type="text/css" rel="stylesheet" media="all" href="styles/global.css"/>
    <link type="text/css" rel="stylesheet" media="all" href="styles/global_color.css"/>
    <script type="text/javascript" src="js/jquery-3.3.1.min.js"></script>
    <script language="javascript" type="text/javascript">
        //显示角色详细信息
        function showDetail(flag, a) {
            var detailDiv = a.parentNode.getElementsByTagName("div")[0];
            if (flag) {
                detailDiv.style.display = "block";
            }
            else
                detailDiv.style.display = "none";
        }

        //重置密码
        function resetPwd() {
            var hasSelectAdmin=false;
            $("input[name='selectAdminId']").each(function(){
                if($(this).is(":checked")){
                    hasSelectAdmin=true;
                    return false;
                }
            });
            if(!hasSelectAdmin){
                alert("请至少选择一条数据！");
                return false;
            }
            //document.getElementById("operate_result_info").style.display = "block";
            return true;
        }

        //删除
        function deleteAdmin(adminId) {
            var bool = window.confirm("确定要删除此管理员吗？");
            //document.getElementById("operate_result_info").style.display = "block";
            if(bool){
                location.href = "deleteAdmin.do?adminId=" + adminId;
            }
        }

        //全选
        function selectAdmins(inputObj) {
            var inputArray = document.getElementById("datalist").getElementsByTagName("input");
            for (var i = 1; i < inputArray.length; i++) {
                if (inputArray[i].type == "checkbox") {
                    inputArray[i].checked = inputObj.checked;
                }
            }
        }
        function searchAdmins() {
            location.href='searchAdmins.do?moduleName='+$("#selModules").val()+"&roleName="+$("#rolename_search").val();
        }
    </script>
</head>
<body>
<!--Logo区域开始-->
<div id="header">
    <%@ include file="../logo.jsp" %>
</div>
<!--Logo区域结束-->
<!--导航区域开始-->
<div id="navi">
    <%@ include file="../menu.jsp" %>
</div>
<!--导航区域结束-->
<!--主要区域开始-->
<div id="main">
    <form action="resetPwd.do" method="post" onsubmit="return resetPwd()">
        <!--查询-->
        <div class="search_add">
            <div>
                模块：
                <select id="selModules" class="select_search">
                    <option>全部</option>
                    <c:forEach items="${totalModules}" var="moduleItem">
                        <option ${moduleName==moduleItem.moduleName?'selected':''}>${moduleItem.moduleName}</option>
                    </c:forEach>
                </select>
            </div>
            <div>角色：<input type="text" value="${roleName}" class="text_search width200" id="rolename_search"/></div>
            <div><input type="button" value="搜索" class="btn_search" onclick="searchAdmins()"/></div>
            <input type="submit" value="密码重置" class="btn_add" />
            <input type="button" value="增加" class="btn_add" onclick="location.href='toAddAdmin.do';"/>
        </div>
        <!--删除和密码重置的操作提示-->
        <div id="operate_result_info" class="operate_fail">
            <img src="images/close.png" onclick="this.parentNode.style.display='none';"/>
            <span>删除失败！数据并发错误。</span><!--密码重置失败！数据并发错误。-->
        </div>
        <!--数据区域：用表格展示数据-->
        <div id="data">
            <table id="datalist">
                <tr>
                    <th class="th_select_all">
                        <input type="checkbox" onclick="selectAdmins(this);"/>
                        <span>全选</span>
                    </th>
                    <th>管理员ID</th>
                    <th>姓名</th>
                    <th>登录名</th>
                    <th>电话</th>
                    <th>电子邮件</th>
                    <th>授权日期</th>
                    <th class="width100">拥有角色</th>
                    <th></th>
                </tr>
                <%
                    List<Admin> admins = (List<Admin>) request.getAttribute("admins");
                    for (Admin admin : admins) {
                        StringBuilder rolesStr = new StringBuilder();
                        for (int i = 0; i < admin.getAdminRoles().size(); i++) {
                            if (i != 0) {
                                rolesStr.append("、");
                            }
                            rolesStr.append(admin.getAdminRoles().get(i).getRoleName());
                        }
                %>
                <tr>
                    <td><input type="checkbox" name="selectAdminId" value="<%=admin.getAdminId()%>"/></td>
                    <td><%=admin.getAdminId()%></td>
                    <td><%=admin.getAdminName()%></td>
                    <td><%=admin.getAdminCode()%></td>
                    <td><%=admin.getTelephone()%></td>
                    <td><%=admin.getEmail()%></td>
                    <td><%=admin.getEnrolldate()%></td>
                    <td>
                        <a class="summary" onmouseover="showDetail(<%=admin.getAdminRoles().size() > 1%>,this);" onmouseout="showDetail(false,this);">
                            <%=admin.getAdminRoles().size() > 0 ? admin.getAdminRoles().get(0).getRoleName() : ""%>
                            <%=admin.getAdminRoles().size() > 1 ? "..." : ""%>
                        </a>
                        <!--浮动的详细信息-->
                        <div class="detail_info">
                            <%=rolesStr%>
                        </div>
                    </td>
                    <td class="td_modi">
                        <input type="button" value="修改" class="btn_modify" onclick="location.href='toModifyAdmin.do?adminId='+<%=admin.getAdminId()%>"/>
                        <input type="button" value="删除" class="btn_delete" onclick="deleteAdmin(<%=admin.getAdminId()%>);"/>
                    </td>
                </tr>
                <%
                    }
                %>
            </table>
        </div>
        <!--分页-->
        <div id="pages">
            <c:if test="${currentPage>1}">
                <a href=${path}?currentPage=${currentPage-1}&moduleName=${moduleName}&roleName=${roleName}>上一页</a>
            </c:if>
            <c:forEach begin="1" end="${pageCount}" var="p">
                <c:choose>
                    <c:when test="${p==currentPage}">
                        <a href=${path}?currentPage=${p}&moduleName=${moduleName}&roleName=${roleName} class="current_page">${p}</a>
                    </c:when>
                    <c:otherwise>
                        <a href=${path}?currentPage=${p}&moduleName=${moduleName}&roleName=${roleName}>${p}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            <c:if test="${currentPage<pageCount}">
                <a href=${path}?currentPage=${currentPage+1}&moduleName=${moduleName}&roleName=${roleName}>下一页</a>
            </c:if>
        </div>
    </form>
</div>
<!--主要区域结束-->
<div id="footer">
    <p>[源自北美的技术，最优秀的师资，最真实的企业环境，最适用的实战项目]</p>
    <p>版权所有(C)加拿大达内IT培训集团公司 </p>
</div>
<script>
    if (${param.deleteSuccess==1}) {
        $("#operate_result_info").css("display","block");
        $("#operate_result_info").removeClass("operate_fail");
        $("#operate_result_info").addClass("operate_success");
        $("#operate_result_info").children("span").html("删除管理员成功");
    }
    if(${param.resetPwdSuccess==1}){
        $("#operate_result_info").css("display","block");
        $("#operate_result_info").removeClass("operate_fail");
        $("#operate_result_info").addClass("operate_success");
        $("#operate_result_info").children("span").html("重置密码成功，初始密码为123");
    }
</script>
</body>
</html>
