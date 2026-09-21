Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F75CC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 21:27:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 597CC6B00A6; Mon, 21 Sep 2026 17:27:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FC8F6B00A7; Mon, 21 Sep 2026 17:27:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EB6A6B00A9; Mon, 21 Sep 2026 17:27:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B4CB6B00A6
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 17:27:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 800EAA5C7D
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:27:00 +0000 (UTC)
X-FDA: 85239054600.28.A019A64
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf09.hostedemail.com (Postfix) with ESMTP id C39D4140004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:26:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=u0pDjyoU;
	spf=pass (imf09.hostedemail.com: domain of 3IaGxag0KCIYklrs2roulkzk3qyyqvo.mywvsx47-wwu5kmu.y1q@flex--abhishekbapat.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3IaGxag0KCIYklrs2roulkzk3qyyqvo.mywvsx47-wwu5kmu.y1q@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790026018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JRTedVM7nBxor9V1RQ1SMJHuSnIvSIlR7gJ4JHxEE28=;
	b=a4cek+DSduOFjoRkWBTHL/HMe3Wx9RP2EzvUFLwTbIi3uIa1N1QGuKYdQBRC5H3XjoOZFd
	Hcu8xnPloZ2YUhXG4iXf6rWL5hCI3lojnK/sg4WLohmoiEvqjfU5hcXd/FFo4NTKS+JOQs
	MPZpP/XoohUyYjLvrMj7WLC/liZzzOg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790026018;
	b=mu+cUOakDEJR4e8vzmfCsuQ8y+h0p88lc8XW1hZSm/M7O836/ZWHwfetRB7iu5OaHi1wdU
	kuEASy93wIq4XKMROGNnPS8QGxnNYswjiL3d5Y3YbZ/ExB7Y9i8mDBecQ7JQz7acn0smuA
	ELTDcbxyJdUIZqCE2tE6HQegig3R0xo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=u0pDjyoU;
	spf=pass (imf09.hostedemail.com: domain of 3IaGxag0KCIYklrs2roulkzk3qyyqvo.mywvsx47-wwu5kmu.y1q@flex--abhishekbapat.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3IaGxag0KCIYklrs2roulkzk3qyyqvo.mywvsx47-wwu5kmu.y1q@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-39aee9b4cf2so6134825a91.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790026018; x=1790630818; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JRTedVM7nBxor9V1RQ1SMJHuSnIvSIlR7gJ4JHxEE28=;
        b=u0pDjyoUGqk6BZ+GjQSNUnDLYkncLAoq4MZWSCRXbHL/DtcqbJULzIKSbCCEOu8AD9
         UIPzjDDE+Kc5ol08VdE1RX47U6UUQSDkb6NMf1nZrBL5BI+d+5Yv4Ki/y3x05txzWnFv
         le2J2XICC05q6jQjnccGhZHhbG4wuk5GGSWqVgwL9nYcfLFHqaWVqRaDwUYgTz8H2eNO
         ozbgWuS37r4YBktvITTjdHmk3JxmDazX4VOXjIik2TxXMxHxCxby+6KHxkw91+7Pu1q+
         t7/LZ3eq1SUh1U/T99KMgRwCb+OvFYE+k0g66ll9ndz+S+L6I6DKJ+eWJkVF7r2M1ohi
         wxzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790026018; x=1790630818;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JRTedVM7nBxor9V1RQ1SMJHuSnIvSIlR7gJ4JHxEE28=;
        b=C138x5K/YIJm0DNU19q8PnQBdKorAL12IHlVhRE8lQU28ZCBq3OPJvf1XamQlmlGaG
         0Bwd4i301pM2+lFYxgP2gU2aKdL3R7fbwcbBxn3Qdnb8d1IPzR1cY0txEy+CRoAMuT+4
         RRuzXhnodIt8aubGk+NVPPxev7V6Gq0HsTaCzJ/ne8rBBgKTfT5J+MGD6U2MPgX67RSq
         7EfDPz/9+95LV/OnBqzH4Z95bLZiB0fQe6LMb6Qcb0aesIEBg+e1wqdcgPiNn62T28j7
         IcjkcHdEWNSQTvoUfav77yw/nlPX8ITqE8oMZ8zrUErT3q85JTjesnMpd0pe5ouPZCOm
         gmCA==
X-Forwarded-Encrypted: i=1; AKwUvBz+TIbT028Hgi/Hllzjw84MI4hO5qM/+Zt+TbLyLhksUIU4aeg4ku55afcqJz/ap1CMrx6hd34Y6w==@kvack.org
X-Gm-Message-State: AFuF++nXbqRg0unkq8xzrHMvDnP/Fd039AClBt2QBeQn+9TLOVb3G+UC
	1Z4BKoHjeUL89Wt2aWu1DzhYv8W8pbaehxJrD0XeFGRkPj9jotGFvMQHKeE0JXC8KIUtPTYfdD3
	c/mfq3N/RC/L45mVbBqSae2o56qDrM3EciQ==
X-Received: from dlzz29.prod.google.com ([2002:a05:7022:49d:b0:144:d6d2:5015])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5287:b0:39e:3285:b776 with SMTP id 98e67ed59e1d1-39e54cb9c71mr17703289a91.7.1790026017349;
 Mon, 21 Sep 2026 14:26:57 -0700 (PDT)
Date: Mon, 21 Sep 2026 21:26:39 +0000
In-Reply-To: <cover.1790025465.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1790025465.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <95bf63d2b9ef14f6610d6543b6892d266e4dc5c6.1790025465.git.abhishekbapat@google.com>
Subject: [PATCH 2/4] alloc_tag: Introduce IOCTLs to toggle allocation tracepoints
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	Shuah Khan <shuah@kernel.org>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C39D4140004
X-Stat-Signature: oxbtdswro3eru43kecuiyjyitb6oy8pi
X-Rspam-User: 
X-HE-Tag: 1790026018-853554
X-HE-Meta: U2FsdGVkX1+4I1Y8a38slNr3mwql3/pdAurWBkwQcq52IJffRcI5eTxiblWk20EbwkrHgZd6ot5Xi7I6yBDL3qB7yWxIClkl/CdT/To2JOgyv7LN7kCeYsgBOUrcSPLC1dXmyeYaIgDoNz5/a0VGwv7AlmQGXcXRuQiw32iCa6Qc9R2CoPDvXiQlkEDKmD7IE7JOXu1R5Sr36/kQmevFGjtX6lKfRIuirhc6IBPzhc7MjnwI5k6qcgH5x/ZdyW/Ocu97BH3eVzSkKxf0WTpd+MTVZ0J7mCh8E/B/eyPPxYmK250UTrl680mJLo5JGJqZq7c2yJBMmXIqQ9fO1Zx/jiw5Dn5WuDyhvVxiB5alLbgvL2+2EMfCdC0/rsGXigW9fLfCww611xJgz6LTKEYwGMwDXbSLJ+Qf2nzEZbLr8FQY8Lg4HxNpqg8mIvS277e8ZLzxvZ3NgvOBRVI0FL7Z2nwQflIvBB2WTmUZRvUjQeXjPxdxEUi2d9ASICVStL/njpYkTdrx+wnX16oJ64kAHJ40hNWpT7T6dhHvO09BqsiOSbpCXIq5bZdlB0RnL0DI0UiCQbeV0V+WHShtbziQLSn/eQwcj2+EvUSYZOWMrA4NoFIBy9IFsC8o0jylZZAAcQceViuxWUHZuWTHvdKF3O7cUrD7/VkiCs4c3mkKPhHOhcaW01gUfFJLhuVsTef8ROJpYdXMbOCztiLJb+9Sw5bU2vfMFo3LMxG7R8i4SonV5w/RitvUKAkpSU0DG6uu2gifnnh9DXZcHOHU1hGLPzUGQr01U6zG90xd8Z9dchBFsu8xtQo+gqhyshQxAasHMtu8e+Az7CoC+BBbknHCaBiF485j2+8YlEsWMzxSmy31UrKaJZ3RzNHKFtnV3E9FzmiZvELdkIBLhoJIcS0ASKOLQQ39x3AanQo11N4lwOwQZjEWu+tF75hZnhIcQxLQ/Vqzb/ORvHSOpQrYxqI
 64RPLaRu
 VHrIZyqX4RvKSIKRHPtxArLTiKNlCwn0QtAucenuayNK9181KY2tRgROkF2+J56dmT11FHEzUK+vBNte72ZAvYq4oiVogcfYVMMu3PVYwTN9QZFGsRPdYXluk/2TjgwZX9FUxo2zkfD+HwradqdSG+YDaty0nC+PnMoSSkk2nQ6L4WB3TyQ86reRCImh9t4/ph3R3ygAkGVTHJfUt6c0fRFfE6L/vB32uG0pN+ioPrPKISx6Q8H4XNKzZWYqxfB0NHerbSyrd88IKgJQ5IDGeai2axY7EQUOESSkAK13w8l9u7Xt2ZDjP73Xf23WkWmZE0m55utqHBQxHhwgMTFZok0/2VAjDbAOjap32MyqLk0n86rCox+xvtBMBnWLwNNGdpjBtKFaOcppOB3VnscTcDtU0My1BWwqIUEIMsVUO0WBfJlOruk04zUkQxeXEu8VNBSvEIl9Q6tyvCL+hTQJhsXMWUYO1GuLp5WqmN9LMl0jRc56hVhe62et0NoCntEjr58gG/4gwRDSzYPSMVd+K14zWA5eVfZ/X0anzbvLsmLmcD2g5Ki50lk7aaXI4oC71+0kql1gSwVlMozqvUIDgF3WwrRQ6Cnhey04RMc2yPaVz3t3g3hfMjwOpELmVkLob0Cg2yPFwwpaS9/mgL2VgBEXjeseI1oHB46/soNchrRNqSUy49Xp23eIAYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new IOCTL (`ALLOCINFO_IOC_TOGGLE_TRACE`) to selectively
toggle tracing on exact allocation call sites. Userspace tools can
use the existing filtering mechanism to specify the set of tags to
toggle tracing for.

To facilitate low overhead execution for non-targeted call sites, add a
new `CODETAG_FLAG_TRACE_ON` flag to `struct codetag` to track per-site
activation. Protect these conditional branch evaluations using a global
`alloc_tag_trace_key` static branch and an inline static key check
pattern in the allocator hooks (`alloc_tag_add`, `alloc_tag_sub`, etc).
This ensures that the trace events are entirely skipped when no
allocation call sites are being actively traced, leaving only a NOP on
the allocation fast path.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
---
 include/linux/alloc_tag.h      |  39 ++++++++----
 include/linux/codetag.h        |   5 +-
 include/uapi/linux/alloc_tag.h |   9 +++
 mm/alloc_tag.c                 | 110 ++++++++++++++++++++++++++++++++-
 4 files changed, 147 insertions(+), 16 deletions(-)

diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
index 2994934cf44a..dc86f8997476 100644
--- a/include/linux/alloc_tag.h
+++ b/include/linux/alloc_tag.h
@@ -136,9 +136,36 @@ static inline bool mem_alloc_profiling_enabled(void)
 				   &mem_alloc_profiling_key);
 }
 
