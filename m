Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C5ABD625E5
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:54:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC9FA6B0412; Fri, 23 Jan 2026 01:54:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C87B96B0414; Fri, 23 Jan 2026 01:54:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4F366B0415; Fri, 23 Jan 2026 01:54:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0156B0412
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:54:03 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5B9F113AA19
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:54:03 +0000 (UTC)
X-FDA: 84362313966.15.B20E780
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id 224CAC0007
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:54:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=o5AeQSFY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rRbyLP3Y;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=o5AeQSFY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rRbyLP3Y;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769151241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TLMwhN+Q0BRaAd8zNAL02f9ktCLgn+VwTLulNhwHIcU=;
	b=2aTvZ7yftUhvzedueb7ovIqjqohIY2h3CqAdiL/OAiiiKdS0ix/1NZZp7075aNKfxC1t7B
	2i1NpyAqQzoJh6D6HbBdOBwbZLHMSQWhM+KW1y7Ig1581MMpoXZnp9NYpTPsMAijm+lBOj
	lq4S9MEeNNSU/LHzmYkg3wc9G/+t1lU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769151241; a=rsa-sha256;
	cv=none;
	b=EWTD/1XhCbTmgpWVDycQak2jQWWP9JxhtqAQYbinnHHC3NQljoKNSr2EFssn/KxFCd1nYw
	bJ/lemeaPPPJoRWfikHOr86FYLERn2cXWL+2I7w9MB351fG1qyb6a7CT7TtR49cVVyWzWa
	EvjJg7VLpf2IPEDQstLfXi8lT1czHLI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=o5AeQSFY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rRbyLP3Y;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=o5AeQSFY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rRbyLP3Y;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C49C633770;
	Fri, 23 Jan 2026 06:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769151190; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TLMwhN+Q0BRaAd8zNAL02f9ktCLgn+VwTLulNhwHIcU=;
	b=o5AeQSFYy7bTetUCqdAgmOYk2cgYLtxLUybHxlCoYswJ8dtX1xHV24K6rQZL0COjM4MB2y
	d1XvajYbfBz4cepvKQC1Egjd9F27VQ9djuCQkLh0FWMkgMTk3Qx1o5NpoHfAK0+2+Opj5A
	Z0X+/PY9Ca1iKh8vyGvXxa0sFmeuprQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769151190;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TLMwhN+Q0BRaAd8zNAL02f9ktCLgn+VwTLulNhwHIcU=;
	b=rRbyLP3Ykx1rjCrgSY7GXBJxoqqezpS/tDLyBXcfmmFUkzOjlyuMvXMRfP/k+onziJ6Nxk
	aR4leZLtX/TLxnDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769151190; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TLMwhN+Q0BRaAd8zNAL02f9ktCLgn+VwTLulNhwHIcU=;
	b=o5AeQSFYy7bTetUCqdAgmOYk2cgYLtxLUybHxlCoYswJ8dtX1xHV24K6rQZL0COjM4MB2y
	d1XvajYbfBz4cepvKQC1Egjd9F27VQ9djuCQkLh0FWMkgMTk3Qx1o5NpoHfAK0+2+Opj5A
	Z0X+/PY9Ca1iKh8vyGvXxa0sFmeuprQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769151190;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TLMwhN+Q0BRaAd8zNAL02f9ktCLgn+VwTLulNhwHIcU=;
	b=rRbyLP3Ykx1rjCrgSY7GXBJxoqqezpS/tDLyBXcfmmFUkzOjlyuMvXMRfP/k+onziJ6Nxk
	aR4leZLtX/TLxnDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 457A9139F2;
	Fri, 23 Jan 2026 06:53:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8GasENYac2k4YgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 23 Jan 2026 06:53:10 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 23 Jan 2026 07:52:49 +0100
