Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E95C2CD98C7
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:54:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A1DF6B0095; Mon, 15 Jun 2026 07:54:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 579636B0096; Mon, 15 Jun 2026 07:54:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B6F76B0098; Mon, 15 Jun 2026 07:54:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E25E6B0095
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:54:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 073CF16636B
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:54:59 +0000 (UTC)
X-FDA: 84881990718.18.9DC6E48
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 360704000A
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:54:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lL3BiGDs;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781524497;
	b=ZgrndHt7QD19p9yWg0fUBG182ZnDBNK6akrN/NUkKrfmbnzqc/CPxTMhnW/xqYGSWVijER
	BgDzZ/fIQE2K4WLl5ytYaOi234FnDc3RkFGHg5dUTq376drJuS8Bbe8VCKMgXJWNdrJ620
	jTXUpStX64UAMt11TBG/PoAdxhx0Rwc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lL3BiGDs;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781524497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wL8mWTTFXJV7/XAwYDfjQ2gnTlQEk8WhfruwwKYSNQQ=;
	b=7FpcUrzOA79njs59wudx/nVdLxyqQVe0SK5mnI0PA7WYkVx4c/96i+BlFcEmnVgYpN19CZ
	EOfIdkMyqHMfY54rUp0G/9q/7mVQvq0ciEpiArp/tTb+Cp1zlxQAzea/G/1REDKWmup/qQ
	UBvgxQcncOqxpyu7R1S+FBEe0RxZxPs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7703843AE8;
	Mon, 15 Jun 2026 11:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6C61F00A3D;
	Mon, 15 Jun 2026 11:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781524496;
	bh=wL8mWTTFXJV7/XAwYDfjQ2gnTlQEk8WhfruwwKYSNQQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lL3BiGDsVMfBPxK1goH7rMiSPcxRke7R9hk2NIlOjq4OE6I++6BqBHDFhmCCF+qAz
	 xpa9vhQoRwuxdIAFd/rqmL5I3JszqP6dYyqrFKCy9StuPM7KiNOOkcsAQCFRNDYtTP
	 e7A/rLuOXjJWBNmuPFqvglFRtuyB7eBFEWugWkbT+c6b/+kKjJK6g5ylQQMbj6LTcr
	 V7+6HnPorUDvakFZKPKgJjhuDdR7SB0Btt53IFMMphI+JXzvhoiZJyYvvIXYqtzkTU
	 L+KYkvcUlUEAem1BfzqNqFWWA8TmWkmhxxEOH1Yk9/2lv7INECV1rLuoi43U3vILr7
	 w4RrPLg49tKiA==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 15 Jun 2026 13:54:36 +0200
