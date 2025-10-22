Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C78D1CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 06:47:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A58E8E000D; Wed, 22 Oct 2025 02:47:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17CFC8E0002; Wed, 22 Oct 2025 02:47:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B9958E000D; Wed, 22 Oct 2025 02:47:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EDAEE8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 02:47:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 967125B39E
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:47:13 +0000 (UTC)
X-FDA: 84024818346.12.FEF126D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id F118DC0005
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:47:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ydOkPqfF
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761115632; a=rsa-sha256;
	cv=none;
	b=oMyUBIEorV214udNN3kRFbay6KHUSl5E8fjS+Oa3cydJ5dvcm56jHnmcXONoIi1WKifqSM
	EED2c0r5UbVCilbT9CBq6Q8NN2WwnzKxvJxYBuO0T7JAn+8EwnUiJfLYVtNS4//Rk2M/7b
	GC6BqWYUetEWceFPlYPmT6yJGqyqe+Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ydOkPqfF;
	spf=none (imf28.hostedemail.com: domain of BATV+21c3bf232c3b55be12f8+8095+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+21c3bf232c3b55be12f8+8095+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761115632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yps/DoJ74xCH7LKaUk7bfRUU8Jdecw5+xxO3zciKsXg=;
	b=ChJW/ByJdkPWsdhg+fm6R9fj8lcC8jcKB55TiUTcvMb6lWg2rY2PD1Yhnlx64Yx+dzmka0
	EqiDP1/gChlCTfBa0tLTd45Z3V7dL2Qf3l7qV2s8hsFLh6PeLcMvVV/W6oksuCgCoHQH/7
	yq0TeoLu7hGfB8XYxgZ2oLULGT3m/w8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yps/DoJ74xCH7LKaUk7bfRUU8Jdecw5+xxO3zciKsXg=; b=ydOkPqfFQJfLbk7/4eJ1nENLB/
	7ico0BBBJlHdZytu4u2JI53ikj+afFUK6Esvzk3movFUM6Eo452gx3KDnRbg5jdNb9VNfLI4eb9oU
	OSh2rbJxhv+/xwwrooRiabHli0lVrBPD58cR6V0dp2X0FtcU9qnl5/xBmLi+Bzv6jamky3YuiR6Ht
	7Nipb9xy14H4yKZqlgkSYa7VbHExeD+aA85T+YzxoN1ywS7/kRZpvJme/gYPmNlKtZ5RD76rRITAX
	jL52eu8xA9ARiwVmNnLAaHO+RC9WzAz85vk3qSkn2C0SG38Dtw+ZFk9T6XObMYyq/GOiSt0VIGdJM
	X4jaQx4g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBSck-00000001iFh-3FyY;
	Wed, 22 Oct 2025 06:47:06 +0000
Date: Tue, 21 Oct 2025 23:47:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
	maple-tree@lists.infradead.org, Alexei Starovoitov <ast@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	WangYuli <wangyuli@uniontech.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH v8 00/23] SLUB percpu sheaves
Message-ID: <aPh96jn2NcqXY4IC@infradead.org>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <aOS0Z5N4HaBNeb_J@infradead.org>
 <c750ab62-a3d4-422e-ac5b-c531dfcc749d@suse.cz>
 <aOX-87tPdtuPb9Uh@infradead.org>
 <c0eb4acf-47ff-4e39-8d32-4e5f3857a851@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0eb4acf-47ff-4e39-8d32-4e5f3857a851@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Stat-Signature: ke1jnynpgrhbojjfsc9sy7dkomba5a6w
