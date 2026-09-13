Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B7BBC88E40
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 10:00:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E65A06B0088; Sun, 13 Sep 2026 06:00:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E16BB6B008C; Sun, 13 Sep 2026 06:00:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2B416B0092; Sun, 13 Sep 2026 06:00:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AADF16B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 06:00:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 48BFEA5552
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 10:00:37 +0000 (UTC)
X-FDA: 85208294514.22.9A6DD75
Received: from mta0.migadu.com (out-142.mta0.migadu.com [91.218.175.142])
	by imf23.hostedemail.com (Postfix) with ESMTP id B0051140008
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 10:00:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JfyQkN+4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.142 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JfyQkN+4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.142 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789293635;
	b=qrXUYatiWbKnRCbdXMCMV59QgSPXA21zNSiwa5RG2KJAAVXWwLyX4UatPGCwcNT133XHAo
	LE3zX37hy15SKQOc/feC6ZTMJmoMCBK4GGCYEkxMGk4awisoqjp/rvPbKLJ3AvoUrQCOoj
	ktW3yqqX93Fi15KWapj1QHUbMCP1YPc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789293635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=41RzS1QznW+Ub7+jeaKRLzeNhoCNTbCMdQbIXDarwzE=;
	b=e8DhRl1tQSK3BJqIKWHZc/iUHYgJSuuIzoGccDrE13hRLdIgqtyfOX5dCdr4kUCepBomI4
	oLar5aDvxPoAP8WctSxD7jWbTsHe3K4cEzXaKl65lucEx8Lmy4Zc+SJPO0xYtzEpvowZ3a
	T+OKsNAljdQ7V5AfE2yypAEhgRCUXH8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=x4lEeuutQHw04q5eI2IDt5aS0x/LR+hbJclQ4L+Pbmw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789293630; v=1; x=1789898430;
 b=JfyQkN+4QySyq7Ez2HNeGJerzThkpfw6WZ2/FLdeZo9n0kVBgb71ujlE3M9ocE3Fu+qSBqeT
 Vc3eODKGZqWggFOPVAkW0SMN5qyuA5qg7OhF6nsUgCAC6mtrFzkwPeIqIL7K3dTaJTuLuoou2E0
 zl3XOZ+S/ynCrd6ebgUFYfwg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 84f15a5693f4a091;
	Sun, 13 Sep 2026 10:00:30 +0000
X-Mizu-Trace-ID: 84f15a5693f4a091
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)),
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v8] mm: vmscan: retry folios written back while isolated for traditional LRU
Date: Sun, 13 Sep 2026 18:00:13 +0800
Message-Id: <20260913100013.3603815-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B0051140008
X-Stat-Signature: 47w6tjgcsyompe5pu8crfy8xopbred1i
X-Rspamd-Server: rspam01
X-HE-Tag: 1789293633-25725
X-HE-Meta: U2FsdGVkX18bsqrgcZXRd817+pVtOjj9VbVq316R9/f+FaGmfCMJUcJAM2lgt3GdGexI1uAOdyCb/PKi0cJA46dRbLbpjVnoBIW9nlnjogUHoJg2rB2SkoIxb9kmn2Ocx4/V27vJjehZ/uEKxdXBt1orHn8PcM/IhNup5ZPMVp7oqX6OxOHQpaQmhPFFAj2PswrJqmIlZ3dDkmIxukWZghRqlSRRWu3zDEVXH2TTi8flKKSxqMbC8624/P/FbyRbxHC3Ggw26pgolfLJt91cuXLBiEYXOKaK13LK/TBqN41xFflBfTV818c5WrW1pV3uejqz8sX+rt++piDKPc8WJJ6v+Rqx7Vld4Jnj5irAj7/jir2oXdfx7q680lrUxjK6s6i8z/8DgZvdSAGdp+yzEphQgB9tgh09b0Q4H2ROVqaNkXqIKcS57tvCLgO3orH2UZSD1j2SCzdTU3GGFqpE3PMICJl9agsb61F9JeXpSEOJ/VguSd33v+sz5ZWO19SXuD+mfSdrP+Xq9vsmPu0rHwTxeKbiF9q5F2ZtbaRYFEhTP9OjJ8XZ6uZo9XLooqfSTyBsFAkiEK8ke8RHbBj8m60166age5/9ExvCmVzEaQLTIouNW81dExXO22Uz7sEkbOCuZKD5jMDYX0UJhUCZn2U7GC3q9HEB9AziBVV4XX2proSHTLBSW0qlaQfKVJ5q7RBGnyxq7X7+rXqfRzEYuJzySfa6Ub1rmvSAtOcU+AWbO/ZlfFh8za/zZfhmgwZXw+eBmg16lPRe3QKbZr+ks3OZfsmGL8+IwHXtHYDobAnCx+mXsHDsxp+m1x7ibEiF6usGqun8D+//0aoR0sEdjSSc+Umw0m28aZQK6b1Dde8aKTaQgOzJTwoHwaN1uDz14YX+zCPwL+4bKPfpyDW/+MTf8w9XAUiaWSvKBffEjDBldrz/DQGXtQXJmf4Iv4zYiuiuuA12iZ4Txf8svkZ
 YZAMEKQa
 oxDpy0DXxZZrUcmp8c+2NHWEknF8YWOs5IsdYeF6aXr9EOZ8alcPTseNY7iS1dtGid+Yic7h7oUjGTtk2Clx0WH9e4bnaZbbgE5Ls0jFIHv0wmV2HXFbVmohPVEqs1uKYCRKIcAFWOGY4dIG4dAI30uE8Kl1BSRRvJQIpFdevBBNaoViiSMNkWNw49VlsPDQt3KT5TenfpM62suZ4qr0bflbZX3WP1HHwfAJkBPAdoJ3Vudo0Ovu07VHHerv0gAMFYOhEVUYsaZ3/7jI20dBEQA/DlNLcN8WvO0kfCFfVPmcaqJwSi4/igM6OZV9dGitage7k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

