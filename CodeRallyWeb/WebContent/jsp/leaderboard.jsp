<%@ page import="com.ibm.coderally.web.model.LeaderboardRow" %>
<%@ page import="com.ibm.coderally.web.service.Leaderboard" %>
<%@ page import="java.lang.Integer" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="UTF-8"%>
<%@ page session="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<!-- ---------------------------------------------------------------------------------- -->
<!-- 	For future benefits in understanding the code and debugging,                    -->
<!-- 	all the print statements are commented out instead of removing them totally     -->
<!-- ---------------------------------------------------------------------------------- -->

<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
		<title>Code Rally Leaderboard</title>
		<link rel="stylesheet" type="text/css" href='<%=Leaderboard.getCss()%>'>
	</head>
	<body>
		<div id="top-banner">
		    <table border="0" cellspacing="0" cellpadding="0" id="banner-table">
				<tr>
					<td>
						<div id="banner-img">
							<img src="Banner-leaderboard.jpg">
						</div>
					</td> 
				</tr>
		    </table>
		</div>
	
		<div id="container-outer">
			<div id="container-inner">
				<div id="search-box" align="right">
					<form action="Leaderboard" class="search-bar">
						<input type="text" name="user" id="search-box-text" value="Search for username"
							   onfocus="if(this.value == 'Search for username'){this.value = '';}"
							   onblur="if (this.value == '') {this.value = 'Search for username';}"> 
						<input type="hidden" name="css" value="<%=Leaderboard.getCss()%>">
						<input type="submit" id="search-box-go" value="Search">
					</form>
				</div> <br />
				<div id="leaderboard-view-toggle" align="right">
					<% 
						if (Leaderboard.getLeaderboardView().equals("fastestTime")){
						%>
							<button class="toggleView" 
								onClick="location.href = '/CodeRallyWeb/Leaderboard?view=avgPlace&css=<%=Leaderboard.getCss()%>';"> 
									Get Ranking by Average Place
							</button>
						<%			
						} else {
						%>	
							<button class="toggleView" 
								onClick="location.href = '/CodeRallyWeb/Leaderboard?view=fastestTime&css=<%=Leaderboard.getCss()%>';"> 
									Get Ranking by Fastest Time
							</button>
						<%		
						}
					%>
				</div>
				
				<h1>Code Rally Leaders</h1>
				
				<%
					if (Leaderboard.getLeaderboardView().equals("fastestTime")){
						%>
<%-- 						<br /> Track ID = <%=Leaderboard.getTrackId()%> <br /> --%>
						<div id="tracks-dropdown" align="right">
						<form>
							<input type="hidden" name="css" value="<%=Leaderboard.getCss()%>">
							<select class="trackName" name="track" onchange="this.form.submit()">
								<option title="AllTracks" value="AllTracks"
								<%
								if (Leaderboard.getTrackId()==-1) {
									%>	
									selected="selected"
									<%
								}
								%>								
								>All Tracks</option>
								<!-- Competition tracks -->
								<option title="Challenge Circuit" value="Challenge_Circuit"
								<%
								if (Leaderboard.getTrackId()==11) {
									%>	
									selected="selected"
									<%
								}
								%>
								>Challenge Circuit</option>
								<option title="Challenge Desk" value="Challenge_Desk"
								<%
								if (Leaderboard.getTrackId()==9) {
									%>	
									selected="selected"
									<%
								}
								%>
								>Challenge Desk</option>
								<option title="Challenge Figure 8" value="Challenge_Figure_8"
								<%
								if (Leaderboard.getTrackId()==6) {
									%>	
									selected="selected"
									<%
								}
								%>
								>Challenge Figure 8</option>
								<option title="Challenge Pond" value="Challenge_Pond"
								<%
								if (Leaderboard.getTrackId()==8) {
									%>	
									selected="selected"
									<%
								}
								%>
								>Challenge Pond</option>
								<option title="Challenge Sky" value="Challenge_Sky"
								<%
								if (Leaderboard.getTrackId()==7) {
									%>	
									selected="selected"
									<%
								}
								%>
								>Challenge Sky</option>								
								<option title="Challenge Space" value="Challenge_Space"
								<%
								if (Leaderboard.getTrackId()==10) {
									%>	
									selected="selected"
									<%
								}
								%>
								>Challenge Space</option>
								<!-- Non-competition tracks -->
								<option title="Circuit" value="Circuit"
								<%
								if (Leaderboard.getTrackId()==5) {
									%>	
									selected="selected"
									<%
								}
								%>
								>Circuit</option>
								<option title="Desk" value="Desk"
								<%
								if (Leaderboard.getTrackId()==3) {
									%>	
									selected="selected"
									<%
								}
								%>
								>Desk</option>
								<option title="Figure8" value="Figure8"
								<%
								if (Leaderboard.getTrackId()==0) {
									%>	
									selected="selected"
									<%
								}
								%>
								>Figure 8</option>
								<option title="Pond" value="Pond"
								<%
								if (Leaderboard.getTrackId()==2) {
									%>	
									selected="selected"
									<%
								}
								%>
								>Pond</option>
								<option title="Sky" value="Sky"
								<%
								if (Leaderboard.getTrackId()==1) {
									%>	
									selected="selected"
									<%
								}
								%>
								>Sky</option>
								<option title="Space" value="Space"
								<%
								if (Leaderboard.getTrackId()==4) {
									%>	
									selected="selected"
									<%
								}
								%>
								>Space</option>																
							</select>
						</form>
						</div>
						<br />
						<%
					}
				%>
				<br />
				<%
					if (Leaderboard.getCurrPageNumber() != 0) {
				%>
					<table id="main-table">
						<tr class="dark">
							
							<th>Rank</th>
							<th>Username</th>
							<th>Total Races</th>
						<%
							if (Leaderboard.getLeaderboardView().equals("fastestTime")){
							%>
								<th>Fastest Time</th>
							<%
							}	
							else {
							%>
								<th>Wins</th>
								<th>Average Place</th>							
							<%	
							}
						%>
							
						</tr>
						<%
							LeaderboardRow[] leaders = (LeaderboardRow[])request.getAttribute("leaders");
							int pg = Leaderboard.getCurrPageNumber();	
							int totalPages  = Leaderboard.getTotalPages();
							int rowsPerPage = Leaderboard.getRowsPerPage();
							int rowsPerPageBy2 = (int)Math.round(((double)rowsPerPage/2.0));
							if 		(pg < 1)  			pg = 1;
							else if (pg > totalPages) 	pg = totalPages;
							int rankStart = 0;
							if (Leaderboard.getStartFromRank() == 1){
								rankStart = rowsPerPage*(pg-1);
								if (Leaderboard.getRankExceptionHandler2() == 2){
									rankStart = 1;
									Leaderboard.setRankExceptionHandler2(0);
								}
							} else {
								rankStart = Leaderboard.getStartFromRank();
							}
							
							// see the rankExceptionHandler2 status inside JSP
// 							System.out.println("JSP : Leaderboard.getRankExceptionHandler2() = " 
// 									+ Leaderboard.getRankExceptionHandler2());
							
							if (Leaderboard.getRankExceptionHandler() == 1){
								rankStart = 1;
							}
							
							for(int i=0; i<leaders.length; i++) {
								String bg = (i%2 == 1 ? "dark" : "light");
								LeaderboardRow row = leaders[i];
							%>
								<tr class="
								<%
// 								System.out.println("JSP:\n row.getName() = " + row.getName() +
// 										"\nLeaderboard.getSearchedName() = " + Leaderboard.getSearchedName());
								if (row.getName().equalsIgnoreCase(Leaderboard.getSearchedName())){
									%>
									  searched
									<%
								}
								%>
								<%=bg%>">
									<td><%=rankStart + (i+1)%></td>
									<td><%=row.getName()%></td>
									<td><%=row.getTotalRaces()%></td>
								<%
									if (Leaderboard.getLeaderboardView().equals("fastestTime")){
										// for fastest time view
										String time = "";
										if (row.getFastestTime() == 5999990) {
											time = "Did not finish";
										} else {
											time = row.getFormatedTime(row.getFastestTime());
										}
									%>
										<td><%=time%></td>
									<%
									}	
									else {
									%>
										<td><%=row.getWins()%></td>
										<td><%=row.getAvgPlace()%></td>									
									<%	
									}
								%>
								</tr>
							<%
							}
							
							if (((pg == 1) || (pg == totalPages)) && 
								 (Leaderboard.getSearchFlag() == 0)) {
								Leaderboard.setStartFromRank(1);
							}
							Leaderboard.setRankExceptionHandler(0);
						%>
					</table>
					<div id="page-footer">
						<br /><br />
						<b>Page <%= Leaderboard.getCurrPageNumber() %> of <%= Leaderboard.getTotalPages() %></b>
						<br /><br />
						<div  id="navigation-bar">
						<%
							String prevButtonStatus = "";
							String nextButtonStatus = "";
							if (Leaderboard.getCurrPageNumber() == 1){
								prevButtonStatus = "disabled";
							}
							if (Leaderboard.getCurrPageNumber() == Leaderboard.getTotalPages()){
								nextButtonStatus = "disabled";
							}
						%>
							<button class="nav-button" <%=prevButtonStatus%> 
								onClick="location.href = '/CodeRallyWeb/Leaderboard?page=1&css=<%=Leaderboard.getCss()%>';"> 
								<< First 
							</button>
						<%
							int nextPageNum = pg + 1;
							int prevPageNum = pg - 1;
							
							// see the status of the Leaderboad class fields when it comes to the JSP page
// 							System.out.println("JSP: \n Leaderboard.getStartFromRank() : " + Leaderboard.getStartFromRank() +
// 													"\n Leaderboard.getSearchFlag() : " + Leaderboard.getSearchFlag() +
// 													"\n Leaderboard.getTotalPlayers() = " + Leaderboard.getTotalPlayers() +
// 													"\n Leaderboard.getRowsPerPage() = " + Leaderboard.getRowsPerPage() +
// 													"\n Leaderboard.getCurrPageNumber() = " + Leaderboard.getCurrPageNumber() +
// 							 						"\n Leaderboard.getTotalPages() = " + Leaderboard.getTotalPages());
						
							int calculatedTotalPage = Leaderboard.getTotalPages();
							try {
								calculatedTotalPage = (int)Math.ceil((double)Leaderboard.getTotalPlayers()/(double)Leaderboard.getRowsPerPage());
							} catch (ArithmeticException e){
							e.printStackTrace();
							}
							
							if (Leaderboard.getSearchFlag() == 1) {
								int prevPageStartFrom = Leaderboard.getStartFromRank() - Leaderboard.getRowsPerPage(); 
								int nextPageStartFrom = Leaderboard.getStartFromRank() + Leaderboard.getRowsPerPage();
								
								// when previous page goes bellow 1
								if (prevPageStartFrom < 1) {
									prevPageStartFrom = 1;
								}
								
								// when next page goes over total page
								if ((Leaderboard.getTotalPlayers()%rowsPerPage != 0) 
									&& (nextPageStartFrom >= ((int)(Leaderboard.getTotalPlayers()/rowsPerPage))*rowsPerPage)) {
									nextPageStartFrom = ((int)(Leaderboard.getTotalPlayers()/rowsPerPage))*rowsPerPage;
// 									System.out.println("JSP: INSIDE 2.1: HIT RIGHT BOUNDARY: Leaderboard.getTotalPages() = " + Leaderboard.getTotalPages());
								}
								
								if ((Leaderboard.getTotalPlayers()%rowsPerPage == 0) 
									&& (nextPageStartFrom >= ((int)(Leaderboard.getTotalPlayers()/rowsPerPage)-1)*rowsPerPage)) {
										nextPageStartFrom = ((int)(Leaderboard.getTotalPlayers()/rowsPerPage)-1)*rowsPerPage;
// 										System.out.println("JSP: INSIDE 2.2: HIT RIGHT BOUNDARY: Leaderboard.getTotalPages() = " + Leaderboard.getTotalPages());
									}
								%>
								<button class="nav-button" <%=prevButtonStatus%> 
								onClick="location.href = '/CodeRallyWeb/Leaderboard?startPageFrom=<%=Integer.toString(prevPageStartFrom)%>&css=<%=Leaderboard.getCss()%>';"> 
									 < Previous 
								</button>
								<button class="nav-button" <%=nextButtonStatus%> 
								onClick="location.href = '/CodeRallyWeb/Leaderboard?startPageFrom=<%=Integer.toString(nextPageStartFrom)%>&css=<%=Leaderboard.getCss()%>';"> 
									Next >
								</button>
								<%
								
								// see status of nextPageStartFrom and prevPageStartFrom
// 								System.out.println("JSP: \n  nextPageStartFrom = " + nextPageStartFrom +
// 														"\n  prevPageStartFrom = " + prevPageStartFrom);
							}
							else {
// 								System.out.println("Generating NEXT & PREV NO search performed");
								%>
								<button class="nav-button" <%=prevButtonStatus%> 
								onClick="location.href = '/CodeRallyWeb/Leaderboard?page=<%=Integer.toString(prevPageNum)%>&css=<%=Leaderboard.getCss()%>';"> 
									 < Previous 
								</button>
								<button class="nav-button" <%=nextButtonStatus%> 
								onClick="location.href = '/CodeRallyWeb/Leaderboard?page=<%=Integer.toString(nextPageNum)%>&css=<%=Leaderboard.getCss()%>';"> 
									Next >
								</button>
								<%
							} 
							%>
							<button class="nav-button" <%=nextButtonStatus%> 
							onClick="location.href = '/CodeRallyWeb/Leaderboard?page=<%=Integer.toString(calculatedTotalPage)%>&css=<%=Leaderboard.getCss()%>';"> 
								Last >> 
							</button>
					<%
					}
					else {
						%>
						Sorry! No races could be found for that Username. Make sure the Username is spelled correctly and has run at least one race. <br />
						Note: Usernames are NOT case sensitive.
						<br /> <br /> <br />
						<button class="nav-button" onClick="location.href = '/CodeRallyWeb/Leaderboard?page=1&css=<%=Leaderboard.getCss()%>';"> 
							Go to Page 1 
						</button>
						<%
					}
					%>
					</div>
					<br />
				</div>
				<br />
			</div>
		</div>
	</body>
</html>