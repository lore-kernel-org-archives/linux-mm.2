Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82C0BCCF9FF
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 09:35:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E302E8E00DC; Fri, 31 Oct 2025 05:35:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E082F8E0042; Fri, 31 Oct 2025 05:35:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1DEB8E00DC; Fri, 31 Oct 2025 05:35:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BCCA98E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 05:35:42 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 51708160421
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:35:42 +0000 (UTC)
X-FDA: 84057902124.02.5B55B16
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9B071C000B
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:35:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=KaxaaIF6;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf28.hostedemail.com: domain of BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761903340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nuQqDH9i4//FEduS8ktJVpYT3Izhdhj+6SksuFO2tVc=;
	b=zcMTIjjqsJJ4VWC7zlPvHl4nOeeEyvnd0c9ujtb6iLlopmnnCBEOdmUqMnkiXLcdM2wLRt
	2bZvg8jlIgAR8RjsxjCVG6dNuLbHsUM0+ZbyT4bQSVQl8RFl0HWaeMIAfb+/s7BeBLOr4W
	JeCAZgFfLHuosnNSbR5FaM3TPCzRgXg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761903340; a=rsa-sha256;
	cv=none;
	b=GtkNNJkbBufvYGAYjNFWrJSpKAtS4KMH6IIuMx2ykBr/o9xBnf2UnIopljkcFZMb6A6CUe
	oR5gE4vPQZg2TJ0Q0UqeWGXGLfuad3TQxGILaLPE+1V6bAqkgdrWkbQuOtLeL7vNl4Enxx
	sBCQ0WdkzQpGZMgSmu3JnCs/sIrayo0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=KaxaaIF6;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf28.hostedemail.com: domain of BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nuQqDH9i4//FEduS8ktJVpYT3Izhdhj+6SksuFO2tVc=; b=KaxaaIF6mxtlKDukKBNc6C60Su
	GlJCAmIzxsEkUM6JKoICqV+QZfYDDMiG5ebFuZBMqy9wVWa62PTlJqlbuAiOz9KC+rMRMbJCTrBYG
	FZryhL1Be+aJ4kqcLKLuK5D9JbDuoPzfmZF30QGZrLNM9vFINxmjkdTlQ0Lfjm0vB+AfI02FFpQvg
	USlIbegEUGsKKvmlVvmiIhMJL663VntxfDWe4zFyWZrheqQ0rKVlBK3RrB9mKDtSeJnn6CEZ8b0WL
	tjvKzj0hI8OJjaawwFEDNy2EFrsRJWiyBpMXB2jzyyZiS/gTNdxDTUAHFOiIGI5IraCP1+U9mpNx4
	NiE89rWg==;
Received: from [2001:4bb8:2dc:1001:a959:25cf:98e9:329b] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vElXl-00000005opy-2vLS;
	Fri, 31 Oct 2025 09:35:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Eric Biggers <ebiggers@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/9] mempool: add mempool_{alloc,free}_bulk
