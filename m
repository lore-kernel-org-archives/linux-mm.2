Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B70F3CD98DA
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:55:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26E936B00B0; Mon, 15 Jun 2026 07:55:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 246B56B00B2; Mon, 15 Jun 2026 07:55:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15D866B00B3; Mon, 15 Jun 2026 07:55:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 083F16B00B0
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:55:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF2791409DF
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:55:45 +0000 (UTC)
X-FDA: 84881992650.01.42508EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 075D410000C
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:55:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="d8jmFUp/";
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781524544;
	b=wbCbf/L4RCh31IAJRqXXYOMfRkOdev2PwczFBwmoLCl9msf36+JSApL77WrCwwYX7LIp9D
	TT/SO1RLWQcSXefPslvdTAXe+QnYzdFMnI/BUFwOqQCU8jiZybEicl9ZDiEUvP7h5GepYk
	m3nxhCBPDf8ExOCiNzgaULC75mQuddc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="d8jmFUp/";
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781524544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zyqT9IUsAQbwcRrsuy0yQvWZuxd/DTadym+oabv6LFI=;
	b=mRXRy9Ra8gpehhgF5aYxWHo9v8M699ZPnezb30AT5+yRZFxuT6uHrqzmyZUgBd2pDUE8W3
	QEMcqY2gmkFsdn9UEUzDB1r2MD4Rt/MMvAQ7QaCHLvK9G4Nl763FCrRJPTMM5arh2HvUEe
	gnP5hbpEdruNjhUuSl4XkX8zMDFgt1Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 580A140919;
	Mon, 15 Jun 2026 11:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8C41F00A3D;
	Mon, 15 Jun 2026 11:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781524543;
	bh=zyqT9IUsAQbwcRrsuy0yQvWZuxd/DTadym+oabv6LFI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=d8jmFUp/F1i15NtYKHs1xEpmGn13xYRQw8UK76UBniN6VQQEsiS7EafW7XcA3wJrv
	 LuOBwmr7LzNL81XvHPNQN/OUfRmBGS/cAfl+RArwqO1oBTK/ksbG8WbDJdMsHR68Tt
	 0KNhFL0vu5fM63FbeMqNhalcPBuU+wJPyIv9wvmiSQ7EZjw+ZpIAlie3x0zWSCDyqZ
	 u4O4+AmROtWI6lBI912OrObWnoWVpn96iZUM1RyXgd3qiOW0gwtq8xlMFPyujLf3uM
	 fEqe3Z/ve8vlAD2aNR3LFcGtzR6BQ6GNbXR+KobjhRkWJQw8WS0iRcHEB4rQ+6WnLU
	 Z/VsxlyDl8tzg==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 15 Jun 2026 13:54:48 +0200
Subject: [PATCH v3 15/15] mm/slab: replace __GFP_NO_OBJ_EXT with
 SLAB_ALLOC_NO_RECURSE for sheaves
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-slab_alloc_flags-v3-15-ce1146d140fb@kernel.org>
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
X-Rspamd-Queue-Id: 075D410000C
X-Stat-Signature: dqc9e81riypmuwfxje8wdyqi81bddx5u
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781524543-887155
X-HE-Meta: U2FsdGVkX1+cDEmWwCm8k4z3uL1QDu4LXm2lm44TZ2RVOaQpWOmkOMCrx9uMbXFucAUlgxjqhC1L+3mRa880NMaR3rCHg7PJ7jX8ObvdaoMKHUqYTfyx+docBCjJrsEHcuVXVQJec1e7Vz0FNWnH2sZ9w67voPrdTZySoY93UFJpj5Y9QVGmu78Y3+OtOUPChNGHgUqho1ZUe/09VMdIf1GY1hUNwo6I5SBIZZKLnJ4F4b/NT/zxIYDpeKkZfiitvtFcBt0xqomnY7v+GE2v8UfJ98skD13ayrnoLLDCa0rnxZ+yg9STeTWtlCuW/HD/FX5/Ow7U03g3xaxyQV1JlyiFM8W+P7e9ofnhIkKoi2tRfl3FHXbBxbK+od9UY5lrpxb8sZYZZCGwZs1BW8X/ECgXd13ve1aTgddWBn0tQdEQslOXxPhmzVKbxoTbTlO1PIMLlmWxJPyZVmi4tCbugLGnIZJukmpnxTdw2VQWRZIksnxoRb/dM0Ri2cUb5djm0Q0XvR8r3T94vPT2nUWG9CBPeRR5LyZNyOVDcm/zN5iJJNpq/Yh4ML9UeLjxeUA/eyJ3s9jV9cQlb7tVcU/ZL/FSDaMnhoenHHmCK4Iubharz1ORT67zrkEZp/PM8PNcTNB9Y8kPZImm6vt65Zy4+lfFI4+DvrJSrSiiF7m5gvKSRDC7xPFQ9u2EZ27PukxqHWEJoGQIUAaSK5IF2zbygdng5QmoaGkJbK4GvYlYGo0x+n3SZKOffHcNImUFtEq872iVK5oTZBvr9SSqRI2SHO10O/Q0Dn/VF4+tar3isnrxdti0VY96Vt8GuZMUDDHoQlRtRdPHIBSu6pNtQTpRdxl/ZXLrjRCmpE3zUw/SHSLyRxics95L4DiWOmkTMa4rL2V93QmZSPL44wbShvNPO06VbQmIjbLn/UDc6LinqAK19CfPTd9QhJTkTgohBC9EF9Hggu510rtueMQfVkn
 ErNxuwRr
 85mRZqaf+FUZ60G3mC5YeqDAvLTTvhnAaEQhw8ypXp4l5SYegGLyU8aollFkuBdT+jJgDnlW7rfg6rP047rl1hyVtEDtmeiGdDrDkHSNw0LOn6PExIs6oNGftEdAd6+BefiEV59J3bsNC6CzhRWeIsacVESe9/3sNtpRr0ctmZzMPUofCOw+2fHDcV3RgT2KTda8rduA7pHCIoZcor/oCMTwO3z4COyvZ3pnhUPYOvpd1lE3DawOzNYlG4a0A8VBsZIpIQRyusJCPxCde/NCZBBpE/vc+aoiBA2pxZ8OapIaI75GmBI8H7lQQ33twWaZfxvPmzcjWtMWz2/Km7ONVmCnh1rSDqQQf3BAjWi6fv3zwgyiKqH2cMgLl289MyTVYeJGa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Finish the switch away from __GFP_NO_OBJ_EXT by replacing it with
