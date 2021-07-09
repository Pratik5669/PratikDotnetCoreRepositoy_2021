using BusinessLayer.Models;
using DataLayer;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer
{
    public class ManageProduct : IManageProduct
    {
        IDataRepository<Product> _dataRepository;
        private readonly string _connectionString;

        public ManageProduct(IDataRepository<Product> dataRepository , IConfiguration configuration)
        {
            _dataRepository = dataRepository;
            _connectionString = configuration.GetConnectionString("defaultConnection");
        }
        public async Task AddProduct(Product product)
        {
            using (SqlConnection sql = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Proc_AddProduct", sql))
                {
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@Name", product.Name));
                    cmd.Parameters.Add(new SqlParameter("@Description", product.Description));
                    cmd.Parameters.Add(new SqlParameter("@Price", product.Price));
                    cmd.Parameters.Add(new SqlParameter("@Quantity", product.Quantity));
                    cmd.Parameters.Add(new SqlParameter("@CategoryName", product.Category));
                    cmd.Parameters.Add(new SqlParameter("@UnitName", product));
                    cmd.Parameters.Add(new SqlParameter("@Weight", product.Measure));
                    cmd.Parameters.Add(new SqlParameter("@SellStartDate", product.SellStartDate));
                    cmd.Parameters.Add(new SqlParameter("@SellEndDateDate", product.SellEndDateDate));
                    cmd.Parameters.Add(new SqlParameter("@ImageURL", product.ImageURL));
                    cmd.Parameters.Add(new SqlParameter("@IsDiscontinued", product.IsDiscontinued));

                    await sql.OpenAsync();
                    await cmd.ExecuteNonQueryAsync();
                    return;
                }
            }
        }

        public async Task DeleteProduct(int id)
        {
            await _dataRepository.Delete(id);
        }

        public async Task<Product> GetProduct(int id)
        {
            Product product = await _dataRepository.Get(id);
            return product;
        }

        public async Task<List<Product>> GetAllProduct()
        {
            return  await _dataRepository.GETALL();
        }

        public async Task UpdateProduct(Product product , int ProductID)
        {
            using (SqlConnection sql = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Proc_UpdateProduct", sql))
                {
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@ProductId", ProductID));
                    cmd.Parameters.Add(new SqlParameter("@Name", product.Name));
                    cmd.Parameters.Add(new SqlParameter("@Description", product.Description));
                    cmd.Parameters.Add(new SqlParameter("@Price", product.Price));
                    cmd.Parameters.Add(new SqlParameter("@Quantity", product.Quantity));
                    cmd.Parameters.Add(new SqlParameter("@CategoryName", product.Category));
                    cmd.Parameters.Add(new SqlParameter("@UnitName", product));
                    cmd.Parameters.Add(new SqlParameter("@Weight", product.Measure));
                    cmd.Parameters.Add(new SqlParameter("@SellStartDate", product.SellStartDate));
                    cmd.Parameters.Add(new SqlParameter("@SellEndDateDate", product.SellEndDateDate));
                    cmd.Parameters.Add(new SqlParameter("@ImageURL", product.ImageURL));
                    cmd.Parameters.Add(new SqlParameter("@IsDiscontinued", product.IsDiscontinued));
                    await sql.OpenAsync();
                    await cmd.ExecuteNonQueryAsync();
                    return;
                }
            }
        }
    }
}
