Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24BEFC43602
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 07:42:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB8346B00A8; Wed,  1 Jul 2026 03:42:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E95726B00A9; Wed,  1 Jul 2026 03:42:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA8016B00AC; Wed,  1 Jul 2026 03:42:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ADFBC6B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 03:42:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 28CDE1C1E87
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:42:20 +0000 (UTC)
X-FDA: 84939414840.09.32275BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6B50418000D
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:42:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fsZidbMK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782891738;
	b=Yx7Zw1WoJKsyHdCT6Ou2UsSaqg0LVUOf2wGCpwmP5enHb7Hxjt2XeEykL0P4W31Op08vxS
	roba7xXbTazyaliKwq5nYZKcK4ghr3GIysqW+2Yt4Tp3JPBR2D11SJdzZ0yvrHga3p24qR
	T4qsv3t47uqLOm/tlgvadYJ3YLzEFdE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782891738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nmMYy+2a7osCrSTRQCfHd44byz7QKxMDnf7l9u44SjA=;
	b=aIUHAyW1TxS7IAHLETbTvvPNZh3OZfltvd9LU0LHfAKJQQTpts1jxMeaWssOC1RJXvS7zz
	g6fQ6qcZjpJ5rNeW46ic4pz/NQFm2aTB+5dXrOShS71qqUxFWIiNQgW0WvzrdEw0B2HX39
	O2VanLQgI7d73vu+mQrQAbxK7iXUnhk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fsZidbMK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CF9E4601D7;
	Wed,  1 Jul 2026 07:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03211F000E9;
	Wed,  1 Jul 2026 07:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782891737;
	bh=nmMYy+2a7osCrSTRQCfHd44byz7QKxMDnf7l9u44SjA=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=fsZidbMK3aBR7NDoEvg7Qgx6aPKRPK+lwaozLCi5Z3P5AGZQhu3jS/N6uWl5+dByc
	 IXgR6giOgTHW83CB/2p8WpDMs1XrYyoLG5tA5VDsTqzvb4cdc+PEmlGKEMmCiVxyUk
	 VuawTYIGbnFpFNQAdf9k0GJHMymk1Ci85D4mMAUkFAF6iuybS9Cnw0TtJ8461iyzxW
	 joKnlas/c6qhcbfbJhVI55XANKqPjE82Ez8lDY6Tegaq67uKUwQGsD4hwZRNx1bcOG
	 yUegAzAf1odZyXsIGiHV21WGbUZiNpiSoPWOjIMzog14M1LDLtuaL41w4qLA+izzMB
	 kYpEGHCKD7r/Q==
Message-ID: <68e7f6cd-cf11-46b2-84a2-d512bb22dae4@kernel.org>
Date: Wed, 1 Jul 2026 16:42:13 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
From: Harry Yoo <harry@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Usama Arif <usama.arif@linux.dev>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Danielle Costantino <dcostantino@meta.com>, Kees Cook <kees@kernel.org>
References: <CAJuCfpFanDcpqq5B7eNZbw2HnWOXD-xzcnrdbz-e2gnSM2EYHA@mail.gmail.com>
 <eac2ed38-432a-4d95-8968-2663540d73d7@kernel.org>
 <CAJuCfpF78_5CjLsbJLte+B4MzfaSiAmyeH57VLhgLtj8AXD2NA@mail.gmail.com>
 <62969830-4b1f-483d-8fa9-9ce487568570@kernel.org>
 <CAJuCfpH8ZjBMaOmso=9gZNz=DK2ja5yMS+04OjTGHh5Uc7r0GQ@mail.gmail.com>
 <CAJuCfpFX_sMrcTad-QGJsCV=fNyMWF=Bi6XmoHRqEAzMbWNfdg@mail.gmail.com>
 <39a79576-dcae-4b66-9478-c81dfe676699@kernel.org>
 <CAJuCfpGRC7NPxcODUsb3YS5nV=qG+-SbSYj1Fwm-QPqgKSVWAA@mail.gmail.com>
 <c5c4208d-a6f0-413e-bad9-49be12f12d55@kernel.org>
 <5ebd3c4a-5c06-43b4-ab0a-7a8f0396c84c@kernel.org>
 <akPSjsbjl-UAcdI8@linux.dev>
 <CAJuCfpE4BwDpt08iXtdh_nqRR5TGzGTdHzGZWYayC7t6V1O49w@mail.gmail.com>
 <c4eab53b-c54d-4f1e-a4ff-8d86b8d32503@kernel.org>
 <CAJuCfpE6WSWPyZMheF4b=2mrwx7bPP3JUe9Pwp6QAswSMF4GyQ@mail.gmail.com>
 <9a139365-28e6-4f1e-b35b-7f6091e9aa14@kernel.org>
 <92bf5e21-690e-4a77-929e-5217e0d7cb0c@kernel.org>
