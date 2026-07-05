Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DD64C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:43:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2032F6B00DD; Mon,  6 Jul 2026 02:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DB826B00DC; Mon,  6 Jul 2026 02:43:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A33C6B00E6; Mon,  6 Jul 2026 02:43:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC68B6B00DC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:43:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A13A1C249C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:43:24 +0000 (UTC)
X-FDA: 84957410328.12.A130E32
Received: from mout-y-209.mailbox.org (mout-y-209.mailbox.org [91.198.250.237])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8E6A7140006
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:43:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=mavick.dev;
	spf=pass (imf09.hostedemail.com: domain of m@mavick.dev designates 91.198.250.237 as permitted sender) smtp.mailfrom=m@mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783320202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yOVKcthDGvAJ8dvBG3cmLRLG3KzkQv//OuPlDX5LVp8=;
	b=3ID6IH09J1IPLbKt3QEpNoQasUtJwUKK7c1y8vxqALRgdZrxBMN2vHIrvIT9Xec1mse2PU
	FqW/Bzj1A7mmdfaihR3IAgZnXqXG16nXPubHIU1sANpTV+Om6cRY/52s5d3Gc9A2zyKfcI
	Se/x2dPstxQNrsKCnBwZLNQI1o5+GzM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=mavick.dev;
	spf=pass (imf09.hostedemail.com: domain of m@mavick.dev designates 91.198.250.237 as permitted sender) smtp.mailfrom=m@mavick.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783320202;
	b=guODzUP3HwbgkMvfaZ+E4PC4URDbBAyVSZBfvt3Oxr24UVpjGhR7CYYvgECAk+gUF+BmHX
	W9aZsUUleqht8X+npQcQ3WFPz3zt7I5KHHH3Mqve2wgmZ64YHyXAmdGJvCwzgPXezEQzng
	Jaw6DyMTycGHiGpjITPEiWco6r48ZiI=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-y-209.mailbox.org (Postfix) with ESMTPS id 4gt7r03qBCz7vTv;
	Sun, 05 Jul 2026 02:37:52 +0200 (CEST)
From: Eugene Mavick <m@mavick.dev>
Date: Sun, 05 Jul 2026 08:36:56 +0800
Subject: [PATCH 1/4] tracing: add ref_trace_final_put tracepoint
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260705-refcount-final-put-trace-v1-1-a41d3fd0e869@mavick.dev>
References: <20260705-refcount-final-put-trace-v1-0-a41d3fd0e869@mavick.dev>
In-Reply-To: <20260705-refcount-final-put-trace-v1-0-a41d3fd0e869@mavick.dev>
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
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFmey20tX0Uv+uo9wcO1T/IDF/s+XU9nj3XtiUxM00Jnn
 2Bi49neUcrCIMbFICumyFKTleCesXJWovHRST0wc1iZQIYwcHEKwETWVTL8T2+7m3q0rGDbIYVf
 tlNavGeYX9rGcrNgn13McuubTG885Bj+Z4t5HgmRc08+Wnty8xrdb2GHFuzybQq7eF59bYOWdoM
 mIwA=
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Stat-Signature: nwhkad1g7jtnmta16yo9rmeruijcs9bb
X-Rspamd-Queue-Id: 8E6A7140006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783320202-664514
X-HE-Meta: U2FsdGVkX1+90gBPBtCoBnrUtWq+91g2r1QKy2koc8PSgty8S6lCxHcuMneCiALQ1CO4+mXQJGgZt4h+Ed1HhTiWCCH6PhQpri+5Ypw/T5g+4F4/CmL+odZ1c2JUz7RWi/clwT+t9xPfahUXICNzZjMrjLV1RCzFE2VgI1UgWyqz51Xg1KILnLsL2Tez/cSsB+NhD4EirvUfqyfIKA4NRD+qdiFho6URDMzHpA+b7YVfnbfAF6i3TIxDxrg7ZTunOJ0C9G20fF6g2gPdFEriBFaE9p9qe2+VmczJtOQnYrk4new7pRcvhNr7PTTs6CPrL9ZK7B+HPgwG0uU8We/vU2ZCYatvOWfiQrLyGeZOAlTMhyWZznKc7PuqGaxw2PpfrYLMOjPQonEOy1lwO/acs3r8OJlVpOGuK5/fC1fHN58tQvHTFZXW3pRB1X44RwfQcBQuN7j9J/5jtmUO7lL+YVh4zhDAMQcLQE3RrAjpttMcPqv5dcoX2cYDGRK7KD/ojlSYOd2AFFwlEgVu+J8FGjV6syEbSfD1W9IxMOAn+oRhmVXsSgAPlyuOfp71hna3DjHPfaEAIvIhL7xfsSgs+7nDL1MPn2ZMyEQokiKzLV3BZAGS4yCBwbxjeNA1Qq4wP0PJjfHsNKwBAQlBVbGj11enULQtPEKOFdEIub4QtlWLROYOtBun/dyrel4G2RpXsCEDorT55z8v8VSKLqgFAkN/r3GILp1cua3poePcozR2ehm49IMyNv0s7fqvjKG9R3tyP9Af+j3lFQQk8jk+Wz7N1ZKqwQQd1iM3+cpKFJx082rLAPXhETbgWyweGV9Lbw9RM53FRleB0+nw2fKtFAPNAAcq4Xfy7RpZJ2Gn7F49q3/PlrRcyVHFEK9EXhNbsY9DqiCpi/mcE+lZwsZR4DzGhENf7NbgkuETXLA8Vk3xkfs6vALLm0H052M1N0aFuAcBY+B11mUKfyT0wsk
 oMt16t8e
 JpsPFJL7KZmp4OAtDWtzwZYuIWT90G3PMGTYmVpJRG913cgkBpqgkP6H7RBkL3vp5ZT6woPgLdPVCd0KJ36AVGTiTtobxc2dlRpRGyfQi6ovZQjbYFwve1on5OADgLlHegKw65bjZQtk2qaA8ZuxXdCKhC9TNbD3rK31EyEd5Zlo5l6kZWVSlUPO6HIR3pQOo8d6SAOEurBEkMBJzuKBZ0xNfMbwtWCo9NvB5MfIMvyg2bMIXRyY2VbUOM44ZiWah8hjg
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


