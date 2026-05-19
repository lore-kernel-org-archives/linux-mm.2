Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ADC6CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 14:09:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C10736B008C; Tue, 19 May 2026 10:09:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE7E46B0095; Tue, 19 May 2026 10:09:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B249A6B0096; Tue, 19 May 2026 10:09:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A0FA36B008C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 10:09:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 439E5C1AFE
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:09:22 +0000 (UTC)
X-FDA: 84784351764.24.848C706
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf03.hostedemail.com (Postfix) with ESMTP id CE5DA2001B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:09:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf03.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779199760; a=rsa-sha256;
	cv=none;
	b=j+E/9McTzI/5WXjkQb0PogPKYoiILw4KtmiytpYOX0D3nqSe72RoyqWP9l8pXzJI1zyDdP
	Mdq61o021Tw+ertE8Hgn++G+e3mFoE1LrfqS5OyHl0MEof984SMBc0lyADZtytWYTzpV/2
	CsaM1YnoovZm7zLd5qepqHY+ESsdcuI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf03.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779199760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UnGjdCnjx9YzQxsRRx+2lUuPw0w/VsCSIDAdcKo/h6A=;
	b=2SqaDYPRq+4pu3GHB/lg/yW3XVg/gKhGdNgRrJxmBZa9Iw5EBBjCTba93FLaTBu2NgO6Ia
	4wHMeaeSA6Ub6nsZMzSdDRLl/g9KjqLIPt7YF+a0Yw8vYE+AjAHiJW3B0NWD9J2QnY6jJZ
	fFahRBpZoH8HN8qc9bdFf4kUIPg2VEE=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gKc3w6sNvz8Xrkn;
	Tue, 19 May 2026 22:09:16 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 64JE97kl056524;
	Tue, 19 May 2026 22:09:07 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 19 May 2026 22:09:09 +0800 (CST)
X-Zmail-TransId: 2afc6a0c6f055d7-efb5a
X-Mailer: Zmail v1.0
Message-ID: <20260519220909868loJhTdEdfN7gGPtr_wH-y@zte.com.cn>
In-Reply-To: <20260519220536792dMIKRMurt3vZ5lXC5pwh8@zte.com.cn>
References: 20260519220536792dMIKRMurt3vZ5lXC5pwh8@zte.com.cn
Date: Tue, 19 May 2026 22:09:09 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>
Cc: <hughd@google.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <michel@lespinasse.org>, <corbet@lwn.net>, <wang.yaxin@zte.com.cn>,
        <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHY1IDEvNV0gbW0vcm1hcDogYWRkIHRyYWNlcG9pbnQgZm9yIHJtYXBfd2Fsaw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 64JE97kl056524
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Tue, 19 May 2026 22:09:16 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A0C6F0C.000/4gKc3w6sNvz8Xrkn
X-Stat-Signature: 7a7g4chn95ypgn4y1myad45uatcrxe9b
X-Rspam-User: 
X-Rspamd-Queue-Id: CE5DA2001B
X-Rspamd-Server: rspam07
X-HE-Tag: 1779199759-461776
X-HE-Meta: U2FsdGVkX1+95mVpVz5U9BsfKBn3ZqrvCndiCTVtBu9jRLAT87zK6jJU0qhDAHqWAnVTArnoRG52vqz+edtbJnKdnXpz92BLDzn3rIxK+HNRX5s4Njd0x3pCi4dmP4PeineNV46BrRtQd8ff9CnzuPGwDPkAMmomxDwDfOQbqgaQI3EXbzjBCiNL/8PlVFpJw2qSiSd9bIvbJA3FGmI0uICEQ5utlsDmONhcS76pSccFuzhM5X0DpVLadCWVNeRIjV5rUB6D6fwdNE3oXFRUfe7RAsJDNRZbmXU9uTwEMiX/eyLPx84g1jDmK4N9pk6iOgQW2BWOEjAsguJRn4N3x5ptTmxGcyxF2cnu/FHSV1nLJrrRiQrd9qHq8uEwxFDHc8RsceHNINEnhv+lzeepqcUoCm8KagOYDy2A1y32sWwUpHjdK0FpCChxFBafKlfb0MJWWYGgKl6T2qQd0fEkq58HuJg3uZfdbWJRVfHqR12FuX8YfRZWQHiYqQ8Wz4TcsrrXlkbKHnWpFtpH8OuYv1y8GGv3Ib0uBvUZO+3pdrVpWYC8c9VKc0jX2CzjVm1zWmfMDFUkRkD5WfA6iGJptNDuOFwY7FscDTSiiyx4XX12ORd7E8o7aiaAeJXTv1xQtM5Y2GWUQdG8lrvw4w9Of99rV2gYklqAbW5igDO5oXJzRGG4suC4aIhSWffirbZ3VZnrCj5gzhb5+e7qrCxqOizyTsW08K+LKzO+ouutvulm6fYvSZ5mBbVkLlYzxi1ZJj0clnc5w5mmgfTfyTQXUa8eqxtRy0HYXvA2Cv84d+b5biEmP1wMWnfmcJ5EC12dySLL0n9mLOsvYsxZcyyHVBTVP1zAEG1BBzlMCwtpQczAQ1/5Vmke/K53yHlA5FTX0NWcc2ivjuG7q6NgE58Fra7oVWRoe/svZ7K8Vdw7t0+rcmrv7T1BTNIoZVMgTXV1juxjlPKgRSb+hGXAZ+A
 SKXPzQEs
 b6YZizyLKXiZcDqDK/2/IK/gywAFPxgGpfZd53G6aJs4XQYdKDCNBKH66HJVTLyo8HfCXlXWpDXVSc5yvvW7HCJqXoYt9YbU84sPbLuYkK1bl3aCoXeE910NpAoDsEOLt/bCvESw8ex7MvzqDGKA2u6M72W9fzQ4skhPuv7/ZX0BH+yNkRHWHsDYKWMLxcZ62bEpwKxi3Yyn3HYz5yWnhhSwEsoobKukv4Wf75hiEUEwKtv5uuQyHNCThm9WjEk209SfmgLh17TyeZPU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

