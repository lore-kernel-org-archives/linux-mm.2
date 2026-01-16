Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C072FC98300
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 19:53:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 083046B0005; Fri, 16 Jan 2026 14:53:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030906B0088; Fri, 16 Jan 2026 14:53:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E71AF6B0089; Fri, 16 Jan 2026 14:53:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D25356B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:53:40 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7DECFD19D7
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 19:53:40 +0000 (UTC)
X-FDA: 84338877000.29.BD7478B
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf22.hostedemail.com (Postfix) with ESMTP id 90081C000B
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 19:53:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Urw0TXrB;
	spf=pass (imf22.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768593218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Ukq5Uc7pUZihKBQL+2WI1aZmTaWSwbfXZse5sZ8ub0=;
	b=JUYhR4HczSkdpuPlbUeKRqoSEpoAbt8g9MKkDr9F3MNm3KKpx4YYs0+QgG8f6LHKit/K0+
	qSomWWyJfoqG8Hr7RwYE1rrzRJpUfhqe2iGsWOmmK2kijd8GKzUo/pTqRDz1zYtNJjNgd6
	TsF7D71Nvf/8mN4hA/NUmmFEHoIRZXE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Urw0TXrB;
	spf=pass (imf22.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768593218; a=rsa-sha256;
	cv=none;
	b=GaBN5cLHt/7ECqncJAcJPYkvUKVXNHlAliLBaET7OXGYgs0be6NXuqDCKgMXF+mdvvWtn2
	QGHL8St1BeWDStc6iZliWEJnqioa9peMOSthHObg8XrgVfnEa/8fZ0eyHvhcja5NtgavZk
	3h9ib9R2QJKBLS9N5z5+iCX0w0bbJ3Q=
Date: Fri, 16 Jan 2026 19:53:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768593214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8Ukq5Uc7pUZihKBQL+2WI1aZmTaWSwbfXZse5sZ8ub0=;
	b=Urw0TXrBOowJbBkcvz/cgWxn7g9/DvQV8cs8XLb8gw746mXJ2AfjJUf6Gybseis4fro4Xg
	/0KfovdaVlr7djDVeXM+bjWcjsSSKRPoU5FGx5qSgeUUYTgiIa5VFQhfqqexzC0r9V/0cp
	G8sU/zzgcRnZo0d9Z/ew0HsN/qcDlzg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Minchan Kim <minchan@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] zsmalloc: introduce SG-list based object read API
Message-ID: <wb2shm35vigisxnokcp3pw3yzu32kezo3ox2v3xu2u5lnxo45n@ktccxxzg2vsc>
References: <20260113034645.2729998-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113034645.2729998-1-senozhatsky@chromium.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ag911f6omwd5b5171ggasbns6otzjt5i
X-Rspam-User: 
X-Rspamd-Queue-Id: 90081C000B
X-Rspamd-Server: rspam08
X-HE-Tag: 1768593218-828053
X-HE-Meta: U2FsdGVkX18MJ5t5gOH4hblE3UX2otkAWNJr5nX/VZzU/8c+AhO5CVBmtOO9s+ctqMPx86FhNFvW33k9gG8QARHn4QaTwYP4fWrhHAH1Ym3irN5GurCPD2385b/OR66IcbnmOoPwhP1fIa/y5x5uT7hBH3unOZdC9deLPXthUjVTGJpvGk0jRsyYD954MmxedLyxjAalIy0VRDkvMiYEyxDO51ieh3o6HjhIXQJZQmg22KCjnVek3dmSXZtWotJ6YP5m8uIAUeMzWY6zO5ixnsbWHX0Als3qh2otMwNfevwmWvEfmickpuT/4Y2a46yhRnS66weN5aiEQdRb3CcqKG4FoO+jLW185tClzEuDbmUMsEZNQPznVXu4uOUf+ap1kotKBg+1548We7+xe2Rgl6EDKXRIvbmbhOuqzBJ0A6qQIgaMGynLiQT1XtRrCMNwtBLe+Ehe6GscxP7v1xG3KjIacUqzpsq6el2PM6Sv+uTODXSErFW27npHU9CEWHsE5zIbAhYMoys0gmgjuXZ1EThEp2gfJPQy1uz7xOOAnaSFrjPJKv6oYA9z7321qr7NL5meDveezLdSaAshPGMVIcS0bLlkZ4CuRyKNP2+hXudR2cMDgq0lc8YNffcMrX9FY0eQADi3sWWRGDfZGGpu2Mz5Gj7DMYtG0QibT6LxALZ0jpvhX0gzkI9nSrcjaX0/dHrDm5mdYGDULv1+BuUnWFzzJAuvPpnkIWnMGJRRQHhy07/rm52y1CJQeuI5E1QxT6bEr6wFboLS2E9tZvd1xMwqnWLXEUNOxB4CqcQ1L1a0thj6x0HIbttkMBqop7PSCHE6Jax70ZiyG0ktek2w4TKnq1f6cCtrZA6NA5QV6zM5lcz184/Ur/Wo9c3tb/lqa0ZptHUm+2+0Vo7xucWOy06U1KL0YxgfFkFA9lTXGOqdd3fHDqtMbNZJWlQXAThnNL7nsT4E3D9P2x8a+K4
 qO2QZ+/x
 vlju4XgtUUXEneLeWBPqJCLCzGcLLWgjMlY5XvkJqlW/EE14GXW5wEVT/9I2/IfktFsWayHDG7IgkDZTAk4jj+HD80up/TzLtsF0oIaTleD1AqibC0Jtxb43tWISTq+eD3aoRb22PRDCBXMt62/osB64RVrNW7cYtQaeBHQ55wglKN4LmF7mJUFsiGjbXmFk4LMfXs+JsODRii0HqxX0UyllfY1PAqwmkIZMqRJgsBWCcyNsoqrEyWRyzqVcxvBtwjCDcvny+uDmpAQVFI7CO1VC8gYTLjEy/boOT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 12:46:45PM +0900, Sergey Senozhatsky wrote:
> Currently, zsmalloc performs address linearization on read
> (which sometimes requires memcpy() to a local buffer).
> Not all zsmalloc users need a linear address. For example,
> Crypto API supports SG-list, performing linearization under
> the hood, if needed. In addition, some compressors can have
> native SG-list support, completely avoiding the linearization
> step.
> 
> Provide an SG-list based zsmalloc read API:
> - zs_obj_read_sg_begin()
> - zs_obj_read_sg_end()
> 
> This API allows callers to obtain an SG representation
> of the object (one entry for objects that are contained
> in a single page and two entries for spanning objects),
> avoiding the need for a bounce buffer and memcpy.
> 
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> ---

I tested this with the zswap patch at the bottom, let me know if you
want me to send separately on top, or you can include it in the next
revision.  Either way, feel free to add:

Tested-by: Yosry Ahmed <yosry.ahmed@linux.dev>

>  include/linux/zsmalloc.h |  4 +++
>  mm/zsmalloc.c            | 65 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 69 insertions(+)
> 
> diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
> index 5565c3171007..11e614663dd3 100644
> --- a/include/linux/zsmalloc.h
> +++ b/include/linux/zsmalloc.h
> @@ -22,6 +22,7 @@ struct zs_pool_stats {
>  };
>  
>  struct zs_pool;
> +struct scatterlist;
>  
>  struct zs_pool *zs_create_pool(const char *name);
>  void zs_destroy_pool(struct zs_pool *pool);
> @@ -43,6 +44,9 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
>  			size_t mem_len, void *local_copy);
>  void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
>  		     size_t mem_len, void *handle_mem);
> +int zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,

