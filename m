Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47336C982C7
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 14:41:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECCD66B009D; Fri, 16 Jan 2026 09:41:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4E896B009E; Fri, 16 Jan 2026 09:41:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C91CA6B009F; Fri, 16 Jan 2026 09:41:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B35296B009D
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:41:11 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 756EBB5DFD
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:41:11 +0000 (UTC)
X-FDA: 84338089542.17.85CAB92
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3D9A0A0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:41:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TGAuPHLM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=baEhQHVp;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TGAuPHLM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=baEhQHVp;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768574469; a=rsa-sha256;
	cv=none;
	b=AiA5qw/Ho1dDy6Ay2ZmgqquXfBbdASaeynQ3WMI3W02r+rea0OHB1uECBjfbySnYxAB65k
	6MzivUlMHPG6kIpb4hOwpjTR1jJjsEWCVY/1N1kGvuUWXk1QFffPxs6BRZn2D6D49OeO5K
	tsD3MkWhzaKpBDDsEy9CtOmOtQmfX/c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TGAuPHLM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=baEhQHVp;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TGAuPHLM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=baEhQHVp;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768574469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1zCFUxTR6Bz27ufJId/W/RTWyhVuq6m8QvGcv4tOF6U=;
	b=JPbAolTiigry3Sc3ZRKdQItsy1+RN3XwDLdGi+MhWKSO+N4iydIdCpbS3pyLfWFhczUSL/
	j164As7U/nVpt1szlGZ6lPwLSwYeGzBWfmYBcb1Q8Aa5N0+pXTEhxJ49YSkf5VKwi6JChH
	UpCTysQoW5pZkuO+l0EQrXYnuUaRAWY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F29EB5BE45;
	Fri, 16 Jan 2026 14:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574438; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1zCFUxTR6Bz27ufJId/W/RTWyhVuq6m8QvGcv4tOF6U=;
	b=TGAuPHLM5r0MWS0JgBUm4bFVNvxL2+oHCsspAn0jvtZHd4f68UE7iKemE5B0XP46+rpoMP
	OM4O3XFoh04Pb0iNiy+LnQGTeGoQ2CiyqKowTxWObSPtugWjXjLcRjjJYM6kgmVvjL5cZq
	W8sodTN4VFP1HBr7B0RS1Xo1GhKFPVQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574438;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1zCFUxTR6Bz27ufJId/W/RTWyhVuq6m8QvGcv4tOF6U=;
	b=baEhQHVpex+vEpAquhHYZkjf/nUtKWStTdk9LyUF7DxOfgtIkx912fmqzkYGS+LKWMv842
	2t1Tpmp5Telq/lCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574438; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1zCFUxTR6Bz27ufJId/W/RTWyhVuq6m8QvGcv4tOF6U=;
	b=TGAuPHLM5r0MWS0JgBUm4bFVNvxL2+oHCsspAn0jvtZHd4f68UE7iKemE5B0XP46+rpoMP
	OM4O3XFoh04Pb0iNiy+LnQGTeGoQ2CiyqKowTxWObSPtugWjXjLcRjjJYM6kgmVvjL5cZq
	W8sodTN4VFP1HBr7B0RS1Xo1GhKFPVQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574438;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1zCFUxTR6Bz27ufJId/W/RTWyhVuq6m8QvGcv4tOF6U=;
	b=baEhQHVpex+vEpAquhHYZkjf/nUtKWStTdk9LyUF7DxOfgtIkx912fmqzkYGS+LKWMv842
	2t1Tpmp5Telq/lCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D05D23EA66;
	Fri, 16 Jan 2026 14:40:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0LyVMuVNamnydgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 16 Jan 2026 14:40:37 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 16 Jan 2026 15:40:32 +0100
