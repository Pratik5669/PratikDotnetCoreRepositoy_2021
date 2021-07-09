using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace DataLayer
{
    public interface IDataRepository<T> where T : class
    {
        Task<List<T>> GETALL();
        Task<T> Get(int id);
        Task Delete(int id);

    }
}
