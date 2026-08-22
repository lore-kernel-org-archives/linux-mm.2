Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A3F1C5B572
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 03:20:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9B336B008C; Fri, 21 Aug 2026 23:20:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A71D96B0092; Fri, 21 Aug 2026 23:20:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 988456B0095; Fri, 21 Aug 2026 23:20:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78C736B008C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 23:20:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5E654802F4
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 03:20:01 +0000 (UTC)
X-FDA: 85127451402.01.ABF7F14
Received: from mta0.migadu.com (out-69.mta0.migadu.com [91.218.175.69])
	by imf03.hostedemail.com (Postfix) with ESMTP id 28B2720002
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 03:19:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="XGph/YaM";
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.69 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787368799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GWPJ+Ubtdu1zKK30inxtIWOeCJAabxBc/dUbXDEnEHg=;
	b=u1jfEyTgzfPZ1R79MZ3Z46uNRFyZix9jGH6/l7CbrBrx4ZhalYtNYGNWL7NN5sIgBwOr1x
	ap8mZUxhla74LgRZC0nOknSyy/NNXdH+jJ27mZDCbjZLICxb3tiuCmFJVPGwYwknkCxPfP
	FifJTkMuPrkB4vYeAW2f+rTJFN9VmvQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="XGph/YaM";
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.69 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787368799;
	b=GXAr36A08VCtvSo0djEsGE+j06u/ZVbn0/+l3DMF8ZU8usfDC7Nf8VWvMEceIMbM9h+umg
	RrDNkli5iiccg+4Uf+vUqCBnI01BG1YYZnzq2+h4Voi523glpide/a8FNvcbqE/CBWMgJ3
	qY9SoDn75XjOEQZ1P2heE/t9RvPiWZY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1lAj0RYynE1f5++3x9dW2tApKBrusbMFAf4fDQ7WuCY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787368797; v=1; x=1787973597;
 b=XGph/YaMg5159DEMOdv6Dag9T3ufhC5fLR1CZw4mpsisQSKm1xueqLoJQZD7SwtB6uEgJJ1n
 xYl73ia+b8aXyPbTtpdD+ex8PN5g49ijPMtc45h2SO5vcxx6aHxiICRMzti/L9jT2lEjh+MQ4wy
 Z5UpAD4LLKw19/FIgBzzc6Sg=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:4c::)
	by smtp.migadu.com with ESMTPS id 6c42c0bd215f903c;
	Sat, 22 Aug 2026 03:19:47 +0000
X-Mizu-Trace-ID: 6c42c0bd215f903c
X-Migadu-Flow: FLOW_OUT
Date: Fri, 21 Aug 2026 20:19:45 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>, 
	Hui Zhu <hui.zhu@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	JP Kobryn <inwardvessel@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, 
	Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Shuah Khan <shuah@kernel.org>, Barry Song <baohua@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v4 1/2] mm/bpf: Add bpf_proactive_reclaim kfuncs
Message-ID: <aojJoHl2uSe1IsfA@linux.dev>
References: <cover.1787205002.git.zhuhui@kylinos.cn>
 <e9b2a34418919f5c3ee2b80bcb4f9d80ce6ec422.1787205002.git.zhuhui@kylinos.cn>
 <CAEf4Bza0KYB+OHpa89K16+ptUQuQDJKyxxNCyDPcgQaO1mtxjg@mail.gmail.com>
 <DKUVJN7NQMAI.2JXLSBOGJTI1W@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DKUVJN7NQMAI.2JXLSBOGJTI1W@gmail.com>
