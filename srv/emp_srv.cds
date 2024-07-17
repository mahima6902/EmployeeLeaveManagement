using app.emp_leave as el from '../db/elm';

service EmployeeLeaveService {
  entity Employees      as projection on el.Employees;
  entity LeaveTypes     as projection on el.LeaveTypes;
  entity LeaveRequests  as projection on el.LeaveRequests;
  entity LeaveBalances  as projection on el.LeaveBalances;
  
  action submitLeaveRequest(employeeId: el.Employees:employeeid, leaveTypeid: el.LeaveTypes:leavetypeid, startDate: Date, endDate: Date, reason: String) returns LeaveRequests;
  action approveLeaveRequest(requestId: el.LeaveRequests:requestid, approverId: el.Employees:employeeid) returns LeaveRequests;
  action rejectLeaveRequest(requestId: el.LeaveRequests:requestid, approverId: el.Employees:employeeid) returns LeaveRequests;
  action initializeLeaveBalance(employeeId: el.Employees:employeeid, leaveTypeId: el.LeaveTypes:leavetypeid, totalDays: Integer) returns LeaveBalances;
}