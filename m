Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6493CC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 06:38:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CE4D6B00A6; Tue,  1 Sep 2026 02:38:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A5216B00A9; Tue,  1 Sep 2026 02:38:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BAC36B00AB; Tue,  1 Sep 2026 02:38:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 461896B00A6
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:38:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3976280170
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:38:26 +0000 (UTC)
X-FDA: 85164239412.20.CB6CBB1
Received: from mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
	by imf21.hostedemail.com (Postfix) with ESMTP id 50F5E1C0002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:38:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.18 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788244704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WwDtKvU41t5ZXaJj2WqS+8LWLekMTRsNNrVLKl6r4tk=;
	b=l1OTAwkNoIkd+/zbACxCmmLePHZvv+tMx9Unht+VdKTtHwC4U42XunMqIAjCkIKc3Rno4F
	l7LCHevNGgMGoYO6oPE/jZlGLybJEpXlBx+A4+12SE3RKTt+6dDcl4QX21DAt5fe2j087p
	hll7JErPtmkV+8mjcl6TJv9Y8fk2+pk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.18 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788244704;
	b=Ewc+/jYPevidComh3CYhBlvGZ5jer4DOUAmFmyYjvp0OqbWG0xV0aq+YknpP63sjZrW7A1
	HQVgRKitSrYlDurnfQ9Q3+5A7yiLaQeLsN1GlltUHvSLKQFf/lWWf5TOg4Y5q60zer9DGH
	vAL0gDsRo3PMovObihTyzZvGKvf+ED0=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 1b1e07543815f6ef;
	Tue, 01 Sep 2026 06:38:22 +0000
X-Mizu-Trace-ID: 1b1e07543815f6ef
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	kasong@tencent.com,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	hannes@cmpxchg.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v2 3/4] mm/mglru: skip cold PUD subtrees during aging
Date: Tue,  1 Sep 2026 14:37:54 +0800
Message-ID: <20260901063755.1519710-4-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260901063755.1519710-1-hebaoquan@kylinos.cn>
References: <20260901063755.1519710-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i5ngpr5b1bepoh8e7qsm7iihtn313wgt
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 50F5E1C0002
X-Rspam-User: 
X-HE-Tag: 1788244704-7522
X-HE-Meta: U2FsdGVkX1+6f+7w05XCByjaXKG/cfl1NV+CDEdmypiFhbTrA38PaTi+a2Z6u5dlqdkL5W8EArKs1cGBl8Ztvu2oK4OZy36zs7vYLQEvsNVoQl55rGm/rJ/Kz9DX9a0v79a5NPNchq4taO8XyUEXmtOJP8EGW5MgW7AS0biWkTaSVL9RiC2+D4WdQvJjJttcCvEcFV+zNXRgR6eP9XWmc6mCyC7+jbckjxKxSpJGHuYh7Ht8o1W6+fWIjwm8T5tl/c3f2WniMIWTV3y3/jz2zlCt9tBZYAq5koTdRbLqskIzKMPDbKh0ktbd4kLK4nxftWgMfVJ9MlSNasExZjnc6qtz/JQr6KEvAJmg68FLFUPdBcTRaVufiZjaKmNIUAZWTnUFsnKPa6fw5L+ff4rzctAPXLR91a+2s2x4zPc4QoRe9RxqIwsKsDnzaXQoK7mKrx3SxJQ0Nu3tjiMpTn9C0XxPa/o5sy7SjB5G8pluSHewZULJhOpBsBNCfYmjyhTjIFLW8KlotzFdr9Mdx68zCP7m1jd/0PtbBpEbT4d6CXfJBmizFNBEESs7VOf8McFkDJfFuf4U4BfBZKOwt/hXNhir2I6wme8PtYxg5sF9b73UPKwzgfNOPEjFIyBoHaK+FsWF/dDZBhscWlQu47pktoj/wfhnE9hMZ/OZS86s9KDbAgQM8udgekYkpD8S+tXDD49Q0E6SrDeklaKcKemaBXEdA7WALL1pN/+MwrYPDfh44gmUqQUhcyIHMSGMeYocpbYmMlGl5OsbX0Aw30L41nnLfslJ9fh/OcBRJGyAf63tdRYXXPy8FhcVb2f5YHIbZqxucnQpSN3t3T1IBCLmoZGsBOwkBMUn+FpQsZVos0RojMBfyAfvZwSo1lXgw9Qm81juxmLbfbD6DJ++ZnCGUuGeC8bTC2bpOPJZ4TMrFv2o+h/JeH2GvfUBKPlNDSjMs10gMD1dCPNWolZtd4u
 TJslvKMo
 A99tQRQRpMVB6LA92WeHA1vEsVi2R2z2LN2wlsngBAaNsWdGmfz4lmb5KTaGTiuFaCLRUTIZHqwGLL2gZuo4Nn0JeBlYj0TKZIoD8Pd+pBSjO+ZNJGwFTfuvIAcyCCRhOV9aufImVs7p7WGPxKuWSwAQxZhSGbwk9eek+Qlghn2fh2aRcC6xiXK2bgwr4amwZuZRL39FhJbb/1j62/qXyrvj5FEShZnCj7Own
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The aging walks into every PUD and runs the PMD-level Bloom filter
on each PMD. Add a coarser PUD-level filter (pud_filters) one level
up:
 - walk_pmd_range() now reports whether it found any young leaf entries,
 - walk_pud_range() records that in the PUD filter, and
 - on subsequent generations, skips the whole 1GB subtree when the filter
   says it had none last generation.

