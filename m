Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBFFE606B36B
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 08:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WOsHMkUr
Received: by kanga.kvack.org (Postfix)
	id EF5326B0618; Fri, 13 Nov 2026 03:50:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECCC16B061C; Fri, 13 Nov 2026 03:50:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE3066B061D; Fri, 13 Nov 2026 03:50:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD6726B0618
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:50:47 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A6D258014D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:50:46 +0000 (UTC)
X-FDA: 85429475292.02.A23A166
Received: from mta1.migadu.com (out-90.mta1.migadu.com [95.215.58.90])
	by imf29.hostedemail.com (Postfix) with ESMTP id AF8E9120005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:50:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WOsHMkUr;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.90 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794559845;
	b=F8OANsiinZEwX5n+21c8zLw/EMlXmBw3Iz5U6FV12eyto4Eum9RRe7ZtWcHR3ybmCI6Nrl
	HdqDYZLRX62Wjtc8F93Izd5aEsL23enGYELTsKehOexTf8yMAr/7vYWm+bRJ5WkmuIUeme
	Td173eJn6R2DdQcpRfqgeC9Y47W0H1s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WOsHMkUr;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.90 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794559845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iayvwzinws+ltPtx+tvNbJMmQUtK1+1d1Sfp4sM6lJY=;
	b=loFiK5F8A/dNY5NiI+YPIsTw4O9AFfX8MLOzUP1NfCHaSwY4IMolQZWEJoWHnlmYtnsCWq
	gJOmUEFljEkIXe5oUVUum8yWXQX2n1Ynp9xO3P3S60hIaw40wbNOHOzldIju0gICucbAap
	VDa5bnyDAEVXmil/YZRL01bW2cSfEos=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RyAquxQzqgV3JbxWPn9HBoAhH3+XewCluce9H+mG1S8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794559843; v=1; x=1795164643;
 b=WOsHMkUryeNnY0Ng2kJA9BorKQYJQk/F4hhNhMtU7jhXmz2H5dsxY7P7xvSdjAk2/t0FQEUS
 u5M+vMXmcfz4ymV3cPbKBpPKais//3RD3QapxRNbpJJcWNWhhpAk6qxNzGQd00kXZE/F+Ksg8ej
 5iKiMbmhePlIm5huJw386Yio=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 62847641418f68e9;
	Fri, 13 Nov 2026 08:50:43 +0000
X-Mizu-Trace-ID: 62847641418f68e9
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
Subject: [PATCH v3 4/4] mm/mglru: count PUD subtrees skipped by the PUD-level filter
Date: Fri, 13 Nov 2026 16:49:53 +0800
Message-ID: <20261113084953.412919-5-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261113084953.412919-1-baoquan.he@linux.dev>
References: <20261113084953.412919-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9ri93subma3dp3c7f1sh1igkorr8gwqu
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AF8E9120005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794559844-804910
X-HE-Meta: U2FsdGVkX19Hruzmbebmb+QDgC+XQ5BGvUJi1nmuiOCUxRxEDHW9oewjdHtCsPpsE/sOfCpVdPxHjvNkdPyATxCNETb403FWZeBbE81jJldcCiWBoOWZR2MNVr3v42s1yRE+Z+IGMhUDgC9pnlez7kPkcE3T7DGcL8D7VfNDPcISOQgDsNPQVtjEB7S2CuA73Fy6AFVY+J/3vmc1p5s5F/h5LypsHYWoJxIrSx8tN1NFR+QktZFscbwhmgA57iR3KsAdKzytBsF/RSddtgA3ZISIE5vDP9s8Yeo/7zL9yM45/69TTEoJB8c0h5w5SUvr6ABeuHDYCVpF4K7ku3US2kHKfqmwmJmdlq45gOAWW6xFd08zqxYXv+eKr8B5bu98WrMutPXXuxfeTSNip4u+hLXG1ytKuGE4Qc3KYfqXDhd3+l2j4XerCpLd6avCx8KxeIn7sq2Qm167WgbebEt10XlaS1coe/cTbEQSsnbFck1X5NhBI4fxYxxwEBsfFY35NMxEhxH6Iw/n419jJWhWctEqQUsafo8HjZq/uoLhJ2925MM/5opC+A6GXGk+E5k/0kv6oASZKZaQxyiWHCGdxADAhiPprzi2atIzdkM0Jx1s9KWdohYJijF2tMfjBvUUnqwKQspXZ8ZIDOzEwDJcK45rz8Lz4ubfbWlmSG96m2jHCKSLicpVkU+S68yCGPpUh2uqLvjFl7xCbbqTomzirmXgwJeVPYnEWxHDNTmPGXHlFPzitf10lJwZ08HjxdjfgboiI29ShlT7Ls6izggwgB+TARcMbcnCrlRYUdnsKVtJXJ8VdNp75GXdD3F6VxdJJ3pB8C3FlvjNi9tt4uE7UIrQ/hDQYNW2Lu5t8XXq9mI3nVlmAMuez3+R9M8wMW6mP0+NAYfBFtksyKNhmvDu+xtjcW0lFdjEiorTDLDdcx2xeyP0Hg9TspIG/+xfV/0QQKo/+RtJiS1qrRqRNbf
 COu48WfA
 Yf9my+CwXiEYAN0yKIY7Zmxq7Y6fdTUB2S5ZloBz7a1pj5qZ4aE5Sps12AfwM3W0XzagSHAxhrnEVPr87+hmdDoSYDihDJYzEXWMo2LSoIavh576f/C01KaDHyeMHgpN19MAxUmeqs79TPHFcLiKFRVm7bpobpI8TAaKg3ScVtPThwCDRjYrKTvC/UbWIIWX43t07osA/dF+LNHG+TOw8rZvIliX08o4lyDVi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

