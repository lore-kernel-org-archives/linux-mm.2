Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BDC0D62602
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:53:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 566076B0404; Fri, 23 Jan 2026 01:53:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5064E6B0407; Fri, 23 Jan 2026 01:53:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3738D6B0404; Fri, 23 Jan 2026 01:53:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2432E6B0404
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:53:39 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DFA6F16037C
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:53:38 +0000 (UTC)
X-FDA: 84362312916.02.94FC374
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id BB5FC100002
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:53:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769151217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R3tMPeH9Ipw8jVs85e3Pd4lK1yV/xqf8NCU0KSfX1vE=;
	b=WBuBSZgnQpqG67S1QyDE2eVGBo5tLXOkBAjOC+dYRTY4+6b23JeSk8tLiuWxPqiR8fFMKI
	zUqlrzidJEdPaerLy7uvoaLei/jd2Njc7yGCJUgivVseRgP6sMEJGc45pvE06qju1ZAmX8
	cCL2KmWf4TR8tIvjmgmyIh9iDd2qe2M=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769151217; a=rsa-sha256;
	cv=none;
	b=k0Xgl6qXGd8clWzW1oB06MmtapVZG984qjHspL/vXibFZ+YbeqG+HpAE1SoytZlwuElqNH
	Jtp4P5q2lCea4YqQ4jwhuSgaEJqJtje++JExFty4guo2K+jl3zZ2cH4ZGa05LjXX7DVDuo
	B4RdIopPQntd9qNMzW4EiLGU4zZNw/M=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D0DD833775;
	Fri, 23 Jan 2026 06:53:10 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0FF1D139F0;
	Fri, 23 Jan 2026 06:53:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CKtxA9Yac2k4YgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 23 Jan 2026 06:53:10 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 23 Jan 2026 07:52:47 +0100
Subject: [PATCH v4 09/22] slab: handle kmalloc sheaves bootstrap
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-sheaves-for-all-v4-9-041323d506f7@suse.cz>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
In-Reply-To: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
To: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
 bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Stat-Signature: hnk8bpy5t59c15x4y4k315qa8wunarsj
X-Rspamd-Queue-Id: BB5FC100002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769151216-438550
X-HE-Meta: U2FsdGVkX187NCX4zyLQFja1Jo8Qonh6EnwTnIpBeAALsN08bf2B41XnTltJ6KY21BQhJA9vc46qebQqTVsPulvsg/4xX9EoHJsbbf5MoQxgONaWrwPlv79pdjxuBDTtXP6fsbxZ0PcUm/NavydxGF0F/wUEbl1dVhZr4ydkZXOb3jOH5KQY0IM88QFS+jT0k+9LkTvLq8fq/mc8UaZzNnst7wUCxg7GXYW3p0/B0/6No55ezgr4/cGh3gXDgZxCeForNUmaPxd8r6hp6lC4KX669jucGfv5xJ4tfHD4RpOiLTR+TjXef1RsZHQmrhUhRB3M8dvNX/PIctZWklarCPRUjBNLN+adDr60i4m4IFjDgTcsfldGTFk2XnBO1qLYprmq1peVmWFtxagUod1r5NNhInbahTd1RxL0IUSgvakHX8pfmovD4wM4ZVqLsihofkaKYQJS8yBiHdehMM807dS7QxFHD/iCufcNntB/Qdes/XEbctAdIlX++VI8RYhMgFskqTL5Lax+Jw1+ofhDCHM7YrN6Di+rsYeYn0JY4hFObyQ4INtxpevrRuqU57qiau5pAS5A5J9BxfLC7yGnn5+6Bi5+M2LYvw80d68uZ0QQUJ73wSJOaJZhaA0KlSjuG7t0AB8qaN2LDToR9ZH3UR5FUsTtGiitjoCIRtnRnlAaEnZPq6Y7OhtYlY3Z68bJf4pfdgw1zfvkaqLssnN2UB48p3BdVquBsRJWjk7AaZhjkQWiG1UQSvdGaTqr3XUFbbZcw5nW9qcYdf1zptRKDC6SJegY0wNVm1xf0pUctOUh/YMSQZawfK01457G4ZjPGDNasjrDe56XFsKy3WPW/JEkRHnDo7T3FlGnu+jUujrPE4wpGNrHTk2ZaTopfu4mJ06z8mCIUlp+OuWxyV4cys+DGyTj9gJ19ayt4v6SPZvuuwWH9nVvdzS8VMYDE9v7vrx26egocWai/nvb/xY
 Woi6rhWJ
 OFgfQ0zVR7FfXnbWo5sVoikzLN0qMYkeSKxcVqCnpWpjourl6c/9QdvMpODp2iE6SAu0KqsAHxA9GJSKIc4WRalPcLWtCLmBxD8Pb4An0Men9CwY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable sheaves for kmalloc caches. For other types than KMALLOC_NORMAL,
