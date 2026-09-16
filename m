Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FD5BC88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:39:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5016F6B0092; Wed, 16 Sep 2026 08:39:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B2B86B0093; Wed, 16 Sep 2026 08:39:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CA546B0095; Wed, 16 Sep 2026 08:39:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F7A06B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:39:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 94AA3A5E36
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:39:14 +0000 (UTC)
X-FDA: 85219580628.03.8C4DCEC
Received: from mta0.migadu.com (out-39.mta0.migadu.com [91.218.175.39])
	by imf21.hostedemail.com (Postfix) with ESMTP id 65BC81C0007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:39:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JZbgaphh;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.39 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789562352;
	b=2dEGpXrt82D0QjeN5FwhUzIyjUdXUCzSPUG4UxcQBgTeA9pZHWG3Jc19HclJmuQ4Zi/Fxt
	hxiwJR7ga3uMQA4CBOX46tj/c3XczVoHdx/dH8hf5LdcpWeHUhFqagxsg+0M1DpSaXGh8a
	Vnn8wVj5+Q6HtXZ38eLLI48vLPH6luA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JZbgaphh;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.39 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789562352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PpZw5HADRSaj+CrE97o9OfySznHUMDE6Vv2u0bIYHrw=;
	b=cX54sJn6M6KzPz7uUdGBiDfKshjX2gvzaoUpW0kQ+rL6pRxs3CMbZ1SWlz9lctHeTaujX2
	eQ+O8uo9PIinyVxZrr+VrPhaQJ3Ui0Ze37reiEl2OPcvG7SKEPDSr8oxVnwho9sDQfX06P
	7PZQ2h396tjIB2SzpPdWtlUCwcpcMAc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=V7MTHUNYw5VRPpGnIueys+1dfCpY67B2KrLC8eDcjo8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789562351; v=1; x=1790167151;
 b=JZbgaphh5KGPG4I65WjEwx0EPyDH5buOXjudRjYZcGeb3rukKXrDWKQRQXOSmdeKk4vzomt9
 masBQ3soYuwBptVzAAGL3NGp8hMsk65yk5C8Eqt/XjmVUOvWT2c9XAbA+Z204a2dM6k7ugELLvC
 +q+5a9qUTIxPzQLTYxV74Geg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 23ac15b2afe3404d;
	Wed, 16 Sep 2026 12:39:00 +0000
