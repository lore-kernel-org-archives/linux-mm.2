Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D451CF6BA0
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 00:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEA496B0005; Tue,  6 Jan 2026 19:23:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D97F16B008A; Tue,  6 Jan 2026 19:23:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7A356B0092; Tue,  6 Jan 2026 19:23:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B3D266B0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 19:23:38 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 45A5E16106D
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 00:23:38 +0000 (UTC)
X-FDA: 84303269316.06.1461804
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf10.hostedemail.com (Postfix) with ESMTP id 52FE3C0008
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 00:23:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SSROjr+y;
	spf=pass (imf10.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767745416; a=rsa-sha256;
	cv=none;
	b=cGEPUsampU+c5Bho1v6kPRC4nI3iSQrN1p4wC5LC6mkFA3RPconv6ih8B0AlXGzD9xwbJG
	MoO7JAgY7AE58q7MhJcUZBkD9pA5ecS3OOfw2weEL1czIzFq4i2/CRLjb0UnSUNO9CzVru
	EbumzocepEvNKFBkguzAMke/l6TXGYg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SSROjr+y;
	spf=pass (imf10.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767745416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FmdecdtvZ+5rZWX0TP6GzhmOnnBdq5eS8Hoyr6j3pp0=;
	b=NR/Lvo1TeRLuHATg9l0hKlePU8/VE2fX9I6p8CDufVielTk+8zrcA3lNvc6wN3/n7q/aHH
	z2aoYv1RpuYfkcxxEYVjf+FmiQSIGIILEs8o4dNyKsCvwUhfzL5PFTkEko7+UygeMoL3/w
	JcUD5ZnZrKa5nPSbkX2+S0/R5BP0mGY=
Date: Wed, 7 Jan 2026 00:23:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767745414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FmdecdtvZ+5rZWX0TP6GzhmOnnBdq5eS8Hoyr6j3pp0=;
	b=SSROjr+yn+Jk1ptfRrfrp2fUwRteSpneb2Ab+GY/qmw7gP4nu+jY1q/HlF6abs203LjZza
	zXzXvroEVsMlWg5dK6piJfTo3AY6WNOESIUsY38Ot5F7ZN2ByqRLYyapiGXnDhF2s6aXBu
	vseePjg2/AUBmG6JDu7RszNs35Nta9o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH] zsmalloc: use actual object size to detect spans
Message-ID: <qh2p3k5c2ulb5g2zmckhrm4o2eoruatb5lnumkrwrvmsxwcn3s@nh5vx4kjn5in>
References: <20260106042507.2579150-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106042507.2579150-1-senozhatsky@chromium.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 52FE3C0008
X-Rspamd-Server: rspam04
X-Stat-Signature: 5zyp7n4kfoz3z6ohy6gs9n9byypi148k
X-HE-Tag: 1767745416-93079
X-HE-Meta: U2FsdGVkX1/TgPSGaLooKH4FZkOnfdO/vnmydo9nKj8lIQwRoq+5gAW/5F0r1RpOFCtBFmtYktNxdfve2SksBnc+5omI5mJcv1nzVIqtdy0cGCuip7DvHYWXgQxqAbsbpaRpqA/v+TzayrVCeyOsbu4ZiZG2WazNgnKuuIZbv96ICmwWw1UHynsuM0JoKLjA1k6s4HwBJQRhAA/5V7NwKfb/f0PrtzqynilqAwiNQpXTxP76UblH3Gcnk7B9jW1IUYmQZX88dV99ISeKF8pBvkxdyr45uKbOY7ePH0dc6ykpO+eojFoELzbts9b64NDjlXMqWPhc9CXBsd47nlHlE60nho03dhfvhcCtTFzTcJLMBjbg0yLyrZdkOmH49rm9I43l3fEQxC3bhM9w02d4cN2ORKYJ8x5Sdc0sRjMJ7PX2M13yoGbV/TydeZ83As43amcWeEs0DAJvW0qIlbsa9FEZAqAZZqQyp/yFT7GM7Jf/5xo6jK2gSrFrMjKukY6kQY5VgK86VHzJLoo6ckZSTBQ6JcgR9GmH7w64X89rHi7sYgkWVYHmQKZBwp6KS/BTqkFDbR5vgKaoToS1xrSZqVxGVQaV5LoDEIk2Pi3CPYJULQ3yoGCh8vQG5o132RDcBU5k2RICX8HYMb9Pc9ZgUuWGCWT5BKkj2AT0FruKiQc6aw55KRBiSuAvMDF2xc2tthG0mxnEk1ZrcZgYejnPOrQAZRiSxJU7xqNVPYPfkfwBU+fC1wNFmDMllGN6i4fTF+rJn8LsPg+7Xzbiyis1e7CBXGzzhK3sdNZTMWTgxRiCjC5YpkRuZJmusgw19p8KT0bu1pEdfQOI8GReaforhmlbg6xRN7ZpTfvwq5aU/Ic=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 01:25:07PM +0900, Sergey Senozhatsky wrote:
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
> ---
>  drivers/block/zram/zram_drv.c | 14 ++++++++------
>  include/linux/zsmalloc.h      |  4 ++--
>  mm/zsmalloc.c                 | 16 ++++++++++++----
>  mm/zswap.c                    |  5 +++--
>  4 files changed, 25 insertions(+), 14 deletions(-)
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
> index 84da164dcbc5..ab7767d9d87d 100644
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
> @@ -1087,7 +1087,11 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
>  	class = zspage_class(pool, zspage);
>  	off = offset_in_page(class->size * obj_idx);
>  
> -	if (off + class->size <= PAGE_SIZE) {
> +	/* Normal classes have inlined handle */
> +	if (!ZsHugePage(zspage))
> +		mem_len += ZS_HANDLE_SIZE;

Instead of modifying mem_len, can we modify 'off' like zs_obj_write()
and zs_obj_read_end()? I think this can actually be done as a prequel to
this patch. Arguably, it makes more sense as we avoid unnecessarily
copying the handle (completely untested):

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 5bf832f9c05c..48c288da43b8 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1087,6 +1087,9 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
        class = zspage_class(pool, zspage);
        off = offset_in_page(class->size * obj_idx);

+       if (!ZsHugePage(zspage))
+               off += ZS_HANDLE_SIZE;
+
        if (off + class->size <= PAGE_SIZE) {
                /* this object is contained entirely within a page */
                addr = kmap_local_zpdesc(zpdesc);
@@ -1107,9 +1110,6 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
                                 0, sizes[1]);
        }

-       if (!ZsHugePage(zspage))
-               addr += ZS_HANDLE_SIZE;
-
        return addr;
 }
 EXPORT_SYMBOL_GPL(zs_obj_read_begin);
