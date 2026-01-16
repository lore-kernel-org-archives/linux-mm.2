Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 862AFC982C7
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 14:40:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D660C6B0093; Fri, 16 Jan 2026 09:40:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC9E06B0095; Fri, 16 Jan 2026 09:40:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB9A66B0096; Fri, 16 Jan 2026 09:40:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 952886B0093
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:40:53 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5872F138F33
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:40:53 +0000 (UTC)
X-FDA: 84338088786.18.6CE8229
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1496D140007
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:40:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eZQyPLN9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JS727WAF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eZQyPLN9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JS727WAF;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768574451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/upRfJ3PHSpDAJJ/Lor3pwgQGBiD4JB0EJmftl/mO6A=;
	b=DG3U3xbJJpm3tryy9bUkAU+T2z1R9ANYdP8zR1YO21VkwGeWl+6zQwLkoaiUaZRpOa4N/v
	0Mg0PtMHG6iE/ZvoWg+yF/4BzngKNgR4NotR28VZWm/xdxO6w6rBZoi3fbmn7JHfXdKrXm
	tA2gjDiPkS3VYKaCzz7NVfhYAUFMNl8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768574451; a=rsa-sha256;
	cv=none;
	b=lDnXQPcyBEK8OMGwFIq97WjoPpYY3v44rY9f7Q8lHXhLrbaUiDaBGgWCSKdjmFaOd5lOmO
	F8AnVQR1RavkIbmgQzWoCqYu8zf9kZWTLhJtNIM/xtPf7DsomiuEUUI497Bi0xooOq1uBX
	Q6MOs1Ez8h15yjGXfmYAjzbTFw1h1jA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eZQyPLN9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JS727WAF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eZQyPLN9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JS727WAF;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 460AA5BE85;
	Fri, 16 Jan 2026 14:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/upRfJ3PHSpDAJJ/Lor3pwgQGBiD4JB0EJmftl/mO6A=;
	b=eZQyPLN9DJMcCaE2uxOwagAotWKBSVJboVVCUKS+aR2tp2qaGnF2WMG8/r0qjet7ZkZyHu
	rRKltn6v/KzG9DoYnXOOg8MPNciFeEEtseWtH+97WkVmIIOB+v0ViasUWqZyG2GEZRCiDe
	dD+JxE02TSMHvJIOBWQSQHoHMOIBqUo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574437;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/upRfJ3PHSpDAJJ/Lor3pwgQGBiD4JB0EJmftl/mO6A=;
	b=JS727WAFeDyGguz7UNeWsDT9YbFz4mhTxOowAOC5XhsXk3Lm/9DWnjramaz1fYa8uIjKc4
	cNVSE1CiWnsvTwDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/upRfJ3PHSpDAJJ/Lor3pwgQGBiD4JB0EJmftl/mO6A=;
	b=eZQyPLN9DJMcCaE2uxOwagAotWKBSVJboVVCUKS+aR2tp2qaGnF2WMG8/r0qjet7ZkZyHu
	rRKltn6v/KzG9DoYnXOOg8MPNciFeEEtseWtH+97WkVmIIOB+v0ViasUWqZyG2GEZRCiDe
	dD+JxE02TSMHvJIOBWQSQHoHMOIBqUo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574437;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/upRfJ3PHSpDAJJ/Lor3pwgQGBiD4JB0EJmftl/mO6A=;
	b=JS727WAFeDyGguz7UNeWsDT9YbFz4mhTxOowAOC5XhsXk3Lm/9DWnjramaz1fYa8uIjKc4
	cNVSE1CiWnsvTwDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 27AF03EA66;
	Fri, 16 Jan 2026 14:40:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cDlrCeVNamnydgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 16 Jan 2026 14:40:37 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 16 Jan 2026 15:40:26 +0100
