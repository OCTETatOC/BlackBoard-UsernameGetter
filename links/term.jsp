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
<%@ page import="blackboard.platform.plugin.PlugInUtil"%>

<bbData:context id="userCtxAvail">
<%
  // Location of the next page.
  String destinationURL = PlugInUtil.getUri("octt", "usernamegetter", "links/departments.jsp");
  // Find the current date (year and month).
  Calendar calendar = Calendar.getInstance();
  int year = calendar.get(Calendar.YEAR);
  // Assume the 'current' term is fall if the month is July or later, spring if before July.
  String semester = calendar.get(Calendar.MONTH) <= 6 ? "02" : "09";
  // <term>TermValue is the actual value provided in the query to the next jsp page if the user selects <term>.
  String currentTermValue = Integer.toString(year) + semester;
  // <term>TermString is the option displayed to the user in the dropdown menu.
  String currentTermString = (semester == "02" ? "Spring " : "Fall ") + Integer.toString(year);
  String previousTermValue, previousTermString, nextTermValue, nextTermString;
  if(semester == "02")
  {
	previousTermValue = Integer.toString(year - 1) + "09";
	previousTermString = "Fall " + Integer.toString(year - 1);
	nextTermValue = Integer.toString(year) + "09";
	nextTermString = "Fall " + Integer.toString(year);
  }
  else
  {
	previousTermValue = Integer.toString(year) + "02";
	previousTermString = "Spring " + Integer.toString(year);
	nextTermValue = Integer.toString(year + 1) + "02";
	nextTermString = "Spring " + Integer.toString(year + 1);
  }
%>
  <!-- Dropdown menu for selecting the term to view courses for; default is the supposedly current term -->
  <div style="text-align:center;">
  <br>
  Please select a term:
  <br>
  <form action="<%=destinationURL%>" method="GET">
    <select name="selectedTerm">
      <option value="<%=previousTermValue%>"><%=previousTermString%></option>
      <option selected value="<%=currentTermValue%>"><%=currentTermString%></option>
      <option value="<%=nextTermValue%>"><%=nextTermString%></option>
    </select>
	<input type="submit" value="Submit">
  </form>
  <br>
  </div>
</bbData:context>
</html>
