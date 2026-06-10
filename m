Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48AEECD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 00:29:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4F5B6B00AB; Tue,  9 Jun 2026 20:29:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B26FE6B00AD; Tue,  9 Jun 2026 20:29:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3CC36B00AE; Tue,  9 Jun 2026 20:29:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93D3B6B00AB
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:29:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 420731C3161
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:29:44 +0000 (UTC)
X-FDA: 84862119888.08.277F0D6
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf18.hostedemail.com (Postfix) with ESMTP id 483051C0008
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:29:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k2Ykltry;
	spf=pass (imf18.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781051382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=n6nRitLA5dXPldaPWFJdkV5WToaQRP9IZnc/9WgQeWE=;
	b=lX70zsx6HCEbSCJwyyMSmxS69qvYkCTGYRg6O8nvool5ta+gJFcSPqZ1jTXL8lno+6dweE
	2TV34IaTFMNv7Cphhxt9vgWqML/Y543QupSodMPe+AkJN4b3QSwUzIzAkWcgJaHvASfmF2
	HkMF2gOwzE5CV9xvCJwO5wGt5UnxEjg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k2Ykltry;
	spf=pass (imf18.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781051382;
	b=ETOrXfrs6GVJlfDI+RQ8uOMyR2PNZqYZbjMUV1uICJRUnLMj6oZnCSS54EpEKGoDQGWjo2
	dCGF9eJZDkZJu5AzA0S9vad8MmxYH4cvkeuvwu6ggbFZMAox4TMZfItSAKhTeSy6iCOiNb
	qjGuap50my7MQ/tT1Z/SUSoQKWANo+U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781051379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=n6nRitLA5dXPldaPWFJdkV5WToaQRP9IZnc/9WgQeWE=;
	b=k2YkltryaSxG3AYCOSdIpuXULa3fQ8OUMTERCHllVLhHajWA21GfAKY3mmj4y1OIY0Ll+u
	slAp1PHk4pDzgon8/6fFc2Z1xLfIvaOIPZ0bj/wjj8VBODn21z+8Aod9n4xk4kZzMLMlFT
	NhnyfLkdTaiG95Q8ZhTlOO10X6Mih8o=
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
Subject: [PATCH v2] mm/lruvec: trace LRU add drains
Date: Tue,  9 Jun 2026 17:29:19 -0700
Message-ID: <20260610002919.14102-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 483051C0008
X-Stat-Signature: fcin4fr4mfghtcdpz4bkd77sagfkj6fs
X-Rspam-User: 
X-HE-Tag: 1781051382-742676
X-HE-Meta: U2FsdGVkX1+KlloEpK8UxZ4UpXqTlLdbCbikzu6Zxx3YsW2HNc4wHxNHvDD2GLJPeG5C701HqAn4UsBRfYeW/iPnjR3CfqpSTu7Yg78WiucZMThitwX/FEbL9n9CpwttP5j1Y03pzY+JjYX97SMH7yEIdKIl2/eBNlrEPeW6b055IehncpkIY4WhPGW2v3Zlk9b4Zypk+IxwWI/F2+vP1Ngn497CZJoe2W4wXbZ/QH1Hagqf9tPYmNPGPIhd/QPYrfyfLqjFvfv+XKmDHKLxh/J/SRNqFamtOB62du+Fe6SSiR8A5Rt/M8es3XGWU9T32q9geNaDzZ0BECreJ7xZY/k2MrQF3jxng/Ff0DWuHGg1GVza3YXH7XrKELHiZIUe6amHyFEyRKXT8xPfIAK5dui5Icki3OrNw51c0KhkCwmpDgNNpu4hDXNlzKu+a3/ZEQFYJZppUidephyHjGWkjDlj9cG66K/XzvhUjbnKbneBeaTlRnwiHMtaqerPdbCEaoAFIoR/TczGnsBoQdj6fn5X6SbICddDEuA3X0o8q5+sic4UowshdPhJ1bXyRnsLKfsyx3q79TmEaC8jdXlGn15R/S9H52Yxcw9X2mb8iH4J5VgW6jCO6czb0iM+OOUnSBxqTsech1Z56gFfk+6O81e4p1u443DXyIT2nOK0ips/wM0hyPuPGSofzyqn/tyjKcAJ+8zEV9pZzXGqGSzDP4yiO9JFdgGgoIFn1DqQrwvyu+gj5OW5A6fny7mSTBmk/ymox3jb9YZ8E/4it8iRa0bUNxR7jwJqpe/C5AZfQZNQUzfQUtWavJs+fXfz8SsMO9sdr280IFr9wSt6bPHsnvvTrEDuOu9sroPYDj1rQlAOTZqg7p3WlAZRKiB8ktrL5CP5ICXaHsYZuW/XlmWLNv/teWNck2BUnhT0ec1UVTz9NNc6FOx9BgGu4a+BvHGNQjKI4sreQ+cz0hU6qGZ
 gFxUBrPd
 5rqvAhAfVeAOpBi8gg96rDpyLl8uiOUQlh7Oucyx33+bykCuEm9MxrpLLhemDZZdaFSJEu48SiHz/cu4uaV61ZZ48RdEzdFk5j8Ot3if8xpK1ZVB5IXefbm3SQY/7NrCZQEU7gb1Iv3UgVHsq6D4DxSUEuLDZ4TMxjz5LQY1zvXJhEd9F4e7x1QMSTemkWBNqaMhqEXN81r2TFYw/X8kluU6iGqMGkjLvNQmF
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

Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
---
v2:
  - removed mm_lru_drain_all tracepoint

v1: https://lore.kernel.org/linux-mm/20260609041156.31127-1-jp.kobryn@linux.dev/

 include/trace/events/pagemap.h | 19 +++++++++++++++++++
 mm/swap.c                      |  5 ++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/pagemap.h b/include/trace/events/pagemap.h
index 171524d3526d..fc28745507be 100644
--- a/include/trace/events/pagemap.h
+++ b/include/trace/events/pagemap.h
@@ -77,6 +77,25 @@ TRACE_EVENT(mm_lru_activate,
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
 #endif /* _TRACE_PAGEMAP_H */
 
 /* This part must be outside protection */
diff --git a/mm/swap.c b/mm/swap.c
index 588f50d8f1a8..8fd6808bfc6e 100644
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
-- 
2.54.0


