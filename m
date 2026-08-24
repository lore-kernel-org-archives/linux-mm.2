Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E8BEC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 07:38:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E5886B0095; Mon, 24 Aug 2026 03:38:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2963E6B0096; Mon, 24 Aug 2026 03:38:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AC2A6B0099; Mon, 24 Aug 2026 03:38:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECE006B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:38:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9006716047A
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:38:36 +0000 (UTC)
X-FDA: 85135360632.27.7C551D5
Received: from mta0.migadu.com (out-82.mta0.migadu.com [91.218.175.82])
	by imf10.hostedemail.com (Postfix) with ESMTP id BF104C0004
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:38:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.82 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787557114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kdgLuo0ICy5rzcZ6s6b2Y+zcnMs4fr9NiSj4VCIzrbs=;
	b=fmiU4I/rCp4z5FRSShEw3VmgSdGzlcGxtyetUH7ihBlO+tvbV6U5DaJIIXJ0LZQZqM4QlD
	b5QqrCVm+/4xPRhXqBVgODEUp8dq45fTwT/bVeXW/qKey50BeMPQgi65JF20IbKIbij0zm
	9Osnp2KDFgBuJPdszDIAI+xi4TYKJ+s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787557114;
	b=BoAwNjQwXBTYQr1IGJE5WAAB7TpJnphtijqSG8rEIHC99mJlXcMIV7cxj6KX51QsQ8g4ml
	ZUPw44IpkjgEbKKiwNWFjp3U5w6I8SJpdEpifxgpMpPe632K/+XoUu+ucfiyO33Ll8ZHx3
	m4xt8QzqNlY0lPfC+iPI4fN+OFEnYVs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.82 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta11.migadu.com with ESMTPS id d61735cbc13f785a;
	Mon, 24 Aug 2026 07:38:32 +0000
X-Mizu-Trace-ID: d61735cbc13f785a
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	hannes@cmpxchg.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 2/9] mm/mglru: suppress cross-node empty page table walks
Date: Mon, 24 Aug 2026 15:37:59 +0800
Message-ID: <20260824073806.629593-3-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260824073806.629593-1-hebaoquan@kylinos.cn>
References: <20260824073806.629593-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 5rkxe3md45n6ya7648661u3hs948xq1a
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BF104C0004
X-HE-Tag: 1787557113-642739
X-HE-Meta: U2FsdGVkX1+9H5q8Cv4lAbcEEswuE+D09XDSN4LP15N77f6irH6+hdPYZys9aPL3RHBIPAQsjANQlQbdArDIQbxXMtaTCv8uFO9A5uLgyFIeb+qMNXgHIlueUh3Q9fL+c8A0gbmnrW2dCainmT5euTzDU8fLTqSora/3DRfk/7IO3Bq1yFSAxNFwY9qqV7fwCmmkcBLpS4d6txH87TJshnVKUTsFUNMPa7Crx99lMu0L7UgtPOjpxQ4Ie/iJoXk0ZtSobgOA+/Mv64OYC1a4g9esJO1bpb0hMGTtZ2bQsncXEaO7v84rxGH1tx6UyQKenMcXbyVYOFNO0+FKpoo9TonpjT/9F3O2MtUNx/hlWo0SVszOuCDiOjv6I2CUaLpE4NylHp9nvm42VbUILc7hczWtSYD4NAFYlyruvPn/35rtq8ZT7/XW5xI8g+qqE7chZ7XomToVvoA9YprYEf/4XeUzlRYOB8zCbyUjY7ra2NznuuJx2XU0r1YFBDsiWkDDrgewp5sAYh/wuySDdDYOLyx1GoMPhp/mlwS75LA7Ges2qwnlzRZxwEokKY/O2vgffM4mlhpaQ4ig0f2hnPwaKqZMU0NYw446loY5R3nnHAT0A4oe2LQu5GsxvnlRZxn6RZNemCny3X5VFSKrZjjoi3+M9+MNtWwW0vsWo5MSkzCTBMw+SPOiiCuvITF6Ic7Xd0g4mBG713E1Jlm2hE9NDB8I/RvS3aKqb2PUP/P7pj54cYGGvqCSVuEyXhsLm8poECMAXGWEV/c1SUQzfcY7/L3VkvzzyVCLXEWI1pS41eYRnlXaihZJTuSo0iU4SFpVOVPuzWh0OJuWMGsPfwqqd+BZoTJpExEiZfW/DyIJcAdK+bgwtR5e8ln1GskQjlL+qYZ83Soi3ya5fTTrgiWgw/nZWHIa7VaQlm1S967Zvb6U4ddLKi2qsR8LwiMz6tjzUztJ0UGtaSXBqZ70p3t
 qAbewhGd
 UCYD+uCoFoDqZHv8ZcXCCk+1z+oGhtMhncC4vCEyeVTJmtO0PAjr/WDXyVjWfebrmUZZbIA/BLJRSd9UMVTLc+YoBEItI1NQAQArBCEf4JxFPnP3q8P/eBVL8jp3L/M0vU1yRVk6nIkDi4oXS28fjCI8Zv8A7WHuU0VeETiYSLGHg06DZlSkMLgY4Wc5Y3QKWzkvutqKRgbpCVFu3FvDnX7jFCwiGIaZKLAkwtPvGl8Pn9IjvYZqxoY7vSyVpSbmqerOe3gLXYrj9nS8UKiXIx1s1wTAIIQYZP5Cx6dNJKHy+6mUzGtxoumH2uNY/7iA6gESRm0YUtAZ3jv5qHFr5+nEKrrIGShhFARSjozBH43ktOK0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the current MGLRU, lru_gen_use_mm() will mark one process's mm used