Add MM_PUD_EMPTY_SKIPPED, incremented in walk_pud_range() whenever a PUD
subtree is skipped by the filter. Like other counters accumulated
per walk, shown in debugfs lru_gen output (the "S" column of TYFALWEES)
and via the mm_vmscan_lru_gen_walk tracepoint, so the avoided cost
by the filter can be measured directly.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 include/linux/mmzone.h |  1 +
 mm/trace_vmscan.h      | 10 ++++++----
 mm/vmscan.c            | 13 ++++++++-----
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 1f086ef3a00e..857ff92d5e58 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -583,6 +583,7 @@ enum {
 	MM_WALK_TOTAL,		/* page-table walks completed */
 	MM_WALK_EMPTY,		/* walks that found no folio in this lruvec */
 	MM_LEAF_EMPTY_WALKS,	/* leaf entries scanned during empty walks */
+	MM_PUD_EMPTY_SKIPPED,	/* PUD subtrees skipped by the PUD-level filter */
 	NR_MM_STATS
 };
 
diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index 4884fc7a35b9..8b31057d66da 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -766,9 +766,9 @@ TRACE_EVENT(mm_vmscan_kswapd_clear_hopeless,
 TRACE_EVENT(mm_vmscan_lru_gen_walk,
 
 	TP_PROTO(int nid, unsigned long seq, int leaf_total,
-		 int leaf_associated, bool empty),
+		 int leaf_associated, bool empty, int pud_skipped),
 
-	TP_ARGS(nid, seq, leaf_total, leaf_associated, empty),
+	TP_ARGS(nid, seq, leaf_total, leaf_associated, empty, pud_skipped),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -776,6 +776,7 @@ TRACE_EVENT(mm_vmscan_lru_gen_walk,
 		__field(int, leaf_total)
 		__field(int, leaf_associated)
 		__field(bool, empty)
+		__field(int, pud_skipped)
 	),
 
 	TP_fast_assign(
@@ -784,11 +785,12 @@ TRACE_EVENT(mm_vmscan_lru_gen_walk,
 		__entry->leaf_total = leaf_total;
 		__entry->leaf_associated = leaf_associated;
 		__entry->empty = empty;
+		__entry->pud_skipped = pud_skipped;
 	),
 
-	TP_printk("nid=%d seq=%lu leaf_total=%d leaf_associated=%d empty=%d",
+	TP_printk("nid=%d seq=%lu leaf_total=%d leaf_associated=%d empty=%d pud_skipped=%d",
 		__entry->nid, __entry->seq, __entry->leaf_total,
-		__entry->leaf_associated, __entry->empty)
+		__entry->leaf_associated, __entry->empty, __entry->pud_skipped)
 );
 
 #endif /* _TRACE_VMSCAN_H */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index d12934f2fbb3..88de6bd4f7ca 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3854,8 +3854,10 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 
 		/* Skip a subtree that had nothing young for this lruvec last gen */
 		if (!walk->force_scan &&
-		    !test_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq, pud_key))
+		    !test_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq, pud_key)) {
+			walk->mm_stats[MM_PUD_EMPTY_SKIPPED]++;
 			continue;
+		}
 
 		if (walk_pmd_range(pud + i, addr, next, args))
 			update_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq + 1,
@@ -4222,7 +4224,8 @@ static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
 			trace_mm_vmscan_lru_gen_walk(
 					lruvec_pgdat(lruvec)->node_id, walk->seq,
 					walk->mm_stats[MM_LEAF_TOTAL],
-					walk->mm_stats[MM_LEAF_ASSOCIATED], empty);
+					walk->mm_stats[MM_LEAF_ASSOCIATED], empty,
+					walk->mm_stats[MM_PUD_EMPTY_SKIPPED]);
 		}
 	} while (mm);
 done:
@@ -5714,14 +5717,14 @@ static void lru_gen_seq_show_full(struct seq_file *m, struct lruvec *lruvec,
 
 	seq_puts(m, "                      ");
 	for (i = 0; i < NR_MM_STATS; i++) {
-		const char *s = "xxxxxxxx";
+		const char *s = "xxxxxxxxx";
 		unsigned long n = 0;
 
 		if (seq == max_seq && NR_HIST_GENS == 1) {
-			s = "TYFALWEE";
+			s = "TYFALWEES";
 			n = READ_ONCE(mm_state->stats[hist][i]);
 		} else if (seq != max_seq && NR_HIST_GENS > 1) {
-			s = "tyfalwee";
+			s = "tyfalwees";
 			n = READ_ONCE(mm_state->stats[hist][i]);
 		}
 
-- 
2.52.0


