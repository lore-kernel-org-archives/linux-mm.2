Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED958CD98C7
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:55:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E7696B009D; Mon, 15 Jun 2026 07:55:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BF376B009E; Mon, 15 Jun 2026 07:55:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3E326B009F; Mon, 15 Jun 2026 07:55:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E80236B009D
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:55:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B61281409D4
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:55:14 +0000 (UTC)
X-FDA: 84881991348.22.A2614F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id CB465160011
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:55:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HdaqbaKd;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781524512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=clKGU2J3FECfFFvrlPmzCBUH3Fhm/wSfYtcUHaC+zIs=;
	b=vGYsZZ+MjRuo5KM9HQ+qIS7ErBKhIT7ufj/ToZs2UBYR4sKmbfcoood0Za0MWNOFaWnPdP
	J+anp3xDMqoe7MLWt0w3ZJS4eTMb6ZhjUt3BbmRfhnBGRsAKjfnOtdKMYOYCNERls25usI
	gLWig1fxHEw0W/9CDv2C491QNGxkNOo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781524512;
	b=qat2+4rcM73W/viSsW07r5Y30b45h949gLAox00zz44LMXSDgshoIT0n1RdK7yxCWTv7+0
	aGeOODpjvJLC70U/Cc5MxqChNANw05aluGpxPNNDQJLZn+IaCL6vAylT33hSB3M2P/3/77
	YV06gEs0YDH8DmNH0WUt6TnproNW468=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HdaqbaKd;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A9C343BAD;
	Mon, 15 Jun 2026 11:55:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816081F00A3D;
	Mon, 15 Jun 2026 11:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781524512;
	bh=clKGU2J3FECfFFvrlPmzCBUH3Fhm/wSfYtcUHaC+zIs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HdaqbaKdUA2kThvtHmI9K1RSKSZN7JliY3uoWE9tdZ+lHtxjpLN0Xsf1YV/zwEW2a
	 4OoHorFuZYbQuyP8SA0gmcbTiFBxjbKqUkm94brLiIJB+UV3G06OThCxRQ81vjWWcz
	 SH/ZZCuD6p24R4PD2shjgWg+Oxp6ZxzeEZwRm6uh8bcalScp5KZpTGVt9lxpUS05nE
	 o1i4KjoENaC63p9ngR3nyfhcIQ5AXdPxVpEG949JZ2Jk4AzWuIlY4Qqu4HIo9L9lsa
	 DyDSrVMg/+wnLtyMiB6FL/xFJLwCjX28UJHj0FhtNQzKxSHBDCZy39YxjrWRZSPTUQ
	 +a3MoAu9VPjmw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 15 Jun 2026 13:54:40 +0200
