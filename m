Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 242AECD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 15:42:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 846C36B00AC; Wed, 10 Jun 2026 11:41:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 822226B00AE; Wed, 10 Jun 2026 11:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75B0F6B00AF; Wed, 10 Jun 2026 11:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 63BC76B00AC
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:41:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 30C851A019E
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:41:59 +0000 (UTC)
X-FDA: 84864418758.08.E9B6DE4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 71DB840009
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:41:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="euWmhiL/";
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781106117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rAo2TJ3mFhvqnm70uvjWd4gD385rP/fi/7KGDakhPn4=;
	b=eVw2hD+gv2rOdHUlG5aMPDOksfT5tW1PI2baUxvtW8DG4Fkcgv+2mxNue1XUPWQv6qY7LN
	HM2HFPd4AhrcM+AiFt/olNt/CB7HD8t9Bbu1VHYbqEih9cpqy9M51dSucwLhVGtUtZ4mJd
	+VYHwfDI532cCABXjLExxe0406p/Vr4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781106117;
	b=7h8e8nX77WosBldg0a2yNNdw8DzbZgFvDRpS54WByXFSpJ1mlEn6UewxRfpUt+ubYqWSwN
	qpj0kFIkJxdwtZNU18AAmNos3edobtrMVfNP2lgHk1lzGrYFAjK0iKDfffdigV5oxUoxeX
	osE5WuqOe2czr7aVMsa09NpZX2Btk5c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="euWmhiL/";
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A06C41A8B;
	Wed, 10 Jun 2026 15:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9314D1F00898;
	Wed, 10 Jun 2026 15:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781106116;
	bh=rAo2TJ3mFhvqnm70uvjWd4gD385rP/fi/7KGDakhPn4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=euWmhiL/lEvXt05tpNb7MhFHmWkvYpZ58BpFYeH7WWhqmkxsGJptakcG9Tjvx5MXP
	 AAm3LKcSUpQQJ3uRGAZAz7MhaYb+6B/7dt2i0ANpYjZB9ijvCnbHhcKlGgON7+MWVI
	 4NwcuqOiBWKZ8zhi3GDUjoKO5pbpCFctoQ8etmybEEa7Fy397FfQhD2XIfcO8M4wzM
	 /XD5DmzJNSoc4ol0L8l/TniwRG9kjwNbZ02/XbK+T4rKfUP3OujCgiJ3qS5ar+BPFv
	 nt6pJkH8khzEKPIQJpqsD+JkJ15LYSaiZaCapgcPBo06od3ClLgqHJPW0UJwg58cFh
	 zHE4WI5ZLiZgQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 10 Jun 2026 17:40:15 +0200
Subject: [PATCH v2 13/16] mm/slab: allow __GFP_NOMEMALLOC and __GFP_NOWARN
 for kmalloc_nolock()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260610-slab_alloc_flags-v2-13-7190909db118@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 71DB840009
