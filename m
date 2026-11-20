Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D5D3606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 08:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=t13JSo18
Received: by kanga.kvack.org (Postfix)
	id 1CAFE6B05F9; Fri, 20 Nov 2026 03:58:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17C0E6B05FB; Fri, 20 Nov 2026 03:58:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 092476B05FC; Fri, 20 Nov 2026 03:58:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CEFCC6B05F9
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:58:48 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C1D3080E76
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:58:47 +0000 (UTC)
X-FDA: 85454897094.11.9F2547D
Received: from mta0.migadu.com (out-92.mta0.migadu.com [91.218.175.92])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9F85E120006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:58:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t13JSo18;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.92 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795165126;
	b=aqozcu9B3uBzZK9E2MwigzQRIBaTyf1cfJOVldWnbFE0psZ6BWJ61B7iHxItuYcMBkFDSc
	B7iwidDHSVA7bvKPHNManKo3wbxjnlERoUM/av4y+Ad006ijsHtDzan2nN8bGxA2wKQ1zW
	vUFw+1xe2tfD8E7xHWBm/VeYnSGNbnA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795165126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NiQJ70WybANBqHxkS0CY6C31atvBrnYTiDvLqBkPxX0=;
	b=l/DO+ojXY+sW6RkayBolqMHzYau3XykqNb60v4lx2gEhfEeyOJAqz02eqBb6M7TMiq8vnz
	QHk2LQeSFooSqRi0xHd3phpA96BBJRPTBgqmQUTLUpFcS3x5+6oEm7cMTUJe3jSLwjEHTu
	x+q5FfzblnP4588qKAAH2tnsjeETU+E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t13JSo18;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.92 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=aEB9dVICwrz9Ujk3046RvWzBejf32Q6ytD2l9s+JPoA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795165124; v=1; x=1795769924;
 b=t13JSo18+wPOlJ3hLYYohHFB7r1APMMFl1QlbjdhGEThUN8yixUHNg+1bhqRb1V0K92qrXZV
 0CP+N9qMgz8NqqguET4LdHyAlwqlfVhY3S84/QlvX6c67Ec7inpkTvbwwsz597iY0N2qGsn18gG
 bjpuA7vsb1wR4DpLqsT361sw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id cb2157f18c2c5909;
	Fri, 20 Nov 2026 08:58:44 +0000
X-Mizu-Trace-ID: cb2157f18c2c5909
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	Baoquan He <hebaoquan@kylinos.cn>,
	Kairui Song <ryncsn@gmail.com>