Content-Language: en-US
In-Reply-To: <92bf5e21-690e-4a77-929e-5217e0d7cb0c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6B50418000D
X-Rspam-User: 
X-Stat-Signature: 5fooew8zwfaqmygbf34t3e4gs46hjko4
X-HE-Tag: 1782891738-8150
X-HE-Meta: U2FsdGVkX1+uSZTfrJbi7aWUd/WH58oqHljv7QKuSA0w6gwYxG9eieKDTowd3O7mLXf6TP30fh/TufORl5lGXAchBDmwHb7pPS3uOAo1KSj3ZzXRIYBc8cTNwOdifzw/GUaXZVEjV9AGYAo9uYlhxGdGxGFUXFuh5/zPWLzy7ed5gibE1Kn3H74Msu7CQiCjMr1a+6Z0lYQ6SnUyL37G6W0Xgfp0zfKigE1k/GBM1y7SJ885gjXojjyLX+WB9plll/CWpWyoWOMvFo4ymrb3vTZNc68O7Ndfa4sAFdVqXdfDURP8yKTCgaMpW6a5KZ1TE2gGyAP4xcR+By0fbNi1kmukEsdpJXWMjDTWRDDBuggdm7QuixuHiRJy59mKvBsggsZbxn/SnSCm+kiBnUX/Pq0/HzUhVYATarFKxUUpYhO+nfS5Efek5eNZGIxVmIlFjI8z5gBMAVkizvIDiRKKARpFJKs4Q+kj+C0ZLlouAg+0ckLWdRn2XuVQyQN8bkQXYkfbiI8+q4oiPJeEgdNcJQFMaxvNaJqTIxOyZsPRIJox4FBGdoYOry21Sc3lK0cJ89rwPZqoepSfYSxiF1z/ZvahKPxF57yVJZeuj/6TKSnglf4Pl3TDSFyCLlRHfPebWooQZZDGrCAbrEXTSGAH0J75/4028q4NAaqHA+fv7UF9pganY6RmHHudziPsVxwbNVWRZfFdGskkR9WvD1poFi/kflKqg51KXEcpGpcH+xqGrFqMEXj91E5RxrHTYGtP8WsbAIsMHktBKRCvndu83KoXHLlIqae0i/q5ydixrs964Up2t/HUEat3DkyZgnrPifb3q4MF+qyG6Vk2UxbMlwRHhXCF01as/j0KtHgJf+xyTkdhL6hmIk1H3et4E6wT7NjKuqq6P5+BKkTdZqCnl3vuF+rbAJYlxQKz3gnjS3qFcEGzLItKUm2P7yiuA+o8kFMdOjIm69EHxGzbhOr
 vSJmEhMi
 f8KDlG72J1YwoIs6NFggqlCNaXdpjDDMHg9HHqX3BOQGPjCgYb4kPleXHpp4vbZrA0KUbbg93NyNqAXkmNDc08x4/lfbxwuI6nfq42xHk5oXQIfh5zh4bKksdIQ9ldkoADPlZNVDsT3eaE8aw1+F0u4+XUGFIq4Vj228u3GAwqTKyteWmD4+/YXFMSxlIvDjt0m3l1UVQEREoI50VnGgMRcue3bFkHS2mw7FBcsFuY4b/bQ17QJA4WMuD4EFIGmQf8PkUkMT4COAKklb2YYrZtuLrDIXQZMN7NIW3qp2NwMis4NbX6F/gxOFI/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/1/26 1:53 PM, Harry Yoo wrote:
> 
> 
> On 7/1/26 1:30 PM, Harry Yoo wrote:
>> We can do that in pre-7.2 kernels, by teaching kmalloc_type() and
>> kmalloc_slab() select the new KMALLOC_TYPE based on __GFP_NO_OBJ_EXT?
>>
>> e.g.) Select the new KMALLOC_TYPE when KMALLOC_NOT_NORMAL_BITS is not
>> set AND __GFP_NO_OBJ_EXT is set.
> 
> Uh, this is bit subtle though.
> 
> In some cases  KMALLOC_DMA == KMALLOC_NORMAL,
> KMALLOC_CGROUP == KMALLOC_NORMAL,
> or KMALLOC_RECLAIM == KMALLOC_NORMAL.
> 
> Just checking KMALLOC_NOT_NORMAL_BITS is misleading.

Here's a prototype for slab/for-next. Backporting it requires handling
__GFP_NO_OBJ_EXT instead of SLAB_ALLOC_NO_RECURSE, but shouldn't be
too difficult. Now writing changelog and going through testing...

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 51f03f18c9a7..91a71537a2fe 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -684,6 +684,26 @@ static inline unsigned int arch_slab_minalign(void)
 #define KMALLOC_PARTITION_CACHES_NR	0
 #endif

+/*
+ * SLUB needs a separate kmalloc type, KMALLOC_NO_RECURSE, when
internal slab
+ * metadata of kmalloc objects can be allocated from the same kmalloc type.
+ */
+#if defined(CONFIG_MEM_ALLOC_PROFILING)
+/*
+ * Memory allocation profiling can allocate internal slab metadata
+ * for any slab cache.
+ */
+#define HAS_KMALLOC_NO_RECURSE
+#elif defined(CONFIG_SLUB_TINY) && defined(CONFIG_MEMCG)
+/*
+ * Accounted slab objects are usually allocated from KMALLOC_CGROUP.
+ * On SLUB_TINY, those can be allocated from KMALLOC_NORMAL because
+ * KMALLOC_RECLAIM aliases with KMALLOC_CGROUP and has higher priority than
+ * KMALLOC_CGROUP.
+ */
+#define HAS_KMALLOC_NO_RECURSE
+#endif
+
 /*
  * Whenever changing this, take care of that kmalloc_type() and
  * create_kmalloc_caches() still work as intended.
@@ -702,6 +722,9 @@ enum kmalloc_cache_type {
 #endif
 	KMALLOC_PARTITION_START = KMALLOC_NORMAL,
 	KMALLOC_PARTITION_END = KMALLOC_PARTITION_START +
KMALLOC_PARTITION_CACHES_NR,
+#ifdef HAS_KMALLOC_NO_RECURSE
+	KMALLOC_NO_RECURSE,
+#endif
 #ifdef CONFIG_SLUB_TINY
 	KMALLOC_RECLAIM = KMALLOC_NORMAL,
 #else
@@ -716,6 +739,16 @@ enum kmalloc_cache_type {
 	NR_KMALLOC_TYPES
 };

+#if !defined(HAS_KMALLOC_NO_RECURSE) && defined(CONFIG_SLAB_OBJ_EXT)
+/*
+ * kmalloc_flags() with SLAB_ALLOC_NO_RECURSE should not use KMALLOC_NORMAL
+ * if any of these alias with KMALLOC_NORMAL.
+ */
+static_assert(KMALLOC_DMA != KMALLOC_NORMAL);
+static_assert(KMALLOC_CGROUP != KMALLOC_NORMAL);
+static_assert(KMALLOC_RECLAIM != KMALLOC_NORMAL);
+#endif
+
 typedef struct kmem_cache * kmem_buckets[KMALLOC_SHIFT_HIGH + 1];

 extern kmem_buckets kmalloc_caches[NR_KMALLOC_TYPES];