Date: Fri, 31 Oct 2025 10:34:33 +0100
Message-ID: <20251031093517.1603379-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251031093517.1603379-1-hch@lst.de>
References: <20251031093517.1603379-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B071C000B
X-Rspamd-Server: rspam02
X-Stat-Signature: 86569psp3h9d98f6efzzn4nrq3ke1rqm
X-HE-Tag: 1761903340-584468
X-HE-Meta: U2FsdGVkX18N2AWWttY3eRzCEbz8QYv4kXyl/Jm5UcOx9vHgDba5a81jH2q2+kaf3zxvOM6ResHoX55HTtHD7NgjF2SIbdlPckmt72p+UhZOzvLOD/YdX/oC89COGBSmD+JKTHEj04saRwh9WSDFoooAyucRzgKbQo0B4qTjnOQAAqUJtPid9RnN3gW80Ggqu4JtuMAc6byxWuIbYOsac+BFEX9JhkYh4SrlFIe2uSe/LgP4ncdA4Ssu4XMB74IeWQFqXqOe89FASq/ByCtjRWbU7mJw+1kG/Tf/ac2u8+FlAlAeaLkr9bBR+Jr/Yea0z/eCeQmi0OpNbB9P1WEQILexhLhQqCC/T17EoxPM1NufiKNMFSdpDcntlXthDyy3anw2JBCN94xpI79MVMEfx8nZs86aVy89TwDuwIxX0dc3mhLVNvBDSIj5XAL7gZcSVUMNUxAljBhTpLJ0BQ9NVsu6s1PzyGVz7BSDMX6g0D+TvUOsOHGbVvJmeGYNEVrzcyqWhXi9eRISaPb02Rle2OrhY5UP2W/NZZ3tLCT6onlk7a4ERKY8ztbnXwxK3jBw2wCH/YWhRkWbFkM57xDH+84ZJc40n7pZ719xnMLrYrJKTAT0gKiVKVFoCVkIp3gUkC5PltkAKREQVbPvmmnmEuZKxp3aPw8rtydPKNYV3jOEFoO3N3D+aQrlgQmqg4tCMlTfs6abrdiy1vNHDWzLEkhsGgZ4yybMpZX+NbZ6TyjlHx08LgAzBX/5I/PlZCehrJssbKJt3Yac0hAiBtxOnZBJXVFiIo1F7Z5tx9mtNaAyQ1MW2EAG5jL151k9M4cy+ViWcBqV5bokQa74dECzyhbUc72CogIno4oePSpfodvc/rYiJoboySwuIp0LunMeES0Xgh3VWJTokywmrcU8bsBqrG/YYe8tWJMIVffVBpILbOOW4lTiSaHWd5c/rBbqOelPB/kdN50MsqsEo7L
 CGMqle4M
 FZHPf33X+wGxj/EZQHkJFDMvwBxcIDKGbcSR8M+TuMQM3m5vVxAWbDrO2Rf+NC+qlwsU/r+ifobFXI+eh8lekZerizpVAxr8D5dDK9ukYo0Te/kZmiwIsG53rRgKWHjRS3JIuxbzPVhQD4lIIHmMQdtiQIY7Q1UNaavnvhOl28farFiwvTNfmEo1PKsHFFNWNB0k1zOVRIzf6z2d/+aqnt/SNIfs7GiBBOlLZyFOCilMFBwoqNQCiAEsmheOQ9FpXCbhLVL3S/AcI7y2JiCMN6h/nhjqhmR+ViisA+2QuYp8hCESBTtyLbw0qqskJW8uxdVtDXc+KOdkiONO1Gp9DjLjs5Ox4mjWLfIXoWDJrwIrudPRmMlufJ5GdoZJEsUkRfm1r8TpvvdDGTGI0WgLEO5/RJtPD6pOSNheyjCcucqhULJxhGRZ1onOUVIxnaGsTbMV+WTARz64ybirAGGcx/HIzRl/Pzy+km4ShSCMoDqtKoj+3uq4tOVAebyT3my1rWIz1LzYSXMqlNy8AGJMGXTlL5h4CPNlJYCc1DkfLwz+UrGXdf4hA5N4AqtxD+u0cLQgde7LsnaWINzWvds7U1F0hi+GIA5+o+VW0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a version of the mempool allocator that works for batch allocations
of multiple objects.  Calling mempool_alloc in a loop is not safe because
it could deadlock if multiple threads are performing such an allocation
at the same time.

As an extra benefit the interface is build so that the same array can be
used for alloc_pages_bulk / release_pages so that at least for page
backed mempools the fast path can use a nice batch optimization.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/mempool.h |   7 ++
 mm/mempool.c            | 145 ++++++++++++++++++++++++++++------------
 2 files changed, 111 insertions(+), 41 deletions(-)

diff --git a/include/linux/mempool.h b/include/linux/mempool.h
index 34941a4b9026..486ed50776db 100644
--- a/include/linux/mempool.h
+++ b/include/linux/mempool.h
@@ -66,9 +66,16 @@ extern void mempool_destroy(mempool_t *pool);
 extern void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask) __malloc;
 #define mempool_alloc(...)						\
 	alloc_hooks(mempool_alloc_noprof(__VA_ARGS__))
+int mempool_alloc_bulk_noprof(mempool_t *pool, void **elem,
+		unsigned int count, gfp_t gfp_mask, unsigned long caller_ip);
+#define mempool_alloc_bulk(pool, elem, count, gfp_mask)			\
+	alloc_hooks(mempool_alloc_bulk_noprof(pool, elem, count, gfp_mask, \
+			_RET_IP_))
 
 extern void *mempool_alloc_preallocated(mempool_t *pool) __malloc;
 extern void mempool_free(void *element, mempool_t *pool);