Subject: [PATCH v3 03/15] mm/slab: introduce slab_alloc_context
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-slab_alloc_flags-v3-3-ce1146d140fb@kernel.org>
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
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
X-Rspamd-Queue-Id: 360704000A
X-Stat-Signature: emia4mkspytuk8gobujxhbbaqtk3xn17
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781524497-929462
X-HE-Meta: U2FsdGVkX1/RxBx7BaBlH6tJFp35xSn5nKlxUhFhcSK3A8ebxfDZPYC+zh6gQvM8eAgSB8OmjSPwUgK+2cVaUqsj7AcI5ZaOQXKqdkLMdMcOGuoT5+9SivJIgYqvQs1DM3W1QbMmnGaTjlxBGmf8NlYpLRq4kiNdbgQv5ebflVwrhR2qgRZ0QVZ/t8yniqHK8d4SsUycY+uJHhAY6F2z3Gs7Z5l410auX1OxnY0BYQZrUmiWbOKr9P8SOahHGIap+Sw6uSI80Jz+LhL9vo9mDLaRZ5914pVs6Hjt40+SXmykMxg9RZAsFp3HieDUj9Yeu2e4+42deX1I7S+tFDBSdfcbg9fC1eeKY9V0xqjH0WQmaWSh3beaC9pNDe3zdQehIzR3O77vzt33JcmkX8LXfA1e7L8e2M8i4AEO6GsQ0GuBufoNUozghZ4bJASlmcmVLoQzzAkK+/FjLtv6ZOxpFkQ6hRs+wGhFTLq3v//AfEN5Pro1NftWvmK71bS3DhMpUVpa/pFsKCYhbLYWnIpk4g/MAwIQ+FrDtBWgZ6h6WoM/3ZnZ3McrDEL/n/10T2m+yDZ+uyNCh/aIn7EFPemWoCXfkr4HVa6ewqfil55D+hMOjiLXzEcM6Gk4kwRjyyXc6LO/5LiBgxJ289RzjuwdW7f07txSt00muWp5isQx12M2BUaJVUKMLy0+VZXszDbM7vVTLHFT/80MhyYwK0ZJTRAhZ6HkyLyK0HpVSdMmbCaW3MtWItlDnbHw/bqhMKtRvXvRvVlPbdwzmxU77wldnogkOnOEXeFlFcebs9boEq/mZmfBnN0ALdZ40aau9VRNGQVTSCQkJ32sIRQ65D+IW0ZNGyM7++QOv+7SF+pTZmpSh/K0NBTL+0nPBX4E38eOyPnO3kmpd3w7aeIeb1IrV+MjI7P+/SnYHIssRFC4jreICize0tjhvAAoXPZMwMsdqZv4xUZ0TWZiePaHC1b
 muz7AyK4
 RIjORJJhLJX39qyqMrmxlYQCPr+TGSQzcM6b7RKXSZMX4YTsrnWWN4EC3JLFNIP9idnttEdUG+k5tgFFe6NSp3Vaav3GPQjAM6/YOMAsPdUE/JIh8+noAOO9Av2MZItP/ODccivoyHfevMpp0LAG7yhGDX3jOedWCzgciR5ogJN3doD0FqHyT0+bYD0NWoZJwptQ9ocQQQ5reXn80XCU4VdZRP6tn4X8IcMPmrfL9cjfHz+8RM2cAqCnJQ5ChBxYMwJjpPZrKUVBaCLf/xHPgt7RU6sQpNJpshyWmkvhdWdRSCEuWn7LvqdkoYXnmd4yGkftdbwpfSc9kwQU5/lHTTgN7QvLZZK3Oju+KE7hmT2rS8vdghqsJd2KIuAKzH/K5iQiOXPmZEe4B1cESJG9fwNODhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Similarly to page allocator's struct alloc_context, introduce a helper
struct to hold a part of the allocation arguments. This will allow
reducing the number of parameters in many functions of the
implementation, and extend them easily if needed.

For now, make it hold the caller address and the originally requested
allocation size.

Convert alloc_single_from_new_slab(), __slab_alloc_node() and
___slab_alloc(). No functional change intended.

Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-4-7190909db118@kernel.org
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 45 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 13 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 8845e15cb152..8a0c5553876e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -213,6 +213,12 @@ DEFINE_STATIC_KEY_FALSE(slub_debug_enabled);
 static DEFINE_STATIC_KEY_FALSE(strict_numa);
 #endif
 
