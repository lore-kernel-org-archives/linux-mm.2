Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7160DC79FA1
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 16:02:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C35316B016F; Mon,  5 Jan 2026 11:02:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0C136B0175; Mon,  5 Jan 2026 11:02:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B18966B0176; Mon,  5 Jan 2026 11:02:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9D5986B016F
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:02:36 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3A1A589AC1
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:02:36 +0000 (UTC)
X-FDA: 84298377912.17.1FA3736
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id BA1C9C0014
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:02:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CGK4q62S;
	spf=pass (imf22.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767628953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d8H38aIg3XHkP2JTNwfBsRThSRBkq7w3SpaJb0aaK6I=;
	b=YN3QZHgMGMKhXqNa9qox6eWOo004iNASvy5kvzWJaM15WXh7Y5RVrJ4RGhxY0DdMxYuvzY
	ayh5aeLe88hruh6RPfecTeSp/46Sy8cOAOI5UETWy0hbS34IV89tTreqPCbYcW1a7DDUXh
	Ozf2/Vk/E1l9lkNFgjU/qXDHbZaIFCg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CGK4q62S;
	spf=pass (imf22.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767628953; a=rsa-sha256;
	cv=none;
	b=emcLTlfo56Tzd1RoBqbl4gkPI9XQh238gbRRSbiENiTlQ9x72AYAYGGV0f2CW594VT4WN3
	fAsoQN9bsAHFxUH96Jfx2+QwqgTJhStQpdsafoE4PP3kWUN1YFTkPBTU4F9L5vVIG6kJGr
	a/EwuP6FizY40ALjmu0h1wOLypdiCH8=
Date: Mon, 5 Jan 2026 16:01:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767628950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d8H38aIg3XHkP2JTNwfBsRThSRBkq7w3SpaJb0aaK6I=;
	b=CGK4q62SyZVxu1YpwNWCCOQP5cs2QvGONTcH/AE7i+g+6uP4rII5EqZ6TtzWS0YnQY/vGE
	tThZA1AjFeN3LUpoIZjoVO4Z1VftV79bRmWv3BdepdAgkB08lsUyJ4RBCEABmolFBAPH19
	rJNq7h+R10Kp5IGR6qUjvr9+m3SlY7E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] zsmalloc: chain-length configuration should
 consider other metrics
Message-ID: <yr7cekjrssjiwqlkrmreugl6fhywssutjzg3ll45mcvdjklnzy@5vkgju4wwtrg>
References: <20260101013814.2312147-1-senozhatsky@chromium.org>
 <20260101013814.2312147-3-senozhatsky@chromium.org>
 <ddfs43qldaws5urlnpah3ibp5xeu7st37p5hgdfajvdtwor4sd@fkcm3brinygo>
 <gg5zdpzrk47tljbnaudcy2gnsodyhmmar23qb57b67bhx6ntje@eq2fcrl2dk4z>
 <gdtbjepmea65zajh6dafxiekv2wmoerje7v3qxjundbezdnpps@f5ofogyw7wnl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gdtbjepmea65zajh6dafxiekv2wmoerje7v3qxjundbezdnpps@f5ofogyw7wnl>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 9iwgcnt16jtm197ro6pd7e79h658qg49
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BA1C9C0014
X-HE-Tag: 1767628952-706009
X-HE-Meta: U2FsdGVkX19C75bGjdYNY3QSEhwkdzBjPl8IB79JdnKs7Jh/DZu+oD/P3k0RjC5CvyasmvaSnOiFi/TlMuGF5gwml2/cw4n0uI5c39eRXVKwDrQs9VlZRcnz88IgXWuYsyzo5Hcj98sjP4B+FnIifAOz8GG+J++jo7lhggQnyOSsnOb12Bg9GPKwDG8nqstvmi4evSz0gWc73VtBQRSc8UB1KM4GPn2/vNm1Vsag74vfmQAANwbWzT3SwS9oWArTTDtT5SHqS/VrWz8phkAfhL6cQ26q+g/lx2lSjefGzm3J/D5p812b4mFM33VD7tP3dqXfgbuMmnKtIwPhKtU0NueKV4bmaBXSL+1wnXm70VXU2VJIsbcIxExNrIz3SCl//F7sKVh/ERXZBjdcpH4UkpOEOEIHhkTi5VeTKRftdjguxSS0XZn20lr0H84XxiWfFNQLlbrkCmfCTz8HOQwdMSN5fbBCFKW/aUVCTtMAAmr3QSdm4Bx22egFHZugUJgtce3Xv8CTDa/77GVnVOlKjHvVwvKdPpkpq3Key3zCEd+9iX/s1EXHjOJ1ShFS4Fgtwo/VYgZfHj0EmVaL8LbPewB9qxUk/DvVESwYKdZeuOsBXx74uiUwQYboKYncy1cKvQ2FeV+UiHfFRkS/rjTR98Ea2UG629uOUCqUi1AXM3ZsBeICpdz80JkgOYIcLzf4GmrmzDwqVVaFFvWFic0qRsRFWwUfrMkRD9aXXNHUyhIo6UvBaA7FRHbvSYHAM0mA6BRJlkyNToqndNIhdDVSimm7eN38tUNBXsVs+w3yS5zdQEnsUXY8AT6oftbfdpKRra/75z+ZHNHpYXQ7cCbclDn5GX99ffGqwh+n/9F5RPE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 04:23:39PM +0900, Sergey Senozhatsky wrote:
> On (26/01/05 10:42), Sergey Senozhatsky wrote:
> > On (26/01/02 18:29), Yosry Ahmed wrote:
> > > On Thu, Jan 01, 2026 at 10:38:14AM +0900, Sergey Senozhatsky wrote:
> > [..]
> > > 
> > > I worry that the heuristics are too hand-wavy
> > 
> > I don't disagree.  Am not super excited about the heuristics either.
> > 
> > > and I wonder if the memcpy savings actually show up as perf improvements
> > > in any real life workload. Do we have data about this?
> > 
> > I don't have real life 16K PAGE_SIZE devices.  However, on 16K PAGE_SIZE
> > systems we have "normal" size-classes up to a very large size, and normal
> > class means chaining of 0-order physical pages, and chaining means spanning.
> > So on 16K memcpy overhead is expected to be somewhat noticeable.
> 
> By the way, while looking at it, I think we need to "fix" obj_read_begin().
> Currently, it uses "off + class->size" to detect spanning objects, which is
> incorrect: size classes get merged, so a typical size class can hold a range
> of sizes, using padding for smaller objects.  So instead of class->size we
> need to use the actual compressed objects size, just in case if actual written
> size was small enough to fit into the first physical page (we do that in
> obj_write()).  I'll cook a patch.

We also need to handle zs_obj_read_end() to do the kunmap() call
correctly.

> 
> Something like this:
> 
> ---
> 
>  drivers/block/zram/zram_drv.c | 8 +++++---
>  include/linux/zsmalloc.h      | 2 +-
>  mm/zsmalloc.c                 | 4 ++--
>  mm/zswap.c                    | 3 ++-
>  4 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index a6587bed6a03..b371ba6bfec2 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -2065,7 +2065,7 @@ static int read_incompressible_page(struct zram *zram, struct page *page,
>  	void *src, *dst;
>  
>  	handle = get_slot_handle(zram, index);
> -	src = zs_obj_read_begin(zram->mem_pool, handle, NULL);
> +	src = zs_obj_read_begin(zram->mem_pool, handle, PAGE_SIZE, NULL);
>  	dst = kmap_local_page(page);
>  	copy_page(dst, src);
>  	kunmap_local(dst);
> @@ -2087,7 +2087,8 @@ static int read_compressed_page(struct zram *zram, struct page *page, u32 index)
>  	prio = get_slot_comp_priority(zram, index);
>  
>  	zstrm = zcomp_stream_get(zram->comps[prio]);
> -	src = zs_obj_read_begin(zram->mem_pool, handle, zstrm->local_copy);
> +	src = zs_obj_read_begin(zram->mem_pool, handle, size,
> +				zstrm->local_copy);
>  	dst = kmap_local_page(page);
>  	ret = zcomp_decompress(zram->comps[prio], zstrm, src, size, dst);
>  	kunmap_local(dst);
> @@ -2114,7 +2115,8 @@ static int read_from_zspool_raw(struct zram *zram, struct page *page, u32 index)
>  	 * takes place here, as we read raw compressed data.
>  	 */
>  	zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_COMP]);
> -	src = zs_obj_read_begin(zram->mem_pool, handle, zstrm->local_copy);
> +	src = zs_obj_read_begin(zram->mem_pool, handle, size,
> +				zstrm->local_copy);
>  	memcpy_to_page(page, 0, src, size);
>  	zs_obj_read_end(zram->mem_pool, handle, src);
>  	zcomp_stream_put(zstrm);
> diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
> index f3ccff2d966c..64f65c1f14d6 100644
> --- a/include/linux/zsmalloc.h
> +++ b/include/linux/zsmalloc.h
> @@ -40,7 +40,7 @@ unsigned int zs_lookup_class_index(struct zs_pool *pool, unsigned int size);
>  void zs_pool_stats(struct zs_pool *pool, struct zs_pool_stats *stats);
>  
>  void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
> -			void *local_copy);
> +			size_t mem_len, void *local_copy);
>  void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
>  		     void *handle_mem);
>  void zs_obj_write(struct zs_pool *pool, unsigned long handle,
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index be385609ef8a..2da60c23cd18 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -1070,7 +1070,7 @@ unsigned long zs_get_total_pages(struct zs_pool *pool)
>  EXPORT_SYMBOL_GPL(zs_get_total_pages);
>  
>  void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
> -			void *local_copy)
> +			size_t mem_len, void *local_copy)
>  {
>  	struct zspage *zspage;
>  	struct zpdesc *zpdesc;
> @@ -1092,7 +1092,7 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
>  	class = zspage_class(pool, zspage);
>  	off = offset_in_page(class->size * obj_idx);
>  
> -	if (off + class->size <= PAGE_SIZE) {
> +	if (off + mem_len <= PAGE_SIZE) {
>  		/* this object is contained entirely within a page */
>  		addr = kmap_local_zpdesc(zpdesc);
>  		addr += off;
> diff --git a/mm/zswap.c b/mm/zswap.c
> index de8858ff1521..291352629616 100644
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
> -- 
> 2.52.0.351.gbe84eed79e-goog