+static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
+{
+	atomic_or(CODETAG_FLAG_INACCURATE, &tag->ct.flags);
+}
+
+static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
+{
+	return !!(atomic_read(&tag->ct.flags) & CODETAG_FLAG_INACCURATE);
+}
+
+static inline void alloc_tag_set_traced(struct alloc_tag *tag)
+{
+	atomic_or(CODETAG_FLAG_TRACE_ON, &tag->ct.flags);
+}
+
+static inline void alloc_tag_clear_traced(struct alloc_tag *tag)
+{
+	atomic_andnot(CODETAG_FLAG_TRACE_ON, &tag->ct.flags);
+}
+
+static inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
+{
+	return !!(atomic_read(&tag->ct.flags) & CODETAG_FLAG_TRACE_ON);
+}
+
 static inline bool alloc_tag_trace_enabled(const struct alloc_tag *tag)
 {
-	return static_branch_unlikely(&alloc_tag_trace_key);
+	if (static_branch_unlikely(&alloc_tag_trace_key))
+		return tag && alloc_tag_is_traced(tag);
+	return false;
 }
 
 void alloc_tag_trace_mem_alloc(union codetag_ref *ref, struct alloc_tag *tag,
@@ -255,16 +282,6 @@ static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes)
 	ref->ct = NULL;
 }
 
