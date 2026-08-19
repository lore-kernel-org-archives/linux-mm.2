Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E480C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 07:16:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 010B06B0092; Wed, 19 Aug 2026 03:16:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F03B06B0093; Wed, 19 Aug 2026 03:16:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D07CA6B0095; Wed, 19 Aug 2026 03:16:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 656B76B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:16:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC8EC16035D
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:16:48 +0000 (UTC)
X-FDA: 85117161696.05.AFCA83B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5A8BA160008
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:16:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jimDSjAv;
	spf=pass (imf08.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787123807;
	b=SedoonG0LeXrptekmsprfpgcdDdw/xYTHuNiPNQF3u23nqF9uqLp0XRcYqHjbSwEWwxQHH
	PdOqMARtMETlu/ce0r6qIyGBYkl4jL7y5ZByEt4I+Ji46kBTQGW2cuehrbU6OZcO8/ix2f
	uc9Op//vEB7Po61wLGQQNhFeVKtEZyM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jimDSjAv;
	spf=pass (imf08.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787123807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hELGPib/uH3jPFvdTEiadn+HQnK3QW+avnxHHcXWrcE=;
	b=B8Hes0lbdjNBecORHPgV5SgLztPbxVpTnkeHKYQqOBWCeXVbSEM8q7c+CXpx9NAn9IwzD3
	oCUDRlH4mJr8wdBt++u1y0D0RzQsA1deFdXe+1y5UDkMphUCA0th6spHukKX8Z8Syxh8P/
	minETPieD186drC5cURLlPISjn5roTk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EE24160A61;
	Wed, 19 Aug 2026 07:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364661F00A3A;
	Wed, 19 Aug 2026 07:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787123806;
	bh=hELGPib/uH3jPFvdTEiadn+HQnK3QW+avnxHHcXWrcE=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=jimDSjAvJfZoTLMtIC0ThiUVmvCu8Vs72gsJczOMZPS0siLynXOz1CIRuMRugJXJk
	 xX4XP352evKC8B9jSbOHdjlBpfuIUTGaa3gnxqKU3G35O9L92Mh4jIHbRvW0mrAYPf
	 WHdp4ivAfDbKTJ/aZmyqscdNqtnq2yeixGL0pxhTsEpaFR7gjYgR5blkOwLFX8yEpo
	 lNePHXGhZGwVSu8l932rl9ls+MC1R1ELISDQGOqkhGfhjqSB9JDm+vHKsZUYQVxy/f
	 fAHk3JdLq1U+9OMgiVq6Ux4uCaYkLFiZ1qhbmzxo9eaafqokoYQxyZJao+oXkQaA4u
	 ZA2exkXVQtpJA==
Content-Type: multipart/mixed; boundary="===============5324425049345538991=="
MIME-Version: 1.0
Message-Id: <5e8780b47d3ea4ea88bc54e5f3171e54adfb868a694d857d838ce28319598915@mail.kernel.org>
In-Reply-To: <0a2355a169c0900427b6e3c0d73ca6ae1be56f13.1787120833.git.zhuhui@kylinos.cn>
References: <0a2355a169c0900427b6e3c0d73ca6ae1be56f13.1787120833.git.zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v3 1/2] mm/bpf: Add bpf_proactive_reclaim kfuncs
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev,roman.gushchin@linux.dev,inwardvessel@gmail.com,shakeel.butt@linux.dev,akpm@linux-foundation.org,andrii@kernel.org,eddyz87@gmail.com,ihor.solodrai@linux.dev,ast@kernel.org,daniel@iogearbox.net,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,shuah@kernel.org,baohua@kernel.org,geliang@kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-mm@kvack.org,linux-kselftest@vger.kernel.org
Cc: zhuhui@kylinos.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Wed, 19 Aug 2026 07:16:46 +0000 (UTC)
X-Rspamd-Queue-Id: 5A8BA160008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: x3zi4gipd74du8mjrcyyg58e4ejb9cj8
X-HE-Tag: 1787123807-282189
X-HE-Meta: U2FsdGVkX1+ejE8ECwzBmdFLp3S8qxtO2ehlw6r3MaJwJIAEIy8rhiijdGh0azv08SBno+/vzOvBJAoDJ5pSkIGyfqFVWmQfiXhzCILMJBoGw8WIh0PJuOd5b+pPjGkfuQ0D3/cHpNOBy1UiNJ/lNc5LGgTIY8U7yEN/BbrZ+R+3x2syRpItZH6Ba+aa55XR6PvXYYGji6C6CXw+SOyUSjyz4PBuP9MGiUWKUoohvCuPcb9xQqYAdnhiwdWs2EsleKX9rkzrvf5G72znFHhHix9ZkEFNvnzbsK6aP9lEF+t0BnFsV6N75+3IXXBRWlxjjFqPHajSZPMPobe08LpRr7Bti1BGB+YADVNUeOdubahgLBCcegaew59OkpQJiaXinL5qzWgirij/aT6TKjKUYwqPavClH25VZhGID9eYn21gN9tTuQBcHsZqzTWRaUpfSRFWD/NRhX8N1lBRw6iG6JI/UTdmWTvfeOAw6zNwTH6Te5uIDi7+TcPk+BqtNJ7J/Q7JJ22EkRL9AcXuaHQB9BqfM50323nBxrD6f2J4ITJmzN6M9XQyN2wgQV1+W4PIp10TCGrjfD0debItzLSshvrNLPTBr3x8dTfwRSH5LJsCJc7ahtcC4KuD1djIiHsO4SF5rlUiZvhv0TcaDPKObg2lZmXkBBSYTavPxlI8VqdJGOnkZcgB1/SPBfKE9zF3BHPoID5L7HNWszKvu6qD6kQEr5xJz4PfDH+MdFHJmi2L11od2MBaYt1LJ0oACgsBafUPxHbq6oBkhqFtz3fqYRIFvDF21xAM31tIbVETATwXM+N/54iVWmpHaymYhpEqj0vcc1Ax9hpNpe2syLxOzvYDzmRrEylxdorU0l5A3jWlrM7fJjMp1iJW/ZKJ/7W9LPY18jhEBAWvN44m3Q7pONrXut1JVNSOIZevwOING5tT6rh31vSmg8XTsKTUU3PgEjFYK6EernEwg1x9GmN
 8Cex0AJm
 J0Zw/TsuysL2KxNTMbzIm2IAaedthAn43BOIfF7HPsBfho9rxrB1c8Qbami6fr0diWaN73vrCInRuN/UWV3muNdI5qaOM1pkyqGi1X5F8aGSwr1oVwK2gydv+3KTSNVLreirgy55KKRS4LPPn/Cuxy+iLTbtjKOZvnTETQV2lT2TKaHxnfonNXP8GsX1LUGcr7ovOLnsn7UDZ5HBuluEw7hqGWPs/JHydQysS4d6qOkctibg5d0zzwDlvdqV0YBGsKum3uv+fTMhZ54WkmYDFSiH1x4j502btOuXjkhLXkI0MOCz38yFkMQbaX5HCGXqQjctwVW9ylRcNdLJukx2OaKF3RrnpimWCc8M4XxNjGgxVfxDmOm6BGvmjMe9mb8HOwkXwZMogEjOXbvr1HSefls6zqQNYoS7/rGemqnKzTQ2KhPdlsfu530Kcieb2mJlrNvkR1S8W40NgkCRXF5uiyTcJQuB1NfJmvHDZ+Hskt5u24Q+zCVHQW2GZJR/W3fpR+BvunYSqHl0rsCCaD8Rw0J7uSVWgt3TUhyLL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============5324425049345538991==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index 716df49d7647..b0a0d4c55dc4 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c
> @@ -6,6 +6,7 @@
>   */
>
>  #include <linux/memcontrol.h>
> +#include <linux/swap.h>
>  #include <linux/bpf.h>
>
>  __bpf_kfunc_start_defs();

[ ... ]

> +/*
> + * Reclaim must not recurse. try_to_free_mem_cgroup_pages() unconditionally
> + * overwrites current->reclaim_state on entry and resets it to NULL on exit.
> + * So invoking it from an in-flight reclaim would clobber the outer reclaim
> + * state and corrupt its accounting.
> + *
> + * The guard is PF_MEMALLOC. Every reclaim entry point marks the current
> + * task with it for the whole reclaim window: try_to_free_mem_cgroup_pages()
> + * and __perform_reclaim() do so via memalloc_noreclaim_save(), and kswapd
> + * keeps it set for its entire lifetime. A hook inside the reclaim path
> + * (shrink_node, shrink_slab, ...) executes in the context of the
> + * reclaiming task, where current->flags already carries the flag. The page
> + * allocator, the memcg charging path and node_reclaim() rely on the same
> + * flag to avoid reclaim recursion.
> + *
> + * In try_to_free_mem_cgroup_pages(), reclaim_state is set slightly before
> + * PF_MEMALLOC, with only a tracepoint in between, which a sleepable BPF
> + * program cannot attach to.
> + * Also, PF_MEMALLOC is set in some non-reclaim contexts (e.g. direct compaction
> + * and vmalloc), where the kfunc conservatively refuses to reclaim as well.
> + */
> +static bool bpf_in_reclaim_context(void)
> +{
> +	return current->flags & PF_MEMALLOC;
> +}
> +
> +/*
> + * Shared implementation of the proactive reclaim kfuncs: performs one
> + * reclaim pass on @memcg with @nr_pages as the goal, allowing swap, and
> + * @swappiness as the anon/file balance override (NULL to follow the
> + * cgroup's own swappiness setting).
> + */
> +static unsigned long
> +bpf_proactive_reclaim_pages(struct mem_cgroup *memcg, unsigned long nr_pages,
> +			    int *swappiness)
> +{
> +	if (!nr_pages || unlikely(bpf_in_reclaim_context()))
> +		return 0;
> +
> +	return try_to_free_mem_cgroup_pages(memcg, nr_pages, GFP_KERNEL,
> +					    MEMCG_RECLAIM_MAY_SWAP |
> +					    MEMCG_RECLAIM_PROACTIVE,
> +					    swappiness);
> +}

Does the PF_MEMALLOC-only guard fully close the recursion window?

The comment states "In try_to_free_mem_cgroup_pages(), reclaim_state
is set slightly before PF_MEMALLOC, with only a tracepoint in between,
which a sleepable BPF program cannot attach to."

The restriction on tracepoint attachment is accurate - sleepable BPF
programs cannot attach to non-faultable tracepoints like
mm_vmscan_memcg_reclaim_begin. But the tracepoint dispatcher itself is
attachable:

Looking at mm/vmscan.c:try_to_free_mem_cgroup_pages():

    set_task_reclaim_state(current, &sc.reclaim_state);
    trace_mm_vmscan_memcg_reclaim_begin(sc.gfp_mask, 0, memcg);
    noreclaim_flag = memalloc_noreclaim_save();

The trace_mm_vmscan_memcg_reclaim_begin() macro expands to a call to
__traceiter_mm_vmscan_memcg_reclaim_begin(), which is a plain global
function generated by __DEFINE_TRACE_EXT(). It carries no notrace
attribute, mm/Makefile doesn't remove ftrace flags from vmscan.o, and
it isn't in btf_id_deny, making it fentry-attachable.

can_be_sleepable() in kernel/bpf/verifier.c returns true for
BPF_TRACE_FENTRY, and check_attach_btf_id() applies no further
restriction beyond btf_id_deny. So a sleepable fentry program on
__traceiter_mm_vmscan_memcg_reclaim_begin would be accepted by the
verifier.

Since the kfuncs are registered for BPF_PROG_TYPE_UNSPEC, such a program
can call bpf_proactive_reclaim().

In that window, current->reclaim_state points to the outer reclaim's
state but PF_MEMALLOC is still clear, so bpf_in_reclaim_context()
returns false. The nested try_to_free_mem_cgroup_pages() would then:

  - Trip the WARN_ON_ONCE(rs && task->reclaim_state) in
    set_task_reclaim_state()

  - On exit, execute set_task_reclaim_state(current, NULL), leaving
    current->reclaim_state == NULL for the rest of the outer reclaim

The outer reclaim continues and under MGLRU, shrink_lruvec() calls
lru_gen_shrink_lruvec() which calls set_mm_walk() in mm/vmscan.c:

    struct lru_gen_mm_walk *walk = current->reclaim_state->mm_walk;
    ...
    current->reclaim_state->mm_walk = walk;

evict_folios() has the same pattern. Result: NULL pointer dereference.

On the classic LRU path the outcome would be lost reclaim accounting in
flush_reclaim_state(), plus the WARN_ON_ONCE on the outer exit.

Would testing current->reclaim_state in addition to PF_MEMALLOC close
this window?

> +/**
> + * bpf_proactive_reclaim - proactively reclaim memory from a memory
> + *                         cgroup
> + * @memcg: the target memory cgroup to reclaim from
> + * @size:  the amount of memory to reclaim, in bytes
> + *
> + * Trigger one proactive reclaim pass on @memcg, similar to a write to
> + * the memory.reclaim cgroup file: pages are reclaimed according to the
> + * cgroup's own swappiness setting and swap is allowed. Note that,
> + * unlike memory.reclaim, this does not retry until @size is reached;
> + * callers can invoke it again if needed.
> + *
> + * Return:
> + *   The number of pages actually reclaimed, or 0 if @size is smaller
> + *   than a page or the calling task is already in a reclaim/freeing
> + *   context (PF_MEMALLOC).
> + */
> +__bpf_kfunc unsigned long bpf_proactive_reclaim(struct mem_cgroup *memcg,
> +						unsigned long size)
> +{
> +	return bpf_proactive_reclaim_pages(memcg, size / PAGE_SIZE, NULL);
> +}

The kfunc takes @size in bytes but returns a count in pages
(try_to_free_mem_cgroup_pages() returns nr_reclaimed in pages). Input
and output use different units.

Every other kfunc in this file normalizes to bytes:
bpf_mem_cgroup_usage() returns page_counter_read(&memcg->memory) *
PAGE_SIZE and is documented as "The current memory cgroup size in
bytes"; bpf_mem_cgroup_page_state() documents "The output is in bytes."

A natural BPF loop like:

    usage = bpf_mem_cgroup_usage(memcg);
    while (usage > target)
            usage -= bpf_proactive_reclaim(memcg, usage - target);

would be off by PAGE_SIZE. The kdoc does say "The number of pages
actually reclaimed", but since this is UAPI-visible the unit asymmetry
is worth resolving before it freezes. Would it make sense to return
nr * PAGE_SIZE, or take @nr_pages instead?

> +/**
> + * bpf_proactive_reclaim_swappiness - proactively reclaim memory from a
> + *                                    memory cgroup with an explicit
> + *                                    swappiness
> + * @memcg:      the target memory cgroup to reclaim from
> + * @size:       the amount of memory to reclaim, in bytes
> + * @swappiness: swappiness override for this reclaim pass
> + *
> + * Same as bpf_proactive_reclaim(), except that the anon/file reclaim
> + * balance is controlled by @swappiness instead of the cgroup's
> + * swappiness setting. Valid values are [MIN_SWAPPINESS, MAX_SWAPPINESS]
> + * and SWAPPINESS_ANON_ONLY, which restricts reclaim to anon folios.
> + *
> + * Return:
> + *   The number of pages actually reclaimed, or 0 if @size is smaller
> + *   than a page, @swappiness is out of range, or the calling task is
> + *   already in a reclaim/freeing context (PF_MEMALLOC).
> + */
> +__bpf_kfunc unsigned long
> +bpf_proactive_reclaim_swappiness(struct mem_cgroup *memcg, unsigned long size,
> +				 int swappiness)
> +{
> +	if (swappiness < MIN_SWAPPINESS || swappiness > SWAPPINESS_ANON_ONLY)
> +		return 0;
> +
> +	return bpf_proactive_reclaim_pages(memcg, size / PAGE_SIZE,
> +					   &swappiness);
> +}

An out-of-range @swappiness returns 0, the same value as a successful
call that reclaimed nothing, and the same as a call refused due to
PF_MEMALLOC context. A BPF program cannot distinguish a programming
error from legitimate lack of progress.

The sibling kfuncs in this file use a distinguishable sentinel for
invalid parameters:

    bpf_mem_cgroup_vm_events():   if (unlikely(!memcg_vm_event_item_valid(event)))
                                      return (unsigned long)-1;

    bpf_mem_cgroup_page_state():  if (unlikely(!memcg_stat_item_valid(idx)))
                                      return (unsigned long)-1;

The userspace equivalent also rejects rather than ignores:
user_proactive_reclaim() returns -EINVAL for out-of-range swappiness in
mm/vmscan.c. Would returning (unsigned long)-1 here match both this
file's convention and the write(2) behaviour of memory.reclaim?

> +__bpf_kfunc_end_defs();
>
>  BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
> @@ -172,6 +270,9 @@ BTF_ID_FLAGS(func, bpf_mem_cgroup_usage)
>  BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state)
>  BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_SLEEPABLE)
>
> +BTF_ID_FLAGS(func, bpf_proactive_reclaim, KF_SLEEPABLE)
> +BTF_ID_FLAGS(func, bpf_proactive_reclaim_swappiness, KF_SLEEPABLE)
> +
>  BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
>
>  static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/32224943030
--===============5324425049345538991==--

