Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81519C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:47:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B07F6B00EF; Mon,  6 Jul 2026 02:47:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 788776B00F1; Mon,  6 Jul 2026 02:47:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 677A56B00F0; Mon,  6 Jul 2026 02:47:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 408FD6B00E9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:47:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B9D868D12E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:47:29 +0000 (UTC)
X-FDA: 84957420618.15.19ED2E8
Received: from mout-y-111.mailbox.org (mout-y-111.mailbox.org [91.198.250.236])
	by imf01.hostedemail.com (Postfix) with ESMTP id 09DB24000C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:47:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=mavick.dev;
	spf=pass (imf01.hostedemail.com: domain of m@mavick.dev designates 91.198.250.236 as permitted sender) smtp.mailfrom=m@mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783320448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yOVKcthDGvAJ8dvBG3cmLRLG3KzkQv//OuPlDX5LVp8=;
	b=Wh4x2/tAR1YTky7f0rZYJZr48kCt6vXchFlPsPT6qSOpuVdbmJxNrQTfd58u1LJkj4zxgJ
	blJrv6ohfPm/l1GW0H8pVmoPqC9SWkTC0BRLuqr+meJEzsLpEhN4Etmfu0dzjQCxxoUdOG
	tT7i0yKD+a0TRY4Uz9pHrAaSbkw2ZpQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=mavick.dev;
	spf=pass (imf01.hostedemail.com: domain of m@mavick.dev designates 91.198.250.236 as permitted sender) smtp.mailfrom=m@mavick.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783320448;
	b=1gTBxnMTv3gH9svzbShjKywC36suQ3WZuMbDz+wzpmO1ZH2emCOQO3+vSlnOlRTIuMXZQe
	bipsZBkSa/XXDqYgg6mXN7LYX7+0cvkfSvPfkcNi5/a5rwQ9KiV8FWktUKWf89HU+WyL6u
	gxbRvksELU/ctHkWhmaS5E1op7g2dZY=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-y-111.mailbox.org (Postfix) with ESMTPS id 4gt66N5P5szMldj;
	Sun, 05 Jul 2026 01:20:12 +0200 (CEST)