Subject: [PATCH v3 12/21] slab: remove the do_slab_free() fastpath
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260116-sheaves-for-all-v3-12-5595cb000772@suse.cz>
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
X-Rspamd-Queue-Id: 3D9A0A0005
X-Rspamd-Server: rspam06
X-Stat-Signature: usfwiu71taosox8rtycwxh671fyx564w
X-Rspam-User: 
X-HE-Tag: 1768574468-52646
X-HE-Meta: U2FsdGVkX19p3RuAnFSEYnRpTtG7Q/Swqrl/SZ9RPlH4uyjqCtFS7pD70OW3EKcem3ssHQGwJ3CBCo1ZgxSbaLV96tByIZfKZqC9oRp3N9s4W6DK4YaMwsYDQb6iK/JR0kDl+q9LHBKh7yMV1oSuwA9DgZnYlhYen42Ynr9lDvSJ0RrL1pGRfebUUwcVHPWLAphbaCChzfq1iCwnB7O0O03aOrLV+FpF+fWQ1Wb+WV4tVzlVAkpF57IUYz3DRyGCcVfp5Ss3yYLItu/b/U6GB0BxT2PRv1TT9taCN6ZX1uoGROaNh1mRr9P8ze6PbKS6WCBxzZuj2WNEAShb281Y//Xna9NAN77u2G+3mqdDxnzcYpZYD4nV/AhtxC2MvC0nEvhjstDVpgTWPeXtDPAVAsT67QHDNgAIS+ohlPQn5P8up5yduwboLH60EwHw8PFdyjAAev7nYPth/2B4FTmY2zIBbDbXIBWly8ZbX0OE8EGpYVnfxQIHrzfrGV96EerJC7pqtDJwft2Keszc6rrAXKA6XygcMK72jSvgflDfU+ieYSbEbYbE0uPNkbHRzxFETRGBd0G/Irg3gw18KLfF7Zo/El2IFwPD8D5zVvVM6q2E7LX5mChZuxWVMkgpvEDP3yKyHwAa+xggD731EPyJkJJ4JkMKMNFfIN+9nIKBFQ4w/3y55nvEoOlP0Gh1fXzV+DGMxN8lni91grw2tSjwR/ZTJQ4x9Ce5CAB/l94U18DMHS8J/9fI8Z0icX59CzlYvvPnUXOMb9vohaTpQaAZhqn95UfEjeib1wWEX74L01GG/4SHR5oFqj1a2isdty+j9qLyyoYu/NIaro1c6UjTQIkPBs8AkHyYhmjMz29tzMxoPdu43sJqDzJ+TAuQp4ZXJRFTV0oMKbXxVFWe8/LHoAnDP8rvICZ9HyuhXE9Dz1ZpSCHvdNYRplZRzcxJqqbwUlVTpp65ml6TzKDv/Xe
 JhQWcHTU
 kWiH2C0gl8evEQfugtvKYo/2LHUScKmHC0adW70orhzOP6Ny7/EJ205jNzvajMz6M+UKcUY/kBPhvZ1TVmLnWOQHz/pcnmmwXamzc6GLc8bfTaGnv3uyjIIBCkXrOw5+SGTZSvWGEuCzSLiw0fzl/Suu46grTS8KWuSQ+OtDmPtyLG1fpwVfc7QvYoJqtSk5e9B3tNFmJFhAA+SKfT3bdBsioWEbp7fwyUV8234gEIE8Ve0S2SwFLgR92QhWxovDO83AKsLjDo4QOteaKOZv24qUNl2czwspxelIhhQJPMXMLTJpcFmTsPOzUdljSW2dQabEN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We have removed cpu slab usage from allocation paths. Now remove
do_slab_free() which was freeing objects to the cpu slab when
the object belonged to it. Instead call __slab_free() directly,
which was previously the fallback.

This simplifies kfree_nolock() - when freeing to percpu sheaf
fails, we can call defer_free() directly.

Also remove functions that became unused.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 149 ++++++--------------------------------------------------------
 1 file changed, 13 insertions(+), 136 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 6b1280f7900a..b08e775dc4cb 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3682,29 +3682,6 @@ static inline unsigned int init_tid(int cpu)
 	return cpu;
 }
 
