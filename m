Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D482CD5BA0
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 08:41:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D28298E0018; Thu, 13 Nov 2025 03:41:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD8E38E0016; Thu, 13 Nov 2025 03:41:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC7788E0018; Thu, 13 Nov 2025 03:41:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A67258E0016
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 03:41:22 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6D520BBEE6
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:41:22 +0000 (UTC)
X-FDA: 84104939604.11.478ED38
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf04.hostedemail.com (Postfix) with ESMTP id B3A8540011
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:41:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=vG62U7I3;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf04.hostedemail.com: domain of BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763023280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PnHKzcO6wKUO2hUXwbtJ8h7p3RHH+OB61u/AP3cRlrA=;
	b=xXU+KMhfvLDv3nkXEA5GVtyXCnno8q8bKeAS0tPeRjKHIdYpN8SWuqt4R3PLx4dOPWLj5y
	Fv1StP5s9eFJelgng+OK5BT24rCyLMkiFVYfsJPJKGBxmMlB8u9dY3Fw9NUvq7RqOGM1Z1
	3SpOz8zbVE3monxknQMWgWFV21kRJu0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763023280; a=rsa-sha256;
	cv=none;
	b=r3KFyDqVCpQAZlKL7KJXkArzAKmZyNNysKcc+Z7sFB//JVqoyTut+bjuLn0UKh70ix/5u6
	s8SpmPFn/fu0AfLbCHx4KiiOlmgpfeGajDpJlWRjXoc7eiN/OvE04Xy/jW+3s2yMXj8glf
	Fha4+Bkp+OrZ27p/VlYqyH/NtgzKsBw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=vG62U7I3;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf04.hostedemail.com: domain of BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PnHKzcO6wKUO2hUXwbtJ8h7p3RHH+OB61u/AP3cRlrA=; b=vG62U7I3gzI7SWYyjtkhCcwha5
	qiE/pO/2dR17nwx67X8CJhriUbEqQwcsQKiJaAs8sD29xPMNFlpmc5qTaViKXkGAgTLhK7o2fzDp5
	jVPVoZyBhBDtXa69oq7qcY44idMcBl3cguQrtEsxQIPChSaZhIaXguF62kEES9MARFSEBzN0ArmHj
	yC0VrCftVjNeewdYBQ5NHYCD+2KVB6arn+9KdUephu30FWO5Cx58TOgvdLQuiBc3i6RvNn0C3a2Tp
	HFJG8P/OCH0ILNDQFBPO2Fgn6lgVdxTY6eyKMCgsYBUV1zY8aAHupW8OEFUbGQ5p+DRoIBooQJ6lj
	gcjo4oUg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJStI-0000000A7TN-1ml7;
	Thu, 13 Nov 2025 08:41:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] mempool: add mempool_{alloc,free}_bulk
