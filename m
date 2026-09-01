Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEA21C61DE4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 06:38:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5DA96B00A9; Tue,  1 Sep 2026 02:38:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E35DA6B00AE; Tue,  1 Sep 2026 02:38:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFCD76B00B0; Tue,  1 Sep 2026 02:38:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ACD006B00A9
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:38:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3AA14120361
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:38:30 +0000 (UTC)
X-FDA: 85164239580.22.CC836CE
Received: from mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
	by imf02.hostedemail.com (Postfix) with ESMTP id 37CB280007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:38:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.24 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788244708;
	b=meUkidi88MLw6bcE/gNcnUjfPXV9a5bKVOOWpqmk0wKIMv7+TU0v2swNk6SCPclDPDhpnv
	xNbOPSIqzGnPRQXDRIj3qFD6/HVMyB/ZPdnVgLlCyUGz5EuK9dKhoaNSR0UCaBqPhtRI7L
	U3XQUoUE4IMoQ2TDUf8xOL4IvFfHUY4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.24 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788244708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Au3HySE7i/GQnk1tiOZZwgh7jN1CwFQPIHncYIHBT9k=;
	b=uBIx8yBmOGRoAJQ7aHg0MWkOJz1NSqdxELTZW9MhskqT0NXqMmiv/BuU7pdLg1N/XUAFtb
	Sl/C+IwwXmrdjhtxHiT2BjnDfmzGb0Xfng6fpdOpObp6AwYf7rdeSHOF6FYXROIPty7Id/
	Y2Wfr6nEUGp+369exrQaQ6HvDpKbyXY=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 07372f654a95b094;
	Tue, 01 Sep 2026 06:38:26 +0000
X-Mizu-Trace-ID: 07372f654a95b094
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	kasong@tencent.com,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	hannes@cmpxchg.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v2 4/4] mm/mglru: count PUD subtrees skipped by the PUD-level filter
Date: Tue,  1 Sep 2026 14:37:55 +0800
Message-ID: <20260901063755.1519710-5-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260901063755.1519710-1-hebaoquan@kylinos.cn>
References: <20260901063755.1519710-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 37CB280007
X-Stat-Signature: fita13sxsngnmw19yiujqguqcoiuj3ps
X-HE-Tag: 1788244707-702403
X-HE-Meta: U2FsdGVkX1865vzrR2vSX8slxuFmuhsIz2WiUza1vf4c5yPtyxOS5lx+U2++BNA7bTB20ctaEnvB/H6xObCa+YY1BbBj93pKmhm86opKQEvSezHvB9mLc9XBQ8dl9FUPrOrDkHSnDUOhEhfNHPKvRSsaWRN6skJbTUnFBJAbEHRRNVTSRmDrgBO5NBMJGbdwSvBhlE+RokbM0BmuC1yk2N5l7hdS5p9pmsQ0e4XHeWU+v5D/NUNFQRC6kIYdRgPTXk5awZQEwktX+lSix9duHfW5EboOqCi8M7obPZzJZK6DXV1OBSST3tQHNfSRe3mhbJ8VtRpxznHwoKCVWGzZmBOv03nep1a2BLUKWeg0Jc4tQZZhKEnlBPpqaTChnX4nAG82JUtVun7DWDeqnQ9JeRTvbEQ73xIoux8PyXxrVrXUTOmGdgjokz4JIjzkBo5AaLvt+it4dpqbr/clxjuzcDjeMvFv1OmV2oxgnjnF1BZMOmQsuwGi/gsAXvKHb1F24O+9akn55GEci6XhAIYsVj8y84fM7ehTg8YxxNU5yHc6NokAye1s3T3DF273o0yHplifcTVnVrRBvp1n4JoaRLN+0JWQsxMo9Z/FP+aVanC9aRYuZplhWNPbfmB2hLUbe+yEbujYM2CFR3GINH3EyxUK9N4s/6T5K6HMdXW7ChORGd26XrNTl0U7ogbRNNjBInU+Kj2xw+fVkXAVzTc1TzbAAgOknjm1XtSk/a6Amz8UJ/dboYXbTHR8OgUVG5bl54/mx+5I/kRuX+TykgHqQWwOf+Z7B8eiT/wQeo9+4tIHyA5b/Vdf9PXQlnGILpoSGpO9YTkfkQiU2LcLjLib/MipW79x9x4GcuX8Xn8jlqNr2JeTa1sUnAXXkObz0r+9BR/MMEqSQv6fJxdIPdfYPTc2X6r1oR75gr3V6Sc5qVy1ez/yX1ZQbW7ZcCwgiwN/BYC7fBY3jUBqYwFQnEp
 LB9bQY7x
 1neKsfAKBxPp6R1ZboW62DSmnrWbibsEemwWisQ6qNY2QKiIV7XdpdBe/DpLcKJXCq0WLUx+HRk0Wv3rTLZwLIPQuN36eaUJ0arSwLHqD9nRdj59W0eaqm3C9takJ62Lu6tCBeXiQfeyyHQhD+2akhZA53uVLhcJLBUc2s0YEyPJLTgsqpn8e9vIhcY9MYH6jdoDUmEExIum1LykhuNvmYR2lrthxUyhXfcdD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add MM_PUD_EMPTY_SKIPPED, incremented in walk_pud_range() whenever a PUD
