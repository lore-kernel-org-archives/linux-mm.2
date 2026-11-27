Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CE29606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 06:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aXPuD6OB
Received: by kanga.kvack.org (Postfix)
	id 773C76B05B9; Fri, 27 Nov 2026 01:17:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74B016B05BA; Fri, 27 Nov 2026 01:17:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63A4B6B05BB; Fri, 27 Nov 2026 01:17:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 34B616B05B9
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:17:08 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3345C020E
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 06:17:05 +0000 (UTC)
X-FDA: 85479891210.10.0D1DEC9
Received: from mta0.migadu.com (out-33.mta0.migadu.com [91.218.175.33])
	by imf22.hostedemail.com (Postfix) with ESMTP id D15BDC0005
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 06:17:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aXPuD6OB;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.33 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795760224;
	b=JbeM5akgaiYT7r785gA0fyMLL21TMlUKtEMXWfGG693nSvr3+3LvlRCErS1MBMq8nD2uPz
	ncbLQb1lY95aVVpvLRZpDTcw03cIgLI3n/rAValUB6r7P8QUa5/YTD00ybg/wgRsAPxIiP
	tOBTT7pGrZGFMlUSkEDFNt4hyjyzdaI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795760224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gf8negw7qt9+3iacF49dOlge+09kMVe/6G8eZlk9zR8=;
	b=22oB8sdbyirXQx9Psh989TCgN26aGa0orM+U4HflXRZTKeySkF//tm1aCRBb4mutUIWeaQ
	WN+JGQ6GqXkT59wmTlKfgUCQlS7yyY6UdWMbOGPqe8LuYabQ5F94Q1bqlFPiBoP6AmcufH
	rypyOcStnwVuB8kuHp1Ho8GmGk+LfDU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aXPuD6OB;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.33 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TcM6qeffsJfFA5o6CnmYYlIe+hqXQksmIKjFeaCoa0c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795760222; v=1; x=1796365022;
 b=aXPuD6OBKwTqO8cknmvt59HlP5p7f5WXPbGeysYiZWG1siip3jGigJtHG9ykK9O1mBMnmkOy
 wu4iLzaQwFcw+M7PWtDZP5rHBQ/iz5NKjul6X7dG4B9geDOk65xMrLSSFZRf4qz7CZEXsenrUrb
 h6OB3DobglURtS4yO3pJTbyE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id df1224ac7f1e52c6;
	Fri, 27 Nov 2026 06:17:02 +0000
X-Mizu-Trace-ID: df1224ac7f1e52c6
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
Subject: [PATCH v6 4/4] mm/mglru: count PUD subtrees skipped by the PUD-level filter
Date: Fri, 27 Nov 2026 14:16:30 +0800
Message-ID: <20261127061630.11290-5-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261127061630.11290-1-baoquan.he@linux.dev>
References: <20261127061630.11290-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D15BDC0005
X-Rspam-User:
X-Stat-Signature: 46g6g4uf4wzu5dwwdxafunhwdmdqzczr
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795760223-511542
X-HE-Meta: U2FsdGVkX1/JNEHeZATzZ1mWqa9swm1GbgPI+VSdXhc5rRTvHcdwDoRYAsehGQhi+5zkn7QbSAgJdBmPa6HQhZr7KFChAcbckiPUBRE7ch/TOnKle3h/gjqVjRYvQO54uG8Mvmm3ihlpNxgfrEEW1oKa8jZLdo0Q5xlYC9HULmtc4AEjdtVlp/w9bVLfD2lyBSb/A70l4I0G6YiyL+OuNe51yQ397k2nFCk9PJGBwm016kNM6akPnwfRKdpFcj78OVRBAvBHFbE+BE4ITFBsbCmBiVGfwgt8M+0z/+Y9u4MyaHMVd7w5YDTo/9BFk+Sn4OgR20VvAcC7cH4LOJSzmQZkpP6y7s5gYKa+qTfBzt3ThKrh15LeJswrVyKET6YoyLc8gXi4Ge+fxJymBl31eKmf4flGtlbRexruGzTFx74vxSGaJO1muCOCoCAjEgvfgcBnYa2VYgWX1H8+p1jjl8UtQFQzJFtZj47ELuivr1RCaDc2SBNPuDysgZ0EUEUko2gHKlklcCYRipA05MuaXKoMjAwUtawX7WMGZQOWQ8mjisatmoJu0e7zKyUhaJj64aZJ7Px4rBmdvd0jFArI2MEa2SgyrhM/bcMN8ichtPVLGh4HhWSNF7/K1zbTVwVd/rElJrshY0xVqbgEgeb5SkhQHiZ9FRqwvJivaU8PJUBYk1T1J7pDQfX4WkbaEOWQSvFUDfhZI30z2bTQLzbenmCqs2AcYlt/fFmn/MxdRBkeC6mRJg3qTfdD1I6LNLgacWn/0IbZCxtkHbCzI5Lbd7p7JljMuRnzEhOFOfKeDroiSIECcbeFLb073mbZ5arZZ//kDaC1GTwN1/e5n5OLziv0HWMQxgb+q5VtlFztdv5EIQ7xEChSNACuCgAfaFeF4WqrirKvUuged3yPB5WmvvhqKSIY6m9kyPHN6hnOaQSE2CGhjuZHT/g12doCouTBSFKZtbYv8XkJnY3gAd4
 cgLr3LJm
 w6zKuOdiPISgpNo7jIui3GWgQHS6iuoEmIYICpfVKjO1i4R3kCPnll3i4KsuOi0dAzLtOfKl31RJaAQU73XIoo3hvYf+ofuIRhS0pJreolvEyu8O8Dny0qSWQQBIF7Dhfv5/SyyMMqehS1g4moxY08dHT5IUeNkpVRgp+21/myVgO45vR/U9bt7prRL/8CoGSnUbEBjjRc72G6STxlrFMlIT24dU/bqhYDzgOYzfuWtTM0iWuKPi/DW81bLOyXyxIkjnmXGtW9WsDadIMS1yt60oOoilP3mRsMbCHIVWe0XccddSqjxtctliGg1Gho1EoKMn+oG53SHQQd0So/ATeEpsBlZu2qQBpkr0waAsIBHYFdWKE9ZDkBtz6XMiBAAqznDXLDF7GwsiyHOeiNpY7MpT5AWzAz3Q/Kb6TzLpNgm7GddB1NVp9+a8C6xaEiRbysSjB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

