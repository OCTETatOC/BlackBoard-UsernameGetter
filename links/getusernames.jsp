<html>
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
<%@ page import="blackboard.platform.plugin.PlugInUtil"%>

<body>
<bbData:context id="userCtxAvail" >

<%
	// Find out which courses they've selected.
	String[] courseIds = request.getParameterValues("selectedCourses");
	if(courseIds != null)
	{
		// Find out what term they've selected.
		String selectedTerm = request.getParameter("selectedTerm");
		// Want non-duplicate, alphabetized list of every student registered for at least one of the given courses. TreeSet is ideal for this.
		Set<String> users = new TreeSet<String>();

		// Set up database loaders.
		BbPersistenceManager bbPm = BbServiceManager.getPersistenceService().getDbPersistenceManager();
		UserDbLoader userLoader = (UserDbLoader) bbPm.getLoader(UserDbLoader.TYPE);
		CourseDbLoader courseLoader = CourseDbLoader.Default.getInstance();

		// Iterate over supplied courses.
		for(String courseId : courseIds)
		{
			Course course = courseLoader.loadByCourseId(selectedTerm + "-" + courseId);
			// Iterate over students in each course.
			for(User user : userLoader.loadByCourseId(course.getId()))
			{
				// Add each user to the TreeSet.
				users.add(user.getUserName());
			}
		}
		if(!users.isEmpty())
		{
			// Display each user.
			for(String userName : users)
			{ %>
				<div>
				<%=userName%>
				</div>
			<% }
		}
		else
		// Don't want to send them to a blank page; confusing.
		{ %>
			<div>
			There are no students currently registered for the selected course(s).
			</div>
		<% }
	}
	else
	// Don't want to send them to a blank page; confusing.
	{ %>
		<div>
		Please select at least one course.
		</div>
	<% }
%>

</bbData:context>
</div>
</body>
</html>
