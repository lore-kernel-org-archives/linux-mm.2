Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3CA4606A329
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 16:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bGQukq2F
Received: by kanga.kvack.org (Postfix)
	id 44EC56B07B3; Tue, 24 Nov 2026 11:30:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D8B76B07B5; Tue, 24 Nov 2026 11:30:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C82A6B07B6; Tue, 24 Nov 2026 11:30:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EEA5A6B07B3
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:30:20 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EA57E160BE5
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:30:18 +0000 (UTC)
X-FDA: 85470550116.11.E52DEC9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2F41C180003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:30:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bGQukq2F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795537817;
	b=VH34IleCJOlliHgKdc4vFq3W2MbDpDrXBlYDJMFWecGHPVY5AbgjU3Uvvqzh3wDCcmmUs1
	E0yqt6cz7JX77sNk5SnD0g9ezvG7KOTiwJBOMSFzvSvfUhltQvp3Ofjh8Qsx16tZhYCGtj
	2OpQg3EwY/i6Ltdqis5IFXpoPk1l95w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795537817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ZY+mY3lGI4RIRF4iKivJELc+MR8ArL5kqtChS56A5E=;
	b=E62/HiWz71g0Bu+WNIC25p9UOhQ/5pRE0O9B8Dr2FD1RDxphDmhxIZF397QaJ/atUU6GfQ
	JrE3d394aOJ4wKvo4tFMVviGxyZyVOWRcBFnriW3Eg7/bKcdvnn1uyjpmoL+q9GCCBW6KL
	kUaFyRFnjPMNflgfKrJm7BzGFe7LnV8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bGQukq2F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C37D6627A5;
	Tue, 24 Nov 2026 16:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77EBC1F00ADE;
	Tue, 24 Nov 2026 16:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795537816;
	bh=2ZY+mY3lGI4RIRF4iKivJELc+MR8ArL5kqtChS56A5E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bGQukq2FIXp5z2SmjTvAqMbciLFLD8iVWZ81cww33IS8H/bWi+FYfw/gAAVRfOE0p
	 K1H4VmVgqSC/s57NDFKNOf3UyRmD6z+RRnmbuiLZxxpDEYhrX6KG66um7JBDZ8SMzz
	 mOlx04L8pkntOYALYfvU4lWmntApZqSNiVctex6MwIlS6T0yz3f2a5lAdvIikK+kGW
	 3nJpAPel26nqe4fTcatno1zhhA3kIn3gSbHKfJPugv0dLkwpUrblVuCqhNmFtwx0zr
	 gu0yeAJBIEibNoLIyGVB4KbLb+/zTIR7VIhuSe4FsIvMy2vs4jsLKs9fnQGPkZYXv9
	 AyBqN8NMj6jXQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 24 Nov 2026 17:30:04 +0100
