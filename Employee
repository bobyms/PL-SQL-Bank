import java.sql.*;
import java.util.*;
import javafx.scene.control.*;
import oracle.jdbc.driver.OracleDriver;
import javafx.application.Application;
import javafx.event.*;
import javafx.scene.Scene;
import javafx.scene.layout.Pane;
import javafx.stage.Stage;

public class employee extends Application{

    public void start(Stage primaryStage){
        Pane aPane = new Pane();

        Menu branchs = new Menu("Branch");
        MenuItem open = new MenuItem("Open branch");
        MenuItem close = new MenuItem("Close branch");
        branchs.getItems().addAll(open,close);

        Menu setup = new Menu("Setup");
        MenuItem account = new MenuItem("Open Account");
        MenuItem create_customer = new MenuItem("Create Customer");
        MenuItem remove_customer = new MenuItem("Remove Customer");
        MenuItem close_account = new MenuItem("Close Account");
        setup.getItems().addAll(account,create_customer,close_account,remove_customer);

        Menu trans = new Menu("Transactions");
        MenuItem withdraw = new MenuItem("Withdraw");
        MenuItem deposit = new MenuItem("Deposit");
        MenuItem transfer = new MenuItem("Transfer");
        trans.getItems().addAll(withdraw,deposit,transfer);

        Menu shows = new Menu("Show");
        MenuItem show_b = new MenuItem("Show Branch");
        MenuItem show_all_branches = new MenuItem("Show All Branches");
        MenuItem show_customer = new MenuItem("Show customer");
        shows.getItems().addAll(show_b,show_all_branches,show_customer);

        try {
            //Connect to server
            DriverManager.registerDriver
                    (new OracleDriver());
            System.out.println("Connecting to JDBC...");

            Connection conn = DriverManager.getConnection
                    ("jdbc:oracle:thin:@localhost:1521:bo", "bo", "bo");
            System.out.println("JDBC connected.\n");

            //1. Opens new branch
            open.setOnAction(new EventHandler<ActionEvent>() {
                @Override
                public void handle(ActionEvent event) {
                    TextInputDialog add = new TextInputDialog();
                    add.setTitle("Input");
                    add.setContentText("Enter address for new branch");
                    Optional<String> result = add.showAndWait();
                    Alert alert = new Alert(Alert.AlertType.INFORMATION);
                    if(result.isPresent()){
                        alert.setContentText("Branch opened");
                        alert.showAndWait();

                    }
                    else alert.setContentText("You entered no value");
                }
            });

            //2.Closes existing branch
            close.setOnAction(new EventHandler<ActionEvent>() {
                @Override
                public void handle(ActionEvent event) {
                    TextInputDialog del = new TextInputDialog();
                    del.setTitle("Input");
                    del.setContentText("Enter address of branch to delete");
                    Optional<String> result = del.showAndWait();
                    Alert alert = new Alert(Alert.AlertType.INFORMATION);
                    if(result.isPresent()){
                        try {
                            CallableStatement call = conn.prepareCall("{call close_branch(?)}");
                            call.setString(1,result.get());
                            call.execute();
                            call.close();
                            alert.setContentText("Branch has been deleted");
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                    else alert.setContentText("You entered no value");

                }
            });

            //3 opens account
            account.setOnAction(new EventHandler<ActionEvent>() {
                @Override
                public void handle(ActionEvent event) {
                    TextInputDialog name = new TextInputDialog();
                    TextInputDialog bran = new TextInputDialog();
                    TextInputDialog amount = new TextInputDialog();
                    name.setTitle("Input");
                    name.setContentText("Enter Customer name");
                    bran.setContentText("Enter branch address");
                    amount.setContentText("Enter initial amount");
                    Optional<String> result = name.showAndWait();
                    Optional<String> result2 = bran.showAndWait();
                    Optional<String> result3 = amount.showAndWait();
                    Alert alert = new Alert(Alert.AlertType.INFORMATION);
                    if (result.isPresent() && result2.isPresent() && result3.isPresent()) {
                        alert.setContentText("Account for "+result.get() +" in "+ result2.get()+" made with value of "+result3.get());
                        alert.showAndWait();
                        /*
                        try {
                            CallableStatement call = conn.prepareCall("{call open_account(?,?,?)}");
                            call.setString(1, result.get());
                            call.setString(2,result2.get());
                            call.setInt(3,Integer.parseInt(result3.get()));
                            call.execute();
                            call.close();

                        } catch (SQLException e) {
                            e.printStackTrace();
                        }*/
                    }
                    else {
                        alert.setContentText("You entered no value");
                        alert.showAndWait();
                    }
                }
            });

            //4
            create_customer.setOnAction(new EventHandler<ActionEvent>() {
                @Override
                public void handle(ActionEvent event) {
                    TextInputDialog name = new TextInputDialog();
                    name.setTitle("Input");
                    name.setContentText("Enter Customer name");
                    Optional<String> result = name.showAndWait();
                    try {
                        CallableStatement call = conn.prepareCall("{call create_customer(?)}");
                        call.setString(1,result.get());
                        call.execute();
                        call.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            });

            remove_customer.setOnAction(new EventHandler<ActionEvent>() {
                @Override
                public void handle(ActionEvent event) {
                    TextInputDialog name = new TextInputDialog();
                    name.setTitle("Input");
                    name.setContentText("Enter Customer name");
                    Optional<String> result = name.showAndWait();
                    try {
                        CallableStatement call = conn.prepareCall("{call remove_customer(?)}");
                        call.setString(1,result.get());
                        call.execute();
                        call.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            });

            //5
            close_account.setOnAction(new EventHandler<ActionEvent>() {
                @Override
                public void handle(ActionEvent event) {
                    TextInputDialog acc = new TextInputDialog();
                    acc.setTitle("Input");
                    acc.setContentText("Enter account number");
                    Optional<String> result = acc.showAndWait();
                    Alert alert = new Alert(Alert.AlertType.INFORMATION);
                    if(result.isPresent()) {
                        try {
                            CallableStatement call = conn.prepareCall("{call close_account(?)}");
                            call.setString(1,result.get());
                            call.execute();
                            call.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                    else {
                        alert.setContentText("Missing info");
                        alert.showAndWait();
                    }
                }
            });

            //6
            withdraw.setOnAction(new EventHandler<ActionEvent>() {
                @Override
                public void handle(ActionEvent event) {
                    TextInputDialog acc = new TextInputDialog();
                    TextInputDialog money = new TextInputDialog();
                    Alert alert = new Alert(Alert.AlertType.INFORMATION);
                    acc.setContentText("Enter account number");
                    money.setContentText("Enter amount to withdraw");
                    Optional<String> result = acc.showAndWait();
                    Optional<String> result2 = money.showAndWait();
                    if(result.isPresent() && result2.isPresent()) {
                        try {
                            CallableStatement call = conn.prepareCall("{call withdraw(?,?)}");
                            call.setString(1,result.get());
                            call.setString(2,result2.get());
                            call.execute();
                            call.close();
                        } catch (SQLException e) {
                            alert.setContentText("Entered info does not match records");
                            alert.showAndWait();
                            e.printStackTrace();
                        }
                    }
                    else {
                        alert.setContentText("Input missing");
                        alert.showAndWait();
                    }
                }
            });

            //7
            deposit.setOnAction(new EventHandler<ActionEvent>() {
                @Override
                public void handle(ActionEvent event) {
                    TextInputDialog acc = new TextInputDialog();
                    TextInputDialog money = new TextInputDialog();
                    Alert alert = new Alert(Alert.AlertType.INFORMATION);
                    acc.setContentText("Enter account number");
                    money.setContentText("Enter amount to deposit");
                    Optional<String> result = acc.showAndWait();
                    Optional<String> result2 = money.showAndWait();
                    if(result.isPresent() && result2.isPresent()) {
                        try {
                            CallableStatement call = conn.prepareCall("{call deposit(?,?)}");
                            call.setString(1,result.get());
                            call.setString(2,result2.get());
                            call.execute();
                            call.close();
                        } catch (SQLException e) {
                            alert.setContentText("Entered info does not match records");
                            alert.showAndWait();
                            e.printStackTrace();
                        }
                    }
                    else {
                        alert.setContentText("Input missing");
                        alert.showAndWait();
                    }
                }
            });

            //8
            transfer.setOnAction(new EventHandler<ActionEvent>() {
                @Override
                public void handle(ActionEvent event) {
                    TextInputDialog acc = new TextInputDialog();
                    TextInputDialog acc2 = new TextInputDialog();
                    TextInputDialog money = new TextInputDialog();
                    Alert alert = new Alert(Alert.AlertType.INFORMATION);
                    acc.setContentText("Enter account number to transfer from");
                    acc2.setContentText("Enter account number to transfer to");
                    money.setContentText("Enter amount to transfer");
                    Optional<String> result = acc.showAndWait();
                    Optional<String> result2 = acc2.showAndWait();
                    Optional<String> result3 = money.showAndWait();

                    if(result.isPresent() && result2.isPresent() && result3.isPresent()) {
                        try {
                            CallableStatement call = conn.prepareCall("{call transfer(?,?,?)}");
                            call.setString(1,result.get());
                            call.setString(2,result2.get());
                            call.setInt(3,Integer.parseInt(result3.get()));
                            call.execute();
                            call.close();
                        } catch (SQLException e) {
                            alert.setContentText("Entered info does not match records");
                            alert.showAndWait();
                            e.printStackTrace();
                        }
                    }
                    else {
                        alert.setContentText("Input missing");
                        alert.showAndWait();
                    }
                }
            });

            //9
            show_b.setOnAction(new EventHandler<ActionEvent>() {
                @Override
                public void handle(ActionEvent event) {
                    TextInputDialog bran = new TextInputDialog();
                    bran.setContentText("Enter Branch address");
                    Optional<String> result = bran.showAndWait();
                    if(result.isPresent()) {
                        try {
                            CallableStatement call = conn.prepareCall("{call show_branch(?)}");
                            call.setString(1,result.get());
                            call.execute();
                            call.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                }
            });

            //10
            show_all_branches.setOnAction(new EventHandler<ActionEvent>() {
                @Override
                public void handle(ActionEvent event) {
                        try {
                            CallableStatement call = conn.prepareCall("{call show_all_branches()}");
                            call.execute();
                            call.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                    }
                }
            });

            //11
            show_customer.setOnAction(new EventHandler<ActionEvent>() {
                @Override
                public void handle(ActionEvent event) {
                    TextInputDialog name = new TextInputDialog();
                    name.setTitle("Input");
                    name.setContentText("Enter customer name");
                    Optional<String> result = name.showAndWait();
                    Alert alert = new Alert(Alert.AlertType.INFORMATION);
                    if(result.isPresent()){
                        try {
                            CallableStatement call = conn.prepareCall("{call show_customer(?)}");
                            call.setString(1,result.get());
                            call.execute();
                            call.close();
                        } catch (SQLException e) {
                            alert.setContentText("Customer does not exist");
                            e.printStackTrace();
                        }
                    }
                    else alert.setContentText("You entered no value");
                }
            });
        }
        catch(Exception e)
        {
            System.out.println("SQL exception: ");
            e.printStackTrace();
            System.exit(-1);
        }
        MenuBar menuBar = new MenuBar();
        aPane.getChildren().addAll(menuBar);
        menuBar.getMenus().addAll(branchs,setup,trans,shows);
        primaryStage.setTitle("PL/SQL Bank");
        primaryStage.setScene(new Scene(aPane, 250,200));
        primaryStage.show();
    }
    public static void main(String[] args) {
        launch(args);
    }
}

