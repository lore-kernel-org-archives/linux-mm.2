Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCB08CA6009
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 22:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D54A86B0093; Wed,  7 Oct 2026 18:40:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2A5E6B0095; Wed,  7 Oct 2026 18:40:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCB2C6B0096; Wed,  7 Oct 2026 18:40:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AFB46B0093
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 18:40:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F441803DA
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 22:40:13 +0000 (UTC)
X-FDA: 85297299906.20.8B4A557
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by imf07.hostedemail.com (Postfix) with ESMTP id B365B40009
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 22:40:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pV9f0ueA;
	spf=pass (imf07.hostedemail.com: domain of 3ScrGag0KCFYyz56G528zyDyH4CC492.0CA96BIL-AA8Jy08.CF4@flex--abhishekbapat.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=3ScrGag0KCFYyz56G528zyDyH4CC492.0CA96BIL-AA8Jy08.CF4@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791412811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=24GVmB+cFG691fgwpuGrIqLCZcfR11JB/Taf/1fuGZo=;
	b=wt35e9z1WO9G/hRRtROYsX5ITRGVQxL//P+jalijoBhhpaVdEqwl84xhzku5RBhTZVHqT+
	6oHor7QowxmqyhmMdIvA2kojFBXhQc+KSPh8AXLEiRolkeBhfqP5UVcRQpV6QlvL5UZEI2
	u4ikL6LsqaoTxsM/jUeJOnx6AXd9dBM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791412811;
	b=nHINJPUEi6lxH2fmoVKN/U/AIgjVqHrPb3cP35mNBGputUTCqHCLFb1T6EzSWIhrIRLBVA
	c4s6YvXaW50iJFRKLru1eki0mqsOasQDyRHdDRi5qV6c5kG9FaqyJRrKywoTSQvqasUYpR
	FWb6VmKu1AV1nG9Hw/Wlc/y6LTdG9/A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pV9f0ueA;
	spf=pass (imf07.hostedemail.com: domain of 3ScrGag0KCFYyz56G528zyDyH4CC492.0CA96BIL-AA8Jy08.CF4@flex--abhishekbapat.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=3ScrGag0KCFYyz56G528zyDyH4CC492.0CA96BIL-AA8Jy08.CF4@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-3515266f6eeso1797735eec.0
        for <linux-mm@kvack.org>; Wed, 07 Oct 2026 15:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791412810; x=1792017610; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=24GVmB+cFG691fgwpuGrIqLCZcfR11JB/Taf/1fuGZo=;
        b=pV9f0ueA5heEzeoySv9t1bA93bqc4IInWaZaLG7GEPvPXVaYlF4oA5eLdwl1k5GNag
         6BnXHkOosGfIzXUVID/YndiGtbwjCHq9+u3qWq2ICtcDSckvkLkzNa6aBEru3vXzzJra
         y3NgYc2CNQS1cRDr5PW2Y//+gQ2u1pFcLpeaJIzlQmSGjKBPWDk3KAajPa7KxkROfJF3
         hVVB98Bj08HU3XfSacRWaIw6PY1UsDPkgbpIbaA3/Q45REfrJL+eMVw7h5JVlnAs9K//
         1EV57ByCY20hW5Y8YYybfUpBg4r7tpPQdngDjznW+h5uUIk/RYlUFGZ4aZx4/SXZ54qd
         XDdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791412810; x=1792017610;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=24GVmB+cFG691fgwpuGrIqLCZcfR11JB/Taf/1fuGZo=;
        b=t9X68zCWf8XLYQHj5z5i8/Z4v9OiemVLtQ8nz7xT5sil/lqFpWApLE53hEGpB3ROWq
         qCZc8IJ3K7lFqxEG9UGF2vi97iRNipu9PXdwgu2MLOhxy8P16c0WNMx3XdiOeqh9QGUL
         PyzF66SqzDnmU0WPK8/nloh80V7LMP64EyjL2Fy9d4QQWjzW64EHq3vWEVaztoYNz8+a
         IfvqStHeFg6NVt83LC66qUFI8PQsJQ0ghXsjcT8OWe6COLdy+zenYLxztP1gACkcFidw
         pk3zVoESi1o1cvchRr//gRyIKdbPIhnjjBo7GOnrpFNXu51xSJc70ByJ+6nxtft4Zlt1
         r28Q==
X-Forwarded-Encrypted: i=1; AKwUvBzGRnhWo88GxZhIAjpl9x4ygEQsp9XnfZHP5ZlNgBqg5WQQFukVOG5eSHMMWQVG+ZBfCIIyBMY0AQ==@kvack.org
X-Gm-Message-State: AFq9FYJjr+QI3o4LE3Gi00Jmbz4Q0JbwL85B+czl+G1dxvB6Rgo1JXWv
	hAbjUn705JJdXqmSosftIpG7J5b9IzLHDUDgpwTZHWbtF28sMVoTUQLkFHiDp1IhyX3IvHC1zvl
	TwuvnVo4fEL1aMNIsbLSBbGw4Hc3mwUNivQ==
X-Received: from dyx16.prod.google.com ([2002:a05:693c:8210:b0:351:28e2:44b4])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:bfa4:b0:33c:b64a:3b82 with SMTP id 5a478bee46e88-3515de60281mr3871352eec.10.1791412809141;
 Wed, 07 Oct 2026 15:40:09 -0700 (PDT)
Date: Wed,  7 Oct 2026 22:40:00 +0000
In-Reply-To: <cover.1791410885.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1791410885.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <1f77364a04d0ae20cf07efaca779756f92ec39f6.1791410886.git.abhishekbapat@google.com>
Subject: [PATCH v2 2/4] alloc_tag: Introduce IOCTLs to toggle allocation tracepoints
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B365B40009
X-Stat-Signature: p4qdft3amdse5ihnopgjin9zrj9sh1t5
X-HE-Tag: 1791412811-488534
X-HE-Meta: U2FsdGVkX1+YGZ1gSJn/E8Jdn0F3vxGIDh1Mc19ElTLBoxSKQguei1BFpMCV7cQRHUGrOaSkYBpWpvBKX7z9KSmezHhQecNXz1sh9DbaJx7Ub2I39J7xijMvjGiyCPnFJ4IdelcQcZDGb/PbAfzEin0WECcF3DPh2zGWgsNSWXbrOmmT/Z7KCA9NJCOJ8VKU4uVQnr6lGgYUtQZDb7rZxpE5K7nzHgPGomqJXSsOg06GnFTVJlBTkG+gKt3RfZGeIpffk5GH/3X5xvTSoExzuf+PommPyEfTiPzF/Q2ZdQCDZwO/imqvl/tv8+6jN0hs1wX1HeBfNuUi6FyPQIUBN3cNCpeMaZB/jNnsSSdF29a0u5g4GHHNxGGIyYHAtB1eC+pMHzInMILpOIO45GuU/RHE1x9Iqr4mSmA2hhVUk1mVLcmEYbj6+ujgk7ul+XOqDucNJMMQ8Lj8Al5ORsiLHeJSfrfv1hTyLvzK+JLxMzu/2Oht34GZnSxxMBJeKicP4XSsD/QE2IJr8eAyLk3mjZwtgxmEHFdWEpHkaYuPvS2KVvVuYF2rku1/nr0YX+YPy+p0fRDVpCoaQVZVAlqMTt67DM10smeD+zBUp6L9xpVef/UCH0dUDkU0sHPYQWJulxtPcIVjET1x+DoTxq08UXYdmGMHzvZ8Ut0VY+jlUgeCvI5YOWlPCij1ZUymlaPUKMBOZ+AFR7H/4hubYTqrZhLqTEUy45cPmtTOHZX/ICqJ7duOlJO0MwyVCkQEqe3JKIfrTnQkTKy6tUPXVUYXVk818EYOBb8FBZmTf2BHpo+Z5LkZcC9tbOr1JoTTbBLFQJJApHOjKNhiEEKCYVKD2bzDwSrF5sRPJ4F9Rebf56dUVwqoLbwLH0bJG3HIpL14Huj4MHZlrHSjA3uY0cUFa/v/Gr8oMdg/jcRNKspQu9C+9JZemaT9FS3akz3CA+J+C5Dr7+IczJA1L9RnYKo
 SOgloySu
 NMWakdeG25J+Oma0TiZgAvxG29BkviWYdMoGR+J2qR086HyI0DEIrgQrPeG+SOhVvRkufwtE2Nx8t9eH6s2S3OIN0NVnMcOmKOCQYdM2TbUk1aFauEsbmhcgz6DZO6lv8N1Zc34FqM1hVk+6CdlUrAyh7Ggym0LMKlZ6zWf8ypK2y/DwLWJTv5VW+ui6km0aUUwLDpVIxuTB04d83WUtd8v5HyVejYvOiUCu89pmAxGkf0Sm1rS+VdKAoLWrMtWVf3nvH8wGVRqiDc/X1EaeChryzMC2VIwZm8H2DsE1C+crbKRcHarOWpW//0as0V9ykeZyyzTsMc9nfUYtjwAil2HZLdM51aMFFw63YbFUUKyw7IZpuo9lew89E6CDzJU1qHegktbmUyRrm9Wj/zPThzPYJ6ogR3+toQ7ZOi2/F/uIjkZtBINqAeQgO5/UtN4NkfC2wRwdSvD8Su5d2Im1twq8esCkfDbvFBaCfYsbQZZLQWz0ap6bGt1eNImJE6n0V3mh7j3jf+w1Fo1x+vBQ4wnTW8hj3nt2LTovQT1RWamE+kCAXRKqqps3ougaf/7IXVBJ7ecoAeD5s1pRQxTulCRrMK5vpzE7TeCs149TwHBhVKHpFmuqgaZa76yG95G/vjn9IUklrxerVsUp/6kjZcWUyxYhTh1I4UcbIB4ixN/Hb9tI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new IOCTL (`ALLOCINFO_IOC_TOGGLE_TRACE`) to selectively
toggle tracing on allocation call sites. Userspace tools can use the
existing filtering mechanism to specify the set of tags to toggle
tracing for.

To facilitate low overhead execution for non-targeted call sites, add a
new `CODETAG_FLAG_TRACE_ON` flag to `struct codetag` to track per-site
activation. Protect these conditional branch evaluations using the global
`alloc_tag_trace_key` static branch and an inline static key check
pattern in the allocator hooks (`alloc_tag_add`, `alloc_tag_sub`, etc).
This ensures that the trace events are entirely skipped when no
allocation call sites are being actively traced, leaving only a NOP on
the allocation fast path.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
---
 Documentation/mm/allocation-profiling.rst |  20 ++++
 include/linux/alloc_tag.h                 |  47 +++++---
 include/linux/codetag.h                   |   5 +-
 include/uapi/linux/alloc_tag.h            |  13 +++
 mm/alloc_tag.c                            | 128 ++++++++++++++++++++--
 5 files changed, 187 insertions(+), 26 deletions(-)

diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
index b241450394df..63b668466342 100644
--- a/Documentation/mm/allocation-profiling.rst
+++ b/Documentation/mm/allocation-profiling.rst
@@ -149,6 +149,26 @@ expose the full call stack and the lifetime of individual allocations:
 - slab and percpu: the address of the object's `codetag_ref`
 - page allocator: the `struct page` pointer of the head page
 
+Events are only emitted for tags that have tracing turned on and while profiling
+is enabled. When no tag is traced, the hooks are behind a static branch.
+
+Enabling Tracing
+----------------
+
+Tracing is toggled on and off per tag with the `ALLOCINFO_IOC_TOGGLE_TRACE`
+ioctl on `/proc/allocinfo`. It takes the same filter as used by
+`ALLOCINFO_IOC_GET_AT`; an empty mask selects all tags. Size limits in the
+filter are checked once, against the tag's size at the time of the call. Tags
+already in the requested state are skipped and a -ENOENT is returned if no
+tag matched.
+
+Tracing is turned off for a module's tags when the module is unloaded.
+
+Memory allocated before a tag was enabled has no alloc event but will still
+produce a free event. Likewise, memory alive when tag is disabled will not
+produce a free event. Tools should expect unmatched frees after enabling and
+missing frees after disabling.
+
 Correlating the events
 ----------------------
 
diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
index 49825177d8c8..94697b28053a 100644
--- a/include/linux/alloc_tag.h
+++ b/include/linux/alloc_tag.h
@@ -136,9 +136,36 @@ static inline bool mem_alloc_profiling_enabled(void)
 				   &mem_alloc_profiling_key);
 }
 
