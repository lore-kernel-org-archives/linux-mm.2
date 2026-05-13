Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96A41CD4F39
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 10:58:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C4066B0095; Wed, 13 May 2026 06:58:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07AA36B0096; Wed, 13 May 2026 06:58:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7E776B0098; Wed, 13 May 2026 06:58:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D34896B0095
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:58:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8702612085B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:58:15 +0000 (UTC)
X-FDA: 84762097350.26.8E77822
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id C99D34000B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:58:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LWTIVeba;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778669894; a=rsa-sha256;
	cv=none;
	b=cLG3ssCqcNYmkM2SsG0d7DMaIinwXlvNzGgvnJhPs66U6XeWJwugx226K7GPSZJi34VZEH
	eFTyo1oxPNbovWayXrUcm3TRmmJCiwiGFCqbALLf1iSXP9jAc1cABK07MKhFONKldItMVH
	A9GNVWGhTqlpiJDn55XOOwfX/KKfN74=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LWTIVeba;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778669894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XvE2VPiL5eBdvFwWO2q2HS1cbsvTYz9KutUrTFHWDas=;
	b=emAOeiz6wMfvNxPYcbkMST/5w2/z4GL31OGrRv7D99ttWtg+xwoUAensGhbte8d6TKAxVV
	rawGOr6o19J3qX4g79uYVwiTnlpfzwh3E0WJQsXmOTFelUE1ccClll5QY9wY42HU8PtaHs
	Vfqhoi8fwI2nLO8edzJgV4264wj3ee4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9CD311655;
	Wed, 13 May 2026 03:58:07 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8C1663F7B4;
	Wed, 13 May 2026 03:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778669892; bh=UMZExYTByTd2BljtAfXzMdW/HfNhKp7vgZPFf8/fELI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWTIVebaAkxUiz6Ypc/nwhKXXYiVbwwureTaFhfH7dbOIpEc+nYYeo+zc801vuxMy
	 RmlcFHKnZihIT4l9XvEk50zD2PzaDEaXDSiSoFhfTupL8odzR7FtEveJZP5JRNbzCg
	 6PpOlut0cqx1FC/G6RUnMV+cRVb3OTnynKZ3ugRE=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	harry@kernel.org,
	ryabinin.a.a@gmail.com
