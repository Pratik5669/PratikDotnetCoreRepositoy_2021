using BusinessLayer;
using BusinessLayer.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace ShopBridgeAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [AllowAnonymous]
    public class ProductController : ControllerBase
    {
        IManageProduct _manageProduct;

        public ProductController(IManageProduct manageProduct)
        {
            _manageProduct = manageProduct;
        }
       

        // GET: api/<ProductController>
        [HttpGet]
        public async Task<List<Product>> GetAsync()
        {
            List<Product> products = new List<Product>();
            try
            {
                products =await _manageProduct.GetAllProduct();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return products;
        }

        // GET api/<ProductController>/5
        [HttpGet("{id}")]
        public async Task<Product> GetAsync(int id)
        {
            Product product = null;
            try
            {
                product = await _manageProduct.GetProduct(id);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return product;
        }

        // POST api/<ProductController>
        [HttpPost]
        public async Task PostAsync([FromBody] Product product)
        {
            try
            {
                await _manageProduct.AddProduct(product);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        // PUT api/<ProductController>/5
        [HttpPut("{id}")]
        public async void Put(int id, [FromBody] Product product)
        {
            try
            {
                await _manageProduct.UpdateProduct(product,id);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        // DELETE api/<ProductController>/5
        [HttpDelete("{id}")]
        public async Task DeleteAsync(int id)
        {

            try
            {
                await _manageProduct.DeleteProduct(id);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