SLAB_ALLOC_NO_RECURSE when allocating empty sheaves. Pass alloc_flags to
[__]alloc_empty_sheaf(). Callers that can't be part of a recursive
kmalloc() chain simply pass SLAB_ALLOC_DEFAULT. Use kmalloc_flags()
instead of kzalloc() for allocating the sheaf.

With that we can finalize the removal the __GFP_NO_OBJ_EXT handling from
obj_ext allocations as well, leaving only SLAB_ALLOC_NO_RECURSE in
place.

This leaves __GFP_NO_OBJ_EXT with no users in slab, so stop allowing the
flag in kmalloc_nolock().

Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-16-7190909db118@kernel.org
Reviewed-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 include/linux/slab.h |  6 +++---
 mm/slub.c            | 34 +++++++++++++++++-----------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index b955f3cbb732..43c3d9b51107 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -1039,9 +1039,9 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 /**
  * kmalloc_nolock - Allocate an object of given size from any context.
  * @size: size to allocate
- * @gfp_flags: GFP flags. Only __GFP_ACCOUNT, __GFP_ZERO, __GFP_NO_OBJ_EXT
- * allowed. Also __GFP_NOWARN and __GFP_NOMEMALLOC are allowed but added
- * internally thus not necessary.
+ * @gfp_flags: GFP flags. Only __GFP_ACCOUNT and __GFP_ZERO allowed.  Also
+ * __GFP_NOWARN and __GFP_NOMEMALLOC are allowed but added internally thus not
+ * necessary.
  * @node: node number of the target node.
  *
  * Return: pointer to the new object or NULL in case of error.
diff --git a/mm/slub.c b/mm/slub.c
index fc5b8c85b690..62e9cd46916f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2171,7 +2171,6 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 
 	gfp &= ~OBJCGS_CLEAR_MASK;
 	/* Prevent recursive extension vector allocation */
-	gfp |= __GFP_NO_OBJ_EXT;
 	alloc_flags |= SLAB_ALLOC_NO_RECURSE;
 
 	sz = obj_exts_alloc_size(s, slab, gfp);
@@ -2376,7 +2375,7 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
 	if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
 		return;
 
-	if (alloc_flags & SLAB_ALLOC_NO_RECURSE || flags & __GFP_NO_OBJ_EXT)
+	if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
 		return;
 
 	slab = virt_to_slab(object);
@@ -2761,7 +2760,7 @@ static inline void *setup_object(struct kmem_cache *s, void *object)
 }
 
 static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
-					      unsigned int capacity)
+				unsigned int alloc_flags, unsigned int capacity)
 {
 	struct slab_sheaf *sheaf;
 	size_t sheaf_size;
@@ -2772,10 +2771,10 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
 	 * bucket)
 	 */
 	if (s->flags & SLAB_KMALLOC)
