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
	String destinationURL = PlugInUtil.getUri("octt", "usernamegetter", "links/getusernames.jsp");
	// Find out what term they've selected.
	String[] selectedDepartments = request.getParameterValues("selectedDepartments");
	// Create a list of all courses.
	List<Course> locatedCourses = new ArrayList<Course>();

	// Iterate over each department.
	for(String department : selectedDepartments)
	{
		// Find every course in the department.
		CourseSearch departmentSearch = new CourseSearch();
		departmentSearch.addParameter(new SearchParameter(SearchKey.CourseId, department, SearchOperator.StartsWith));
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
	<div>
	Please select one or more courses:
	<br>
	<br>
	</div>
	<form action="<%=destinationURL%>" method="GET">
		<%
		// Display all courses by their IDs and names, and allow user to select from them.
		for(Course course : locatedCourses)
		{ %>
			<input type="checkbox" name="selectedCourses" value="<%=course.getCourseId()%>"> <%=course.getCourseId()%>: <%=course.getTitle().substring(7)%>
			<br>
		<% }
		%>
		<br>
		<input type="submit" value="Submit">
	</form>
	<% }
%>
</bbData:context>
</html>