Subject: [PATCH v4 11/22] slab: remove cpu (partial) slabs usage from
 allocation paths
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-sheaves-for-all-v4-11-041323d506f7@suse.cz>
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
X-Rspamd-Queue-Id: 224CAC0007
X-Stat-Signature: jayopof6m5ybkiux31r5oub65qogfdxb
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769151240-894029
X-HE-Meta: U2FsdGVkX18cko2pFC8NIn7uhB3Eq902Tw0mVss1BEkuVqCmu4QPSI6q78r2iIhERPGwSapr4+7rMNAUj1dCrfKbzumE/FFGhUZPTXwqZGkv8lNAmCJBj6J61vMf80UnreiazKHtOxqReJmfdLn4dufjBYA7bBJjFw0eqzY4/2zyOwCK3kJogaTTL36IgEiR7FSDkWEPoMHPSLE+lAj/tExA2pcl6FTUck9Na79xR6CL8eWAjuJ7unozLHHFZ1BiBGURiupe6MvcZ1+29TxBdKYKr+225OlGjgXAvC6tAtecWgCkQvfg7fOQ/BO+W8tHkE6rsJLWl7H8IBP/N31iJIY/vbe8CqItcMA5Va8aPP56dPH9gd2Y/dF5u1pGAo0xY7S+G6Qr/euGMHyRETfhXj0ps8xsUza4cPSJXNE7ALGUis+qpe2Z5Xl9UEc6n3ctj4V29ISVkcorcScLXY5ASlJsR26XTjP2Brl+6pLg95ZD3oTRvFrD3FcOnn3KF0Znp5v6vqpP2yb8DX3i9soWlxMxR/lVfcfXzaA7FButpDDBm6p3dUl1fhjoCDe+GLraZhlUIoR9a5Fmbb7rsGTsYa+GzId90GGqUl/7eTIHHcJgeT82IWmhlWGa1emFMTlP+AuZAfLWhev7LtrVVM38G/3ZryB3dfXTBeaTacJd6GE/170FUPW1gKk8LNtaMCS/UkMcbLdXz7NRSRuE3d8ZSfsOrFAJQiYEQizpehkhtyR/Yrwv+I48ATesMy4buFItPEeAfzauNinxKg99Qka5s1ogxxQP7eWWlBFylAPPjiVF+iCNJ645Xe32SuNwfaGysSrRmi3I33EFX6CD1kesV+B+CRjl3/Uq2CRscV6bhg+AyUBZqjszzpzrji/GcdiTKMwR3Dfgqem6yokJEhf1JpcosDWUEPYIC1g3qEWj8ZLH+bnItImV2gmExanrR6SsEQSsRVmNxG7jPnUJYrm
 3+jJAdPM
 mH/bboKwQAcXc3dasJv+0ctazfMzns1t/frsN7w5ucSucbNBKSDO+3A/CER+k4ze5N9P7i4gdR2i+Ma6QIHuiruFdpTcYpeQ63PsQSH800yaQxMJbIvTM9PKU2jFONR/KiuLTmpk+wO8qcuYYbHCz9o3ZLQEmrXvqajeiqNtr4Sw2yVs2qM6vgEK1DpfT/fgnOdlAaczh2B1E1lLtOUuC3QwIF1NklPg5KSQuoNkqcHQtWXCFzVSy3ozzRFAnF7YBE6+R/zZIqpiB2xput/CBNeMs0ChWPw/a9AvOoF0LZ24plTsFpv3TgqNjbvB0ZXZlNbBFBe8Zv7GiMB0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We now rely on sheaves as the percpu caching layer and can refill them
directly from partial or newly allocated slabs. Start removing the cpu
(partial) slabs code, first from allocation paths.

This means that any allocation not satisfied from percpu sheaves will
end up in ___slab_alloc(), where we remove the usage of cpu (partial)
slabs, so it will only perform get_partial() or new_slab(). In the
latter case we reuse alloc_from_new_slab() (when we don't use
the debug/tiny alloc_single_from_new_slab() variant).

In get_partial_node() we used to return a slab for freezing as the cpu
slab and to refill the partial slab. Now we only want to return a single
object and leave the slab on the list (unless it became full). We can't
simply reuse alloc_single_from_partial() as that assumes freeing uses
free_to_partial_list(). Instead we need to use __slab_update_freelist()
to work properly against a racing __slab_free().

To reflect the new purpose of get_partial() functions, rename them to
get_from_partial(), get_from_partial_node(), and get_from_any_partial().

The rest of the changes is removing functions that no longer have any
callers.

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Hao Li <hao.li@linux.dev>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 628 +++++++++-----------------------------------------------------
 1 file changed, 87 insertions(+), 541 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 142a1099bbc1..3a78cee811cf 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -241,11 +241,10 @@ DEFINE_STATIC_KEY_FALSE(slub_debug_enabled);
 static DEFINE_STATIC_KEY_FALSE(strict_numa);
 #endif
 
-/* Structure holding parameters for get_partial() call chain */
+/* Structure holding parameters for get_from_partial() call chain */
 struct partial_context {
 	gfp_t flags;
 	unsigned int orig_size;
-	void *object;
 };
 
 /* Structure holding parameters for get_partial_node_bulk() */
@@ -604,36 +603,6 @@ static inline void *get_freepointer(struct kmem_cache *s, void *object)
 	return freelist_ptr_decode(s, p, ptr_addr);
 }
 