Date: Thu, 13 Nov 2025 09:39:48 +0100
Message-ID: <20251113084022.1255121-8-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113084022.1255121-1-hch@lst.de>
References: <20251113084022.1255121-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: n9r5aqayogi6huwgkz8sj7t33z8aqsnc
X-Rspam-User: 
X-Rspamd-Queue-Id: B3A8540011
X-Rspamd-Server: rspam10
X-HE-Tag: 1763023280-243073
X-HE-Meta: U2FsdGVkX1/38BCFCJBABfULj7gzeBbQzh6iwfEAkxecGOaPYk4idPGmQLSXMim94zROVzS0g2Pyhq1ICLVWHYOe6ZfiZFIelut4q8OFNW6vYBDo5uzLAE9U0k2tXav46LPVK/TN13sjKegqul9ZstFzYN0xFKDWPxX0skRZHcVohAbHaMyNohoTw/ruKdo7l7Hj8CKQjYyAoHvtAbELs7QuFR5vHLUQd59RuWidJgfrCJ0UXOCzomN7hYAWx7yeMHbVlGsTqRZUHJoWJgYHzmjnCfFvCsrUQPc9tZewDT4iCzIF7z7bfqL8fmsQ2FjBHoSTHR5IhdVXqqU6VC4noR7XndOMzf2KQbxuaeymnTRNPqfya+t5Ux9W59UtTQ/IxoL6hyuIS2GY17dJG/unjd9RKv8o3IY/630K5U+CQj8QLgRlX0QInj+Zcu8W39HeXSviNr08lcpu6BO5kMlWpZ78xkApbKY7TNNRRYB+1zQw0tXP6unSKMR0jM7IOlGcdLUfXh7Tz53UDWgdqlh7PmPGwlo3buYOl1ufYg4eh+Qfn4KQ89S4kvSp8NUdnV1BvMyyvNRYdlkt4qrec8eHP/ZGmAgz1uv0qBZhCJIjiigZJvhgim+ZjcKJrACi5O3J4DKa1MO5hX2EcFMH6CMDnadYKa1BW2/o2GANh3D/w5EGPzJqa7dUvwKXSMP572snpQ3R2hKkPyxJ9GbF8jGiKTBDc6Ug2gu22TFumHZnf5SJVpTlgZGxCurocuOFbtmytyAcOHelQYkRiy/XZknzNZJTKgaBeRCAaTOFRsYj7OixEYv5l+si9mD88p7sGiJ1dWGzASwTl6oyLCLxNsGsAs9eUTZKfv9TKvYjM3dfPzVxclIuK9Q2+mWQQRp2sBY4NprH941YTyBs2gT8O5qSreWL1NrtkASw2JIs9DwD5ZvZaMveCt9nZEBSLfvcuJaaE/bWWl4K/X74RtVPLWE
 vUr8HWxR
 mvXy1SKXXsnvIKQ/JLYogzZcSN6Hhtip5pIXwmdH1HmLN80D6z/+SKZPvkq9p2Zoashu/lo+DzIgC2QRDcDqDhJHap9j0pQVyJkWpswg/M9lIQgd2/BibB1WNp0d8sKYNDGVVCz/NrjwQRPGrIVq7peeewU3y4EARQ+orWl0d4Ei4Rk+V8TUivIpBVpz9F08VbN1+vRXZZQnNf+BnRNrfybrAdUFlh+TjLGLtHTLOs3itOIABBGP2PdCvmQyV/eVOoKYfUFm9mq/Oh6Z5/00GMEmGfQ/j8cuDAedlCCaefpls7I133UW5c0IwGdazkwFOci/u8c1kUTCphuQDsE4HBJNGz2TRkXfsm18JP0wxYfSgFULuSpGbjFVGczj8wTEdunsc0uDSVVJ6X6quM5xYfFvRwQv3p9UjOTHoI3ub/eEEeNwQXFxXPQp7a4Rz6SxAZxpkpKhYrAUNmQbpUDsZ769QgKoFtGYP4oy0ObghE0JkbQHHpIpXf2Xa7TeGmflHotFGnQ5fZh3VEuCXF93DalRKjroyzLnI81sNG0LzjapIIoaMVVou9EQGZQMtFd3ikScYhiBnmbMP+YwnKptNWmFFkspiCAGgwLoa
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

Note that mempool_alloc_bulk does not take a gfp_mask argument as it
must always be able to sleep and doesn't support any non-trivial
modifiers.  NOFO or NOIO constrainst must be set through the scoped API.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/mempool.h |   6 ++
 mm/mempool.c            | 178 ++++++++++++++++++++++++++++++----------
 2 files changed, 142 insertions(+), 42 deletions(-)

diff --git a/include/linux/mempool.h b/include/linux/mempool.h
index 34941a4b9026..e914fec0e119 100644
--- a/include/linux/mempool.h
+++ b/include/linux/mempool.h
@@ -66,9 +66,15 @@ extern void mempool_destroy(mempool_t *pool);
 extern void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask) __malloc;
 #define mempool_alloc(...)						\
 	alloc_hooks(mempool_alloc_noprof(__VA_ARGS__))
+int mempool_alloc_bulk_noprof(struct mempool *pool, void **elem,
+		unsigned int count, unsigned int allocated);
+#define mempool_alloc_bulk(...)						\
+	alloc_hooks(mempool_alloc_bulk_noprof(__VA_ARGS__))
 
 extern void *mempool_alloc_preallocated(mempool_t *pool) __malloc;
 extern void mempool_free(void *element, mempool_t *pool);
+unsigned int mempool_free_bulk(struct mempool *pool, void **elem,
+		unsigned int count);
 
 /*
  * A mempool_alloc_t and mempool_free_t that get the memory from
diff --git a/mm/mempool.c b/mm/mempool.c
index c28087a3b8a9..88b9a8476d31 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -21,11 +21,21 @@
 #include "slab.h"
 
 static DECLARE_FAULT_ATTR(fail_mempool_alloc);
+static DECLARE_FAULT_ATTR(fail_mempool_alloc_bulk);
 
 static int __init mempool_faul_inject_init(void)
 {
-	return PTR_ERR_OR_ZERO(fault_create_debugfs_attr("fail_mempool_alloc",
+	int error;
+
+	error = PTR_ERR_OR_ZERO(fault_create_debugfs_attr("fail_mempool_alloc",
 			NULL, &fail_mempool_alloc));
+	if (error)
+		return error;
+
+	/* booting will fail on error return here, don't bother to cleanup */
+	return PTR_ERR_OR_ZERO(
+		fault_create_debugfs_attr("fail_mempool_alloc_bulk", NULL,
+		&fail_mempool_alloc_bulk));
 }
 late_initcall(mempool_faul_inject_init);
 
