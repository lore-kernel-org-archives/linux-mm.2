Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C144CD98DA
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:55:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C313E6B0096; Mon, 15 Jun 2026 07:55:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE24B6B0098; Mon, 15 Jun 2026 07:55:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B202F6B0099; Mon, 15 Jun 2026 07:55:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A57B96B0096
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:55:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6F7DF16636B
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:55:02 +0000 (UTC)
X-FDA: 84881990844.07.56BB9BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E34C620006
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:55:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E//gYDDW";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781524500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=glc3QEqPnlGb8w7UmY4poSPBjS3UXiolMpPhxF92RJo=;
	b=3qnaJsz71cUCnyce0h4V7JIxZHcDusbcVA0aDFuAQk7P7W5MqfxyPSJWA2lf0iSuZJ1t91
	UinU3r2NfWTcNvR3bLSRelZdizx7Q4nE4bLSpuyF2PJPN7hjG6XoUfJRGCrYeG8oyF18Dp
	7xgERbnKz/MZh8MNqkDcsE4JiXlWVEc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E//gYDDW";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781524500;
	b=XncVxBgmliyCrDEPOZaL6gURV84QL8ljOtKQTKFtfKQVAIPtqH8rTogrrG7BCtwLo5Li83
	7YtLppTlj1AWMZni/YSxHaf0aWEKEyupKJTi+KqhsR7mCcUd3LhGEGfjh6VJz50hqP7pGu
	tWcPBWza2AjNeB9eHPg8taJ1eu8yC/c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A67060132;
	Mon, 15 Jun 2026 11:55:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51A51F000E9;
	Mon, 15 Jun 2026 11:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781524500;
	bh=glc3QEqPnlGb8w7UmY4poSPBjS3UXiolMpPhxF92RJo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=E//gYDDWQdOcb5vH3L6tFTUI9pZsx8ZrNEH0l8RXCgxzkf/cXKHMKNwLC9ZZEgDes
	 JgwGJ7F1TvYbR6dXtfBIcAMm8d9b8ctTBeLB0t5TO6Wbyh7WTp7NWA3SmqVySwgjOx
	 L0RV6WXLu+nPKn3BNXoFI/sMWJEc1QKOmv+LAZWmzawkXHHhzBp8tPyb4dsJS/ByR7
	 bFylYFJphbfSHbY7oDaavJuSk7LEEP3xC3sU6Ioseff5HNljL80Q/5kFUNHKQCevES
	 pW55GNJ+T2zyYs5Z3JwqR2kW7W/EeeKxx5Fen47XvbnGcOU5W4ygRYWedJeO0aR/RH
	 wgloQ17asotIQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 15 Jun 2026 13:54:37 +0200
Subject: [PATCH v3 04/15] mm/slab: introduce alloc_flags and
 SLAB_ALLOC_NOLOCK
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-slab_alloc_flags-v3-4-ce1146d140fb@kernel.org>
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
X-Rspamd-Queue-Id: E34C620006
X-Rspam-User: 
X-Stat-Signature: sxtshwf4sui6y8qawaaqak9iszg9mub6
X-Rspamd-Server: rspam09
X-HE-Tag: 1781524500-201090
X-HE-Meta: U2FsdGVkX1/GtuMl0x1Ivanfs2S+1tJcre7u2/tXnK6u50VLLwfJSBUoOyM75cDzYCqpMoY84jr2IvmOCo61J61DZm5Gm8JyGtEMgDzNDxv0HdSK86HD5wFZ34uVRtE3O7//ejeFa6j/ryVCUzUqJ0a6rTmqAUpUiEPdAYxuXpe56JyBOssa4k5sGlBPKqcJPG8hlK3wN46NR92/mjoIntivL9rF/HYix75aeCMxP9XHR+/iXutbtazuCFG68fJbkQGap7baA0fHK2KO6+eZAD8mVV7XpjmDxZtOQq0KWgXR36wS1zm8Yxogd6BEwOcL+Afu+pCXBXvkk+naF3USdCCv6xzBt6y9dh1Szxxzc/3HsZ7pC7GkoBzW8f1wXsGKZ04oLuFmlNpfLWI2KQQtC+asC/FabVa8DP/RpDld6xX7H14YXX9T310SKUg0fOO8sQFlqq4bvJN4UbGA8QatpT5JJhdfyjK+/5evMM0jcLUg/9W5Aax24uTK8C5ybFoK5l6j9S0JHvuwH0+7tnrp0RseOhSnleTuU0/hYcWNMemZRCixLMTPJ2DxTGq5rhoKC0r/P5HeNtT8V2VMM+sxtb7Kkhd28GpU8xFjwU3UYIa8ChIQpgS68jsqfrgV7LxGDcfIMT1vpcSbUUiefCnHJF6TwMM02qpImqIslN0PuF85ZfDNh6UCDyD2PEiDfTsiYfipmCzCx/iUn65pVR6Zkz4Ko2MMSRCeJs8UfqKIZrcFK+ZymXkw+LwM7jCpHtYYCebT8ctfoN2fBRJ9DEoyEAR1MkQMdN5Bkbxe0P9pkugPC1Z2NhljOwLyGyD/9FkcR5UQSE9DpYK3+EF9YrGMCCDDUsO3+djR2KOBr9stHpbaEQF8g4uaCH01GUJFfYlEBioniVme3eQhfF3B/Dy99KlllYvuh6s3tupgXQTpbr0baUPmJm+McxPnAJ5dcMdG0p3iJRlJv2wMUxrRG/H
 lm0fT4wN
 KLMRBW8urdKuvUDF/MIgQhXQ1GJyVMdyZV6KPUj8dSaaUYVSF1orjVT7UGPBHd0ktXmcW+napV1cXdgmWuSMhcuPYKK79Y6HDokWPX1hT+9lV/a+F1ZYz8yMy7uS1SEEaljWKQYAOeOvsaj7KBq0SDHsqH/3Vr6rKub0UWriVQ9+Bz5fMg0BRqUK2OjY/ACFPUJVFPX2mgherY2kg+6b46CLXB14w8loII6HmEpgW0DGEk8VLrgZiQuBsJfQeFJgCPIROk23B0LZpLIW+Cq2WgJ4C909QDA5RL71vD0q4OsITZkM7ef/+IQVE1BPg4AsKdW7vy56gDBttyoP2iw/vO9Z/fS009ePWTt9c+9i5T4e5A02w+FXPPZFksN41R4qxcVHJTcRt3B1WgCs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Similarly to the page allocators, introduce slab-allocator specific
