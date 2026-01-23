Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 322D1D62602
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:53:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CC2A6B040C; Fri, 23 Jan 2026 01:53:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51E4F6B040E; Fri, 23 Jan 2026 01:53:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38D296B040F; Fri, 23 Jan 2026 01:53:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1E5116B040C
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:53:51 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D604216036F
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:53:50 +0000 (UTC)
X-FDA: 84362313420.08.7D3E302
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id A4DA8140005
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:53:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Z2g9m/rc";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="u/P/pwZ9";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Z2g9m/rc";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="u/P/pwZ9";
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769151228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lz6+CfboTVUMod3u7B664uLDJDmXudIqpgLE6OkuCxw=;
	b=Dmf5C9ltgf9/RfUFuJ/pJZccfzzNPkVKfL1V366RiKCjk00IE2PO0DyIgS/uyB0Zc6TXf0
	EE3ZMvGKL1L6we8mVqQdoal4p0IvBg9ezLKXJXzMemXZ1nbcp32oQFcNJNNSSEjwiFvvq2
	D6svEdCa6nLoZPyhvW3i8XZuLti3EuY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769151228; a=rsa-sha256;
	cv=none;
	b=7LxcacdxgOOkNZzTSr8wHE+PhEhwa+fSXUkmNg2ocEZNxKxRJg/LfVn4NtbMKLVtoyEdV8
	X7Q+dIZEeVRA4I8HXJFboxUnJIm9y7PbhsMsAQn2fo/LnkdnTBrryImSJbjp6/WiMEZXJV
	f5/clH8SBihKcIAwq6d+9+HpBdIMXsY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Z2g9m/rc";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="u/P/pwZ9";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Z2g9m/rc";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="u/P/pwZ9";
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C9F8033772;
	Fri, 23 Jan 2026 06:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769151190; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lz6+CfboTVUMod3u7B664uLDJDmXudIqpgLE6OkuCxw=;
	b=Z2g9m/rcdQXb7ha3+S6UqASNZmOJNr7F30VJDOieU1AGvt+srX1olSuMb2LtLW0vnUEl2Y
	ZN/48UbRACPGgqHBdyew5JdSytha46m9hSDac//pLlIjia4RBo7098CZXcXccCRpXHDP7G
	Vypc5k7Lzp7SYcx4wPLpp+7Ndn5klNk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769151190;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lz6+CfboTVUMod3u7B664uLDJDmXudIqpgLE6OkuCxw=;
	b=u/P/pwZ9ky+Ip6KENw9mi4Y3FkSM4RJB211LC5waIXA/I+Q4De3PBR+9IK/NaIAqDCm8GB
	LJOLnePCSyAPYgCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769151190; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lz6+CfboTVUMod3u7B664uLDJDmXudIqpgLE6OkuCxw=;
	b=Z2g9m/rcdQXb7ha3+S6UqASNZmOJNr7F30VJDOieU1AGvt+srX1olSuMb2LtLW0vnUEl2Y
	ZN/48UbRACPGgqHBdyew5JdSytha46m9hSDac//pLlIjia4RBo7098CZXcXccCRpXHDP7G
	Vypc5k7Lzp7SYcx4wPLpp+7Ndn5klNk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769151190;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lz6+CfboTVUMod3u7B664uLDJDmXudIqpgLE6OkuCxw=;
	b=u/P/pwZ9ky+Ip6KENw9mi4Y3FkSM4RJB211LC5waIXA/I+Q4De3PBR+9IK/NaIAqDCm8GB
	LJOLnePCSyAPYgCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7C249139F7;
	Fri, 23 Jan 2026 06:53:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2McKHtYac2k4YgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 23 Jan 2026 06:53:10 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 23 Jan 2026 07:52:51 +0100
