Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8065760A2605
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 22:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T6xfCS3X
Received: by kanga.kvack.org (Postfix)
	id 929CB6B05B3; Tue, 10 Nov 2026 17:14:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DFD06B05B4; Tue, 10 Nov 2026 17:14:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CB7C6B05B5; Tue, 10 Nov 2026 17:14:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 532716B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:14:48 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D750116016E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:14:47 +0000 (UTC)
X-FDA: 85420615014.30.351ACFD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3813E8000A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:14:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T6xfCS3X;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794348886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Og72oe+m3P1h0u76txqnDoP5dIPRHS5cx4UkGXzBEYI=;
	b=GNoyrTTw8cYzqkF4cewzWvoG2ne3eS9r8g4hyCegsv9hVfxgcjL2oX/oyYiZaifl1FGvM+
	+LG7zVece1SgbyT8fA7fMI98D59BUSatPhzjeJTC46UKDEk3hlOW/2IsTrZCL+hl5swXaT
	ABEakWFD/RPmtMLMHgjxZ256Vv4Dy00=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794348886;
	b=mhFTz8G8c6X3j2cAMPbvKZpvDFl8ZEmoi9D3R82hfhV2eG+fEce+m8fObwUlst7EWZM//2
	mqtpM67Mt4kH/X9e0+EuhOuOYS//g513bvepZTr8K6ZKj/GMet3QhrXqk3bC9/iwPokL6E
	0k/F83AmAzBz/uCC7rs5F8XKiMJw3JQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T6xfCS3X;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 99DEF6389A;
	Tue, 10 Nov 2026 22:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D681F0089F;
	Tue, 10 Nov 2026 22:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794348885;
	bh=Og72oe+m3P1h0u76txqnDoP5dIPRHS5cx4UkGXzBEYI=;
	h=From:Date:Subject:To:Cc;
	b=T6xfCS3Xsi/l2tZaEtOBwKOOG3MPj2VdYPzyTUfMMN8d/SeS5B9lUKyEjS2HBdZ/m
	 4/9YZozckaSfy8cdPtTgcUIPYsRNv+ksZKrh2y4IpoVJSAeHg/IOb3H+oQ5ZSiXubI
	 CaW5h71O7lv0afFvusuCIGP3reqlM+g8sGQG6lUDJJi7G8Wu/IjuUvNK0n0JtfH/i8
	 5hINsYNcr+XeyeOzr6bdXxes91LqBhQ31DT94fHqfrJBM/fhM7tJSX/18+BCRXjbCv
	 Y9NttuiFC1BlPLG3gZ3kTsaRJIAAhcCi1rU8oS2BWdUg/lMEsOPSXVmUbkldoDbMlg
	 B3G3x6oPgSmbg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 11 Nov 2026 00:14:40 +0200
Subject: [PATCH v2] mm/cma: simplify cma_declare_contiguous_multi()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-cma-multi-v2-1-4e2dddb2a2d8@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22OQQ6CMBBFr0K6dpQ2QNCV9zAs2jqFKtOathAN4
 e5S3Lp8k5f3Z2ERg8XILsXCAs42Wu82EIeC6UG6HsHeN2aiFA3nZQOaJNA0JgvGtC22lTL1+cw
 2/xXQ2PfeunU/jpN6oE45kA0lI4IK0ukhn4h8ohMRTC4mqUbMzmBj8uGzPzTz3Pq3PXPgUNYVS
 mxQaK6vTwwOx6MPPevWdf0C8rU6m9kAAAA=
