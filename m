Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43FC2CD98DA
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:55:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF9E26B00A0; Mon, 15 Jun 2026 07:55:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAB1F6B00A1; Mon, 15 Jun 2026 07:55:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C1006B00A2; Mon, 15 Jun 2026 07:55:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F3F96B00A0
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:55:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 587011409DA
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:55:22 +0000 (UTC)
X-FDA: 84881991684.15.6CC019F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id A1E134000E
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:55:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ki1+3FRP;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781524520;
	b=v5ItDz/rpjIS14188IZrwUde2LWTbcPlZfQR0D5XTK6D2UiqGRZPuxT2mJNVswo/i9jpns
	6beYPUecCiYMwoZecbWQXNZu0KicE6grC9iNSq9lQKWdV6U+0gZ7L1VHaxvpyeGkpdtiwi
	8xxZWRWkirCkcDtFT7ouzYRMtwkxLYA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ki1+3FRP;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781524520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b/ONCctF5YKbZLzEkUCbIbq/8VsD8siPyJ17yXksSxM=;
	b=bvf2DxIBKxJ1C/j7wSNPFJWir932G0UATsQWbGDt2xYtJgSDz/8vAjb2QY3bRkcplx3eur
	ViCRZ4mUv6rj3sF55ox5qKa5d6fhN24d5VeSbuBznbgqRjLFYDBYXIsQ7yGLbrfGJ3fU3V
	h+KB6zSvAlUSLWC45r8oysy6QjqL500=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E15D94199C;
	Mon, 15 Jun 2026 11:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D0D1F000E9;
	Mon, 15 Jun 2026 11:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781524519;
	bh=b/ONCctF5YKbZLzEkUCbIbq/8VsD8siPyJ17yXksSxM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ki1+3FRPY5COKqVJtaJLCbGM5L/1vyiu41LlO4SMEIKmvm+Bl3T5L51NUYZX9kYfA
	 GuGcjm+Z1kzfTDxuJ8/K19Dhw7WuQ9O88hc0nw17v3EpGbZdXXRPQHOkauWdB3UM4a
	 34NXRdCganp015gkodc7LTz3LcigGHmlbYPhUPypBk9wy69eBSLhSldror/coHgSvc
	 6u4oZrDQBZ4xiRROFSlWMtZJFGKnbK2TewAudWsJy/bIDFMMrdk3uTEz8fnTD10y3x
	 YkFhFqPqT7zXeN/jGK6AtoRM2/11ps9qe/pQdqXfGQ3BVDm6AGa0SYCq6mF3p0TAzy
	 jv7MHn5+x1Giw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 15 Jun 2026 13:54:42 +0200
Subject: [PATCH v3 09/15] mm/slab: replace slab_alloc_node() parameters
 with slab_alloc_context
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-slab_alloc_flags-v3-9-ce1146d140fb@kernel.org>
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
X-Rspamd-Queue-Id: A1E134000E
X-Stat-Signature: sei6nbpoge91d4511s6b17na4crjeuax
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781524520-80627
X-HE-Meta: U2FsdGVkX1/f+sWwvN41oTKBz385v3xJoBAaKrFulBILtNQ+SPARaqNiqiQ3kDCm5SciXmXkdKcPVDQXEp1j1XMVxKr67KjYqjmwNUzYTgBIpX292aMlkfa+ixOea08IGa4NBZMnmSSyb/63tWNO3xpGHC3/dFa0VpqBI1ivRAkYHAM+1YYyMYTpu85qbziBvRM8nKdFH2DD4TZgmkAYkQ4O/tztCQt02bcZvNHVGrX+ZqaNlUrA3EjJJaQjBL4IxQJ3yevcr3IAJOCkpclWpMmDbxiU50mXvMkt4cRr3pd0b+Ng9W7+vlXJNwHThAEPBdizFU38uLh9h5SO/83jPUxBpu2SVSjWYIREhE/3K4QnoO6WHaZYiFOUJVNxnNPGVO1v3K8yfZS+WSzzTW8GmY0hcNv2z85Z7VTibsO4n3KtEc5Hvu+cO6AaQgBd9mgRrS4riABfctJffmRNFBdwRqfp8pG40wyM9Hvi32ogBXfAuaSPZ+96c6M98UXYCgxAyVZmrMocM+UtoiooQnVkWenGcwFCfDJ2m+Jv0GUjyjrpxOPhlM+grJWuZnKf3bM1H2gMDVG2Ubmn+/JDVQ0ue0AZAUfQmSyutPhcJONirbx3NVQUpSQzpF0kmyr/v1hp8UahFoTh4hVPEa7FqxAfyep5iMHhZR1HH3HOIf+4JxvGaUVq1dVyKQSXMU7tip4PteVUzDVBfgtI9Jae7uGOly1AdXw01skodAtLN5rHBrT2vpQk6vxWQFIEOrXmrdswNtiMLPUntaWlGttuH3MFFhWviygBiqPBoqbX34AmYbG/A4VAYZ2KUh0p//JgCFdtYiLhHoNDXxRRW3xQdnctu9ISWLBBn9C1/dGv2a79vAJlh68noFbA1VNziVZwSFaeh1QAYzxwruiz6Y2xtP69dMnntM6ugT+TkIi2Lf4dWCVBkKzlneZUfhpNV4lF2cctBiZXoxWZ3xww1dcrdRQ
 ZF042WUt
 QFsVh0qJFrzaYUhwnZscMfpjo2z8s2a1hZSpDQRWCQu2vZpPolXFQ3OLjROdlScJ+i275NC9yvxYvSFLbrIbdJRiK/pC2M007f4IUzzNquR5rdglIQcWTuwBdxHmz36itfQNED9nVu0Yj///TovTgTdXKdwUcCcaaZVkVkLc0nFPR6nV12hriYcmp3Thz8bdSHa7R8s9Vq0ILBbdpWNLP27eJHLARnJ5xc8l7AdZW3zE9iNQubi8k6AfKprOu7G2HCDcxOCCv3xS3I+veIpOyoOQXolNvriNDABkaYm4xDPbKP3nyPjk0QzSyFL49nmUdr3fYzw+uZxf45Q/evL/BFws75XaeLBf60iXGMYraVf81so3SStbRRqNIZW0btKQepZaMWk2vAH8lHlPb6v2MxHDnuQ==
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

Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-10-7190909db118@kernel.org
Reviewed-by: Hao Li <hao.li@linux.dev>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 75 ++++++++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 53 insertions(+), 22 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 465eb4db5770..562495b80d74 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4920,30 +4920,23 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, gfp_t gfp, size_t size,
  *
  * Otherwise we can simply pick the next object from the lockless free list.
  */
