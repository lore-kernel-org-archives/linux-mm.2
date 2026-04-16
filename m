Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AB2DF8A146
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 10:05:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5D9C6B0005; Thu, 16 Apr 2026 06:05:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE7656B0089; Thu, 16 Apr 2026 06:05:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A878F6B008A; Thu, 16 Apr 2026 06:05:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 946C06B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:05:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C97D8C52B
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:05:34 +0000 (UTC)
X-FDA: 84663986988.17.B5B043F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6647D40004
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:05:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TtUb6cwE;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776333932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bZCamC3NO5H6FDh5Ud8NF2G8Xxcja9K0kOjvNKUpyog=;
	b=FOH9Enk3NhFIyy1TcRcSAiZrbHev4SkW4i4tIopbiVQVZGekQQRZIV2XYJ+V8sCWcN8lua
	/o/QnaWbnEYdB0ho11N8NmHEtE4G8+Gx1h5GTE6GIKktvx8g7ve0l6iNIWT9yOHN99DS1t
	j6QAneRxA9gxBpRjJGlTvJSGJSyGoWU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776333932; a=rsa-sha256;
	cv=none;
	b=G9KIGAI+bb/41pRj/mCFC+6yiVrwok6CsDhqnfj/zeJt7+7vzeIInHoS0+tjdMIw0fOp+0
	vDo2dct5BhQZ6d1sZjMmj5h3mPzqBKf05vTAV3n01M26g17ddZDahIO5hoHtty+iLuq0v6
	Io1rkZfeJpuGDqWMtNLbBWNaRgKsBns=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TtUb6cwE;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1422943716;
	Thu, 16 Apr 2026 10:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E33C2BCAF;
	Thu, 16 Apr 2026 10:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776333930;
	bh=8gyZUaLwbT9XK/gBK6i0TFCYB/r+2lYDLzDL4l1s5EY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TtUb6cwEGYRjaC6Xkc6sM5pQaMqh4YiEV4RrNWkD4lGUhKygpzCg9HdZ4FZU8OALs
	 mwEuc2zvhg2Ylp0ZfztSWpQF++fuvLyl1NTwMsOMguQ/U0jPcvsHkfZaat1D1LNXNH
	 SpAq1RTal4xZ39M0h19M5DjXUfF9b3JEAwX6FLPDNU5PvrwDwlPh1BN5QCbNNvZmSF
	 VKyLDMlP1gzdnKTwJfdtjiccm8JU72z7IUq5Do9ZHaPKYimEnBNepUMvRKE0Wnt2tl
	 c6Y1PyOjuM7FFFa+1eluY9U4tiIs78crX2yaRxkaIBfGdAVxHj2xmiwrMzmjnU6YgD
	 zGEECpiJP8Skg==
Message-ID: <af3a7fa9-b368-4ffd-964d-9e4fcba863a8@kernel.org>
Date: Thu, 16 Apr 2026 12:05:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] making nested spin_trylock() work on UP?
Content-Language: en-US
To: "Harry Yoo (Oracle)" <harry@kernel.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 LKML <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>, Linus Torvalds <torvalds@linux-foundation.org>,
 Waiman Long <longman@redhat.com>, Mel Gorman <mgorman@techsingularity.net>,
 Steven Rostedt <rostedt@goodmis.org>,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>, Hao Li
 <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
References: <d762c46b-36f0-471a-b5b4-23c8cf5628ae@suse.cz>
 <aZAWGwZP_Z75YHKt@casper.infradead.org> <ad_cqe51pvr1WaDg@hyeyoo>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <ad_cqe51pvr1WaDg@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: e9re7y8gnxedmf676srqus1xizgnuu1j