Subject: [PATCH 3/3] mm/slab: drop BUCKET_PARAMS and KMALLOC_PARAMS macros
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-kmalloc-entry-rework-v1-3-37b1631a67b5@kernel.org>
References: <20261124-kmalloc-entry-rework-v1-0-37b1631a67b5@kernel.org>
In-Reply-To: <20261124-kmalloc-entry-rework-v1-0-37b1631a67b5@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Chris Down <chris@chrisdown.name>, Kees Cook <kees@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2F41C180003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: mpimtts4ibymy7m8bsusr3tbi6gtzpca
X-HE-Tag: 1795537817-529002
X-HE-Meta: U2FsdGVkX1+x72YKj7C3GT6a6GpQ6rLKblPzvPeds9X27P6LnV68bg6D+I8GNyu2oRS+5+rW5K+9p6VwEwYjwU4Y1Hykdg6mzwKGdZjYgZNG9WxEUXB2SWcZkH3gbPDfbM4A0zoyBzSGcP29bK+XdAAN4y0vUV8wY61kg9uWNORoDTDUKhR7Q08r0ABIbOBSrR82+VJQVdP1gUuitU8cVJV8dEKpM0nC5ShJ+zrypUYwHifKWx1Gb7iX89ZjFOO7tC4h+z+jpZg+GAl5mehMSpQ2i2TxMcIp3H5txvPU3Bfu8SKegl+0tY86RuiRP+wjGBnWDDDVB2xa+4iBusr7Hd34usfO4gTnhwASYucTJjqyv1+uCopuSHyqNmyVjnntHhCLPi/V9M0cvgUym1aLDvFuvcP8i3wHgDcHa7/s5HnNDeRttbnuuVa/toKX1Ss5vyZHG23OSkR7qcSdVKwQRNDe1rJJFQp599pA9qOSTVIk3gmcC/45FHufH+6/DFEbS3i7TLjBOCfwg9PnYdWS1RjoA+RAGTOBLaFh7j+gcopd96dHx7h8deLzWDvCY678VoR31PAbhe7g44vkmcD+Biwsg9quRckvc1Q83a/HTxacHw+3oTDWbx0n1DI3y8ChZTGjy+M3y1WrH5FYyKEHhrgNQNx6WjH5V8S3Zxqen8ipi0ba19pv41/njxegFBsvexZzx5PafS4qum5CzI/SO4dSVt9IuhSOrEsRWudDctw0ofYOhrln5j5oMTx6kHUcwErAWFEhv3B2f1N69FgRDNSdZmdIVmycPSv9GDFixLbi3HcCgq10WhhMUTq5bz6VqQmywkgBL1LaZqo8ImrSG14xiOT3xaOb7ByfJLrf6rBGLEHYnSVRlUkXMFnwSeozDjpDbkaGhnjizeICcfkBCcdXQk5vjckLyorchX8ZJthiA63rEWmFtBgJgQErJFQVwRlIqaSN9lU6V9nmHIp
 UyT4Rgxy
 s6SA2I1jL/AEKuIGPEfCExaL1Wu+xOeoiRiuiYgtOdGSAdoWi6aktX9cQDXiJ4ZnWT24Q4qsV3/1wWULbzv7xVc/0V2hwAYt2htfL/hDCFULgPnx6omexFNqSi8H3rvtU11K4tBUlVUWcIu8OxCs1b4FRV9fGOVnyoVcDwymeFHEfYfTio6X3/xHSXQE6NkA5/33QoPRk0xyxiwoTaYaBO0cOBioD8o8nL6m2KcrfqZG4WiYH2sEdrTHM3om43/j9QwMC0j/l3V0CzFk9/T1XAmlrP53DIcLdjAoeg5JuZZZaG6HDXMxiSJLLd1nvVLPCcbvKbAw26gGuCs023nFtGBKBMjDQ9Z4hT1sZwwjiuwCwSoCFAbRcd9otz2ZII/keQn0/WfyRFwgVDhWuaWG7+wTZxyN7hvir6ZeKCIMzDRtWJNGz0F4dJ64tZchMEGlJ64HkekEM7lDkDEy063W+G9aH4hSTzBbYuKhN2PuP9MPFiazW9XEwQK1ryzC5H8DnobUpnl6BM923nzc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Now that kmem_buckets allocations have their own entry points, we can
drop the corresponding macros for kmalloc functions. BUCKET_PARAMS can
be dropped completely and KMALLOC_PARAMS users can use TOKEN_PARAMS for
handling just the randomization tokens.

Passing hardcoded NULL kmem_buckets pointer to __do_kmalloc_node() is
cheap because it (and everything that cares about the pointer) is
inlined.

This has a minor reduction effect on kmalloc_node() family of callers
not passing the NULL buckets pointer anymore with CONFIG_SLAB_BUCKETS=y,
as expected.

add/remove: 1/1 grow/shrink: 51/217 up/down: 1316/-1798 (-482)

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 include/linux/slab.h | 37 ++++++++-----------------------------
 mm/slub.c            | 19 ++++++++-----------
 2 files changed, 16 insertions(+), 40 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 46ecf99f044e..bf6ce52fd105 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -933,27 +933,6 @@ void *kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *cachep, gfp_t gfp,
 
 unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf);
 
