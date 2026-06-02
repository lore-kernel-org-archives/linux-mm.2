Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F5D2CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 16:00:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AB956B0005; Tue,  2 Jun 2026 12:00:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4823C6B008C; Tue,  2 Jun 2026 12:00:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BF5E6B0092; Tue,  2 Jun 2026 12:00:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2AA526B0005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:00:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BA449C309A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 16:00:50 +0000 (UTC)
X-FDA: 84835435860.30.6392550
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id B04BAC002A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 16:00:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=H2v1eMrR;
	spf=none (imf10.hostedemail.com: domain of BATV+be7fc048bc4f2c536b43+8318+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+be7fc048bc4f2c536b43+8318+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780416048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VvElFF068Ve7ZBeg/s+GYXAA/2OootEbAfLXW7NSBv4=;
	b=RO8LhLrGNnV6lEYwu7zHaiaGM/vH/8FNd4qr6DdOLq4+0f749wW/EPPfZ/KEyNilYxVkkg
	tu6DGd4nMbZZ7jxOgp4XtYQiCOXS0H4wLAfyPIdfvWkXA0LDthnt80eTH+u0LxoWDQzQpe
	xG+kEDV5qv02gNlBZWX8p/Zb6e6eTog=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780416048;
	b=W6VKxRTQUGhlQJNOrbrY/N8qiJj3t7aifoJwSTqala9p11IBcoivDCw/B70xfHmIS+33Mb
	NjkBRwBQC2YCuV00yCG7ubJaz6qN/EE/OoXFAgs/nVe/kvGSz5XgUVZ/ObShSQintBoe4J
	sYFEH4WikryfVzGIOgMdmE/Vx6R36s0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=H2v1eMrR;
	spf=none (imf10.hostedemail.com: domain of BATV+be7fc048bc4f2c536b43+8318+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+be7fc048bc4f2c536b43+8318+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=VvElFF068Ve7ZBeg/s+GYXAA/2OootEbAfLXW7NSBv4=; b=H2v1eMrR4o3a9ugvd7BrH/6Tw0
	r3SU+To9h8oh+5o8YQTgBa/xfTMb+naqzquPhwWqqQ+yUHWCutZdKD13IoLAdVeGSGV2Br+BHSkh7
	DaeIBed7+2oackQBAGW3aPABvIZ77cQ0rXiuqxYhWI7Nvkf9IyBrjGjmJ28klJjCLHKXsXm3NjwgM
	h8D9klFrEkqboBdyvYkFn1tyZD1vfKpAMcl9V31O7oUm97BMDPfSZW5F6pSxFp5m8hZq6QF788sT5
	54eqjYCTHGrzg6f8Qf2NVq4269GhUqXjRYswDyxKRavAP9GDp3AqesMArvIXm//iJWRMfs+67TuEV
	dhB8xWOw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wURXn-0000000DO2R-1baf;
	Tue, 02 Jun 2026 16:00:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: vbabka@kernel.org,
	harry@kernel.org,
	akpm@linux-foundation.org
Cc: hao.li@linux.dev,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm: simplify the mempool_alloc_bulk API
Date: Tue,  2 Jun 2026 18:00:38 +0200
Message-ID: <20260602160038.3976341-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: B04BAC002A
X-Rspam-User: 
X-Stat-Signature: qs3kf5fciwzxkq5w9b57ijh9644xqxcg
X-Rspamd-Server: rspam08
X-HE-Tag: 1780416047-982362
X-HE-Meta: U2FsdGVkX1/6GJdSfBl1X+l3gLzTMufSUATOmTXd5LK/SIt4JdZ8E7utVm8Xt19XajRR6hrI5K1prEqCnPKC05Ek6qebdJYU7W+MSV8w0JiPwfoAjCMwvDN918W/R/eQv1FQD6tHficMFD27Qm6m8ETTU3i/62J6bVyynhv/2DRzFDV8VOkX9GtAXCHU/GB/lgKY+eYzFzc1Uj/KLIoTkmBxoi4YZ67KKSb6idK9yIcDh6uvniCTWA6aOIzyHR/waTnmMybU3Fn63f8UqSIwm7NCP8lGwbKlQstPDxXwyt0+q9B9lYdwTBDEWaTtIAK5zLf97DxXZ8Z0Nh3WDF7xZFfH1H3XWNMC1KTb6OV0nLdDuMrx82p9fEp0ZnvW23cbj1DSZHr9CKDPVSMybGozEpYx1h+tVs41od1Hjn0e33IKIUH86qfK2VhAuRg0ijbFlEau8mjuHSuZZEGSsHjZxG8Ni2kHtacztNnaMEkQ+LHRP6dHgESXcqujl5WNaiUvSz6pX0OhbQKVfWlNStjuqXA7nuGArbco9eEc5jqYVlLMZu07dzmqKXWh1S2mBBFpYT9ym+TrDvWyIYko25+rAti1DQUNjpVXGCBPtemqKIKhR/RT+697Kj0bMTPjUA3rHDBV5MeewaPcAUkU2LJcVbY+SgeKvlSXbAx+7P6bcjjGtYJ5xy43KfUUCT3vZvHnQBjvWbG65Uv+bLhYw1ClQRkTsm2PIGN5vFws52KwjY74Mayl0x/1J9xur4yy5+xUgCbXmUQ70mykNcVnhosrD3zKfqxGB3m2wjcbi9kbxLQvOulEyNbqOs6yrAvxEbGRpB4pDuGMlLvvoEnizQ/oQa8CVspD9P21ppTbXDl0YmsTDU11F6Z2WaD0mWzvg5zz/Do3ttvSeRtof7855MTJ9a0vVRohVT/UqqmQcZeExR1hX3ikSMs7h8Ggtq9WBL6huIg74Brf5bAOETZGlMl
 Zeh9B+yt
 tQ6qGPnewD0PCKZuBjvyG2xXHnAu9pTvgrwwWrrxsKvm1elAKypryo7N46MAU7T9ZNrcdQopnMRM0UASFCfSt0hGP5YprEgTuav8XhcQA29RwFd4SEGpNCSWT7jBUQjGcUw3Gh65PYbXv9d6HJ+E29ieJV2Rp8LwyXhvbv4xcscpxuJ+t9InA9ErTOk0MQd9r1qmjlBgUmw8wa6pN7zBHOt6d1i0CShh3JIHBWWpSgMNuWyY9x8eKZk5dS/ohQRxG+NGlIQVVBzShwyHP/kdRRuKZR3MYXgqrmteCNHTqT9rnjAM8+cfp5X01g89kK1iMFp/di1CEY/M4WsK2iEFlFsi02u79PjUH+P7bISXZHvs1dRJ5lQ+u/+scNBT4+rt1+/owtj4YBZsjdb+UVkL+s4/X8cCrZdND+KpT0jjFRLjXhh2cIeZMpSr8d148BQyT+GbUuOQjPTAChM+DQZYoV6kmUymnsw9taM86cX3yL2r7uL3cEIel2iLRRFmG4efJ0iJWNR6/Prt3QbhMFrZvTe1SmqAFfI4RZL/qr/T64bQAJikhitgw7S9CzugB1r9kboeEl95yNm9SMlTBZD0ZJT3TrpqOYB3wXH/eaxPPT8i2nutbJeYDYUEfSHGmwf6HYSj4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mempool_alloc_bulk was modelled after the alloc_pages_bulk API,
including some misunderstanding of it.

Remove checking for NULL slots in the array, as alloc_pages_bulk and
kmem_cache_alloc_bulk always fill the array from the beginning and thus
we know the offset of the first failing allocation.  This removes support
for working well with alloc_pages_bulk used to refill page arrays that
might have an entry removed from in the middle, but that is only used by
sunrpc and hopefully on it's way out.

Also remove the allocated parameter as it is redundant because the caller
can simply specific and offset into the entries array.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-crypto-fallback.c |  9 +++++----
 include/linux/mempool.h     |  2 +-
 mm/mempool.c                | 27 ++++++++++-----------------
 3 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index 61f595410832..ab6924fba280 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -199,8 +199,8 @@ static struct bio *blk_crypto_alloc_enc_bio(struct bio *bio_src,
 	pages += nr_segs * (PAGE_PTRS_PER_BVEC - 1);
 
 	/*
-	 * Try a bulk allocation first.  This could leave random pages in the
-	 * array unallocated, but we'll fix that up later in mempool_alloc_bulk.
+	 * Try a bulk allocation first.  This might not fill all allocated
+	 * pages, but we'll fix that up later in mempool_alloc_bulk.
 	 *
 	 * Note: alloc_pages_bulk needs the array to be zeroed, as it assumes
 	 * any non-zero slot already contains a valid allocation.
@@ -208,8 +208,9 @@ static struct bio *blk_crypto_alloc_enc_bio(struct bio *bio_src,
 	memset(pages, 0, sizeof(struct page *) * nr_segs);
 	nr_allocated = alloc_pages_bulk(GFP_KERNEL, nr_segs, pages);
 	if (nr_allocated < nr_segs)
-		mempool_alloc_bulk(blk_crypto_bounce_page_pool, (void **)pages,
-				nr_segs, nr_allocated);
+		mempool_alloc_bulk(blk_crypto_bounce_page_pool,
+				(void **)pages + nr_allocated,
+				nr_segs - nr_allocated);
 	memalloc_noio_restore(memflags);
 	*pages_ret = pages;
 	return bio;
diff --git a/include/linux/mempool.h b/include/linux/mempool.h
index e8e440e04a06..a0fa6d43e0dc 100644
--- a/include/linux/mempool.h
+++ b/include/linux/mempool.h
@@ -66,7 +66,7 @@ void *mempool_alloc_noprof(struct mempool *pool, gfp_t gfp_mask) __malloc;
 #define mempool_alloc(...)						\
 	alloc_hooks(mempool_alloc_noprof(__VA_ARGS__))
 int mempool_alloc_bulk_noprof(struct mempool *pool, void **elem,
-		unsigned int count, unsigned int allocated);
+		unsigned int count);
 #define mempool_alloc_bulk(...)						\
 	alloc_hooks(mempool_alloc_bulk_noprof(__VA_ARGS__))
 
diff --git a/mm/mempool.c b/mm/mempool.c
index db23e0eef652..473a029fa31f 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -419,12 +419,8 @@ static unsigned int mempool_alloc_from_pool(struct mempool *pool, void **elems,
 	spin_lock_irqsave(&pool->lock, flags);
 	if (unlikely(pool->curr_nr < count - allocated))
 		goto fail;
-	for (i = 0; i < count; i++) {
-		if (!elems[i]) {
-			elems[i] = remove_element(pool);
-			allocated++;
-		}
-	}
+	while (allocated < count)
+		elems[allocated++] = remove_element(pool);
 	spin_unlock_irqrestore(&pool->lock, flags);
 
 	/* Paired with rmb in mempool_free(), read comment there. */
@@ -479,22 +475,21 @@ static inline gfp_t mempool_adjust_gfp(gfp_t *gfp_mask)
  * @pool:	pointer to the memory pool
  * @elems:	partially or fully populated elements array
  * @count:	number of entries in @elem that need to be allocated
- * @allocated:	number of entries in @elem already allocated
  *
- * Allocate elements for each slot in @elem that is non-%NULL. This is done by
- * first calling into the alloc_fn supplied at pool initialization time, and
- * dipping into the reserved pool when alloc_fn fails to allocate an element.
+ * Allocate @count elements into @elems.  This is done by first calling into the
+ * alloc_fn supplied at pool initialization time, and dipping into the reserved
+ * pool when alloc_fn fails to allocate an element.
  *
  * On return all @count elements in @elems will be populated.
  *
  * Return: Always 0.  If it wasn't for %$#^$ alloc tags, it would return void.
  */
 int mempool_alloc_bulk_noprof(struct mempool *pool, void **elems,
-		unsigned int count, unsigned int allocated)
+		unsigned int count)
 {
 	gfp_t gfp_mask = GFP_KERNEL;
 	gfp_t gfp_temp = mempool_adjust_gfp(&gfp_mask);
-	unsigned int i = 0;
+	unsigned int allocated = 0;
 
 	VM_WARN_ON_ONCE(count > pool->min_nr);
 	might_alloc(gfp_mask);
@@ -514,11 +509,9 @@ int mempool_alloc_bulk_noprof(struct mempool *pool, void **elems,
 	 * Try to allocate the elements using the allocation callback first as
 	 * that might succeed even when the caller's bulk allocation did not.
 	 */
-	for (i = 0; i < count; i++) {
-		if (elems[i])
-			continue;
-		elems[i] = pool->alloc(gfp_temp, pool->pool_data);
-		if (unlikely(!elems[i]))
+	while (allocated < count) {
+		elems[allocated] = pool->alloc(gfp_temp, pool->pool_data);
+		if (unlikely(!elems[allocated]))
 			goto use_pool;
 		allocated++;
 	}
-- 
2.53.0