Subject: [PATCH 3/4] mm/mglru: skip cold PUD subtrees during aging
Date: Fri, 20 Nov 2026 16:58:05 +0800
Message-ID: <20261120085806.781225-4-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261120085806.781225-1-baoquan.he@linux.dev>
References: <20261120085806.781225-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 9F85E120006
X-Stat-Signature: 137jhmfmgep5qw8wws81fsdwjic45998
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795165125-701097
X-HE-Meta: U2FsdGVkX1+h8GlN9/VWIUFLPXIsl5TMhndoluBIL/57IU2wVMbyXNTxO36KElHNHjnJVZHSku8weeIqM1cs67ect7sPDpkh5SQ+LfLPh42/+6Oer5x9nHIH7XQgAXlSsJkNO4sBva03gHWCP8ldrCKjAAR2tlcMH/BI3MsIcQCktBAOHfCOXWk29u1vW7Q8P/zBCdnbfxTCsz/qdjgnIVfB3q9W+D3obUX16RF0RWdDh4kVPVBGJpHljulaukXzj47n1WtBNsYvk/MNeP1nhO4tnQdahuC7qO+xQt3y14rt4/sWzINOVOBflLrSEV5uAJM7CmeWso5tMaoKMtrjf2Y7/HeH+zmgoDWEeqs8XJ5de1q4OtVyNd20YcOVWk9OsUBle5tMUpmzZsifqRcxWX7uMickHRj673S5dXhGioSMwVva+JhPxVPWqsLnGUNxtS6m4aVCK9SIx9YYt2yG9HquUzAiyy3V20d5shdYNxWzyOw1huEL9s/n/QqBbxL/NwC8J1j4m+xDLFrGg3jjNeCmUnrjdkmypIa8763WbPJaucWXqKELgri+Vl8heUK8XsjgpHOJ6PxjcJM0PpYUQW++BtusocebNgBDqBgC4olcvz/G2GEUERi6rbnc4pUFQuJrAruU/nPJcqyjVmfI055rvx6BnpM88hZLJJL6ujFlvuVkJlBcNCttjeeK1Sk+Y1zm+nqJSWP71vw9g81hvFF6MCEciZlESgCUgOTaXHEY7OoRquRv3Psey1WCf7InkF+CR5U9L+r9+pLIn/eX2CMGWkfW1VkptlZam9Fy4jmTtjkHe0xeMXPc/Wsj+NBu2JRqSZpMDsHRtkWpsl2XkM79N/JSybFaPgcSiE+RQl5bAR04pXH6xn0GcnTPDxCurbcbrX6he11l3OjUD6BVVxkTsu4A7eLmZzYOKzo1xiEUOrKVRZI4jH1z0AvoZOzr7CCC8tIvA4dycY+me0e
 m5L9vdTB
 AiF6r+GiKaGn+gjPd+5xcQRgZsSJG/Dyx9d/3G+VzFj94t2TbxgtusekNrQ8MXMYhNZkusu4hcyp8UJD1Ws+adP8awWN6QH9XLNhGBI1vj9hne+UUFojERVzOTaVEU43n6fiX6+ZBJWGXVjzXVVcAU5qDzenO4zlG45VLp7lsAPJazTFPV3adgV11HdH5vzE6y8bZ466p+6sqtg7vTOxBBL2YMiOhzeVVVxOFTg5WY0G+S+ekJlijcReEB+hooVkx66tbD3Bsj5g8ZeyuPLwB+bc3+5VdsSWhGl//5aBMOKp8W8A9mHUNo2EB2H6bze3rcuwN848UIo5tSSaHoQVXF6DjbPniIiaD7YdKdRqgH+Ogwo+PvHUQPk4z6nXCxgJxHIFuJq0aZX3G7lrx0tYv8u74Dq5VD49SCMg1W31ltVkgKx4WDFIspVFCgWZ05Xf7fhrWCgpau1XKIBaiEWHOKqypWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

The aging walks into every PUD and runs the PMD-level Bloom filter on
each PMD. Add a coarser PUD-level filter one level up:

 - walk_pmd_range() reports whether the subtree held anything young for
   this lruvec. That is the same condition which already carries a PMD
   over into the next generation: a young PMD entry, a huge page owned by
   this lruvec, or PTEs with enough young ones to pass suitable_to_scan().
 - walk_pud_range() records that in the PUD filter, and
 - on subsequent generations, skips the whole PUD subtree when the filter
   says it had nothing young last generation.

Use (mm, PUD-aligned address) as the filter key rather than the PUD page
table pointer. It is a stable identity for the range being walked, is
available without walking the page tables in lru_gen_look_around(), and
does not depend on the lifetime of a page table page.

The PUD level keeps the same m and k as the PMD level. It holds far
fewer keys, but a false positive there costs a walk over 512 PMDs, so
the same bitmap size is not an over-allocation.

The double-buffered filter flips with each new iteration, so newly hot or
migrated-in pages are re-checked promptly rather than suppressed
indefinitely. force_scan walks bypass the PUD test, so manual aging and
newly added mms always rescan and re-populate the filter.

To keep hot regions marked, also report the covering PUD from the rmap
feedback path: lru_gen_look_around() for PTE-mapped folios, and
folio_referenced_one() for PMD-mapped ones, which never reaches
lru_gen_look_around(). Without the second path a PUD that holds only
transparent huge pages stays skipped after one cold generation.

Suggested-by: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/mmzone.h |  6 +++
 mm/rmap.c              |  5 ++-
 mm/vmscan.c            | 99 ++++++++++++++++++++++++++++++++++++------
 3 files changed, 96 insertions(+), 14 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index a3a13a77ca8e..59963fbee255 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -678,6 +678,7 @@ struct lru_gen_memcg {
 void lru_gen_init_pgdat(struct pglist_data *pgdat);
 void lru_gen_init_lruvec(struct lruvec *lruvec);
 bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr);
+void lru_gen_mark_pud(struct mm_struct *mm, struct folio *folio, unsigned long addr);
 
 void lru_gen_init_memcg(struct mem_cgroup *memcg);
 void lru_gen_exit_memcg(struct mem_cgroup *memcg);
@@ -703,6 +704,11 @@ static inline bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw,
 	return false;
 }
 
