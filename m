Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D28C9CD98DA
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:55:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 491096B00AA; Mon, 15 Jun 2026 07:55:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 468F06B00AC; Mon, 15 Jun 2026 07:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37E896B00AD; Mon, 15 Jun 2026 07:55:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 21D476B00AA
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:55:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E82CBC36A2
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:55:33 +0000 (UTC)
X-FDA: 84881992146.07.0C7B0E9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5322940013
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:55:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nSPq5Pu2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781524532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1LMlha3I3jmWXWTn3LCS36ZII8qgnXRUvT0Ggzn4U4k=;
	b=OO6mvta5kqQFDqQCgbktKrIckD+KcgoPWHO5RDo5Jhh4WPJHV6NBP2srIWV+yhy8Udwe5N
	hWnTX6+xiUBz8OHaLWurU1zg2gBs/4+HhnWQpLR580d/GwzxgDUl3gu10AnXvIku17lDyX
	u8QxrBbEC1WRNcE4Ys9xxdNyP3gH7s0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nSPq5Pu2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781524532;
	b=KNaGv6TLHK1Qsy3t6OJo92SgUzpeR6fxuhNI3Sbd+PYUEewRJSGItjDkaNMZsQxm47eFul
	dR4PgSSHJskF0z2oD8PK3e+l4PelMidvOfIPi06xCRzY6cyes4ZhEVu7NWm7i6rEyiJEcB
	MwmKIhXirYzf3GPHcnSB1tii74Ptur0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C67B760132;
	Mon, 15 Jun 2026 11:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7031F00A3D;
	Mon, 15 Jun 2026 11:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781524531;
	bh=1LMlha3I3jmWXWTn3LCS36ZII8qgnXRUvT0Ggzn4U4k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nSPq5Pu2IrBynukV+o2+XQc5aXPntEQ5LyA88YUlAq7W/+J4DZ6nG2UnHMo2CuFgW
	 ei8Ls9ftSWVnK74ef1CwdMD3y+g12ip3WVnH/mBQvQ+mIZOlVqeV2t+WLlmRCDxr/+
	 EV3OXmSBpDdiW3v/rprj+fNd7gd5vrn1XrKYPMnmeXh3ogUkZU1kNB59js63pHfGY/
	 wmUUzMO84rwLMwkLH7ypPY2jcE12UDCjG61HdOZdcm+rs7GK0FXQCdpPuTSogzD70q
	 geIXxfN9D8/S7OC5CgwQnOzT1Qg1uO0/aZSEey8Y43VTxtofTAju0NbtCIxMMVNi7q
	 RpHp+TIitP3tg==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 15 Jun 2026 13:54:45 +0200
Subject: [PATCH v3 12/15] mm/slab: allow __GFP_NOMEMALLOC and __GFP_NOWARN
 for kmalloc_nolock()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-slab_alloc_flags-v3-12-ce1146d140fb@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5322940013
X-Stat-Signature: d6au73taw39f8u4su9oxyyckym7cs9ue
X-HE-Tag: 1781524532-7483
X-HE-Meta: U2FsdGVkX1+tkFmk580ifvOSq4XMSgAIHSBBucbDRVlEhD+SNFOr9YZdSL65PC9PqNKO3XsV19YkeZtfP1wxhznk5NVTPwIkEiRsjB5GxfOoM+jKCNG5QsUyaq7AGKoCAvAMvlLjkuSKAl5sJMeNESBdxfhjsVbSoq2Dk32/bTZCiVwb4sdAm9Swzuu4WjV6JG6bqTM0TocnZGtwCaDKr96bUF2+nZUdBlzlENQjU5DUDLY7FM2ydgBVs+JVqJKXo9TG3icDqpAvP487fFw9snJIG0ZK3femS6KDVgRpbVh/qyXNa/3pOEmM9kdlS96tYAlilkT2CKIa2iPRCU1DggPqnI3Q4EXFrJduitps5dpQVvfC8l1M0pHM2j/ja2l58K1dQ2ksfH3aPDSbJ9s7hpTHgPC3u7Dkt7J5K4MlHIQsymdDgp7agy+/mi9tJE1jDWE2hRzZL/2UsxY6QlOTKclnGCGlJauMYMcZxmWNRzK75qvjhyGMENbxivvuSp9JuTdZkpw9VrvcFoKKObasEWBSWIYoULXaQ9VQAW4hXxYswVHc9Hq6sx6blPzZJY+n38kN6JftcCyugFwwG2ZQNBsRt2C24ShzLjR9hK/ovArip0xe0fKG7pDvoajMR5CnOemHNoDU4GDTmodivgCRt1zQAfTcFHGZYae/oGfaUJcCZ41UxnH0g/EjHPDDoxDLJ2nzZrnYW91UOyrgyjI0ImKbWMeFtAPfI4tr9gdfEiwIgYwX6Eb6Ij/7zI5nO7IfhCmtKGqwNZoXaXyWd7xvvC5BxFP+GP1xF+68e2rmmB+mMczFFQ5KDdS6qfJifjE8NCCS23QW1A9cUkMdMmbd2So6w1Lgka2E/o873ELVKWhUOYPZ9gPoFMXiuQijhE/n2Wi7UjJfSFwJgyB8arEGnxJ6cIYLc7q9tF4m72+wBfj1UDm3BPYvSajoWwK3XYbmYvCtmHJEYX8ZKaoLylv
 zLUGgOnY
 +v2ZFtyNgTrsoyq5ww3cY9f81NFK8Eh6tdGWz4R/iL4YfMnJd1aXZISYoqahiHjjzuXZ3NDGeVKUmr+8S48pSJyknR/4h0yFt/OQzCaQDIABbV4iRf3X4kwCeFC7RLQgnm5LdYVQ9SfvO1LokPFyzrCyYTmgLS8ePgFN2cMTKRPLVy5QdOQo9+H/yb81FNUaeeicBWqiRVTHNc0ofVUlqz0is4Irvy6+MktkxwAb9iXCADq/xXGC8MscOzbbL0ZVvIFvbBThV8IsNJ68nAELq2RMfNAWFTiK/EJm490nlT+CaaYPAbbaoLUNoJmLWbpdHzLhBnp/Edb5YzDXC3fjFxB6EjVo/6dcilFVla+srXr6vvcFsoINjCQEZXUol4AFFDIUj9LkF+nOScYc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The two flags are added internally so there's no point for warning if