subtree is skipped by the filter. Like other counters accumulated
per walk, shown in debugfs lru_gen output (the "S" column of TYFALWEES)
and via the mm_vmscan_lru_gen_walk tracepoint, so the avoided cost
by the filter can be measured directly.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/mmzone.h        |  1 +
 include/trace/events/vmscan.h | 10 ++++++----
 mm/vmscan.c                   | 13 ++++++++-----
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index faf28d35065d..276d0ca8d1c1 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -599,6 +599,7 @@ enum {
 	MM_WALK_TOTAL,		/* page-table walks completed */
 	MM_WALK_EMPTY,		/* walks that found no folio in this lruvec */
 	MM_LEAF_EMPTY_WALKS,	/* leaf entries scanned during empty walks */
+	MM_PUD_EMPTY_SKIPPED,	/* PUD subtrees skipped by the PUD-level filter */
 	NR_MM_STATS
 };
 
diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index 695d6fefc606..1cf031d88290 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -662,9 +662,9 @@ TRACE_EVENT(mm_vmscan_kswapd_clear_hopeless,
 TRACE_EVENT(mm_vmscan_lru_gen_walk,
 
 	TP_PROTO(int nid, unsigned long seq, int leaf_total,
-		 int leaf_associated, bool empty),
+		 int leaf_associated, bool empty, int pud_skipped),
 
-	TP_ARGS(nid, seq, leaf_total, leaf_associated, empty),
+	TP_ARGS(nid, seq, leaf_total, leaf_associated, empty, pud_skipped),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -672,6 +672,7 @@ TRACE_EVENT(mm_vmscan_lru_gen_walk,
 		__field(int, leaf_total)
 		__field(int, leaf_associated)
 		__field(bool, empty)
+		__field(int, pud_skipped)
 	),
 
 	TP_fast_assign(
@@ -680,11 +681,12 @@ TRACE_EVENT(mm_vmscan_lru_gen_walk,
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
index 955585626387..035bd9ea49aa 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3857,8 +3857,10 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 			continue;
 
 		/* Skip a subtree whose 512 PMDs all failed the PMD-level filter last gen */
-		if (!walk->force_scan && !test_pud_bloom_filter(mm_state, walk->seq, pud + i))
+		if (!walk->force_scan && !test_pud_bloom_filter(mm_state, walk->seq, pud + i)) {
+			walk->mm_stats[MM_PUD_EMPTY_SKIPPED]++;
 			continue;
+		}
 
 		if (walk_pmd_range(&val, addr, next, args))
 			update_pud_bloom_filter(mm_state, walk->seq + 1, pud + i);
@@ -4182,7 +4184,8 @@ static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
 			trace_mm_vmscan_lru_gen_walk(
 					lruvec_pgdat(lruvec)->node_id, walk->seq,
 					walk->mm_stats[MM_LEAF_TOTAL],
-					walk->mm_stats[MM_LEAF_ASSOCIATED], empty);
+					walk->mm_stats[MM_LEAF_ASSOCIATED], empty,
+					walk->mm_stats[MM_PUD_EMPTY_SKIPPED]);
 		}
 	} while (mm);
 done:
@@ -5664,14 +5667,14 @@ static void lru_gen_seq_show_full(struct seq_file *m, struct lruvec *lruvec,
 
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
2.54.0