-static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
-{
-	tag->ct.flags |= CODETAG_FLAG_INACCURATE;
-}
-
-static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
-{
-	return !!(tag->ct.flags & CODETAG_FLAG_INACCURATE);
-}
-
 #define alloc_tag_record(p)	((p) = current->alloc_tag)
 
 #else /* CONFIG_MEM_ALLOC_PROFILING */
diff --git a/include/linux/codetag.h b/include/linux/codetag.h
index a25a085c2df1..f728295d50c0 100644
--- a/include/linux/codetag.h
+++ b/include/linux/codetag.h
@@ -18,6 +18,7 @@ struct module;
 
 /* codetag flags */
 #define CODETAG_FLAG_INACCURATE	(1 << 0)
+#define CODETAG_FLAG_TRACE_ON	(1 << 1)
 
 /*
  * An instance of this structure is created in a special ELF section at every
@@ -25,7 +26,7 @@ struct module;
  * an array of these.
  */
 struct codetag {
-	unsigned int flags;
+	atomic_t flags;
 	unsigned int lineno;
 	const char *modname;
 	const char *function;
@@ -71,7 +72,7 @@ struct codetag_iterator {
 	.function	= __func__,			\
 	.filename	= __FILE__,			\
 	.lineno		= __LINE__,			\
-	.flags		= 0,				\
+	.flags		= ATOMIC_INIT(0),		\
 }
 
 void codetag_lock_module_list(struct codetag_type *cttype);
diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
index 7d4618bea043..069ab8341e87 100644
--- a/include/uapi/linux/alloc_tag.h
+++ b/include/uapi/linux/alloc_tag.h
@@ -85,9 +85,16 @@ struct allocinfo_get_at {
 	struct allocinfo_tag_data data;
 };
 
+struct allocinfo_toggle_traces {
+	/* inputs */
+	struct allocinfo_tag fields;
+	__u64 enable;
+};
+
 #define _ALLOCINFO_IOC_CONTENT_ID	0
 #define _ALLOCINFO_IOC_GET_AT		1
 #define _ALLOCINFO_IOC_GET_NEXT		2
+#define _ALLOCINFO_IOC_TOGGLE_TRACE	3
 
 #define ALLOCINFO_IOC_BASE		0xA6
 #define ALLOCINFO_IOC_CONTENT_ID	_IOR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_CONTENT_ID,	\
@@ -96,5 +103,7 @@ struct allocinfo_get_at {
 					      struct allocinfo_get_at)
 #define ALLOCINFO_IOC_GET_NEXT		_IOR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_GET_NEXT,	\
 					     struct allocinfo_tag_data)
