Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D02B3606B35D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 08:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AEWtbHxN
Received: by kanga.kvack.org (Postfix)
	id CAACF6B060E; Fri, 13 Nov 2026 03:50:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C82A46B0612; Fri, 13 Nov 2026 03:50:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B97D06B0613; Fri, 13 Nov 2026 03:50:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D3306B060E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:50:16 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1EF881A03A6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:50:16 +0000 (UTC)
X-FDA: 85429474032.07.567040F
Received: from mta0.migadu.com (out-32.mta0.migadu.com [91.218.175.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1F8A3C0006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:50:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AEWtbHxN;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.32 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794559814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aed1HwrsGX4SXOgJfurikQOdPksv21rcL2mhR6jMcnw=;
	b=RLyFPA6i7mYkbLK47Oo9+ADJywTbYn8tcuIjTFhFD+E1ppat9w4fRgMTpEp9vR+cINQ1DB
	ZSjE9BDVVB43+u0lerVnWkwIM2viekAb41EMGvuIBNsgfdzsW5CNYmFGjbl05Z/480m1P2
	OYhjFTkk2bieeNR5tGabDNoeWdjlpeE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794559814;
	b=jce79LOpgxDjd+PVZU2Sj5Bd55xmNdcykq81YoA3Y80i+VRfjfm4SFxizm9kq7g+1gtEca
	zwJnaRoxiZ/KXUO1GQUesFJs5zUA0vsdJubvRE7YB2WjRyAxiHLF5qUQd+f05hbmqsur2j
	/sinTPViGtcqpcUspvY0VvBg50rgo5E=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AEWtbHxN;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.32 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3EuaOZZWbRqw7udhTgU/svcnwCv7/IHaoLa5hxix7Ck=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794559811; v=1; x=1795164611;
 b=AEWtbHxNPbchav7qJem1rM3rzJKKXx4ZbsKoxdDpq2TAZnxe0VWXrnPDQVHY0Z6dec/yDIvX
 vEMfzJJy/rJnqAu59r6z2E83yAruYt19nppn4CHhZvLyuRuXYAkaUU60D2TYFAkvBlhnSaI+Zyp
 kjK7q7Q/vX7D6u14ktI/6/0k=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id ef292256cc6ec20e;
	Fri, 13 Nov 2026 08:50:11 +0000
X-Mizu-Trace-ID: ef292256cc6ec20e
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	Baoquan He <hebaoquan@kylinos.cn>,
	Baoquan He <baoquan.he@linux.dev>
Subject: [PATCH v3 1/4] mm/mglru: add MM_WALK_EMPTY stats and tracepoint
Date: Fri, 13 Nov 2026 16:49:50 +0800
Message-ID: <20261113084953.412919-2-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261113084953.412919-1-baoquan.he@linux.dev>
References: <20261113084953.412919-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o71s5gpzhk5fh3xsd6s9qo8efy9niqw5
X-Rspamd-Queue-Id: 1F8A3C0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794559813-16809
X-HE-Meta: U2FsdGVkX1/MG7BfW7W+oll9ToAKeXrqdVu2HQ52zJ8MY3/JsMPdj9a8ftTrq3m5blVh/vnEGrwyuBO+vDsmZU8O69rioqi+sfUaAJbAztxL+y6UOllScKNLExUXya4YejkKXlo3QyUeDn1VMKElutjw5QQ1CZcDih1ec0mvfXOi9sRnHTaUOEwEgb5f36gA529it2blI3qJwS3eX+O1hK6rxh1OCmyu01bmhaaYqVTumj3UcO7BTkFxyshFbd5/YC6DAUjJDLc244xusN7wI5GvTqG1H03hxj5ZzP44hELnUrI3pD5uKNaPuoVen+/UUVwsi3S+rg7M7Uq+PDG3ZjqXAtc9x6FmjohkEOColtI9pexayHrHLmPXTE47+TtJFSlCV3mvqo2jmOpspJiR5+4wnR/MQj4d/zPvlHzAPOJS1woIueklZZTsnQQsyPgJjVEJ0MCp1zNXE6qJhzrCyXG1T2RagWLCVwoe/ytFmkY20/ncJiwDySBBKTwhj856lVVgbR+g8o3f5QFOUsRqIhZvFEwvdIDyFnRyyg2UNBORT+bLqwcpF/EGDoCklRfSoq95d2+krzOdAWpz/EndAgPXoGNBfHqafISU8NKLe29P7uLmRXrO2VPCXeUizVMvcssYftBy8wTFMFYDVIjeA+B4gR8smNp9aEZ4jMZXo4RbkBh0s8uJuXkc+a9ra/MDbZweYlDvp95QJYP8HThcHxHxgC2Qu2Q43mWkaGUznnABVs5eetsBwET3VJOWc7JXfhjjlkIVVXDVWuOLdUJeLmTyWtAwkBdPyrGXdnE2bPsnuY/yZoMnwEurpB+pZtKjTOwMF0iPlxXUKBqY2FlZur8dGIAIfC9LbwAnGoG2XsQIHZWZpA36+bcwHqt/4wGOoeUTpxvTzQuW5J0uIl8U8OdUB0krwig7p9PcmhLXI4rmtIHsPK2ZhPmcwYfDuplXyGpirmw76R/3yVv0rhw
 fVrtFBId
 5cAHQ7oY/qMQzQNwXmApkOKypy5j7g1ydrR9Jq+Wm7Co09BHWsk8lp1+E09ATK1D/mwA6Fj0UaTlenwv8ESL7CMwaxlinTjyojRJYhAlqwTjIadiXRqVdEadx1itcPwtm3zkZVesZInOICmXafJnWuAHP6ICkOsP59DhNk6XAaUV7V5VIskxMDggbPlPIt9gCmCZ14xBDF5qKkBbH47p5U19Yl3hIi27i/F5YjowQr2GShUbpWfv5UINwjbvJdjxa0clhYkfRJB/cTHWUKZNCrKreAhBuX09kt5jKbgWYfQ224oU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

Add per-walk counters to measure empty aging walks which traverse
an mm's page tables but find no folio for the current lruvec (node+memcg).
These are common on multi-NUMA node systems because lru_gen_use_mm() marks
an mm for all nodes at every context switch.

New counters (accumulated in mm_state->stats[]):

  MM_LEAF_ASSOCIATED   - leaf entries whose folio is in this lruvec
  MM_WALK_TOTAL        - page-table walks completed
  MM_WALK_EMPTY        - walks that found no folio in this lruvec
  MM_LEAF_EMPTY_WALKS  - leaf entries scanned during empty walks

A new tracepoint, mm_vmscan_lru_gen_walk(), fires after each walk, and the
debugfs lru_gen output ("TYFALWEE") exposes the new counters.

Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 include/linux/mmzone.h |  4 ++++
 mm/trace_vmscan.h      | 28 ++++++++++++++++++++++++++++
 mm/vmscan.c            | 32 ++++++++++++++++++++++++++++----
 3 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index c161d563ce8f..a49efd9b74ed 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -579,6 +579,10 @@ enum {
 	MM_LEAF_YOUNG,		/* young leaf entries */
 	MM_NONLEAF_FOUND,	/* non-leaf entries found in Bloom filters */
 	MM_NONLEAF_ADDED,	/* non-leaf entries added to Bloom filters */
+	MM_LEAF_ASSOCIATED,	/* leaf entries whose folio is in this lruvec (node+memcg) */
+	MM_WALK_TOTAL,		/* page-table walks completed */
+	MM_WALK_EMPTY,		/* walks that found no folio in this lruvec */
+	MM_LEAF_EMPTY_WALKS,	/* leaf entries scanned during empty walks */
 	NR_MM_STATS
 };
 
diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index 565c56428364..4884fc7a35b9 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -763,6 +763,34 @@ TRACE_EVENT(mm_vmscan_kswapd_clear_hopeless,
 		__entry->nid,
 		__print_symbolic(__entry->reason, kswapd_clear_hopeless_reason_ops))
 );
+TRACE_EVENT(mm_vmscan_lru_gen_walk,
+
+	TP_PROTO(int nid, unsigned long seq, int leaf_total,
+		 int leaf_associated, bool empty),
+
+	TP_ARGS(nid, seq, leaf_total, leaf_associated, empty),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+		__field(unsigned long, seq)
+		__field(int, leaf_total)
+		__field(int, leaf_associated)
+		__field(bool, empty)
+	),
+
+	TP_fast_assign(
+		__entry->nid = nid;
+		__entry->seq = seq;
+		__entry->leaf_total = leaf_total;
+		__entry->leaf_associated = leaf_associated;
+		__entry->empty = empty;
+	),
+
+	TP_printk("nid=%d seq=%lu leaf_total=%d leaf_associated=%d empty=%d",
+		__entry->nid, __entry->seq, __entry->leaf_total,
+		__entry->leaf_associated, __entry->empty)
+);
+
 #endif /* _TRACE_VMSCAN_H */
 
 /* This part must be outside protection */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 96201eae0ceb..98037a562ab6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3590,6 +3590,8 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		if (!folio)
 			continue;
 
