Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71151CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 13:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D30958E000F; Tue, 11 Nov 2025 08:53:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDFA88E0002; Tue, 11 Nov 2025 08:53:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1D118E000F; Tue, 11 Nov 2025 08:53:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF9A88E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:53:48 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4FF47598AA
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:53:48 +0000 (UTC)
X-FDA: 84098469336.02.C4A195A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id 97FB0C000B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:53:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Wy8T808g;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf22.hostedemail.com: domain of BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762869226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wQcuu7VaQGCF87dPhrIRwVsAsL1vlnQ6T/IgSFkHcWQ=;
	b=7YQUKoRcHe7GybUuVUBl+q0rmCWRqm9Z+N03ju3DrShJ6p7n5PSd4v9edh4fxx/3f36USt
	rRHvmOXraJ2odXCU4cmQU3Wv3mN6uXeGbjopw/DNwoz+C0cxqTtA5WWS3Dz3GlHG7WFIbs
	6prIlRN3IPAPhhMVl9CNKFkI7FLCDFU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762869226; a=rsa-sha256;
	cv=none;
	b=CXv0i+XDliBSt+IdbSUA50/YyGVLuU9yKyq+Fkd4IiqyRWIOuXXSasQnz/sKmITNaDc6ol
	AsTBEuhYwNg1yuH02bZNR1vAzX0ND8aVEGI4X07L6274Qb/4RmrJ/5DNiyo2ZmtzWDJpH9
	337lHGiXNFD3XDh0Zp06+ODVXNYvw80=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Wy8T808g;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf22.hostedemail.com: domain of BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wQcuu7VaQGCF87dPhrIRwVsAsL1vlnQ6T/IgSFkHcWQ=; b=Wy8T808gp0Sb3xawqNntZZU7O5
	105H+56N/YGQr5K+Tdoc23Eq5QC47U0ceCdtqpEO0xhSz85bNPbEqE+2G9SE/Bu8HDjxGInSVUPOb
	2eFMpUxf4goeRuUMklg+16hjxh5DiQO8+BD9ZcLgAopd6fPxlxcDhmxAOAEG4OYh714zeVoKIKNOu
	qN4qlaMS2SXIhYqKqDwX50mOuzQMKhjMknyEpvJfFhliLazCQ0R3aTo6N4p/PcpSkooZBTyLOacW/
	eCgLLMds1vD37xgRHZbBfwfyKfDdq3NUurFNSjoQKtv+JR5uFYShhDapDsjC/ws/dfyXnqJBGpD6r
	bOJYXqLg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIooZ-00000007GeR-1oyQ;
	Tue, 11 Nov 2025 13:53:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] mempool: add mempool_{alloc,free}_bulk
