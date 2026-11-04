Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3B85606EE9A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=od6rdxah
Received: by kanga.kvack.org (Postfix)
	id 111AB6B05BE; Wed,  4 Nov 2026 14:03:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EA986B05BF; Wed,  4 Nov 2026 14:03:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECB916B05C0; Wed,  4 Nov 2026 14:03:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA29D6B05BE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:03:48 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 533D81207F5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:03:48 +0000 (UTC)
X-FDA: 85398360936.22.72C633E
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8830620008
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:03:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=od6rdxah;
	spf=pass (imf03.hostedemail.com: domain of 3kIHrag0KCJ89AGHRGDJA9O9SFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--abhishekbapat.bounces.google.com designates 74.125.82.72 as permitted sender) smtp.mailfrom=3kIHrag0KCJ89AGHRGDJA9O9SFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793819026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hJyeXduiQM+4dzc6a9GLkCFM1A1rcEOgjiBv2Ui60dQ=;
	b=gVekLSF+q06tlJjCF/pPGncixcECZxZcDkJlYTWf4/OmAVBNGO119xXcEWDDtTAbwPCcW/
	KklQr+Nvwma107eadqK0LRmb8RDXun0fbnzHjlZWX2cPyi5TaT6Ith4Ithp8hj1kq6koSC
	AF4/dEgKXVnDt1B9dxdX1UEz2+AXUag=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793819026;
	b=vr0+YaydguHkCs6t+Ea4j/JrXVPC8PuWYTHne4DOmW8yYMuV5MzFQROntF92EJCj2loiD4
	5IxrNOVCwTxfRIAK4xkgJFu1zHmn7S+Zo2UMvjUUkFwJeR23lbE+YJbblAQGaZaMWYuNg2
	F9XMA94ZQHCYLFWhZF2N8BVML4DAy1A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=od6rdxah;
	spf=pass (imf03.hostedemail.com: domain of 3kIHrag0KCJ89AGHRGDJA9O9SFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--abhishekbapat.bounces.google.com designates 74.125.82.72 as permitted sender) smtp.mailfrom=3kIHrag0KCJ89AGHRGDJA9O9SFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-15c16792146so1264944c88.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 11:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793819025; x=1794423825; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hJyeXduiQM+4dzc6a9GLkCFM1A1rcEOgjiBv2Ui60dQ=;
        b=od6rdxah+/B/v6w+xMhPZhwWJmQWvmRk2IcYOz2RX1gdk3dyjQfdVmwBRULVW/FwYq
         zshI4qp+te4UixJPzvYo+B5d9Ytd+dF2ZQNM+gc41hcG8pQM2TW/zTsD1FaeKsCLMrjx
         HYAxpa2l1LJgRKjImCZ2lihFfpy2EJzKzL5NVRnC1xabsVcJT8JUx8bOmYwmVoJWYRHE
         nGQQW4cGKc7sWjNnNBMvyy8FPK7WdePBvD28wTCioHYgdBea7o/xmT0GCPxx1pzP8ZPt
         j/8bUfJPsu1THzNXW2baSMn58eIIFLlT5qk0jvc9bpp1/fT67Fl5dtgcuHU+xY9qije7
         dx1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793819025; x=1794423825;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hJyeXduiQM+4dzc6a9GLkCFM1A1rcEOgjiBv2Ui60dQ=;
        b=2oIDxgzZcxVPmkdexGPZisJfJS6xc+5Fa9E/5HGPYyjKLes6EwSSK6B0Hk2BWSVC0K
         PTucQ4Y8CMEjprpPNFVYu8VJ/aGyLlrqZMkXmZCOi1J+uD3C5WzLY5RzOU7fcscRP25T
         5M1OW2Vw7X+70LXktn0m+HP1l00QbKEqysvHP1RQY+uek2lvktB4GC2IosnLGizgI/BB
         V45+bw3TJ9zM4yZsXNVCBV3sCALsA5Zm5M1VkbiP5sGfWo2HaXd56PeNP3pfUlM32zKA
         l4vXgV7MnZHqE0osVMyZsbdBQTyTPUH10mHNqMXImJdR8TxkPMbH79quZne0y1iW6yU6
         hb4A==
X-Forwarded-Encrypted: i=1; AKwUvBykRpjUcDPsLq2jJ7ewyjhxl3+uwbUcyws2V8hJaeY9VXSTtrFtQk4IDrXp9yLCjx7dDNXkP/zWGw==@kvack.org
X-Gm-Message-State: APuU4Z/SEU3JF/5gvxY38pHmW/bXOGHiehMLcN4yPVHhhzg3N9lw+aTt
	NU9MrD2oWsTPfVrbEYis69/M5bMWMWfYaBYzUqbPlqGHle6RVoSYJHW59u8anTJuJh1h2EQbLEO
	/SzyijhcnpU5pJfaY89zXB3YjzOS68QWkcg==
