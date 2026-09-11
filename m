Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB53CC88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 10:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFB0C6B0098; Fri, 11 Sep 2026 06:30:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBB4F6B0099; Fri, 11 Sep 2026 06:30:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD1D06B009B; Fri, 11 Sep 2026 06:30:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9AC276B0098
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 06:30:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C59EC4016B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:30:53 +0000 (UTC)
X-FDA: 85201113186.13.50E45AE
Received: from mta0.migadu.com (out-163.mta0.migadu.com [91.218.175.163])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7C9E110000D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:30:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BzEEi9MF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.163 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789122652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bCHmDjvoSh7UbIYsNt37Hn/FTYHN1UOxZy/fdagRdko=;
	b=IAJwMftXLs3Z3gg8FkFheuD3zyyqOQdWM18GNaKS0l94ggZa+ONxYfxSRNBxBj8M8utMis
	fkVPjrBORuHwm7ojuLMGZtSios1wJhGaMiZyC0sP6Qlct+YHnVZp05xujeHPej5AwmIXOn
	EgPdT9gEOt8ZA3jc23EVtodIDn6ZmI4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789122652;
	b=ADlLZn3Ux1ULjl/3XxwUFssPTD279+3s29OaV5FjBqwSVfd+K9NmCzW2/LZ7LGAMpLzbNi
	YUbtxPuRQp9GYxZuZ9Bmw+G7CP+8RzkZtKd9xiptLuDf3aGApV6X1CrN/GH6KE4m8vFxI9
	ABDtJYxIZczyz5Ca0RblA0/E3ldfmeA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BzEEi9MF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.163 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=g+Mf/kGaBSRXqlRStbFxv9nvRzYBpUgfPbFtW3GN2lM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789122643; v=1; x=1789727443;
 b=BzEEi9MFIx2W5/R4L8onsD37pl0LiBvCvmUbhg0dhfrids0Qo7MXMe2CcZuwoed//NL0I3kV
 /jckL3QZvm+TWpsQyu+ZOwEF6nmYLh0HD8wSbAHs1nfiLZ7Uj6GcrNTpbjxMQuO5CKS1S2YEiZ8
 gIqrNZjQK5YLbQB0rbSDr1pQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4018faa0ac020977;
	Fri, 11 Sep 2026 10:30:43 +0000
X-Mizu-Trace-ID: 4018faa0ac020977
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
Subject: [PATCH v2 3/3] mm/mglru: add tracepoint for inc_max_seq()
Date: Fri, 11 Sep 2026 18:29:39 +0800
Message-Id: <20260911102939.2485750-4-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260911102939.2485750-1-ridong.chen@linux.dev>
References: <20260911102939.2485750-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7C9E110000D
X-Stat-Signature: 9pmt111m3wqnmo8zrfn91d3xp3aqxsa6
X-HE-Tag: 1789122651-718447
X-HE-Meta: U2FsdGVkX19i45Vie8xeV3vSJmxE+MDDLUELMPBj0VldXctjfiCFDYjLmQMgCxg+4rzHGKpxToJkyYza4S7a62r1dvRSRCgAE80/aZHNWmMjo0FssbpTv4b6PtF4i3kkE2NIXaYEc9bTBRfyS4PDKiPC9do0flU1XvyPwdLc1hUjj805QQ/kuu05M0mD7ZipCHKTyQ7Fa6T6PyuphVEB5n9e5UVwBbGkX0fWf4iFLnQyyYFxqBrxtF91rNB79yt7lK/EU185oyo0zKTcB/DDhJpiWpv9wphy5xZnL3t8RNoOUcTtooZyIDgP9F7Di4CuyxsiRbWyeWjEiFimTweH5+NXNIVlzCGruG1881i4VfNrZj2XF5zjPYLvsHdUUL4mu/bKCVT/ZCvCVv6zljObGMFl3lasc4r2QLRxXOX2clajyoac3YZ40WSzpiPVLL561eNuDwmJMjYk+Bpm3bYcGXsqiiObGFqaOa2ubgLv82eqAkuSsB4eWm9R7mjyfxzeP92jXT4qhvBI7fDIGSVt+s1zRSUBpUmh4tmX2+Qz+U9twpR3B1Qoe/BoXh8x2zqRTs/u7UzLKyvv9ygmzxL/dOH1sI4CQaJB7QSLQC9kfxtcrBqkZVK2oEtnJbuevQdKtp9Qi92VK0wi6TmY+YPiRnAUqRr3GC0yZXAHISczkm8N3N74zqqx3v7AOqRZeMlqmbdru8T3BdwXOwHyGf1N1nP0C+EbZbhw0kpL9qP+Gw+5dLNLjMcum3TH70yIfjkCd8VEg9RWwFZH3rV8oLrUWaNxe0/zBqpWFKI8lAHPEtfDdtcvTyWdhvf8Gn6bAKF/kupkhTV+ho/5gVegrzwqztuwWS9L/3LWfEdMihIKPlNcjAnBBV/bHGE0ufwu+hi47590MM4tPUCd72OQgTWwWaOG4brCqsqhK0VsFhCSGg/3mhSr25vOHIh3bx+RvdTd2pw1897aE49CYgClHts
 sMVdRVjX
 O/bXakxMqZ5+KvwdH4gqvo99IvPWz8DCQb6VzWflsKgkGysm/L+J47/7wngw0NqOLZOqF4+Bm9T531ENB8sH7lZ4o9t772M8XgVUj66jSuQQvQ2UK5PtYmee0L7mNE1jXa0w0zbQDeQHqFSj1hUT0+/4l+fo0j0WDl6DSIftQlnv7wMrAL1qRp4Dsfn2AB3HYvndtxjPXphKF2zO6ijbEu40vCKW/8HpfTkLHaE0NytAuPK2r2mK8ihD9mIUt1QmZBTZHG86C/Dy75tsqqrqo3mI0npY6K8cKRXyhrCNVQKQ7vkE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

