Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 578B5C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 05:31:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 728C76B008A; Fri, 10 Jul 2026 01:31:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CB566B0098; Fri, 10 Jul 2026 01:31:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 445E46B0096; Fri, 10 Jul 2026 01:31:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 006D96B0092
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:31:19 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 80EE6169395
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:31:19 +0000 (UTC)
X-FDA: 84971743878.15.A137627
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6AD62180004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:31:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qoyoHKwz;
	spf=pass (imf16.hostedemail.com: domain of devnull+m.mavick.dev@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+m.mavick.dev@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783661477;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fHHmiJENkWsfhROlt4Yp3Jnrg+0OWDYSDCspkW5xc7s=;
	b=0RDVYvWCxZLkCaC3TmiQteqTen0xFKfg0S36SH/hVPmw7MPH3LiSVr5Beja8flMafpu7LP
	MrRRNFS0p0J7t+Gd9gA7XDEz1xV5oR6nrD6Y4DVMqnU0vhs0FUUYOsfWmcQ0cDGt1fHaFH
	+gQf+8NLDTNYYwfgjERW1icU1SHuunc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783661477;
	b=xnYFZSmltrCKR4k553WPmko+BEhE2eDbkzLZFIzNYKOOAPqPcM+km4w3QEks7F+1SpfMm/
	0c7gnyZYu54lnRQW4X1bXD6h+Shr9zpDzA1vamtiZ4FZDdP/H6luBD6q1yiO22N19Vn4Lm
	PdebQX7WVOATxklcWSfciaQ3qkp0x0s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qoyoHKwz;
	spf=pass (imf16.hostedemail.com: domain of devnull+m.mavick.dev@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+m.mavick.dev@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3DAA244004;
	Fri, 10 Jul 2026 05:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 13958C2BCB8;
	Fri, 10 Jul 2026 05:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783661476;
	bh=sJwNGf50ntTffD4/Akpa0xR1rlsG3ZrhWjyIlK4Mk08=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qoyoHKwzoiP05HCTetHmLNHeovi0PBuuKIpAM3oXyCwMTQyvrb3PxZbDsNJQ21FqZ
	 qoOyASbGcMF/UWWhC8a0dcoaN83b4n3d5KyKJFAt1wMy8qZ65YkshHhF9GcnnNAK9R
	 y8+7bZnUm5TtZEEdFq+nZgpwoIvUT0uThyWVbjqbhF+uJjrjWHtshiNFAXF4EgHDeH
	 4kjSk5gyAPRh2YqwCCpGNk79AjrkzhPC8MzAjtPglXbDBj1QgcOhEtGgkJTmMUI4CM
	 WCJHLIl+Xt6MAS5ABuGcVI6vxjo+dYgM1+Up+rg/puVkD4+KpVE5TSYaXJIKLiSfwR
	 dBKZULiGiOBiw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E912AC44501;
	Fri, 10 Jul 2026 05:31:15 +0000 (UTC)
From: Eugene Mavick via B4 Relay <devnull+m.mavick.dev@kernel.org>
Date: Fri, 10 Jul 2026 13:30:39 +0800
Subject: [PATCH v2 1/5] tracing: add ref_trace_final_put tracepoint
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-refcount-final-put-trace-v2-1-557cfce860a2@mavick.dev>
References: <20260710-refcount-final-put-trace-v2-0-557cfce860a2@mavick.dev>
In-Reply-To: <20260710-refcount-final-put-trace-v2-0-557cfce860a2@mavick.dev>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4782; i=m@mavick.dev;
 h=from:subject:message-id;
 bh=qR1tr9zkvfO0Ekv8EXksBaXJupN2DKoOXEp8ReORpQI=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFkBzT0KGade/c9KdFHS3h8rXtH3ZPqyLVL5tiWiZ997v
 /MXTEjsKGVhEONikBVTZKnJSnDPWDkr0fjopB6YOaxMIEMYuDgFYCJvtzL8z0vLdXzxyiZUwe4R
 x0+dqs6sZO7uVRfrkp6uPSuhM9t4G8P/0kO8PGqhJzoeq/yr6Zf+scT6y67vgcwLzlpFrnlt3qL
 CCwA=
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Endpoint-Received: by B4 Relay for m@mavick.dev/default with auth_id=850
X-Original-From: Eugene Mavick <m@mavick.dev>
Reply-To: m@mavick.dev
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6AD62180004
X-Stat-Signature: 7f4irmf6h4pte9ndw75zpdyrfaw968rx
X-HE-Tag: 1783661477-876374
X-HE-Meta: U2FsdGVkX1+FwNkxAXL8+7OmbNbLCa4RTWVbwQutUplTFdvoyJCxN4GxmVJ35+wUUTU593eUWTwXbE+PRY3ej6Aswb7ruaO3AZ1d36SiWs4oq6HVCrxwtyOG7Tl6VQ6PlHOBKrNTG220qaVoMx0W4WcgHSrSJY4lq0CytOLsfc2OkjRiLqdpgKCkZVKhPNtxdJBIypBT6zyJNMzzCEjTsYCajKetBk/4emN5YOhLCl9mNDttBFShXMGELkg8xwiUbtS/eghKxlgqpfyVjuBlI0Iag/WJL/kHx5RpoHSAgStkcczUFzbQ4llMK5CsgXeVdMO2Y0QJxL9vXvD3toBtzKlYrm2N8r+ZZ7fx7LZKMh2X01AqC05hDcVrcKbmZjWTv/8eAGfsJc3C9LKNNSZBEeY++G+EwTneiz2xOxh08o6Hlt7w1WEwOYq9bt+t9TT2FaxL6PqJ5nIaMov4vVuES3wxqAamjGHBpaYhkFxZGBgBX5lPU5D2ZodHhoUwzj4EEI+BOu5ZWG2K1BeAri1oBlPVCwqUY2ejKY2Jza6otB5SsFGZMNlx6NzgjovQj80Ahgs4tRN6Aw+vm9Eyu5G0QrrMXheHSc+UQVKSrP3mZ0MfUq465V4r+sq6s9bXPIY0b9KzVeWDm7A4wd8lYsnWViNXne/fwnSN728UzsbSSS6lp35i0UqO8W118d0AYoSG3ueExhz86M0pzEBe/1L2T+hIMFOISzyMy2vOLl/rUvOxJA0y10IXnEOm0O/FFvMGnt2DWL68pjWfC4OFH3z9jwT0P9h8b208+hJS2L0VbrRdojJsh7CwiYl/f3T2YL3sooe5E0ovpo8IIg23ngKRtqmMBp+WwoHebhYY1KWeMxzTilHCMUkXZ5CNlbVVlqwklZrxRl+C+VIaxhMSXjerplBuRYsqQolVyvlVqYylSXLVprh/2sko3yfOgBvoHYRpoR+oKsBSPp6o4oO9JYA
 RMlK8RCL
 EM/b5IVym5hVtcGspUDaMQHk/+5FfX9WF/giPwZB6fJxHhK23wV8ojviYChxI4rXSCw81NpLSQWPDossan8EM9iURJPuwFESij8y6/eSA0xE61gjai0MTLjEBmDtBQu+23Vy6PkSzSlGuSzIb08nQbd0QPRsmrWSJKqrMrYK6AMgu3hd7KZnWM2k2Et9mQfhGaFkGixpPg33aafeH6xfm9D0o6hOa9gi85WILoLu1WeLCV0BKVv5vBiZJIgWxj7+Kgq+JmREzKC3q0WFoNC17IYf2KVyiRj1vblvVrMQECpP4oyFbXv52dA3biKUpiGtAvywFCTkhzMB78XdLvPc2qHHPwggDX5a1Hlf6RKvRDEftKBCHn4MXff0UwhOGYJD54nNNqfFd8JBX2fpBZyTZUfMHs4N4GzByCPrwSx+1605M/dL0ZmaNkL9YRaEYDqBT2S1+X9jM5bcnIwwLI0r4ilQgR9cRRRJ26aHdaEeclE8tJdCI2eXbUr+5gQ==
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
v2:
-change trace_ref_final_put macro name to do_trace_ref_final_put to
 avoid overlap with tracepoint names(trace_*)
-change, in above mentioned macro, from trace_ref_trace_final_put( to
 trace_call__ref_trace_final_put( to avoid double check
-changes suggested by Steven Rostedt
-v1:https://lore.kernel.org/all/20260705-refcount-final-put-trace-v1-1-cdd0014626a9@mavick.dev/
---
 include/linux/ref_trace.h        | 26 +++++++++++++++++++++++
 include/trace/events/ref_trace.h | 46 ++++++++++++++++++++++++++++++++++++++++
 lib/Makefile                     |  2 ++
 lib/ref_trace.c                  | 12 +++++++++++
 4 files changed, 86 insertions(+)

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
index 000000000000..9102dc7117db
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
+	trace_call__ref_trace_final_put(caller, fn, obj);
+}
+EXPORT_SYMBOL_GPL(do_ref_trace_final_put);
+
+EXPORT_TRACEPOINT_SYMBOL_GPL(ref_trace_final_put);

-- 
2.51.2