void? The return value is always 0.

> +		   struct scatterlist *sg, size_t mem_len);
> +void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle);
>  void zs_obj_write(struct zs_pool *pool, unsigned long handle,
>  		  void *handle_mem, size_t mem_len);
>  
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 16d5587a052a..5abb8bc0956a 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -30,6 +30,7 @@
>  #include <linux/highmem.h>
>  #include <linux/string.h>
>  #include <linux/slab.h>
> +#include <linux/scatterlist.h>
>  #include <linux/spinlock.h>
>  #include <linux/sprintf.h>
>  #include <linux/shrinker.h>
> @@ -1146,6 +1147,70 @@ void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
>  }
>  EXPORT_SYMBOL_GPL(zs_obj_read_end);
>  
> +int zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
> +			 struct scatterlist *sg, size_t mem_len)
> +{
> +	struct zspage *zspage;
> +	struct zpdesc *zpdesc;
> +	unsigned long obj, off;
> +	unsigned int obj_idx;
> +	struct size_class *class;
> +
> +	/* Guarantee we can get zspage from handle safely */
> +	read_lock(&pool->lock);
> +	obj = handle_to_obj(handle);
> +	obj_to_location(obj, &zpdesc, &obj_idx);
> +	zspage = get_zspage(zpdesc);
> +
> +	/* Make sure migration doesn't move any pages in this zspage */
> +	zspage_read_lock(zspage);
> +	read_unlock(&pool->lock);
> +
> +	class = zspage_class(pool, zspage);
> +	off = offset_in_page(class->size * obj_idx);

There is a lot of duplication between this and zs_obj_read_begin(). I
wanted to create a common helper for them both that returns the zpdesc
and offset, but we cannot do the same on the read end side as the unlock
needs to happen after kunmap() in zs_obj_read_end().

Putting parts of this code in helpers makes it a bit obscure due to the
locking rules :/

I wonder if we can drop zs_obj_read_*() and move the spanning logic into
zram. Looking at zram code, seems like read_from_zspool_raw() and
read_incompressible_page() just copy the return address, so I think they
can trivially move to using the SG list helpers and
memcpy_from_sglist().

The only non-trivial caller is read_compressed_page(), because it passes
the compressed object to zcomp. So I think we only need to handle the
linearization there, something like this (completely untested):

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 61d3e2c74901..6872819184d9 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2073,6 +2073,7 @@ static int read_incompressible_page(struct zram *zram, struct page *page,

 static int read_compressed_page(struct zram *zram, struct page *page, u32 index)
 {
+       struct scatterlist src_sg[2];
        struct zcomp_strm *zstrm;
        unsigned long handle;
        unsigned int size;
@@ -2084,12 +2085,23 @@ static int read_compressed_page(struct zram *zram, struct page *page, u32 index)
        prio = get_slot_comp_priority(zram, index);

        zstrm = zcomp_stream_get(zram->comps[prio]);
-       src = zs_obj_read_begin(zram->mem_pool, handle, size,
-                               zstrm->local_copy);
+       zs_obj_read_sg_begin(zram->mem_pool, handle, src_sg, size);
+
+       if (sg_nents(src_sg) == 1) {
+               src = kmap_local_page(sg_page(src_sg)) + src_sg->offset;
+       } else {
+               memcpy_from_sglist(zstrm->local_copy, src_sg, 0, size);
+               src = zstrm->local_copy;
+       }
+
        dst = kmap_local_page(page);
        ret = zcomp_decompress(zram->comps[prio], zstrm, src, size, dst);
        kunmap_local(dst);
-       zs_obj_read_end(zram->mem_pool, handle, size, src);
+
+       if (src != zstrm->local_copy)
+               kunmap_local(src);
+
+       zs_obj_read_sg_end(zram->mem_pool, handle);
        zcomp_stream_put(zstrm);

        return ret;

---

If this is too ugly we can even put it in helpers like
linearize_sg_list() and delinearize_sg_list(), that take in the SG list
and zstrm, and figure out if mapping or copying to the buffer is needed.

> +
> +	if (!ZsHugePage(zspage))
> +		off += ZS_HANDLE_SIZE;
> +
> +	if (off + mem_len <= PAGE_SIZE) {
> +		/* this object is contained entirely within a page */
> +		sg_init_table(sg, 1);
> +		sg_set_page(sg, zpdesc_page(zpdesc), mem_len, off);
> +	} else {
> +		size_t sizes[2];
> +
> +		/* this object spans two pages */
> +		sizes[0] = PAGE_SIZE - off;
> +		sizes[1] = mem_len - sizes[0];
> +
> +		sg_init_table(sg, 2);
> +		sg_set_page(sg, zpdesc_page(zpdesc), sizes[0], off);
> +
> +		zpdesc = get_next_zpdesc(zpdesc);
> +		sg = sg_next(sg);
> +
> +		sg_set_page(sg, zpdesc_page(zpdesc), sizes[1], 0);
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(zs_obj_read_sg_begin);
> +
> +void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle)
> +{
> +	struct zspage *zspage;
> +	struct zpdesc *zpdesc;
> +	unsigned long obj;
> +	unsigned int obj_idx;
> +
> +	obj = handle_to_obj(handle);
> +	obj_to_location(obj, &zpdesc, &obj_idx);
> +	zspage = get_zspage(zpdesc);
> +
> +	zspage_read_unlock(zspage);
> +}
> +EXPORT_SYMBOL_GPL(zs_obj_read_sg_end);
> +
>  void zs_obj_write(struct zs_pool *pool, unsigned long handle,
>  		  void *handle_mem, size_t mem_len)
>  {
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

Zswap patch:

From 8b7c41efce7635dd14db9586c3bb96c861298772 Mon Sep 17 00:00:00 2001
From: Yosry Ahmed <yosry.ahmed@linux.dev>
Date: Fri, 16 Jan 2026 19:20:02 +0000
Subject: [PATCH] mm: zswap: Use SG list decompression APIs from zsmalloc

Use the new zs_obj_read_sg_*() APIs in zswap_decompress(), instead of
zs_obj_read_*() APIs returning a linear address. The SG list is passed
directly to the crypto API, simplifying the logic and dropping the
workaround that copies highmem addresses to a buffer. The crypto API
should internally linearize the SG list if needed.

Zsmalloc fills an SG list up to 2 entries in size, so change the input
SG list to fit 2 entries.

Update the incompressible entries path to use memcpy_from_sglist() to
copy the data to the folio. Opportunistically set dlen to PAGE_SIZE in
the same code path (rather that at the top of the function) to make it
clearer.

Drop the goto in zswap_compress() as the code now is not simple enough
for an if-else statement instead. Rename 'decomp_ret' to 'ret' and reuse
it to keep the intermediate return value of crypto_acomp_decompress() to
keep line lengths manageable.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 mm/zswap.c | 49 +++++++++++++++++++------------------------------
 1 file changed, 19 insertions(+), 30 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 2f410507cbc8..aea3267c5a96 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -26,6 +26,7 @@
 #include <linux/mempolicy.h>
 #include <linux/mempool.h>
 #include <crypto/acompress.h>
+#include <crypto/scatterwalk.h>
 #include <linux/zswap.h>
 #include <linux/mm_types.h>
 #include <linux/page-flags.h>
@@ -936,53 +937,41 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 {
 	struct zswap_pool *pool = entry->pool;
-	struct scatterlist input, output;
+	struct scatterlist input[2]; /* zsmalloc returns an SG list 1-2 entries */
+	struct scatterlist output;
 	struct crypto_acomp_ctx *acomp_ctx;
-	int decomp_ret = 0, dlen = PAGE_SIZE;
-	u8 *src, *obj;
+	int ret = 0, dlen;
 
 	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
-	obj = zs_obj_read_begin(pool->zs_pool, entry->handle, entry->length,
-				acomp_ctx->buffer);
+	zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->length);
 
 	/* zswap entries of length PAGE_SIZE are not compressed. */
 	if (entry->length == PAGE_SIZE) {
-		memcpy_to_folio(folio, 0, obj, entry->length);
-		goto read_done;
-	}
-
-	/*
-	 * zs_obj_read_begin() might return a kmap address of highmem when
-	 * acomp_ctx->buffer is not used.  However, sg_init_one() does not
-	 * handle highmem addresses, so copy the object to acomp_ctx->buffer.
-	 */
-	if (virt_addr_valid(obj)) {
-		src = obj;
+		WARN_ON_ONCE(input->length != PAGE_SIZE);
+		memcpy_from_sglist(kmap_local_folio(folio, 0), input, 0, PAGE_SIZE);
+		dlen = PAGE_SIZE;
 	} else {
-		WARN_ON_ONCE(obj == acomp_ctx->buffer);
-		memcpy(acomp_ctx->buffer, obj, entry->length);
-		src = acomp_ctx->buffer;
+		sg_init_table(&output, 1);
+		sg_set_folio(&output, folio, PAGE_SIZE, 0);
+		acomp_request_set_params(acomp_ctx->req, input, &output,
+					 entry->length, PAGE_SIZE);
+		ret = crypto_acomp_decompress(acomp_ctx->req);
+		ret = crypto_wait_req(ret, &acomp_ctx->wait);
+		dlen = acomp_ctx->req->dlen;
 	}
 
-	sg_init_one(&input, src, entry->length);
-	sg_init_table(&output, 1);
-	sg_set_folio(&output, folio, PAGE_SIZE, 0);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, PAGE_SIZE);
-	decomp_ret = crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait);
-	dlen = acomp_ctx->req->dlen;
-
-read_done:
-	zs_obj_read_end(pool->zs_pool, entry->handle, entry->length, obj);
+	zs_obj_read_sg_end(pool->zs_pool, entry->handle);
 	acomp_ctx_put_unlock(acomp_ctx);
 
-	if (!decomp_ret && dlen == PAGE_SIZE)
+	if (!ret && dlen == PAGE_SIZE)
 		return true;
 
 	zswap_decompress_fail++;
 	pr_alert_ratelimited("Decompression error from zswap (%d:%lu %s %u->%d)\n",
 						swp_type(entry->swpentry),
 						swp_offset(entry->swpentry),
-						entry->pool->tfm_name, entry->length, dlen);
+						entry->pool->tfm_name,
+						entry->length, dlen);
 	return false;
 }
 
-- 
2.52.0.457.g6b5491de43-goog


