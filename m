Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACECE10F3DCB
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 04:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A294E6B008C; Sat, 28 Mar 2026 00:55:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DA096B0095; Sat, 28 Mar 2026 00:55:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EFA26B0096; Sat, 28 Mar 2026 00:55:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D16A6B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:55:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B90801A06D1
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 04:55:57 +0000 (UTC)
X-FDA: 84594259554.15.77BBEB2
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id E373820008
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 04:55:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf13.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774673755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=eaCqqasKi7zCq1H1d9DbIPUezQ/e8kSpQ5gpk0KsGnQ=;
	b=54j1LEN7Hh0BEZLnijchMrhBu7qzOB/XRSHrH+O04JtktjBGKokp0SNON7ZjRoeeAjZ5I6
	/09G5R1jslSAIFkxEWD9Fp0NbrHd7qP3yP5v4IpIi9iRlXXMK6VgZbKeUZKW+I2q0ZDlVb
	kCwju1G1Q5AqQpL723IQTT0O+lJzZ38=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774673755; a=rsa-sha256;
	cv=none;
	b=i/sV3f+TPHYx8hRxR9TF5d/zx3Nho+LSN673k05vjBiHxEQcVB4ygdlJiQBh3BZtEtKljr
	j0t8N1vjtEV1PU26P048tQ4h37M/xGdEUdoN7JosAMD5HnAXnozVBVRd6C7j1cw4DWFnQh
	C2IUth3l7n0Xld39ClE0I16REdK4+5I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf13.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4fjQFJ0wz1z5B10d;
	Sat, 28 Mar 2026 12:55:48 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 62S4taXs044377;
	Sat, 28 Mar 2026 12:55:36 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Sat, 28 Mar 2026 12:55:38 +0800 (CST)
X-Zmail-TransId: 2afa69c75f4a4e6-2c208
X-Mailer: Zmail v1.0
Message-ID: <20260328125538341lvTGRpS62UNdRiAAz2gH3@zte.com.cn>
Date: Sat, 28 Mar 2026 12:55:38 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>, <harry@kernel.org>, <akpm@linux-foundation.org>
Cc: <hao.li@linux.dev>, <cl@gentwo.org>, <rientjes@google.com>,
        <roman.gushchin@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <zhang.run@zte.com.cn>,
        <xu.xin16@zte.com.cn>, <yang.tao172@zte.com.cn>,
        <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIXSBtbS9zbHViOiBza2lwIGZyZWVsaXN0IGNvbnN0cnVjdGlvbiBmb3Igd2hvbGUtc2xhYiBidWxrIHJlZmlsbA==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 62S4taXs044377
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Sat, 28 Mar 2026 12:55:48 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69C75F54.000/4fjQFJ0wz1z5B10d
X-Rspamd-Queue-Id: E373820008
X-Stat-Signature: 4xtegao49sbjnaanzqe9u494y1e8gy1h
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774673754-315572
X-HE-Meta: U2FsdGVkX18yHoDO9pvtgmzrqdj5YfNBVCH1tBfJ32Um2sZtoJd+3lcLq9bXcd+QS67QO6Fc1NxJ/6ajVLXkwRogJl1S6o4K7eM6Eg8D/vY6oEi82f20nNhXHMmbQrJEUC5oZos8Wzigh4I9rejFYV/2vqmsRt184iZ9RbD3agJe2KK82OsD1Gu1X9Q1dfGgrp2pLTa6B9blyaCvpWjw+MqXDloKmhwfhPcUpFljMWTFoibvxF9lDZR66iVwcskE1e081UglwsMnJ2Z76oVdAjtvBSiNSzDn+lzfrPC3bsr3bCTltKdII1Un/71CuWzaWQ/Vb/3s0eYVPB6aijMC7mTLRXLtpj89ML81MOLx46uKGMtR5eoJTaLqA6fyESku0eBvMrNTgk0Afjn/2/fB7WZlMbSoqDmjbgwOWQo+eBv7F+/vPTbwXd195DRbOt50HO91XOYm/HiBrVAaLJM2ROJ4G3ll4g1Wqw0NEAW1Jq18lx3OzaqeaeVDiwaeeCm0oAwmcwnky+SA+iSA9hyyPPQSD3x9rbeDUp9u1sJ6A+ANMzLWPDdhfZFSmwDtaw+lAD82UwNS2BFEARKVJT7FO35m0d3tqQlMhMX+4L9IDayNb4R4BAnNGV7rYe4/W/Cr0NkSOdOobtN4JtSqXKgFcltTkuq8Zf40+slXq6I4WdiQyxOyG+seBGjS8vZJZSp/4zSTy3H3jk+NNBZcAAlw5b4D4NDTfUxewonTrv3m+TKC9jElxazhN9Yu6mi1TwbNos8V2rqUIoGVUiEiuV4PcaHqoVENpLtKT/M4D5FYf32X+VI2vmJTiiZtGywwkEjGwJBhU//g3t8AnKtcylw35YnNp5vaMrpzEBlCEzdkKfubN5yRnfxLBhPb6YiaOsa5sPI9tWhIDtOpRlGQp48VYlsPKAPREN+Dg+DEG9pxAdY2ayCtqin+03JusyUXNbCA7PKJ69Ya0A5GqXOChWf
 +vLCAeSN
 S6gndy0U0ZTNVTqhlVvWzT9JmXwz2zM+osiK+qwpkg2Epkt+QLDUhxh69rMelASnnuUcQ29DeS23DQeW1neUHoSt9Y3uFwJlYNwDkuj9yymPtqg9rwn8ud9v7WqSoRM9hEabAjBpy4RXgPU1LkWHrkPYLVzE3RneS4UEk6YHMW18iyYpkWTo6I/1q++pWU9OacEzGHtLai+kTkbl4RhJ45TbWr0XJSP9GAfUx6nj/+wXegiPzYWc7cFbY1gE6xG9Tf5u2TfhPcejkC+Jkclvi4Y0vQTXyuTCueQFqHDe7RZX2hZw2GUwbLbVvNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shengming Hu <hu.shengming@zte.com.cn>

