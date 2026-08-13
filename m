Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 320FCC5AC67
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 03:50:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D45366B01A3; Wed, 12 Aug 2026 23:50:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA7226B01A4; Wed, 12 Aug 2026 23:50:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE5A46B01A5; Wed, 12 Aug 2026 23:50:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 838F46B01A3
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:50:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 082A01204E8
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:50:30 +0000 (UTC)
X-FDA: 85094869020.12.5CE4724
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	by imf15.hostedemail.com (Postfix) with ESMTP id 37C4DA0009
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:50:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=xHgBGCEm;
	spf=pass (imf15.hostedemail.com: domain of m@mavick.dev designates 80.241.56.152 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786593028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bEXWfsEWtFFEp+0efKsBCvQdDR44+02Pu5SRRh4WvD8=;
	b=vTBvsWlLRlo+uTr0bRd6b7t35REfP+judMkl/3aCvQ/C3t8OG3GEnbMRKdRbNeSjUzfsAe
	8iUsOE9J7QDAKTzU2fsohb+m2OYkv8KiThghSDYw18DgCZMmW3v7U7/Xrj2QU0ZIecOuY0
	h5i63zQv/FO6xnoNfpIvckyRT5+gFA0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=xHgBGCEm;
	spf=pass (imf15.hostedemail.com: domain of m@mavick.dev designates 80.241.56.152 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786593028;
	b=dpPIhviR6UGmPhoHOeCmTSgA4ImfZ/LCZ/rdvOb3gXm0uqTalzXyTnR1n5AfLGtMQ2fThS
	Ngf7+6QJzcQPlgWpuNU6h0iD+ZKLla8NV99w+hLzadLruVszy3uoT2TdwV4G2qptbSlMvY
	rvur00visr+Lsgl4vnPlsYLiFXe2aRg=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4hLBG92N6QzKw1y;
	Thu, 13 Aug 2026 05:50:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mavick.dev; s=MBO0001;
	t=1786593025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bEXWfsEWtFFEp+0efKsBCvQdDR44+02Pu5SRRh4WvD8=;
	b=xHgBGCEm+3b1/xWePC0fKvD2X+/AktKduhbs5J/5JXXpF4UF5K0KM4vKDypjx3SNJqUMEi
	3i1lzTbnGNvLvW/7YTNM3TgYF08OSnvSew8OTOdxenB6arH4tzF/tR5uBe/ITZ6iIftFUU
	6Bj181XPQeoFyxwaNDO3sVN4KGxWNAjI694DaD8CZQY5/NcLdvl8eOC0M3jzqUxcdAZeAr
	F26NLiE321S3EGYlq82BDro0jhkZtOwCvmr4DcGWj3C55ZdZ5z7/OO8OetIGrUvp6SaKlS
	8tNTuhqnDI8FLqI5IbXgkNQdjbkUKR6a0QiDO56RByl5dNasyYahRzTX8C3yjA==
From: Eugene Mavick <m@mavick.dev>
Date: Thu, 13 Aug 2026 11:49:07 +0800
Subject: [PATCH v5 1/5] tracing: add refcount_final_put tracepoint
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-refcount-final-put-trace-v5-1-6e8bf8a38b31@mavick.dev>
References: <20260813-refcount-final-put-trace-v5-0-6e8bf8a38b31@mavick.dev>
In-Reply-To: <20260813-refcount-final-put-trace-v5-0-6e8bf8a38b31@mavick.dev>
To: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Boqun Feng <boqun@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Gary Guo <gary@garyguo.net>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-mm@kvack.org, kasan-dev@googlegroups.com, 
 Eugene Mavick <m@mavick.dev>
X-Developer-Signature: v=1; a=openpgp-sha256; l=5562; i=m@mavick.dev;
 h=from:subject:message-id; bh=/DyJ/Pt5HgNY+1AYXZ1YsFD8V1gs37HPB1lvRPBQOWM=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFm1dgen8J9b9fMDq5pp/aWjMaqSlwrVjvyJExR7IlwSw
 x+7edvUjlIWBjEuBlkxRZaarAT3jJWzEo2PTuqBmcPKBDKEgYtTACYyk4Hhf85WLaft4Zf2337d
 8+ov+3LnJ8W3rkutXaDnWt3yw/GXgjnD/6j9k78unJKeydLcfe7ijGt/JdQTJC3jXd43MvmsrXe
 I5gMA
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 37C4DA0009
X-Stat-Signature: kdxakdnqun1a86bq1wpukr17m5g3rqkh
X-Rspam-User: 
X-HE-Tag: 1786593028-196070
X-HE-Meta: U2FsdGVkX1+kAVR/skKJbequsdtc51Sq/14c6atr6Q9KSkXWUvrBKpexr0HddDGCyOxiAf/FU3P/TDofQJtvwze8G+Wh4VASzSlSZQV5sIqWebJhpsJm1d5JxjQe4aXB6f9fvK9zLQwgp4acprPINCTDM+zfn+9pCu5AYcYp/TR8n7r4LCV2w3p2qY8opFjslntRjrqb1XEI8OV5hQ+SgBt9SAci5srNh7AyWT27DyT99qW4LnfnjBalj39mBSMOudbang4Q93SpZndiGZURmN/mN4sVMKEGRa3FJTeEy35OM4RS8WW8CN83t5rh/lywFxpr6m3cirOeHcFfcPH45OTP948jpgQZTEj5nkq6i2dBrZjRtP0mFDEeN4JM7LkUHSMXCV9N/Zmza0+LXokMPL5MwPFWiX3e7nC6VvjCFqhIuvRX88oUh75qqqvAc7215lW8bBoKkYxK7kNC/Ku3afxji13ONDri6kAR2jvEFCjjDvWNqIvvCLGBlt6dOjR30F2+QG5HUthnBJWHibBt0LGFg/YZcoqyp40bPRBa4YN3KN+IKe4Lxu4d7I+k3/Llqm4dRuGACsIwdEJ5saZRnm65kcqNHjFu4VovTBXoD9qiSNe1QLlaoK3SKTJQry+JtOXevpVb1G8EEm/suOcBw9Qvun91vXyikkzbA/6EI6ikmZ+CzLQ5Ws7WBa3x3thY0YbzJfUiMIUOOuHZqvh4bhL7TZnSM1R4zEm9C1OrvJoo5Jt+n0udt5N9Leu0xmV8fM1XffSEAUDIjpA8fVgK3ylgKMZSnA143UGnhx+99oYeLpUS0pj+DiW+kzI0X6GY+vz79sp7FQFsKaT9rvKE+x5tvQ/N6GvKO/et4ptZoXHTptOk1CTiff2py1noZ8mvVrkLr950SOK2i2J1kLSGSaN4foq2mTfWtoW1G4wO88VnBPDOJIE+t98r80ZERogEC4wLfOLF77KUls3NB5/
 70nVWUBT
 9JzIX1Vif7UhjXSOas9mJUiM03YPekwUTIQiwWY+/EKwUvK94fEcLM57DZcgtmzQQfpE1TisPEKBYDowfZ5TKJ8rI2s9ZHjqJ9HMSGyVZDN0im636salq2EIMehnx219I1WkXSu2yeyv4voUC2JOIPuQYXMHp3v1YI9YF7eMwvRDk3ej1heVrpAv5gHkfX+Mk8gnYHmeNJcoqihVMjELsSozMaHMJk6y+77XvW/TIG1jzJAcE6Tj37j74dtOT5xfYxXQ9WvlDpED9jFf+J3Nhu7tMneIXnfWlvg5yifprsS/6j1j9MZa2U2QWIvJlIwPFQOXD1z2ALIWZQ42qd/qdDRkKYStLEJnl0m/44fNK6GEGoYQPOkpMd0g4F3KiM6W2fPsDaclAA7T6ZZt4dxRuW2o2H80KDV7ij/u3wJeDkL2W6Xg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add refcount_final_put tracepoint and related core infrastructure

refcount_final_put fires when a reference
count reaches zero and the object enters its final release path.

The tracepoint records three fields:
- caller: function that called the refcounting
  function(refcount_sub_and_test, percpu_ref_put_many)
- ip: return address of trace wrapper macro call
- obj: refcount object(struct percpu_ref, refcount_t)

Signed-off-by: Eugene Mavick <m@mavick.dev>
---
 include/linux/refcount_trace.h  | 33 +++++++++++++++++++++++++
 include/trace/events/refcount.h | 55 +++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig                     |  8 ++++++
 lib/Makefile                    |  2 ++
 lib/refcount_trace.c            | 14 +++++++++++
 5 files changed, 112 insertions(+)

diff --git a/include/linux/refcount_trace.h b/include/linux/refcount_trace.h
new file mode 100644
index 000000000000..6f8d0ba910f0
--- /dev/null
+++ b/include/linux/refcount_trace.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_REFCOUNT_TRACE_H
+#define _LINUX_REFCOUNT_TRACE_H
+
+#include <linux/tracepoint-defs.h>
+#include <linux/instruction_pointer.h>
+
+#ifdef CONFIG_REFCOUNT_TRACE_FINAL_PUT
+/* Declare the tracepoint so tracepoint_enabled() can be used */
+DECLARE_TRACEPOINT(refcount_final_put);
+
+/* Wrapper function implemented in lib/ref_trace.c */
+extern void do_refcount_trace_final_put(unsigned long caller, unsigned long ip, const void *obj);
+
+#define do_trace_refcount_final_put(obj)					\
+	do {									\
+		if (tracepoint_enabled(refcount_final_put))			\
+			do_refcount_trace_final_put(_RET_IP_, _THIS_IP_, obj);	\
+	} while (0)
+
+#define do_trace_refcount_final_put_cond(cond, obj)				\
+	do {									\
+		if (tracepoint_enabled(refcount_final_put) && cond)		\
+			do_refcount_trace_final_put(_RET_IP_, _THIS_IP_, obj);	\
+	} while (0)
+
+#else /* !CONFIG_REFCOUNT_TRACE_FINAL_PUT */
+extern void do_refcount_trace_final_put(unsigned long caller, unsigned long ip, const void *obj);
+#define do_trace_refcount_final_put(obj) do { } while (0)
+#define do_trace_refcount_final_put_cond(cond, obj) do { } while (0)
+#endif
+
+#endif /* _LINUX_REFCOUNT_TRACE_H */
diff --git a/include/trace/events/refcount.h b/include/trace/events/refcount.h
new file mode 100644
index 000000000000..a4dc23aff93b
--- /dev/null
+++ b/include/trace/events/refcount.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM refcount
+
+#if !defined(_TRACE_REFCOUNT_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_REFCOUNT_H
+
+#include <linux/tracepoint.h>
+
+#ifdef CONFIG_REFCOUNT_TRACE_FINAL_PUT
+
+/**
+ * refcount_final_put - trace when a reference count reaches zero
+ * @caller: return address of refcount
+ * function(refcount_sub_and_test, percpu_ref_put_many)
+ * @ip: return address of trace wrapper macro call,
+ * inlining may cause it to be something else tho
+ * @obj: refcount object(struct percpu_ref, refcount_t)
+ *
+ * Tracepoint instrumentation can be added using the do_refcount_trace_final_put
+ * macro defined in include/linux/refcount_trace.h
+ * which uses _RET_IP_ and _THIS_IP_ for caller and ip arguments respectively,
+ * thus only requiring obj arg to be supplied
+ */
+TRACE_EVENT(refcount_final_put,
+
+	TP_PROTO(unsigned long caller, unsigned long ip, const void *obj),
+
+	TP_ARGS(caller, ip, obj),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,		caller	)
+		__field(	unsigned long,		ip	)
+		__field(	const void *,		obj	)
+	),
+
+	TP_fast_assign(
+		__entry->caller = caller;
+		__entry->ip = ip;
+		__entry->obj = obj;
+	),
+
+	TP_printk("caller=%pS ip=%pS obj=%p",
+		  (void *)__entry->caller,
+		  (void *)__entry->ip,
+		  __entry->obj
+	)
+);
+
+#endif /* CONFIG_REFCOUNT_TRACE_FINAL_PUT */
+
+#endif /* _TRACE_REFCOUNT_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/lib/Kconfig b/lib/Kconfig
index 00a9509636c1..12bc59515a3e 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -52,6 +52,14 @@ config PACKING_KUNIT_TEST
 
 	  When in doubt, say N.
 