-static void prefetch_freepointer(const struct kmem_cache *s, void *object)
-{
-	prefetchw(object + s->offset);
-}
-
-/*
- * When running under KMSAN, get_freepointer_safe() may return an uninitialized
- * pointer value in the case the current thread loses the race for the next
- * memory chunk in the freelist. In that case this_cpu_cmpxchg_double() in
- * slab_alloc_node() will fail, so the uninitialized value won't be used, but
- * KMSAN will still check all arguments of cmpxchg because of imperfect
- * handling of inline assembly.
- * To work around this problem, we apply __no_kmsan_checks to ensure that
- * get_freepointer_safe() returns initialized memory.
- */
-__no_kmsan_checks
-static inline void *get_freepointer_safe(struct kmem_cache *s, void *object)
-{
-	unsigned long freepointer_addr;
-	freeptr_t p;
-
-	if (!debug_pagealloc_enabled_static())
-		return get_freepointer(s, object);
-
-	object = kasan_reset_tag(object);
-	freepointer_addr = (unsigned long)object + s->offset;
-	copy_from_kernel_nofault(&p, (freeptr_t *)freepointer_addr, sizeof(p));
-	return freelist_ptr_decode(s, p, freepointer_addr);
-}
-
 static inline void set_freepointer(struct kmem_cache *s, void *object, void *fp)
 {
 	unsigned long freeptr_addr = (unsigned long)object + s->offset;
@@ -713,23 +682,11 @@ static void slub_set_cpu_partial(struct kmem_cache *s, unsigned int nr_objects)
 	nr_slabs = DIV_ROUND_UP(nr_objects * 2, oo_objects(s->oo));
 	s->cpu_partial_slabs = nr_slabs;
 }
-
-static inline unsigned int slub_get_cpu_partial(struct kmem_cache *s)
-{
-	return s->cpu_partial_slabs;
-}
-#else
-#ifdef SLAB_SUPPORTS_SYSFS
+#elif defined(SLAB_SUPPORTS_SYSFS)
 static inline void
 slub_set_cpu_partial(struct kmem_cache *s, unsigned int nr_objects)
 {
 }
-#endif
-
-static inline unsigned int slub_get_cpu_partial(struct kmem_cache *s)
-{
-	return 0;
-}
 #endif /* CONFIG_SLUB_CPU_PARTIAL */
 
 /*
@@ -1071,7 +1028,7 @@ static void set_track_update(struct kmem_cache *s, void *object,
 	p->handle = handle;
 #endif
 	p->addr = addr;
-	p->cpu = smp_processor_id();
+	p->cpu = raw_smp_processor_id();
 	p->pid = current->pid;
 	p->when = jiffies;
 }
@@ -3579,20 +3536,20 @@ static bool get_partial_node_bulk(struct kmem_cache *s,
 }
 
 /*
- * Try to allocate a partial slab from a specific node.
+ * Try to allocate object from a partial slab on a specific node.
  */
-static struct slab *get_partial_node(struct kmem_cache *s,
-				     struct kmem_cache_node *n,
-				     struct partial_context *pc)
+static void *get_from_partial_node(struct kmem_cache *s,
+				   struct kmem_cache_node *n,
+				   struct partial_context *pc)
 {
-	struct slab *slab, *slab2, *partial = NULL;
+	struct slab *slab, *slab2;
 	unsigned long flags;
-	unsigned int partial_slabs = 0;
+	void *object = NULL;
 
 	/*
 	 * Racy check. If we mistakenly see no partial slabs then we
 	 * just allocate an empty slab. If we mistakenly try to get a
-	 * partial slab and there is none available then get_partial()
+	 * partial slab and there is none available then get_from_partial()
 	 * will return NULL.
 	 */
 	if (!n || !n->nr_partial)
@@ -3603,54 +3560,55 @@ static struct slab *get_partial_node(struct kmem_cache *s,
 	else if (!spin_trylock_irqsave(&n->list_lock, flags))
 		return NULL;
 	list_for_each_entry_safe(slab, slab2, &n->partial, slab_list) {
+
+		struct freelist_counters old, new;
+
 		if (!pfmemalloc_match(slab, pc->flags))
 			continue;
 
 		if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
-			void *object = alloc_single_from_partial(s, n, slab,
+			object = alloc_single_from_partial(s, n, slab,
 							pc->orig_size);
-			if (object) {
-				partial = slab;
-				pc->object = object;
+			if (object)
 				break;
-			}
 			continue;
 		}
 
-		remove_partial(n, slab);
+		/*
+		 * get a single object from the slab. This might race against
+		 * __slab_free(), which however has to take the list_lock if
+		 * it's about to make the slab fully free.
+		 */
+		do {
+			old.freelist = slab->freelist;
+			old.counters = slab->counters;
 
-		if (!partial) {
-			partial = slab;
-			stat(s, ALLOC_FROM_PARTIAL);
+			new.freelist = get_freepointer(s, old.freelist);
+			new.counters = old.counters;
+			new.inuse++;
 
-			if ((slub_get_cpu_partial(s) == 0)) {
-				break;
-			}
-		} else {
-			put_cpu_partial(s, slab, 0);
-			stat(s, CPU_PARTIAL_NODE);
+		} while (!__slab_update_freelist(s, slab, &old, &new, "get_from_partial_node"));
 
-			if (++partial_slabs > slub_get_cpu_partial(s) / 2) {
-				break;
-			}
-		}
+		object = old.freelist;
+		if (!new.freelist)
+			remove_partial(n, slab);
+
+		break;
 	}
 	spin_unlock_irqrestore(&n->list_lock, flags);
-	return partial;
+	return object;
 }
 
 /*
- * Get a slab from somewhere. Search in increasing NUMA distances.
+ * Get an object from somewhere. Search in increasing NUMA distances.
  */
-static struct slab *get_any_partial(struct kmem_cache *s,
-				    struct partial_context *pc)
+static void *get_from_any_partial(struct kmem_cache *s, struct partial_context *pc)
 {
 #ifdef CONFIG_NUMA
 	struct zonelist *zonelist;
 	struct zoneref *z;
 	struct zone *zone;
 	enum zone_type highest_zoneidx = gfp_zone(pc->flags);
-	struct slab *slab;
 	unsigned int cpuset_mems_cookie;
 
 	/*
@@ -3685,8 +3643,10 @@ static struct slab *get_any_partial(struct kmem_cache *s,
 
 			if (n && cpuset_zone_allowed(zone, pc->flags) &&
 					n->nr_partial > s->min_partial) {
-				slab = get_partial_node(s, n, pc);
-				if (slab) {
+
+				void *object = get_from_partial_node(s, n, pc);
+
+				if (object) {
 					/*
 					 * Don't check read_mems_allowed_retry()
 					 * here - if mems_allowed was updated in
@@ -3694,7 +3654,7 @@ static struct slab *get_any_partial(struct kmem_cache *s,
 					 * between allocation and the cpuset
 					 * update
 					 */
-					return slab;
+					return object;
 				}
 			}
 		}
