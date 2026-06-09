Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9C1ACD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:18:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ECEC6B0096; Tue,  9 Jun 2026 05:18:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C3AA6B0098; Tue,  9 Jun 2026 05:18:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DA2D6B0099; Tue,  9 Jun 2026 05:18:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0F3126B0096
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:18:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D40EAA040A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:16 +0000 (UTC)
X-FDA: 84859822992.29.E4E8ADF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3548A4000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fuQh7gWD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780996695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UaSnETjCVjKQXWJX1aoWsst86Gp93Bm51zl46Fnvd9Q=;
	b=wW+DlpCTL2YavQOq8eZkvhfcLMoiyYGi0sy29Ls6yejwShGZSO0136QfmHbpWqfw831tYC
	rmqXwGFScRQfleYGqK0a8R+UhtUcTpkaEJvvbrvBJfVfsV6I7v1/i2fbbSmu5YYEtvPXKp
	0x478Gnm3EHmCOmNyOriCqB50T3D6bY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fuQh7gWD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780996695;
	b=mWwUBVPgmeAFS/EKEBVK65egYZMWtnRPGAFEwjVnDRtcrjUQWRjaJAwSLrBVRvbP5bVGYS
	3kzo3TRua7oOuo/fif3UUg2XSNQ9oIF66saDKF5mjbZLU6kpUCQqwpImzDJOOUEosm++ao
	PzmbVilO0y2QZzGefa1VkFSlFPCiYOY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7640843405;
	Tue,  9 Jun 2026 09:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D762D1F00893;
	Tue,  9 Jun 2026 09:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780996694;
	bh=UaSnETjCVjKQXWJX1aoWsst86Gp93Bm51zl46Fnvd9Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fuQh7gWDayJSvLXaB+wnx5dQuD5ZWO3KkG541FD7WN8TTBLqUfkzaQdPnG8Z972n8
	 FEEn1P++JxpaAG/u7Q51YwJ4k4indiGn8LAAOeiLW5b81km8G/bc48kOSuUaqUJucB
	 WeJ4ZxSEzWNPDBKbVhwmmzqeawSPoZnDGZSbyI+aQ58Ol4HtjK9EIXCTNuxTkljNjv
	 TBcqmly6vqldZyJX7J0CV24jhy3TUQvrOPyHgLSq/ZTu7faTh9UtfMAQK4yc2F/zO3
	 Tut+uyQ13I4Izx7CJe5Q3VuqQBSY3mq37X6VXKzwCbOxlevwCcEOPgvbIhc4GYZ529
	 crHcT/FegA1KQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 09 Jun 2026 11:17:50 +0200
Subject: [PATCH RFC 05/15] mm/slab: add alloc_flags to slab_alloc_context
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-slab_alloc_flags-v1-5-2bf4a4b9b526@kernel.org>
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
X-Rspamd-Queue-Id: 3548A4000A
X-Rspam-User: 
X-Stat-Signature: 8ccenieutymt76wod156ar69c8kxfwfc
X-Rspamd-Server: rspam09
X-HE-Tag: 1780996695-465611
X-HE-Meta: U2FsdGVkX193ta9gWXyqzLNuODWO4zku5Uc+5llurCJGQKSHIFHYw0Acv6LZx14637IgAf0azANFvPsVk0kzrycybWJbRLYngJyEE2KLyBiqQt4v91SGse7+gA9vvFNutWmoiBDNZkDluhVaZslhckBluWKse9jhlAqfKzxLIkBuLg8PvJRtItRpoAPgp6oBkqRDkBHza3KmPmvgjZ9w2dQSPQG9TgPqHgRyCRmpSyjtFUkLvE57zjaRPArNZZU9MkfLFhg6R9kzfeH9ISksHPKpXXQvvDNyClt0RrD90kZpyu9nJcarIlo1qf2afWGiAPivgFWIjzpX79Oe3Rz+ZNPS2W8eBVP8G6nb35b+yH2Drz0t3DGVXLbSIIxUqk1GXYP+8UnWC7BF+x596ylMmR+ooTO/y9AXt6bgHfrZ+lzMWhw4+2xgU5p/kJllz6KNX8gv+84ekHaHNGYY9ijAHj8YxjJ+BFLoHo2rTYq5rMigoPtSD49MCQEdO1J9cCoIMm7uWsVvt6DXFJz08KPRmk486mYMGjTZATqiAPZHXxsTsvp+aDqeZhoykL0wF2QaGc8vVn8Lzy2/SGWnhAYVmVUVTIkNwC0HewOOXcWdIF3DHsCfL9eALDcXehKuDgtKHLDNMQw8gLfWZlivSvCU7Pl4xWS3yePIEhRownqBEYisJF0t7asT3EhU9LuiejoHVx9DT54fOj1/Qb54PVWUxXOmj9MVkiaaLM8VvwWiIN5l+O144yW+cNRhE67kOno8s6T0XyZiJ7hVYowqkJwFfJoNckV7ODGtElNDBYn72KczyyfCeHShynSA1vh+b9+f+AH6nIqFwo4aqip8pFXNvFN7PjwF0MERHdbWBukyE+s5i1455FWrPX0OBOYvtP3U+9x8v1fSYvCC8kXYwn5auHuuDn+SMpIo1RGh5e7NjGFEeYM76gT7e8S1IrRhIzEsp2rbLKCZVcN9pu/HCae
 o9Cakp+E
 77OGodL2Wd3X/8cfuv85ZrCqD+59ORy9cBsqeHOaiEk/NDb0Br52ormwJwNnlZ6r5QsnaX3aIEaClQnETpO7OsOtQZ9oRUUzZYSZP8IqPSdyDgVVPH2YKuqHGyiL15n0GjLEQetze9DFvcY2vrBExPE59so2Q+pIlE1kxypVVfRamjgvE6WYUxTG+qswiW9tZlUtBw/fH3D5CGVXLv3vKeJ9UOJaBGQZb/AVWQhVu9qGx0gH6w7mci9FfYvLIKDslacJhiXCzdpQ1zEw/4PHw3+dbycPAOsIQ/yMI5UOC0+iEy3k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add alloc_flags as a new field to the slab_alloc_context helper struct,
