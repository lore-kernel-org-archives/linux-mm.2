Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E6A1CD98DA
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2D5F6B0098; Mon, 15 Jun 2026 07:55:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E05646B0099; Mon, 15 Jun 2026 07:55:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D429D6B009B; Mon, 15 Jun 2026 07:55:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C78D46B0098
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:55:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8F5C91409CB
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:55:06 +0000 (UTC)
X-FDA: 84881991012.11.F6B879A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id E43D9120005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:55:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XZorzDkk;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781524504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G2X5hpGdNDsHWaRqNjT3IegqGlojYoq+qbTKUu2hAO8=;
	b=HWjxMBy2mmO5zzTpZbpvmeXA0nJ/oo6fzy21w5KtPuZiU+XXilaWjAkkTLwnCNc4AA7x81
	4thKjLQlBm3yLRBU8b0n84817nnEmECM5XOgRndHi9la2uRP0RUPls/6cc6EPhZrGG7wtJ
	jMLhhUbfAo5zySta43O9Yl1dadxPk2I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781524504;
	b=5KIvB9dGDxhe0Gm+RRy5Id+EkSg8f6lfr1tvqDdFSMSyuyjZlKHdMHQgB4pTOiqlLxCN5d
	oMUf/wDS4tdaG4i6Xwc/BLC3E6Ab1RbhcM8Nh0399uc7DtFoMHEgLnGSU0X1VnXXQwG4B1
	7NfcXhxlhcF71hFRBVGok9OqUD8Rtuk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XZorzDkk;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 769E7601E5;
	Mon, 15 Jun 2026 11:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB061F00A3D;
	Mon, 15 Jun 2026 11:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781524504;
	bh=G2X5hpGdNDsHWaRqNjT3IegqGlojYoq+qbTKUu2hAO8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XZorzDkkFgRxREpwnq3eFbrbpYQYTpiJWBwxZnQwQjk+kpFhkW4uaZhIK6NqK9xXu
	 7afxpkHkrRZ4AXcaqxeP43g02XWkA/5VSygjZ7GALMY37ygbDa9IOns+SN9govHI2W
	 zXDg/OIkrTnROlKylHQugR+pE5iI+79y81OsOTVy7ukRJu5M35REaKmzgAezB6IwER
	 4axtdXNQNXDQAAmzJslrkMf8hqrzgIbEI1ZjxobJ5rcjr9gp8pxx8GMl/8Y9hbLH+x
	 2T80ZwSM5JFBEiCzDxmuJt7c4Xa6Ye9CASgdtuqtipFKi1Di4x91MA41HDJl9mJBuN
	 PngPS6ACMz9Fw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 15 Jun 2026 13:54:38 +0200
Subject: [PATCH v3 05/15] mm/slab: replace struct partial_context with
 slab_alloc_context
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-slab_alloc_flags-v3-5-ce1146d140fb@kernel.org>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E43D9120005
X-Stat-Signature: 337yfs7q9pp6k9rnby8ou5u1nmithrra
X-HE-Tag: 1781524504-103230
X-HE-Meta: U2FsdGVkX19RScAS0FyYqHV7zMA1VjwumF74kbZaDpNyiodZXCEf4B646MksMtoiSYX4sy15DSSY/gdebHf8F1s4S83WHmfF3duD05FEC06GTwOhqaSR06KKZ0DWB6mKuo/HQlZs6MAd5aS7uwFcJwWhJjh3E42qYZ4IQvPNbdaIEHkSoICrn/CgSVUQbwvD32rIIlBVmmKptQbMSEWWDUWfg/bBNqO5oatH3TDHnxonwABupFTzluCf/U/PavDLo/KDUxGW5RtP71I+qqpk25/sm6EL/J7MbKXPAiYxgz5237LfFx+QpVe8+CaGqqh0HRz0e+6lkaNvMst1QHy5AcASZI1NQQIo0CCIL8MqS/K4BaTqFiEr/8PtFSTymclaZkGLCLqGUxOG9Tr7ekWEPtKYhh4rBjsQrXliVfuaUWmyKHDH0PvCoHlRAlY2KTzegM1dLExcGw5q7oCIAiUx6nPAVOcG1h5KeNgmeechPjgJ3qBMTGAHmVIFjVEA7J3eVuqXXbL/CtpEp8n+yyoyzI41/leWpg4QrbrRFCEiePpcylCQHL+ct+qk2Jj0cblrOymCuW/6ksnI1EXKbTiVHchD567v9jeVilDtIHM9t9vBwotjFwaXpCkrgYyvKY5ePIZQDAOT8WOFhawIbJqCnO6VkjQGGVzqx8yRKF6HNjegrh171QM7pYew02KgBaXq67d1CBfrZ8SRpu4tEy74wbXcclwx5qv41O6wBFxu6flDhBVTyxJ5cTs1S7Hg8X+eLERwvTrSH3nwSrzSidRz4pc5RGpTbUKIGETneNtDy9KI9HqAokHxo+klE2y+Z1WDNGAbFfbNyAPmDA2vMYM2gt1dNNh5PmQ163sjrXCsz7PJ/8/t0jflmsA/Ti/R3xqP/30S7W85jwAhrnBpq9VTKu0R1Q1jL+nzJ9k7rX+XsclvImZ4FWYbM+zkemQS1RUxQdal0xmgGkQrMCFkCR0
 rsHsNhK4
 6xfdICwTAxgtzkrMblXTyMR/dnRwdqgfz/KKvH/Gol7So3SbErs+h65uvdbAVKnbc2gUYRxqAsz8OIX/R0eKP84/SgTCVqHM75JlrqGR53OwH/dnCKhbuGLGk7RnhT+EgU7NEHHk+claCA9Bg+uR2T68EUPJi016F4M7FzB+O/8R0P8r/VakSVOUw38wvclovxd0JOJfOsAEsbaAsCsedMihLbaaK3PqUT0v42HpJDApn8I90nwjUYgbGZTs37sbt4HN9ujiDlZu/DKC26jJZfsxf3/ehn8Pci+VG6z3Sv3+ocUvAhWB+3DimcoYjPcm1y8VeUZWMsgAObKRv1bKk06XnnNGz5l7ft+7FFQQWH6fWIAHAhAQHVlVKgr037Phiyei3yLvtEUnjQNc=
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
partial_context, and alloc_flags are about to be added to
slab_alloc_context as well.