@@ -3704,22 +3664,22 @@ static struct slab *get_any_partial(struct kmem_cache *s,
 }
 
 /*
- * Get a partial slab, lock it and return it.
+ * Get an object from a partial slab
  */
-static struct slab *get_partial(struct kmem_cache *s, int node,
-				struct partial_context *pc)
+static void *get_from_partial(struct kmem_cache *s, int node,
+			      struct partial_context *pc)
 {
-	struct slab *slab;
 	int searchnode = node;
+	void *object;
 
 	if (node == NUMA_NO_NODE)
 		searchnode = numa_mem_id();
 
-	slab = get_partial_node(s, get_node(s, searchnode), pc);
-	if (slab || (node != NUMA_NO_NODE && (pc->flags & __GFP_THISNODE)))
-		return slab;
+	object = get_from_partial_node(s, get_node(s, searchnode), pc);
+	if (object || (node != NUMA_NO_NODE && (pc->flags & __GFP_THISNODE)))
+		return object;
 
-	return get_any_partial(s, pc);
+	return get_from_any_partial(s, pc);
 }
 
 #ifdef CONFIG_PREEMPTION
@@ -4277,19 +4237,6 @@ static int slub_cpu_dead(unsigned int cpu)
 	return 0;
 }
 
-/*
- * Check if the objects in a per cpu structure fit numa
- * locality expectations.
- */
-static inline int node_match(struct slab *slab, int node)
-{
-#ifdef CONFIG_NUMA
-	if (node != NUMA_NO_NODE && slab_nid(slab) != node)
-		return 0;
-#endif
-	return 1;
-}
-
 #ifdef CONFIG_SLUB_DEBUG
 static int count_free(struct slab *slab)
 {
@@ -4474,36 +4421,6 @@ __update_cpu_freelist_fast(struct kmem_cache *s,
 					     &old.freelist_tid, new.freelist_tid);
 }
 