Date: Tue, 11 Nov 2025 14:52:35 +0100
Message-ID: <20251111135300.752962-8-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251111135300.752962-1-hch@lst.de>
References: <20251111135300.752962-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: 3ht6qoagsfn77fw6xn4s3kh1k555peo4
X-Rspam-User: 
X-Rspamd-Queue-Id: 97FB0C000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1762869226-221279
X-HE-Meta: U2FsdGVkX1/MaTI+RQVDs4Gdt9rdy4AhAlQ0f7pQWeG7IMBtW9qfwV1s1HWpYpAEI8BRBpyJf/7upe1/AVztHM8UhKDFdRn19W3aJyvmEPH/0Wclrx/WWuEAUyX/y6iZjFuE+cZMeX3dXdHgR+ulpgdHEVRT/fEHRswY5Z4od/nBBz6VE4tJWNY5rbpI/fRp/WnI0EkLGbbJ8jz7MgCcek0ckbit+MPtZnbVSEiejXqrO6PrQ+t0+HnudXACghLFd9A4Z0rfLQSR1FBgaa+xvbukk3ZZpogJJ55Rmqin8fpyh5dSd8cZE2AsdGidB/0ote8i1ew8NmApb59GSZ/3tPke6E1Qz+njBAvjJ42kwtneu9f1ojlSw3HJBs2QRptAiqXs6FVnsdvHTBLCSfpxtKhXNsraDElUeiYylGBe4c1GHBQM0KeVUa+3KKaKSaocqpdbpSErTzwbxI49FxTKof8fF265y+YxFX0n9pZv7vJ6pO1cFHIlKtK5BnEY5vSnp55TkvdTYewyEh5rHppTiG+3bzHftPkKBEDOLlp5TtU1Jc5PUG8ezOmJFc9184ZBdHjcynnYi7+gM0Hv/PAyINUlhkozrd0FtK9IqC/lgC0gkyTp7y8SMgyMaul4uOzCWA/19z358qK3tJ9AF8Nhx/Cp+gNLTZcUoc54L1pK8KtLnz8wQobkIcOCWlQKmArqeJl/9fa+4DqRemgvqWAWljoPSemF6fMfCPjeZlxSKja0uLoG6rCFAcbKVftunjF20mJakn+CPsKdF0aHfLo4/yP9XAGdr9aXsQYWEMrzVbPyrod5K22Ju4bGoOjdZ1UpleZSAnxbazCqVsnE6hdZHwlM3Rr+BgP0WdCpX0KJY9+S2lI8HY47SnS3DnSyGPrGFpUB80yr7+tUvkhV6TH9aQNql8w/0S0uUmpusJDqp8aHCwBgNgLFvcpQRpzJ0LE00eQxIFluVxuNoroGR2R
 rgU8+VUk
 jGOPT+Cp14D1co85MPbaBXfhNe80tat4yf8HP5E764wU0WnbzRfC6IO4V0AGjxAkSJ5fKvQRIvT2gVLnr+/ZQptQdt1ObxN33pZKzI9cgJ7n6rlG0/AT2BZQpLevrIhQPgO0icz/XT/6IA+2qDAhCjLW1GRbrSnWyPgr/faljxNkwrzVW3O91MdWuN/fz+5Rt/WtTflE1RpaXB7yundWCgQiaE60Xl7TQt6sLnZsvARdyeXg9jQn8vxLtGAGX3j50Y9aCnWfR56b6xGpsivPCawEnllcJvGNOQHZhqjf9F2bJYM+nKkFHLUWJ6/a+MfaxeS4ePhmVVRwz6acTYgM6L6siyly8zaJBylgI+NL5HCCblDYYItidXfU7xILyNhWgZk7hNfM6ZOerwdLabN3/eFlzNs/SZC6F2jGG1wEksDzPyqZshdvLYm1QKIRFWR5pZ4FSsVl6Hi/RzNeqBWVhCsOiYfncfOCO/VJ1/HcfWxfWPqOaqxkktZTelc2W97qd7XnSR1LkfY4BfxYMbhqgbjBjGd9IQvIj1SuuyqsOz7RMwLAacQr+AOvz8bkTMPRywMvVAQuE4GPyrWaAYj8AwlkGcZ6rMMNOfm+D
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
 mm/mempool.c            | 182 ++++++++++++++++++++++++++++++----------
 2 files changed, 145 insertions(+), 44 deletions(-)

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
index 8cf3b5705b7f..e2f05bec633b 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -21,11 +21,16 @@
 #include "slab.h"
 
 static DECLARE_FAULT_ATTR(fail_mempool_alloc);
+static DECLARE_FAULT_ATTR(fail_mempool_alloc_bulk);
 
 static int __init mempool_faul_inject_init(void)
 {
-	return PTR_ERR_OR_ZERO(fault_create_debugfs_attr("fail_mempool_alloc",
-			NULL, &fail_mempool_alloc));
+	if (IS_ERR(fault_create_debugfs_attr("fail_mempool_alloc", NULL,
+			&fail_mempool_alloc)) ||
+	    IS_ERR(fault_create_debugfs_attr("fail_mempool_alloc_bulk", NULL,
+			&fail_mempool_alloc_bulk)))
+		return -ENOMEM;
+	return 0;
 }
 late_initcall(mempool_faul_inject_init);
 
@@ -380,16 +385,21 @@ int mempool_resize(mempool_t *pool, int new_min_nr)
 }
 EXPORT_SYMBOL(mempool_resize);
 
