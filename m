Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36A98606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 08:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Emlf2w73
Received: by kanga.kvack.org (Postfix)
	id 5B4016B05B5; Mon, 23 Nov 2026 03:58:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58A066B05B6; Mon, 23 Nov 2026 03:58:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8CA6B05B7; Mon, 23 Nov 2026 03:58:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 266A96B05B5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:58:25 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BAAAA1A0735
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:58:24 +0000 (UTC)
X-FDA: 85465782528.29.814170F
Received: from mta0.migadu.com (out-198.mta0.migadu.com [91.218.175.198])
	by imf28.hostedemail.com (Postfix) with ESMTP id AEBF4C0004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:58:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Emlf2w73;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.198 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795424303;
	b=16/kr+Tm1JsDerrhQVGgBeQ2ui8K277rCYeTm6shWzx86W8NJpVX8wjRH56xa3oWizWriw
	3gJCMkLXvu6VRIl048JM0PiNPdMAmqcYcf1EFqPvWSKadg3d59uOZdGGM/+lRping64IJK
	k++QuACmetLTVuYF5nAhZ/vew8zm4rs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795424303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qy7buhtlte+VKS5usa54kVNmWbFO/1e3c+JI77Qdp8E=;
	b=hUeC5RkksL+ZupmrmLankLqDcHvwErGgvBpo5TWnMnDeRCRtQiXHtiLBd2uU45Y6TvV7t4
	TCC9We8jk1+GZcNhGZ4g57H3dzwS4Q4L9mqvlPQX/LeJ/bKFmbcupBWZ+G3gISnNRc23Mj
	flB3bVrtpdJ3zJ8gByD++WuGawhuLR0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Emlf2w73;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.198 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5dUTyanq4G0dIqJC6TnX42zmwEskLk3jE+BRGLfSw+8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795424301; v=1; x=1796029101;
 b=Emlf2w73Jg+yHuqqBk8ANCLmB2/BfLDFx8hQ6qqnOgNt1kplRCXl4nI8CKGzfjObQMTtd3OL
 ckpxb5CFqlzUcPtqKQSmFKgLodUM0CzMh9XFllsQtoc9+MA8AVurMBZFzU9LT/QT1ftdoLqh2U3
 jN111mzSppaaOpeK/hGEu9cw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 1bfd051bc4c1f62d;
	Mon, 23 Nov 2026 08:58:21 +0000
