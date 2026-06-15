Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0625ECD98C7
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DB0E6B00A9; Mon, 15 Jun 2026 07:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B2DF6B00AA; Mon, 15 Jun 2026 07:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C8DD6B00AB; Mon, 15 Jun 2026 07:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F5D96B00A9
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:55:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1997CC36A2
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:55:30 +0000 (UTC)
X-FDA: 84881992020.06.CA2F90B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 637274000A
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:55:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HdUMO7qd;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781524528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B6dmcdjP+5ZIBOi/iXRYbZybDrhTvdvmtqJeoRuINj4=;
	b=uZ740Av5uTr75HWJo+RY1goHJPEcMjHWrC7/g1pPD6Gq035JpCPoc5uwywTIygjFwWjBRe
	BWpH9XZG93/O1U4kGM6WsbymBXBs4o3QZez+AzPgNSPx9Cq+1vzALoQw1unrY5SoLtvHa9
	8FleNoZED9HayCkpznkUmzBS1Oe69vQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HdUMO7qd;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781524528;
	b=DuB5zm4DUDh19zPdoisvMiYpv+u0Q3HGC8+Prz381XLtsZAGCS7bkLwMco0i0+sgX/lMGW
	7pPoZWtjcoE2GJI6pYVIxWZ3fH9ZVmjukAWYz+ALgjIyeWo2cEmMyXUyZdqA/Z4QTDAqRP
	Lwgx9Nv1XFSxTcmPupOPbaHSsP9vJ+M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B4228419C8;
	Mon, 15 Jun 2026 11:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24FFE1F000E9;
	Mon, 15 Jun 2026 11:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781524527;
	bh=B6dmcdjP+5ZIBOi/iXRYbZybDrhTvdvmtqJeoRuINj4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HdUMO7qdkda4aakMktunsbyk0bBiJgwEkxj9/C6vT/cp3P7H9EDO/8EP7dK8HvepH
	 tnaDmbWoH5V5QPxT0x7HSCV/L5RZsckBrbHsbfBCblSYuaxfF3B3DGAtzYMo2V/C2E
	 QaoP/2kjRGlZqvV7ma50hx9maTaXW0zTtVcGGw85Pofht3pCQ/o7iGOUAWmdetpK/L
	 KZ9pbDEyvLJfd7xyZeAmcidIn52okNaAPj3dNV4Pu9vxOH4o2AiRsYU7GGB/HXWEdm
	 23wD8vJJCjGpASWbfVZC9/RTqktswWqL099XaVZstDyu+mU+LkmUw77sGShrJ/6FnC
	 mDxO9cSAirF1Q==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 15 Jun 2026 13:54:44 +0200
Subject: [PATCH v3 11/15] mm/slab: pass slab_alloc_context to
 __do_kmalloc_node()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-slab_alloc_flags-v3-11-ce1146d140fb@kernel.org>
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
X-Rspamd-Queue-Id: 637274000A
X-Stat-Signature: xzdica7jcpizpf5d6nr4eos63njnm3q3
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781524528-31449
X-HE-Meta: U2FsdGVkX1/k+Pj7OXRYSrOCjfzSXeSBEmaTSuq5FalXmATMUbdKOVWtj1XijH2p7E0a1QBf2IxfUSKfj+/bzTd1+3gdRkh6hNl3uA5+aNw/wKZFmMfUiLcJboPUrpuGI2zOq4H7XWFkpP5YNBQSvXsgqSbIaFkc4lrT728C9VpDl9ALttQA2F0qjhiOMQFF3Ti9jwDaRyMgdICwy+4xBximux5Y17c7Z7VMxVLTB6SlZqT++UnqrOMmdx+dEoX55Wa41Gj01TmPT5jCeDLzxmR8tOPPaMSLGOUyKToX4r0vFw8Q5qxwRtSeJXX5+M9Tpv5B1e0UEYAOXoBJ/SEBLg7ObLvq+wbiW3KXcOWXZt4aDJAvSxLrtu2u/ALpZnlm7IM8rExeiEV9ukzgNGxX9/0ENDQ71rT3bqh8mk2VwPO/VLgtTM/PyCpD7cpYbosVG/FNbGm7gdOhXuxF6qQKoxKcK99GKl9uOJckkZ2COyry8xRqDM5ZRSYq77oUSpe1v2gj+e8DYLg1HzmEIEY7hTmpfAAw5ogt0rCtXdyJTupFVG/hDlK2BdK8J4Satk6sGQayjsqLwHbwCnhsJhPOik6bYiLli2KkM5XwJWsAe150Q8w3SGfTBs1jRpFguuwLRLCew1qGD0axgfYRwNiM4HW+Qvx9E+GkHxkfxh0/48U+1NEritmb0ywpS8FOJMLNN4oG5IJYp4NZw3yVoUhvGyGCdTGHEfdJd/Bg8D2YcqLf37el1TGNnTpABK5uGmlW0XlS4DkLswCr2zFTo+FW9ACqyNuw/72g1csOCCkTp9IzKFCQdKX0b7Uu7LsurRd5B/RYE8djk5VUiuYSMNA/HQ1aeVaaUH+KKd1itWImZ7m9nUGZq+xOL2k7Ou/Zfjm5OqHuoqbh1cm+YckK4mSSFtFrXXTJsNOPm5SKAqjnTN6hQ2Oi2TW3TITYCQhubgXvYLqk4+Vcv/TYZjFXj63
 um+8/c2y
 qABTE9BxdIxhLbMe92h4OYSC0AGhEwEUc0zt+8Rwl/FhOFd+4JahpQzrw7eShJ4grf7kQqmUOcfYR8cMOn4tstzBsRIM+gQS/HMwzjzfZdma8XDqFofsOV5gEJLSFo11ERe8r0oAfMAXfxZywLehgvO67+QkCKU6T/idB9RXGZnuaGhsFQlDjW/dsgHgP0Uzc+sMiknhR66AnQj10OuXvDw/+UBiUybBrcstX/NFDcRv4gif+i5m3rFceFP9U3c36gIAzfk854Mh4AO8nDlkiHaPIhRjRpBrGHnkNllwhO/QMAEmS23N5UEGA80bnwfFTR2ZmGHONdNgzLAHjPejPNYLYzuRgS1D4f+/DKQQQ2hYIhFcJNVdC2GcnUw==
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
slab_alloc_context. This replaces the 'size' and 'caller' parameters and
includes alloc_flags which we'll make use of.

Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-12-7190909db118@kernel.org
Reviewed-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 54 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 18 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 81938774098b..537ea68f417b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5335,20 +5335,16 @@ void *__kmalloc_large_node_noprof(size_t size, gfp_t flags, int node)
 EXPORT_SYMBOL(__kmalloc_large_node_noprof);
 
 static __always_inline