X-Received: from dlbts16.prod.google.com ([2002:a05:7022:b050:b0:1a3:1342:a32d])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:701b:464d:b0:1b2:3497:5998 with SMTP id a92af1059eb24-1b2349759cfmr12065722c88.36.1793819024797;
 Wed, 04 Nov 2026 11:03:44 -0800 (PST)
Date: Wed,  4 Nov 2026 19:03:37 +0000
In-Reply-To: <cover.1793818636.git.abhishekbapat@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <cover.1793818636.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <37ae7dca766994d3872fcc65b623a80d5d506369.1793818636.git.abhishekbapat@google.com>
Subject: [PATCH v5 2/5] alloc_tag: Introduce IOCTLs to toggle allocation tracepoints
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8830620008
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: xd3obzn9r3anwcus61ru5f15rkcxb6na
X-Rspam-User: 
X-HE-Tag: 1793819026-620821
X-HE-Meta: U2FsdGVkX1+2I2kDs2uEG5sdBHD5fZfTg2xYGVeFMc0BRS78L5ngrAArnyNHKnAQIE+u3kcWWMSNYR/kQEdOYz7QPERPMQ9GDOhYoYhns2uCyM6gzdMsjim0dGNGCciAlaQZizPbiE/fpqGL11Oxb9qy/+xUJ+mjfp40cSMqM+YGm4P7XSjDkTJoZl03vwihrv/Nb5n0/cJkLaykAdDYT4YJvjconJ7iu6bQbp1yhSSPvPJfCF4FzSJWCjFtAoPJ5eWiEUxbORPt8qsDa6vIv+y8tzGJl7M92/tjcfINVwvIRUih/stY85d60tma9wHYZuNiwYMgJljdY1FqJ76LHLM0z3XoI0EF5ypSJUTThXedLjS2RIO2VMEfUpQF/TjzwuVQseyLRYcTzir3tdR8M/RVt6ZHoYCGAanghsftXawblxbfHiCEQf7ErrRhhXylGOTmpsJG1W/UzTFtFwTqsd7nX0KyCHHs0yRW4OzmsdF/eetd1ZfTFeYV1yZoyEsA3M3mvQlxRY8Ax+u9ql1fsyWE3v+IVFiJpooMHlAUd3Z4bT87jIXB4LjdYBnCQtF18XT3SD/TqjhuTgkyGK+GCdqp2m6eRPddXnqvf2rocqmqSbHEDTXGvh4/otnGJ2sosmMrRHoESlFwt6i7XNPJKI+hTAJrGoymzCn5HRzrZVwBAB7WR9bjAV6n1wwI65O6mIDnx3qwn/cZoaKAcle/BOWDwcx98mVEY6oZsQQKqF95fe+BwbEhJGm+83IkHFBhaIre90NYNDmzf1aDIO7AOznGhSp/lZocKAMiEpFK1nw/sccdVFztUHxhcrPxvCl9iAy5wpa51KqgMjcHgGXFgE95rr1VPxve+XZgDlfLKOncH3k6wq7/9zmS0y878n8AR4DAoDsIgu37HFOyHzOcXqkxYbqf7tAyzNwb5F9NgRv8/1B2vEoEmYkPEZmTxxTZmGzV0IsNoxhG8Grj3op
 sxZqyNdT
 yExqZmd7/5vPcu56e8LmE1/uoIO35mchmBk2ZEcJ0C15UqVhs+qtnfLfajbrqPTvIzIPqe0qrq+N/tRCjvYf3ZJ94q7Zj79wH1hNiuHD+uSnyvtG+MSY55Lhf6V0+li/Zbs7zqq/dHe/mdAuXOX2s216JGNBFq6piMo5phRF5xq5OGj+jgvIrRZONDZ5fti2Nv0kEhbJPRpAIGznY5/ktXwLx//dSHj61Tb2yROw5wlu27o2JeAolGg7oxzcQt1qMZK0lHyt0lBVMVZJmpaFC/dFmdSzwZAe74wHZf/A6Wed6OlJ3pl8Hrn/Hq2Gm4P68bTM1uXHRH5Z9eEkxQHM9RRUZA9OL0iE7nC8vKRjx9ctwYUTRs1Az4l4pimr9P6C8DDIgaA8xV1bREIVnH2zzn1LEa7aOvg/Nhaqqs4cdEsXoD2qgYbzwTFW7bdHpDN0icZYWpq/g+FPlvaiTeY56U944i6ZuxnBBUn/CNYPj/llcpSplyiiwwVkZLYJFz3cTd0PYmvMHl8A6Vop+E/IbclLPvrFF4qGGMXV402Exurj0Cs5+WuUlHEnhAkXtU1LV+GNNnGANiAgelQUtHCQl4nfb+RE7ZUY4/yPA1cvL7w1Mqo74kjgmEmrfRhqXRRnP+nWJHleWD4X4OC5xLbROJlSUDGEQuEQx5Jeb6YM2098aHE8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