+unsigned int mempool_free_bulk(mempool_t *pool, void **elem,
+		unsigned int count);
 
 /*
  * A mempool_alloc_t and mempool_free_t that get the memory from
diff --git a/mm/mempool.c b/mm/mempool.c
index 15581179c8b9..c980a0396986 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -381,23 +381,29 @@ int mempool_resize(mempool_t *pool, int new_min_nr)
 EXPORT_SYMBOL(mempool_resize);
 
 /**
- * mempool_alloc - allocate an element from a memory pool
+ * mempool_alloc_bulk - allocate multiple elements from a memory pool
  * @pool:	pointer to the memory pool
+ * @elem:	partially or fully populated elements array
+ * @count:	size (in entries) of @elem
  * @gfp_mask:	GFP_* flags.
  *
+ * Allocate elements for each slot in @elem that is non-%NULL.
+ *
  * Note: This function only sleeps if the alloc_fn callback sleeps or returns
  * %NULL.  Using __GFP_ZERO is not supported.
  *
- * Return: pointer to the allocated element or %NULL on error. This function
- * never returns %NULL when @gfp_mask allows sleeping.
+ * Return: 0 if successful, else -ENOMEM.  This function never returns -ENOMEM
+ * when @gfp_mask allows sleeping.
  */
-void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
+int mempool_alloc_bulk_noprof(struct mempool *pool, void **elem,
+		unsigned int count, gfp_t gfp_mask, unsigned long caller_ip)
 {
-	void *element;
 	unsigned long flags;
 	wait_queue_entry_t wait;
 	gfp_t gfp_temp;
+	unsigned int i;
 
+	VM_WARN_ON_ONCE(count > pool->min_nr);
 	VM_WARN_ON_ONCE(gfp_mask & __GFP_ZERO);
 	might_alloc(gfp_mask);
 
@@ -407,20 +413,31 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
 
 	gfp_temp = gfp_mask & ~(__GFP_DIRECT_RECLAIM|__GFP_IO);
 
+	i = 0;
 repeat_alloc:
-	if (should_fail_ex(&fail_mempool_alloc, 1, FAULT_NOWARN)) {
-		pr_info("forcing mempool usage for pool %pS\n",
-				(void *)_RET_IP_);
-		element = NULL;
-	} else {
-		element = pool->alloc(gfp_temp, pool->pool_data);
-		if (likely(element != NULL))
-			return element;
+	for (; i < count; i++) {
+		if (!elem[i]) {
+			if (should_fail_ex(&fail_mempool_alloc, 1,
+					FAULT_NOWARN)) {
+				pr_info("forcing pool usage for pool %pS\n",
+					(void *)caller_ip);
+				goto use_pool;
+			}
+			elem[i] = pool->alloc(gfp_temp, pool->pool_data);
+			if (unlikely(!elem[i]))
+				goto use_pool;
+		}
 	}
 
+	return 0;
+
+use_pool:
 	spin_lock_irqsave(&pool->lock, flags);
-	if (likely(pool->curr_nr)) {
-		element = remove_element(pool);
+	if (likely(pool->curr_nr >= count - i)) {
+		for (; i < count; i++) {
+			if (!elem[i])
+				elem[i] = remove_element(pool);
+		}
 		spin_unlock_irqrestore(&pool->lock, flags);
 		/* paired with rmb in mempool_free(), read comment there */
 		smp_wmb();
@@ -428,8 +445,9 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
 		 * Update the allocation stack trace as this is more useful
 		 * for debugging.
 		 */
-		kmemleak_update_trace(element);
-		return element;
+		for (i = 0; i < count; i++)
+			kmemleak_update_trace(elem[i]);
+		return 0;
 	}
 
 	/*
@@ -445,10 +463,12 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
 	/* We must not sleep if !__GFP_DIRECT_RECLAIM */
 	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
 		spin_unlock_irqrestore(&pool->lock, flags);
-		return NULL;
+		if (i > 0)
+			mempool_free_bulk(pool, elem + i, count - i);
+		return -ENOMEM;
 	}
 
-	/* Let's wait for someone else to return an element to @pool */
+	/* Let's wait for someone else to return elements to @pool */
 	init_wait(&wait);
 	prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
 
@@ -463,6 +483,27 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
 	finish_wait(&pool->wait, &wait);
 	goto repeat_alloc;
 }
+EXPORT_SYMBOL_GPL(mempool_alloc_bulk_noprof);
+
+/**
+ * mempool_alloc - allocate an element from a memory pool
+ * @pool:	pointer to the memory pool
+ * @gfp_mask:	GFP_* flags.
+ *
+ * Note: This function only sleeps if the alloc_fn callback sleeps or returns
+ * %NULL.  Using __GFP_ZERO is not supported.
+ *
+ * Return: pointer to the allocated element or %NULL on error. This function
+ * never returns %NULL when @gfp_mask allows sleeping.
+ */
+void *mempool_alloc_noprof(struct mempool *pool, gfp_t gfp_mask)
+{
+	void *elem[1] = { };
+
+	if (mempool_alloc_bulk_noprof(pool, elem, 1, gfp_mask, _RET_IP_) < 0)
+		return NULL;
+	return elem[0];
+}
 EXPORT_SYMBOL(mempool_alloc_noprof);
 
 /**
@@ -502,21 +543,26 @@ void *mempool_alloc_preallocated(mempool_t *pool)
 EXPORT_SYMBOL(mempool_alloc_preallocated);
 
 /**
- * mempool_free - return an element to a mempool
- * @element:	pointer to element
+ * mempool_free_bulk - return elements to a mempool
  * @pool:	pointer to the memory pool
+ * @elem:	elements to return
+ * @count:	number of elements to return
  *
- * Returns @elem to @pool if its needs replenishing, else free it using
- * the free_fn callback in @pool.
+ * Returns elements from @elem to @pool if its needs replenishing and sets
+ * their slot in @elem to NULL.  Other elements are left in @elem.
+ *
+ * Return: number of elements transferred to @pool.  Elements are always
+ * transferred from the beginning of @elem, so the return value can be used as
+ * an offset into @elem for the freeing the remaining elements in the caller.
  *
  * This function only sleeps if the free_fn callback sleeps.
  */
-void mempool_free(void *element, mempool_t *pool)
+unsigned int mempool_free_bulk(struct mempool *pool, void **elem,
+		unsigned int count)
 {
 	unsigned long flags;
-
-	if (unlikely(element == NULL))
-		return;
+	bool added = false;
+	unsigned int freed = 0;
 
 	/*
 	 * Paired with the wmb in mempool_alloc().  The preceding read is
@@ -553,15 +599,11 @@ void mempool_free(void *element, mempool_t *pool)
 	 */
 	if (unlikely(READ_ONCE(pool->curr_nr) < pool->min_nr)) {
 		spin_lock_irqsave(&pool->lock, flags);
-		if (likely(pool->curr_nr < pool->min_nr)) {
-			add_element(pool, element);
-			spin_unlock_irqrestore(&pool->lock, flags);
-			if (wq_has_sleeper(&pool->wait))
-				wake_up(&pool->wait);
-			return;
+		while (pool->curr_nr < pool->min_nr && freed < count) {
+			add_element(pool, elem[freed++]);
+			added = true;
 		}
 		spin_unlock_irqrestore(&pool->lock, flags);
-	}
 
 	/*
 	 * Handle the min_nr = 0 edge case:
@@ -572,20 +614,41 @@ void mempool_free(void *element, mempool_t *pool)
 	 * allocation of element when both min_nr and curr_nr are 0, and
 	 * any active waiters are properly awakened.
 	 */
-	if (unlikely(pool->min_nr == 0 &&
+	} else if (unlikely(pool->min_nr == 0 &&
 		     READ_ONCE(pool->curr_nr) == 0)) {
 		spin_lock_irqsave(&pool->lock, flags);
 		if (likely(pool->curr_nr == 0)) {
-			add_element(pool, element);
-			spin_unlock_irqrestore(&pool->lock, flags);
-			if (wq_has_sleeper(&pool->wait))
-				wake_up(&pool->wait);
-			return;
+			add_element(pool, elem[freed++]);
+			added = true;
 		}
 		spin_unlock_irqrestore(&pool->lock, flags);
 	}
 
-	pool->free(element, pool->pool_data);
+	if (unlikely(added) && wq_has_sleeper(&pool->wait))
+		wake_up(&pool->wait);
+
+	return freed;
+}
+EXPORT_SYMBOL_GPL(mempool_free_bulk);
+
+/**
+ * mempool_free - return an element to the pool.
+ * @element:	element to return
+ * @pool:	pointer to the memory pool
+ *
+ * Returns @elem to @pool if its needs replenishing, else free it using
+ * the free_fn callback in @pool.
+ *
+ * This function only sleeps if the free_fn callback sleeps.
+ */
+void mempool_free(void *element, struct mempool *pool)
+{
+	if (likely(element)) {
+		void *elem[1] = { element };
+
+		if (!mempool_free_bulk(pool, elem, 1))
+			pool->free(element, pool->pool_data);
+	}
 }
 EXPORT_SYMBOL(mempool_free);
 
-- 
2.47.3