X-Change-ID: 20261106-cma-multi-ff88e84bf599
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>, Ivy Lopez <skunkolee@gmail.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: x69garm8bkagrpmuttc5uuygra7aajpw
X-Rspamd-Queue-Id: 3813E8000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794348886-442498
X-HE-Meta: U2FsdGVkX18UBKv3KTT+b7wCpLe9+34IIYVS6yF93COm2ULFe5zE0K2Q8hyQLCIp+7Gf7ewuaDgQ6u/paNRO3qUc9ufWLM1PnRJ5k5EZulbcDVnyJYWzsJr2HVXPyofQPwuh1K4BzX/JvgK9SkMNdAt4wktxiL3xt62zoNze9QcqubjBqQyIK2GjzEw0QyDdyQ4sY0Xit22SUq/3IvPZCxh7DWZue70T3hcKbbpon/P3LiH4jGRQn0D+Rtg8A64aS6+XhLfNUFkfr9hHqFEVnT4NFjVXd+0kvUCoefPzwetYlZV/1NWyU9+Ak1uLHiKETEe9OKGo2Rwlo8QC2bVx96bsvTmv7N/ty9H1YaGueH4FblOiNvaYrFRPNRq1xSiLVfc254JS1wMTjWXyupRlw/jPrdPi9QDeNCimxRD5RFE9eCTlUHpuh+YD4yuEil9BKSTdi3V5eHw9Bw8eE6u4rxRAxa2Xs86IFVYAs7iXfwzC99TfEapeN7Z/iR/JhT9122MYpmEUDUNqlb37QRwuGfsBGMLtx7odCi0mQFJpGZJm7DWMoIJu1gu3LOfW7Mz000mFwgiS3rltVVK97OMT0Gu9vNVLj2s04szCgfXCf7UlVVuZ9ylX65qn2apMKbfm1RoOoZ2DaotamqgsZQwphn1m9oS3lJ7SuIhMCltSS3x4BBuSdlU2kf9awkpQRul4An0pvZIcMNWTxwPMJ4lbXCMlKS81qEgusi7Dl33WA4QY5tO/G0zHgzswWmzl9hX38lUKmD5+o2i72/q1UADZWkvf2QzWk5BHWJiKgQA/UT1/+WR9tLW0IW/KtMgLve823MrMbbQClmWVpdKCvaoFtcvCYoWGo8tygmp06/zCT6wRqoNU9+zuI8uqSHnKHCgnGaUyG4BADhFn0xwPBuhkOIfuTuEtm0kUNKx/7tfqFyg6QDLGVfVWg386QB+D/xHlfHwkhc2KRgys0iIIzk8
 ZBhUL/f5
 4EFPkOBMV2jaaVXZmjsI6jN4Yl7o1EOL7b0Os+nRzPpmuSrXu1C5ZY1aHsSfGR8l4i5gmW/f6EnN8KGzQdfmIq3ZOrwG6daIPfDFU7CdFNCXTWRRxKUTp+A/b6mHkgh+ouRVoS6r4xmQmDfvct8985l9LBZxsLKGX31nDSye4m1IrAzF0LR4djoKU5Q/RhrgMvAFfvT1aCywg/n1bAKwM1hFZZQSJzQOOLuBm4lvcsig0L2F5M9iXP7HfWceiGfU/BeLx/bhotcose4b2JjTdsCuBjPd/m33T1ZsmDE0E3dpFxCoEQKpLXS3j5yOvgFCK0NLqiUtYYHpJ/IrK7Wm7Zzbbpi1+ctO54aJ85xathdnw9x4CW7uUyqFptrLYQ5gOuHexOTwwUJdJF13QaudpOxo8ag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When cma_declare_contiguous_multi() cannot allocate a CMA area as a
single range, it falls back to collecting a list of up to CMA_MAX_RANGES
largest free ranges above 4G, reserves them in memblock and adds them to
cma->ranges.

The list and subsequently cma->ranges are supposed to be sorted in the
order of base addresses of the "allocated" ranges.

This implementation has two bugs:

* The allocation may fail even when there is enough free memory because
  list_insert_sorted() sorts the list in the wrong order.

  When the list is full, the largest range is evicted rather than the
  smallest, the final list is not sorted by address, and the smallest
  ranges are used first.

* the function may report success while it reserved less memory than
  requested because sizesum accounts for ranges that were skipped.

And overall it is a lot of list management and open coded range
selection for no real gain.

Replace the current code with a loop that finds the largest free range
above 4G, reserves as much of it as needed and repeats until the entire
area is reserved or CMA_MAX_RANGES ranges are used.

