Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D6B3C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 16:10:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E10E6B018D; Tue, 18 Aug 2026 12:10:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B8786B018F; Tue, 18 Aug 2026 12:10:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CEAB6B0488; Tue, 18 Aug 2026 12:10:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 152196B018D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:10:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C55D8012D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:10:57 +0000 (UTC)
X-FDA: 85114878954.24.21E30A6
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf25.hostedemail.com (Postfix) with ESMTP id 744ADA0007
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:10:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="KeATOA k";
	spf=pass (imf25.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787069455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TCWJgyt+yj8iW+I0mXfDkyu3WR+FxzVzqga2224bXwI=;
	b=Ae59FpZqu0ChpVNHlzrWKZJMqjhkN9Ag0NAFv55CzgSDpK692qy9HIo7FCJMpe8aiVDeHx
	zHBWdl0iYVwJh/th+0oIaXVu5HTqh5xFi2WukmwQ9Rfs5qTth0Cla+AaNAa7xdpNCuErIv
	YGkcFrvina8PEiDWII/O7KHcqIV+vvk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="KeATOA k";
	spf=pass (imf25.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787069455;
	b=X3F1mDHI5KA3VtgUHvHl1tj+IAxYForBSt2UXqVBI81BR/9vGLf1EKaalZrCmhMBCOI+4j
	fb5R2JbIJKZZUnN+dFlG3XlKZcrCAQCIsPhzCe0MXFOLI19MSzOjGbfXOu3MxqgLhas52+
	Ibe6TaZuc6bgrKftM4JuKHaYWflUs8A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=TCWJgyt+yj8iW+I0mXfDkyu3WR+FxzVzqga2224bXwI=; b=KeATOA
	kqQVG9ksZ/roxci4rBXXKNZdw7DanOHRbiqZ/0SPWzKXFN3/bMmMzOajVUCCby2zp4HJuLnw2YVhS
	Yaj70H2QFcxWwfPBni3P3FEbPLPvPvmfkmc4BuMf2OVDp5eCNe55gQxwKPfc/6j4nV3yZv3RIAdJJ
	U7n9LU4hLz/lW+7l+AVboxwcRrQYCvcn7PT/P5jqU3pWjIY/Td4lUMd4tEQRRwY2xcgKQ8pzhMSQp
	wJGg0OX+BGZiKRV63udi9K5hwwkGvoU+zCMmrPeOQ3qKKZBc5QQ8FCwgaP0tS5sRHVBGdSzjwA6t1
	RXy4+aU1Cbo9/U/RCV+MqJh94aog==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wwLga-00000001TR7-1YmE;
	Tue, 18 Aug 2026 15:25:08 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	iommu@lists.linux.dev,
	liam@infradead.org,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	ashok.raj@oss.qualcomm.com,
	jgg@ziepe.ca,
	kyle@mcmartin.ca,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 2/3] iommu/iova: defer maple tree erase on GFP_ATOMIC failure
Date: Tue, 18 Aug 2026 11:25:02 -0400
Message-ID: <20260818152505.1057922-3-riel@surriel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260818152505.1057922-1-riel@surriel.com>
References: <20260818152505.1057922-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 744ADA0007
X-Stat-Signature: 8no6wsh37ra7qa7udybjiyo7ko5cmp6x
X-Rspam-User: 
X-HE-Tag: 1787069454-770643
X-HE-Meta: U2FsdGVkX18fxgGT5prF8buIDlBg1ZlTrfQh3dlbre5mZEVr3PzYW0hAhtCCbh4KTFqLM7smxn5uLF4a4+oRhxZTHyadXLM2j7Z0IaoPz1BKQjAe3uVK1GXd5dZ2oW53FpvqoAi+MLZJf28TxsDu1b31DTINNRiT6Y7BGP6iC9M+ZcvzhDLOUDHW/TVfrbI7Je8Ndox8DOVgsBKT7kEcmR3FoQ5oSiuVbMoz+87ESnEhVcSETOJT7N+i5gj9a29gej/ng8ycqUxX6ttnqH5VQmQknUOrfmyUq6CTAEzv/sQpKcTMQadVj5rjiD7hwbhMblzAgGzv8PkuCtRRM5xEP3Ed+DvnFet6l+XLPBsBVftLSdVi995Dr2ZMTRoYBwYiHKaAQ8PQ0Rg3bqVqVrfjHnjTc5aTHylDqzatB5kA+ORpZMmXfjPpBcdq0ShR5mbc1s7Xip6nttLkUAL1NyQbdHthABbK5keCKU9vRHoswl7hezEOZNKB9DvDJHta9WIkTdLK4KcVmBO8st5O8VmkPtZ7nkRokh3UdB5LZtK4tgJ6znld2fpgdcZLiiuJvHwyeeZz8aWhpR8bBYUVLVBEM2H0t8eNzEgp0qGD3WAIP5nehPw7CgdlDxNqie6fkiRIfYCiFwjQJOduFkkSWbw7dwK3NcQqQLyzsT84HlNdtTiAOGA8QSh90+jkZ3nZamgKUseaPvXN0R2aeZSdbiLL06c/y1DueKAhMosGZfQYM3EjbkI6Jf9IDY7MpfyRvAHQhK5DTpLXKGjbt1InY/Y4qyMojtkwKGSvw8lBFYMuMhfLqeYPHPiSIcG6z/mrkT4iFluy2pnzQE/9TJrsfvPiu6edSX31e/gtYrDhAz4OA3l+gD3Kk1SkeDDZt1qoY5ofrfuWug9imNnVJxs5LgNrc3Fyqg1ShF+kcEEyz7yMK6+7ekZRjems0rBYkvduB/CrP5bLq85Ww1sekcCcwcw
 niOvVh/l
 /x703smjue+XWy+DaiicqsnE8y3nl1U2iX9yBYA6yUDJp4gGQKkT+XBRziBHJhmfuogDL9i0Kz9DHWv0Wi9medQUOjN9C+GYANt5WQo5ry3tzllrprZdGemcOhXCJCk9CJrdML9Mfc4sczilPxeq240jL6r2SvFAu7pEArNP9uxL+XGYZgbRr3hi54MUvkbNzf/KANxUyM7y2/dE7AIFztMtxcoBsoTSR2k5hVan6epjsIipBj28l+XoPKx3FqDMOmtwGfSiUxuxljTKx0BS9VZHLOjqkv3Kd26zKiRM/5CYPLpmBGte/LtheehtyyLwHqrEqlNVUxarnZ4VACLbPVCi0bHRbKl5enQ9q8J1cP4M3NJSh2DldvLnx2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

rb_erase() never allocates. Removing an entry from a maple tree can, so
the mas_store_gfp(&mas, NULL, GFP_ATOMIC) in remove_iova() can fail, and
iovas are freed from atomic context, where GFP_KERNEL is not available.

Failing takes a specific shape. Storing NULL runs mas_wr_extend_null()
first, which pulls adjacent free ranges into the store. With a live iova
on either side there is nothing to pull in, and the store is wr_exact_fit,
which needs no node. Only a free neighbour, dropping the leaf below
mt_min_slots, makes the tree rebalance and allocate.

When the erase does fail, store IOVA_DEFERRED over the entry's own range
instead, and free the struct iova. A non-NULL value does not extend the
range, so that store is wr_exact_fit whatever the neighbours look like,
and cannot fail.

XA_ZERO_ENTRY would reserve the range too, but mtree_load() and mt_find()
turn it back into NULL, so any later use of the normal API on this tree
would see a marked range as free.

The domain keeps a [deferred_lo, deferred_hi] range covering the markers.
iova_drain_deferred() walks only that range, and retries the erases from
the next allocation or the next successful free.

struct iova stays at 16 bytes: the state is the marker plus two unsigned
longs per domain. The store that can fail now runs where failure can be
returned to the caller, so no timer or workqueue is needed.

Should the marker store fail anyway, WARN_ON_ONCE() reports it and the
entry stays in the tree as a live iova. Its range is then reserved until
put_iova_domain() frees it with the rest of the domain. BUG_ON() would
trade that stranded range for a dead machine.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 drivers/iommu/iova.c | 131 +++++++++++++++++++++++++++++++++++++------
 include/linux/iova.h |   3 +
 2 files changed, 118 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
index 69f80b14cb3d..255a1cefe8c5 100644
--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -26,6 +26,23 @@ static unsigned long iova_rcache_get(struct iova_domain *iovad,
 static void free_iova_rcaches(struct iova_domain *iovad);
 static void free_cpu_cached_iovas(unsigned int cpu, struct iova_domain *iovad);
 static void free_global_cached_iovas(struct iova_domain *iovad);
+static void iova_drain_deferred(struct iova_domain *iovad);
+
+/*
+ * Stored over an entry whose erase failed: an in-place store of a
+ * non-NULL value needs no node allocation, so it works where the
+ * erase did not. The gap search treats the slot as occupied, keeping
+ * the range reserved; lookups, teardown and the invariant checker
+ * skip it. Pointing at a static keeps it 8-byte aligned, out of the
+ * range the maple tree uses for internal entries.
+ */
+static const unsigned long iova_deferred_marker;
+#define IOVA_DEFERRED		((struct iova *)&iova_deferred_marker)
+
+static inline bool iova_has_deferred(const struct iova_domain *iovad)
+{
+	return iovad->deferred_lo <= iovad->deferred_hi;
+}
 
 void
 init_iova_domain(struct iova_domain *iovad, unsigned long granule,
@@ -50,6 +67,8 @@ init_iova_domain(struct iova_domain *iovad, unsigned long granule,
 	iovad->start_pfn = start_pfn;
 	iovad->dma_32bit_pfn = 1UL << (32 - iova_shift(iovad));
 	iovad->max32_alloc_size = iovad->dma_32bit_pfn;
+	iovad->deferred_lo = ULONG_MAX;
+	iovad->deferred_hi = 0;
 }
 EXPORT_SYMBOL_GPL(init_iova_domain);
 
@@ -71,6 +90,9 @@ static int __alloc_and_insert_iova_range(struct iova_domain *iovad,
 	}
 
 	spin_lock_irqsave(&iovad->iova_lock, flags);
+	/* Reclaim deferred frees to get their address space back. */
+	if (unlikely(iova_has_deferred(iovad)))
+		iova_drain_deferred(iovad);
 	/* No 32-bit request this large can fit until the hint is cleared. */
 	if (limit_pfn <= iovad->dma_32bit_pfn &&
 			size >= iovad->max32_alloc_size)
@@ -156,28 +178,96 @@ static struct iova *
 private_find_iova(struct iova_domain *iovad, unsigned long pfn)
 {
 	MA_STATE(mas, &iovad->mtree, pfn, pfn);
+	struct iova *iova;
+
+	assert_spin_locked(&iovad->iova_lock);
+	iova = mas_walk(&mas);
+	/* A deferred-erase marker is not a live iova; treat it as absent. */
+	if (iova == IOVA_DEFERRED)
+		return NULL;
+	return iova;
+}
+
+/* Every marker lies within [deferred_lo, deferred_hi]. Needs iova_lock. */
+static void iova_drain_deferred(struct iova_domain *iovad)
+{
+	unsigned long hi = iovad->deferred_hi;
+	void *entry;
+
+	MA_STATE(mas, &iovad->mtree, iovad->deferred_lo, hi);
 
 	assert_spin_locked(&iovad->iova_lock);
-	return mas_walk(&mas);
+
+	while ((entry = mas_find(&mas, hi)) != NULL) {
+		unsigned long lo = mas.index, last = mas.last;
+
+		if (entry == IOVA_DEFERRED) {
+			mas_set_range(&mas, lo, last);
+			if (mas_store_gfp(&mas, NULL, GFP_ATOMIC)) {
+				/*
+				 * No reclaim can happen under the lock, so
+				 * the remaining erases would fail too.
+				 */
+				iovad->deferred_lo = lo;
+				iovad->deferred_hi = hi;
+				return;
+			}
+			/* The store moves the iterator; re-anchor. */
+			mas_set(&mas, last + 1);
+		}
+
+		if (last >= hi)
+			break;
+	}
+
+	iovad->deferred_lo = ULONG_MAX;
+	iovad->deferred_hi = 0;
 }
 
+/*
+ * Must not fail: DMA unmap runs in atomic context, so there is no caller to
+ * return an error to.
+ */
 static void remove_iova(struct iova_domain *iovad, struct iova *iova)
 {
-	MA_STATE(mas, &iovad->mtree, iova->pfn_lo, iova->pfn_hi);
+	unsigned long pfn_lo = iova->pfn_lo, pfn_hi = iova->pfn_hi;
+
+	MA_STATE(mas, &iovad->mtree, pfn_lo, pfn_hi);
 
 	assert_spin_locked(&iovad->iova_lock);
 
-	if (iova->pfn_lo < iovad->dma_32bit_pfn)
+	if (pfn_lo < iovad->dma_32bit_pfn)
 		iovad->max32_alloc_size = iovad->dma_32bit_pfn;
 
-	/*
-	 * A failed store leaves the iova in the tree, so it cannot be freed
-	 * here. The range stays reserved until the domain is torn down.
-	 */
-	if (mas_store_gfp(&mas, NULL, GFP_ATOMIC))
+	if (mas_store_gfp(&mas, NULL, GFP_ATOMIC)) {
+		/*
+		 * A NULL store gets widened over the neighbouring free ranges,
+		 * and the wider store may cause a maple tree rebalance, which
+		 * can fail if tree nodes failed to allocate. The IOVA_DEFERRED
+		 * store is never widened and needs no allocation, as
+		 * test_marker_store_needs_no_node() checks. Check anyway,
+		 * because surviving e.g. a maple tree corruption here is cheap.
+		 */
+		mas_set_range(&mas, pfn_lo, pfn_hi);
+		if (WARN_ON_ONCE(mas_store_gfp(&mas, IOVA_DEFERRED, GFP_ATOMIC)))
+			/*
+			 * The tree still holds the live iova: nothing for the
+			 * sweep to find, and teardown frees it.
+			 */
+			return;
+		if (pfn_lo < iovad->deferred_lo)
+			iovad->deferred_lo = pfn_lo;
+		if (pfn_hi > iovad->deferred_hi)
+			iovad->deferred_hi = pfn_hi;
+		free_iova_mem(iova);
 		return;
+	}
 
 	free_iova_mem(iova);
+
+	/* A successful erase means memory is available; clear any backlog. */
+	if (unlikely(iova_has_deferred(iovad)))
+		iova_drain_deferred(iovad);
 }
 
 /**
@@ -231,11 +321,8 @@ free_iova(struct iova_domain *iovad, unsigned long pfn)
 
 	spin_lock_irqsave(&iovad->iova_lock, flags);
 	iova = private_find_iova(iovad, pfn);
-	if (!iova) {
-		spin_unlock_irqrestore(&iovad->iova_lock, flags);
-		return;
-	}
-	remove_iova(iovad, iova);
+	if (iova)
+		remove_iova(iovad, iova);
 	spin_unlock_irqrestore(&iovad->iova_lock, flags);
 }
 EXPORT_SYMBOL_GPL(free_iova);
@@ -335,8 +422,10 @@ void put_iova_domain(struct iova_domain *iovad)
 	 * walk still has to hold the lock the tree was given.
 	 */
 	spin_lock_irqsave(&iovad->iova_lock, flags);
+	/* Skip IOVA_DEFERRED entries: their iovas were already freed. */
 	mas_for_each(&mas, iova, ULONG_MAX)
-		free_iova_mem(iova);
+		if (iova != IOVA_DEFERRED)
+			free_iova_mem(iova);
 	__mt_destroy(&iovad->mtree);
 	spin_unlock_irqrestore(&iovad->iova_lock, flags);
 }
@@ -369,6 +458,12 @@ static struct iova *iova_merge_overlaps(struct iova_domain *iovad,
 	MA_STATE(mas, &iovad->mtree, pfn_lo, pfn_hi);
 
 	mas_for_each(&mas, overlap, pfn_hi) {
+		/*
+		 * A deferred-erase marker isn't a real iova; the merged-range
+		 * store in the caller spans and overwrites it.
+		 */
+		if (overlap == IOVA_DEFERRED)
+			continue;
 		if (pfn_lo >= overlap->pfn_lo && pfn_hi <= overlap->pfn_hi)
 			return overlap;
 		if (overlap->pfn_lo < *lo)
@@ -409,6 +504,10 @@ reserve_iova(struct iova_domain *iovad,
 
 	spin_lock_irqsave(&iovad->iova_lock, flags);
 
+	/* Leave the walk below with only live iovas to look at. */
+	if (unlikely(iova_has_deferred(iovad)))
+		iova_drain_deferred(iovad);
+
 	/*
 	 * The overlapping iovas cannot be freed yet: the merged store below
 	 * can fail, and freeing before a failed store would leave dangling
@@ -435,7 +534,8 @@ reserve_iova(struct iova_domain *iovad,
 
 	mas_set_range(&fmas, merged_lo, merged_hi);
 	mas_for_each(&fmas, overlap, merged_hi)
-		free_iova_mem(overlap);
+		if (overlap != IOVA_DEFERRED)
+			free_iova_mem(overlap);
 
 	mas_store_prealloc(&mas, iova);
 out:
@@ -525,7 +625,6 @@ iova_magazine_free_pfns(struct iova_magazine *mag, struct iova_domain *iovad)
 			continue;
 
 		remove_iova(iovad, iova);
-		free_iova_mem(iova);
 	}
 
 	spin_unlock_irqrestore(&iovad->iova_lock, flags);
diff --git a/include/linux/iova.h b/include/linux/iova.h
index a3dab6c5fd62..e17bb1e85838 100644
--- a/include/linux/iova.h
+++ b/include/linux/iova.h
@@ -31,6 +31,9 @@ struct iova_domain {
 	unsigned long	start_pfn;	/* Lower limit for this domain */
 	unsigned long	dma_32bit_pfn;
 	unsigned long	max32_alloc_size; /* Size of last failed allocation */
+	/* Bounding range of deferred erases; lo > hi when there are none. */
+	unsigned long	deferred_lo;
+	unsigned long	deferred_hi;
 
 	struct iova_rcache	*rcaches;
 	struct hlist_node	cpuhp_dead;
-- 
2.53.0-Meta


