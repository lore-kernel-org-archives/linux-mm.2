Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03CEE606A328
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MLB8QlI4
Received: by kanga.kvack.org (Postfix)
	id 1ED1D6B05B0; Thu,  5 Nov 2026 12:29:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19D616B05B1; Thu,  5 Nov 2026 12:29:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B3316B05B2; Thu,  5 Nov 2026 12:29:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6F276B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:29:12 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 74CA340BE7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:29:12 +0000 (UTC)
X-FDA: 85401751344.16.577E05C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id BFC30140003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:29:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MLB8QlI4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793899750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OI82NC+VtO6XCg1b7sL9Mba+LLUc0Oyq52Xd0koXNtA=;
	b=d2qDJppT+uqAjOuLEEpoE3f+HDmpBXaq5gcKcXIxNg+Ry3KP6LCck2ulqv7ZPMZfcrO54M
	kvRu54RyoNLbTfCGmKRkU/7noCjGnRLImNQdx0MTmCqqdN/dAfKOpUPsmIOtxdtXD+k2hf
	2RWvrT6D2Eo7magmgtaRo7y+B2VFl7M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793899750;
	b=38sPwuAA+Lc+bsjG0Goovhdxk0ilE9vscXeVG07F3QQvKaCsZPpVO4OQZAizBnlyBghQCh
	oWe6x+xT/EWMQ8whGz0O8uiiIuqXXet1R8nca10NGgqE3fyTjQ7Fw7UbEWmJAz6Fj3onpw
	yLxfB08T8rUVQXMAoPCt13EL/bhKa9A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MLB8QlI4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EDF8142E71;
	Thu,  5 Nov 2026 17:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4601F000C1;
	Thu,  5 Nov 2026 17:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793899749;
	bh=OI82NC+VtO6XCg1b7sL9Mba+LLUc0Oyq52Xd0koXNtA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MLB8QlI4b9Zj96xuu1gX2RDKKLpHjWgsbP+lWZ/jXYJAgMJaQP0yow/NhM2eVaerw
	 RUl1gWByjCzr+FPSbtEBObL1y9PjsQTmtTwmlt3C1G0K03nDpp9ICWHkhGOPVfaqHB
	 PooUz4IiQUp6OymGCzzlwIav3h+XQsZ9dBMQaLfT0OQ5gleCT87KAcKDSJENdGj+6v
	 YICepRUZDih8ob8KMzawL3S2K4uLzieLoJa5pMxSuWZ4D4TeQBxlIBrBRhPZfZtIr6
	 BamFIJDtq1UNS7fLmn3sr4TxMwc/Bcs8xFc4lHnswt1r7NTA2cohCcWKoJDVZ/iP0e
	 Muxsn+zeGo5Iw==
Date: Thu, 5 Nov 2026 17:29:08 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 6/7] zsmalloc: fold zs_obj_write() into zs_store()
Message-ID: <auy6wQIz89NxpskT@google.com>
References: <20261105044752.1997895-1-senozhatsky@chromium.org>
 <20261105044752.1997895-7-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105044752.1997895-7-senozhatsky@chromium.org>
