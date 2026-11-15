Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 561F6606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 06:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U8I7pPFQ
Received: by kanga.kvack.org (Postfix)
	id 7D07E6B05B5; Sun, 15 Nov 2026 01:27:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 781D36B05B6; Sun, 15 Nov 2026 01:27:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6704C6B05B7; Sun, 15 Nov 2026 01:27:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41C206B05B5
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 01:27:13 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AECE98059C
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 06:27:12 +0000 (UTC)
X-FDA: 85436371104.28.1BB7B42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id F025A160003
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 06:27:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U8I7pPFQ;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794724031;
	b=Uv+cipEzY+2T66iqfwazN6/1vr//+EAiC4MNAVMCmzPCZI+mdKbdSIYiF/cQG/HczAJ7yz
	NwHFWF5nJww5wSNhAvseZSxOA8guobfV7xDK119pNfPtaMeF/MGF3pfzZcq97KLHX3qD4W
	ZY32m3E/G88SzQAg5wanKnvNlO2vQdU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U8I7pPFQ;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794724031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Dz1HTKa9cA29oU+jZvIB6qYsMLCpYfnrjTOCzLvXPpE=;
	b=W3XDcT/aQhl6TiSpv+XqnyvQhDyNCaOBuyGJq8tGOb0Yd++52+u2yj70AqhQDjYFyY5wWk
	5xqifjBtTsy1n8oeChcZ06SpdQoJMPCadfq9OgCTJhR/Hq3IRPqA9cWycaMFF/uN9dXdxy
	8wuPxUg6tUxE6W/Yg7L6fOeZEufKbAY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 72E65417AF;
	Sun, 15 Nov 2026 06:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2A31F000C4;
	Sun, 15 Nov 2026 06:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794724029;
	bh=Dz1HTKa9cA29oU+jZvIB6qYsMLCpYfnrjTOCzLvXPpE=;
	h=From:Date:Subject:To:Cc;
	b=U8I7pPFQ08dzjlu+6xk9g3RxW8PWk9xXyQcl948Va0LSjgPdTTdMXgwFdvK+e4bb5
	 LF68Y84WXZXKQW/H11R5cA3j6MhL0JOMlKTdfpsKazcjpMob262cFZ2clZUOdjURuk
	 5ECQ6nJZ6XRwWQdUPixsDje1OHVVA1jeIoLL2TxZ+2wl21UyWKaO2KELkZkY26+KTl
	 mFN2uXDvcDkDOoldAmXA29oTGxR44AGQWNtNLdgL5qxRzaasMYr4909Ynsi6HhBYlT
	 +dDDgorPALhYOvCZ/NITPNRxcHvL1UfE5vKvFpxm7g/dGG5UvJw7MThT/f0mtbYGGF
	 A8uixuQcxywOg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 15 Nov 2026 08:27:03 +0200