No functional change intended.

Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-7-7190909db118@kernel.org
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Hao Li <hao.li@linux.dev>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 54 +++++++++++++++++++++++++-----------------------------
 1 file changed, 25 insertions(+), 29 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index c53592baa027..6f6c15d796e1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -219,12 +219,6 @@ struct slab_alloc_context {
 	size_t orig_size;
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
@@ -3825,7 +3819,8 @@ static bool get_partial_node_bulk(struct kmem_cache *s,
  */
 static void *get_from_partial_node(struct kmem_cache *s,
 				   struct kmem_cache_node *n,
-				   struct partial_context *pc)
+				   gfp_t gfp_flags,
+				   const struct slab_alloc_context *ac)
 {
 	struct slab *slab, *slab2;
 	unsigned long flags;
@@ -3840,7 +3835,7 @@ static void *get_from_partial_node(struct kmem_cache *s,
 	if (!n || !n->nr_partial)
 		return NULL;
 
-	if (gfpflags_allow_spinning(pc->flags))
+	if (gfpflags_allow_spinning(gfp_flags))
 		spin_lock_irqsave(&n->list_lock, flags);
 	else if (!spin_trylock_irqsave(&n->list_lock, flags))
 		return NULL;
@@ -3848,12 +3843,12 @@ static void *get_from_partial_node(struct kmem_cache *s,
 
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
@@ -3887,15 +3882,16 @@ static void *get_from_partial_node(struct kmem_cache *s,
 /*
  * Get an object from somewhere. Search in increasing NUMA distances.
  */
-static void *get_from_any_partial(struct kmem_cache *s, struct partial_context *pc)
+static void *get_from_any_partial(struct kmem_cache *s, gfp_t gfp_flags,
+				  const struct slab_alloc_context *ac)
 {
 #ifdef CONFIG_NUMA
 	struct zonelist *zonelist;
 	struct zoneref *z;
 	struct zone *zone;
-	enum zone_type highest_zoneidx = gfp_zone(pc->flags);
+	enum zone_type highest_zoneidx = gfp_zone(gfp_flags);
 	unsigned int cpuset_mems_cookie;
-	bool allow_spin = gfpflags_allow_spinning(pc->flags);
+	bool allow_spin = gfpflags_allow_spinning(gfp_flags);
 
 	/*
 	 * The defrag ratio allows a configuration of the tradeoffs between
@@ -3929,16 +3925,17 @@ static void *get_from_any_partial(struct kmem_cache *s, struct partial_context *
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
@@ -3960,8 +3957,8 @@ static void *get_from_any_partial(struct kmem_cache *s, struct partial_context *
 /*
  * Get an object from a partial slab
  */
-static void *get_from_partial(struct kmem_cache *s, int node,
-			      struct partial_context *pc)
+static void *get_from_partial(struct kmem_cache *s, int node, gfp_t flags,
+			      const struct slab_alloc_context *ac)
 {
 	int searchnode = node;
 	void *object;
@@ -3969,11 +3966,11 @@ static void *get_from_partial(struct kmem_cache *s, int node,
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
@@ -4453,21 +4450,21 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 			   const struct slab_alloc_context *ac)
 {
 	bool allow_spin = gfpflags_allow_spinning(gfpflags);
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
 	 * 1) try to get a partial slab from target node only by having
-	 *    __GFP_THISNODE in pc.flags for get_from_partial()
+	 *    __GFP_THISNODE in trynode_flags for get_from_partial()
 	 * 2) if 1) failed, try to allocate a new slab from target node with
 	 *    GPF_NOWAIT | __GFP_THISNODE opportunistically
 	 * 3) if 2) failed, retry with original gfpflags which will allow
@@ -4478,17 +4475,16 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
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


