Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DBF4CD8CA7
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:18:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9FAF6B00AC; Tue,  9 Jun 2026 05:18:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B50286B00AE; Tue,  9 Jun 2026 05:18:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A17F36B00AF; Tue,  9 Jun 2026 05:18:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 88E216B00AC
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:18:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 56A83A048E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:44 +0000 (UTC)
X-FDA: 84859824168.28.411A6E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id A0BA9180003
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O+lAReT+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780996722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EpyqwcPlF0qyNQnaXmyS4YqGBf1HLcYFrD5EYMZEjBc=;
	b=H+gFdt2SxEDqmxtnMSPW4iD5MddqdgJSx/FQ+UOKoJOxK+MZclCT9D7cd7mfOO4BxJzsA4
	zZRRJR/EIYiyKe4zp6ZEbxVqKacukBTXY536iD5U9E8J3J151yrFE1fyjUgIvuyPQdq79R
	c8pghq0RYbn00Qvyd5hlqO0PggGtyms=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O+lAReT+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780996722;
	b=VRU8wjnBS6Aqq4dRCEMrzpdcHNkhEi7MBGPTZ7eaGrqxD34TLQV7JTqCzMARVcnT/7qLao
	5+r4MrgXrU1vvvtRfCRPBaFhCQasEntvUV5i+Y5+vBshsjFoqQrYgUAnLgnNejSaFL26rA
	Mgp9aZGXjGGp6pyi7Gceht0ydDfBFjM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E8A54402E9;
	Tue,  9 Jun 2026 09:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F781F00898;
	Tue,  9 Jun 2026 09:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780996721;
	bh=EpyqwcPlF0qyNQnaXmyS4YqGBf1HLcYFrD5EYMZEjBc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=O+lAReT+de6tcsvpGObqmLv84nKfJpswHPzAsYVqWrSc1Rm5kscoCNYsBp3VqEiCj
	 Cr5rpl5kMEms+MH3xFCJL1bGnE1fKZjYD19QtwgDsBl8c6K0xoAG6k8MT3VGaI5jEP
	 bVfpGaWs6N3RVr+MvZKISWQ/KaPIhRJDvad4or6/t40uemY6/LuU3W2UWvFf5EHyn0
	 wYBOC0rZ1Qik7J+SbjLCAmY6lZdbqjUQlyVleLXVNV0ucwQj2vhsT5sUz22NYVWn3V
	 q+IJR5eeFHB61kJK67afYWzLr/XEzT9a8L2+h63lGCac32xze8X63Gn9HxsmoMlTWV
	 nRf6aXvzeJpeQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 09 Jun 2026 11:17:57 +0200
