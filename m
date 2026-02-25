Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DF90FD3765
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 14:44:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AFE86B0092; Wed, 25 Feb 2026 09:44:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 279B66B008C; Wed, 25 Feb 2026 09:44:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1279B6B0096; Wed, 25 Feb 2026 09:44:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EC7816B008C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:44:18 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B11711B6DB9
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:44:18 +0000 (UTC)
X-FDA: 84483249396.11.EE54E3B
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf03.hostedemail.com (Postfix) with ESMTP id EA42D20002
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:44:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=A1yEiJvQ;
	spf=pass (imf03.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772030657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XPqImC2TPNE3mWVBZnFo3D8DNDiiyeBsQfFfJqogg+U=;
	b=ncgCob/Bh5l2xmNBsz9gS5jnoW/3/CIxz9Z0Wncb73xWwRIse4dEXEytpJkjvi8EIktViq
	23cetczm08QMHJ7tl2weFyCIcaBthHiEDOzuwAg6fOgsvTtnG5Kth35CMyEwmNBwhwdOTW
	rsZfGncWYTVS4lj48wjxXEwWNNNewE8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=A1yEiJvQ;
	spf=pass (imf03.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772030657; a=rsa-sha256;
	cv=none;
	b=Q5tN3cvLGa+GnqoFGF2oYzdCykl/WKY2Ddfp1nrngp+nu+JA6tZ5qrQ0NCiQdegcB8uI4q
	QR9/cjW0sK1jVasJhHiHDdsnmXN8yOlwK1xH7IFtQupkOKRSqsgMnlh07MOGocFxH3p1x7
	aMP5RYsEhDPWeJ3hTnN/JiTCqAD4XzA=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 4B199B2C33;
	Wed, 25 Feb 2026 14:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772030655;
	bh=XPqImC2TPNE3mWVBZnFo3D8DNDiiyeBsQfFfJqogg+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A1yEiJvQPSMM1ahjoqJNeG7mUI570Qu8i36AHRQwQY4PdUDHHILXGDd3F3qpQQ5A9
	 5sXXyAmowTgjAt1BEROfaOt26QNUzuzekjRftskOcEbBJD7jkMDgZwPd65PqwpZmgn
	 h5E/FyQxip3srFZkfadc2jwr8O0VKP/Wrx0nqgtI=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v2 4/4] mm: add tracepoints for zone lock
Date: Wed, 25 Feb 2026 14:43:06 +0000
Message-ID: <bde161acf827852ef19de51e91caf5c9f7df81bd.1772030186.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772030186.git.d@ilvokhin.com>
References: <cover.1772030186.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: EA42D20002
X-Stat-Signature: ebfxgprbia4x536c9oc5zrp93gw5dcfj
X-HE-Tag: 1772030656-197629
X-HE-Meta: U2FsdGVkX188osWSwtHkMnTPvNh784/BGdCM8wk8UdgcRrNfZvWsHIY4ADiGP3/SIuRQieoXlqnttRBICu9n2DUXaSJeKZGKpBn5SPdHQYENb6r4Q08SdIwtgTfkYp/Zo8ZNnqzaa3nitnc3J+zMrwrMv2EaxUepQcjBIJoATdmviWNoSWWMnUxaVLTTKvGu4TKNsEXjOdmY9JHWGnPU/zOCaaECdS9IMnXMxbKXVhR60P0pX+eZeMVx4TyCd1JK8/uOySiIF4xSuR4Fr3QkTVpHfHdqK8F8lrUm9PrePODC7ayDRH13Lh1tZBFeuhKRItLg7MPBsqmmFoZAJeHnwbxMZKR/TsTCCWRukM1K+WMrHK4cAfPspY1Dr7YB+gARm3pZkcVb/nrIUBBSe/K5gJPSd5zxgVvkIFjrcZUwIJUBBJoWInAcXoQ43lgWOEWInMEGZkz6bdgeW5/+KmQWqJB5zvsbDMiIza1E909KWxBOwAKGlUW9Z5QfGdLyHf9n2m9sO9MaQaJtf1Va/Fg/L/Q1ulM25tJLdTiV3p7BXnKJFEeZu8xyG4WzWTXf9R9IlcrljN6OOe+3RvEqXk9YWxO+y3WCyIn9qBVmH26A8hBq7s+ZkKUYKQcB7dW1QdNgbDQAxJFZNMW0QnxNCiCHnB/ajcZMOoncq34VKOvVB0ntHXWOj/MwIkYg0dRkmfOMtvMzPuSkf8LKn3TdUSUbgyw83zi6fZovTvrM4Ls7ESeEMAprsDxZDfJLhAY0jj+79mCN9+JEPN9BeA+BQD0Zk5QyJyau3g1HyIwQ1taN8C5QFoooLFuRqLsJZ49BZEOEm/7DEfFHMyx2yXRx5qSAS2M6A6c7nApAMo21k4GzZuOW2Mu26Hl6jVkT8yKgE0ddAlcipo27up1lS37ZLRem5IMa9p5/JqCelpysKhBqPBpK97uN978Y/7T38pEUnda0iZFAEOosXgmfEnP4h5n
 yTE7qVdG
 7UTtXtrjDVCeSWsnE3zpTl0aXMhP3gzCYM2T1l0QwEzWnve14INf7VEHA0miDVPh1XsyHByUmwttMw4koEU7rTXwHyMfMBxkqvpOMVlFmeYV+71iX68SHuboDFSTOWtqGN4o/RtSEjYRfncbdkSM7zVkwSGR2SK2Gw0Edp7B8s2CDpGStRdNbxX7qTwWfBF/Baon18Dw9shpEmtvHJIyB3SLA35j7q7sEs8ttdRm/AHKuPPP79amtHU5hoT1QHirhwyj3Sebu/9yyKCsWeIBh7eBNFW2PJ+4gEjHU11LU8FdBAD0r1NXYCjt8ueBZavzJQvyf
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
index c531e26280e6..cea41dd56324 100644
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
 	spin_lock_irqsave(&(zone)->lock, flags);		\
+	__zone_lock_trace_acquire_returned(zone, success);	\
 } while (0)
 
 #define zone_trylock_irqsave(zone, flags)			\
 ({								\
-	spin_trylock_irqsave(&(zone)->lock, flags);		\
+	bool success;						\
+								\
+	__zone_lock_trace_start_locking(zone);			\
+	success = spin_trylock_irqsave(&(zone)->lock, flags);	\
+	__zone_lock_trace_acquire_returned(zone, success);	\
+	success;						\
 })
 
 static inline void zone_unlock_irqrestore(struct zone *zone, unsigned long flags)
 {
+	__zone_lock_trace_released(zone);
 	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
 static inline void zone_lock_irq(struct zone *zone)
 {
+	bool success = true;
+
+	__zone_lock_trace_start_locking(zone);
 	spin_lock_irq(&zone->lock);
+	__zone_lock_trace_acquire_returned(zone, success);
 }
 
 static inline void zone_unlock_irq(struct zone *zone)
 {
+	__zone_lock_trace_released(zone);
 	spin_unlock_irq(&zone->lock);
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


