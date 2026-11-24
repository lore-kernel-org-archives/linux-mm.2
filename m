Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCEEE606A32E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 16:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PW28nj0f
Received: by kanga.kvack.org (Postfix)
	id B7BA76B07B1; Tue, 24 Nov 2026 11:30:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B52776B07B3; Tue, 24 Nov 2026 11:30:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1BA96B07B4; Tue, 24 Nov 2026 11:30:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B0E06B07B1
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:30:17 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6BC6E1C46C5
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:30:16 +0000 (UTC)
X-FDA: 85470550032.11.48A587E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id A178DA0019
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:30:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PW28nj0f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795537814;
	b=OghwxLYSJQepTRyQTVlvbUJEnnKhG/H9vR/43WzHrtFoF/4n5gsIVCo9PGqdS4qC44NW8h
	dzKQC3/jnCbS9HafZKyys6kDrkUlpGZHeD7gL6mGl4HUL+Nfq52fx9ibNrUUh/pECPpTjm
	VHMUAwsYB0kUjy60XRp78CL3YSv8sZA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795537814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0YOPC/VLNeMdRJQ9kwXd9U/GVf6NunW+URWaX0/FAcA=;
	b=HvMWam7uHf5Qaa+XxPkGyqT3L3d0lyGqTayF8Xf5fdpX7OtEwChk68Dxs58PZi7VmRyIb8
	FMUHLTEA0HOXjY+MlneSKh7GUUWNJsqe/NudgyHLGXaU3w9xfipyIgWKHfDRBGHTB6Gx/y
	SJTS0gpFLmTGUo/seoKfZpliEjC+bQI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PW28nj0f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E99C041B65;
	Tue, 24 Nov 2026 16:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD831F000C6;
	Tue, 24 Nov 2026 16:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795537813;
	bh=0YOPC/VLNeMdRJQ9kwXd9U/GVf6NunW+URWaX0/FAcA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PW28nj0fqJl30QfG7T+ET2wN1ObTPauVNBzfsnQQrHjHoI0UUqBB8JOG7lCfIA4ON
	 d/Q1SyjRREy1OM3MycA30XGEuIDbgd6wJRK8w3U+pcHfwZDH2xZn9jtUWM3GaazjzQ
	 AILkS0HZmpxCjzu1e8QdgJLArfMMU0SpGH/1uWbt/yZrqJU9jqXiu7XkW5jD/a9/Ao
	 urRQhxwRX+pOlP9Acg0XP9gUiTlKPEvlNqLjSjqpa4A+Cfyi7vBrVMjoqjxDBi1+72
	 +M/xkEiDosIMgJSRjVRfbLgDkncbhVG9kclEir+DX9D5jDK7gdfYkuRdveu82lxv02
	 CX1QtyUUiKZWQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 24 Nov 2026 17:30:03 +0100
