Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA7A2606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 08:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=c/0qsJGs
Received: by kanga.kvack.org (Postfix)
	id C1BC36B05BB; Mon, 23 Nov 2026 03:58:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCC446B05BC; Mon, 23 Nov 2026 03:58:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE26D6B05BD; Mon, 23 Nov 2026 03:58:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 823376B05BB
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:58:44 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0A4EC160802
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:58:44 +0000 (UTC)
X-FDA: 85465783368.14.F90910E
Received: from mta0.migadu.com (out-206.mta0.migadu.com [91.218.175.206])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0AB51A0004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:58:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="c/0qsJGs";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.206 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795424322;
	b=Tyi9Junpe/0xMr1pQaoQ52MzEkWPcD6AeNX4Z61OHfWnJWieWrb1zKT7qnFw1ftTdiXglE
	TPvepJ4Q/7ctJuIMk0+xH2AzWOHolxcZBR4DLqLBUI3nWGE6nnudczEmu+c8eYgx/hEn9f
	GkjNjValKbPRDhCWSbAP7U7DjLj+39Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795424322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RXKNXPtz5O0aVWR3tL9vhs8d4AxxDQDK0IlHeroj4NE=;
	b=Pa952i3lkBKdgzHUc7qldWt5jDdcClirsfgPSA3GRKa66YRgW4CteQC+078bef+U085LAF
	2NaRq0fT+EHETmP3uA9/SjyA9ByWzvSM/7tSCS67OJfVvjERFRFpDF2v7au8eAW0ZtynYJ
	E2I4r380clgM6sT6G8rCA2ctrzZUvC4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="c/0qsJGs";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.206 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gi+XBvOxvs7hGu8yQdg9cucQH8UCPwCDMNBrGua15wI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795424320; v=1; x=1796029120;
 b=c/0qsJGsolmniKwRJF7WewGt3WAMgaltk2dle9JFMxKDzoN8pL8UdWSI6B9zKF/ugHKCsMyV
 gCLVqWwT1+ho09xcRftnOWeIZmiQvwLzol55hPom/ok/sjG12mznnCp6OmoEOF9S/HeMd3E8uSU
 iz4ucotiA0wajYslW9OdGdPk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id f2e4efc47e082763;
	Mon, 23 Nov 2026 08:58:40 +0000
X-Mizu-Trace-ID: f2e4efc47e082763
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: david@kernel.org,
	akpm@linux-foundation.org,
	kasong@tencent.com,
	baohua@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>,
	Kairui Song <ryncsn@gmail.com>
