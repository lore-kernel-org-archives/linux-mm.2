Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A09B3CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 13:53:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A9AB8E003B; Thu, 23 Oct 2025 09:53:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 081848E0002; Thu, 23 Oct 2025 09:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDA7D8E003B; Thu, 23 Oct 2025 09:53:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC0C38E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:53:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A8621BD2FC
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:53:47 +0000 (UTC)
X-FDA: 84029522094.12.253EAAD
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6FF2E40004
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:53:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=z3rmiI5k;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=o5yPsWQw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="G/Z/edsQ";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=I0DlbivU;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761227625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0cRSA4PJ9lxbCwCll7kH1WYq1YeHWKEspaqv5Y36OJw=;
	b=Cq3nniIlEpJKytnKbXXew+ueXPyWBcrbrEB3l6VuE0l8BXxFFeC3iuI0gBhzH1aSKE1Lq2
	UdpDg6GHR7mCn3DoQB2e2jSn0e8sQiRiSqGMsnoZtdPwZ1RCkBr2cnkn1KAT8FGL5AnKGt
	/U2nsm20ob9ux87GSXsz3FOTPvG9Oxg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=z3rmiI5k;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=o5yPsWQw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="G/Z/edsQ";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=I0DlbivU;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761227625; a=rsa-sha256;
	cv=none;
	b=VGuqRUS3H46lghIc8IEIWD/G9TimV37ZFT8pGUG/4sVHWgM/PXfjjRyNawSbhg3Pa+ecaO
	iyphgXhEWUJzfVL5UY9yFheG6++rW46gLIWu99HGKUHhcqkcSRpbk35a8uzIqb/TzzFQ29
	/r7C8XwDxnGdvUQWH5XUN+vkHd3JaFQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AC4972122F;
	Thu, 23 Oct 2025 13:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761227581; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0cRSA4PJ9lxbCwCll7kH1WYq1YeHWKEspaqv5Y36OJw=;
	b=z3rmiI5k4Y0PLAShEvQIu/GzTplnb+9771WFIyf+G7LYTZqbNA4nQ0/9mMFy85T6DgV0yx
	KrP72uu06LL89TSrnxWsYsleHPtJxLat5Myz69ChXZEvaeXeg+sVvNsQLA/7SbwPgd+MEc
	UG6UXOfuL8NfN0fGPanzMbRXxxKAHCs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761227581;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0cRSA4PJ9lxbCwCll7kH1WYq1YeHWKEspaqv5Y36OJw=;
	b=o5yPsWQwMj3him6/E4HjDTvq+a1NamzqR2YbbZRfM+zvNNNkDXUYZh3iIEvYr7wo13gJjU
	125KIIVGBgBX++DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761227577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0cRSA4PJ9lxbCwCll7kH1WYq1YeHWKEspaqv5Y36OJw=;
	b=G/Z/edsQex+KnnfaD43LwZXT1o4T3veUoiwxdtaEHoiFabuaP5fIsUpI9uOQ0inBcx22Qf
	wdYlm3vDJ+ivqSoOtGDT2QuMCZ55ipF+qR6zzar9AgSgFnm1IfAXNrCbNYV9ULlLNJOa7R
	IhZiaqXxh4d4WSaHm4AkBAPvcKi3j4Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761227577;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0cRSA4PJ9lxbCwCll7kH1WYq1YeHWKEspaqv5Y36OJw=;
	b=I0DlbivUiRq829QRkC9a0zolA9AZl1GevFBzLf14QegxHVtCmkrheut9YNWJW1rAtHfj1p
	2ZIcUtAlrKLDa/DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 923EE13AEF;
	Thu, 23 Oct 2025 13:52:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sKw+IzUz+mjvQQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 23 Oct 2025 13:52:53 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Thu, 23 Oct 2025 15:52:28 +0200
