Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D193FC982C7
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 14:41:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F27BC6B0098; Fri, 16 Jan 2026 09:41:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBDB16B0099; Fri, 16 Jan 2026 09:41:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D41DF6B009B; Fri, 16 Jan 2026 09:41:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C4FAA6B0098
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:41:04 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8E4E01AD324
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:41:04 +0000 (UTC)
X-FDA: 84338089248.21.A60A334
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id 521E0140004
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:41:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=k6hRjn02;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3NeDCWdf;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=k6hRjn02;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3NeDCWdf;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768574462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=en/PV8L5vRbZ1mp+m0UL7Z3JJuIYQSFGAs1yxFq9ZMM=;
	b=IzYVPcAgXi3rQAzmfHutZPMbOH1foo5WGQin8m/w/3KkkK26UlCRpgaKHOL09m9op49RzW
	J160EMVAWGhdfU/68wke6vekNpK1sWioOl2gh7bOYKfsxXnOuk5pvJ9Xcl5HLgFGfw3zLK
	7k6pHIxnxrt7GWmDW0c7p+88nQ0/4oM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768574462; a=rsa-sha256;
	cv=none;
	b=3RtiDJQVxXp7uwPEjNvgp0uKaM8TcM5Dzk5hcp3a4v7II2/2kABg5FJjsEbr9Hs78fHmWd
	XA4Sv5Tg+Gx4rHQ/7pn0j4q7dM1QSpZbZl5FDcLALToWHy2qGk8u2dWUjRBIAFpCX76de3
	syyfvmmgDpnISVNmYdk6tuPq8MirIlk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=k6hRjn02;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3NeDCWdf;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=k6hRjn02;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3NeDCWdf;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7CFEA337F4;
	Fri, 16 Jan 2026 14:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=en/PV8L5vRbZ1mp+m0UL7Z3JJuIYQSFGAs1yxFq9ZMM=;
	b=k6hRjn02kgL6wXHoy4EJb+sOs8vawSDtCZXKYpubQOgmFJW4ifecLsuxeRYDdihbZBdrHA
	jDQ8RQBfZAOkNIUD+gpO1Dc+GoasvzTBd2t1DE4vAA60xeFKiRtGrxJjx/eYqzRul+/+3i
	oysVC477tk84xgu0UhFHEcn+RUWNKqA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574437;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=en/PV8L5vRbZ1mp+m0UL7Z3JJuIYQSFGAs1yxFq9ZMM=;
	b=3NeDCWdfbS4Ut4e0yvLQm+Wq3XKjTQqscJKUneY6XLrZSK4XqBUQFduaHFfkwMlZ8fKz4t
	WyT9KpEjEmNERDCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=en/PV8L5vRbZ1mp+m0UL7Z3JJuIYQSFGAs1yxFq9ZMM=;
	b=k6hRjn02kgL6wXHoy4EJb+sOs8vawSDtCZXKYpubQOgmFJW4ifecLsuxeRYDdihbZBdrHA
	jDQ8RQBfZAOkNIUD+gpO1Dc+GoasvzTBd2t1DE4vAA60xeFKiRtGrxJjx/eYqzRul+/+3i
	oysVC477tk84xgu0UhFHEcn+RUWNKqA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574437;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=en/PV8L5vRbZ1mp+m0UL7Z3JJuIYQSFGAs1yxFq9ZMM=;
	b=3NeDCWdfbS4Ut4e0yvLQm+Wq3XKjTQqscJKUneY6XLrZSK4XqBUQFduaHFfkwMlZ8fKz4t
	WyT9KpEjEmNERDCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5F6B03EA65;
	Fri, 16 Jan 2026 14:40:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iCQFF+VNamnydgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 16 Jan 2026 14:40:37 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 16 Jan 2026 15:40:28 +0100
