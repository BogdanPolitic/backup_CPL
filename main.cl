class StringList inherits IO {	-- aka Product sau Rank
	front : StringNode;
	rear : StringNode;

	init() : StringList {
		{
			--front <- (new Cons).initType("name");
			front <- (new StringNode).init("name");
			rear <- front;
			self;
		}
	};

	add(str_value : String) : StringList {
		{
			--front <- front.cons(str_value).cdr();
			front <- front.appendString(str_value);
			self;
		}
	};

	printStringList(index : Int) : Object {
		{
			rear.toString();	-- nu e recursiv cu functia de aici, ci cu printStringList din clasa StringNode (aka Cons)
		}
	};

	getFirstElement() : StringNode {
		rear
	};

	getLastElement() : StringNode {
		front
	};
};

class NilStringList inherits StringList {
	printStringList(index : Int) : Object {
		true
	};
};




----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
class StringNode inherits IO {		-- aka wrapper pentru o valoare (valoarea este un String)
	nodeValue : String;
	nextNode : StringNode;
	componentType : String;
	initialized : Bool;

	init(type : String) : StringNode {
		{
			componentType <- type;
			nodeValue <- "";
			initialized <- false;
			nextNode <- new NilStringNode;
			self;
		}
	};

	getType() : String {
		componentType
	};

	wasInitialized() : Bool {
		initialized
	};

	appendString(str_value : String) : StringNode {
		{
			nodeValue <- str_value;
			initialized <- true;
			nextNode <- (new StringNode).init("attribute");
			nextNode;
		}
	};

	toString() : Object {
		{
			out_string(nodeValue);

			if componentType = "name" then
				out_string("(")
			else
				case nextNode of
					dummy : NilStringNode => out_string("");	-- sau new Object; pur si simplu
					dummy : StringNode => 
						if nextNode.wasInitialized() then
							out_string(";")
						else
							new Object
						fi;
				esac
			fi;

			nextNode.toString();
		}
	};
};

class NilStringNode inherits StringNode {
	toString() : Object {
		out_string(")")
	};
};
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------







class Main inherits IO{
    lists : List;
	row : Row;
	index : Int <- 0;
    looping : Bool <- true;
    inputStr : String;
 
	tokenList : StringList;

	isLoad : Bool <- false;

	parseItem(entryStr : String) : Object {
		{
			tokenList <- (new StringList).init();
			(let offset : Int <- 0 in
				while not (offset = entryStr.length()) loop
				{
					offset <- nextToken(entryStr, offset);
					--out_string("Y: ").out_int(offset).out_string("\n");
				}
				pool
			);
		}
	};

	nextToken(entryStr : String, offset : Int) : Int {
		(let entryStrLength : Int <- entryStr.length() in
			(let i : Int <- offset in
				(let continuationCond : Bool <- true in
					(let encounteredSpace : Bool <- false in
						{
							while continuationCond loop
								{
									--out_string("i is ").out_int(i).out_string(" and offset is ").out_int(offset).out_string(" ok.\n");
									i <- i + 1;
									if i = entryStrLength then
										continuationCond <- false
									else if entryStr.substr(i, 1) = " " then
										{
											continuationCond <- false;
											encounteredSpace <- true;
										}
									else
										new Object
									fi fi;
								}
							pool;
							
							tokenList <- tokenList.add(entryStr.substr(offset, i - offset));

							if encounteredSpace then
								{
									continuationCond <- true;

									while continuationCond loop
										{
											i <- i + 1;
											if i = entryStrLength then
												continuationCond <- false
											else if not (entryStr.substr(i, 1) = " ") then
												{
													continuationCond <- false;
													encounteredSpace <- true;
												}
											else
												new Object
											fi fi;
										}
									pool;
								}
							else
								new Object
							fi;

							(i);
						}
					)
				)
			)
		)
	};

