class StringListWrapper inherits IO {	-- aka nod de Product sau Rank
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

	printProducts(index : Int) : Object {
		{
			currentStringList.printStringList(index);
			nextStringList.printProducts(index);
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

    toString() : Object {
		{
			out_string("\n").out_int(index).out_string(": [");
        	rear.printProducts(index);
			out_string("]\n");
		}
    };
};

class EmptyRow inherits Row {
	toString() : Object {
		true
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

	appendRow(row : Row) : RowWrapper {
		{
			currentRow <- row;
			nextRow <- (new RowWrapper).init();
			nextRow;
		}
	};

	printRows() : Object {
		{
			currentRow.toString();
			nextRow.printRows();
		}
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
