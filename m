Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96462CD98C5
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 19:53:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C05C6B0005; Wed, 10 Jun 2026 15:53:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9703E6B0088; Wed, 10 Jun 2026 15:53:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 886416B008C; Wed, 10 Jun 2026 15:53:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 789526B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:53:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CFBE6C1262
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 19:53:04 +0000 (UTC)
X-FDA: 84865051488.23.437B6CC
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf02.hostedemail.com (Postfix) with ESMTP id E4D668000B
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 19:53:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KIT1SxJv;
	spf=pass (imf02.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781121183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fFNM+csKuGsAi8zW+tua6hmsF6Jv56ZUXMuPVDdT++g=;
	b=GRsf6rKuJiU3z/Or30qv6MctWI5hpAh+5Bpn0NKvVG6KeyRSVepMRQI+mwRnWWSoSGCBei
	oGHylcOEW7/NNxYvgXdGpL8dDjqSsXZTZ2IYXvuOwV6x9VTd+KAzuj9+7ENQafK/oXP/iw
	+TA4SZtmop/MTzCRVgPq7AzSxrLpzVw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KIT1SxJv;
	spf=pass (imf02.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781121183;
	b=ka1LhFLD96nmjeR4aOYZCElcR+isz5tGRsSqKHU1Omr0QP4VCT9EMCKOWuZ9j3VWS7x3rG
	IbFBywE+RS1l5ItjIrkuOlD/BRjPHyVl48wbQZjMIpyL697yq7FeKAujonEI5Fr7fY6Wm0
	/jgNfecaakh4YxEeG7bE8LksVGqBgXw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781121180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fFNM+csKuGsAi8zW+tua6hmsF6Jv56ZUXMuPVDdT++g=;
	b=KIT1SxJvnnMM9esD4/wv1ZtvrkIc7so2MoZbLd8fD4HwqlXWLnTI1+chx03t1ehbZlvO7s
	Yb2l8RO/m2g+mbEg2u+yzJJ47onjz5+Z+eevu3UsW0VRqvjJ11JKxC5Wu+YlyBrOosrTTO
	hyNY3tLcrojL03mL86KA6EMszoCnHmQ=
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
Subject: [PATCH v3] mm/lruvec: trace LRU add drains and drain-all requests
Date: Wed, 10 Jun 2026 12:52:20 -0700
Message-ID: <20260610195220.12403-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E4D668000B
X-Stat-Signature: tep6awrc98rdmx6cqdbbzhqnprh88emf
X-Rspam-User: 
X-HE-Tag: 1781121182-606934
X-HE-Meta: U2FsdGVkX19sNr9CEz4LQlSZ5PVcV4mg9E3SUbnY+8O9o8177dchCBlZ0XAAMRtju6WUj0zXtc3Rco4mbdptRRwp7hd/xUKAjXfLTrFfpb5R4uE1CAwNWK9ICza7SKKEbixj1oeB9OGdGFzx5B0o0c6IYqDq9jf5+Ymn7+2BS90hrtnXllTw1oFBBdmxqXNsG3bA8OgBVf3WAPrXBHMcnDBhPLRgtfQ7cKICyxxfU8SaKQKEk8D76YAr6JozE5z2pZvkgyBCtCJmEQwCOPUtbciDRq27Fo/4RBbtaq7az2bPOwiQ+RKUalvss8aiBWF4KWLJdka8cuvM+my8c8eReqg4cokL3SYYpHtrF/X+bha7tz/cGO2oCgKeFJxxMjg9rnna+co+oEeAHFl9D7h3+JZ6EvX44a+SzQmZUBLgrhFjlYDrhtlYCs67FsPszJTCJ/jW9v8t904Gg/c4i50dc4wXfCgdw0xaAAeqUYDuKZBdDtqL+lcYTYJR3IbVTJJr2JErCOYWPOqe8I5Ug/qsGpif7bwt/vK1LTak7t1cJTbXKVgLG9L29M/2oTXBzWtaTnTppTkWqv31tyfh5iJ4x2dNEu8QHFdhtb68YBvFo6Ep0q+MuUNyipUUuXWVHfvho6DGdxVGxZxq9N0uKgRdq3t1Daj+Zw/p6HnrORmgXKM88z2/6A7U0cYRUMyFgdIF7dYiQac6K+zDIIUy8xy1SNBJNgHXgePz4wnJZ2VMNVm2d1SVFK49AgfREP8JesjfW/RqBxwHQ/RYHwcRy1ZzOTDuIjeszrWNmykPuaiiBTbws1xj25AdHXGu75nJS/wU7z5qObexiw48jd7BWOF0f0SAaNXaZAPiOD6QWFA54m5TbYbtjOMe8kmlgPxlRzawugfwF/dFlpZt9FIcVdaZirdmSw3lec+VCI4wDpVGmP2ynxtmTS7z9zBuF7rqR88iyFZfpiDRIV5gLc88ILU
 n4jIKXjx
 015Q+aL/do67/V+U4uLAA6W06BRu6k9yRGzj1jJxbByWPPOD48FAY6T2ieqdCu48/6ttVphpgh2jWTIsqm+r/eQiK/VV1ZU5ST3zYElF5F1x62wMS1RpcSyYjbmUB8XpFzyUwvthntUEH5HjyNoZHNVFNwjF+bWlabIHEsMJYHUQUSDl2VYpHiXNExPuZ/mtTSsKdEiqcNq/d3BE=
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

Add mm_lru_add_drain_all to capture callers of __lru_add_drain_all and
whether they set the force flag for all CPUs. The tracepoint resembles
the signature of the enclosing function, but is needed because of
potential inlining.

Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
---
 include/trace/events/pagemap.h | 37 ++++++++++++++++++++++++++++++++++
 mm/swap.c                      |  7 ++++++-
 2 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/pagemap.h b/include/trace/events/pagemap.h
index 171524d3526d..ff3da07ccb40 100644
--- a/include/trace/events/pagemap.h
+++ b/include/trace/events/pagemap.h
@@ -77,6 +77,43 @@ TRACE_EVENT(mm_lru_activate,
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
+TRACE_EVENT(mm_lru_add_drain_all,
+
+	TP_PROTO(bool force_all_cpus),
+
+	TP_ARGS(force_all_cpus),
+
+	TP_STRUCT__entry(
+		__field(bool,	force_all_cpus	)
+	),
+
+	TP_fast_assign(
+		__entry->force_all_cpus	= force_all_cpus;
+	),
+
+	TP_printk("force_all_cpus=%s",
+		__entry->force_all_cpus ? "true" : "false")
+);
+
 #endif /* _TRACE_PAGEMAP_H */
 
 /* This part must be outside protection */
diff --git a/mm/swap.c b/mm/swap.c
index 588f50d8f1a8..e14b7612f896 100644
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
@@ -869,6 +872,8 @@ static inline void __lru_add_drain_all(bool force_all_cpus)
 	if (WARN_ON(!mm_percpu_wq))
 		return;
 
+	trace_mm_lru_add_drain_all(force_all_cpus);
+
 	/*
 	 * Guarantee folio_batch counter stores visible by this CPU
 	 * are visible to other CPUs before loading the current drain
-- 
2.54.0