-static inline bool alloc_tag_trace_enabled(void)
+static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
 {
-	return static_branch_unlikely(&alloc_tag_trace_key);
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
+static inline bool alloc_tag_trace_enabled(const struct alloc_tag *tag)
+{
+	if (static_branch_unlikely(&alloc_tag_trace_key))
+		return tag && alloc_tag_is_traced(tag);
+	return false;
 }
 
 void alloc_tag_trace_mem_alloc(const void *ptr, struct alloc_tag *tag,
@@ -151,7 +178,7 @@ void __alloc_tag_trace_hit(struct alloc_tag *tag);
 
 static __always_inline void alloc_tag_trace_hit(struct alloc_tag *tag)
 {
-	if (alloc_tag_trace_enabled())
+	if (alloc_tag_trace_enabled(tag))
 		__alloc_tag_trace_hit(tag);
 }
 
@@ -225,7 +252,7 @@ static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag,
 	if (likely(alloc_tag_ref_set(ref, tag))) {
 		this_cpu_add(tag->counters->bytes, bytes);
 
-		if (alloc_tag_trace_enabled())
+		if (alloc_tag_trace_enabled(tag))
 			/* Trace successful allocs with their unique ptr */
 			alloc_tag_trace_mem_alloc(ptr, tag, bytes);
 	}
@@ -249,23 +276,13 @@ static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes, const voi
 	this_cpu_sub(tag->counters->bytes, bytes);
 	this_cpu_dec(tag->counters->calls);
 
-	if (alloc_tag_trace_enabled())
+	if (alloc_tag_trace_enabled(tag))
 		/* Trace frees with their unique ptr */
 		alloc_tag_trace_mem_free(ptr, tag, bytes);
 
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
index 7d4618bea043..dafcba2f7e2c 100644
--- a/include/uapi/linux/alloc_tag.h
+++ b/include/uapi/linux/alloc_tag.h
@@ -85,9 +85,20 @@ struct allocinfo_get_at {
 	struct allocinfo_tag_data data;
 };
 
+struct allocinfo_toggle_traces {
+	/* inputs */
+	/*
+	 * Tags matching the filter are toggled; an empty mask selects all tags.
+	 * Size criteria are checked once, against the tag's size at call time.
+	 */
+	struct allocinfo_filter filter;
+	__u64 enable;
+};
+
 #define _ALLOCINFO_IOC_CONTENT_ID	0
 #define _ALLOCINFO_IOC_GET_AT		1
 #define _ALLOCINFO_IOC_GET_NEXT		2
+#define _ALLOCINFO_IOC_TOGGLE_TRACE	3
 
 #define ALLOCINFO_IOC_BASE		0xA6
 #define ALLOCINFO_IOC_CONTENT_ID	_IOR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_CONTENT_ID,	\
@@ -96,5 +107,7 @@ struct allocinfo_get_at {
 					      struct allocinfo_get_at)
 #define ALLOCINFO_IOC_GET_NEXT		_IOR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_GET_NEXT,	\
 					     struct allocinfo_tag_data)
+#define ALLOCINFO_IOC_TOGGLE_TRACE	_IOW(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_TOGGLE_TRACE,	\
+					    struct allocinfo_toggle_traces)
 
 #endif /* _UAPI_ALLOC_TAG_H */
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index ca2412a67312..262f00f2bba9 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -60,6 +60,15 @@ DEFINE_STATIC_KEY_FALSE(mem_profiling_compressed);
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
@@ -296,7 +305,7 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
 		return false;
 
 	if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
