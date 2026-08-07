Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 700A7C5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 09:23:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ACA06B0088; Fri,  7 Aug 2026 05:23:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 735FD6B0093; Fri,  7 Aug 2026 05:23:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FDF86B0095; Fri,  7 Aug 2026 05:23:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C7176B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 05:23:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E7521401E1
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:23:53 +0000 (UTC)
X-FDA: 85073936346.20.4A21CD7
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf05.hostedemail.com (Postfix) with ESMTP id A77EF100009
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:23:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="qHwl/Ce8";
	spf=pass (imf05.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786094632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bBLjPHKj7ewYEFDkI+8W+MrOFuQbGGpOgVwFtitxf7w=;
	b=ptcwi07fxEW4+9PEO8EKvRwjxa7DTS+ktKoClRPWHRaNlCIRlniumgrbbvpBkw+ywoxOJ3
	eoTcTjb6z2yERYAVlHQUsTbyCtehndSbOoyhXXYaACVH2GC1pBm6s3L4MgiRTRQbo3ViCM
	54PKvyA3xvya3ocJ6mgWEd7Av8gy1NM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="qHwl/Ce8";
	spf=pass (imf05.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786094632;
	b=VwFVb5CEN2P+tCGhAkI4hZdQ2dTmyw/OpXdinR+i7b65YZljcqrURoCmi0SdznqkcJ9iTu
	BZNV3xinT71FilGkwStkub5h+FMZic16mD5WvAQ7rb8XEfri2uPOF2gz+C7lkouDPjVE0/
	dtyRTY6cFLbMJ/zdeRLhtNM/aGpn7LY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786094629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bBLjPHKj7ewYEFDkI+8W+MrOFuQbGGpOgVwFtitxf7w=;
	b=qHwl/Ce88MbRbC/KkNCGkGxKiGhhKbJVRrX9GvfduZ7NrYf4H6goe4/nhqt7Pq4Elf6f0t
	qnyotNe6qNi16MhZnPZC3pe+46D+DzTyrWzgpUynqIK1JyoEg0wihPtieT+oc1+7dcSL0/
	eYvcGqm50R089rMYt9lXn6W3FbENhOU=
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
Subject: [PATCH 1/4] mm/mglru: add MM_WALK_EMPTY stats and tracepoint for cross-node measurement
Date: Fri,  7 Aug 2026 17:23:38 +0800
Message-ID: <20260807092343.4123734-1-baoquan.he@linux.dev>
In-Reply-To: <anRqew3VikVzxJJb@MiWiFi-R3L-srv>
References: <anRqew3VikVzxJJb@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: hoeepgaa9zckprw3gxgcceef3gwoiq7u
X-Rspamd-Queue-Id: A77EF100009
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786094631-684111
X-HE-Meta: U2FsdGVkX19BI40D172kvTvV5XKtbZrAozJ21MfO4BmkHeDjvaP+06jrQF1mDA8eAYtayY4W0mxjY6tLhGjSmoynKeyGh1O5s66aGyX3aMbz+6kqpFI+slgIQ0SavOUHjTwqaSJDBqTimWXDsQlR2K2B4v/QjJNxkzMuDEPM6ZRnUiPg4Bs2LAWMbeMp+GgqWPxutSNhhEkF7SlJfdDx1Re6Wtj0IkgRZT4RK50V/D5kSnIzGV3BRbzhvc0ruCLhCLn76trLvDgHenko1xirNMjp3NsU5Yu5GJsXxIB0uAWGxiuuiF+88cp+QZ1t9WP2vaRXzeMLL0HR7r+wTpjUsTnnOROOeoBcAesxFL/d4Zfz+i7cz6tag/dXgRboWcZ1srcy+qfgEzYFc7QnApIBZwkZx8gKPtQHGwLXQt/mkv/5WRcVn+GVayG5MCWxURURHOk4rRSeI0jgU7OSY9MNl2b/5iLt2Maby7CqUuIxdD/AySEnAAQoFLErIFX6SMvSkYbes6SkPRlM01tnNOsmgJNGmqY6EGosLZv3J9WGD//TUcHbOEpQtaXTf27PIMlshW57jiq9toPVn1+C0++hizW4XndCngHTgix9QdfTmCA3jnhRZhuf5nr7jvshnw/OcuHNvkA4k1CFrS3+CY0H0Wk3u/owMhhoBSq+SgPnLDC/zYDGz2xqfrhr+x9KC64MDMDxhN3vYRBgg8CWWSJ3Za2CD0GYMqoDLoMqs0v/1HIwiSaYA23FqmiUT+YP/P93FFtPddNWDJvlWaum1gaaE2Z1gdBqlsWjjB76FfEwlqtDhd7BxhQE3qDJvI4TpCgbb6CJQ/SfCqqT0PZgZRoIaZOfCzrHnpgKxfu4danyyo7aVegtLB4Gyr5TF0Kum+dcHZB8pqsez15zJ27XO9Zo5zjYfyHE+oQdxlliginlSJ03cf2Cy84u4KkQ3dIa0Ll2hDlEBAXwLfgpa+1EDLw
 FkxCdWqu
 CAcvL9sZu5LlQAvyuPky7tHCsDPo9cELDVulAeu/t8jyO/27W4R1FEvzMtd+0c+jEOGeoWKNxBgfBf+AMpFahsctaN4nL3FKSA5QSiZrvuL9SRsu8Po1JQ1ZnB7Mf+BbTw2QCk62xFeUG6lE5LtDpuCuZ/i0Lek0z4Qt4mnnqNsxuFSZGgyLnR/gu07cdghIIIpkAvX+xDw66zZeIBfE6tO408l2COkFJZeX6F3iWs+zoZVIEE8sUr/OiIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add infrastructure to quantify cross-node empty page table walks in the
MGLRU aging path. These are walks that traverse an mm's page tables but
find no folio belonging to the current lruvec (node+memcg) - pure waste
caused by lru_gen_use_mm() setting mm->lru_gen.bitmap to -1 (all nodes)
at context switch.

New per-walk counters (accumulated in mm_state->stats[]):

  MM_LEAF_ELIGIBLE    - folios belonging to this lruvec
  MM_WALK_TOTAL       - page-table walks completed
  MM_WALK_EMPTY       - walks that found no eligible folio
  MM_LEAF_TOTAL_EMPTY - leaf entries scanned by empty walks

A new tracepoint, mm_vmscan_lru_gen_walk(nid, seq, leaf_total,
leaf_eligible, empty), fires after each walk for live monitoring. The
debugfs lru_gen output format is updated ("TYFA" -> "TYFALWEE") to
display the new fields.

This series uses these counters to quantify the cross-node empty walk
cost and to validate the suppression implemented by the follow-up
patches.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 include/linux/mmzone.h        |  4 ++++
 include/trace/events/vmscan.h | 28 ++++++++++++++++++++++++++++
 mm/vmscan.c                   | 30 ++++++++++++++++++++++++++----
 3 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index a26c8b855222..34938d4f8e23 100644
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
index 17d2b793cbfc..83de2b147919 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3587,6 +3587,8 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		if (!folio)
 			continue;
 
+		walk->mm_stats[MM_LEAF_ELIGIBLE]++;
+
 		if (folio_test_large(folio)) {
 			const unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
 
@@ -3687,6 +3689,8 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 		if (!folio)
 			goto next;
 
+		walk->mm_stats[MM_LEAF_ELIGIBLE]++;
+
 		if (!pmdp_test_and_clear_young_notify(vma, addr, pmd + i))
 			goto next;
 
@@ -4108,8 +4112,26 @@ static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
 
 	do {
 		success = iterate_mm_list(walk, &mm);
-		if (mm)
+		if (mm) {
+			bool empty = false;
+
 			walk_mm(mm, walk);
+			/* A walk that traversed page tables but found no folio
+			 * belonging to this lruvec (node+memcg) is pure waste. */
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
@@ -5588,14 +5610,14 @@ static void lru_gen_seq_show_full(struct seq_file *m, struct lruvec *lruvec,
 
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