-static void *mempool_alloc_from_pool(struct mempool *pool, gfp_t gfp_mask)
+static bool mempool_alloc_from_pool(struct mempool *pool, void **elems,
+		unsigned int count, unsigned int allocated,
+		gfp_t gfp_mask)
 {
 	unsigned long flags;
-	void *element;
+	unsigned int i;
 
 	spin_lock_irqsave(&pool->lock, flags);
-	if (unlikely(!pool->curr_nr))
+	if (unlikely(pool->curr_nr < count - allocated))
 		goto fail;
 alloc:
-	element = remove_element(pool);
+	for (; allocated < count; allocated++) {
+		if (!elems[allocated])
+			elems[allocated] = remove_element(pool);
+	}
 	spin_unlock_irqrestore(&pool->lock, flags);
 
 	/* Paired with rmb in mempool_free(), read comment there. */
@@ -399,15 +409,16 @@ static void *mempool_alloc_from_pool(struct mempool *pool, gfp_t gfp_mask)
 	 * Update the allocation stack trace as this is more useful for
 	 * debugging.
 	 */
-	kmemleak_update_trace(element);
-	return element;
+	for (i = 0; i < count; i++)
+		kmemleak_update_trace(elems[i]);
+	return true;
 
 fail:
 	if (gfp_mask & __GFP_DIRECT_RECLAIM) {
 		DEFINE_WAIT(wait);
 
 		prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
-		if (pool->curr_nr) {
+		if (pool->curr_nr >= count - allocated) {
 			finish_wait(&pool->wait, &wait);
 			goto alloc;
 		}
@@ -426,7 +437,7 @@ static void *mempool_alloc_from_pool(struct mempool *pool, gfp_t gfp_mask)
 		spin_unlock_irqrestore(&pool->lock, flags);
 	}
 
-	return NULL;
+	return false;
 }
 
 /*
@@ -442,6 +453,72 @@ static inline gfp_t mempool_adjust_gfp(gfp_t *gfp_mask)
 	return *gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_IO);
 }
 
+/**
+ * mempool_alloc_bulk - allocate multiple elements from a memory pool
+ * @pool:	pointer to the memory pool
+ * @elems:	partially or fully populated elements array
+ * @count:	size (in entries) of @elem
+ * @gfp_mask:	GFP_* flags.  %__GFP_ZERO is not supported.
+ *
+ * Allocate elements for each slot in @elem that is non-%NULL. This is done by
+ * first calling into the alloc_fn supplied at pool initialization time, and
+ * dipping into the reserved pool when alloc_fn fails to allocate an element.
+ *
+ * This function only sleeps if the alloc_fn callback sleeps, or when waiting
+ * for elements to become available in the pool.
+ *
+ * Return: Always 0.  If it wasn't for %$#^$ alloc tags, it would return void.
+ */
+int mempool_alloc_bulk_noprof(struct mempool *pool, void **elems,
+		unsigned int count, gfp_t gfp_mask, unsigned long caller_ip)
+{
+	gfp_t gfp_temp = mempool_adjust_gfp(&gfp_mask);
+	unsigned int i = 0;
+
+	VM_WARN_ON_ONCE(count > pool->min_nr);
+	VM_WARN_ON_ONCE(!(gfp_mask & __GFP_DIRECT_RECLAIM));
+	VM_WARN_ON_ONCE(gfp_mask & __GFP_ZERO);
+	might_alloc(gfp_mask);
+
+	/*
+	 * If an error is injected, fail all elements in a bulk allocation so
+	 * that we stress the multiple elements missing path.
+	 */
+	if (should_fail_ex(&fail_mempool_alloc_bulk, 1, FAULT_NOWARN)) {
+		pr_info("forcing mempool usage for pool %pS\n",
+				(void *)_RET_IP_);
+		goto use_pool;
+	}
+
+repeat_alloc:
+	/*
+	 * Try to allocate the elements using the allocation callback.  If that
+	 * succeeds or we were not allowed to sleep, return now.  Don't dip into
+	 * the reserved pools for !__GFP_DIRECT_RECLAIM allocations as they
+	 * aren't guaranteed to succeed and chances of getting an allocation
+	 * from the allocators using GFP_ATOMIC is higher than stealing one of
+	 * the few items from our usually small pool.
+	 */
+	for (; i < count; i++) {
+		if (!elems[i]) {
+			elems[i] = pool->alloc(gfp_temp, pool->pool_data);
+			if (unlikely(!elems[i]))
+				goto use_pool;
+		}
+	}
+
+	return 0;
+
+use_pool:
+	if (!mempool_alloc_from_pool(pool, elems, count, i, gfp_temp)) {
+		gfp_temp = gfp_mask;
+		goto repeat_alloc;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mempool_alloc_bulk_noprof);
+
 /**
  * mempool_alloc - allocate an element from a memory pool
  * @pool:	pointer to the memory pool
@@ -483,8 +560,8 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
 		 * sleep in mempool_alloc_from_pool.  Retry the allocation
 		 * with all flags set in that case.
 		 */
-		element = mempool_alloc_from_pool(pool, gfp_mask);
-		if (!element && gfp_temp != gfp_mask) {
+		if (!mempool_alloc_from_pool(pool, &element, 1, 0, gfp_mask) &&
+		    gfp_temp != gfp_mask) {
 			gfp_temp = gfp_mask;
 			goto repeat_alloc;
 		}
@@ -508,26 +585,33 @@ EXPORT_SYMBOL(mempool_alloc_noprof);
  */
 void *mempool_alloc_preallocated(mempool_t *pool)
 {
-	return mempool_alloc_from_pool(pool, GFP_NOWAIT);
+	void *element = NULL;
+
+	mempool_alloc_from_pool(pool, &element, 1, 0, GFP_NOWAIT);
+	return element;
 }
 EXPORT_SYMBOL(mempool_alloc_preallocated);
 
 /**
- * mempool_free - return an element to a mempool
- * @element:	pointer to element
+ * mempool_free_bulk - return elements to a mempool
  * @pool:	pointer to the memory pool
+ * @elems:	elements to return
+ * @count:	number of elements to return
  *
- * Returns @element to @pool if it needs replenishing, else frees it using
- * the free_fn callback in @pool.
+ * Returns a number of elements from the start of @elem to @pool if @pool needs
+ * replenishing and sets their slots in @elem to NULL.  Other elements are left
+ * in @elem.
  *
- * This function only sleeps if the free_fn callback sleeps.
+ * Return: number of elements transferred to @pool.  Elements are always
+ * transferred from the beginning of @elem, so the return value can be used as
+ * an offset into @elem for the freeing the remaining elements in the caller.
  */
-void mempool_free(void *element, mempool_t *pool)
+unsigned int mempool_free_bulk(struct mempool *pool, void **elems,
+		unsigned int count)
 {
 	unsigned long flags;
-
-	if (unlikely(element == NULL))
-		return;
+	unsigned int freed = 0;
+	bool added = false;
 
 	/*
 	 * Paired with the wmb in mempool_alloc().  The preceding read is
@@ -561,21 +645,6 @@ void mempool_free(void *element, mempool_t *pool)
 	 * Waiters happen iff curr_nr is 0 and the above guarantee also
 	 * ensures that there will be frees which return elements to the
 	 * pool waking up the waiters.
-	 */
-	if (unlikely(READ_ONCE(pool->curr_nr) < pool->min_nr)) {
-		spin_lock_irqsave(&pool->lock, flags);
-		if (likely(pool->curr_nr < pool->min_nr)) {
-			add_element(pool, element);
-			spin_unlock_irqrestore(&pool->lock, flags);
-			if (wq_has_sleeper(&pool->wait))
-				wake_up(&pool->wait);
-			return;
-		}
-		spin_unlock_irqrestore(&pool->lock, flags);
-	}
-
-	/*
-	 * Handle the min_nr = 0 edge case:
 	 *
 	 * For zero-minimum pools, curr_nr < min_nr (0 < 0) never succeeds,
 	 * so waiters sleeping on pool->wait would never be woken by the
@@ -583,20 +652,45 @@ void mempool_free(void *element, mempool_t *pool)
 	 * allocation of element when both min_nr and curr_nr are 0, and
 	 * any active waiters are properly awakened.
 	 */
-	if (unlikely(pool->min_nr == 0 &&
+	if (unlikely(READ_ONCE(pool->curr_nr) < pool->min_nr)) {
+		spin_lock_irqsave(&pool->lock, flags);
+		while (pool->curr_nr < pool->min_nr && freed < count) {
+			add_element(pool, elems[freed++]);
+			added = true;
+		}
+		spin_unlock_irqrestore(&pool->lock, flags);
+	} else if (unlikely(pool->min_nr == 0 &&
 		     READ_ONCE(pool->curr_nr) == 0)) {
+		/* Handle the min_nr = 0 edge case: */
 		spin_lock_irqsave(&pool->lock, flags);
 		if (likely(pool->curr_nr == 0)) {
-			add_element(pool, element);
-			spin_unlock_irqrestore(&pool->lock, flags);
-			if (wq_has_sleeper(&pool->wait))
-				wake_up(&pool->wait);
-			return;
+			add_element(pool, elems[freed++]);
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
+ * Returns @element to @pool if it needs replenishing, else frees it using
+ * the free_fn callback in @pool.
+ *
+ * This function only sleeps if the free_fn callback sleeps.
+ */
+void mempool_free(void *element, struct mempool *pool)
+{
+	if (likely(element) && !mempool_free_bulk(pool, &element, 1))
+		pool->free(element, pool->pool_data);
 }
 EXPORT_SYMBOL(mempool_free);
 
-- 
2.47.3