-static inline void note_cmpxchg_failure(const char *n,
-		const struct kmem_cache *s, unsigned long tid)
-{
-#ifdef SLUB_DEBUG_CMPXCHG
-	unsigned long actual_tid = __this_cpu_read(s->cpu_slab->tid);
-
-	pr_info("%s %s: cmpxchg redo ", n, s->name);
-
-	if (IS_ENABLED(CONFIG_PREEMPTION) &&
-	    tid_to_cpu(tid) != tid_to_cpu(actual_tid)) {
-		pr_warn("due to cpu change %d -> %d\n",
-			tid_to_cpu(tid), tid_to_cpu(actual_tid));
-	} else if (tid_to_event(tid) != tid_to_event(actual_tid)) {
-		pr_warn("due to cpu running other code. Event %ld->%ld\n",
-			tid_to_event(tid), tid_to_event(actual_tid));
-	} else {
-		pr_warn("for unknown reason: actual=%lx was=%lx target=%lx\n",
-			actual_tid, tid, next_tid(tid));
-	}
-#endif
-	stat(s, CMPXCHG_DOUBLE_CPU_FAIL);
-}
-
 static void init_kmem_cache_cpus(struct kmem_cache *s)
 {
 #ifdef CONFIG_PREEMPT_RT
@@ -4243,18 +4220,6 @@ static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags)
 	return true;
 }
 
-static inline bool
-__update_cpu_freelist_fast(struct kmem_cache *s,
-			   void *freelist_old, void *freelist_new,
-			   unsigned long tid)
-{
-	struct freelist_tid old = { .freelist = freelist_old, .tid = tid };
-	struct freelist_tid new = { .freelist = freelist_new, .tid = next_tid(tid) };
-
-	return this_cpu_try_cmpxchg_freelist(s->cpu_slab->freelist_tid,
-					     &old.freelist_tid, new.freelist_tid);
-}
-
 /*
  * Get the slab's freelist and do not freeze it.
  *
@@ -6162,99 +6127,6 @@ void defer_free_barrier(void)
 		irq_work_sync(&per_cpu_ptr(&defer_free_objects, cpu)->work);
 }
 
-/*
- * Fastpath with forced inlining to produce a kfree and kmem_cache_free that
- * can perform fastpath freeing without additional function calls.
- *
- * The fastpath is only possible if we are freeing to the current cpu slab
- * of this processor. This typically the case if we have just allocated
- * the item before.
- *
- * If fastpath is not possible then fall back to __slab_free where we deal
- * with all sorts of special processing.
- *
- * Bulk free of a freelist with several objects (all pointing to the
- * same slab) possible by specifying head and tail ptr, plus objects
- * count (cnt). Bulk free indicated by tail pointer being set.
- */
-static __always_inline void do_slab_free(struct kmem_cache *s,
-				struct slab *slab, void *head, void *tail,
-				int cnt, unsigned long addr)
-{
-	/* cnt == 0 signals that it's called from kfree_nolock() */
-	bool allow_spin = cnt;
-	struct kmem_cache_cpu *c;
-	unsigned long tid;
-	void **freelist;
-
-redo:
-	/*
-	 * Determine the currently cpus per cpu slab.
-	 * The cpu may change afterward. However that does not matter since
-	 * data is retrieved via this pointer. If we are on the same cpu
-	 * during the cmpxchg then the free will succeed.
-	 */
-	c = raw_cpu_ptr(s->cpu_slab);
-	tid = READ_ONCE(c->tid);
-
-	/* Same with comment on barrier() in __slab_alloc_node() */
-	barrier();
-
-	if (unlikely(slab != c->slab)) {
-		if (unlikely(!allow_spin)) {
-			/*
-			 * __slab_free() can locklessly cmpxchg16 into a slab,
-			 * but then it might need to take spin_lock
-			 * for further processing.
-			 * Avoid the complexity and simply add to a deferred list.
-			 */
-			defer_free(s, head);
-		} else {
-			__slab_free(s, slab, head, tail, cnt, addr);
-		}
-		return;
-	}
-
-	if (unlikely(!allow_spin)) {
-		if ((in_nmi() || !USE_LOCKLESS_FAST_PATH()) &&
-		    local_lock_is_locked(&s->cpu_slab->lock)) {
-			defer_free(s, head);
-			return;
-		}
-		cnt = 1; /* restore cnt. kfree_nolock() frees one object at a time */
-	}
-
-	if (USE_LOCKLESS_FAST_PATH()) {
-		freelist = READ_ONCE(c->freelist);
-
-		set_freepointer(s, tail, freelist);
-
-		if (unlikely(!__update_cpu_freelist_fast(s, freelist, head, tid))) {
-			note_cmpxchg_failure("slab_free", s, tid);
-			goto redo;
-		}
-	} else {
-		__maybe_unused unsigned long flags = 0;
-
-		/* Update the free list under the local lock */
-		local_lock_cpu_slab(s, flags);
-		c = this_cpu_ptr(s->cpu_slab);
-		if (unlikely(slab != c->slab)) {
-			local_unlock_cpu_slab(s, flags);
-			goto redo;
-		}
-		tid = c->tid;
-		freelist = c->freelist;
-
-		set_freepointer(s, tail, freelist);
-		c->freelist = head;
-		c->tid = next_tid(tid);
-
-		local_unlock_cpu_slab(s, flags);
-	}
-	stat_add(s, FREE_FASTPATH, cnt);
-}
-
 static __fastpath_inline
 void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
 	       unsigned long addr)
