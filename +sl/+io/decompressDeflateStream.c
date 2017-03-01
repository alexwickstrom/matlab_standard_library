#include "mex.h"
#include "zlib.h"

//This might work:
//https://github.com/qbittorrent/qBittorrent/wiki/Compiling-with-MSVC-2013-(static-linkage)#compiling-zlib

//  d = linspace(0,100,1e7);
//  tic; wtf = same_diff(d); toc;    

//LDFLAGS="$LDFLAGS -lz" 
//  Compile via:
//  mex -lz decompressDeflateStream.c 


//%C:\Program Files\MATLAB\R2015b\bin\win64

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
    //
    //  http://undocumentedmatlab.com/blog/matlab-mex-in-place-editing
    //
    //   Usage
    //   -----
    //   output_data = decompressDeflateStream(uint8_data,n_bytes_out);
    //
    //   TODO: We should also have an input of the form:
    //   (uint8_data,n_bytes_out,start_I_1_based,n_samples)
    //
    //   This is for when the input is part of a larger stream
    //
    //   Ideally we could output to a larger stream, but Matlab doesn't
    //   like modifications of RHS variables
    
    
    if (nrhs != 2){
        mexErrMsgIdAndTxt("SL:decompressDeflateStream:call_error","Invalid # of inputs, 2 expected");
    }else if (!mxIsClass(prhs[0],"uint8")){
        mexErrMsgIdAndTxt("SL:decompressDeflateStream:call_error","The 1st input must be of type uint8");
    }else if (!mxIsClass(prhs[1],"double")){
        mexErrMsgIdAndTxt("SL:decompressDeflateStream:call_error","The 2nd input must be of type double");
    }

//     if (!(nlhs == 1)){
//         mexErrMsgIdAndTxt("SL:decompressDeflateStream:call_error","Invalid # of outputs, 1 expected");
//     }

    mwSize n_data_samples = mxGetNumberOfElements(prhs[0]);
    Bytef *data_in = mxGetData(prhs[0]);
    
    mwSize n_samples_out = mxGetScalar(prhs[1]);
    
    
//     plhs[0] = mxCreateLogicalMatrix(1,1);
//     mxLogical *pl = mxGetLogicals(plhs[0]);
//     
//     *pl = true;
//     if (n_samples_data < 3){
//         return;
//     }
//     
//     double *data = mxGetData(prhs[0]);
//     double *p_start = data;
//     
//     double last_sample    = *data;
//     double current_sample = *(++data);
//     double current_diff   = current_sample - last_sample;
//     double last_diff      = current_diff;
//     
//     double MAX_DIFF = tolerance_multiplier*fabs(last_diff);


    //--------------------------------------------------------
    //  http://www.zlib.net/manual.html#Stream
    // typedef struct z_stream_s {
    //     z_const Bytef *next_in;     /* next input byte */
    //     uInt     avail_in;  /* number of bytes available at next_in */
    //     uLong    total_in;  /* total number of input bytes read so far */
    // 
    //     Bytef    *next_out; /* next output byte will go here */
    //     uInt     avail_out; /* remaining free space at next_out */
    //     uLong    total_out; /* total number of bytes output so far */
    // 
    //     z_const char *msg;  /* last error message, NULL if no error */
    //     struct internal_state FAR *state; /* not visible by applications */
    // 
    //     alloc_func zalloc;  /* used to allocate the internal state */
    //     free_func  zfree;   /* used to free the internal state */
    //     voidpf     opaque;  /* private data object passed to zalloc and zfree */
    // 
    //     int     data_type;  /* best guess about the data type: binary or text
    //                            for deflate, or the decoding state for inflate */
    //     uLong   adler;      /* Adler-32 or CRC-32 value of the uncompressed data */
    //     uLong   reserved;   /* reserved for future use */
    // } z_stream;


    z_stream strm;
    
    strm.zalloc = Z_NULL; //We shouldn't need to allocate ...
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.avail_in = Z_NULL; //TODO: This needs to be set ...
    strm.next_in = Z_NULL; //TODO: This is a a pointer to the input data
    
    //Next output bytes go here ...
    strm.avail_out = Z_NULL; //TODO
    strm.next_out = Z_NULL; //TODO: Bytes for output ...
    int ret = inflateInit(&strm);
    if (ret != Z_OK){
        mexErrMsgIdAndTxt("SL:same_diff:call_error","The input array must be of type double");
    }
    
    
// // // // //     ret = inflate(&strm, Z_NO_FLUSH);
// // // // //     assert(ret != Z_STREAM_ERROR);  /* state not clobbered */
// // // // //     switch (ret) {
// // // // //     case Z_NEED_DICT:
// // // // //         ret = Z_DATA_ERROR;     /* and fall through */
// // // // //     case Z_DATA_ERROR:
// // // // //     case Z_MEM_ERROR:
// // // // //         (void)inflateEnd(&strm);
// // // // //         return ret;
// // // // //     }
    
//     nErr= inflate( &zInfo, Z_FINISH );
    
    //This is the no error case ...
//     if ( nErr == Z_STREAM_END ) {
//         nRet= zInfo.total_out;
//     }
    
    
//     zInfo.total_in =  zInfo.avail_in=  nLenSrc;
//     zInfo.total_out=0;
//     zInfo.avail_out= nLenDst;
//     zInfo.next_in= (BYTE*)abSrc;
//     zInfo.next_out= abDst;

    
    //http://www.zlib.net/zpipe.c
    
    /* clean up and return */
    (void)inflateEnd(&strm);
    //return ret == Z_STREAM_END ? Z_OK : Z_DATA_ERROR;
    

    
    //--------------------------------------------------------

    
}