Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 436B0CD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 15:41:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A42726B009E; Wed, 10 Jun 2026 11:41:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A19A46B009F; Wed, 10 Jun 2026 11:41:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90A216B00A0; Wed, 10 Jun 2026 11:41:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 816296B009E
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:41:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4C8371A0122
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:41:20 +0000 (UTC)
X-FDA: 84864417120.21.17A8437
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 98128A0012
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:41:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nIC4+tgu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781106078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zw7OfgTsThDHzuQXS+OL+Mrf7Mf3Iw/m9nWLfYn615A=;
	b=n1E8eDWB5fp6Zn1RHqUDdN6v8GV7xv1oGIiiK1plSgF9cd7AXZynPqLPd6gNE96PwMEFkR
	RtrLTNK75h8vI2grtwAVhf6IAge43HrTM/O17IfoOdTKBBabw6ycZdB1LArZBrSEfVULAS
	ScZ++3cw9guaABK39TOluG8iCmhXs5s=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nIC4+tgu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781106078;
	b=2dXSVZj4WGZ2a6GF9KUBxVcGTEXlXdF4t5BC+OkHG4nGgSMJAPURU2F52LB4sBMBuK/U5U
	X90yhyEKtEbh7Su66dyIITdJKve4NkTvKa8mmSb5VVUoAcPBqtRfcVYmi1Hre0xYEQKKiH
	GdWF2wDr8qv+tbQtxgrPDfsntVEHVag=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2652660172;
	Wed, 10 Jun 2026 15:41:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3922E1F00893;
	Wed, 10 Jun 2026 15:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781106077;
	bh=zw7OfgTsThDHzuQXS+OL+Mrf7Mf3Iw/m9nWLfYn615A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nIC4+tguZQTWq8AmKG92I9Jn9Q7ZciPLThGgiggAl2kImmdgWPpBQenefZeEvZRlx
	 ey5e2PnNze0f+V3yjUZarwjMTpXmCZeH+YkpxeTzLUYWfr8qcI6FMNVFNa0666iQd+
	 3Rm3WN2juaXNqUcFbjgtIcFY1gcJM52rNy9hoN1tqd7h85HqHkjl/u6VxBwv1KmPno
	 kcdu1liXPl9KXtdVvu1btuA1W57iiBEFl/2Mg169S39LQB+ANgVEe4zn8UyDjlRqfS
	 PpxQ1lvKTKgF7ZcW+3qjhHRH12ZVTaRYU0W3gACrtD4bbBYFpS0JlUuuHKw/PcAUiX
	 rltrfMALmUqrw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 10 Jun 2026 17:40:10 +0200
Subject: [PATCH v2 08/16] mm/slab: pass alloc_flags to new slab allocation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260610-slab_alloc_flags-v2-8-7190909db118@kernel.org>
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
X-Rspamd-Queue-Id: 98128A0012
X-Rspam-User: 
X-Stat-Signature: b6q844gm1sqt1j35pgckuncqrn7a9bqz
X-Rspamd-Server: rspam09
X-HE-Tag: 1781106078-770533
X-HE-Meta: U2FsdGVkX1/Juk72u2msZdnbVdpFHf7S183n3F4gHfEAmNccYRSwh+BuTHAQtKijiJrrpQP+daVwwqgS6jl8+dGMnezGY7gEbc8MbNuYXXA0F4TGy9i9jPtKwOofuNBNnagd4kzrT1E2gy+qEfJYAT7Y99LXEEhQEsNb6g0/7lQJxqMCRYUpVdVm5GvsL8ZVhK6/kwx+x4ZxqZ8U0LW+bQLGFL2mx5lJtCbGiCtb1kUWyxXDLwy7yUZN5ZKpCTExRP5hei8jF9g4nXIVYVnKYGsIfLd9fJDmKMIv1JrtT+M3HfPPN9evZh5aVwJ0lurdFt4xf/J1qRfz2XG8CTGAlPVVrwxmqyDKRbH5/M7mQmMhiGwxjhl8Cn/wWsyQccWJpCRyi35gYH0HRBx2mhYmfsJ9EcrvfDMJziGuQxiLGM9WTsuHTb1DPs0LMbLV8bL4D6PWsUhg6mgSmj8J8RkGvejIohC1+s7fdzFSz7pzGrhkgAUlag9OBl5HD3E0Byg8XOHwuc9W5crWwomozn6Uuv13Zis5KmiqUtXTJAVwSP55yrKCS7g20Fb4Anb21OMvnBuDWzhZvXeiX9rsS9CCxijZl/GHwnkYQR9LFyvdm/W9Zx1SxP/2ziAIxEUYMdqgbINbsVMRVMTsE4Nd00pA6XW3t9y4lLggACRYG5DGYXtCxlZU9ftJWOjPiGbqXe6nuauFLTXqsuJReUyNtu8wZeYIiU+FSGb3uM8fE0oLPdX+8j4T2QvRuq5xlhxFFKBeqJOpmrYnLvRXUQzG5RPAMZ4gRxDA6L5K3y2I54kZMuwi1VERGaDUr4BVUOzayxvKQRu73uQ+2HlJ1fg0mJ/xwyeBm3nuqJhSZIWsbF3LqnAJP63jMvkI5tTLDMZJ/722XI720t5/gTsAZlc0zDe7TD2y9d7eBddvL5bEssNr41Pk+b9czA3n60XNXaun37hvrLgVleFDMUAkeuRU/Jj
 LT9Od/Ph
 dR0/4EIQW8YfsNYQXZCigRDMbxxiMWPVPoayk3ElYRUxNKQPOfn2+6W1pjxMz6ufsezn8uLlLqXWh/8VTB+y+t8jZ5Syx0LlWp4QjGr3pi+FGSlQ7aF7i8pi2E0NhVis8h+wwvOo+OKDaNlnU4ji2nHhmTgZGp1r1OYAK7nsoYCGc/mGaTFkiaP/z751nQoBjzBy4PNQK2sgHei/CHM+gI5Hvfwki9tXRfj/hOLxvCzMKXGtZcSSrpGUYX31pi/CDOzy4Ps9SJFyWQJ/vBrvFqmKhRm4RPotnGteX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the alloc_flags parameter to allocate_slab() and new_slab()
