Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 750F3D3EE9A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:53:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6AC16B040A; Fri, 23 Jan 2026 01:53:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C14FF6B040C; Fri, 23 Jan 2026 01:53:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD7316B040D; Fri, 23 Jan 2026 01:53:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9D6356B040A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:53:50 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5B8AB1A0336
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:53:50 +0000 (UTC)
X-FDA: 84362313420.20.1C63B67
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 56B271C0004
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:53:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pcUtnIn8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ztrrGuUV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pcUtnIn8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ztrrGuUV;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769151228; a=rsa-sha256;
	cv=none;
	b=c4XorAtiqlC9R+hc7B/zd/9in+sfRQXS4/xWi4CUme+lrUxdqVtHbXWVxjmoToUp4G+284
	0dI2LV5BKDl08cvUnH6q8mv/eQmbTwL5CykIQE5QQ2LeuZIOMbRgTQHxmaSzOSNyZYRttl
	fN6E9VN7WL50HJ8BTDa7aVfXoRRKcgI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pcUtnIn8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ztrrGuUV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pcUtnIn8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ztrrGuUV;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769151228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FwnfOtyNNX1UiOQaNmveWBNxfRACVrp0A1Nv9nB3IOs=;
	b=aK9RiAp9Kf6Rb2C9enZoBosybrkDZpRUqJWBzc4hjWPA4C9c47wAwfgW1CIHmE1tbnEmqb
	FUAIFa1n6eVk3PDTxhbQLuexgsjst8nF+5PtfNuhlj+tFCWRRHeEjaMX88BYaicyhFssJi
	LXqXsk1FxaTyjifv8FtJCKxFbft3v9k=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D62C05BCD2;
	Fri, 23 Jan 2026 06:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769151190; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FwnfOtyNNX1UiOQaNmveWBNxfRACVrp0A1Nv9nB3IOs=;
	b=pcUtnIn8l0/P7gVvf2iZydB8O4ssrseTTvfrXLvLR7vhaCTMTJ7Eg4vHCdNDQfbusoAGWh
	Ntl4gQr3gskTMalOxsZl0HLquHbAMrgfQ0crkHzVnqfcEB3yQ+Kb2EBevel4RAC50t92x4
	67yki14xkLJ7D03zUy7YveVvs9kP7Zc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769151190;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FwnfOtyNNX1UiOQaNmveWBNxfRACVrp0A1Nv9nB3IOs=;
	b=ztrrGuUVIg2BUt0B78LnNtZe24bhVib6tTOzFFzA94WdTHBsQcs8PsW2/mkpmt5e0q9QP8
	LZ8vruyiKhXWIOCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769151190; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FwnfOtyNNX1UiOQaNmveWBNxfRACVrp0A1Nv9nB3IOs=;
	b=pcUtnIn8l0/P7gVvf2iZydB8O4ssrseTTvfrXLvLR7vhaCTMTJ7Eg4vHCdNDQfbusoAGWh
	Ntl4gQr3gskTMalOxsZl0HLquHbAMrgfQ0crkHzVnqfcEB3yQ+Kb2EBevel4RAC50t92x4
	67yki14xkLJ7D03zUy7YveVvs9kP7Zc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769151190;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FwnfOtyNNX1UiOQaNmveWBNxfRACVrp0A1Nv9nB3IOs=;
	b=ztrrGuUVIg2BUt0B78LnNtZe24bhVib6tTOzFFzA94WdTHBsQcs8PsW2/mkpmt5e0q9QP8
	LZ8vruyiKhXWIOCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AFC871395E;
	Fri, 23 Jan 2026 06:53:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aEakKtYac2k4YgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 23 Jan 2026 06:53:10 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 23 Jan 2026 07:52:53 +0100