Cc: Dev Jain <dev.jain@arm.com>,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	hao.li@linux.dev,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	kasan-dev@googlegroups.com,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	catalin.marinas@arm.com
Subject: [PATCH 2/3] kasan: avoid re-poisoning tag-based kmalloc redzones
Date: Wed, 13 May 2026 16:27:33 +0530
Message-Id: <20260513105734.3380544-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260513105734.3380544-1-dev.jain@arm.com>
References: <20260513105734.3380544-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w8szsh9sx5k6mcrom9wk4cw5imqumbq4
X-Rspam-User: 
X-Rspamd-Queue-Id: C99D34000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1778669893-747932
X-HE-Meta: U2FsdGVkX18jftBEcrwP6Z/NGbkCJgVQAbAIGWTnJvcUpiN7DvicKFmbnO/IIm8u2lxBNFY/S5ltsJaRIL7wDo19vx7NBoqo1Z338pvnA2nJBfvxx62fgWvTo0jav562DsyxBuTzJGwtVOybQTxFWsR2x78OFhnq6dDRsThl8q8uwwg/Rm2zUyOdHO+MvrxgKzFQoVY2CCi1vjy5MRF2ovpso3NZfunMJ+RdK0/rbfi16T2kw/VJy6OOSq57iKkrrHwxGm2gN0Sb/7TFL8xdec8UsAudgi/hnFdq4TTcY5axs5JoTYZmnfTxsXkTUUW9CtMQNYPy3YdtRJ/M0mUs7n2qwuMqBOmhIHK7hPKunpxZkjSW8OGjUqGhkNM78u2X39p8NkVIH5LBoaZrWyuKkjbwzo68D9fJEP0QCRI9wFcVUbmeHrsBNHCOedeg5s//jswnhvmLkXtwYj+v6m25ItFbK/gXeEmUvbtWJJfUTzTTO5/08921UlwC1OicmGWrXZ2DoHrRqs6KmXDGRIQsnUjx9lrILiZ6mSyeM7lrgtYwWnebnA75xT7nbng0I7qja4RT8DZMXMWDJNT0qbPDImXVgInx7+R7T+2HKAITITCpfGmPiTi3FSPov3gYsDp1fD/E2nYP3e0+54ssJ6oaMu3kAAbIAHGG6rrAirazgAi4k21pjJOr0tJUzzpd2o6ontcU0ILgz4bodPlYanCk4/n62QhlGkU/XLEcCwVbXIhzOtXIVjckHWSQvE341ZN8TPp5geJchdsU8CkN8NC9OEwA1LlkodD0AOw3ikswL6yjQDx7Tb9IqaUxydBHW4sMYnx/PoD73q7a0tnvjBp+MsGuzZVbJoYaky91T5it9XVDU1qxNThtLdNAz30MrZGsWzX+FNsj7eWzRbNFqXXwAZrOHRFrVzlIhcF+6N6+BKNYbwGLPLAK48/GPNfzmT6l/RlhNXsU/W05i5zLeor
 jQtfBAiL
 QzjGjGpDeGSVhGuVNsprGgG7V7Xraj1npdfOBYMTkBzVlKiIHLW13vBQFrIc9ih4Xv82M5cmIjq/Xy9FiEIVV2hCk56xZCqZJxUfBOyMCdbFBIKdStKfT5sZOtLQj56w6wNtTLzSMGKqc2eViPVVHbDCOb2KdiuA6eM+Lz9IcH8A5w7IOnTSIAwL0FeLS67FVD0cUGQq6X7/xuK5tKBq6qs5YSCI2MiLQwYnZrqxeFdykSYMLJ82Bacgihpx7HQRsSoEqIrfoXETCtxGk4rSPzF1U3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When we allocate object from slab, kasan will unpoison the entire object.
In case of allocation from kmalloc caches, the actual allocation size
request can be less than the size of the kmalloc cache. kasan poisons
the bytes following allocation size up till object size to catch OOB.

We can do this operation in one shot: while unpoisoning the object upon
allocation, only unpoison up till allocation size bytes, so that the
bytes following that up till object size remain poisoned.

Currently when we free an object into the slab, we use KASAN_SLAB_FREE for
poisoning, and use KASAN_SLAB_REDZONE for poisoning the tail end. For
tag-based kasan, these two are equal, as opposed to generic kasan. So we
make this optimization only for tag-based kasan.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 include/linux/kasan.h | 17 +++++++++----
 mm/kasan/common.c     | 55 +++++++++++++++++++++++++++++++++----------
 mm/slub.c             | 11 +++++----
 3 files changed, 61 insertions(+), 22 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index bf233bde68c7..fd7c1f5f9fd6 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -102,6 +102,12 @@ static inline bool kasan_has_integrated_init(void)
 	return kasan_hw_tags_enabled();
 }
 
+static inline bool kasan_has_tag_based_kmalloc_redzones(void)
+{
+	return kasan_enabled() &&
+	       (IS_ENABLED(CONFIG_KASAN_SW_TAGS) || kasan_hw_tags_enabled());
+}
+
 #ifdef CONFIG_KASAN
 void __kasan_unpoison_range(const void *addr, size_t size);
 static __always_inline void kasan_unpoison_range(const void *addr, size_t size)
@@ -244,13 +250,14 @@ static __always_inline void kasan_kfree_large(void *ptr)
 		__kasan_kfree_large(ptr, _RET_IP_);
 }
 
