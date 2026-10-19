Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CAD0606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 20:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=eiaKsJw6
Received: by kanga.kvack.org (Postfix)
	id 0C5636B0366; Mon, 19 Oct 2026 16:00:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0766C6B0369; Mon, 19 Oct 2026 16:00:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5F366B0366; Mon, 19 Oct 2026 16:00:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F2396B0366
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:00:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 13822A0859
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:00:38 +0000 (UTC)
X-FDA: 85340443356.21.A83993E
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5EB3112000B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:00:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eiaKsJw6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 333bWag0KCIQijpq0pmsjixi1owwotm.kwutqv25-uus3iks.wzo@flex--abhishekbapat.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=333bWag0KCIQijpq0pmsjixi1owwotm.kwutqv25-uus3iks.wzo@flex--abhishekbapat.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792440036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RmZW/EaxYtDr+F004TjWzi+O0SiFINYBCEInP1SKBj4=;
	b=hUazMDCOgCgjBUftLld84tIEbHb31RZjYkEDFzhZytBNk2JyyuF18PpMxkpxLqTFmylGDw
	3OkO9cnKOnSBFzoRlAN1fvYkuVaoseSvBP1a2io6FRlmuBZVcj3UUHWluecFPV9MW0DDan
	3AO5qdS2GYu+VVLGpfufSeJlmuLLmkg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eiaKsJw6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 333bWag0KCIQijpq0pmsjixi1owwotm.kwutqv25-uus3iks.wzo@flex--abhishekbapat.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=333bWag0KCIQijpq0pmsjixi1owwotm.kwutqv25-uus3iks.wzo@flex--abhishekbapat.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792440036;
	b=2XcBUqdqKA8FbjRe2Ntx2iuWa5gQ/xYX6oODBlXgBlXvsCkEVwJlY2xUIvYuc71Ry8GNAu
	LrNAV48dzQ6eRya/UVx6xIuosDTn4UmE6OmrDRvHL6qplPE4SWdCCSFv4HLVRNXYOwRNsH
	UZqL/l+6LuL4EORcaQH2+8K/aJUsqm0=
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-30c0d568830so5350887eec.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792440035; x=1793044835; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RmZW/EaxYtDr+F004TjWzi+O0SiFINYBCEInP1SKBj4=;
        b=eiaKsJw6fQ0XygGWrBW1NaHY2WBqqYxYdeLPGf23oqCaXUb2S5AN7gW4mUTEDCtcuo
         bm+RFf3zpBsALzHqhNXcVGFXGaDeRUUBf5wtp1T72ltKOgy1Om7qrGlrK5AQxa2n81Tp
         7pyi3munhEFpNHNwCdXTpQxCA13uuag0TijejAB0LdzBG+zureQ4auYiiDZSvfNs5SEj
         p9UAFstB98/FwVrtnzFEfLFUg88m82Yixj4/GcDH+Us6nOeTCqNC+BwcMbnOQULSynyi
         NUh6sOGQIEquBV6u2AM77j1fIDQHhEgs7VKw+xOVakTMeVcAV2DOuDrSYRmKfIe5Rd3f
         xEcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792440035; x=1793044835;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RmZW/EaxYtDr+F004TjWzi+O0SiFINYBCEInP1SKBj4=;
        b=yR426gXZR6tQBEoKyek4y8bdfGkjfy5DEkkt+K05diHpA++JGR6jFIjypjuUdd+EWy
         +jcxnHdlMiQ5I5MjpLMagKkuUTwADAvb+Hw8u9yo+1OOHdNZemVsa1wDxRpGmrRvpyiw
         ZN2rI/4UsblKdDHpAmMlFm4FmzR+Z2EarUbKLa1A1SFLLc86h+b/MiouGqWpd/D+ijXR
         jaq0ccoScZScUX4VpFPOjYOJmfKa4eZSW35fnDhw8iwVy2PeaI9gJrsl0a8ZOjNUeqF+
         4a4EjzeZCliuu+AdCSzHuO1hhOahTz0aic7A5xm6LAJlQFUKHJshywWGLMJo2KyvD0jn
         hl+Q==
X-Forwarded-Encrypted: i=1; AKwUvBykFM5ob/KNhHjRP+fAzAg2eNTz38fjJQioFf94qdlgtvFS+5lNyHIzpV3bGTZ9UoF1wVKhPwKTlg==@kvack.org
X-Gm-Message-State: AFq9FYLvDCVs8/cYSvXzbyc3O72QS5sSzc/yi6ETJwoUpRqgOEsGffzz
	oKMXHeYFF7Ixb6D2g47k5SdO531GJFliUi8i+vF0lGDisdTsaTBO+vt49U3jhPof89TEROQdrr4
	fL+Qe/13F4NjHJLsDzjLRJm8tkQtRhkDezw==