As commit 359a5e1416ca ("mm: multi-gen LRU: retry folios written back
while isolated") mentioned:

  The page reclaim isolates a batch of folios from the tail of one of the
  LRU lists and works on those folios one by one.  For a suitable
  swap-backed folio, if the swap device is async, it queues that folio for
  writeback.  After the page reclaim finishes an entire batch, it puts back
  the folios it queued for writeback to the head of the original LRU list.

  In the meantime, the page writeback flushes the queued folios also by
  batches.  Its batching logic is independent from that of the page
  reclaim. For each of the folios it writes back, the page writeback calls
  folio_rotate_reclaimable() which tries to rotate a folio to the tail.

  folio_rotate_reclaimable() only works for a folio after the page reclaim
  has put it back.  If an async swap device is fast enough, the page
  writeback can finish with that folio while the page reclaim is still
  working on the rest of the batch containing it.  In this case, that folio
  will remain at the head and the page reclaim will not retry it before
  reaching there".

The commit 359a5e1416ca ("mm: multi-gen LRU: retry folios written back
while isolated") only fixed the issue for mglru. However, this issue
also exists in the traditional active/inactive LRU and was found at [1].

It can be reproduced with below steps:

1. Compile with CONFIG_TRANSPARENT_HUGEPAGE=y
2. Mount memcg v1, and create memcg named test_memcg and set
   limit_in_bytes=1G, memsw.limit_in_bytes=2G.
3. Create a 1G swap file, and allocate 1.35G anon memory in test_memcg.

It was found that:

  cat memory.usage_in_bytes
  1073700864
  cat memory.memsw.usage_in_bytes
  1413124096

  free -h
                total        used        free
  Mem:           1.6Gi       1.2Gi       299Mi
  Swap:          1.0Gi       678Mi       346Mi

As shown above, the test_memcg charged about 324M swap (memsw.usage minus
usage), but almost 678M swap memory was used, which means that 350M+ may
be wasted because other memcgs can not use these swap memory.

This issue should be fixed in the same way as mglru. Therefore, the common
logic was extracted to the 'find_folios_written_back' function firstly,
which is then reused in the 'shrink_inactive_list' function. Finally,
retry reclaiming those folios that may have missed the rotation for
traditional LRU.

After change, the same test case only wasted about 2M swap. The swap
device usage matches what the memcg actually charged.

  cat memory.usage_in_bytes
  1070301184
  cat memory.memsw.usage_in_bytes
  1412448256

  free -h
                total        used        free
  Mem:           1.6Gi       1.2Gi       299Mi
  Swap:          1.0Gi       327Mi       696Mi

[1] https://lore.kernel.org/linux-kernel/20241010081802.290893-1-chenridong@huaweicloud.com/
[2] https://lore.kernel.org/linux-kernel/CAGsJ_4zqL8ZHNRZ44o_CC69kE7DBVXvbZfvmQxMGiFqRxqHQdA@mail.gmail.com/
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
v8: Rebase to the -next tree, adapt to the current reclaim API, and retest.

[v7]: https://lore.kernel.org/linux-mm/20250111091504.1363075-1-chenridong@huaweicloud.com/

 mm/vmscan.c | 104 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 73 insertions(+), 31 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d1495a7d469d..6e13e570aab8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -181,6 +181,10 @@ struct scan_control {
 	struct reclaim_state reclaim_state;
 };
 
+static void find_folios_written_back(struct list_head *list,
+				     struct list_head *clean, struct lruvec *lruvec,
+				     int type, bool skip_retry);
+
 #ifdef ARCH_HAS_PREFETCHW
 static inline void prefetchw_prev_lru_folio(struct folio *folio,
 		struct list_head *base)
@@ -2013,14 +2017,16 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 		enum lru_list lru)
 {
 	LIST_HEAD(folio_list);
+	LIST_HEAD(clean_list);
 	unsigned long nr_scanned;
-	unsigned int nr_reclaimed = 0;
-	unsigned long nr_taken;
+	unsigned int nr_reclaimed, total_reclaimed = 0;
+	unsigned long nr_taken, isolated;
 	struct reclaim_stat stat;
 	bool file = is_file_lru(lru);
 	enum node_stat_item item;
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	bool stalled = false;
+	bool skip_retry = false;
 
 	while (unlikely(too_many_isolated(pgdat, file, sc))) {
 		if (stalled)
@@ -2052,25 +2058,42 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	if (nr_taken == 0)
 		return 0;
 
+	isolated = nr_taken;
+retry:
 	nr_reclaimed = shrink_folio_list(&folio_list, pgdat, sc, &stat, false,
 					 lruvec_memcg(lruvec));
+	total_reclaimed += nr_reclaimed;
+
+	/* Retry pass is only meant for clean folios without new isolation */
+	if (isolated)
+		handle_reclaim_writeback(isolated, pgdat, sc, &stat);
+	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
+			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
+
+	find_folios_written_back(&folio_list, &clean_list, lruvec, file, skip_retry);
 
 	move_folios_to_lru(&folio_list);
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
 					stat.nr_demoted);
-	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
 	mod_lruvec_state(lruvec, item, nr_reclaimed);
 	mod_lruvec_state(lruvec, PGSTEAL_ANON + file, nr_reclaimed);
-	if (nr_scanned > nr_reclaimed)
+
+	if (!list_empty(&clean_list)) {
+		list_splice_init(&clean_list, &folio_list);
+		skip_retry = true;
+		/* Retry folios were already isolated and accounted above */
+		isolated = 0;
+		goto retry;
+	}
+
+	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
+	if (nr_scanned > total_reclaimed)
 		mod_lruvec_state(lruvec, PGROTATE_ANON + file,
-				 nr_scanned - nr_reclaimed);
+				 nr_scanned - total_reclaimed);
 
-	handle_reclaim_writeback(nr_taken, pgdat, sc, &stat);
-	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
-			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
-	return nr_reclaimed;
+	return total_reclaimed;
 }
 
 /*
@@ -5006,8 +5029,6 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 {
 	LIST_HEAD(list);
 	LIST_HEAD(clean);
-	struct folio *folio;
-	struct folio *next;
 	enum node_stat_item item;
 	struct reclaim_stat stat;
 	struct lru_gen_mm_walk *walk;
@@ -5046,26 +5067,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			type_scanned, reclaimed, &stat, sc->priority,
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
-	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
-		DEFINE_MIN_SEQ(lruvec);
-
-		/* move_folios_to_lru() culls unevictable folios via folio_putback_lru() */
-		if (!folio_evictable(folio))
-			continue;
-
-		/* retry folios that may have missed folio_rotate_reclaimable() */
-		if (!skip_retry && !folio_test_active(folio) && !folio_mapped(folio) &&
-		    !folio_test_dirty(folio) && !folio_test_writeback(folio)) {
-			list_move(&folio->lru, &clean);
-			continue;
-		}
-
-		/* don't add rejected folios to the oldest generation */
-		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type]) {
-			folio_set_lru_refs(folio, 0);
-			folio_set_active(folio);
-		}
-	}
+	find_folios_written_back(&list, &clean, lruvec, type, skip_retry);
 
 	move_folios_to_lru(&list);
 
