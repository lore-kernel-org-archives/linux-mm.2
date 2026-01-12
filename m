Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1825CC9EC94
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:17:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E5F86B00AA; Mon, 12 Jan 2026 10:17:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 751DC6B00AB; Mon, 12 Jan 2026 10:17:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63D996B00AC; Mon, 12 Jan 2026 10:17:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 428286B00AA
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:17:38 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D49F68BBE4
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:17:37 +0000 (UTC)
X-FDA: 84323666154.27.307CD0C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id A0F5D40017
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:17:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768231055; a=rsa-sha256;
	cv=none;
	b=ZHCQq/o1jCHavJHbMz/B9m143gW7H7CJ7qmLIHZTHEYSRhQOtYTNVkflUPJaWCaCgGL7Hz
	LMTjyypnbp2HE+n/qgn3y7PsU1gcWFEh5ekTuDnPFoVH9WzvFwZv4U7+QoGXSpnsk604fp
	uAHxZYRtJVrNzRK7kyhl/zFaVhT/toE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768231055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HO3yb5/DTvOVu4gGCODslTusNQMw4vd0+MOyeq3eM4Y=;
	b=Ojrs++W7SadPMCAyqBCjirYdmzYb9Lkcu+pq6Vin3EKy4pKsZ1ESBUhaUWO/HB5059Adc6
	MmpGsCt6VcRFmV1vlgXbNq+G8PgPrdZqObTLE3hssECBh75SX/5ie7lAQTdOuV8FiOZTj/
	UICXrUptUleHTk47YIJFYN9Tb57j+t4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AA0905BCD5;
	Mon, 12 Jan 2026 15:16:58 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8C2473EA63;
	Mon, 12 Jan 2026 15:16:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WDzqIWoQZWn7FgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 12 Jan 2026 15:16:58 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 12 Jan 2026 16:17:05 +0100
Subject: [PATCH RFC v2 11/20] slab: remove the do_slab_free() fastpath
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260112-sheaves-for-all-v2-11-98225cfb50cf@suse.cz>
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
In-Reply-To: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A0F5D40017
X-Stat-Signature: 87p5g4bzq6p3iqiq6bddmfq87osjtxdq
X-Rspam-User: 
X-HE-Tag: 1768231055-892922
X-HE-Meta: U2FsdGVkX19SpP2jT1W6FNu4XGF8sWm16z7i71RrCkf4Fvfk+gBwHnGc4XaNgopm+++iYqVO9KpSMTqvAEbgpxm+uuSx9LXUpcvV+IYeor/3qsgUlVs3pyCtmGgRb2SyhNd18nOLNyF6PFhkpmxMU5C7RrnEGZ2Xrwk2CjTXe/OolhKDxlfbioKNUHaUnbe0O9wrt5wAXa41oqXAznZpaNCEBNXzbDmgDByb4oaulgT+alWRRaZln3U+sdy++zZ++VeCQGkg2LcZEJ5JHb1ym5SDANI6D6BNx+1e6OcxRz5F01Go3DbENrzpYViokeCDv8T+Gp/KGs3IM3wdt2RWAdpeuAlhXVi+pAxga6cxEaQ7D1i4MW7kSUWmlfuLB7E0T6s31mklZ2e/EFMaCnSfaQAgItnDrfFWY+mTIm5E8kI+tNXxwYQRydpV1hEp+dCthK1wEmXBbean8JFaDidyIe9QMbw6c7VaJ2RwqXqmdlQjNQK/mIj+Jjp1nziNwJtjRLZZEjussrJbSbzYoCdvdGEarx6wMtKljJkV1fqBa+CUioIntCMinVS/BJwfITq5OXZGjYDMkP7GFtLTAPiBHkVX457FGTQLCB2LRY8qBnELEvQ3gg+blF0M6unuEYmJNjBhikzWUXYUO4ZaGiYCgY6kKx+XD1D1MHI7dYyTgJR6LyAjsSXw1laTsZX9U2dEaEEdwHhK6xAjvGB5z9aF2XzyExOiGWO+PmPHLbROaW+Uq/0YKb8wfFuYPQ2AagQgQSUn5XKJ13WnCplpdWyCpzmZXeWuWM0vku/wrIQ1jYkQnb94OPii4CAr7a1y5d8Eaf2sLBsDbVrF+RnUm65YAQCehOyhF/eFWlvGzBtCFR+QqjRR6RWZTdDWPzwiEA2YQ3/iRSHd9MGi+21PsTpWCRit6aeC/IIkugVUTvv4AHCJGQYpmt9j6FxO2ob8Tu0rNgIw6Ic+7G0dC8tpfJ4
 GrMihD37
 JrHG5UwULEHLHMgvFO69+SkIgWpapjXO15M/ti3Q1+OEtOCjpMDw2L1f71O0hPaJsLHAnnD/P6A4lvlpj1CmnteMw9IsHtK+A3DXE+kTlIvHqqEY/exIHLs2RQxTqoK45EgmmgoBgJcydBhg=
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

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 149 ++++++--------------------------------------------------------
 1 file changed, 13 insertions(+), 136 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 006f3be1a163..522a7e671a26 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3668,29 +3668,6 @@ static inline unsigned int init_tid(int cpu)
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
@@ -4229,18 +4206,6 @@ static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags)
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
@@ -6158,99 +6123,6 @@ void defer_free_barrier(void)
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
@@ -6267,7 +6139,7 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
 			return;
 	}
 
-	do_slab_free(s, slab, object, object, 1, addr);
+	__slab_free(s, slab, object, object, 1, addr);
 }
 
 #ifdef CONFIG_MEMCG
@@ -6276,7 +6148,7 @@ static noinline
 void memcg_alloc_abort_single(struct kmem_cache *s, void *object)
 {
 	if (likely(slab_free_hook(s, object, slab_want_init_on_free(s), false)))
-		do_slab_free(s, virt_to_slab(object), object, object, 1, _RET_IP_);
+		__slab_free(s, virt_to_slab(object), object, object, 1, _RET_IP_);
 }
 #endif
 
@@ -6291,7 +6163,7 @@ void slab_free_bulk(struct kmem_cache *s, struct slab *slab, void *head,
 	 * to remove objects, whose reuse must be delayed.
 	 */
 	if (likely(slab_free_freelist_hook(s, &head, &tail, &cnt)))
-		do_slab_free(s, slab, head, tail, cnt, addr);
+		__slab_free(s, slab, head, tail, cnt, addr);
 }
 
 #ifdef CONFIG_SLUB_RCU_DEBUG
@@ -6317,14 +6189,14 @@ static void slab_free_after_rcu_debug(struct rcu_head *rcu_head)
 
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
 
@@ -6524,8 +6396,13 @@ void kfree_nolock(const void *object)
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
 
@@ -6951,7 +6828,7 @@ static void __kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
 		if (kfence_free(df.freelist))
 			continue;
 
-		do_slab_free(df.s, df.slab, df.freelist, df.tail, df.cnt,
+		__slab_free(df.s, df.slab, df.freelist, df.tail, df.cnt,
 			     _RET_IP_);
 	} while (likely(size));
 }
@@ -7037,7 +6914,7 @@ __refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
 				cnt++;
 				object = get_freepointer(s, object);
 			} while (object);
-			do_slab_free(s, slab, head, tail, cnt, _RET_IP_);
+			__slab_free(s, slab, head, tail, cnt, _RET_IP_);
 		}
 
 		if (refilled >= max)

-- 
2.52.0