@@ -380,15 +390,22 @@ int mempool_resize(mempool_t *pool, int new_min_nr)
 }
 EXPORT_SYMBOL(mempool_resize);
 
-static void *mempool_alloc_from_pool(struct mempool *pool, gfp_t gfp_mask)
+static unsigned int mempool_alloc_from_pool(struct mempool *pool, void **elems,
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
-	element = remove_element(pool);
+	for (i = 0; i < count; i++) {
+		if (!elems[i]) {
+			elems[i] = remove_element(pool);
+			allocated++;
+		}
+	}
 	spin_unlock_irqrestore(&pool->lock, flags);
 
 	/* Paired with rmb in mempool_free(), read comment there. */
@@ -398,8 +415,9 @@ static void *mempool_alloc_from_pool(struct mempool *pool, gfp_t gfp_mask)
 	 * Update the allocation stack trace as this is more useful for
 	 * debugging.
 	 */
-	kmemleak_update_trace(element);
-	return element;
+	for (i = 0; i < count; i++)
+		kmemleak_update_trace(elems[i]);
+	return allocated;
 
 fail:
 	if (gfp_mask & __GFP_DIRECT_RECLAIM) {
@@ -421,7 +439,7 @@ static void *mempool_alloc_from_pool(struct mempool *pool, gfp_t gfp_mask)
 		spin_unlock_irqrestore(&pool->lock, flags);
 	}
 
-	return NULL;
+	return allocated;
 }
 
 /*
@@ -437,6 +455,65 @@ static inline gfp_t mempool_adjust_gfp(gfp_t *gfp_mask)
 	return *gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_IO);
 }
 
+/**
+ * mempool_alloc_bulk - allocate multiple elements from a memory pool
+ * @pool:	pointer to the memory pool
+ * @elems:	partially or fully populated elements array
+ * @count:	number of entries in @elem that need to be allocated
+ * @allocated:	number of entries in @elem already allocated
+ *
+ * Allocate elements for each slot in @elem that is non-%NULL. This is done by
+ * first calling into the alloc_fn supplied at pool initialization time, and
+ * dipping into the reserved pool when alloc_fn fails to allocate an element.
+ *
+ * On return all @count elements in @elems will be populated.
+ *
+ * Return: Always 0.  If it wasn't for %$#^$ alloc tags, it would return void.
+ */
+int mempool_alloc_bulk_noprof(struct mempool *pool, void **elems,
+		unsigned int count, unsigned int allocated)
+{
+	gfp_t gfp_mask = GFP_KERNEL;
+	gfp_t gfp_temp = mempool_adjust_gfp(&gfp_mask);
+	unsigned int i = 0;
+
+	VM_WARN_ON_ONCE(count > pool->min_nr);
+	might_alloc(gfp_mask);
+
+	/*
+	 * If an error is injected, fail all elements in a bulk allocation so
+	 * that we stress the multiple elements missing path.
+	 */
+	if (should_fail_ex(&fail_mempool_alloc_bulk, 1, FAULT_NOWARN)) {
+		pr_info("forcing mempool usage for %pS\n",
+				(void *)_RET_IP_);
+		goto use_pool;
+	}
+
+repeat_alloc:
+	/*
+	 * Try to allocate the elements using the allocation callback first as
+	 * that might succeed even when the caller's bulk allocation did not.
+	 */
+	for (i = 0; i < count; i++) {
+		if (elems[i])
+			continue;
+		elems[i] = pool->alloc(gfp_temp, pool->pool_data);
+		if (unlikely(!elems[i]))
+			goto use_pool;
+		allocated++;
+	}
+
+	return 0;
+
+use_pool:
+	allocated = mempool_alloc_from_pool(pool, elems, count, allocated,
+			gfp_temp);
+	gfp_temp = gfp_mask;
+	goto repeat_alloc;
+}
+EXPORT_SYMBOL_GPL(mempool_alloc_bulk_noprof);
+
 /**
  * mempool_alloc - allocate an element from a memory pool
  * @pool:	pointer to the memory pool
@@ -478,8 +555,8 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
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
@@ -503,26 +580,33 @@ EXPORT_SYMBOL(mempool_alloc_noprof);
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
@@ -556,21 +640,6 @@ void mempool_free(void *element, mempool_t *pool)
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
@@ -578,20 +647,45 @@ void mempool_free(void *element, mempool_t *pool)
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