+#define ALLOCINFO_IOC_TOGGLE_TRACE	_IOW(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_TOGGLE_TRACE,	\
+					    struct allocinfo_toggle_traces)
 
 #endif /* _UAPI_ALLOC_TAG_H */
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index a5339767efd5..fb179321a2a1 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -61,6 +61,15 @@ DEFINE_STATIC_KEY_FALSE(mem_profiling_compressed);
 DEFINE_STATIC_KEY_FALSE(alloc_tag_trace_key);
 EXPORT_SYMBOL(alloc_tag_trace_key);
 
+static atomic_t alloc_tag_trace_cnt = ATOMIC_INIT(0);
+
+/*
+ * As `codetag_lock_module_list` is a read lock, we need an additional mutex
+ * to protect against the race conditions involved in the alloc tag trace
+ * toggle path.
+ */
+static DEFINE_MUTEX(alloc_tag_trace_mutex);
+
 struct alloc_tag_kernel_section kernel_tags = { NULL, 0 };
 unsigned long alloc_tag_ref_mask;
 int alloc_tag_ref_offs;
@@ -297,7 +306,7 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
 		return false;
 
 	if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
-		inaccurate = !!(ct->flags & CODETAG_FLAG_INACCURATE);
+		inaccurate = alloc_tag_is_inaccurate(ct_to_alloc_tag(ct));
 		if (inaccurate != !!(filter->inaccurate))
 			return false;
 	}
@@ -444,6 +453,81 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
 	return ret;
 }
 
