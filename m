Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBC74C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 09:24:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D1C36B0093; Fri,  7 Aug 2026 05:24:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 082F46B0095; Fri,  7 Aug 2026 05:24:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8BED6B0096; Fri,  7 Aug 2026 05:24:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B5E876B0093
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 05:24:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A309F1202C7
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:24:40 +0000 (UTC)
X-FDA: 85073938320.14.4E5E8EB
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf09.hostedemail.com (Postfix) with ESMTP id D462F140007
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:24:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w+KtYi72;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786094679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g9ZH0Zn2dkGbUHq+jtix592h5DQByOyStq+Ycs/E/Bs=;
	b=4d2PxCRvhuH4V8xYPk6mD8wtaNP9sBE4airENWBpw5tesC7WkZLMw0z9GQWRfF6AZ0zK6c
	NizeTdoQF1bBw+DCtTUMrfztBGCHbRmLPrGBxsCscGMy4xrewqSrvqufjLpRtCVvV/Evs+
	AMYzU8jdfbfevdqeCrSiqTsBc7462Yc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w+KtYi72;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786094679;
	b=S8+YaSvWSFblv4iPgTwv6ciNoIQ7px9k81ccpqrcMLNcP1TB61IGTnumhes7/aZdTxd9qh
	gTvlQcn6w5WjnaYXbjI/Ual2FYPcpJBNG+dsZBKVugPBjzYQX1Pkpa9DJ71QKZKOHiZ45N
	NBpdbpcv4CEDcpD4ZidbWWm4C/4Dwpc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786094675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g9ZH0Zn2dkGbUHq+jtix592h5DQByOyStq+Ycs/E/Bs=;
	b=w+KtYi72j+z0n74MlYlxLc0pMaKph2xz8PqL8n+uqFD1eJf2W/eMFopllJaXBQCVUO668r
	K0n+IhmWTtUXnVBGgb4zx1OkxxE6gGn7WLxuzV4UY0aq18rj442kIPTzXiLnCMFdNWneCn
	Fa+G7qVQxLyQ6D2IVp5Gfft5y8zGoLQ=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	kasong@tencent.com,
	baohua@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	Baoquan He <baoquan.he@linux.dev>
Subject: [PATCH 2/4] mm/mglru: suppress cross-node empty page table walks
Date: Fri,  7 Aug 2026 17:23:39 +0800
Message-ID: <20260807092343.4123734-2-baoquan.he@linux.dev>
In-Reply-To: <20260807092343.4123734-1-baoquan.he@linux.dev>
References: <anRqew3VikVzxJJb@MiWiFi-R3L-srv>
 <20260807092343.4123734-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D462F140007
X-Stat-Signature: 4xtdqn9nc6atyj6naydqudm1wpqcyund
X-HE-Tag: 1786094678-955787
X-HE-Meta: U2FsdGVkX19vgqdzmRxIrV6SotrEag9ha9MY1tIVo/U4CwmXOkcaW6T/FsTZN46G6TpW3u2aXSTXl7AAi+4GbAD87NOBRqrzrQuTppV1lTifhvPI9bTx+ECaSWh/Hl/H9auVZti0Kp5wSVhITiRSaawJR6gEzXO8fqsquizI9hTbqruqMg7/RfIDkRTnd/C4FlTSijbMlBAOGivmlBXnpZ1s0ckkUWqZgigRcO28VXJMJtV5L7TJSLhvUPZa6MpO5uASZlb/SHycZjq6gmyYaluXLRF5B8u8bfVO21LO698O5pv7GMMDPAnzPYC591FumH+y8yw0NlU53w4QChdfSsyweS8W0k7V6r1VUlmAEp8096VCR2797li2letWoIKPxd1zhiCBfccrSxTnNR1PBxVzpQ2lpAYL+MgEuQiHf3onN2sZLA3JrP8EUXqoGDjlL08bkTYStGmv0E+5D8Yn6xnLyoawvyj0ukrBbNQMJmx8oJBFf2jZgHFlAxhJ3Y3S18OEvi+xPjGvUkHhds6t21YhTsGzxujwS5AVWga2VpO3ZbEHa9pFIWyDoNQKBVhhyYPBnjADC9VRUSCTqMEDmcVUfaLZAARaiAJ7Ngn8LgTiatVvUXRt8td1An8HGqVBj8QAyKKgnenij9oFmRB5nNfOkK+SzqAEgzok644CYyLXSKR7ve7j58wPeiqqyXNb2B0t3aM8t/HzzYEHP6lC82bzDksA3FraC6Yj/ugKy164w9RLsBvIvS0gMUyEyv0gdj8VbQn5hIMp2JX8ffHJZfwKkQnnqBK7+v5p3VDDO/DzbTj7l68kQstlN2zKtB5sraGvad7du/5lMBCmhJDfzzMaf1DlWTA4Lx0R5KSwfo3SaU7DhTD3JCYC0dFJPT3+lLjwSzD5BUuiVUz0uupC+I6loQfgVFKZnhpxdpoVXca2/zEnwNg0nIR/SGOhUoskpmsVytPqwFA3uq82J+8
 v3td0/NL
 RJwtwtm1tO9Sqm2CWKMOhpIuW5cqGKNR0UBAhdw3xCm842T0bR0G4osfteSPEdYEyGepy7DUchqg5/KFDVjiqMciWlK19kTNOb8QizL8VHo0X1T9QvtBhzKLmjxzR9NNwol3yc1/hMvwMPRaa9qpCgeKeDIUeuyopX3XofDPeTSk8zBDYKD56d7rXrSp6EjhuPGMmr3hX/taXVbXFkegrxsQgvhj79ueR8VZM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

