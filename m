Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B19AD5C0C1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 02:35:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F22546B0089; Mon, 15 Dec 2025 21:35:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF9A26B008A; Mon, 15 Dec 2025 21:35:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF90D6B008C; Mon, 15 Dec 2025 21:35:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CED306B0089
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:35:54 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 765A7B96D6
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:35:54 +0000 (UTC)
X-FDA: 84223769028.07.84E434D
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id 704BC40002
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:35:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="TxI7E3/S";
	spf=pass (imf04.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765852552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=14Qnu6glJrs2grpIMzCNPU4lzsGBr4BJiAY7oS1kvoU=;
	b=pGcSUZdcEze44IND5JzmcEBOs4OT0Zzz3nHWDShYQdvBfZX8JaPkSCaBxZfRmOJQla5fcy
	WpHNdEAvU9F0VycPecPuM3vNwlGxfVGDq+Dgfnx+Dmiet4Hn1fa/qqsLyykAuoWhoQW2wZ
	Wvf7S7IxZmQbsm/Nx/sxfY/zfkOUT2M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="TxI7E3/S";
	spf=pass (imf04.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765852552; a=rsa-sha256;
	cv=none;
	b=ZZFsVU6Oj3nDEB6us9ZlOYg415pIGV/OC+jFkAkpkaoZZKCxZwR7q2/H4TWTbAARSVupsR
	/ftzzwkeY8mJl5YgcOE7ABdgPVtYUE4x2jXCO0a+tPfPVv82rspGR+7rWBAIOmSJNWxDYO
	tSceCN5g7IcK0hPYSZBxlDb7B+DnrF0=
Date: Tue, 16 Dec 2025 10:35:33 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765852550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=14Qnu6glJrs2grpIMzCNPU4lzsGBr4BJiAY7oS1kvoU=;
	b=TxI7E3/S7+4rZCQiKf2z+nSpsjXv+tW2r+ReSrfzDPjxW8ym0KAf3HLlrO8k+fZMNghWQg
	rsDmHDr7bfSLTfChuKT90dtdQvKT0wF57vu4O49CYaMNzdreB68BU/fx8kIu4+OHg+7LnB
	RuSslJFJZoAwtcWSqNWEcv+ik+jJNM4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH RFC 14/19] slab: simplify kmalloc_nolock()
Message-ID: <4ukrk3ziayvxrcfxm2izwrwt3qrmr4fcsefl4n7oodc4t2hxgt@ijk63r4f3rkr>
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
 <20251023-sheaves-for-all-v1-14-6ffa2c9941c0@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251023-sheaves-for-all-v1-14-6ffa2c9941c0@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Stat-Signature: yjhd34y6qxxh49j8atagkr9br6y8yino
X-Rspam-User: 
X-Rspamd-Queue-Id: 704BC40002
X-HE-Tag: 1765852552-151604
X-HE-Meta: U2FsdGVkX187nV/34uq6LHFQfRdS/yQhJaDfzy3y96KAmPw0p9m7y/uHR5aR99tRdAbKsuv8EAoGrzUnM08y2AC3fSa3BlIslr8Zk2+U1ail323JB8WSreJvSoNEpUadFtg71HY5B2Sal7/agqiuDy7jc4Yq2s1MNFFQ2getJntjpdA13RsPy0ggTznNbB0gD+0Q0Oc7XW0XTJgDhgwsIzZGSYUwFhGINIFlprv5ODNY2EzhrfzzehPwVYwxXwEcaBALD9wnaRuT0TaCCng7Ni5DGFRzjqivgMmALRFF3asGNuzwE1DwwubPHVn6IyJQ6AHKSTZjuOZUbTnHIQ5ls17BHjs6B8L4DWpehAumAXjUDK0Sz3uqDGOEhOQ2hqkZtTUwL1OQq93VMbE2FQyi6xHtmbyje4ZU0MIM6+gVI0k9ClsupFJfL5oYZdz1IEFfD0mwA2k3dm+aoaU8oACMNjDUDjksSpA4tE5ftV0SIZEuDPEGkFjk3Ol4uIQ5GLV7cYnTnCVJx8XHWq/ZS3coy84rWGSot8+leFhkyG8rBsaD6rsmFKVJU09ZoP9yPaqlXFTxp817vfY3iR0aE0xhMKZ8KyQC1Kw0/4oTa39FTUxId8xY0ZzetX+3SwujfNRh44MkBN8vHYCOecDAr6S198UVeJoo/LCkPIc3RBhMsa2Kwm00ysLOFG0QAoeoNaHcZdbguArfCgwZvECyG+lDOFgmvTwbrPr7t0RBRkl0nzOOqLNaa6j+Xb7WsoAWrR6Yc1mKjcVa4IGA6XrOZQ+Jf0x184RVTGIqsKfvr5IE/n0jPBI/gNb+TgZ3KLcuVchpm/LE8TMLp5RVG/YUhP/BVZRuKltXmwyiKLa8W9q30NKoy3w/6S9FxDtiKKTRNHdiHB7k0xxizZ/9WZ5xI81C04Eehf+LdgWBP7QywzJyxpYWGEasVXSW1G8hZ8yGK3GhWP7vyPGD9p5dB626Wca
 Hr8393uS
 1vGY89xZGG4HGz+JFi5SLQ3qrpPZI019yEOutEzU3BKqDxlTwM1CTd8sXRATVc1PiffglD2yB6A3Imgqv7osRiiqHhdR/T8gnAb0/lswZEl39IghAePGLvPMGk0pX1lc9WqNyfBQlMNJJfwHD+JX/F6PsyrGIPLo3glS5hulHvFUsXPPjPwc4AV828AAko4lvhUz3z1KtgAhYAdTLQTEZsfrz30CNXCuMcmVaUJgagFf9lsUR5kncMfkzCpHIlMV12sof
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 03:52:36PM +0200, Vlastimil Babka wrote:
> The kmalloc_nolock() implementation has several complications and
> restrictions due to SLUB's cpu slab locking, lockless fastpath and
> PREEMPT_RT differences. With cpu slab usage removed, we can simplify
> things:
> 
> - the local_lock_cpu_slab() macros became unused, remove them
> 
> - we no longer need to set up lockdep classes on PREEMPT_RT
> 
> - we no longer need to annotate ___slab_alloc as NOKPROBE_SYMBOL
>   since there's no lockless cpu freelist manipulation anymore
> 
> - __slab_alloc_node() can be called from kmalloc_nolock_noprof()
>   unconditionally
> 
> Note that we still need __CMPXCHG_DOUBLE, because while it was removed
> we don't use cmpxchg16b on cpu freelist anymore, we still use it on
> slab freelist, and the alternative is slab_lock() which can be
> interrupted by a nmi. Clarify the comment to mention it specifically.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slab.h |   1 -
>  mm/slub.c | 100 ++++----------------------------------------------------------
>  2 files changed, 6 insertions(+), 95 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index b2663cc594f3..7dde0b56a7b0 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -208,7 +208,6 @@ struct kmem_cache_order_objects {
>   */
>  struct kmem_cache {
>  	struct kmem_cache_cpu __percpu *cpu_slab;
> -	struct lock_class_key lock_key;
>  	struct slub_percpu_sheaves __percpu *cpu_sheaves;
>  	/* Used for retrieving partial slabs, etc. */
>  	slab_flags_t flags;
> diff --git a/mm/slub.c b/mm/slub.c
> index 6f5ca26bbb00..6dd7fd153391 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3679,29 +3679,12 @@ static inline unsigned int init_tid(int cpu)
>  
>  static void init_kmem_cache_cpus(struct kmem_cache *s)
>  {
> -#ifdef CONFIG_PREEMPT_RT
> -	/*
> -	 * Register lockdep key for non-boot kmem caches to avoid
> -	 * WARN_ON_ONCE(static_obj(key))) in lockdep_register_key()
> -	 */
> -	bool finegrain_lockdep = !init_section_contains(s, 1);
> -#else
> -	/*
> -	 * Don't bother with different lockdep classes for each
> -	 * kmem_cache, since we only use local_trylock_irqsave().
> -	 */
> -	bool finegrain_lockdep = false;
> -#endif
>  	int cpu;
>  	struct kmem_cache_cpu *c;
>  
> -	if (finegrain_lockdep)
> -		lockdep_register_key(&s->lock_key);
>  	for_each_possible_cpu(cpu) {
>  		c = per_cpu_ptr(s->cpu_slab, cpu);
>  		local_trylock_init(&c->lock);
> -		if (finegrain_lockdep)
> -			lockdep_set_class(&c->lock, &s->lock_key);
>  		c->tid = init_tid(cpu);
>  	}
>  }
> @@ -3792,47 +3775,6 @@ static void deactivate_slab(struct kmem_cache *s, struct slab *slab,
>  	}
>  }
>  
> -/*
> - * ___slab_alloc()'s caller is supposed to check if kmem_cache::kmem_cache_cpu::lock
> - * can be acquired without a deadlock before invoking the function.
> - *
> - * Without LOCKDEP we trust the code to be correct. kmalloc_nolock() is
> - * using local_lock_is_locked() properly before calling local_lock_cpu_slab(),
> - * and kmalloc() is not used in an unsupported context.
> - *
> - * With LOCKDEP, on PREEMPT_RT lockdep does its checking in local_lock_irqsave().
> - * On !PREEMPT_RT we use trylock to avoid false positives in NMI, but
> - * lockdep_assert() will catch a bug in case:
> - * #1
> - * kmalloc() -> ___slab_alloc() -> irqsave -> NMI -> bpf -> kmalloc_nolock()
> - * or
> - * #2
> - * kmalloc() -> ___slab_alloc() -> irqsave -> tracepoint/kprobe -> bpf -> kmalloc_nolock()
> - *
> - * On PREEMPT_RT an invocation is not possible from IRQ-off or preempt
> - * disabled context. The lock will always be acquired and if needed it
> - * block and sleep until the lock is available.
> - * #1 is possible in !PREEMPT_RT only.
> - * #2 is possible in both with a twist that irqsave is replaced with rt_spinlock:
> - * kmalloc() -> ___slab_alloc() -> rt_spin_lock(kmem_cache_A) ->
> - *    tracepoint/kprobe -> bpf -> kmalloc_nolock() -> rt_spin_lock(kmem_cache_B)
> - *
> - * local_lock_is_locked() prevents the case kmem_cache_A == kmem_cache_B
> - */
> -#if defined(CONFIG_PREEMPT_RT) || !defined(CONFIG_LOCKDEP)
> -#define local_lock_cpu_slab(s, flags)	\
> -	local_lock_irqsave(&(s)->cpu_slab->lock, flags)
> -#else
> -#define local_lock_cpu_slab(s, flags)					       \
> -	do {								       \
> -		bool __l = local_trylock_irqsave(&(s)->cpu_slab->lock, flags); \
> -		lockdep_assert(__l);					       \
> -	} while (0)
> -#endif
> -
> -#define local_unlock_cpu_slab(s, flags)	\
> -	local_unlock_irqrestore(&(s)->cpu_slab->lock, flags)
> -
>  static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
>  {
>  	unsigned long flags;
> @@ -4320,19 +4262,6 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
>  
>  	return freelist;
>  }
> -/*
> - * We disallow kprobes in ___slab_alloc() to prevent reentrance
> - *
> - * kmalloc() -> ___slab_alloc() -> local_lock_cpu_slab() protected part of
> - * ___slab_alloc() manipulating c->freelist -> kprobe -> bpf ->
> - * kmalloc_nolock() or kfree_nolock() -> __update_cpu_freelist_fast()
> - * manipulating c->freelist without lock.
> - *
> - * This does not prevent kprobe in functions called from ___slab_alloc() such as
> - * local_lock_irqsave() itself, and that is fine, we only need to protect the
> - * c->freelist manipulation in ___slab_alloc() itself.
> - */
> -NOKPROBE_SYMBOL(___slab_alloc);
>  
>  static __always_inline void *__slab_alloc_node(struct kmem_cache *s,
>  		gfp_t gfpflags, int node, unsigned long addr, size_t orig_size)
> @@ -5201,10 +5130,11 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
>  	if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
>  		/*
>  		 * kmalloc_nolock() is not supported on architectures that
> -		 * don't implement cmpxchg16b, but debug caches don't use
> -		 * per-cpu slab and per-cpu partial slabs. They rely on
> -		 * kmem_cache_node->list_lock, so kmalloc_nolock() can
> -		 * attempt to allocate from debug caches by
> +		 * don't implement cmpxchg16b and thus need slab_lock()
> +		 * which could be preempted by a nmi.
> +		 * But debug caches don't use that and only rely on
> +		 * kmem_cache_node->list_lock, so kmalloc_nolock() can attempt
> +		 * to allocate from debug caches by
>  		 * spin_trylock_irqsave(&n->list_lock, ...)
>  		 */
>  		return NULL;
> @@ -5214,27 +5144,13 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
>  	if (ret)
>  		goto success;
>  
> -	ret = ERR_PTR(-EBUSY);
> -
>  	/*
>  	 * Do not call slab_alloc_node(), since trylock mode isn't
>  	 * compatible with slab_pre_alloc_hook/should_failslab and
>  	 * kfence_alloc. Hence call __slab_alloc_node() (at most twice)
>  	 * and slab_post_alloc_hook() directly.
> -	 *
> -	 * In !PREEMPT_RT ___slab_alloc() manipulates (freelist,tid) pair
> -	 * in irq saved region. It assumes that the same cpu will not
> -	 * __update_cpu_freelist_fast() into the same (freelist,tid) pair.
> -	 * Therefore use in_nmi() to check whether particular bucket is in
> -	 * irq protected section.
> -	 *
> -	 * If in_nmi() && local_lock_is_locked(s->cpu_slab) then it means that
> -	 * this cpu was interrupted somewhere inside ___slab_alloc() after
> -	 * it did local_lock_irqsave(&s->cpu_slab->lock, flags).
> -	 * In this case fast path with __update_cpu_freelist_fast() is not safe.
>  	 */
> -	if (!in_nmi() || !local_lock_is_locked(&s->cpu_slab->lock))
> -		ret = __slab_alloc_node(s, alloc_gfp, node, _RET_IP_, size);
> +	ret = __slab_alloc_node(s, alloc_gfp, node, _RET_IP_, size);
>  
>  	if (PTR_ERR(ret) == -EBUSY) {

After Patch 10 is applied, the logic that returns `EBUSY` has been
removed along with the `s->cpu_slab` logic. As a result, it appears that
`__slab_alloc_node` will no longer return `EBUSY`.

>  		if (can_retry) {
> @@ -7250,10 +7166,6 @@ void __kmem_cache_release(struct kmem_cache *s)
>  {
>  	cache_random_seq_destroy(s);
>  	pcs_destroy(s);
> -#ifdef CONFIG_PREEMPT_RT
> -	if (s->cpu_slab)
> -		lockdep_unregister_key(&s->lock_key);
> -#endif
>  	free_percpu(s->cpu_slab);
>  	free_kmem_cache_nodes(s);
>  }
> 
> -- 
> 2.51.1
> 

