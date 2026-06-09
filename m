Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67E14CD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:18:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3BB86B008A; Tue,  9 Jun 2026 05:18:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C12AE6B008C; Tue,  9 Jun 2026 05:18:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B295D6B0092; Tue,  9 Jun 2026 05:18:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9941E6B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:18:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 36B7940476
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:01 +0000 (UTC)
X-FDA: 84859822362.16.B62A8B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 79850A0002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:17:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Img4nAe/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780996679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hqVWkFIfMg3YzVLrDjibkNrMS+xjyWA2/yvCzTNv4UI=;
	b=XVINNACx8yl/Uw4tdPymkcwgk6F0VfihrlW0ePI9uJRFbiPZxBR+1iJgfPmSqwM1YZEg3U
	qbcrZmOhBUJwYjvO/UUOlmQDQJiqnM2kuHQjy9TISpBYRYfzrqxJtXk6GKJDcWbIKWRe3O
	ZQEkVCcaGRX9ouyatoIGhDkAoDSbxg4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Img4nAe/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780996679;
	b=bfiXYfRqbW86MmeQmVK08XKh0fKfsIKgJWFAKMSVwx8RoL3cpDWWmc+ReQ9K1rFffC+kik
	p8amSXX8U9HRKO3WSo9c8xRjZ4M9mY5q+l+cpJwtODWUYuvFFH2MGkqOozQmK7Lt/UFnnK
	oAFyq+2l356AcsT9u57OYPclShrKvHk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BD41543271;
	Tue,  9 Jun 2026 09:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EECB1F00898;
	Tue,  9 Jun 2026 09:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780996678;
	bh=hqVWkFIfMg3YzVLrDjibkNrMS+xjyWA2/yvCzTNv4UI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Img4nAe/5V8E6cxtW6XUME70KqHhQt4eQitIoMBnbvRO8EolKfGQy4ph6150/1q4I
	 r+QkZbx82GWXn3BT1OkLWXVRjPMq8xdU2SAnWgFnzT5FKa++00H0sFhZqsQ8KsqGL5
	 5i6sxzxG+JNS5HfFGuY8qhtIuOd+gVHbAL0WxV29K/rERjA50i6Noa0vcv/7LTzLxL
	 RPESWW2K1sM2Bf06nYBlc5O/yujnys6yOPlsKbXZRm+V3mpduFQvVzbh4YrxZQ9UQK
	 b2D2jqtGSm/bgjGw9uxvDMaLaHXHM+G6Q4mO1OFhqS71V9gJsROwxg0iXZRQLW9JqN
	 qL9XXPr8aYukA==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 09 Jun 2026 11:17:46 +0200