alloc flags that internally control allocation behavior in addition to
gfp_flags, without occupying the limited gfp flags space.

Introduce the first flag SLAB_ALLOC_NOLOCK that behaves similarly to
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
higher chances of success, and this will further increase with followup
changes.

Remove a WARN_ON_ONCE() from refill_objects() as it's now legitimate to
reach it from a slab allocation that's not _nolock() and yet lacks
__GFP_KSWAPD_RECLAIM for other reasons.

Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-5-7190909db118@kernel.org
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Hao Li <hao.li@linux.dev>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h |  9 +++++++++
 mm/slub.c | 17 ++++++++---------
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 1bf9c3021ae3..f1246f0c9f74 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -16,6 +16,15 @@
  * Internal slab definitions
  */
 
+/* slab's alloc_flags definitions */
+#define SLAB_ALLOC_DEFAULT	0x00 /* no flags */
+#define SLAB_ALLOC_NOLOCK	0x01 /* a kmalloc_nolock() allocation */
+
+static inline bool alloc_flags_allow_spinning(const unsigned int alloc_flags)
+{
+	return !(alloc_flags & SLAB_ALLOC_NOLOCK);
+}
+
 #ifdef CONFIG_64BIT
 # ifdef system_has_cmpxchg128
 # define system_has_freelist_aba()	system_has_cmpxchg128()
diff --git a/mm/slub.c b/mm/slub.c
index 8a0c5553876e..c53592baa027 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4641,7 +4641,8 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
  * unlocked.
  */
 static struct slub_percpu_sheaves *
-__pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs, gfp_t gfp)
+__pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
+			 gfp_t gfp, unsigned int alloc_flags)
 {
 	struct slab_sheaf *empty = NULL;
 	struct slab_sheaf *full;
@@ -4667,7 +4668,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	allow_spin = gfpflags_allow_spinning(gfp);
+	allow_spin = alloc_flags_allow_spinning(alloc_flags);
 
 	full = barn_replace_empty_sheaf(barn, pcs->main, allow_spin);
 
@@ -4753,7 +4754,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 }
 
 static __fastpath_inline
-void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
+void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, unsigned int alloc_flags, int node)
 {
 	struct slub_percpu_sheaves *pcs;
 	bool node_requested;
@@ -4798,7 +4799,7 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
 	if (unlikely(pcs->main->size == 0)) {
-		pcs = __pcs_replace_empty_main(s, pcs, gfp);
+		pcs = __pcs_replace_empty_main(s, pcs, gfp, alloc_flags);
 		if (unlikely(!pcs))
 			return NULL;
 	}
@@ -4931,7 +4932,7 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 	if (unlikely(object))
 		goto out;
 
-	object = alloc_from_pcs(s, gfpflags, node);
+	object = alloc_from_pcs(s, gfpflags, SLAB_ALLOC_DEFAULT, node);
 
 	if (unlikely(!object)) {
 		const struct slab_alloc_context ac = {
@@ -5362,6 +5363,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 {
 	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
 	size_t orig_size = size;
+	unsigned int alloc_flags = SLAB_ALLOC_NOLOCK;
 	struct kmem_cache *s;
 	bool can_retry = true;
 	void *ret;
@@ -5404,7 +5406,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 		 */
 		return NULL;
 
-	ret = alloc_from_pcs(s, alloc_gfp, node);
+	ret = alloc_from_pcs(s, alloc_gfp, alloc_flags, node);
 	if (ret)
 		goto success;
 
@@ -7218,9 +7220,6 @@ refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
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