-void * __must_check __kasan_slab_alloc(struct kmem_cache *s,
-				       void *object, gfp_t flags, bool init);
+void * __must_check __kasan_slab_alloc(struct kmem_cache *s, void *object,
+				       size_t size, gfp_t flags, bool init);
 static __always_inline void * __must_check kasan_slab_alloc(
-		struct kmem_cache *s, void *object, gfp_t flags, bool init)
+		struct kmem_cache *s, void *object, size_t size,
+		gfp_t flags, bool init)
 {
 	if (kasan_enabled())
-		return __kasan_slab_alloc(s, object, flags, init);
+		return __kasan_slab_alloc(s, object, size, flags, init);
 	return object;
 }
 
@@ -437,7 +444,7 @@ static inline bool kasan_slab_free(struct kmem_cache *s, void *object,
 }
 static inline void kasan_kfree_large(void *ptr) {}
 static inline void *kasan_slab_alloc(struct kmem_cache *s, void *object,
-				   gfp_t flags, bool init)
+				   size_t size, gfp_t flags, bool init)
 {
 	return object;
 }
diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index b7d05c2a6d93..9a4db9c21aaf 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -326,14 +326,25 @@ void __kasan_kfree_large(void *ptr, unsigned long ip)
 	/* The object will be poisoned by kasan_poison_pages(). */
 }
 