	ctoi(character : String) : Int {
		if character = "0" then 0 else
		if character = "1" then 1 else
		if character = "2" then 2 else
		if character = "3" then 3 else
		if character = "4" then 4 else
		if character = "5" then 5 else
		if character = "6" then 6 else
		if character = "7" then 7 else
		if character = "8" then 8 else
		if character = "9" then 9 else
		{abort(); 0;} fi fi fi fi fi fi fi fi fi fi
	};

	atoi(number : String) : Int {
		(let numberLength : Int <- number.length() in
			(let integer : Int <- 0 in
				(let i : Int <- 0 in
					{
						while i < numberLength loop
							{
								integer <- integer * 10;
								integer <- integer + ctoi(number.substr(i, 1));
								i <- i + 1;
							}
						pool;
						integer;
					}
				)
			)
		)
	};

	isCommandHelp(command : String) : Bool {
		command = "help"
	};

	isCommandLoad(command : String) : Bool {
		command = "load"
	};

	isCommandPrint(command : String) : Bool {
		command = "print"
	};

	isCommandMerge(command : String) : Bool {
		if not (command.length() <= 5) then
			if command.substr(0, 5) = "merge" then
				(let index1 : Int in
					(let index2 : Int in
						(let i : Int <- 5 in
							(let j : Int <- 0 in
								{
									while command.substr(i, 1) = " " loop
										i <- i + 1
									pool;

									while not (command.substr(i + j, 1) = " ") loop
										j <- j + 1
									pool;

									index1 <- atoi(command.substr(i, j));

									i <- i + j;
									j <- 0;

									-- duplicate code:
									while command.substr(i, 1) = " " loop
										i <- i + 1
									pool;

									(let endLoop : Bool <- false in
										while not endLoop loop
											{
												if i + j = command.length() then 				-- echivalent cu (if command.substr(i + j, 1) = "\n" then)
													endLoop <- true
												else
													if command.substr(i + j, 1) = " " then
														endLoop <- true
													else
														false
													fi
												fi;
												j <- j + 1;
											}
										pool
									);
									j <- j - 1;

									index2 <- atoi(command.substr(i, j));
									out_string("index1 = ").out_int(index1).out_string(" index2 = ").out_int(index2).out_string("\n");

									true;
								}
							)
						)
					)
				)
			else
				false
			fi
		else
			false
		fi
	};

    main():Object {
		{
			lists <- (new List).init();

		    while looping loop {
				isLoad <- false;

		        out_string("Your name: ");
		        inputStr <- in_string();
				out_string("\nyou typed ").out_string(inputStr).out_string("\n");

				if isCommandHelp(inputStr) then
					{
						out_string("Showing available commands:\n");
						out_string("load - \n");
						out_string("print - \n");
						out_string("merge - \n");
						out_string("filterBy - \n");
						out_string("sortBy - \n");
					}
				else if isCommandLoad(inputStr) then
					{
						(let newEntry : String <- in_string() in
							{
								row <- (new Row).init(index);
								while not (newEntry = "END") loop
									{
										parseItem(newEntry);
										--tokenList.printStringList(index);	-- doar daca vreau sa printez produsul imediat dupa ce il scriu la load
										row.add(tokenList);

										newEntry <- in_string();
									}
								pool;
								lists.add(row);
								index <- index + 1;
							}
						);
					}
				else if inputStr = "print" then
					{
						lists.toString();
						new Object;
					}
				else if inputStr = "merge" then
					{
						true;
					}
				else if inputStr = "filterBy" then
					{
						isCommandMerge(in_string());
					}
				else if inputStr = "sortBy" then
					new Object
				else if inputStr = "dummy" then
		        	out_string("OK, Let's start...\n")
				else if inputStr = "END" then
		        	out_string("End of example file...\n")
				else
					{
						"I'm gonna halt now!".abort();
						new Object;
					}
				fi fi fi fi fi fi fi fi;
		    } pool;
		}
    };
};