Aging in MGLRU advances max_seq via inc_max_seq(), creating a new
youngest generation. There is currently no tracepoint on this path, so
the moment a new generation is created, and how the min_seq of each type
trails behind it, cannot be observed as it happens.

Add mm_mglru_inc_max_seq, emitted right after max_seq is bumped, with
the memcg id, the new max_seq, the anon and file min_seq, and the number
of pages in each generation for both types, summed over zones the same
way the debugfs lru_gen file reports them. The nr_anon/nr_file arrays are
indexed by generation slot, so the emitted max_seq/min_seq say which slot
holds which seq. They are printed with __print_array(), so the output is
hex and its length follows MAX_NR_GENS automatically. Paired with the
mm_mglru_scan_folios tracepoint it makes the full aging-to-eviction
window observable per memcg.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 include/trace/events/vmscan.h | 38 +++++++++++++++++++++++++++++++++++
 mm/vmscan.c                   | 23 +++++++++++++++++++++
 2 files changed, 61 insertions(+)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index 5defa8f6719c..a20c6b2e062f 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -455,6 +455,44 @@ TRACE_EVENT(mm_mglru_scan_folios,
 		__entry->min_seq)
 );
 
+TRACE_EVENT(mm_mglru_inc_max_seq,
+
+	TP_PROTO(struct lruvec *lruvec,
+		unsigned long max_seq,
+		unsigned long anon_min_seq,
+		unsigned long file_min_seq,
+		unsigned long *nr_anon,
+		unsigned long *nr_file),
+
+	TP_ARGS(lruvec, max_seq, anon_min_seq, file_min_seq, nr_anon, nr_file),
+
+	TP_STRUCT__entry(
+		__field(u64, memcg_id)
+		__field(unsigned long, max_seq)
+		__field(unsigned long, anon_min_seq)
+		__field(unsigned long, file_min_seq)
+		__array(unsigned long, nr_anon, MAX_NR_GENS)
+		__array(unsigned long, nr_file, MAX_NR_GENS)
+	),
+
+	TP_fast_assign(
+		__entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
+		__entry->max_seq = max_seq;
+		__entry->anon_min_seq = anon_min_seq;
+		__entry->file_min_seq = file_min_seq;
+		memcpy(__entry->nr_anon, nr_anon, sizeof(__entry->nr_anon));
+		memcpy(__entry->nr_file, nr_file, sizeof(__entry->nr_file));
+	),
+
+	TP_printk("memcg_id=%llu max_seq=%lu anon_min_seq=%lu file_min_seq=%lu nr_anon=%s nr_file=%s",
+		__entry->memcg_id,
+		__entry->max_seq,
+		__entry->anon_min_seq,
+		__entry->file_min_seq,
+		__print_array(__entry->nr_anon, MAX_NR_GENS, sizeof(unsigned long)),
+		__print_array(__entry->nr_file, MAX_NR_GENS, sizeof(unsigned long)))
+);
+
 TRACE_EVENT(mm_vmscan_write_folio,
 
 	TP_PROTO(struct folio *folio),
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 67f59aa73fb9..d1495a7d469d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4100,6 +4100,27 @@ static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
 	}
 }
 
+static void trace_inc_max_seq(struct lruvec *lruvec)
+{
+	int type, gen;
+	unsigned long nr[ANON_AND_FILE][MAX_NR_GENS];
+	struct lru_gen_folio *lrugen;
+
+	if (!trace_mm_mglru_inc_max_seq_enabled())
+		return;
+
+	lrugen = &lruvec->lrugen;
+	for (type = 0; type < ANON_AND_FILE; type++)
+		for (gen = 0; gen < MAX_NR_GENS; gen++)
+			nr[type][gen] = lru_gen_seq_nr_pages(lrugen, gen, type);
+
+	trace_mm_mglru_inc_max_seq(lruvec,
+				   lrugen->max_seq,
+				   lrugen->min_seq[LRU_GEN_ANON],
+				   lrugen->min_seq[LRU_GEN_FILE],
+				   nr[LRU_GEN_ANON], nr[LRU_GEN_FILE]);
+}
+
 static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness)
 {
 	bool success;
@@ -4159,6 +4180,8 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	WRITE_ONCE(lrugen->timestamps[next], jiffies);
 	/* make sure preceding modifications appear */
 	smp_store_release(&lrugen->max_seq, lrugen->max_seq + 1);
+
+	trace_inc_max_seq(lruvec);
 unlock:
 	lruvec_unlock_irq(lruvec);
 
-- 
2.34.1


