Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B4D5CD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 15:41:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A5E06B00A7; Wed, 10 Jun 2026 11:41:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97DCE6B00A8; Wed, 10 Jun 2026 11:41:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8947C6B00A9; Wed, 10 Jun 2026 11:41:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 78D5C6B00A7
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:41:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20639C08D5
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:41:36 +0000 (UTC)
X-FDA: 84864417792.05.1CE4827
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4A548C000F
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:41:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AIjmLxGH;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781106094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sg/Tskmnml7waI3JEH90Cm0YBKXCVybYdgxFLhHLMdE=;
	b=YqbyWr+hIZoe3Svj4hHYVWYKMSGp+4Pw1s0hD+x6MrH6gqQe/dAztvAZbMLamBvH9wSoXF
	mawI027mYatR4yu0W6M9FvLSCnN2tvHExwkqZWW7XHDWosE3xSF7g/btKBZWGfc0RqKy5r
	DwPkCkAFG6XId0439uDWHiHfH0Is5AA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781106094;
	b=dZDGDa4lf6iHzdZPevEkXCsiQmU0+6sKjYJHdCZJRtBfepUpiWY/E1h4Lyq4BgIOhOmice
	HDY2LYWlg29/UDIkbSntz5dqTTk6EqFcveByTvNWFYOCyJw0wni9H1iCsos88CuUtlt2Bo
	S3WvD2uUlX9oY1R1ycoS4jV1DqbbV40=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AIjmLxGH;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D177437B3;
	Wed, 10 Jun 2026 15:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05BC1F00893;
	Wed, 10 Jun 2026 15:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781106093;
	bh=sg/Tskmnml7waI3JEH90Cm0YBKXCVybYdgxFLhHLMdE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AIjmLxGH0i43NviLgImZ9HF9DC+gewVXMKj5az49sPzA7nurY+pjxASikLvwWteEb
	 7CboNyVZDQSrmEfFKVNHs3dTVYo0FTl2vVhPSfY8b6f3cj7Dmkf3Q1/HNOaUovJnvQ
	 l4kVLvgp9zoVzfIpPPtHO2EjRLdSQ3kVztiTby7C/n47XbFH9MoRdvYthyVM6NMO5E
	 dJnw6PgiD+96KkRMuKz+doEtMr5E9+8xbwuG3Jkf3Nb9J6MzlWNmLaHQmz15MLnNOn
	 ajI9j3RbtyenMzwjwSxoqe3CaHb5a786nXCAhFbcdhUZFCvLWhSgs9YBcLcZm1nu7P
	 CP1Q8bcA3wPwA==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 10 Jun 2026 17:40:12 +0200
Subject: [PATCH v2 10/16] mm/slab: replace slab_alloc_node() parameters
 with slab_alloc_context
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260610-slab_alloc_flags-v2-10-7190909db118@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4A548C000F
X-Stat-Signature: a8boyjtg8duaf43ektykmbc7ku1qxhmb
X-HE-Tag: 1781106094-954763
X-HE-Meta: U2FsdGVkX1/Ccu0G/YDn20KzUJpj8Yw8Q9VUXSmWPf0hsW1iz4Z+2AorXITpveAhWQfpe0ir+CTG8wIWShTnGmq2xnluKZ3/kdbS1J3f85bmVIdRxyXbNokw8U+/0q1nuYW4nVTMFoInAz9ctf43pGmtpLGrtsjJCVDhCB/tj73sbDdQ5LT/d8eth/lnGSKu8L+r60tcU4BMcEl5+fvt0AFLa9OHKFSQ7CfogbZRal9zRGX1dcjV7xILS6iK9D9q5pnQhFHkdV7ExEBp2lMYW3F+og3A+jTPjoVDAaYRHoPrkS3SOA+N8ZlTgp6xGBKyJXBCxD6bxBK/7p+TR8ZpoSmy2HaDN6a/aDoZS+r5nrDa/VuMhT6vy0Q3P+y7/jHpzUhLOpkClNjFZzmSCMvRzrJiL7DyaNy+Uq6R5cXS/LzcyaoXTWuxaGcjnTdqwLTne1zDtqgI2bKNTgJnsjYA33+kvLu0cFQBt5RTMzd3gQ6xov5ZfDm/XrJGM8IPhIucegZ2ROAcJk/Ll7VHk23SdrgxvEsAxn/Q1jBixtuiPGp4sEASkjqrE23Xy0bKh2A4iUX+pP6x5OMtAH+5KaGVdidVghg7sYK1NJ7tFhmJBhDIu7wvmpUNR2WzXU4TL8mToYZddtDHlPa6Fu/baln13rCEMWP/j5oPEYI2HUeG7YPFNLBguq+czJr2jqltyMQYVLuJbTRN1MLC3BtKPrWAyaM9bMjDi8wQTALuZyXEq+zCDOlmzo4PH9a6nnxd4RD2eY0JuV1hypgaxMh8U2f5zPHk1D9vg/pkN5RryoZ4TSsOAbMVz17/gXsGFM07+3r0u77E9w0YbT5qsJrGLTXdoMhCOB+lhKn9WjenftY1682QQbCruAfo71MOMt8QDMqI2JvXVCV7dl8h+33QtDIyOiGHk3E5AtAxufApHT2GZQmxRQJirw0EczmgcEzotKOdrV5v6LZ9f40WjaGlm5U
 Zj3ST6Qc
 bRgk8xIV507xKGyvgQjAy5WPX6lLpkxsgBYLeo3lL/LMOp/1opzBuqQfmXX+oJ+vaDkym1xCzgFmJzc+ulV29DOALMbVxiyatQr3j0Eg5QdP0Rv0X1q4fKT515B/fLuz1dnd2yQlDhUIC3huWlwHwlnsr1Klu8cC+b3/rM9+5lGTILbt+sNaxMlGXxARUbd1hp/Q68TJWlgQw+0ZdhwMEWFDl10s/HELGplnCqD/1Q1TLELyrOjgwP/qMC5Y7B5SLkQ51WWwBGhyqf/EfTHcWJDQS3yrSTWT11A8U
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
index e634137b67fa..0b9974bfcb24 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4921,30 +4921,23 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, gfp_t gfp, size_t size,
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
 
@@ -4953,15 +4946,21 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
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
 
@@ -4972,8 +4971,15 @@ EXPORT_SYMBOL(kmem_cache_alloc_noprof);
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
 
@@ -5005,7 +5011,14 @@ EXPORT_SYMBOL(kmem_cache_charge);
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
 
@@ -5335,6 +5348,11 @@ void *__do_kmalloc_node(size_t size, kmem_buckets *b, gfp_t flags, int node,
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
@@ -5348,7 +5366,7 @@ void *__do_kmalloc_node(size_t size, kmem_buckets *b, gfp_t flags, int node,
 
 	s = kmalloc_slab(size, b, flags, token);
 
-	ret = slab_alloc_node(s, NULL, flags, node, caller, size);
+	ret = slab_alloc_node(s, flags, node, &ac);
 	ret = kasan_kmalloc(s, ret, size, flags);
 	trace_kmalloc(caller, ret, size, s->size, flags, node);
 	return ret;
@@ -5467,8 +5485,14 @@ EXPORT_SYMBOL(__kmalloc_node_track_caller_noprof);
 
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
 
@@ -5480,7 +5504,14 @@ EXPORT_SYMBOL(__kmalloc_cache_noprof);
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