Subject: [PATCH RFC 12/15] mm/slab: introduce kmalloc_flags()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-slab_alloc_flags-v1-12-2bf4a4b9b526@kernel.org>
References: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
In-Reply-To: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A0BA9180003
X-Stat-Signature: ya6sgnp9n6phn3txws7b3e6trg7aptbu
X-Rspam-User: 
X-HE-Tag: 1780996722-507999
X-HE-Meta: U2FsdGVkX1/OXkuprjKss2WqMllHXH+ko9ewNeEBmwbgW7nnCzPsci4iVRNbi70aOzivdlubVH/NDM7dftS9oXCjOxEJpq4+6YW3wm2Qf2kI669Rr+KEJpBJ347SrNvOKTPSWs36RPZ/O9zuLL1ULQ4sGmfzSRluS3UqcSXRBfTnynDkwWBu1XA0p4Z243Ir3wgLmJ9cfj74QIkUtSogJ2dFxDLrOZAoE5feZstfDVOf2lSHf/h0bOQbx85Y5B2f69l7+l4cE0X0O5Nzq6JKYhKiWfs5VHK5rvfa15CWjAXanxJPefiEBDKBuXvViPjea7SUAAZJUpUJMXF8rtC6xlVAmicmcmBTr90Qxt6gH8TSbUllUOZRENlR9kyItP5A4NP7hZkKkDEbL3sfyg0RpOxzOeWUPQtPyddlA5HOwTBfUdDUZwr1ywd6wDm9gmm4sFOQwZyw/HAChSiaEucKyMJ8ffkjRhXDflIg3+q0fdwbE9tMqEvzxOChvwNRgGGN1EYr11peCri6JQOLj9uxoboMU/sLRyllyGYoNvUZ0oCtYBS8Ag5xDg93QlKbZjxZGDo9BiJEDW5ac1Ae67biqvZyFAqzp/Uls9yoX5gs8GPIuN9QsgVXHXOgfRJMjI9967vMrewh7DatbrF4YseB/0XOwR/6902SJQiU0VxyZt3dXigFLg2DgeDJ8HqnvILMEcrDjcL9IjHwNT92FzeOX2qQIp4jVfd7qBgU83i1tZK274UOJeVk0rqOBYeCTaKiz+yjiLJLrm50IOGhY2B7SIFcw9WDn6DFYugXqq4xi1zCaKe5tjqkTZJwVMVNWcGcJ2+ecU00Sh5Lp4PohS5XdFe01Swo2VHXIB1hWLWNKxvOObmEfPdJZNJsQqCUDJZXHjNW7DYMA+OXw3O7U3hsOUtmjeJhtEEw1Aisx8IxBz3feQPZKvSww5ufxeka7RgpyIUgxNakUNrbJSobDUi
 zxR8afKt
 Jst0/TpYjeMpggd4KeXyvlQgCoZ1nYymTwbBRthimxco65xfMMFlWokHugP2bLgMldxeL6C6i83LNNX+zQh5PDU+96WDTPCj5S3GJssIGYe7UUimXy4r/T16SKjDBJ3vDSK1QraONLp8Zw29LjcALobB3dqFqzp3TpzUKshJnGHikf0YSe5e/nCOsNdS/x9+Toz1GDJHiyoI0mnh0S4btHXVrR57cFitniQm5LRdOjByxnxjEdpJCuXkj6k93I1OfjlFEYe69dCaweBTbQgq1fH+VqxamajbE5kDy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With alloc_flags usage in slab, we can replace __GFP_NO_OBJ_EXT with an
alloc flag that prevents kmalloc recursion. For that we need a version
of kmalloc() that takes alloc_flags and use it in places that perform
these potentially recursive kmalloc allocations (of sheaves or obj_ext
arrays).

Add this function, named kmalloc_flags(). Right now it's only useful for
these nested allocations, so it doesn't need to optimize build-time
constant sizes like kmalloc() or kmalloc_buckets.

Since we need it to support both normal and non-spinning
kmalloc_nolock() context through the SLAB_ALLOC_TRYLOCK flag, split out
most of the special _kmalloc_nolock_noprof() implementation to
__kmalloc_nolock_noprof() that takes a slab_alloc_context, and make
_kmalloc_nolock_noprof() a simple tail calling wrapper with the proper
context.

kmalloc_flags() can thus determine whether to call
__kmalloc_nolock_noprof() or __do_kmalloc_node(), based on the
given alloc_flags.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 include/linux/slab.h | 12 +++++++++++
 mm/slub.c            | 56 ++++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 55 insertions(+), 13 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index ce1c867dc0ba..11e82fdbe8d3 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -944,6 +944,10 @@ void *__kmalloc_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags)
 void *__kmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags, int node)
 				__assume_kmalloc_alignment __alloc_size(1);
 
+void *__kmalloc_flags_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags,
+				  unsigned int alloc_flags, int node)
+				  __assume_kmalloc_alignment __alloc_size(1);
+
 void *__kmalloc_cache_noprof(struct kmem_cache *s, gfp_t flags, size_t size)
 				__assume_kmalloc_alignment __alloc_size(3);
 
@@ -1176,6 +1180,14 @@ static __always_inline __alloc_size(1) void *_kmalloc_node_noprof(size_t size, g
 #define kmalloc_node_noprof(...)		_kmalloc_node_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
 #define kmalloc_node(...)			alloc_hooks(kmalloc_node_noprof(__VA_ARGS__))
 
+static __always_inline __alloc_size(1) void *_kmalloc_flags_noprof(size_t size,
+		gfp_t flags, unsigned int alloc_flags, int node, kmalloc_token_t token)
+{
+	return __kmalloc_flags_noprof(PASS_TOKEN_PARAMS(size, token), flags, alloc_flags, node);
+}
+#define kmalloc_flags_noprof(...)		_kmalloc_flags_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
+#define kmalloc_flags(...)			alloc_hooks(kmalloc_flags_noprof(__VA_ARGS__))
+
 static inline __alloc_size(1, 2) void *_kmalloc_array_noprof(size_t n, size_t size, gfp_t flags, kmalloc_token_t token)
 {
 	size_t bytes;
diff --git a/mm/slub.c b/mm/slub.c
index c11edd58b52d..86691eb14002 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5370,15 +5370,15 @@ void *__kmalloc_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags)
 }
 EXPORT_SYMBOL(__kmalloc_noprof);
 