Subject: [PATCH v4] mm/cma: simplify cma_declare_contiguous_multi()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-cma-multi-v4-1-d159631171d5@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23OTW7DIBAF4KtErEsLY0JJVrlH1AU/45jW4Aiw1
 Sjy3QPpxlW7fOh9b7iTjMljJsfdnSRcfPZTrEG87IgddLwg9a5mAgwk50xSGzQN81g87XulUAn
 T7w8HUvvXhL3/fm6dP35yns0n2tIGWsPojNQkHe3QnkKYSngLgc4xF21GbJ3B5zKl2/NDC29b/
 91eOOWU7QVqlAiW29MXpojj65QupB1fYEM531KoVCA45wxocOoP7bYUtrSrVMpOsPcOFDL9i67
 r+gCRUB92TwEAAA==
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
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F025A160003
X-Stat-Signature: easwzck18y7por5zjc51yn7j7mwmcy1p
X-Rspam-User: 
X-HE-Tag: 1794724030-155449
X-HE-Meta: U2FsdGVkX19xVe2Rw3G7KFBXYHWdGi04T+7PhHNyK4XEgjM7JmM2CrOQhv5scsgL6utApahTdUJ8tt4sqvSHV8Skr8LcQve/Jk22PP3FdXP8tnWGLW5HNBV/sohGPAgnn8sUIgjosROazK7ZlYUPbZuVGCK4b7jSoo7PuCNUJP9Lu4Zl+3kE33dBeAI4SiIkByik5DcjMHKMZ7m8qxSpWxAfvAeIxax+Gs+gneKIvKVfSbFfSX+gJp//umqMUR5lbL3fxKrTBhs9ngGNoLz+nSbckDH9JzMMflwydMtZ1Ur8Ye7VUdkkTD8LcJJCQACmvT84A1x0ElikVcjU0POWt3tJtuU/SdBAQNRNME84cnurZTLJuFh27mXyrpnFmLCd1xy4FLpPjQkg81u39k50rc2aP2O/s/l/8MBdLSrErQxw0zoUhxyK+fIrIZfWMAia5BWTxNONXD0V5BQp7MHHewsWOMrJYT2mkGgf/cwbXr1sUop+6Q36kkRBciwdETn7VTTAGwzxyNoETZGti/fm+OvLuMt4ZuwXePArIF+OOJr0LoFhWxlCZhBO2Z9vqyHXHlNMajJKqiWMUesuT3NKAyb1phoQDtu+tYQeSSivaweIFaTkCUkGxP2FLHFaRDBCvZUGl5CjMs1ToDRSI2XGSd5QDUNQ3pq01oW8k0r6SNuVYWno59XQmkILWOAN3wshUtv620lB5YzMkPsmXuMnVkzlmOF2HvPi10tU8E94Ug6oZyZxLEob8pNjBe8glDszWzLOUy05w76el7lD6z6bqd+lSTJ3OFyvxAWLb22nWopQF5TV2sRO+e308bz7gaxQWq/sxkBty5ho8r9GCnh5XGTodxAd5fxFKEulXb6x/Z842x91KNfs8jzii5qBSD4RJCMyOJ3ff6f/61uVbpJmcR34jU5kukuVbnZylXHwxN0cPnlpH3aamHfn8fsGswoUgd0xSde0RztHek97WPA
 daX85ABt
 qFU2AbKD9u5TfS5YkUyzkZN2ICWHH4qAt9Y+DS0x5JEfCuVNVUra7lvEid6Yr8jNY6Dbm3Zq58HBY2YXi59B3yTuOSW3Re5MsDC16bQzm0M3gakPqjqU/eGsUg4XGYVMf3OrA2UpoeGbuMcsrFY+Ta/TJKBViGl2HGuNK26M83XhSBLb5PRMmn39Ft9M2Aj7/if7JPSTuxA/Zvg/oMeHXujVNxga56y86VLEIknNkHTh+8ZG/qbyXAacBSKcAnlA5WJFTfzlesu0MD+/Uaai85Xx60XBpAWYgGtIxpW5u6B6NnvSPxXp9YOQJRU9+0+OP1MPHPwD49Zv7RcOk9EMWaHTRrlmlBpRTFeAbDvOcAVvCJov3WOeG0DhmIaTwohHHLG0neKLotnp+QLI/bmiX3uoYZrsWbgZbegbKA8NTEtmiGoAQNcqK4qO6OhAtOwVe24mrhkUAE+izmDg=
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
Changes in v4:
- silence smatch warning about SZ_4G on 32 bits
- fix a type in a comment
- Link to v3: https://patch.msgid.link/20261112-cma-multi-v3-1-663407328e0a@kernel.org

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
index f61d52796f4e..bdad6e74abbc 100644
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
+	/* no point searching if the system can't address above 4G */
+	if (!IS_ENABLED(CONFIG_PHYS_ADDR_T_64BIT))
+		return 0;
+
+	for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &start, &end, NULL) {
+		if (!upper_32_bits(start))
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