Subject: [PATCH v3 08/21] slab: handle kmalloc sheaves bootstrap
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260116-sheaves-for-all-v3-8-5595cb000772@suse.cz>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
In-Reply-To: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 521E0140004
X-Rspam-User: 
X-Stat-Signature: 57mtcbhx9tuzhwpm9fu9pgh6n1tpxxsg
X-HE-Tag: 1768574462-741942
X-HE-Meta: U2FsdGVkX1+EwJIuiupXlsqYdeYgJFa0wt8dnBMGzZ1TkLLQLECJmagu+sOGw4s/GyXmh4MtbFuhZbW+TFEqbknYunUmC4HL+B6HBuTR5MYzTQwi9WRDQ4sIp8ufi88srgmB7z6nAoyrmTQSJyLTie04ri6f1zyuB2Xgp2N2k4k0d2eYE2RiyY67P49lhrMC4vxRXs5nSMGBx3HkdRAjn56oHsbQodv4GEcKS52vBdYVmsDGSommnDjFZEbWOa/3GJ0SeyG8PjRCUXo4kl2l5wPDzi2ucy9+hTrZV+Q+C/xggVLL2WbXtO0a0T3+/4lbX/KTGu1idee0lDXyltgksYitur0tVSneYEDtbBcpv3peRon5yuZNO4VWgDscjusFLcKjLn78NV+e+81PTaF7Ijd0y4XVM+lxW2scQl6lPx0Nqo5WFrpJJAK18Gl+qA/piKE5A4NcUTX2oSe46hsEWMXFq5wjUiyKOWenudRyy01GhaFeCpEYwKy6EelCDd/nVLH+N61rvF/0/CmSpIIIwfBOTH7HhIOu8lHxq2b1uqszYoCfOo+oCP4xuIU0yZZlCSLmAyDI9fAJrdkx2ikZmTqXFxIkJY5W2QskP4UdqShqLg+gJjrxFXfFDO6prNa2kSiEGGMSRpRF//Vxo6ao9/masfYZMBZWqqKeHYW3JH6GRi5H6yOlCVmAe5UC5hK3etFwhK39w9oftOnBQd2rTcTzQ5xCDuUb3Gywj6YT6oPVUfUyTBifm6QULbgtFG/jIX+tKAX1ySvPXtQaosts2hZu4lf/X3syQ6xf+FOq9BrnxNLPPW0i+vaYmPjxRNcoSBNa3JnJuUHrtVE0MJYF6KhOdyTcJUz4a4eXDEfq/3TTv4oqgDr06qXxo15gxA79HraxVE5WBujDiike3g9vyXnFw7PmttnnTQH1K6czZHM2Fge9sEhMbv+eaApC+E8d9HgtmS3Km/eV8Q3XndJ
 iOQjYzVJ
 UnelzZwJRu7CzzcZEGylfb52fnvJrfpM4nGiG+oidTWs12TooOJKwXmhWS7I7ZrlABjNTf/7rNY2zmZxYfBQyMnma+1Yxj/Bm7tB8cvA3xS3Cfb6RwOl01tYp7FTJnifXhvxTTppyxkI0ZrfSO4EuqHjSGYHFtzoz4u+FQsAaQYF7oyjakNqmqUHC42l0WM8ZHKX0XpH5XIcsWk/NuvplScqcifLMC5HkD5qSS7Ttdf8V/G2hoOs7hW+k5PSV1eaN2HwIeAebojlDsh8=
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

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 84 insertions(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b385247c219f..9bea8a65e510 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2605,7 +2605,8 @@ static void *setup_object(struct kmem_cache *s, void *object)
 	return object;
 }
 
-static struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp)
+static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
+					      unsigned int capacity)
 {
 	struct slab_sheaf *sheaf;
 	size_t sheaf_size;
@@ -2623,7 +2624,7 @@ static struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp)
 	if (s->flags & SLAB_KMALLOC)
 		gfp |= __GFP_NO_OBJ_EXT;
 
-	sheaf_size = struct_size(sheaf, objects, s->sheaf_capacity);
+	sheaf_size = struct_size(sheaf, objects, capacity);
 	sheaf = kzalloc(sheaf_size, gfp);
 
 	if (unlikely(!sheaf))
@@ -2636,6 +2637,12 @@ static struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp)
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
@@ -8119,8 +8126,11 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
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
@@ -8615,6 +8625,74 @@ static struct kmem_cache * __init bootstrap(struct kmem_cache *static_cache)
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
@@ -8658,6 +8736,8 @@ void __init kmem_cache_init(void)
 	setup_kmalloc_cache_index_table();
 	create_kmalloc_caches();
 
+	bootstrap_kmalloc_sheaves();
+
 	/* Setup random freelists for each cache */
 	init_freelist_randomization();
 

-- 
2.52.0