-static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list_lru *lru,
-		gfp_t gfpflags, int node, unsigned long addr, size_t orig_size)
+static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s,
+		gfp_t gfpflags, int node, const struct slab_alloc_context *ac)
 {
-	const unsigned int alloc_flags = SLAB_ALLOC_DEFAULT;
 	void *object;
-	const struct slab_alloc_context ac = {
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
 
 	if (unlikely(!object))
-		object = __slab_alloc_node(s, gfpflags, node, &ac);
+		object = __slab_alloc_node(s, gfpflags, node, ac);
 
 	maybe_wipe_obj_freeptr(s, object);
 
@@ -4952,15 +4945,21 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
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
+	const struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = s->object_size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
+
+	ret = slab_alloc_node(s, gfpflags, NUMA_NO_NODE, &ac);
 
 	trace_kmem_cache_alloc(_RET_IP_, ret, s, gfpflags, NUMA_NO_NODE);
 
@@ -4971,8 +4970,15 @@ EXPORT_SYMBOL(kmem_cache_alloc_noprof);
 void *kmem_cache_alloc_lru_noprof(struct kmem_cache *s, struct list_lru *lru,
 			   gfp_t gfpflags)
 {
-	void *ret = slab_alloc_node(s, lru, gfpflags, NUMA_NO_NODE, _RET_IP_,
-				    s->object_size);
+	void *ret;
+	const struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = s->object_size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+		.lru = lru,
+	};
+
+	ret = slab_alloc_node(s, gfpflags, NUMA_NO_NODE, &ac);
 
 	trace_kmem_cache_alloc(_RET_IP_, ret, s, gfpflags, NUMA_NO_NODE);
 
@@ -5004,7 +5010,14 @@ EXPORT_SYMBOL(kmem_cache_charge);
  */
 void *kmem_cache_alloc_node_noprof(struct kmem_cache *s, gfp_t gfpflags, int node)
 {
-	void *ret = slab_alloc_node(s, NULL, gfpflags, node, _RET_IP_, s->object_size);
+	void *ret;
+	const struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = s->object_size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
+
+	ret = slab_alloc_node(s, gfpflags, node, &ac);
 
 	trace_kmem_cache_alloc(_RET_IP_, ret, s, gfpflags, node);
 
@@ -5334,6 +5347,11 @@ void *__do_kmalloc_node(size_t size, kmem_buckets *b, gfp_t flags, int node,
 {
 	struct kmem_cache *s;
 	void *ret;
+	const struct slab_alloc_context ac = {
+		.caller_addr = caller,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
 
 	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE)) {
 		ret = __kmalloc_large_node_noprof(size, flags, node);
@@ -5347,7 +5365,7 @@ void *__do_kmalloc_node(size_t size, kmem_buckets *b, gfp_t flags, int node,
 
 	s = kmalloc_slab(size, b, flags, token);
 
-	ret = slab_alloc_node(s, NULL, flags, node, caller, size);
+	ret = slab_alloc_node(s, flags, node, &ac);
 	ret = kasan_kmalloc(s, ret, size, flags);
 	trace_kmalloc(caller, ret, size, s->size, flags, node);
 	return ret;
@@ -5465,8 +5483,14 @@ EXPORT_SYMBOL(__kmalloc_node_track_caller_noprof);
 
 void *__kmalloc_cache_noprof(struct kmem_cache *s, gfp_t gfpflags, size_t size)
 {
-	void *ret = slab_alloc_node(s, NULL, gfpflags, NUMA_NO_NODE,
-					    _RET_IP_, size);
+	void *ret;
+	const struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
+
+	ret = slab_alloc_node(s, gfpflags, NUMA_NO_NODE, &ac);
 
 	trace_kmalloc(_RET_IP_, ret, size, s->size, gfpflags, NUMA_NO_NODE);
 
@@ -5478,7 +5502,14 @@ EXPORT_SYMBOL(__kmalloc_cache_noprof);
 void *__kmalloc_cache_node_noprof(struct kmem_cache *s, gfp_t gfpflags,
 				  int node, size_t size)
 {
-	void *ret = slab_alloc_node(s, NULL, gfpflags, node, _RET_IP_, size);
+	void *ret;
+	const struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
+
+	ret = slab_alloc_node(s, gfpflags, node, &ac);
 
 	trace_kmalloc(_RET_IP_, ret, size, s->size, gfpflags, node);
 

-- 
2.54.0


