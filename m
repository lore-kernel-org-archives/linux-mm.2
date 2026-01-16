Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 372D1C982C4
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 14:41:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCF196B00AD; Fri, 16 Jan 2026 09:41:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C11EA6B00AE; Fri, 16 Jan 2026 09:41:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEF256B00AF; Fri, 16 Jan 2026 09:41:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9C1E26B00AD
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:41:22 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 69D781A0178
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:41:22 +0000 (UTC)
X-FDA: 84338090004.14.085AD46
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2AAFF180006
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:41:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JbNQlxsV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iH7aI8ZG;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JbNQlxsV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iH7aI8ZG;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768574480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x//ubRuVrxiZHDkZo7cacxsgeijKPvlM+1IHTFUCb9Y=;
	b=tQhSvM5VYaxtW4A1QcG8g/6v7Q9gg/uM0QuE3k//HWMZAunKEQJMHtB5CKp4cx0Z0oghDX
	wCpMhgVgwoVfAzdRK3WT0E3RLtCjA0rdIPwG/MwWkztasITHUjSE+yQPy5tCf1rJq1QSYy
	yLD67wIBHnYWBZ0gIRE/AUKCDg5sHRE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JbNQlxsV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iH7aI8ZG;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JbNQlxsV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iH7aI8ZG;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768574480; a=rsa-sha256;
	cv=none;
	b=rnpAXRNgEvrhmIEOfFYoMWbq1HPbg1hgtxcxHDDW6HOC5qlPN2jGNQRPXMpbPQq6yOzwfs
	Q13+VWkOEWyCm+E7aU/8ELC8iqVjE9AkYiXnRAKbPvJXQgn6vb+Rw6/zpGUuynPmgUeYEN
	CUuuZGvtlw5KqS+E1vO3sec7ssMQzKs=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1AB9D3373A;
	Fri, 16 Jan 2026 14:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574438; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x//ubRuVrxiZHDkZo7cacxsgeijKPvlM+1IHTFUCb9Y=;
	b=JbNQlxsVhA2n1R6NuVy1eBjv+9EQlLdJSJkHNdOQJp0cRTrbuWlcbBXeMGWSUT1j41h/dJ
	CQtse5FbF1trF1wBUhVCMKA/RQki884cc3wJbIGBVOIfSSuFkRKNbQbntGHmk0ZRCoya/r
	YO/h95Ut+g2hX+SaxOVYTiTdPNXJ5Go=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574438;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x//ubRuVrxiZHDkZo7cacxsgeijKPvlM+1IHTFUCb9Y=;
	b=iH7aI8ZGtC2Q4Bii2XHEOxukYi0tA8acNEhUzxicmloLiGDlUQpTidDvt12UB4u02O60NC
	gFSW7benzyLTmUCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574438; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x//ubRuVrxiZHDkZo7cacxsgeijKPvlM+1IHTFUCb9Y=;
	b=JbNQlxsVhA2n1R6NuVy1eBjv+9EQlLdJSJkHNdOQJp0cRTrbuWlcbBXeMGWSUT1j41h/dJ
	CQtse5FbF1trF1wBUhVCMKA/RQki884cc3wJbIGBVOIfSSuFkRKNbQbntGHmk0ZRCoya/r
	YO/h95Ut+g2hX+SaxOVYTiTdPNXJ5Go=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574438;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x//ubRuVrxiZHDkZo7cacxsgeijKPvlM+1IHTFUCb9Y=;
	b=iH7aI8ZGtC2Q4Bii2XHEOxukYi0tA8acNEhUzxicmloLiGDlUQpTidDvt12UB4u02O60NC
	gFSW7benzyLTmUCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EFFE43EA63;
	Fri, 16 Jan 2026 14:40:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cEpROuVNamnydgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 16 Jan 2026 14:40:37 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 16 Jan 2026 15:40:33 +0100
