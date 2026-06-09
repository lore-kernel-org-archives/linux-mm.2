Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2172FCD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:18:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 892186B00A8; Tue,  9 Jun 2026 05:18:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8429A6B00AA; Tue,  9 Jun 2026 05:18:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77FC56B00AB; Tue,  9 Jun 2026 05:18:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66B7D6B00A8
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:18:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3474C8DD36
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:40 +0000 (UTC)
X-FDA: 84859824000.17.83997F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9775E100004
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FUt3cilt;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780996718;
	b=DEu4XhiUG8x8nDbt5zO56gdPreFLV866jbGDItUr6gy1Q1eWM+kmukXiHYEcNgBGXm8wlK
	6Y6A1K0K2KoIN6j29YkytRFy+BzQzTInd4Us+YLPX/5Vd1BioR8FUxTJLrzrS1BU/eHt1T
	NbtU91BHfVrk29ZfJq4qrE1z0MWsnM0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FUt3cilt;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780996718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=atZYs+VWD5R8CjJ56mv03lmgYQhNeJOPFzN8FlEDrB0=;
	b=wRw7bIueKCDG0Fc4x4km+R7c7G3/7pGe/Mp6DofvHkOMCu5UOTVMJtgNAcKP91VH+NF1BI
	a7CbRVWVv+ROni7SWHEIcFVY8vZGCCR8S73JEcjEeCgfSILYfZU8E7VuOff3KKta66AZcK
	phT1JM2AT5cXqY/XCU3z+H6iO4NTl/4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3297660204;
	Tue,  9 Jun 2026 09:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691B41F0089F;
	Tue,  9 Jun 2026 09:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780996717;
	bh=atZYs+VWD5R8CjJ56mv03lmgYQhNeJOPFzN8FlEDrB0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FUt3ciltM1LEhEJtZsSvYQ8r1fIqeDJk2DDs9/ac4OucfY6/Zzh3NY3c2NNOzn4D1
	 lmATl8qFFczlRIN6ySJiz0AnL3w9PYN5K6laadglDmefqkjpgZHr4QXH1iz208g9Zc
	 DBzPvokXd6ouJemC5ifyFhHkWm9N5Q49uBZIYYqpzl4qeYnZDfPIn6Nlc6yYae7bKl
	 EWJPrkzzE7+5QnjUkDSuIaqaI5R9RGfpwVLZPLB3N7hKjsxlQ1pJwbbtxmkbjFFQlM
	 NuH8M2itG4sURmoRO6NUNmH5V/onOTbLMcprveyEmThpR4Bd2VQ2dGQnFOz5HXvfv+
	 IRszgI52iciaQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 09 Jun 2026 11:17:56 +0200
Subject: [PATCH RFC 11/15] mm/slab: pass slab_alloc_context to
 __do_kmalloc_node()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-slab_alloc_flags-v1-11-2bf4a4b9b526@kernel.org>
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9775E100004
X-Rspam-User: 
X-Stat-Signature: bgkcbq7s19gmm1pi641r1gx49ackm7to
X-HE-Tag: 1780996718-968715
X-HE-Meta: U2FsdGVkX19LX6+vOOhOceXVfsmVTbMMcaLFPw7Oo7x3Sh8wJIZREh/C07qmAbojAGgmMxcQbHOKh1DsIGSKO4ITBS4w0I4S9TkrauARmPYeDFl4YeiL+JW54yPcVbYidFGJ+twbjSH4qgK1pGmBljx6+sxToWoyTuueN4faD6lpwl7tCEBfL5o93IhUFF3EjDtlK78z3j2lC7HJjLlw7w1wODqzTGHnerqHdF8vwoWaBGkknrWAbZV1Prv5Rj+NY+Y0bAWfOzRgjIlWhtkCbDZn/ZdcEtCXr4iERp7Cu0S4Fqps4aOeHZ9hMeVAmN3eXR8ZpotCzA6UVyD+9HNd7VpvXq/kMABTqgyS1+xnQ/MaJwxyz1dz9aLmY/vCcnNE1At2DupaksKZjZTM1u4bp89enZNlnci3qUMpkYYUJ/1vCm47SdKokO21+1vjiYJLjarOyYNCkkFet8OBb83onEXR0Oifd3JstEXx8wKKd4pwi2Gx6QZny6QfDQj2ChA+EJzezBagAyXqyjsxmDJu3xgNhRIrAseNeVOQU4cUoRf95hqbOyVABlyyPmibAVGBUOs2VFdc8FaZHOe9xf45cEVLp/kP3qqTq/8hZsIj199oTmDixjc4f2awyGislMRvT4d4FPYLVjVrT3WI7JXgkH3bj/NGkrnSxJDL6EHurwEhHPsmQ5z7yPSYLlZdl0i4Sy9aDcq6gEb/IJ7yvm6wwrQzgiWhiqLsP9TpKAx1jxKm4JQRHMbIweGiVnOT0BdGDi1akqEMC6tQON6edMG7pYXvYRZA8CZ8keQAq7e64mqWSB15KW4LfcveZ49dOI7f38aMNpPu6gNWnU8wszGBw3RU87guWkrdQJ+3LjRwJHQEVnp/GHILmM+sHP25GFSXRtEX4s/brBmdFesvLFlDLeRlbhckXBUq1RYx9LnMU8hxMyA7ryfAg1HHqACyhuqiZFg5Kast30K0dwCeRAV
 1LcvZsmQ
 PTpbdXZk42t+0SLiNbbyUS+W9CiwjJhpfHJebdmDhbHzH2kilNDrMS9S+vAGdfdgPetiGZDAqcwWEQortuQ8sBvtQw5TQ/Qs/iKvSQzRg/MrbbQQ6a2zpIN1FJa4YOd/jK/jxlTrHcSwXceLrxE9Yep4GGBh4eMPyuaXUfCUX4TJY7OcyfqnhBj3b0s31tRZ1ojEC/J/SvuU1fffN3MCUwUW+rur2B935TsgiNCWkRyONdAuYNwfH563zxh/WzcVS6LCKk7H532+pEMUh2g+7KUXvxHYGh519AGn7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With alloc_flags usage in slab, we can replace __GFP_NO_OBJ_EXT with an