-/*
- * Check the slab->freelist and either transfer the freelist to the
- * per cpu freelist or deactivate the slab.
- *
- * The slab is still frozen if the return value is not NULL.
- *
- * If this function returns NULL then the slab has been unfrozen.
- */
-static inline void *get_freelist(struct kmem_cache *s, struct slab *slab)
-{
-	struct freelist_counters old, new;
-
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_slab->lock));
-
-	do {
-		old.freelist = slab->freelist;
-		old.counters = slab->counters;
-
-		new.freelist = NULL;
-		new.counters = old.counters;
-
-		new.inuse = old.objects;
-		new.frozen = old.freelist != NULL;
-
-
-	} while (!__slab_update_freelist(s, slab, &old, &new, "get_freelist"));
-
-	return old.freelist;
-}
-
 /*
  * Get the slab's freelist and do not freeze it.
  *
@@ -4531,29 +4448,6 @@ static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *sla
 	return old.freelist;
 }
 
-/*
- * Freeze the partial slab and return the pointer to the freelist.
- */
-static inline void *freeze_slab(struct kmem_cache *s, struct slab *slab)
-{
-	struct freelist_counters old, new;
-
-	do {
-		old.freelist = slab->freelist;
-		old.counters = slab->counters;
-
-		new.freelist = NULL;
-		new.counters = old.counters;
-		VM_BUG_ON(new.frozen);
-
-		new.inuse = old.objects;
-		new.frozen = 1;
-
-	} while (!slab_update_freelist(s, slab, &old, &new, "freeze_slab"));
-
-	return old.freelist;
-}
-
 /*
  * If the object has been wiped upon free, make sure it's fully initialized by
  * zeroing out freelist pointer.
@@ -4621,170 +4515,23 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
 }
 
 /*
- * Slow path. The lockless freelist is empty or we need to perform
- * debugging duties.
- *
- * Processing is still very fast if new objects have been freed to the
- * regular freelist. In that case we simply take over the regular freelist
- * as the lockless freelist and zap the regular freelist.
- *
- * If that is not working then we fall back to the partial lists. We take the
- * first element of the freelist as the object to allocate now and move the
- * rest of the freelist to the lockless freelist.
+ * Slow path. We failed to allocate via percpu sheaves or they are not available
+ * due to bootstrap or debugging enabled or SLUB_TINY.
  *
- * And if we were unable to get a new slab from the partial slab lists then
- * we need to allocate a new slab. This is the slowest path since it involves
- * a call to the page allocator and the setup of a new slab.
- *
- * Version of __slab_alloc to use when we know that preemption is
- * already disabled (which is the case for bulk allocation).
+ * We try to allocate from partial slab lists and fall back to allocating a new
+ * slab.
  */
 static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
-			  unsigned long addr, struct kmem_cache_cpu *c, unsigned int orig_size)
+			   unsigned long addr, unsigned int orig_size)
 {
 	bool allow_spin = gfpflags_allow_spinning(gfpflags);
-	void *freelist;
+	void *object;
 	struct slab *slab;
-	unsigned long flags;
 	struct partial_context pc;
 	bool try_thisnode = true;
 
 	stat(s, ALLOC_SLOWPATH);
 
-reread_slab:
-
-	slab = READ_ONCE(c->slab);
-	if (!slab) {
-		/*
-		 * if the node is not online or has no normal memory, just
-		 * ignore the node constraint
-		 */
-		if (unlikely(node != NUMA_NO_NODE &&
-			     !node_isset(node, slab_nodes)))
-			node = NUMA_NO_NODE;
-		goto new_slab;
-	}
-
-	if (unlikely(!node_match(slab, node))) {
-		/*
-		 * same as above but node_match() being false already
-		 * implies node != NUMA_NO_NODE.
-		 *
-		 * We don't strictly honor pfmemalloc and NUMA preferences
-		 * when !allow_spin because:
-		 *
-		 * 1. Most kmalloc() users allocate objects on the local node,
-		 *    so kmalloc_nolock() tries not to interfere with them by
-		 *    deactivating the cpu slab.
-		 *
-		 * 2. Deactivating due to NUMA or pfmemalloc mismatch may cause
-		 *    unnecessary slab allocations even when n->partial list
-		 *    is not empty.
-		 */
-		if (!node_isset(node, slab_nodes) ||
-		    !allow_spin) {
-			node = NUMA_NO_NODE;
-		} else {
-			stat(s, ALLOC_NODE_MISMATCH);
-			goto deactivate_slab;
-		}
-	}
-
-	/*
-	 * By rights, we should be searching for a slab page that was
-	 * PFMEMALLOC but right now, we are losing the pfmemalloc
-	 * information when the page leaves the per-cpu allocator
-	 */
-	if (unlikely(!pfmemalloc_match(slab, gfpflags) && allow_spin))
-		goto deactivate_slab;
-
-	/* must check again c->slab in case we got preempted and it changed */
-	local_lock_cpu_slab(s, flags);
-
-	if (unlikely(slab != c->slab)) {
-		local_unlock_cpu_slab(s, flags);
-		goto reread_slab;
-	}
-	freelist = c->freelist;
-	if (freelist)
-		goto load_freelist;
-
-	freelist = get_freelist(s, slab);
-
-	if (!freelist) {
-		c->slab = NULL;
-		c->tid = next_tid(c->tid);
-		local_unlock_cpu_slab(s, flags);
-		stat(s, DEACTIVATE_BYPASS);
-		goto new_slab;
-	}
-
-	stat(s, ALLOC_REFILL);
-
-load_freelist:
-
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_slab->lock));
-
-	/*
-	 * freelist is pointing to the list of objects to be used.
-	 * slab is pointing to the slab from which the objects are obtained.
-	 * That slab must be frozen for per cpu allocations to work.
-	 */
-	VM_BUG_ON(!c->slab->frozen);
-	c->freelist = get_freepointer(s, freelist);
-	c->tid = next_tid(c->tid);
-	local_unlock_cpu_slab(s, flags);
-	return freelist;
-
-deactivate_slab:
-
-	local_lock_cpu_slab(s, flags);
-	if (slab != c->slab) {
-		local_unlock_cpu_slab(s, flags);
-		goto reread_slab;
-	}
-	freelist = c->freelist;
-	c->slab = NULL;
-	c->freelist = NULL;
-	c->tid = next_tid(c->tid);
-	local_unlock_cpu_slab(s, flags);
-	deactivate_slab(s, slab, freelist);
-
-new_slab:
-
-#ifdef CONFIG_SLUB_CPU_PARTIAL
-	while (slub_percpu_partial(c)) {
-		local_lock_cpu_slab(s, flags);
-		if (unlikely(c->slab)) {
-			local_unlock_cpu_slab(s, flags);
-			goto reread_slab;
-		}
-		if (unlikely(!slub_percpu_partial(c))) {
-			local_unlock_cpu_slab(s, flags);
-			/* we were preempted and partial list got empty */
-			goto new_objects;
-		}
-
-		slab = slub_percpu_partial(c);
-		slub_set_percpu_partial(c, slab);
-
-		if (likely(node_match(slab, node) &&
-			   pfmemalloc_match(slab, gfpflags)) ||
-		    !allow_spin) {
-			c->slab = slab;
-			freelist = get_freelist(s, slab);
-			VM_BUG_ON(!freelist);
-			stat(s, CPU_PARTIAL_ALLOC);
-			goto load_freelist;
-		}
-
-		local_unlock_cpu_slab(s, flags);
-
-		slab->next = NULL;
-		__put_partials(s, slab);
-	}
-#endif
-
 new_objects:
 
 	pc.flags = gfpflags;
