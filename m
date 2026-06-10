Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 422BDCD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 15:41:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1AB86B009B; Wed, 10 Jun 2026 11:41:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F2166B009D; Wed, 10 Jun 2026 11:41:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92F9B6B009E; Wed, 10 Jun 2026 11:41:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 813DB6B009B
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:41:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3B5F712019B
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:41:07 +0000 (UTC)
X-FDA: 84864416574.07.4C04FB0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9199840010
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:41:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mnIo4SnC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781106065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yRohSSU7buAwP8rkGvuFsooGceecpgqW9FG/cY7L87c=;
	b=t0n+PzRJUHEiDuhifQUOqNMeKsC5bMolxynYzC21AakS2OtuNxWvQcMfXrVSQKbrWBlJQu
	iTn/tIsxQ8Adb2/xFdlRnb45X6jFZuCE/VY6gRqjux3tKHHolIYz/EHJPNVHap3QDfO0jw
	nTeYT89PcEdK7olbL9gapv7xbxHIU3U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mnIo4SnC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781106065;
	b=Mh2BYTeDCwd83YBuwYZ76K/nWKb8uU45LkAeaS8m+KQDOH0lYqj7boL+ylhMWmIMoZA64G
	5b/T3ayqmYQvDOxq+eo6LspYok2vJrNqg3wnm32xSAnGw/4gE81+c9QDhQ9U87RxRzaxeR
	OkULs8WDoQRZszzWTeOf7UufuyQ+2nM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 22807601E1;
	Wed, 10 Jun 2026 15:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E454D1F00893;
	Wed, 10 Jun 2026 15:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781106064;
	bh=yRohSSU7buAwP8rkGvuFsooGceecpgqW9FG/cY7L87c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mnIo4SnCqJZi4Zezto2wNu4R9ghQQlbBBS1ONRe0lv42vFME08dn0cs4xiR3ZtQC+
	 W/WEGkU0/zRVgGy4KlAwKUXewIIBBY/mfIoVx3rI54ZWxEXAxO2JMjk/RzZD+DKFRC
	 V7+1TDExqnms4jOu2eO9pNHmcLaR7QJ9qWHYXGmblyNs5lYHYJfko8GpU1cc79LCZw
	 FgrLywy46zNqot1QYCaUMSsxguO24wNGd2K5ig1lLBP3pCAfIjaPYuPvn/DbJI1gn7
	 J5s3wVmYglUFGS7abi/4zSN+AfWq9+MtKAcDTH4+M2oo2XV63fnhGioWrfaFUE6U+O
	 gJUEmgf82O+Eg==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 10 Jun 2026 17:40:08 +0200
Subject: [PATCH v2 06/16] mm/slab: add alloc_flags to slab_alloc_context
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260610-slab_alloc_flags-v2-6-7190909db118@kernel.org>
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
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: wcywt3k7rr8s5yg1um9iembsff8i58tu
X-Rspamd-Queue-Id: 9199840010
X-HE-Tag: 1781106065-500092
X-HE-Meta: U2FsdGVkX1/RnuFISmALYq13L/xCWcWqqoCI1OTXkGD/KI9wVqU7hd1fcSc+FjynnIkgZiko4FskyY79hJTJPKNbh3h8zq22qPneSVbHevRMlHUGPYcEJ62OwyU6RqvQ7Yb71lJLtKPb0I/1nNfDq0rTCDLmN5nmXOPBtA4cP2DdXbpdKv1GI0HcEL+pbHngVNFlphCH7g9QIAKdC5vN0xsbY4UIFfluhPbx4nYnkLSLto/au8kmdQw2kapXtY4rBq5Y8WaTlFvUlGujEM5elb8qA6ZH1ZjpQRhMx1TapynlqL+94pzpSvuGGX/bRQCvg5HhlQYU/o3RqciGrxaRriUNaNmptyj0zV/9qhfhk+jqH27jLylf35zJM1AW6D6BshPOAQJGqaaw/XBk6kuYLx1fCqSIftRW9fVD65fTDEehFaffuGJt2JckRnZAEi+4+GIRuphskZgRYD3/yUJMo3RrT8647HIg5OaLA1GCDU+Squ0rBknNSGb7VH3Lu1lTTNl9i9++e8LxmKphRrVngH3dw0WZatj3Ad3h1pzDJey6CU+lZsuduuiajPoG8hORKn8aca61byNrCP8Unz1MrSn7atxsZeAieKuFKRCdlVqxetTHkpeUuaisiJNlzesSQ8/nqAQF3eYZRi5Vc0TDxNJLcG/gYBunKn4i5q3oD9yF7B5tiCMkuL8hrL2hLtQ4NmB8pKY4pCq1cXeRPCBHy5eUziDvlOiJs2tMsB2nkryf2fNpwTCdV95xMrjcRtbUcsA6NkPJyH0yAQenk3lnQA/fyx4b2H0FfmteWD8oEXbqt5ct5M6VqYd7hcPKB836Gi9SMZFxo8R0BvYZhmCzVexV/C0h6AuMlguhXQUE529uCR2qmGSEX/TgmeTOC7ja43lPuwX5gsOffjdSOkpTwwyoWkp/tOSJHRalgikewqb1ub18vMEzad2rwHdCXUkGS0ZAK0ubLWXa9XPrWMW
 rh5frGSi
 I6MU0pHLBiZm+Dhw1sb2cWYMn4PEAQCmdVTycdy7arkVelOaMSFqjl6zJvISPCraCExpLAXPBKnte2lNmAGAIr9IOGIrZhY0/C6iRM4skZKKDubqqwiJ+J/xc5FuJwGUjgKZWDOWn3utJ8ZmNIpfPAuX2HEWs9hh0DFAM9Cq1JwZzVAr6lB8LMN5A7pzO63+n5P1UCbpJXed8Ku9zaWhDmxSDyG+NPiiQOGCToORfLxFMoc8TDOqO1U/cympRy9TIt/uMC+/VFLd2TfTf8YK1apQELC0hEnmjIGza
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
index e79fbca11bc0..ef745b37d063 100644
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
@@ -4919,6 +4920,7 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, gfp_t gfp, size_t size,
 static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list_lru *lru,
 		gfp_t gfpflags, int node, unsigned long addr, size_t orig_size)
 {
+	const unsigned int alloc_flags = SLAB_ALLOC_DEFAULT;
 	void *object;
 
 	s = slab_pre_alloc_hook(s, gfpflags);
@@ -4929,12 +4931,13 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
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
@@ -5406,6 +5409,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 	struct slab_alloc_context ac = {
 		.caller_addr = _RET_IP_,
 		.orig_size = orig_size,
+		.alloc_flags = alloc_flags,
 	};
 
 	/*
@@ -7256,6 +7260,7 @@ static bool __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
 		struct slab_alloc_context ac = {
 			.caller_addr = _RET_IP_,
 			.orig_size = s->object_size,
+			.alloc_flags = SLAB_ALLOC_DEFAULT,
 		};
 		for (i = 0; i < size; i++) {
 

-- 
2.54.0