-/*
- * These macros allow declaring a kmem_buckets * parameter alongside size, which
- * can be compiled out with CONFIG_SLAB_BUCKETS=n so that a large number of call
- * sites don't have to pass NULL.
- */
-#ifdef CONFIG_SLAB_BUCKETS
-#define DECL_BUCKET_PARAMS(_size, _b)	size_t (_size), kmem_buckets *(_b)
-#define PASS_BUCKET_PARAMS(_size, _b)	(_size), (_b)
-#define PASS_BUCKET_PARAM(_b)		(_b)
-#else
-#define DECL_BUCKET_PARAMS(_size, _b)	size_t (_size)
-#define PASS_BUCKET_PARAMS(_size, _b)	(_size)
-#define PASS_BUCKET_PARAM(_b)		NULL
-#endif
-
-#define DECL_KMALLOC_PARAMS(_size, _b, _token) DECL_BUCKET_PARAMS(_size, _b) \
-					       DECL_TOKEN_PARAM(_token)
-
-#define PASS_KMALLOC_PARAMS(_size, _b, _token) PASS_BUCKET_PARAMS(_size, _b) \
-					       _PASS_TOKEN_PARAM(_token)
-
 /*
  * The following functions are not to be used directly and are intended only
  * for internal use from kmalloc() and kmalloc_node()
@@ -963,7 +942,7 @@ unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf);
 void *__kmalloc_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags)
 				__assume_kmalloc_alignment __alloc_size(1);
 
-void *__kmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags, int node)
+void *__kmalloc_node_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags, int node)
 				__assume_kmalloc_alignment __alloc_size(1);
 
 void *__kmalloc_cache_noprof(struct kmem_cache *s, gfp_t flags, size_t size)
@@ -1204,7 +1183,7 @@ static __always_inline __alloc_size(1) void *_kmalloc_node_noprof(size_t size, g
 				kmalloc_caches[kmalloc_type(flags, token)][index],
 				flags, node, size);
 	}
-	return __kmalloc_node_noprof(PASS_KMALLOC_PARAMS(size, NULL, token), flags, node);
+	return __kmalloc_node_noprof(PASS_TOKEN_PARAMS(size, token), flags, node);
 }
 #define kmalloc_node_noprof(...)		_kmalloc_node_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
 #define kmalloc_node(...)			alloc_hooks(kmalloc_node_noprof(__VA_ARGS__))
@@ -1272,10 +1251,10 @@ void *krealloc_array(void *p, size_t new_n, size_t new_size, gfp_t flags);
  */
 #define kcalloc(n, size, flags)		kmalloc_array(n, size, (flags) | __GFP_ZERO)
 
-void *__kmalloc_node_track_caller_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags, int node,
+void *__kmalloc_node_track_caller_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags, int node,
 					 unsigned long caller) __alloc_size(1);
 #define kmalloc_node_track_caller_noprof(size, flags, node, caller) \
-	__kmalloc_node_track_caller_noprof(PASS_KMALLOC_PARAMS(size, NULL, __kmalloc_token(size)), flags, node, caller)
+	__kmalloc_node_track_caller_noprof(PASS_TOKEN_PARAMS(size, __kmalloc_token(size)), flags, node, caller)
 #define kmalloc_node_track_caller(...)		\
 	alloc_hooks(kmalloc_node_track_caller_noprof(__VA_ARGS__, _RET_IP_))
 
@@ -1301,7 +1280,7 @@ static inline __alloc_size(1, 2) void *_kmalloc_array_node_noprof(size_t n, size
 		return NULL;
 	if (__builtin_constant_p(n) && __builtin_constant_p(size))
 		return _kmalloc_node_noprof(bytes, flags, node, token);
-	return __kmalloc_node_noprof(PASS_KMALLOC_PARAMS(bytes, NULL, token), flags, node);
+	return __kmalloc_node_noprof(PASS_TOKEN_PARAMS(bytes, token), flags, node);
 }
 #define kmalloc_array_node_noprof(...)		_kmalloc_array_node_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
 #define kmalloc_array_node(...)			alloc_hooks(kmalloc_array_node_noprof(__VA_ARGS__))
@@ -1330,10 +1309,10 @@ void *kzalloc(size_t size, gfp_t flags);
 #define kzalloc(size, flags)			alloc_hooks(kzalloc_noprof(size, flags))
 #define kzalloc_node(_size, _flags, _node)	kmalloc_node(_size, (_flags)|__GFP_ZERO, _node)
 
-void *__kvmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), unsigned long align,
+void *__kvmalloc_node_noprof(DECL_TOKEN_PARAMS(size, token), unsigned long align,
 			     gfp_t flags, int node) __alloc_size(1);
 #define kvmalloc_node_align_noprof(_size, _align, _flags, _node)	\
-	__kvmalloc_node_noprof(PASS_KMALLOC_PARAMS(_size, NULL, __kmalloc_token(_size)), _align, _flags, _node)
+	__kvmalloc_node_noprof(PASS_TOKEN_PARAMS(_size, __kmalloc_token(_size)), _align, _flags, _node)
 #define kvmalloc_node_align(...)		\
 	alloc_hooks(kvmalloc_node_align_noprof(__VA_ARGS__))
 #if 0 /* kernel-doc */
@@ -1381,7 +1360,7 @@ _kvmalloc_array_node_noprof(size_t n, size_t size, gfp_t flags, int node, kmallo
 	if (unlikely(check_mul_overflow(n, size, &bytes)))
 		return NULL;
 
-	return __kvmalloc_node_noprof(PASS_KMALLOC_PARAMS(bytes, NULL, token), 1, flags, node);
+	return __kvmalloc_node_noprof(PASS_TOKEN_PARAMS(bytes, token), 1, flags, node);
 }
 #define kvmalloc_array_node_noprof(...)		_kvmalloc_array_node_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
 #define kvmalloc_array_noprof(...)		kvmalloc_array_node_noprof(__VA_ARGS__, NUMA_NO_NODE)