X-Received: from dlep3-n1.prod.google.com ([2002:a05:701b:4583:10b0:145:9130:6444])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:701b:4510:10b0:144:fb87:5b91 with SMTP id a92af1059eb24-18513e80de6mr11985995c88.44.1792440031935;
 Mon, 19 Oct 2026 13:00:31 -0700 (PDT)
Date: Mon, 19 Oct 2026 20:00:25 +0000
In-Reply-To: <cover.1792439751.git.abhishekbapat@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <cover.1792439751.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
Message-ID: <6f243b0d48e541b35e31a49841ea02cb9a328d99.1792439751.git.abhishekbapat@google.com>
Subject: [PATCH v3 2/4] alloc_tag: Introduce IOCTLs to toggle allocation tracepoints
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5EB3112000B
X-Stat-Signature: xkrgakumcz17dg19gkx94pp3yid4qxnp
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792440036-211740
X-HE-Meta: U2FsdGVkX1+H9EjiJqOuaKXxGrTb0A7r3UiJ1rMKt0EpAe67THaQSFQ2pUuiqhJFLY06K1Kv4JsMSWd/szVVYXIP+6zHYdiz2+aG4IP3ZB/LDGq7QN4zNkOONV8jOguiJz5Zc01L5i+6zAcQKQyvbLL8vMj/KploujYb1Po+GUbRhsUIVt1rBiiOV0z2jE+0O1QfksVseaJgfqAwBd94WVQ1qY7M2mrotlac6sDnNtjSgaRNaDacsN8Dj+P6ufqWRhOcVJFeBqE3xKq4nWMRJ2CX8/WQyaaO9jhS0J9MTBrvxs6WUBn6dRtT1vJeGVjskuhh/Z4KJT1VtI/x20mAFwbGVilnMeFPBtvX17NHmWudkh/B4YqgUoA4sWKwIP+yxUDnbtnOMBAfaDJ3xJBh1Yb55+sFdPIM3f7aWYrgWfEW6dTI3SWHr+LoL1f9APjtnH6JMId2PLsIkR51LzF54CASR0GwlEO5CqUMgwR1zdk8SwjypF5X7VqKXGT+ZgAyKsrtF4IJB85ORuc93Cv9KgFiV4wM2bgRO6yom3/4NRSK4K/ECiF9O1/tVHZ7UhGHtoRTaKIZipNHlMCqOlw4bd5VHjGxP2NApsiA6ki9jJU/Gor+GLekmehO+dmJWXCghSK50HlHNpU5wrY1IkYo/UsL61Hl9056oWP65+I8wkcR2w1pXXfZHCU/2t7b829B0UtHLvCXwRWZ2jKAdn+C8AsmlXnXDKs9lEtCMnxLEQIB3AW89rys6TETCNS9wgfl96YGyzWMefEgVnmP+EwLMfmrUA6ayvpsxRcszqTs05bs6DE9VfGIpQekqWrBbiFYjbQ2nyTuaNlzZ2EqljYITOXnN0L7VJiV03rjBeG/4aKokGWlNe2I2IaW7EUinQVlm7l538odkXoobElxrPgQRYNyBWsZsoRxOvoQnNZfQKOR2yWiUZJGAZafuFhltfU/bpyVWV/cw0jsd9GVwMf
 nadtVqw5
 Bnz/BTX/MG9P2girJZrWyB4Z+hkK66rLCdBUCSEJRWhX5LckN2asoOlush8sSRV8GynTv+V+TX23oIOG4BxFDHh3CoFWfgcX3XHTsQJ9Zj/tQCs+q8Wg9AeiUi8MzBFdiqiB+sCVwdZIhuO1NGnGTzq/5edqkPfQIPL6amwhQR8ZLhBTQy05HaIWh2rip/XX8VoMlN5lZR7dtmyX8QmyhdSke7axXTrihlzEguRZevpY2vA9JgkFv0CkyO8QjQ/MCCwB1jBvy/3Y98xUwaukJZAPAnojDh6WQVXg0tadcC53rydJa6b6OTtdtHXsHsWYcccN5KLU5xFSWOJ7a2TTve6GPuFbePx0FUxgv+s+DkrhNtiajFB9dlLaOFAGUpYhaUmnTWJcSnjOGj76k4aDMUMWeFmVuBkT9BC/x9mNfhKRQBS96kSeAGX7d2yn7yJJCb4t8BRfji5RNK4fBJpolMe66LM4PXSXFGxyFaUYmWSmKYr4meIWECiouKU30DHc+koXjmp6S9vNHv6mvNp8MAXpwLCKWXoUrA9wSx4JpUcOAj4l+eBrq/BYP3VYCZfTuf5zRKd7yGwdDBVSOmkx8lLgIkfOAcBbtAnET9g18RKurqTI7StMDF6+ambLZ1Ou6zF/mGcM0x4u5wxRDiMnfCQsXqUeQ9NB807cdMHWvvw0Gqus=
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
index 0319c2f1e4e2..4e72c96f31ea 100644
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
2.56.0.218.g1ec904b173-goog


