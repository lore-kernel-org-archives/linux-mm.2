Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D997DCD3426
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 12:39:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 497A16B008C; Sun,  3 May 2026 08:39:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 421146B0092; Sun,  3 May 2026 08:39:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E8AA6B0093; Sun,  3 May 2026 08:39:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 17C136B008C
	for <linux-mm@kvack.org>; Sun,  3 May 2026 08:39:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BFF8B120956
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:39:19 +0000 (UTC)
X-FDA: 84726064038.25.CC02BA3
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1F736140004
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:39:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf26.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777811957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nJb4oAeeiY+Wa5suj3OJJgnNoLom1IuA7LurQ1Q4BOI=;
	b=601vUUmnhY7zDYAhxP7s51lvja9CR6N50EncgrVQEY8XfRAfSgG0F9wRfenClxJMe3g+ZU
	BZ4XJK2H4fx+aD4gB4zQG4bovhgMMnb+6nb2sIIrUWz4J1LAaODsTGpN+Wb13y8zyCIEYN
	Qza++4YrLrhDFmFdANuEti5v8N/uxyc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777811957; a=rsa-sha256;
	cv=none;
	b=2Sv+ePCN/iAI3h1eg6LlKd4EyAR/zCdM9dqcEX5mrLD8YuKfOqmB1EmQFDtdy921wkAruv
	4L4qLm3QU0etA5hjJYECQMRpTq5NKy/xe90ZSxeqzWK52+BLlZ1q1UWIczP7RvkY2CzcsA
	Ew//3J0FZWVSNeU84e4PXo34Mm6HBM4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf26.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4g7kqP5Qkqz5B1Jb;
	Sun, 03 May 2026 20:39:13 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 643Cd9N1062142;
	Sun, 3 May 2026 20:39:09 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 3 May 2026 20:39:11 +0800 (CST)
X-Zmail-TransId: 2af969f741ef502-521d1
X-Mailer: Zmail v1.0
Message-ID: <20260503203911259NKHEr5gDy3PbvnSc077a7@zte.com.cn>
In-Reply-To: <20260503203538194jFwVGloy43M1F3sQGaFt7@zte.com.cn>
References: 20260503203538194jFwVGloy43M1F3sQGaFt7@zte.com.cn
Date: Sun, 3 May 2026 20:39:11 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <xu.xin16@zte.com.cn>, <akpm@linux-foundation.org>, <david@kernel.org>,
        <ljs@kernel.org>
Cc: <hughd@google.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <michel@lespinasse.org>
Subject: =?UTF-8?B?W1BBVENIIHY0IDEvNV0gbW0vcm1hcDogYWRkIHRyYWNlcG9pbnQgZm9yIHJtYXBfd2Fsaw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 643Cd9N1062142
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Sun, 03 May 2026 20:39:13 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69F741F1.000/4g7kqP5Qkqz5B1Jb
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1F736140004
X-Stat-Signature: xoisi9nmqxcbyhwn65cst1qisbo3tyfw
X-Rspam-User: 
X-HE-Tag: 1777811956-942081
X-HE-Meta: U2FsdGVkX1/CaLSk2HsYh6XDSG836u3WmpslXKtrpwJnWXvGt3oVJ/JQtpCEfNMqJRTKebil4f9LxxT/SWsbfDGYTv1Io+fB33YXbNll+fFZCjQmkNNGAPScB0zF3gK8lQggNoUyE5AaUBBfRNpS+t92Nboraj4OGqf8IMzcSBQhOa1XH1Ms9J1YSXFctcj/7jZEUHBv4bFHrBFzdBM63fIRK2LK6T9vy+A9hTG8vW9q0euUOn3U/JLKUZkO+0+KBg65vFwaN0v+r3momPrM7WAEnX5rU9PRJw+yglTAGFN357f1JFG2TlJhZBdwqhZEWHK2S6l9fOxz1X2xxkIEVNmfIMyjdYMd6H8Ks3NlcRsHYzM1JUxY/1jfPoIrK4peDq1Kf/kr0khBk6zUjc1yy+alPTILWvdU0X7bjvhDroYyDLV+Mp8LK9Pm7afCOq5wzwxy9X+ZGZhDi+9Jb9RxDeV/0nNmyMlxnCVeIRJohIY5UG2FufS/mfs9Z855hoAiEHrmzoXPJaPqyPyFC2B/aXsgN7KyMmh5+1uMNS5ICyW5ch1j1jMXInaKgJ6E3xM/aODG5mA7nE3mC919HMPa2ofqnMBGFS+2dI9NK7PSDMSeCMyq7V8rt0srCbdcnMl+/DPZdvNHfQz1BtH91UIzjoRS3wens/tHJHvWZaWBjSSw4lqyIwdtDFUko8zOH2gX//Mnd+aww0MXFUgHa1UCietJwhRwLaCOutR3EMWZY07an1R6+K1+6Jn24Lc40HZuyxVVMgQYNDeNcdN3W+pOhDt7+Bwy25SEVUVypa5rwE8xZ67kzYzqImmrLj+vTTkC4N9h+SHRzWJ9vgyENOhJ8pkBA9Du0tqRHtYHF/jwCjqdyNaSoik/wZkEusaR4L6HM2MHf5Hx270xEtiJSSAOo+SfvrR5zTIn8ykJp9ubyHm+hQtn9QDJmr+bZiFONBFBWWCH4nH3bPVtq0Gyn4o
 PkXT9kz/
 8lPJ3DnuPOODLauY22Giww2V86hSul35bmA8olpCkBivCncaPotw88BfftbDy55nw6+/bu17CAhF/bMslk6dbgmiO32j9um1eHM+CLTFP4g3hwU0UxeJ4256K+8fqA+CS/fX3t9ba6F/oEm0UPwgaOUTi+MA1mfgiwVYys/0zfoy8G29InNrx3HmpkcYnj6P9o/6bq43A2za4PI0+Dqv1ahbcKzBIYEisPlFO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