Subject: [PATCH v3 13/21] slab: remove defer_deactivate_slab()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260116-sheaves-for-all-v3-13-5595cb000772@suse.cz>
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
X-Rspamd-Queue-Id: 2AAFF180006
X-Stat-Signature: jya7f394idr8gq51d9559dqfaoy18u5g
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768574479-625167
X-HE-Meta: U2FsdGVkX18yvLMTPll3EVcZZ6Eb2EcukUayZLlKpqq3YNLJiPiYfRQRKDfmZeaxim3666+Kb1acugD7zKb0CTtCDHTrPq6xs/oEuZSd977rnk21r0JJHtVXmzDlRYOdc3s9+UaQZzqfTA+NmXt6p9G5IsM793hFzYgbtjHEwotNV+kpEj2/80yGxyXT3J5DdQeYgGmvxOvLynQFSoNr0fe9MQyIKuqAxGh8RD+Fya/w0gJsZQXpCSN//HxcYRN8fTNB4XWIRVV9YcGV7D06UmRhpYKZllyZmgGV4uEH+kDXuo2nR/OYgyONilUoWCeJC2nQ1SYRp6/RnrpZz0jFwwyPheAFQXlLSvPeIkvgd8OAzsZksxUIrBCNgbhRjL3tGpcW3R7LNmOEUF8nfapIMin1zqRFrugCq8TcQJBxmv9kXuDZS88k4JIH5QjR/HyW888E4K/0a0OVLdrMe1DFvCZ9bAjDFok4lI39zZNAeskbRW3ptaP9qvth+QmEla2OvW82VWVaDBClX7Un32sh1l5OyIqQlnaNXncx9BjyRH91F4b7Cj1Sz8s5F6s5l93DSPyiaYVR6lTThM60QaOHNdh84CfEel7veJuEd6jInWIiWctA6yA3q4pFXQrhXzzNfptWvAmWWXergtFvPZeylVPH8s/1+T2ExW7pPJQx+gYU4kLd143aw/+9AAm7bWQaJlOnjid+Rb0HCf/IXRZLFew82/4BxlvXQBO7OA9tia2RhCJp10qzvM1UK9RavZY67zFcbQgLrj7inO6dQ3Xd9nSa80fhZKijYJGer/fx2eLdBmbt7tUAfMN4ALtXN0HFEoEN2hYhLkvuaQn2FlZbmID7sGY6VvkQMWd2w7jB2aMy+21t/+CyAy3c7gomAt231/8EHX81WTLQHiT5LYruM3Smt8hVTDwha7rBtFJs4moWrPefJxfVeg684ybxzkKFV8Yf9nCZB4vYhSUbs7M
 deHtTBMq
 fX39aKvsys15vZvCIsD+pbU+IYXc2k4YOBj8Hbq4e42Cr/FqY7xv/950H9946F5WLzW8M/vb8GEoeeXQpxgSpAPwQlkjwgXWsrFcD8aa/Of0nFLHiGlQ3lQRaC4cFvubNavJgFotjH1E3Pws1FKixul1W0vQFOOV27Ok24R56UD2O+1jmGdGNNdpD6HOfokSGiEp8ZPUvr18Ucttwx79Zkhn6zg+ds8hd6k4ImKru/XorHdaZHmh6bqD7rjDJyag0h8Na
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are no more cpu slabs so we don't need their deferred
deactivation. The function is now only used from places where we
allocate a new slab but then can't spin on node list_lock to put it on
the partial list. Instead of the deferred action we can free it directly
via __free_slab(), we just need to tell it to use _nolock() freeing of
the underlying pages and take care of the accounting.

Since free_frozen_pages_nolock() variant does not yet exist for code
outside of the page allocator, create it as a trivial wrapper for
__free_frozen_pages(..., FPI_TRYLOCK).

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/internal.h   |  1 +
 mm/page_alloc.c |  5 +++++
 mm/slab.h       |  8 +-------
 mm/slub.c       | 56 ++++++++++++++++++++------------------------------------
 4 files changed, 27 insertions(+), 43 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index e430da900430..1f44ccb4badf 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -846,6 +846,7 @@ static inline struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned int ord
 struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned int order);
 #define alloc_frozen_pages_nolock(...) \
 	alloc_hooks(alloc_frozen_pages_nolock_noprof(__VA_ARGS__))
+void free_frozen_pages_nolock(struct page *page, unsigned int order);
 
 extern void zone_pcp_reset(struct zone *zone);
 extern void zone_pcp_disable(struct zone *zone);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c380f063e8b7..0127e9d661ad 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2981,6 +2981,11 @@ void free_frozen_pages(struct page *page, unsigned int order)
 	__free_frozen_pages(page, order, FPI_NONE);
 }
 
+void free_frozen_pages_nolock(struct page *page, unsigned int order)
+{
+	__free_frozen_pages(page, order, FPI_TRYLOCK);
+}
+
 /*
  * Free a batch of folios
  */
diff --git a/mm/slab.h b/mm/slab.h
index e77260720994..4efec41b6445 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -71,13 +71,7 @@ struct slab {
 	struct kmem_cache *slab_cache;
 	union {
 		struct {
-			union {
-				struct list_head slab_list;
-				struct { /* For deferred deactivate_slab() */
-					struct llist_node llnode;
-					void *flush_freelist;
-				};
-			};
+			struct list_head slab_list;
 			/* Double-word boundary */
 			struct freelist_counters;
 		};
diff --git a/mm/slub.c b/mm/slub.c
index b08e775dc4cb..33f218c0e8d6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3260,7 +3260,7 @@ static struct slab *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);
 }
 