+config REFCOUNT_TRACE_FINAL_PUT
+	bool "Trace final puts on multiple refcount implementations"
+	depends on TRACEPOINTS && DEBUG_KERNEL
+	help
+	  Trace when a refcount implementation considers refcounted object dead.
+
+	  If unsure, say N.
+
 config BITREVERSE
 	tristate
 
diff --git a/lib/Makefile b/lib/Makefile
index f33a24bf1c19..e75e88f0c870 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -335,3 +335,5 @@ CONTEXT_ANALYSIS_test_context-analysis.o := y
 obj-$(CONFIG_CONTEXT_ANALYSIS_TEST) += test_context-analysis.o
 
 subdir-$(CONFIG_FORTIFY_SOURCE) += test_fortify
+
+obj-$(CONFIG_REFCOUNT_TRACE_FINAL_PUT) += refcount_trace.o
diff --git a/lib/refcount_trace.c b/lib/refcount_trace.c
new file mode 100644
index 000000000000..2476bb5f2f60
--- /dev/null
+++ b/lib/refcount_trace.c
@@ -0,0 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0
+#define CREATE_TRACE_POINTS
+#include <trace/events/refcount.h>
+#include <linux/refcount_trace.h>
+
+//Wrapper function for functions defined entirely in header files
+void do_refcount_trace_final_put(unsigned long caller,
+				 unsigned long ip,
+				 const void *obj)
+{
+	trace_call__refcount_final_put(caller, ip, obj);
+}
+EXPORT_SYMBOL_GPL(do_refcount_trace_final_put);
+EXPORT_TRACEPOINT_SYMBOL_GPL(refcount_final_put);

-- 
2.51.2


