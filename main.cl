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
			out_string(",  ");
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
	componentType : String <- "none";

	init(type : String) : StringNode {
		{
			componentType <- type;
			nodeValue <- "";
			nextNode <- new NilStringNode;
			self;
		}
	};

	getType() : String {
		componentType
	};

	appendString(str_value : String) : StringNode {
		{
			nodeValue <- str_value;
			nextNode <- (new StringNode).init("attribute");
			nextNode;
		}
	};

	toString() : Object {
		{
			out_string(nodeValue).out_string(", ");

			if componentType = "name" then
				out_string("(")
			else 
				new Object
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

    main():Object {
		{
			lists <- (new List).init();

		    while looping loop {
				isLoad <- false;

		        out_string("Your name: ");
		        inputStr <- in_string();
				out_string("\nyou typed ").out_string(inputStr).out_string("\n");

				if inputStr = "help" then
					{
						out_string("Showing available commands:\n");
						out_string("load - \n");
						out_string("print - \n");
						out_string("merge - \n");
						out_string("filterBy - \n");
						out_string("sortBy - \n");
					}
				else if inputStr = "load" then
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
					new Object
				else if inputStr = "filterBy" then
					new Object
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
