//Surya Vadivazhagu and James Flynn
//Part 3 of Phase 3

import java.sql.*;
import java.util.Scanner;

public class Reporting {
    //TA's will specify uname and pword as input
    static String uname = "";
    static String pw = "";
    static String queryNum = "";
    static Connection connxn;
    //The JDBC Driver URL is oracle.jdbc.driver.OracleDriver
    static String url = "jdbc:oracle:thin:@oracle.wpi.edu:1521:orcl";

    public static boolean login(){
        try{
            connxn = DriverManager.getConnection(url, uname, pw);
            System.out.println("Connecting to the database...");
        }
        //Possibility of the SQLException? only way to make it go away in IDE is to accommodate the exception in try-catch
        catch(SQLException e){
            e.printStackTrace();
            return false;
        }
        System.out.println("Logged in");
        return true;
    }
    //the command has to be a string as it's coming from Scanner, too much trouble to cast it to Integer later on.
    public static void queryRun(String cmd, String cmdNum) {
        try {
            Statement sqlStatement = connxn.createStatement();
            //There are 3 possibilities for the commands
            //The first 2 options need only 1 sql statement but later on more will be needed.
            String cmd1 = null;
            String cmd2 = null;
            String cmd3 = null;

            if(cmdNum.equals("1")) {
                //pk of patient is SSN
                cmd1 = "SELECT * FROM Patient WHERE SSN = '"+cmd+"'";
            }
            if(cmdNum.equals("2")) {
                //pk of doctor is Id
                cmd1 = "SELECT * FROM Doctor WHERE Id = '"+cmd+"'";
            }
            if(cmdNum.equals("3")) {
                //pk of admission is AdmissionNum
                //need to show RoomNum, StartDate, EndDate, and DoctorId doctorId needs to be unique
                cmd1 = "SELECT * FROM Admission WHERE AdmissionNum = "+cmd+"";
                cmd2 = "SELECT DISTINCT RoomNum, StartDate, EndDate FROM StayIn WHERE AdmissionNum = "+cmd+"";
                cmd3 = "SELECT DISTINCT DoctorId FROM Examine WHERE AdmissionNum = "+cmd+"";
            }
            //Only will need output2 and output3 for the commmand 3 as that will be 3 SQL queries.
            System.out.println("\n Now Running " + cmd1 + "\n");
            ResultSet queryResult = sqlStatement.executeQuery(cmd1);
            ResultSet queryResult2 = null;
            ResultSet queryResult3 = null;

            //case of user doing command 3, need to print the notification of the other 2 being run.
            if(cmdNum.equals("3")) {
                System.out.println("\n Now Running " + cmd2);
                System.out.println("\n Now Running " + cmd3 + "\n");
            }

            while(queryResult.next()){
                if(cmdNum.equals("1")) {
                    System.out.println("Patient SSN: " + queryResult.getString("SSN"));
                    System.out.println("Patient First Name: " + queryResult.getString("FirstName"));
                    System.out.println("Patient Last Name: " + queryResult.getString("LastName"));
                    System.out.println("Patient Address: " + queryResult.getString("Address"));
                }
                if(cmdNum.equals("2")) {
                    System.out.println("Doctor ID: " + queryResult.getString("Id"));
                    System.out.println("Doctor First Name: " + queryResult.getString("FirstName"));
                    System.out.println("Doctor Last Name: " + queryResult.getString("LastName"));
                    System.out.println("Doctor Gender: " + queryResult.getString("Gender"));
                }
                if(cmdNum.equals("3")) {
                    System.out.println("Admission Number: " + queryResult.getString("AdmissionNum"));
                    System.out.println("Admission Date: " + queryResult.getString("AdmissionDate"));
                    System.out.println("Patient SSN: " + queryResult.getString("PatientSSN"));
                    System.out.println("TotalPayment: " + queryResult.getString("TotalPayment"));

                    System.out.println("Rooms:");

                    queryResult2 = sqlStatement.executeQuery(cmd2);
                    while(queryResult2.next()) {
                        //need to emulate the spec sheet, going to add a tab?
                        System.out.println("    RoomNum: " + queryResult2.getString("RoomNum") + "  From Date: " + queryResult2.getString("StartDate") + "  End Date: " + queryResult2.getString("EndDate"));
                    }

                    System.out.println("Doctors examined the patient in this admission:");

                    queryResult3 = sqlStatement.executeQuery(cmd3);
                    while(queryResult3.next()) {
                        System.out.println("    Doctor ID: " + queryResult3.getString("DoctorId"));
                    }
                }
            }
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
    }
    //if user specifies argument 4, it means they are updating the admission payment.
    public static void paymentUpdate(String admitNum, String newPayment) {
        //need to do try/catch for the SQLException again
        try { Statement statement = connxn.createStatement();
            String cmd = "UPDATE Admission SET TotalPayment = " + newPayment + " WHERE AdmissionNum= " + admitNum+ "";
            System.out.println("Now Running " + cmd);
            statement.executeQuery(cmd);
            System.out.println("\nSuccessfully updated admission number " + admitNum + "'s total payment to $" + newPayment+ ".");
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
    }
    //main method, to handle the generic UI stuff mentioned in the spec sheet now that the logic has been handled.
    public static void main(String[] args) {

        if(args.length < 2) {
            Scanner input = new Scanner(System.in);
            //don't need println here, just taking input. Should make new lines via the scanner itself
            System.out.print("Enter your username: ");
            uname = input.next();
            System.out.print("Enter your password: ");
            pw = input.next();
            System.out.print("Which Function Number?: ");
            queryNum = input.next();
        }
        else {
            //if they have more than 2 arguments we know it's going to already have the username and password, extract that.
            uname = args[0];
            pw = args[1];
        }
        if(!login()) {
            //add case of if the login was a failure, like they entered wrong credentials in.
            System.out.println("Login failed.");
        }
        if(args.length == 2) {
            System.out.println("1- Report Patients Basic Information");
            System.out.println("2- Report Doctors Basic Information");
            System.out.println("3- Report Admissions Information");
            System.out.println("4- Update Admissions Payment");
        }
        if(args.length == 3) {
            Scanner input = new Scanner(System.in);
            queryNum = args[2];
            //Support for the Reporting Patient's Basic Info mode.
            if(queryNum.equals("1")) {
                System.out.print("Enter Patient SSN: ");
                String patientSsn = input.next();
                queryRun(patientSsn, "1");
            }
            else if(queryNum.equals("2")) {
                System.out.print("Enter Doctor ID: ");
                String id = input.next();
                queryRun(id, "2");
            }
            else if(queryNum.equals("3")) {
                System.out.print("Enter Admission Number: ");
                String admitNum = input.next();
                queryRun(admitNum, "3");
            }
            else if(queryNum.equals("4")) {
                System.out.print("Enter Admission Number: ");
                String admitNum= input.next();
                System.out.print("Enter the new total payment: ");
                String newPayment = input.next();
                paymentUpdate(admitNum, newPayment);
            }
            else {
                //the edge case of if they make a typo like enter 5 or 0?
                System.out.println("Invalid argument. Number must be between 1 and 4.");
                System.out.println("1- Report Patients Basic Information");
                System.out.println("2- Report Doctors Basic Information");
                System.out.println("3- Report Admissions Information");
                System.out.println("4- Update Admissions Payment");
            }
        }
        try {
            connxn.close();
            System.out.println("\nDisconnected from the server.");
        }
        catch(SQLException e) {
            e.printStackTrace();
        }
    }
}