X-Rspamd-Queue-Id: F118DC0005
X-Rspamd-Server: rspam09
X-HE-Tag: 1761115631-134958
X-HE-Meta: U2FsdGVkX19zvm3ima816qU2DgDfciwHDJZxxv/+X6vm0r3UL32vostJOYAHF2jZEzyiQId6CVT8oKxrxnadhjgP/QmCB7J9NZHjvz277b7oPQXG3Oq7+79b9JNpepeVX18tTmCO991IJIrRQzlQVEZ5tRy7R0GJt4LYO6AwFmEBUOzDtMzK0Si/0RfseQtclz8J2VH1uwZKAU+762dOxoyHT/xAUraIwXe/cb137FFnw5wCq692+vzrWvT2xsicAFWi5WHfwEFkYKH+1fGFpc330Yl8dNuPqqQvkNB1R1L5BWBYNxJHlfq7WwTT87DUMiwyk9/Bh8NoLjxqR7Hiwna67Zpzw8wvE5xk9VJCNXkfTMVPVlD14WNx+GydJXN7W2WsiYLl25g3tQ1cpzfFpbh+BqvGD0aGp4i0Bo6L6/xMbOT0+/qPrcJ60eKT0QkXU6pkv/XvtM8WyAK32v1+87wjFnMJf5JCx1pECFMntasis5yCFpHbp+ZPDxQsxqjWk+uqKlSrUUqUXIzCRAdZ8m9XTQYFAY+SW34AIMq/MX7XwxWUuIMicNqElZJ/QYaQrwtLfZZXYv8I/xA2UUykDlt9d92B1+AV2xtL3jkXRmyRzTIsm2aV6AaM/+GC9GcF84vqK8CyAbWNtXWH3aLig7Ql600w+0+gza+jDH3jFcRMVGG25VuwSSYYfmB5FnHzjhHapI0gl7grW6wN0xUjJ43Zk6lw9ExO4p5H0jgsVE8gyrACJH2NLwvpP++FcwNJUAKLu0GERaMxcXWto5FiqdfriS6F4nAZkSt9BnMZxTIjHw/IdRcUnWaVph/+B0M/x8sn11cBLD+3ip4AmO9wd5Pw1poM3/5DE5HvGITITnKZPiJTk3ZqPmnVPfpLnZEhosuuuGpvoA5EFeMEuzmK/g873mCxS55sUo1vvwceD8suSo7j6k8tDxYdURqsJHnkTYASKOepKXKGAKp/AnG
 DMRcr8NE
 VJCUt32ZBCwBhSjxZUZN9HW2TXARYvPTJRFDLvkEC0wwl+0qR1+k2vhmIQrEog0pd+Q2+CUkF6i0DT2+FVJGnzTM17snmtLz88U6P4mvvndbQXrH32k5c1wAaKX8V4WXLWZAFJkPnveIMsqAEQWDoJl/WUn6FygaKolz1+IVtz3eXNPydImsXhTZ1outY+w88ALBOccS9QwKsZ3E5YGahjqzA1yBJt71kT4eg1vznldtY8vp+EhtSn3B0z91WxJnKBiqbRKEzCVTjjDefYYtosybDRfOgpxZqJIRm+c3MJWL8ri6T8V+BlFjnt3DOLTHT5Odi1ABI9Sf4sG0Tzu9Iywu4ad1s4lAFW5IMD4wtLlo6K/Gz+VejRjWvVS4ixpl5aCZDMpSbR8pWNv3EjY8ksA6wkNgZ9jRJHBrQViKbv7a/g8Hf0+S+MZY91KiXe3M/G0ywVwde7KdJMpC5iLpTsA88wicFiPCukpoiUrRo0Qy6KwJpLu+R3tBhWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 10:32:44AM +0200, Vlastimil Babka wrote:
> Yeah, not a replacement for mempools which have their special semantics.
> 
> > to implement a mempool_alloc_batch to allow grabbing multiple objects
> > out of a mempool safely for something I'm working on.
> 
> I can imagine allocating multiple objects can be difficult to achieve with
> the mempool's guaranteed progress semantics. Maybe the mempool could serve
> prefilled sheaves?

It doesn't look too bad, but I'd be happy for even better versions.

This is wht I have:

---
From 9d25a3ce6cff11b7853381921c53a51e51f27689 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Mon, 8 Sep 2025 18:22:12 +0200
Subject: mempool: add mempool_{alloc,free}_bulk

Add a version of the mempool allocator that works for batch allocations
of multiple objects.  Calling mempool_alloc in a loop is not safe
because it could deadlock if multiple threads are attemping such an
allocation at the same time.

As an extra benefit the interface is build so that the same array
can be used for alloc_pages_bulk / release_pages so that at least
for page backed mempools the fast path can use a nice batch optimization.

Still WIP, this needs proper documentation, and mempool also seems to
miss error injection to actually easily test the pool code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/mempool.h |   6 ++
 mm/mempool.c            | 131 ++++++++++++++++++++++++----------------
 2 files changed, 86 insertions(+), 51 deletions(-)

diff --git a/include/linux/mempool.h b/include/linux/mempool.h
index 34941a4b9026..59f14e94596f 100644
--- a/include/linux/mempool.h
+++ b/include/linux/mempool.h
@@ -66,9 +66,15 @@ extern void mempool_destroy(mempool_t *pool);
 extern void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask) __malloc;
 #define mempool_alloc(...)						\
 	alloc_hooks(mempool_alloc_noprof(__VA_ARGS__))
+int mempool_alloc_bulk_noprof(mempool_t *pool, void **elem,
+		unsigned int count, gfp_t gfp_mask);
+#define mempool_alloc_bulk(...)						\
+	alloc_hooks(mempool_alloc_bulk_noprof(__VA_ARGS__))
 
 extern void *mempool_alloc_preallocated(mempool_t *pool) __malloc;
 extern void mempool_free(void *element, mempool_t *pool);
