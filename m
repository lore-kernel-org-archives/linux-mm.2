Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B196C44500
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 01:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 304DF6B00A4; Sat,  4 Jul 2026 21:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D9496B00A8; Sat,  4 Jul 2026 21:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A0C06B00A9; Sat,  4 Jul 2026 21:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D05E86B00A2
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 21:21:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 39FD31405B9
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 01:21:22 +0000 (UTC)
X-FDA: 84952970004.13.905F7CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4D1CA80004
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 01:21:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jvmxeLw7;
	spf=pass (imf02.hostedemail.com: domain of devnull+m.mavick.dev@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+m.mavick.dev@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783214480;
	b=0JX8h8Y3jr760zHCezw+pj2Kk2jv2tZHX0tDAiuwUz2ngPuMb6BZJcv+SqNJj4XiE2ULBF
	nxgh0mUHxclwmvr1MkmfB4tYQbioQxVv3nSl4BFyidHn72+2opb1cZ53okqD6xSVBsdLwI
	z0QlkUVQBYrh6ikQs9ScXdOMXurux7U=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jvmxeLw7;
	spf=pass (imf02.hostedemail.com: domain of devnull+m.mavick.dev@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+m.mavick.dev@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783214480;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SWp55qF8lp7nUmSd+/1IgTAL4bMKgyCUKaX0YYGnAFo=;
	b=sZZWsgQsVQ5UtNUMBVqq2zASWVzZ8udCJ5nvCzabBshwvHCRPE5+Hj31v4upI54WYPn+Sq
	UtGDcLh/WWybPetuQiHlKAX18QmPNhQc1ViLwftm8hKzPkSE7+/WFhw1QV3o5V4I3te12O
	3xsY3ueG6XlPfyYKxD6ZPXY5YFBZroI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B26A86111A;
	Sun,  5 Jul 2026 01:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3325CC2BCC9;
	Sun,  5 Jul 2026 01:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783214479;
	bh=OH6pUiTJHa8HI8N9mb0rE7HnMbkqq0RnkKcjwUxyeNY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=jvmxeLw7VGxdlFScMXVVocyappEmmFra11a9Ypv+johLhCrIRNbqWfzfbPrdbNqGs
	 gnNw4SpYC0hwMbplA51iDLflblhzx5JDxyFT24o3dPrzNbi4Pd0hgTA9zeGIl3zT3e
	 cOm95S3m4R+TyYKhM0dtXvJP91CZETfMdgv4fLJKBywZuVdPGZ28y6br2iQH3VXtS6
	 XOdGNDypT6X19fC/z236NHkujRYyDeLywWb+f5eqEzVR2+Z8cgKa/fvnZLd5H7vBeY
	 Zo36nFwr97x2e9x1971T/jwqBnWxXTL93lx04Mbwssy9xdwp11OyAw5Mu1BZc214zz
	 lEYR0ePq19CKg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD51C44500;
	Sun,  5 Jul 2026 01:21:19 +0000 (UTC)
From: Eugene Mavick via B4 Relay <devnull+m.mavick.dev@kernel.org>
Date: Sun, 05 Jul 2026 09:20:51 +0800
Subject: [PATCH 1/4] tracing: add ref_trace_final_put tracepoint
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260705-refcount-final-put-trace-v1-1-0ae936edb750@mavick.dev>
References: <20260705-refcount-final-put-trace-v1-0-0ae936edb750@mavick.dev>
In-Reply-To: <20260705-refcount-final-put-trace-v1-0-0ae936edb750@mavick.dev>
To: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Boqun Feng <boqun@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Gary Guo <gary@garyguo.net>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Eugene Mavick <m@mavick.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4836; i=m@mavick.dev;
 h=from:subject:message-id;
 bh=qHwnbzvpK9wYBzbeGmnuCtzzLwF8aY1zM3ldVu/OfqE=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFmeGytvvJdkW+ErErKj6k0+85WG9YriqcYSvQejHn9Ms
 jVO00zvKGVhEONikBVTZKnJSnDPWDkr0fjopB6YOaxMIEMYuDgFYCLM0YwMHyQd7QX+uVTEReyb
 seZ+3NcZe/WkUlxNzyyccvdIR77dW0aGqWHH00Pf+12tT5go+jD06wmDUtXodzaq3R1N/ald01S
 4AA==
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Endpoint-Received: by B4 Relay for m@mavick.dev/default with auth_id=850
X-Original-From: Eugene Mavick <m@mavick.dev>
Reply-To: m@mavick.dev
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4D1CA80004
X-Stat-Signature: em3rfjyswk1ns7xrieio7w74kh9bexes
X-HE-Tag: 1783214480-391289
X-HE-Meta: U2FsdGVkX18WgDLdotaF2743RL5oYrSzfqE8hyK8WNg6N5miGKg8hAC5NsqYfhPuvsmnE5sokmGrPlemYfLtScyvRdwDgI+c3EKEh6jnuPIETHU0SlLee3WoutkKAtDpMX/NGczGDIEA/+Zbr2kMEnxypv/GscG+UETrptIZ7DuWKER+KBkCZZRVJKr1Mig+x0y0btC+wo8AbzE53piHmIJpwohsAJCqes1NnicLZn1/gQ2AczBvU9vroJPP+Aal858azhwaVlpibXkLtDvvcDQVdfagjH7kjrv+aGKem4IHYnX8G5GrtAcw3FvB2ilpevLw7o2DwYE78xto4nfCRVEMlNNVwuKupfCOeEyG+whG6o9n1R9+aPTndxYYv3o/0LZDeCCNX9NVATmK9QDz/vzrXWLjBqqZBgq0xciOKJH+XUotzShIkkVh3Y9gbE5mzyD/cMP9wFFDceRFqJIlPwRN8BmNEkzNqsPqOpyeWZJD+5kzzQoJihLEYx039UB0LcwtuwZafIrgTecAQUe6OJwaxXLymP6PLCZp11XUiDTBUMVeX1YwoDKCOIqFzfyiIGydetcjFqmeHk5Fgl7s1fhqzzYzXBjrS3itqRZLdzdGq2Jt3mCIUyj6+87pwiVY1ZhYYfokBDjFGKC/dya4ssPP+6yhwXaeDRiq7Nqjemqgx+aBx/LDeKLNgWe8JWULZcqEgmaRNec5CkuCUCaHu1w9cCpGk+CJGLKEVFZHuMycRgxYE+/DcsmdFgyevQgssm/IQNqgvVia8TNZ57u8KETjTUF0k7W/8kTfDeJYyZpl1Hb9CKoV0Pts5tEXdbAmV0AfFE2MJyLAtXdKJtu0WzoxgA8tHeE+GczWP1aa09MjFW0t8q2rpqv4VqrtxJcXbMZ3j/rK0NRwU9B/L3owbyeupJA0mQlfaZdSLpwDFcBx8egg7onp3lHX4LoNCM8b/vNQXuK25675IrvaU6P
 eaLVjFgf
 x9sLlHIvREHVdSWQDIZdXu2mD3lRZGlM9pw840R4Sj/fWjMV6GGAP8ykql6xSDrKmbYO9X7o/vmdWgmOKoxNDPPwSG4PoCAKRoVANAEl2a8TFfYaUtm5AlXXOKi9Feyb8ewM2irU1S8YmyH9TvNaV/xanB7MQyn/3dpivhuvKK5sCjGEN+bBNqa2k5IWlnOGqKCYWyrixcW3xNqkKUYgtQrKQiR9yweUzCV98JmcExH9TLupoazSlRRlWc3cZxlcKkzxXL/TYCR1DbEShTJVYYMhoW+opPWlFYLrKKQ8XjNd9Zkbt84LnEgNJyozalNQocw4I4+aVgzo34Scjy6H0sDhAeO3QVrkbraajSdX5781WJ3tS+WfE9nBGS1dPalSm7bygdQghoNCqBsa36pB798WdOuTcP+e9TJucrG08mKSDHwlAFZ07Kvmsug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugene Mavick <m@mavick.dev>

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