Acked-by: Hao Ge <hao.ge@linux.dev>
Acked-by: Suren Baghdasaryan <surenb@google.com>
---
 Documentation/mm/allocation-profiling.rst |  20 ++++
 include/linux/alloc_tag.h                 |  47 +++++---
 include/linux/codetag.h                   |   5 +-
 include/uapi/linux/alloc_tag.h            |  13 +++
 mm/alloc_tag.c                            | 127 ++++++++++++++++++++--
 5 files changed, 186 insertions(+), 26 deletions(-)

diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
index b241450394df..b855f8ac87fd 100644
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
+ioctl on `/proc/allocinfo` (requires `CAP_SYS_ADMIN`, returns `-EPERM`
+otherwise). It takes the same filter as used by `ALLOCINFO_IOC_GET_AT`; an
+empty mask selects all tags. Size limits in the filter are checked once,
+against the tag's size at the time of the call. Tags already in the requested
+state are skipped and a -ENOENT is returned if no tag matched.
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
index cf8a29d463aa..00eca9bf8190 100644
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
index ca2412a67312..9ff9dd04d692 100644
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
@@ -443,6 +464,74 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
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
+ * Requires CAP_SYS_ADMIN.
+ */
+static int allocinfo_ioctl_toggle_trace(struct seq_file *m, void __user *arg)
+{
+	struct allocinfo_toggle_traces params;
+	struct codetag_iterator iter;
+	struct codetag *ct;
+	struct alloc_tag_counters counters;
+	bool fetched_counters;
+	int ret = 0;
+	int matches = 0;
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
+	mutex_lock(&alloc_tag_trace_mutex);
+	/* Toggle tracing on all codetags that match */
+	while ((ct = codetag_next_ct(&iter))) {
+		fetched_counters = false;
+		if (matches_filter(ct, &params.filter, &counters, &fetched_counters)) {
+			matches++;
+			alloc_tag_trace_toggle(ct_to_alloc_tag(ct), !!params.enable);
+		}
+	}
+	mutex_unlock(&alloc_tag_trace_mutex);
+
+	if (matches == 0)
+		/* Nothing matched the filter */
+		ret = -ENOENT;
+
+	codetag_unlock_module_list(alloc_tag_cttype);
+
+	return ret;
+}
+
 /*
  * Entry point ioctl function for /proc/allocinfo routing requests to fetch the
  * layout content ID, seek to a specific tag, or read sequential tags.
@@ -463,6 +552,9 @@ static long allocinfo_ioctl(struct file *file, unsigned int cmd,
 	case ALLOCINFO_IOC_GET_NEXT:
 		ret = allocinfo_ioctl_get_next(file->private_data, arg);
 		break;
+	case ALLOCINFO_IOC_TOGGLE_TRACE:
+		ret = allocinfo_ioctl_toggle_trace(file->private_data, arg);
+		break;
 	default:
 		ret = -ENOIOCTLCMD;
 		break;
@@ -492,8 +584,6 @@ static const struct proc_ops allocinfo_proc_ops = {
 
 void __alloc_tag_trace_hit(struct alloc_tag *tag)
 {
-	if (unlikely(!tag))
-		return;
 	trace_alloc_tag_hit(tag);
 }
 EXPORT_SYMBOL(__alloc_tag_trace_hit);
@@ -1031,6 +1121,24 @@ static int load_module(struct module *mod, struct codetag *start, struct codetag
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
@@ -1357,6 +1465,7 @@ static int __init alloc_tag_init(void)
 		.alloc_section_mem	= reserve_module_tags,
 		.free_section_mem	= release_module_tags,
 		.module_load		= load_module,
+		.module_unload		= unload_module,
 		.module_replaced	= replace_module,
 #endif
 	};
-- 
2.56.0.506.g506a7eabc5-goog