+static inline size_t slab_unpoison_size(struct kmem_cache *cache, size_t size)
+{
+	if (kasan_has_tag_based_kmalloc_redzones() && is_kmalloc_cache(cache))
+		return min_t(size_t, size, cache->object_size);
+
+	return cache->object_size;
+}
+
 static inline void unpoison_slab_object(struct kmem_cache *cache, void *object,
-					gfp_t flags, bool init)
+					size_t size, gfp_t flags, bool init)
 {
 	/*
-	 * Unpoison the whole object. For kmalloc() allocations,
-	 * poison_kmalloc_redzone() will do precise poisoning.
+	 * For tag-based modes, kmalloc redzones all use the same invalid tag.
+	 * Keep the tail poisoned and only unpoison the requested allocation
+	 * size. Generic KASAN keeps distinct shadow values for free objects and
+	 * redzones, so it still unpoisons the whole object and later poisons
+	 * the precise redzone.
 	 */
-	kasan_unpoison(object, cache->object_size, init);
+	kasan_unpoison(object, slab_unpoison_size(cache, size), init);
 
 	/* Save alloc info (if possible) for non-kmalloc() allocations. */
 	if (kasan_stack_collection_enabled() && !is_kmalloc_cache(cache))
@@ -341,7 +352,8 @@ static inline void unpoison_slab_object(struct kmem_cache *cache, void *object,
 }
 
 void * __must_check __kasan_slab_alloc(struct kmem_cache *cache,
-					void *object, gfp_t flags, bool init)
+					void *object, size_t size,
+					gfp_t flags, bool init)
 {
 	u8 tag;
 	void *tagged_object;
@@ -363,11 +375,18 @@ void * __must_check __kasan_slab_alloc(struct kmem_cache *cache,
 	tagged_object = set_tag(object, tag);
 
 	/* Unpoison the object and save alloc info for non-kmalloc() allocations. */
-	unpoison_slab_object(cache, tagged_object, flags, init);
+	unpoison_slab_object(cache, tagged_object, size, flags, init);
 
 	return tagged_object;
 }
 
+static inline void save_kmalloc_alloc_info(struct kmem_cache *cache,
+					   void *object, gfp_t flags)
+{
+	if (kasan_stack_collection_enabled() && is_kmalloc_cache(cache))
+		kasan_save_alloc_info(cache, object, flags);
+}
+
 static inline void poison_kmalloc_redzone(struct kmem_cache *cache,
 				const void *object, size_t size, gfp_t flags)
 {
@@ -394,8 +413,7 @@ static inline void poison_kmalloc_redzone(struct kmem_cache *cache,
 	 * Save alloc info (if possible) for kmalloc() allocations.
 	 * This also rewrites the alloc info when called from kasan_krealloc().
 	 */
-	if (kasan_stack_collection_enabled() && is_kmalloc_cache(cache))
-		kasan_save_alloc_info(cache, (void *)object, flags);
+	save_kmalloc_alloc_info(cache, (void *)object, flags);
 
 }
 
@@ -411,8 +429,14 @@ void * __must_check __kasan_kmalloc(struct kmem_cache *cache, const void *object
 	if (is_kfence_address(object))
 		return (void *)object;
 
-	/* The object has already been unpoisoned by kasan_slab_alloc(). */
-	poison_kmalloc_redzone(cache, object, size, flags);
+	/*
+	 * For tag-based modes, the object has already been precisely
+	 * unpoisoned by kasan_slab_alloc(). The tail remains poisoned.
+	 */
+	if (kasan_has_tag_based_kmalloc_redzones())
+		save_kmalloc_alloc_info(cache, (void *)object, flags);
+	else
+		poison_kmalloc_redzone(cache, object, size, flags);
 
 	/* Keep the tag that was set by kasan_slab_alloc(). */
 	return (void *)object;
@@ -561,11 +585,16 @@ void __kasan_mempool_unpoison_object(void *ptr, size_t size, unsigned long ip)
 		return;
 
 	/* Unpoison the object and save alloc info for non-kmalloc() allocations. */
-	unpoison_slab_object(slab->slab_cache, ptr, flags, false);
+	unpoison_slab_object(slab->slab_cache, ptr, size, flags, false);
 
 	/* Poison the redzone and save alloc info for kmalloc() allocations. */
-	if (is_kmalloc_cache(slab->slab_cache))
-		poison_kmalloc_redzone(slab->slab_cache, ptr, size, flags);
+	if (is_kmalloc_cache(slab->slab_cache)) {
+		if (kasan_has_tag_based_kmalloc_redzones())
+			save_kmalloc_alloc_info(slab->slab_cache, ptr, flags);
+		else
+			poison_kmalloc_redzone(slab->slab_cache, ptr, size,
+					       flags);
+	}
 }
 
 bool __kasan_check_byte(const void *address, unsigned long ip)
diff --git a/mm/slub.c b/mm/slub.c
index da3520769d1f..15144b2e078c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4550,8 +4550,9 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 	 * replacement of current poisoning under certain debug option, and
 	 * won't break other sanity checks.
 	 */
-	if (kmem_cache_debug_flags(s, SLAB_STORE_USER | SLAB_RED_ZONE) &&
-	    (s->flags & SLAB_KMALLOC))
+	if ((s->flags & SLAB_KMALLOC) &&
+	    (kmem_cache_debug_flags(s, SLAB_STORE_USER | SLAB_RED_ZONE) ||
+	     kasan_has_tag_based_kmalloc_redzones()))
 		zero_size = orig_size;
 
 	/*
@@ -4573,7 +4574,8 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 	 * As p[i] might get tagged, memset and kmemleak hook come after KASAN.
 	 */
 	for (i = 0; i < size; i++) {
-		p[i] = kasan_slab_alloc(s, p[i], init_flags, kasan_init);
+		p[i] = kasan_slab_alloc(s, p[i], orig_size, init_flags,
+					kasan_init);
 		if (p[i] && init && (!kasan_init ||
 				     !kasan_has_integrated_init()))
 			memset(p[i], 0, zero_size);
@@ -7615,7 +7617,8 @@ static void early_kmem_cache_node_alloc(int node)
 #ifdef CONFIG_SLUB_DEBUG
 	init_object(kmem_cache_node, n, SLUB_RED_ACTIVE);
 #endif
-	n = kasan_slab_alloc(kmem_cache_node, n, GFP_KERNEL, false);
+	n = kasan_slab_alloc(kmem_cache_node, n, kmem_cache_node->object_size,
+			     GFP_KERNEL, false);
 	slab->freelist = get_freepointer(kmem_cache_node, n);
 	slab->inuse = 1;
 	kmem_cache_node->per_node[node].node = n;
-- 
2.43.0


