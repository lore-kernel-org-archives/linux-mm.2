Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD150CD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 04:12:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 282326B0005; Tue,  9 Jun 2026 00:12:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 232D06B0088; Tue,  9 Jun 2026 00:12:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1218B6B008A; Tue,  9 Jun 2026 00:12:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 02F116B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:12:46 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3F3BA03CA
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:12:45 +0000 (UTC)
X-FDA: 84859053090.21.FC08324
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7ED8040005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:12:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JZ1T1k9d;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780978364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4h6x44t/kUL5SJGKCThKAyRtoW9WrlvFmr2fXLO09kY=;
	b=b7a2T6Hd6K4vywthKR0qaRzb2cynl1CpECMdEl3LMsSO7BUU5aAVv8xkY9s9VHelZ+mBkB
	9gxBT6x0PScZgZxg+zW6w54GPnsgRwOJdrHqxJWICQ25rEwXw4gsa4YD9nwEccWZ0zKgG/
	p+NMLYgRrWKcXScgHg3WiJAd2bMWkjw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JZ1T1k9d;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780978364;
	b=kRJd07+2k1+utLcaw10iVdqu1gnXZcSQ0n0hHYBzgxmHt2qPxmP2pUNE/afJN7AQ13rxvN
	aBuL7xrWlmczg1hUNpIcB1AaewXjvep11EjibMoUQteAfrIATl+hX2PyKTjpIQ2+BqoRq3
	45DagG6H4p5vULwvDnQMOCIK6VSEc6Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780978361;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4h6x44t/kUL5SJGKCThKAyRtoW9WrlvFmr2fXLO09kY=;
	b=JZ1T1k9dmfNfGxSCYXOE5B1BNYHUXaoBZFJM7tL5++Ew64OXoBMeebrwgAbt2wTLRUqGDP
	QvS/wtp+R9YSs7rg4JVmPaj+/Ev64gd+FXdmJV4LY2gNE9MRq4J9OkXPquGoTZew1+bs2l
	iuqJkMfsYm/i8jxh0QxrcwvENfug+D4=
From: JP Kobryn <jp.kobryn@linux.dev>
To: linux-mm@kvack.org,
	willy@infradead.org,
	shakeel.butt@linux.dev,
	usama.arif@linux.dev,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	mhocko@suse.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com
Cc: linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH] mm/lruvec: trace LRU add drains and drain-all queuing
Date: Mon,  8 Jun 2026 21:11:56 -0700
Message-ID: <20260609041156.31127-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 7ED8040005
X-Rspam-User: 
X-Stat-Signature: h36uz3kte4unuyggpxcd1urwud6b8t84
X-Rspamd-Server: rspam09
X-HE-Tag: 1780978363-437643
X-HE-Meta: U2FsdGVkX1+20oN0XT3KMlOLXiGNosRMPdzh9BRMQVw1KCOIcRDtzqk9JJNKXWFpLUFdp+KyQErX9i8mvK85SJaSJU5SQQqDoFTAaSltanUvH9pYj0o0AgD18+GnnYlcMvFDLG/l4YQao+ozJsBvqYMIjegioob1nn8ESZvT2K74RjTswpxtInJ0jJY/RAX9KC6eA8sUK9XmoJ8k5vImDzjVhUxte46pqABdvTqXTKqUeLiEyaN0wNa6ku71FGAe2K8CfspETYN/3Fbwgrx5j5xhZukxPFgue2cT++kksEy0+XH06ASzVc7pF6tcly8AHMwqkm8L7IZLcjgoE/CJBkY953KU1szb73eUOL/5roJf7wInaa1kyw4i6WN7OwZ+UaK3Q5KV+GsD8uSRfKhSA6TPgdtVtyvyfW3Bwv/9wNjvyWws08B5EJsrn7bXMoNLgS/xWSxEC8Tx3nWqIKb4KeLYSCiua+twKlEDTkOzI9pdyOQdnSGO5tefr+wyxTEW2ptBZbwSOw0wGrRYpIrJ6fnBwHbmA+AbfiwxaQt1VHQMyQWw20K9f1lWbJDkvXgZfY1qSf3DDFDsaC6C5nzOuQyhOHMw4DVOKDQ8oAR3gNp6J7Z9hx+P0ctIZcAxIARVFMO2H909nBW+I5QLqhLzU1SsGNLOijRg9uLXv8RJUzP3SItrFm2H/v2IJ03wGDjEnRDIXmbUb5FNXYKaHjk4mqLxVT3JqcHHL9yoD1m1T5ICL8nFYP52W0qKXapSAQLfrEhsHjW4wZPP/INv5E23iVQgs2RTcj2KEjvZtIlc9Rm+gjnFP8AWmwZydm5D3gMrUGA9Rg2QMoQg031UVL4V93gwoTajsu7mymyoY7IQvaGC3oKMmREmaBh22awic3bW6nw5CPZAvPZNNse9+wf9eDxZbB4tVtBJrItx919IsELRPQwFz7GoyWaXsEMJhTmMTS6tfigNWKbrTg/zB68
 dzcLunYS
 NL77sxJL31rmTYLwfMlOPYJ6UULGHoJQ9eGt33jfpSLfL6hdzOH+aTEwPAjb9lx0x7lDLIyiXmE7S1RxmGjcQA9u4n55CYPZyAc452F8jf2cf2E8mTmdvfNIGXtXvN93miw7nykQxdP1Slp2oXwbfIK6OiBZgF5WXCr3kZx3HQT5zKt3hl0YhspdYTtA4mMJhDQMo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

