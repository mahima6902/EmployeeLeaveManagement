namespace app.emp_leave;
using {cuid, managed} from '@sap/cds/common';


// Table - A  Employee_Details
entity Employees {
  @title : 'Employee ID'
  key employeeid : UUID;

  @title : 'First Name'
  firstname     : String;

  @title : 'Last Name'
  lastname      : String;

  @title : 'Email'
  email         : String;

  @title : 'Department'
  department    : String;

  @title : 'Position'
  position      : String;

  @title : 'Joining Date'
  joiningdate   : Date;

  @title : 'Leave Balance'
  leaveBalances : Composition of many LeaveBalances on leaveBalances.employee = $self;
}


// Table - B  Leave_Details
entity LeaveTypes {
  @title : 'Leave Type ID'
  key leavetypeid : UUID;

  @title : 'Name'
  name           : String;

  @title : 'Description'
  description    : String;

  @title : 'Days Allowed'
  daysallowed    : Integer;

  @title : 'Leave Balance'
  leaveBalances  : Composition of many LeaveBalances on leaveBalances.leavetype = $self;
}


// Table - C  Balance_Details
entity LeaveBalances {
  @title : 'ID'
  key id         : UUID;

  @title : 'Employee'
  employee       : Association to Employees;
 
  @title : 'Leave Type'
  leavetype      : Association to LeaveTypes;

  @title : 'Total Days'
  totaldays      : Integer;

  @title : 'Used Days'
  useddays       : Integer;

  @title : 'Remaining Days'
  remainingdays  : Integer;
}


// Table - D  Request_Details
entity LeaveRequests {
  @title : 'Request ID'
  key requestid   : UUID;

  @title : 'Employee'
  employee       : Association to Employees;

  @title : 'Leave Type'
  leavetype      : Association to LeaveTypes;

  @title : 'Start Date'
  startdate      : Date;

  @title : 'End Date'
  enddate        : Date;

  @title : 'Reason'
  reason         : String;

  @title : 'Status'
  status         : String enum {
    PENDING;
    APPROVED;
    REJECTED;
  };

  @title : 'Approver'
  approver       : Association to Employees;

  @title : 'Created At'
  createdat      : Date;

  @title : 'Updated At'
  updatedat      : Date;
}