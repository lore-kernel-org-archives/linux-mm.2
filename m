Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B8DFCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 09:05:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD8C38E0010; Wed,  5 Nov 2025 04:05:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFB868E0002; Wed,  5 Nov 2025 04:05:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 976438E0010; Wed,  5 Nov 2025 04:05:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7388F8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:05:41 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2DE5D140252
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:05:41 +0000 (UTC)
X-FDA: 84075970482.15.04F827E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 04D8B160008
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:05:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dRvvKLgY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1NzQGu59;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dRvvKLgY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1NzQGu59;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762333539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tVqdfrjinTijcg8TfrfGQECaxpdrWMMyTcELwLOOflY=;
	b=T0JK+9uIVjrNgaLGlSZat1fIkTv4ky6bfp+BAungGmPfLty4bKImxXY9PCRqX7WCHfH+Yp
	T3Di125WaGVyd9S7+Duz/5ElXIOQ7ve5+ibvTCOG0gRF6EnY3Qkak1jrwXj8LurNxPur8R
	Qm2Ue7FJDMKSxkmEQG0fwLP8g3xjHSs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762333539; a=rsa-sha256;
	cv=none;
	b=i6QwcfiU9OdA+RDJFRUoc8x8V+WT+TzpYJ+IHyrtwkhujDERFiuKAlW1fJx7eSrvR5BIyB
	KfBcFCOag2GqPazKdittNsnbn9iRusLPMvxGlq6MXezFQ2/dZfp2F2xmHnpsYoTBCuKN8p
	WcJ7ywacfzhTaJnaUj3OVFsgx4jrAic=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dRvvKLgY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1NzQGu59;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dRvvKLgY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1NzQGu59;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CCF9B21193;
	Wed,  5 Nov 2025 09:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762333530; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tVqdfrjinTijcg8TfrfGQECaxpdrWMMyTcELwLOOflY=;
	b=dRvvKLgYGTfd/n3M1dFj6+GxTd+NScV+vYHpylekGIYZcBLNjg/XfoL8xaa3nbx3hYxrqO
	SkhthjfMSKpKkGZkyS0vjzTLoRYcAXpSjc9FtNWtyXM2w+dYdL3G0Q65uJfJ8erXDaz/8N
	RlAB3GlKVXoufpmp5E2og5oBgyIDq/k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762333530;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tVqdfrjinTijcg8TfrfGQECaxpdrWMMyTcELwLOOflY=;
	b=1NzQGu59u/7ZxRzwVyaZG9DTNHQteJfJjumnVC7Yd0iBtAHohH+7ncrCCJghTB2JqSsAch
	zWnZcE5Od9QwF7CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762333530; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tVqdfrjinTijcg8TfrfGQECaxpdrWMMyTcELwLOOflY=;
	b=dRvvKLgYGTfd/n3M1dFj6+GxTd+NScV+vYHpylekGIYZcBLNjg/XfoL8xaa3nbx3hYxrqO
	SkhthjfMSKpKkGZkyS0vjzTLoRYcAXpSjc9FtNWtyXM2w+dYdL3G0Q65uJfJ8erXDaz/8N
	RlAB3GlKVXoufpmp5E2og5oBgyIDq/k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762333530;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tVqdfrjinTijcg8TfrfGQECaxpdrWMMyTcELwLOOflY=;
	b=1NzQGu59u/7ZxRzwVyaZG9DTNHQteJfJjumnVC7Yd0iBtAHohH+7ncrCCJghTB2JqSsAch
	zWnZcE5Od9QwF7CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B303613ADD;
	Wed,  5 Nov 2025 09:05:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iKJyK1oTC2lSBAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 05 Nov 2025 09:05:30 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 05 Nov 2025 10:05:31 +0100
