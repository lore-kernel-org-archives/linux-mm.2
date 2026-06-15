Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E05DCD98C7
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:54:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 701976B008C; Mon, 15 Jun 2026 07:54:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D91B6B0092; Mon, 15 Jun 2026 07:54:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EFCD6B0093; Mon, 15 Jun 2026 07:54:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 502D16B008C
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:54:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EAC4E40680
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:54:50 +0000 (UTC)
X-FDA: 84881990340.09.B3EE853
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 49A4220003
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:54:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bp5/gS/H";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781524489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rF2KPZAYSMCMaUkCSzteXR62HLRjNqxtc4Qy0wCy7Js=;
	b=pUiPk6V/VuwSQCkBH0knGRcyoKYqIVoZav4BKBoJd67pQTn22Qg81LudbvSF8g4r+OGvI5
	mVtDSruuCIGG3RdS5mufXRZ0kJ4Z7p1g+yusWDKwBcI6+Kwmx6adHaM12lnfHE8g6LOsAr
	79cywoW88DXmhOTKlvvtVjGXMx5FqX0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bp5/gS/H";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781524489;
	b=FHxPS6V6ERSZgcb5fKJCRu89tUJcJbyAqVr6vITlVAfZzVV9Ll7jwtuDFatX0FB/05AHop
	9xqCq8Z8jYvvg+5gI3Zo/2J+kZrAEU+9XYOvOluBrOB/tmCM/TXLeJko2GqM8oTgDx3J+/
	IQQzrKGgXxEfqfoK+mVvFWTMcBrzmGw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D12E5601E3;
	Mon, 15 Jun 2026 11:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17AE81F00A3A;
	Mon, 15 Jun 2026 11:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781524488;
	bh=rF2KPZAYSMCMaUkCSzteXR62HLRjNqxtc4Qy0wCy7Js=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bp5/gS/HxOvXkSZolqVvBQRPO8CCBYdQJbc/EZElnbJ3F28bzRNKDPgmIhhfbSmRu
	 o+9Onv1HMEu06W0+m6MCMTQZBBI+SaEh3iANuy/vFrnvssf3MKdcG/MUiJPTHZqa/x
	 7oC9SRWnH6dpeo/Z/uk46HhpFjn15z4jjKa7183MOdZJ23gYOwFwhnZNRWqS352ipo
	 jTwoDjo4mcSkCyCmswClw+iSgAMLQ+CaVolDq0mGguugmUCf4Nqymt2aDql5RzhQb7
	 ccPU/qj4mp81af1x85AZYfQRKaATFJ4xv8RTS2cLSZYRG+jsAlor370NVdoq5gQbeC
	 VUY9hZSFgmj+A==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 15 Jun 2026 13:54:34 +0200
Subject: [PATCH v3 01/15] mm/slab: do not init any kfence objects on
 allocation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-slab_alloc_flags-v3-1-ce1146d140fb@kernel.org>
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
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: f4ryhfnrisz7so4f69fghnano63tt5z6
X-Rspamd-Queue-Id: 49A4220003
X-HE-Tag: 1781524489-974816
X-HE-Meta: U2FsdGVkX1/pZEIiJj1PAFS0oZThRIJAlYRuSZ+8RVc9ZJ6yCOj9xMUYsq8jP6Z49SajGnVV1d0ws1zYxVSPoqWqFX56ZTpBJ/IL0U0B+JzoM1R8rYir3a64YBwGKxFJunPX7gKO3UDi15UU0TxkYUlP9KXUey8dLtXaxp8PP7qepBeu2Cil2o7JCjXr0jlXW2QTdUvaBWxTjHfdagRobQscC/BGcxukr/0fyNLlKmZURChOrxVxJfrnmxQ0WqMIGXiVC4+0blN0gjP3fWbwKQCSdbfrCUXmS5MZKB2Ev+0+lYC1T4nrhgyjF0JXPw4MMc6X1JspGLZuGsTZT7+pBQBfaZ7ai8oQxKim3HjsRx7xQc8PwQTCqObp67U4q3ZMWNtxq7/iSdsXeupVMzAD8rYxb3IQ+wENTxPCofuXzmuOzIJ2XgELE+13F0CiDTAC216DTd9qSGsFKb1H8zeojDF6Yj0358ZHE29PipxyAe+ayokowIfKZfyPQWXRgnPQZRdZRukWwrOKUe7BIuRwx+EQ90STXCs8d7xi+cdil5pHdhTM6jhinJ6yxP5GmoHwlpt7pEycAMTTIbnuX5+JehRE7uek5LH7eTuI/Jc4TyW0TOHgcCrdM3UHmwh+9p4F0OZXFEKfNE5ONaZYKIo2Qw1wkaXR4Y2hcdjtae3NWEZugpVg5U/npTwIsy/M63wqFzDEvUGi8MLHDgrXxMgBedOb56gEndzTTN3bI99AkvVq83lgPzCfdrS2arYlDAHVb8VboYo3ARkxtjF/CXBZPvHsz9X3QXq1RTgDkbWCWwNueHU1yZZHzugQr+c5p0ieMpvJ8781VsQ/LMveQzHJona3uFw5Gp4/5+WrJXSdDsGtxKJrac3Zk3C/KY3JORMyA1PdFUMI5N/6EC5f9wRyIIiNBxWMprqCgw6P4NDLqM+5Iql7hGexfnVyj8gWpG9DAuz+QOHTnsaDJsnj7ll
 jsKHGbpu
 UHqDoZhKhXhsDmRNORaUBfvcypkr3kRNDeksVPsa5QyQvbiED7l5ySiA44C9SAC3woNVOROwNPznKAPhgPw0+uZ5RbvhTx3ZBHL5HthCqbwv1tZ4ZWGFRySUdJfDwAkUhSGEkEgqgXvPvLNdpznDJ65C+tY5KkG/BG7TQbF3Dasf39qe3D+1bYAiSSLBtMzGV6DnyUitIdR6ro3ohXgPLDZMxa1U0EJYxZR7QBZp5xhJAvc63oMUY2HPs4X9OSHaH7qPeOv5cZzBh+9/eOpyVKR3H5+8FvvNeBHARhhwipZ26kLgbOnYbk//3o0E37RjNMLr3Fw52mD/I+I5iw5hn+AAbE+SkpzZ5au27
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When init (zeroing) on allocation is requested, for kmalloc() we
generally have to zero the full object size even if a smaller size is
requested, in order to provide krealloc()'s __GFP_ZERO guarantees.