so we can pass it to more functions in the slab implementation without
adding another function parameter.

Start checking them via alloc_flags_allow_spinning() in
alloc_single_from_new_slab() (where we can drop the allow_spin
parameter) and ___slab_alloc(). This further reduces false-positive
spinning-not-allowed from allocations that are not kmalloc_nolock() but
lack __GFP_RECLAIM flags.

_kmalloc_nolock_noprof() initializes ac.alloc_flags using its flags that
are SLAB_ALLOC_TRYLOCK. slab_alloc_node() and __kmem_cache_alloc_bulk()
are not reachable from kmalloc_nolock() and all their callers expect
spinning to be allowed, so they can use SLAB_ALLOC_DEFAULT. This is
temporary as the scope of slab_alloc_context will further move to the
callers, making the alloc_flags usage more obvious.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 278d8cbcc7ee..b2a452dd70fa 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -217,6 +217,7 @@ static DEFINE_STATIC_KEY_FALSE(strict_numa);
 struct slab_alloc_context {
 	unsigned long caller_addr;
 	unsigned long orig_size;
+	unsigned int alloc_flags;
 };
 
 /* Structure holding parameters for get_from_partial() call chain */
@@ -3693,9 +3694,9 @@ static inline void init_slab_obj_iter(struct kmem_cache *s, struct slab *slab,
  * and put the slab to the partial (or full) list.
  */
 static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
-					struct slab_alloc_context *ac,
-					bool allow_spin)
+					struct slab_alloc_context *ac)
 {
+	bool allow_spin = alloc_flags_allow_spinning(ac->alloc_flags);
 	struct kmem_cache_node *n;
 	struct slab_obj_iter iter;
 	bool needs_add_partial;
@@ -4452,7 +4453,7 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
 static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 			   struct slab_alloc_context *ac)
 {
-	bool allow_spin = gfpflags_allow_spinning(gfpflags);
+	bool allow_spin = alloc_flags_allow_spinning(ac->alloc_flags);
 	void *object;
 	struct slab *slab;
 	struct partial_context pc;
@@ -4503,7 +4504,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	stat(s, ALLOC_SLAB);
 
 	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
-		object = alloc_single_from_new_slab(s, slab, ac, allow_spin);
+		object = alloc_single_from_new_slab(s, slab, ac);
 
 		if (likely(object))
 			goto success;
@@ -4903,6 +4904,7 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, gfp_t gfp, size_t size,
 static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list_lru *lru,
 		gfp_t gfpflags, int node, unsigned long addr, size_t orig_size)
 {
+	const unsigned int alloc_flags = SLAB_ALLOC_DEFAULT;
 	void *object;
 
 	s = slab_pre_alloc_hook(s, gfpflags);
@@ -4913,12 +4915,13 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 	if (unlikely(object))
 		goto out;
 
-	object = alloc_from_pcs(s, gfpflags, SLAB_ALLOC_DEFAULT, node);
+	object = alloc_from_pcs(s, gfpflags, alloc_flags, node);
 
 	if (unlikely(!object)) {
 		struct slab_alloc_context ac = {
 			.caller_addr = addr,
 			.orig_size = orig_size,
+			.alloc_flags = alloc_flags,
 		};
 		object = __slab_alloc_node(s, gfpflags, node, &ac);
 	}
@@ -5390,6 +5393,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 	struct slab_alloc_context ac = {
 		.caller_addr = _RET_IP_,
 		.orig_size = orig_size,
+		.alloc_flags = alloc_flags,
 	};
 
 	/*
@@ -7240,6 +7244,7 @@ static bool __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
 		struct slab_alloc_context ac = {
 			.caller_addr = _RET_IP_,
 			.orig_size = s->object_size,
+			.alloc_flags = SLAB_ALLOC_DEFAULT,
 		};
 		for (i = 0; i < size; i++) {
 

-- 
2.54.0