LRU add batches can be drained before they reach capacity. This can be a
source of LRU lock contention, but it is not currently possible to
attribute these drains to callers with existing tracepoints.

Add mm_lru_add_drain to report the CPU and lru_add batch count when an
lru_add batch is drained. This allows tracing to distinguish full drains
from partial drains and attribute them to the calling stack.

Add mm_lru_drain_all_queue to report when lru_add_drain_all() queues
per-CPU drain work. This captures the requester stack and target CPU for
remote drain work. The event is named as a drain-all queue event because
the queued work can be needed for batches other than lru_add.

Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
---
 include/trace/events/pagemap.h | 40 ++++++++++++++++++++++++++++++++++
 mm/swap.c                      |  6 ++++-
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/pagemap.h b/include/trace/events/pagemap.h
index 171524d3526d..ea8fc46bedb0 100644
--- a/include/trace/events/pagemap.h
+++ b/include/trace/events/pagemap.h
@@ -77,6 +77,46 @@ TRACE_EVENT(mm_lru_activate,
 	TP_printk("folio=%p pfn=0x%lx", __entry->folio, __entry->pfn)
 );
 
+TRACE_EVENT(mm_lru_add_drain,
+
+	TP_PROTO(int cpu, unsigned int nr),
+
+	TP_ARGS(cpu, nr),
+
+	TP_STRUCT__entry(
+		__field(int,		cpu	)
+		__field(unsigned int,	nr	)
+	),
+
+	TP_fast_assign(
+		__entry->cpu	= cpu;
+		__entry->nr	= nr;
+	),
+
+	TP_printk("cpu=%d nr=%u", __entry->cpu, __entry->nr)
+);
+
+TRACE_EVENT(mm_lru_drain_all_queue,
+
+	TP_PROTO(int target_cpu, bool force_all_cpus),
+
+	TP_ARGS(target_cpu, force_all_cpus),
+
+	TP_STRUCT__entry(
+		__field(int,	target_cpu	)
+		__field(bool,	force_all_cpus	)
+	),
+
+	TP_fast_assign(
+		__entry->target_cpu	= target_cpu;
+		__entry->force_all_cpus	= force_all_cpus;
+	),
+
+	TP_printk("target_cpu=%d force_all_cpus=%s",
+		__entry->target_cpu,
+		__entry->force_all_cpus ? "true" : "false")
+);
+
 #endif /* _TRACE_PAGEMAP_H */
 
 /* This part must be outside protection */
diff --git a/mm/swap.c b/mm/swap.c
index 588f50d8f1a8..c385b93582eb 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -694,9 +694,12 @@ void lru_add_drain_cpu(int cpu)
 {
 	struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
 	struct folio_batch *fbatch = &fbatches->lru_add;
+	unsigned int nr_folios_add = folio_batch_count(fbatch);
 
-	if (folio_batch_count(fbatch))
+	if (nr_folios_add) {
 		folio_batch_move_lru(fbatch, lru_add);
+		trace_mm_lru_add_drain(cpu, nr_folios_add);
+	}
 
 	fbatch = &fbatches->lru_move_tail;
 	/* Disabling interrupts below acts as a compiler barrier. */
@@ -928,6 +931,7 @@ static inline void __lru_add_drain_all(bool force_all_cpus)
 		if (cpu_needs_drain(cpu)) {
 			INIT_WORK(work, lru_add_drain_per_cpu);
 			queue_work_on(cpu, mm_percpu_wq, work);
+			trace_mm_lru_drain_all_queue(cpu, force_all_cpus);
 			__cpumask_set_cpu(cpu, &has_work);
 		}
 	}
-- 
2.54.0


