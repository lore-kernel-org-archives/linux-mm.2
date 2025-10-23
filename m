Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB000CCD1BF
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 13:53:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F8968E003E; Thu, 23 Oct 2025 09:53:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AA3D8E0002; Thu, 23 Oct 2025 09:53:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB2E48E003E; Thu, 23 Oct 2025 09:53:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D2AFB8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:53:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C21D129B4E
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:53:56 +0000 (UTC)
X-FDA: 84029522472.05.C4C2CDA
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3B43C1C0005
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:53:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=g2RqqKtb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2EFdvI6L;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=a5zjqizc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sWIyNwSz;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761227634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bwEJAB2u9ltAgWYDeLEgZcAvDMG4WKRh64HkDQCHmoQ=;
	b=1rwuiyHENBf861sXhZza2ypYA+ekMKOYblMUHZp2CrUra2HUkePSYZ/yyToB0Bn02eDSrH
	xo8aIIKL9mc3Csw95DSWe19RtpdpA5tO5NlOL+SwQeo+kMgNW/h2GaVTFtHR0665GZBNa1
	Z9sIZUsFeC/AeSHRkdYBif8F2iAen9s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=g2RqqKtb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2EFdvI6L;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=a5zjqizc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sWIyNwSz;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761227634; a=rsa-sha256;
	cv=none;
	b=A0ERIBoBjq68HDhb5hSi+cVBCnXc7ZUSAHK/W/mhSfnlw1yQro7fCoDlICWDkqsnKFtN9L
	5ppdcB3enx5sOC1jTA6nLvwI+huOmZdDM0Onhz2dMMq2+Sbvhxsyi70FzefTXyj8EoAzyX
	MDtAA4o4w6SJMHW+Qp47hEuCIudWmQo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 799841F788;
	Thu, 23 Oct 2025 13:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761227585; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bwEJAB2u9ltAgWYDeLEgZcAvDMG4WKRh64HkDQCHmoQ=;
	b=g2RqqKtbdgDO5PzJSrGzm/1RUPPCbQTAhSf1EsfLVAyEJQUGqw3q2BKm6dC7Nz87CyuBa2
	PXFvqzQSb8Bit8YvQkEFYRTxQfPCl+3iZDb8SmqZi9Zs0tdv20/+bUOS1LBhJv4DBhZBeN
	yubVX/UoWHnVHsRzgfNdi9S0cgF/ZZo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761227585;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bwEJAB2u9ltAgWYDeLEgZcAvDMG4WKRh64HkDQCHmoQ=;
	b=2EFdvI6LKPGqMVlUHaZwPgV9WiojBfwO6nCP8O0l6222vnuPhpc8R+eJO6sux7/zhK2znv
	9cm9o+FAz9peUuCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761227581; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bwEJAB2u9ltAgWYDeLEgZcAvDMG4WKRh64HkDQCHmoQ=;
	b=a5zjqizcJ+R3FBfrwgMdNMnv3gqv/TcisPLUO3PJDxYXyhZIPfoi3mlk6HMHjco5s7OXY+
	h12Wgzo/N3oF/3GSpoOvnBs4MKQs2dHxCAf9XTv3mxgenk3fdytcSYs8HqIMX+wR7sKoId
	s9//9D7GoVn1ouxIoxO59mDj77cnNsI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761227581;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bwEJAB2u9ltAgWYDeLEgZcAvDMG4WKRh64HkDQCHmoQ=;
	b=sWIyNwSz3I0urZD07FY5c2Si4JYzhXTW3YuKNjV6bM+hzo1cKhr/e0aDoK2F/54o3PUGFd
	UTH+vRqfOOxQZWCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C4B1713B06;
	Thu, 23 Oct 2025 13:52:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KE6+LzUz+mjvQQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 23 Oct 2025 13:52:53 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Thu, 23 Oct 2025 15:52:30 +0200
Subject: [PATCH RFC 08/19] slab: handle kmalloc sheaves bootstrap
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-sheaves-for-all-v1-8-6ffa2c9941c0@suse.cz>
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
In-Reply-To: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
 bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Stat-Signature: o8h1eaqoxiogoaiq7tumzznnyrqp77zf
