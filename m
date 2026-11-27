Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4887606A323
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 06:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TTEIKit1
Received: by kanga.kvack.org (Postfix)
	id B92806B05B7; Fri, 27 Nov 2026 01:17:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B69B16B05B8; Fri, 27 Nov 2026 01:17:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A59336B05B9; Fri, 27 Nov 2026 01:17:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78FB76B05B7
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:17:02 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0CFA01401ED
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 06:17:02 +0000 (UTC)
X-FDA: 85479891084.16.18C1429
Received: from mta1.migadu.com (out-14.mta1.migadu.com [95.215.58.14])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0796412000A
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 06:16:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TTEIKit1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.14 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795760220;
	b=AqCfZTOC7v/mO1dFBQgCk67VZHXj447CQCJE7mag7Qo8fR4Oh4AI8Ns12P1BeTqKaD1QLy
	+c4JbgnUfUef2rpTZ4L2zU9yfAGRqwLxq0r1YeifGxLIax+xL8GnHTFR6BKUrmXGpo6vDh
	MHScIIXi856ED6uHy/uzLVRFfWxJ83k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795760220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sBt2TxsD2PmoSj7kx08nhr1+tAfyGURFrfNIng6d2YI=;
	b=EzrnrBSlTzxo3OWK17HaLMkGUc+QGJ9NFN5iZ6PfxJfnBLxa6UoSkpQ9zOEERV+0vRz6yB
	rhZ29Y2vx/gvp8An6ZjGZldquPqcAS+rbPzNkxnR24htpuPimBYG2wsOSCdgat8Plc9OH9
	ohATYtRpCe7fwjI+tKdWscuWv4+xwyI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TTEIKit1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.14 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PLsMK+jr/sszpjUmgwu6x/c+moD3UzMjMqJQgN+u3g4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795760218; v=1; x=1796365018;
 b=TTEIKit1L9WZldFxSVv/S1fG/jiuD+RKrJkooymG6brazyzPUdzt97nBrM7e4CmkJbzWALeU
 E+S3CFMNc53IZYfYwhUy4XI/VEM6M3oxgNgsaggseyzMAdseJYoP9Ysvzc9y8j8VAT0dLR3h1bk
 4th0wxbdiuONoj34Z3aG48JU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 4bd992dca8764b17;
	Fri, 27 Nov 2026 06:16:58 +0000
X-Mizu-Trace-ID: 4bd992dca8764b17
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	baohua@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	mhocko@suse.com,
	riel@surriel.com,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	hannes@cmpxchg.org,
	Baoquan He <hebaoquan@kylinos.cn>,
	Kairui Song <ryncsn@gmail.com>