@@ -1129,9 +1129,10 @@ void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
        class = zspage_class(pool, zspage);
        off = offset_in_page(class->size * obj_idx);

+       if (!ZsHugePage(zspage))
+               off += ZS_HANDLE_SIZE;
+
        if (off + class->size <= PAGE_SIZE) {
-               if (!ZsHugePage(zspage))
-                       off += ZS_HANDLE_SIZE;
                handle_mem -= off;
                kunmap_local(handle_mem);
        }

---
Does this work?

> +
> +	if (off + mem_len <= PAGE_SIZE) {
>  		/* this object is contained entirely within a page */
>  		addr = kmap_local_zpdesc(zpdesc);
>  		addr += off;

In the else case below (spanning object), should we also use mem_len
instead of class->size to determine the copy size?

> @@ -1115,7 +1119,7 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
>  EXPORT_SYMBOL_GPL(zs_obj_read_begin);
>  
>  void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
> -		     void *handle_mem)
> +		     size_t mem_len, void *handle_mem)
>  {
>  	struct zspage *zspage;
>  	struct zpdesc *zpdesc;
> @@ -1129,7 +1133,11 @@ void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
>  	class = zspage_class(pool, zspage);
>  	off = offset_in_page(class->size * obj_idx);
>  
> -	if (off + class->size <= PAGE_SIZE) {
> +	/* Normal classes have inlined handle */
> +	if (!ZsHugePage(zspage))
> +		mem_len += ZS_HANDLE_SIZE;
> +
> +	if (off + mem_len <= PAGE_SIZE) {
>  		if (!ZsHugePage(zspage))
>  			off += ZS_HANDLE_SIZE;

With the proposed prequel patch, I think we won't need to handle
ZS_HANDLE_SIZE twice here. WDYT? Did I miss sth?

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