Add trace_rmap_walk_start() and trace_rmap_walk_end() to bracket
reverse mapping walks.  Unlike manual clock sampling, these
tracepoints record no timestamp; latency can be computed offline
by tools (e.g., perf, trace-cmd) using the event timestamps.

When tracepoints are disabled, the only cost is a static branch
check (no clock read, no duration calculation), making them
suitable for production use.

The information (folio type, locked state) helps diagnose
performance issues in KSM, anonymous, and file-backed rmap walks.

'# cat /sys/kernel/tracing/trace
'# tracer: nop
'#
'# entries-in-buffer/entries-written: 408/408   #P:4
'#
'#                     _-----=> irqs-off/BH-disabled
'#                    / _----=> need-resched
'#                   | / _---=> hardirq/softirq
'#                   || / _--=> preempt-depth
'#                   ||| / _-=> migrate-disable
'#                   |||| /     delay
'#TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
'#   | |         |   |||||     |         |
rmap-215     [002] .....   163.530676: rmap_walk_start: folio=00000000ae4eb941 rwc=0000000030d943e6 page_type=ksm locked=false
rmap-215     [002] .....   163.532446: rmap_walk_end: folio=00000000ae4eb941 rwc=0000000030d943e6 page_type=ksm locked=false
rmap-215     [002] .....   163.533201: rmap_walk_start: folio=00000000ae4eb941 rwc=000000003c9e8513 page_type=ksm locked=false
rmap-215     [002] .....   163.533597: rmap_walk_end: folio=00000000ae4eb941 rwc=000000003c9e8513 page_type=ksm locked=false
rmap-215     [002] .....   163.533899: rmap_walk_start: folio=00000000ae4eb941 rwc=0000000030d943e6 page_type=ksm locked=false
rmap-215     [002] .....   163.534053: rmap_walk_end: folio=00000000ae4eb941 rwc=0000000030d943e6 page_type=ksm locked=false

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 include/trace/events/rmap.h | 73 +++++++++++++++++++++++++++++++++++++
 mm/rmap.c                   |  9 +++++
 2 files changed, 82 insertions(+)
 create mode 100644 include/trace/events/rmap.h