Subject: [PATCH v6 3/4] mm/mglru: skip cold PUD subtrees during aging
Date: Fri, 27 Nov 2026 14:16:29 +0800
Message-ID: <20261127061630.11290-4-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261127061630.11290-1-baoquan.he@linux.dev>
References: <20261127061630.11290-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0796412000A
X-Stat-Signature: ekbymwot9k7jm9xyaubcm1ywsyszt3qd
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795760219-865781
X-HE-Meta: U2FsdGVkX19Ab4pFooPVdAd3XbWleOW+m0DTsVFEcIiXGLeX2K3d52r4hPXqg+W8GNT/cqwQLwNfnSXJB+niaY8d2rIXTakL/1ESmgWlV5W3/W5smUAXADNW7jkXXtHFQD+w614aOHnD+s5byru3Tf3UEhGDyHTIL3lXV892PRHknVSKw0dZQifAICYkWa2kC2PghM/RzTRs60fKCELRApq8hbLPYmZ3AQ5pNwHGKL9avKyp9ziXEeYFrbKZtGzdMKcUf0NWk1Q8eCYT19yDIFdKNrBHWaOV7jLZHQjdJfAvlIn1yLAG3dHMOvvmA0d38zjcVorJ9hqokP8TeYiR6oCvkENp7Do73NL8OR/uyKFxkepbNnXZs+5qliXVRptN3mfcuGLWKZa1r3hBOI/a9pzFoeIRdhpjMHG5wcV5EvNrcTJ2BY4zOeurl3txCuUTWZs9N2lXvSjX8RDFaB37jKIMkY9oM8fL2NFKhMomd1wvWFj307m7xYeQhxuN7Rwd0akckJvosKGF24YOE9etoc//kQTZWXQ9M50uW+YcdwG+wZRG9d4gCTDby/APy3HdorChmRo0QjFkABD7t1T0afpzx65RG0JHXZhhueG5yf+pmTBCD0FKGvcvg3zYKmbQFrZX+byIL3e7pWg9VDpx1gzuHYoELr1G2zOeOfhf18/7dRsyWVNVoCQEkODVugurovniXu8GtSzWuTF7ymo7V9PETiAnJ3L/Mx1/2zjNhB8LMhJqQd21qkUoi0awInL0f7kF/ArAny9LfMvw20vCh23W3RCz410tmGFoGUNKMvLxZWxhcUMATQc6Y6Wlj2mH/EFCfPhtBRbFW9POEzN+jNgoDrpDvNawW0VaV8kTuLtn4AZDIGqlMfyjUHHT00rL/3TA4hyvOUCLuCXAzJX48bgAR4OI/EJCRnw/VO7Ah8oNA3pk8xDVkNIw3Z+vEH0ATPPvYnRPl8FjA6E+TtI
 C3jdGcHi
 Wbo6dlOriEgQDaQ7dhKbB8e4S3thzlAxBOq4ish8Cx0ZKMhe8tKdz1Go9a8qOeTQhMy0my4D1GI8IoZnuZbVj3bQ6QhOuo3hVoTRRkFFGTDQGDoAdxAiEdUur9oP53v7bqMy8geCXiZZ3DAaz2G0TMsJMvwg80zy8MRMxs4JZcMO+6I2PGy0rHYgDWa1AWsaIWK/TpztB+AsOK3CHrRzf6tRh0EzBWdgdMS7Oxw7YRxpdmOqhItzi896l9clsSPW8vVqiTnRmS4EkNG18zF7s5TPkT+9UnkxKajw9A4DPaMnUu6uYYUn4cXbBXShxAJacchdqILMSFPnLxnLs6Yu3yDSkdXILATQ9t1PP1Bn4eo/XqZ29GGvj6XASW8SknCwclJC8cqd2gGD9WaG0dRqxOiA8V5fCYq4ui9+RJpJGF0VfRV+qBFdxouUA4gOG5K33lKeGTGzaotUOSVIGl4DnLK2DIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

The aging walks into every PUD and runs the PMD-level Bloom filter on each
PMD. Add a coarser PUD-level filter one level up:

 - walk_pmd_range() reports whether the subtree held anything young for
   this lruvec. That is the same condition which already carries a PMD
   over into the next generation: a young PMD entry, a huge page owned by
   this lruvec, or PTEs with enough young ones to pass suitable_to_scan().
 - walk_pud_range() records that in the PUD filter, and
 - on subsequent generations, skips the whole PUD subtree when the filter
   says it had nothing young last generation.

The filter key is (mm, PUD-aligned address): a stable identity for the
range that does not depend on the lifetime of a page table page, and that
the rmap path can compute without walking page tables.

The filter flips each generation and force_scan bypasses it, so a missed
re-mark costs at most one generation. To keep hot regions marked, the
rmap feedback path reports the covering PUD as well: lru_gen_look_around()
for PTE-mapped folios, folio_referenced_one() for PMD-mapped ones.
Without the second one a PUD that holds only transparent huge pages stays
skipped after one cold generation.

Suggested-by: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/mmzone.h |   6 +++
 mm/rmap.c              |   4 +-
 mm/vmscan.c            | 114 ++++++++++++++++++++++++++++++++++++-----
 3 files changed, 109 insertions(+), 15 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 98b60cd6b534..832809cbeeb0 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -731,6 +731,7 @@ struct lru_gen_memcg {
 void lru_gen_init_pgdat(struct pglist_data *pgdat);
 void lru_gen_init_lruvec(struct lruvec *lruvec);
 bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr);
