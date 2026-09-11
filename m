Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B70DC88E45
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 07:29:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BBE56B008C; Fri, 11 Sep 2026 03:29:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96C806B0092; Fri, 11 Sep 2026 03:29:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A93E6B0093; Fri, 11 Sep 2026 03:29:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6812A6B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 03:29:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5C6F1A0110
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:29:24 +0000 (UTC)
X-FDA: 85200655848.05.94F622C
Received: from mta0.migadu.com (out-104.mta0.migadu.com [91.218.175.104])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6383040006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:29:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IaY+C2kt;
	spf=pass (imf27.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.104 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789111762;
	b=Y4WM6YFgUVlqLtsF+b94ncTfzcExIvvlwS255Zkt66NLL8MUtGRKs2a8dMQifEBCNTOqUd
	2Hscub70SjtbEd74r+WMqtScRAKUS9EUK/O5AQSd004z6qIh9k2N5mGnCfFcsGvzFq10Hd
	rBEohSJAsADGc9vGjBxUsZWDSHiyT9g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IaY+C2kt;
	spf=pass (imf27.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.104 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789111762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7xf5cO8i1fvbMjYR041dxQ4K7REFcZow2QMXWDWsaMY=;
	b=3Y6cxslSbVwlpR4E+J1Pu5erwkP5ymDfpFdy0P2wEd4drMMyEFpNrabRFGEzKFOkATYKXC
	+FV/6G3/5pmbHieQBWcQfGvNYdBVqGZykrFhWbX0mEOgwxJWYoWJxy126X+tuJnfsrVixe
	fESXUlIk4ddrN/EJUEpXyBZFEZdRerM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=g5xNOknu84CKDZN5IQmWT85FT3qL1QmesKNb79arhdM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789111759; v=1; x=1789716559;
 b=IaY+C2ktpNiNjDGG75HQbpPJUk/6BFVCv1QnkH+C3MFknAkgwDfMtd4arJOw4o2ODTpMLMdo
 OWO7Vr01F1I7Vgc5sqBRXsHI2S99opU6cM/M6P/j7xS9/DXVluaagWbK+WbAiHASWDSrDF3N9bd
 meskw8DC+g7kW2VlakksIic0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7d4cc03316c4c354;
	Fri, 11 Sep 2026 07:29:18 +0000
X-Mizu-Trace-ID: 7d4cc03316c4c354
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Kairui Song <kasong@tencent.com>,
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
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH 1/3] mm/mglru: factor out lru_gen_seq_nr_pages()
Date: Fri, 11 Sep 2026 15:28:46 +0800
Message-Id: <20260911072848.2346073-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260911072848.2346073-1-ridong.chen@linux.dev>
References: <20260911072848.2346073-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6383040006
X-Stat-Signature: z8enfqeu7wxut8fn9hwfxtqcewkw5174
X-HE-Tag: 1789111762-940028
X-HE-Meta: U2FsdGVkX1+Fve5sIxspa5oTBDNPw34vLEaKmuoG7CWd8r8YFjeQxSvcIah1tjlktCEG7b0j0EAsMXXap+DxjbsnrA5Y9tsLRsjbbhbN1jgXRX1aZAtWJAj8bU92jyGt89SYkwmo8ozGqkpVjeoXnjwijISyfcvcIcxl4xI255Bqrit0v+vJM7orL8Fo7x3QTDrnpXsrMiALBNxk9MVvGhKY0FtyztWnY/fzfNhyL0sIFlB8zZw1YrJWuwOjytvyLsnlFx8x9jMIm8rDShnsXZVFQ9zmgJ3qE/4dklXdRsp2BT5/NLB1vCbkblLNesRPqJTK5lc2FN9ag5NZSwK3yZQKKagmx/pN5Kti0vKGan7DI073ZEmdNQ49lxFvTWqa0TuF51Tjl+hAsOlpQaVWWhMCqspycmzOBjKZ89jxTD4PttN1T3pI+p02o7kOP2pxFTCR9S8y99pGINNxVehBSfl29LJA9SUayoC0dcGcAn2jyLQqPlHV248A6V0Mt/lkt16p+QIul2/fCpCE5YEKqHsds6Oz2f6+emWrWleCecE+jwHxLqagO9UUPQBwc2KHIGZ8CFQa5cbAdCNT1y/cm7V+XSRAdu5aQ8fLHlaPnBUPRDks1wqQfQFkX6g0ZUXp2vsQCba5xkuiZZSaTMAF9SpAAS4tyAGN9N68QX3Gg355LmLne+5f6OX06RTvFZu9S72uL5ESPZXioex7NV1rtXI9aRViUJyaqh9jX5LZ+y7p5+1rzy3D+QRhdcYHeLhymWwNpF/gmYo3JEzwD3ES8V29BRIke1ORLlPdmSbrwD9UnhZzVyX7gJjLogscsc4j3juqik28s5BtxRkw94FAeTTymkAgKtR1QAsEbZvjYCliqssVed4EzFDfBHX1seXMOalXwvcwFJLuSBZzM1pdUIZp5WfJe4GDJVW6sbaVfXtzhjonuly6SKPOMpF70KcIVSlgc7LARbDLko2ZSV6
 rQaIGQGH
 2r7eAF0ssJMpA+KoTFGuywLdYuKQi9jHIaPrNgVJvnzF1FXSlDW/sn8SFnw16wQazo3foAPwRNdrlo75AQhWxkuEEafDZVw2AzhmVTBZEVfLTot0frBJW0mqoSi0CA6O8zcPY4OYRiAbaVLMOQ6mfpJZxetuRjiKx5IIy1CbD/90iYC0tXDFVTuNGRLUli4eVSCEVqJ6Cnv+9UNUKQgTA+07YV7p9YH7TP4s7T+7Tx6jsduFVmnnujV7Aght02HiubQKZmhywThlDOHQPlWA0O/FUWMPUO6Fc7s/ZIlIQI+vbZWY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

Both lruvec_evictable_size() and the debugfs lru_gen_seq_show() compute
the number of pages in a generation the same way: sum lrugen->nr_pages
over all zones for a given (gen, type) and clamp each term to >= 0.

Factor that out into lru_gen_seq_nr_pages() so the open-coded zone loop
lives in one place. No functional change.

A follow-up patch adds a tracepoint that needs the same per-generation
page count, and will reuse this helper instead of open-coding it again.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/vmscan.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 40d3f1b48a74..2554a6513aa8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2813,6 +2813,18 @@ static int get_nr_gens(struct lruvec *lruvec, int type)
 	return lruvec->lrugen.max_seq - lruvec->lrugen.min_seq[type] + 1;
 }
 
