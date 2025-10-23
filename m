Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A2C2CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 13:53:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCCA48E0036; Thu, 23 Oct 2025 09:53:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7E678E0002; Thu, 23 Oct 2025 09:53:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6C0D8E0036; Thu, 23 Oct 2025 09:53:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8E1088E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:53:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 59E74BCD78
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:53:32 +0000 (UTC)
X-FDA: 84029521464.26.2B41061
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2846B40010
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:53:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761227610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T2ZEYr8/h5A7sedphkcRhXt+75mCYtLkQBBoLhCU1eo=;
	b=s9SDcOFOqGwfTP9ey5nhOptkPcRaA6lZBaTJNw5oQPz/inT6hEpK4EHmv8f0hFA/9XCkT+
	pfz4c4A4sSo7UIYHM70O+uYCfB6uxSuGQ5LM8jOoEvH+ne2Yj56XWj663z5aRzTvWVlTIt
	K7zQLnTGQICix9/sdKpivuTFOLe8Sug=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761227610; a=rsa-sha256;
	cv=none;
	b=u1Tjcyw0ytdUt5m9CFK9aaIZMmFkqK3mp2YfM4q1VXCokQsh9HbDII1aWvUHK/SMLS/8cH
	TO2CYScigpHKBilCDD6MgR5kvZohCx+BsygZL6L7mFbxUKuX8BSnZlV+h/Sa2avOis43Da
	/MIodcC97ruv41q1H/c2eand1qQEjuM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A95971F7CA;
	Thu, 23 Oct 2025 13:53:01 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4F60413B0B;
	Thu, 23 Oct 2025 13:52:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QOT/EjYz+mjvQQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 23 Oct 2025 13:52:54 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Thu, 23 Oct 2025 15:52:35 +0200
Subject: [PATCH RFC 13/19] slab: remove defer_deactivate_slab()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-sheaves-for-all-v1-13-6ffa2c9941c0@suse.cz>
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
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 2846B40010
X-Rspamd-Server: rspam03
X-Stat-Signature: 8xin83jfki865keddfksuw1mtnpshdrw
X-HE-Tag: 1761227609-560122
X-HE-Meta: U2FsdGVkX19n4W8L0ZgBDeYAFAy1LVcJEpU6QctskWr/9eBu9jmlG25MthZzdit0eVFT65P2lksmnZUXR81fNV7aa5v9Vg3dxLFuvqBOwM8Rb6RNcjHQtY4wG22dVsnTO3ulLu0W+kG67CE82FrWXjwXpQlG+n4k7kGA9IDROHxn+H7je8j7pwoSObBrq9JpuEtxGmvw/zmyYUGZVw0/tqK6/W+tkqceIAfSo172y85R+wuUbptuQ5Czd3ddQUlOKEadQk7BSBIKlc9SqJOUCz3dTmYkbNYfsPFAR+Y8phZdsg9ifaaKmMjw5ricT4IjbbilSii2/FV0h2z4+8ErOoFCiUTeVYEOnNjjGYE5ZKAx8WV2m6LiyFmeVaC08jqEjl6Uw3oRdFb2G2PDT9KxYrKUQg5JdbjFz5BG8wEHih2eMOeKVTPDWKp9FW81/3SciGeRuoAkRTGEzi8cW3WF9anbXkIxL/CkD6/rkk/Ml0ThK1E6DDDuOstNM1bZRdbPGjUCgwR2EAWrhxmwQU9IQsAO/zyQuaAxWRtQ9jxBMbUOuAJCqUe6bU4t1RuSW1giDGLxUReJhfnvDuAtLOvhe1PO008w3GimuSc/AYNKWGOJwzM5p/tfo74d0Wt/2TAlWcrQuJy5fDw70K01aFLqfY91uwE0tLREJxiz0Shmy4q0BqUUeQfmE+Qc5CtB3UuteY5FlwnX2u+O5J3WcRgk1N2O9o8r5ylF2E69Vrm21nv9np6WM7DwBG4Xm7YblcswG19j9ly12C0BdYLtqEDr4OgeqGzbGJXG1cC8r8//RD7WPGfMaSz06WCf/hBe3wKLPqcM75IzwA555n1EfxoeVPzqeF1ADKmAH0mR8yeH5zjLExwcQAOtC539OVDm2b3LibTIJZBDsM2PlAOCqqHyVHjG7LMia7vjSZJfDrIeha8fCtfrGWE6ybjNiHH/w1JBt+xReqaTjrStViVPMTR
 mMDcPHM0
 m9WWcQ5s12x7nCokfaYuU1caVNn1Xid9HsRSC7tuBIXgP0ITaZMjAoERjZzE8TS4AJ0atJgHSZtugE4vk7iw3sJqRYbRXNSIl1vNeRTGfFYLwF+IhOOCpJpWg8+t2kCv7ldehqiqX8ppwzto=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are no more cpu slabs so we don't need their deferred