X-Rspam-User: 
X-Rspamd-Queue-Id: 6647D40004
X-Rspamd-Server: rspam05
X-HE-Tag: 1776333932-200962
X-HE-Meta: U2FsdGVkX1+dwSL7rqECKWlZfj1sfSzgImLy5ALPvsEzLi+XMpkg4RO0YUN6eODbJNFRFCy9/nw1r8gtdcLmz3IC/8eItL/33bjZ/QF5l9y0wuxlht2H2zzv3uaUrRJHc4W+EDQxRKcpWkZyP3pjMTtXouOm/4EUDh4NIC9s/AH5kNQxJNBlP4muY5E7FpU2dRIOy4o522RscdiZPHqvYE3zEYHPDrqi/4yif+ls1WQD12ptDg6FNoIKDWUuCMQtS86gkp2PSKeAWgwudATLsRkyW/6RkGbdJfL89n1mEWLjKy9zHYazZHTmHZNdlQ34mvo8LU4W+4aMGYyY8GjeQkD2R74ddBh7EIU/tMOgFO+ThmWFDoiZlPu/8FWAPb2Vg/T2eXRIRfsfWA/nKFbiGknRc+//8iWwvXLf81AzZOnBCatEcwGTdyvouu1sX3ocCTMqc33eIW2HTveDWG8xcTWZC+74g/xoGzEXQQlT1Lm0Tdgr2aw0z5X0RHXDu727kdPOpgDi9XBxSOkeU6Pq+7eVMEU9+/qNrPs3edzBR6mKfcNzVv9oD0UB4hY0JsZjxhHGlKCPm9JWEIp+j7LHCKlpgrdW2qht8/fl9eC3kX9iULFWQUBN1dHo+t4A+dZDtVrWHXpAQnXACmq4iV4aG2w8pN3MFaOQLbUT7dI351VxaUT2liBUJ3bbn7i8VoSyEAUE+9ySiCatzp7ZKjxYzXETfTOAEzykS21b7mhXnc0Bm3/eMAV5NvcGfjje7rWkJvocjiysfNIjr58M+hCXCrvZ6VODZ+b+XtdIM3Sbilc+IXRw32VyYUzwXiLR21eOnV1MpoAh3ur02+9Wjmcvxwpujq57Q98TOpbUl+YNhuwyjD9v7UoDk4qankSzinlVhztqXM+WFWwDx80pABRREsuQx47GbJTfCGIP3SJ1aLPGZmukeIZc/wQayKzlCkw8Ey2GvqQJCiVneT05Nh3
 BGjzYiqf
 uQ+qnDZkU4XMVsy38eORCzZcS9XDQXtnken8OE9FbYcDvRNofHY07qmJl6NAOfnu9N/VyFgPk2KHAxPOMXH2raLLEjJbdFWVzMIz8NmkBG4Mj8WnaNtLEwGdbmXrEL/cbR9x+hH1pCYfvUPYKjQJGya04+CaBr4RACXxpGTkpjEkICUC4dswcBn1ht4dBcTDjlui8K36pEn8YsHeyknk7kga1v6cXXUfdV6+6Xv9XSzU+xAHqZjWT0Nr020zkFEqwt3IVBomn0hqxOttibed3bxgjNVJ1m+C04aEZ4U2LI43wds2BeW5J6XkexyRbqYsZexhvyxS5C9JfnRtwE4hYaqX2agD6+kLtrtU5dxAl57J46DmRHFeJuO7ZLq5sGxeQodARADf6S+AoP2QY7nJFGDwwasXde4lKCy2FpYKHYvUjbGgt5e5/H2bYJ0d96pwaDaQXx9AgsFSmNz0pHPvXwK6Ogs0FO8KYtnzxCJrLVcItyhU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/15/26 20:44, Harry Yoo (Oracle) wrote:
> [+Cc Alexei for _nolock() APIs]
> [+Cc SLAB ALLOCATOR and PAGE ALLOCATOR folks]
> 
> I was testing kmalloc_nolock() on UP and I think
> I'm dealt with a similar issue...
> 
> On Sat, Feb 14, 2026 at 06:28:43AM +0000, Matthew Wilcox wrote:
>> On Fri, Feb 13, 2026 at 12:57:43PM +0100, Vlastimil Babka wrote:
>> > The page allocator has been using a locking scheme for its percpu page
>> > caches (pcp) for years now, based on spin_trylock() with no _irqsave() part.
>> > The point is that if we interrupt the locked section, we fail the trylock
>> > and just fallback to something that's more expensive, but it's rare so we
>> > don't need to pay the irqsave cost all the time in the fastpaths.
>> > 
>> > It's similar to but not exactly local_trylock_t (which is also newer anyway)
>> > because in some cases we do lock the pcp of a non-local cpu to flush it, in
>> > a way that's cheaper than IPI or queue_work_on().
>> > 
>> > The complication of this scheme has been UP non-debug spinlock
>> > implementation which assumes spin_trylock() can't fail on UP and has no
>> > state to track it. It just doesn't anticipate this usage scenario.
> 
> This is not the only scenario that doesn't work.
> 
> I was testing "calling {kmalloc,kfree}_nolock() in an NMI handler
> when the CPU is calling kmalloc() & kfree()" [1] scenario.
> 
> Weirdly it's broken (dmesg at the end of the email) on UP since v6.18,
> where {kmalloc,kfree}_nolock() APIs were introduced.
> 
> [1] https://lore.kernel.org/linux-mm/20260406090907.11710-3-harry@kernel.org
> 
>> > So to
>> > work around that we disable IRQs on UP, complicating the implementation.
>> > Also recently we found years old bug in the implementation - see
>> > 038a102535eb ("mm/page_alloc: prevent pcp corruption with SMP=n").
> 
> In the case mentioned above, disabling IRQs doesn't work as the handler
> can be called in an NMI context.

