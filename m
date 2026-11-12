Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67941606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 08:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e0QsxdfR
Received: by kanga.kvack.org (Postfix)
	id 781A16B05BB; Thu, 12 Nov 2026 03:17:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 732ED6B05BC; Thu, 12 Nov 2026 03:17:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 648366B05BD; Thu, 12 Nov 2026 03:17:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4945C6B05BB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:17:10 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4075E404CB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:17:09 +0000 (UTC)
X-FDA: 85425761778.05.4DB53F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7EA00160007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:17:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e0QsxdfR;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794471427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6nvYO01y5mKHUhkA/waTaNTnklLNaQwBCR/GbfrB9VI=;
	b=pXODiYHIBLoKjbwpXtMRc3QgntULViMn444STIj/bUQ8D/1djlk00yKccRnTUQld/hXNDD
	ZCk6fpmxuzDRxeEWtYl3pciIgXg23PoQrbkU16RU5dGXj3wAyfc99cMOq6qP03P6kxxK4c
	3z7xyeuvwMSv/Ec9NVPDuiyfhUWtoEg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794471427;
	b=vxz+Fx3GF8iRE5H3Ko+cnRiPHlwwRFtO1ypiUOA/5WASIXELpU3Mffz2VAqZa4EpTcrCW7
	J9NelZ+IvAvhZpCk4BFlAcFwDayMTpHu5yXu1zg5B0FPjC3SBva5itcYt6wzQSrluOcKxe
	jcIEyUuuA69UvnDSbBfrTp0qY06lTBM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e0QsxdfR;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AB8F243F7F;
	Thu, 12 Nov 2026 08:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773571F00A05;
	Thu, 12 Nov 2026 08:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794471426;
	bh=6nvYO01y5mKHUhkA/waTaNTnklLNaQwBCR/GbfrB9VI=;
	h=From:Date:Subject:To:Cc;
	b=e0QsxdfRYSDsk8pqZMMWR+h9FbnIeSwmMvhseYhCFiEaOsT98+9fJXWqppdFGb4pL
	 ZJrR4gGlZI1sRDWbpFnPMr123JoMCat7K0t7BDufzYXQ3AmDIhkqRdM68XYTOfaY4k
	 xEz6khtWErdnXBHzh/Tq7E7CIsEvYngkI+f9/0LjiAvaS2uNTMQjko+IVJxa0X9dRJ
	 wEegdryK6TY9OLB3LCfg/KkgIiwPYtweGaUTz2/B/5yTiKeL+XLitu44zvReGcRayz
	 rzpVwXTM7rOlxIYy2CoBpg14QExR6/Nj5vWYnyBEVdEYGwl0MUMHjZq6b5V+o4nM/d
	 84tpRwVo4wBvQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 12 Nov 2026 10:16:57 +0200
Subject: [PATCH v3] mm/cma: simplify cma_declare_contiguous_multi()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-cma-multi-v3-1-663407328e0a@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22Oyw7CIBBFf6VhLVqwbdCV/2Fc8Ji2aAEDtNE0/
 Xehbmri8k7OuXdmFMBrCOhczMjDpIN2NoXjrkCy57YDrFXKiJa0IaRssDQcm3GIGrctY8Aq0da
 nE0r800OrX2vX9fbNYRR3kDEXZELwAFh4bmWfT8a4aA7G4NGGyMUAmel1iM6/14cmkrv+bU8EE
 1zWFXBogEoiLw/wFoa98x3K4xPdqIRsVZrUCqhSSlBOFftRl2X5AHF8ixMUAQAA
