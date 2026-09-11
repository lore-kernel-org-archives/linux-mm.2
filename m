Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BACDC88E45
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 07:29:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F3CD6B0092; Fri, 11 Sep 2026 03:29:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A4986B0093; Fri, 11 Sep 2026 03:29:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BA556B0095; Fri, 11 Sep 2026 03:29:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E6A696B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 03:29:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6BAE8C0125
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:29:33 +0000 (UTC)
X-FDA: 85200656226.10.29E62D6
Received: from mta0.migadu.com (out-120.mta0.migadu.com [91.218.175.120])
	by imf18.hostedemail.com (Postfix) with ESMTP id EDE611C0003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:29:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="pM+QHW8/";
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.120 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789111771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1zkCYWBzgrq6H1kSHELexh23YwfnZJmhYRAHVpmaVa8=;
	b=3k1yiKiD0/MAed8gwzKiibwrggqItzU44eV7E6SqFtxCS0izPYGJRu3oMiVUr6KkbV0Cx5
	jLFI9pgFgpXRbPhJiqafPm3YiSaBjZPKsvUN6MN3f7UlFWI/kUFCOHbdN62dEOseedwOHB
	IHdfj/jwmf2sYfW1MaJlpuHdNJPhopw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789111771;
	b=KijQ4phiiHsaJkF7i/bDHPrz6xUWnhENYamlVp4zadPBcTmBJyitOBFgaNmYND0HTsitiX
	Ga+xLnH9y72RsyIr7Cb4ny6hbd0lIpX4+cmchb87V4RU8+Y7xU88Okq7jiy1OCOivgWVtt
	nCVsk1GOUm5tEUrmH7tYsmKayjgGK2Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="pM+QHW8/";
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.120 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=F8lEjUgDEYXzI9ZONpaLcnDoyXX5+afRbkkgw4XCoDA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789111769; v=1; x=1789716569;
 b=pM+QHW8/dAVKYbXaLvsg7Vt/XtEzus68mg9mkRKxX2oGxE9CgHpp4W6gTMSCnADVYlKB+Uh4
 qyF/xYCHEkHEfNbRzdp1S9uvO/x4zVrg5JgFX4RPNm9EmY34IZML9e6ztkN1xCpLe9zC7nxT8t/
 0rfpELJm5xpBQJHPR9ocOOHo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a3e5a5186c9ad1a6;
	Fri, 11 Sep 2026 07:29:29 +0000
X-Mizu-Trace-ID: a3e5a5186c9ad1a6
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
Subject: [PATCH 2/3] mm/mglru: add tracepoint for scan_folios()
Date: Fri, 11 Sep 2026 15:28:47 +0800
Message-Id: <20260911072848.2346073-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260911072848.2346073-1-ridong.chen@linux.dev>
References: <20260911072848.2346073-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EDE611C0003
X-Stat-Signature: hgombnb97ds7wpi9xf7bzdnuefh74ufx
X-Rspam-User: 
X-HE-Tag: 1789111770-938695
X-HE-Meta: U2FsdGVkX196V8cknJJ5RMRpo8eShiK9CBDui2YzJZhdcxqMefcOuR4UkZiGirhebcYw3ptFak4/fGHhD6O9T9RHiOKQ/wyLCLCVceUxQ6vSGF9Sc7gl8FlPxIJFNd9272CzjeQAiC7u5dHkk5SboBO3lNRkst2UUNE/Xy95pOHyD14TC6Na+AMORgl1VB5orhz3lIaQFNoNoNy5HKqzFhTot7fwgcVuDWTtOTrWKiFCcbAnuu9PdE69R1mp9wp8eDn1aYMupPSnPhDpe3/gjUUmRQzUhxSOTKESBKCqSN313wsdT4xihXaOfG7uwGvXFLgoyfuwIZwcKrJPwwh5y3bphQ+pokg2zmAi1om9K7xD61E1HeW2KeMGTmArciMxEZgBQQJfQp1dERrg+Tt9GZsZSMD1iWC7puRFHgHydcYa+orIVgjocV7GrN7r8qoZ/ldUeLny3mRUByFnxZYlAJZtO/huUVkxDKQlEKvO9QUBu29t5QAu41XuP/tCUMGrr/+40mcmQb1ZrO+plxAkee10um5j15J8lr+OGtma2WZKzfyC9MSYsa83XCROIytHLMqXLi/elqD0TIeJC8Xih6TTqFuzpSmJnNnlEvPiMWkKO9ORKO3S2tahJheqYNKoJ6tXz+K+nZdeTm+ygJL93ATu1mKQ+Pp5L279fpwXaw9Zi9urP0MQEuz+85Co3tSyd7r2Ib3SQue946A/OOLvoya/iwE9ghUWcO4jMU6pytoqwPQ22XB1Sl3GHGpS+gZxPLVi0Ar4ogb+CcgR92TLdC6gQDbvW4d+iDDjOyw/AiqmaT9g5z4jY31Lvk5CTd+KGC1VzJNirR4lZqEcmi4wyvw0lVH9bvL3CQbfySt0CYGqiJ/BdSDsR2pJB5DXs5BmAShHL+635qw39dosR64sKM3l/DD71WLVihgl8xmrjRsKcQm2ZvI/b0Woo4Ki09OZvlsmY7rhgIVLBmxcTs+
 ygafyear
 wDCj4mWbk1W1SqCnqlH4oZGWY7zGkE8Dk6PnhKR6/f55RWagcbaD6BzP606/w36Qi0x4nvL+EOToxQg/akKGtv5lrX85kxjarKfUpRLFowImdKegncfUV90cE4XYE4vEK3Vbp8ugKcSaUKK9x+cPq1ujwuQwejYS59LIBGuY0hDDS8dK3vXN6Alb3arJqMWl8B8SNzt/rVCJQo1qy2lDqgOM6PNxIBWW65CRlJ3Yea5BOAfK17X3Mb9h13uaNH4I3+zzDQ7wBBJ5KW3vWsPSXhHtZo3PcUPC45Q2zPwrkfUpjAgg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

