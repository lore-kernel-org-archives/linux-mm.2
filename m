Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AFB6C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 04:41:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A6EC6B0088; Sat, 11 Jul 2026 00:41:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75E256B008A; Sat, 11 Jul 2026 00:41:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61F356B008C; Sat, 11 Jul 2026 00:41:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40C8E6B0088
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:41:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C61D01C3DBA
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:41:10 +0000 (UTC)
X-FDA: 84975246300.01.BC9CA3E
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf28.hostedemail.com (Postfix) with ESMTP id E7304C0004
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:41:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=i9Xo9o4D;
	spf=pass (imf28.hostedemail.com: domain of m@mavick.dev designates 80.241.56.151 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783744869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5fRYBbl/zFHo/ph55CpxjBKpforkcs9UdExdzuIQ868=;
	b=p9uYo8bq/cbDpIhIUK2yJ56DGQrKj6QvfIupwx3HpiSwRN1fZRg1IIxK4vs4ZKpgN81AYi
	FaQdmRp/0rkwlB2Ggot8IaC02tmvp4JXQM71HPSaKxpF4lu0RMj276odhjxuLPhj89LaPa
	TjcUilxPm1MB4GbITfPzydUWvr42/OU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783744869;
	b=6zDIEYCt0owsuNu2JMKv8C75MdFznRpqF6yMsPCJi+tfy1DWFDkw/1QBommFxIk4a0EKYq
	jzodjzsDS43iKkaYoL0ha4G726Y1C52nnpVZnezw3nFhbMAJqFwT+c6pP/eR4+DcyBDmB2
	N1U5uyZBRwamBwOoCiLD3SJ3ElZxDQw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=i9Xo9o4D;
	spf=pass (imf28.hostedemail.com: domain of m@mavick.dev designates 80.241.56.151 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4gxwxt41NSz8v1p;
	Sat, 11 Jul 2026 06:41:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mavick.dev; s=MBO0001;
	t=1783744866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5fRYBbl/zFHo/ph55CpxjBKpforkcs9UdExdzuIQ868=;
	b=i9Xo9o4De01YdLlfiFfiUO4cTTk+rdHz9XoaG27qFEXE8Dr2HpfhUlzoH9sqJ5FJ5+S3p2
	1UDvwaIavR7TQSjMd2scSqfFieEPssjD9yEbWuGaHjjl97INZAgw7UhSqPXsG3KssX5oKj
	xcgRhqffsfD+Qinnf1y0HAwo2t3xOrQyoHAKk1EHFp8fI/j/FMWUnVnO2oX/J4Or3eKz2y
	pJrR25bJCRYlGvZ+653qV72ImAm3q310S/yZD0u5B2l8qrtCocQ/vcpNM6NYglC458J0Ep
	lv/gn1+E4i0utnWL+Kf7TIy7X+dxPN3rhbY0b8GqJxF3X25uA6atUto+AAsYCg==
From: Eugene Mavick <m@mavick.dev>
Date: Sat, 11 Jul 2026 12:40:19 +0800
Subject: [PATCH v3 1/5] tracing: add ref_trace_final_put tracepoint
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260711-refcount-final-put-trace-v3-1-674c8f03d9f9@mavick.dev>
References: <20260711-refcount-final-put-trace-v3-0-674c8f03d9f9@mavick.dev>
In-Reply-To: <20260711-refcount-final-put-trace-v3-0-674c8f03d9f9@mavick.dev>
To: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Boqun Feng <boqun@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Gary Guo <gary@garyguo.net>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Eugene Mavick <m@mavick.dev>
X-Developer-Signature: v=1; a=openpgp-sha256; l=4418; i=m@mavick.dev;
 h=from:subject:message-id; bh=togALykcuUOAaOKZnU5+keMWktwavqkGC+6SZdVlIpU=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFmBJ20vBxSl+CqVOyzui55aOcfuqR/rIrPjf5PmrK87L
 bWtzWxSRykLgxgXg6yYIktNVoJ7xspZicZHJ/XAzGFlAhnCwMUpABMpNGT4K/dCtMKuz5OT9X4p
 /92Sq1Pn3Shns5Xlrl2m2WT1xm5bFSPDCo7AM3P+er9OesvRs++ogfkx9pdPPt+sDmyqMPwXWHe
 BGwA=
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E7304C0004
X-Stat-Signature: nn8pi9esbm7kke61azne8difx9qj8i35
X-HE-Tag: 1783744868-194737
X-HE-Meta: U2FsdGVkX18KItUsrM6Uo+uKHjW+Cpm/JIiZ4Grpe+AXs1Xbj8tab/z+NV9o/deU3HbGCXK/HuvIN9gVqMKzH5PfzG0F/jGwSvOhIjTH388o/IWDPX5gChkquba1LXQqwRssvdBL6QQOfIUZ65jw4f00Hul1Vxl8F45LtMOkZ3xgJheXFeMTApHPVAiTatW+SlIk15dwSUI80j+jQlUVtOHy4MXxcgRuYsJJxPuIVgY9hhJdM6J/K2+gjldIbSvmOLkAmphaXd08Rvw8s6WtN5+/qfKRuegCZFH9B4dol1IzwVTdgfv98r0py4wQWW2ZHjK4u19aPpOza8npFCjfNcOAvwiHbopecsdjKRjtiqcgOXt7d8kGZeuhkLe7Pn6VISXvw6j2fshKYmE66OW0yNK8RLf3mKyOzO/OCjXZwDD7TtE0moyVLLPUnaMHNSj8f9iao0iqcYEWN+kabBdUaB/6HicBFsBXjEW7BeF4KeRg1lrPkyIMzW6sY/3Do6sBHce6SEU2+MzpsVZBpxcCQyuJ3k9dSjagkfFD+35ZKHwvlce6c1KtXs1NINrn9DcCO1v9ujb88J1wYU+WtqitYeQPyOUtCHsv0mTq8KSM44hdVUNTenSHamboUDDnd6mPcvMhBVvkAstEU3bVZfIU4JscV5nYUCu6U976Hxo4ONBIbMHbhEaHQY0AUtucEivf+8Ab072syrb/ydULxD3/TUth2XtXk40jqTTyM/PDOpLESYxLBzQYfGhoIS7g12ynFLZT3/kQNNcIj9Usw22S5D1eImu++kJV4eQ7b0sawgEtpklI/aWhHn/+gDHxsLkvCsLKHD7YubBDx2VcFUsjNxI7Fx4n/ix2qrjA8BHhmOmpZ5r8n08vR+awIe9Cc0O8QilJ0V2+4aiEy+TR96NGwDrBGfIpjR0aoW+2EpQifExJHof4DvLg3LBkS+vreSY9RtNerA2GjmNA3saFP9+
 WBQI5bGP
 ECdGfLcAtAbR1l6fE/3vnNbre7zG/TauPlqEgH4iek17aPMQjIuEzMopjw+1T3F++OrQBfHCbXKYdCdfuvpwBhP6Pw7uOydwx+neYNPUMGCAIc17s81FGh4MCzD4lvLG4vHsU4wx0rcvaKXD7ew31MwNdzybYPV6y5h2UG6/JmYF5DDmGDSY2qxu4nxZGDLWD4WB7cb433Pttx0PKueuMYPUNKhwYMKoL4iKNrpDciXqvNd0F3IsAjVkUF6ZYHx5pA1NJTZWYG/CP4LMZMuchtMkNl+20WuJ8R/S0Y7oInq0/GP98V5wu87KCfdDSVVux8ogW9o4ow5hR1+d6rmip2Oc6IqqOU0d3i9j/
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
 include/linux/ref_trace.h        | 26 +++++++++++++++++++++++
 include/trace/events/ref_trace.h | 46 ++++++++++++++++++++++++++++++++++++++++
 lib/Makefile                     |  2 ++
 lib/ref_trace.c                  | 13 ++++++++++++
 4 files changed, 87 insertions(+)

diff --git a/include/linux/ref_trace.h b/include/linux/ref_trace.h
new file mode 100644
index 000000000000..6c6600938a47
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
+#define do_trace_ref_final_put(obj)						\
+	do {									\
+		if (tracepoint_enabled(ref_trace_final_put))			\
+			do_ref_trace_final_put(_RET_IP_, __func__, obj);	\
+	} while (0)
+
+#else /* !CONFIG_TRACEPOINTS */
+static inline void do_ref_trace_final_put(unsigned long caller, const char *fn, const void *obj) { }
+#define do_trace_ref_final_put(obj) do { } while (0)
+#endif
+
+#endif /* _LINUX_REF_TRACE_H */
diff --git a/include/trace/events/ref_trace.h b/include/trace/events/ref_trace.h
new file mode 100644
index 000000000000..3bf1b1d390b8
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
+ * @caller: return address of refcount
+ * function(refcount_sub_and_test, percpu_ref_put_many)
+ * @fn: refcounting function(eg refcount_sub_and_test)
+ * @obj: refcount object(struct percpu_ref, refcount_t)
+ *
+ * Tracepoint instrumentation can be added using the do_ref_trace_final_put
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
index 000000000000..466647772ce1
--- /dev/null
+++ b/lib/ref_trace.c
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0
+#define CREATE_TRACE_POINTS
+#include <trace/events/ref_trace.h>
+#include <linux/ref_trace.h>
+
+//Wrapper function for functions defined entirely in header files
+void do_ref_trace_final_put(unsigned long caller, const char *fn, const void *obj)
+{
+	trace_call__ref_trace_final_put(caller, fn, obj);
+}
+EXPORT_SYMBOL_GPL(do_ref_trace_final_put);
+
+EXPORT_TRACEPOINT_SYMBOL_GPL(ref_trace_final_put);

-- 
2.51.2