@@ -4792,12 +4539,12 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	 * When a preferred node is indicated but no __GFP_THISNODE
 	 *
 	 * 1) try to get a partial slab from target node only by having
-	 *    __GFP_THISNODE in pc.flags for get_partial()
+	 *    __GFP_THISNODE in pc.flags for get_from_partial()
 	 * 2) if 1) failed, try to allocate a new slab from target node with
 	 *    GPF_NOWAIT | __GFP_THISNODE opportunistically
 	 * 3) if 2) failed, retry with original gfpflags which will allow
-	 *    get_partial() try partial lists of other nodes before potentially
-	 *    allocating new page from other nodes
+	 *    get_from_partial() try partial lists of other nodes before
+	 *    potentially allocating new page from other nodes
 	 */
 	if (unlikely(node != NUMA_NO_NODE && !(gfpflags & __GFP_THISNODE)
 		     && try_thisnode)) {
@@ -4809,33 +4556,11 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	}
 
 	pc.orig_size = orig_size;
-	slab = get_partial(s, node, &pc);
-	if (slab) {
-		if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
-			freelist = pc.object;
-			/*
-			 * For debug caches here we had to go through
-			 * alloc_single_from_partial() so just store the
-			 * tracking info and return the object.
-			 *
-			 * Due to disabled preemption we need to disallow
-			 * blocking. The flags are further adjusted by
-			 * gfp_nested_mask() in stack_depot itself.
-			 */
-			if (s->flags & SLAB_STORE_USER)
-				set_track(s, freelist, TRACK_ALLOC, addr,
-					  gfpflags & ~(__GFP_DIRECT_RECLAIM));
-
-			return freelist;
-		}
-
-		freelist = freeze_slab(s, slab);
-		goto retry_load_slab;
-	}
+	object = get_from_partial(s, node, &pc);
+	if (object)
+		goto success;
 
-	slub_put_cpu_ptr(s->cpu_slab);
 	slab = new_slab(s, pc.flags, node);
