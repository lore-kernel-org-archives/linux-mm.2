Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8F71CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 15:41:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33C906B0098; Wed, 10 Jun 2026 11:41:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 313BD6B0099; Wed, 10 Jun 2026 11:41:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 229C56B009B; Wed, 10 Jun 2026 11:41:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1326F6B0098
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:41:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B4E651C0CA6
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:40:59 +0000 (UTC)
X-FDA: 84864416238.24.99F8024
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 16B1440007
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:40:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aCXPhkm8;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781106058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uzrQqVr+7rwNnJX12Vdm6hcXiPQHxl3cGwRGRVjeEkE=;
	b=V+moxOJv/76K2hdwpFtSTT3BFUQ78ELvBxYkt84vxP3IkwcwqCgw3Dr1fr+l9BFC5xf4gO
	is0GCLnSdSEPisZ+Tmyoy3/52XnY42A9prTKQdSFDldSdgxyouOi5Ttcxx1zrMRHf0MIxU
	GUdCmJ97B2mOpxtUy3TRT+3KZzFPo7U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aCXPhkm8;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781106058;
	b=RHQhF0YT6EZeUiufFaSN5XcnZBqETF2y6xzrMmR8+eJ1RAdO5KtcA07WFFNXILVdmN8LGu
	DWQE0JEN+ZwkBPyMate4oC3IPisOnA9xpgMkc1BdqAlFBS6iiStWSoeDxD8O+saAr5uh3g
	q98X24RIXQu8BwlbjejZq2ZlavHBccs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ABDCF60172;
	Wed, 10 Jun 2026 15:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19E11F00898;
	Wed, 10 Jun 2026 15:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781106057;
	bh=uzrQqVr+7rwNnJX12Vdm6hcXiPQHxl3cGwRGRVjeEkE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aCXPhkm8nAkdUVhcPCJUTOjkUtEJISo7BfGZrCD7i28tiCbagbHjNon8sAPgrzyYc
	 2RkRNiVBG+fSPgFQixWt62WNno7HDDOpVLkxlbVAOff0N2BRYxkY26fOCMQgqnxIQg
	 Vo6/+wKzhCMrPVUUkdYBvEko/zuKCyMmAc5ejtIHc93n94xPW9QfEejrYaYkqazkc0
	 TZ+dRNAy1COnYajg+g3r+nMP1/8JHCUZ3ShqlSynY7NQKWfgT6lUPu/5jED69sEsyf
	 rTxnFxgtwHqzh6qGp2iD7D9WVL1dU3WYdmEvzAnc8FubCtBIY8M6+XDQ9jNguIIFzo
	 OR6jq3M1atcFA==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 10 Jun 2026 17:40:07 +0200