+static inline void lru_gen_mark_pud(struct mm_struct *mm, struct folio *folio,
+				    unsigned long addr)
+{
+}
+
 static inline void lru_gen_init_memcg(struct mem_cgroup *memcg)
 {
 }
diff --git a/mm/rmap.c b/mm/rmap.c
index 65646ed6fc45..ea5ada45c09f 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1004,8 +1004,11 @@ static bool folio_referenced_one(struct folio *folio,
 				referenced++;
 		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 			if (pmdp_clear_flush_young_notify(vma, address,
-						pvmw.pmd))
+						pvmw.pmd)) {
 				referenced++;
+				if (lru_gen_enabled() && !lru_gen_switching())
+					lru_gen_mark_pud(vma->vm_mm, folio, address);
+			}
 		} else {
 			/* unexpected pmd-mapped folio? */
 			WARN_ON_ONCE(1);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index a4c64a190391..2cd3f28f7428 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2794,9 +2794,18 @@ static bool __maybe_unused seq_is_valid(struct lruvec *lruvec)
  * walk_pmd_range(); the eviction also report them when walking the rmap
  * in lru_gen_look_around().
  *
+ * A second pair of filters works one level above the first pair, over a whole
+ * 1 GiB subtree (a PUD): BLOOM_FILTER_PUD next to BLOOM_FILTER_PMD. A false
+ * positive at the PMD level only costs a PTE walk when the PUD level also
+ * passes. A false positive at the PUD level is rare, because it holds far
+ * fewer keys, but it costs 512 PMD walks. So both levels keep the same m and
+ * k, even though the PUD level holds much fewer keys.
+ *
  * For future optimizations:
- * 1. It's not necessary to keep both filters all the time. The spare one can be
- *    freed after the RCU grace period and reallocated if needed again.
+ * 1. It's not necessary to keep both filters of a level all the time.
+ *    The spare one can be freed after the RCU grace period and reallocated
+ *    if needed again. Now: two levels of double buffering take 16 KiB
+ *    per lruvec.
  * 2. And when reallocating, it's worth scaling its size according to the number
  *    of inserted entries in the other filter, to reduce the memory overhead on
  *    small systems and false positives on large systems.
@@ -3110,8 +3119,10 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
 
 	spin_unlock(&mm_list->lock);
 
-	if (mm && first)
+	if (mm && first) {
 		reset_bloom_filter(mm_state, BLOOM_FILTER_PMD, walk->seq + 1);
+		reset_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq + 1);
+	}
 
 	if (*iter)
 		mmdrop(*iter);
@@ -3626,11 +3637,12 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 	return suitable_to_scan(total, young);
 }
 
-static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area_struct *vma,
+static bool walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area_struct *vma,
 				  struct mm_walk *args, unsigned long *bitmap, unsigned long *first)
 {
 	int i;
 	bool dirty;
+	bool young = false;
 	pmd_t *pmd;
 	spinlock_t *ptl;
 	struct folio *last = NULL;
@@ -3644,13 +3656,13 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	if (*first == -1) {
 		*first = addr;
 		bitmap_zero(bitmap, MIN_LRU_BATCH);
-		return;
+		return false;
 	}
 
 	i = addr == -1 ? 0 : pmd_index(addr) - pmd_index(*first);
 	if (i && i <= MIN_LRU_BATCH) {
 		__set_bit(i - 1, bitmap);
-		return;
+		return false;
 	}
 
 	pmd = pmd_offset(pud, *first);
@@ -3702,6 +3714,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 			dirty = true;
 
 		walk->mm_stats[MM_LEAF_YOUNG]++;
+		young = true;
 next:
 		i = i > MIN_LRU_BATCH ? 0 : find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
 	} while (i <= MIN_LRU_BATCH);
@@ -3712,12 +3725,15 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	spin_unlock(ptl);
 done:
 	*first = -1;
+
+	return young;
 }
 
-static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
+static bool walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			   struct mm_walk *args)
 {
 	int i;
+	bool young = false;
 	pmd_t *pmd;
 	unsigned long next;
 	unsigned long addr;
@@ -3755,7 +3771,8 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			walk->mm_stats[MM_LEAF_TOTAL]++;
 
 			if (pfn != -1)
-				walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
+				young |= walk_pmd_range_locked(pud, addr, vma, args,
+							       bitmap, &first);
 			continue;
 		}
 
@@ -3777,15 +3794,18 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			continue;
 
 		walk->mm_stats[MM_NONLEAF_ADDED]++;