From: Eugene Mavick <m@mavick.dev>
Date: Sun, 05 Jul 2026 07:19:20 +0800
Subject: [PATCH 1/4] tracing: add ref_trace_final_put tracepoint
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260705-refcount-final-put-trace-v1-1-cdd0014626a9@mavick.dev>
References: <20260705-refcount-final-put-trace-v1-0-cdd0014626a9@mavick.dev>
In-Reply-To: <20260705-refcount-final-put-trace-v1-0-cdd0014626a9@mavick.dev>
To: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Boqun Feng <boqun@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Gary Guo <gary@garyguo.net>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Eugene Mavick <m@mavick.dev>
X-Developer-Signature: v=1; a=openpgp-sha256; l=4836; i=m@mavick.dev;
 h=from:subject:message-id; bh=qHwnbzvpK9wYBzbeGmnuCtzzLwF8aY1zM3ldVu/OfqE=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFmeU5kuGiV5R227xfz40tbY2TPW8N9ucCi4MlNq7mZRO
 adVpkxpHSUsDGJcDLJiiiw1WQnuGStnJRofndQDM4eVCWQIAxenAEyk4S7Dj75nhgeaw+OehfO8
 8Gy6XJJ4osE+Zem0+UrvfB7n3pDXZGRYXT/znGHqvydvs89bdLYz6zAHaf1t6GPTTLXV4jde1ME
 EAA==
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 09DB24000C
X-Stat-Signature: g7tj3z8ccawn7nqmognok85n37f7zkac
X-HE-Tag: 1783320447-121450
X-HE-Meta: U2FsdGVkX19YwUqubBVMUnFTRRb5BRQQtMHgFhnjl7gfkWHoA8lXcY6XTrLgmiYH+WHogep/jM4MakvJgrLcIt78Vm595+IM7sfgIYeZFnxwyNDghNwvFSiht1HBp/2I61KKb0IjENaKVyRi0Dp8nTSUXB+FNHdHUEvqZrY/YDIow2nIS3nc+3N1VI0n/5kQfNrIkXAG3BkB/Z6Xv1woAudJGwwXXSLXCMLDlIMtRYrjn7B3F27ghxxbj1+xCJ6TWJMXmEa1+XwyXwjybVDxOQ2eO4gKDJD0uHZDnUqN2HLA+AE00JoEe8DyuPb//H1YJULHOqrOl3/atAyOpa6x0k+lILAP6z5rJuYmhn2jTKKu8cV79zBq7/P88Twq+Ei+CFdYfOsulI/wS3gGGcM/bK2MjS3kmoxvUGhNnp5DAandSiw2Ibx4Z+mUfQuXn2YDi9Kd6yRbYs+2jR+qihcOXnZA09a2C831cDiHZ52zw64F7ag7NUobyyY4nc8FckB4uaPEyo3WzxS+9qHGpVEDMHLEKmTp+9beQWqa9V2RSaLvkisFNqD5gD6K93TM/B2WD1OEmXHwm1v23KO54yLch5D9+ekki45QFRYFW0nZLtJeSGgiNlcO4BPMEnEN2n4trA45N4Sh1M7Fl/CbaFzKdKx6Q40964MOg16sBj5lgnGcMqcwXHwzsS5YCWfFOArZKhlM39ldW1mMmwUATybSSNlUoLDsJKr+Qkv6GKIUWySlD20HN57QwBOA+upMDDiTRust0JH/kpnM26KqSSI+6+9IpLXKGU1EfJlY23Ij8OWFUv8trOq/n3nn61LiBW+6nzCxX1SItyQTrqfrSyA8RrA1dmda1vvUBu7yK0xQ6SZOd7OtQo5Rth9A0uKHwEXE0jurIvFj1Zfboee5yVTSThWVlsebEcQnyWI0f4PtKLDVWCxnNQFxekOdtTneMmQPu8C3Xhf6N29dajdcAzA
 VuSKt20K
 C1geqJwYjllMAj03/2HAFfqLanwMPopHFxBs2y6v5+PZwgkxIqwf5Z/zLHHUlBVdV8q4V2v5ksfOVNclThMbYSpQH8ppIswbOvQ0E3PszIBhT0/6I1BypmY5nnuSCys7WZ2gq2BJ/mDS4EHNAYZFiLc+1ZtvRF965oUfr6RUMe2oq+sxapB1gewP/lsuXhR+o/T2GjvNUsDYwbU6f8AMO29OvcwN2zXGQgYyvaLJBJLEAhz0YH4TN6HsyIAt2d4dkXG9N5zIaSDWt6Gn4Zp/YDzyO2UC6KTBRptnv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add ref_trace_final_put tracepoint and related core infrastructure

ref_trace_final_put fires when a reference
count reaches zero and the object enters its final release path.

The tracepoint records three fields:
- caller: function that called the refcounting
  function(refcount_sub_and_test, percpu_ref_put_many)
- fn: refcounting function(eg refcount_sub_and_test)
- obj: refcount object(struct percpu_ref, refcount_t)

Signed-off-by: Eugene Mavick <m@mavick.dev>
---
 MAINTAINERS                      |  2 ++
 include/linux/ref_trace.h        | 26 +++++++++++++++++++++++
 include/trace/events/ref_trace.h | 46 ++++++++++++++++++++++++++++++++++++++++
 lib/Makefile                     |  2 ++
 lib/ref_trace.c                  | 12 +++++++++++
 5 files changed, 88 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 10e8253181d3..8dab37726b9d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4210,7 +4210,9 @@ S:	Maintained
 F:	Documentation/atomic_*.txt
 F:	arch/*/include/asm/atomic*.h
 F:	include/*/atomic*.h
+F:	include/linux/ref_trace.h
 F:	include/linux/refcount.h
+F:	lib/ref_trace.h
 F:	scripts/atomic/
 F:	rust/kernel/sync/atomic.rs
 F:	rust/kernel/sync/atomic/
