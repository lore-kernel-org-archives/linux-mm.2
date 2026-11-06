Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DCB6606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 12:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GMqEJvRG
Received: by kanga.kvack.org (Postfix)
	id 580866B05B2; Fri,  6 Nov 2026 07:56:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 558F86B05B3; Fri,  6 Nov 2026 07:56:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46F326B05B4; Fri,  6 Nov 2026 07:56:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B2A36B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:56:29 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD40AC0C0C
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:56:26 +0000 (UTC)
X-FDA: 85404692772.24.05C9249
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 026A5100008
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:56:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GMqEJvRG;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793969785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OKC3jRj48kkpLMD/38L/s6W+8zOo1qaYUVoBDKlZfA0=;
	b=wvGtf6o+qu0dJcb1ieo8i0cHncu89CLbkdnDUvtNoXPDUYY/NoeMnHc2z0/k/VJhb1jFuW
	WB3DxBvfQKewIkWOJZR7dXXwWyDtY/I+4q1LuQCRZ7ta2Eo6HvOm2joUOTPKWKSwEMa6Ij
	+PwJV/NE8YB234RyJ38CF+WUtpM6adA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GMqEJvRG;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793969785;
	b=CLj+7tTBSlPiQgkxEHOnpfjuoMtNX6Pk2G6q8HODXuI+AVgL+8OfLaiQi/nzRIfC5a7QH7
	eTZU8dQ81pdMRknOR/Yolpj5aTSH2wpUyeu+CvWQevNr3naxXQavyiaEsX68Ii15lB2eD8
	nYl3HwxSS9718W/JMB/qszK/R46r2Og=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2BD956020F;
	Fri,  6 Nov 2026 12:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE4C1F0089F;
	Fri,  6 Nov 2026 12:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793969783;
	bh=OKC3jRj48kkpLMD/38L/s6W+8zOo1qaYUVoBDKlZfA0=;
	h=From:Date:Subject:To:Cc;
	b=GMqEJvRGeJoZ7ShatF0hf21L5XG0wYnBdvD+vTp/XsO/ae4552bG3CgvjDBly3PBw
	 cWfpvIiX5qi5vJrr0FAOxJLZ+6uutH1I8EHQ5b1CLslCwJ83kfGN7r1o5yzpxlif1r
	 CVElrBe+TSOOx0t4du6Vbfcyc3EHHpfM2OTlxgfrOnN/yN5lyJLi2FrDhi0NZxQ9nF
	 FLK2b3YgCMo0Mts6YGG0WtIlDTKmAWP2I2pweBXlBFGrXhaYPpk8zD16tWp6X1M06D
	 QxEwCH+w5FILodvt2g0rx0vaumRA3XfV5U4J/OdKN9r/3hu82M5iqhczVNETjOgB+Y
	 SQigG5ELb0YRA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Fri, 06 Nov 2026 14:56:18 +0200
Subject: [PATCH] mm/cma: simplify cma_declare_contiguous_multi()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-cma-multi-v1-1-054eae6e2c1c@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMQQ7CIBAAv9Ls2Y2l0Yb6FeMBcLGYLjUsGJOmf
 xf0OJPJbCCUAglcug0SvYOENVZQhw7cbOKDMNwrw9APo1L9iI4NcllyQO+1Jn2y/jxNUPtXIh8
 +v9f19mcp9kkut0ErrBFCm0x0c1PMa+YjM5Yo2diFYN+/g30ZzJEAAAA=
X-Change-ID: 20261106-cma-multi-ff88e84bf599
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Ivy Lopez <skunkolee@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: jd9zdiit6r4m31bj9ygckxc5krtmcc7f
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 026A5100008
X-HE-Tag: 1793969784-120368
X-HE-Meta: U2FsdGVkX18ETr31cZyYAaIFyM3joBbHPqk2jeGKRyohZat2Nl4JmX56dpPfvUs6GV+7M0GdHbUzGZ/XBmMroezrAWEuqJ1kCgimVQdFXCvrynMDHkM+JFNhqPXQVKsZNk08kS7mW8EHXM6mnZRXQQn6pvXWYXF0y4j3Fa1vOJQkdEZVjVXMcWevm5aiLRKpsAoVNnSqOuYgdQP9TZq3b1dkPnro2WTdzAYiha/MWQUhoZjItudSTKqLt2Fk6usKeZoExQHleVGFlyKikLv/NeRSh9ewHi1uvMbM3nUHJNMP6HE1t9I3wWrQQgzKfvkDaOHuuF0EDyBRY7T0BjD7LTe3PjZoCSDrxTmFOktrfmqg5RTIWN4/nZ2fqP7GiY1ic6nYLIF4coyGnYey1mBgRtbM1+9PPQoDwyt6K+yQmBZEOW67jsGUOzi9COA2dyFE8Xvb7szotZOua5lF/egSJ237fGWBi8TC3fvikm1I60ge2KKh9a0xtl6bC+Xp73WNFyZQd6BvzqEHus9JUu9/9YAzgojJ0OJh+xBenf/CPJm/itJmvo2/QOhMJOpsuW85obnItqFXOHzgzj2unmtEkFxKGn4J7HKWS9oMvqIAnUjHfjfgdESz8nc5tZPqhWh5Neon7lWwWYzCKolhkJv8g/o04Dbax+aXpdqj4qIPl066gSjnecXTzXADQp/wkMuLxadP9vgqRb1LAPLLjXchVh7223JZMRGd49Qe2J5mR8V2jlBblvdPqgOB98pE3G4mj1RzCcbdtoi7KNkNuoQ1Ix3HzK7jjo0RB6bDOU+DfbWB2SU+32covriNBcyNxi9p7/G4slCNtBdenI/83uM/g4NeLDc7mlZw6d+XYwwvyNdKu2BC9AhFYANjkvHI/Rc1dPTx/c1XCr7+N6iZ6gb0z8rQN6SaVrfcX7PtrurhygJIkqZ2CGn7ZihMDHyhnCoNNpVZwriLOd93IGzpnpl
 nVDIC/+a
 hlJkqFousLoV/lAWL3MeiNt8nk84jySXPFJSdRfoWQIdOwid/QnF8NhOGWfRNxOmnasa8ENAiGRzvuh4PorWgT9rqNZTJmIfo2Q4TKgzcsOxUkFJfdbv9F6m0l1/ARpsVxsU50qC7qdTuR9utJP1x3ffrqgyJmUMXNrSest/sk7o4Y/c1p8/iRH+D7ksqivy7SNmPe1ekhalyHgNaDRC8/MGG9MoGlqof6V7DG7pzuf62P9DuOGM1XPKRJnA1swVG6FTuVgomFT72MljwyNB2+E48JwMMohh3Fb4Q4U9sQCS3YLK6O0+Jh3Vdb04xyGpXlBCr
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
---
 mm/cma.c | 265 +++++++++++++++++++--------------------------------------------
 1 file changed, 77 insertions(+), 188 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index f61d52796f4ef..ef0c49985067d 100644
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
+	unsigned long size_mb = (unsigned long)total_size / SZ_1M;
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


