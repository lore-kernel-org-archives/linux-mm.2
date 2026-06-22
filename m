Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0C05CDB476
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 18:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34B766B00A8; Mon, 22 Jun 2026 14:52:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2883E6B00A9; Mon, 22 Jun 2026 14:52:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14F246B00AA; Mon, 22 Jun 2026 14:52:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DEF236B00A8
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:52:02 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BCDA516549E
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:51:56 +0000 (UTC)
X-FDA: 84908443032.29.05EC536
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id 81C2CA0002
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:51:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LQ5UmGuH;
	spf=pass (imf15.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782154315;
	b=U6lr1ddbRAucrg1NmDOvADqjCNIkrkFRbi2BPLkX3XrEPQ0kuS9/xlO6rI/cGjqTs+OsWs
	09PwsKZvJMI+63ZaUuv6WqZHFxHxB4WDb0m7hol9NgoiuMjAMRj5Tz2mfM4st+7/Dkx8s1
	QguXk/Ft/mnLepdbEvzuL/lIAOAOSQE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782154315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=P2FntB3QrBOJu+PV6zq+MqWBctOWxjgmfPOSEN+T8fQ=;
	b=rffo6t2fMi1H82arlHOcIbP1kjmGg4/fpb+wrL98zmgLdDuDwb1+Hh2mAJmKal0izCz1yf
	OXJV5YMV51cW0aCDF9jkoEvIYP0pKYYtj5JmNkDVH4iaDmayeuSLPr4aLRjLbe8RM58bsl
	vBFHhqbnMRpiuiCvGIRd+m6pp0lH+GY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LQ5UmGuH;
	spf=pass (imf15.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782154311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=P2FntB3QrBOJu+PV6zq+MqWBctOWxjgmfPOSEN+T8fQ=;
	b=LQ5UmGuHzFWHqd4GHfy0JN96cJGwdY/deLgob6tnNEhffHniusw8d7dZWRP4O+D7ueXhqo
	saP0kl8mWM9szfoXk82w7rja1AKDf7JQnoge7BEACXrcmH6IDhOC6XNsL11Sh7ipaYm+9p
	Qo+lpUJuO2M0jG8xOjGMd2NExehc6rI=
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
Subject: [PATCH v5] mm/lruvec: trace LRU add drains and drain-all requests
Date: Mon, 22 Jun 2026 11:51:27 -0700
Message-ID: <20260622185127.24579-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 81C2CA0002
X-Stat-Signature: smexqr7md73hynquxpkkh6bqo6fq69o4
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782154313-554182
X-HE-Meta: U2FsdGVkX19fJ0JzHogQFOp2xZorXnV3xtZKSSrWad+rtcba0U9XWuZdIcQ5HHZucU3uSiaqV3IVPOli3wI2vOaQ1Jg1D8CcSqdMoRa6crWpfXk3P6suxpfnNj0MirP0sOWva3UQRqujHBxGjEHRFsWzJkGomkmC+kAQn62FzKs5WoAii4M/zFzTiUdAGrYT4WqS4fZDJd8ujc07HAFa1T48rjKIXa4ngxw16SQy5qzpxdy5EWzoNpmMcZmYO7nkFcdjG8VP0iv2za8SOua397PZ3YJoRQp/C95Tj9qX1O5OmybOU4j903RZXOEq54oV+ifJKH5kvTLrdonuUGnlnGQqXEzuapzauMcMaXwfKqik+k/urXIz59eRq9OwTPY+z0vJLizQ9MiLpqJlvRvQxLqV4fQ8WuW5oB+PYd1Ov8Fbjhyn+ep6JHfibCLrH5JDxr3VhOHg5rW/ya46OIW9V8IuRxsA0aRdoUosac8LHRzkfXlVFLT+aKL0S7+TsQiZFI5pOwo+3wA5cXPyxFJdNLhkdrk2iMvlHZjeyYmBQVAKg7CC+UuIrE/WzoBN5q2pxWErfC6KrZkzCLWHkfwoJCKboYFCCutx+83Mr6reBiuU0Z7Egnwg+O5HHrJ4OmMx66IAB4NMBscLCyEZaaog1EhN1ygD1KjTXjLsYMk0c8z87WepRdEdhM/YxG09BKWRrA0NbLcnoRvk7op2S93BmTo6UGliqztder74OdpQsq/jOODKOESVv9cBizgPA9P9lk1EM1eZ//oPAxTa1M20kDP7q2QqbNQO092grNA5g+Dl/CxGeWqVR79m9f6uVHHxFaHrcz0woOOa823kJShBv2EDBS1LmqUruGYQW78+TEnp/+Toly9ZFZyDJCPXwLu3cDjVkAZOo/uRzifkojTewumS1R6mD0ykC90gUOxvxmzEIdXFzXseouBO0dB5OEcqgxrHQAiz1cWm3vlEeSJ
 +ODIGtDE
 SiqDD3RteeIqhvbkSCKdS3cR3AqJWjO6+1Ptkvk/iaE26qSc1WbqYrVNXei6fSkNzUXX6mBGHlemrhYcQKfSKs1smUcGxWIUHwNI+KeE3qQm30s3tIZsZcV/Ie2BwTpOPYbLDYVYFnly3kSnwXHRHhAW68BKDncNSkVXAwcoBN8GI4a0k7g4joH/37LZAcscTKRHjMmdJs3OiePBW37ggIHXQFQXIWhFLjutW
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

Note that DECLARE_TRACE() is used for these new trace hooks to avoid
creating a new trace event ABI.

Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
v5:
  - change from trace events to bare trace hooks

v4: https://lore.kernel.org/linux-mm/20260610234808.212397-1-jp.kobryn@linux.dev/
  - renamed nr_folio_add to nr_folios in lru_add_drain()
  - renamed nr to nr_folios in tracepoint for consistency

v3: https://lore.kernel.org/linux-mm/20260610195220.12403-1-jp.kobryn@linux.dev/
  - restored and renamed tracepoint in __lru_add_drain_all

v2: https://lore.kernel.org/linux-mm/20260609041156.31127-1-jp.kobryn@linux.dev/
  - removed mm_lru_drain_all tracepoint

v1: https://lore.kernel.org/linux-mm/20260609041156.31127-1-jp.kobryn@linux.dev/

 include/trace/events/pagemap.h | 8 ++++++++
 mm/swap.c                      | 7 ++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/pagemap.h b/include/trace/events/pagemap.h
index 171524d3526d..36c3a90f0acc 100644
--- a/include/trace/events/pagemap.h
+++ b/include/trace/events/pagemap.h
@@ -77,6 +77,14 @@ TRACE_EVENT(mm_lru_activate,
 	TP_printk("folio=%p pfn=0x%lx", __entry->folio, __entry->pfn)
 );
 
+DECLARE_TRACE(mm_lru_add_drain,
+	      TP_PROTO(int cpu, unsigned int nr_folios),
+	      TP_ARGS(cpu, nr_folios));
+
+DECLARE_TRACE(mm_lru_add_drain_all,
+	      TP_PROTO(bool force_all_cpus),
+	      TP_ARGS(force_all_cpus));
+
 #endif /* _TRACE_PAGEMAP_H */
 
 /* This part must be outside protection */
diff --git a/mm/swap.c b/mm/swap.c
index 588f50d8f1a8..460e56370b3c 100644
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
+		trace_mm_lru_add_drain_tp(cpu, nr_folios);
+	}
 
 	fbatch = &fbatches->lru_move_tail;
 	/* Disabling interrupts below acts as a compiler barrier. */
@@ -869,6 +872,8 @@ static inline void __lru_add_drain_all(bool force_all_cpus)
 	if (WARN_ON(!mm_percpu_wq))
 		return;
 
+	trace_mm_lru_add_drain_all_tp(force_all_cpus);
+
 	/*
 	 * Guarantee folio_batch counter stores visible by this CPU
 	 * are visible to other CPUs before loading the current drain
-- 
2.54.0


