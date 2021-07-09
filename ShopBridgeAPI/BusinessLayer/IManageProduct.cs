using BusinessLayer.Models;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace BusinessLayer
{
    public interface IManageProduct
    {
        Task<List<Product>> GetAllProduct();
        Task<Product> GetProduct(int id);
        Task AddProduct(Product product);
        Task UpdateProduct(Product product , int ProductID);
        Task DeleteProduct(int id);
    }
}
