Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 262B4C982FA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 21:27:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA2E56B00A5; Mon, 21 Sep 2026 17:27:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2BC76B00A6; Mon, 21 Sep 2026 17:27:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A60C6B00A7; Mon, 21 Sep 2026 17:27:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 556C86B00A5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 17:27:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CE9BC140116
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:26:59 +0000 (UTC)
X-FDA: 85239054558.23.48278C5
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf10.hostedemail.com (Postfix) with ESMTP id 24ADBC0003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:26:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z4zEFwah;
	spf=pass (imf10.hostedemail.com: domain of 3IKGxag0KCIUjkqr1qntkjyj2pxxpun.lxvurw36-vvt4jlt.x0p@flex--abhishekbapat.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3IKGxag0KCIUjkqr1qntkjyj2pxxpun.lxvurw36-vvt4jlt.x0p@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790026018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dObMqg9/Qyt4/t/40pZAxqs94G9neMmesRffkXIevgI=;
	b=pCnPDyxwxlwCsXGYcZEE4qvvsLcat4XZs76n2QfTq1Z9NdqWffNu/Qfh0AXYBeHlaXcqAx
	ReJTGod/z2qqsRqoqxQOChQiPYzBs9oC66WAGnQwmjoBCJxoo+02n6ILLP3lz9XZHtaiwh
	O5s/uqO5Op9Z+jwaKLLUDU8B4j6Ao4Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z4zEFwah;
	spf=pass (imf10.hostedemail.com: domain of 3IKGxag0KCIUjkqr1qntkjyj2pxxpun.lxvurw36-vvt4jlt.x0p@flex--abhishekbapat.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3IKGxag0KCIUjkqr1qntkjyj2pxxpun.lxvurw36-vvt4jlt.x0p@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790026018;
	b=ZgsUqMj2+CHcLTB5nuyQ0Um5wWRQYnuZo8KKPPMQq8MbL0b4cIzCtws0xC+58dvm9mkqKO
	3YdrGrT0MnhHhrwxU0sP7BpcZ3nY2qPMAJtEkRioR6U3lUeleLAdNo/uZ5mzA1+IqUeLS5
	yxl0BR2OoRS1B1Ysn63OTL485C4PQTA=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c89704da8c7so4649626a12.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790026017; x=1790630817; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dObMqg9/Qyt4/t/40pZAxqs94G9neMmesRffkXIevgI=;
        b=Z4zEFwahT8jktpCmy0sB6aJEdx3JyKiOOdWgHGc9IX8jGabmhcVZnuJnVEVIdJ+aSb
         C9Us9VX1u1seTxaHrCuOTmhBypWUoiord1zV0OZerwkJbCNUa+gHHGLKOsQoAkL9YUgd
         MLV8IgpCrrANPgsiXjvrsRRmyo/OnFBnheYNI61W4f48CqamszDX9vw+Ysx5wOzAHXQu
         vaYe8U3VMcB94pD8QBXGcs33Q0iVpXF1k/gtqXfjjNrKHaFG6y/x4SdljT33ubSKivi9
         1ltugSlSvq+/3FVFvlNvHZF1gz2F3ZiqX8o3RfbaLQ/BTTatCjMHIIE3WodhTNA8d/OU
         /PbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790026017; x=1790630817;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dObMqg9/Qyt4/t/40pZAxqs94G9neMmesRffkXIevgI=;
        b=WnNB7Qo+SLK/RP4t69tb3UfMIfBIA9m24qPrr+YQ6ia0afl8Xc76lWKRrd0GAExXd9
         NOjq5kHjHsyW504ecgfBPw0CAFB/y+juXABB3GXxOlMjYf9wXPzBacSP7YdmqS20TdvH
         3/zMcsPDMSRWtamOgVSbKhoEjISd3t/v+GcGqFxAlCz3wBElXvkRL9LKynikDIEv8LVM
         xooKmbxWQDhR14OpyyJKwqWTq0DvZfZlFnZHYX0CzlRpUeWYeTsTwN975SbltLphvhXl
         DmwSpnuGdYMgTnR5mAW1gs5kbSdj8Uc47ZOVpgnaxZD0eLDlGSZ8lklxcDSmcVgjLP01
         JZ9A==
X-Forwarded-Encrypted: i=1; AKwUvBysluprBYGSJl1PoCoCSveG1H2Ew+xK5pmbOjsQ2slaTY//Gfn8sybbxUJ7oMeC1WtgTxKw5m+OJQ==@kvack.org
X-Gm-Message-State: AFuF++m12/WhRlz/3QaVr0mkPFztzQr05kdgQRGRjB2rrx/sk/z6Jw9u
	8NupJSIfewRfom/W48oEqblWINq+rbYKUPNwJMEkrIkCVJL2ZylYWqOWaqENDQ7c6FebgsTB9Aa
	7nz2Xj8emUYilTo7M6/QA4E2JAveT55CPeg==
X-Received: from dyaz4-n2.prod.google.com ([2002:a05:693c:6384:20b0:33c:4c1f:ace6])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:224c:b0:39b:61f1:8032 with SMTP id 98e67ed59e1d1-39e54e7c18emr16859882a91.16.1790026016572;
 Mon, 21 Sep 2026 14:26:56 -0700 (PDT)
Date: Mon, 21 Sep 2026 21:26:38 +0000
In-Reply-To: <cover.1790025465.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1790025465.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <06c3a9b52785e6968ea15709a55365b2342c7a15.1790025465.git.abhishekbapat@google.com>
Subject: [PATCH 1/4] alloc_tag: Add trace events for tracing allocations
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	Shuah Khan <shuah@kernel.org>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 24ADBC0003
X-Stat-Signature: nb7w6qhfjgo5tk5znuyxpwodt3ud4dgs
X-Rspam-User: 
X-HE-Tag: 1790026017-156611
X-HE-Meta: U2FsdGVkX1//iURINTaOEI6DOsJ2LEhdhSrnvsjhN3GDFxM8Nll2/X4jbSqcSg0bgGGMWDp36iEFFouet7b479gznV8/c6soLPxf55EjFr/xCikB77YrAW9zlMX3xssaxSbHvqMdqq1IUVcl447bw82Xehm7FddSWuXHVC9m2vUiscfNqIKyzLJMB2ymTs3/zps4Ej/xHW0iZ8HOeX330P7yjHI0wNWW79OR64MvrYgkPQkuO2ErNz9tU20PooOG1yy+E6V6cgmpXIO0EJgSnJMGgabQaMtTuWMgLiLHFP4Gy8emYGwBgWAlpk8t6vtpITB6KzKq6KRyh9XwChmqzPa4jgWzAKFCd25359QNp5nEiKsHije0y1YJUasVQEqyKv8KXT06/Bo8qhy0v/P8GZt/5k0hl3ruFjO2zJ8oqODJjzN+nm5nmh6ib6LBGVRrg2OZnyQy1dZQsWH3cxvT/CP/2xzBkI45oIFBVTo06f/VIYsAf1KyShS7sGwrZSf6W1rdflBgl9HB/UMmw31qO9gh87o2swJCbVVmS53NtIQm/uEklRe2FzGJPqdJ9nN9EQeVP1iUF/JdowKYyXlrrwyJ6t0RG9AgxDvoWcHiVFD17k6u0Q6v5a4rZlTWmdKnwYQ8cn8Y/l2H3NSAJlLIZYEFDNG8x9ykoBAAo1+8477K/PgOl3sehBYaLM3KvbpWzWd+UohtGmD169PR1wdKK5dA0E99+MR3IdongVhNV0QeBy8ZbU//tVxGLbUJLib2rSWAf3+RoNE3GL9sy0v5Szap8igCG8k6vwerL53qQj2uzA8tbk98fAaB3D51eoijnoSkv+7TiJC4rwSQQguvIK/WwDn9nwa5zD0r+TFa+tpA/arXUNCPvkK2QcRxjS9e6aZuHPQcV1lyfUlhaWhKJA14EyZ5HNmi2zoz38VwTWbKtIQHKNo5BDpA4aB/dQMb7ZwkY2O9xfr4yq4pqoY
 BTDv6mLu
 di4fgqj2o8KFV8Gv3gLXkpprf4vor5aoT0iURbx96tL1QkNylKiSs+XQAejlKqoqnFibTRMH1Dt6vDYY5D48T4n5ObDfqbUAjqKMwXrP92IQGJDJp7K7IKRq5g80Lqnu+h4THSPNaLeR+AeJwX+jdgcYuMHaj3IKZ3Hugj1Aw8wtR0LyaT1xr73y3zyEOSr1zAMrucVDQ80X8iZr337DZM/Mv1J6tAyIS/Bvj/JFfKkOpDy2thgJb0i5k6qZc+gzX0kEWoM4DK5qK0gDGD2BpgeIawuqfbXWg0KiJIB2vZg2hIaJzowBzyZIy0hYq+mf0uPI45Pr5FlGziRjdFgH0ufcrFTcCD2dUffuxvXbhYniZA2R6Lj6AFMO+M52gVfQ4Nf56Ii7XGzQj0HpBSZ2OUnWe6r34M0k2LdpVHOJfHsMjXbyALaNYrMYREqrDg3iYAY/IzfBdxyKvhoZ+y3rZx+QRhzqEwL3FADSjzTxf7cyCifrjt7IiyyUcfXcvt978GFdobneC3q2mmtiMwed5O9FzJWgwryhErAWSAyEZcT10ieRMuUV6RCbfgh+j/YNZ7e+Gvp6aIEhVA0qbEmHDl1e/bG6Zu+1Nls5/ufm4LbL1JwTJzl6NUdzSN9nkewM/gUVbKJjbXhaNf/rVc9mrJ67NWifqX2k9QJEFeARNfCG+tvAUud11TBMxiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memory allocation profiling framework intercepts allocations across
the core subsystems, but currently lacks runtime tracing hooks for
standard observability tools to dynamically track the context (stack
traces and lifecycles of the individual memory chunks) of the
allocations made.

Introduce three standard trace events to allow this tracking:

1. `alloc_tag_hit`: Fired at the exact call site. This allows userspace
   tools to trigger and capture a call stack.
2. `alloc_tag_mem_alloced`: Fired in alloc_tag_add upon successful
   allocation. It records the allocated size, the tag, and the uniquely
   generated codetag_ref metadata pointer.
3. `alloc_tag_mem_freed`: Fired in alloc_tag_sub right before memory is
   freed, yielding the same codetag_ref to allow tracing tools to find
   the corresponding allocation.

Because the introduced trace events occur at different stages in the
call stack, userspace tracing tools must stitch them together to form a
complete picture of a buffer's lifetime. Here's an example of how
userspace correlates these three events:

1. On `alloc_tag_hit`: The tool captures the stack trace and caches it,
   keyed by the combination of the current thread's PID and the `tag`.
2. On `alloc_tag_mem_alloced`: The tool extracts the PID and `tag` from
   the event and looks up the stack trace cached in step 1. It creates a
   new active allocation record, mapping the new provided `codetag_ref`
   to this cached stack trace and the newly returned allocation size.
3. On `alloc_tag_mem_freed`: When the memory is freed, the event yields
   the same `codetag_ref`. The tool uses this reference to look up the
   original allocation record, correlates the free, and safely retires
   the tracking entry.

Also, introduce `alloc_tag_trace_key` static key to minimize the
overhead when no tags are being traced (the usual case). Once tracing
for any tag is requested, the key is set, opening the path to check
whether tracing is enabled for the current tag.
Nore that the mechanism to enabl tag tracing is implemented in the next
patch, therefore for now, `alloc_tag_trace_key` stays always unset.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
---
 MAINTAINERS                      |   1 +
 include/linux/alloc_tag.h        |  57 ++++++++++++---
 include/trace/events/alloc_tag.h | 122 +++++++++++++++++++++++++++++++
 mm/alloc_tag.c                   |  28 +++++++
 4 files changed, 196 insertions(+), 12 deletions(-)
 create mode 100644 include/trace/events/alloc_tag.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 24420a8c06d0..29e1f7915cb9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17096,6 +17096,7 @@ S:	Maintained
 F:	Documentation/mm/allocation-profiling.rst
 F:	include/linux/alloc_tag.h
 F:	include/linux/pgalloc_tag.h
+F:	include/trace/events/alloc_tag.h
 F:	include/uapi/linux/alloc_tag.h
 F:	mm/alloc_tag.c
 F:	tools/testing/selftests/alloc_tag/
diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
index 7f2d80a59792..2994934cf44a 100644
--- a/include/linux/alloc_tag.h
+++ b/include/linux/alloc_tag.h
@@ -128,12 +128,33 @@ DECLARE_PER_CPU(struct alloc_tag_counters, _shared_alloc_tag);
 DECLARE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
 			mem_alloc_profiling_key);
 
+DECLARE_STATIC_KEY_FALSE(alloc_tag_trace_key);
+
 static inline bool mem_alloc_profiling_enabled(void)
 {
 	return static_branch_maybe(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
 				   &mem_alloc_profiling_key);
 }
 
+static inline bool alloc_tag_trace_enabled(const struct alloc_tag *tag)
+{
+	return static_branch_unlikely(&alloc_tag_trace_key);
+}
+
+void alloc_tag_trace_mem_alloc(union codetag_ref *ref, struct alloc_tag *tag,
+			      size_t bytes);
+
+void alloc_tag_trace_mem_free(union codetag_ref *ref, struct alloc_tag *tag,
+			     size_t bytes);
+
+void __alloc_tag_trace_hit(struct alloc_tag *tag);
+
+static inline void alloc_tag_trace_hit(struct alloc_tag *tag)
+{
+	if (alloc_tag_trace_enabled(tag))
+		__alloc_tag_trace_hit(tag);
+}
+
 bool mem_alloc_profiling_permanently_disabled(void);
 
 static inline struct alloc_tag_counters alloc_tag_read(struct alloc_tag *tag)
@@ -200,8 +221,13 @@ static inline bool alloc_tag_ref_set(union codetag_ref *ref, struct alloc_tag *t
 
 static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag, size_t bytes)
 {
-	if (likely(alloc_tag_ref_set(ref, tag)))
+	if (likely(alloc_tag_ref_set(ref, tag))) {
 		this_cpu_add(tag->counters->bytes, bytes);
+
+		if (alloc_tag_trace_enabled(tag))
+			/* Trace successful allocs with their unique ref */
+			alloc_tag_trace_mem_alloc(ref, tag, bytes);
+	}
 }
 
 static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes)