Subject: [PATCH 3/5] slab: handle pfmemalloc slabs properly with sheaves
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251105-sheaves-cleanups-v1-3-b8218e1ac7ef@suse.cz>
References: <20251105-sheaves-cleanups-v1-0-b8218e1ac7ef@suse.cz>
In-Reply-To: <20251105-sheaves-cleanups-v1-0-b8218e1ac7ef@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 04D8B160008
X-Stat-Signature: n3qs7asfe6omtbptk18sjcnjt3qccs9y
X-Rspam-User: 
X-HE-Tag: 1762333538-430655
X-HE-Meta: U2FsdGVkX19aCzS1t04sgSsRqPx2aMEP6DMHq+8M34w5qXrLLIVXmmk91NcgiWMaPHKeBRU9csiOjhxkBzvJ7BK2yikBQYj56Iax4Cmr4WlDI4vkvkEJuEZ1adY1JbV31wAjpHryciZLS7dMUe15I+yHo8irtt0hVBoWXF+28h88bdgjJsFbrYNKjHcWv+dcTaADDY/a71iyv0njic97v8z2SqI+xsMMrFtJCtcuC/3/nVaIUjTOhIQBwpD1t+8lhr9DhNMrmH+x8fpOL++ZAERFK5YARYCb0EeDcip8cNrqC8nFazqrDy4u2IIjIQMyjN6G//7YyJfYFtSyGJ/4qrhzHLNaR0kYf328HoWj9x0SQGe/0RGvO4hjnu4VNaip4lK+Bdy9cSsImfzU2lPFE53CKovBT8M2Rp1YpY8T6TYy7LcdLWinndsqXp5e8uqM2J2FnFrNCq0wnjYMDezivCsFkOoaEbkhGHkFKZ6bwW5WVOhY9ZJqB7JqBkNR2swxgE01+90kyA3a4bDb9wQ1S+n4zycWPumEygIQ/QIEZ0aHx6GRxgKL0w8FR/ncnpeKD5jloIJeeCsxo+joEPQwWeju0yPusksVy0hqkx+8j7uNhpxGqR0E9x7TKcQNIorp4YwKw6AX+q9cs4a3AD8YYOhH9BkrWlFJlAQ6cET3SWpxeArRAEe9ofDT2kzulMxZabcVeaOOBu8TLtBvt+MSXXOIwQHNu1dGxU+iSY0qVO2C53+MZUlgJzti2YSghKmA+NCfRWNhwq8Y0YRsmU6oaS/tf9/JEodm1w9JV2NNf3rPDKfjmezVf0e/d23Ca4nhXW91kbREAqALwYs8a/SNEHxEge0iLe6oKYa3SAecDniuPd1YOATxffmZ6MlnllKFjSvtqPVWetJW6Muw8vnHO5DS9Az4UC2mjMWPtshX2T2CGaONpk7pu2IjhnBEihIUMeAltBo22j5aZrgnmTU
 7+HAbuxJ
 ktkvQpkqMMYJo77jrNdhSQH+OWPtJd6Ck5MeRf0aYM5vp3xW9YwvbnMcQXZSWk8eRSxES8PnRYtCzC3qjfHC5eD0XXzHYo5eqnRvaVg/ybybxrUFF3dth33vnISjSW62K/Y16r7O1hGDsmmmO+IMWEAhGBXd6VbLmwFOVnMKUrfsAxQxsLAU4pt3g6LECy1CZBcd5SwAMOunBwBhzXxrcv+kYIE8zfynaKFGZ0PpXzlG9snhEINiYe9hh7JCcvqLGDdP5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a pfmemalloc allocation actually dips into reserves, the slab is
marked accordingly and non-pfmemalloc allocations should not be allowed
to allocate from it. The sheaves percpu caching currently doesn't follow
this rule, so implement it before we expand sheaves usage to all caches.

Make sure objects from pfmemalloc slabs don't end up in percpu sheaves.
When freeing, skip sheaves when freeing an object from pfmemalloc slab.
When refilling sheaves, use __GFP_NOMEMALLOC to override any pfmemalloc
context - the allocation will fallback to regular slab allocations when
sheaves are depleted and can't be refilled because of the override.

For kfree_rcu(), detect pfmemalloc slabs after processing the rcu_sheaf
after the grace period in __rcu_free_sheaf_prepare() and simply flush
it if any object is from pfmemalloc slabs.

For prefilled sheaves, try to refill them first with __GFP_NOMEMALLOC
and if it fails, retry without __GFP_NOMEMALLOC but then mark the sheaf
pfmemalloc, which makes it flushed back to slabs when returned.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 55 insertions(+), 14 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 0237a329d4e5..bb744e8044f0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -469,7 +469,10 @@ struct slab_sheaf {
 		struct rcu_head rcu_head;
 		struct list_head barn_list;
 		/* only used for prefilled sheafs */
-		unsigned int capacity;
+		struct {
+			unsigned int capacity;
+			bool pfmemalloc;
+		};
 	};
 	struct kmem_cache *cache;
 	unsigned int size;
@@ -2651,7 +2654,7 @@ static struct slab_sheaf *alloc_full_sheaf(struct kmem_cache *s, gfp_t gfp)
 	if (!sheaf)
 		return NULL;
 
-	if (refill_sheaf(s, sheaf, gfp)) {
+	if (refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC)) {
 		free_empty_sheaf(s, sheaf);
 		return NULL;
 	}
@@ -2729,12 +2732,13 @@ static void sheaf_flush_unused(struct kmem_cache *s, struct slab_sheaf *sheaf)
 	sheaf->size = 0;
 }
 