X-Rspamd-Queue-Id: 3B43C1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761227634-544635
X-HE-Meta: U2FsdGVkX187DJFncj4pXNtsGo2Y84L2Ip4Z3PgUUVYzcZpuhJfwX8duN/snzAz3hzdk8jIgZtc2X431dfTpwAyxCqWsyGnivOavp3e21jHnGDkCTjLFbjHeshTKebfJwQSubRreCEnc43Z+c1krRl5tySX/NpMZn6+sRu2uZ9biPJ8dE4qyhawMs5fh2hDrJMFeqUCDcIXw6r4RBdKgBltlZ+GXr6wD4aBugmlnH+nFaNWpj2sNALVhQS46r/y2McCI80PnLz8hlDklCswFT+mGXJa8mhtv54lwT0JOOcAFdCpCDj2d5V2TIU25qNhveQdpUkB9Jj2EXUe5jqhhs/6xyLvrsXROnlaty1GR4u9clrJFBnflpHRTX9WQ/0HVDxyauz4MBJI+c+7FImVwZ6su/KZeDAZ6tqk0+WeK8AitTysQb9gaIA39t4nKOf9RjGqvaLc95PzymN6YEP6YjzM63SLdR94d8gCooZ+9d7VyFFz5omho/gMBJLxtn4RTc/waw3tFUIyqp4xfiMS8kqBNbaEYa8BdJjiJMomHn5qIHVs7DbvGBO/iJuTvzLp+eUDuM8rvRBphDhB+T3qoBkVYHcfNYbrueGT1bLS/i0knxtvvWlNl+xpKURovQBpywfkyGPNH9CLsxfV0h5ZUg/hL0BUJ8QJIdzpDuBQ9msdZK98D4B+7LAsk4ytcWx/1Ksuj962f6qdazTUWBltc/ujXY8/0ZLD9vTmyhV27K1I3rhrUtkdJrzlJJrkBj2wqbuwBX7MlNrBorMb8KejQ2n3NONMPA2EnFGpXNQS8CfTQ0wlwpts/AnFV1SDmwnuaPfisl56CoNLA4yULwCljb3Cy8UdpME27zVrsl5iK+ISVa4XV+/UBcCQaduc+VxoZDpkCenyxAAOK9PZtDdCBWQnQWSTZSluPlW4NbDyejDsdW87uEkw3QVVY29a/zl+MLBCcXr25tN+/QsxmMea
 Xd7TF4of
 oDqx2K3SAKLjYQw4SYHzYD6M9t30fekP54stGMBsREjCjDd5cpHB1bVh51bYeiwQjNGvijQMxOQO3VLZ4tCyHBwELy9pAbO9/w9eHEm+pVfcgLEKUCufsQEsRuotWp7awVLJrhr3viLzJtut3a/eacGIgJaVyiEer+WDRjHLeG2hiXN7wtGMc8qM5ke8CJHemsrDW8/7FGFpNWinZgG2jjmy3kw==
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

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 84 insertions(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 5d0b2cf66520..a84027fbca78 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2588,7 +2588,8 @@ static void *setup_object(struct kmem_cache *s, void *object)
 	return object;
 }
 
-static struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp)
+static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
+					      unsigned int capacity)
 {
 	struct slab_sheaf *sheaf;
 	size_t sheaf_size;
@@ -2606,7 +2607,7 @@ static struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp)
 	if (s->flags & SLAB_KMALLOC)
 		gfp |= __GFP_NO_OBJ_EXT;
 
-	sheaf_size = struct_size(sheaf, objects, s->sheaf_capacity);
+	sheaf_size = struct_size(sheaf, objects, capacity);
 	sheaf = kzalloc(sheaf_size, gfp);
 
 	if (unlikely(!sheaf))
@@ -2619,6 +2620,12 @@ static struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp)
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
@@ -8064,8 +8071,11 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
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
@@ -8549,6 +8559,74 @@ static struct kmem_cache * __init bootstrap(struct kmem_cache *static_cache)
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
@@ -8592,6 +8670,8 @@ void __init kmem_cache_init(void)
 	setup_kmalloc_cache_index_table();
 	create_kmalloc_caches();
 
+	bootstrap_kmalloc_sheaves();
+
 	/* Setup random freelists for each cache */
 	init_freelist_randomization();
 

-- 
2.51.1