alloc flag that prevents kmalloc recursion. For that we need a version
of kmalloc() that takes alloc_flags and use it in places that perform
these potentially recursive kmalloc allocations (of sheaves or obj_ext
arrays).

As a preparatory step, make __do_kmalloc_node() take a pointer to
slab_alloc_context. This replaces the 'caller' parameter and includes
alloc_flags which we'll make use of.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 47 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index dee69e0b7780..c11edd58b52d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5322,19 +5322,14 @@ EXPORT_SYMBOL(__kmalloc_large_node_noprof);
 
 static __always_inline
 void *__do_kmalloc_node(size_t size, kmem_buckets *b, gfp_t flags, int node,
-			unsigned long caller, kmalloc_token_t token)
+			kmalloc_token_t token, struct slab_alloc_context *ac)
 {
 	struct kmem_cache *s;
 	void *ret;
-	struct slab_alloc_context ac = {
-		.caller_addr = caller,
-		.orig_size = size,
-		.alloc_flags = SLAB_ALLOC_DEFAULT,
-	};
 
 	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE)) {
 		ret = __kmalloc_large_node_noprof(size, flags, node);
-		trace_kmalloc(caller, ret, size,
+		trace_kmalloc(ac->caller_addr, ret, size,
 			      PAGE_SIZE << get_order(size), flags, node);
 		return ret;
 	}
@@ -5344,22 +5339,34 @@ void *__do_kmalloc_node(size_t size, kmem_buckets *b, gfp_t flags, int node,
 
 	s = kmalloc_slab(size, b, flags, token);
 
-	ret = slab_alloc_node(s, flags, node, &ac);
+	ret = slab_alloc_node(s, flags, node, ac);
 	ret = kasan_kmalloc(s, ret, size, flags);
-	trace_kmalloc(caller, ret, size, s->size, flags, node);
+	trace_kmalloc(ac->caller_addr, ret, size, s->size, flags, node);
 	return ret;
 }
 void *__kmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags, int node)
 {
+	struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
+
 	return __do_kmalloc_node(size, PASS_BUCKET_PARAM(b), flags, node,
-				 _RET_IP_, PASS_TOKEN_PARAM(token));
+				 PASS_TOKEN_PARAM(token), &ac);
 }
 EXPORT_SYMBOL(__kmalloc_node_noprof);
 
 void *__kmalloc_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags)
 {
-	return __do_kmalloc_node(size, NULL, flags,  NUMA_NO_NODE, _RET_IP_,
-				 PASS_TOKEN_PARAM(token));
+	struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
+
+	return __do_kmalloc_node(size, NULL, flags,  NUMA_NO_NODE,
+				 PASS_TOKEN_PARAM(token), &ac);
 }
 EXPORT_SYMBOL(__kmalloc_noprof);
 
@@ -5455,9 +5462,14 @@ EXPORT_SYMBOL_GPL(_kmalloc_nolock_noprof);
 void *__kmalloc_node_track_caller_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags,
 					 int node, unsigned long caller)
 {
-	return __do_kmalloc_node(size, PASS_BUCKET_PARAM(b), flags, node,
-				 caller, PASS_TOKEN_PARAM(token));
+	struct slab_alloc_context ac = {
+		.caller_addr = caller,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
 
+	return __do_kmalloc_node(size, PASS_BUCKET_PARAM(b), flags, node,
+				 PASS_TOKEN_PARAM(token), &ac);
 }
 EXPORT_SYMBOL(__kmalloc_node_track_caller_noprof);
 
@@ -6858,6 +6870,11 @@ void *__kvmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), unsigned long
 {
 	bool allow_block;
 	void *ret;
+	struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
 
 	/*
 	 * It doesn't really make sense to fallback to vmalloc for sub page
@@ -6865,7 +6882,7 @@ void *__kvmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), unsigned long
 	 */
 	ret = __do_kmalloc_node(size, PASS_BUCKET_PARAM(b),
 				kmalloc_gfp_adjust(flags, size),
-				node, _RET_IP_, PASS_TOKEN_PARAM(token));
+				node, PASS_TOKEN_PARAM(token), &ac);
 	if (ret || size <= PAGE_SIZE)
 		return ret;
 

-- 
2.54.0


