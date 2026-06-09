Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8201CD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:18:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 201E56B0095; Tue,  9 Jun 2026 05:18:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D9CA6B0096; Tue,  9 Jun 2026 05:18:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EFCF6B0098; Tue,  9 Jun 2026 05:18:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F2C6E6B0095
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:18:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA143A03A5
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:12 +0000 (UTC)
X-FDA: 84859822824.26.E689634
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2CFD34000D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bljgESA/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780996691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D0jKKYeVe3GOsHiT9w2I0J78neM62mSyd5GKmJH2d5I=;
	b=OCpACyDe/jCfK2j1BF4QR+dG8E/vyyRbMIgfmMhMZ+iHE4cbqAUjyz2ldz+sglPhseSRS5
	4dO2xkMpze07NZ1B4cM0n9Ktf76jWlR172z9jgeevsEb3qPBcTZ1jpfLT42NX3bsZ9LkGJ
	IS1bShp4CnXzwthB8tjFUTRAKYvSgd0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bljgESA/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780996691;
	b=T/PpVCUUpg4pXOJ+300+2tWmA5Xvpo1BVz7yKTDps2PkiHw0sLMbjK5OiYNNMuUpXnb6Jh
	VPv+LHIO3TaRmo+anpzuqcOwmcgda1vs4Emczvw2oewNBrHprMRLy7p69KQeyfqIVCeRs2
	QDQ4/MypyFEEDfBvkj37oBKngzt7q48=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B2EC96020A;
	Tue,  9 Jun 2026 09:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80C61F008A1;
	Tue,  9 Jun 2026 09:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780996690;
	bh=D0jKKYeVe3GOsHiT9w2I0J78neM62mSyd5GKmJH2d5I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bljgESA/jqmLYPOioHWBwsF8jHKWn4DOAoZBVAKxkywX+5Bf74eaadpUyEuoLLVkm
	 hQv/E4KkGHbO4sbCaR99hIFpwTRlnzKda066KDq0Nh8iAaj1shfHlwZ9CVBUcW3n54
	 6j/O1/6JpQzHWQymZxABYN1ZbyjRN4/VFkCC0HAKgevx9KZGkW1X5ehAndML9xQI4D
	 Rf8ilzwltkI07ufLvxxW2v5nJRZtKg1/Uqsh3iaP4YDVkD+Uj5TQMFklq5JlgEdG4o
	 Co1XBUCYvgDD2R42QFMsvEbBrs7WpuJDU7uT7Qg5flrB49iW5znSMcxKoLfVXwdWTT
	 2WEoJz5Ces8zw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 09 Jun 2026 11:17:49 +0200
Subject: [PATCH RFC 04/15] mm/slab: introduce alloc_flags and
 SLAB_ALLOC_TRYLOCK
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-slab_alloc_flags-v1-4-2bf4a4b9b526@kernel.org>
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
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: f99wybutcxk67spdeux3wiob4m84qn6j
X-Rspamd-Queue-Id: 2CFD34000D
X-HE-Tag: 1780996691-917500
X-HE-Meta: U2FsdGVkX18CTdYBL0bAM1I7MpyQ2r8PjB3/m0ZQ+Q04FZU/fdcri1SdIv8WFCPzSYVrywU5vxDBO39PYoFW4zqJL/nl43Bq6mqFdRPO/olOBfuBVJno247u0Hd71Rqlu4opi0HQh6oJdXBuhCVyx1mue9Bmf1YiSmKN599ommtGwyOimHSZSYx2HmEqp2VkO2u6pbcCGousWvSAmlhLtlYFcmCg2wTphrztLhq2ypfNO/f5+30Tu61i0jV92diJNHQgvljwPk8SsJZEtzePI18k6Bemh8Qq5u7AFMIyfAZHgjUiHayUi/wmwpUC/lbaa1yLvwTDbXHmJWAYbVdaK3BDh1jl7U6aVQJulmoxq/dIpvry046U7W9zxL+BZz2eZOH8YsmPJXqXcW4wNI8hofMe2jeHJ6wsHbmoYOB0O3gnLb19GLYZLr9bq6Zg5b4CUBTMPMxn7Q5vImA+52HVMZl/HvxsFgIXd/oUmIK+heJ9OEyMZszYWhbrEAGLdR2rzaNY7/ITyi1HRwoWZkTPZqITkb5055HsO5y9K276JKuP0di5VflUtR+v1OiKJMBuHR8OQYzWikjU9zak/Srqo2qT4iL2rDQD1KZthiIh6YNdeuw5Sg/quA1R0O1LkDRHJF+DUOknp0hqajY5NegKf8DWO6p9JpDdfweBqaQSXRqGgzXmWKAh2UD7WR5y4uQaE54q5yMsBw66fvrqkJsIaSM16VKVWPiPl4yidC8fiOYVHgoRu38D4Mntu773VRS1hk2fH5FO0bgoCOqkJJ20ln0hwRiPgeZoEGlAQMJ/8yORacyk0WHE0YI8yTkix+/IIXPmqA6O119VASKVQU4mi1I72+El+WJyVj73C4BphuVkqQgbFYyMpbeFP5Zftnamvedd/Jxgw8qEOS+5kZJ5vgIM8hFWfLIuMmWPLOghh8BVT0yPaJbUAJJbRxJozWF7e8bTVJgwWLvwUgPMqjM
 JdN8zai8
 /Y9BUQNZbK0MMaYyl+BM4lDrOQbMuCJG3CCKQZD033yKlY1L12mXeyCVmFJP5ITeskzVOL2GExvJVesTT08DDvoGGbyUb+h1gI2Hd5Gj0jTlMikO26qbr7E5gP9wHmMfsXvQdZNRJcaiOS31biheAuC8SAxupeN0/khnzBpXttZLwQLkhSbjlNs/3gUFHBlOTvGfyM5NSAE1ZRD5rXsLUPMbnD/fekNpo72LBEwFZ184qAn2KSH9rrvxexmZoghEYGvUgAtI3v6xmYmZ45vviR9ipoaLaW6AVXO1o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Similarly to the page allocators, introduce slab-allocator specific
