Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23B6CC5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 22:11:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06E5C6B008A; Thu,  6 Aug 2026 18:11:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01F0E6B0093; Thu,  6 Aug 2026 18:11:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E77106B0092; Thu,  6 Aug 2026 18:11:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F4A26B0095
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:11:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 16D91A047A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:11:20 +0000 (UTC)
X-FDA: 85072241520.04.45280C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7477F80012
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:11:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NPUsZw4y;
	spf=pass (imf30.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786054278;
	b=yZp3gXCqSFzq3zV+uWShBoz7QCe+55/wMXWjagUTtluDrvKc7N5LDR01LCT7M/r3zC5Y6J
	buZDfXOndiaYwYLfteifVD/7IL7sc6SE/RAMujd5pTJc/ne93Dtn31fhl8wdZtfWrC16qD
	dgNmia3Kc/9kNPT6kMeSIgMpEjdExhc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NPUsZw4y;
	spf=pass (imf30.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786054278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=792LT4+1Tv2pX39OSancINytl7JfR1u67Mihl21iXxI=;
	b=O5e0xYgt3xVQiiR9ig150ESXbjBYWtBNwiOQW9Q+1jpghXBR6mxe57qStAT/SoFsiZshKz
	jUZf/ptJLC11c/k5VmdOjg6fVohiiPRBzWxJnIzoYsP7opSmFfZz2uIquZJ/81/TAGPvs9
	SeBIKJpeyG+sGNCbIQ13BtNkWTWMq5w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA35343A80;
	Thu,  6 Aug 2026 22:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6101F00A3D;
	Thu,  6 Aug 2026 22:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786054277;
	bh=792LT4+1Tv2pX39OSancINytl7JfR1u67Mihl21iXxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NPUsZw4yuUWpxsOGrZoU88oVspSTpuVo5cBuKXt8yvd1vNfpIgd298DSVVS1X+rIq
	 NyPee7Qhmm5nAcDVco+hSzND73pUYCziKRr5/fnM2BmiwT5sw62WpITHox98h0RggS
	 jUoUxBoO8sCAXAg1qKbtsMHaLijURdBBbw3saDL1fVv75ESo/RR1G5sroWw08FMSje
	 XLDaBW4L45kAc7moY6pGxnNoCJTwGmKLWAkHAG1KYzt/vdIr/T/dFOuLqZlcUJFBuD
	 4XP/w86pPEDL4Z1Aqr4YHuNJ9KKz4PFVgYuIRmHBqHfNrERP64PEBsRYPlVZBF752+
	 GGoSGh+pkLEBQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-block@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/3] mm: support fallible mempool_alloc_bulk()
Date: Thu,  6 Aug 2026 15:10:30 -0700
Message-ID: <20260806221031.79050-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260806221031.79050-1-ebiggers@kernel.org>
References: <20260806221031.79050-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7477F80012
X-Stat-Signature: w4cprqhcoruxe9euppzgt9zjrhjxuoum
X-Rspam-User: 
X-HE-Tag: 1786054278-16609
X-HE-Meta: U2FsdGVkX1+Ip2B2FQIhKTfrMLnr2v2F+7vsSBtr5hDL7q738xX3DXexPn1ar1KAF2vyjIhcbrbApbjacwlOX8dksVtd1lul6PzQBglKrsjxCfiaHJwhvO3OuleegfWJFDel3/qzEiyXPDFyJTfNN7edx4Ol7uZDiB1jwp+GdrH02+B+iRHQ/qV6NQ0EdxHEHNKETna1eJ+KiB7s2otecJhHeJ48BAP7TO9R4r052pD/QhWPpJPwcXMT164ht6boWAE+54YMuoFI/7NCsQ7qtIu37FY7C0eaWCtnxUv+nbXowmem2+w1APfp/IU6cn3Of2YvqlqYGFIjg+Jy7BQGQNpvjdZ1xtBouqCHLdoNVWguZuhwk1u2N0IbOam/GosigLXskihwbLO+haTjl33e7ew5woejBDaKzao07H97ydqUoRqg+3JyDJPPz2OQ1UEmp/daSvS1bGcj6NFN05qi9yT3y/LDe1iG0A7mPp5J3skUIIXagl7ooDJGhDnlbarEDy+lzi+MRTG6/qxMRIJYPFtr98uaxS85QLWuUKnNc81uzkk2vtTDHFIcG7irIcAk6+/OHKtr6gNsyhIMyWa5okLQSoQ+kCOwoSadc9cI5ShVneT2IUfRgq/sILYbf8ZJrG1D7DNbom/B5pVfWQdu6+EreAJkb8qaoKCkZJtUft/sQscySUXyI6ZsaJGF2hENxot/1i/Qtl/R5Xm6wNqPb0oxdahyrHCM0u62pVXC2Bam5nHPsf5+C3P5fHntKTBB7skw3lM5yBj91deiaxtTaxhqngvKxLvScUBNnz9/+EildQ1hgwTUX/hbYx3WR5EdpMrylhVaoUH4IfyQSvKxG6DY7VoIkeXd/TeqRR+1nNs7p7QFT/XGz71pSmXIl7b/mODXRTQbjwRRAs2B4qAxRV+OO9Ag4nwLrA+SrdpU0a/248JjsolOnA4FHzrIqpLJfr7zAu0kXaTHL9R5eQA
 b4bMj5aD
 cBIcozWhKUB5+eWWoVK6ukSX3Atkn7lrf7fSyL49fgyHK6166iXOA9DmK4ZvttA/bI5fOCi3WMRwoDIUnIj9vsPy9U3eCM8KO+EIXg4KLkqxkRaJfsw2iQlFJO9GTwFOaRbqtK2pCizrxlswtxSz4ihPUGJfcqwK7uGEcjkrmJJZyZL35XVylUWALYhwjBcvtee9H2spTtE94j8fpFxDhwDNXjTbG5gtXEUt9XVeLZasJ1ewhdpnyYkY2Rz1qjIeSvmTjK3WmAjwYanwdiMucgFX7JyDSP64c0vcH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To fix a deadlock, blk-crypto-fallback needs to be able to make fallible
mempool_alloc_bulk() allocations.  But mempool_alloc_bulk() hardcodes
GFP_KERNEL and infinite retries, which differs from mempool_alloc()
which supports fallible allocations via its gfp_mask argument.

Therefore, add a gfp_mask argument to mempool_alloc_bulk().  As with
mempool_alloc(), the presence of __GFP_DIRECT_RECLAIM in the mask
selects between the fallible and infallible modes.

For now it just provides all-or-nothing semantics and returns a bool,
similar to kmem_cache_alloc_bulk().

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 block/blk-crypto-fallback.c |  6 ++----
 include/linux/mempool.h     |  4 ++--
 mm/mempool.c                | 42 +++++++++++++++++++++++++------------
 3 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index 2a5c52ab74b4..bda913c39381 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -172,7 +172,6 @@ static void blk_crypto_fallback_encrypt_endio(struct bio *enc_bio)
 static struct bio *blk_crypto_alloc_enc_bio(struct bio *bio_src,
 		unsigned int nr_segs, struct page ***pages_ret)
 {
-	unsigned int memflags = memalloc_noio_save();
 	unsigned int nr_allocated;
 	struct page **pages;
 	struct bio *bio;
@@ -206,12 +205,11 @@ static struct bio *blk_crypto_alloc_enc_bio(struct bio *bio_src,
 	 * any non-zero slot already contains a valid allocation.
 	 */
 	memset(pages, 0, sizeof(struct page *) * nr_segs);
-	nr_allocated = alloc_pages_bulk(GFP_KERNEL, nr_segs, pages);
+	nr_allocated = alloc_pages_bulk(GFP_NOIO, nr_segs, pages);
 	if (nr_allocated < nr_segs)
 		mempool_alloc_bulk(blk_crypto_bounce_page_pool,
 				(void **)pages + nr_allocated,
-				nr_segs - nr_allocated);
-	memalloc_noio_restore(memflags);
+				nr_segs - nr_allocated, GFP_NOIO);
 	*pages_ret = pages;
 	return bio;
 }
diff --git a/include/linux/mempool.h b/include/linux/mempool.h
index a0fa6d43e0dc..f7898cd1512b 100644
--- a/include/linux/mempool.h
+++ b/include/linux/mempool.h
@@ -65,8 +65,8 @@ void mempool_destroy(struct mempool *pool);
 void *mempool_alloc_noprof(struct mempool *pool, gfp_t gfp_mask) __malloc;
 #define mempool_alloc(...)						\
 	alloc_hooks(mempool_alloc_noprof(__VA_ARGS__))
-int mempool_alloc_bulk_noprof(struct mempool *pool, void **elem,
-		unsigned int count);
+bool mempool_alloc_bulk_noprof(struct mempool *pool, void **elem,
+		unsigned int count, gfp_t gfp_mask);
 #define mempool_alloc_bulk(...)						\
 	alloc_hooks(mempool_alloc_bulk_noprof(__VA_ARGS__))
 
diff --git a/mm/mempool.c b/mm/mempool.c
index d454bc9f39e9..d741e5f62554 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -473,25 +473,28 @@ static inline gfp_t mempool_adjust_gfp(gfp_t *gfp_mask)
 /**
  * mempool_alloc_bulk - allocate multiple elements from a memory pool
  * @pool:	pointer to the memory pool
- * @elems:	partially or fully populated elements array
- * @count:	number of entries in @elem that need to be allocated
+ * @elems:	pointer to array into which the element pointers will be stored
+ * @count:	number of elements to allocate
+ * @gfp_mask:	GFP_* flags.  %__GFP_ZERO is not supported.  If this mask
+ *		includes %__GFP_DIRECT_RECLAIM, then the allocation is retried
+ *		indefinitely until it succeeds and the return value is always
+ *		%true.  If the mask doesn't include %__GFP_DIRECT_RECLAIM, then
+ *		failure is allowed and %false can be returned.
  *
  * Allocate @count elements into @elems.  This is done by first calling into the
  * alloc_fn supplied at pool initialization time, and dipping into the reserved
- * pool when alloc_fn fails to allocate an element.
- *
- * On return all @count elements in @elems will be populated.
+ * pool to atomically allocate the remaining elements if alloc_fn fails.
  *
- * Return: Always 0.  If it wasn't for %$#^$ alloc tags, it would return void.
+ * Return: %true if the allocation succeeded, or %false if it failed.
  */
-int mempool_alloc_bulk_noprof(struct mempool *pool, void **elems,
-		unsigned int count)
+bool mempool_alloc_bulk_noprof(struct mempool *pool, void **elems,
+		unsigned int count, gfp_t gfp_mask)
 {
-	gfp_t gfp_mask = GFP_KERNEL;
 	gfp_t gfp_temp = mempool_adjust_gfp(&gfp_mask);
 	unsigned int allocated = 0;
 
 	VM_WARN_ON_ONCE(count > pool->min_nr);
+	VM_WARN_ON_ONCE(gfp_mask & __GFP_ZERO);
 	might_alloc(gfp_mask);
 
 	/*
@@ -516,13 +519,26 @@ int mempool_alloc_bulk_noprof(struct mempool *pool, void **elems,
 		allocated++;
 	}
 
-	return 0;
+	return true;
 
 use_pool:
+	/* Try to atomically allocate the remaining elements from the pool. */
 	if (mempool_alloc_from_pool(pool, elems, count, allocated, gfp_temp))
-		return 0;
-	gfp_temp = gfp_mask;
-	goto repeat_alloc;
+		return true;
+	/* Retry if this was just the opportunistic first pass. */
+	if (gfp_temp != gfp_mask) {
+		gfp_temp = gfp_mask;
+		goto repeat_alloc;
+	}
+	/* Retry indefinitely if __GFP_DIRECT_RECLAIM is set. */
+	if (gfp_mask & __GFP_DIRECT_RECLAIM)
+		goto repeat_alloc;
+	/* On failure, roll back any successful allocations from ->alloc(). */
+	while (allocated--) {
+		pool->free(elems[allocated], pool->pool_data);
+		elems[allocated] = NULL;
+	}
+	return false;
 }
 EXPORT_SYMBOL_GPL(mempool_alloc_bulk_noprof);
 
-- 
2.55.0