IIRC for the BPF usecases of kmalloc_nolock() think there could be also some
kprobe context somewhere in the locked section.

> {kmalloc,kfree}_nolock()->spin_trylock_irqsave() can succeed on UP
> when the CPU already acquired the spinlock w/ IRQs disabled.
> 
>> > So my question is if we could have spinlock implementation supporting this
>> > nested spin_trylock() usage, or if the UP optimization is still considered
>> > too important to lose it. I was thinking:
>> > 
>> > - remove the UP implementation completely - would it increase the overhead
>> > on SMP=n systems too much and do we still care?
>> > 
>> > - make the non-debug implementation a bit like the debug one so we do have
>> > the 'locked' state (see include/linux/spinlock_up.h and lock->slock). This
>> > also adds some overhead but not as much as the full SMP implementation?
>> 
>> What if we use an atomic_t on UP to simulate there being a spinlock,
>> but only for pcp?  Your demo shows pcp_spin_trylock() continuing to
>> exist, so how about doing something like:
>> 
>> #ifdef CONFIG_SMP
>> #define pcp_spin_trylock(ptr)						\
>> ({									\
>> 	struct per_cpu_pages *__ret;					\
>> 	__ret = pcpu_spin_trylock(struct per_cpu_pages, lock, ptr);	\
>> 	__ret;								\
>> })
>> #else
>> static atomic_t pcp_UP_lock = ATOMIC_INIT(0);
>> #define pcp_spin_trylock(ptr)						\
>> ({									\
>> 	struct per_cpu_pages *__ret = NULL;				\
>> 	if (atomic_try_cmpxchg(&pcp_UP_lock, 0, 1))			\
>> 		__ret = (void *)&pcp_UP_lock;				\
>> 	__ret;								\
>> });
>> #endif
>>
>> (obviously you need pcp_spin_lock/pcp_spin_unlock also defined)
>> 
>> That only costs us 4 extra bytes on UP, rather than 4 bytes per spinlock.
>> And some people still use routers with tiny amounts of memory and a
>> single CPU, or retrocomputers with single CPUs.
> 
> I think we need a special spinlock type that wraps something like this
> and use them when spinlocks can be trylock'd in an unknown context:
> pcp lock, zone lock, per-node partial slab list lock,
> per-node barn lock, etc.

Soudns like a lot of hassle for a niche config (SMP=n) where nobody would
use e.g. bpf tracing anyway. We already have this in kmalloc_nolock():

        /*
         * See the comment for the same check in
         * alloc_frozen_pages_nolock_noprof()
         */
        if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
                return NULL;

It would be trivial to extend this to !SMP. However it wouldn't cover the
kprobe context. Any idea Alexei?

> dmesg here, HEAD is a commit that adds the test case, on top of
> commit af92793e52c3a ("slab: Introduce kmalloc_nolock() and
> kfree_nolock()."):
>> 
>> [    3.658916] ------------[ cut here ]------------
>> [    3.659492] perf: interrupt took too long (5015 > 5005), lowering kernel.perf_event_max_sample_rate to 39000
>> [    3.660800] kernel BUG at mm/slub.c:4382!
> 
> This is BUG_ON(new.frozen) in freeze_slab(), which implies that
> somebody else has taken it off list and froze it already (which should
> have been prevented by the spinlock)
> 
>> [    3.661674] Oops: invalid opcode: 0000 [#1] NOPTI
>> [    3.662427] CPU: 0 UID: 0 PID: 256 Comm: kunit_try_catch Tainted: G            E    N  6.17.0-rc3+ #24 PREEMPTLAZY
>> [    3.663270] Tainted: [E]=UNSIGNED_MODULE, [N]=TEST
>> [    3.663658] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>> [    3.664571] RIP: 0010:___slab_alloc (mm/slub.c:4382 (discriminator 1) mm/slub.c:4599 (discriminator 1)) 
>> [ 3.664949] Code: 4c 24 78 e8 32 cc ff ff 84 c0 0f 85 09 fa ff ff 49 8b 4c 24 28 4d 8b 6c 24 20 48 89 c8 48 89 4c 24 78 48 c1 e8 18 84 c0 79 b3 <0f> 0b 41 8b 46 10 a9 87 04 00 00 74 a1 a8 80 75 24 49 89 dd e9 09
> 