-		gfp |= __GFP_NO_OBJ_EXT;
+		alloc_flags |= SLAB_ALLOC_NO_RECURSE;
 
 	sheaf_size = struct_size(sheaf, objects, capacity);
-	sheaf = kzalloc(sheaf_size, gfp);
+	sheaf = kmalloc_flags(sheaf_size, gfp | __GFP_ZERO, alloc_flags, NUMA_NO_NODE);
 
 	if (unlikely(!sheaf))
 		return NULL;
@@ -2788,20 +2787,20 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
 }
 
 static inline struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s,
-						   gfp_t gfp)
+				gfp_t gfp, unsigned int alloc_flags)
 {
-	if (gfp & __GFP_NO_OBJ_EXT)
+	if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
 		return NULL;
 
 	gfp &= ~OBJCGS_CLEAR_MASK;
 
-	return __alloc_empty_sheaf(s, gfp, s->sheaf_capacity);
+	return __alloc_empty_sheaf(s, gfp, alloc_flags, s->sheaf_capacity);
 }
 
 static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
 {
 	/*
-	 * If the sheaf was created with __GFP_NO_OBJ_EXT flag then its
+	 * If the sheaf was created with SLAB_ALLOC_NO_RECURSE flag then its
 	 * corresponding extension is NULL and alloc_tag_sub() will throw a
 	 * warning, therefore replace NULL with CODETAG_EMPTY to indicate
 	 * that the extension for this sheaf is expected to be NULL.
@@ -4693,7 +4692,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 
 	if (!empty) {
-		empty = alloc_empty_sheaf(s, gfp);
+		empty = alloc_empty_sheaf(s, gfp, alloc_flags);
 		if (!empty)
 			return NULL;
 	}
@@ -5066,7 +5065,7 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
 
 	if (unlikely(size > s->sheaf_capacity)) {
 
-		sheaf = __alloc_empty_sheaf(s, gfp, size);
+		sheaf = __alloc_empty_sheaf(s, gfp, SLAB_ALLOC_DEFAULT, size);
 		if (!sheaf)
 			return NULL;
 
@@ -5111,7 +5110,7 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
 
 
 	if (!sheaf)
-		sheaf = alloc_empty_sheaf(s, gfp);
+		sheaf = alloc_empty_sheaf(s, gfp, SLAB_ALLOC_DEFAULT);
 
 	if (sheaf) {
 		sheaf->capacity = s->sheaf_capacity;
@@ -5396,7 +5395,7 @@ static void *__kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_f
 
 	VM_WARN_ON_ONCE(alloc_flags_allow_spinning(ac->alloc_flags));
 	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO |
-			__GFP_NO_OBJ_EXT | __GFP_NOWARN | __GFP_NOMEMALLOC));
+				      __GFP_NOWARN | __GFP_NOMEMALLOC));
 
 	gfp_flags |= __GFP_NOWARN | __GFP_NOMEMALLOC;
 
@@ -5911,7 +5910,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	if (!allow_spin)
 		return NULL;
 
-	empty = alloc_empty_sheaf(s, GFP_NOWAIT);
+	empty = alloc_empty_sheaf(s, GFP_NOWAIT, SLAB_ALLOC_DEFAULT);
 	if (empty)
 		goto got_empty;
 
@@ -6095,7 +6094,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 
 		local_unlock(&s->cpu_sheaves->lock);
 
-		empty = alloc_empty_sheaf(s, GFP_NOWAIT);
+		empty = alloc_empty_sheaf(s, GFP_NOWAIT, SLAB_ALLOC_DEFAULT);
 
 		if (!empty)
 			goto fail;
@@ -7640,7 +7639,7 @@ static int init_percpu_sheaves(struct kmem_cache *s)
 		if (!s->sheaf_capacity)
 			pcs->main = &bootstrap_sheaf;
 		else
-			pcs->main = alloc_empty_sheaf(s, GFP_KERNEL);
+			pcs->main = alloc_empty_sheaf(s, GFP_KERNEL, SLAB_ALLOC_DEFAULT);
 
 		if (!pcs->main)
 			return -ENOMEM;
@@ -8506,7 +8505,8 @@ static void __init bootstrap_cache_sheaves(struct kmem_cache *s)
 
 		pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
 
-		pcs->main = __alloc_empty_sheaf(s, GFP_KERNEL, capacity);
+		pcs->main = __alloc_empty_sheaf(s, GFP_KERNEL,
+				SLAB_ALLOC_DEFAULT, capacity);
 
 		if (!pcs->main) {
 			failed = true;

-- 
2.54.0


