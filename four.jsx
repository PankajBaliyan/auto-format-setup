import * as React from "react";
import { createBrowserRouter, RouterProvider } from "react-router-dom";
     import Header from '../Components/NavBar'
import News from '../Components/News'
import About    from '../Components/About'

// Default Variables
let pageSizeHere =    10
let apiKey = process.env.REACT_APP_API_KEY
let country =     "in"

            const router = createBrowserRouter([
    {
                path: "/technology",
        // key: "technology",
        element: (
                <div>
                   <Header />
                <News
                    pageSize={pageSizeHere}
                    country={country}
                    category="technology"
                    apiKey={apiKey}
                    key="technology"
                />
            </div>
        ),
        errorElement: "no page found",
    },
]);
const AppRouter = () => {
    return (
        <React.StrictMode>
            <RouterProvider router={router} />
        </React.StrictMode>
    );
};

export default AppRouter;