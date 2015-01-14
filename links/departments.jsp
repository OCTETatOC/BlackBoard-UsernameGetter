<html lang="en">
<%@ page import="java.util.*,
				java.lang.Integer,
				blackboard.base.*,
				blackboard.data.*,
                blackboard.data.user.*,
				blackboard.data.course.*,
                blackboard.persist.*,
                blackboard.persist.user.*,
				blackboard.persist.course.*,
                blackboard.platform.*,
                blackboard.platform.persistence.*,
				blackboard.portal.external.*,
				blackboard.platform.session.*,
				java.text.SimpleDateFormat"
%>
<%@ taglib uri="/bbData" prefix="bbData"%>
<%@ taglib uri="/bbUI" prefix="bbUI"%>
<%@ page import="blackboard.platform.plugin.PlugInUtil,
				blackboard.persist.course.CourseSearch.*"
%>

<bbData:context id="userCtxAvail">
<%
	// Location of the next page.
	String destinationURL = PlugInUtil.getUri("octt", "usernamegetter", "links/coursenames.jsp");
	// Find out what term they've selected.
	String selectedTerm = request.getParameter("selectedTerm");
	// Make it human-readable.
	String readableSelectedTerm = (selectedTerm.substring(4).equals("09") ? "Fall of " : "Spring of ") + selectedTerm.substring(0, 4);
	// Create a set of all possible department codes.
	Set<String> departments = new TreeSet<String>();

	// Iterate over every course in the selected term.
	CourseSearch termSearch = new CourseSearch();
	termSearch.addParameter(new SearchParameter(SearchKey.CourseId, selectedTerm, SearchOperator.StartsWith));
	for(Course course : CourseDbLoader.Default.getInstance().loadByCourseSearch(termSearch))
	{
		departments.add(course.getCourseId().substring(7, 11));
	}

	// Don't want to send them to a blank page; confusing.
	if(departments.isEmpty())
	{ %>
		<div>
		We can't find any courses in the term you selected.
		</div>
	<% }
	else
	{ %>
		<!-- Show they which term they've selected. -->
		<div>
		Term selected: <%=readableSelectedTerm%>
		<br>
		<br>
		Please select one or more departments:
		<br>
		<br>
		</div>
		<form action="<%=destinationURL%>" method="GET">
			<%
			// Display all departments by their four-letter identifiers, and allow user to select from them in a checkbox menu.
			for(String department : departments)
			{ %>
				<input type="checkbox" name="selectedDepartments" value="<%=department%>"> <%=department%>
				<br>
			<% }
			%>
			<br>
			<input type="hidden" name="selectedTerm" value="<%=selectedTerm%>">
			<input type="submit" value="Submit">
		</form>
	<% }
%>
</bbData:context>
</html>