-void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, int node)
+static void *__kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags,
+				     int node, struct slab_alloc_context *ac)
 {
 	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
-	size_t orig_size = size;
-	unsigned int alloc_flags = SLAB_ALLOC_TRYLOCK;
 	struct kmem_cache *s;
 	bool can_retry = true;
 	void *ret;
 
+	VM_WARN_ON_ONCE(alloc_flags_allow_spinning(ac->alloc_flags));
 	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO |
 				      __GFP_NO_OBJ_EXT));
 
@@ -5413,23 +5413,17 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 		 */
 		return NULL;
 
-	ret = alloc_from_pcs(s, alloc_gfp, alloc_flags, node);
+	ret = alloc_from_pcs(s, alloc_gfp, ac->alloc_flags, node);
 	if (ret)
 		goto success;
 
-	struct slab_alloc_context ac = {
-		.caller_addr = _RET_IP_,
-		.orig_size = orig_size,
-		.alloc_flags = alloc_flags,
-	};
-
 	/*
 	 * Do not call slab_alloc_node(), since trylock mode isn't
 	 * compatible with slab_pre_alloc_hook/should_failslab and
 	 * kfence_alloc. Hence call __slab_alloc_node() (at most twice)
 	 * and slab_post_alloc_hook() directly.
 	 */
-	ret = __slab_alloc_node(s, alloc_gfp, node, &ac);
+	ret = __slab_alloc_node(s, alloc_gfp, node, ac);
 
 	/*
 	 * It's possible we failed due to trylock as we preempted someone with
@@ -5452,11 +5446,23 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 
 success:
 	maybe_wipe_obj_freeptr(s, ret);
-	slab_post_alloc_hook(s, alloc_gfp, 1, &ret, &ac);
+	slab_post_alloc_hook(s, alloc_gfp, 1, &ret, ac);
 
-	ret = kasan_kmalloc(s, ret, orig_size, alloc_gfp);
+	ret = kasan_kmalloc(s, ret, ac->orig_size, alloc_gfp);
 	return ret;
 }
+
+void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, int node)
+{
+	struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_TRYLOCK,
+	};
+
+	return __kmalloc_nolock_noprof(PASS_TOKEN_PARAMS(size, token),
+				       gfp_flags, node, &ac);
+}
 EXPORT_SYMBOL_GPL(_kmalloc_nolock_noprof);
 
 void *__kmalloc_node_track_caller_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags,
@@ -5510,6 +5516,30 @@ void *__kmalloc_cache_node_noprof(struct kmem_cache *s, gfp_t gfpflags,
 }
 EXPORT_SYMBOL(__kmalloc_cache_node_noprof);
 
+/*
+ * The only version of kmalloc_node() that takes alloc_flags and thus can
+ * determine on its own whether to handle the allocation via kmalloc_nolock() or
+ * normally
+ */
+void *__kmalloc_flags_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags,
+			     unsigned int alloc_flags, int node)
+{
+	struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = size,
+		.alloc_flags = alloc_flags,
+	};
+
+	if (alloc_flags_allow_spinning(alloc_flags)) {
+		return __do_kmalloc_node(size, NULL, flags, node,
+				PASS_TOKEN_PARAM(token), &ac);
+	} else {
+		return __kmalloc_nolock_noprof(PASS_TOKEN_PARAMS(size, token),
+					       flags, node, &ac);
+	}
+}
+
+
 static noinline void free_to_partial_list(
 	struct kmem_cache *s, struct slab *slab,
 	void *head, void *tail, int bulk_cnt,

-- 
2.54.0


