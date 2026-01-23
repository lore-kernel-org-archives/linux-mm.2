Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C979D6261A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:54:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEE0A6B0410; Fri, 23 Jan 2026 01:53:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6A4B6B0412; Fri, 23 Jan 2026 01:53:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B658F6B0413; Fri, 23 Jan 2026 01:53:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A02D76B0412
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:53:57 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7651D1A0332
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:53:57 +0000 (UTC)
X-FDA: 84362313714.05.0EA08A7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 18C321C0005
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:53:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769151235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kfgm0LdoXDs24MuLOAO2Q48iONigc/hfGhDfxSTYaYE=;
	b=Ot+5js9xCCinkKWnrOl6sb65y7YmuAJ4W+Wnf8TwIbxXfj1iO5MbkyV9ndtpxzr5MRLw4j
	tz1IHaUqkSgMkXfATHpXRmHdalL7Bh086Gup82cNELEKLBo06RUI/pKHtP4aGV9Jg+f2HP
	tgsihGdOqncXBmlCLDLyVs3ch9IGLWs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769151235; a=rsa-sha256;
	cv=none;
	b=vpgKsHBxPT87N8eTHAx/FZrFFfkedv0qgxRF170ERzlLIcjGNpsHOcl2TwQDrEt/0/22+8
	m7FNOXSqsjeNxZ7Ik3o8AIvTGDfS8THINKTU/CVQxT5hXG/lenCuUgUOq8raSB2pKBtJnQ
	ax6y42OJFK6upIu5MGp+8s70BzxyOaQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EE9145BCD3;
	Fri, 23 Jan 2026 06:53:10 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C88CF139E8;
	Fri, 23 Jan 2026 06:53:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MMqxMNYac2k4YgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 23 Jan 2026 06:53:10 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 23 Jan 2026 07:52:54 +0100
Subject: [PATCH v4 16/22] slab: remove struct kmem_cache_cpu
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-sheaves-for-all-v4-16-041323d506f7@suse.cz>
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 18C321C0005
X-Stat-Signature: q79eg4ygy33y7yjagj4e5wmufh3dsx64
X-Rspam-User: 
X-HE-Tag: 1769151234-645821
X-HE-Meta: U2FsdGVkX1/ud0Rpf4PdoVEECDQgJIKvmd6kZP7s0RFfMvNTdBp7qi+z8smaEB4oC+L7FNZo0R55Ok6A8dm/yuXEDhxiBGeie3P5csSmSbxUjS2qJRc4sLXNuSdUaTQyk7FiC2IWFwH4CkvEkjvt5RFDAUX3ujgSveiBUo9j/mHn0Pjr9TPVO8IyzLoeOx2dgWlT1vUNH97nkwdOkXjulTZYm7JcW+Cj+ypGKSdoUfVBkz817J2v/+rF+Vw0eNQs/lokLe0dq+jkIVVEzSyT6ONkQDxe3tl3vUtuVuE/SYE49xvXl9hzd3DM9Pz30YjQtbKvcH7/0xj+94I1XFwrMVZ6H7qxze5EGZ2KfPkwCAsUDVPL9u1bKaLVVz6MF99Qinwc+KJ75dYl1XjKNdM89AVAOXed3WDaIjayR+YuMlJz0F3ZfdaOj03dHiZTvEpnI1Z4OqbrfEFDy6NGYUghgQOYJP576x+xgjxTahpuL0FvoT6PD/NIZ6CFUr29ROIVLYY1920b5UlQ+4Rc6hcBPXnhztKV10kQK6HNItaPuqePTxyqrXjewIzRfhJuvj3iT3+OX6AMPtsM5RWjoC5z2mvqWtlaEyx4vx7dhkfR99w7cWYZnkDZlP0J88mvkso7xlZ1Hmi0vL0BeYq7XHm/WvJZxq2qi2DkNqBEr0fSGM28JCMSH52RYQcxGNq6dSqfks3h2GOTgM6ap/NaBPUTiJ2rjNopgDJSdGk5h1/F2Qq4pwvOXlqinc6VdeUFF/vcCG2eNJUr9TK3/bzFNMMdf+LFigw40iHMvCVX+zm7jDSbErh2ZiPQXLP6cA5NGHR2BYYbvIQ+fJd87nF5BG9h4LRdK9Wia1IQQ0p+UsVFm++/bZ0K39J0zKOo3wxdJujLU7gjQcscVIQJShNJNDEx6pYnfAsDHluFjy1cGCTpXQ7XDyOduokgLfNyhYWwhnEACzdvLtxa1cTLBVDoVqr
 VOEQYEuL
 zjNM4SJCRIh7VS4RAT8V6C0enyT9/K3iKvXKQNNoNHLeEx3S2eB/O4HAlfOnLNuo6pl9fwk9iOlpimu1W208IrzaXD3KMzSIQ07Q0pyDwU5Ho0TwOOj58WYyAzXGMKm1XP4hfGDdZlWe/Bn5sJhVP0kuVDF7dd8tDgycTXvk+RF7LbtAUnlnvOjGU3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The cpu slab is not used anymore for allocation or freeing, the
