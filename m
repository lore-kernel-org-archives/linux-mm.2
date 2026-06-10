Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8510ACD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 15:42:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E14816B00B2; Wed, 10 Jun 2026 11:42:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC5126B00B4; Wed, 10 Jun 2026 11:42:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D02846B00B5; Wed, 10 Jun 2026 11:42:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BFD4A6B00B2
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:42:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 839E5163478
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:42:19 +0000 (UTC)
X-FDA: 84864419598.20.FC007F7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id CF10D4001C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:42:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qg4uqDVH;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781106137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6aryytOBNurBkp5Uw74m0IHlGcpQ9KrOL+zxkUQGPho=;
	b=8Y95Y8akmkYYo9/xsrVVnt85pZp8keOLDN/PjmjilBBDdhtAA5tXTRU5ZiYQ7wh4ZvHdg8
	rt3zolVE1Pv9L8JxmmxdpG2hT8T4wjiM8mcWWwP528FJyoUx78weN6JBxgdd0zQCgW4rVV
	NR0ks8Py9vwIpVDZChUeEPO7+l7MWh8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qg4uqDVH;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781106137;
	b=1yqWOLETvyExk+clKJ4iA4nWK9H3TVrJHmXUcCkFoKfy9DQ1ZGu7bEE47kdoMI1P7Isg3t
	9sdHgkID9SM0G6e9V6Q05+DHi2ULWVJbnkdU12klHWEC/p9nUEVyP4+pqFzczCJ9vLaLc3
	NAW8m2iGeHQ8CznkEXlLq2twWdVMJQI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 65973601E8;
	Wed, 10 Jun 2026 15:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F571F00893;
	Wed, 10 Jun 2026 15:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781106137;
	bh=6aryytOBNurBkp5Uw74m0IHlGcpQ9KrOL+zxkUQGPho=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Qg4uqDVH2Od4OJDTajLnIl8nVeghe4DAgiT0czgSacooafpW481IQQDixrdbMhLcb
	 GlRnhZpCu4p7BLw4qvBcTYtVUXh5LcCj6ceGF6PlaOolrp5TyN3TgEVZVqR//+QXdm
	 vRdCklZf1Erf1fyXoBSfZDH2F0UsVjwY0uiKiSojTHdETEd2NkTF5YQNl8uZ4oNZ6n
	 HmM6jQT15H+wuCPzDBvfHhkGcvwCZjCmsTS+4aQexi4TUFtCeTt3t1z1ty67arWq1v
	 +Djs/uKFnMOEFUaeyJwgMKJmqujy8ZlMWv5jUNl0IVypqs218B5ZEijmNE1HjQMOIj
	 jwyKEnXTIeK7g==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 10 Jun 2026 17:40:18 +0200
Subject: [PATCH v2 16/16] mm/slab: replace __GFP_NO_OBJ_EXT with
 SLAB_ALLOC_NO_RECURSE for sheaves
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260610-slab_alloc_flags-v2-16-7190909db118@kernel.org>
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CF10D4001C
X-Stat-Signature: dd113xm8dsngpy3w17r7tzkgasoa3c1o
X-Rspam-User: 
X-HE-Tag: 1781106137-687973
X-HE-Meta: U2FsdGVkX19pQZNYCRAga6AH9avfvKMRyzFhfyf2eE33NrJkF8sjw8CBzv9DlDGYBGgGGVLbOF6ZGgv7QRHUK5t4qiva5EXtkmg+nZkXRuBDnYWlewGoCIXUGSUTkrZeZzM2zm2C4tGRX1I8gDgBSm+EW+b1Z87fW2J8+5q3sH753oE/xBJW1Pa9coZ8Z4lgzAfQLhc/TklRRidh9ziZwqz1b9X5jA6d1X9dLDk76lCNXKmH9IthdtgrdqoJ24I/zygfJFIJaApK46PB6vAwbFsh5RI0b/OjU/yYN/65hnncPt2pjQC4HyuSgBpcdwgkU4S2TliC9zfx1s9zv7wHHkV1K+TdqFXd6lD/U+d+vfIl/09gbCcA6BYWR8go301xw0ArQM4xzSXgoZbxZENUvp88BztVxnJ9USvTHmsv6fieaO2i5K9a9LSinIMi3NALTR6aNITwHUk4V7CkFVyaFZRa+LwBHV4gIdGNRGmIOIoREcxo19lNDBNf9bh3TeniPe9pBDfUZ+LerTMqIYoChLXg0r+1JqNf8QA2io5M/5U7PdbWL14DHpNpqtYj8zAqvw60hywYlhGan3/jeSDecISA78pa5qwFLRdneruFk4/cH+UQ2MAWnOa2VfhWhJ6zLglovQyRE3qW+iCWzjS3NyNchF3n90dQeDSrS4uhrZuQzxB88so1TCucb6XEFIrmUQhZ6a1MRuU9Sn5dZEOzaYntsTrNO4xzddz1n38Kpjrl2uBpEHCOUs+kBq8N9ljVir8VXq0vRFZ6GZ04r+p6RuR9ejcs8z+bTKtQJiVXsVRWQkSaBbNkMLmfRGRtIAUpSkLqcdA/x0mwSoIHuFvcwXmDBrgPZExMmpPtGVrP9xgPg5dXtU9ZhK4z6u9VNbKSBjKPVMqtZqNoQjuOnJIB3uhLA6UhHlZSmPfoiMZ/W+1c0Y/Y8O5n+6uDSB9XdaoY8QauEKxUKXD6zNIArjp
 oW15KW7L
 oIWlM0AgB4Dj7kJhbeqDGIIukOIpib8mCKk3KGBLTjckMbW/qgP0X4SoV7qIc2dEtFq43KIlXzQpqHVozl+NDUi84QB8JCsE+1hpj3u+biMCwaX60/zuHR4lym8np17NTPAscnfieGGbBO5kftt2f3hq6qqId+/QDVIEVCETayhN73vn9woVTvq3bYjb0HmcAXE4gYn+rU7nMUlJigKJiz1zMRPq5A4tfy3eF+cf8f+DtEP1VEfwtnjrajwIMp+7yBXqx2muS79Mi+tgjP9jI5hzAcqvuVcFCDT0DbjT5F73vZpE=
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

