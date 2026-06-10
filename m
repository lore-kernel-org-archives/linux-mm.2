Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA421CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 15:40:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38A7C6B0096; Wed, 10 Jun 2026 11:40:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 361CF6B0098; Wed, 10 Jun 2026 11:40:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29F5E6B0099; Wed, 10 Jun 2026 11:40:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 198C76B0096
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:40:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BBE0DA0199
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:40:51 +0000 (UTC)
X-FDA: 84864415902.28.57857B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1E0201C0007
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:40:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jUeN5ldg;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781106050;
	b=dI/22zM9PxTJDDhg/hzkwGwUe6RtYXCWzkGIBYd2cobcRMBeJMdoSVcpfPJ2UweOO1r+rT
	wxybpNbP7kHkEfqqcz5x3yZy3lWVwN3UeZPmpVDpBtIqaW2BJQcC8HUymlcjdm+43hvUHp
	ieZBkF8iGYzFwbQ4xmIa6S7hF25FLpo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jUeN5ldg;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781106050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mHBDdnCc4cC9GbIMocm8Cn9JTTYjMC8IGCXXWTdvkjE=;
	b=69A3RvpoWKkXhd0JWoIbhR58PLWFAFns89bsoAZ5c5z0+udX2Ciouk0SMuL/lGUimMoLQC
	PHYrXMs0hvUdtz5Zaac8+fE/LiUC+i7lrgvLZ2v9/lgnsEFOJcfXWUNZ71yxYp+qGrc/ip
	7JkPEoZs3y34C5G4aDJC29GVXt/FCW0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AA15160172;
	Wed, 10 Jun 2026 15:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F611F00893;
	Wed, 10 Jun 2026 15:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781106049;
	bh=mHBDdnCc4cC9GbIMocm8Cn9JTTYjMC8IGCXXWTdvkjE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jUeN5ldgu0oUbTa5L0Rh2Xs6xUZN85uN8eqoJddnNtETxIYIaYEjtvAclPhIiGfLP
	 6CKzpo+NURrzjE+t11zkSW1RfAET41uBPnJAMdPKqdzic0fC8w9/MEX+i05ImnNnAj
	 d6FZwXd2dtz813RH/EuCbqLdr/MGPXkcD59zh+tkdgwlajUw9Fsj5rdrR5+jLU83nH
	 e0AaWzPDx+rQJ+9mARcEaN3Cma8Z5XJG1qdJ/j2+CHi/WJ79Dy4QKlq/BvKMgXb/Ys
	 jMeQECQQgGZd4a4CFHHPtAfZiXlfl7fEXdOxySu6Ay3Ot1WNKlZ+CHVk0+eJ8Ut7Mh
	 QY7Yg5fjK4xYw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 10 Jun 2026 17:40:06 +0200
Subject: [PATCH v2 04/16] mm/slab: introduce slab_alloc_context
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260610-slab_alloc_flags-v2-4-7190909db118@kernel.org>
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1E0201C0007
X-Rspam-User: 
X-Stat-Signature: eypfcfainc4k3ai1sk5xbkzrnkdqba96
X-HE-Tag: 1781106049-450242
X-HE-Meta: U2FsdGVkX1/Oeyar6OAAAo0NA48Qn1AKj7H5iZyiL0ZMadUyJ1fop2MnXi/NqngXKxhU+dNHak3SKdhGuV7mwaonFmYhFGFwiwYPdhmzJwtZHGekvOaR+CFQ85EpbiGGYNF4x+N2798mZazYTeXJiYzZZpP+bVmXjTU89AFtHpBYJHEojEbR3UiwZ8oZodh+KL4XT7FGdS0Qm4ReQ8bzol1VV6r7xFQEXz7i2V3iTLAkzQfnZTeyRbIEhHMkWye1btZ2s1wttI1urcmgZSbnqnuxeUV0P1jMraaJjoBVahur7fhxdXhAC0CGZBbnPnnJBGy/H57y++hRjcIA0HQbn6gIbQh+Afy2A7IudxeI3P9g0DeaKu8MBy7pZF0ljBXcQ+pOS9hNvZRh33LUEbK1P6uvU5L2lZ7e6BC7PvhyjjQO5y9tmT2zM73LztCJhYOA58l1AyaJ7mk1+qXEWI5GvE4bn1pI3a2r2opsSfJW4T8Bavak4Pb9z90Gpv6GOXPxc9+sso2caB9yNpahxp07/IYHpduzf0xOTh44oIFFdik4SrGeVQ3Y2yp5doZRJa/1evnamFyVuWY7a4NQjHvoKLhQonAdHEFGCQK47OYXs/2D5PM5qAI4XnCMwg/J20V33WW7exMFERUYv7BkxWjQu/6g4j20kKnlQgX3a41aXlOtoBIRkHh0atSD1JkyHbieeiLZCqvMASmDfJilLtwwvMf+Yxizx+zWKcfQyuvBfGy6p6QznEOQ1kr3/mO3m7Daha4CxBhibuCLGoM7ciDcIgb4D/cFH01HvnDhcpDPzmr1wkkQGzL0/ms4zPDJAZuWn9NSDEvhpw8gnLnWfdRsRzPo/tmtYt7ieWqu6JPs59T6adEtBwQaUGRmgxAE+9LWOcpHtKHmFIoE5qE7X60oG2+sQt1M7LL6p+RI+BmVI2Dk38x2E/8tQD1i+XICIw7W6VHzC7ObSX9nr8VmiOM
 O4MTEL7G
 /iBkYt6t2pzfNsng8UhQwyA/QrkkViVTeMKQVB09SLsQXFZETmdULdqDay33DUzd4In/T5+GI91/CccOvxQ4aK0rq2l/CpnGv0YJiaCIIXkoz/Lny9GkFPSarFM/wQp9pPI7U03qiYCaV+Um6rUaXoHHvD42ir3yejpHHwq6vnASFzXRR0/yIKCTqnZSJu98zo2IHebmh5UtEE9NsDvSFf4fzeEO4x7FgvvToXjuxY1p1iy1YuwwBZwIDYXiXVv1rAvQQxNOqmPu0GZmMVOoHTLhSo4iZ7s2KzgPi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Similarly to page allocator's struct alloc_context, introduce a helper