@@ -6108,6 +6110,46 @@ static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *
 
 #endif /* CONFIG_LRU_GEN */
 
+/**
+ * find_folios_written_back - Find and move the written back folios to a new list.
+ * @list: folios list
+ * @clean: the written back folios list
+ * @lruvec: the lruvec
+ * @type: LRU type (only used for CONFIG_LRU_GEN)
+ * @skip_retry: whether skip retry.
+ */
+static void find_folios_written_back(struct list_head *list,
+				     struct list_head *clean, struct lruvec *lruvec,
+				     int type, bool skip_retry)
+{
+	struct folio *folio;
+	struct folio *next;
+
+	list_for_each_entry_safe_reverse(folio, next, list, lru) {
+#ifdef CONFIG_LRU_GEN
+		DEFINE_MIN_SEQ(lruvec);
+#endif
+		/* move_folios_to_lru() culls unevictable folios via folio_putback_lru() */
+		if (!folio_evictable(folio))
+			continue;
+
+		/* retry folios that may have missed folio_rotate_reclaimable() */
+		if (!skip_retry && !folio_test_active(folio) && !folio_mapped(folio) &&
+		    !folio_test_dirty(folio) && !folio_test_writeback(folio)) {
+			list_move(&folio->lru, clean);
+			continue;
+		}
+#ifdef CONFIG_LRU_GEN
+		/* don't add rejected folios to the oldest generation */
+		if (lruvec->lrugen.enabled &&
+		    lru_gen_folio_seq(lruvec, folio, false) == min_seq[type]) {
+			folio_set_lru_refs(folio, 0);
+			folio_set_active(folio);
+		}
+#endif
+	}
+}
+
 static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
 	unsigned long nr[NR_LRU_LISTS];
-- 
2.34.1


