Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C7FD606A31B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 17:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=V5wdiMd8
Received: by kanga.kvack.org (Postfix)
	id CCD7A6B099E; Thu, 22 Oct 2026 13:38:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C77D06B09A0; Thu, 22 Oct 2026 13:38:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3C236B09A1; Thu, 22 Oct 2026 13:38:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 778146B099E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:38:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F132E40103
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:38:31 +0000 (UTC)
X-FDA: 85350971622.20.741A5C5
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3FB2040003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:38:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=V5wdiMd8;
	spf=pass (imf12.hostedemail.com: domain of 3FEraag0KCG8NOUVfURXONcNgTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--abhishekbapat.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=3FEraag0KCG8NOUVfURXONcNgTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792690710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WS9otnJYzEV0+5/QDJL8y5YBapfWuijHL3woqGPHVSE=;
	b=4XsZBiu7PKC84xAj8yf7z9QzRZJ48vvecEI1GqxevE3GW1mdPmRqXOxL7e/s04m8al42nV
	tgymeLYJXdzmquiu4LG8hjjhXXE3haanNVAitPg9/ftfWo5hKyXUaOsx82m5dEm7QJDHVc
	O10zBhV2KZky6p9kN9zdh2T3GBQdiG8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792690710;
	b=WVra4fofcHJ00i9DdMQWS1++meZjbsrf9kIvScsYvauwcxpL9x3VV190zO+ODy+ZHFhPTI
	JNqq/V/hP1vczG6v14Vle2KII+QdCxCVop0oR/UG5pbJ0wCuclFRdXHObTGbY5EbgqJ4d7
	RjfDaVvjq1Vb34SDOh8Fsf/0gERMzq0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=V5wdiMd8;
	spf=pass (imf12.hostedemail.com: domain of 3FEraag0KCG8NOUVfURXONcNgTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--abhishekbapat.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=3FEraag0KCG8NOUVfURXONcNgTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-3698bd5392cso358112eec.1
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792690709; x=1793295509; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WS9otnJYzEV0+5/QDJL8y5YBapfWuijHL3woqGPHVSE=;
        b=V5wdiMd8Cs5Y2vQLCf5Ed6Cz7bYAVgkFV6QgJLD1au4MizBgEV5lQJu84OQnE1y7+7
         IjUtdtscTk68GT5rie5kfNEq93V6PP0b6ri7Z1NumL/oQi5QKtqe/+9SJP5k04rKYaBx
         AeWkP2DXH2TE+xa0NBdD5oTUw6SMr+4luOpGNj4E/gLxeSpXLGPGHMa0T3xDQ51Xmjd6
         LRXgOW+OPZjarcNIlyDwX90kB+FwwZQ+uwmoGU+y38aQ5SFKwWEXF4mK6noVGgVi3QsQ
         JWPL5Mq0zmm7D2qDL/ynvLBlQ9zSdLLe4ai4D7Elkq40+/eGlLGpENFy8pbB9LnLwmFW
         6aOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792690709; x=1793295509;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WS9otnJYzEV0+5/QDJL8y5YBapfWuijHL3woqGPHVSE=;
        b=aH6YIIiyqVY2FnWkm3O9H+rxrT5/Gu7fjlZB27Jl3ZeZkpm2L9Schgo+EL2BHlNmD8
         SWQJsn1ONATYGdg2C7F8v8JhgeYa9diM5V7+n7yDaK6Ygr1xI4LNxTARttFBjC8vlayh
         q4dbaHd5+qMyE8fLCPjdWrKuQa+9bliuwFCbM5fL0p9WtL+LXWpBI6cmrHV1lkPbiHDk
         97TAnN3u/2ER5HOBm6f/p6CTx+P+gkDKM6R+S4DpOVrSD94+dLKbpFnFgjfqu6gTU9FF
         pKnvApW5uOMLTp6ueA1Pek9lqInS4JRjsOedr6kszkASWw9k9TiFR2zBF+3kfS5SAZv2
         5bZA==
X-Forwarded-Encrypted: i=1; AKwUvBzR2T3PR4WU9gzh8zJrdENcn25cNd28PE51vng8i6TFUnFhFMCYiLLdYMR4fTpGSJFCBVoNweA5EQ==@kvack.org
X-Gm-Message-State: AFq9FYKOw326GRJD3eZ58+ZXvSE0aOq+BydtoIb2R0p9pS4lVMc47yjL
	I/JtYXANAoKx2D7RV2kQrAw0V2416CNEZDAu20g4kOnfyXdN5OSRicCAO52DwmTSXUEM4iE9Zaw
	8/UKoiu82PnO5GmWAr8coXJASERT19p1SeQ==
X-Received: from dycok18.prod.google.com ([2002:a05:7301:db12:b0:343:6b6a:3d5d])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:7e17:b0:366:6c79:212b with SMTP id 5a478bee46e88-368b122ff22mr3447592eec.25.1792690708648;
 Thu, 22 Oct 2026 10:38:28 -0700 (PDT)
Date: Thu, 22 Oct 2026 17:38:21 +0000
In-Reply-To: <cover.1792690544.git.abhishekbapat@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <cover.1792690544.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <a57fe6bda1ce4d98de14babf059aa63dd734c730.1792690544.git.abhishekbapat@google.com>
Subject: [PATCH v4 2/4] alloc_tag: Introduce IOCTLs to toggle allocation tracepoints
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3FB2040003
X-Stat-Signature: 9k8qawtecho6u6rd5brt7nh6yxdf5b58
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792690710-41766
X-HE-Meta: U2FsdGVkX1+rXk+0oAz63cHz4bR0Gp/mIAKKVBHQ0q5cR2zaJK75Sr5TaqBEkdwVaNHQWeHp/8EzKZDEjmqVeorsf27sQxZyGXAKRGLdbRUko2anbTkcSo/QvO2H7hgXkjxADyrH0XRgK5U9830G/7WKSnZOwLgAwp4UBldzinW5B19XMf+8ZDwPSdxKinfIPs0VmYzOBmYI/D3mFXi2T6lJeEBgivzLuq7VWU0cEfbiaiyLPWTVf/ajMm4dxOsn1+HSlX7IKOOYdmalVdtHgciJPiSyiv0/GxgtyF1pFdtFz3JQRcq5OYGPEs18ahePmMKDO2eyLFUPbPTtYQBTG11+LQadeDBP+EFGbTF4cIWjj/nJH73OninycH+mirxElBt+/kRd2k0pTynxo8pNuYIMTzgFyaLu1xDUDohH1dzCLqViHF3TAnhNCc8ZVLYRRJmLhU6Q9QMhOirIPkVYwKmnEvnntzmz5rg5kTYMSKrI2K+yWY1U+EIWYZLiTV1cwsmohQtmeQzHKgBMpjMj65azHov2xcv3ry/qm2fCejxTjzl2d3Xb3BVrayYdQGdvd18OIupXz/hqQcglJOYyoNPhL8QCyQpVy6ZqH1TFWtiWI7e7IbCRzSRmuQa7DVMCZ0Y5x+10VOE9ezQgEBHYZWhMgpg+Ts0ZYOA9r6tzAAGqBRLrl9C3wQWlYEAnFI0SGKot+Nf+675HtiDIa/aJ7V4mob2KCXqKOl5iEiWRsfb6E//Pe+kLv0oBAbk+QO73nSQOST3N2Tseu2BQxik7vRv+b42AYxwSSeRPmSLjOwVdinJJ155aAnAkCVhLCEWdYYsvfy/MrRzrn9566ca0ehZBgCBwzHldZjjsUNrpevv7dpGdFmmr97rhHLiiAkfvAmSNVRMfH7YD3m6jilZc3ghjRIUz85G/GKuAFh8WuTa5jdEW6LL00XpvuGbUxp/xwbBj6NWCs7i1pH+TbgX
 PhAs6dzQ
 q/GNsgVJNQfwxBXXN2xrx+Mg8OlTy16JiDi+MDUAhWFFgmB7EhD+9TnCShwT1yQRyEf+K4x6OaVdT9IlD1kpkh5KrNasaWCdiCCbTMKs3Yk7mJ0AzZCArNSbqFe6bPg+3AwdCeZeq9kvVqMlgss7H5pggKqseuyFDyz0F+ujGQVXoiQlMrXq82KIqrt9N/9u9kOyHywCF7pkbEB2Bc5BYvSQzzPR6c6WhyIrMuTzk+psss3dkjwbgLTQCq4QDhSX+4ITpLfdB2nb93CK9FGwCn0S6SikPiKhomjOxjJX9x1zo8hm9x6cMiUWaWrMzqNPQr684MOmBlyebXxE7pFqloiNGF7SfL0Z2a6pmvzgc/o2fOVUPywJ8CMsh873ImgbQ37axXLviBSmrE0IXOpreod5/kzujnbUrPYMTSMcU+s0TD9JhFulKzr1HblLPA36jUYLRbDKC8jNq644SwS0SiZwZAQ5aS5Ei9/ZvXILuykZvZNh+Lb/K8B2SlM0tZseBQyf5+X75o2Wo1dLmJ4kQCpbSnoAgflZycyQyFYBqjgI4M1Az/QMFv6oLtGxD5PkSJq3zXPxUlgzzgyiBOG/ssW0OBFxRlTlk8kjy5tG80XJTVulgG5KzbWIYSM5qWUue8YjA+kk1YiwvpBdt0RQJ/C2o/Pqv+f6VrCyc1kqeHHn+N1k=
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
2.56.0.257.gf7497c7d27-goog