+void lru_gen_mark_pud(struct mm_struct *mm, struct folio *folio, unsigned long addr);
 
 void lru_gen_init_memcg(struct mem_cgroup *memcg);
 void lru_gen_exit_memcg(struct mem_cgroup *memcg);
@@ -756,6 +757,11 @@ static inline bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw,
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
index fe354fa6cc43..6459aee862e2 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1005,8 +1005,10 @@ static bool folio_referenced_one(struct folio *folio,
 				referenced++;
 		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 			if (pmdp_clear_flush_young_notify(vma, address,
-						pvmw.pmd))
+						pvmw.pmd)) {
 				referenced++;
+				lru_gen_mark_pud(vma->vm_mm, folio, address);
+			}
 		} else {
 			/* unexpected pmd-mapped folio? */
 			WARN_ON_ONCE(1);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9861cc35062f..db89b5f5f0db 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3043,9 +3043,18 @@ static bool __maybe_unused seq_is_valid(struct lruvec *lruvec)
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
@@ -3359,8 +3368,10 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
 
 	spin_unlock(&mm_list->lock);
 
-	if (mm && first)
+	if (mm && first) {
 		reset_bloom_filter(mm_state, BLOOM_FILTER_PMD, walk->seq + 1);
+		reset_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq + 1);
+	}
 
 	if (*iter)
 		mmdrop(*iter);
@@ -3872,11 +3883,12 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
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
@@ -3890,13 +3902,13 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
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
@@ -3946,6 +3958,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 			dirty = true;
 
 		walk->mm_stats[MM_LEAF_YOUNG]++;
+		young = true;
 next:
 		i = i > MIN_LRU_BATCH ? 0 : find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
 	} while (i <= MIN_LRU_BATCH);
@@ -3956,12 +3969,15 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
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
@@ -3999,7 +4015,8 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			walk->mm_stats[MM_LEAF_TOTAL]++;
 
 			if (pfn != -1)
-				walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
+				young |= walk_pmd_range_locked(pud, addr, vma, args,
+							       bitmap, &first);
 			continue;
 		}
 
@@ -4008,7 +4025,13 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			if (!pmd_young(val))
 				continue;
 
-			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
+			/*
+			 * This call can flush the batched huge pages queued
+			 * by an earlier iteration, so keep its result: those
+			 * pages are young and must mark this PUD.
+			 */
+			young |= walk_pmd_range_locked(pud, addr, vma, args,
+						       bitmap, &first);
 		}
 
 		if (!walk->force_scan &&
@@ -4021,15 +4044,18 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
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
@@ -4040,6 +4066,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 	unsigned long addr;
 	unsigned long next;
 	struct lru_gen_mm_walk *walk = args->private;
+	struct lru_gen_mm_state *mm_state = get_mm_state(walk->lruvec);
 
 	VM_WARN_ON_ONCE(p4d_leaf(*p4d));
 
@@ -4047,13 +4074,29 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
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
@@ -4551,6 +4594,46 @@ static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
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
+ *
+ * The rmap path knows nothing about MGLRU, so the "is MGLRU in use" test
+ * lives here and the callers stay one plain call.
+ */
+void lru_gen_mark_pud(struct mm_struct *mm, struct folio *folio, unsigned long addr)
+{
+	struct mem_cgroup *memcg;
+
+	if (!lru_gen_enabled() || lru_gen_switching())
+		return;
+
+	memcg = get_mem_cgroup_from_folio(folio);
+	lru_gen_update_pud_filter(mem_cgroup_lruvec(memcg, folio_pgdat(folio)),
+				  mm, addr);
+	mem_cgroup_put(memcg);
+}
+
 bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 {
 	int i;
@@ -4652,9 +4735,12 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
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


