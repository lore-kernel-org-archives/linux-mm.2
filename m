Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3E5F606A9E2
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JrJzy7hf
Received: by kanga.kvack.org (Postfix)
	id 490CE6B05B7; Tue, 10 Nov 2026 11:58:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41F586B05B8; Tue, 10 Nov 2026 11:58:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B9C26B05B9; Tue, 10 Nov 2026 11:58:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F2ACF6B05B7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:58:00 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9026B1A09EB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:58:00 +0000 (UTC)
X-FDA: 85419816720.11.BB1021A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id EB3D140004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:57:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JrJzy7hf;
	spf=pass (imf12.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794329879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=he0nLvBGCDN8uqNcjTTM0VHtxOcySMAUdvuWZ5SeqT8=;
	b=zDIafqGjxkckoASgrlv5jJvWTjt/y/DPVYR13AyXX8JNbOTMk4p47Bu79DnIKbhh+iRBRK
	19TRlGsfvBqTc+uxnjr/VNXTiNivqtcro375jZhzYmP3Tqq0TDP0W7/jPKKki/WjayNea/
	V3tXxaVrZlVTKc7FeCFA3HYuhBxbZns=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794329879;
	b=DXXgJHIXASzdkS7LvzkS9lW42ESTbX5UH30Cvr9CtE7x8BP31gZwAMa7YhVjvfm8Ws/3RD
	v6Z+yNPtIJaAfIOsoZTnBCmBmN2yuxBZMmMuLw/EXLp6JOJkAc4UNmF3+Va55bncwitE7h
	fo++ZQi0zDUy3M0tjbESx6A99dwm8Dw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JrJzy7hf;
	spf=pass (imf12.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 791B963A86;
	Tue, 10 Nov 2026 16:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE40D1F008A6;
	Tue, 10 Nov 2026 16:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794329878;
	bh=he0nLvBGCDN8uqNcjTTM0VHtxOcySMAUdvuWZ5SeqT8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JrJzy7hfvYhnswLWixpqtp3vtRIm615A8irbRopyLbtLZhLpctLfiWiJExN8odzXq
	 Ox6jFSj1mIc9nbGMGB7xtcyqCaCDtOnVHMGj4dsGzou1lJgcNnOcazLMncEKBvHb2j
	 dKQI+UgsjSTlxKTfBh5+1K4D9aEhGc8a5Ha1FQqUSxyZQMb7A9jc1V726myR1T5qqj
	 V4vfUgOb9Qw/WChXpJbLULMTypa6qlIr/ByOspZkkQz+aHng+8tT28XQTzpoRcPzR+
	 qlCmnF8KXwMCBCknw8xFdv+6LfJTQQ00ikIpG4oTbAHMkT2+/ZwioYZCsFENxjLLhb
	 9rxEjA8fkYOTg==
Date: Tue, 10 Nov 2026 16:57:56 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 09/11] zsmalloc: embed struct zs_handle into zram and
 zswap entries
Message-ID: <avNMwoleXeYGz2CT@google.com>
References: <20261110054836.1515030-1-senozhatsky@chromium.org>
 <20261110054836.1515030-10-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110054836.1515030-10-senozhatsky@chromium.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EB3D140004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 83etnqpkzet86rdkypfzfc96r6a86o6z
X-Rspam-User: 
X-HE-Tag: 1794329878-260312
X-HE-Meta: U2FsdGVkX18dnmaGl/CuY8BfA6EdgF0jnAxIAn36Lw+zCSzfxz0mFL2JOu3n+/2DKZVs+lGogpdjdrG8YdxaJRRgzWFx3SYm6xAJ4grPGXoPWdnG3fpz3ZE+G/qKgHxkGjMyxiBxNXzgiyRj5w2eqbVs4OvN+D4WeFwPQtI8Ac1d3oPY63eejgM02P/UrFCWk7SYtCIkh497tUt7Qdww0x4H4Ti0lD9E06WpTyjUtje6BEC2eFJSOSxCHCLqxtdMnMrZ6HyEU6qNBiskkIm2KlN+LBkYfm0z5ccBAeGFlmvhtEz9yQ61c6qk7ZtZruIgoRLKIb1nR9U8cKijz6yhF6xtMuftI69H2zwrtA9C6OhznkgKeNlO8lo4A1jJ2yq7VnSy4fPC2gN2hkjxa4ilm7SwA0QZ1pxOryAwbc8/ufKGZsIUNGMJrsioFjwtKINgzlZHgn7+FMHg9sVDu4YIpeHNX8/ioJg/0PZFPoXcz7XYMPpAsk0e6ZsnHJ3SGiW707goNV9KSZ290CYPXsRTzBs3cynZT9SpdjbJFd0C4nFHFNg1mvOldNMPk3HKVkhfzOy/ofdQ5CcwuqUHtB539HuB2M5vHbbKSWpCOuPrpRW13kwUrFFOjkCrIW+WDJTzCm60ooa3piYauEG7ita4LTw07XTUhDQZoD3D1sGov3gZrw9RaQf4CjTnOT90p0LFDBiU6fJNgobAISgFu275Hr5pJYzly5UayD/CgvDp3ZPsZpozT0XZLbkmXkH2sYY1hTn4I5+WM5hg7VPa2yj2BFryTqgdRkGpt6dht1vccokwglbDldaghDHAeJ3pXxo2Z5ZTdEkRluHw1neuWKZwbmo1gWepRVBI9jpy39iEIK4G2kugNDHXcHArewk3dLzYpr9lYPjr/ZrjyeMoGx0eGJxl45ZY2uFVUzrMi/h1zagfC+wpo0NZKM6SjIBLINTQU65WNOZoWIbZ0b3B0Mp
 SO+BAh0g
 jjKyzeCGHwMwkq53oNire2gQNehlrX1Ty20cg7nh2DLVXwxQsFz5zuDwV3m9qiQPJiM9KEgMYDRT7/gCRqus+2+H2uPUdFRb4PY3K0jFf67bx6dM5EMyX4/Q4oqhi8DbvjxW2s8IzMA2aVdGrLOm2e++ByKcwWYIfJCyqcf7p3YW8JvD6+e5uAUqucZTb53fxSfr4OE5EThI5e0GScvhIXRsP5soXkAeIp6eTETCe9N+QlczDMNFdqco4S2XeUjkAnsB8WIxLhFbDoIzVO46UHQmKhSjfyMoDzryjnwdv2xc1ukBXZRjKgpuK2/rhi2g2t2rCTQ9NMiLbEvqoM2/r8jcb4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 02:48:14PM +0900, Sergey Senozhatsky wrote:
> zsmalloc allocates an object from handle_cachep for every stored
> object, just to have a stable address which compaction and page
> migration can update when the object moves.  Both zram and zswap
> already have per-entry structures that hold the handle, so we basically
> keep a pointer to a pointer, which costs 8 bytes per stored object,
> slab alloc/free on every store and free, and one more memory load on
> every access.
> 
> Make struct zs_handle public and embed it into zram_table_entry and
> zswap_entry (their sizes don't change), so that zsmalloc writes object
> location directly there, and remove handle_cachep.  zs_malloc() now
> takes a handle pointer and returns an error code, zs_free() resets the
> handle.
> 
> Since compaction and migration update the handle in place, it must be
> naturally aligned, must not be on the stack (zs_malloc() warns about
> both), must not be copied, and must stay allocated until zs_free() or
> zs_rebind_handle().  zram recompression allocates a new object before
> it frees the old one, so it uses zram->recomp_handle, protected by
> ->dev_lock, and zs_rebind_handle() moves the new object to the slot
> handle.  zram recompression is the only user of zs_rebind_handle().
> 
> This saves 8 bytes per stored page, e.g. 2MB per 1GB of swapped out
> 4K pages.  Since handle is per-entry the memory savings scale.
> 
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> ---
>  Documentation/admin-guide/mm/slab.rst |   2 +-
>  Documentation/mm/zsmalloc.rst         |  18 ++--
>  drivers/block/zram/zram_drv.c         |  70 ++++++-------
>  drivers/block/zram/zram_drv.h         |   6 +-
>  include/linux/zsmalloc.h              |  29 +++++-
>  mm/zsmalloc.c                         | 144 ++++++++++++++++----------
>  mm/zswap.c                            |  22 ++--
>  7 files changed, 177 insertions(+), 114 deletions(-)

zsmalloc and zswap bits LGTM with a small nit below:

Reviewed-by: Yosry Ahmed <yosry@kernel.org>

[..]
>  
>  /*
> - * Pairs with READ_ONCE() in handle_to_obj(): zs_free() may read the
> - * handle locklessly, so prevent store tearing here.
> + * Pairs with READ_ONCE() in handle_to_obj() and zs_handle_is_allocated():
> + * zs_free(), zs_rebind_handle(), and zs_handle_is_allocated() may read
> + * the handle locklessly, so prevent store tearing here.
>   */
>  static void record_obj(struct zs_handle *handle, unsigned long obj)
>  {
> @@ -1307,31 +1292,37 @@ static unsigned long obj_malloc(struct zs_pool *pool,
>  /**
>   * zs_malloc - Allocate block of given size from pool.
>   * @pool: pool to allocate from
> + * @handle: handle to store allocated object in
>   * @size: size of block to allocate
>   * @gfp: gfp flags when allocating object
>   * @nid: The preferred node id to allocate new zspage (if needed)
>   *
> - * On success, handle to the allocated object is returned,
> - * otherwise an ERR_PTR().
>   * Allocation requests with size > ZS_MAX_ALLOC_SIZE will fail.
> + * zsmalloc keeps a back-pointer to @handle and updates it asynchronously
> + * when the object moves, so @handle must be unsigned-long aligned, must
> + * not be on the stack or modified/copied by the caller, and must remain
> + * allocated until zs_free() or zs_rebind_handle().
> + *
> + * Return: 0 on success, negative error code otherwise.
>   */
> -struct zs_handle *zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp,
> -			    const int nid)
> +int zs_malloc(struct zs_pool *pool, struct zs_handle *handle, size_t size,
> +	      gfp_t gfp, const int nid)
>  {
> -	struct zs_handle *handle;
>  	struct size_class *class;
>  	int newfg;
>  	struct zspage *zspage;
>  
> +	if (WARN_ON_ONCE(!IS_ALIGNED((unsigned long)handle,
> +				     __alignof__(unsigned long)) ||
> +			 object_is_on_stack(handle) ||
> +			 zs_handle_is_allocated(handle)))

Nit: Put this in a helper to reuse in zs_rebind_handle().

> +		return -EINVAL;
> +
[..]  
> +/**
> + * zs_rebind_handle() - Rebind an allocated object to a new handle.
> + * @pool: pool the object belongs to
> + * @dst: unallocated destination handle (must not be on the stack)
> + * @src: source handle that currently owns the object
> + *
> + * Rebinds the object from @src to @dst, updating the object header so
> + * compaction and page migration update @dst instead of @src, and resets
> + * @src.
> + */
> +void zs_rebind_handle(struct zs_pool *pool, struct zs_handle *dst,
> +		      struct zs_handle *src)
> +{
> +	struct size_class *class;
> +	struct zspage *zspage;
> +	struct zpdesc *zpdesc;
> +	struct link_free *link;
> +	unsigned int obj_idx;
> +	unsigned long obj;
> +	unsigned long off;
> +	void *vaddr;
> +
> +	/* Should never happen; bail out rather than corrupting handles */
> +	if (WARN_ON_ONCE(!IS_ALIGNED((unsigned long)dst,
> +				     __alignof__(unsigned long)) ||
> +			 object_is_on_stack(dst) ||
> +			 zs_handle_is_allocated(dst) ||
> +			 !zs_handle_is_allocated(src)))
> +		return;
[..]