Subject: [PATCH v4 13/22] slab: remove the do_slab_free() fastpath
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-sheaves-for-all-v4-13-041323d506f7@suse.cz>
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
X-Rspamd-Queue-Id: A4DA8140005
X-Stat-Signature: r5g89dykopbcfd8f84e53zzjg87h53ec
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769151228-45005
X-HE-Meta: U2FsdGVkX1/JrXjiJC+o0F1bEivjHTPKvX2VyTxCmj/pJ4je+LlJbv/LlbgMZiQ9JiVawqOyhca+RPrzMQdsarpPxXgFOrNkL4kcG+rR0LYlyg5HBahp/suCVUCiH2om/0VRZQChLfSNAWgK/+fmwzvIQX9uB8izWo/HC/gvC08Yb3IDL9v+yuYKPhSOOF79lQMU/qzyQoh/teFv5OIwGuGMXvcNAGE6TP7KarbDfUROnIcmWieUhDZR520UQjA67dnJ9GgJT35ZkpPQ2D4ZLRImFYaNO8t3rtiFm4/RkJDFH/CWPXUX3cs2XbZCzkbC9UQ1742mmhqYW+2j/rO5PqB6HT5UctGMmyS2kXh5YzA9O4VkeBqfnsMJo2Owp7xY69KUwUcF7xF66pZPGgzl50BWjwcku2hZw8quMZtzyZ67goOvkRiWhr97tXWMIvDhFQAUUmmfryRe4X38MMoFeeR6TF2S3Pa7P00se/N6LdRTypmfFf86IFUf0C5wyinwuOuG1Ijik/kgnqPnHbVMw0vOgUebQveVmjfMjhgXlfvlyc/aToiyEp9EEhwfAl/0/nL8g6rhQY/ZCVNl4m5xkrMtolbmCZVQfj1Q/zZCq3JBZ3fr7D9nmuesI97Hvw6fFjn5sYOLGvR4JocGdoGYt5GHRfOMz4qrGxzGBgr7qpdb9OzfUD1My+Vs2uaxkr9HUyO/fMtwb/pSZpWbnqxjvmaoDtH9kH3Y0kaZXb1OqdNBalef3G0T80+S+FVGjXDk4zgCzZZU2xKC2F2I+3GUWAr11HZWuJnYefblA2Sl1O7vKov+q0KXCvIvZlDfhWHzUY39F1KJMWQaw6f7xTGHJE6dZKDPN7P8n/HVNYxJED0C9nE3GL5mo/RSVrIMUBoJYexj/gw5fXGma2VFDK6yYx9UqJEaB2iB9tkBoupbJb3AdHLY6fS9tQKrWwP2Kq702WzrJw52LuKK76596Gp
 eNFiA6Yf
 IbWDGBSigJYbV0gEB0E5YFivuML+zgU8MCT7gWaYlVYl2ZnuQFxRK4l9wJYYFfcpY2aYLzc7DKLAvEaU6JlMSwGKvT1olCgfGgK0vBURU1P2iGL6psdyMhnucrM/OZACvtejMHnpZatxZRQhU/ABC+Y41eVWvXeuzqaNyUpk/FmsxxISiGX4SrtnAPH6z3IQj0fCTxrdw81IrC3ENvMYGIknYUhIf0ncrwSnAlM/swJaDGnwyzRvHJX2Ewy8BAUDo3dWB5Gjppbm+xAtR8J8Mn0dvbZkKpaVb+m3tXoJQWaMVuvnsWLrah3Gb9wi40IlS9NT9qip2ebfTKaiSyhnKC00QMy/Acd4xTGNo
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

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Hao Li <hao.li@linux.dev>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 149 ++++++--------------------------------------------------------
 1 file changed, 13 insertions(+), 136 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 914b51aedb25..a63a0eed2c55 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3678,29 +3678,6 @@ static inline unsigned int init_tid(int cpu)
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
@@ -4239,18 +4216,6 @@ static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags)
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
@@ -6185,99 +6150,6 @@ void defer_free_barrier(void)
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
@@ -6294,7 +6166,7 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
 			return;
 	}
 
-	do_slab_free(s, slab, object, object, 1, addr);
+	__slab_free(s, slab, object, object, 1, addr);
 }
 
 #ifdef CONFIG_MEMCG
@@ -6303,7 +6175,7 @@ static noinline
 void memcg_alloc_abort_single(struct kmem_cache *s, void *object)
 {
 	if (likely(slab_free_hook(s, object, slab_want_init_on_free(s), false)))
-		do_slab_free(s, virt_to_slab(object), object, object, 1, _RET_IP_);
+		__slab_free(s, virt_to_slab(object), object, object, 1, _RET_IP_);
 }
 #endif
 
@@ -6318,7 +6190,7 @@ void slab_free_bulk(struct kmem_cache *s, struct slab *slab, void *head,
 	 * to remove objects, whose reuse must be delayed.
 	 */
 	if (likely(slab_free_freelist_hook(s, &head, &tail, &cnt)))
-		do_slab_free(s, slab, head, tail, cnt, addr);
+		__slab_free(s, slab, head, tail, cnt, addr);
 }
 
 #ifdef CONFIG_SLUB_RCU_DEBUG
@@ -6344,14 +6216,14 @@ static void slab_free_after_rcu_debug(struct rcu_head *rcu_head)
 
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
 
@@ -6557,7 +6429,12 @@ void kfree_nolock(const void *object)
 			return;
 	}
 
-	do_slab_free(s, slab, x, x, 0, _RET_IP_);
+	/*
+	 * __slab_free() can locklessly cmpxchg16 into a slab, but then it might
+	 * need to take spin_lock for further processing.
+	 * Avoid the complexity and simply add to a deferred list.
+	 */
+	defer_free(s, x);
 }
 EXPORT_SYMBOL_GPL(kfree_nolock);
 
@@ -6983,7 +6860,7 @@ static void __kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
 		if (kfence_free(df.freelist))
 			continue;
 
-		do_slab_free(df.s, df.slab, df.freelist, df.tail, df.cnt,
+		__slab_free(df.s, df.slab, df.freelist, df.tail, df.cnt,
 			     _RET_IP_);
 	} while (likely(size));
 }
@@ -7069,7 +6946,7 @@ __refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
 				cnt++;
 				object = get_freepointer(s, object);
 			} while (object);
-			do_slab_free(s, slab, head, tail, cnt, _RET_IP_);
+			__slab_free(s, slab, head, tail, cnt, _RET_IP_);
 		}
 
 		if (refilled >= max)

-- 
2.52.0