Subject: [PATCH v3 06/21] slab: introduce percpu sheaves bootstrap
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260116-sheaves-for-all-v3-6-5595cb000772@suse.cz>
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
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1496D140007
X-Rspam-User: 
X-Stat-Signature: aadnscdr6mt9s4dy36i6ze8qxhhwepo1
X-HE-Tag: 1768574450-395716
X-HE-Meta: U2FsdGVkX19Ark3JawTO9dZnMSqkvNYXF0oBg+ju28ct4mVNU6sQUo7NuCY4FZqXbX6gRPLedoE3O6hwBBpmoPNLJv83/c4GLn/rGNrOfUJjubsLuluW+NwXm5qMNdGg5Xlrfqyg+t1AcOKJ5cwRlTs9mVedBw+LfDt4nVSG8YYTqlbTl409fN+fRdcOf2nYCNw+DOE3J4a9E5mjsz2KkCOaWW6050eibFA6+HIa54OP5CNC7jOHKRm5b6S5e46V6OS1ihQpQuvLI3qrY10FBdzT/XnVAAdcS4jVnMAcea4HQINzsOGeXZEOcge13Ns5HYx2HdAFw29UVasiQWKedhJFGHmKbh+hSzHUP+aGPEKjJZB57uQiy73gE+On/XLi0UdkL63y+/AtAJOPAUrmE5+8rPx/bHvXM/ljvfcmvLvVTqTj6zarFNF/CBkW7Pobv+OmlLP4gjklk7LEp1EfIIIRoQp93VNtZM/ykdw1Hs9FGoXiQqMOBi6e0wJNzs/lXfKXi2q3LhK60rOsmKuYWBCv13Lo/RWiHnyK+b224bmykC+LWRFRgWCfXcxR5lChTr5XycWFheiDqqVXlYN++UYvFZ1FZpDKVlCG5QDi1OM8uAGvplK2SjvB50H69+DX2eeRhnTcjBg96IRrPl6cQuSTx2HEHISteW/7fCNicqFBM8yq5CouRjQ37qnQIGMTA0F/5/Iw+kQIBQYdix5QLaaM1TcBtpolHo7dgegu6L+LDjx1mBz+oOSfZifOtwaUzNHucs1by3Pa5WhGE+2bY6+Alxpilxmh4vEYmUcUSyUc0adPFnt8xLiAqlevjqyQwW85Sx+sm4EX6nQw19YDcyiG9JI+6yvXlnCbQv3XnpIKoxu6QKLiuHeMsMR1dUeYkY/pwcCAIEma4AOJ60TVMBiRZ+hCXUxmZR+nRbQG7oNDoGRSfGhKLG0qrx2KB/R8q1RCV+Yo4Xqi1cArtuz
 VZNGnJAr
 ri4kVyT7JJsD8v0iK4dp6N3XgBHKvUg+ltHfsMkXes0ba8B6QFH1o1fclfYD3i+dWlaJSIkIXIkEr0fo53hTmZGumQjYBUOux3J6/8iPHrxCjgvy27vNatYKdfStcaCanFBJMuWA72rsvbqW4fU1LmgGxnBJCXLecEhYnSTy9gb1klEsrDozusoeb+lUHKV5gIWW8lkay9B6mZsGrewML7wtSR8Uv7zqLHOFjU+KfPoFPgk87W52GaoXtuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Until now, kmem_cache->cpu_sheaves was !NULL only for caches with
sheaves enabled. Since we want to enable them for almost all caches,
it's suboptimal to test the pointer in the fast paths, so instead
allocate it for all caches in do_kmem_cache_create(). Instead of testing
the cpu_sheaves pointer to recognize caches (yet) without sheaves, test
kmem_cache->sheaf_capacity for being 0, where needed, using a new
cache_has_sheaves() helper.

However, for the fast paths sake we also assume that the main sheaf
always exists (pcs->main is !NULL), and during bootstrap we cannot
allocate sheaves yet.

Solve this by introducing a single static bootstrap_sheaf that's
assigned as pcs->main during bootstrap. It has a size of 0, so during
allocations, the fast path will find it's empty. Since the size of 0
matches sheaf_capacity of 0, the freeing fast paths will find it's
"full". In the slow path handlers, we use cache_has_sheaves() to
recognize that the cache doesn't (yet) have real sheaves, and fall back.
Thus sharing the single bootstrap sheaf like this for multiple caches
and cpus is safe.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 119 ++++++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 81 insertions(+), 38 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index edf341c87e20..706cb6398f05 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -501,6 +501,18 @@ struct kmem_cache_node {
 	struct node_barn *barn;
 };
 
