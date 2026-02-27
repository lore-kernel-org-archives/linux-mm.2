Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B3AFFEFB6A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 16:01:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 431256B008C; Fri, 27 Feb 2026 11:01:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D2586B0092; Fri, 27 Feb 2026 11:01:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25FC76B0093; Fri, 27 Feb 2026 11:01:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 06ACB6B008C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:01:23 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4DA1D1A0884
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:01:19 +0000 (UTC)
X-FDA: 84490701078.06.D6B12B0
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4ADE840014
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:01:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=3FTzkSlG;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf04.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772208077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nr0uptGXatjh+gHrR6JnOHzhsiGPuBf52QtluKSZ74Y=;
	b=dYC83f2abV97p6+py34MUf+z8LR4VM1OlnhMRCOyXm26BqCrrk8UwLlDxg/YtW5Go/1cuS
	VkwNeK5eKuKWCBNmTPiG+dZ4kxCsI3jhDYgPiFGSGezl8fHEo7frQZbZMpoP1c3s7hLnIu
	irPNP+k708UTJQzNR1nTNqHlwlcexRM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772208077; a=rsa-sha256;
	cv=none;
	b=KdxM9y7Mw5Ypk0EZcJ9YtPu6GtNBPHSoXMHc14ycYDxktLxqMSkaw8l0IALqSz0BahERp9
	+E1g2Umf118XGn+B0JQSXz08GT7Qi62WDnHFbj6WAWHcZ1xMYSquE0fXNJ2Ghxx2jW5Btk
	3uC5N1tpU5ajCp1iXdlFQCq3sg4JNiI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=3FTzkSlG;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf04.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 16406B2E47;
	Fri, 27 Feb 2026 16:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772208074;
	bh=nr0uptGXatjh+gHrR6JnOHzhsiGPuBf52QtluKSZ74Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=3FTzkSlGA/RICj3i3JKDU2LeILeGexDooMVgfRIoWjEvhKaF5x1OKWMeJBTbw1Cp/
	 zFQGgfKPfH+Vp6hk/ucTHJHxnoBknaFKdfmNHkFwRE7lSdx5QchTXs4BVncOBOYdta
	 XsZTMsEkybEntMJy6U4t+63/O7LtPl0y6S7NG86g=
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
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
	"linux-cxl@vger.kernel.orgkernel-team"@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v4 5/5] mm: add tracepoints for zone lock