on all nodes at each context switch. So each nodes's aging walks into
each mm's page tables. For an mm with memory on one or only a subset of
nodes, the other nodes' walks find no pages for one lruvec. While these
empty walks are pure waste.

Track per-mm, per-node empty-walk marks: bit N on mm->lru_gen.empty_map is
set when node N's walk of the mm found no page for this lruvec, and
get_next_mm() will skip the mm on node N between re-scan passes. The re-scan
is driven by each node's own pass count (mm_state->seq), so every
mglru_empty_skip_gens-th (default 4) pass re-walks all empty-marked mms to
close migration/NUMA-balancing windows; keeping it on the node's own clock
avoids a shared "oldest marking" sequence latching at the slowest node.

A walk is "empty" when it traversed the page tables and found no folio for
this lruvec.

A page that appears on the node during the skip (fault or migration) is not
aged until the re-scan; a later patch invalidates the skip on those
paths. mm_struct grows by 8 bytes per process.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/mm_types.h |  3 +++
 include/linux/mmzone.h   |  2 ++
 mm/vmscan.c              | 52 ++++++++++++++++++++++++++++++++++------
 3 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 6d815f6440c9..3738e8877b73 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1410,6 +1410,8 @@ struct mm_struct {
 			 * page table walkers cleared the corresponding bits.
 			 */
 			unsigned long bitmap;
+			/* bit N: node N's last walk found no folio; skip until re-scan */
+			unsigned long empty_map;
 #ifdef CONFIG_MEMCG
 			/* points to the memcg of "owner" above */
 			struct mem_cgroup *memcg;
@@ -1503,6 +1505,7 @@ static inline void lru_gen_init_mm(struct mm_struct *mm)
 {
 	INIT_LIST_HEAD(&mm->lru_gen.list);
 	mm->lru_gen.bitmap = 0;
+	mm->lru_gen.empty_map = 0;
 #ifdef CONFIG_MEMCG
 	mm->lru_gen.memcg = NULL;
 #endif
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 229d27fbfb54..30213a880db0 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -633,6 +633,8 @@ struct lru_gen_mm_walk {
 	int batched;
 	int swappiness;
 	bool force_scan;
+	/* this aging pass is an empty-walk re-scan pass (every K-th) */
+	bool rescan_pass;
 };
 
 /*
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 92cb83a78971..e8ba49683b28 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2710,6 +2710,14 @@ static bool should_clear_pmd_young(void)
 	return arch_has_hw_nonleaf_pmd_young() && get_cap(LRU_GEN_NONLEAF_YOUNG);
 }
 
+/*
+ * Cross-node empty walk suppression. lru_gen_use_mm() marks an mm used on all
+ * nodes, so aging on a node where the mm has no memory wastes a full page table
+ * walk. Skip such an mm for up to MGLRU_EMPTY_SKIP_GENS generations after an
+ * empty walk, then force-rescan to close migration/mlock/NUMA-balancing windows.
+ */
+#define MGLRU_EMPTY_SKIP_GENS 4
+
 /******************************************************************************
  *                          shorthand helpers
  ******************************************************************************/
@@ -2930,9 +2938,17 @@ static struct mm_struct *get_next_mm(struct lru_gen_mm_walk *walk)
 	mm = list_entry(mm_state->head, struct mm_struct, lru_gen.list);
 	key = pgdat->node_id % BITS_PER_TYPE(mm->lru_gen.bitmap);
 
+	/* skip if not used on this node since the last walk */
 	if (!walk->force_scan && !test_bit(key, &mm->lru_gen.bitmap))
 		return NULL;
 
+	/* Skip empty-marked mms except on a re-scan pass; off on node-id alias */
+	if (!walk->force_scan &&
+	    nr_node_ids <= BITS_PER_TYPE(mm->lru_gen.bitmap) &&
+	    !walk->rescan_pass &&
+	    test_bit(key, &mm->lru_gen.empty_map))
+		return NULL;
+
 	clear_bit(key, &mm->lru_gen.bitmap);
 	mmgrab(mm);
 
@@ -3833,7 +3849,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 	return -EAGAIN;
 }
 
-static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
+static bool walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
 {
 	static const struct mm_walk_ops mm_walk_ops = {
 		.test_walk = should_skip_vma,
@@ -3841,6 +3857,7 @@ static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
 		.walk_lock = PGWALK_RDLOCK,
 	};
 	int err;
+	bool walked = false;
 	struct lruvec *lruvec = walk->lruvec;
 
 	walk->next_addr = FIRST_USER_ADDRESS;
@@ -3859,6 +3876,7 @@ static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
 			err = walk_page_range(mm, walk->next_addr, ULONG_MAX, &mm_walk_ops, walk);
 
 			mmap_read_unlock(mm);
+			walked = true;
 		}
 
 		if (walk->batched)
@@ -3866,6 +3884,9 @@ static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
 
 		cond_resched();
 	} while (err == -EAGAIN);