diff --git a/mm/slub.c b/mm/slub.c
index 6674caabbb6e..5a176322fde5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5552,7 +5552,7 @@ void *__do_kmalloc_node(kmem_buckets *b, gfp_t flags, int node,
 	return ___do_kmalloc_node(s, flags, node, ac);
 }
 
-void *__kmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags, int node)
+void *__kmalloc_node_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags, int node)
 {
 	const struct slab_alloc_context ac = {
 		.caller_addr = _RET_IP_,
@@ -5560,8 +5560,7 @@ void *__kmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags, in
 		.alloc_flags = SLAB_ALLOC_DEFAULT,
 	};
 
-	return __do_kmalloc_node(PASS_BUCKET_PARAM(b), flags, node,
-				 PASS_TOKEN_PARAM(token), &ac);
+	return __do_kmalloc_node(NULL, flags, node, PASS_TOKEN_PARAM(token), &ac);
 }
 EXPORT_SYMBOL(__kmalloc_node_noprof);
 
@@ -5670,7 +5669,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 }
 EXPORT_SYMBOL_GPL(_kmalloc_nolock_noprof);
 
-void *__kmalloc_node_track_caller_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags,
+void *__kmalloc_node_track_caller_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags,
 					 int node, unsigned long caller)
 {
 	const struct slab_alloc_context ac = {
@@ -5679,8 +5678,7 @@ void *__kmalloc_node_track_caller_noprof(DECL_KMALLOC_PARAMS(size, b, token), gf
 		.alloc_flags = SLAB_ALLOC_DEFAULT,
 	};
 
-	return __do_kmalloc_node(PASS_BUCKET_PARAM(b), flags, node,
-				 PASS_TOKEN_PARAM(token), &ac);
+	return __do_kmalloc_node(NULL, flags, node, PASS_TOKEN_PARAM(token), &ac);
 }
 EXPORT_SYMBOL(__kmalloc_node_track_caller_noprof);
 
@@ -7081,7 +7079,7 @@ __do_krealloc(const void *p, size_t new_size, unsigned long align, gfp_t flags,
 	return (void *)p;
 
 alloc_new:
-	ret = __kmalloc_node_track_caller_noprof(PASS_KMALLOC_PARAMS(new_size, NULL, token), flags, nid, _RET_IP_);
+	ret = __kmalloc_node_track_caller_noprof(PASS_TOKEN_PARAMS(new_size, token), flags, nid, _RET_IP_);
 	if (ret && p) {
 		/* Disable KASAN checks as the object's redzone is accessed. */
 		kasan_disable_current();
@@ -7166,7 +7164,7 @@ static void *__kvmalloc_fallback(size_t size, unsigned long align, gfp_t flags,
 			node, caller);
 }
 
-void *__kvmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), unsigned long align,
+void *__kvmalloc_node_noprof(DECL_TOKEN_PARAMS(size, token), unsigned long align,
 			     gfp_t flags, int node)
 {
 	void *ret;
@@ -7180,8 +7178,7 @@ void *__kvmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), unsigned long
 	 * It doesn't really make sense to fallback to vmalloc for sub page
 	 * requests
 	 */
-	ret = __do_kmalloc_node(PASS_BUCKET_PARAM(b),
-				kmalloc_gfp_adjust(flags, size),
+	ret = __do_kmalloc_node(NULL, kmalloc_gfp_adjust(flags, size),
 				node, PASS_TOKEN_PARAM(token), &ac);
 	if (ret || size <= PAGE_SIZE)
 		return ret;
@@ -7281,7 +7278,7 @@ void *kvrealloc_node_align_noprof(const void *p, DECL_TOKEN_PARAMS(size, token),
 	n = krealloc_node_align_noprof(p, PASS_TOKEN_PARAMS(size, token), align, kmalloc_gfp_adjust(flags, size), nid);
 	if (!n) {
 		/* We failed to krealloc(), fall back to kvmalloc(). */
-		n = __kvmalloc_node_noprof(PASS_KMALLOC_PARAMS(size, NULL, token), align, flags, nid);
+		n = __kvmalloc_node_noprof(PASS_TOKEN_PARAMS(size, token), align, flags, nid);
 		if (!n)
 			return NULL;
 

-- 
2.56.1