+/*
+ * Every cache has !NULL s->cpu_sheaves but they may point to the
+ * bootstrap_sheaf temporarily during init, or permanently for the boot caches
+ * and caches with debugging enabled, or all caches with CONFIG_SLUB_TINY. This
+ * helper distinguishes whether cache has real non-bootstrap sheaves.
+ */
+static inline bool cache_has_sheaves(struct kmem_cache *s)
+{
+	/* Test CONFIG_SLUB_TINY for code elimination purposes */
+	return !IS_ENABLED(CONFIG_SLUB_TINY) && s->sheaf_capacity;
+}
+
 static inline struct kmem_cache_node *get_node(struct kmem_cache *s, int node)
 {
 	return s->node[node];
@@ -2855,6 +2867,10 @@ static void pcs_destroy(struct kmem_cache *s)
 		if (!pcs->main)
 			continue;
 
+		/* bootstrap or debug caches, it's the bootstrap_sheaf */
+		if (!pcs->main->cache)
+			continue;
+
 		/*
 		 * We have already passed __kmem_cache_shutdown() so everything
 		 * was flushed and there should be no objects allocated from
@@ -4030,7 +4046,7 @@ static bool has_pcs_used(int cpu, struct kmem_cache *s)
 {
 	struct slub_percpu_sheaves *pcs;
 
-	if (!s->cpu_sheaves)
+	if (!cache_has_sheaves(s))
 		return false;
 
 	pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
@@ -4052,7 +4068,7 @@ static void flush_cpu_slab(struct work_struct *w)
 
 	s = sfw->s;
 
-	if (s->cpu_sheaves)
+	if (cache_has_sheaves(s))
 		pcs_flush_all(s);
 
 	flush_this_cpu_slab(s);
@@ -4157,7 +4173,7 @@ void flush_all_rcu_sheaves(void)
 	mutex_lock(&slab_mutex);
 
 	list_for_each_entry(s, &slab_caches, list) {
-		if (!s->cpu_sheaves)
+		if (!cache_has_sheaves(s))
 			continue;
 		flush_rcu_sheaves_on_cache(s);
 	}
@@ -4179,7 +4195,7 @@ static int slub_cpu_dead(unsigned int cpu)
 	mutex_lock(&slab_mutex);
 	list_for_each_entry(s, &slab_caches, list) {
 		__flush_cpu_slab(s, cpu);
-		if (s->cpu_sheaves)
+		if (cache_has_sheaves(s))
 			__pcs_flush_all_cpu(s, cpu);
 	}
 	mutex_unlock(&slab_mutex);
@@ -4979,6 +4995,12 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
+	/* Bootstrap or debug cache, back off */
+	if (unlikely(!cache_has_sheaves(s))) {
+		local_unlock(&s->cpu_sheaves->lock);
+		return NULL;
+	}
+
 	if (pcs->spare && pcs->spare->size > 0) {
 		swap(pcs->main, pcs->spare);
 		return pcs;
@@ -5165,6 +5187,11 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 		struct slab_sheaf *full;
 		struct node_barn *barn;
 
+		if (unlikely(!cache_has_sheaves(s))) {
+			local_unlock(&s->cpu_sheaves->lock);
+			return allocated;
+		}
+
 		if (pcs->spare && pcs->spare->size > 0) {
 			swap(pcs->main, pcs->spare);
 			goto do_alloc;
@@ -5244,8 +5271,7 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 	if (unlikely(object))
 		goto out;
 
-	if (s->cpu_sheaves)
-		object = alloc_from_pcs(s, gfpflags, node);
+	object = alloc_from_pcs(s, gfpflags, node);
 
 	if (!object)
 		object = __slab_alloc_node(s, gfpflags, node, addr, orig_size);
@@ -5355,17 +5381,6 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
 
 	if (unlikely(size > s->sheaf_capacity)) {
 
-		/*
-		 * slab_debug disables cpu sheaves intentionally so all
-		 * prefilled sheaves become "oversize" and we give up on
-		 * performance for the debugging. Same with SLUB_TINY.
-		 * Creating a cache without sheaves and then requesting a
-		 * prefilled sheaf is however not expected, so warn.
-		 */
-		WARN_ON_ONCE(s->sheaf_capacity == 0 &&
-			     !IS_ENABLED(CONFIG_SLUB_TINY) &&
-			     !(s->flags & SLAB_DEBUG_FLAGS));
-
 		sheaf = kzalloc(struct_size(sheaf, objects, size), gfp);
 		if (!sheaf)
 			return NULL;
@@ -6082,6 +6097,12 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
 restart:
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
+	/* Bootstrap or debug cache, back off */
+	if (unlikely(!cache_has_sheaves(s))) {
+		local_unlock(&s->cpu_sheaves->lock);
+		return NULL;
+	}
+
 	barn = get_barn(s);
 	if (!barn) {
 		local_unlock(&s->cpu_sheaves->lock);
@@ -6280,6 +6301,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 		struct slab_sheaf *empty;
 		struct node_barn *barn;
 
+		/* Bootstrap or debug cache, fall back */
+		if (unlikely(!cache_has_sheaves(s))) {
+			local_unlock(&s->cpu_sheaves->lock);
+			goto fail;
+		}
+
 		if (pcs->spare && pcs->spare->size == 0) {
 			pcs->rcu_free = pcs->spare;
 			pcs->spare = NULL;
@@ -6674,9 +6701,8 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
 	if (unlikely(!slab_free_hook(s, object, slab_want_init_on_free(s), false)))
 		return;
 
-	if (s->cpu_sheaves && likely(!IS_ENABLED(CONFIG_NUMA) ||
-				     slab_nid(slab) == numa_mem_id())
-			   && likely(!slab_test_pfmemalloc(slab))) {
+	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id())
+	    && likely(!slab_test_pfmemalloc(slab))) {
 		if (likely(free_to_pcs(s, object)))
 			return;
 	}
@@ -7379,7 +7405,7 @@ void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
 	 * freeing to sheaves is so incompatible with the detached freelist so
 	 * once we go that way, we have to do everything differently
 	 */
-	if (s && s->cpu_sheaves) {
+	if (s && cache_has_sheaves(s)) {
 		free_to_pcs_bulk(s, size, p);
 		return;
 	}
@@ -7490,8 +7516,7 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
 		size--;
 	}
 
-	if (s->cpu_sheaves)
-		i = alloc_from_pcs_bulk(s, size, p);
+	i = alloc_from_pcs_bulk(s, size, p);
 
 	if (i < size) {
 		/*
@@ -7702,6 +7727,7 @@ static inline int alloc_kmem_cache_cpus(struct kmem_cache *s)
 
 static int init_percpu_sheaves(struct kmem_cache *s)
 {
+	static struct slab_sheaf bootstrap_sheaf = {};
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
@@ -7711,7 +7737,28 @@ static int init_percpu_sheaves(struct kmem_cache *s)
 
 		local_trylock_init(&pcs->lock);
 
-		pcs->main = alloc_empty_sheaf(s, GFP_KERNEL);
+		/*
+		 * Bootstrap sheaf has zero size so fast-path allocation fails.
+		 * It has also size == s->sheaf_capacity, so fast-path free
+		 * fails. In the slow paths we recognize the situation by
+		 * checking s->sheaf_capacity. This allows fast paths to assume
+		 * s->cpu_sheaves and pcs->main always exists and is valid.
+		 * It's also safe to share the single static bootstrap_sheaf
+		 * with zero-sized objects array as it's never modified.
+		 *
+		 * bootstrap_sheaf also has NULL pointer to kmem_cache so we
+		 * recognize it and not attempt to free it when destroying the
+		 * cache
+		 *
+		 * We keep bootstrap_sheaf for kmem_cache and kmem_cache_node,
+		 * caches with debug enabled, and all caches with SLUB_TINY.
+		 * For kmalloc caches it's used temporarily during the initial
+		 * bootstrap.
+		 */
+		if (!s->sheaf_capacity)
+			pcs->main = &bootstrap_sheaf;
+		else
+			pcs->main = alloc_empty_sheaf(s, GFP_KERNEL);
 
 		if (!pcs->main)
 			return -ENOMEM;
@@ -7809,7 +7856,7 @@ static int init_kmem_cache_nodes(struct kmem_cache *s)
 			continue;
 		}
 
-		if (s->cpu_sheaves) {
+		if (cache_has_sheaves(s)) {
 			barn = kmalloc_node(sizeof(*barn), GFP_KERNEL, node);
 
 			if (!barn)
@@ -8127,7 +8174,7 @@ int __kmem_cache_shutdown(struct kmem_cache *s)
 	flush_all_cpus_locked(s);
 
 	/* we might have rcu sheaves in flight */
-	if (s->cpu_sheaves)
+	if (cache_has_sheaves(s))
 		rcu_barrier();
 
 	/* Attempt to free all objects */
@@ -8439,7 +8486,7 @@ static int slab_mem_going_online_callback(int nid)
 		if (get_node(s, nid))
 			continue;
 
-		if (s->cpu_sheaves) {
+		if (cache_has_sheaves(s)) {
 			barn = kmalloc_node(sizeof(*barn), GFP_KERNEL, nid);
 
 			if (!barn) {
@@ -8647,12 +8694,10 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
 
 	set_cpu_partial(s);
 
-	if (s->sheaf_capacity) {
-		s->cpu_sheaves = alloc_percpu(struct slub_percpu_sheaves);
-		if (!s->cpu_sheaves) {
-			err = -ENOMEM;
-			goto out;
-		}
+	s->cpu_sheaves = alloc_percpu(struct slub_percpu_sheaves);
+	if (!s->cpu_sheaves) {
+		err = -ENOMEM;
+		goto out;
 	}
 
 #ifdef CONFIG_NUMA
@@ -8671,11 +8716,9 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
 	if (!alloc_kmem_cache_cpus(s))
 		goto out;
 
-	if (s->cpu_sheaves) {
-		err = init_percpu_sheaves(s);
-		if (err)
-			goto out;
-	}
+	err = init_percpu_sheaves(s);
+	if (err)
+		goto out;
 
 	err = 0;
 

-- 
2.52.0