they are passed by the caller as well, so allow them. This will allow
simplifying obj_ext allocation under kmalloc_nolock().

Also it's not necessary to have the extra alloc_gfp variable for adding
the two flags. The original gfp_flags parameter is not used anywhere
except for the warning. So remove alloc_gfp and directly modify and use
gfp_flags everywhere.

Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-13-7190909db118@kernel.org
Reviewed-by: Hao Li <hao.li@linux.dev>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 include/linux/slab.h |  3 ++-
 mm/slub.c            | 19 ++++++++++---------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index ce1c867dc0ba..b955f3cbb732 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -1040,7 +1040,8 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
  * kmalloc_nolock - Allocate an object of given size from any context.
  * @size: size to allocate
  * @gfp_flags: GFP flags. Only __GFP_ACCOUNT, __GFP_ZERO, __GFP_NO_OBJ_EXT
- * allowed.
+ * allowed. Also __GFP_NOWARN and __GFP_NOMEMALLOC are allowed but added
+ * internally thus not necessary.
  * @node: node number of the target node.
  *
  * Return: pointer to the new object or NULL in case of error.
diff --git a/mm/slub.c b/mm/slub.c
index 537ea68f417b..8769083bec81 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5387,7 +5387,6 @@ EXPORT_SYMBOL(__kmalloc_noprof);
 
 void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, int node)
 {
-	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
 	size_t orig_size = size;
 	unsigned int alloc_flags = SLAB_ALLOC_NOLOCK;
 	struct kmem_cache *s;
@@ -5400,7 +5399,9 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 	};
 
 	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO |
-				      __GFP_NO_OBJ_EXT));
+			__GFP_NO_OBJ_EXT | __GFP_NOWARN | __GFP_NOMEMALLOC));
+
+	gfp_flags |= __GFP_NOWARN | __GFP_NOMEMALLOC;
 
 	if (unlikely(!size))
 		return ZERO_SIZE_PTR;
@@ -5419,7 +5420,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 retry:
 	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
 		return NULL;
-	s = kmalloc_slab(size, NULL, alloc_gfp, PASS_TOKEN_PARAM(token));
+	s = kmalloc_slab(size, NULL, gfp_flags, PASS_TOKEN_PARAM(token));
 
 	if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
 		/*
@@ -5433,7 +5434,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 		 */
 		return NULL;
 
-	ret = alloc_from_pcs(s, alloc_gfp, alloc_flags, node);
+	ret = alloc_from_pcs(s, gfp_flags, alloc_flags, node);
 	if (ret)
 		goto success;
 
@@ -5443,7 +5444,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 	 * kfence_alloc. Hence call __slab_alloc_node() (at most twice)
 	 * and slab_post_alloc_hook() directly.
 	 */
-	ret = __slab_alloc_node(s, alloc_gfp, node, &ac);
+	ret = __slab_alloc_node(s, gfp_flags, node, &ac);
 
 	/*
 	 * It's possible we failed due to trylock as we preempted someone with
@@ -5456,8 +5457,8 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 		size = s->object_size + 1;
 		/*
 		 * Another alternative is to
-		 * if (memcg) alloc_gfp &= ~__GFP_ACCOUNT;
-		 * else if (!memcg) alloc_gfp |= __GFP_ACCOUNT;
+		 * if (memcg) gfp_flags &= ~__GFP_ACCOUNT;
+		 * else if (!memcg) gfp_flags |= __GFP_ACCOUNT;
 		 * to retry from bucket of the same size.
 		 */
 		can_retry = false;
@@ -5466,9 +5467,9 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 
 success:
 	maybe_wipe_obj_freeptr(s, ret);
-	slab_post_alloc_hook(s, alloc_gfp, 1, &ret, &ac);
+	slab_post_alloc_hook(s, gfp_flags, 1, &ret, &ac);
 
-	ret = kasan_kmalloc(s, ret, orig_size, alloc_gfp);
+	ret = kasan_kmalloc(s, ret, orig_size, gfp_flags);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(_kmalloc_nolock_noprof);

-- 
2.54.0