+unsigned int mempool_free_bulk(mempool_t *pool, void **elem,
+		unsigned int count);
 
 /*
  * A mempool_alloc_t and mempool_free_t that get the memory from
diff --git a/mm/mempool.c b/mm/mempool.c
index 1c38e873e546..d8884aef2666 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -371,26 +371,13 @@ int mempool_resize(mempool_t *pool, int new_min_nr)
 }
 EXPORT_SYMBOL(mempool_resize);
 
-/**
- * mempool_alloc - allocate an element from a specific memory pool
- * @pool:      pointer to the memory pool which was allocated via
- *             mempool_create().
- * @gfp_mask:  the usual allocation bitmask.
- *
- * this function only sleeps if the alloc_fn() function sleeps or
- * returns NULL. Note that due to preallocation, this function
- * *never* fails when called from process contexts. (it might
- * fail if called from an IRQ context.)
- * Note: using __GFP_ZERO is not supported.
- *
- * Return: pointer to the allocated element or %NULL on error.
- */
-void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
+int mempool_alloc_bulk_noprof(mempool_t *pool, void **elem,
+		unsigned int count, gfp_t gfp_mask)
 {
-	void *element;
 	unsigned long flags;
 	wait_queue_entry_t wait;
 	gfp_t gfp_temp;
+	unsigned int i;
 
 	VM_WARN_ON_ONCE(gfp_mask & __GFP_ZERO);
 	might_alloc(gfp_mask);
@@ -401,15 +388,24 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
 
 	gfp_temp = gfp_mask & ~(__GFP_DIRECT_RECLAIM|__GFP_IO);
 
+	i = 0;
 repeat_alloc:
+	for (; i < count; i++) {
+		if (!elem[i])
+			elem[i] = pool->alloc(gfp_temp, pool->pool_data);
+		if (unlikely(!elem[i]))
+			goto use_pool;
+	}
 
-	element = pool->alloc(gfp_temp, pool->pool_data);
-	if (likely(element != NULL))
-		return element;
+	return 0;
 
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
@@ -417,8 +413,9 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
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
@@ -434,10 +431,12 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
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
 
@@ -452,6 +451,30 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
 	finish_wait(&pool->wait, &wait);
 	goto repeat_alloc;
 }
+EXPORT_SYMBOL_GPL(mempool_alloc_bulk_noprof);
+
+/**
+ * mempool_alloc - allocate an element from a specific memory pool
+ * @pool:      pointer to the memory pool which was allocated via
+ *             mempool_create().
+ * @gfp_mask:  the usual allocation bitmask.
+ *
+ * this function only sleeps if the alloc_fn() function sleeps or
+ * returns NULL. Note that due to preallocation, this function
+ * *never* fails when called from process contexts. (it might
+ * fail if called from an IRQ context.)
+ * Note: using __GFP_ZERO is not supported.
+ *
+ * Return: pointer to the allocated element or %NULL on error.
+ */
+void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
+{
+	void *elem[1] = { };
+
+	if (mempool_alloc_bulk_noprof(pool, elem, 1, gfp_mask) < 0)
+		return NULL;
+	return elem[0];
+}
 EXPORT_SYMBOL(mempool_alloc_noprof);
 
 /**
@@ -491,20 +514,11 @@ void *mempool_alloc_preallocated(mempool_t *pool)
 }
 EXPORT_SYMBOL(mempool_alloc_preallocated);
 
-/**
- * mempool_free - return an element to the pool.
- * @element:   pool element pointer.
- * @pool:      pointer to the memory pool which was allocated via
- *             mempool_create().
- *
- * this function only sleeps if the free_fn() function sleeps.
- */
-void mempool_free(void *element, mempool_t *pool)
+unsigned int mempool_free_bulk(mempool_t *pool, void **elem, unsigned int count)
 {
 	unsigned long flags;
-
-	if (unlikely(element == NULL))
-		return;
+	bool added = false;
+	unsigned int freed = 0;
 
 	/*
 	 * Paired with the wmb in mempool_alloc().  The preceding read is
@@ -541,15 +555,11 @@ void mempool_free(void *element, mempool_t *pool)
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
@@ -560,20 +570,39 @@ void mempool_free(void *element, mempool_t *pool)
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
+ * @element:   pool element pointer.
+ * @pool:      pointer to the memory pool which was allocated via
+ *             mempool_create().
+ *
+ * this function only sleeps if the free_fn() function sleeps.
+ */
+void mempool_free(void *element, mempool_t *pool)
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