diff --git a/include/linux/ref_trace.h b/include/linux/ref_trace.h
new file mode 100644
index 000000000000..54e9fba9e3e9
--- /dev/null
+++ b/include/linux/ref_trace.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_REF_TRACE_H
+#define _LINUX_REF_TRACE_H
+
+#include <linux/tracepoint-defs.h>
+#include <linux/instruction_pointer.h>
+
+/* Declare the tracepoint so tracepoint_enabled() can be used */
+DECLARE_TRACEPOINT(ref_trace_final_put);
+
+#ifdef CONFIG_TRACEPOINTS
+/* Wrapper function implemented in lib/ref_trace.c */
+extern void do_ref_trace_final_put(unsigned long caller, const char *fn, const void *obj);
+
+#define trace_ref_final_put(obj)						\
+	do {									\
+		if (tracepoint_enabled(ref_trace_final_put))			\
+			do_ref_trace_final_put(_RET_IP_, __func__, obj);	\
+	} while (0)
+
+#else /* !CONFIG_TRACEPOINTS */
+static inline void do_ref_trace_final_put(unsigned long caller, const char *fn, const void *obj) { }
+#define trace_ref_final_put(obj) do { } while (0)
+#endif
+
+#endif /* _LINUX_REF_TRACE_H */
diff --git a/include/trace/events/ref_trace.h b/include/trace/events/ref_trace.h
new file mode 100644
index 000000000000..e6037a325be2
--- /dev/null
+++ b/include/trace/events/ref_trace.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM ref_trace
+
+#if !defined(_TRACE_REF_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_REF_TRACE_H
+
+#include <linux/tracepoint.h>
+
+/**
+ * ref_trace_final_put - trace when a reference count reaches zero
+ * @caller: function that called the refcounting
+ * function(refcount_sub_and_test, percpu_ref_put_many)
+ * @fn: refcounting function(eg refcount_sub_and_test)
+ * @obj: refcount object(struct percpu_ref, refcount_t)
+ *
+ * Tracepoint instrumentation can be added using the ref_trace_final_put
+ * macro defined in include/linux/ref_trace.h
+ * which uses _RET_IP_ and __func__ for caller and fn arguments respectively,
+ * thus only requiring obj arg to be supplied
+ */
+TRACE_EVENT(ref_trace_final_put,
+
+	TP_PROTO(unsigned long caller, const char *fn, const void *obj),
+
+	TP_ARGS(caller, fn, obj),
+
+	TP_STRUCT__entry(
+	__field(unsigned long, caller)
+	__string(fn, fn)
+	__field(const void *, obj)
+	),
+
+	TP_fast_assign(
+	__entry->caller = caller;
+	__assign_str(fn);
+	__entry->obj = obj;
+	),
+
+	TP_printk("caller=%pS fn=%s obj=%p", (void *)__entry->caller, __get_str(fn), __entry->obj)
+);
+
+#endif /* _TRACE_REF_TRACE_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/lib/Makefile b/lib/Makefile
index f33a24bf1c19..41737090a95d 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -335,3 +335,5 @@ CONTEXT_ANALYSIS_test_context-analysis.o := y
 obj-$(CONFIG_CONTEXT_ANALYSIS_TEST) += test_context-analysis.o
 
 subdir-$(CONFIG_FORTIFY_SOURCE) += test_fortify
+
+obj-$(CONFIG_TRACEPOINTS) += ref_trace.o
diff --git a/lib/ref_trace.c b/lib/ref_trace.c
new file mode 100644
index 000000000000..25f7c17c7c47
--- /dev/null
+++ b/lib/ref_trace.c
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+#define CREATE_TRACE_POINTS
+#include <trace/events/ref_trace.h>
+
+//Wrapper function for functions defined entirely in header files
+void do_ref_trace_final_put(unsigned long caller, const char *fn, const void *obj)
+{
+	trace_ref_trace_final_put(caller, fn, obj);
+}
+EXPORT_SYMBOL_GPL(do_ref_trace_final_put);
+
+EXPORT_TRACEPOINT_SYMBOL_GPL(ref_trace_final_put);

-- 
2.51.2