struct to hold a part of the allocation arguments. This will allow
reducing the number of parameters in many functions of the
implementation, and extend them easily if needed.

For now, make it hold the caller address and the originally requested
allocation size.

Convert alloc_single_from_new_slab(), __slab_alloc_node() and
___slab_alloc(). No functional change intended.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 46 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 13 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 7b48c0d38404..a3cac7281cc6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -213,6 +213,12 @@ DEFINE_STATIC_KEY_FALSE(slub_debug_enabled);
 static DEFINE_STATIC_KEY_FALSE(strict_numa);
 #endif
 
+/* Structure holding extra parameters for slab allocations */
+struct slab_alloc_context {
+	unsigned long caller_addr;
+	unsigned long orig_size;
+};
+
 /* Structure holding parameters for get_from_partial() call chain */
 struct partial_context {
 	gfp_t flags;
@@ -3687,7 +3693,8 @@ static inline void init_slab_obj_iter(struct kmem_cache *s, struct slab *slab,
  * and put the slab to the partial (or full) list.
  */
 static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
-					int orig_size, bool allow_spin)
+					struct slab_alloc_context *ac,
+					bool allow_spin)
 {
 	struct kmem_cache_node *n;
 	struct slab_obj_iter iter;
@@ -3705,7 +3712,7 @@ static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
 	/* alloc_debug_processing() always expects a valid freepointer */
 	set_freepointer(s, object, slab->freelist);
 
-	if (!alloc_debug_processing(s, slab, object, orig_size)) {
+	if (!alloc_debug_processing(s, slab, object, ac->orig_size)) {
 		/*
 		 * It's not really expected that this would fail on a
 		 * freshly allocated slab, but a concurrent memory
@@ -4443,7 +4450,7 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
  * slab.
  */
 static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
-			   unsigned long addr, unsigned int orig_size)
+			   struct slab_alloc_context *ac)
 {
 	bool allow_spin = gfpflags_allow_spinning(gfpflags);
 	void *object;
@@ -4476,7 +4483,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 			pc.flags = GFP_NOWAIT | __GFP_THISNODE;
 	}
 
-	pc.orig_size = orig_size;
+	pc.orig_size = ac->orig_size;
 	object = get_from_partial(s, node, &pc);
 	if (object)
 		goto success;
@@ -4496,7 +4503,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	stat(s, ALLOC_SLAB);
 
 	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
-		object = alloc_single_from_new_slab(s, slab, orig_size, allow_spin);
+		object = alloc_single_from_new_slab(s, slab, ac, allow_spin);
 
 		if (likely(object))
 			goto success;
@@ -4514,13 +4521,13 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 
 success:
 	if (kmem_cache_debug_flags(s, SLAB_STORE_USER))
-		set_track(s, object, TRACK_ALLOC, addr, gfpflags);
+		set_track(s, object, TRACK_ALLOC, ac->caller_addr, gfpflags);
 
 	return object;
 }
 
 static void *__slab_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node,
-			       unsigned long addr, size_t orig_size)
+			       struct slab_alloc_context *ac)
 {
 	void *object;
 
@@ -4545,7 +4552,7 @@ static void *__slab_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node,
 	}
 #endif
 
-	object = ___slab_alloc(s, gfpflags, node, addr, orig_size);
+	object = ___slab_alloc(s, gfpflags, node, ac);
 
 	return object;
 }
@@ -4923,8 +4930,13 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 
 	object = alloc_from_pcs(s, gfpflags, node);
 
-	if (unlikely(!object))
-		object = __slab_alloc_node(s, gfpflags, node, addr, orig_size);
+	if (unlikely(!object)) {
+		struct slab_alloc_context ac = {
+			.caller_addr = addr,
+			.orig_size = orig_size,
+		};
+		object = __slab_alloc_node(s, gfpflags, node, &ac);
+	}
 
 	maybe_wipe_obj_freeptr(s, object);
 
@@ -5389,13 +5401,18 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 	if (ret)
 		goto success;
 
+	struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = orig_size,
+	};
+
 	/*
 	 * Do not call slab_alloc_node(), since trylock mode isn't
 	 * compatible with slab_pre_alloc_hook/should_failslab and
 	 * kfence_alloc. Hence call __slab_alloc_node() (at most twice)
 	 * and slab_post_alloc_hook() directly.
 	 */
-	ret = __slab_alloc_node(s, alloc_gfp, node, _RET_IP_, orig_size);
+	ret = __slab_alloc_node(s, alloc_gfp, node, &ac);
 
 	/*
 	 * It's possible we failed due to trylock as we preempted someone with
@@ -7237,10 +7254,13 @@ static bool __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
 	int i;
 
 	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
+		struct slab_alloc_context ac = {
+			.caller_addr = _RET_IP_,
+			.orig_size = s->object_size,
+		};
 		for (i = 0; i < size; i++) {
 
-			p[i] = ___slab_alloc(s, flags, NUMA_NO_NODE, _RET_IP_,
-					     s->object_size);
+			p[i] = ___slab_alloc(s, flags, NUMA_NO_NODE, &ac);
 			if (unlikely(!p[i]))
 				goto error;
 

-- 
2.54.0