X-Stat-Signature: qepnfhe9w393dq18buawod6bkw8fg1tt
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BFC30140003
X-HE-Tag: 1793899750-15256
X-HE-Meta: U2FsdGVkX1/tIe0o6Sk7cMEbcHsibi+3+P9EaO2dGueohZz1seNyUSzfoxTLzAId7BdwPPjH75vmR831rVVf1C/pa/kHXnYgt3HD/AfUMJxedlgSS59lzXRqqEexaddYTYe3jxbggl6neYKYgRG01X/sUitd0c5dKR9yeWZnbKSZp0xBnh7LXe09Zx8xsd0ON/LYL7OimpOyjj3n+lmbQ2CeF/Opnwxc0k30A/yvN38Mcw4g/0XyBiTc8aj+laO/btKo1mEX9NhikKjawD4A11AQUjSBHONcfgMH/xT6DnMVyFSJjepkStK7PaOHVz4ONCSq1za8MWeQAWYKzh/o9+JsPawc2b+3tyN91AFoNpxr5VkPNUbLR4sonX2XJQoRfJZLGfIRDlVKHOoSH8OT6x10zcpTSldUYgSCUxavTLHwZelKHOsCg7bBnG8RNvCFJZkh6rMkbF1XEDnRxT/kDxN1267YNh2yejR0pxDH+u9AcmnJKYmk8ojUzdL6NriID5SgFw8Jr3fvvixpGWwI2E8mY4WECp62wGNnJP8HPGAJwZIZwIEhxuDls0T+lAfDxJsSqIdwOt/I1zXx48HYvhg+m6P4d1TQ40d0DMm3LotVO7jqUEUzutOtAKxZU91blD8yrLjv5zOkhD42DddR98zkWovlEx+0DmtGecjZNtcSg455iXp5YoUtSjoskXpuncKa33gXNq5iKyjy5Mh1OZIaGAQ2lKl8tZZjUJj6PvUr0NyIjg4e/J6W6j14LtZY0fhc7R9wObi78LcrQ/FhSmnf/SXCycMq67hs5zaxaP9GcLpg0fYnxW0ob+jy9JaiHX4u6n5x9imKymrfP5AvL31/MYvt1mhmqZUk+hq8o2NmyPdSFZ2skpM13slrM/vi/4/sCK0s6veQWEFU5jNAief7S+ip4oGyGDt8jHDSbIjOtrPlEeMAFCqSjfzY5vsXUbisWj+BTTChNKX+e5T
 D1u6+Ofu
 ogaTDQAmZI4Pb6v4gu9FyAj0+8toeE/0+exByo4tKQyTHiz85T9Yt1wMOzSY9pkQaMbLhcRp4r1CYiUOASSEIZsinTJCcFbK4dDU2bvmCKm5Dt9HwPIFnAMJ23kjC2fjtkMasRt5Bxrb6X5nIt4lwUFyyseTvOvY+kU8fYjxKuch0jIHi+YRurLLrJHaID4wbtlFARNHvDmeQ7FO/zQLYyO4H2KXsm2eQFLb81rnT4tkMfpKDWRzxX8oCfEhEaavp3n5DsXAnIH/l3tG0QRM105QhmdXqL5ZH+w7fd63+ccfI/eg04b/SYLcU/SWmOxqWaLmKpJ/Q+oMDXwX+xU+QsrpcmjWF7DW7iithSlbwV4Rj1Iw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 01:47:36PM +0900, Sergey Senozhatsky wrote:
> zram and zswap always call zs_obj_write() right after zs_malloc(), and
> zs_obj_write() has to take pool->lock and look up object location
> again, which zs_malloc() just did.
> 
> Replace zs_malloc() and zs_obj_write() with one single zs_store()
> call.
> 
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> ---
>  Documentation/core-api/memory-allocation.rst |  2 +-
>  Documentation/mm/zsmalloc.rst                |  4 +-
>  drivers/block/zram/zram_drv.c                | 43 ++++++-----------
>  include/linux/zsmalloc.h                     |  6 +--
>  mm/zsmalloc.c                                | 51 +++++++++-----------
>  mm/zswap.c                                   |  5 +-
>  6 files changed, 46 insertions(+), 65 deletions(-)
> 
> diff --git a/Documentation/core-api/memory-allocation.rst b/Documentation/core-api/memory-allocation.rst
> index 648222b6c857..5069ac72b857 100644
> --- a/Documentation/core-api/memory-allocation.rst
> +++ b/Documentation/core-api/memory-allocation.rst
> @@ -9,7 +9,7 @@ allocate small chunks using `kmalloc` or `kmem_cache_alloc` families,
>  large virtually contiguous areas using `vmalloc` and its derivatives,
>  or you can directly request pages from the page allocator with
>  `alloc_pages`. It is also possible to use more specialized allocators,
> -for instance `cma_alloc` or `zs_malloc`.
> +for instance `cma_alloc` or `zs_store`.
>  
>  Most of the memory allocation APIs use GFP flags to express how that
>  memory should be allocated. The GFP acronym stands for "get free
> diff --git a/Documentation/mm/zsmalloc.rst b/Documentation/mm/zsmalloc.rst
> index dbb5c1a8dcc3..52eaba8f97e9 100644
> --- a/Documentation/mm/zsmalloc.rst
> +++ b/Documentation/mm/zsmalloc.rst
> @@ -20,9 +20,9 @@ For simplicity, zsmalloc can only allocate objects of size up to PAGE_SIZE
>  since this satisfies the requirements of all its current users (in the
>  worst case, page is incompressible and is thus stored "as-is" i.e. in
>  uncompressed form). For allocation requests larger than this size, failure
> -is returned (see zs_malloc).
> +is returned (see zs_store).
>  
> -Additionally, zs_malloc() does not return a dereferenceable pointer.
> +Additionally, zs_store() does not return a dereferenceable pointer.

Well, it doesn't return a pointer at all now.

>  Instead, it stores the encoded location of the allocated object in the
>  provided ``struct zs_handle``. The reason for this indirection is that
>  zsmalloc does not keep zspages permanently mapped since that would cause
[..]

> diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
> index 6c76fd10344e..674358f39191 100644
> --- a/include/linux/zsmalloc.h
> +++ b/include/linux/zsmalloc.h
> @@ -48,8 +48,8 @@ struct scatterlist;
>  struct zs_pool *zs_create_pool(const char *name);
>  void zs_destroy_pool(struct zs_pool *pool);
>  
> -int zs_malloc(struct zs_pool *pool, struct zs_handle *handle, size_t size,
> -	      gfp_t flags, const int nid);
> +int zs_store(struct zs_pool *pool, struct zs_handle *handle, const void *src,
> +	     size_t size, gfp_t flags, const int nid);
>  void zs_free(struct zs_pool *pool, struct zs_handle *handle);
>  #ifdef CONFIG_ZSMALLOC_REBIND_HANDLE
>  void zs_rebind_handle(struct zs_pool *pool, struct zs_handle *dst,
> @@ -68,8 +68,6 @@ void zs_pool_stats(struct zs_pool *pool, struct zs_pool_stats *stats);
>  void zs_obj_read_sg_begin(struct zs_pool *pool, struct zs_handle *handle,
>  			  struct scatterlist *sg, size_t mem_len);
>  void zs_obj_read_sg_end(struct zs_pool *pool, struct zs_handle *handle);
> -void zs_obj_write(struct zs_pool *pool, struct zs_handle *handle,
> -		  void *handle_mem, size_t mem_len);
>  
>  extern const struct movable_operations zsmalloc_mops;
>  
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 71e6dcb1fb3f..ff1cde4c5dc2 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -1172,26 +1172,15 @@ void zs_obj_read_sg_end(struct zs_pool *pool, struct zs_handle *handle)
>  }
>  EXPORT_SYMBOL_GPL(zs_obj_read_sg_end);
>  
> -void zs_obj_write(struct zs_pool *pool, struct zs_handle *handle,
> -		  void *handle_mem, size_t mem_len)
> +static void obj_write(struct size_class *class, struct zspage *zspage,
> +		      unsigned long obj, const void *handle_mem,
> +		      size_t mem_len)

Should handle_mem and mem_len be renamed now?

Also, there's a comment in zs_page_migrate() referring to zs_obj_read/write().

>  {
> -	struct zspage *zspage;
>  	struct zpdesc *zpdesc;
> -	unsigned long obj, off;
> +	unsigned long off;
>  	unsigned int obj_idx;
> -	struct size_class *class;
>  
> -	/* Guarantee we can get zspage from handle safely */
> -	read_lock(&pool->lock);
> -	obj = handle_to_obj(handle);
>  	obj_to_location(obj, &zpdesc, &obj_idx);
> -	zspage = get_zspage(zpdesc);
> -
> -	/* Make sure migration doesn't move any pages in this zspage */
> -	zspage_read_lock(zspage);
> -	read_unlock(&pool->lock);
> -
> -	class = zspage_class(pool, zspage);
>  	off = offset_in_page(class->size * obj_idx);
>  
>  	if (!ZsHugePage(zspage))
[..]
  
> @@ -1318,12 +1306,16 @@ int zs_malloc(struct zs_pool *pool, struct zs_handle *handle, size_t size,
>  	spin_lock(&class->lock);
>  	zspage = find_get_zspage(class);
>  	if (likely(zspage)) {
> -		obj_malloc(pool, zspage, handle);
> +		obj = obj_malloc(pool, zspage, handle);
>  		/* Now move the zspage to another fullness group, if required */
>  		fix_fullness_group(class, zspage);
>  		class_stat_add(class, ZS_OBJS_INUSE, 1);
> +		zspage_read_lock(zspage);

The zspage lock is now acquired under the class lock instead of the pool
lock, this is probably fine but worth calling out explicitly in the
changelog.

> +		spin_unlock(&class->lock);
>  
> -		goto out;
> +		obj_write(class, zspage, obj, src, size);
> +		zspage_read_unlock(zspage);
> +		return 0;
>  	}
>  
>  	spin_unlock(&class->lock);
> @@ -1332,8 +1324,14 @@ int zs_malloc(struct zs_pool *pool, struct zs_handle *handle, size_t size,
>  	if (!zspage)
>  		return -ENOMEM;
>  
> +	/*
> +	 * New zspage is not in class->fullness_list or movable yet, so we
> +	 * can allocate the object and copy data before taking class->lock.
> +	 */
> +	obj = obj_malloc(pool, zspage, handle);
> +	obj_write(class, zspage, obj, src, size);
> +
>  	spin_lock(&class->lock);
> -	obj_malloc(pool, zspage, handle);

Should moving obj_malloc() and obj_write() outside class->lock (and
skipping zspage_read_lock()) for new zspages be split into a separate
patch on top? AFAICT, it's a separate change from merging the
interfaces.

>  	newfg = get_fullness_group(class, zspage);
>  	insert_zspage(class, zspage, newfg);
>  	atomic_long_add(class->pages_per_zspage, &pool->pages_allocated);