-	c = slub_get_cpu_ptr(s->cpu_slab);
 
 	if (unlikely(!slab)) {
 		if (node != NUMA_NO_NODE && !(gfpflags & __GFP_THISNODE)
@@ -4850,70 +4575,31 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	stat(s, ALLOC_SLAB);
 
 	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
-		freelist = alloc_single_from_new_slab(s, slab, orig_size, gfpflags);
-
-		if (unlikely(!freelist)) {
-			/* This could cause an endless loop. Fail instead. */
-			if (!allow_spin)
-				return NULL;
-			goto new_objects;
-		}
-
-		if (s->flags & SLAB_STORE_USER)
-			set_track(s, freelist, TRACK_ALLOC, addr,
-				  gfpflags & ~(__GFP_DIRECT_RECLAIM));
-
-		return freelist;
-	}
-
-	/*
-	 * No other reference to the slab yet so we can
-	 * muck around with it freely without cmpxchg
-	 */
-	freelist = slab->freelist;
-	slab->freelist = NULL;
-	slab->inuse = slab->objects;
-	slab->frozen = 1;
+		object = alloc_single_from_new_slab(s, slab, orig_size, gfpflags);
 
-	inc_slabs_node(s, slab_nid(slab), slab->objects);
+		if (likely(object))
+			goto success;
+	} else {
+		alloc_from_new_slab(s, slab, &object, 1, allow_spin);
 
-	if (unlikely(!pfmemalloc_match(slab, gfpflags) && allow_spin)) {
-		/*
-		 * For !pfmemalloc_match() case we don't load freelist so that
-		 * we don't make further mismatched allocations easier.
-		 */
-		deactivate_slab(s, slab, get_freepointer(s, freelist));
-		return freelist;
+		/* we don't need to check SLAB_STORE_USER here */
+		if (likely(object))
+			return object;
 	}
 
-retry_load_slab:
-
-	local_lock_cpu_slab(s, flags);
-	if (unlikely(c->slab)) {
-		void *flush_freelist = c->freelist;
-		struct slab *flush_slab = c->slab;
-
-		c->slab = NULL;
-		c->freelist = NULL;
-		c->tid = next_tid(c->tid);
-
-		local_unlock_cpu_slab(s, flags);
-
-		if (unlikely(!allow_spin)) {
-			/* Reentrant slub cannot take locks, defer */
-			defer_deactivate_slab(flush_slab, flush_freelist);
-		} else {
-			deactivate_slab(s, flush_slab, flush_freelist);
-		}
+	if (allow_spin)
+		goto new_objects;
 
-		stat(s, CPUSLAB_FLUSH);
+	/* This could cause an endless loop. Fail instead. */
+	return NULL;
 
-		goto retry_load_slab;
-	}
-	c->slab = slab;
+success:
+	if (kmem_cache_debug_flags(s, SLAB_STORE_USER))
+		set_track(s, object, TRACK_ALLOC, addr, gfpflags);
 
-	goto load_freelist;
+	return object;
 }
+
 /*
  * We disallow kprobes in ___slab_alloc() to prevent reentrance
  *
@@ -4928,87 +4614,11 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
  */
 NOKPROBE_SYMBOL(___slab_alloc);
 