Subject: [PATCH v5 3/4] mm/mglru: skip cold PUD subtrees during aging
Date: Mon, 23 Nov 2026 16:57:59 +0800
Message-ID: <20261123085800.981256-4-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261123085800.981256-1-baoquan.he@linux.dev>
References: <20261123085800.981256-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0AB51A0004
X-Rspam-User:
X-Stat-Signature: 3mggaog1eoezi6qkh73cdxdbk5aepuyd
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795424321-367002
X-HE-Meta: U2FsdGVkX1+t4dNJ+TqD/ukdTPXiN5/DTSRBNQzS6gdoQUYW/NTJzUNyap14hfJMKB3a9xcjilEM9cp9hFAg0AIygEG5bwOry8Oa9kfV9BYxGWOKkap5N2BQizPXFoaq0oSBB78HDFb20R9tqlYuKJOKiY/85E2IxAOg88Cq0ntObXP8/6Ns1MhQuntCsk2cvfSkQGKhPOs8T7hp1MBGkF2b2pYl/R8hEKq0u2+Tj1BMi4GV0zQ5MQz3y1JnpEngdKI+dCyQRWi3D3XZVkHrzxIpNPjV0FfM2242HBLi91d95ctF7IOMh59hDPhlPfyU3ZHVyL3JflCrpGVLiWuwZgYst4zYQByBD6QJrAxpk/frSHe/VDjoGmgOkqs96r5D8hf5T2iSRbXA5FrK+kAmD3J1G2r5Bm7bfSISb+2uytsq+38/aYwfsCaaOA9WbSpynDy/M9s+VXJXZbkK+qHYt5590vtMSQc9F1WL/j7uYB7XJKSHf6OzTDngR2RdKgEta+so+xhETRooAHOl7xIyjuIoZJFZhacm3545PDQ4gpAlRYhIuOVgsGmP3r4J8k7f21QHiYQ6aGc6jRoIZ6UsoU1Fd5j2IQ4qVPWQ7exdFvYNZIMPKOXvmjbEXS67VusULEVh/SujPH3cOwVli62nfJifwjoPDmhJr6yCXgUDcwO95IWHqUie78s3bUHp6SAZDRbucXmROlz36fizUH1lB34koX8AgB6DOg0KMGleWL2rA3RlYh1Si6vuvhe244sFRo/QVf/vGSLRUN/ttdAUziVonZuNGejmtuiqDyDdJAwavGEGMXLb2X3i9pvkjSwefENdmWzix4b5S6aQjt78/LVGzgxaH0IbFBZc/9T5vhpGOD0Ofr7T2LmW6Z/wSDHaP0nK95NU7rGCP674TI9yx7Vc91oTFFpdFa+RGxRuCo8TSYFfLiGetJ7+BUckb9QgfNYWtpCy/siplPwOVSQ
 sAxEP6HJ
 C7GFpC2MbyJHch1NKWSmSya3oLaXXZo/FPzfyjhRBnkE4Guy9h1ZxZ5c5rPhgazKAaqHH1GdIKQVEPt4fTowfbokqXWzVO8nQUHY0rqpzCI6GFNgt9JTNCyHe+YAP9Jtckw4mWKG61VN8bgWadAJaYEFBuLBwedt/Hf+D758eNITsBJrHT+5hehtOWrgn736QnVx/ZHfgvdO+7wm+TNDlQUp2SmxNn8G0xKnIw5EQosRaN7Ded+kqlaZ0LG62XR1obJPNAMt2tQi0xdYlC836DNAFOlp9AGrnWjBcf131whFCxpwxSrV2ou5Htg42YAhA/pCMoLVj1seF+qtggpaTYj8BCy+pHJgBsXw7EhZf/oxiLHDEHsqWqAhLHeBt+pdrbd7mi+6x7l5BmkpC5tbjGJLUemOMptYy8V/IrCFPw8eKZf7hj27jtEJfe4Q5fiAOyUsGjZfl9R8KVc92uBKErqcEzA==
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
 include/linux/mmzone.h |  6 +++
 mm/rmap.c              |  5 ++-
 mm/vmscan.c            | 99 ++++++++++++++++++++++++++++++++++++------
 3 files changed, 96 insertions(+), 14 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index f057c98d1f97..07e6c887e21a 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -677,6 +677,7 @@ struct lru_gen_memcg {
 void lru_gen_init_pgdat(struct pglist_data *pgdat);
 void lru_gen_init_lruvec(struct lruvec *lruvec);
 bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr);
+void lru_gen_mark_pud(struct mm_struct *mm, struct folio *folio, unsigned long addr);
 
 void lru_gen_init_memcg(struct mem_cgroup *memcg);
 void lru_gen_exit_memcg(struct mem_cgroup *memcg);
@@ -702,6 +703,11 @@ static inline bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw,
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
index 7d20ee1b6c10..517f5fbecdbf 100644
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
@@ -3623,11 +3634,12 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
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
@@ -3641,13 +3653,13 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
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
@@ -3697,6 +3709,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 			dirty = true;
 
 		walk->mm_stats[MM_LEAF_YOUNG]++;
+		young = true;
 next:
 		i = i > MIN_LRU_BATCH ? 0 : find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
 	} while (i <= MIN_LRU_BATCH);
@@ -3707,12 +3720,15 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
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
@@ -3750,7 +3766,8 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			walk->mm_stats[MM_LEAF_TOTAL]++;
 
 			if (pfn != -1)
-				walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
+				young |= walk_pmd_range_locked(pud, addr, vma, args,
+							       bitmap, &first);
 			continue;
 		}
 
@@ -3772,15 +3789,18 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
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
@@ -3791,6 +3811,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 	unsigned long addr;
 	unsigned long next;
 	struct lru_gen_mm_walk *walk = args->private;
+	struct lru_gen_mm_state *mm_state = get_mm_state(walk->lruvec);
 
 	VM_WARN_ON_ONCE(p4d_leaf(*p4d));
 
@@ -3798,13 +3819,29 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
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
@@ -4334,6 +4371,39 @@ static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
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
@@ -4435,9 +4505,12 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
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


