Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EE1BCD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:18:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0549B6B009E; Tue,  9 Jun 2026 05:18:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 005826B00A0; Tue,  9 Jun 2026 05:18:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E846D6B00A1; Tue,  9 Jun 2026 05:18:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D4A4F6B009E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:18:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8D3131204B7
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:32 +0000 (UTC)
X-FDA: 84859823664.04.C5F7B85
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id B693CC000F
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k4EYp5WV;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780996710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pi3O3D8NkrwDsiflwfpbJbAUdo/o74gPku/tjUk2wnc=;
	b=QAXookKSf8D5ipX/GW7DLiEAahscJO/gwnxL5SSiykt2qb/GiMdR6f0aO8gj6MLm5FmacE
	u1sBfCdXwOL3PU4EiaR72gikeZ442O6IcnV9WRiMczPyCNqnBSNU3W+nsxVxTnLKhni9k/
	p4bwEVxvErOeb8qXaqQs7bX4aOpHsLs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k4EYp5WV;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780996710;
	b=Lcwib2jFfsAdFTe3i07pQXmXitx7g4FDD0F7Txo7nCad+p117QBNxHbEF79pS4ruxpLv07
	12R2hyR166kDjGHBMjVIv9QofwdCfCm5bG7u+gWugyiZqSuGrAji9RL1qjGaU4BCXXGj71
	4Fv/L4JZDoLqliBwPUqKGW1QBCdbbqs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5616A601FE;
	Tue,  9 Jun 2026 09:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE1D1F00899;
	Tue,  9 Jun 2026 09:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780996710;
	bh=pi3O3D8NkrwDsiflwfpbJbAUdo/o74gPku/tjUk2wnc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=k4EYp5WVrNZXlKvH/rsFUgnWi5jQNPZ0/cTItnU98OxAcliXIFzqU1mosvG1Y1G8W
	 7uADeqxV3aNk9JiWUgOdt9K4P4mI9jUhZpi1KSm7NuuyrQOV+o9BbKFsohfE04emv7
	 APPgQqnnpvHeuG8crrXlb6kqDRlaXlAb1ibNirMLWqCnOkkoB4RiakAo/n4sGwya8R
	 uBk9+3iEX4/02ZPVIDsPxgMs0izEpQ9t5gxKl0dqRQLxC+KjBhneIFh2BBDzBMwPhx
	 COHB94NEZ9rOAEjddIetOiJ5vtNhIkhJQNfdWhvdoXvUpK+ZcDfTVrdL8/4rcnQO8q
	 7fPVB2J+XkaQg==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 09 Jun 2026 11:17:54 +0200