When we end up allocating a kfence object, kfence performs the zeroing
on its own because it has its own redzone beyond the requested size.
Thus slab_post_alloc_hook() has an 'init' parameter which has to be
evaluated in all callers (via slab_want_init_on_alloc()) and should be
false for kfence allocations.

For kfence allocations in slab_alloc_node() this is achieved by subtly
skipping over the slab_want_init_on_alloc() call. Other callers (i.e.
kmem_cache_alloc_bulk_noprof()) however evaluate it unconditionally even
if they do end up with a kfence allocation. This is only subtly not a
problem, as those are not kmalloc allocations and thus the "requested
size" equals s->object_size and thus it cannot interfere with kfence's
redzone. There's just a unnecessary double zeroing (in both kfence and
slab_post_alloc_hook()), but it's all very fragile and contradicts the
comment in kfence_guarded_alloc().

Remove this subtlety and simplify the code by eliminating the init
parameter from slab_post_alloc_hook() and make it call
slab_want_init_on_alloc() itself. Instead add a is_kfence_address()
check before performing the memset, which will start doing the right
thing for all callers of slab_post_alloc_hook().

This potentially adds overhead of the is_kfence_address() check to
allocation hotpath, but that one is designed to be as small as possible,
and it's only evaluated if zeroing is about to happen. This means (aside
from init_on_alloc hardening) only for __GFP_ZERO allocations, and the
zeroing itself comes with an overhead likely larger than the added
check.

While at it, refactor the handling of evaluating when KASAN does the
init instead of SLUB, with no intended functional changes. A
non-functional change is that we don't pass kasan_init as true to
kasan_slab_alloc() if kasan has no integrated init, but then the value
is ignored anyway, so it's theoretically more correct.

