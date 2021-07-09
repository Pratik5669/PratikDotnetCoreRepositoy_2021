using System;
using System.Collections.Generic;
using System.Text;

namespace BusinessLayer.Models
{
    public class Product
    {
        public int Id { get; set; }

        public int ProductId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public decimal Price { get; set; }
        public int Quantity { get; set; }
        public string Category { get; set; }
        public int Measure { get; set; }
        public int Weight { get; set; }
        public DateTime SellStartDate { get; set; }
        public DateTime SellEndDateDate { get; set; }
        public string ImageURL { get; set; }
        public bool IsDiscontinued { get; set; }
        public DateTime RecordCreatedDate { get; set; }
        public int RecordCreatedBy { get; set; }
        public DateTime RecordUpdatedDate { get; set; }

        public int RecordUpdatedBy { get; set; }


    }
}