alloc flags that internally control allocation behavior in addition to
gfp_flags, without occupying the limited gfp flags space.

Introduce the first flag SLAB_ALLOC_TRYLOCK that behaves similarly to
page allocator's ALLOC_TRYLOCK and will be used to reimplement
kmalloc_nolock()'s "!allow_spin" behavior. That currently relies on
gfpflags_allow_spinning() and thus the lack of both __GFP_RECLAIM flags,
importantly __GFP_KSWAPD_RECLAIM. This can give false-positive results
e.g. in early boot with a restricted gfp_allowed_mask.

Also introduce alloc_flags_allow_spinning() to replace the usage of
gfpflags_allow_spinning().

Start using alloc_flags and the new check first in alloc_from_pcs() and
__pcs_replace_empty_main(). This means some slab allocations that were
falsely treated as kmalloc_nolock() due to their gfp flags will now have
higher chances of succeed, and this will further increase with followup
changes.

Remove a WARN_ON_ONCE() from refill_objects() as it's now legitimate to
reach it from a slab allocation that's not _nolock() and yet lacks
__GFP_KSWAPD_RECLAIM for other reasons.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h |  9 +++++++++
 mm/slub.c | 17 ++++++++---------
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 1bf9c3021ae3..3e75182ee144 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -16,6 +16,15 @@
  * Internal slab definitions
  */
 
+/* slab's alloc_flags definitions */
+#define SLAB_ALLOC_DEFAULT	0x00
+#define SLAB_ALLOC_TRYLOCK	0x01
+
+static inline bool alloc_flags_allow_spinning(const unsigned int alloc_flags)
+{
+	return !(alloc_flags & SLAB_ALLOC_TRYLOCK);
+}
+
 #ifdef CONFIG_64BIT
 # ifdef system_has_cmpxchg128
 # define system_has_freelist_aba()	system_has_cmpxchg128()
diff --git a/mm/slub.c b/mm/slub.c
index 06fc1656080f..278d8cbcc7ee 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4622,7 +4622,8 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
  * unlocked.
  */
 static struct slub_percpu_sheaves *
-__pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs, gfp_t gfp)
+__pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
+			 gfp_t gfp, unsigned int alloc_flags)
 {
 	struct slab_sheaf *empty = NULL;
 	struct slab_sheaf *full;
@@ -4648,7 +4649,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	allow_spin = gfpflags_allow_spinning(gfp);
+	allow_spin = alloc_flags_allow_spinning(alloc_flags);
 
 	full = barn_replace_empty_sheaf(barn, pcs->main, allow_spin);
 
@@ -4734,7 +4735,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 }
 
 static __fastpath_inline
-void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
+void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, unsigned int alloc_flags, int node)
 {
 	struct slub_percpu_sheaves *pcs;
 	bool node_requested;
@@ -4779,7 +4780,7 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
 	if (unlikely(pcs->main->size == 0)) {
-		pcs = __pcs_replace_empty_main(s, pcs, gfp);
+		pcs = __pcs_replace_empty_main(s, pcs, gfp, alloc_flags);
 		if (unlikely(!pcs))
 			return NULL;
 	}
@@ -4912,7 +4913,7 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 	if (unlikely(object))
 		goto out;
 
-	object = alloc_from_pcs(s, gfpflags, node);
+	object = alloc_from_pcs(s, gfpflags, SLAB_ALLOC_DEFAULT, node);
 
 	if (unlikely(!object)) {
 		struct slab_alloc_context ac = {
@@ -5343,6 +5344,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 {
 	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
 	size_t orig_size = size;
+	unsigned int alloc_flags = SLAB_ALLOC_TRYLOCK;
 	struct kmem_cache *s;
 	bool can_retry = true;
 	void *ret;
@@ -5381,7 +5383,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 		 */
 		return NULL;
 
-	ret = alloc_from_pcs(s, alloc_gfp, node);
+	ret = alloc_from_pcs(s, alloc_gfp, alloc_flags, node);
 	if (ret)
 		goto success;
 
@@ -7200,9 +7202,6 @@ refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
 	unsigned int refilled;
 	struct slab *slab;
 
-	if (WARN_ON_ONCE(!gfpflags_allow_spinning(gfp)))
-		return 0;
-
 	refilled = __refill_objects_node(s, p, gfp, min, max,
 					 get_node(s, local_node),
 					 /* allow_spin = */ true);

-- 
2.54.0