diff --git a/include/trace/events/rmap.h b/include/trace/events/rmap.h
new file mode 100644
index 000000000000..275e77849698
--- /dev/null
+++ b/include/trace/events/rmap.h
@@ -0,0 +1,73 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM rmap
+
+#if !defined(_TRACE_RMAP_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_RMAP_H
+
+#include <linux/tracepoint.h>
+#include <linux/rmap.h>
+
+#define GET_RMAP_PAGE_TYPE(folio) (folio_test_ksm(folio) ? "ksm" : \
+		(folio_test_anon(folio) ? "anon" : "file"))
+
+TRACE_EVENT(rmap_walk_start,
+
+	TP_PROTO(struct folio *folio, struct rmap_walk_control *rwc, bool locked),
+
+	TP_ARGS(folio, rwc, locked),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, folio_addr)
+		__field(unsigned long, rwc_addr)
+		__string(page_type, GET_RMAP_PAGE_TYPE(folio))
+		__field(bool, locked)
+	),
+
+	TP_fast_assign(
+		__entry->folio_addr = (unsigned long)folio;
+		__entry->rwc_addr = (unsigned long)rwc;
+		__assign_str(page_type);
+		__entry->locked = locked;
+	),
+
+	TP_printk("folio=%p rwc=%p page_type=%s locked=%s",
+		(void *)(unsigned long)__entry->folio_addr,
+		(void *)(unsigned long)__entry->rwc_addr,
+		__get_str(page_type),
+		__entry->locked ? "true" : "false")
+);
+
+TRACE_EVENT(rmap_walk_end,
+
+	TP_PROTO(struct folio *folio, struct rmap_walk_control *rwc, bool locked),
+
+	TP_ARGS(folio, rwc, locked),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, folio_addr)
+		__field(unsigned long, rwc_addr)
+		__string(page_type, GET_RMAP_PAGE_TYPE(folio))
+		__field(bool, locked)
+	),
+
+	TP_fast_assign(
+		__entry->folio_addr = (unsigned long)folio;
+		__entry->rwc_addr = (unsigned long)rwc;
+		__assign_str(page_type);
+		__entry->locked = locked;
+	),
+
+	TP_printk("folio=%p rwc=%p page_type=%s locked=%s",
+		(void *)(unsigned long)__entry->folio_addr,
+		(void *)(unsigned long)__entry->rwc_addr,
+		__get_str(page_type),
+		__entry->locked ? "true" : "false")
+);
+
+
+#endif /* _TRACE_RMAP_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
+
diff --git a/mm/rmap.c b/mm/rmap.c
index 78b7fb5f367c..52f795f768e1 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -80,6 +80,7 @@

 #define CREATE_TRACE_POINTS
 #include <trace/events/migrate.h>
+#include <trace/events/rmap.h>

 #include "internal.h"
 #include "swap.h"
@@ -3098,23 +3099,31 @@ static void rmap_walk_file(struct folio *folio,

 void rmap_walk(struct folio *folio, struct rmap_walk_control *rwc)
 {
+	trace_rmap_walk_start(folio, rwc, false);
+
 	if (unlikely(folio_test_ksm(folio)))
 		rmap_walk_ksm(folio, rwc);
 	else if (folio_test_anon(folio))
 		rmap_walk_anon(folio, rwc, false);
 	else
 		rmap_walk_file(folio, rwc, false);
+
+	trace_rmap_walk_end(folio, rwc, false);
 }

 /* Like rmap_walk, but caller holds relevant rmap lock */
 void rmap_walk_locked(struct folio *folio, struct rmap_walk_control *rwc)
 {
+	trace_rmap_walk_start(folio, rwc, true);
+
 	/* no ksm support for now */
 	VM_BUG_ON_FOLIO(folio_test_ksm(folio), folio);
 	if (folio_test_anon(folio))
 		rmap_walk_anon(folio, rwc, true);
 	else
 		rmap_walk_file(folio, rwc, true);
+
+	trace_rmap_walk_end(folio, rwc, true);
 }

 #ifdef CONFIG_HUGETLB_PAGE
-- 
2.25.1

