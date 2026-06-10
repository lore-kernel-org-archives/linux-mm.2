Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57D53CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 15:40:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA0A46B0092; Wed, 10 Jun 2026 11:40:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77D06B0093; Wed, 10 Jun 2026 11:40:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB50C6B0095; Wed, 10 Jun 2026 11:40:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D1E06B0092
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:40:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 66B181C0D0D
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:40:39 +0000 (UTC)
X-FDA: 84864415398.29.E55632F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 87FFF8000A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:40:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MGXfLz7Z;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781106037;
	b=NoZSyu3Rvn1Zj4SjeRS8ka/1uj6sj7vlD8K2qzEohkB6EMSXtnP11D9mObgo21lO75tqDt
	M7PwMzXZHinRAiqj6sZuTQcDZO+LANNx7P2J8RYCbd79wEnF30gpNgmzQlr4CJwSEZ5aIs
	Svn/VuuCjPXsoykylUVUDoWEk3QSrtI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MGXfLz7Z;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781106037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZhFKmHctgSxoJWqzBYD58wKUXHYe5psqPpAeu+LOPVw=;
	b=b0dsPseKCQRN25amFmSn/ohVTDAtCv3N0e1q7NNXohVn0WfQhs3oEg3WoiFVa3lRqoVhUh
	kiG5vbLggpGASutg0zJUfC231w1xvr+30Fmtt5hZE1GYd/fJTossySc2vT2c5Sf1j5t6Ut
	8sULmVK+pqNRiKF7I69DqGvEddh/+/k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B8E84195B;
	Wed, 10 Jun 2026 15:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067421F00893;
	Wed, 10 Jun 2026 15:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781106036;
	bh=ZhFKmHctgSxoJWqzBYD58wKUXHYe5psqPpAeu+LOPVw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MGXfLz7ZZVI7GqiN/jfhQa/zsWy9FrniBQpUixElaK2h8d+l7MRqVQ9U8bttWhrvt
	 pcuvBZg2MfxB/9/Q0PIRpo2dQdk99czRHJR83TG496O+h97+AWRBWC5Q1XxePGo1uY
	 Nj6mAlYXB5M42sx679YfYDE8S3AV0NA1UprxNgEgUg7JrfPXFDsvnNLjTxXODA1/Ts
	 cTTzAVYJcvSJtYdsG5XKPStNXixlNvTF6O1qZitE6feN8u6K2dDkj4bwvSr1IR3lsZ
	 BGq5SoMUIYMoHVWEmCp4syrJtm8k3Ov8NEwXrxrKC43cc87FrLr6TPH65baRtzfrbz
	 j9jTC+MmTLwew==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 10 Jun 2026 17:40:04 +0200
Subject: [PATCH v2 02/16] mm/slab: do not init any kfence objects on
 allocation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260610-slab_alloc_flags-v2-2-7190909db118@kernel.org>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
In-Reply-To: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
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
X-Rspamd-Queue-Id: 87FFF8000A
X-Stat-Signature: whrxtf8znptre99ukh8e44zyn9zsmrpc
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781106037-265248
X-HE-Meta: U2FsdGVkX1/l97xDkb6T1NdOXdiwaQIwpTKyWfTxUQ6a3iPdO5LAQvSOny8L0UQhYwpelY5VsiLgrvgNwt8yRS6X/o81uyA+vz0cZ6nYvZd2MDfO8WkZ6uIME0Mbt2y2wyO9CdsZonWzBGpeJoJcMCfoLKvyju41QxFfOtWkOh/HMbVihnRVMn8B71BoEil96TKyq3xv8eH4SG3gDxK0eyWvyYnJ652N0onwEGa+lgaxYlaLUltauNTSkkvv+wJoqUHiBTp3m7cfAUiWATGtoNkjuguftpUXH+ICyvIBF4+v7uou0Nlwnc4a4E/YkKx6Sckrd4t4txxz0NxPHSHdfb7qcOpQUPQCBiEgAW9JA82XwiVsN44Ka0WAckPWNctDjYCGUJfmH4BEUtLubOjNbCUeC7WhOjCyIaiW+kgdo5NONO3ELwtlfqfEIJ0RBim6qQCPVniVkZKucoa5nEifjB81rX+pQPh//Eoisu5pef7oZdr4Py3Y8TkCsz1dJ4aq3h8xtbFIJ3Dq4qvdRG+LISFotpF+0FTGyMfmlXJPaYs1CIO0tpdUCMzyczhcIdjyXpzNtbhoxCIBnJax20n/wdCqUdgOUu8Bvt2f3VHpzNqk8zY30GroXzwRUYBuOtBMo77B9kU5OiXfiUrz/HbOV9tpES5589oRCcR8v5yx/eSIq5RSWHSb2ZSwpCirdBRqukvXue48QWZPjgQDrPJ0Jh9gHzUgJxhUPjrd9fbXUuDyn1sMiQME3hdz+YJUWmUDei4UE8p6j6SER9TtEY6uqoZQUZawkp6zflTiYhWUOkpvT2PCb/r+dNVWPfj0yclJNSdKxh5DMp4xDFff5hsMNN/pzUIduiof0HwdzkA/Rn3gGelRZfq8ZMPpLs+9MlE9SHuJAXOBjESdaztoQliVmnJW3SsOfHClCpNjr4L+2SCFpyjD3shYQG/K2Vn9gGcj/bKnXlV8pdZ0ZfRO5nw
 hSVpKRK7
 KD9JJsz9kZzAZmdgUgWDROGiDvUUtaRCOn45RtCPPOnInPzaO9IsLwkadP4tnb/oNrN7kdrbmL03cciy2jGwX3eHVQQRACbmbHPLXn55uxZJCDfdiPA1tmyrCtkP8bkQALLrjm4e8iZMC5WwgiZbsevuoHmQcGidTS12ykbXdyc/P/EEd4mZGhhBYnE4q5AI7q3aROG/Rnh0SGqxY6WOq0+oJc03ZLlpYqSx7I0YE5yLTQUlsVjlqGkgRdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When init (zeroing) on allocation is requested, for kmalloc() we