remaining code is for flushing, but it's effectively dead.  Remove the
whole struct kmem_cache_cpu, the flushing code and other orphaned
functions.

The remaining used field of kmem_cache_cpu is the stat array with
CONFIG_SLUB_STATS. Put it instead in a new struct kmem_cache_stats.
In struct kmem_cache, the field is cpu_stats and placed near the
end of the struct.

Reviewed-by: Hao Li <hao.li@linux.dev>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab.h |   7 +-
 mm/slub.c | 304 +++++---------------------------------------------------------
 2 files changed, 27 insertions(+), 284 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 47ca9e2cd3be..598f45033f0d 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -21,14 +21,12 @@
 # define system_has_freelist_aba()	system_has_cmpxchg128()
 # define try_cmpxchg_freelist		try_cmpxchg128
 # endif
-#define this_cpu_try_cmpxchg_freelist	this_cpu_try_cmpxchg128
 typedef u128 freelist_full_t;
 #else /* CONFIG_64BIT */
 # ifdef system_has_cmpxchg64
 # define system_has_freelist_aba()	system_has_cmpxchg64()
 # define try_cmpxchg_freelist		try_cmpxchg64
 # endif
-#define this_cpu_try_cmpxchg_freelist	this_cpu_try_cmpxchg64
 typedef u64 freelist_full_t;
 #endif /* CONFIG_64BIT */
 
