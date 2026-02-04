Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE1DEE9D40F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 18:17:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0AC66B0089; Wed,  4 Feb 2026 13:17:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE2C16B0092; Wed,  4 Feb 2026 13:17:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE1BE6B0093; Wed,  4 Feb 2026 13:17:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BE0C36B0089
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 13:17:20 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 26C47C1709
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:17:20 +0000 (UTC)
X-FDA: 84407581440.09.A621274
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id C7DBA8000E
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:17:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QIBSbWK0;
	spf=pass (imf30.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770229037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=viN+xgaqkngX+K+Ki2JrCSTJd9J+iu7vc82wk52Dt7E=;
	b=7oNVfe1a1bWmOfxtQ0lNr63dMgPEn81Ed0PeXdXBSFWNipc2kMUwilrvfjQkJpXBcQ4OFw
	Z1cfweLCEzrHysleBQGjX/wy4L+4VVFOO9bVlBAd9/XcNsRvzuS13XEpYQo2A3ht+Ih7nv
	GfndaZ4+yrtc+8lMJR8993GJ2gkGBjE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QIBSbWK0;
	spf=pass (imf30.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770229037; a=rsa-sha256;
	cv=none;
	b=k96HvtOFGGvLHz9TKK/ejPR7bE18V1oSRKVvHL3OhPm8xy6rEGGjbLwdVZi+/QmX8JbpOx
	iaB74pzlg1NXiRLa9uzWLCg6I66qp4m3Mr3RXCSAGRPBJw0w8zteS4JQkExDKOHP02SsHT
	FnJWISE9OtZkmFcE/LX/FnDftzP6mKU=
Date: Wed, 4 Feb 2026 18:17:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770229034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=viN+xgaqkngX+K+Ki2JrCSTJd9J+iu7vc82wk52Dt7E=;
	b=QIBSbWK0OGIOVi3bDhEBY2yTgf7pXHUkaKFMzb0vm67PVYmhrfm3HJUsqSiZZ8dT1sDUOx
	3Fiz5qOTmO0QQQRuqfOGDwZbotufRCmP2mKIha/PH+5gD7BQFM0igdRJu+dlcdtY4ewymH
	Gd9h6ZhnGarIzsH3JeDFHm6dm0P8Qdw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, sj@kernel.org, kasong@tencent.com, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, 
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com, surenb@google.com, 
	kristen.c.accardi@intel.com, vinicius.gomes@intel.com, giovanni.cabiddu@intel.com, 
	wajdi.k.feghali@intel.com
Subject: Re: [PATCH v14 26/26] mm: zswap: Batched zswap_compress() for
 compress batching of large folios.
Message-ID: <vxqmbih57lgkh44jnbxsy375m4rtskt7djzeze3hn4jyig6auz@cbwmq45dncbj>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
 <20260125033537.334628-27-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260125033537.334628-27-kanchana.p.sridhar@intel.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: 3xta9fagedocgjemtqgkimwqwhh46fej
X-Rspam-User: 
X-Rspamd-Queue-Id: C7DBA8000E
X-HE-Tag: 1770229036-71471
X-HE-Meta: U2FsdGVkX1/XdedLWgj6I2E6eeM2IuFNjnuKN3viRecLAre1tA/KSlLTKfm2oSJShqTVRy7jX8d8AyjNbPkwZJDHOYlfNQOF+i2yAJduYc+w+gET+/K4697AX/hViAmESsamxZNrhdakatHZcc5WwCG9Rv54WMXHu83QoKIFmRyOP7/PstRIYvL99PqzcK+pUci69g1/o5xXxKmTx///wNqH4XweRK4JN20bGQRvRf3U4U9owmRv0uEB/WoqhBjmBQVniFjhU1BmVQovD2n3K0RCyFdO7eqg7PSmAexMiSdAF/Hw/L/fwn3U8QeDzQOQ9i6C6lrr2WhsYlVvdgUpq8jNUb3FR5wJBcio+aVpAp1IPqLul/7RCR9hIOR08nym47BzY6tGx1C6BHpOkZrntA1aFtz2mHX418j+4PHy8kxNcKr2fdkcCiBdOD42PU2+gUT2BXXi0YqA5iKI+sYOzKw6f3uhVfKgIF18q9kjbaUG5bnG0M1j7gqI1Nrg2m8mSpjvuQEr+mdwLS8//OuyY0r38PI4W2AXSBkeqKnMQhGhchbBMUtYAn1ZNJK8NBaHOevffeyYLJilsdGUrO3/5PvvhQGnli3TwAqenFd7WUcy29tSuMaTp2l2ovtYg5oiPK6qNCYjvgpvTqv/fTUMw+7Luw/nVEh9uUqPH6QqY+HB33lhjhWdTrGuJ8qVYzwMJCdLhh2eITssuIPPikXvfdPVHOaBanzN9p6MmL8KegQ9C8/7ACSVUCPAdjax4jtz+DvfhBboPGRMevQuC9jOsH7MY9AG4MyfMY9w4q+2/49ikbq4I9T7scrE+gmOhDX9P76B+dA+wfjiqwoNGNNvVTzmH3bJTOViR70rIqocGagRdC1M6jNvZ1yL/dDzxur7FD0wxlYKjRkjMaiSOwc7IervOfIkgZavtoo4v1Bx5saMEBxcOgALMTdws2eqZjfEIlsUob7T+AvJQO4Psty
 WOYYXOKA
 Vj0CBRuatdvsf++DS21fULDnIuHcTqjl85bOUpuMLHbNR9xEMn1wPgOT0vmumf2e0HskeX8rAui+BZVjYPdnD5gYLeIm4406KuSEKGArZhoY2/ufEVVnXaYXap7APgazboUl7c3EViM/Yj603LRV688SMGuPhMMw/r9KUpaPK1ud8RLgFiAx+VYITJr9CI4BI6pNLqkyct1DLNEh9u4Jf5EfHZTRJiq+U1YTQSzHE3/BbStsnLu+IDLlDWOwq9dTxnvt4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 24, 2026 at 07:35:37PM -0800, Kanchana P Sridhar wrote:
[..]

I am still not happy with the batching approach in general, but I will
leave that to the other thread with Nhat. Other comments below.

> ---
>  mm/zswap.c | 260 ++++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 190 insertions(+), 70 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 6a22add63220..399112af2c54 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -145,6 +145,7 @@ struct crypto_acomp_ctx {
>  	struct acomp_req *req;
>  	struct crypto_wait wait;
>  	u8 **buffers;
> +	struct sg_table *sg_table;
>  	struct mutex mutex;
>  };
>  
> @@ -272,6 +273,11 @@ static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx, u8 nr_buffers)
>  			kfree(acomp_ctx->buffers[i]);
>  		kfree(acomp_ctx->buffers);
>  	}
> +
> +	if (acomp_ctx->sg_table) {
> +		sg_free_table(acomp_ctx->sg_table);
> +		kfree(acomp_ctx->sg_table);
> +	}
>  }
>  
>  static struct zswap_pool *zswap_pool_create(char *compressor)
> @@ -834,6 +840,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
>  	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
>  	int nid = cpu_to_node(cpu);
> +	struct scatterlist *sg;
>  	int ret = -ENOMEM;
>  	u8 i;
>  
> @@ -880,6 +887,22 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  			goto fail;
>  	}
>  
> +	acomp_ctx->sg_table = kmalloc(sizeof(*acomp_ctx->sg_table),
> +					GFP_KERNEL);
> +	if (!acomp_ctx->sg_table)
> +		goto fail;
> +
> +	if (sg_alloc_table(acomp_ctx->sg_table, pool->compr_batch_size,
> +			   GFP_KERNEL))
> +		goto fail;
> +
> +	/*
> +	 * Statically map the per-CPU destination buffers to the per-CPU
> +	 * SG lists.
> +	 */
> +	for_each_sg(acomp_ctx->sg_table->sgl, sg, pool->compr_batch_size, i)
> +		sg_set_buf(sg, acomp_ctx->buffers[i], PAGE_SIZE);
> +
>  	/*
>  	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
>  	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
> @@ -900,84 +923,177 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  	return ret;
>  }
>  
> -static bool zswap_compress(struct page *page, struct zswap_entry *entry,
> -			   struct zswap_pool *pool, bool wb_enabled)
> +/*
> + * zswap_compress() batching implementation for sequential and batching
> + * compressors.
> + *
> + * Description:
> + * ============
> + *
> + * Compress multiple @nr_pages in @folio starting from the @folio_start index in
> + * batches of @nr_batch_pages.
> + *
> + * It is assumed that @nr_pages <= ZSWAP_MAX_BATCH_SIZE. zswap_store() makes
> + * sure of this by design and zswap_store_pages() warns if this is not true.

These 2 lines are not necessary, the WARN documents it.

> + *
> + * @nr_pages can be in (1, ZSWAP_MAX_BATCH_SIZE] even if the compressor does not
> + * support batching.
> + *
> + * If @nr_batch_pages is 1, each page is processed sequentially.
> + *
> + * If @nr_batch_pages is > 1, compression batching is invoked within
> + * the algorithm's driver, except if @nr_pages is 1: if so, the driver can
> + * choose to call it's sequential/non-batching compress routine.

I think the "except.." part should be dropped? Can we have
nr_batch_pages > nr_pages?

Also, what the driver does is irrelevant here.

We can probably replace the above two sentences with

    * if @nr_batch_pages > 1, the compressor may use batching to
    * optimize compression.

> + *
> + * In both cases, if all compressions are successful, the compressed buffers
> + * are stored in zsmalloc.

This part is unnecessary.

> + *
> + * Design notes for batching compressors:
> + * ======================================
> + *
> + * Traversing SG lists when @nr_batch_pages is > 1 is expensive, and
> + * impacts batching performance if repeated:
> + *   - to map destination buffers to each SG list in @acomp_ctx->sg_table.
> + *   - to initialize each output @sg->length to PAGE_SIZE.
> + *
> + * Design choices made to optimize batching with SG lists:
> + *
> + * 1) The source folio pages in the batch are directly submitted to
> + *    crypto_acomp via acomp_request_set_src_folio().

I think this part is a given, what else would we do?

> + *
> + * 2) The per-CPU @acomp_ctx->sg_table scatterlists are statically mapped
> + *    to the per-CPU dst @buffers at pool creation time.

This is good to document. Although I think documenting it inline where
@acomp_ctx->sg_table is used would be better.

> + *
> + * 3) zswap_compress() sets the output SG list length to PAGE_SIZE for
> + *    non-batching compressors. The batching compressor's driver should do this
> + *    as part of iterating through the dst SG lists for batch compression setup.

Not sure what this is referring to?

> + *
> + * Considerations for non-batching and batching compressors:
> + * =========================================================
> + *
> + * For each output SG list in @acomp_ctx->req->sg_table->sgl, the @sg->length
> + * should be set to either the page's compressed length (success), or it's
> + * compression error value.

Would also be better to move to where it's used (e.g. when iterating the
sglist after compression).

> + */
> +static bool zswap_compress(struct folio *folio,
> +			   long folio_start,
> +			   u8 nr_pages,
> +			   u8 nr_batch_pages,
> +			   struct zswap_entry *entries[],
> +			   struct zs_pool *zs_pool,
> +			   struct crypto_acomp_ctx *acomp_ctx,
> +			   int nid,
> +			   bool wb_enabled)
>  {
> -	struct crypto_acomp_ctx *acomp_ctx;
> -	struct scatterlist input, output;
> -	int comp_ret = 0, alloc_ret = 0;
> -	unsigned int dlen = PAGE_SIZE;
> +	gfp_t gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
> +	unsigned int slen = nr_batch_pages * PAGE_SIZE;
> +	u8 batch_start, batch_iter, compr_batch_size_iter;
> +	struct scatterlist *sg;
>  	unsigned long handle;
> -	gfp_t gfp;
> -	u8 *dst;
> -	bool mapped = false;
> -
> -	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
> -	mutex_lock(&acomp_ctx->mutex);
> -
> -	dst = acomp_ctx->buffers[0];
> -	sg_init_table(&input, 1);
> -	sg_set_page(&input, page, PAGE_SIZE, 0);
> -
> -	sg_init_one(&output, dst, PAGE_SIZE);
> -	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
> +	int err, dlen;
> +	void *dst;
>  
>  	/*
> -	 * it maybe looks a little bit silly that we send an asynchronous request,
> -	 * then wait for its completion synchronously. This makes the process look
> -	 * synchronous in fact.
> -	 * Theoretically, acomp supports users send multiple acomp requests in one
> -	 * acomp instance, then get those requests done simultaneously. but in this
> -	 * case, zswap actually does store and load page by page, there is no
> -	 * existing method to send the second page before the first page is done
> -	 * in one thread doing zswap.
> -	 * but in different threads running on different cpu, we have different
> -	 * acomp instance, so multiple threads can do (de)compression in parallel.
> +	 * Locking the acomp_ctx mutex once per store batch results in better
> +	 * performance as compared to locking per compress batch.
>  	 */
> -	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
> -	dlen = acomp_ctx->req->dlen;
> +	mutex_lock(&acomp_ctx->mutex);
>  
>  	/*
> -	 * If a page cannot be compressed into a size smaller than PAGE_SIZE,
> -	 * save the content as is without a compression, to keep the LRU order
> -	 * of writebacks.  If writeback is disabled, reject the page since it
> -	 * only adds metadata overhead.  swap_writeout() will put the page back
> -	 * to the active LRU list in the case.
> +	 * Compress the @nr_pages in @folio starting at index @folio_start
> +	 * in batches of @nr_batch_pages.
>  	 */
> -	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
> -		if (!wb_enabled) {
> -			comp_ret = comp_ret ? comp_ret : -EINVAL;
> -			goto unlock;
> -		}
> -		comp_ret = 0;
> -		dlen = PAGE_SIZE;
> -		dst = kmap_local_page(page);
> -		mapped = true;
> -	}
> +	for (batch_start = 0; batch_start < nr_pages;
> +	     batch_start += nr_batch_pages) {
> +		/*
> +		 * Send @nr_batch_pages to crypto_acomp for compression:
> +		 *
> +		 * These pages are in @folio's range of indices in the interval
> +		 *     [@folio_start + @batch_start,
> +		 *      @folio_start + @batch_start + @nr_batch_pages).
> +		 *
> +		 * @slen indicates the total source length bytes for @nr_batch_pages.
> +		 *
> +		 * The pool's compressor batch size is at least @nr_batch_pages,
> +		 * hence the acomp_ctx has at least @nr_batch_pages dst @buffers.
> +		 */
> +		acomp_request_set_src_folio(acomp_ctx->req, folio,
> +					    (folio_start + batch_start) * PAGE_SIZE,
> +					    slen);
> +
> +		acomp_ctx->sg_table->sgl->length = slen;
> +
> +		acomp_request_set_dst_sg(acomp_ctx->req,
> +					 acomp_ctx->sg_table->sgl,
> +					 slen);
> +
> +		err = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req),
> +				      &acomp_ctx->wait);
> +
> +		/*
> +		 * If a page cannot be compressed into a size smaller than
> +		 * PAGE_SIZE, save the content as is without a compression, to
> +		 * keep the LRU order of writebacks.  If writeback is disabled,
> +		 * reject the page since it only adds metadata overhead.
> +		 * swap_writeout() will put the page back to the active LRU list
> +		 * in the case.
> +		 *
> +		 * It is assumed that any compressor that sets the output length
> +		 * to 0 or a value >= PAGE_SIZE will also return a negative
> +		 * error status in @err; i.e, will not return a successful
> +		 * compression status in @err in this case.
> +		 */
> +		if (unlikely(err && !wb_enabled))
> +			goto compress_error;
> +
> +		for_each_sg(acomp_ctx->sg_table->sgl, sg, nr_batch_pages,
> +			    compr_batch_size_iter) {
> +			batch_iter = batch_start + compr_batch_size_iter;
> +			dst = acomp_ctx->buffers[compr_batch_size_iter];
> +			dlen = sg->length;
> +
> +			if (dlen < 0) {
> +				dlen = PAGE_SIZE;
> +				dst = kmap_local_page(folio_page(folio,
> +						      folio_start + batch_iter));
> +			}
> +
> +			handle = zs_malloc(zs_pool, dlen, gfp, nid);
> +
> +			if (unlikely(IS_ERR_VALUE(handle))) {
> +				if (PTR_ERR((void *)handle) == -ENOSPC)
> +					zswap_reject_compress_poor++;
> +				else
> +					zswap_reject_alloc_fail++;
>  
> -	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
> -	handle = zs_malloc(pool->zs_pool, dlen, gfp, page_to_nid(page));
> -	if (IS_ERR_VALUE(handle)) {
> -		alloc_ret = PTR_ERR((void *)handle);
> -		goto unlock;
> +				goto err_unlock;
> +			}
> +
> +			zs_obj_write(zs_pool, handle, dst, dlen);
> +			entries[batch_iter]->handle = handle;
> +			entries[batch_iter]->length = dlen;
> +			if (dst != acomp_ctx->buffers[compr_batch_size_iter])
> +				kunmap_local(dst);
> +		}
>  	}
>  
> -	zs_obj_write(pool->zs_pool, handle, dst, dlen);
> -	entry->handle = handle;
> -	entry->length = dlen;
> +	mutex_unlock(&acomp_ctx->mutex);
> +	return true;
>  
> -unlock:
> -	if (mapped)
> -		kunmap_local(dst);
> -	if (comp_ret == -ENOSPC || alloc_ret == -ENOSPC)
> -		zswap_reject_compress_poor++;
> -	else if (comp_ret)
> -		zswap_reject_compress_fail++;
> -	else if (alloc_ret)
> -		zswap_reject_alloc_fail++;
> +compress_error:
> +	for_each_sg(acomp_ctx->sg_table->sgl, sg, nr_batch_pages,
> +		    compr_batch_size_iter) {
> +		if ((int)sg->length < 0) {
> +			if ((int)sg->length == -ENOSPC)
> +				zswap_reject_compress_poor++;
> +			else
> +				zswap_reject_compress_fail++;
> +		}
> +	}
>  
> +err_unlock:
>  	mutex_unlock(&acomp_ctx->mutex);
> -	return comp_ret == 0 && alloc_ret == 0;
> +	return false;
>  }
>  
>  static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
> @@ -1499,12 +1615,16 @@ static bool zswap_store_pages(struct folio *folio,
>  		INIT_LIST_HEAD(&entries[i]->lru);
>  	}
>  
> -	for (i = 0; i < nr_pages; ++i) {
> -		struct page *page = folio_page(folio, start + i);
> -
> -		if (!zswap_compress(page, entries[i], pool, wb_enabled))
> -			goto store_pages_failed;
> -	}
> +	if (unlikely(!zswap_compress(folio,
> +				     start,
> +				     nr_pages,
> +				     min(nr_pages, pool->compr_batch_size),
> +				     entries,
> +				     pool->zs_pool,
> +				     acomp_ctx,
> +				     nid,
> +				     wb_enabled)))
> +		goto store_pages_failed;

Similar to the previous patch, I don't like the huge arg list. Drop args
that don't have to be passed in (e.g. acomp_ctx, nid..), and either drop
unlikely() or use an intermediate variable.

>  
>  	for (i = 0; i < nr_pages; ++i) {
>  		struct zswap_entry *old, *entry = entries[i];
> -- 
> 2.27.0
> 