Add a new tracepoint rmap_walk in mm/rmap.c to monitor reverse mapping
traversal. The tracepoint records the duration (in nanoseconds), the
type of the folio (KSM, anonymous, or file-backed), and the addresses
of the folio and rmap_walk_control structures. The type determination
is performed inside the tracepoint to keep the function itself
lightweight.

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
rmap-215     [001] .....   692.237079: rmap_walk: folio=000000000029ddcb rwc=00000000dac4cda0 duration_ns=828682 page_type=ksm locked=false
rmap-215     [001] .....   692.239480: rmap_walk: folio=0000000092a21fd3 rwc=00000000986376ff duration_ns=905966 page_type=ksm locked=false
rmap-230     [003] .....   692.583619: rmap_walk: folio=0000000037a237b6 rwc=0000000080fbbb0a duration_ns=107892 page_type=ksm locked=false
rmap-230     [003] .....   692.584104: rmap_walk: folio=0000000031bdbf8b rwc=00000000b39c973a duration_ns=330886 page_type=ksm locked=false
rmap-244     [003] .....   692.708706: rmap_walk: folio=000000009105fa6b rwc=0000000037d46cd7 duration_ns=987826 page_type=file locked=false
rmap-244     [003] .....   692.709198: rmap_walk: folio=000000009105fa6b rwc=0000000093942e2c duration_ns=161733 page_type=file locked=false
rmap-244     [003] .....   692.709606: rmap_walk: folio=000000009105fa6b rwc=0000000037d46cd7 duration_ns=54428 page_type=file locked=false
rmap-244     [003] .....   692.709658: rmap_walk: folio=000000009105fa6b rwc=0000000093942e2c duration_ns=27192 page_type=file locked=false

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 include/trace/events/rmap.h | 49 +++++++++++++++++++++++++++++++++++++
 mm/rmap.c                   | 14 +++++++++++
 2 files changed, 63 insertions(+)
 create mode 100644 include/trace/events/rmap.h

diff --git a/include/trace/events/rmap.h b/include/trace/events/rmap.h
new file mode 100644
index 000000000000..987fa204d65d
--- /dev/null
+++ b/include/trace/events/rmap.h
@@ -0,0 +1,49 @@
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
+TRACE_EVENT(rmap_walk,
+
+	TP_PROTO(struct folio *folio, struct rmap_walk_control *rwc, u64 duration_ns, bool locked),
+
+	TP_ARGS(folio, rwc, duration_ns, locked),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, folio_addr)
+		__field(unsigned long, rwc_addr)
+		__field(u64, duration_ns)
+		__string(page_type, GET_RMAP_PAGE_TYPE(folio))
+		__field(bool, locked)
+	),
+
+	TP_fast_assign(
+		__entry->folio_addr = (unsigned long)folio;
+		__entry->rwc_addr = (unsigned long)rwc;
+		__entry->duration_ns = duration_ns;
+		__assign_str(page_type);
+		__entry->locked = locked;
+	),
+
+	TP_printk("folio=%p rwc=%p duration_ns=%llu page_type=%s locked=%s",
+		(void *)(unsigned long)__entry->folio_addr,
+		(void *)(unsigned long)__entry->rwc_addr,
+		__entry->duration_ns,
+		__get_str(page_type),
+		__entry->locked ? "true" : "false")
+);
+
+
+
+#endif /* _TRACE_RMAP_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/mm/rmap.c b/mm/rmap.c
index 78b7fb5f367c..14bf8483f38b 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -75,11 +75,13 @@
 #include <linux/userfaultfd_k.h>
 #include <linux/mm_inline.h>
 #include <linux/oom.h>
+#include <linux/sched/clock.h>

 #include <asm/tlb.h>

 #define CREATE_TRACE_POINTS
 #include <trace/events/migrate.h>
+#include <trace/events/rmap.h>

 #include "internal.h"
 #include "swap.h"
@@ -3098,23 +3100,35 @@ static void rmap_walk_file(struct folio *folio,

 void rmap_walk(struct folio *folio, struct rmap_walk_control *rwc)
 {
+	u64 ts_start, delta_ns;
+	ts_start = local_clock();
+
 	if (unlikely(folio_test_ksm(folio)))
 		rmap_walk_ksm(folio, rwc);
 	else if (folio_test_anon(folio))
 		rmap_walk_anon(folio, rwc, false);
 	else
 		rmap_walk_file(folio, rwc, false);
+
+	delta_ns = local_clock() - ts_start;
+	trace_rmap_walk(folio, rwc, delta_ns, false);
 }

 /* Like rmap_walk, but caller holds relevant rmap lock */
 void rmap_walk_locked(struct folio *folio, struct rmap_walk_control *rwc)
 {
+	u64 ts_start, delta_ns;
+	ts_start = local_clock();
+
 	/* no ksm support for now */
 	VM_BUG_ON_FOLIO(folio_test_ksm(folio), folio);
 	if (folio_test_anon(folio))
 		rmap_walk_anon(folio, rwc, true);
 	else
 		rmap_walk_file(folio, rwc, true);
+
+	delta_ns = local_clock() - ts_start;
+	trace_rmap_walk(folio, rwc, delta_ns, true);
 }

 #ifdef CONFIG_HUGETLB_PAGE
-- 
2.25.1