Thanks to Harry Yoo for the initial refactoring attempt, and for updated
comments that are used here.

Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-2-7190909db118@kernel.org
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/kfence/core.c |  2 +-
 mm/slub.c        | 60 ++++++++++++++++++++++++++------------------------------
 2 files changed, 29 insertions(+), 33 deletions(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 655dc5ce3240..5e0b406924e9 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -500,7 +500,7 @@ static void *kfence_guarded_alloc(struct kmem_cache *cache, size_t size, gfp_t g
 
 	/*
 	 * We check slab_want_init_on_alloc() ourselves, rather than letting
-	 * SL*B do the initialization, as otherwise we might overwrite KFENCE's
+	 * slab do the initialization, as otherwise it might overwrite KFENCE's
 	 * redzone.
 	 */
 	if (unlikely(slab_want_init_on_alloc(gfp, cache)))
diff --git a/mm/slub.c b/mm/slub.c
index e2ee8f1aaccf..d762cbe5d040 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4565,13 +4565,13 @@ struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
 
 static __fastpath_inline
 bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
-			  gfp_t flags, size_t size, void **p, bool init,
+			  gfp_t flags, size_t size, void **p,
 			  unsigned int orig_size)
 {
+	bool init = slab_want_init_on_alloc(flags, s);
 	unsigned int zero_size = s->object_size;
-	bool kasan_init = init;
-	size_t i;
 	gfp_t init_flags = flags & gfp_allowed_mask;
+	bool kasan_init = false;
 
 	/*
 	 * For kmalloc object, the allocated size (object_size) can be larger
@@ -4588,28 +4588,33 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 		zero_size = orig_size;
 
 	/*
-	 * When slab_debug is enabled, avoid memory initialization integrated
-	 * into KASAN and instead zero out the memory via the memset below with
-	 * the proper size. Otherwise, KASAN might overwrite SLUB redzones and
-	 * cause false-positive reports. This does not lead to a performance
+	 * ARM64 can set memory tags and zero the memory using a single
+	 * instruction. Since HW_TAGS KASAN uses that while tagging the object,
+	 * separate zeroing is unnecessary.
+	 *
+	 * However, KASAN never zeroes memory when slab_debug is enabled to
+	 * avoid overwriting SLUB redzones. This does not lead to a performance
 	 * penalty on production builds, as slab_debug is not intended to be
 	 * enabled there.
 	 */
-	if (__slub_debug_enabled())
-		kasan_init = false;
+	if (kasan_has_integrated_init() && !__slub_debug_enabled()) {
+		kasan_init = init;
+		init = false;
+	}
 
-	/*
-	 * As memory initialization might be integrated into KASAN,
-	 * kasan_slab_alloc and initialization memset must be
-	 * kept together to avoid discrepancies in behavior.
-	 *
-	 * As p[i] might get tagged, memset and kmemleak hook come after KASAN.
-	 */
-	for (i = 0; i < size; i++) {
+	for (size_t i = 0; i < size; i++) {
 		p[i] = kasan_slab_alloc(s, p[i], init_flags, kasan_init);
-		if (p[i] && init && (!kasan_init ||
-				     !kasan_has_integrated_init()))
+
+		/*
+		 * memset and hooks come after KASAN as p[i] might get tagged
+		 *
+		 * kfence zeroes the object instead of SLUB to avoid overwriting
+		 * its own redzone starting at orig_size, which could happen
+		 * with SLUB zeroing full s->object_size
+		 */
+		if (init && p[i] && !is_kfence_address(p[i]))
 			memset(p[i], 0, zero_size);
+
 		if (gfpflags_allow_spinning(flags))
 			kmemleak_alloc_recursive(p[i], s->object_size, 1,
 						 s->flags, init_flags);
@@ -4910,7 +4915,6 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 		gfp_t gfpflags, int node, unsigned long addr, size_t orig_size)
 {
 	void *object;
-	bool init = false;
 
 	s = slab_pre_alloc_hook(s, gfpflags);
 	if (unlikely(!s))
@@ -4926,16 +4930,13 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 		object = __slab_alloc_node(s, gfpflags, node, addr, orig_size);
 
 	maybe_wipe_obj_freeptr(s, object);
-	init = slab_want_init_on_alloc(gfpflags, s);
 
 out:
 	/*
-	 * When init equals 'true', like for kzalloc() family, only
-	 * @orig_size bytes might be zeroed instead of s->object_size
 	 * In case this fails due to memcg_slab_post_alloc_hook(),
 	 * object is set to NULL
 	 */
-	slab_post_alloc_hook(s, lru, gfpflags, 1, &object, init, orig_size);
+	slab_post_alloc_hook(s, lru, gfpflags, 1, &object, orig_size);
 
 	return object;
 }
@@ -5230,7 +5231,6 @@ kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
 				   struct slab_sheaf *sheaf)
 {
 	void *ret = NULL;
-	bool init;
 
 	if (sheaf->size == 0)
 		goto out;
@@ -5240,10 +5240,8 @@ kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
 	if (likely(!ret))
 		ret = sheaf->objects[--sheaf->size];
 
-	init = slab_want_init_on_alloc(gfp, s);
-
 	/* add __GFP_NOFAIL to force successful memcg charging */
-	slab_post_alloc_hook(s, NULL, gfp | __GFP_NOFAIL, 1, &ret, init, s->object_size);
+	slab_post_alloc_hook(s, NULL, gfp | __GFP_NOFAIL, 1, &ret, s->object_size);
 out:
 	trace_kmem_cache_alloc(_RET_IP_, ret, s, gfp, NUMA_NO_NODE);
 
@@ -5423,8 +5421,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 
 success:
 	maybe_wipe_obj_freeptr(s, ret);
-	slab_post_alloc_hook(s, NULL, alloc_gfp, 1, &ret,
-			     slab_want_init_on_alloc(alloc_gfp, s), orig_size);
+	slab_post_alloc_hook(s, NULL, alloc_gfp, 1, &ret, orig_size);
 
 	ret = kasan_kmalloc(s, ret, orig_size, alloc_gfp);
 	return ret;
@@ -7339,8 +7336,7 @@ bool kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags,
 
 out:
 	/* memcg and kmem_cache debug support and memory initialization */
-	return likely(slab_post_alloc_hook(s, NULL, flags, size, p,
-			slab_want_init_on_alloc(flags, s), s->object_size));
+	return likely(slab_post_alloc_hook(s, NULL, flags, size, p, s->object_size));
 }
 EXPORT_SYMBOL(kmem_cache_alloc_bulk_noprof);
 

-- 
2.54.0