+static bool alloc_tag_trace_toggle(struct alloc_tag *tag, bool enable)
+{
+	if (enable) {
+		if (alloc_tag_is_traced(tag))
+			return false;
+
+		alloc_tag_set_traced(tag);
+		if (atomic_fetch_inc(&alloc_tag_trace_cnt) == 0)
+			static_branch_enable(&alloc_tag_trace_key);
+	} else {
+		if (!alloc_tag_is_traced(tag))
+			return false;
+
+		alloc_tag_clear_traced(tag);
+		if (atomic_dec_and_test(&alloc_tag_trace_cnt))
+			static_branch_disable(&alloc_tag_trace_key);
+	}
+
+	return true;
+}
+
+/*
+ * Toggles context capture for a specified allocation.
+ */
+static int allocinfo_ioctl_toggle_trace(struct seq_file *m, void __user *arg)
+{
+	struct allocinfo_toggle_traces params;
+	struct codetag_iterator iter;
+	struct codetag *ct;
+	int matches = 0, successes = 0, ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (copy_from_user(&params, arg, sizeof(params)))
+		return -EFAULT;
+
+	codetag_lock_module_list(alloc_tag_cttype);
+
+	struct allocinfo_filter filter = {
+		.mask = ALLOCINFO_FILTER_MASK_MODNAME |
+		       ALLOCINFO_FILTER_MASK_FUNCTION |
+		       ALLOCINFO_FILTER_MASK_FILENAME |
+		       ALLOCINFO_FILTER_MASK_LINENO,
+		.fields = params.fields,
+	};
+
+	iter = codetag_get_ct_iter(alloc_tag_cttype);
+
+	/* Toggle tracing on all codetags that match */
+	while ((ct = codetag_next_ct(&iter))) {
+		if (matches_filter(ct, &filter, NULL, NULL)) {
+			matches++;
+
+			mutex_lock(&alloc_tag_trace_mutex);
+			if (alloc_tag_trace_toggle(ct_to_alloc_tag(ct), !!params.enable))
+				successes++;
+			mutex_unlock(&alloc_tag_trace_mutex);
+		}
+	}
+
+	if (matches == 0)
+		/* Nothing matched the filter */
+		ret = -ENOENT;
+	else if (successes == 0)
+		/* Items matched, but were already in the requested state */
+		ret = -EINVAL;
+	else
+		ret = 0;
+
+	codetag_unlock_module_list(alloc_tag_cttype);
+
+	return ret;
+}
+
 /*
  * Entry point ioctl function for /proc/allocinfo routing requests to fetch the
  * layout content ID, seek to a specific tag, or read sequential tags.
@@ -464,6 +548,9 @@ static long allocinfo_ioctl(struct file *file, unsigned int cmd,
 	case ALLOCINFO_IOC_GET_NEXT:
 		ret = allocinfo_ioctl_get_next(file->private_data, arg);
 		break;
+	case ALLOCINFO_IOC_TOGGLE_TRACE:
+		ret = allocinfo_ioctl_toggle_trace(file->private_data, arg);
+		break;
 	default:
 		ret = -ENOIOCTLCMD;
 		break;
@@ -493,8 +580,6 @@ static const struct proc_ops allocinfo_proc_ops = {
 
 void __alloc_tag_trace_hit(struct alloc_tag *tag)
 {
-	if (unlikely(!tag))
-		return;
 	trace_alloc_tag_hit(tag);
 }
 EXPORT_SYMBOL(__alloc_tag_trace_hit);
@@ -1043,6 +1128,24 @@ static int load_module(struct module *mod, struct codetag *start, struct codetag
 	return 0;
 }
 
+static void unload_module(struct module *mod, struct codetag *start, struct codetag *stop)
+{
+	struct alloc_tag *start_tag = ct_to_alloc_tag(start);
+	struct alloc_tag *stop_tag = ct_to_alloc_tag(stop);
+	struct alloc_tag *tag;
+
+	/*
+	 * Turn tracing off for the tags of the module being unloaded. Without
+	 * this, `alloc_tag_trace_cnt` would never reach zero and tracing would
+	 * stay enabled forever.
+	 *
+	 * `alloc_tag_trace_mutex` is not needed here as this code path is
+	 * protected by a `down_write(&cttype->mod_lock)`.
+	 */
+	for (tag = start_tag; tag < stop_tag; tag++)
+		alloc_tag_trace_toggle(tag, false);
+}
+
 static void replace_module(struct module *mod, struct module *new_mod)
 {
 	MA_STATE(mas, &mod_area_mt, 0, module_tags.size);
@@ -1369,6 +1472,7 @@ static int __init alloc_tag_init(void)
 		.alloc_section_mem	= reserve_module_tags,
 		.free_section_mem	= release_module_tags,
 		.module_load		= load_module,
+		.module_unload		= unload_module,
 		.module_replaced	= replace_module,
 #endif
 	};
-- 
2.55.0.1082.g2b9226bbc0-goog