+
+	/* true only if the page tables were traversed - a failed trylock/stale seq is not */
+	return walked;
 }
 
 static struct lru_gen_mm_walk *set_mm_walk(struct pglist_data *pgdat, bool force_alloc)
@@ -4110,22 +4131,39 @@ static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
 	walk->seq = seq;
 	walk->swappiness = swappiness;
 	walk->force_scan = force_scan;
+	/* every skip_gens-th pass re-scans empty-marked mms; 0 disables */
+	walk->rescan_pass = mglru_empty_skip_gens == 0 ||
+			    mm_state->seq % READ_ONCE(mglru_empty_skip_gens) == 0;
 
 	do {
 		success = iterate_mm_list(walk, &mm);
 		if (mm) {
+			int nid = lruvec_pgdat(lruvec)->node_id;
+			int key = nid % BITS_PER_TYPE(mm->lru_gen.bitmap);
+			bool walked;
 			bool empty = false;
 
-			walk_mm(mm, walk);
-			/* A walk that traversed page tables but found no folio
-			 * belonging to this lruvec (node+memcg) is pure waste. */
-			if (walk->mm_stats[MM_LEAF_TOTAL]) {
+			walked = walk_mm(mm, walk);
+
+			/* Empty = walked, no eligible folio; failed trylock/stale seq is not */
+			empty = walked && walk->mm_stats[MM_LEAF_ELIGIBLE] == 0;
+			/* skip_gens == 0: stop maintaining marks */
+			if (mglru_empty_skip_gens &&
+			    nr_node_ids <= BITS_PER_TYPE(mm->lru_gen.bitmap)) {
+				if (empty)
+					set_bit(key, &mm->lru_gen.empty_map);
+				else
+					/* found eligible folios: clear the marking */
+					clear_bit(key, &mm->lru_gen.empty_map);
+			}
+
+			/* Count completed walks with the same "empty" definition */
+			if (walked) {
 				walk->mm_stats[MM_WALK_TOTAL]++;
-				if (walk->mm_stats[MM_LEAF_ELIGIBLE] == 0) {
+				if (empty) {
 					walk->mm_stats[MM_WALK_EMPTY]++;
 					walk->mm_stats[MM_LEAF_TOTAL_EMPTY] +=
 						walk->mm_stats[MM_LEAF_TOTAL];
-					empty = true;
 				}
 			}
 			trace_mm_vmscan_lru_gen_walk(
-- 
2.54.0