lru_gen_use_mm() marks an mm used on all nodes at every context switch,
so each node's aging walker independently walks every mm's page tables.
For an mm with memory on only a subset of nodes, the other nodes' walks
find no folio belonging to that lruvec (node+memcg) - pure waste (~80%
of walks on multi-socket systems).

Add per-mm, per-node empty-walk tracking so get_next_mm() skips an mm on
a node for K generations (K=MGLRU_EMPTY_SKIP_GENS=4) after an empty walk,
then force a rescan. empty_map records the node, empty_map_seq the oldest
max_seq among the set bits (via min(), so the rescan never fires late).

A walk is "empty" when it finds no folio for this lruvec, regardless of
MM_LEAF_TOTAL - the PMD-level Bloom filter often keeps leaf_total at 0
for a foreign mm, so gating on it would mean the skip never engages.

The periodic rescan bounds the blind window to K generations, but a page
that appears on a node during the skip (e.g. migration) is not aged until
the rescan. A follow-up patch in this series invalidates the skip on page
fault and migration. mm_struct grows by 16 bytes per process.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 include/linux/mm_types.h | 13 ++++++++++
 mm/vmscan.c              | 54 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 63 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index b5d4cd3b067b..68ec8bb2ab71 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1410,6 +1410,17 @@ struct mm_struct {
 			 * page table walkers cleared the corresponding bits.
 			 */
 			unsigned long bitmap;
+			/*
+			 * Cross-node empty-walk suppression: bit N set means
+			 * node N's last aging walk of this mm found no folio
+			 * for this lruvec (pure waste). Skip the mm on node N
+			 * for up to K generations, then force a rescan.
+			 * empty_map_seq is the oldest max_seq among the set
+			 * bits (min(), conservative), so a bit is cleared when
+			 * max_seq >= empty_map_seq + K.
+			 */
+			unsigned long empty_map;
+			unsigned long empty_map_seq;
 #ifdef CONFIG_MEMCG
 			/* points to the memcg of "owner" above */
 			struct mem_cgroup *memcg;
@@ -1503,6 +1514,8 @@ static inline void lru_gen_init_mm(struct mm_struct *mm)
 {
 	INIT_LIST_HEAD(&mm->lru_gen.list);
 	mm->lru_gen.bitmap = 0;
+	mm->lru_gen.empty_map = 0;
+	mm->lru_gen.empty_map_seq = ~0UL;
 #ifdef CONFIG_MEMCG
 	mm->lru_gen.memcg = NULL;
 #endif
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 83de2b147919..c39b392d7b7e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2709,6 +2709,14 @@ static bool should_clear_pmd_young(void)
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
@@ -2929,9 +2937,27 @@ static struct mm_struct *get_next_mm(struct lru_gen_mm_walk *walk)
 	mm = list_entry(mm_state->head, struct mm_struct, lru_gen.list);
 	key = pgdat->node_id % BITS_PER_TYPE(mm->lru_gen.bitmap);
 
+	/* skip if this mm hasn't been used on this node since the last walk */
 	if (!walk->force_scan && !test_bit(key, &mm->lru_gen.bitmap))
 		return NULL;
 
+	/*
+	 * Skip if this node's last walk of this mm was empty and fewer than K
+	 * generations have passed; after K, clear the bit to force a rescan.
+	 * empty_map_seq tracks the oldest marking via min(), so the rescan
+	 * never fires later than K generations on any node.
+	 */
+	if (!walk->force_scan && test_bit(key, &mm->lru_gen.empty_map)) {
+		DEFINE_MAX_SEQ(walk->lruvec);
+		unsigned long empty_seq = READ_ONCE(mm->lru_gen.empty_map_seq);
+
+		if (max_seq < empty_seq + MGLRU_EMPTY_SKIP_GENS)
+			return NULL;		/* skip: < K gens since empty */
+
+		/* K generations passed → force rescan */
+		clear_bit(key, &mm->lru_gen.empty_map);
+	}
+
 	clear_bit(key, &mm->lru_gen.bitmap);
 	mmgrab(mm);
 
@@ -4113,18 +4139,38 @@ static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
 	do {
 		success = iterate_mm_list(walk, &mm);
 		if (mm) {
+			int nid = lruvec_pgdat(lruvec)->node_id;
+			int key = nid % BITS_PER_TYPE(mm->lru_gen.bitmap);
 			bool empty = false;
 
 			walk_mm(mm, walk);
-			/* A walk that traversed page tables but found no folio
-			 * belonging to this lruvec (node+memcg) is pure waste. */
+
+			/*
+			 * Any walk that found no folio for this lruvec is empty -
+			 * even if the PMD-level Bloom filter kept MM_LEAF_TOTAL at 0
+			 * (the common case for a foreign mm). Mark it so get_next_mm()
+			 * skips it next time; otherwise the empty-walk skip never
+			 * engages for the walks that matter most.
+			 */
+			if (walk->mm_stats[MM_LEAF_ELIGIBLE] == 0) {
+				set_bit(key, &mm->lru_gen.empty_map);
+				/* track the oldest marking (conservative) */
+				WRITE_ONCE(mm->lru_gen.empty_map_seq,
+					min(READ_ONCE(mm->lru_gen.empty_map_seq),
+					    walk->seq));
+				empty = true;
+			} else {
+				/* found eligible folios: clear the marking */
+				clear_bit(key, &mm->lru_gen.empty_map);
+			}
+
+			/* measurement stats keep the leaf_total gate */
 			if (walk->mm_stats[MM_LEAF_TOTAL]) {
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


