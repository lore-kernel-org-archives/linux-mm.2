Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8421DCD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:18:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED3EC6B0098; Tue,  9 Jun 2026 05:18:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E35666B0099; Tue,  9 Jun 2026 05:18:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72DD6B009B; Tue,  9 Jun 2026 05:18:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C7EF06B0098
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:18:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A14161C1039
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:20 +0000 (UTC)
X-FDA: 84859823160.26.7A076D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0A013180004
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i0pCMfID;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780996699;
	b=08e++Bz6DggQyGPSIMKhdUClOkFsqSsmKmNkk0doRqioyJ0NqSXDBf1ARLcoVI3SeeR1Md
	zCGc4Dclkl/31f/54IrJJN7SvVWDnyK0OXK3LUWR6sEgwHqPhaRHIqOnme0bcM5mdx7Eza
	58cMqqEHWBPbKDEJRTDbU1SOjtsDnbw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i0pCMfID;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780996699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vfE2JW2NevESnpLgbLVUdD60WBjBFWnXxCfZNTt4csA=;
	b=TmZukTd+EsKdJJtj/7v9EhUdDOilcqqZv5Cfu2nfTR+AdDDNrXGSvmiG6nvGOgi7BjXGcd
	npQhg1djj1eFPKpW6qySFlmxpCDMwNkI/W8mfr/nLgne3NLAERF23pUdO7bPTAZGMr9aW/
	y+jNepBQ+EJM5k4mkYZnbKSuWLLrnEQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D9B760207;
	Tue,  9 Jun 2026 09:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4EC41F00898;
	Tue,  9 Jun 2026 09:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780996698;
	bh=vfE2JW2NevESnpLgbLVUdD60WBjBFWnXxCfZNTt4csA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=i0pCMfID9bPgEqXp+BuomAg5WrIvzYhOfvJqY8Ei3gYRGK/Z4sJZTnqnHcTvX2Mwi
	 0i3Jg6HQcgA/GmARey6i1OKtJw4jYxntAugYddhk7I6idIrD+LADXCIiZuEINYHl/s
	 tsm0ts8vxezmbqWW/6yZRrUbmc8+goIoZjbXFgoP1OkjoFi4tp9w4jKbcch8JUt91l
	 2WikOVyJiq2Tz49q+qC1aTfw2Yn4L6vHvyGbPtMwZ8Ea15Gtz8hST67xZymsAbRMR/
	 GxBWiQMeA/EO6CJfjzYSacyiFrXDdxl9iwYPYmZ5eK9Htm5modRwIhzeZk7vccurBb
	 xm8uC+Za6kDWQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 09 Jun 2026 11:17:51 +0200
Subject: [PATCH RFC 06/15] mm/slab: replace struct partial_context with
 slab_alloc_context
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-slab_alloc_flags-v1-6-2bf4a4b9b526@kernel.org>
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
X-Rspamd-Queue-Id: 0A013180004
X-Stat-Signature: ydzyrbm5oy7pqtriswxewem3fwmruu5z
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780996698-164187
X-HE-Meta: U2FsdGVkX1/jdTp33MCpoBBf2ljwhC0PvzRCgyVJpToEJQP1IhKk/eT+HSR6VQNoAdG/9mCHluSY4x+GyOSwbR3gMbbTM7NiQKbctgTzSW1EjhBlFVV5m2FzoPH92a2hoNkR3zZpDOHy/e+RlgiS39cYFpAEZpTIg6v8Y+LzWg6Jz5uTbtXhsCs+FzqPmSOrNUOJAwyQslkD9XCZIsIyKPP811pw63jrY5ljRxwDs3MnmhYVuw+INscMv1dr3cRKvs/2bWItuQbGA5hKaOCXW+3qv17gw5Ujs0ZrSm7E8tjJC+jddF/9z873t06dzlINja6sqNHdBrJ6wI0wMWuyj7QaOO7G6nux2Rn/thbN15mGnO/YWIbQD4RKAABjeV21HhlZY3h1XM1Fw1YOH2eIXj4Q4eBwe38WgaU7baan4+OICvoIfeCvbVWo/pqYf/wAN/4xmrws/yJ4dv0zuOAsn8SkVNQ5iJgdyFupXsgDzgR9HG0rmPZig9Okq/7XrS2kKS4A9PR3j5K8Ji2VEebwbtef36JQbraG3IT0Ux6ER3showVBQ+j6VR3jNF+UROWVpKpBA6BH6EkQc5Z/gmOXf540lvOZ8vZS7XHHhxSbhFfi6beKXv22wog7Twob1l9kqmtV4PQKklZE1ipHKaEYuy0gM3POEIsBakP7TOL5U2qpVZwsRCz6hW45kJrypVgmkgrIm2QHnqp3nv1Qn5rc0GUDrr6LqmZpx9HKOiPSgVkwrDuJ1ffKNMbsoBkXfiQ30wmIBuXY3K+UmPpOZ5ZCuuy4FhmhFl+Pm9SXt+5wvuW3+fDlvljezwaWdnh+RzZpCmeZs7njF3tPC5P5i13JKCZUWjHC+E/OLTbjcLksbOC5yo7BHYCjp9kc2V+bblvOslgSzK/Faze4CP9f2/uEk5YfYNz/eVPYWOMlHu/ncETeH5XPyZrqahkpTgU3pA8XXTkMDKJRFVLzT2S1mrM
 a9+jE2UJ
 gwW2y9+cVY4nm7suq6SidHtQCvIwmmRSVv20sgOK/ysI7QqSm9fP2gWsXPV/IWJ5GZ4TBu2DMbtypFUCpaj0X99rZ3y3kPN4n5WphRM4OQaSrTJIPBbGoTyRuYdzblzy1yT2f7spGYpan5i3ayEPqAsdQbI3RRpsD8YGc1zdnTe+xG5xvonDjW4UF7NFUHOxkc/NgG1vTNVtPBGX1g86F81NND6hqCsy5twY15O7ai/ConLWWFjEWpA462Ipyeb4cqpc9at/dRgcv/PSAlbjNfcYDMH0iFeQWVx4E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor get_from_partial_node(), get_from_any_partial(),