@@ -222,6 +248,10 @@ static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes)
 	this_cpu_sub(tag->counters->bytes, bytes);
 	this_cpu_dec(tag->counters->calls);
 
+	if (alloc_tag_trace_enabled(tag))
+		/* Trace frees with their unique ref */
+		alloc_tag_trace_mem_free(ref, tag, bytes);
+
 	ref->ct = NULL;
 }
 
@@ -247,21 +277,24 @@ static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag,
 static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes) {}
 static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag) {}
 static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag) { return false; }
+#define alloc_tag_trace_hit(_tag)	/* NOOP */
 #define alloc_tag_record(p)	do {} while (0)
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
-#define alloc_hooks_tag(_tag, _do_alloc)				\
-({									\
-	typeof(_do_alloc) _res;						\
-	if (mem_alloc_profiling_enabled()) {				\
-		struct alloc_tag * __maybe_unused _old;			\
-		_old = alloc_tag_save(_tag);				\
-		_res = _do_alloc;					\
-		alloc_tag_restore(_tag, _old);				\
-	} else								\
-		_res = _do_alloc;					\
-	_res;								\
+#define alloc_hooks_tag(_tag, _do_alloc)					\
+({										\
+	typeof(_do_alloc) _res;							\
+	if (mem_alloc_profiling_enabled()) {					\
+		struct alloc_tag * __maybe_unused _old;				\
+		/* Fired here to cleanly capture the caller's stack trace */	\
+		alloc_tag_trace_hit(_tag);					\
+		_old = alloc_tag_save(_tag);					\
+		_res = _do_alloc;						\
+		alloc_tag_restore(_tag, _old);					\
+	} else									\
+		_res = _do_alloc;						\
+	_res;									\
 })
 
 #define alloc_hooks(_do_alloc)						\
diff --git a/include/trace/events/alloc_tag.h b/include/trace/events/alloc_tag.h
new file mode 100644
index 000000000000..af2182501864
--- /dev/null
+++ b/include/trace/events/alloc_tag.h
@@ -0,0 +1,122 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM alloc_tag
+
+#if !defined(_TRACE_ALLOC_TAG_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_ALLOC_TAG_H
+
+#include <linux/tracepoint.h>
+
+/*
+ * alloc_tag_hit is generated at the exact allocation call site and can be
+ * used to capture a clean stack trace.
+ *
+ * To link this stack trace to the actual allocated memory chunk, tools must
+ * correlate this event with the resulting alloc_tag_mem_alloced event. Since
+ * multiple threads can hit the same tag simultaneously, tools must match BOTH
+ * the `tag` field and the implicitly recorded PID provided by the core
+ * tracing subsystem.
+ */
+TRACE_EVENT(alloc_tag_hit,
+
+	TP_PROTO(struct alloc_tag *tag),
+
+	TP_ARGS(tag),
+
+	TP_STRUCT__entry(
+		__field(struct alloc_tag *, tag)
+		__string(modname, tag->ct.modname ? tag->ct.modname : "NONE")
+		__string(filename, tag->ct.filename)
+		__string(function, tag->ct.function)
+		__field(unsigned int, lineno)
+	),
+
+	TP_fast_assign(
+		__entry->tag = tag;
+		__assign_str(modname);
+		__assign_str(filename);
+		__assign_str(function);
+		__entry->lineno = tag->ct.lineno;
+	),
+
+	TP_printk("tag %p, module: %s, filename: %s, function %s, lineno %u",
+		__entry->tag,
+		__get_str(modname),
+		__get_str(filename),
+		__get_str(function),
+		__entry->lineno
+	)
+);
+
+/*
+ * alloc_tag_mem_alloced is generated after memory is successfully allocated.
+ * It captures the exact byte size.
+ *
+ * The `ref` pointer identifies the memory chunk for tracking its lifecycle
+ * (e.g., matching it with alloc_tag_mem_freed).
+ *
+ * Because the kernel isolates active allocations within the task struct
+ * (current->alloc_tag), this even will always share the same implicit PID as
+ * its corresponding alloc_tag_hit event. Tools should use the combination
+ * PID + `tag` to correlate them.
+ */
+TRACE_EVENT(alloc_tag_mem_alloced,
+
+	TP_PROTO(union codetag_ref *ref, struct alloc_tag *tag, size_t bytes),
+
+	TP_ARGS(ref, tag, bytes),
+
+	TP_STRUCT__entry(
+		__field(union codetag_ref *, ref)
+		__field(struct alloc_tag *, tag)
+		__field(size_t, bytes)
+	),
+
+	TP_fast_assign(
+		__entry->ref = ref;
+		__entry->tag = tag;
+		__entry->bytes = bytes;
+	),
+
+	TP_printk("reference %p, tag %p, bytes %zu",
+		__entry->ref,
+		__entry->tag,
+		__entry->bytes
+	)
+);
+
+/*
+ * alloc_tag_mem_freed event is generated immediately before memory is
+ * freed. The `ref` pointer matches the one emitted during allocation,
+ * allowing tools to match it to it's corresponding allocation and
+ * call stack.
+ */
+TRACE_EVENT(alloc_tag_mem_freed,
+
+	TP_PROTO(union codetag_ref *ref, struct alloc_tag *tag, size_t bytes),
+
+	TP_ARGS(ref, tag, bytes),
+
+	TP_STRUCT__entry(
+		__field(union codetag_ref *, ref)
+		__field(struct alloc_tag *, tag)
+		__field(size_t, bytes)
+	),
+
+	TP_fast_assign(
+		__entry->ref = ref;
+		__entry->tag = tag;
+		__entry->bytes = bytes;
+	),
+
+	TP_printk("reference %p, tag %p, bytes %zu",
+		__entry->ref,
+		__entry->tag,
+		__entry->bytes
+	)
+);
+
+#endif /* _TRACE_ALLOC_TAG_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index f30ef8dd24c7..a5339767efd5 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -19,6 +19,9 @@
 #include <linux/kmemleak.h>
 #include <uapi/linux/alloc_tag.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/alloc_tag.h>
+
 #include "internal.h"
 #include "page_alloc.h"
 
@@ -55,6 +58,9 @@ EXPORT_SYMBOL(mem_alloc_profiling_key);
 
 DEFINE_STATIC_KEY_FALSE(mem_profiling_compressed);
 
+DEFINE_STATIC_KEY_FALSE(alloc_tag_trace_key);
+EXPORT_SYMBOL(alloc_tag_trace_key);
+
 struct alloc_tag_kernel_section kernel_tags = { NULL, 0 };
 unsigned long alloc_tag_ref_mask;
 int alloc_tag_ref_offs;
@@ -485,6 +491,28 @@ static const struct proc_ops allocinfo_proc_ops = {
 #endif
 };
 
+void __alloc_tag_trace_hit(struct alloc_tag *tag)
+{
+	if (unlikely(!tag))
+		return;
+	trace_alloc_tag_hit(tag);
+}
+EXPORT_SYMBOL(__alloc_tag_trace_hit);
+
+void alloc_tag_trace_mem_alloc(union codetag_ref *ref, struct alloc_tag *tag,
+			      size_t bytes)
+{
+	trace_alloc_tag_mem_alloced(ref, tag, bytes);
+}
+EXPORT_SYMBOL(alloc_tag_trace_mem_alloc);
+
+void alloc_tag_trace_mem_free(union codetag_ref *ref, struct alloc_tag *tag,
+			     size_t bytes)
+{
+	trace_alloc_tag_mem_freed(ref, tag, bytes);
+}
+EXPORT_SYMBOL(alloc_tag_trace_mem_free);
+
 size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, bool can_sleep)
 {
 	struct codetag_iterator iter;
-- 
2.55.0.1082.g2b9226bbc0-goog


