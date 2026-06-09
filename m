Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9A44CD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AB556B0093; Tue,  9 Jun 2026 05:18:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 582A66B0095; Tue,  9 Jun 2026 05:18:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C0166B0096; Tue,  9 Jun 2026 05:18:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CFB36B0093
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:18:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D6AB91404A6
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:08 +0000 (UTC)
X-FDA: 84859822656.06.229DB89
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4A21A100007
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XkiEQzgM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780996687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=weO6c/1G9Hrx18MM2p1O4dDAw1r/wQnymnAXQ1WYRCQ=;
	b=3KfosjyeM6BHqKnL21grlY2CYS4I3wRs5nsNq7DkFZmMBviQtCWsRIW2c7DHOg1hW4mtM1
	0kp4zUTku9O0ighKOdlJGVk/tMu0sRnPqVQc1i0UtdidLc7DZOsSJa23f2zi+6WrOu2elF
	5DIEqUKPT7NzL78CeQ74GsCqLbuhar8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XkiEQzgM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780996687;
	b=qObVhgha0FGgtr0Pl6hY7l01NnzpguFcANvkcwlorcOh96MVZF2cEuoK56vgRlTm7vCLpj
	rwZSZu4UTuNRyKNpiCLCt4LhI9ytm8oD7U1FqKO9e3u0rZ6WaBjZfCi+d+Bheu4dUNwEQP
	q/0h+qHQuugdtWOtVssQGxedxBzrNrI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C3C2E601FD;
	Tue,  9 Jun 2026 09:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052DB1F0089B;
	Tue,  9 Jun 2026 09:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780996686;
	bh=weO6c/1G9Hrx18MM2p1O4dDAw1r/wQnymnAXQ1WYRCQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XkiEQzgM65eRzR9w3QxLA4cK5j6i33PhkjrObytF8KmOdNLSlripy9FAjHUCHYMm2
	 Abi2RR+kKce8qpTquTUyAL8vyTuc3eJwKtEvvaAdjmgZ9eX8xmN/epXrENYlqjpTEB
	 dK3P6K2xRX+Kh1q+/zRlwKlw0nBqOvaqOP/1Uc58BCHYlZbFSgrK3fI5HW0q2LqnCs
	 866So9kzR3HmNmGs+eRngdf3zRhwzPwa1zSqkMU1QaN6kXme1g+1MgYv4ILvFEwwre
	 TmRPS7hqTvQ0fYaA+OITuI6apIFs3pAC6p+ROBgrei5iW1a+SR1Ka0ct5P8RkYAZQh
	 rFk+XJd4cQoGg==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 09 Jun 2026 11:17:48 +0200
Subject: [PATCH RFC 03/15] mm/slab: introduce slab_alloc_context
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-slab_alloc_flags-v1-3-2bf4a4b9b526@kernel.org>
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4A21A100007
X-Stat-Signature: sbi1f451a3sewoqm3tcbhpcaan5683ja
X-Rspam-User: 
X-HE-Tag: 1780996687-425037
X-HE-Meta: U2FsdGVkX18lWl2IM5LEAgwqPabnIGByaStUymx8FoCtfaN0uXpAHqw0iSEWugCtWVQT6pH1Qzz4bDcA1pi7OxHuPp58euT1Hnt3FL+aarpkWoBo/m1D4Pv3PQJHWA1atFtuS3AbIiLNNXnS4LERRhywViNIf36MZoXWqiH86EyNnrUPwnulY59/1gohgAS83M9uA6nTAmmAP7fAIpdBcwuTmvv9hORnqdqaujDy18MVcaJEfScRzl+qjjCYbjsyrffHpfiBmxXZHh3n9WG10D3OYr8J7JybLZN5CLP2+40kJdSeYIuzj4f3lbmA7nTNKz1EogF1BDmULlcEckVClXcHsSRarvRUudPGOLszzC8C80/FQ/gO+63le3y86wUienvUc6Q0p+npYgO+VsOR+z7FdTxtIkQvjd00NyGhalPck1+wkTUFHb0jVWxAVqMKXPje1TuTYrklOxltvZTDc3yerOKs3rDDHchirHcOhSRLOrUBsXm4X5NUCAxturrSXRNLpz4mbAQQL0Lyx3lmgRH/A3tY4MBS0pvaiy3N/6Qu8BiO3dQbIOR/6dZUe5O+7A9q27pjurul9kf5U+DfT9V0zRpDm5DUBEL75rrQu0u4djawPXm5TwFqMCOppcginusQZHYzcWDStVUlJcFZD0IIzAgc+5nPvCn6GUJr4JSUfXIY4zBH0zoLLYmoISZKpjNlH5o9seTDW6QAa7si4mxVvPyV9KmWSUitxW13PKvA2Y9qALltKNfgXdF0CxRrNU6XYO/d+bOcrMqN3lRE5oj9zwwe2P7/lwvXIy/KulctOE6cHCRvlV3f/+bGsRzwOkAI7p12ZHQgCWoIKIT5tk0DmXkaR2Dsrft+bhFycq9hkYVneg+vtVIcoKoJdj/QFsh0Oj+EkYsM1XervZoIG42YM/Mx7d17AdQ8+lUPsRvbTCLR5/SYFBlXc/+dO2Y7s0OJICfyQar6P3hYKnv
 UJaysXJi
 EDdDDZr8cThX2hC2qtXi4AAe5m+KJ2acSkUVCFG6cOZDXv1h9ZNEhtTntcAoxMz0FptzIUAhmF6f6pOL9XhqQkwo5MEcn4WTwGbnP7lymlRMZ6oUYzojA2ri4OHo3OcitHwgXXKHW0OJ73Nw+CseYJjaCb5X74seW4c2mCgUVkQ7GupDM1+WvwFxe7cHA1OFmmtVbeL5ez11cFBzy497s8Z3XPlP3j6Tb3PxBRMx18ul6wJkqKku2/zrLtOIydwrpElNknI+iN/Q/WGwg0bB790ciYYeAzG41menX
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
index af85f338db4f..06fc1656080f 100644
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
@@ -4907,8 +4914,13 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 
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
 
@@ -5373,13 +5385,18 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
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
@@ -7221,10 +7238,13 @@ static bool __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
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


