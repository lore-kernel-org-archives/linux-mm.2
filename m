Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FC1EE9E31F
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 15:23:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF41F6B0092; Wed, 11 Feb 2026 10:23:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E65C56B0095; Wed, 11 Feb 2026 10:23:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEF026B0092; Wed, 11 Feb 2026 10:23:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B54696B0092
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:23:27 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2DC698B615
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:23:27 +0000 (UTC)
X-FDA: 84432544854.29.06B808C
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5DDA880003
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:23:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=EnNKT7M3;
	spf=pass (imf02.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770823405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WI9HzWB33RHOS7x2iM4is6SHnBj+us5QajX97yLBu8U=;
	b=DZEM729S8JURkIPBlX+oNRKa6P3JbAqs+RLkdno7Fl+S0WPv1zvu1juMFnmVTDqjWoRu/c
	ZHiw65Oz4C7YB372DvBaMoXtZGVMVzZi1sejkmlE+Mcd/voicg0de1zZssrXKcpQAEmLPp
	heo7+CMVs17+9uthZP44fNJTOdfY0y0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=EnNKT7M3;
	spf=pass (imf02.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770823405; a=rsa-sha256;
	cv=none;
	b=R46LBUx8TJBvp3huSHEe/oXb/2aSuuuY3JDXErac4RWFWf5dRIPEcyg4iLWGoVxh0Au9CQ
	bTObILYHSSiqUsSXloA635J6DMOXqBF8ROvn0IfqqxXPbXLdZxysLzSre/YW4HQZGFvSW/
	QlsuhHVhvusJdYfMwIZi+e3Y/ktH8h0=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id B6507B2591;
	Wed, 11 Feb 2026 15:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1770823404;
	bh=WI9HzWB33RHOS7x2iM4is6SHnBj+us5QajX97yLBu8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EnNKT7M3TS3ryf7KVT447cgDcaIceytqYXzKU1+bD221uVnfKF5m7bpAMnXDRHx79
	 7pvy+2IjemivNf4Iu5+zUFr0aAZ1nDn2Yx8vgl6Ew9riIW67mirzm3v/bMBLk1fhh0
	 1nqXinwuEJ6IksxPU61gSyVI39gCQxtp+yEpEsF0=
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
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH 4/4] mm: add tracepoints for zone lock
Date: Wed, 11 Feb 2026 15:22:16 +0000
Message-ID: <1d2a7778aeee03abf8a11528ce8d4926ca78e9b4.1770821420.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1770821420.git.d@ilvokhin.com>
References: <cover.1770821420.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5DDA880003
X-Stat-Signature: ssnkaf4jexw6fi4cmfe1mq1qo8yyae3a
X-Rspam-User: 
X-HE-Tag: 1770823405-847258
X-HE-Meta: U2FsdGVkX1+4MlLjhce78cfCykPYSUY6vUk6cmbjha9idevoAP+WFfkSICnDzcLlb3vTIxqGk7pxi5MnoZajLOlPXn5wOajhyXvpDdqNChZ84kzweXJlZ/dNO2i8xKDhte0Dr71LfWkDS1oElDdOj7GU/5rwyDZEQ1aiW4aGw+vbsMOe3OXdzDOc+d1A0h5k8+CeFHDlD3YMcj1wnUVoRqxwjAXtsoNFPmTWwtzRvqzwsDC+Y2y5kBWEVYUKcfCBBoktZG+iT0M4drkkUy8ndgNZ2lrjx6wZPhlurvoWgN7GsD2fSJasNFgQCE06VLIfaARLZZziaw79Ea89NKoklpwz6z1eAKu9M+lcUXqCqVRb1ussdIxkfFmng9B46MM0gyo95fKRH6frNCAchiz3C9pkuoOYaWO+pkqSZhe4ylwyQtAvwxU3tcO4KK2C2a8SZPqEk6W5uOg4tv4PxVU5p0kL/PwLh09MNgVeycNWfIWhXLkWqcOsVOQPxqURArmek+VCk0oOQsssVSMZ/7TEFUOISfGK8ITUhuGef4fSMob8vgbLjofjTIwO4VURJqn+8eOiWuZTqwR3RmGdKupd/T69WQGSEUo31jOC/BD92hY385DWFBth5p21UfZ98q7/68wAaJbGRKhKzDVAQdnpknShTSpS9p6J+T4BA0jpvzjZ4hJtLJu2YHD2JsjugqaAEKm9n6tQQm79V0FKb/nmz6a0EATmo4fpTz4Y6F2QsA2U6xgc1lkPK14b5IfBEsMhO+5zBF3jgJncfhc55tjyQ2JWT8jWH7k8YzDd9J7TX3wgDHjatq9VFQutZ0a8nQ9oKdVn5J5OwGHrvUs694YDR2nvwjOBkcze4tw2riJgN499Tqt/iBYF7hHYXtWZCMbk6UOueYLeqXTliPGtucayl5k7CfbyZU0MIAd11fJbsDHUwc54ANAhaUmN1bwhZ+c+kLQ9l8xw0j+5QOUHZwg
 85eHmiCJ
 wOAgfo+vpHgxQjnNPEf+fMUAxaabpn8l6qyRsZt/IoLzsC1deKakbX0aixFsCq713v6A7vlY/jmPlBdDulxbcOJC3f2XcBvpvGcMmFQFQrusXuguphrOJ2Zubbyfv7pVV075mYA1FqBKabDUnmZo1JKALQsBpVQZR4+WKyXF3BU/W8bfCSPZVpfmvp1BAoNiliv0TfFrSKvlTTpiIX+fyniccSI1cI41pn79dm4IGrTbTlRQI7eQiuhaRuyb3ytGxC5WdnAyM4F8yY37IfiOCFlN/QWEOn1UV1gxquE4jcCi0TMmXZ0mHzucCdUDZnhHiktsj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index 680c9ae02d7e..711ffa15f4c3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16499,6 +16499,7 @@ F:	include/linux/ptdump.h
 F:	include/linux/vmpressure.h
 F:	include/linux/vmstat.h
 F:	include/linux/zone_lock.h
+F:	include/trace/events/zone_lock.h
 F:	kernel/fork.c
 F:	mm/Kconfig
 F:	mm/debug.c
@@ -16518,6 +16519,7 @@ F:	mm/sparse.c
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
index 0d85b10dbdde..fd891710c696 100644
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


