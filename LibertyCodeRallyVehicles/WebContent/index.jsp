<%@page import="com.ibm.coderally.autonomous.AutonomousRequestHandler"%>
<%@page import="com.ibm.coderally.autonomous.JSPUtil"%>
<%@page import="java.util.List"%>
<%@page import="com.ibm.coderally.autonomous.DBFactory"%>
<%@page import="com.ibm.coderally.autonomous.PersistentDBConnection2"%>
<%@page import="com.ibm.coderally.autonomous.PersistentDBConnection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Code Rally Cloud Racer</title>

<style>
.CSSTableGenerator {
	margin: 0px;
	padding: 0px;
	width: 100%;
	box-shadow: 10px 10px 5px #888888;
	border: 1px solid #000000;
	-moz-border-radius-bottomleft: 0px;
	-webkit-border-bottom-left-radius: 0px;
	border-bottom-left-radius: 0px;
	-moz-border-radius-bottomright: 0px;
	-webkit-border-bottom-right-radius: 0px;
	border-bottom-right-radius: 0px;
	-moz-border-radius-topright: 0px;
	-webkit-border-top-right-radius: 0px;
	border-top-right-radius: 0px;
	-moz-border-radius-topleft: 0px;
	-webkit-border-top-left-radius: 0px;
	border-top-left-radius: 0px;
}

.CSSTableGenerator table {
	border-collapse: collapse;
	border-spacing: 0;
	width: 100%;
	height: 100%;
	margin: 0px;
	padding: 0px;
}

.CSSTableGenerator tr:last-child td:last-child {
	-moz-border-radius-bottomright: 0px;
	-webkit-border-bottom-right-radius: 0px;
	border-bottom-right-radius: 0px;
}

.CSSTableGenerator table tr:first-child td:first-child {
	-moz-border-radius-topleft: 0px;
	-webkit-border-top-left-radius: 0px;
	border-top-left-radius: 0px;
}

.CSSTableGenerator table tr:first-child td:last-child {
	-moz-border-radius-topright: 0px;
	-webkit-border-top-right-radius: 0px;
	border-top-right-radius: 0px;
}

.CSSTableGenerator tr:last-child td:first-child {
	-moz-border-radius-bottomleft: 0px;
	-webkit-border-bottom-left-radius: 0px;
	border-bottom-left-radius: 0px;
}

.CSSTableGenerator tr:hover td {
	
}

.CSSTableGenerator tr:nth-child(odd) {
	background-color: #efe2ff;
}

.CSSTableGenerator tr:nth-child(even) {
	background-color: #ffffff;
}

.CSSTableGenerator td {
	vertical-align: middle;
	border: 1px solid #000000;
	border-width: 0px 1px 1px 0px;
	text-align: left;
	padding: 7px;
	font-size: 10px;
	font-family: Arial;
	font-weight: bold;
	color: #000000;
}

.CSSTableGenerator tr:last-child td {
	border-width: 0px 1px 0px 0px;
}

.CSSTableGenerator tr td:last-child {
	border-width: 0px 0px 1px 0px;
}

.CSSTableGenerator tr:last-child td:last-child {
	border-width: 0px 0px 0px 0px;
}

.CSSTableGenerator tr:first-child td {
	background: -o-linear-gradient(bottom, #7700ff 5%, #4b09bc 100%);
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.05, #7700ff
		), color-stop(1, #4b09bc));
	background: -moz-linear-gradient(center top, #7700ff 5%, #4b09bc 100%);
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr="#7700ff",
		endColorstr="#4b09bc");
	background: -o-linear-gradient(top, #7700ff, 4b09bc);
	background-color: #7700ff;
	border: 0px solid #000000;
	text-align: center;
	border-width: 0px 0px 1px 1px;
	font-size: 14px;
	font-family: Arial;
	font-weight: bold;
	color: #ffffff;
}

.CSSTableGenerator tr:first-child:hover td {
	background: -o-linear-gradient(bottom, #7700ff 5%, #4b09bc 100%);
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.05, #7700ff
		), color-stop(1, #4b09bc));
	background: -moz-linear-gradient(center top, #7700ff 5%, #4b09bc 100%);
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr="#7700ff",
		endColorstr="#4b09bc");
	background: -o-linear-gradient(top, #7700ff, 4b09bc);
	background-color: #7700ff;
}

.CSSTableGenerator tr:first-child td:first-child {
	border-width: 0px 0px 1px 0px;
}

.CSSTableGenerator tr:first-child td:last-child {
	border-width: 0px 0px 1px 1px;
}
</style>

</head>


<body>

<img src="img/Code_Rally_Banner.png"/><br/>
<br/>

<table width="700" border="0"><tr><td>

	<div class="CSSTableGenerator">

		<table>

			<tr>
				<td>Server</td>
				<td>Race ID</td>
				<td>Car</td>
				<td>Status</td>
				<td>Track</td>
				<td>Race Time</td>
				<td>Result</td>
			</tr>

			<%
			
				AutonomousRequestHandler.getInstance().refreshDatabaseIfNeeded(null);
			
				PersistentDBConnection2 conn = DBFactory.getInstance().createConnection();

				List<PersistentDBConnection.PersistentRaceInfo> list = conn.getFromTable(null, null);

				list = JSPUtil.sortTableForJsp(list);

				for (PersistentDBConnection.PersistentRaceInfo pri : list) {
			%>


			<tr>
				<td><%=pri.getServerUrl()%></td>
				<td><%=pri.getRaceId()%></td>
				<td><%=pri.getAgentName() %></td>
				<td><%=JSPUtil.getStatusText(pri.getStatus())%></td>
				<td><%= pri.getTrack() %></td>
				<td><%=JSPUtil.convertMillsecondsToMinutesAndSeconds(pri.getRaceTime())%></td>
				<td><%=JSPUtil.getPlaceText(pri.getStatus(), pri.getPlace())%></td>
			</tr>

			<%
				}
			%>

		</table>

	</div>
	
	</td>
	</tr>
	</table>
	
	<br/>
	<br/>
</body>
</html>