-/*
- * A wrapper for ___slab_alloc() for contexts where preemption is not yet
- * disabled. Compensates for possible cpu changes by refetching the per cpu area
- * pointer.
- */
-static void *__slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
-			  unsigned long addr, struct kmem_cache_cpu *c, unsigned int orig_size)
-{
-	void *p;
-
-#ifdef CONFIG_PREEMPT_COUNT
-	/*
-	 * We may have been preempted and rescheduled on a different
-	 * cpu before disabling preemption. Need to reload cpu area
-	 * pointer.
-	 */
-	c = slub_get_cpu_ptr(s->cpu_slab);
-#endif
-	if (unlikely(!gfpflags_allow_spinning(gfpflags))) {
-		if (local_lock_is_locked(&s->cpu_slab->lock)) {
-			/*
-			 * EBUSY is an internal signal to kmalloc_nolock() to
-			 * retry a different bucket. It's not propagated
-			 * to the caller.
-			 */
-			p = ERR_PTR(-EBUSY);
-			goto out;
-		}
-	}
-	p = ___slab_alloc(s, gfpflags, node, addr, c, orig_size);
-out:
-#ifdef CONFIG_PREEMPT_COUNT
-	slub_put_cpu_ptr(s->cpu_slab);
-#endif
-	return p;
-}
-
 static __always_inline void *__slab_alloc_node(struct kmem_cache *s,
 		gfp_t gfpflags, int node, unsigned long addr, size_t orig_size)
 {
-	struct kmem_cache_cpu *c;
-	struct slab *slab;
-	unsigned long tid;
 	void *object;
 
-redo:
-	/*
-	 * Must read kmem_cache cpu data via this cpu ptr. Preemption is
-	 * enabled. We may switch back and forth between cpus while
-	 * reading from one cpu area. That does not matter as long
-	 * as we end up on the original cpu again when doing the cmpxchg.
-	 *
-	 * We must guarantee that tid and kmem_cache_cpu are retrieved on the
-	 * same cpu. We read first the kmem_cache_cpu pointer and use it to read
-	 * the tid. If we are preempted and switched to another cpu between the
-	 * two reads, it's OK as the two are still associated with the same cpu
-	 * and cmpxchg later will validate the cpu.
-	 */
-	c = raw_cpu_ptr(s->cpu_slab);
-	tid = READ_ONCE(c->tid);
-
-	/*
-	 * Irqless object alloc/free algorithm used here depends on sequence
-	 * of fetching cpu_slab's data. tid should be fetched before anything
-	 * on c to guarantee that object and slab associated with previous tid
-	 * won't be used with current tid. If we fetch tid first, object and
-	 * slab could be one associated with next tid and our alloc/free
-	 * request will be failed. In this case, we will retry. So, no problem.
-	 */
-	barrier();
-
-	/*
-	 * The transaction ids are globally unique per cpu and per operation on
-	 * a per cpu queue. Thus they can be guarantee that the cmpxchg_double
-	 * occurs on the right processor and that there was no operation on the
-	 * linked list in between.
-	 */
-
-	object = c->freelist;
-	slab = c->slab;
-
 #ifdef CONFIG_NUMA
 	if (static_branch_unlikely(&strict_numa) &&
 			node == NUMA_NO_NODE) {
@@ -5017,47 +4627,20 @@ static __always_inline void *__slab_alloc_node(struct kmem_cache *s,
 
 		if (mpol) {
 			/*
-			 * Special BIND rule support. If existing slab
+			 * Special BIND rule support. If the local node
 			 * is in permitted set then do not redirect
 			 * to a particular node.
 			 * Otherwise we apply the memory policy to get
 			 * the node we need to allocate on.
 			 */
-			if (mpol->mode != MPOL_BIND || !slab ||
-					!node_isset(slab_nid(slab), mpol->nodes))
-
+			if (mpol->mode != MPOL_BIND ||
+					!node_isset(numa_mem_id(), mpol->nodes))
 				node = mempolicy_slab_node();
 		}
 	}
 #endif
 
-	if (!USE_LOCKLESS_FAST_PATH() ||
-	    unlikely(!object || !slab || !node_match(slab, node))) {
-		object = __slab_alloc(s, gfpflags, node, addr, c, orig_size);
-	} else {
-		void *next_object = get_freepointer_safe(s, object);
-
-		/*
-		 * The cmpxchg will only match if there was no additional
-		 * operation and if we are on the right processor.
-		 *
-		 * The cmpxchg does the following atomically (without lock
-		 * semantics!)
-		 * 1. Relocate first pointer to the current per cpu area.
-		 * 2. Verify that tid and freelist have not been changed
-		 * 3. If they were not changed replace tid and freelist
-		 *
-		 * Since this is without lock semantics the protection is only
-		 * against code executing on this cpu *not* from access by
-		 * other cpus.
-		 */
-		if (unlikely(!__update_cpu_freelist_fast(s, object, next_object, tid))) {
-			note_cmpxchg_failure("slab_alloc", s, tid);
-			goto redo;
-		}
-		prefetch_freepointer(s, next_object);
-		stat(s, ALLOC_FASTPATH);
-	}
+	object = ___slab_alloc(s, gfpflags, node, addr, orig_size);
 
 	return object;
 }
@@ -7739,62 +7322,25 @@ static inline
 int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
 			    void **p)
 {
-	struct kmem_cache_cpu *c;
-	unsigned long irqflags;
 	int i;
 
 	/*
-	 * Drain objects in the per cpu slab, while disabling local
-	 * IRQs, which protects against PREEMPT and interrupts
-	 * handlers invoking normal fastpath.
+	 * TODO: this might be more efficient (if necessary) by reusing
+	 * __refill_objects()
 	 */
-	c = slub_get_cpu_ptr(s->cpu_slab);
-	local_lock_irqsave(&s->cpu_slab->lock, irqflags);
-
 	for (i = 0; i < size; i++) {
-		void *object = c->freelist;
-
-		if (unlikely(!object)) {
-			/*
-			 * We may have removed an object from c->freelist using
-			 * the fastpath in the previous iteration; in that case,
-			 * c->tid has not been bumped yet.
-			 * Since ___slab_alloc() may reenable interrupts while
-			 * allocating memory, we should bump c->tid now.
-			 */
-			c->tid = next_tid(c->tid);
-
-			local_unlock_irqrestore(&s->cpu_slab->lock, irqflags);
-
-			/*
-			 * Invoking slow path likely have side-effect
-			 * of re-populating per CPU c->freelist
-			 */
-			p[i] = ___slab_alloc(s, flags, NUMA_NO_NODE,
-					    _RET_IP_, c, s->object_size);
-			if (unlikely(!p[i]))
-				goto error;
-
-			c = this_cpu_ptr(s->cpu_slab);
-			maybe_wipe_obj_freeptr(s, p[i]);
 
-			local_lock_irqsave(&s->cpu_slab->lock, irqflags);
+		p[i] = ___slab_alloc(s, flags, NUMA_NO_NODE, _RET_IP_,
+				     s->object_size);
+		if (unlikely(!p[i]))
+			goto error;
 
-			continue; /* goto for-loop */
-		}
-		c->freelist = get_freepointer(s, object);
-		p[i] = object;
 		maybe_wipe_obj_freeptr(s, p[i]);
-		stat(s, ALLOC_FASTPATH);
 	}
-	c->tid = next_tid(c->tid);
-	local_unlock_irqrestore(&s->cpu_slab->lock, irqflags);
-	slub_put_cpu_ptr(s->cpu_slab);
 
 	return i;
 
 error:
-	slub_put_cpu_ptr(s->cpu_slab);
 	__kmem_cache_free_bulk(s, i, p);
 	return 0;
 

-- 
2.52.0


