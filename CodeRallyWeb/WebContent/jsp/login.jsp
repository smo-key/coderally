<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page session="false" %>
<%@ page import="com.ibm.coderally.web.server.config.ConfigXml" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Code Rally Login</title>
		<link rel="stylesheet" type="text/css" href="style/login.css">
	</head>
	<body>
	<div id="container" class="container">
		<div id="top-banner">
		    <table border="0" cellspacing="0" cellpadding="0" id="banner-table">
				<tr>
					<td>
						<div id="banner-img">
							<img src="../Banner-leaderboard.jpg">
						</div>
					</td> 
				</tr>
		    </table>
		</div>
		
		<h1>Code Rally Login</h1>
		
		<%
		String x = request.getParameter("user");
		String y = request.getParameter("id");
		if(x != null && y != null){
			%>
			A response code has been sent.
			-201 indicates that the accounts has been created/ updated/ successfully logged into
			-403 indicated that the account name has already been taken
			<form action = "../LoginServlet?user=<%=x %>&id=<%=y %>" method = "POST" id = "info">
				<input type = "hidden" name = "user" id = "user" value = "<%=x %>" /> 
				<input type = "hidden" name = "id" id = "id" value = "<%=y %>" />
				<script>document.getElementById('info').submit();</script>
			</form>
			<%
		}else{%>
			
		<div id="button-holder">
		
			<form action = "../LoginServlet" method = "POST" >
			
<%

		String googleClientID = ConfigXml.getAttribute("GOOGLE_CLIENT_ID");
		String googleClientSecret = ConfigXml.getAttribute("GOOGLE_CLIENT_SECRET");
		String facebookID = ConfigXml.getAttribute("FACEBOOK_ID");
		String facebookSecret = ConfigXml.getAttribute("FACEBOOK_SECRET");
		String twitterID = ConfigXml.getAttribute("TWITTER_KEY");
		String twitterSecret = ConfigXml.getAttribute("TWITTER_SECRET");
		String weiboID = ConfigXml.getAttribute("WEIBO_KEY");
		String weiboSecret = ConfigXml.getAttribute("WEIBO_SECRET");
		String weiboRedirectURI = ConfigXml.getAttribute("WEIBO_REDIRECT_URI");

		if (googleClientID != null && googleClientSecret != null && (!googleClientID.trim().isEmpty() && !googleClientSecret.trim().isEmpty())){
			out.println("<button name=\"loginType\" type=\"submit\" value=\"google\">Login With Google</button>");
		}
		
		if (facebookID != null && facebookSecret != null && (!facebookID.trim().isEmpty() && !facebookSecret.trim().isEmpty())){
			out.println("<button name=\"loginType\" type=\"submit\" value=\"facebook\">Login With Facebook</button>");
		}	
		
		if (twitterID != null && twitterSecret != null && (!twitterID.trim().isEmpty() && !twitterSecret.trim().isEmpty())){
			out.println("<button name=\"loginType\" type=\"submit\" value=\"twitter\">Login With Twitter</button>");
		}
		
		if (weiboID != null && weiboSecret != null && weiboRedirectURI != null && (!weiboID.trim().isEmpty() && !weiboSecret.trim().isEmpty() && !weiboRedirectURI.trim().isEmpty())){
			out.println("<button name=\"loginType\" type=\"submit\" value=\"weibo\">Login With Weibo</button>");
		}
%>			
  				<%
  				String z = request.getParameter("user");
  				%>
  				<input type = "hidden" name = "user" id = "user" value = "<%=z %>" />

			</form>
		<%}%>
			
		</div>
		</div>
	</body>
</html>