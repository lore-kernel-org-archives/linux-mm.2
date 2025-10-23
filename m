Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1814CCCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 13:53:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7112E8E0034; Thu, 23 Oct 2025 09:53:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C2C08E0002; Thu, 23 Oct 2025 09:53:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53CF18E0034; Thu, 23 Oct 2025 09:53:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3F8C88E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:53:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A94E349232
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:53:26 +0000 (UTC)
X-FDA: 84029521212.02.7C39773
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 72F17C0005
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:53:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wqZuf521;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CnYeHNMj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cByGnC2S;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YD2XioWV;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761227604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fdXDD3/ZApJgGZ00uKWLh+CAcEIa/UY+x34vKoVNPc8=;
	b=JeldjuCPt87mwr5KGQ99KzSG3bNsBrfCjjszTGdf0fcKs06H9zYUBhqVZINyO9mkVUgNdI
	a8An2tg4vAeKKpmHfTzHQR3MyVVqQkRW1813CFEy+e12QrM5oiitrTRkTvxgkpAShr25r5
	+iphlkExoLASuyboGs538l8jWtKzZt0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761227604; a=rsa-sha256;
	cv=none;
	b=lEN2OONxCSF7HYyD7euMm8JIJ2Bt/5PiTVHskbpH/vhI4JzRKpMN7kqHKPwmvhKBn2QbTk
	WSKtAIdsm+7xr3Kc4TpWe+pXTMWWbtXolnNz2bGTUiRewxEFnQ4RhEabL7KS7q2Luuo5NG
	rxF8U2vmjqZru7VE4zlUPxMOMaB3iHI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wqZuf521;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CnYeHNMj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cByGnC2S;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YD2XioWV;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5A2011F7E2;
	Thu, 23 Oct 2025 13:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761227577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fdXDD3/ZApJgGZ00uKWLh+CAcEIa/UY+x34vKoVNPc8=;
	b=wqZuf521dhBUSe+PUBx5cFjW0EwNwJ09LrbM/jktq5YHqpOLnp+mhM6lSq/rq2o5FOJ2MW
	sorgz8blp0znWqoZfvlkKYcB2kjPyDLm0LjWK1x4w15RN+JEReXLwUjAedi4TFv1kfO4AS
	w6kNaPq61VzY0A6++uSdhetdNNLJtnU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761227577;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fdXDD3/ZApJgGZ00uKWLh+CAcEIa/UY+x34vKoVNPc8=;
	b=CnYeHNMjlFQL7+/DQKpWMg0TtyCTAOWISIgwHjfphP18Y0wo43Rh/50FTu2drTTDthhQQ/
	PlUpuLQ2A7PqPwAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761227573; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fdXDD3/ZApJgGZ00uKWLh+CAcEIa/UY+x34vKoVNPc8=;
	b=cByGnC2SYolBTRDYP8LS+IpQD1Eji+sWPYqwG9A7uyT2WYWd6uF4ocy1PBoEU2twgSQF3F
	po19jPfCxukL6MloV/Hb7HvbDv3zwlHggPvg+lsQjKntGDG3IooxXV8xRzqBWw0DfRZY0o
	ZdMcKD+AS5LAdkwznTDzrjwN+w9yVO8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761227573;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fdXDD3/ZApJgGZ00uKWLh+CAcEIa/UY+x34vKoVNPc8=;
	b=YD2XioWV/+tzIWCxj8BZXcvzFXDMaQOhyZIP1OrCHhNrqg2jVi0Z5PnAZ1jSf3E020PTTA
	OlHX/cLWXNnc99Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3099A13AAB;
	Thu, 23 Oct 2025 13:52:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yIGWCzUz+mjvQQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 23 Oct 2025 13:52:53 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Thu, 23 Oct 2025 15:52:24 +0200