Subject: [PATCH RFC 01/15] mm/slab: always zero only requested size on
 alloc
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-slab_alloc_flags-v1-1-2bf4a4b9b526@kernel.org>
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
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: jm3n4idnkthyrzpp78de63inh8yu5xre
X-Rspamd-Queue-Id: 79850A0002
X-HE-Tag: 1780996679-558627
X-HE-Meta: U2FsdGVkX19cnc6L6U7fFoIhzGd6UR8TtiyU7d5dR3C8oYD5n4967bEUzKDHdR7tDvoA2MQxz5AbvZVxSfA4qXyfZV+DLsWA9R2qFqm4excTRczyXB0DInFY+DLF/qSl9zcIUAz3DPMbZ2oAD/SAherGa7gtFfk/XxFzAc6UheN0G6y8Cwk1NpSqiSIU/3NhRu7h3jojRKXJ/OzPQEt+iN+G05YZcEoxzoI0+eilhGUragDxXqYU86KEQwXNCuzuMOGF/ZtlWA7kN0hKtz0H5JgypVHZiQYlbTWvhgmY0K9B6248G1MGmYry8kxceIBNAse+RS1GCf3jyN6l8EWh97nEMIMkLb8eKcznDsiMshoTRGvvGXe4k5Y8YT3HjwV9Kffx3a0lU/07m+buwiSUXZd1YHy0fob1ie2J7klWSuGflHxAv54BC7S7XwgqGeAp1RsCB2q4bbjRG5q2zwc0Rl4nEt7NekTgNPCiWyfcKTzByHKohi3HWJBn+mvS2vtqLcHOKIhPMDyrgnuSfiOlemnJW2+gxd8/IpTNPdIpBObGyC1RqI4sfK3qA5nVfNpvsbP/9/9nGLMBXx0tnK/zA2ajwQq0iL3kgk7W9q4Mo5fj8J7jiyS312nf7yhce9om4+MtENFP+MgiP+D/hLhpUd7CaFjW8r4mycocS4/ybcBx8eKwVk70ytwLiAnh8fDoQo2b0hAU36bia8+gs1G8uOGGMkuTPXL2T07H4+cY1ROTKcUG/Cae1UZFrpuQfzKk7W3uBlg8xk6uSfH6dPo+zda7ncXQa2yWfBHDF5YmIiVFBT0MyUxfR+FStPQi2rbDZ4p0sKBd1dFh6vBqCIb4j2yWze0G8Hlxd8RBjFqrfT62+PlkrJuImuHBK+TC56Qj8silsjmuv5Li8Oj6sjjWUaelEO66ETzNhg7hIpPs8whTuEyNdEyUKsQD7pddxegOvvyKJ3bCCiLPS1H4otm
 MbWlz8J3
 kNQw14uVXyGb33X71RXluKOMegaftnFdGHOPh9h8x4DYpXjfNojFHJX7wHHudyslq2qAatrqlJB3Hx5d2l64W+ErDBDwt7bQ8y25eOucpQrJ+0LcOFYuefPCQ9SLQ+7/sw+yuYkZjZ57AyqIcm/c+PSsNLi1/+ld1CMTb4dtuql7uX7qc0t+zbiRKrrTEtPRqNojjfVT182pCTbc3+rWGF8PnamDpxItsRoOZJ3KX7WyOEtUe+hPEiDy5+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When zeroing on alloc is requested (by __GFP_ZERO or the init_on_alloc
parameter), we have been trying to zero the whole kmalloc bucket size
and not just requested size, if possible.

This probably comes from the past where ksize() could be used to
discover the bucket size and use it opportunistically beyond the
requested size. This is now forbidden and enabling debugging such as
KASAN or slab's red zoning would catch this misuse. Therefore, nobody
can be relying on __GFP_ZERO zeroing beyond requested size.

Theoretically it might still improve hardening in case of unintended
accesses beond requested size accessing some sensitive data from a
previous allocation. But then, init_on_free is probably used also for
hardening and would have cleared that.

So the usefullness of zeroing beyond requested size is practically none
nowadays. The disadvantages for doing it are:

- Interaction with KFENCE, which perfoms the zeroing on its own because
  it has its own redzone beyond requested size. As a consequence
  slab_post_alloc_hook() has an 'init' parameter which has to be
  evaluated in all callers (via slab_want_init_on_alloc()).

  For kfence allocations in slab_alloc_node() this evaluation is subtly
  skipped over in order to do the right thing. Other callers (i.e.
  kmem_cache_alloc_bulk_noprof()) evaluate it unconditionally even if
  they do end up with a kfence allocation. This is only subtly not a
  problem, as those are not kmalloc allocations and are using
  s->object_size as requested size, so it doesn't interfere with kfence's
  redzone. There's just a unnecessary double zeroing (in both kfence and
  slab_post_alloc_hook()), but it's all very fragile and contradicts the
  comment in kfence_guarded_alloc().

- Interaction with slab's redzoning where we have to limit the zeroing
  to requested size.

We can make the code much more simple by always zeroing only up to the
requested size. Move slab_want_init_on_alloc() call to
slab_post_alloc_hook(), removing the parameter. Remove the red zone
handling.