diff --git a/mm/slab.h b/mm/slab.h
index 281a65233795..ba0560111488 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -386,12 +386,21 @@ static inline unsigned int
size_index_elem(unsigned int bytes)
  * KMALLOC_MAX_CACHE_SIZE and the caller must check that.
  */
 static inline struct kmem_cache *
-kmalloc_slab(size_t size, kmem_buckets *b, gfp_t flags, kmalloc_token_t
token)
+kmalloc_slab(size_t size, kmem_buckets *b, gfp_t flags, kmalloc_token_t
token,
+	     unsigned int alloc_flags)
 {
 	unsigned int index;
+	enum kmalloc_cache_type type = kmalloc_type(flags, token);
+
+#ifdef HAS_KMALLOC_NO_RECURSE
+	if (type >= KMALLOC_PARTITION_START &&
+			type <= KMALLOC_PARTITION_END &&
+			(alloc_flags & SLAB_ALLOC_NO_RECURSE))
+		type = KMALLOC_NO_RECURSE;
+#endif

 	if (!b)
-		b = &kmalloc_caches[kmalloc_type(flags, token)];
+		b = &kmalloc_caches[type];
 	if (size <= 192)
 		index = kmalloc_size_index[size_index_elem(size)];
 	else
diff --git a/mm/slab_common.c b/mm/slab_common.c
index b6426d7ceec9..8541f4a9cfda 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -783,11 +783,15 @@ u8 kmalloc_size_index[24] __ro_after_init = {
 size_t kmalloc_size_roundup(size_t size)
 {
 	if (size && size <= KMALLOC_MAX_CACHE_SIZE) {
+		struct kmem_cache *s;
+
 		/*
 		 * The flags don't matter since size_index is common to all.
 		 * Neither does the caller for just getting ->object_size.
 		 */
-		return kmalloc_slab(size, NULL, GFP_KERNEL,
__kmalloc_token(0))->object_size;
+		s = kmalloc_slab(size, NULL, GFP_KERNEL, __kmalloc_token(0),
+				 SLAB_ALLOC_DEFAULT);
+		return s->object_size;
 	}

 	/* Above the smaller buckets, size is a multiple of page size. */
@@ -843,6 +847,12 @@ EXPORT_SYMBOL(kmalloc_size_roundup);
 #define KMALLOC_PARTITION_NAME(N, sz)
 #endif

+#ifdef HAS_KMALLOC_NO_RECURSE
+#define KMALLOC_NO_RECURSE_NAME(sz) .name[KMALLOC_NO_RECURSE] =
"kmalloc-no-recurse-" #sz,
+#else
+#define KMALLOC_NO_RECURSE_NAME(sz)
+#endif
+
 #define INIT_KMALLOC_INFO(__size, __short_size)			\
 {								\
 	.name[KMALLOC_NORMAL]  = "kmalloc-" #__short_size,	\
@@ -850,6 +860,7 @@ EXPORT_SYMBOL(kmalloc_size_roundup);
 	KMALLOC_CGROUP_NAME(__short_size)			\
 	KMALLOC_DMA_NAME(__short_size)				\
 	KMALLOC_PARTITION_NAME(KMALLOC_PARTITION_CACHES_NR, __short_size)	\
+	KMALLOC_NO_RECURSE_NAME(__short_size)			\
 	.size = __size,						\
 }

@@ -966,6 +977,11 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type
type)
 		flags |= SLAB_NO_MERGE;
 #endif

+#ifdef HAS_KMALLOC_NO_RECURSE
+	if (type == KMALLOC_NO_RECURSE)
+		flags |= SLAB_NO_OBJ_EXT;
+#endif
+
 	/*
 	 * If CONFIG_MEMCG is enabled, disable cache merging for
 	 * KMALLOC_NORMAL caches.
diff --git a/mm/slub.c b/mm/slub.c
index 9f754cf1c187..a5745759f0af 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2123,42 +2123,6 @@ static inline void init_slab_obj_exts(struct slab
*slab)
 	slab->obj_exts = 0;
 }

-/*
- * Calculate the allocation size for slabobj_ext array.
- *
- * When memory allocation profiling is enabled, the obj_exts array
- * could be allocated from the same slab cache it's being allocated for.
- * This would prevent the slab from ever being freed because it would
- * always contain at least one allocated object (its own obj_exts array).
- *
- * To avoid this, increase the allocation size when we detect the array
- * may come from the same cache, forcing it to use a different cache.
- */
-static inline size_t obj_exts_alloc_size(struct kmem_cache *s,
-					 struct slab *slab, gfp_t gfp)
-{
-	size_t sz = sizeof(struct slabobj_ext) * slab->objects;
-	struct kmem_cache *obj_exts_cache;
-
-	if (sz > KMALLOC_MAX_CACHE_SIZE)
-		return sz;
-
-	if (!is_kmalloc_normal(s))
-		return sz;
-
-	obj_exts_cache = kmalloc_slab(sz, NULL, gfp, __kmalloc_token(0));
-	/*
-	 * We can't simply compare s with obj_exts_cache, because partitioned
kmalloc
-	 * caches have multiple caches per size, selected by caller address or
type.
-	 * Since caller address or type may differ between kmalloc_slab() and
actual
-	 * allocation, bump size when sizes are equal.
-	 */
-	if (s->object_size == obj_exts_cache->object_size)
-		return obj_exts_cache->object_size + 1;
-
-	return sz;
-}
-
 int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 			gfp_t gfp, unsigned int alloc_flags)
 {
@@ -2168,15 +2132,13 @@ int alloc_slab_obj_exts(struct slab *slab,
struct kmem_cache *s,
 	unsigned long new_exts;
 	unsigned long old_exts;
 	struct slabobj_ext *vec;
-	size_t sz;
+	size_t sz = sizeof(struct slabobj_ext) * slab->objects;

 	gfp &= ~OBJCGS_CLEAR_MASK;
 	/* Prevent recursive extension vector allocation */
 	alloc_flags |= SLAB_ALLOC_NO_RECURSE;
 	alloc_flags &= ~SLAB_ALLOC_NEW_SLAB;

-	sz = obj_exts_alloc_size(s, slab, gfp);
-
 	/* This will use kmalloc_nolock() if alloc_flags say so */
 	vec = kmalloc_flags(sz, gfp | __GFP_ZERO, alloc_flags, slab_nid(slab));

@@ -5330,7 +5292,7 @@ void *__do_kmalloc_node(kmem_buckets *b, gfp_t
flags, int node,
 	if (unlikely(!size))
 		return ZERO_SIZE_PTR;

-	s = kmalloc_slab(size, b, flags, token);
+	s = kmalloc_slab(size, b, flags, token, ac->alloc_flags);

 	ret = slab_alloc_node(s, flags, node, ac);
 	ret = kasan_kmalloc(s, ret, size, flags);
@@ -5395,7 +5357,9 @@ static void
*__kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_f
 retry:
 	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
 		return NULL;
-	s = kmalloc_slab(size, NULL, gfp_flags, PASS_TOKEN_PARAM(token));
+
+	s = kmalloc_slab(size, NULL, gfp_flags, PASS_TOKEN_PARAM(token),
+			 ac->alloc_flags);

 	if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
 		/*


-- 
Cheers,
Harry / Hyeonggon

