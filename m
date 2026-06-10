Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A50D7CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 15:41:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 009D26B00AA; Wed, 10 Jun 2026 11:41:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F230C6B00AC; Wed, 10 Jun 2026 11:41:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E602A6B00AD; Wed, 10 Jun 2026 11:41:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D57EC6B00AA
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:41:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A86B162F66
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:41:50 +0000 (UTC)
X-FDA: 84864418380.05.BD2B5A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id D4C6340018
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:41:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Su1gbBTv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781106108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z4p7lBTo620lw4Cx9cPSuEFRwzQZKtUkN/W+8V4LMiY=;
	b=kA4yhI61HSap/JWRXIs3X3+RVXXr/tfSA0/xdWigbnsBilDYF+akUZd0vG5ZXmy977umYC
	1niftRz/7NS8OQBblZBaF3C7LmuHhhEEjwh1Ugot6ong1zgGmkqqtPX3+6FwaUhDhPOfEv
	v2SGWIQN5t0FspanPKPcXLVvuXG8TNk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Su1gbBTv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781106108;
	b=Cb8XYUQ+ho+mfSbQ5yiBI7hpG1EsuqWc3CwJQfAx8RP82rV5BOLqUP9wqAx7WOuHoKeaPn
	A0q0gFzyBIpjmw8aW9QKYMgQk4O4qLGpkiOyJCuvmi5wZgpMsIGOKN/prI8I6y0o403iUz
	duMiX+eUCKLNiL4WMIzystT0aXIhvFE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 59A7360172;
	Wed, 10 Jun 2026 15:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E8B1F00893;
	Wed, 10 Jun 2026 15:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781106108;
	bh=Z4p7lBTo620lw4Cx9cPSuEFRwzQZKtUkN/W+8V4LMiY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Su1gbBTvmRn8OWDOvh3qn3pI4cAxHZ45px1Swujt8aZRyDQ2J7bmOwZiD1kaqqChI
	 HetPcwR6LmZcW4IC8PlXBx/UmddVjTIcdIO3FOs6AnS58JKxtaPhIbT8wb8accI83E
	 g3t5AfHsFGIIRPOYjEHT7BPV7OtTDbuAdMQEiStz5Jixcbxo4J3KK2+gvgEWDBCmF9
	 jccFfMTKAgQnaLM37K620iiUYGXcScDJS/t6B9eG+EKRovUFFlWbdVryacWBLk9mm9
	 HOk6gy3RMYea3PCFfmfHKRA/snC0KQNkbfiwHpIfsxc1d5g3cME27KqU1tmsG9tWvk
	 kD/LblYVS9Dow==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 10 Jun 2026 17:40:14 +0200
Subject: [PATCH v2 12/16] mm/slab: pass slab_alloc_context to
 __do_kmalloc_node()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260610-slab_alloc_flags-v2-12-7190909db118@kernel.org>
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
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D4C6340018
X-Stat-Signature: r65ngwh5sopayxoeqw8ndnucbcdobgix
X-HE-Tag: 1781106108-62121
X-HE-Meta: U2FsdGVkX1+2Lg3Y5Kh2C8qDYO1KxmsSYPie4FtAfrrktB1NTAyfYzG2Xof1DwXmBIVXTGaLK7EUPjAfHAlWer/1RMi/3lv4EaepH6BqVQxjrRwO9u30BHCF0wts/ZbjXvunvu3RuVkjiaABCzL6f2q9kQzGFLadsH3k7cvjFOr3UcaO0OYWas8sFngAe742qulikPiOHsoZxlK9AyfgIQUex6wCd3mz71LiSeAa9KzzCE57BOqPiTQhRBPJrzMw4kT+vEPiKsT6+ERnJuhDiBzI1iPODK6LfYF6RNjsNif3+8X428aMFVH4Wz4DrKekYWY85n6owFE3lduSPoPT3Nyn3s3VKBScQCxSnQ5vWi+DO17HzehdIBX/LfFl1teeVaFhbZuhkGgsr8djO3G8CuGu7QSDCBIMYgV6BUqCSfmkoHgrIXD3EXg4RcnS5qQEHH4lPZyLzyvpprT3ETy9TxPmQeWn5uinYD55gWJGvmQu+67DrgejQ1NFS2ZX17bKiXyVKHJoa5COsZV+800VjgmHPVxJCj+Q6rfX9R/jA11HvSRgt8yYjEpiTsh+ukVUeLzJIi9Iix4S00kbUQkHrM7bBco6RQnADzRngvbVEK2lMgdlfmglMdPJJqTm9Z+HRolBpGw6KEdDFGU2mtRPM1NrkTfoHekJTPzbDB6hbx4aLC5hNTn1dJuQGNLgPA0Qs/PRFYHyNzV04xMhNahsthF58Wo7Wr1shdXm36hCT35KzP3HKgOXS8j27u8KIVYYWvm4cci/bvsZuMc30UVxtw4tjA/PZh305d6p33RW05CS97g1zi2SjO7E42WdFewNxltkMpuX0YMS+JVpUOjaUhTYQMjN+JaTGQF9Bvk95BUeZKhDyluS7c+kUfX5oV128KplGu9an8yRg8NI+6yYxbb3JOvDd4LPmG3J5UMikP3/loGFGirfg5fJAsruNax+reBxomYI9s7KrY/gdI8
 +dRvszd2
 m3gYKOwPqd9gGj3gjLkKeZSE+KEoJ4P0cXYsUsVZSX/wdrLavJ2v6G9NAr+zCx0QEijkky4WREd+WVWkhKnikTcJICLf/gV15+Vum19lQ7jUB6o0wNiKXB1y0Uqv86OoRZK6iRtmO1gJMmx6V/GLeaf4IujZ79KwhbnrVN9DMfreF3XqTYRrHBLIa0vXK0kL3hxrwHJiUdZACI5JgFTdOLVbBQJsvrnO7n42KW5IHFQAZwla+yeo3e3yFBR6p8baEWd716CDuLujfSHiTkqYm3yUMVKFucg4AUwai
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
index ef457e07db83..6845e15c148a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5338,19 +5338,14 @@ EXPORT_SYMBOL(__kmalloc_large_node_noprof);
 
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
@@ -5360,22 +5355,34 @@ void *__do_kmalloc_node(size_t size, kmem_buckets *b, gfp_t flags, int node,
 
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
 
@@ -5471,9 +5478,14 @@ EXPORT_SYMBOL_GPL(_kmalloc_nolock_noprof);
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
 
@@ -6874,6 +6886,11 @@ void *__kvmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), unsigned long
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
@@ -6881,7 +6898,7 @@ void *__kvmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), unsigned long
 	 */
 	ret = __do_kmalloc_node(size, PASS_BUCKET_PARAM(b),
 				kmalloc_gfp_adjust(flags, size),
-				node, _RET_IP_, PASS_TOKEN_PARAM(token));
+				node, PASS_TOKEN_PARAM(token), &ac);
 	if (ret || size <= PAGE_SIZE)
 		return ret;
 

-- 
2.54.0


