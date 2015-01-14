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
	// Find out which departments they've selected.
	String[] selectedDepartments = request.getParameterValues("selectedDepartments");
	if(selectedDepartments == null)
	{ %>
		<div>
	  Please select at least one department.
		</div>
	<% }
	else
	{
		// Location of the next page.
		String destinationURL = PlugInUtil.getUri("octt", "usernamegetter", "links/getusernames.jsp");
		// Find out which term they've selected.
		String selectedTerm = request.getParameter("selectedTerm");
		// Make it human-readable.
		String readableSelectedTerm = (selectedTerm.substring(4).equals("09") ? "Fall of " : "Spring of ") + selectedTerm.substring(0, 4);
		// Create a list of all courses.
		List<Course> locatedCourses = new ArrayList<Course>();

		// Iterate over each department.
		for(String department : selectedDepartments)
		{
			// Find every course in the department.
			CourseSearch departmentSearch = new CourseSearch();
			departmentSearch.addParameter(new SearchParameter(SearchKey.CourseId, selectedTerm + "-" + department, SearchOperator.StartsWith));
			// Add those courses to the list.
			locatedCourses.addAll(CourseDbLoader.Default.getInstance().loadByCourseSearch(departmentSearch));
		}

		// Don't want to send them to a blank page; confusing.
		if(locatedCourses.isEmpty())
		{ %>
			<div>
			We can't find any courses for the department(s) and term you selected.
			</div>
		<% }
		else
		{ %>
		  <!-- Show them which term they selected, as well as which departments. -->
			<div>
			Term selected: <%=readableSelectedTerm%>
			<br>
			Departments selected:
			<%
			for(int i = 0; i < selectedDepartments.length - 1; i++)
			{ %>
				<%=selectedDepartments[i] + ", "%>
			<% }
			%>
			<%=selectedDepartments[selectedDepartments.length - 1]%>
			<br>
			<br>
			Please select one or more courses:
			<br>
			<br>
			</div>
			<form action="<%=destinationURL%>" method="GET">
				<%
				// Display all courses by their IDs and names (with the term and department stripped from the beginning), and allow user to select from them in a checkbox menu.
				for(Course course : locatedCourses)
				{ %>
					<input type="checkbox" name="selectedCourses" value="<%=course.getCourseId().substring(7)%>"> <%=course.getCourseId()%>: <%=course.getTitle().substring(7)%>
					<br>
				<% }
				%>
				<br>
				<input type="hidden" name="selectedTerm" value="<%=selectedTerm%>">
				<input type="submit" value="Submit">
			</form>
		<% }
	}
%>
</bbData:context>
</html>