-void *__do_kmalloc_node(size_t size, kmem_buckets *b, gfp_t flags, int node,
-			unsigned long caller, kmalloc_token_t token)
+void *__do_kmalloc_node(kmem_buckets *b, gfp_t flags, int node,
+			kmalloc_token_t token, const struct slab_alloc_context *ac)
 {
+	const size_t size = ac->orig_size;
 	struct kmem_cache *s;
 	void *ret;
-	const struct slab_alloc_context ac = {
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
@@ -5358,22 +5354,34 @@ void *__do_kmalloc_node(size_t size, kmem_buckets *b, gfp_t flags, int node,
 
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
-	return __do_kmalloc_node(size, PASS_BUCKET_PARAM(b), flags, node,
-				 _RET_IP_, PASS_TOKEN_PARAM(token));
+	const struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
+
+	return __do_kmalloc_node(PASS_BUCKET_PARAM(b), flags, node,
+				 PASS_TOKEN_PARAM(token), &ac);
 }
 EXPORT_SYMBOL(__kmalloc_node_noprof);
 
 void *__kmalloc_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags)
 {
-	return __do_kmalloc_node(size, NULL, flags,  NUMA_NO_NODE, _RET_IP_,
-				 PASS_TOKEN_PARAM(token));
+	const struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
+
+	return __do_kmalloc_node(NULL, flags,  NUMA_NO_NODE,
+				 PASS_TOKEN_PARAM(token), &ac);
 }
 EXPORT_SYMBOL(__kmalloc_noprof);
 
@@ -5468,9 +5476,14 @@ EXPORT_SYMBOL_GPL(_kmalloc_nolock_noprof);
 void *__kmalloc_node_track_caller_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags,
 					 int node, unsigned long caller)
 {
-	return __do_kmalloc_node(size, PASS_BUCKET_PARAM(b), flags, node,
-				 caller, PASS_TOKEN_PARAM(token));
+	const struct slab_alloc_context ac = {
+		.caller_addr = caller,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
 
+	return __do_kmalloc_node(PASS_BUCKET_PARAM(b), flags, node,
+				 PASS_TOKEN_PARAM(token), &ac);
 }
 EXPORT_SYMBOL(__kmalloc_node_track_caller_noprof);
 
@@ -6871,14 +6884,19 @@ void *__kvmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), unsigned long
 {
 	bool allow_block;
 	void *ret;
+	const struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
 
 	/*
 	 * It doesn't really make sense to fallback to vmalloc for sub page
 	 * requests
 	 */
-	ret = __do_kmalloc_node(size, PASS_BUCKET_PARAM(b),
+	ret = __do_kmalloc_node(PASS_BUCKET_PARAM(b),
 				kmalloc_gfp_adjust(flags, size),
-				node, _RET_IP_, PASS_TOKEN_PARAM(token));
+				node, PASS_TOKEN_PARAM(token), &ac);
 	if (ret || size <= PAGE_SIZE)
 		return ret;
 

-- 
2.54.0