The double-buffered filter flips with each new iteration, so newly hot or
migrated-in pages are re-checked promptly rather than suppressed
indefinitely. force_scan walks bypass the PUD test, so manual aging and
newly added mm's always rescan and re-populate the filter.

To keep hot regions marked, also report the covering PUD from the rmap
feedback path (lru_gen_look_around()), so regions whose hotness is only
observed by eviction will be re-scanned.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/vmscan.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 47 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index cd09c5b8af8c..955585626387 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2817,6 +2817,8 @@ static bool __maybe_unused seq_is_valid(struct lruvec *lruvec)
  * walk_pmd_range(); the eviction also report them when walking the rmap
  * in lru_gen_look_around().
  *
+ * A second, coarser pair of filters (pud_filters) sits one level up.
+ *
  * For future optimizations:
  * 1. It's not necessary to keep both filters all the time. The spare one can be
  *    freed after the RCU grace period and reallocated if needed again.
@@ -2908,6 +2910,23 @@ static void reset_pmd_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned l
 	__reset_bloom_filter(mm_state->pmd_filters, seq);
 }
 
+static bool test_pud_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq,
+				  void *item)
+{
+	return __test_bloom_filter(mm_state->pud_filters, seq, item);
+}
+
+static void update_pud_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq,
+				    void *item)
+{
+	__update_bloom_filter(mm_state->pud_filters, seq, item);
+}
+
+static void reset_pud_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq)
+{
+	__reset_bloom_filter(mm_state->pud_filters, seq);
+}
+
 /******************************************************************************
  *                          mm_struct list
  ******************************************************************************/
@@ -3147,8 +3166,10 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
 
 	spin_unlock(&mm_list->lock);
 
-	if (mm && first)
+	if (mm && first) {
 		reset_pmd_bloom_filter(mm_state, walk->seq + 1);
+		reset_pud_bloom_filter(mm_state, walk->seq + 1);
+	}
 
 	if (*iter)
 		mmdrop(*iter);
@@ -3733,10 +3754,11 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	*first = -1;
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
@@ -3773,8 +3795,10 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 
 			walk->mm_stats[MM_LEAF_TOTAL]++;
 
-			if (pfn != -1)
+			if (pfn != -1) {
 				walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
+				young = true;
+			}
 			continue;
 		}
 
@@ -3784,6 +3808,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 				continue;
 
 			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
+			young = true;
 		}
 
 		if (!walk->force_scan && !test_pmd_bloom_filter(mm_state, walk->seq, pmd + i))
@@ -3795,6 +3820,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			continue;
 
 		walk->mm_stats[MM_NONLEAF_ADDED]++;
+		young = true;
 
 		/* carry over to the next generation */
 		update_pmd_bloom_filter(mm_state, walk->seq + 1, pmd + i);
@@ -3804,6 +3830,8 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 
 	if (i < PTRS_PER_PMD && get_next_vma(PUD_MASK, PMD_SIZE, args, &start, &end))
 		goto restart;
+
+	return young;
 }
 
 static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
@@ -3814,6 +3842,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 	unsigned long addr;
 	unsigned long next;
 	struct lru_gen_mm_walk *walk = args->private;
+	struct lru_gen_mm_state *mm_state = get_mm_state(walk->lruvec);
 
 	VM_WARN_ON_ONCE(p4d_leaf(*p4d));
 
@@ -3827,7 +3856,12 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 		if (!pud_present(val) || WARN_ON_ONCE(pud_leaf(val)))
 			continue;
 
-		walk_pmd_range(&val, addr, next, args);
+		/* Skip a subtree whose 512 PMDs all failed the PMD-level filter last gen */
+		if (!walk->force_scan && !test_pud_bloom_filter(mm_state, walk->seq, pud + i))
+			continue;
+
+		if (walk_pmd_range(&val, addr, next, args))
+			update_pud_bloom_filter(mm_state, walk->seq + 1, pud + i);
 
 		if (need_resched() || walk->batched >= MAX_LRU_BATCH) {
 			end = (addr | ~PUD_MASK) + 1;
@@ -4397,8 +4431,14 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 	lazy_mmu_mode_disable();
 
 	/* feedback from rmap walkers to page table walkers */
-	if (mm_state && suitable_to_scan(i, young))
+	if (mm_state && suitable_to_scan(i, young)) {
+		/* the PUD entry covering the young PTEs scanned above */
+		pud_t *pud_p = pud_offset(p4d_offset(pgd_offset(vma->vm_mm, pvmw->address),
+						     pvmw->address), pvmw->address);
+
 		update_pmd_bloom_filter(mm_state, max_seq, pvmw->pmd);
+		update_pud_bloom_filter(mm_state, max_seq, pud_p);
+	}
 
 	mem_cgroup_put(memcg);
 
@@ -5963,6 +6003,8 @@ void lru_gen_exit_memcg(struct mem_cgroup *memcg)
 		for (i = 0; i < NR_BLOOM_FILTERS; i++) {
 			bitmap_free(mm_state->pmd_filters[i]);
 			mm_state->pmd_filters[i] = NULL;
+			bitmap_free(mm_state->pud_filters[i]);
+			mm_state->pud_filters[i] = NULL;
 		}
 	}
 }
-- 
2.54.0