X-Mizu-Trace-ID: 23ac15b2afe3404d
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
Subject: [PATCH mm-new v9] mm: vmscan: retry folios written back while isolated for traditional LRU
Date: Wed, 16 Sep 2026 20:38:46 +0800
Message-Id: <20260916123846.1242548-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 65BC81C0007
X-Stat-Signature: 3nab3afpk6phyii84p59o1k8e7d47tto
X-Rspam-User: 
X-HE-Tag: 1789562352-593942
X-HE-Meta: U2FsdGVkX18ooqviUU05MFgfvRsX7Zu2zb+RkJs+rq61zgmWthhgUBYd06JISq5F2hEffoVe7puXPl9eRk2OPoDSk3jC2nQSNxP+48LsNqyEgQfwpNeofG1+gmGW+o0OS5i+ktUiUWfYCaXaEG3RjxWYr9EZTEmQDeFVH1I+IBuTe/KoRZ3prZhZDWVc2AcoAlzDhjb03/HHjTFKRLIOKwkj0a6AC9JsVj4Tir76WUrpaDzlKsnkmjxNdO7uPbRJjplv7/IiadwkL3ImPaADSggucssvSDQv066jdIo5mqc1Htgv83YRRIV6SZWbt40r1tK1W78+0l3C/Djt9NSDm5Egvf0JSoHkcPYSxd2wCax8A0w/L6U+0fVCKnFNsYGM+KjjTakq5Y4WRJEYo6YQZYD8JreLsqKhS1qPhUja1BFzLKp0OUeHm77yvi075knktYELy/7Rsk10qCwTpE11ChFRxcq5AfXlQy59hX91PN9WZAkoPbojCYQuT1Yhf8BFDM8KSv824sa2Bk0S22iyhLaT+o/S6CTRTCaya2C2GeIzsKAdH9dFQ13Kk5Lvku7f+XHkowD0RZa6yEuMs1D3YjQjghq00yAD8qf1R28caOSjKpWv1iv5gUNgISxXhpblNM+1+VzdFbK+Rm8V6kRs51Z/UZNgk4qwY92lKIgv3wfljPjh0/aP4+XpWaoTJlZuaL+hnMHlLP4UFOjIFLDeSEsOVON5MJ+6162QbZOCEskpfLXZ+CvctXbJm3+QtRslY0mNsW3U8ZxgMRjCcP5SMEPyoZvDDuOHOQJKMc98fbeJszfp32krD2IJ41X6NPX5dy2K2rXnPXd7AJX7LfpYDLlIF+3L3m6DccEzBSQWvYY73LWclk1g687GqN1it2voxcjdsuqcmDCyDJIbh3/INAr9u/BDPhiNoGj72gzNpnN8JT+DVx1k/Ds+iKFxhQkZzCeKrjqbZ3dDUOz4yob
 R6+XOQl1
 iqjmeVFyPPMLueTFuUVNTIdClCMrf9LgWNkWEJXCoiYIpG+EINjv+50R2l2qqwOKJYd31H3pBTDyE65I4jxS/Flutk7NbhfxBg48jhcxEiAqXasmnquZ8RYui7XaZGibd0Ymj86nKtgq4sekJIPK4FsZGXchaM8O61BvP6HCVZVq6f8nVZYBVaqBYla5ajw3JvniDWYeNcJ6y3xVw1jX/5oY99HjkC7SZBOMOFED+RWzz8jz0pZegAi4dI7BiPyVyOjlJA73W4YKJuTCRm8+vAiSLyQXH1XcP5xBNT8ngAc1lN/F7XrHSAsST++z7UrRhSti3
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

It can be reproduced with below steps [3]:

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
[3] https://lore.kernel.org/lkml/46037a37-4cf6-448e-a94b-30a4d16e8814@linux.dev/
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 v9: rebase on mm-new branch.
 v8: https://lore.kernel.org/lkml/20260913100013.3603815-1-ridong.chen@linux.dev/

 mm/vmscan.c | 114 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 79 insertions(+), 35 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index fde28d0a647d..d9191fc240fd 100644
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
@@ -2064,14 +2068,16 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
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
@@ -2103,25 +2109,42 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
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
@@ -5018,8 +5041,6 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 {
 	LIST_HEAD(list);
 	LIST_HEAD(clean);
-	struct folio *folio;
-	struct folio *next;
 	enum node_stat_item item;
 	struct reclaim_stat stat;
 	struct lru_gen_mm_walk *walk;
@@ -5058,30 +5079,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
-		/*
-		 * See the comments on LRU_REFS_FLAGS.
-		 *
-		 * The rejected folios are never added to the oldest generation,
-		 * so this effectively promotes them by at least one generation.
-		 */
-		folio_set_lru_refs(folio, 0);
-		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
-			folio_set_active(folio);
-	}
+	find_folios_written_back(&list, &clean, lruvec, type, skip_retry);
 
 	move_folios_to_lru(&list);
 
@@ -6136,6 +6134,52 @@ static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *
 
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
+		if (lruvec->lrugen.enabled) {
+			/*
+			 * See the comments on LRU_REFS_FLAGS.
+			 *
+			 * The rejected folios are never added to the oldest
+			 * generation, so this effectively promotes them by at
+			 * least one generation.
+			 */
+			folio_set_lru_refs(folio, 0);
+			if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
+				folio_set_active(folio);
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