generally have to zero the full object size even if a smaller size is
requested, in order to provide krealloc()'s __GFP_ZERO guarantees.

When we end up allocating a kfence object, kfence perfoms the zeroing on
its own because has its own redzone beyond the requested size. Thus
slab_post_alloc_hook() has an 'init' parameter which has to be evaluated
in all callers (via slab_want_init_on_alloc()) and should be false for
kfence allocations.

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

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/kfence/core.c |  2 +-
 mm/slub.c        | 23 ++++++++---------------
 2 files changed, 9 insertions(+), 16 deletions(-)

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
index e2ee8f1aaccf..8e5264d3ddbf 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4565,9 +4565,10 @@ struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
 
 static __fastpath_inline
 bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
-			  gfp_t flags, size_t size, void **p, bool init,
+			  gfp_t flags, size_t size, void **p,
 			  unsigned int orig_size)
 {
+	bool init = slab_want_init_on_alloc(flags, s);
 	unsigned int zero_size = s->object_size;
 	bool kasan_init = init;
 	size_t i;
@@ -4608,7 +4609,8 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 	for (i = 0; i < size; i++) {
 		p[i] = kasan_slab_alloc(s, p[i], init_flags, kasan_init);
 		if (p[i] && init && (!kasan_init ||
-				     !kasan_has_integrated_init()))
+				     !kasan_has_integrated_init())
+				 && !is_kfence_address(p[i]))
 			memset(p[i], 0, zero_size);
 		if (gfpflags_allow_spinning(flags))
 			kmemleak_alloc_recursive(p[i], s->object_size, 1,
@@ -4910,7 +4912,6 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 		gfp_t gfpflags, int node, unsigned long addr, size_t orig_size)
 {
 	void *object;
-	bool init = false;
 
 	s = slab_pre_alloc_hook(s, gfpflags);
 	if (unlikely(!s))
@@ -4926,16 +4927,13 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
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
@@ -5230,7 +5228,6 @@ kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
 				   struct slab_sheaf *sheaf)
 {
 	void *ret = NULL;
-	bool init;
 
 	if (sheaf->size == 0)
 		goto out;
@@ -5240,10 +5237,8 @@ kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
 	if (likely(!ret))
 		ret = sheaf->objects[--sheaf->size];
 
-	init = slab_want_init_on_alloc(gfp, s);
-
 	/* add __GFP_NOFAIL to force successful memcg charging */
-	slab_post_alloc_hook(s, NULL, gfp | __GFP_NOFAIL, 1, &ret, init, s->object_size);
+	slab_post_alloc_hook(s, NULL, gfp | __GFP_NOFAIL, 1, &ret, s->object_size);
 out:
 	trace_kmem_cache_alloc(_RET_IP_, ret, s, gfp, NUMA_NO_NODE);
 
@@ -5423,8 +5418,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 
 success:
 	maybe_wipe_obj_freeptr(s, ret);
-	slab_post_alloc_hook(s, NULL, alloc_gfp, 1, &ret,
-			     slab_want_init_on_alloc(alloc_gfp, s), orig_size);
+	slab_post_alloc_hook(s, NULL, alloc_gfp, 1, &ret, orig_size);
 
 	ret = kasan_kmalloc(s, ret, orig_size, alloc_gfp);
 	return ret;
@@ -7339,8 +7333,7 @@ bool kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags,
 
 out:
 	/* memcg and kmem_cache debug support and memory initialization */
-	return likely(slab_post_alloc_hook(s, NULL, flags, size, p,
-			slab_want_init_on_alloc(flags, s), s->object_size));
+	return likely(slab_post_alloc_hook(s, NULL, flags, size, p, s->object_size));
 }
 EXPORT_SYMBOL(kmem_cache_alloc_bulk_noprof);
 

-- 
2.54.0