-static void __rcu_free_sheaf_prepare(struct kmem_cache *s,
+static bool __rcu_free_sheaf_prepare(struct kmem_cache *s,
 				     struct slab_sheaf *sheaf)
 {
 	bool init = slab_want_init_on_free(s);
 	void **p = &sheaf->objects[0];
 	unsigned int i = 0;
+	bool pfmemalloc = false;
 
 	while (i < sheaf->size) {
 		struct slab *slab = virt_to_slab(p[i]);
@@ -2747,8 +2751,13 @@ static void __rcu_free_sheaf_prepare(struct kmem_cache *s,
 			continue;
 		}
 
+		if (slab_test_pfmemalloc(slab))
+			pfmemalloc = true;
+
 		i++;
 	}
+
+	return pfmemalloc;
 }
 
 static void rcu_free_sheaf_nobarn(struct rcu_head *head)
@@ -5041,7 +5050,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 
 	if (empty) {
-		if (!refill_sheaf(s, empty, gfp)) {
+		if (!refill_sheaf(s, empty, gfp | __GFP_NOMEMALLOC)) {
 			full = empty;
 		} else {
 			/*
@@ -5341,6 +5350,26 @@ void *kmem_cache_alloc_node_noprof(struct kmem_cache *s, gfp_t gfpflags, int nod
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node_noprof);
 
+static int __prefill_sheaf_pfmemalloc(struct kmem_cache *s,
+				      struct slab_sheaf *sheaf, gfp_t gfp)
+{
+	int ret = 0;
+
+	ret = refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC);
+
+	if (likely(!ret || !gfp_pfmemalloc_allowed(gfp)))
+		return ret;
+
+	/*
+	 * if we are allowed to, refill sheaf with pfmemalloc but then remember
+	 * it for when it's returned
+	 */
+	ret = refill_sheaf(s, sheaf, gfp);
+	sheaf->pfmemalloc = true;
+
+	return ret;
+}
+
 /*
  * returns a sheaf that has at least the requested size
  * when prefilling is needed, do so with given gfp flags
@@ -5375,6 +5404,10 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
 		sheaf->cache = s;
 		sheaf->capacity = size;
 
+		/*
+		 * we do not need to care about pfmemalloc here because oversize
+		 * sheaves area always flushed and freed when returned
+		 */
 		if (!__kmem_cache_alloc_bulk(s, gfp, size,
 					     &sheaf->objects[0])) {
 			kfree(sheaf);
@@ -5411,17 +5444,18 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
 	if (!sheaf)
 		sheaf = alloc_empty_sheaf(s, gfp);
 
-	if (sheaf && sheaf->size < size) {
-		if (refill_sheaf(s, sheaf, gfp)) {
+	if (sheaf) {
+		sheaf->capacity = s->sheaf_capacity;
+		sheaf->pfmemalloc = false;
+
+		if (sheaf->size < size &&
+		    __prefill_sheaf_pfmemalloc(s, sheaf, gfp)) {
 			sheaf_flush_unused(s, sheaf);
 			free_empty_sheaf(s, sheaf);
 			sheaf = NULL;
 		}
 	}
 
-	if (sheaf)
-		sheaf->capacity = s->sheaf_capacity;
-
 	return sheaf;
 }
 
@@ -5441,7 +5475,8 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
 	struct slub_percpu_sheaves *pcs;
 	struct node_barn *barn;
 
-	if (unlikely(sheaf->capacity != s->sheaf_capacity)) {
+	if (unlikely((sheaf->capacity != s->sheaf_capacity)
+		     || sheaf->pfmemalloc)) {
 		sheaf_flush_unused(s, sheaf);
 		kfree(sheaf);
 		return;
@@ -5507,7 +5542,7 @@ int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
 
 	if (likely(sheaf->capacity >= size)) {
 		if (likely(sheaf->capacity == s->sheaf_capacity))
-			return refill_sheaf(s, sheaf, gfp);
+			return __prefill_sheaf_pfmemalloc(s, sheaf, gfp);
 
 		if (!__kmem_cache_alloc_bulk(s, gfp, sheaf->capacity - sheaf->size,
 					     &sheaf->objects[sheaf->size])) {
@@ -6215,8 +6250,12 @@ static void rcu_free_sheaf(struct rcu_head *head)
 	 * handles it fine. The only downside is that sheaf will serve fewer
 	 * allocations when reused. It only happens due to debugging, which is a
 	 * performance hit anyway.
+	 *
+	 * If it returns true, there was at least one object from pfmemalloc
+	 * slab so simply flush everything.
 	 */
-	__rcu_free_sheaf_prepare(s, sheaf);
+	if (__rcu_free_sheaf_prepare(s, sheaf))
+		goto flush;
 
 	n = get_node(s, sheaf->node);
 	if (!n)
@@ -6371,7 +6410,8 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 			continue;
 		}
 
-		if (unlikely(IS_ENABLED(CONFIG_NUMA) && slab_nid(slab) != node)) {
+		if (unlikely((IS_ENABLED(CONFIG_NUMA) && slab_nid(slab) != node)
+			     || slab_test_pfmemalloc(slab))) {
 			remote_objects[remote_nr] = p[i];
 			p[i] = p[--size];
 			if (++remote_nr >= PCS_BATCH_MAX)
@@ -6669,7 +6709,8 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
 		return;
 
 	if (s->cpu_sheaves && likely(!IS_ENABLED(CONFIG_NUMA) ||
-				     slab_nid(slab) == numa_mem_id())) {
+				     slab_nid(slab) == numa_mem_id())
+			   && likely(!slab_test_pfmemalloc(slab))) {
 		if (likely(free_to_pcs(s, object)))
 			return;
 	}

-- 
2.51.1