refill_objects() still carries a long-standing note that a whole-slab
bulk refill could avoid building a freelist that is immediately drained.

When the remaining bulk allocation is large enough to fully consume a
new slab, constructing the freelist is unnecessary overhead. Instead,
allocate the slab without building its freelist and hand out all objects
directly to the caller. The slab is then initialized as fully in-use.

Keep the existing behavior when CONFIG_SLAB_FREELIST_RANDOM is enabled,
as freelist construction is required to provide randomized object order.

Additionally, mark setup_object() as inline. After introducing this
optimization, the compiler no longer consistently inlines this helper,
which can regress performance in this hot path. Explicitly marking it
inline restores the expected code generation.

This reduces per-object overhead in bulk allocation paths and improves
allocation throughput significantly.

Benchmark results (slub_bulk_bench):

  Machine: qemu-system-x86_64 -m 1024M -smp 8
  Kernel:  Linux 7.0.0-rc5-next-20260326
  Config:  x86_64_defconfig
  Rounds:  20
  Total:   256MB

  obj_size=16, batch=256:
    before: 28.80 ± 1.20 ns/object
    after:  17.95 ± 0.94 ns/object
    delta:  -37.7%

  obj_size=32, batch=128:
    before: 33.00 ± 0.00 ns/object
    after:  21.75 ± 0.44 ns/object
    delta:  -34.1%

  obj_size=64, batch=64:
    before: 44.30 ± 0.73 ns/object
    after:  30.60 ± 0.50 ns/object
    delta:  -30.9%

  obj_size=128, batch=32:
    before: 81.40 ± 1.85 ns/object
    after:  47.00 ± 0.00 ns/object
    delta:  -42.3%

  obj_size=256, batch=32:
    before: 101.20 ± 1.28 ns/object
    after:  52.55 ± 0.60 ns/object
    delta:  -48.1%

  obj_size=512, batch=32:
    before: 109.40 ± 2.30 ns/object
    after:  53.80 ± 0.62 ns/object
    delta:  -50.8%

Link: https://github.com/HSM6236/slub_bulk_test.git
Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
---
 mm/slub.c | 90 +++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 71 insertions(+), 19 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index fb2c5c57bc4e..c0ecfb42b035 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2733,7 +2733,7 @@ bool slab_free_freelist_hook(struct kmem_cache *s, void **head, void **tail,
 	return *head != NULL;
 }

-static void *setup_object(struct kmem_cache *s, void *object)
+static inline void *setup_object(struct kmem_cache *s, void *object)
 {
 	setup_object_debug(s, object);
 	object = kasan_init_slab_obj(s, object);
@@ -3438,7 +3438,8 @@ static __always_inline void unaccount_slab(struct slab *slab, int order,
 			    -(PAGE_SIZE << order));
 }

