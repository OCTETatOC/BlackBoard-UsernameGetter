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
<bbData:context id="userCtxAvail">

<%
	// Find out which courses they've selected.
	String[] courseIds = request.getParameterValues("selectedCourses");
	if(courseIds != null)
	{
		// Find out what term they've selected.
		String selectedTerm = request.getParameter("selectedTerm");

		// Set up persistence manager to get database loaders from.
		BbPersistenceManager bbPm = BbServiceManager.getPersistenceService().getDbPersistenceManager();
		// Get user database loader; used to find every student in a given course.
		UserDbLoader userLoader = (UserDbLoader)bbPm.getLoader(UserDbLoader.TYPE);
		// Get course database loader; used to find a course by courseID.
		CourseDbLoader courseLoader = (CourseDbLoader)bbPm.getLoader(CourseDbLoader.TYPE);
		// Get course membership database loader; used to separate students from TA's and staff.
		CourseMembershipDbLoader courseMembershipLoader = (CourseMembershipDbLoader)bbPm.getLoader(CourseMembershipDbLoader.TYPE);

		int records = 0;

		// Iterate over supplied courses.
		for(String courseId : courseIds)
		{
			Course course = courseLoader.loadByCourseId(selectedTerm + "-" + courseId);
			// Iterate over students in each course.
			for(User user : userLoader.loadByCourseId(course.getId()))
			{
				CourseMembership courseMembership = courseMembershipLoader.loadByCourseAndUserId(course.getId(), user.getId());
				// Make sure the user is a student.
				if(courseMembership.getRole() == CourseMembership.Role.STUDENT)
				{ %>
					<div>
						<%=user.getUserName()%>,
						<%=user.getBatchUid()%>,
						<%=user.getFamilyName()%>,
						<%=user.getGivenName()%>,
						,
						,
						,
						<%=course.getCourseId()%>,
						<%=user.getUserName()+"@oberlin.edu"%>
					</div>
				<%
				records++;
				}
			}
		} %>

		<%-- Display the total number of users, which also prevents blank pages if none are found. --%>
		<div>
		Total records: <%=records%>
		</div>

	<% }
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
