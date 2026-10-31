Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91F74606A326
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uGbX2OdZ
Received: by kanga.kvack.org (Postfix)
	id B92966B05BA; Sat, 31 Oct 2026 05:02:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B69156B05BB; Sat, 31 Oct 2026 05:02:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA5B46B05BC; Sat, 31 Oct 2026 05:02:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 850416B05BA
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:02:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1ADC31C42DC
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:02:04 +0000 (UTC)
X-FDA: 85382329368.02.84D6673
Received: from mta1.migadu.com (out-113.mta1.migadu.com [95.215.58.113])
	by imf02.hostedemail.com (Postfix) with ESMTP id 288CC8000D
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:02:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uGbX2OdZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.113 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793437322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=olUAZWb4rGnN0WOUAfDAcNNMoLgDIGZnl5od4gLL/8A=;
	b=kBA2aqz98E87gK/dSiX6HD4UezM4n9xzUTW0wWoy0r8E0A3dgVrkOTpM34AtaMGr+gw7Sa
	5GD4b1ryb3vLqOA9wtPzEgNfS7jcpypao58mt+ts28DV3Ws0JFFGbyg8dfieF2Tf3hKmqC
	FRHviqer7iEftkwQx3gM6jLTsbUO9qk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uGbX2OdZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.113 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793437322;
	b=57RbceHs+SoiFO2v0tXXhPBUpRZjpEG0zQoRkeV12XKVzCt/JXuh0mk72A/t7RNjIRM0wq
	hEOoJT9S0XlkZhr1+6rI1vrjqkZp1Tuh7gCk95msrcXXWt19TQbfYq6z4HmyyfS5Xzfz5b
	5s0wdBKwMbt+ugt3Us8Jz6UQXw1x13A=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7oaQzh3qIYdYljiSohYitxTlhwMYY+sEAEK75MIPRFw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793437320; v=1; x=1794042120;
 b=uGbX2OdZDDvuT9QNY7AfoBgt6rUlIIG5PSNdObeHyALrAP1okGgWz4f4p4tTlFqHUVD9j1ZG
 WNLlsgtgdqhG2FdFDIK/q1pbYHcHJt4dC+IeeW8D2XxgOoScxqh4x1OtVzHYOKDlGLCVUo/J4NZ
 bShoJ8QG63/QOTYhq/BftB7w=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id bda5cc6f278b6035;
	Sat, 31 Oct 2026 09:02:00 +0000
X-Mizu-Trace-ID: bda5cc6f278b6035
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dave Chinner <david@fromorbit.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v5 6/6] mm/mglru: add tracepoint for inc_max_seq()
Date: Sat, 31 Oct 2026 17:00:41 +0800
Message-ID: <20261031090041.58574-7-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261031090041.58574-1-ridong.chen@linux.dev>
References: <20261031090041.58574-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 288CC8000D
X-Stat-Signature: sdin8nzwiedjk8jqqpmaug41c34uymfj
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793437321-861084
X-HE-Meta: U2FsdGVkX1/pqK/gjlkDwcC/EytvUBCIMYq1RxQPtZ51buDltjN1UQUx0TSRo8TWhC8+SglreNIxCUW9YMK3ND0LZ/waWeMD4XdQ9OFE+5kKilLB7epzHT52zoSGowdHtCDCfRJHf1f3bp1hwYKKaIXIu2wsVrBr39UOTyqpBGKIMdKZ7T/CDGqxqhH9P/D510na1iihBHkCNdHaufJJO81/m2ifu0mhdbjZDN1Xtj+jDsyK7JGnwBDyCoWZW/W8x3oBNy1SYIqTysvacmvi7xlctnlogkWgJbVG+A3Z480BLYGvecga91KlC9BXZwVohO6KEV23X2MxJLfM/5ALYIiRMckjY8bpiuxQGEeTRRgB1SaIu0LMvFtoLOfgYBXYomv+LV9pfxmNZNhedELRuMhb/pc8ozyZ7vjOVqzYgbQFHIXp1i7dr4ty/f33DVaSP7l6Z5mjPh6SxjaJWThznOVPDgHXKWH8R/5tZqGwi84B2q935nDArwUrcIIkCZPqYBiEoaNgFfPauY0e78dGRJyEngDsf8PToX60/HhwZ4ngEoq0YvJmwyl9u+gZoELtmBWt0IV2kFbrGr9V9gk3Vj7YMEYFcywDEjoERJsGwsJ0qNAMfQUyBnY4G+4ZZlmkc1woH8vI07CDxUrdp+sivcTMqZ5uOwEyvDzqj1+zkDvbsU6L1NbQC7HZojW85AkWWnZMo9U0PeaMiteo0K2p9zv8oWmTcTPGx2ipZvJEN4OFtZsUQ/6LXocy/A44MQwvrn7+sBnUnwVzJHsS7AhMIrj0ydJU/SUb4Mga9B79nA+81WROAjpZda3cQ46yHdfDgge13OHKcrDzDPbUJUIUwiPad9rP4/CaoxEhKQx3OOkDxk44WZeTSyhylLqfcUWoyf3jCJhBeskw+KN07+P8HTdPfFwH2QzbnyuwAZf/pl+lUExXGZeB2abE8sc1ZK/FTZrtYHfBtHePnUVVTcw
 8lQh+N/V
 yC5q0x/mV7TSETBableVhx9DtgMoGyIFEBsB5arBxDznP+FnmgKmtbyIgzVplb3zAO3i+6LJBGzEg1M9eF+BCBcveIvzV90FRHdlpZaJQhn1VPEdSFgJrQ4JolQbOAshArp/eA6CiVH+SeN3kIcGoWxyJmhhqhdxgCID8kh0Noh7evl7jayU8qkFazLRGCADxCsonUEGu5I3T0iZ5dvCWkQP94q1pTORrmySzTGC6Y02nLdYnXeG2CVGcPjypvjNIdjfkDv54TKbblJVdsr4q9INtb3p42jIxEEwpXqX5Vre4N3rtrsqqSJ4eYqMg4s1YevXib6Ba1rppWLaPr9F43RU8EA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