Subject: [PATCH RFC 06/19] slab: introduce percpu sheaves bootstrap
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-sheaves-for-all-v1-6-6ffa2c9941c0@suse.cz>
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
X-Rspamd-Queue-Id: 6FF2E40004
X-Rspamd-Server: rspam03
X-Stat-Signature: mfkt33cwzfokceu69py9zkmjifofbhwp
X-HE-Tag: 1761227625-845037
X-HE-Meta: U2FsdGVkX18WD8xDMvxr8ErYgMMTPn+0ex61qx75WoLTdaxywvfK6odNF6VrrUWBDpfaPQfisAXiaVwY9RA4zvXEmQGSn4n1RKXDqyMaw2AaJ/lzxEMuqMt5hDnjkH/Z/kjvtgq5vaIBIof9CvwjxkbdHpU8naIsc4xcpsahTBr6DjVWV5T3xAfQFWCyb8wfgklgkC6R4Bkkkg6bOfGeDiADrCXZaE+yWotvIpTC6DDFZLlSJ4FyKpvQ0F8E9DGIEqtXT47voC8WE4Rhc9nCVuMjsz/FkNHijKHOirQTxKkeeqf9hiAuWzi0mL1hosbXAR71k6ylVkWcAErFMgWB12ajx1LB+LyiJv8+Wg0dziA8AcYsMmDqLcw0lj+ooIN6XBkqpKUV/XWWFhhyTFDt3XY7HUjDSZ8PgJGG/ziFjbgrDIveqG3Hnt3ncEN9Gr15oTzRjCXGSuTl2r2gDBpNPTIBlX/hJ56D5Rmhaqd+qP+445LLfkhaE2D8H+kMLEjOiJseH/cTaWoVCZAquAqP4Q0fcFqJ0iX4Tb2rCk+Zbc0RsttOsBL7KWebZiQFIwrhoKbbah2WLHZ/hYmWoC6PFQRVk6njUJEvJyotmbfqjyQCvPgpZV3mHhCAyrvT/Y5nTOhkjznZgPo4S18rCJlUZ8Lf7pM9ku0xTCGspVPFn+qv5sQkO/yrlASrjSSqaaK14tT+15rcBHs3K6bAKNATN94AmjI9r6ufhaRB6zAWFO8+8XzHMnsQtsumccW0whdRYGiVllRssqppw1VwDK6LqqrIniEGtGskg5MFxzU29t1bA+AnfutHztriBFlQquC3vXCk/XFqPBXQWTm8BS064A0xCHKz0RnKZJyHeW9RTCCxiuWiUyJcbM9B8sxgEP8vT96wVIvm1I2WsRafB5ZJ0dq+DqC3UCFPZ++TQvuvR6+e10m0XT1iOhsJizc43hkcRUuscVKEMRd3C+xtXkf
 tn1/k5+8
 KLr/LDivlvFsyGMVAOIBAK9qaCe4VWPHxSreb7MGjeVGpyHZBuxlqjdmho8lDiggA4pTyzLwPzI2Jbf4xhf9GjTTSIEglj5qqbhdFWbqVYYJ0T1sgtFXIxVg6xPkzkfXuICGEHlRXShWKtuEKISd1LLeroaDR54Fm8V9s7LgWm9G7+TN5WEf8FlcIf17xJLLayVo9pq5W5VPQ/dEskF80RQuabFjMZ4Z6fbFGHuaV37VHkfQNbf1fB6nNTg==
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
kmem_cache->sheaf_capacity for being 0, where needed.

However, for the fast paths sake we also assume that the main sheaf
always exists (pcs->main is !NULL), and during bootstrap we cannot
allocate sheaves yet.

Solve this by introducing a single static bootstrap_sheaf that's
assigned as pcs->main during bootstrap. It has a size of 0, so during
allocations, the fast path will find it's empty. Since the size of 0
matches sheaf_capacity of 0, the freeing fast paths will find it's
"full". In the slow path handlers, we check sheaf_capacity to recognize
that the cache doesn't (yet) have real sheaves, and fall back. Thus
sharing the single bootstrap sheaf like this for multiple caches and
cpus is safe.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 96 ++++++++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 70 insertions(+), 26 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a6e58d3708f4..ecb10ed5acfe 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2850,6 +2850,10 @@ static void pcs_destroy(struct kmem_cache *s)
 		if (!pcs->main)
 			continue;
 
