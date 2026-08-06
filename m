Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3000BC56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 10:31:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EEEF6B00A7; Thu,  6 Aug 2026 06:31:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39F1D6B00AA; Thu,  6 Aug 2026 06:31:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DCD96B00AB; Thu,  6 Aug 2026 06:31:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 10AB36B00A7
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 06:31:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ABFC71206AF
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:31:03 +0000 (UTC)
X-FDA: 85070476806.04.D75BB18
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf31.hostedemail.com (Postfix) with ESMTP id F249B20008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:31:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jUQNwREQ;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786012262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3huU6e694bIFlA70vMxTN0EgWh1w1sy7DMZVgqBOLg4=;
	b=xGEYdTVUU25dkBLIEc1x/Si091TxLIGk1n2qwgxCtV96f783KnXEeRiWqWFXmI97SSp5E3
	lmtc/bzlHUoWv0NvvlLr5Scv+pX3dyCTrx1waWGliMZb41DD7/K7YR4O9xoQ3sQeW+fdv0
	HsJexNKrKdR9hnx72cqub6MNhT43SPA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786012262;
	b=nPR6M/+ht0Wq1bdlLLu47BAhJwUr7NqmizG4BA4K2bBQchCKHG4ysWJtf5qS4cRXco802r
	pJLf3ruLYdahIN2K3KWREMoQrV7dY1Q78RzEr5lly931OO2Gie+j/Ibl+/t752h4WzV2yT
	vl1gCYUj1VJkPtlw+lcnAoe8mxvzuRI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jUQNwREQ;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786012260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3huU6e694bIFlA70vMxTN0EgWh1w1sy7DMZVgqBOLg4=;
	b=jUQNwREQBPJe1SLktvkAKHtYRMpbWJznRYl+7kPFrkMne60XSIzEEBhqmjUp7WyfJD0d8S
	mwkVw1GAJGCgHz0mjRLJpejM5WVeUyKWSY90Wp5nn9Chfnc37t26FW0XXnI+WTJ0HXSOyf
	eCDGwJ0nAl8USMCL5O6T2stwfBadP+w=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH 5/6] mm/mglru: add MM_WALK_EMPTY stats and tracepoint for cross-node measurement
Date: Thu,  6 Aug 2026 18:29:59 +0800
Message-ID: <20260806103003.3924438-6-baoquan.he@linux.dev>
In-Reply-To: <20260806103003.3924438-1-baoquan.he@linux.dev>
References: <20260806103003.3924438-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 8xztun3ebxfq1a5foi7ag3as15top8uf
X-Rspamd-Queue-Id: F249B20008
X-HE-Tag: 1786012261-574190
X-HE-Meta: U2FsdGVkX18E5iDv/pzraGKeH5tm0l51QrMjh9udgOWC+UQP8sGb6Yy6QDQFvxYUFnoR/YxSia10Ehn9O+nWziIyjlD5Im/vXfQwa9y1wMXvGqToiabLna3Q+vsFi4geqblnmGZ4DrMVXik/ZDgXO4aec7t/+ChdvZqGHTDGnTitQXoJWKzgelxNTRPmP1Xw7sQrr92PXj0cjX2Wfu+awpnXYzoJfGBp5cCNaGRzG1L7Jz3fAqSOdv7EXXFXKj2+iQRyKtyorqDOe2nqNFy4Mbs3XC5Iivj5CuoaFJTPqoKGQaxVq8G8YXk9c3eoBxEYyDWKYAmxE2ZM0HkOETAO1j0qDICH/nRSabFpRophFW1EReFdGnWPfBkqmxxTzXC6VmtLFlDSrzO6bf+GeT3YSp6aCFoGjuyLWpDoUnJ7aIvfQrrK6wlYRgkcxoTef7jLoPLl5I1sevP2ZLInPLrOFYH9Ju8mbVHtIWBtwCVokt0Ac3aa7JYppcuc2FwXvNS2H8f28qA3keaMB44KbkImQZ2ZwtdzRFdjT452dNV714ol38lM3clMCoty/OuZ5gyBMmxYMRQDaTGT9E+bsI88v2iFeCzqsx3SDBiWi/h06PIpyshk83qg/u6g5L/Hz+1mA/sEHgTCkuWz+JeTVJCUiEknU4cCBLnOtPu7SppU30YKhFHVngCUspNlAbqe1jyX4tbWGrSJ880t3t96wLg2X5tZ02d+aQhZrd8iFXNZa1TJHFNdgCMxl3upmiD41huukSSJkT9euXu0olh3ZqmyWzCvwWbkpa/arO2wW1ICt/skTrKtIZ+VSpAYvdHfehJKTq13Tbqx2tjnwylCAwQgu3ELsQlK9dC/p8/zBkbgRvQSzJb+RV9cyon+nRxw96RED4U3u6qvl3+YFSzgSUITREd8trJVGp5+NyccaHys7qOXZU8H0MyGryaygT0xT7jnqj+4E8tK44v5DLMYUpk
 W0dCli3X
 pRWKOohs0HACpROLQgtVvu3GTQ510ku3qNY9WbtHnNuKd9fvKC/8L1jDfjJi3mjKZ41XCPlyLZCFYBxZ7zDn1O8ZEk+kwItTMPHo6tKELPgrqd//h09i2ffBrMtszIZB9Bk8iYgmeqD7dPzAHCvaOVfpjDYDyN8gUnJh1N4VECXZdDDXOKKQn/aQO86CAR4QCdSh7ZInrOTs0Q4rZSqzxQ2mCqPMKdSr7pjVRedzWdspa+BZeAQT9LxYh9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add infrastructure to quantify cross-node empty page table walks in