get_from_partial() and ___slab_alloc().

Remove struct partial_context, which used to be more substantial but
shrank as part of the sheaves conversion. Instead pass gfp_flags and
pointer to the new slab_alloc_context, which together is a superset of
partial_context.

This means alloc_flags are now available and we can use them to
determine if spinning is allowed, further reducing false positive "not
allowed" in the slow path due to gfp flags lacking __GFP_RECLAIM.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 52 ++++++++++++++++++++++++----------------------------
 1 file changed, 24 insertions(+), 28 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b2a452dd70fa..0bde4f6d9126 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -220,12 +220,6 @@ struct slab_alloc_context {
 	unsigned int alloc_flags;
 };
 
-/* Structure holding parameters for get_from_partial() call chain */
-struct partial_context {
-	gfp_t flags;
-	unsigned int orig_size;
-};
-
 /* Structure holding parameters for get_partial_node_bulk() */
 struct partial_bulk_context {
 	gfp_t flags;
@@ -3826,7 +3820,8 @@ static bool get_partial_node_bulk(struct kmem_cache *s,
  */
 static void *get_from_partial_node(struct kmem_cache *s,
 				   struct kmem_cache_node *n,
-				   struct partial_context *pc)
+				   gfp_t gfp_flags,
+				   struct slab_alloc_context *ac)
 {
 	struct slab *slab, *slab2;
 	unsigned long flags;
@@ -3841,7 +3836,7 @@ static void *get_from_partial_node(struct kmem_cache *s,
 	if (!n || !n->nr_partial)
 		return NULL;
 
-	if (gfpflags_allow_spinning(pc->flags))
+	if (alloc_flags_allow_spinning(ac->alloc_flags))
 		spin_lock_irqsave(&n->list_lock, flags);
 	else if (!spin_trylock_irqsave(&n->list_lock, flags))
 		return NULL;
@@ -3849,12 +3844,12 @@ static void *get_from_partial_node(struct kmem_cache *s,
 
 		struct freelist_counters old, new;
 
-		if (!pfmemalloc_match(slab, pc->flags))
+		if (!pfmemalloc_match(slab, gfp_flags))
 			continue;
 
 		if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
 			object = alloc_single_from_partial(s, n, slab,
-							pc->orig_size);
+							ac->orig_size);
 			if (object)
 				break;
 			continue;
@@ -3888,15 +3883,16 @@ static void *get_from_partial_node(struct kmem_cache *s,
 /*
  * Get an object from somewhere. Search in increasing NUMA distances.
  */
-static void *get_from_any_partial(struct kmem_cache *s, struct partial_context *pc)
+static void *get_from_any_partial(struct kmem_cache *s, gfp_t gfp_flags,
+				  struct slab_alloc_context *ac)
 {
 #ifdef CONFIG_NUMA
 	struct zonelist *zonelist;
 	struct zoneref *z;
 	struct zone *zone;
-	enum zone_type highest_zoneidx = gfp_zone(pc->flags);
+	enum zone_type highest_zoneidx = gfp_zone(gfp_flags);
 	unsigned int cpuset_mems_cookie;
-	bool allow_spin = gfpflags_allow_spinning(pc->flags);
+	bool allow_spin = alloc_flags_allow_spinning(ac->alloc_flags);
 
 	/*
 	 * The defrag ratio allows a configuration of the tradeoffs between
@@ -3930,16 +3926,17 @@ static void *get_from_any_partial(struct kmem_cache *s, struct partial_context *
 		if (allow_spin)
 			cpuset_mems_cookie = read_mems_allowed_begin();
 
-		zonelist = node_zonelist(mempolicy_slab_node(), pc->flags);
+		zonelist = node_zonelist(mempolicy_slab_node(), gfp_flags);
 		for_each_zone_zonelist(zone, z, zonelist, highest_zoneidx) {
 			struct kmem_cache_node *n;
 
 			n = get_node(s, zone_to_nid(zone));
 
-			if (n && cpuset_zone_allowed(zone, pc->flags) &&
+			if (n && cpuset_zone_allowed(zone, gfp_flags) &&
 					n->nr_partial > s->min_partial) {
 
-				void *object = get_from_partial_node(s, n, pc);
+				void *object = get_from_partial_node(s, n,
+								gfp_flags, ac);
 
 				if (object) {
 					/*
@@ -3961,8 +3958,8 @@ static void *get_from_any_partial(struct kmem_cache *s, struct partial_context *
 /*
  * Get an object from a partial slab
  */
-static void *get_from_partial(struct kmem_cache *s, int node,
-			      struct partial_context *pc)
+static void *get_from_partial(struct kmem_cache *s, int node, gfp_t flags,
+			      struct slab_alloc_context *ac)
 {
 	int searchnode = node;
 	void *object;
@@ -3970,11 +3967,11 @@ static void *get_from_partial(struct kmem_cache *s, int node,
 	if (node == NUMA_NO_NODE)
 		searchnode = numa_mem_id();
 
-	object = get_from_partial_node(s, get_node(s, searchnode), pc);
-	if (object || (node != NUMA_NO_NODE && (pc->flags & __GFP_THISNODE)))
+	object = get_from_partial_node(s, get_node(s, searchnode), flags, ac);
+	if (object || (node != NUMA_NO_NODE && (flags & __GFP_THISNODE)))
 		return object;
 
-	return get_from_any_partial(s, pc);
+	return get_from_any_partial(s, flags, ac);
 }
 
 static bool has_pcs_used(int cpu, struct kmem_cache *s)
@@ -4454,16 +4451,16 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 			   struct slab_alloc_context *ac)
 {
 	bool allow_spin = alloc_flags_allow_spinning(ac->alloc_flags);
+	gfp_t trynode_flags;
 	void *object;
 	struct slab *slab;
-	struct partial_context pc;
 	bool try_thisnode = true;
 
 	stat(s, ALLOC_SLOWPATH);
 
 new_objects:
 
-	pc.flags = gfpflags;
+	trynode_flags = gfpflags;
 	/*
 	 * When a preferred node is indicated but no __GFP_THISNODE
 	 *
@@ -4479,17 +4476,16 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 		     && try_thisnode)) {
 		if (unlikely(!allow_spin))
 			/* Do not upgrade gfp to NOWAIT from more restrictive mode */
-			pc.flags = gfpflags | __GFP_THISNODE;
+			trynode_flags = gfpflags | __GFP_THISNODE;
 		else
-			pc.flags = GFP_NOWAIT | __GFP_THISNODE;
+			trynode_flags = GFP_NOWAIT | __GFP_THISNODE;
 	}
 
-	pc.orig_size = ac->orig_size;
-	object = get_from_partial(s, node, &pc);
+	object = get_from_partial(s, node, trynode_flags, ac);
 	if (object)
 		goto success;
 
-	slab = new_slab(s, pc.flags, node);
+	slab = new_slab(s, trynode_flags, node);
 
 	if (unlikely(!slab)) {
 		if (node != NUMA_NO_NODE && !(gfpflags & __GFP_THISNODE)

-- 
2.54.0


