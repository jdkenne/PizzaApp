package cpsc4620;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
/*
 * This file is where the front end magic happens.
 * 
 * You will have to write the functionality of each of these menu options' respective functions.
 * 
 * This file should need to access your DB at all, it should make calls to the DBNinja that will do all the connections.
 * 
 * You can add and remove functions as you see necessary. But you MUST have all 8 menu functions (9 including exit)
 * 
 * Simply removing menu functions because you don't know how to implement it will result in a major error penalty (akin to your program crashing)
 * 
 * Speaking of crashing. Your program shouldn't do it. Use exceptions, or if statements, or whatever it is you need to do to keep your program from breaking.
 * 
 * 
 */

public class Menu {
	public static void main(String[] args) throws SQLException, IOException {
		BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));

		System.out.println("Welcome to Taylor's Pizzeria!");
		
		int menu_option = 0;

		// present a menu of options and take their selection
		PrintMenu();
		String option = reader.readLine();
		menu_option = Integer.parseInt(option);

		while (menu_option != 9) {
			switch (menu_option) {
			case 1:// enter order
				EnterOrder();
				break;
			case 2:// view customers
				viewCustomers();
				break;
			case 3:// enter customer
				EnterCustomer();
				break;
			case 4:// view order
				// open/closed/date
				ViewOrders();
				break;
			case 5:// mark order as complete
				MarkOrderAsComplete();
				break;
			case 6:// view inventory levels
				ViewInventoryLevels();
				break;
			case 7:// add to inventory
				AddInventory();
				break;
			case 8:// view reports
				PrintReports();
				break;
			}
			PrintMenu();
			option = reader.readLine();
			menu_option = Integer.parseInt(option);
		}

	}

	public static void PrintMenu() {
		System.out.println("\n\nPlease enter a menu option:");
		System.out.println("1. Enter a new order");
		System.out.println("2. View Customers ");
		System.out.println("3. Enter a new Customer ");
		System.out.println("4. View orders");
		System.out.println("5. Mark an order as completed");
		System.out.println("6. View Inventory Levels");
		System.out.println("7. Add Inventory");
		System.out.println("8. View Reports");
		System.out.println("9. Exit\n\n");
		System.out.println("Enter your option: ");
	}

	// allow for a new order to be placed
	public static void EnterOrder() throws SQLException, IOException 
	{
		BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
		Order order = new Order(0, 0, "dinein", "n ", 0, 0, 0);
		int orderId = DBNinja.getNextOrderID() + 1;
		System.out.println(orderId);
		order.setOrderID(orderId);
		System.out.println("Is this order for an existing customer? Answer y/n: ");
		String existing = reader.readLine();

		if (existing.equals("y")){
			System.out.println("Here is a list of the current customers");
			ArrayList<Customer> custList = DBNinja.getCustomerList();
			for (Customer cust: custList){
				System.out.println(cust);
			}
			System.out.println("Which customer is this order for? Enter ID Number ");
			int custID = Integer.parseInt(reader.readLine());
			order.setCustID(custID);
			DBNinja.addOrder(order);
			System.out.println("Is this order for: \n1.)Dine-in\n2.)Pick-up\n3.)Delivery\nEnter to corresponding number\n ");
			int orderType = Integer.parseInt(reader.readLine());
			if (orderType == 1){
				System.out.println("Enter the table number");
				int tableNum = Integer.parseInt(reader.readLine());
				Pizza p = buildPizza(orderId);
				order.setCustID(DBNinja.getNextOrderID());
				order.setDate(p.getPizzaDate());
				order.setBusPrice(p.getBusPrice());
				order.setCustPrice(p.getCustPrice());
				order.setIsComplete(p.getPizzaState());
				//DineinOrder dineinOrder = new DineinOrder(order.getOrderID,..., tablenum);
				DineinOrder dineinOrder = new DineinOrder(order.getOrderID(),order.getCustID(),
						order.getDate(), order.getCustPrice(), order.getBusPrice(), order.getIsComplete(), tableNum);
				
				
				
				DBNinja.addOrder(dineinOrder);

			}
			if (orderType == 2){
				buildPizza(orderId);
				PickupOrder pickup = (PickupOrder) order;
				DBNinja.addOrder(pickup);
			}
			if (orderType == 3){
				System.out.println("Enter the customer address");
				String addy = reader.readLine();
				buildPizza(orderId);
				DeliveryOrder deliv = (DeliveryOrder) order;
				((DeliveryOrder) order).setAddress(addy);
				DBNinja.addOrder(deliv);
			}


		}
		else{
			EnterCustomer();
			order.setCustID(DBNinja.getNextOrderID());
			DBNinja.addOrder(order);
			
			System.out.println("Is this order for: \n1.)Dine-in\n2.)Pick-up\n3.)Delivery\nEnter to corresponding number\n ");
			int orderType = Integer.parseInt(reader.readLine());
			
			if (orderType == 1){
				System.out.println("Enter the table number");
				int tableNum = Integer.parseInt(reader.readLine());
				
				//populate order with correct values
				Pizza p = buildPizza(orderId);
			
				order.setDate(p.getPizzaDate());
				order.setBusPrice(p.getBusPrice());
				order.setCustPrice(p.getCustPrice());
				order.setIsComplete(p.getPizzaState());
				order.setOrderType(DBNinja.dine_in);
				DBNinja.updateOrder(order);

				DineinOrder dineinOrder = new DineinOrder(order.getOrderID(),order.getCustID(),
						order.getDate(), order.getCustPrice(), order.getBusPrice(), order.getIsComplete(), tableNum);
				DBNinja.addSubOrder(dineinOrder);
			}
			if (orderType == 2){
				int isPickedUp = 0;
				Pizza p = buildPizza(orderId);
				order.setDate(p.getPizzaDate());
				order.setBusPrice(p.getBusPrice());
				order.setCustPrice(p.getCustPrice());
				order.setIsComplete(p.getPizzaState());
				order.setOrderType(DBNinja.pickup);
				DBNinja.updateOrder(order);
				PickupOrder pickup = new PickupOrder(order.getOrderID(),order.getCustID(),order.getDate(),order.getCustPrice(),
						order.getBusPrice(),isPickedUp,order.getIsComplete());
						
				DBNinja.addSubOrder(pickup);
			}
			if (orderType == 3){
				System.out.println("What address would you like to enter?");
				String address = reader.readLine();
				Pizza p = buildPizza(orderId);
				order.setDate(p.getPizzaDate());
				order.setBusPrice(p.getBusPrice());
				order.setCustPrice(p.getCustPrice());
				order.setIsComplete(p.getPizzaState());
				order.setOrderType(DBNinja.delivery);
				DBNinja.updateOrder(order);
				DeliveryOrder deliv = new DeliveryOrder(order.getOrderID(), order.getCustID(), order.getDate(), order.getCustPrice(), order.getBusPrice()
						, order.getIsComplete(), address);
				DBNinja.addSubOrder(deliv);
			}
		}
	
		System.out.println("Finished adding order...Returning to menu...");
	}
	
	
	public static void viewCustomers() throws SQLException, IOException
	{
		Connection connection = DBConnector.make_connection();
		ResultSet rs = null;
		/*
		 * Simply print out all of the customers from the database. 
		 */
		try (PreparedStatement ps = connection.prepareStatement(viewCustomers)) {
			rs = ps.executeQuery();
			ArrayList<Customer> customers = DBNinja.getCustomerList();
			for (Customer c: customers) {
				System.out.println(c.toString());
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		connection.close();
	}

	// Enter a new customer in the database
	public static void EnterCustomer() throws SQLException, IOException 
	{
		/*
		 * Ask what the name of the customer is. YOU MUST TELL ME (the grader) HOW TO FORMAT THE FIRST NAME, LAST NAME, AND PHONE NUMBER.
		 * If you ask for first and last name one at a time, tell me to insert First name <enter> Last Name (or separate them by different print statements)
		 * If you want them in the same line, tell me (First Name <space> Last Name).
		 * 
		 * same with phone number. If there's hyphens, tell me XXX-XXX-XXXX. For spaces, XXX XXX XXXX. For nothing XXXXXXXXXXXX.
		 * 
		 * I don't care what the format is as long as you tell me what it is, but if I have to guess what your input is I will not be a happy grader
		 * 
		 * Once you get the name and phone number (and anything else your design might have) add it to the DB
		 */
		int customerID = DBNinja.getNextOrderID() + 1;
		String Fname = "";
		String Lname = "";
		String phone = "";
		BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
		System.out.println("Enter the customer's first name");
		Fname = reader.readLine();
		System.out.println("Enter the customer's last name");
		Lname = reader.readLine();
		System.out.println("Enter the customer's phone number");
		phone = reader.readLine();

		
		Customer customer = new Customer(customerID,Fname,Lname,phone);
		DBNinja.addCustomer(customer);

		System.out.println(customer.toString());
	}

	// View any orders that are not marked as completed
	public static void ViewOrders() throws SQLException, IOException 
	{
	/*
	 * This should be subdivided into two options: print all orders (using simplified view) and print all orders (using simplified view) since a specific date.
	 * 
	 * Once you print the orders (using either sub option) you should then ask which order I want to see in detail
	 * 
	 * When I enter the order, print out all the information about that order, not just the simplified view.
	 * 
	 */
	BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
	Connection connection = DBConnector.make_connection();
	ResultSet rs = null;
	System.out.println("Would you like to:\n(a) display all orders\n(b) display orders since a specific date");
	String option = "";
	option = reader.readLine();

	if(option == "a") {
		String viewOrders = "Select * FROM  cust_order";
		try(PreparedStatement ps = connection.prepareStatement(viewOrders)){
			rs = ps.executeQuery();

			while(rs.next()) {
				int order_id = rs.getInt("ORDER_ID");
				//might be a date time
				String date = rs.getString("TIMESTAMP");
				String type = rs.getString("ORDER_TYPE");
				//need to figure out how to do forst and last name of customer
				boolean isComplete = rs.getBoolean("IS_COMPLETE");
				System.out.println("OrderID=" + order_id + " | Date Placed=" + date + " | OrderType=" + type
						+ " | IsComplete=" + isComplete);

			}
		}catch (SQLException e) {
			System.out.println(e);
		}
		System.out.println("Which order would you like to see in detail? Enter the number: ");
		ResultSet orderChosen = null;
		String whichOrder = "";
		whichOrder = reader.readLine();
		String orderNum = ("SELECT * FROM cust_order WHERE ORDER_ID = " + whichOrder);

		try (PreparedStatement ps = connection.prepareStatement(viewOrders)) {
			rs = ps.executeQuery();

			while(rs.next()) {
				int order_id = rs.getInt("ORDER_ID");
				//print all info this time
				String date = rs.getString("TIMESTAMP");
				String type = rs.getString("ORDER_TYPE");
				Boolean isComplete = rs.getBoolean("IS_COMPLETE");

				System.out.println("OrderID=" + order_id + " | Date Placed=" + date + " | OrderType=" + type
						+ " | IsComplete=" + isComplete);
			}
		}
		catch (SQLException e) {
			System.out.println(e);
		}
	}
		
	}

	
	// When an order is completed, we need to make sure it is marked as complete
	public static void MarkOrderAsComplete() throws SQLException, IOException 
	{
		/*All orders that are created through java (part 3, not the 7 orders from part 2) should start as incomplete
		 * 
		 * When this function is called, you should print all of the orders marked as complete 
		 * and allow the user to choose which of the incomplete orders they wish to mark as complete
		 * 
		 */
		
		
		
		
		
		

	}

	// See the list of inventory and it's current level
	public static void ViewInventoryLevels() throws SQLException, IOException 
	{
		//print the inventory. I am really just concerned with the ID, the name, and the current inventory
		DBNinja.printInventory();
	}

	// Select an inventory item and add more to the inventory level to re-stock the
	// inventory
	public static void AddInventory() throws SQLException, IOException 
	{
		/*
		 * This should print the current inventory and then ask the user which topping they want to add more to and how much to add
		 */
		
		
		
		
		
		
	}

	// A function that builds a pizza. Used in our add new order function
	public static Pizza buildPizza(int orderID) throws SQLException, IOException 
	{
		
		/*
		 * This is a helper function for first menu option.
		 * 
		 * It should ask which size pizza the user wants and the crustType.
		 * 
		 * Once the pizza is created, it should be added to the DB.
		 * 
		 * We also need to add toppings to the pizza. (Which means we not only need to add toppings here, but also our bridge table)
		 * 
		 * We then need to add pizza discounts (again, to here and to the database)
		 * 
		 * Once the discounts are added, we can return the pizza
		 */
		BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
		ArrayList<Topping> toppingSelection = new ArrayList<Topping>();
		ArrayList<Topping> toppingList = DBNinja.getInventory();
		Pizza p = null;
		int size = 0;
		int crustType = 0;
		int topping = 0;
		String Stopping = " ";
		String Ssize = " ";
		String scrustType = " ";

		System.out.println("What size pizza?");
		System.out.println("1. Small\n2.Medium\n3. Large\n4. Extra Large\nEnter the corresponding number:");
		size = Integer.parseInt(reader.readLine());
		System.out.println("What type of crust do you want?");
		System.out.println("1. Thin\n2. Original\n3. Pan\n,4. Gluten-Free\nEnter the corresponding number:");
		crustType = Integer.parseInt(reader.readLine());

		switch(size) {
			case 1: Ssize = DBNinja.size_s;
				break;
			case 2: Ssize = DBNinja.size_m;
				break;
			case 3: Ssize = DBNinja.size_l;
				break;
			case 4: Ssize = DBNinja.size_xl;
		}
		switch(crustType) {
			case 1: scrustType = DBNinja.crust_thin;
				break;
			case 2: scrustType = DBNinja.crust_orig;
				break;
			case 3: scrustType = DBNinja.crust_pan;
				break;
			case 4: scrustType = DBNinja.crust_gf;

		}
		
		int nextPizzaID = DBNinja.getMaxPizzaID() + 1;

		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("uuuu/MM/dd HH:mm:ss");
		LocalDateTime now = LocalDateTime.now();

		p = new Pizza(nextPizzaID, Ssize, scrustType, orderID,0,dtf.format(now),0,0);
	
		int topping_choice = 0;
		String topping_extra = " ";
		while(true) {
			System.out.println("Printing current toppings list:\n");
			DBNinja.printInventory();
			System.out.println("Which topping do you want to add? Enter the topping ID. Enter -1 to stop adding toppings.");
			topping_choice = Integer.parseInt(reader.readLine());
			if(topping_choice == -1) {
				break;
			}
			System.out.println("Do you want to add extra topping? Enter y/n");
			topping_extra = reader.readLine();

			for(Topping t: toppingList) {
				if(topping_choice == t.getTopID()) {

					if(topping_extra.equals("y")) {
						DBNinja.useTopping(p, t, true);
						p.addToppings(t, true);

					}else {
						DBNinja.useTopping(p, t, false);
						p.addToppings(t, false);
					}
				}
			}
		}

		System.out.println(p.toString());
		return p;
		
		
		
		
		
		
	}
	
	private static int getTopIndexFromList(int TopID, ArrayList<Topping> tops)
	{
		/*
		 * This is a helper function I used to get a topping index from a list of toppings
		 * It's very possible you never need a function like this
		 * 
		 */
		int ret = -1;
		
		
		
		return ret;
	}
	
	
	public static void PrintReports() throws SQLException, NumberFormatException, IOException
	{
		/*
		 * This function calls the DBNinja functions to print the three reports.
		 * 
		 * You should ask the user which report to print
		 */
	}

}