-static void __free_slab(struct kmem_cache *s, struct slab *slab)
+static void __free_slab(struct kmem_cache *s, struct slab *slab, bool allow_spin)
 {
 	struct page *page = slab_page(slab);
 	int order = compound_order(page);
@@ -3271,14 +3271,26 @@ static void __free_slab(struct kmem_cache *s, struct slab *slab)
 	__ClearPageSlab(page);
 	mm_account_reclaimed_pages(pages);
 	unaccount_slab(slab, order, s);
-	free_frozen_pages(page, order);
+	if (allow_spin)
+		free_frozen_pages(page, order);
+	else
+		free_frozen_pages_nolock(page, order);
+}
+
+static void free_new_slab_nolock(struct kmem_cache *s, struct slab *slab)
+{
+	/*
+	 * Since it was just allocated, we can skip the actions in
+	 * discard_slab() and free_slab().
+	 */
+	__free_slab(s, slab, false);
 }
 
 static void rcu_free_slab(struct rcu_head *h)
 {
 	struct slab *slab = container_of(h, struct slab, rcu_head);
 
-	__free_slab(slab->slab_cache, slab);
+	__free_slab(slab->slab_cache, slab, true);
 }
 
 static void free_slab(struct kmem_cache *s, struct slab *slab)
@@ -3294,7 +3306,7 @@ static void free_slab(struct kmem_cache *s, struct slab *slab)
 	if (unlikely(s->flags & SLAB_TYPESAFE_BY_RCU))
 		call_rcu(&slab->rcu_head, rcu_free_slab);
 	else
-		__free_slab(s, slab);
+		__free_slab(s, slab, true);
 }
 
 static void discard_slab(struct kmem_cache *s, struct slab *slab)
@@ -3387,8 +3399,6 @@ static void *alloc_single_from_partial(struct kmem_cache *s,
 	return object;
 }
 
-static void defer_deactivate_slab(struct slab *slab, void *flush_freelist);
-
 /*
  * Called only for kmem_cache_debug() caches to allocate from a freshly
  * allocated slab. Allocate a single object instead of whole freelist
@@ -3404,8 +3414,8 @@ static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
 	void *object;
 
 	if (!allow_spin && !spin_trylock_irqsave(&n->list_lock, flags)) {
-		/* Unlucky, discard newly allocated slab */
-		defer_deactivate_slab(slab, NULL);
+		/* Unlucky, discard newly allocated slab. */
+		free_new_slab_nolock(s, slab);
 		return NULL;
 	}
 
@@ -4276,7 +4286,7 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
 
 		if (!spin_trylock_irqsave(&n->list_lock, flags)) {
 			/* Unlucky, discard newly allocated slab */
-			defer_deactivate_slab(slab, NULL);
+			free_new_slab_nolock(s, slab);
 			return 0;
 		}
 	}
@@ -6033,7 +6043,6 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 
 struct defer_free {
 	struct llist_head objects;
-	struct llist_head slabs;
 	struct irq_work work;
 };
 
@@ -6041,7 +6050,6 @@ static void free_deferred_objects(struct irq_work *work);
 
 static DEFINE_PER_CPU(struct defer_free, defer_free_objects) = {
 	.objects = LLIST_HEAD_INIT(objects),
-	.slabs = LLIST_HEAD_INIT(slabs),
 	.work = IRQ_WORK_INIT(free_deferred_objects),
 };
 
@@ -6054,10 +6062,9 @@ static void free_deferred_objects(struct irq_work *work)
 {
 	struct defer_free *df = container_of(work, struct defer_free, work);
 	struct llist_head *objs = &df->objects;
-	struct llist_head *slabs = &df->slabs;
 	struct llist_node *llnode, *pos, *t;
 
-	if (llist_empty(objs) && llist_empty(slabs))
+	if (llist_empty(objs))
 		return;
 
 	llnode = llist_del_all(objs);
@@ -6081,16 +6088,6 @@ static void free_deferred_objects(struct irq_work *work)
 
 		__slab_free(s, slab, x, x, 1, _THIS_IP_);
 	}
-
-	llnode = llist_del_all(slabs);
-	llist_for_each_safe(pos, t, llnode) {
-		struct slab *slab = container_of(pos, struct slab, llnode);
-
-		if (slab->frozen)
-			deactivate_slab(slab->slab_cache, slab, slab->flush_freelist);
-		else
-			free_slab(slab->slab_cache, slab);
-	}
 }
 
 static void defer_free(struct kmem_cache *s, void *head)
@@ -6106,19 +6103,6 @@ static void defer_free(struct kmem_cache *s, void *head)
 		irq_work_queue(&df->work);
 }
 
-static void defer_deactivate_slab(struct slab *slab, void *flush_freelist)
-{
-	struct defer_free *df;
-
-	slab->flush_freelist = flush_freelist;
-
-	guard(preempt)();
-
-	df = this_cpu_ptr(&defer_free_objects);
-	if (llist_add(&slab->llnode, &df->slabs))
-		irq_work_queue(&df->work);
-}
-
 void defer_free_barrier(void)
 {
 	int cpu;

-- 
2.52.0