we can simply allow them in calculate_sizes() as they are created later
than KMALLOC_NORMAL caches and can allocate sheaves and barns from
those.

For KMALLOC_NORMAL caches we perform additional step after first
creating them without sheaves. Then bootstrap_cache_sheaves() simply
allocates and initializes barns and sheaves and finally sets
s->sheaf_capacity to make them actually used.

Afterwards the only caches left without sheaves (unless SLUB_TINY or
debugging is enabled) are kmem_cache and kmem_cache_node. These are only
used when creating or destroying other kmem_caches. Thus they are not
performance critical and we can simply leave it that way.

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 84 insertions(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 4ca6bd944854..22acc249f9c0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2593,7 +2593,8 @@ static void *setup_object(struct kmem_cache *s, void *object)
 	return object;
 }
 
-static struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp)
+static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
+					      unsigned int capacity)
 {
 	struct slab_sheaf *sheaf;
 	size_t sheaf_size;
@@ -2611,7 +2612,7 @@ static struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp)
 	if (s->flags & SLAB_KMALLOC)
 		gfp |= __GFP_NO_OBJ_EXT;
 
-	sheaf_size = struct_size(sheaf, objects, s->sheaf_capacity);
+	sheaf_size = struct_size(sheaf, objects, capacity);
 	sheaf = kzalloc(sheaf_size, gfp);
 
 	if (unlikely(!sheaf))
@@ -2624,6 +2625,12 @@ static struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp)
 	return sheaf;
 }
 
+static inline struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s,
+						   gfp_t gfp)
+{
+	return __alloc_empty_sheaf(s, gfp, s->sheaf_capacity);
+}
+
 static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
 {
 	kfree(sheaf);
@@ -8144,8 +8151,11 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
 	if (s->flags & SLAB_RECLAIM_ACCOUNT)
 		s->allocflags |= __GFP_RECLAIMABLE;
 
-	/* kmalloc caches need extra care to support sheaves */
-	if (!is_kmalloc_cache(s))
+	/*
+	 * For KMALLOC_NORMAL caches we enable sheaves later by
+	 * bootstrap_kmalloc_sheaves() to avoid recursion
+	 */
+	if (!is_kmalloc_normal(s))
 		s->sheaf_capacity = calculate_sheaf_capacity(s, args);
 
 	/*
@@ -8640,6 +8650,74 @@ static struct kmem_cache * __init bootstrap(struct kmem_cache *static_cache)
 	return s;
 }
 
+/*
+ * Finish the sheaves initialization done normally by init_percpu_sheaves() and
+ * init_kmem_cache_nodes(). For normal kmalloc caches we have to bootstrap it
+ * since sheaves and barns are allocated by kmalloc.
+ */
+static void __init bootstrap_cache_sheaves(struct kmem_cache *s)
+{
+	struct kmem_cache_args empty_args = {};
+	unsigned int capacity;
+	bool failed = false;
+	int node, cpu;
+
+	capacity = calculate_sheaf_capacity(s, &empty_args);
+
+	/* capacity can be 0 due to debugging or SLUB_TINY */
+	if (!capacity)
+		return;
+
+	for_each_node_mask(node, slab_nodes) {
+		struct node_barn *barn;
+
+		barn = kmalloc_node(sizeof(*barn), GFP_KERNEL, node);
+
+		if (!barn) {
+			failed = true;
+			goto out;
+		}
+
+		barn_init(barn);
+		get_node(s, node)->barn = barn;
+	}
+
+	for_each_possible_cpu(cpu) {
+		struct slub_percpu_sheaves *pcs;
+
+		pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
+
+		pcs->main = __alloc_empty_sheaf(s, GFP_KERNEL, capacity);
+
+		if (!pcs->main) {
+			failed = true;
+			break;
+		}
+	}
+
+out:
+	/*
+	 * It's still early in boot so treat this like same as a failure to
+	 * create the kmalloc cache in the first place
+	 */
+	if (failed)
+		panic("Out of memory when creating kmem_cache %s\n", s->name);
+
+	s->sheaf_capacity = capacity;
+}
+
+static void __init bootstrap_kmalloc_sheaves(void)
+{
+	enum kmalloc_cache_type type;
+
+	for (type = KMALLOC_NORMAL; type <= KMALLOC_RANDOM_END; type++) {
+		for (int idx = 0; idx < KMALLOC_SHIFT_HIGH + 1; idx++) {
+			if (kmalloc_caches[type][idx])
+				bootstrap_cache_sheaves(kmalloc_caches[type][idx]);
+		}
+	}
+}
+
 void __init kmem_cache_init(void)
 {
 	static __initdata struct kmem_cache boot_kmem_cache,
@@ -8683,6 +8761,8 @@ void __init kmem_cache_init(void)
 	setup_kmalloc_cache_index_table();
 	create_kmalloc_caches();
 
+	bootstrap_kmalloc_sheaves();
+
 	/* Setup random freelists for each cache */
 	init_freelist_randomization();
 

-- 
2.52.0