Subject: [PATCH 2/3] mm/slab: add own entry points for kmem_buckets_alloc()
 family
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-kmalloc-entry-rework-v1-2-37b1631a67b5@kernel.org>
References: <20261124-kmalloc-entry-rework-v1-0-37b1631a67b5@kernel.org>
In-Reply-To: <20261124-kmalloc-entry-rework-v1-0-37b1631a67b5@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Chris Down <chris@chrisdown.name>, Kees Cook <kees@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: emegu3c5a15ohn5tao5nno1qqs4ioubr
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A178DA0019
X-Rspam-User:
X-HE-Tag: 1795537814-650436
X-HE-Meta: U2FsdGVkX1+mwy20kbJZxK8WW6Ejgk/ScpmyNw42EfBguCj+Rq8g/F/MVZa/vrGHPcbpQ3TkE/f5VjcmZAnDi1bjS2vke+l5xwT4J7ABnkAanGnHN0+0nPJAKLvSiLpzcRkRTwrf2avxN0O3OIxsFXQaZgdA33JD30aq7bkAiiAL2gxwTJ6GBdmk5oBTCn36K2IGAa0LK7h2RqsmTT4C4Hl2FET5mvogJWCjXSyPw1BYDEu9TGvxhpYNjbUP2FvWsZr/NP5ojX0OcHRoAU/2xagQ+grUp0LGHLXCGraAxMcGeWWMxyWVgKEbVBv/fbdZbN/bEQOdcHF+ymt/uhwaRpkLlYVCDiYGtvmqlFP+HgVLuUYmjuUzUrw34GTqRIPUBmRG+e3mxmwD5JSb9Ts+kLAUEI7iW7TVAdP2iRGjp/c+wt0vNhciXEc4j6AcoGblWzcpZAZM3Vw9DQZ9rKpG3fVWG5dIt6TOlcQtGMLOcdKFQtMuPeuXItxcU77k/djkEt3+PnHmgohmGKbrPsUeUceqPAIFb1XKEHGfkc/L3iwJziQ/wcnoWNnH9EEufz4ZISsAYwcb1uG6NQYPT86WAOy/1GykB1ofBnbKpud4y6EFehsCefEvxqvUBuPzVpx+SbMA9ukUfex2j4ZFf/Qfk00FLoXxldGsTmWjml1ib9N6QH1+4umuVeZLCv7rJP+ainb1SqOX2p/pu6I2fJs3ihH7VMnaD45TGdzScp/7tfxkJTgGWsvmcX+bSQxtHni14YwRQUNevtFLbynfGhpdrTqhdRLyVD443hFNXTQ+edioIaeCTg29JHpdiK2txhykHkumcChjGi2RcYJXqt/fsIcs3cYgsGWx3zK2zWtdd/jzszUPnz7NhuWfExUinKWup28ROXFCvLlQHffxCZ/e0nT9d9IeRO87IusGHWYg5jWlYIM18FzsYq5KAeBarLg6uu0+btLSqK92Uum5O85
 q3fWK0bP
 Dv/iJoS7xoyTjwQiWgFfaek13OtYi1Gl/JTtFDIfA38L2ydaG+WyJQNWh+moeryoZj2Q3BlcpGl+v5lHtrvUEJcTfy8h/wOjdR/aZm10cEz2S0qoRG3OXeGJ6sCbSUkWsKc0CnzfHbCBqXdZytip2gHcmaZMfruusOlELKeqEMEnQMlalybFBefyCfYB1AOtXK5YSww//EIxuIN+N3FsYvfqbmIx0/10llv4/fKa40ztBUGNBix2ZWEck6nfdZQA3iUlOSFgUBnPkdwt9xM9jnPMbRV0Uo81ZtBlyG3j0/+d3dqmTK2eL78ZVCz8WLGUoe5zWxK8MKElW/KsHIf634WAc0LDk/OSMRTPn6QEjPDPolAsuKFj+yI/erNPLR6DfnJ6mZMWgRiK7miv84TFiZnOy4lzx67HRFmaP6eZxN3+pPsRct6fr/gPxP5EWo1AbHAhh/rI/GeK307JUgwsV//WZf8+m+bukxyLIyj/VRQXqYtQQIzo6euKnSzVBp5JApMj+doNt4Fjyi/M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The way buckets have been implemented was to extend
__kmalloc_node_noprof() and two more functions with the kmem_buckets
pointer parameter, which means all kmalloc_node() callers now have to
pass NULL. To avoid this extra parameter with CONFIG_SLAB_BUCKETS=n,
we added macros for parameter declaring and passing.

This can be avoided by creating own entry points for kmem_buckets
allocations and not using the kmalloc ones. They all end up performing
__do_kmalloc_node() internally.

Since it's just 3 functions with few callers, do not try to do anything
special to eliminate code with CONFIG_SLAB_BUCKETS=n. Only make sure the
bucket parameter is changed to NULL in that case because it would be
ZERO_SIZE_PTR otherwise.

The removal of the now-unnecessary parameter macros is done separately
next.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 include/linux/slab.h |  16 +++++++--
 mm/slub.c            | 100 +++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 94 insertions(+), 22 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index cda126def67a..46ecf99f044e 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -1175,11 +1175,18 @@ void *kmalloc_nolock(size_t size, gfp_t gfp_flags, int node);
 #define kvzalloc_flex(P, FAM, COUNT, ...) \
 	__alloc_flex(kvzalloc, default_gfp(__VA_ARGS__), typeof(P), FAM, COUNT)
 
+void *__kmem_buckets_alloc_noprof(kmem_buckets *b, size_t size, gfp_t flags)
+				__assume_kmalloc_alignment __alloc_size(2);
+
+void *__kmem_buckets_alloc_node_track_caller_noprof(kmem_buckets *b, size_t size,
+		gfp_t flags, int node, unsigned long caller)
+		__assume_kmalloc_alignment __alloc_size(2);
+
 #define kmem_buckets_alloc(_b, _size, _flags)	\
-	alloc_hooks(__kmalloc_node_noprof(PASS_KMALLOC_PARAMS(_size, _b, __kmalloc_token(_size)), _flags, NUMA_NO_NODE))
+	alloc_hooks(__kmem_buckets_alloc_noprof(_b, _size, _flags))
 
 #define kmem_buckets_alloc_node_track_caller(_b, _size, _flags, _node)	\
-	alloc_hooks(__kmalloc_node_track_caller_noprof(PASS_KMALLOC_PARAMS(_size, _b, __kmalloc_token(_size)), _flags, _node, _RET_IP_))
+	alloc_hooks(__kmem_buckets_alloc_node_track_caller_noprof(_b, _size, _flags, _node, _RET_IP_))
 
 #define kmem_buckets_alloc_track_caller(_b, _size, _flags) \
 	kmem_buckets_alloc_node_track_caller(_b, _size, _flags, NUMA_NO_NODE)