Subject: [PATCH v2 05/16] mm/slab: introduce alloc_flags and
 SLAB_ALLOC_TRYLOCK
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260610-slab_alloc_flags-v2-5-7190909db118@kernel.org>
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 16B1440007
X-Stat-Signature: bfzj3w4oskuc4je9tr8mwysadanzxz84
X-Rspam-User: 
X-HE-Tag: 1781106057-286467
X-HE-Meta: U2FsdGVkX18Qz7yWm/SlT5Sn//tooMP/smEdzHZcVYQ9s4KuRMCggjKbmugU+4/ODmYGJB2XaYD7qg4gxY4f4kQugsZbBfXCCdyfB7xYr42IzhDOFCmCuQBIBfjxm0NTO2ttkxLGi3wzZIDnsIxu3FBm+dtXtsBZs3eUVB0LE90Snmiq9Pk99LlcoTlh4qboAQbN0Hpylm/jxUR3QWzqWeo1upboCtSeGwLKBCD0gMa0BHtf/59B27dpxI0eh/E8nJ4/2MqD77ZzWnrje+GPxVByeQqLxKEp3U72NxyJomCXRP1BAEVdpTqSr/82sgsxTu/KMSWN75q9jcfeX6HaUv9kKFzJihVPkqhqxsRntbFuj3xhNe2FpDSsra7RaxRcg8rxUXdbe3es1tSATrQ1cqk0Jy6DWB10n3Wj590qGMTBDAQCiKCyd+piv6wDQ3jQL+v/TcrOzGtMlTm2svQli+xcIMOCXuN7pMxvgVW71e1C++tPgX6LofVL+CK5Mpa1a4vNxJb+1tzdt63CiDUpjDJ7NFmOl86YjoEY/PB36HHRQkjULjkcF2ao9K/LuHYsTpes8dz8GDH/4h8F5Bcg69SWFbDq3mmNf4iLFWNhXxlz9oL5j/UJ8CzPGBzdSM37FotVgtP6JZxKXX39GcUnsB5UaOFOmmA1qk/ChNVeFnUiiJrqyyon64xDdmTPpc9nbE+RA/0nnI52TNFXewMwsTAB+LnRpHuB9sBHhWi+QtunrAxvFkLJJauyli9LrtByOXa+wS1zZbJEEraSyVtJ5oqy7VcY10jsdgGee/xNgxt7b5mh2b9TB5lARzybp00hYKhXjA5baxWlYg/+uDzJLQ38YjpN5eqKTNF9T1/dH7tH5dsLEahX2HUZQhPWJgUp8Ax05EKnD0CAtKO/Pzi77/Nl9OI8ljIan+5gPqmf4QnPj7VoCtAZdGmOLzvc1dakQ/pv0dyTCXgUM6i5C2N
 JrEfgW4y
 zSwv647r/8OCMSio9EpEYe/0qZsPMEdUv3Gr6in32K/GChARvPSI2RZVtXym1rZC7oyHE8XiYKgbcnWDmcxVVn+7Gl6xvJdk4QNoV/Qf7XzHN4OUiCyVdkijffsvC4BKN08TGxKL5RrzNh3SRP4gz/d+MGZ1S+vjpGjtHCPuJQFhIUeQq1d3LpSgxM5l0vR3fnR5/qi6j98kFckRdcHYgd7qnL6YNmEwEXblSpJwejP4li99VFA8D6oorYtyvhnKT6w1A0josZAd9ExjAIbHq52rYO6zW+RHw+Eno
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
index 1bf9c3021ae3..96f65b625600 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -16,6 +16,15 @@
  * Internal slab definitions
  */
 
+/* slab's alloc_flags definitions */
+#define SLAB_ALLOC_DEFAULT	0x00 /* no flags */
+#define SLAB_ALLOC_TRYLOCK	0x01 /* a kmalloc_nolock() allocation */
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
index a3cac7281cc6..e79fbca11bc0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4638,7 +4638,8 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
  * unlocked.
  */
 static struct slub_percpu_sheaves *
-__pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs, gfp_t gfp)
+__pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
+			 gfp_t gfp, unsigned int alloc_flags)
 {
 	struct slab_sheaf *empty = NULL;
 	struct slab_sheaf *full;
@@ -4664,7 +4665,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	allow_spin = gfpflags_allow_spinning(gfp);
+	allow_spin = alloc_flags_allow_spinning(alloc_flags);
 
 	full = barn_replace_empty_sheaf(barn, pcs->main, allow_spin);
 
@@ -4750,7 +4751,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 }
 
 static __fastpath_inline
-void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
+void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, unsigned int alloc_flags, int node)
 {
 	struct slub_percpu_sheaves *pcs;
 	bool node_requested;
@@ -4795,7 +4796,7 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
 	if (unlikely(pcs->main->size == 0)) {
-		pcs = __pcs_replace_empty_main(s, pcs, gfp);
+		pcs = __pcs_replace_empty_main(s, pcs, gfp, alloc_flags);
 		if (unlikely(!pcs))
 			return NULL;
 	}
@@ -4928,7 +4929,7 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 	if (unlikely(object))
 		goto out;
 
-	object = alloc_from_pcs(s, gfpflags, node);
+	object = alloc_from_pcs(s, gfpflags, SLAB_ALLOC_DEFAULT, node);
 
 	if (unlikely(!object)) {
 		struct slab_alloc_context ac = {
@@ -5359,6 +5360,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 {
 	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
 	size_t orig_size = size;
+	unsigned int alloc_flags = SLAB_ALLOC_TRYLOCK;
 	struct kmem_cache *s;
 	bool can_retry = true;
 	void *ret;
@@ -5397,7 +5399,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 		 */
 		return NULL;
 
-	ret = alloc_from_pcs(s, alloc_gfp, node);
+	ret = alloc_from_pcs(s, alloc_gfp, alloc_flags, node);
 	if (ret)
 		goto success;
 
@@ -7216,9 +7218,6 @@ refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
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