For kfence's zeroing code, update the comment. We could remove it
completely, but due to possible interactions with KASAN, there are
configurations where neither slab or KASAN would zero the object,
so simply do it in kfence. At worst the zeroing will happen twice, but
kfence allocations are rare by design so the cost is negligible.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/kfence/core.c |  6 +++---
 mm/slub.c        | 35 +++++++----------------------------
 2 files changed, 10 insertions(+), 31 deletions(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 655dc5ce3240..c765ba0a3a67 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -499,9 +499,9 @@ static void *kfence_guarded_alloc(struct kmem_cache *cache, size_t size, gfp_t g
 	set_canary(meta);
 
 	/*
-	 * We check slab_want_init_on_alloc() ourselves, rather than letting
-	 * SL*B do the initialization, as otherwise we might overwrite KFENCE's
-	 * redzone.
+	 * SLUB will generally init kfence objects, but due to possible
+	 * interactions with KASAN, it might not happen, so do it ourselves.
+	 * In the worst case the init just happens twice.
 	 */
 	if (unlikely(slab_want_init_on_alloc(gfp, cache)))
 		memzero_explicit(addr, size);
diff --git a/mm/slub.c b/mm/slub.c
index 63c1ef998dd3..f787dc422d1b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4565,26 +4565,14 @@ struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
 
 static __fastpath_inline
 bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
-			  gfp_t flags, size_t size, void **p, bool init,
+			  gfp_t flags, size_t size, void **p,
 			  unsigned int orig_size)
 {
-	unsigned int zero_size = s->object_size;
+	bool init = slab_want_init_on_alloc(flags, s);
 	bool kasan_init = init;
 	size_t i;
 	gfp_t init_flags = flags & gfp_allowed_mask;
 
-	/*
-	 * For kmalloc object, the allocated memory size(object_size) is likely
-	 * larger than the requested size(orig_size). If redzone check is
-	 * enabled for the extra space, don't zero it, as it will be redzoned
-	 * soon. The redzone operation for this extra space could be seen as a
-	 * replacement of current poisoning under certain debug option, and
-	 * won't break other sanity checks.
-	 */
-	if (kmem_cache_debug_flags(s, SLAB_STORE_USER | SLAB_RED_ZONE) &&
-	    (s->flags & SLAB_KMALLOC))
-		zero_size = orig_size;
-
 	/*
 	 * When slab_debug is enabled, avoid memory initialization integrated
 	 * into KASAN and instead zero out the memory via the memset below with
@@ -4607,7 +4595,7 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 		p[i] = kasan_slab_alloc(s, p[i], init_flags, kasan_init);
 		if (p[i] && init && (!kasan_init ||
 				     !kasan_has_integrated_init()))
-			memset(p[i], 0, zero_size);
+			memset(p[i], 0, orig_size);
 		if (gfpflags_allow_spinning(flags))
 			kmemleak_alloc_recursive(p[i], s->object_size, 1,
 						 s->flags, init_flags);
@@ -4908,7 +4896,6 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 		gfp_t gfpflags, int node, unsigned long addr, size_t orig_size)
 {
 	void *object;
-	bool init = false;
 
 	s = slab_pre_alloc_hook(s, gfpflags);
 	if (unlikely(!s))
@@ -4924,16 +4911,13 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
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
@@ -5228,7 +5212,6 @@ kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
 				   struct slab_sheaf *sheaf)
 {
 	void *ret = NULL;
-	bool init;
 
 	if (sheaf->size == 0)
 		goto out;
@@ -5238,10 +5221,8 @@ kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
 	if (likely(!ret))
 		ret = sheaf->objects[--sheaf->size];
 
-	init = slab_want_init_on_alloc(gfp, s);
-
 	/* add __GFP_NOFAIL to force successful memcg charging */
-	slab_post_alloc_hook(s, NULL, gfp | __GFP_NOFAIL, 1, &ret, init, s->object_size);
+	slab_post_alloc_hook(s, NULL, gfp | __GFP_NOFAIL, 1, &ret, s->object_size);
 out:
 	trace_kmem_cache_alloc(_RET_IP_, ret, s, gfp, NUMA_NO_NODE);
 
@@ -5421,8 +5402,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 
 success:
 	maybe_wipe_obj_freeptr(s, ret);
-	slab_post_alloc_hook(s, NULL, alloc_gfp, 1, &ret,
-			     slab_want_init_on_alloc(alloc_gfp, s), orig_size);
+	slab_post_alloc_hook(s, NULL, alloc_gfp, 1, &ret, orig_size);
 
 	ret = kasan_kmalloc(s, ret, orig_size, alloc_gfp);
 	return ret;
@@ -7337,8 +7317,7 @@ bool kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags,
 
 out:
 	/* memcg and kmem_cache debug support and memory initialization */
-	return likely(slab_post_alloc_hook(s, NULL, flags, size, p,
-			slab_want_init_on_alloc(flags, s), s->object_size));
+	return likely(slab_post_alloc_hook(s, NULL, flags, size, p, s->object_size));
 }
 EXPORT_SYMBOL(kmem_cache_alloc_bulk_noprof);
 

-- 
2.54.0


