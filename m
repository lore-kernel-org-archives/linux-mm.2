Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32352CD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 23:48:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68DF36B0005; Wed, 10 Jun 2026 19:48:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63EBE6B0088; Wed, 10 Jun 2026 19:48:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52DAC6B008C; Wed, 10 Jun 2026 19:48:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3EA206B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 19:48:35 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B9B3EC17ED
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:48:34 +0000 (UTC)
X-FDA: 84865644948.19.65C797E
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id 17737C0007
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:48:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=spFffeka;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781135313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VD+REWS2c4musML7b4GLOPUaBPQLj7UUXZPvizUGrS0=;
	b=4Dnk4+s4LIEGDsXEZ6p1L/dz3nn6q11YBxNgErQuRWyaLmUuQgg1H4pTOnvr4iVnbx5P9M
	EFTeF6C2ClSM/nfUV/II6ehYjRjUcatbTJIBR754HVfV1ev7hn6+vJ6n1MiJDWJFIERrBo
	tVndNjz+eprvcIzlg8EItJHUyq7UCLs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=spFffeka;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781135313;
	b=NFH5dJQLrHwclYZ648Pt/XtLSKNweWhXZS3UKwU3spl8tsdhywAzbFa2k3bIh1xKhcTJs7
	nQ7BcPjOY8/1Du56PuvBhC8UbU+XIBGFOwQa5Aa63xPSkDOgxhoQC7mq9xLDsMfTPvXUnC
	iOzja/hciJFHsCn/mXhamrQOd2Z7L0o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781135310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VD+REWS2c4musML7b4GLOPUaBPQLj7UUXZPvizUGrS0=;
	b=spFffekazjkqmDNp6yHGuellmOpBYaeh/eHvFUdl9wmedoJYjMh1XJI9OjXtllgbCMaM3I
	gFMk9Au1+OgRF8KOJ782m7UeSwwLad6EpeQ5Wy4gxwaIm1oKt5KmjtXPrZOn2O6j2owK+N
	LQ7ss6/xkKe1gAXmP2aIklOhWIZcsbs=
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
Subject: [PATCH v4] mm/lruvec: trace LRU add drains and drain-all requests
Date: Wed, 10 Jun 2026 16:48:08 -0700
Message-ID: <20260610234808.212397-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 6ezxi47we1a9d3hcasqpa4ar9bknfhs6
X-Rspamd-Queue-Id: 17737C0007
X-HE-Tag: 1781135312-182253
X-HE-Meta: U2FsdGVkX19bQ+Zta1A8KH9tm65uw+py7DgV/AaGEeXBMlbsqVMK0Rx22nHzSYJgmb9NbjMT7H2D1/S4cD22Z4lpFkraUJewNE6yJuJXmPCryn4wnyKxKNus9uIIr9VK2mPnPvf0DEf0OEy31GfOP+bOZvy3dniE9fonCxL5P/DaflqWzycPrAIrKtGEn+rkJn07K158iz3JS6TUsxyJlJNvafQclSPGsEaACJ2DJmoG5o9yP+Q0Me4YQV5mm9+BkRjTt4l/5+5i7eNY7RGP+hdfXcNG5UZ5f/iedk79VedIoWaAGqm9nSTfVHPO+eymVfc40OMTuwKP9hVR7roMh2j+EBagOeCDF0H5RwcnfCLZ1I2lgSc1lozqTefK5RU8yjrlfNpD+iPnTljxfZIZG3vHtDHalpxuxTAykEa8EyfMNBwSj2JU01VgXArMO7BI7dTAezXtQOMxs3/wclCoD95q5kNF8dDXrzJhdh5+MlzZeeVaT290RyJcgW5RMBH5/OwgkIy9dWq+RZmiV/zN+vh1cHAOUveJbwJOD+p7iRfEjBmXh3wpLh+1Yq3LqLUnDleG4Ynf7DSRjCgaRankTnNNIJChFOemjPyiOA9nye+d79nRUaiT6UJHexkpjeoGi9hDqGTVzS0ypoIsgBe+kFed+obd1BaFrpRcXGd2VnNziq1LkfDHdqFTyC0mXYw8eMrdtIjv+6OM3HdtgI7md1KqzEobtiOesp9Uny5LeeoXjlOi2VCoHlLfUyQPv8WtkfCMvdqybYNJla/LewGi5RivmyHEnL3YzHw1/r/wBmX55zbMYtDs9qfpXQs5nFZoxkyUzT5K4jrsfJH2l4Y1WwDD1VZK/iiaYv35BSEslulMeXMy0Qzs9BYKNQyJK5R7hwC/UWcPshuVqsXuBSGJZAjjA3pO6QAIfvdmshRMgSwuf6C/TTH7kHxLFvZJwRB0iyp1n25nc/eJ+VB6b95
 ELWwxbgo
 Y/2ghv52TYUiqAIWjc+2zEEUskKP1U7kraq/YzpP0uF3yg7Z2W9mhaglh1BJZEzcqhJNLliYDrV2v1UlIaClnMaG/evryLfd2FBcIpT1IKnpbqkfWNgFILUWzpj0OP9yBfgE3RNFQaGLAvbVz0GIqC2DSB6K6bqLTFHrCATPPECoRQfcoPivQgrMiWtgBbFsLKaIuI1Re5d+GkqVPD8kHXPDtY6LSQOVBdxTl
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
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
v4:
  - renamed nr_folio_add to nr_folios in lru_add_drain()
  - renamed nr to nr_folios in tracepoint for consistency

v3: https://lore.kernel.org/linux-mm/20260610195220.12403-1-jp.kobryn@linux.dev/
  - restored and renamed tracepoint in __lru_add_drain_all

v2: https://lore.kernel.org/linux-mm/20260609041156.31127-1-jp.kobryn@linux.dev/
  - removed mm_lru_drain_all tracepoint

v1: https://lore.kernel.org/linux-mm/20260609041156.31127-1-jp.kobryn@linux.dev/

 include/trace/events/pagemap.h | 37 ++++++++++++++++++++++++++++++++++
 mm/swap.c                      |  7 ++++++-
 2 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/pagemap.h b/include/trace/events/pagemap.h
index 171524d3526d..df6ac4d13dcf 100644
--- a/include/trace/events/pagemap.h
+++ b/include/trace/events/pagemap.h
@@ -77,6 +77,43 @@ TRACE_EVENT(mm_lru_activate,
 	TP_printk("folio=%p pfn=0x%lx", __entry->folio, __entry->pfn)
 );
 
+TRACE_EVENT(mm_lru_add_drain,
+
+	TP_PROTO(int cpu, unsigned int nr_folios),
+
+	TP_ARGS(cpu, nr_folios),
+
+	TP_STRUCT__entry(
+		__field(int,		cpu	)
+		__field(unsigned int,	nr_folios	)
+	),
+
+	TP_fast_assign(
+		__entry->cpu	= cpu;
+		__entry->nr_folios	= nr_folios;
+	),
+
+	TP_printk("cpu=%d nr_folios=%u", __entry->cpu, __entry->nr_folios)
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
index 588f50d8f1a8..b506fa912a93 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -694,9 +694,12 @@ void lru_add_drain_cpu(int cpu)
 {
 	struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
 	struct folio_batch *fbatch = &fbatches->lru_add;
+	unsigned int nr_folios = folio_batch_count(fbatch);
 
-	if (folio_batch_count(fbatch))
+	if (nr_folios) {
 		folio_batch_move_lru(fbatch, lru_add);
+		trace_mm_lru_add_drain(cpu, nr_folios);
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