Aging in MGLRU advances max_seq via inc_max_seq(), creating a new
youngest generation. There is currently no tracepoint on this path, so
the moment a new generation is created, and how the min_seq of each type
trails behind it, cannot be observed as it happens.

Add mm_mglru_inc_max_seq, emitted right after max_seq is bumped while
the lruvec lock is still held, with the node id, memcg id, the new
max_seq, the anon and file min_seq, and the number of pages in each
generation for both types, summed over zones and clamped to >= 0 the
same way the debugfs lru_gen file reports them. The nr_anon/nr_file
arrays are indexed by generation slot, so the emitted max_seq/min_seq
say which slot holds which seq. They are printed with __print_array(),
so the output is hex and its length follows MAX_NR_GENS automatically.

Only the lruvec is passed in; all of the above is collected in
TP_fast_assign(), so inc_max_seq() does no extra work when the event is
disabled. Paired with mm_mglru_scan_folios it makes the full
aging-to-eviction window observable per memcg.

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/trace_vmscan.h | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c       |  2 ++
 2 files changed, 49 insertions(+)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index 8148b8224422..cddf42b5849a 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -456,6 +456,53 @@ TRACE_EVENT(mm_mglru_scan_folios,
 		__entry->min_seq)
 );
 
+TRACE_EVENT(mm_mglru_inc_max_seq,
+
+	TP_PROTO(struct lruvec *lruvec),
+
+	TP_ARGS(lruvec),
+
+	TP_STRUCT__entry(
+		__field(u64, memcg_id)
+		__field(unsigned long, max_seq)
+		__field(unsigned long, anon_min_seq)
+		__field(unsigned long, file_min_seq)
+		__array(unsigned long, nr_anon, MAX_NR_GENS)
+		__array(unsigned long, nr_file, MAX_NR_GENS)
+		__field(int, nid)
+	),
+
+	TP_fast_assign(
+		struct lru_gen_folio *lrugen = &lruvec->lrugen;
+		int gen, zone;
+
+		__entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
+		__entry->max_seq = lrugen->max_seq;
+		__entry->anon_min_seq = lrugen->min_seq[LRU_GEN_ANON];
+		__entry->file_min_seq = lrugen->min_seq[LRU_GEN_FILE];
+		/* summed over zones and clamped to >= 0, as debugfs lru_gen does */
+		for (gen = 0; gen < MAX_NR_GENS; gen++) {
+			__entry->nr_anon[gen] = 0;
+			__entry->nr_file[gen] = 0;
+			for (zone = 0; zone < MAX_NR_ZONES; zone++) {
+				__entry->nr_anon[gen] +=
+					max(lrugen->nr_pages[gen][LRU_GEN_ANON][zone], 0L);
+				__entry->nr_file[gen] +=
+					max(lrugen->nr_pages[gen][LRU_GEN_FILE][zone], 0L);
+			}
+		}
+		__entry->nid = lruvec_pgdat(lruvec)->node_id;
+	),
+
+	TP_printk("nid=%d memcg_id=%llu max_seq=%lu anon_min_seq=%lu file_min_seq=%lu nr_anon=%s nr_file=%s",
+		__entry->nid,
+		__entry->memcg_id,
+		__entry->max_seq,
+		__entry->anon_min_seq,
+		__entry->file_min_seq,
+		__print_array(__entry->nr_anon, MAX_NR_GENS, sizeof(unsigned long)),
+		__print_array(__entry->nr_file, MAX_NR_GENS, sizeof(unsigned long)))
+);
 #endif /* CONFIG_LRU_GEN */
 
 TRACE_EVENT(mm_vmscan_write_folio,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index ff51fee872f8..24cb2b7779b1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4134,6 +4134,8 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	WRITE_ONCE(lrugen->timestamps[next], jiffies);
 	/* make sure preceding modifications appear */
 	smp_store_release(&lrugen->max_seq, lrugen->max_seq + 1);
+
+	trace_mm_mglru_inc_max_seq(lruvec);
 unlock:
 	lruvec_unlock_irq(lruvec);
 
-- 
2.43.0