X-Mizu-Trace-ID: 1bfd051bc4c1f62d
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
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v5 1/4] mm/mglru: add MM_WALK_EMPTY stats and tracepoint
Date: Mon, 23 Nov 2026 16:57:57 +0800
Message-ID: <20261123085800.981256-2-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261123085800.981256-1-baoquan.he@linux.dev>
References: <20261123085800.981256-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AEBF4C0004
X-Rspam-User:
X-Stat-Signature: bk8o77h5pibunz7yejs16bj8xqjd9pms
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795424302-299553
X-HE-Meta: U2FsdGVkX1++NIvzpbhfUJM4wNBVa81UJDonwc2bgPHDTHiYRqFZ2zz2BiS1bhQErqF1DpyPUi0fEXkSOm+duxqvVjLcaDLhHKUbGnqn5ux4urlK9rheEx7zjFzrMDNfbYmCXwYlIGslBmFSypuBUIeLMUthfM2B4CRUEVtGsSz2gFMJI81ke6xIonKdsyECCQA9+o/jdDJKGQXNkE/x/hfVhwXV5axKPMWgHKUbXBXxytk2fL6xnpXtD9BsXbsofDMo3evbi3i6akhbCVS2gSXfStuZAIg5I9NADHdJ6P8v6nx2R9ZN1gaZicw4dXP6icErq2eKlPyTVYr+qhg0p5uMmY8aVnhWVzJDoYUlPkfz7FYPOQiGCn5IHQwc1R3PAqMpAb677Kv46vETXbkaxz0JdlgZl/IvGiKURrrl2DSY0JefWbtxfBO/vNNucNbM4BLdj0hIbuSnmhWgv3LL9A/y6huoK0GQxHR6g6MLmMDMbSIP7MfDTQ80voqofCWaXKBEM2OytrxjIiEr4/ba+KcE9j3a6+awHgZeaPBkgufabgr6Dd2+i0GXf/k63QjAjthvPyx9pShdI8mAvMxB2hibwNDrpNGWavCUly4egespDKhZ8p8G7Ncj0gAmU/n9jCT4mhbUTLQUAnmxKe/1bSwfSjNpagkKcDqj+EigIsxfVquidlGfiVxa62n5HP9ez8vqcv8QT/nNPDTIBxlanIzGKr/Qg7tT07jqkXcA8oPem2s5OsQb9yCSBWiZdkpTgwdDvOVZNuDi3ahVhJ6oqQWiMZEkx+vWkB97avvzLjJIpmwDL9FmlMdbONxTOb8sOK3Efuv/uEBTDuJRmijEKjEj+lqo5GjxowNLV00TL40vVCchfH+KqDKWZ4vihjvBHXYM8Ftig859nYWs9lk5MWwwji7zamiP2ujvYpWFhO1v1/vv/hR+Az7sJy+5cRFIJPioaVc7BSzwbyCLIBW
 38tvL58q
 xi9dNV1rp495yqaZhxE/hrxLDeT+6NltGMfOY8UsO77PQG4SM1F5f26089N1SEVgj6jJQpz1gTNgx+qV9M22Lpkf2GAx/wCm0vFvQNqE5VGc0WiUJGDchWmGhqmueUfBWNSDh9JOWGf6d51E+/3HV5Sa5F02arcwz8DA2HOHKAIvA5A0oYLcC7M5GBsWVrvtxD/dvaDww0zbGbZLyaT3hHsLGy3bZWFHJmRWbVmc/zgOJkKHPeWBxiM0VjE3G7Wntc6NDti5OhVb+M2RJHp0PKk0cxYta0sfvHqTXvpaiHu4Tzgu3Jugdhk/Q5xwQthVKz3JDBwd9T2G3wgH3luhmYBPnx9yv07/+w+fLE5lojtSThxYiX+ZoKxudWMld83wuP8ZTwcYA1Wim72gl/48cgz4AOET3IfnkLuRIKsPhaw85ea8l3xd7Npy2u6u1LE33kcI70R8efEutBPPIJOyvSbfBJauGYtJwGF/6aAyVgV3vIzM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

Add per-walk counters to measure empty aging walks, which traverse an mm's
page tables but find no young leaf for the current lruvec (node+memcg).
These are common on multi-NUMA node systems because lru_gen_use_mm() marks
an mm for all nodes at every context switch.

New counters (accumulated in mm_state->stats[]):

  MM_WALK_TOTAL        - page-table walks completed
  MM_WALK_EMPTY        - walks that found no young leaf for this lruvec
  MM_LEAF_EMPTY_WALKS  - leaf entries scanned during empty walks

A walk is empty when MM_LEAF_TOTAL > 0 and MM_LEAF_YOUNG == 0.
MM_LEAF_YOUNG already counts only the young leaves whose folio is in this
lruvec, which is the condition the PUD-level filter of the following
patches uses.

The new tracepoint mm_vmscan_lru_gen_walk() fires after each walk, and the
debugfs lru_gen output ("TYFAWEE") exposes the counters.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/mmzone.h |  3 +++
 mm/trace_vmscan.h      | 28 ++++++++++++++++++++++++++++
 mm/vmscan.c            | 32 ++++++++++++++++++++++++++++----
 3 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 6a2ad0cff795..8aabe0f23e60 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -579,6 +579,9 @@ enum {
 	MM_LEAF_YOUNG,		/* young leaf entries */
 	MM_NONLEAF_FOUND,	/* non-leaf entries found in Bloom filters */
 	MM_NONLEAF_ADDED,	/* non-leaf entries added to Bloom filters */
+	MM_WALK_TOTAL,		/* page-table walks completed */
+	MM_WALK_EMPTY,		/* walks that found no young leaf for this lruvec */
+	MM_LEAF_EMPTY_WALKS,	/* leaf entries scanned during empty walks */
 	NR_MM_STATS
 };
 
diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index 9dafdb5bd3ce..b0c2af65c1ea 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -508,6 +508,34 @@ TRACE_EVENT(mm_mglru_aging,
 		__print_array(__entry->nr_anon, MAX_NR_GENS, sizeof(unsigned long)),
 		__print_array(__entry->nr_file, MAX_NR_GENS, sizeof(unsigned long)))
 );
+TRACE_EVENT(mm_vmscan_lru_gen_walk,
+
+	TP_PROTO(int nid, unsigned long seq, int leaf_total,
+		 int leaf_young, bool empty),
+
+	TP_ARGS(nid, seq, leaf_total, leaf_young, empty),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+		__field(unsigned long, seq)
+		__field(int, leaf_total)
+		__field(int, leaf_young)
+		__field(bool, empty)
+	),
+
+	TP_fast_assign(
+		__entry->nid = nid;
+		__entry->seq = seq;
+		__entry->leaf_total = leaf_total;
+		__entry->leaf_young = leaf_young;
+		__entry->empty = empty;
+	),
+
+	TP_printk("nid=%d seq=%lu leaf_total=%d leaf_young=%d empty=%d",
+		__entry->nid, __entry->seq, __entry->leaf_total,
+		__entry->leaf_young, __entry->empty)
+);
+
 #endif /* CONFIG_LRU_GEN */
 
 TRACE_EVENT(mm_vmscan_write_folio,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index bc7579d47f9b..a0cbbbb2ff00 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4158,8 +4158,32 @@ static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
 
 	do {
 		success = iterate_mm_list(walk, &mm);
-		if (mm)
+		if (mm) {
+			bool empty = false;
+
 			walk_mm(mm, walk);
+			/*
+			 * A walk that traversed page tables but found no young
+			 * leaf for this lruvec (node+memcg) is pure waste: the
+			 * PUD-level filter will skip it next generation.
+			 * MM_LEAF_YOUNG only counts leaves whose folio belongs
+			 * to this lruvec, so it is the condition the filter
+			 * uses as well.
+			 */
+			if (walk->mm_stats[MM_LEAF_TOTAL]) {
+				walk->mm_stats[MM_WALK_TOTAL]++;
+				if (walk->mm_stats[MM_LEAF_YOUNG] == 0) {
+					walk->mm_stats[MM_WALK_EMPTY]++;
+					walk->mm_stats[MM_LEAF_EMPTY_WALKS] +=
+						walk->mm_stats[MM_LEAF_TOTAL];
+					empty = true;
+				}
+			}
+			trace_mm_vmscan_lru_gen_walk(
+					lruvec_pgdat(lruvec)->node_id, walk->seq,
+					walk->mm_stats[MM_LEAF_TOTAL],
+					walk->mm_stats[MM_LEAF_YOUNG], empty);
+		}
 	} while (mm);
 done:
 	if (success) {
@@ -5804,14 +5828,14 @@ static void lru_gen_seq_show_full(struct seq_file *m, struct lruvec *lruvec,
 
 	seq_puts(m, "                      ");
 	for (i = 0; i < NR_MM_STATS; i++) {
-		const char *s = "xxxx";
+		const char *s = "xxxxxxxx";
 		unsigned long n = 0;
 
 		if (seq == max_seq && NR_HIST_GENS == 1) {
-			s = "TYFA";
+			s = "TYFAWEE";
 			n = READ_ONCE(mm_state->stats[hist][i]);
 		} else if (seq != max_seq && NR_HIST_GENS > 1) {
-			s = "tyfa";
+			s = "tyfawee";
 			n = READ_ONCE(mm_state->stats[hist][i]);
 		}
 
-- 
2.52.0