This leaves __GFP_NO_OBJ_EXT with no users in slab, so stop allowing the
flag in kmalloc_nolock().

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 include/linux/slab.h |  6 +++---
 mm/slub.c            | 31 ++++++++++++++++---------------
 2 files changed, 19 insertions(+), 18 deletions(-)

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
index 7dfbd0251aa2..5d7ea72ebebd 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2756,7 +2756,7 @@ static inline void *setup_object(struct kmem_cache *s, void *object)
 }
 
 static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
-					      unsigned int capacity)
+				unsigned int alloc_flags, unsigned int capacity)
 {
 	struct slab_sheaf *sheaf;
 	size_t sheaf_size;
@@ -2767,10 +2767,10 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
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
@@ -2783,20 +2783,20 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
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
@@ -4689,7 +4689,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 
 	if (!empty) {
-		empty = alloc_empty_sheaf(s, gfp);
+		empty = alloc_empty_sheaf(s, gfp, alloc_flags);
 		if (!empty)
 			return NULL;
 	}
@@ -5063,7 +5063,7 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
 
 	if (unlikely(size > s->sheaf_capacity)) {
 
-		sheaf = __alloc_empty_sheaf(s, gfp, size);
+		sheaf = __alloc_empty_sheaf(s, gfp, SLAB_ALLOC_DEFAULT, size);
 		if (!sheaf)
 			return NULL;
 
@@ -5108,7 +5108,7 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
 
 
 	if (!sheaf)
-		sheaf = alloc_empty_sheaf(s, gfp);
+		sheaf = alloc_empty_sheaf(s, gfp, SLAB_ALLOC_DEFAULT);
 
 	if (sheaf) {
 		sheaf->capacity = s->sheaf_capacity;
@@ -5392,7 +5392,7 @@ static void *__kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_f
 
 	VM_WARN_ON_ONCE(alloc_flags_allow_spinning(ac->alloc_flags));
 	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO |
-			__GFP_NO_OBJ_EXT | __GFP_NOWARN | __GFP_NOMEMALLOC));
+				      __GFP_NOWARN | __GFP_NOMEMALLOC));
 
 	gfp_flags |= __GFP_NOWARN | __GFP_NOMEMALLOC;
 
@@ -5907,7 +5907,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	if (!allow_spin)
 		return NULL;
 
-	empty = alloc_empty_sheaf(s, GFP_NOWAIT);
+	empty = alloc_empty_sheaf(s, GFP_NOWAIT, SLAB_ALLOC_DEFAULT);
 	if (empty)
 		goto got_empty;
 
@@ -6091,7 +6091,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 
 		local_unlock(&s->cpu_sheaves->lock);
 
-		empty = alloc_empty_sheaf(s, GFP_NOWAIT);
+		empty = alloc_empty_sheaf(s, GFP_NOWAIT, SLAB_ALLOC_DEFAULT);
 
 		if (!empty)
 			goto fail;
@@ -7636,7 +7636,7 @@ static int init_percpu_sheaves(struct kmem_cache *s)
 		if (!s->sheaf_capacity)
 			pcs->main = &bootstrap_sheaf;
 		else
-			pcs->main = alloc_empty_sheaf(s, GFP_KERNEL);
+			pcs->main = alloc_empty_sheaf(s, GFP_KERNEL, SLAB_ALLOC_DEFAULT);
 
 		if (!pcs->main)
 			return -ENOMEM;
@@ -8502,7 +8502,8 @@ static void __init bootstrap_cache_sheaves(struct kmem_cache *s)
 
 		pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
 
-		pcs->main = __alloc_empty_sheaf(s, GFP_KERNEL, capacity);
+		pcs->main = __alloc_empty_sheaf(s, GFP_KERNEL,
+				SLAB_ALLOC_DEFAULT, capacity);
 
 		if (!pcs->main) {
 			failed = true;

-- 
2.54.0