+		walk->mm_stats[MM_LEAF_ASSOCIATED]++;
+
 		if (folio_test_large(folio)) {
 			const unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
 
@@ -3688,6 +3690,8 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 		if (!folio)
 			goto next;
 
+		walk->mm_stats[MM_LEAF_ASSOCIATED]++;
+
 		if (!pmdp_test_and_clear_young_notify(vma, addr, pmd + i))
 			goto next;
 
@@ -4151,8 +4155,28 @@ static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
 
 	do {
 		success = iterate_mm_list(walk, &mm);
-		if (mm)
+		if (mm) {
+			bool empty = false;
+
 			walk_mm(mm, walk);
+			/*
+			 * A walk that traversed page tables but found no folio
+			 * belonging to this lruvec (node+memcg) is pure waste.
+			 */
+			if (walk->mm_stats[MM_LEAF_TOTAL]) {
+				walk->mm_stats[MM_WALK_TOTAL]++;
+				if (walk->mm_stats[MM_LEAF_ASSOCIATED] == 0) {
+					walk->mm_stats[MM_WALK_EMPTY]++;
+					walk->mm_stats[MM_LEAF_EMPTY_WALKS] +=
+						walk->mm_stats[MM_LEAF_TOTAL];
+					empty = true;
+				}
+			}
+			trace_mm_vmscan_lru_gen_walk(
+					lruvec_pgdat(lruvec)->node_id, walk->seq,
+					walk->mm_stats[MM_LEAF_TOTAL],
+					walk->mm_stats[MM_LEAF_ASSOCIATED], empty);
+		}
 	} while (mm);
 done:
 	if (success) {
@@ -5638,14 +5662,14 @@ static void lru_gen_seq_show_full(struct seq_file *m, struct lruvec *lruvec,
 
 	seq_puts(m, "                      ");
 	for (i = 0; i < NR_MM_STATS; i++) {
-		const char *s = "xxxx";
+		const char *s = "xxxxxxxx";
 		unsigned long n = 0;
 
 		if (seq == max_seq && NR_HIST_GENS == 1) {
-			s = "TYFA";
+			s = "TYFALWEE";
 			n = READ_ONCE(mm_state->stats[hist][i]);
 		} else if (seq != max_seq && NR_HIST_GENS > 1) {
-			s = "tyfa";
+			s = "tyfalwee";
 			n = READ_ONCE(mm_state->stats[hist][i]);
 		}
 
-- 
2.52.0