X-Change-ID: 20261106-cma-multi-ff88e84bf599
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>, Ivy Lopez <skunkolee@gmail.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Oscar Salvador <osalvador@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7EA00160007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ywq9u7ybumeeqkkobogjyrnh6maeybwa
X-Rspam-User: 
X-HE-Tag: 1794471427-360347
X-HE-Meta: U2FsdGVkX18517ILL1HHRgRvNZnG79vtEeQqIIcaEOe3sBxekho/4720tqtwXHBWqjEACEgXmD2GxnMOAjOUpb7JSbtM19NmXW4iF++mRycDx/TgUDh62S2vVZCdf8eEGZpHsz/dODQPytGD0rzIoGjoWI38v684dHQbPRKjezPvtI882EchEbKciqQjBgUannvGjVSVNfHDig2aRDE8bJhsd1r/9a2CQziWoCMOZz2CuHzS7XqfDKtKBW24X1Rb5Vxt7atw6muMOCF4JY4yksuNjYexXAxQTGi9nb7WCmioiDAJuffZZziAi1JaQEbs66Varn3y8oSENdWr+Elec7vxUp6T2ZYnGteq8ZzKCKGwuLNyrGqPNLXyPFyCHVbsIFULly4H6f8xicNfEDow+FMufxhIhizxzplUmJawue/ApVR9YQe9W0UY4804Pg+az33n3v5yFqe5KCThnFrmmANnk26hshmlxa2S+V8xu8BSbsTarbBJDkRxgCg3e8pbABkCqey8QfjaKdGVtOkQHvcG274a2XGZdaoXbHZeCFjP8p5FBxw8xKSEqdGwkqN+jbBJwWQERo+ATAI7mBA+A/W5/4JvLABc3iX+40HskiMnPUDl37DVdbkIOJoHdqAhDXjtWH2CX//V8rpi/WyYq6uLkW3HSV9vpYNpiHGKD/yPUM5PQuYJHY72WouDXeN2v4I1a/TsiE9p3lt+R2F7V/Khfx7sgpdnjX83H4iISujxBLWt1954HRwu1JElCAJ+NbzsX0r7dZK4/DrPSTgcNaUkZj+eDFVuBg51Kh3OokWZ08u9gkUNdd6V8EJXRNDZg2K4ce/IN13aM2wz/dIss94aRsBtxBVACY9+JZQ9G0EIxcaJu3abl1wyDms+syRkPf/hfx7m+JXJmyeKcshtiQeiuHbERcLQjrSrxfFIZXm/F2+dPuZe0pwtAgtgaPFHNlHZD+62m4FOD2JOI6C
 rZIU7sWE
 BP8+ivqHaEe0oC59dlwFQwSu/z9mozGh/tmRqmiJe0rkg5NjF9Ka5iA+YWNQLrvX+f8C1LyyYMPah2DFQCeGiY9v7PatJKBLSKxUJgIvNYfb3Ud+rNkyhUWcMsq5zPJBGUVL1drXj9SIxptaJ7rT3EnNdZf4aarualJLEF/yv3I1saZt65Re1ypkcrxPIkZsIH5EyF74D0OXj0D1thnUHRiBcURYDP9s0YCPcDZu1IU3GIl3Ni59ojR759poG670SLq3LfHeuiBSyiIP5eH07J7KrFQV9RoHM2HEcWnyi6bKwXpgnGbpgXLCksdozASTWTCwFL7tcCyKU6yPJZkv4DhvRGxcIOOij+Bxk+5p32yO9U7+it6erZ6cS2tHZDpfeLfEh1XLtvzaql2ebY6yb8QhoGa6Josf/HPixAe/ZYXUX+c0afs+KEQwJXKzkVX+IliCR5h0ry0LFdcg=
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
Reviewed-by: Liam R. Howlett (Google) <liam@infradead.org>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
---
Changes in v3:
- Skip the search when CONFIG_PHYS_ADDR_T_64BIT is not set to avoid
  clang warnings on 32 bits.
- Link to v2: https://patch.msgid.link/20261111-cma-multi-v2-1-4e2dddb2a2d8@kernel.org

Changes in v2:
- make size_mb const
- Link to v1: https://patch.msgid.link/20261106-cma-multi-v1-1-054eae6e2c1c@kernel.org
---
 mm/cma.c | 269 +++++++++++++++++++--------------------------------------------
 1 file changed, 81 insertions(+), 188 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index f61d52796f4ef..1733c418320ae 100644
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
@@ -524,37 +474,75 @@ static int __init __cma_declare_contiguous_nid(phys_addr_t *basep,
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
+	/* no point searching if the system can't addres above 4G */
+	if (!IS_ENABLED(CONFIG_PHYS_ADDR_T_64BIT))
+		return 0;
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
@@ -572,151 +560,56 @@ int __init cma_declare_contiguous_multi(phys_addr_t total_size,
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
+	size_align = max_t(phys_addr_t, align, PAGE_SIZE << order_per_bit);
 
-		end = ALIGN_DOWN(end, align);
-		if (end <= start)
-			continue;
-
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


