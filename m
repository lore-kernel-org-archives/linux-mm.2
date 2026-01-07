Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F41FD0D163
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 18:57:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB66E6B0092; Wed,  7 Jan 2026 13:57:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8E956B0093; Wed,  7 Jan 2026 13:57:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C5336B0095; Wed,  7 Jan 2026 13:57:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8CA766B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 13:57:25 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 26E5F8AE4B
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 18:57:25 +0000 (UTC)
X-FDA: 84306076050.25.0FF9CFF
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1787040009
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 18:57:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CMkUXEAY;
	spf=pass (imf07.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767812243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gzvQEjvJ1nzCkckYF+R3TxyHT/zA5TN2rQBRz+o11wM=;
	b=sRUqciRIBhoTsbBwi8i+tXXUFD5vvNui8NNCYheDzKHe76QZ2AMcVkNRTZAzOyH4oaYNaf
	jnwSmzVEKrNmrJdXODUy+jifXlvuKifjD9Jp5WY/LwCAx4+o8YDKdoZYoXELBPYwju9vWy
	G38LHfb6+jwoEpmfRZauz8Vphn3NQM4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CMkUXEAY;
	spf=pass (imf07.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767812243; a=rsa-sha256;
	cv=none;
	b=i37m/FZdPbjWhBOncgghj6BomER2bp9CHcmH3D2BJC4V7z6/frN9lJPP+oEWouOhYR1Sk/
	cROUmFO5SuCzVt+2roqbRRCUjGrPU4axEJqDCicMEBIUNVVjiC01Ttg10MfWKk98CBmwcv
	A/YWwA8+Kjv/YgMcPszmyHn10qDSWfY=
Date: Wed, 7 Jan 2026 18:57:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767812241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gzvQEjvJ1nzCkckYF+R3TxyHT/zA5TN2rQBRz+o11wM=;
	b=CMkUXEAYYNqBxYcZXulSyp716iBza11gQXm+bUQI4z4VwXkRiJf6OZnJQmUsISyiYVoq/F
	I6lhOv9BodFQekf3nN14RJIgN/mMSkL9poHXIM9Sykf6ISsKffeBx1fM9Kra5m/DA8Y6bt
	yj8yBoLJqiZNoAh57EyqRdK46QY2d2g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCHv2 1/2] zsmalloc: use actual object size to detect spans
Message-ID: <dvdaf3cuwvk332nvds46uqqvpoo46bf34zgqorpq4ldwxjo7sk@uh5v5bn5nrab>
References: <20260107052145.3586917-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107052145.3586917-1-senozhatsky@chromium.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1787040009
X-Stat-Signature: 77wpcrwzzxnfjchnz44uf83ijo4gbxcq
X-Rspam-User: 
X-HE-Tag: 1767812242-67393
X-HE-Meta: U2FsdGVkX1+2HDVxYbSAYABmJgCKrgVdUap9+TI4IZOZ7abNLfhoGiTDT58vq/ufiNr691gEJnoTGq+Eror7Yq7oi1coUM52l0ll67CWkCBIRzj4IblLXVnZSq9HJTVnWferdkGMuP9K+YdBOq1bv7Pjzr4tKQmKSUWzSDpkUZmCJrrwbRf1Wb/tCiGtu9U/RPMWCgb1JjPkH2NWrDCpU4g3O9qEB6Xzyy+EqI4XRRopRpi9UadF9l4RC20UnZQnb2UC8HpZq0LTnKHhx4oPJhHFWgLMFYi51eKI+3xOSjsQ4ilhnAZm5Lu6lxaa9kD/TFgjUTfryR+KYJb15rG9W4/KLWvROQRBv2WhHUvdeagGUL/Db3L4z05ZRoF2HZFDz1TRgg1dUxZE3wlZPHa1c/d8EAzVTzl+AROYHYMX90HXg6TagKgyNPpkZbTf7HyvBuxOATCbha0D7xiWElnsqiBMdwmosrWtix8EQtcej+3DF2Pj8ZMN3SscgMLcdjViEfP3cR2+OjJYuHDV6FBa5zF/I6AeurkTaIDb4A5+IgX6OACtauXjRb1A9/5FjPBdrSN83X6TrwRMqKUksYOJSvpbOBj58tS5NSm03ASZMKlkbRaF8qTAEN71d7sIYI6LaKRjDqq9Lc839UI8zmbOF3sb6b0sH9nqTQ5OywfWHaF1XQ5QThbxLr3/8R+B7OqvcGhLBC01/hIquCkIr5yx6muvNSY/ppqaOG+WHCUawBax5wSNUs08cFD2vG3OMT9ZLEULPCaaKj+F/5M6dLQ0JDGTymLKqK7q4OlfizJS9wDdefIskDjk/6vIogGJDYTuld8HZ5cH3gPZmO0jQXisdGxdfJiGGpo8CT2om28gP/B8dZCB3+gDW1mOcQ09egiQc42X4PjuWZDna4HPd0C2c9RUPYgoThPJRzmzo8+SxjmzJ2j4An5KGS4x6YC52wtXRgdkQduNG2PoVVx5M3H
 57AgQxzI
 63NIL7KRxByQvCrw+A/yeeu0k4TlVwyqt2d/qzyXBbheFVJa2XKdHd5WEWj0iPFLxKOpZEx4H3jRH4TY6pPlwVNn1YfaNcqQimdb0AFDm1m/xPyY4i56sBqrQubhMyiXpTyUR/319Cw4XFSy9KqM13+7dSGkL4yLs6wJ7qJ8Ot3yZn6tl8sfoMj/P2vpZrKN08yT/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 02:21:44PM +0900, Sergey Senozhatsky wrote:
> Using class->size to detect spanning objects is not entirely correct,
> because some size classes can hold a range of object sizes of up to
> class->size bytes in length, due to size-classes merge.  Such classes
> use padding for cases when actually written objects are smaller than
> class->size.  zs_obj_read_begin() can incorrectly hit the slow path
> and perform memcpy of such objects, basically copying padding bytes.
> Instead of class->size zs_obj_read_begin() should use the actual
> compressed object length (both zram and zswap know it) so that it can
> correctly handle situations when a written object is small enough to
> fit into the first physical page.
> 
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

For zsmalloc and zswap bits:
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
> 
> v1->v2:
> - use mem_len for second memcpy size calculation (Yosry)
> - simplified read_begin/end logic (Yosry)
> 
>  drivers/block/zram/zram_drv.c | 14 ++++++++------
>  include/linux/zsmalloc.h      |  4 ++--
>  mm/zsmalloc.c                 | 16 +++++++++++-----
>  mm/zswap.c                    |  5 +++--
>  4 files changed, 24 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index a6587bed6a03..76a54eabe889 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -2065,11 +2065,11 @@ static int read_incompressible_page(struct zram *zram, struct page *page,
>  	void *src, *dst;
>  
>  	handle = get_slot_handle(zram, index);
> -	src = zs_obj_read_begin(zram->mem_pool, handle, NULL);
> +	src = zs_obj_read_begin(zram->mem_pool, handle, PAGE_SIZE, NULL);
>  	dst = kmap_local_page(page);
>  	copy_page(dst, src);
>  	kunmap_local(dst);
> -	zs_obj_read_end(zram->mem_pool, handle, src);
> +	zs_obj_read_end(zram->mem_pool, handle, PAGE_SIZE, src);
>  
>  	return 0;
>  }
> @@ -2087,11 +2087,12 @@ static int read_compressed_page(struct zram *zram, struct page *page, u32 index)
>  	prio = get_slot_comp_priority(zram, index);
>  
>  	zstrm = zcomp_stream_get(zram->comps[prio]);
> -	src = zs_obj_read_begin(zram->mem_pool, handle, zstrm->local_copy);
> +	src = zs_obj_read_begin(zram->mem_pool, handle, size,
> +				zstrm->local_copy);
>  	dst = kmap_local_page(page);
>  	ret = zcomp_decompress(zram->comps[prio], zstrm, src, size, dst);
>  	kunmap_local(dst);
> -	zs_obj_read_end(zram->mem_pool, handle, src);
> +	zs_obj_read_end(zram->mem_pool, handle, size, src);
>  	zcomp_stream_put(zstrm);
>  
>  	return ret;
> @@ -2114,9 +2115,10 @@ static int read_from_zspool_raw(struct zram *zram, struct page *page, u32 index)
>  	 * takes place here, as we read raw compressed data.
>  	 */
>  	zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_COMP]);
> -	src = zs_obj_read_begin(zram->mem_pool, handle, zstrm->local_copy);
> +	src = zs_obj_read_begin(zram->mem_pool, handle, size,
> +				zstrm->local_copy);
>  	memcpy_to_page(page, 0, src, size);
> -	zs_obj_read_end(zram->mem_pool, handle, src);
> +	zs_obj_read_end(zram->mem_pool, handle, size, src);
>  	zcomp_stream_put(zstrm);
>  
>  	return 0;
> diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
> index f3ccff2d966c..5565c3171007 100644
> --- a/include/linux/zsmalloc.h
> +++ b/include/linux/zsmalloc.h
> @@ -40,9 +40,9 @@ unsigned int zs_lookup_class_index(struct zs_pool *pool, unsigned int size);
>  void zs_pool_stats(struct zs_pool *pool, struct zs_pool_stats *stats);
>  
>  void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
> -			void *local_copy);
> +			size_t mem_len, void *local_copy);
>  void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
> -		     void *handle_mem);
> +		     size_t mem_len, void *handle_mem);
>  void zs_obj_write(struct zs_pool *pool, unsigned long handle,
>  		  void *handle_mem, size_t mem_len);
>  
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 84da164dcbc5..119c196a287a 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -1065,7 +1065,7 @@ unsigned long zs_get_total_pages(struct zs_pool *pool)
>  EXPORT_SYMBOL_GPL(zs_get_total_pages);
>  
>  void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
> -			void *local_copy)
> +			size_t mem_len, void *local_copy)
>  {
>  	struct zspage *zspage;
>  	struct zpdesc *zpdesc;
> @@ -1087,7 +1087,10 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
>  	class = zspage_class(pool, zspage);
>  	off = offset_in_page(class->size * obj_idx);
>  
> -	if (off + class->size <= PAGE_SIZE) {
> +	if (!ZsHugePage(zspage))
> +		mem_len += ZS_HANDLE_SIZE;
> +
> +	if (off + mem_len <= PAGE_SIZE) {
>  		/* this object is contained entirely within a page */
>  		addr = kmap_local_zpdesc(zpdesc);
>  		addr += off;
> @@ -1096,7 +1099,7 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
>  
>  		/* this object spans two pages */
>  		sizes[0] = PAGE_SIZE - off;
> -		sizes[1] = class->size - sizes[0];
> +		sizes[1] = mem_len - sizes[0];
>  		addr = local_copy;
>  
>  		memcpy_from_page(addr, zpdesc_page(zpdesc),
> @@ -1115,7 +1118,7 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
>  EXPORT_SYMBOL_GPL(zs_obj_read_begin);
>  
>  void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
> -		     void *handle_mem)
> +		     size_t mem_len, void *handle_mem)
>  {
>  	struct zspage *zspage;
>  	struct zpdesc *zpdesc;
> @@ -1129,7 +1132,10 @@ void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
>  	class = zspage_class(pool, zspage);
>  	off = offset_in_page(class->size * obj_idx);
>  
> -	if (off + class->size <= PAGE_SIZE) {
> +	if (!ZsHugePage(zspage))
> +		mem_len += ZS_HANDLE_SIZE;
> +
> +	if (off + mem_len <= PAGE_SIZE) {
>  		if (!ZsHugePage(zspage))
>  			off += ZS_HANDLE_SIZE;
>  		handle_mem -= off;
> diff --git a/mm/zswap.c b/mm/zswap.c
> index de8858ff1521..a3811b05ab57 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -937,7 +937,8 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
>  	u8 *src, *obj;
>  
>  	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
> -	obj = zs_obj_read_begin(pool->zs_pool, entry->handle, acomp_ctx->buffer);
> +	obj = zs_obj_read_begin(pool->zs_pool, entry->handle, entry->length,
> +				acomp_ctx->buffer);
>  
>  	/* zswap entries of length PAGE_SIZE are not compressed. */
>  	if (entry->length == PAGE_SIZE) {
> @@ -966,7 +967,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
>  	dlen = acomp_ctx->req->dlen;
>  
>  read_done:
> -	zs_obj_read_end(pool->zs_pool, entry->handle, obj);
> +	zs_obj_read_end(pool->zs_pool, entry->handle, entry->length, obj);
>  	acomp_ctx_put_unlock(acomp_ctx);
>  
>  	if (!decomp_ret && dlen == PAGE_SIZE)
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 