X-Stat-Signature: 5tbd76gcio4pdo4uazggbriw6rjgy91e
X-Rspamd-Queue-Id: 28B2720002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787368798-288922
X-HE-Meta: U2FsdGVkX1+T54h8aWd+XGUI0V15e3LkJ6Rt1JE3kFWxTuDAIChBDKZoKkw0dGaSEsrWjb1QBlb2UiWyCtqvia+2YXu+7jwm2+Yk1CpQMsE4pDkxpcN/CdNswH7bBfWoUBt3Ql021ErBX55n+cAIlnT1zE9OYAEdLyoMQNQDYgkfXmB1SZuMFueTVD28dnoif+7XuUjfICu+jxkz2ETTGVnhUz2LJdoLC3T59H1m3hXg7CqJyUWL/GHWd6RjJagOE9HYPbOOAu+/WZ3Sn9OOd04Cwl70CK08yzBeP4yV3OCUxJekbtFbByZpeOpQy7Can+H6toEDf5fZAGXJmNmZ374WoG2TTKaXuHjVCC9GCfSf8V1xGrrnbKYDYzPLjsC5LElYC4LDd5D++ozyxswrFCfqnD+sAU51pVjyCBAvmVPvt3mvqpMnJesjye+pHRYUiuDy7EryWZ2ZiqtNalDYK6kIm2J3pdIF7BbItBxKRjnxJduezJofXBpASRVtgUa8GHY2Sy814DynhQjvBK08Js7On/OW9uBa99pSyqBJZ5AMDxv0DCJ+K6xPqyogrHNKOFgvgs7h1N3MtbykhHCcgMfLtEpfqv6RpOUpy4ft7cgdL9N2U3wUzKt0mhF5ZvNcWGHr0nT+ZO1tHpoOt+5WVAuFB3U1qVgW9hp9vDhqeph91r8ARX+5TAqsZUjRN/klNedu8rY9zkShqsTijHFfqLund84IAK4BcS825WJSvvDRVOmeO7T184EBVGh1T/yQaHyxAtaKaJqCBlXi++6RLwvSoY82tIOWRkMuvYqLX8seMp/vrjO3oDH7X+oWaQWLqaCEbziaDzU7nSsAQ+AcLw8LDLqWG0aC7gFL6gIgBJ/4tyquKu0XsMHFo8aKhdsjSBV7Kc1+UW+VZNv2+uN5IiunnQELhpPbbw8etPTKsW1G17T4T6CU3AOWNQ1PaJQ7cnzelhlhAeOQSPcxHEJ
 3M4oOLx4
 ZMqIN3VxLi3viDMHbK8zpvk3DGCqHRF6VrAjEDrBUUBJ3qjuoLztE/LWOaZE3lTZSGUxmJzkg3VTGPo25UpFeLoqeFCJuPnrbCSaE23YNlGMgpyepq8cngmyAvd7Wlc5iu2tIZA2HSHg5qzdtTGQcqWn3TuSOF7RiMlihKsN40r2IxgtrMSW9wVsm6N3zfsFgEwMN9RQdtmfXHDL4QNkWUqiVWBZuiJ30bAA1TIq8t6pFJvQEp0PUS4YSygAJe01nyWEwQPst6cEdO54/JqQoDDDdJDowxlmurWkn1ylS/2XXsHhShVLta8A+hO90XGGQ1bbZU1RafFuB/0JegKwTRW3Nw9Q8FBDkxCaA2RRI09tDoSAyYIZxImD5C9939dxoGNh0ihWGeOVx12XyLUrlIfJbdlvTKZPAgjOzxPfOqpGBRnQi52OnKP4Pd0FAd5TLPe8qmwlqOIs5/2pCwWuzUQR+Zz53SzYg73TZV7BfdhUtBBrs0gor27/dPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 09:38:31PM +0200, Kumar Kartikeya Dwivedi wrote:
> On Fri Aug 21, 2026 at 9:12 PM CEST, Andrii Nakryiko wrote:
> > On Wed, Aug 19, 2026 at 11:12 PM Hui Zhu <hui.zhu@linux.dev> wrote:
> >>
> >> From: Hui Zhu <zhuhui@kylinos.cn>
> >>
> >> Expose memcg proactive reclaim to sleepable BPF programs:
> >> unsigned long bpf_proactive_reclaim(memcg, size);
> >> unsigned long bpf_proactive_reclaim_swappiness(memcg, size, swappiness);
> >>
> >> They perform one reclaim pass on @memcg, like a write to memory.reclaim:
> >> swap is allowed, and the anon/file balance follows the cgroup's
> >> swappiness or an explicit override in [MIN_SWAPPINESS, MAX_SWAPPINESS]
> >> plus SWAPPINESS_ANON_ONLY. Both go through a shared helper,
> >> bpf_proactive_reclaim_pages(), which guards against reclaim recursion
> >> and calls try_to_free_mem_cgroup_pages() with GFP_KERNEL and
> >> MEMCG_RECLAIM_MAY_SWAP | MEMCG_RECLAIM_PROACTIVE, the same parameters
> >> user_proactive_reclaim() uses, and unlike memory.reclaim they do not
> >> retry until @size is reached.
> >>
> >> Reclaim must not recurse: try_to_free_mem_cgroup_pages() overwrites
> >> current->reclaim_state on entry and NULLs it on exit, so a nested call
> >> from an in-flight reclaim would corrupt the outer reclaim state (e.g.
> >> MGLRU dereferences current->reclaim_state->mm_walk). Both kfuncs
> >> therefore refuse to reclaim when PF_MEMALLOC is set or
> >> current->reclaim_state is non-NULL. The latter check also closes the
> >> window in try_to_free_mem_cgroup_pages() where reclaim_state is already
> >> installed but PF_MEMALLOC is not: only a tracepoint call sits in
> >> between, and while a sleepable BPF program cannot attach to the
> >> tracepoint itself, it can attach to the generated trace iterator
> >> function (__traceiter_mm_vmscan_memcg_reclaim_begin) via fentry.
> >>
> >> The kfuncs take @size in bytes; the return value is normalized to bytes
> >> as well, matching the byte-based unit of bpf_mem_cgroup_usage() and
> >> bpf_mem_cgroup_page_state(), so callers can mix them without manual
> >> page/byte conversions.
> >>
> >> An out-of-range @swappiness is reported with (unsigned long)-1 instead
> >> of 0, following the convention of bpf_mem_cgroup_vm_events() and
> >> bpf_mem_cgroup_page_state(), as 0 cannot be told apart from a
> >> successful pass that reclaimed nothing.
> >>
> >> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> >> ---
> >>  mm/bpf_memcontrol.c | 118 ++++++++++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 118 insertions(+)
> >>
> >> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> >> index 716df49d7647..dc51868b3acf 100644
> >> --- a/mm/bpf_memcontrol.c
> >> +++ b/mm/bpf_memcontrol.c
> >> @@ -6,6 +6,7 @@
> >>   */
> >>
> >>  #include <linux/memcontrol.h>
> >> +#include <linux/swap.h>
> >>  #include <linux/bpf.h>
> >>
> >>  __bpf_kfunc_start_defs();
> >> @@ -159,6 +160,120 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
> >>         mem_cgroup_flush_stats(memcg);
> >>  }
> >>
> >> +/*
> >> + * Reclaim must not recurse. try_to_free_mem_cgroup_pages() unconditionally
> >> + * overwrites current->reclaim_state on entry and resets it to NULL on exit.
> >> + * So invoking it from an in-flight reclaim would clobber the outer reclaim
> >> + * state and corrupt its accounting.
> >> + *
> >> + * The guards are PF_MEMALLOC and current->reclaim_state. Every reclaim
> >> + * entry point marks the current task with PF_MEMALLOC for the whole
> >> + * reclaim window: try_to_free_mem_cgroup_pages() and __perform_reclaim()
> >> + * do so via memalloc_noreclaim_save(), and kswapd keeps it set for its
> >> + * entire lifetime. A hook inside the reclaim path (shrink_node,
> >> + * shrink_slab, ...) executes in the context of the reclaiming task, where
> >> + * current->flags already carries the flag. The page allocator, the memcg
> >> + * charging path and node_reclaim() rely on the same flag to avoid reclaim
> >> + * recursion.
> >> + *
> >> + * reclaim_state is checked in addition because it is set slightly before
> >> + * PF_MEMALLOC in try_to_free_mem_cgroup_pages(), with only a tracepoint
> >> + * call in between. A sleepable BPF program cannot attach to the tracepoint
> >> + * itself, but it can attach to the generated trace iterator function
> >> + * (__traceiter_mm_vmscan_memcg_reclaim_begin) via fentry, so PF_MEMALLOC
> >> + * alone would leave that window open.
> >> + *
> >> + * Also, PF_MEMALLOC is set in some non-reclaim contexts (e.g. direct compaction
> >> + * and vmalloc), where the kfunc conservatively refuses to reclaim as well.
> >> + */
> >> +static bool bpf_in_reclaim_context(void)
> >> +{
> >> +       return (current->flags & PF_MEMALLOC) || current->reclaim_state;
> >> +}
> >> +
> >> +/*
> >> + * Shared implementation of the proactive reclaim kfuncs: performs one
> >> + * reclaim pass on @memcg with @nr_pages as the goal, allowing swap, and
> >> + * @swappiness as the anon/file balance override (NULL to follow the
> >> + * cgroup's own swappiness setting). Returns the reclaimed amount in
> >> + * bytes, keeping the byte-based unit of the kfuncs' @size argument.
> >> + */
> >> +static unsigned long
> >> +bpf_proactive_reclaim_pages(struct mem_cgroup *memcg, unsigned long nr_pages,
> >> +                           int *swappiness)
> >> +{
> >> +       unsigned long nr_reclaimed;
> >> +
> >> +       if (!nr_pages || unlikely(bpf_in_reclaim_context()))
> >> +               return 0;
> >> +
> >> +       nr_reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages, GFP_KERNEL,
> >> +                                                   MEMCG_RECLAIM_MAY_SWAP |
> >> +                                                   MEMCG_RECLAIM_PROACTIVE,
> >> +                                                   swappiness);
> >> +
> >> +       return nr_reclaimed * PAGE_SIZE;
> >> +}
> >> +
> >> +/**
> >> + * bpf_proactive_reclaim - proactively reclaim memory from a memory
> >> + *                         cgroup
> >> + * @memcg: the target memory cgroup to reclaim from
> >> + * @size:  the amount of memory to reclaim, in bytes
> >> + *
> >> + * Trigger one proactive reclaim pass on @memcg, similar to a write to
> >> + * the memory.reclaim cgroup file: pages are reclaimed according to the
> >> + * cgroup's own swappiness setting and swap is allowed. Note that,
> >> + * unlike memory.reclaim, this does not retry until @size is reached;
> >> + * callers can invoke it again if needed.
> >> + *
> >> + * The reclaim runs with GFP_KERNEL, so this function must not be called
> >> + * from a context that holds a filesystem lock (e.g. an LSM hook invoked
> >> + * with inode_lock held): the reclaim path may enter filesystem shrinkers
> >> + * and deadlock trying to reacquire the lock. Contexts that set
> >> + * PF_MEMALLOC_NOFS/NOIO are handled by the gfp context inheritance.
> >> + *
> >> + * Return:
> >> + *   The amount of memory actually reclaimed, in bytes (rounded to full
> >> + *   pages), or 0 if @size is smaller than a page or the calling task is
> >> + *   already in a reclaim/freeing context (PF_MEMALLOC).
> >> + */
> >> +__bpf_kfunc unsigned long bpf_proactive_reclaim(struct mem_cgroup *memcg,
> >> +                                               unsigned long size)
> >> +{
> >> +       return bpf_proactive_reclaim_pages(memcg, size / PAGE_SIZE, NULL);
> >> +}
> >> +
> >> +/**
> >> + * bpf_proactive_reclaim_swappiness - proactively reclaim memory from a
> >> + *                                    memory cgroup with an explicit
> >> + *                                    swappiness
> >> + * @memcg:      the target memory cgroup to reclaim from
> >> + * @size:       the amount of memory to reclaim, in bytes
> >> + * @swappiness: swappiness override for this reclaim pass
> >> + *
> >> + * Same as bpf_proactive_reclaim(), except that the anon/file reclaim
> >> + * balance is controlled by @swappiness instead of the cgroup's
> >> + * swappiness setting. Valid values are [MIN_SWAPPINESS, MAX_SWAPPINESS]
> >> + * and SWAPPINESS_ANON_ONLY, which restricts reclaim to anon folios.
> >> + *
> >> + * Return:
> >> + *   The amount of memory actually reclaimed, in bytes (rounded to full
> >> + *   pages), (unsigned long)-1 if @swappiness is out of range, or 0 if
> >> + *   @size is smaller than a page or the calling task is already in a
> >> + *   reclaim/freeing context (PF_MEMALLOC).
> >> + */
> >> +__bpf_kfunc unsigned long
> >> +bpf_proactive_reclaim_swappiness(struct mem_cgroup *memcg, unsigned long size,
> >> +                                int swappiness)
> >> +{
> >> +       if (swappiness < MIN_SWAPPINESS || swappiness > SWAPPINESS_ANON_ONLY)
> >> +               return (unsigned long)-1;
> >> +
> >> +       return bpf_proactive_reclaim_pages(memcg, size / PAGE_SIZE,
> >> +                                          &swappiness);
> >> +}
> >
> > I haven't followed previous discussion, so I apologize if this was
> > discussed, but if not, isn't it a bit an overkill to have second
> > variant just to provide optional swappiness? Valid range of swappinees
> > seems to be non-negative [0, 200], that special ANON is 201, so why
> > can't we defined that <0 swappiness just means no swappiness was
> > provided and get away with just one kfunc?
> >
> 
> I think my understanding of Shakeel's suggestion was that we only add one
> bpf_proactive_reclaim() for now, if swappiness parameter is necessary we can
> introduce the second API later. But given it seems Hui wants to add both, I
> think it would make sense to do what Andrii said and just introduce one kfunc
> with the swappiness parameter now.
> 
> But Hui, please wait for Shakeel to comment before respinning again.

Yes let's go with Andri's suggestion.

However Hui, don't respin the series. Let me go through it first. I am not happy
with the amount of text and comments added to the patches.

> 
> >> +
> >>  __bpf_kfunc_end_defs();
> >>
> >>  BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
> >> @@ -172,6 +287,9 @@ BTF_ID_FLAGS(func, bpf_mem_cgroup_usage)
> >>  BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state)
> >>  BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_SLEEPABLE)
> >>
> >> +BTF_ID_FLAGS(func, bpf_proactive_reclaim, KF_SLEEPABLE)
> >> +BTF_ID_FLAGS(func, bpf_proactive_reclaim_swappiness, KF_SLEEPABLE)
> >> +
> >>  BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
> >>
> >>  static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
> >> --
> >> 2.53.0
> >>
> 