Subject: [PATCH RFC 02/19] slab: handle pfmemalloc slabs properly with
 sheaves
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-sheaves-for-all-v1-2-6ffa2c9941c0@suse.cz>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 72F17C0005
X-Rspamd-Server: rspam02
X-Stat-Signature: anzkstyrta3nd435f1mwipzar4xot5jr
X-HE-Tag: 1761227604-963311
X-HE-Meta: U2FsdGVkX1/ttnfpuNWgK6tiq+BSAc6vpcsAk0ZkTF/yZ8WjyqE1ezCaptQrhW2OewvKtgOjQkm+1SEvka9XQNgMEhAuEWrlJqVLcwS7wWwYSpz/PvsO+eg5NRD6qrIJIFQWhwnQ1I1295oeew8IAKf1qjDdtRM/tehAfNHeJZJsx8RKg8oPydHD8Yv8etdmBGJxoGgKBCN93tla4TY9u0dF9S8IKPcY9xYGBtWWFyhWrRs+tkIbYBIfN3fMl4b80xVBX0bZlEfwu9tQhjXGVrI5GJKw9cCr6tdKMKF5V5upPCiI3SfHAY2LGUwoHnG9FTa6QGMEYnHGBt6i/kVavEQTd62Hje6/0Uku45K2eFCvlk2yMIagNSMoqgMWPpbOBtGk4V2VA9SHs/dAGniDKrwcXtb1u09JaydV+ZNLs/40qCMOZVmO0nme1f/ADNYwsVTPYMQZeiqkXhaLKY7fC3M5XJ1ujNCcLYUdhGRyRNt5v+L2QZ/AMzL1PBg6PKRmbGbcrsRkT+zX1oXgyMsnyBx9GneHu0YblCSu6AJQD+3d7PtnqyN8nC0QxvJLg5YI3/PFtFhaRDTIVlhm1AWYGqAUhs1cc4eCTYg4nSid8XhakrwKQMin1qaxm8+wWniJL3/tUCNkuNJrI3r9UNXZYf2+r1bcZUcCL92IF9F7M/fmMgh+BAPpPyPaU43xPZon4LZ+znk+QU8LahUJt7LJjTQpggqB+b8ptNg5w0wQzHYVeabDWw3HNAtC6uE2XxOVAQVHHCfwY1zxdXGhvNDmsu+HbSv4a2zjIRPhkG3iSxR+wAf7RHA31GrfqA8FS/gPjrZM24OGd0xEIKASdl2DdKCERKvgZ/hxkK0fZStom8Ge90CJcpC1DbYu9g23bqPi90cLpYFw4KyaY9O1dWxdlWeEGy2+QC7CddhJ1C55k2dGXvR2zCwypOrHB67zmlp5InOjt5ZyrrHOcdrq9I6
 gg4CJKqq
 hJL6OWlftpSAifYOtmI7/hbqHHNeeRy8THhE0qKIny/6TujQ9g9dV2A4lSSJQiylZ+9XHdW5d/03+Q244j5nIinfMqyr7uX/980JPR3edhJRHxWO0cHAR1zN+QYgubKWwgh8FMa5toeRUYmi9Awpgi/OBojA4SPGBZ/8NASbuxp+pdQ2Z8aD1Zw9Wvkax40MqTK1vA6PLmnmDGP9pRuvA/+eEQGlCYVJtgRH8esjxet34vPKeYBP2rzQPXg==
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
 mm/slub.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 51 insertions(+), 14 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 4731b9e461c2..ab03f29dc3bf 100644
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
@@ -2645,7 +2648,7 @@ static struct slab_sheaf *alloc_full_sheaf(struct kmem_cache *s, gfp_t gfp)
 	if (!sheaf)
 		return NULL;
 
-	if (refill_sheaf(s, sheaf, gfp)) {
+	if (refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC)) {
 		free_empty_sheaf(s, sheaf);
 		return NULL;
 	}
@@ -2723,12 +2726,13 @@ static void sheaf_flush_unused(struct kmem_cache *s, struct slab_sheaf *sheaf)
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
@@ -2741,8 +2745,13 @@ static void __rcu_free_sheaf_prepare(struct kmem_cache *s,
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
@@ -5031,7 +5040,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 
 	if (empty) {
-		if (!refill_sheaf(s, empty, gfp)) {
+		if (!refill_sheaf(s, empty, gfp | __GFP_NOMEMALLOC)) {
 			full = empty;
 		} else {
 			/*
@@ -5331,6 +5340,26 @@ void *kmem_cache_alloc_node_noprof(struct kmem_cache *s, gfp_t gfpflags, int nod
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
@@ -5401,17 +5430,18 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
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
 
@@ -5431,7 +5461,8 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
 	struct slub_percpu_sheaves *pcs;
 	struct node_barn *barn;
 
-	if (unlikely(sheaf->capacity != s->sheaf_capacity)) {
+	if (unlikely((sheaf->capacity != s->sheaf_capacity)
+		     || sheaf->pfmemalloc)) {
 		sheaf_flush_unused(s, sheaf);
 		kfree(sheaf);
 		return;
@@ -5497,7 +5528,7 @@ int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
 
 	if (likely(sheaf->capacity >= size)) {
 		if (likely(sheaf->capacity == s->sheaf_capacity))
-			return refill_sheaf(s, sheaf, gfp);
+			return __prefill_sheaf_pfmemalloc(s, sheaf, gfp);
 
 		if (!__kmem_cache_alloc_bulk(s, gfp, sheaf->capacity - sheaf->size,
 					     &sheaf->objects[sheaf->size])) {
@@ -6177,8 +6208,12 @@ static void rcu_free_sheaf(struct rcu_head *head)
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
@@ -6333,7 +6368,8 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 			continue;
 		}
 
-		if (unlikely(IS_ENABLED(CONFIG_NUMA) && slab_nid(slab) != node)) {
+		if (unlikely((IS_ENABLED(CONFIG_NUMA) && slab_nid(slab) != node)
+			     || slab_test_pfmemalloc(slab))) {
 			remote_objects[remote_nr] = p[i];
 			p[i] = p[--size];
 			if (++remote_nr >= PCS_BATCH_MAX)
@@ -6631,7 +6667,8 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
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


