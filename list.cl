class StringListWrapper inherits IO {	-- aka nod de Product sau Rank Wrapper
	currentStringList : StringList;
	nextStringList : StringListWrapper;

	init() : StringListWrapper {
		{
			currentStringList <- new NilStringList;
			nextStringList <- new EmptyStringListWrapper;
			self;
		}
	};

	appendProduct(product : StringList) : StringListWrapper {
		{
			currentStringList <- product;
			nextStringList <- (new StringListWrapper).init();
			nextStringList;
		}
	};

	getCurrentStringList() : StringList {
		currentStringList
	};

	printProducts(index : Int) : Object {
		{
			currentStringList.printStringList(index);

			-- tratarea cazului de terminare in structura case: puteam apela recursiv direct, fara aceste conditii de mai jos, dar asta ar fi insemnat ca se mai cicleaza o data, pe un element de tip EmptyStringListWrapper (apeland metoda print din clasa NilStringList).
			-- nu ar fi o eroare, dar in functia curenta eu printez si separatorul (acea virgula), iar daca mai apelez o data metoda pe un obiect gol, se va afisa o virgula in plus la finalul sirului, ceea ce nu corespunde cu outcome-ul corect.
			-- exact asa tratez si terminarea recursivitatii in functia de print din StringListWrapper (aka StringNode)
			case nextStringList of
				dummy : EmptyStringListWrapper => out_string(" (BAD TERMINATOR) ");
				dummy : StringListWrapper => {
					case nextStringList.getCurrentStringList() of
						dummy : NilStringList => true;
						dummy : StringList => {
							out_string(", ");
							nextStringList.printProducts(index);
						};
					esac;
				};
			esac;

			-- de aceea nu mai fac aici apelul recursiv
			-- nextStringList.printProducts(index);
		}
	};
};

class EmptyStringListWrapper inherits StringListWrapper {
	printProducts(index : Int) : Object {
		{
			true;
		}
	};
};

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

class Row inherits IO {
    front : StringListWrapper;
	rear : StringListWrapper;
	index : Int;

	init(idx : Int) : Row {	-- s-ar putea sa nu trebuiasca asta
		{
			front <- (new StringListWrapper).init();
			rear <- front;
			index <- idx;
			self;
		}
	};

    add(stringList : StringList) : Object {
        front <- front.appendProduct(stringList)
    };

    toString(isLastRow : Bool) : Object {
		{
			out_string("\n").out_int(index).out_string(": [ ");
        	rear.printProducts(index);
			out_string(" ]\n");
		}
    };
};

class EmptyRow inherits Row {
	toString(isLastRow : Bool) : Object {
		{
			true;
		}
	};
};


class RowWrapper inherits IO {
	currentRow : Row;
	nextRow : RowWrapper;

	init() : RowWrapper {
		{
			currentRow <- new EmptyRow;
			nextRow <- new EmptyRowWrapper;
			self;
		}
	};

	getRow() : Row {
		currentRow
	};

	appendRow(row : Row) : RowWrapper {
		{
			currentRow <- row;
			nextRow <- (new RowWrapper).init();
			nextRow;
		}
	};

	printRows() : Object {
		(let isLastRow : Bool <- false in 
			{
				case nextRow of
					dummy : EmptyRowWrapper => isLastRow <- true;
					dummy : RowWrapper => isLastRow <- false;
					(*dummy : EmptyRowWrapper => {isLastRow <- true; out_string("\nYOU SEE EMPTY ROW?\n");};
					dummy : RowWrapper => {isLastRow <- false; out_string("\nYOU SEE ROW?\n");};*)
				esac;
				currentRow.toString(isLastRow);
				nextRow.printRows();
			}
		)
	};
};

class EmptyRowWrapper inherits RowWrapper {
	printRows() : Object {
		true
	};
};



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


class List inherits IO {
	front : RowWrapper;
	rear : RowWrapper;

	init() : List {
		{
			front <- (new RowWrapper).init();
			rear <- front;
			self;
		}
	};

	add(row : Row) : Object {
        front <- front.appendRow(row)
    };

    toString():Object {
        rear.printRows()
    };

    merge(other : Row):SELF_TYPE {
        self (* TODO *)
    };

    filterBy():SELF_TYPE {
        self (* TODO *)
    };

    sortBy():SELF_TYPE {
        self (* TODO *)
    };
};