-static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
+static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node,
+				  bool build_freelist)
 {
 	bool allow_spin = gfpflags_allow_spinning(flags);
 	struct slab *slab;
@@ -3446,7 +3447,7 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	gfp_t alloc_gfp;
 	void *start, *p, *next;
 	int idx;
-	bool shuffle;
+	bool shuffle = false;

 	flags &= gfp_allowed_mask;

@@ -3483,6 +3484,7 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	slab->frozen = 0;

 	slab->slab_cache = s;
+	slab->freelist = NULL;

 	kasan_poison_slab(slab);

@@ -3497,9 +3499,10 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	alloc_slab_obj_exts_early(s, slab);
 	account_slab(slab, oo_order(oo), s, flags);

-	shuffle = shuffle_freelist(s, slab, allow_spin);
+	if (build_freelist)
+		shuffle = shuffle_freelist(s, slab, allow_spin);

-	if (!shuffle) {
+	if (build_freelist && !shuffle) {
 		start = fixup_red_left(s, start);
 		start = setup_object(s, start);
 		slab->freelist = start;
@@ -3515,7 +3518,8 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	return slab;
 }

-static struct slab *new_slab(struct kmem_cache *s, gfp_t flags, int node)
+static struct slab *new_slab(struct kmem_cache *s, gfp_t flags, int node,
+			     bool build_freelist)
 {
 	if (unlikely(flags & GFP_SLAB_BUG_MASK))
 		flags = kmalloc_fix_flags(flags);
@@ -3523,7 +3527,7 @@ static struct slab *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 	WARN_ON_ONCE(s->ctor && (flags & __GFP_ZERO));

 	return allocate_slab(s,
-		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);
+		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node, build_freelist);
 }

 static void __free_slab(struct kmem_cache *s, struct slab *slab, bool allow_spin)
@@ -4395,6 +4399,45 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
 	return allocated;
 }

+static unsigned int alloc_whole_from_new_slab(struct kmem_cache *s,
+		struct slab *slab, void **p)
+{
+	unsigned int allocated = 0;
+	void *object;
+
+	object = fixup_red_left(s, slab_address(slab));
+	object = setup_object(s, object);
+
+	while (allocated < slab->objects - 1) {
+		p[allocated] = object;
+		maybe_wipe_obj_freeptr(s, object);
+
+		allocated++;
+		object += s->size;
+		object = setup_object(s, object);
+	}
+
+	p[allocated] = object;
+	maybe_wipe_obj_freeptr(s, object);
+	allocated++;
+
+	slab->freelist = NULL;
+	slab->inuse = slab->objects;
+	inc_slabs_node(s, slab_nid(slab), slab->objects);
+
+	return allocated;
+}
+
+static inline bool bulk_refill_consumes_whole_slab(struct kmem_cache *s,
+		unsigned int count)
+{
+#ifdef CONFIG_SLAB_FREELIST_RANDOM
+	return false;
+#else
+	return count >= oo_objects(s->oo);
+#endif
+}
+
 /*
  * Slow path. We failed to allocate via percpu sheaves or they are not available
  * due to bootstrap or debugging enabled or SLUB_TINY.
@@ -4441,7 +4484,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	if (object)
 		goto success;

-	slab = new_slab(s, pc.flags, node);
+	slab = new_slab(s, pc.flags, node, true);

 	if (unlikely(!slab)) {
 		if (node != NUMA_NO_NODE && !(gfpflags & __GFP_THISNODE)
@@ -7244,18 +7287,27 @@ refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,

 new_slab:

-	slab = new_slab(s, gfp, local_node);
-	if (!slab)
-		goto out;
-
-	stat(s, ALLOC_SLAB);
-
 	/*
-	 * TODO: possible optimization - if we know we will consume the whole
-	 * slab we might skip creating the freelist?
+	 * If the remaining bulk allocation is large enough to consume
+	 * an entire slab, avoid building the freelist only to drain it
+	 * immediately. Instead, allocate a slab without a freelist and
+	 * hand out all objects directly.
 	 */
-	refilled += alloc_from_new_slab(s, slab, p + refilled, max - refilled,
-					/* allow_spin = */ true);
+	if (bulk_refill_consumes_whole_slab(s, max - refilled)) {
+		slab = new_slab(s, gfp, local_node, false);
+		if (!slab)
+			goto out;
+		stat(s, ALLOC_SLAB);
+		refilled += alloc_whole_from_new_slab(s, slab, p + refilled);
+	} else {
+		slab = new_slab(s, gfp, local_node, true);
+		if (!slab)
+			goto out;
+		stat(s, ALLOC_SLAB);
+		refilled += alloc_from_new_slab(s, slab, p + refilled,
+						max - refilled,
+						/* allow_spin = */ true);
+	}

 	if (refilled < min)
 		goto new_slab;
@@ -7587,7 +7639,7 @@ static void early_kmem_cache_node_alloc(int node)

 	BUG_ON(kmem_cache_node->size < sizeof(struct kmem_cache_node));

-	slab = new_slab(kmem_cache_node, GFP_NOWAIT, node);
+	slab = new_slab(kmem_cache_node, GFP_NOWAIT, node, true);

 	BUG_ON(!slab);
 	if (slab_nid(slab) != node) {
-- 
2.25.1