@@ -189,7 +187,6 @@ struct kmem_cache_order_objects {
  * Slab cache management.
  */
 struct kmem_cache {
-	struct kmem_cache_cpu __percpu *cpu_slab;
 	struct slub_percpu_sheaves __percpu *cpu_sheaves;
 	/* Used for retrieving partial slabs, etc. */
 	slab_flags_t flags;
@@ -238,6 +235,10 @@ struct kmem_cache {
 	unsigned int usersize;		/* Usercopy region size */
 #endif
 
+#ifdef CONFIG_SLUB_STATS
+	struct kmem_cache_stats __percpu *cpu_stats;
+#endif
+
 	struct kmem_cache_node *node[MAX_NUMNODES];
 };
 
diff --git a/mm/slub.c b/mm/slub.c
index 92e75aeeb89b..8ecd5766635b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -405,28 +405,11 @@ enum stat_item {
 	NR_SLUB_STAT_ITEMS
 };
 
-struct freelist_tid {
-	union {
-		struct {
-			void *freelist;		/* Pointer to next available object */
-			unsigned long tid;	/* Globally unique transaction id */
-		};
-		freelist_full_t freelist_tid;
-	};
-};
-
-/*
- * When changing the layout, make sure freelist and tid are still compatible
- * with this_cpu_cmpxchg_double() alignment requirements.
- */
-struct kmem_cache_cpu {
-	struct freelist_tid;
-	struct slab *slab;	/* The slab from which we are allocating */
-	local_trylock_t lock;	/* Protects the fields above */
 #ifdef CONFIG_SLUB_STATS
+struct kmem_cache_stats {
 	unsigned int stat[NR_SLUB_STAT_ITEMS];
-#endif
 };
+#endif
 
 static inline void stat(const struct kmem_cache *s, enum stat_item si)
 {
@@ -435,7 +418,7 @@ static inline void stat(const struct kmem_cache *s, enum stat_item si)
 	 * The rmw is racy on a preemptible kernel but this is acceptable, so
 	 * avoid this_cpu_add()'s irq-disable overhead.
 	 */
-	raw_cpu_inc(s->cpu_slab->stat[si]);
+	raw_cpu_inc(s->cpu_stats->stat[si]);
 #endif
 }
 
@@ -443,7 +426,7 @@ static inline
 void stat_add(const struct kmem_cache *s, enum stat_item si, int v)
 {
 #ifdef CONFIG_SLUB_STATS
-	raw_cpu_add(s->cpu_slab->stat[si], v);
+	raw_cpu_add(s->cpu_stats->stat[si], v);
 #endif
 }
 
@@ -532,7 +515,7 @@ static inline struct node_barn *get_barn(struct kmem_cache *s)
 static nodemask_t slab_nodes;
 
 /*
- * Workqueue used for flush_cpu_slab().
+ * Workqueue used for flushing cpu and kfree_rcu sheaves.
  */
 static struct workqueue_struct *flushwq;
 
@@ -1154,20 +1137,6 @@ static void object_err(struct kmem_cache *s, struct slab *slab,
 	WARN_ON(1);
 }
 
-static bool freelist_corrupted(struct kmem_cache *s, struct slab *slab,
-			       void **freelist, void *nextfree)
-{
-	if ((s->flags & SLAB_CONSISTENCY_CHECKS) &&
-	    !check_valid_pointer(s, slab, nextfree) && freelist) {
-		object_err(s, slab, *freelist, "Freechain corrupt");
-		*freelist = NULL;
-		slab_fix(s, "Isolate corrupted freechain");
-		return true;
-	}
-
-	return false;
-}
-
 static void __slab_err(struct slab *slab)
 {
 	if (slab_in_kunit_test())
@@ -1949,11 +1918,6 @@ static inline void inc_slabs_node(struct kmem_cache *s, int node,
 							int objects) {}
 static inline void dec_slabs_node(struct kmem_cache *s, int node,
 							int objects) {}
-static bool freelist_corrupted(struct kmem_cache *s, struct slab *slab,
-			       void **freelist, void *nextfree)
-{
-	return false;
-}
 #endif /* CONFIG_SLUB_DEBUG */
 
 /*
@@ -3651,191 +3615,6 @@ static void *get_from_partial(struct kmem_cache *s, int node,
 	return get_from_any_partial(s, pc);
 }
 
-#ifdef CONFIG_PREEMPTION
-/*
- * Calculate the next globally unique transaction for disambiguation
- * during cmpxchg. The transactions start with the cpu number and are then
- * incremented by CONFIG_NR_CPUS.
- */
-#define TID_STEP  roundup_pow_of_two(CONFIG_NR_CPUS)
-#else
-/*
- * No preemption supported therefore also no need to check for
- * different cpus.
- */
-#define TID_STEP 1
-#endif /* CONFIG_PREEMPTION */
-
-static inline unsigned long next_tid(unsigned long tid)
-{
-	return tid + TID_STEP;
-}
-
-#ifdef SLUB_DEBUG_CMPXCHG
-static inline unsigned int tid_to_cpu(unsigned long tid)
-{
-	return tid % TID_STEP;
-}
-
-static inline unsigned long tid_to_event(unsigned long tid)
-{
-	return tid / TID_STEP;
-}
-#endif
-
-static inline unsigned int init_tid(int cpu)
-{
-	return cpu;
-}
-
-static void init_kmem_cache_cpus(struct kmem_cache *s)
-{
-	int cpu;
-	struct kmem_cache_cpu *c;
-
-	for_each_possible_cpu(cpu) {
-		c = per_cpu_ptr(s->cpu_slab, cpu);
-		local_trylock_init(&c->lock);
-		c->tid = init_tid(cpu);
-	}
-}
-
-/*
- * Finishes removing the cpu slab. Merges cpu's freelist with slab's freelist,
- * unfreezes the slabs and puts it on the proper list.
- * Assumes the slab has been already safely taken away from kmem_cache_cpu
- * by the caller.
- */
-static void deactivate_slab(struct kmem_cache *s, struct slab *slab,
-			    void *freelist)
-{
-	struct kmem_cache_node *n = get_node(s, slab_nid(slab));
-	int free_delta = 0;
-	void *nextfree, *freelist_iter, *freelist_tail;
-	int tail = DEACTIVATE_TO_HEAD;
-	unsigned long flags = 0;
-	struct freelist_counters old, new;
-
-	if (READ_ONCE(slab->freelist)) {
-		stat(s, DEACTIVATE_REMOTE_FREES);
-		tail = DEACTIVATE_TO_TAIL;
-	}
-
-	/*
-	 * Stage one: Count the objects on cpu's freelist as free_delta and
-	 * remember the last object in freelist_tail for later splicing.
-	 */
-	freelist_tail = NULL;
-	freelist_iter = freelist;
-	while (freelist_iter) {
-		nextfree = get_freepointer(s, freelist_iter);
-
-		/*
-		 * If 'nextfree' is invalid, it is possible that the object at
-		 * 'freelist_iter' is already corrupted.  So isolate all objects
-		 * starting at 'freelist_iter' by skipping them.
-		 */
-		if (freelist_corrupted(s, slab, &freelist_iter, nextfree))
-			break;
-
-		freelist_tail = freelist_iter;
-		free_delta++;
-
-		freelist_iter = nextfree;
-	}
-
-	/*
-	 * Stage two: Unfreeze the slab while splicing the per-cpu
-	 * freelist to the head of slab's freelist.
-	 */
-	do {
-		old.freelist = READ_ONCE(slab->freelist);
-		old.counters = READ_ONCE(slab->counters);
-		VM_BUG_ON(!old.frozen);
-
-		/* Determine target state of the slab */
-		new.counters = old.counters;
-		new.frozen = 0;
-		if (freelist_tail) {
-			new.inuse -= free_delta;
-			set_freepointer(s, freelist_tail, old.freelist);
-			new.freelist = freelist;
-		} else {
-			new.freelist = old.freelist;
-		}
-	} while (!slab_update_freelist(s, slab, &old, &new, "unfreezing slab"));
-
-	/*
-	 * Stage three: Manipulate the slab list based on the updated state.
-	 */
-	if (!new.inuse && n->nr_partial >= s->min_partial) {
-		stat(s, DEACTIVATE_EMPTY);
-		discard_slab(s, slab);
-		stat(s, FREE_SLAB);
-	} else if (new.freelist) {
-		spin_lock_irqsave(&n->list_lock, flags);
-		add_partial(n, slab, tail);
-		spin_unlock_irqrestore(&n->list_lock, flags);
-		stat(s, tail);
-	} else {
-		stat(s, DEACTIVATE_FULL);
-	}
-}
-
-static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
-{
-	unsigned long flags;
-	struct slab *slab;
-	void *freelist;
-
-	local_lock_irqsave(&s->cpu_slab->lock, flags);
-
-	slab = c->slab;
-	freelist = c->freelist;
-
-	c->slab = NULL;
-	c->freelist = NULL;
-	c->tid = next_tid(c->tid);
-
-	local_unlock_irqrestore(&s->cpu_slab->lock, flags);
-
-	if (slab) {
-		deactivate_slab(s, slab, freelist);
-		stat(s, CPUSLAB_FLUSH);
-	}
-}
-
-static inline void __flush_cpu_slab(struct kmem_cache *s, int cpu)
-{
-	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
-	void *freelist = c->freelist;
-	struct slab *slab = c->slab;
-
-	c->slab = NULL;
-	c->freelist = NULL;
-	c->tid = next_tid(c->tid);
-
-	if (slab) {
-		deactivate_slab(s, slab, freelist);
-		stat(s, CPUSLAB_FLUSH);
-	}
-}
-
-static inline void flush_this_cpu_slab(struct kmem_cache *s)
-{
-	struct kmem_cache_cpu *c = this_cpu_ptr(s->cpu_slab);
-
-	if (c->slab)
-		flush_slab(s, c);
-}
-
-static bool has_cpu_slab(int cpu, struct kmem_cache *s)
-{
-	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
-
-	return c->slab;
-}
-
 static bool has_pcs_used(int cpu, struct kmem_cache *s)
 {
 	struct slub_percpu_sheaves *pcs;
@@ -3849,11 +3628,11 @@ static bool has_pcs_used(int cpu, struct kmem_cache *s)
 }
 
 /*
- * Flush cpu slab.
+ * Flush percpu sheaves
  *
  * Called from CPU work handler with migration disabled.
  */
-static void flush_cpu_slab(struct work_struct *w)
+static void flush_cpu_sheaves(struct work_struct *w)
 {
 	struct kmem_cache *s;
 	struct slub_flush_work *sfw;
@@ -3864,8 +3643,6 @@ static void flush_cpu_slab(struct work_struct *w)
 
 	if (cache_has_sheaves(s))
 		pcs_flush_all(s);
-
-	flush_this_cpu_slab(s);
 }
 
 static void flush_all_cpus_locked(struct kmem_cache *s)
@@ -3878,11 +3655,11 @@ static void flush_all_cpus_locked(struct kmem_cache *s)
 
 	for_each_online_cpu(cpu) {
 		sfw = &per_cpu(slub_flush, cpu);
-		if (!has_cpu_slab(cpu, s) && !has_pcs_used(cpu, s)) {
+		if (!has_pcs_used(cpu, s)) {
 			sfw->skip = true;
 			continue;
 		}
-		INIT_WORK(&sfw->work, flush_cpu_slab);
+		INIT_WORK(&sfw->work, flush_cpu_sheaves);
 		sfw->skip = false;
 		sfw->s = s;
 		queue_work_on(cpu, flushwq, &sfw->work);
@@ -3988,7 +3765,6 @@ static int slub_cpu_dead(unsigned int cpu)
 
 	mutex_lock(&slab_mutex);
 	list_for_each_entry(s, &slab_caches, list) {
-		__flush_cpu_slab(s, cpu);
 		if (cache_has_sheaves(s))
 			__pcs_flush_all_cpu(s, cpu);
 	}
@@ -7149,26 +6925,21 @@ init_kmem_cache_node(struct kmem_cache_node *n, struct node_barn *barn)
 		barn_init(barn);
 }
 
-static inline int alloc_kmem_cache_cpus(struct kmem_cache *s)
+#ifdef CONFIG_SLUB_STATS
+static inline int alloc_kmem_cache_stats(struct kmem_cache *s)
 {
 	BUILD_BUG_ON(PERCPU_DYNAMIC_EARLY_SIZE <
 			NR_KMALLOC_TYPES * KMALLOC_SHIFT_HIGH *
-			sizeof(struct kmem_cache_cpu));
+			sizeof(struct kmem_cache_stats));
 
-	/*
-	 * Must align to double word boundary for the double cmpxchg
-	 * instructions to work; see __pcpu_double_call_return_bool().
-	 */
-	s->cpu_slab = __alloc_percpu(sizeof(struct kmem_cache_cpu),
-				     2 * sizeof(void *));
+	s->cpu_stats = alloc_percpu(struct kmem_cache_stats);
 
-	if (!s->cpu_slab)
+	if (!s->cpu_stats)
 		return 0;
 
-	init_kmem_cache_cpus(s);
-
 	return 1;
 }
+#endif
 
 static int init_percpu_sheaves(struct kmem_cache *s)
 {
@@ -7279,7 +7050,9 @@ void __kmem_cache_release(struct kmem_cache *s)
 {
 	cache_random_seq_destroy(s);
 	pcs_destroy(s);
-	free_percpu(s->cpu_slab);
+#ifdef CONFIG_SLUB_STATS
+	free_percpu(s->cpu_stats);
+#endif
 	free_kmem_cache_nodes(s);
 }
 
@@ -7976,12 +7749,6 @@ static struct kmem_cache * __init bootstrap(struct kmem_cache *static_cache)
 
 	memcpy(s, static_cache, kmem_cache->object_size);
 
-	/*
-	 * This runs very early, and only the boot processor is supposed to be
-	 * up.  Even if it weren't true, IRQs are not up so we couldn't fire
-	 * IPIs around.
-	 */
-	__flush_cpu_slab(s, smp_processor_id());
 	for_each_kmem_cache_node(s, node, n) {
 		struct slab *p;
 
@@ -8196,8 +7963,10 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
 	if (!init_kmem_cache_nodes(s))
 		goto out;
 
-	if (!alloc_kmem_cache_cpus(s))
+#ifdef CONFIG_SLUB_STATS
+	if (!alloc_kmem_cache_stats(s))
 		goto out;
+#endif
 
 	err = init_percpu_sheaves(s);
 	if (err)
@@ -8516,33 +8285,6 @@ static ssize_t show_slab_objects(struct kmem_cache *s,
 	if (!nodes)
 		return -ENOMEM;
 
-	if (flags & SO_CPU) {
-		int cpu;
-
-		for_each_possible_cpu(cpu) {
-			struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab,
-							       cpu);
-			int node;
-			struct slab *slab;
-
-			slab = READ_ONCE(c->slab);
-			if (!slab)
-				continue;
-
-			node = slab_nid(slab);
-			if (flags & SO_TOTAL)
-				x = slab->objects;
-			else if (flags & SO_OBJECTS)
-				x = slab->inuse;
-			else
-				x = 1;
-
-			total += x;
-			nodes[node] += x;
-
-		}
-	}
-
 	/*
 	 * It is impossible to take "mem_hotplug_lock" here with "kernfs_mutex"
 	 * already held which will conflict with an existing lock order:
@@ -8913,7 +8655,7 @@ static int show_stat(struct kmem_cache *s, char *buf, enum stat_item si)
 		return -ENOMEM;
 
 	for_each_online_cpu(cpu) {
-		unsigned x = per_cpu_ptr(s->cpu_slab, cpu)->stat[si];
+		unsigned int x = per_cpu_ptr(s->cpu_stats, cpu)->stat[si];
 
 		data[cpu] = x;
 		sum += x;
@@ -8939,7 +8681,7 @@ static void clear_stat(struct kmem_cache *s, enum stat_item si)
 	int cpu;
 
 	for_each_online_cpu(cpu)
-		per_cpu_ptr(s->cpu_slab, cpu)->stat[si] = 0;
+		per_cpu_ptr(s->cpu_stats, cpu)->stat[si] = 0;
 }
 
 #define STAT_ATTR(si, text) 					\

-- 
2.52.0