so it can be used to determine if spinning is allowed, independently
from gfp flags.

refill_objects() passes SLAB_ALLOC_DEFAULT because it can only be
reached from contexts that allow spinning.

Also change how trynode_flags are constructed in ___slab_alloc() to
achieve the same "do not upgrade to GFP_NOWAIT" by using masking instead
of a branch. It will now also not upgrade in cases where gfp is weaker
than GFP_NOWAIT (i.e. lacks __GFP_KSWAPD_RECLAIM) but doesn't come from
kmalloc_nolock() - which is more correct anyway.

During the masking keep also existing __GFP_NOMEMALLOC (pointed out by
Sashiko) and __GFP_ACCOUNT. Previously the hardcoded GFP_NOWAIT would
eliminate them, but it's not a big problem that would need a separate
fix.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 98b79e5e7679..8f6ca3d5fdfa 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3378,9 +3378,10 @@ static __always_inline void unaccount_slab(struct slab *slab, int order,
 }
 
 /* Allocate and initialize a slab without building its freelist. */
-static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
+static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags,
+				  unsigned int alloc_flags, int node)
 {
-	bool allow_spin = gfpflags_allow_spinning(flags);
+	bool allow_spin = alloc_flags_allow_spinning(alloc_flags);
 	struct slab *slab;
 	struct kmem_cache_order_objects oo = s->oo;
 	gfp_t alloc_gfp;
@@ -3438,15 +3439,17 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	return slab;
 }
 
-static struct slab *new_slab(struct kmem_cache *s, gfp_t flags, int node)
+static struct slab *new_slab(struct kmem_cache *s, gfp_t flags,
+			     unsigned int alloc_flags, int node)
 {
 	if (unlikely(flags & GFP_SLAB_BUG_MASK))
 		flags = kmalloc_fix_flags(flags);
 
 	WARN_ON_ONCE(s->ctor && (flags & __GFP_ZERO));
 
-	return allocate_slab(s,
-		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);
+	flags &= GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK;
+
+	return allocate_slab(s, flags, alloc_flags, node);
 }
 
 static void __free_slab(struct kmem_cache *s, struct slab *slab, bool allow_spin)
@@ -4467,25 +4470,22 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	 * 1) try to get a partial slab from target node only by having
 	 *    __GFP_THISNODE in pc.flags for get_from_partial()
 	 * 2) if 1) failed, try to allocate a new slab from target node with
-	 *    GPF_NOWAIT | __GFP_THISNODE opportunistically
+	 *    (at most) GFP_NOWAIT | __GFP_THISNODE opportunistically
 	 * 3) if 2) failed, retry with original gfpflags which will allow
 	 *    get_from_partial() try partial lists of other nodes before
 	 *    potentially allocating new page from other nodes
 	 */
 	if (unlikely(node != NUMA_NO_NODE && !(gfpflags & __GFP_THISNODE)
 		     && try_thisnode)) {
-		if (unlikely(!allow_spin))
-			/* Do not upgrade gfp to NOWAIT from more restrictive mode */
-			trynode_flags = gfpflags | __GFP_THISNODE;
-		else
-			trynode_flags = GFP_NOWAIT | __GFP_THISNODE;
+		trynode_flags &= GFP_NOWAIT | __GFP_NOMEMALLOC | __GFP_ACCOUNT;
+		trynode_flags |= __GFP_NOWARN | __GFP_THISNODE;
 	}
 
 	object = get_from_partial(s, node, trynode_flags, ac);
 	if (object)
 		goto success;
 
-	slab = new_slab(s, trynode_flags, node);
+	slab = new_slab(s, trynode_flags, ac->alloc_flags, node);
 
 	if (unlikely(!slab)) {
 		if (node != NUMA_NO_NODE && !(gfpflags & __GFP_THISNODE)
@@ -7231,7 +7231,7 @@ refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
 
 new_slab:
 
-	slab = new_slab(s, gfp, local_node);
+	slab = new_slab(s, gfp, SLAB_ALLOC_DEFAULT, local_node);
 	if (!slab)
 		goto out;
 
@@ -7579,7 +7579,7 @@ static void early_kmem_cache_node_alloc(int node)
 
 	BUG_ON(kmem_cache_node->size < sizeof(struct kmem_cache_node));
 
-	slab = new_slab(kmem_cache_node, GFP_NOWAIT, node);
+	slab = new_slab(kmem_cache_node, GFP_NOWAIT, SLAB_ALLOC_DEFAULT, node);
 
 	BUG_ON(!slab);
 	if (slab_nid(slab) != node) {

-- 
2.54.0