deactivation. The function is now only used from a place where we
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
 mm/slub.c       | 50 +++++++++++++++-----------------------------------
 4 files changed, 22 insertions(+), 42 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 1561fc2ff5b8..64c5eda7c1ae 100644
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
index 600d9e981c23..f8ac3232db41 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2944,6 +2944,11 @@ void free_frozen_pages(struct page *page, unsigned int order)
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
index a103da44ab9d..b2663cc594f3 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -55,13 +55,7 @@ struct slab {
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
 			union {
 				struct {
diff --git a/mm/slub.c b/mm/slub.c
index a35eb397caa9..6f5ca26bbb00 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3246,7 +3246,7 @@ static struct slab *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);
 }
 
-static void __free_slab(struct kmem_cache *s, struct slab *slab)
+static void __free_slab(struct kmem_cache *s, struct slab *slab, bool allow_spin)
 {
 	struct folio *folio = slab_folio(slab);
 	int order = folio_order(folio);
@@ -3257,14 +3257,18 @@ static void __free_slab(struct kmem_cache *s, struct slab *slab)
 	__folio_clear_slab(folio);
 	mm_account_reclaimed_pages(pages);
 	unaccount_slab(slab, order, s);
-	free_frozen_pages(&folio->page, order);
+
+	if (allow_spin)
+		free_frozen_pages(&folio->page, order);
+	else
+		free_frozen_pages_nolock(&folio->page, order);
 }
 
 static void rcu_free_slab(struct rcu_head *h)
 {
 	struct slab *slab = container_of(h, struct slab, rcu_head);
 
-	__free_slab(slab->slab_cache, slab);
+	__free_slab(slab->slab_cache, slab, true);
 }
 
 static void free_slab(struct kmem_cache *s, struct slab *slab)
@@ -3280,7 +3284,7 @@ static void free_slab(struct kmem_cache *s, struct slab *slab)
 	if (unlikely(s->flags & SLAB_TYPESAFE_BY_RCU))
 		call_rcu(&slab->rcu_head, rcu_free_slab);
 	else
-		__free_slab(s, slab);
+		__free_slab(s, slab, true);
 }
 
 static void discard_slab(struct kmem_cache *s, struct slab *slab)
@@ -3373,8 +3377,6 @@ static void *alloc_single_from_partial(struct kmem_cache *s,
 	return object;
 }
 
-static void defer_deactivate_slab(struct slab *slab, void *flush_freelist);
-
 /*
  * Called only for kmem_cache_debug() caches to allocate from a freshly
  * allocated slab. Allocate a single object instead of whole freelist
@@ -3390,8 +3392,12 @@ static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
 	void *object;
 
 	if (!allow_spin && !spin_trylock_irqsave(&n->list_lock, flags)) {
-		/* Unlucky, discard newly allocated slab */
-		defer_deactivate_slab(slab, NULL);
+		/*
+		 * Unlucky, discard newly allocated slab.
+		 * Since it was just allocated, we can skip the actions
+		 * in discard_slab() and free_slab().
+		 */
+		__free_slab(s, slab, false);
 		return NULL;
 	}
 
@@ -5949,7 +5955,6 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 
 struct defer_free {
 	struct llist_head objects;
-	struct llist_head slabs;
 	struct irq_work work;
 };
 
@@ -5957,7 +5962,6 @@ static void free_deferred_objects(struct irq_work *work);
 
 static DEFINE_PER_CPU(struct defer_free, defer_free_objects) = {
 	.objects = LLIST_HEAD_INIT(objects),
-	.slabs = LLIST_HEAD_INIT(slabs),
 	.work = IRQ_WORK_INIT(free_deferred_objects),
 };
 
@@ -5970,10 +5974,9 @@ static void free_deferred_objects(struct irq_work *work)
 {
 	struct defer_free *df = container_of(work, struct defer_free, work);
 	struct llist_head *objs = &df->objects;
-	struct llist_head *slabs = &df->slabs;
 	struct llist_node *llnode, *pos, *t;
 
-	if (llist_empty(objs) && llist_empty(slabs))
+	if (llist_empty(objs))
 		return;
 
 	llnode = llist_del_all(objs);
@@ -5997,16 +6000,6 @@ static void free_deferred_objects(struct irq_work *work)
 
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
@@ -6020,19 +6013,6 @@ static void defer_free(struct kmem_cache *s, void *head)
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
2.51.1