@@ -6271,7 +6143,7 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
 			return;
 	}
 
-	do_slab_free(s, slab, object, object, 1, addr);
+	__slab_free(s, slab, object, object, 1, addr);
 }
 
 #ifdef CONFIG_MEMCG
@@ -6280,7 +6152,7 @@ static noinline
 void memcg_alloc_abort_single(struct kmem_cache *s, void *object)
 {
 	if (likely(slab_free_hook(s, object, slab_want_init_on_free(s), false)))
-		do_slab_free(s, virt_to_slab(object), object, object, 1, _RET_IP_);
+		__slab_free(s, virt_to_slab(object), object, object, 1, _RET_IP_);
 }
 #endif
 
@@ -6295,7 +6167,7 @@ void slab_free_bulk(struct kmem_cache *s, struct slab *slab, void *head,
 	 * to remove objects, whose reuse must be delayed.
 	 */
 	if (likely(slab_free_freelist_hook(s, &head, &tail, &cnt)))
-		do_slab_free(s, slab, head, tail, cnt, addr);
+		__slab_free(s, slab, head, tail, cnt, addr);
 }
 
 #ifdef CONFIG_SLUB_RCU_DEBUG
@@ -6321,14 +6193,14 @@ static void slab_free_after_rcu_debug(struct rcu_head *rcu_head)
 
 	/* resume freeing */
 	if (slab_free_hook(s, object, slab_want_init_on_free(s), true))
-		do_slab_free(s, slab, object, object, 1, _THIS_IP_);
+		__slab_free(s, slab, object, object, 1, _THIS_IP_);
 }
 #endif /* CONFIG_SLUB_RCU_DEBUG */
 
 #ifdef CONFIG_KASAN_GENERIC
 void ___cache_free(struct kmem_cache *cache, void *x, unsigned long addr)
 {
-	do_slab_free(cache, virt_to_slab(x), x, x, 1, addr);
+	__slab_free(cache, virt_to_slab(x), x, x, 1, addr);
 }
 #endif
 
@@ -6528,8 +6400,13 @@ void kfree_nolock(const void *object)
 	 * since kasan quarantine takes locks and not supported from NMI.
 	 */
 	kasan_slab_free(s, x, false, false, /* skip quarantine */true);
+	/*
+	 * __slab_free() can locklessly cmpxchg16 into a slab, but then it might
+	 * need to take spin_lock for further processing.
+	 * Avoid the complexity and simply add to a deferred list.
+	 */
 	if (!free_to_pcs(s, x, false))
-		do_slab_free(s, slab, x, x, 0, _RET_IP_);
+		defer_free(s, x);
 }
 EXPORT_SYMBOL_GPL(kfree_nolock);
 
@@ -6955,7 +6832,7 @@ static void __kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
 		if (kfence_free(df.freelist))
 			continue;
 
-		do_slab_free(df.s, df.slab, df.freelist, df.tail, df.cnt,
+		__slab_free(df.s, df.slab, df.freelist, df.tail, df.cnt,
 			     _RET_IP_);
 	} while (likely(size));
 }
@@ -7041,7 +6918,7 @@ __refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
 				cnt++;
 				object = get_freepointer(s, object);
 			} while (object);
-			do_slab_free(s, slab, head, tail, cnt, _RET_IP_);
+			__slab_free(s, slab, head, tail, cnt, _RET_IP_);
 		}
 
 		if (refilled >= max)

-- 
2.52.0