+		young = true;
 
 		/* carry over to the next generation */
 		update_bloom_filter(mm_state, BLOOM_FILTER_PMD, walk->seq + 1, pmd + i);
 	}
 
-	walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);
+	young |= walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);
 
 	if (i < PTRS_PER_PMD && get_next_vma(PUD_MASK, PMD_SIZE, args, &start, &end))
 		goto restart;
+
+	return young;
 }
 
 static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
@@ -3796,6 +3816,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 	unsigned long addr;
 	unsigned long next;
 	struct lru_gen_mm_walk *walk = args->private;
+	struct lru_gen_mm_state *mm_state = get_mm_state(walk->lruvec);
 
 	VM_WARN_ON_ONCE(p4d_leaf(*p4d));
 
@@ -3803,13 +3824,29 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 restart:
 	for (i = pud_index(start), addr = start; addr != end; i++, addr = next) {
 		pud_t val = pudp_get(pud + i);
+		void *pud_key;
 
 		next = pud_addr_end(addr, end);
 
 		if (!pud_present(val) || WARN_ON_ONCE(pud_leaf(val)))
 			continue;
 
-		walk_pmd_range(pud + i, addr, next, args);
+		/*
+		 * Use (mm, PUD-aligned address) as the filter key instead of
+		 * the page table pointer. It is stable across the aging walk
+		 * and the rmap feedback path, and avoids walking the page
+		 * tables in lru_gen_look_around().
+		 */
+		pud_key = (void *)((unsigned long)args->mm ^ (addr & PUD_MASK));
+
+		/* Skip a subtree that had nothing young for this lruvec last gen */
+		if (!walk->force_scan &&
+		    !test_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq, pud_key))
+			continue;
+
+		if (walk_pmd_range(pud + i, addr, next, args))
+			update_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq + 1,
+					    pud_key);
 
 		if (need_resched() || walk->batched >= MAX_LRU_BATCH) {
 			end = (addr | ~PUD_MASK) + 1;
@@ -4336,6 +4373,39 @@ static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
  * the PTE table to the Bloom filter. This forms a feedback loop between the
  * eviction and the aging.
  */
+/*
+ * Mark the PUD covering addr as young for lruvec, so that the PUD-level filter
+ * walks that 1 GiB subtree in the next generation.
+ */
+static void lru_gen_update_pud_filter(struct lruvec *lruvec, struct mm_struct *mm,
+				      unsigned long addr)
+{
+	struct lru_gen_mm_state *mm_state = get_mm_state(lruvec);
+	unsigned long max_seq;
+
+	if (!mm_state)
+		return;
+
+	max_seq = READ_ONCE(lruvec->lrugen.max_seq);
+	update_bloom_filter(mm_state, BLOOM_FILTER_PUD, max_seq,
+			    (void *)((unsigned long)mm ^ (addr & PUD_MASK)));
+}
+
+/*
+ * Same for a PMD-mapped folio: folio_referenced_one() takes the
+ * pmdp_clear_flush_young_notify() branch for those and never reaches
+ * lru_gen_look_around(), so without this a PUD holding only THPs stays
+ * suppressed once it has been skipped for one generation.
+ */
+void lru_gen_mark_pud(struct mm_struct *mm, struct folio *folio, unsigned long addr)
+{
+	struct mem_cgroup *memcg = get_mem_cgroup_from_folio(folio);
+
+	lru_gen_update_pud_filter(mem_cgroup_lruvec(memcg, folio_pgdat(folio)),
+				  mm, addr);
+	mem_cgroup_put(memcg);
+}
+
 bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 {
 	int i;
@@ -4437,9 +4507,12 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 	lazy_mmu_mode_disable();
 
 	/* feedback from rmap walkers to page table walkers */
-	if (mm_state && suitable_to_scan(i, young))
-		update_bloom_filter(mm_state, BLOOM_FILTER_PMD,
-				    READ_ONCE(lruvec->lrugen.max_seq), pvmw->pmd);
+	if (mm_state && suitable_to_scan(i, young)) {
+		unsigned long max_seq = READ_ONCE(lruvec->lrugen.max_seq);
+
+		update_bloom_filter(mm_state, BLOOM_FILTER_PMD, max_seq, pvmw->pmd);
+		lru_gen_update_pud_filter(lruvec, vma->vm_mm, pvmw->address);
+	}
 
 	mem_cgroup_put(memcg);
 
-- 
2.52.0