Subject: [PATCH RFC 09/15] mm/slab: replace slab_alloc_node() parameters
 with slab_alloc_context
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-slab_alloc_flags-v1-9-2bf4a4b9b526@kernel.org>
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
X-Rspamd-Queue-Id: B693CC000F
X-Stat-Signature: z4tpjxph3zrtidzo1hxrn5z1xhmjxm7x
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780996710-338166
X-HE-Meta: U2FsdGVkX191ea5U/wV6w0RjfldPDSMNd6kJ4elpRJ+oE7ZbDKIYgwZ4ZCLeUkCEuHV+blrWalRw1IrfTCHVvfCVvJUkkbjtauCF9qlQsADMS6at4kpGWyvBGrxYrrOy3SNRQsvBBPPwFejfNj0oKa8cUdw//amORDbTrbk64V9cLfUwz7I0Aj6WQivQYFAtEUWv6H/641CVj+BKwxFYvBBV6xEnqj0R7OW+Jn2xB4lW4ut3scwwzxj/kDAEghDhKotBPT72sQQiuqWvtcza0l6aIPdR1TW18bS8hkbmfpFxnisjNr6d0F2Dyi8Bm1prxc8YdB3CM3JK0TYRijTtzNKKHprJyOCmCSd/uha/hbBCflJOIGeTyf3ltPQy3GWscKg3LJSeUnoywsCWPdSqXnMGjY9bu+xNqH4qIRyMd0xCpnvKLM01CiEBljHuv59cQvlFQ++9roHbGYV7/ldslYefpWay1Z8pKeycfrwguSqgwx2lKIgFqIIFsz6PGr3aP2FagKgHAdscpCeW0eO7VE9PC4YBl5Q8kpgNth/47zNDRk/PA225DqA3ED4RkFNI/ebofLg0nR4F3EBSL1avVM8eMot7hFXyYOXy6bVSH1OlqGsdmoGhlw1nT09k7HoGA8PPINNcBWx7/GAVk50Fkh5/08vVaOcYA2JK5O9CMXYiKdsRAMjQT63DAztkjYeD8gEPnYy0krGBAP3NPf/D6M4LkK2PmcjpWYoRxgeoaxqmdZUv3IbP1MTkuHdc9tarytMprCGsLHeCTcs2+q5WelckcAsRosdkdXxw8Xpk94AFhNAdo94YH7ShkBXX+xpiKff7qer1EhkmIUc65cFRsRH/irpA2jyPFzoen5S5vdQTuyVCTQUWxAkErLiYsEWQ8JG/ocVnqir8jAfIWw6T37qplQLBrx3JmWYGnsWCgAQ4QH4v6NrxXhwtc7cIkwjhFxjCcfDZCKeV6gf+Ctb
 JdSglKo9
 efJrBNTSL17aW4dtgnZkvCRIt2KMVqcjyqcUYtl0M53QCuYKLK+wQSchLNMomo8dsQfDFqaWlBhex8Jl/c6bFKAuY7YHYnr8anmilPw3ASeYiorR95neF4OCgkFSJ6t0uf9hdRc2mWpzxLPKto9chjPoIzLQjZPRCBTlU7lKoueiI/PKmvn9rG8Ds2zowtsTTZHtwXXM9vSoVqPYb+BM2LRXKmhLolWsWo9m6zTL4cxY764kZ8euc6u5A4ehL9FmIZ5iZVGTY+qTL5BCoVoSY34IMulVhbtsTbqt/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function takes all the parameters that exist as fields in
slab_alloc_context, except alloc_flags. Replace them with a single
pointer.

This moves slab_alloc_context initialization to a number of callers,
which is more verbose, but arguably also more clear than a long list of
parameters, and most do not use the 'lru' field.

This will also allow kmalloc_nolock() to call slab_alloc_node() and
reduce the special open-coding it currently has.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 75 ++++++++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 53 insertions(+), 22 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 034f2cd1c1fd..b511d768e9b6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4905,30 +4905,23 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, gfp_t gfp, size_t size,
  *
  * Otherwise we can simply pick the next object from the lockless free list.
  */