+		/* bootstrap or debug caches, it's the bootstrap_sheaf */
+		if (!pcs->main->cache)
+			continue;
+
 		/*
 		 * We have already passed __kmem_cache_shutdown() so everything
 		 * was flushed and there should be no objects allocated from
@@ -4054,7 +4058,7 @@ static void flush_cpu_slab(struct work_struct *w)
 
 	s = sfw->s;
 
-	if (s->cpu_sheaves)
+	if (s->sheaf_capacity)
 		pcs_flush_all(s);
 
 	flush_this_cpu_slab(s);
@@ -4176,7 +4180,7 @@ static int slub_cpu_dead(unsigned int cpu)
 	mutex_lock(&slab_mutex);
 	list_for_each_entry(s, &slab_caches, list) {
 		__flush_cpu_slab(s, cpu);
-		if (s->cpu_sheaves)
+		if (s->sheaf_capacity)
 			__pcs_flush_all_cpu(s, cpu);
 	}
 	mutex_unlock(&slab_mutex);
@@ -4979,6 +4983,12 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
+	/* Bootstrap or debug cache, back off */
+	if (unlikely(!s->sheaf_capacity)) {
+		local_unlock(&s->cpu_sheaves->lock);
+		return NULL;
+	}
+
 	if (pcs->spare && pcs->spare->size > 0) {
 		swap(pcs->main, pcs->spare);
 		return pcs;
@@ -5162,6 +5172,11 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 		struct slab_sheaf *full;
 		struct node_barn *barn;
 
+		if (unlikely(!s->sheaf_capacity)) {
+			local_unlock(&s->cpu_sheaves->lock);
+			return allocated;
+		}
+
 		if (pcs->spare && pcs->spare->size > 0) {
 			swap(pcs->main, pcs->spare);
 			goto do_alloc;
@@ -5241,8 +5256,7 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 	if (unlikely(object))
 		goto out;
 
-	if (s->cpu_sheaves)
-		object = alloc_from_pcs(s, gfpflags, node);
+	object = alloc_from_pcs(s, gfpflags, node);
 
 	if (!object)
 		object = __slab_alloc_node(s, gfpflags, node, addr, orig_size);
@@ -6042,6 +6056,12 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
 restart:
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
+	/* Bootstrap or debug cache, back off */
+	if (unlikely(!s->sheaf_capacity)) {
+		local_unlock(&s->cpu_sheaves->lock);
+		return NULL;
+	}
+
 	barn = get_barn(s);
 	if (!barn) {
 		local_unlock(&s->cpu_sheaves->lock);
@@ -6240,6 +6260,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 		struct slab_sheaf *empty;
 		struct node_barn *barn;
 
+		/* Bootstrap or debug cache, fall back */
+		if (!unlikely(s->sheaf_capacity)) {
+			local_unlock(&s->cpu_sheaves->lock);
+			goto fail;
+		}
+
 		if (pcs->spare && pcs->spare->size == 0) {
 			pcs->rcu_free = pcs->spare;
 			pcs->spare = NULL;
@@ -6364,6 +6390,9 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 	if (likely(pcs->main->size < s->sheaf_capacity))
 		goto do_free;
 
+	if (unlikely(!s->sheaf_capacity))
+		goto no_empty;
+
 	barn = get_barn(s);
 	if (!barn)
 		goto no_empty;
@@ -6628,9 +6657,8 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
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
@@ -7437,8 +7465,7 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
 		size--;
 	}
 
-	if (s->cpu_sheaves)
-		i = alloc_from_pcs_bulk(s, size, p);
+	i = alloc_from_pcs_bulk(s, size, p);
 
 	if (i < size) {
 		/*
@@ -7649,6 +7676,7 @@ static inline int alloc_kmem_cache_cpus(struct kmem_cache *s)
 
 static int init_percpu_sheaves(struct kmem_cache *s)
 {
+	static struct slab_sheaf bootstrap_sheaf = {};
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
@@ -7658,7 +7686,28 @@ static int init_percpu_sheaves(struct kmem_cache *s)
 
 		local_trylock_init(&pcs->lock);
 
-		pcs->main = alloc_empty_sheaf(s, GFP_KERNEL);
+		/*
+		 * Bootstrap sheaf has zero size so fast-path allocation fails.
+		 * It has also size == s->sheaf_capacity, so fast-path free
+		 * fails. In the slow paths we recognize the situation by
+		 * checking s->sheaf_capacity. This allows fast paths to assume
+		 * s->pcs_sheaves and pcs->main always exists and is valid.
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
@@ -7733,8 +7782,7 @@ static void free_kmem_cache_nodes(struct kmem_cache *s)
 void __kmem_cache_release(struct kmem_cache *s)
 {
 	cache_random_seq_destroy(s);
-	if (s->cpu_sheaves)
-		pcs_destroy(s);
+	pcs_destroy(s);
 #ifdef CONFIG_PREEMPT_RT
 	if (s->cpu_slab)
 		lockdep_unregister_key(&s->lock_key);
@@ -7756,7 +7804,7 @@ static int init_kmem_cache_nodes(struct kmem_cache *s)
 			continue;
 		}
 
-		if (s->cpu_sheaves) {
+		if (s->sheaf_capacity) {
 			barn = kmalloc_node(sizeof(*barn), GFP_KERNEL, node);
 
 			if (!barn)
@@ -8074,7 +8122,7 @@ int __kmem_cache_shutdown(struct kmem_cache *s)
 	flush_all_cpus_locked(s);
 
 	/* we might have rcu sheaves in flight */
-	if (s->cpu_sheaves)
+	if (s->sheaf_capacity)
 		rcu_barrier();
 
 	/* Attempt to free all objects */
@@ -8375,7 +8423,7 @@ static int slab_mem_going_online_callback(int nid)
 		if (get_node(s, nid))
 			continue;
 
-		if (s->cpu_sheaves) {
+		if (s->sheaf_capacity) {
 			barn = kmalloc_node(sizeof(*barn), GFP_KERNEL, nid);
 
 			if (!barn) {
@@ -8608,12 +8656,10 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
 
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
@@ -8632,11 +8678,9 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
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
2.51.1