the MGLRU aging path - walks that traverse an mm's page tables but
find no folio belonging to the current lruvec (node+memcg). These
are the pure waste that the PUD-level Bloom filter (see "skip empty
PUD subtrees during aging") is meant to suppress, and this provides
the counters to verify its effect.

New per-walk counters (accumulated in mm_state->stats[]):

  MM_LEAF_ELIGIBLE    - folios belonging to this lruvec
  MM_WALK_TOTAL       - page-table walks completed
  MM_WALK_EMPTY       - walks that found no eligible folio
  MM_LEAF_TOTAL_EMPTY - leaf entries scanned by empty walks

A new tracepoint, mm_vmscan_lru_gen_walk(nid, seq, leaf_total,
leaf_eligible, empty), fires after each walk for live monitoring.

The debugfs lru_gen output format is updated ("TYFA" -> "TYFALWEE",
"tyfa" -> "tyfalwee") to display the new fields.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 include/linux/mmzone.h        |  4 ++++
 include/trace/events/vmscan.h | 28 ++++++++++++++++++++++++++++
 mm/vmscan.c                   | 32 ++++++++++++++++++++++++++++----
 3 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 2bda24522d9f..508f6fcbbe5a 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -595,6 +595,10 @@ enum {
 	MM_LEAF_YOUNG,		/* young leaf entries */
 	MM_NONLEAF_FOUND,	/* non-leaf entries found in Bloom filters */
 	MM_NONLEAF_ADDED,	/* non-leaf entries added to Bloom filters */
+	MM_LEAF_ELIGIBLE,	/* folios belonging to this lruvec (node+memcg) */
+	MM_WALK_TOTAL,		/* page-table walks completed */
+	MM_WALK_EMPTY,		/* walks that found no eligible folio */
+	MM_LEAF_TOTAL_EMPTY,	/* leaf entries scanned by empty walks */
 	NR_MM_STATS
 };
 
diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index b4bf7b8def1f..c7c2034715b6 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -659,6 +659,34 @@ TRACE_EVENT(mm_vmscan_kswapd_clear_hopeless,
 		__entry->nid,
 		__print_symbolic(__entry->reason, kswapd_clear_hopeless_reason_ops))
 );
+TRACE_EVENT(mm_vmscan_lru_gen_walk,
+
+	TP_PROTO(int nid, unsigned long seq, int leaf_total,
+		 int leaf_eligible, bool empty),
+
+	TP_ARGS(nid, seq, leaf_total, leaf_eligible, empty),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+		__field(unsigned long, seq)
+		__field(int, leaf_total)
+		__field(int, leaf_eligible)
+		__field(bool, empty)
+	),
+
+	TP_fast_assign(
+		__entry->nid = nid;
+		__entry->seq = seq;
+		__entry->leaf_total = leaf_total;
+		__entry->leaf_eligible = leaf_eligible;
+		__entry->empty = empty;
+	),
+
+	TP_printk("nid=%d seq=%lu leaf_total=%d leaf_eligible=%d empty=%d",
+		__entry->nid, __entry->seq, __entry->leaf_total,
+		__entry->leaf_eligible, __entry->empty)
+);
+
 #endif /* _TRACE_VMSCAN_H */
 
 /* This part must be outside protection */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index ca0f06641adc..e34179343782 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3628,6 +3628,8 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		if (!folio)
 			continue;
 
+		walk->mm_stats[MM_LEAF_ELIGIBLE]++;
+
 		if (folio_test_large(folio)) {
 			const unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
 
@@ -3728,6 +3730,8 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 		if (!folio)
 			goto next;
 
+		walk->mm_stats[MM_LEAF_ELIGIBLE]++;
+
 		if (!pmdp_test_and_clear_young_notify(vma, addr, pmd + i))
 			goto next;
 
@@ -4167,8 +4171,28 @@ static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
 
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
+				if (walk->mm_stats[MM_LEAF_ELIGIBLE] == 0) {
+					walk->mm_stats[MM_WALK_EMPTY]++;
+					walk->mm_stats[MM_LEAF_TOTAL_EMPTY] +=
+						walk->mm_stats[MM_LEAF_TOTAL];
+					empty = true;
+				}
+			}
+			trace_mm_vmscan_lru_gen_walk(
+					lruvec_pgdat(lruvec)->node_id, walk->seq,
+					walk->mm_stats[MM_LEAF_TOTAL],
+					walk->mm_stats[MM_LEAF_ELIGIBLE], empty);
+		}
 	} while (mm);
 done:
 	if (success) {
@@ -5653,14 +5677,14 @@ static void lru_gen_seq_show_full(struct seq_file *m, struct lruvec *lruvec,
 
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
2.54.0


