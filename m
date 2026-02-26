Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C092EFD8FF8
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 18:27:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAFD76B0180; Thu, 26 Feb 2026 13:27:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6DB46B0183; Thu, 26 Feb 2026 13:27:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC72C6B0184; Thu, 26 Feb 2026 13:27:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B4F4F6B0180
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:27:10 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 86AF5160342
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:27:10 +0000 (UTC)
X-FDA: 84487439820.03.1CE6D86
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9FF83A0017
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:27:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=HtgDyNSQ;
	spf=pass (imf15.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772130428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0LKKlLe+YhKO7o329A7m73xvNfBWJnGt18tZ/iyWG2I=;
	b=J0M0atcB33M1zweALhY6YoGGdgjtOeu866VFGM8rGCFoJ/46yKoGNO8p5GJslmvcghoYCi
	ZWu4eqQly+QZOS19xHs1yZIEFJfinXS8qRAkZKIbOMYG3c0i8no7GoOkiUd8M7rspLhtGy
	Jxx/H/6RybQCxXEdLyEyj7z667ZCWx8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=HtgDyNSQ;
	spf=pass (imf15.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772130428; a=rsa-sha256;
	cv=none;
	b=nhV8TpIY7iID+mJYtdhMD5FxhBSrpklN3IDSI3xRV1nK67/5+Kdhz6cD2yznbWQ/NnGZKr
	8/WFa3FBV/1De2kQTpldDP+M8TudJMa30gFrTSZ+sa+yieZNkF0Eh0IYS/bc1UVrqGqiZm
	OYCM8Kf6Wne7RoSn/aUbDWnig9KTPj0=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 21AF8B2CE9;
	Thu, 26 Feb 2026 18:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772130416;
	bh=0LKKlLe+YhKO7o329A7m73xvNfBWJnGt18tZ/iyWG2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HtgDyNSQsc5OOYXt8Lu2WiYyqNLrSkEdLiAWO0FgQdJeGTG/vh2VHprW6CqmKoUzj
	 DMU76FNUcTKHR1QaJxMFnnpW6R4bxlYUjaRp5/OmHu+ykA5MFvRTsnTDPl164DtAdw
	 6HZohSwO1xzUmkYAc3QV6RRnpCgvY2XcVAV5piuc=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v3 5/5] mm: add tracepoints for zone lock
Date: Thu, 26 Feb 2026 18:26:22 +0000
Message-ID: <378089dd269249d3d7981fe10eb8b49ad551d353.1772129168.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772129168.git.d@ilvokhin.com>
References: <cover.1772129168.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9FF83A0017
X-Stat-Signature: 9ifdt9m96o3iskf96b3rqpkcukaxs73q
X-Rspam-User: 
X-HE-Tag: 1772130428-790216
X-HE-Meta: U2FsdGVkX18mYNxh7c7PVazlG1bAWKwqJFv9licI1cTr+fgjLL/MXJVFo+Tzw38eJ9yNF4dfpSur8kHTQ3Vv9ZSt76GHaTqGZan1YbDB+G+f4NKzHj0LGFP1nHA3x+TS13whOO5XkwG+/n4lNE7wQAONYaLqpUsgepQSg3Vus1cFHt2UbPZwDPUjxdOj3Ck6C5cE8HHB8ntAMZtLN2djp+DYObClhM5HSSQa2MII27zpF2sHUM85dvAbhbLf3TQ/fpznLMyVmANGHzHdn79s7whZ8OH/APrESqb+cnJT2WB6xX7E5lCHSI4EBSOmyfK6gRJnfYbnYpY1Sagqg++jPodZiMZsZ+YFAo0hntGFEqmRNBrUz8//yz/iw7iMReAiBTEKz63ttZScDG4JcLr7jerae1v0FDUa9ZAVlCRhso9gVuoh/a69IjxF25T9rnjDbeV+rT63SufQL1oFudXu/WA27sECO8duyo6cp6Vq24bE0gb/AP4OZTCxkUsSynyKuZTvan5r9Vkk9dX0fhij0Ph8N1K+z1jKc5wFclic9HB59qKQp/IARk4xNEcNcjaKu2j0z/ZkOZVeCRmosMeCpnx6clq9GNlj64pW3E18nxIjny0coU2F18qP0JI9yTx9n3CAk78+QWddG4w30uSVTgmwJzWLS7meyYwxPk37EkvpQx/ufUyrEMc3M+jGpDjOLR2sM7PU9ZdP0PNyPkT+otBxdcpJOTVLaGUq0JFPsTBS+kzy2/tO06mwmeVTp6YzjFu2Djzyef06f4LPJ6D6WKwKHVZi3Pxm2obvYL2HDKU4TOUJ2E9i3QBv6lRiCiSoZlq1+DdDG0iizUIG+o7kDHfvtOy3+ue10f3cIEv63khLD7oc9qiC+YVFgnSegD3jKri27Mehx236JvUe70V30Tw84Y5iRw+IQsu4EHS2R8BBihyWctduTxh/6nGk0OPJv5Vyhy2SlFBTElNrovr
 RNqILHO+
 ambNoC2duboG7Le9VZV5DQlw2eo6tjp9wZfm8qXyiK4Gi5gVUX3kqjcAohFbQda0gCtblSdTA3AfdLZKVQqFjnasJNl+GyBsON/n2wqmjQdD3CFHvTH/WkARQG4q4r68Kh9s1BwfylguFnX/YnUVEv3nTHZMLRntCraDOHEBuS71cMO9KOdfZJ963OQkz1uhag4qyliMt7M8xl3BSPZbGcsHhBK+iFAnGREkGi+bdRidJYNK+rmHvDP4FAlrL83x4Ah0wXCljh204HgnSXX+vjn4WFP/PY+dv0WxSN0MtyRqpocxGWUyHRudmFyDhUKvWsC4q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add tracepoint instrumentation to zone lock acquire/release operations
via the previously introduced wrappers.

The implementation follows the mmap_lock tracepoint pattern: a
lightweight inline helper checks whether the tracepoint is enabled and
calls into an out-of-line helper when tracing is active. When
CONFIG_TRACING is disabled, helpers compile to empty inline stubs.

The fast path is unaffected when tracing is disabled.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 MAINTAINERS                      |  2 +
 include/linux/zone_lock.h        | 64 +++++++++++++++++++++++++++++++-
 include/trace/events/zone_lock.h | 64 ++++++++++++++++++++++++++++++++
 mm/Makefile                      |  2 +-
 mm/zone_lock.c                   | 31 ++++++++++++++++
 5 files changed, 161 insertions(+), 2 deletions(-)
 create mode 100644 include/trace/events/zone_lock.h
 create mode 100644 mm/zone_lock.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 61e3d1f5bf43..b5aa2bb5d2ba 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16681,6 +16681,7 @@ F:	include/linux/ptdump.h
 F:	include/linux/vmpressure.h
 F:	include/linux/vmstat.h
 F:	include/linux/zone_lock.h
+F:	include/trace/events/zone_lock.h
 F:	kernel/fork.c
 F:	mm/Kconfig
 F:	mm/debug.c
@@ -16700,6 +16701,7 @@ F:	mm/sparse.c
 F:	mm/util.c
 F:	mm/vmpressure.c
 F:	mm/vmstat.c
+F:	mm/zone_lock.c
 N:	include/linux/page[-_]*
 
 MEMORY MANAGEMENT - EXECMEM
diff --git a/include/linux/zone_lock.h b/include/linux/zone_lock.h
index 5ce1aa38d500..f32ff0fae266 100644
--- a/include/linux/zone_lock.h
+++ b/include/linux/zone_lock.h
@@ -4,6 +4,53 @@
 
 #include <linux/mmzone.h>
 #include <linux/spinlock.h>
+#include <linux/tracepoint-defs.h>
+
+DECLARE_TRACEPOINT(zone_lock_start_locking);
+DECLARE_TRACEPOINT(zone_lock_acquire_returned);
+DECLARE_TRACEPOINT(zone_lock_released);
+
+#ifdef CONFIG_TRACING
+
+void __zone_lock_do_trace_start_locking(struct zone *zone);
+void __zone_lock_do_trace_acquire_returned(struct zone *zone, bool success);
+void __zone_lock_do_trace_released(struct zone *zone);
+
+static inline void __zone_lock_trace_start_locking(struct zone *zone)
+{
+	if (tracepoint_enabled(zone_lock_start_locking))
+		__zone_lock_do_trace_start_locking(zone);
+}
+
+static inline void __zone_lock_trace_acquire_returned(struct zone *zone,
+						      bool success)
+{
+	if (tracepoint_enabled(zone_lock_acquire_returned))
+		__zone_lock_do_trace_acquire_returned(zone, success);
+}
+
+static inline void __zone_lock_trace_released(struct zone *zone)
+{
+	if (tracepoint_enabled(zone_lock_released))
+		__zone_lock_do_trace_released(zone);
+}
+
+#else /* !CONFIG_TRACING */
+
+static inline void __zone_lock_trace_start_locking(struct zone *zone)
+{
+}
+
+static inline void __zone_lock_trace_acquire_returned(struct zone *zone,
+						      bool success)
+{
+}
+
+static inline void __zone_lock_trace_released(struct zone *zone)
+{
+}
+
+#endif /* CONFIG_TRACING */
 
 static inline void zone_lock_init(struct zone *zone)
 {
@@ -12,26 +59,41 @@ static inline void zone_lock_init(struct zone *zone)
 
 #define zone_lock_irqsave(zone, flags)				\
 do {								\
+	bool success = true;					\
+								\
+	__zone_lock_trace_start_locking(zone);			\
 	spin_lock_irqsave(&(zone)->_lock, flags);		\
+	__zone_lock_trace_acquire_returned(zone, success);	\
 } while (0)
 
 #define zone_trylock_irqsave(zone, flags)			\
 ({								\
-	spin_trylock_irqsave(&(zone)->_lock, flags);		\
+	bool success;						\
+								\
+	__zone_lock_trace_start_locking(zone);			\
+	success = spin_trylock_irqsave(&(zone)->_lock, flags);	\
+	__zone_lock_trace_acquire_returned(zone, success);	\
+	success;						\
 })
 
 static inline void zone_unlock_irqrestore(struct zone *zone, unsigned long flags)
 {
+	__zone_lock_trace_released(zone);
 	spin_unlock_irqrestore(&zone->_lock, flags);
 }
 
 static inline void zone_lock_irq(struct zone *zone)
 {
+	bool success = true;
+
+	__zone_lock_trace_start_locking(zone);
 	spin_lock_irq(&zone->_lock);
+	__zone_lock_trace_acquire_returned(zone, success);
 }
 
 static inline void zone_unlock_irq(struct zone *zone)
 {
+	__zone_lock_trace_released(zone);
 	spin_unlock_irq(&zone->_lock);
 }
 
diff --git a/include/trace/events/zone_lock.h b/include/trace/events/zone_lock.h
new file mode 100644
index 000000000000..3df82a8c0160
--- /dev/null
+++ b/include/trace/events/zone_lock.h
@@ -0,0 +1,64 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM zone_lock
+
+#if !defined(_TRACE_ZONE_LOCK_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_ZONE_LOCK_H
+
+#include <linux/tracepoint.h>
+#include <linux/types.h>
+
+struct zone;
+
+DECLARE_EVENT_CLASS(zone_lock,
+
+	TP_PROTO(struct zone *zone),
+
+	TP_ARGS(zone),
+
+	TP_STRUCT__entry(
+		__field(struct zone *, zone)
+	),
+
+	TP_fast_assign(
+		__entry->zone = zone;
+	),
+
+	TP_printk("zone=%p", __entry->zone)
+);
+
+#define DEFINE_ZONE_LOCK_EVENT(name)			\
+	DEFINE_EVENT(zone_lock, name,			\
+		TP_PROTO(struct zone *zone),		\
+		TP_ARGS(zone))
+
+DEFINE_ZONE_LOCK_EVENT(zone_lock_start_locking);
+DEFINE_ZONE_LOCK_EVENT(zone_lock_released);
+
+TRACE_EVENT(zone_lock_acquire_returned,
+
+	TP_PROTO(struct zone *zone, bool success),
+
+	TP_ARGS(zone, success),
+
+	TP_STRUCT__entry(
+		__field(struct zone *, zone)
+		__field(bool, success)
+	),
+
+	TP_fast_assign(
+		__entry->zone = zone;
+		__entry->success = success;
+	),
+
+	TP_printk(
+		"zone=%p success=%s",
+		__entry->zone,
+		__entry->success ? "true" : "false"
+	)
+);
+
+#endif /* _TRACE_ZONE_LOCK_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/mm/Makefile b/mm/Makefile
index 8ad2ab08244e..ffd06cf7a04e 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -55,7 +55,7 @@ obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
 			   mm_init.o percpu.o slab_common.o \
 			   compaction.o show_mem.o \
 			   interval_tree.o list_lru.o workingset.o \
-			   debug.o gup.o mmap_lock.o vma_init.o $(mmu-y)
+			   debug.o gup.o mmap_lock.o zone_lock.o vma_init.o $(mmu-y)
 
 # Give 'page_alloc' its own module-parameter namespace
 page-alloc-y := page_alloc.o
diff --git a/mm/zone_lock.c b/mm/zone_lock.c
new file mode 100644
index 000000000000..f647fd2aca48
--- /dev/null
+++ b/mm/zone_lock.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0
+#define CREATE_TRACE_POINTS
+#include <trace/events/zone_lock.h>
+
+#include <linux/zone_lock.h>
+
+EXPORT_TRACEPOINT_SYMBOL(zone_lock_start_locking);
+EXPORT_TRACEPOINT_SYMBOL(zone_lock_acquire_returned);
+EXPORT_TRACEPOINT_SYMBOL(zone_lock_released);
+
+#ifdef CONFIG_TRACING
+
+void __zone_lock_do_trace_start_locking(struct zone *zone)
+{
+	trace_zone_lock_start_locking(zone);
+}
+EXPORT_SYMBOL(__zone_lock_do_trace_start_locking);
+
+void __zone_lock_do_trace_acquire_returned(struct zone *zone, bool success)
+{
+	trace_zone_lock_acquire_returned(zone, success);
+}
+EXPORT_SYMBOL(__zone_lock_do_trace_acquire_returned);
+
+void __zone_lock_do_trace_released(struct zone *zone)
+{
+	trace_zone_lock_released(zone);
+}
+EXPORT_SYMBOL(__zone_lock_do_trace_released);
+
+#endif /* CONFIG_TRACING */
-- 
2.47.3


