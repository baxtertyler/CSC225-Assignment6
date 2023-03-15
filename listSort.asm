	.globl	recurSelectionSort
recurSelectionSort:
#struct Node* recurSelectionSort(struct Node* head) {


#	if (head->next == NULL)


#		return head;


#	struct Node* min = head;

#	struct Node* beforeMin = NULL;


#	struct Node* ptr;

#	for (ptr = head; ptr->next != NULL; ptr = ptr->next) {
forinit:


forloop:

#		if (ptr->next->studentid < min->studentid ) {
ifmin:

#			min = ptr->next;


#			beforeMin = ptr;
endifmin:
#		}


endfor:
#	}


if2:
#	if (min != head)

#		swapNodes(&head, head, min, beforeMin);


endif2:


#	head->next = recurSelectionSort(head->next);

#	return head;



#}