X-Stat-Signature: uhshqumdz7nrdtjcdy9cyku3hpnqihms
X-HE-Tag: 1781106117-70804
X-HE-Meta: U2FsdGVkX197Ma52PNU5DG/ZgmN0sj9rulNhsaZcc/Q2nfMGlGqGRIqcatw3kHgoX2nhcGiy2h6mIusch82CRU/ii7jy8rxs/1RrH4amrEfEC1PJ5MiDVLBvUcvNgFkXCrjRyceuUUnUFWU1S5hBHfIqQPPSXZzfOjDWHKMPmrXCX+VftUG8S1pngyO0bVo+5oh8Is5OwXXyM9cSJ7c4QdLgSbK06fG4jdwn4QM+/QIlCVJUuSm4oKuRV4aZK8zrwjpGGB++6iejiQjlBO0mVqtgPAcTxBYRaX/uWcVYmU+/9pr8urCmPDr7s0PeTqGzDhETySdV6+etN4dLNPCIkHk1x+2RJ6ZYoq0mEE3+mZD4IdPG4zk5NpcnYiyoi71r2rcFt2BE3cQ3UR/C7705WTCn59fWRAf474LJ578jOO7oPiu7fgwazgzqUzcod4X5ngW7moRjNH5zXdzzLbN0cbIm3bnQDVZzCVCgZWrCBuX68bpXBPNBLzo2Rtf3SeF26OfmR8/n0E2rtRum6gi8ZeFfr1X3yDI8ZzKFWUFCGD9vQLQUABsRedumVKrEeCU+Xybu3vTJ/lAP0fxmozoM7T+0nevRHTnbcpOT+dsM7dJ0aJBPLaNygDip4weZJErFko6M92/gF92aR/G2NFvJ07JaSaA2c+t1I/hLZ02ioi13A2XhoPpOUEFXYJ2sjxM3WAQ/9c9zWwzcuEU33JB2rlTUQM/CAAauQMd8givgAgSHXYnHzLKCTd2EYJr29kQwZvbKG5QKY6mKSVR6IyqyRlFC10/gw7q4reFznpqn2ok4/u/5WSgIGO/HDxeO4onN0yAKzP8IUlAg1itcM0/Pvk+UunY7qN4xaiGaXuH1d0wDBh3h9VyLEhHnKrwhQAivU/xKGNMEd29PTinP3IRWinhw8OkL1da59niYnyWGlKs2mHwl7oFLZcFgksg+PhOG88MKJ6EufVER5dSKNEf
 Rz8zaTe1
 F0SN8QLyVwqZLZCnOZYmxg0oMVsDdtgk2/bqY74fJOIQA0f7DHoabe5PdMi7w2ChaKsgYtTtAIXVSoz5c+tt/g+JUWwa0ZZbpE9z5OrC7N11FYLSzRsHICQpVM6r5o3y9SVjhuMOnaezNZlxHTKu7NKYa1yrU/ii/Ae7JQN7xnltcmEuQKwO7yehPsv5a5/98c3ntFWR8HDE7LIMfPu3ux7p1o1vf6sg6TMT+HO/AQ9XHnoZCDOLnEUkLzJkILprnXuvG7lXRLPLUxKiIIZAtaW97VOLAiQdNzY4w
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
index 6845e15c148a..847cad5203b2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5388,7 +5388,6 @@ EXPORT_SYMBOL(__kmalloc_noprof);
 
 void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, int node)
 {
-	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
 	size_t orig_size = size;
 	unsigned int alloc_flags = SLAB_ALLOC_TRYLOCK;
 	struct kmem_cache *s;
@@ -5396,7 +5395,9 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 	void *ret;
 
 	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO |
-				      __GFP_NO_OBJ_EXT));
+			__GFP_NO_OBJ_EXT | __GFP_NOWARN | __GFP_NOMEMALLOC));
+
+	gfp_flags |= __GFP_NOWARN | __GFP_NOMEMALLOC;
 
 	if (unlikely(!size))
 		return ZERO_SIZE_PTR;
@@ -5415,7 +5416,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 retry:
 	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
 		return NULL;
-	s = kmalloc_slab(size, NULL, alloc_gfp, PASS_TOKEN_PARAM(token));
+	s = kmalloc_slab(size, NULL, gfp_flags, PASS_TOKEN_PARAM(token));
 
 	if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
 		/*
@@ -5429,7 +5430,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 		 */
 		return NULL;
 
-	ret = alloc_from_pcs(s, alloc_gfp, alloc_flags, node);
+	ret = alloc_from_pcs(s, gfp_flags, alloc_flags, node);
 	if (ret)
 		goto success;
 
@@ -5445,7 +5446,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 	 * kfence_alloc. Hence call __slab_alloc_node() (at most twice)
 	 * and slab_post_alloc_hook() directly.
 	 */
-	ret = __slab_alloc_node(s, alloc_gfp, node, &ac);
+	ret = __slab_alloc_node(s, gfp_flags, node, &ac);
 
 	/*
 	 * It's possible we failed due to trylock as we preempted someone with
@@ -5458,8 +5459,8 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
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
@@ -5468,9 +5469,9 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 
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