Subject: [PATCH v3 07/15] mm/slab: pass alloc_flags to new slab allocation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-slab_alloc_flags-v3-7-ce1146d140fb@kernel.org>
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
X-Rspamd-Queue-Id: CB465160011
X-Rspam-User: 
X-Stat-Signature: tipngfg71g1zfdugoz16togta9r8hi5y
X-Rspamd-Server: rspam08
X-HE-Tag: 1781524512-719704
X-HE-Meta: U2FsdGVkX1/4hotl1theau9CSF9nqjASNS/0dGi9tpHUSYl2nkbyenX2rMvJafvYBDwPo6m/vjZ+xxCAvddXKiStSrldnVFt4t9bd2YSHcytJOlv2RdTlgaEo6CyFrLwnHbQL5kdHW88250b/fJPxPHr0ylLu82DuUylRMJZi8k3BK0joYClOcdJh6n+wr5fbeXMu9/VmikzjGB4oaOAoTRjrbb76nYOY+QtQmOBGKhw746HsyZB9Z+J6EBR4T58iQxxss7+6USNzMsek1CAY9NEm3BE1HaX56G10UaOkPRX0IRT7hTsihBMUYC8FnYu0VhZsFqi7nRKV/QwrTDdLaiP4VTWavXganZ91ftNpKnsPsf2AiOyPARs6zEM34Y+LeJ5Gw1HRSB/5Hk6Y4GuQBxm4sWCFU+qmpae+Uj/7NO6PqGEr4Z4QoOvkHJz4VEno6aW8I2YXC9/XHhRqrVheW5I8iCMXlIMn2nrAoh9dKfn5DamqxfT/sVn4m15H3hUc9OUefNFRBNbr/Bgl9/7EzJNN2an2UntsrGPcmKy3nyl3f2WU59X6wnxYrsaQH7DTaYoCXygdujW6lTGhyHdWJ/+RkS6q0Ut/ls0M4BePClfQJ0RHLe2Hd5xY2i8DWbA34T4JGtm6bwEK1b8CB6N/LPkCriPCLyI07GlUlTTnbJeI1xESu4gmjgj689XTMozop12CE9cxJA+7YtJ+letkQNNQe8h4iKKVBAcwZSwx4BJumy/JxWdSX9cv/vGPF+kJ9UyjlhN1ROZIf9nzgysxduCV0l5i3VHPmmhfzbfEBbutwrjcoU9ygzb7oexOS3/XDb/584BpgnAjFYiyrXHQkrr20FXUnxHhwJTRKz4g+4LIo1cp6Vq4qtmeH+8ijBd72qtvaIEOGv0LBVwG9tBa1g8o4cJWOcVbnVl6iQ7N2nVLvSGlMH8stkmU1QDwxOSgDTLHpFy1JgcS1bwa8b
 IyAg7kl5
 rbIludSXEWVfdetEB3fP5Lw38jpnVCDnW5wfZqZnyOt/ihZNb2GrWNzKSOHywlsWDLPq+5vub2i0LjeNf0YEw1yYsEzEzqwOAsr9g1rebVpM8QF1QvOnWCyO5Fd5m/7F6i9WA3qwshqdJBIjoXBZPr0+vMws0kTl9jZw6G7cuJiRtb6DFqoJDTA9n3BCxM2Kcu6XhSrAOujK4i6PxZ6A3wgSsQcROgVvgowTy+getQh9KySliK2JuDGt8Q5mynb9H5MT3LoFPW4fjCLehl/aCol3v2IgwoRAB8DetrseeCBjH4EEXcw/QFGfAz+DfGfR44Zm6lbVhf8iexeJHVXGnDGuvMenMAwo3e781nj/R40ju5kaZZ5MFnbYPttT2qe0dBlL3oXymxRLDd+46bTNmqu/hIg==
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

Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-8-7190909db118@kernel.org
Reviewed-by: Hao Li <hao.li@linux.dev>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 3a34907b881b..a975a2e727c8 100644
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
@@ -3398,10 +3399,6 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	if ((alloc_gfp & __GFP_DIRECT_RECLAIM) && oo_order(oo) > oo_order(s->min))
 		alloc_gfp = (alloc_gfp | __GFP_NOMEMALLOC) & ~__GFP_RECLAIM;
 
-	/*
-	 * __GFP_RECLAIM could be cleared on the first allocation attempt,
-	 * so pass allow_spin flag directly.
-	 */
 	slab = alloc_slab_page(alloc_gfp, node, oo, allow_spin);
 	if (unlikely(!slab)) {
 		oo = s->min;
@@ -3438,15 +3435,17 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
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
@@ -4482,7 +4481,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	if (object)
 		goto success;
 
-	slab = new_slab(s, trynode_flags, node);
+	slab = new_slab(s, trynode_flags, ac->alloc_flags, node);
 
 	if (unlikely(!slab)) {
 		if (node != NUMA_NO_NODE && !(gfpflags & __GFP_THISNODE)
@@ -7230,7 +7229,7 @@ refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
 
 new_slab:
 
-	slab = new_slab(s, gfp, local_node);
+	slab = new_slab(s, gfp, SLAB_ALLOC_DEFAULT, local_node);
 	if (!slab)
 		goto out;
 
@@ -7578,7 +7577,7 @@ static void early_kmem_cache_node_alloc(int node)
 
 	BUG_ON(kmem_cache_node->size < sizeof(struct kmem_cache_node));
 
-	slab = new_slab(kmem_cache_node, GFP_NOWAIT, node);
+	slab = new_slab(kmem_cache_node, GFP_NOWAIT, SLAB_ALLOC_DEFAULT, node);
 
 	BUG_ON(!slab);
 	if (slab_nid(slab) != node) {

-- 
2.54.0