Date: Fri, 27 Feb 2026 16:00:27 +0000
Message-ID: <ae145fe890f028409f727b4921904b547346fa0b.1772206930.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772206930.git.d@ilvokhin.com>
References: <cover.1772206930.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4ADE840014
X-Stat-Signature: ingm1pwxeph3zw3khgdu3h1rfnif7fz4
X-Rspam-User: 
X-HE-Tag: 1772208076-689719
X-HE-Meta: U2FsdGVkX1/qfH5+DxhJ8mlDVasrfLVbii3msM8A42Lw4MsOVpt+qYke2Ow9avGfH293u5AjAcV0poRdrx1uXVjyJ/JSpXOfozTAmlMA6F0gPVQCCSWlhUaa17e1u960vUbZXBViWbNZXzT+V+GZqVHkKHgWZFxMaKHaEjv199h98ZYZX4i+nJsfvPFdaYYYDny7eWYvUYx7B7Ul+361sejfcIV3wtS4BJq+0MvE017V4ak+xPgzxywy/tn3/8ZHdsm3J3aXsEX63+bKPzgw6n/goDRK2vSqrs+YpFMdP0JYsU7usUjw2nOfF41+ZaMsEx3ZSMFlco9JzisvJWOtxoaaOOLwNYyEvc1pJo0ptJq8iRCyQkcCo++YCUhpEUn4vXxNRHyU/3wwSc8XjdSDJs6eQHlKHMyFcypeLETMjITNe0kCw4VVUgpkaVN1WnBtalmRiSzANXxPZvqF03fle6QfIQERr86i974TKME3FGZthJsflY5DePJwZY1q6qo44UOfMG9TyhbJDvwR3TfFjd/sRmHUeRPYcnmGa5tJK6telIbDgkV1km+wjNVqfnksFLPJ02Xw86lEl9rKBo8nnTshbc8k6kJ2JhOcTnnuxQ7vlMdIjyRb1j7XPJdNB8VjBuAfYzyjrd9zzqftt3fvdvFIo5zrvbVuYvV2XcDCYCx6B+VL6kBEGZbc0KlOrBMbLPSecPNz78ThuAcRZ9q/F3Eea1wT7KqFCD0LjeAB2DA2as90w3kwjVQIzGG9c8WaQ2f6Mf6XwV/VBtw6NB37l0Z4H78V95Bjq/wrkAZzt4xn7Mk8aPFrb67j8KnFCcdvySLkrwILTUm4KDML9GBHKBdptEXstPXGUjlP46DFgpp7tbWD6XOVIXSUZp3ND9Fll3zPpf5bXl1h3di/QylP1J+qbEPQMc+btERwTijp0CoDgP7OdEuatnfAuShghJUyQE+8tuygs1jGvMnQhcA
 YVifJFco
 f5GFVh0/Mm4kmGGGNkFQapOmv4hZ1HIPjiJU9etd1meFzXPs9VOzzNn5TTE9PcZCmFo3PCngLMKbE/pvaxtj9qsw1HbbjCUKSdDvIrs0L4qDFWhDE/TU6jIA+VBY1VnvIAbxVGurGGgt18Fvj3Qj0PD4ohrdRI4hxlmr2WeDM36ZEw0nCznBCf8thyQRgfD6Jxzc29YvhIcwezFTKPlsUUNuUROAu7Q1/jlLKjyVTSsW8X/BLmJspmM07MgdzQW1c4H3HXl5wMGezjOQ5BEr9Wm6bDK25bTzv+4/TNGzoFArLyrkdGjf9zCmTuAu5Nono9bpH
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
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 MAINTAINERS                      |  1 +
 include/linux/mmzone_lock.h      | 64 +++++++++++++++++++++++++++++++-
 include/trace/events/zone_lock.h | 64 ++++++++++++++++++++++++++++++++
 mm/Makefile                      |  2 +-
 mm/zone_lock.c                   | 28 ++++++++++++++
 5 files changed, 157 insertions(+), 2 deletions(-)
 create mode 100644 include/trace/events/zone_lock.h
 create mode 100644 mm/zone_lock.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 947298ecb111..de39e87a4c46 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16681,6 +16681,7 @@ F:	include/linux/pgtable.h
 F:	include/linux/ptdump.h
 F:	include/linux/vmpressure.h
 F:	include/linux/vmstat.h
+F:	include/trace/events/zone_lock.h
 F:	kernel/fork.c
 F:	mm/Kconfig
 F:	mm/debug.c
diff --git a/include/linux/mmzone_lock.h b/include/linux/mmzone_lock.h
index 62e34d500078..6bd8b026029f 100644
--- a/include/linux/mmzone_lock.h
+++ b/include/linux/mmzone_lock.h
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
index 000000000000..f4e32220af9a
--- /dev/null
+++ b/mm/zone_lock.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0
+#define CREATE_TRACE_POINTS
+#include <trace/events/zone_lock.h>
+
+#include <linux/mmzone_lock.h>
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
+
+void __zone_lock_do_trace_acquire_returned(struct zone *zone, bool success)
+{
+	trace_zone_lock_acquire_returned(zone, success);
+}
+
+void __zone_lock_do_trace_released(struct zone *zone)
+{
+	trace_zone_lock_released(zone);
+}
+
+#endif /* CONFIG_TRACING */
-- 
2.47.3