+/* Structure holding extra parameters for slab allocations */
+struct slab_alloc_context {
+	unsigned long caller_addr;
+	size_t orig_size;
+};
+
 /* Structure holding parameters for get_from_partial() call chain */
 struct partial_context {
 	gfp_t flags;
@@ -3687,7 +3693,8 @@ static inline void init_slab_obj_iter(struct kmem_cache *s, struct slab *slab,
  * and put the slab to the partial (or full) list.
  */
 static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
-					int orig_size, bool allow_spin)
+					const struct slab_alloc_context *ac,
+					bool allow_spin)
 {
 	struct kmem_cache_node *n;
 	struct slab_obj_iter iter;
@@ -3705,7 +3712,7 @@ static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
 	/* alloc_debug_processing() always expects a valid freepointer */
 	set_freepointer(s, object, slab->freelist);
 
-	if (!alloc_debug_processing(s, slab, object, orig_size)) {
+	if (!alloc_debug_processing(s, slab, object, ac->orig_size)) {
 		/*
 		 * It's not really expected that this would fail on a
 		 * freshly allocated slab, but a concurrent memory
@@ -4443,7 +4450,7 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
  * slab.
  */
 static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
-			   unsigned long addr, unsigned int orig_size)
+			   const struct slab_alloc_context *ac)
 {
 	bool allow_spin = gfpflags_allow_spinning(gfpflags);
 	void *object;
@@ -4476,7 +4483,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 			pc.flags = GFP_NOWAIT | __GFP_THISNODE;
 	}
 
-	pc.orig_size = orig_size;
+	pc.orig_size = ac->orig_size;
 	object = get_from_partial(s, node, &pc);
 	if (object)
 		goto success;
@@ -4496,7 +4503,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	stat(s, ALLOC_SLAB);
 
 	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
-		object = alloc_single_from_new_slab(s, slab, orig_size, allow_spin);
+		object = alloc_single_from_new_slab(s, slab, ac, allow_spin);
 
 		if (likely(object))
 			goto success;
@@ -4514,13 +4521,13 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 
 success:
 	if (kmem_cache_debug_flags(s, SLAB_STORE_USER))
-		set_track(s, object, TRACK_ALLOC, addr, gfpflags);
+		set_track(s, object, TRACK_ALLOC, ac->caller_addr, gfpflags);
 
 	return object;
 }
 
 static void *__slab_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node,
-			       unsigned long addr, size_t orig_size)
+			       const struct slab_alloc_context *ac)
 {
 	void *object;
 
@@ -4545,7 +4552,7 @@ static void *__slab_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node,
 	}
 #endif
 
-	object = ___slab_alloc(s, gfpflags, node, addr, orig_size);
+	object = ___slab_alloc(s, gfpflags, node, ac);
 
 	return object;
 }
@@ -4926,8 +4933,13 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 
 	object = alloc_from_pcs(s, gfpflags, node);
 
-	if (unlikely(!object))
-		object = __slab_alloc_node(s, gfpflags, node, addr, orig_size);
+	if (unlikely(!object)) {
+		const struct slab_alloc_context ac = {
+			.caller_addr = addr,
+			.orig_size = orig_size,
+		};
+		object = __slab_alloc_node(s, gfpflags, node, &ac);
+	}
 
 	maybe_wipe_obj_freeptr(s, object);
 
@@ -5353,6 +5365,10 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 	struct kmem_cache *s;
 	bool can_retry = true;
 	void *ret;
+	const struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = orig_size,
+	};
 
 	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO |
 				      __GFP_NO_OBJ_EXT));
@@ -5398,7 +5414,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 	 * kfence_alloc. Hence call __slab_alloc_node() (at most twice)
 	 * and slab_post_alloc_hook() directly.
 	 */
-	ret = __slab_alloc_node(s, alloc_gfp, node, _RET_IP_, orig_size);
+	ret = __slab_alloc_node(s, alloc_gfp, node, &ac);
 
 	/*
 	 * It's possible we failed due to trylock as we preempted someone with
@@ -7240,10 +7256,13 @@ static bool __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
 	int i;
 
 	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
+		const struct slab_alloc_context ac = {
+			.caller_addr = _RET_IP_,
+			.orig_size = s->object_size,
+		};
 		for (i = 0; i < size; i++) {
 
-			p[i] = ___slab_alloc(s, flags, NUMA_NO_NODE, _RET_IP_,
-					     s->object_size);
+			p[i] = ___slab_alloc(s, flags, NUMA_NO_NODE, &ac);
 			if (unlikely(!p[i]))
 				goto error;
 

-- 
2.54.0