-		inaccurate = !!(ct->flags & CODETAG_FLAG_INACCURATE);
+		inaccurate = alloc_tag_is_inaccurate(ct_to_alloc_tag(ct));
 		if (inaccurate != !!(filter->inaccurate))
 			return false;
 	}
@@ -317,6 +326,23 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
 	return true;
 }
 
+/*
+ * Checks that a user supplied filter only uses known fields and that its size
+ * range, if any, is not inverted.
+ */
+static bool allocinfo_filter_valid(const struct allocinfo_filter *filter)
+{
+	if (filter->mask & ~ALLOCINFO_FILTER_MASKS)
+		return false;
+
+	if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
+	    (filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
+	    filter->min_size > filter->max_size)
+		return false;
+
+	return true;
+}
+
 /*
  * Seeks the ioctl iterator to the specified 0-indexed tag position, reads its
  * profiling data and returns it to userspace.
@@ -333,12 +359,7 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
 	if (copy_from_user(&params, arg, sizeof(params)))
 		return -EFAULT;
 
-	if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
-		return -EINVAL;
-
-	if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
-	    (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
-	    params.filter.min_size > params.filter.max_size)
+	if (!allocinfo_filter_valid(&params.filter))
 		return -EINVAL;
 
 	priv = m->private;
@@ -443,6 +464,75 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
 	return ret;
 }
 
+static void alloc_tag_trace_toggle(struct alloc_tag *tag, bool enable)
+{
+	if (enable) {
+		if (alloc_tag_is_traced(tag))
+			return;
+
+		alloc_tag_set_traced(tag);
+		if (atomic_fetch_inc(&alloc_tag_trace_cnt) == 0)
+			static_branch_enable(&alloc_tag_trace_key);
+	} else {
+		if (!alloc_tag_is_traced(tag))
+			return;
+
+		alloc_tag_clear_traced(tag);
+		if (atomic_dec_and_test(&alloc_tag_trace_cnt))
+			static_branch_disable(&alloc_tag_trace_key);
+	}
+}
+
+/*
+ * Toggles tracing on every allocation tag that matches the user supplied
+ * filter. An empty filter mask selects all tags, same as for
+ * ALLOCINFO_IOC_GET_AT. Tags already in the requested state are not an error.
+ */
+static int allocinfo_ioctl_toggle_trace(struct seq_file *m, void __user *arg)
+{
+	struct allocinfo_toggle_traces params;
+	struct codetag_iterator iter;
+	struct codetag *ct;
+	struct alloc_tag_counters counters;
+	bool fetched_counters;
+	int matches = 0, ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (copy_from_user(&params, arg, sizeof(params)))
+		return -EFAULT;
+
+	if (!allocinfo_filter_valid(&params.filter))
+		return -EINVAL;
+
+	codetag_lock_module_list(alloc_tag_cttype);
+
+	iter = codetag_get_ct_iter(alloc_tag_cttype);
+
+	/* Toggle tracing on all codetags that match */
+	while ((ct = codetag_next_ct(&iter))) {
+		fetched_counters = false;
+		if (matches_filter(ct, &params.filter, &counters, &fetched_counters)) {
+			matches++;
+
+			mutex_lock(&alloc_tag_trace_mutex);
+			alloc_tag_trace_toggle(ct_to_alloc_tag(ct), !!params.enable);
+			mutex_unlock(&alloc_tag_trace_mutex);
+		}
+	}
+
+	if (matches == 0)
+		/* Nothing matched the filter */
+		ret = -ENOENT;
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
@@ -463,6 +553,9 @@ static long allocinfo_ioctl(struct file *file, unsigned int cmd,
 	case ALLOCINFO_IOC_GET_NEXT:
 		ret = allocinfo_ioctl_get_next(file->private_data, arg);
 		break;
+	case ALLOCINFO_IOC_TOGGLE_TRACE:
+		ret = allocinfo_ioctl_toggle_trace(file->private_data, arg);
+		break;
 	default:
 		ret = -ENOIOCTLCMD;
 		break;
@@ -492,8 +585,6 @@ static const struct proc_ops allocinfo_proc_ops = {
 
 void __alloc_tag_trace_hit(struct alloc_tag *tag)
 {
-	if (unlikely(!tag))
-		return;
 	trace_alloc_tag_hit(tag);
 }
 EXPORT_SYMBOL(__alloc_tag_trace_hit);
@@ -1031,6 +1122,24 @@ static int load_module(struct module *mod, struct codetag *start, struct codetag
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
@@ -1357,6 +1466,7 @@ static int __init alloc_tag_init(void)
 		.alloc_section_mem	= reserve_module_tags,
 		.free_section_mem	= release_module_tags,
 		.module_load		= load_module,
+		.module_unload		= unload_module,
 		.module_replaced	= replace_module,
 #endif
 	};
-- 
2.56.0.385.gd3acb90ef8-goog