+/* the number of pages in a generation, summed over zones and clamped to >= 0 */
+static unsigned long lru_gen_seq_nr_pages(struct lru_gen_folio *lrugen, int gen, int type)
+{
+	int zone;
+	unsigned long size = 0;
+
+	for (zone = 0; zone < MAX_NR_ZONES; zone++)
+		size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+
+	return size;
+}
+
 static bool __maybe_unused seq_is_valid(struct lruvec *lruvec)
 {
 	int type;
@@ -4239,7 +4251,7 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
 
 static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness)
 {
-	int gen, type, zone;
+	int gen, type;
 	unsigned long seq, total = 0;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	DEFINE_MAX_SEQ(lruvec);
@@ -4248,8 +4260,7 @@ static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness
 	for_each_evictable_type(type, swappiness) {
 		for (seq = min_seq[type]; seq <= max_seq; seq++) {
 			gen = lru_gen_from_seq(seq);
-			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				total += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+			total += lru_gen_seq_nr_pages(lrugen, gen, type);
 		}
 	}
 
@@ -5738,19 +5749,16 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
 		seq = 0;
 
 	for (; seq <= max_seq; seq++) {
-		int type, zone;
+		int type;
 		int gen = lru_gen_from_seq(seq);
 		unsigned long birth = READ_ONCE(lruvec->lrugen.timestamps[gen]);
 
 		seq_printf(m, " %10lu %10u", seq, jiffies_to_msecs(jiffies - birth));
 
 		for (type = 0; type < ANON_AND_FILE; type++) {
-			unsigned long size = 0;
+			unsigned long size = lru_gen_seq_nr_pages(lrugen, gen, type);
 			char mark = full && seq < min_seq[type] ? 'x' : ' ';
 
-			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
-
 			seq_printf(m, " %10lu%c", size, mark);
 		}
 
-- 
2.34.1


