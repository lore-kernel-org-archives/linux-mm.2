Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D258606A329
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 06:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZJWJ8L2O
Received: by kanga.kvack.org (Postfix)
	id 5020D6B05B2; Fri, 27 Nov 2026 01:16:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B1D16B05B5; Fri, 27 Nov 2026 01:16:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A1896B05B6; Fri, 27 Nov 2026 01:16:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 070016B05B2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:16:46 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C3F2A7858
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 06:16:46 +0000 (UTC)
X-FDA: 85479890412.16.DB3A387
Received: from mta0.migadu.com (out-16.mta0.migadu.com [91.218.175.16])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4E65420005
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 06:16:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZJWJ8L2O;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.16 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795760204;
	b=HdGQjjvNXf72aFfMH7mb/3wzJIzCZmES0X5mWVUHVgWZ3zOwXEMytkLoHTcKo9HPlZZa33
	nX6Af0f6xnRPqm3juVvhg9vtBh3QldZwKStFKZLJ3yaUDaDaturYpSrGU31j7L4Q5HQ5gb
	UKMOghZOpMkr2yRAsa6jk6Kzd3ISmPY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795760204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ciomd9qsnAfbzZfOUYtL3Ir1nRXHBNdqG1q3zzdSGWA=;
	b=g0ffSc73RIWk6cuBHivfwY/qBD3Uuhhvt6dtIj2rEhjh7j9yn7fiz+oy2XmC7aIBnEkbrH
	XpuCQ/YSb9Gh0YFAT8hNruuIIYnzhyZBvskBx/nib37CUcnVXdRDTdLN44BN6rkcCgGshB
	MhKaZON4S7SwNt192buIGVJw3CWcZMU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZJWJ8L2O;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.16 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=89Uapx8Ndb47eD1+bo4pMSnasCM/0ZG7zsqxuFxiWLw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795760203; v=1; x=1796365003;
 b=ZJWJ8L2ODXuscdwFoNyZ++3pkXNg59VX1uxdaDSI/L+M1y5Tj2lBB7Zic36Ng4p8ohey3xwz
 HkSJnZc7BYC0KnExSWFzRC7fmJbiZcm14G7hfTIVqvXkU/IG8oF8NsCI8pDymxLTYDnO3e1zByd
 D+tyR8Lt3S/0mQ/36mZNWpdc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 6d41019d88495dbf;
	Fri, 27 Nov 2026 06:16:42 +0000
X-Mizu-Trace-ID: 6d41019d88495dbf
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	baohua@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	mhocko@suse.com,
	riel@surriel.com,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	hannes@cmpxchg.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v6 1/4] mm/mglru: add MM_WALK_EMPTY stats and tracepoint
Date: Fri, 27 Nov 2026 14:16:27 +0800
Message-ID: <20261127061630.11290-2-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261127061630.11290-1-baoquan.he@linux.dev>
References: <20261127061630.11290-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4E65420005
X-Rspam-User:
X-Stat-Signature: 5k6pzkua9fb3cizw6dirutd7c8pun9it
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795760204-844525
X-HE-Meta: U2FsdGVkX1/KVfkeFl/r/yENZWQGkZYwOhl8QPkF3PNm4VuzAeoDJZyQsPaaEFFaTYmz8Pur/6oqIGXH77AsNshknCsaebv7QtvpuCcmT9MoLCDeiu6b6sNyF76n1keR0UnRxXJkpNHd1g0DESyhUllVQRpQzcsw/0gSKch/yBiU/MrJOn60CHL0ssWuKMhn/6Y6oD/KO2fmb418zcwgVLKV1zskwjGabHtr4OJjeUAnRXPyYG2k0p7w6UEW2LJY3py4Olw7l39CEn6EnzcO2akE/yxHfQkYfjvTEfSRk7qBCffj/pUh8X2JWi/jbn3tHrFC0p3ve5t1cFPpF3xQAQ28lPqMfepfVivano9GUc5M2r29MEIERshYoKcDBcWzDP/kdNNMZslUmcCApbDhj85x2mZliy6lR9r34p/mqiscZjXJMrqxBp/6UhnhcQ6mgO5sbfxsvPqi/1RGz/yAYe7XO5tMzqcbV4IfnLUjxzi1lbLnOWtUab5qvXhIxB/+iZetUT/6Juh1EDNGaTF9s6KcchDNxUuBeDyuam2+Xlh3LCjaHaLPotJeuhTDw4Ww3v215I7rtKSYLzY6KTxo3a4u7Hi4TaAXOG1WMUlUMUHtr83A5OSz+r98ZFLKH4o84WaP+Cq3Qae1nagdnCl+Mo1uzuoF1YRvfNxmHpckcd0w8bkwdY4AM1XJBkAc8B1wy9U58JmnVr+4gf/4W06KDQoC+jYspQTiGAF+O8MhGZgL9HtsVMb04Djmz1GXBlJkccpAeGQ1w1urEWsMMqg5r+ZdmRrOVuHh6Mht3x+akKZfUp3sbi+iruouTd2+LBH/h5ZTvUUjPjv3CNfnYAeW4mF+2yFH7PaAHz6SJzYi5UaRMMFn54cWkvafQ3UYZ6gJApUN5PaCSJNy0QjAuYg6JJ/9APmfMoZtQh2xldudgH4bxmJU2k+S0ExNW+rjDyA8s23K4E23N2/i/pOY0kL
 NLV01o3Y
 ha/UAnj5xsy2sSorSWwn3drEZB2oJ5W/aSlN2jn0sHCE1A4kAiOoXtbuIsK2LxpVDOgue2G3QLrN02qnxWyeyjEBn7YKyuPVTOWSTf3O2p60/KwsuyMFEPxDfefjA6lLkZVZt8uEObb4ZguD7rrohcmdyDwwcvVwZj6kfsENGFar0TFIzQJO9kvHcHySXBVyiz8Xwfp4XXyrPWrn8Z5M93rozFufWH4dhFtSQgGZShklkdHINI3ReHJXp7QcxCc+l1l6UpW8bmebW8bGF2jundcpQfjhtFEfb3P4w3Zky5UNd9iH4JYrjRzXq8sShtTBtbOc4A6HqM5pvXS5+6001LbRgAC2r1ZmibeZZatn8OGd54BpFqbewGHbYixG0NiQJ3QroFGdjNCBhle0D2tVWjmdUrAVx4hN4Pi78G3B37TZCjpttG+n/nPBGgMUVYag+klwlqEtkN2XApPqennktYfWcl5CWDauZTphr6yakyFYzTNU=
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
index 14c58bbd1606..12cba15a02fa 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -631,6 +631,9 @@ enum {
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
index 81797b71228f..c755d4914d76 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4375,8 +4375,32 @@ static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
 
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
@@ -6010,14 +6034,14 @@ static void lru_gen_seq_show_full(struct seq_file *m, struct lruvec *lruvec,
 
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