Subject: [PATCH v4 15/22] slab: simplify kmalloc_nolock()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-sheaves-for-all-v4-15-041323d506f7@suse.cz>
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
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 56B271C0004
X-Stat-Signature: qzoef64ghy5n4o8k9i78jm75uc9xdyas
X-HE-Tag: 1769151228-586294
X-HE-Meta: U2FsdGVkX18/zItdgaIAbtH5WJGF+xNkht5Wdy6EGrqsWM83tmf+fCRXI310DmKUCoMFT4QI4HqDh/9sm8W+pdNwpsuBkU1eoWNnJwGgpugMco8S0jW8rt5Sr3vnghxEYFejg/8k3CdEFTx90lrzOhfados0rrQaZFsrMoeUnwI3UG2wRl6cWfFaqnY1P2DKIQxesvZ/tl6UZUW+vSybXGq7QeSImNI+XXJxp4bC9CftxG1GRFl5GQ1SoLhThbEdhOGlQZezJ5zi2LVzufgVz677H2RhAO3zBynxLOp6iUcxpO7ubr5z0F9JBJmBAUDDOJWO0Z5n0EHNtQpRHM2bfgT6UsIuIxRYMoiIBd3tt/zGCYh7z8asS5XmXML+bgSTpq/Bm64Viq2Y6GCaYgoo9CIZ8p8bJR3ewPphx+tW+J7zE5KH+If0iPXdxxNzn/SDqyqDkpEUroQxjnt61PFa5dFfcxQ7BOgtWbdWxOCQwlNKOmQX81mP+JfC4bgXtIpQXtJys6+kJnH1jVMhN44vtreRz4G1DdeYHsm/oWbqUgzCarcKkHKgjHvdO7vdSlIF4g90ja8dv2cFypKMbWVxr2HDcguVC6vkdnZA1AR9QIFJxiKyuWrR0kTXjJNF0cHqptXmYCs2SyuwXxVLyMquyx5spbApJmw5NAGGZehdeUrHyiKPKHLBXZ0TCTgtFtmglOJIVmHih8vCAzT6+UbKuON+/q4D79rhs5EsjiujDVEzDq44njKVKQHdjmFAPr6GNBLyRxfNTQzb+DNPu8zASPEdvT7/fWPSRqteiid2KAMXGQF6GSvkafO8Z3LtJuG0Kom79xBDpAByMrHD3l5i1gv6wz/KbZCwdFY9vAKpYVxv9nkcaJi08Nqf5fW8ighmCtnerpVexrVWktHQrArzL3lvWbn9vaU8KxNh0mbu15AjGOGrAaLZurX4CaCZ+Biz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kmalloc_nolock() implementation has several complications and
restrictions due to SLUB's cpu slab locking, lockless fastpath and
PREEMPT_RT differences. With cpu slab usage removed, we can simplify
things:

- relax the PREEMPT_RT context checks as they were before commit
  99a3e3a1cfc9 ("slab: fix kmalloc_nolock() context check for
  PREEMPT_RT") and also reference the explanation comment in the page
  allocator

- the local_lock_cpu_slab() macros became unused, remove them

- we no longer need to set up lockdep classes on PREEMPT_RT

- we no longer need to annotate ___slab_alloc as NOKPROBE_SYMBOL
  since there's no lockless cpu freelist manipulation anymore

- __slab_alloc_node() can be called from kmalloc_nolock_noprof()
  unconditionally. It can also no longer return EBUSY. But trylock
  failures can still happen so retry with the larger bucket if the
  allocation fails for any reason.

Note that we still need __CMPXCHG_DOUBLE, because while it was removed
we don't use cmpxchg16b on cpu freelist anymore, we still use it on
slab freelist, and the alternative is slab_lock() which can be
interrupted by a nmi. Clarify the comment to mention it specifically.

Acked-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Hao Li <hao.li@linux.dev>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab.h |   1 -
 mm/slub.c | 144 +++++++++++++-------------------------------------------------
 2 files changed, 29 insertions(+), 116 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 37090a7dffb6..47ca9e2cd3be 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -190,7 +190,6 @@ struct kmem_cache_order_objects {
  */
 struct kmem_cache {
 	struct kmem_cache_cpu __percpu *cpu_slab;
-	struct lock_class_key lock_key;
 	struct slub_percpu_sheaves __percpu *cpu_sheaves;
 	/* Used for retrieving partial slabs, etc. */
 	slab_flags_t flags;
diff --git a/mm/slub.c b/mm/slub.c
index 82950c2bc26d..92e75aeeb89b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3690,29 +3690,12 @@ static inline unsigned int init_tid(int cpu)
 
 static void init_kmem_cache_cpus(struct kmem_cache *s)
 {
-#ifdef CONFIG_PREEMPT_RT
-	/*
-	 * Register lockdep key for non-boot kmem caches to avoid
-	 * WARN_ON_ONCE(static_obj(key))) in lockdep_register_key()
-	 */
-	bool finegrain_lockdep = !init_section_contains(s, 1);
-#else
-	/*
-	 * Don't bother with different lockdep classes for each
-	 * kmem_cache, since we only use local_trylock_irqsave().
-	 */
-	bool finegrain_lockdep = false;
-#endif
 	int cpu;
 	struct kmem_cache_cpu *c;
 
-	if (finegrain_lockdep)
-		lockdep_register_key(&s->lock_key);
 	for_each_possible_cpu(cpu) {
 		c = per_cpu_ptr(s->cpu_slab, cpu);
 		local_trylock_init(&c->lock);
-		if (finegrain_lockdep)
-			lockdep_set_class(&c->lock, &s->lock_key);
 		c->tid = init_tid(cpu);
 	}
 }
@@ -3799,47 +3782,6 @@ static void deactivate_slab(struct kmem_cache *s, struct slab *slab,
 	}
 }
 
-/*
- * ___slab_alloc()'s caller is supposed to check if kmem_cache::kmem_cache_cpu::lock
- * can be acquired without a deadlock before invoking the function.
- *
- * Without LOCKDEP we trust the code to be correct. kmalloc_nolock() is
- * using local_lock_is_locked() properly before calling local_lock_cpu_slab(),
- * and kmalloc() is not used in an unsupported context.
- *
- * With LOCKDEP, on PREEMPT_RT lockdep does its checking in local_lock_irqsave().
- * On !PREEMPT_RT we use trylock to avoid false positives in NMI, but
- * lockdep_assert() will catch a bug in case:
- * #1
- * kmalloc() -> ___slab_alloc() -> irqsave -> NMI -> bpf -> kmalloc_nolock()
- * or
- * #2
- * kmalloc() -> ___slab_alloc() -> irqsave -> tracepoint/kprobe -> bpf -> kmalloc_nolock()
- *
- * On PREEMPT_RT an invocation is not possible from IRQ-off or preempt
- * disabled context. The lock will always be acquired and if needed it
- * block and sleep until the lock is available.
- * #1 is possible in !PREEMPT_RT only.
- * #2 is possible in both with a twist that irqsave is replaced with rt_spinlock:
- * kmalloc() -> ___slab_alloc() -> rt_spin_lock(kmem_cache_A) ->
- *    tracepoint/kprobe -> bpf -> kmalloc_nolock() -> rt_spin_lock(kmem_cache_B)
- *
- * local_lock_is_locked() prevents the case kmem_cache_A == kmem_cache_B
- */
-#if defined(CONFIG_PREEMPT_RT) || !defined(CONFIG_LOCKDEP)
-#define local_lock_cpu_slab(s, flags)	\
-	local_lock_irqsave(&(s)->cpu_slab->lock, flags)
-#else
-#define local_lock_cpu_slab(s, flags)					       \
-	do {								       \
-		bool __l = local_trylock_irqsave(&(s)->cpu_slab->lock, flags); \
-		lockdep_assert(__l);					       \
-	} while (0)
-#endif
-
-#define local_unlock_cpu_slab(s, flags)	\
-	local_unlock_irqrestore(&(s)->cpu_slab->lock, flags)
-
 static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
 {
 	unsigned long flags;
@@ -4405,20 +4347,6 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	return object;
 }
 
-/*
- * We disallow kprobes in ___slab_alloc() to prevent reentrance
- *
- * kmalloc() -> ___slab_alloc() -> local_lock_cpu_slab() protected part of
- * ___slab_alloc() manipulating c->freelist -> kprobe -> bpf ->
- * kmalloc_nolock() or kfree_nolock() -> __update_cpu_freelist_fast()
- * manipulating c->freelist without lock.
- *
- * This does not prevent kprobe in functions called from ___slab_alloc() such as
- * local_lock_irqsave() itself, and that is fine, we only need to protect the
- * c->freelist manipulation in ___slab_alloc() itself.
- */
-NOKPROBE_SYMBOL(___slab_alloc);
-
 static __always_inline void *__slab_alloc_node(struct kmem_cache *s,
 		gfp_t gfpflags, int node, unsigned long addr, size_t orig_size)
 {
@@ -5259,13 +5187,13 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
 	if (unlikely(!size))
 		return ZERO_SIZE_PTR;
 
-	if (IS_ENABLED(CONFIG_PREEMPT_RT) && !preemptible())
-		/*
-		 * kmalloc_nolock() in PREEMPT_RT is not supported from
-		 * non-preemptible context because local_lock becomes a
-		 * sleeping lock on RT.
-		 */
+	/*
+	 * See the comment for the same check in
+	 * alloc_frozen_pages_nolock_noprof()
+	 */
+	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
 		return NULL;
+
 retry:
 	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
 		return NULL;
@@ -5274,10 +5202,11 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
 	if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
 		/*
 		 * kmalloc_nolock() is not supported on architectures that
-		 * don't implement cmpxchg16b, but debug caches don't use
-		 * per-cpu slab and per-cpu partial slabs. They rely on
-		 * kmem_cache_node->list_lock, so kmalloc_nolock() can
-		 * attempt to allocate from debug caches by
+		 * don't implement cmpxchg16b and thus need slab_lock()
+		 * which could be preempted by a nmi.
+		 * But debug caches don't use that and only rely on
+		 * kmem_cache_node->list_lock, so kmalloc_nolock() can attempt
+		 * to allocate from debug caches by
 		 * spin_trylock_irqsave(&n->list_lock, ...)
 		 */
 		return NULL;
@@ -5286,42 +5215,31 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
 	if (ret)
 		goto success;
 
-	ret = ERR_PTR(-EBUSY);
-
 	/*
 	 * Do not call slab_alloc_node(), since trylock mode isn't
 	 * compatible with slab_pre_alloc_hook/should_failslab and
 	 * kfence_alloc. Hence call __slab_alloc_node() (at most twice)
 	 * and slab_post_alloc_hook() directly.
-	 *
-	 * In !PREEMPT_RT ___slab_alloc() manipulates (freelist,tid) pair
-	 * in irq saved region. It assumes that the same cpu will not
-	 * __update_cpu_freelist_fast() into the same (freelist,tid) pair.
-	 * Therefore use in_nmi() to check whether particular bucket is in
-	 * irq protected section.
-	 *
-	 * If in_nmi() && local_lock_is_locked(s->cpu_slab) then it means that
-	 * this cpu was interrupted somewhere inside ___slab_alloc() after
-	 * it did local_lock_irqsave(&s->cpu_slab->lock, flags).
-	 * In this case fast path with __update_cpu_freelist_fast() is not safe.
 	 */
-	if (!in_nmi() || !local_lock_is_locked(&s->cpu_slab->lock))
-		ret = __slab_alloc_node(s, alloc_gfp, node, _RET_IP_, size);
+	ret = __slab_alloc_node(s, alloc_gfp, node, _RET_IP_, size);
 
-	if (PTR_ERR(ret) == -EBUSY) {
-		if (can_retry) {
-			/* pick the next kmalloc bucket */
-			size = s->object_size + 1;
-			/*
-			 * Another alternative is to
-			 * if (memcg) alloc_gfp &= ~__GFP_ACCOUNT;
-			 * else if (!memcg) alloc_gfp |= __GFP_ACCOUNT;
-			 * to retry from bucket of the same size.
-			 */
-			can_retry = false;
-			goto retry;
-		}
-		ret = NULL;
+	/*
+	 * It's possible we failed due to trylock as we preempted someone with
+	 * the sheaves locked, and the list_lock is also held by another cpu.
+	 * But it should be rare that multiple kmalloc buckets would have
+	 * sheaves locked, so try a larger one.
+	 */
+	if (!ret && can_retry) {
+		/* pick the next kmalloc bucket */
+		size = s->object_size + 1;
+		/*
+		 * Another alternative is to
+		 * if (memcg) alloc_gfp &= ~__GFP_ACCOUNT;
+		 * else if (!memcg) alloc_gfp |= __GFP_ACCOUNT;
+		 * to retry from bucket of the same size.
+		 */
+		can_retry = false;
+		goto retry;
 	}
 
 success:
@@ -7361,10 +7279,6 @@ void __kmem_cache_release(struct kmem_cache *s)
 {
 	cache_random_seq_destroy(s);
 	pcs_destroy(s);
-#ifdef CONFIG_PREEMPT_RT
-	if (s->cpu_slab)
-		lockdep_unregister_key(&s->lock_key);
-#endif
 	free_percpu(s->cpu_slab);
 	free_kmem_cache_nodes(s);
 }

-- 
2.52.0