-static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list_lru *lru,
-		gfp_t gfpflags, int node, unsigned long addr, size_t orig_size)
+static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s,
+		gfp_t gfpflags, int node, struct slab_alloc_context *ac)
 {
-	const unsigned int alloc_flags = SLAB_ALLOC_DEFAULT;
 	void *object;
-	struct slab_alloc_context ac = {
-		.caller_addr = addr,
-		.orig_size = orig_size,
-		.alloc_flags = alloc_flags,
-		.lru = lru,
-	};
 
 	s = slab_pre_alloc_hook(s, gfpflags);
 	if (unlikely(!s))
 		return NULL;
 
-	object = kfence_alloc(s, orig_size, gfpflags);
+	object = kfence_alloc(s, ac->orig_size, gfpflags);
 	if (unlikely(object))
 		goto out;
 
-	object = alloc_from_pcs(s, gfpflags, alloc_flags, node);
+	object = alloc_from_pcs(s, gfpflags, ac->alloc_flags, node);
 
 	if (!object)
-		object = __slab_alloc_node(s, gfpflags, node, &ac);
+		object = __slab_alloc_node(s, gfpflags, node, ac);
 
 	maybe_wipe_obj_freeptr(s, object);
 
@@ -4937,15 +4930,21 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 	 * In case this fails due to memcg_slab_post_alloc_hook(),
 	 * object is set to NULL
 	 */
-	slab_post_alloc_hook(s, gfpflags, 1, &object, &ac);
+	slab_post_alloc_hook(s, gfpflags, 1, &object, ac);
 
 	return object;
 }
 
 void *kmem_cache_alloc_noprof(struct kmem_cache *s, gfp_t gfpflags)
 {
-	void *ret = slab_alloc_node(s, NULL, gfpflags, NUMA_NO_NODE, _RET_IP_,
-				    s->object_size);
+	void *ret;
+	struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = s->object_size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
+
+	ret = slab_alloc_node(s, gfpflags, NUMA_NO_NODE, &ac);
 
 	trace_kmem_cache_alloc(_RET_IP_, ret, s, gfpflags, NUMA_NO_NODE);
 
@@ -4956,8 +4955,15 @@ EXPORT_SYMBOL(kmem_cache_alloc_noprof);
 void *kmem_cache_alloc_lru_noprof(struct kmem_cache *s, struct list_lru *lru,
 			   gfp_t gfpflags)
 {
-	void *ret = slab_alloc_node(s, lru, gfpflags, NUMA_NO_NODE, _RET_IP_,
-				    s->object_size);
+	void *ret;
+	struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = s->object_size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+		.lru = lru,
+	};
+
+	ret = slab_alloc_node(s, gfpflags, NUMA_NO_NODE, &ac);
 
 	trace_kmem_cache_alloc(_RET_IP_, ret, s, gfpflags, NUMA_NO_NODE);
 
@@ -4989,7 +4995,14 @@ EXPORT_SYMBOL(kmem_cache_charge);
  */
 void *kmem_cache_alloc_node_noprof(struct kmem_cache *s, gfp_t gfpflags, int node)
 {
-	void *ret = slab_alloc_node(s, NULL, gfpflags, node, _RET_IP_, s->object_size);
+	void *ret;
+	struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = s->object_size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
+
+	ret = slab_alloc_node(s, gfpflags, node, &ac);
 
 	trace_kmem_cache_alloc(_RET_IP_, ret, s, gfpflags, node);
 
@@ -5319,6 +5332,11 @@ void *__do_kmalloc_node(size_t size, kmem_buckets *b, gfp_t flags, int node,
 {
 	struct kmem_cache *s;
 	void *ret;
+	struct slab_alloc_context ac = {
+		.caller_addr = caller,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
 
 	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE)) {
 		ret = __kmalloc_large_node_noprof(size, flags, node);
@@ -5332,7 +5350,7 @@ void *__do_kmalloc_node(size_t size, kmem_buckets *b, gfp_t flags, int node,
 
 	s = kmalloc_slab(size, b, flags, token);
 
-	ret = slab_alloc_node(s, NULL, flags, node, caller, size);
+	ret = slab_alloc_node(s, flags, node, &ac);
 	ret = kasan_kmalloc(s, ret, size, flags);
 	trace_kmalloc(caller, ret, size, s->size, flags, node);
 	return ret;
@@ -5451,8 +5469,14 @@ EXPORT_SYMBOL(__kmalloc_node_track_caller_noprof);
 
 void *__kmalloc_cache_noprof(struct kmem_cache *s, gfp_t gfpflags, size_t size)
 {
-	void *ret = slab_alloc_node(s, NULL, gfpflags, NUMA_NO_NODE,
-					    _RET_IP_, size);
+	void *ret;
+	struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
+
+	ret = slab_alloc_node(s, gfpflags, NUMA_NO_NODE, &ac);
 
 	trace_kmalloc(_RET_IP_, ret, size, s->size, gfpflags, NUMA_NO_NODE);
 
@@ -5464,7 +5488,14 @@ EXPORT_SYMBOL(__kmalloc_cache_noprof);
 void *__kmalloc_cache_node_noprof(struct kmem_cache *s, gfp_t gfpflags,
 				  int node, size_t size)
 {
-	void *ret = slab_alloc_node(s, NULL, gfpflags, node, _RET_IP_, size);
+	void *ret;
+	struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
+
+	ret = slab_alloc_node(s, gfpflags, node, &ac);
 
 	trace_kmalloc(_RET_IP_, ret, size, s->size, gfpflags, node);
 

-- 
2.54.0