@@ -1360,8 +1367,11 @@ void *kvmalloc_node(size_t size, gfp_t flags, int node);
 
 #define kvzalloc_node(_size, _flags, _node)	kvmalloc_node(_size, (_flags)|__GFP_ZERO, _node)
 
+void *__kmem_buckets_valloc_noprof(kmem_buckets *b, size_t size,
+		unsigned long align, gfp_t flags, int node) __alloc_size(2);
+
 #define kmem_buckets_valloc(_b, _size, _flags)	\
-	alloc_hooks(__kvmalloc_node_noprof(PASS_KMALLOC_PARAMS(_size, _b, __kmalloc_token(_size)), 1, _flags, NUMA_NO_NODE))
+	alloc_hooks(__kmem_buckets_valloc_noprof(_b, _size, 1, _flags, NUMA_NO_NODE))
 
 static inline __alloc_size(1, 2) void *
 _kvmalloc_array_node_noprof(size_t n, size_t size, gfp_t flags, int node, kmalloc_token_t token)
diff --git a/mm/slub.c b/mm/slub.c
index 70df0a2e3876..6674caabbb6e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5732,6 +5732,34 @@ void *__kmalloc_flags_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags,
 	}
 }
 
+void *__kmem_buckets_alloc_noprof(kmem_buckets *b, size_t size, gfp_t flags)
+{
+	const struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
+
+	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
+		b = NULL;
+
+	return __do_kmalloc_node(b, flags, NUMA_NO_NODE, (kmalloc_token_t){}, &ac);
+}
+
+void *__kmem_buckets_alloc_node_track_caller_noprof(kmem_buckets *b, size_t size,
+		gfp_t flags, int node, unsigned long caller)
+{
+	const struct slab_alloc_context ac = {
+		.caller_addr = caller,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
+
+	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
+		b = NULL;
+
+	return __do_kmalloc_node(b, flags, node, (kmalloc_token_t){}, &ac);
+}
 
 static noinline void free_to_partial_list(
 	struct kmem_cache *s, struct slab *slab,
@@ -7106,26 +7134,10 @@ static gfp_t kmalloc_gfp_adjust(gfp_t flags, size_t size)
 	return flags;
 }
 
-void *__kvmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), unsigned long align,
-			     gfp_t flags, int node)
+static void *__kvmalloc_fallback(size_t size, unsigned long align, gfp_t flags,
+		int node, const void *caller)
 {
 	bool allow_block;
-	void *ret;
-	const struct slab_alloc_context ac = {
-		.caller_addr = _RET_IP_,
-		.orig_size = size,
-		.alloc_flags = SLAB_ALLOC_DEFAULT,
-	};
-
-	/*
-	 * It doesn't really make sense to fallback to vmalloc for sub page
-	 * requests
-	 */
-	ret = __do_kmalloc_node(PASS_BUCKET_PARAM(b),
-				kmalloc_gfp_adjust(flags, size),
-				node, PASS_TOKEN_PARAM(token), &ac);
-	if (ret || size <= PAGE_SIZE)
-		return ret;
 
 	/* Don't even allow crazy sizes */
 	if (unlikely(size > INT_MAX)) {
@@ -7151,10 +7163,60 @@ void *__kvmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), unsigned long
 	 */
 	return __vmalloc_node_range_noprof(size, align, VMALLOC_START, VMALLOC_END,
 			flags, PAGE_KERNEL, allow_block ? VM_ALLOW_HUGE_VMAP:0,
-			node, __builtin_return_address(0));
+			node, caller);
+}
+
+void *__kvmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), unsigned long align,
+			     gfp_t flags, int node)
+{
+	void *ret;
+	const struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
+
+	/*
+	 * It doesn't really make sense to fallback to vmalloc for sub page
+	 * requests
+	 */
+	ret = __do_kmalloc_node(PASS_BUCKET_PARAM(b),
+				kmalloc_gfp_adjust(flags, size),
+				node, PASS_TOKEN_PARAM(token), &ac);
+	if (ret || size <= PAGE_SIZE)
+		return ret;
+
+	return __kvmalloc_fallback(size, align, flags, node,
+				__builtin_return_address(0));
 }
 EXPORT_SYMBOL(__kvmalloc_node_noprof);
 
+void *__kmem_buckets_valloc_noprof(kmem_buckets *b, size_t size,
+		unsigned long align, gfp_t flags, int node)
+{
+	void *ret;
+	const struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
+
+	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
+		b = NULL;
+
+	/*
+	 * It doesn't really make sense to fallback to vmalloc for sub page
+	 * requests
+	 */
+	ret = __do_kmalloc_node(b, kmalloc_gfp_adjust(flags, size),
+				node, (kmalloc_token_t){}, &ac);
+	if (ret || size <= PAGE_SIZE)
+		return ret;
+
+	return __kvmalloc_fallback(size, align, flags, node,
+				__builtin_return_address(0));
+}
+
 /**
  * kvfree() - Free memory.
  * @addr: Pointer to allocated memory.

-- 
2.56.1