After successful alocation sort the cma->ranges by their base address.

The new code scans free memory once for every range rather than once
for all ranges, so it is slightly slower, but it is way simpler and more
robust.

Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
Reported-by: Ivy Lopez <skunkolee@gmail.com>
Closes: https://lore.kernel.org/all/cover.1792032699.git.skunkolee@gmail.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
Changes in v2:
- make size_mb const
- Link to v1: https://patch.msgid.link/20261106-cma-multi-v1-1-054eae6e2c1c@kernel.org
---
 mm/cma.c | 265 +++++++++++++++++++--------------------------------------------
 1 file changed, 77 insertions(+), 188 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index f61d52796f4ef..f01850d13799f 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -23,8 +23,8 @@
 #include <linux/sizes.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/string_choices.h>
 #include <linux/log2.h>
+#include <linux/sort.h>
 #include <linux/cma.h>
 #include <linux/highmem.h>
 #include <linux/io.h>
@@ -310,56 +310,6 @@ int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
 	return 0;
 }
 
-/*
- * Structure used while walking physical memory ranges and finding out
- * which one(s) to use for a CMA area.
- */
-struct cma_init_memrange {
-	phys_addr_t base;
-	phys_addr_t size;
-	struct list_head list;
-};
-
-/*
- * Work array used during CMA initialization.
- */
-static struct cma_init_memrange memranges[CMA_MAX_RANGES] __initdata;
-
-static bool __init revsizecmp(struct cma_init_memrange *mlp,
-			      struct cma_init_memrange *mrp)
-{
-	return mlp->size > mrp->size;
-}
-
-static bool __init basecmp(struct cma_init_memrange *mlp,
-			   struct cma_init_memrange *mrp)
-{
-	return mlp->base < mrp->base;
-}
-
-/*
- * Helper function to create sorted lists.
- */
-static void __init list_insert_sorted(
-	struct list_head *ranges,
-	struct cma_init_memrange *mrp,
-	bool (*cmp)(struct cma_init_memrange *lh, struct cma_init_memrange *rh))
-{
-	struct list_head *mp;
-	struct cma_init_memrange *mlp;
-
-	if (list_empty(ranges))
-		list_add(&mrp->list, ranges);
-	else {
-		list_for_each(mp, ranges) {
-			mlp = list_entry(mp, struct cma_init_memrange, list);
-			if (cmp(mlp, mrp))
-				break;
-		}
-		__list_add(&mrp->list, mlp->list.prev, &mlp->list);
-	}
-}
-
 static int __init cma_fixed_reserve(phys_addr_t base, phys_addr_t size)
 {
 	if (IS_ENABLED(CONFIG_HIGHMEM)) {
@@ -524,37 +474,71 @@ static int __init __cma_declare_contiguous_nid(phys_addr_t *basep,
 	return 0;
 }
 
+/*
+ * Find the largest free range above 4G that can hold a part of a multi-range
+ * CMA area.
+ */
+static phys_addr_t __init cma_find_free_range(phys_addr_t align,
+		phys_addr_t size_align, int nid, phys_addr_t *basep)
+{
+	phys_addr_t start, end, size;
+	phys_addr_t max = 0;
+	u64 i;
+
+	for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &start, &end, NULL) {
+		if (start < SZ_4G)
+			continue;
+
+		start = ALIGN(start, align);
+		if (start >= end)
+			continue;
+
+		size = ALIGN_DOWN(end - start, size_align);
+		if (size > max) {
+			max = size;
+			*basep = start;
+		}
+	}
+
+	return max;
+}
+
+static int __init cma_range_cmp(const void *a, const void *b)
+{
+	const struct cma_memrange *cmr_a = a;
+	const struct cma_memrange *cmr_b = b;
+
+	return cmp_int(cmr_a->base_pfn, cmr_b->base_pfn);
+}
+
 /*
  * Create CMA areas with a total size of @total_size. A normal allocation
- * for one area is tried first. If that fails, the biggest memblock
- * ranges above 4G are selected, and allocated bottom up.
- *
- * The complexity here is not great, but this function will only be
- * called during boot, and the lists operated on have fewer than
- * CMA_MAX_RANGES elements (default value: 8).
+ * for one area is tried first. If that fails, the area is assembled from
+ * up to CMA_MAX_RANGES of the biggest free memblock ranges above 4G.
  */
 int __init cma_declare_contiguous_multi(phys_addr_t total_size,
 			phys_addr_t align, unsigned int order_per_bit,
 			const char *name, struct cma **res_cma, int nid)
 {
-	phys_addr_t start = 0, end;
-	phys_addr_t size, sizesum, sizeleft;
-	struct cma_init_memrange *mrp, *mlp, *failed;
+	const unsigned long size_mb = (unsigned long)total_size / SZ_1M;
+	phys_addr_t size, remaining, size_align;
 	struct cma_memrange *cmrp;
-	LIST_HEAD(ranges);
-	LIST_HEAD(final_ranges);
-	struct list_head *mp, *next;
-	int ret, nr = 1;
-	u64 i;
+	phys_addr_t start = 0;
 	struct cma *cma;
+	int nr = 0;
+	int ret;
 
 	/*
 	 * First, try it the normal way, producing just one range.
 	 */
 	ret = __cma_declare_contiguous_nid(&start, total_size, 0, align,
 			order_per_bit, false, name, res_cma, nid);
+	if (!ret) {
+		pr_info("Reserved %lu MiB at %pa\n", size_mb, &start);
+		return 0;
+	}
 	if (ret != -ENOMEM)
-		goto out;
+		goto err;
 
 	/*
 	 * Couldn't find one range that fits our needs, so try multiple
@@ -572,151 +556,56 @@ int __init cma_declare_contiguous_multi(phys_addr_t total_size,
 	 * aligned to @align, and a size that is aligned to
 	 * both @align and @order_to_bit, things will work out.
 	 */
-	nr = 0;
-	sizesum = 0;
-	failed = NULL;
-
 	ret = cma_new_area(name, total_size, order_per_bit, &cma);
-	if (ret != 0)
-		goto out;
+	if (ret)
+		goto err;
 
 	align = max_t(phys_addr_t, align, CMA_MIN_ALIGNMENT_BYTES);
-	/*
-	 * Create a list of ranges above 4G, largest range first.
-	 */
-	for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &start, &end, NULL) {
-		if (upper_32_bits(start) == 0)
-			continue;
-
-		start = ALIGN(start, align);
-		if (start >= end)
-			continue;
-
-		end = ALIGN_DOWN(end, align);
-		if (end <= start)
-			continue;
+	size_align = max_t(phys_addr_t, align, PAGE_SIZE << order_per_bit);
 
-		size = end - start;
-		size = ALIGN_DOWN(size, (PAGE_SIZE << order_per_bit));
+	remaining = total_size;
+	while (remaining && nr < CMA_MAX_RANGES) {
+		size = cma_find_free_range(align, size_align, nid, &start);
 		if (!size)
-			continue;
-		sizesum += size;
-
-		pr_debug("consider %016llx - %016llx\n", (u64)start, (u64)end);
-
-		/*
-		 * If we don't yet have used the maximum number of
-		 * areas, grab a new one.
-		 *
-		 * If we can't use anymore, see if this range is not
-		 * smaller than the smallest one already recorded. If
-		 * not, re-use the smallest element.
-		 */
-		if (nr < CMA_MAX_RANGES)
-			mrp = &memranges[nr++];
-		else {
-			mrp = list_last_entry(&ranges,
-					      struct cma_init_memrange, list);
-			if (size < mrp->size)
-				continue;
-			list_del(&mrp->list);
-			sizesum -= mrp->size;
-			pr_debug("deleted %016llx - %016llx from the list\n",
-				(u64)mrp->base, (u64)mrp->base + size);
-		}
-		mrp->base = start;
-		mrp->size = size;
-
-		/*
-		 * Now do a sorted insert.
-		 */
-		list_insert_sorted(&ranges, mrp, revsizecmp);
-		pr_debug("added %016llx - %016llx to the list\n",
-		    (u64)mrp->base, (u64)mrp->base + size);
-		pr_debug("total size now %llu\n", (u64)sizesum);
-	}
-
-	/*
-	 * There is not enough room in the CMA_MAX_RANGES largest
-	 * ranges, so bail out.
-	 */
-	if (sizesum < total_size) {
-		cma_drop_area(cma);
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	/*
-	 * Found ranges that provide enough combined space.
-	 * Now, sorted them by address, smallest first, because we
-	 * want to mimic a bottom-up memblock allocation.
-	 */
-	sizesum = 0;
-	list_for_each_safe(mp, next, &ranges) {
-		mlp = list_entry(mp, struct cma_init_memrange, list);
-		list_del(mp);
-		list_insert_sorted(&final_ranges, mlp, basecmp);
-		sizesum += mlp->size;
-		if (sizesum >= total_size)
 			break;
-	}
 
-	/*
-	 * Walk the final list, and add a CMA range for
-	 * each range, possibly not using the last one fully.
-	 */
-	nr = 0;
-	sizeleft = total_size;
-	list_for_each(mp, &final_ranges) {
-		mlp = list_entry(mp, struct cma_init_memrange, list);
-		size = min(sizeleft, mlp->size);
-		if (memblock_reserve(mlp->base, size)) {
-			/*
-			 * Unexpected error. Could go on to
-			 * the next one, but just abort to
-			 * be safe.
-			 */
-			failed = mlp;
+		size = min(size, remaining);
+		if (memblock_reserve(start, size))
 			break;
-		}
-
-		accept_memory(mlp->base, size);
+		accept_memory(start, size);
 
 		pr_debug("created region %d: %016llx - %016llx\n",
-		    nr, (u64)mlp->base, (u64)mlp->base + size);
+		    nr, (u64)start, (u64)start + size);
 		cmrp = &cma->ranges[nr++];
-		cmrp->base_pfn = PHYS_PFN(mlp->base);
+		cmrp->base_pfn = PHYS_PFN(start);
 		cmrp->early_pfn = cmrp->base_pfn;
 		cmrp->count = size >> PAGE_SHIFT;
 
-		sizeleft -= size;
-		if (sizeleft == 0)
-			break;
+		remaining -= size;
 	}
 
-	if (failed) {
-		list_for_each(mp, &final_ranges) {
-			mlp = list_entry(mp, struct cma_init_memrange, list);
-			if (mlp == failed)
-				break;
-			memblock_phys_free(mlp->base, mlp->size);
-		}
-		cma_drop_area(cma);
+	if (remaining) {
 		ret = -ENOMEM;
-		goto out;
+		goto err_free_ranges;
 	}
 
+	/* allocate from lower addresses first */
+	sort(cma->ranges, nr, sizeof(cma->ranges[0]), cma_range_cmp, NULL);
+
 	cma->nranges = nr;
 	cma->nid = nid;
 	*res_cma = cma;
 
-out:
-	if (ret != 0)
-		pr_err("Failed to reserve %lu MiB\n",
-			(unsigned long)total_size / SZ_1M);
-	else
-		pr_info("Reserved %lu MiB in %d range%s\n",
-			(unsigned long)total_size / SZ_1M, nr, str_plural(nr));
+	pr_info("Reserved %lu MiB in %d ranges\n", size_mb, nr);
+	return 0;
+
+err_free_ranges:
+	for (int i = 0; i < nr; i++)
+		memblock_phys_free(PFN_PHYS(cma->ranges[i].base_pfn),
+				   PFN_PHYS(cma->ranges[i].count));
+	cma_drop_area(cma);
+err:
+	pr_err("Failed to reserve %lu MiB\n", size_mb);
 	return ret;
 }
 

---
base-commit: b3710a1d0f145a4f6f1d44fdaff56a6af8cffe89
change-id: 20261106-cma-multi-ff88e84bf599

--
Sincerely yours,
Mike.


