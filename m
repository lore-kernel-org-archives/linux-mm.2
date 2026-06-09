Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0315CD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:18:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49A306B0099; Tue,  9 Jun 2026 05:18:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 471B46B009B; Tue,  9 Jun 2026 05:18:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 388756B009D; Tue,  9 Jun 2026 05:18:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2AA546B0099
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:18:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D21671C1DEB
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:24 +0000 (UTC)
X-FDA: 84859823328.15.3752DC7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1BBBE10000E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UtZ6gzxN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780996703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lUdhGEsiIkmEk98q3M/PwP2pTSml7IktU/L4N6zTfjk=;
	b=OF8M++7Qm4HLmj3MOJuM0eYX2haPz70LdF3Je44T8KcKHRuUzlKNR7BzZ7Jdss/jWX1L8r
	Od5jGa71MM1z39aYPE1w/emvZPppHXZ9fz6MeBkbMG4LdFARXSgh7CJ1fVKs764me+v0nS
	ljPi0qlYwypwbfBADZhvleA1k+FkVhM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UtZ6gzxN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780996703;
	b=WfVoEQEJHkIj8jUFGXZxyPe0BKPqsxVlxO/XGA4Q3cZQqYXzGqM6ZHYyXornu4qt/cEmww
	5xKUNSJTIXVpwzz6D98TO/GT0+76zthuTZr0myRAfLCDwN3EoKYmCNwj24H+bkWieULE23
	DctwkN4ggq+d7nVVLHKMcCf0KyqyKgA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 50F2F40C44;
	Tue,  9 Jun 2026 09:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DAE1F00899;
	Tue,  9 Jun 2026 09:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780996702;
	bh=lUdhGEsiIkmEk98q3M/PwP2pTSml7IktU/L4N6zTfjk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UtZ6gzxNRqJnwAm06gvctWhYRD1xV7p2uYuLW7IkT76bgUGxQilzhLe4h3POLT3Rl
	 Fli0goPoJ6XbQS+O5oCeQfJ2cbwUPao6Zwqtf+P8nkcgt3cTTd624a1s0d+g+IVCPd
	 ZV6sDEdiH4Hf9pRMTAiPubWpczu7irXpSc0IYDV0v3CuiqqhVdy8Xw4yRIyXh+SB1N
	 N8NJgQTKSPWxWf5J9DFruOAPnOi3MpleCxvmh9/O/zXFevg1klFbMT0NQ8G9k7exJb
	 gkY0drGG8uu275WdSpHbUjFN7uGnWgkl2HKp+8MejZtPbku79OJZogCD86MRsJD8dk
	 ZZSeyyeLJAWLg==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 09 Jun 2026 11:17:52 +0200
Subject: [PATCH RFC 07/15] mm/slab: pass alloc_flags to new slab allocation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-slab_alloc_flags-v1-7-2bf4a4b9b526@kernel.org>
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
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: s3pm5g6jafbodf7gcot7xnc8jc85d93c
X-Rspamd-Queue-Id: 1BBBE10000E
X-HE-Tag: 1780996702-198551
X-HE-Meta: U2FsdGVkX19pJVoJmLIzMxfysKwuUO6nybRJhRNwmx92KvRWFnU662SX5NJwLmoVa+RzRbdbsBhNkWe7uOkkDI6a+PeOhfi1YWRmzPk8yzm46Roocnu5LLNMm7O78f+ulArWIHCtniHbtW4rTp6SowI1YGHI/pys5op/fm1qRmTsiPga6/urr9xVu6RnEfny5QVDJGPwq7j6nRXA7onTLvvWtxckornG43U0gAEkVVIofNz7dqL8Yggi1uWTEn63OnyGNpOkaiB345dB5frpfEi6Tshj4WI0C09omzicsW5z9K2D3UUOryg3UtprhAiqjVwYLDvKqcP+bCCZzguKzez3urdQzgF8BTtfqzQS2Jad7kGJSAHQJAof65mnHNWGnryyV4d4FrakXrsA9Lxdd+ot4yNnI8BSmCT7ktwDDt+vWmV2+e4nyGJYaGXqH2ngk/mFhJiyPSLyhagUqgQYS0MjTka9yOkyj34lWy07d66GXpKj3OF1lD1AJETpQJV8lUNVNFQ2cor3iZkGjdaeQgSrkNqL66XV24tlb4bUepgfYR+m6u40mHGigQ9jTEvjc4nwLhfllP6Nsg7mrnl9YACD+AEVt6LuUkLRfOM1q0oG/Ad9CuusIBWdSTpKUqwWIxVi2N/eik/sTBvWDFLlZebZjNLA5NzWsW+sadK0TMIvJGC7jCF3Rg8KwLZTQ92WdF72qv/G09PjfL0wuFoNyykPwGArruguv0ZaI11YJFz0kBDNuUHtgaLk8cUQcL1IlgqflrbZN6str/kzoYF2BE6E6BTLUnCIw+7iF8x5R0MbIk1Or3poyzt8HrnnBruESbcnj1rhk+BMbaFkVFOFEXYGOpYomTUyNEABSxEcI4Eajg6Judm93SD4Z7NheeyfMVBk5jkt1ldUOgPZ0oxc5G8c3sWeVjKEKA6Q1z4qkzyP9obs7sLVYc8B/+CoAoQxkmvaSXAwx0nA0DBkRfM
 5Rgep06M
 sE/LRU3H4hIslM03zsuEsMFnWn6U+XaZ2PpUDjRUdna7auWhb7ZpZ867A8TeHW5kYnwbAaVSOmCZwrfSBusyaCMoDLJ6rwnWObM5Pf6axsTrtuE1Utos5qYAJv6AsKENdVkDQWPfmxdKZQDvaD78eV585ob0FZdTQB+xi8vCSpmwdZJBvnMY6XCm0bW0IXeaf10gRZb4H8d1tsVhpwTbEXcEn6gB/TmA55Hokrs7KjLwJmCHyumfMVN2XqbUDicNffKLxZ27QwWyeDwvmkQrMP7gwAvduD9XIbtE4
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

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 0bde4f6d9126..20df6b131f63 100644
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
+	 *    (at most) GPF_NOWAIT | __GFP_THISNODE opportunistically
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
+		trynode_flags &= GFP_NOWAIT;
+		trynode_flags |= __GFP_NOWARN | __GFP_THISNODE;
 	}
 
 	object = get_from_partial(s, node, trynode_flags, ac);
 	if (object)
 		goto success;
 
-	slab = new_slab(s, trynode_flags, node);
+	slab = new_slab(s, trynode_flags, ac->alloc_flags, node);
 
 	if (unlikely(!slab)) {
 		if (node != NUMA_NO_NODE && !(gfpflags & __GFP_THISNODE)
@@ -7215,7 +7215,7 @@ refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
 
 new_slab:
 
-	slab = new_slab(s, gfp, local_node);
+	slab = new_slab(s, gfp, SLAB_ALLOC_DEFAULT, local_node);
 	if (!slab)
 		goto out;
 
@@ -7563,7 +7563,7 @@ static void early_kmem_cache_node_alloc(int node)
 
 	BUG_ON(kmem_cache_node->size < sizeof(struct kmem_cache_node));
 
-	slab = new_slab(kmem_cache_node, GFP_NOWAIT, node);
+	slab = new_slab(kmem_cache_node, GFP_NOWAIT, SLAB_ALLOC_DEFAULT, node);
 
 	BUG_ON(!slab);
 	if (slab_nid(slab) != node) {

-- 
2.54.0


