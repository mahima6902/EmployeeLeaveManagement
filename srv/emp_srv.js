const cds = require('@sap/cds');

module.exports = cds.service.impl(async function() {
  const { Employees, LeaveTypes, LeaveRequests, LeaveBalances } = this.entities;

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////SUBMIT LEAVE REQUEST
///////////////////////////////////////////////////////////////////////////////////////////////////

  this.on('submitLeaveRequest', async (req) => {
    const { employeeid, leavetypeid, startdate, enddate, reason } = req.data;
    
    // Validation of employee
    const employee = await SELECT.from(Employees).where({ employeeId: employeeid });
    if (!employee.length) {
      req.error(404, `Employee with ID ${employeeid} not found`);
    }

    // Validation of leave type
    const leavetype = await SELECT.from(LeaveTypes).where({ leaveTypeId: leavetypeid });
    if (!leavetype.length) {
      req.error(404, `Leave type with ID ${leavetypeid} not found`);
    }

    // Number of days
    const start = new Date(startdate);
    const end = new Date(enddate);
    const days = Math.ceil((end - start) / (1000 * 60 * 60 * 24)) + 1;

    // Validation of leave balance
    const leavebalance = await SELECT.from(LeaveBalances)
      .where({ employeeId: employeeid, leaveTypeId: leavetypeid });

    if (leavebalance.length === 0) {
        req.error(404, `Leave balance not found for employee ${employeeid} and leave type ${leavetypeid}`);
    }
    
    if (leavebalance[0].remainingdays < days) {
      req.error(404, `Insufficient leave balance. Available: ${leavebalance[0].remainingdays}, Requested: ${days}`);
    }

    // Creating leave request
    const leaverequest = await INSERT.into(LeaveRequests).entries({
      employee_employeeid: employeeid,
      leaveType_leavetypeid: leavetypeid,
      startdate: startdate,
      enddate: enddate,
      reason: reason,
      status: 'PENDING',
      createdat: new Date().toISOString(),
      updatedat: new Date().toISOString()
    });

    // Updating leave balance
    await UPDATE(LeaveBalances)
      .set({  useddays: { '+=': days },
      remainingdays: { '-=': days } })
      .where({ employeeId: employeeid, leaveTypeId: leavetypeid });

    return leaverequest;
  });

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////START LEAVE BALANCE
///////////////////////////////////////////////////////////////////////////////////////////////////
  
    this.on('initializeLeaveBalance', async (req) => {
    const { employeeid, leavetypeid, totaldays } = req.data;

    //validating both
    const employee = await SELECT.from(Employees).where({ employeeId: employeeid });
    const leavetype = await SELECT.from(LeaveTypes).where({ leaveTypeId: leavetypeid });

    if (employee.length === 0) {
      req.error(404, `Employee with ID ${employeeid} not found`);
    }
    if (leavetype.length === 0) {
      req.error(404, `Leave type with ID ${leavetypeid} not found`);
    }

    // Updating leave balance
    const existingbalance = await SELECT.from(LeaveBalances)
      .where({ employee_employeeId: employeeid, leaveType_leaveTypeId: leavetypeid });

    if (existingbalance.length > 0) {

      // Updating existing balance
      return UPDATE(LeaveBalances)
        .set({ 
          totaldays: totaldays,
          remainingdays: totaldays,
          useddays: 0
        })
        .where({ employee_employeeId: employeeid, leaveType_leaveTypeId: leavetypeid });
    } 
    else 

    {
      // Creating new balance
      return INSERT.into(LeaveBalances).entries({
        employee_employeeId: employeeid,
        leaveType_leaveTypeId: leavetypeid,
        totalDays: totaldays,
        usedDays: 0,
        remainingDays: totaldays
      });
    }

  });

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////APPROVE LEAVE REQUEST
///////////////////////////////////////////////////////////////////////////////////////////////////

  this.on('approveLeaveRequest', async (req) => {
    const { requestid, approverid } = req.data;
    
    // Validating the leave request
    const leaverequest = await SELECT.from(LeaveRequests).where({ requestId: requestid });
    
    if (leaverequest.length === 0) {
      req.error(404, `Leave request with ID ${requestid} not found`);
    }

    // Checking the status of request
    if (leaverequest[0].status !== 'PENDING') {
      req.error(400, `Leave request is already ${leaverequest[0].status.toLowerCase()}`);
    }

    // Validating the approver
    const approver = await SELECT.from(Employees).where({ employeeid: approverid });
    
    if (approver.length === 0) {
      req.error(404, `Approver with ID ${approverid} not found`);
    }

    // Updating request status
    const updatedrequest = await UPDATE(LeaveRequests)
      .set({
        status: 'APPROVED',
        approver_employeeid: approverid,
        updatedat: new Date().toISOString()
      })
      .where({ requestid: requestid });

    // Calculating number of days
    const startDate = new Date(leaverequest[0].startdate);
    const endDate = new Date(leaverequest[0].enddate);
    const days = Math.ceil((endDate - startDate) / (1000 * 60 * 60 * 24)) + 1;

    // Updating the leave balance
    await UPDATE(LeaveBalances)
      .set({ 
        useddays: { '+=': days },
        remainingdays: { '-=': days }
      })
      .where({ 
        employee_employeeId: leaverequest[0].employee_employeeid, 
        leaveType_leaveTypeId: leaverequest[0].leaveType_leavetypeid 
      });

    return updatedrequest;
  });

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////REJECT LEAVE REQUEST
///////////////////////////////////////////////////////////////////////////////////////////////////

  this.on('rejectLeaveRequest', async (req) => {
    const { requestid, approverid } = req.data;
    
    // Validate the leave request
    const leaverequest = await SELECT.from(LeaveRequests).where({ requestId: requestid });
    
    if (leaverequest.length === 0) {
      req.error(404, `Leave request with ID ${requestid} not found`);
    }

    // Checking status of request
    if (leaverequest[0].status !== 'PENDING') {
      req.error(400, `Leave request is already ${leaverequest[0].status.toLowerCase()}`);
    }

    // Validate the approver
    const approver = await SELECT.from(Employees).where({ employeeid: approverid });
    
    if (approver.length === 0) {
      req.error(404, `Approver with ID ${approverid} not found`);
    }

    // Updating request status
    const updatedrequest = await UPDATE(LeaveRequests)
      .set({
        status: 'REJECTED',
        approver_employeeid: approverid,
        updatedat: new Date().toISOString()
      })
      .where({ requestid: requestid });

    return updatedrequest;
  });

}); 