Add MM_PUD_EMPTY_SKIPPED, incremented in walk_pud_range() whenever a PUD
subtree is skipped by the filter. Like the other per-walk counters it is
shown in the debugfs lru_gen output (the "S" column of TYFAWEES) and in
the mm_vmscan_lru_gen_walk tracepoint, so the avoided cost can be measured
directly.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/mmzone.h |  1 +
 mm/trace_vmscan.h      | 10 ++++++----
 mm/vmscan.c            | 13 ++++++++-----
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 832809cbeeb0..49eb833aa786 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -634,6 +634,7 @@ enum {
 	MM_WALK_TOTAL,		/* page-table walks completed */
 	MM_WALK_EMPTY,		/* walks that found no young leaf for this lruvec */
 	MM_LEAF_EMPTY_WALKS,	/* leaf entries scanned during empty walks */
+	MM_PUD_EMPTY_SKIPPED,	/* PUD subtrees skipped by the PUD-level filter */
 	NR_MM_STATS
 };
 
diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index b0c2af65c1ea..5a78b8ca3dac 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -511,9 +511,9 @@ TRACE_EVENT(mm_mglru_aging,
 TRACE_EVENT(mm_vmscan_lru_gen_walk,
 
 	TP_PROTO(int nid, unsigned long seq, int leaf_total,
-		 int leaf_young, bool empty),
+		 int leaf_young, bool empty, int pud_skipped),
 
-	TP_ARGS(nid, seq, leaf_total, leaf_young, empty),
+	TP_ARGS(nid, seq, leaf_total, leaf_young, empty, pud_skipped),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -521,6 +521,7 @@ TRACE_EVENT(mm_vmscan_lru_gen_walk,
 		__field(int, leaf_total)
 		__field(int, leaf_young)
 		__field(bool, empty)
+		__field(int, pud_skipped)
 	),
 
 	TP_fast_assign(
@@ -529,11 +530,12 @@ TRACE_EVENT(mm_vmscan_lru_gen_walk,
 		__entry->leaf_total = leaf_total;
 		__entry->leaf_young = leaf_young;
 		__entry->empty = empty;
+		__entry->pud_skipped = pud_skipped;
 	),
 
-	TP_printk("nid=%d seq=%lu leaf_total=%d leaf_young=%d empty=%d",
+	TP_printk("nid=%d seq=%lu leaf_total=%d leaf_young=%d empty=%d pud_skipped=%d",
 		__entry->nid, __entry->seq, __entry->leaf_total,
-		__entry->leaf_young, __entry->empty)
+		__entry->leaf_young, __entry->empty, __entry->pud_skipped)
 );
 
 #endif /* CONFIG_LRU_GEN */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index db89b5f5f0db..4d0f82c6cc59 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4091,8 +4091,10 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 
 		/* Skip a subtree that had nothing young for this lruvec last gen */
 		if (!walk->force_scan &&
-		    !test_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq, pud_key))
+		    !test_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq, pud_key)) {
+			walk->mm_stats[MM_PUD_EMPTY_SKIPPED]++;
 			continue;
+		}
 
 		if (walk_pmd_range(pud + i, addr, next, args))
 			update_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq + 1,
@@ -4444,7 +4446,8 @@ static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
 			trace_mm_vmscan_lru_gen_walk(
 					lruvec_pgdat(lruvec)->node_id, walk->seq,
 					walk->mm_stats[MM_LEAF_TOTAL],
-					walk->mm_stats[MM_LEAF_YOUNG], empty);
+					walk->mm_stats[MM_LEAF_YOUNG], empty,
+					walk->mm_stats[MM_PUD_EMPTY_SKIPPED]);
 		}
 	} while (mm);
 done:
@@ -6122,14 +6125,14 @@ static void lru_gen_seq_show_full(struct seq_file *m, struct lruvec *lruvec,
 
 	seq_puts(m, "                      ");
 	for (i = 0; i < NR_MM_STATS; i++) {
-		const char *s = "xxxxxxxx";
+		const char *s = "xxxxxxxxx";
 		unsigned long n = 0;
 
 		if (seq == max_seq && NR_HIST_GENS == 1) {
-			s = "TYFAWEE";
+			s = "TYFAWEES";
 			n = READ_ONCE(mm_state->stats[hist][i]);
 		} else if (seq != max_seq && NR_HIST_GENS > 1) {
-			s = "tyfawee";
+			s = "tyfawees";
 			n = READ_ONCE(mm_state->stats[hist][i]);
 		}
 
-- 
2.52.0