MGLRU's scan_folios() emits the classic-LRU tracepoint
trace_mm_vmscan_lru_isolate(), which predates MGLRU. It reports the
scan/isolate counts and the LRU type, but carries no generation or
memcg context, so a trace of an MGLRU run cannot tell which memcg a
given scan belongs to, nor how far reclaim has progressed through the
generations.

Add mm_mglru_scan_folios next to it, reporting the same counters plus
nr_sorted (folios moved to a younger generation by sort_folio()) and
the MGLRU context the classic tracepoint lacks: the memcg id, and the
max_seq, tier and min_seq of the type being scanned.

scan_folios() is the MGLRU-specific layer where folios are actually
scanned, so it has no classic-LRU counterpart. That the classic
trace_mm_vmscan_lru_isolate() has lived here stably shows this is a
long-lived place to hook, and the new tracepoint can be enabled on its
own to observe the MGLRU-specific information. The existing tracepoint
is left unchanged.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 include/trace/events/vmscan.h | 63 +++++++++++++++++++++++++++++++++++
 mm/vmscan.c                   |  6 ++++
 2 files changed, 69 insertions(+)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index 8a872990b4be..c39dfacef033 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -392,6 +392,69 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		__print_symbolic(__entry->lru, LRU_NAMES))
 );
 
+TRACE_EVENT(mm_mglru_scan_folios,
+
+	TP_PROTO(u64 memcg_id,
+		int highest_zoneidx,
+		int order,
+		unsigned long nr_requested,
+		unsigned long nr_scanned,
+		unsigned long nr_sorted,
+		unsigned long nr_skipped,
+		unsigned long nr_taken,
+		int lru,
+		unsigned long max_seq,
+		int tier,
+		unsigned long min_seq),
+
+	TP_ARGS(memcg_id, highest_zoneidx, order, nr_requested, nr_scanned,
+		nr_sorted, nr_skipped, nr_taken, lru, max_seq, tier, min_seq),
+
+	TP_STRUCT__entry(
+		__field(u64, memcg_id)
+		__field(int, highest_zoneidx)
+		__field(int, order)
+		__field(unsigned long, nr_requested)
+		__field(unsigned long, nr_scanned)
+		__field(unsigned long, nr_sorted)
+		__field(unsigned long, nr_skipped)
+		__field(unsigned long, nr_taken)
+		__field(int, lru)
+		__field(unsigned long, max_seq)
+		__field(int, tier)
+		__field(unsigned long, min_seq)
+	),
+
+	TP_fast_assign(
+		__entry->memcg_id = memcg_id;
+		__entry->highest_zoneidx = highest_zoneidx;
+		__entry->order = order;
+		__entry->nr_requested = nr_requested;
+		__entry->nr_scanned = nr_scanned;
+		__entry->nr_sorted = nr_sorted;
+		__entry->nr_skipped = nr_skipped;
+		__entry->nr_taken = nr_taken;
+		__entry->lru = lru;
+		__entry->max_seq = max_seq;
+		__entry->tier = tier;
+		__entry->min_seq = min_seq;
+	),
+
+	TP_printk("memcg_id=%llu classzone=%d order=%d nr_requested=%lu nr_scanned=%lu nr_sorted=%lu nr_skipped=%lu nr_taken=%lu lru=%s max_seq=%lu tier=%d min_seq=%lu",
+		__entry->memcg_id,
+		__entry->highest_zoneidx,
+		__entry->order,
+		__entry->nr_requested,
+		__entry->nr_scanned,
+		__entry->nr_sorted,
+		__entry->nr_skipped,
+		__entry->nr_taken,
+		__print_symbolic(__entry->lru, LRU_NAMES),
+		__entry->max_seq,
+		__entry->tier,
+		__entry->min_seq)
+);
+
 TRACE_EVENT(mm_vmscan_write_folio,
 
 	TP_PROTO(struct folio *folio),
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2554a6513aa8..bd1b9ecf2e84 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4876,6 +4876,12 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
+	trace_mm_mglru_scan_folios(mem_cgroup_id(lruvec_memcg(lruvec)),
+				   sc->reclaim_idx, sc->order, nr_to_scan,
+				   scanned, sorted, skipped, isolated,
+				   type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON,
+				   lrugen->max_seq, tier,
+				   lrugen->min_seq[type]);
 
 	*isolatedp = isolated;
 	return scanned;
-- 
2.34.1


