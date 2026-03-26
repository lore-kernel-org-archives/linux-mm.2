Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCCC010A1E7E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 11:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C296E6B0088; Thu, 26 Mar 2026 07:43:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C011A6B0089; Thu, 26 Mar 2026 07:43:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3DD76B008C; Thu, 26 Mar 2026 07:43:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A31236B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:43:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 62D221B9149
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 11:43:57 +0000 (UTC)
X-FDA: 84588030114.19.90CB7CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 997BD140005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 11:43:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JA6ACA81;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774525435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SHgl1jqC1OOHtfkPHWAutDHX5Y+GkXVVzRGYKgkhj3E=;
	b=HiT/nRDXausRXpdsyJJ6tfb2viZ+DYIP+bwqVnBl5zyBkLH+QAq3Qz+OdXXP0fjzJqbFFL
	HIpayWT7xXv68r7l5yrCeB9rAF4shXgzpRGI7pwchuaIZjVKRQ9EwDKjiC3D3i3uZC6+gC
	hj4tk1bYHKTguXnfIxD1zOigDuFKp1M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JA6ACA81;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774525435; a=rsa-sha256;
	cv=none;
	b=XUe1cr31L8n9+ugYy3viUl5xzB49DZ6/yERxuPR9ZLMO8JW5ZOQRjII0aLsBJ/b7I9q5aZ
	BU9S8y6/SdE6Q/tTADNNnnsjy6v2ybAFLW4jTwxLXrc8P8vEx+8EsGesBLebdO4nrQcEu3
	YCkYQ2U2n3g0B5dhC/0XeGsMwRoGksg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B13142DC7;
	Thu, 26 Mar 2026 11:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303A4C2BC87;
	Thu, 26 Mar 2026 11:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774525434;
	bh=YL97lFy5kQhwfmoYidad7USKzO67YzuUg7btoOK2/BM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JA6ACA81RfmbrWjxio4e7C5FDjZFNALezl7n8aWESFgc2wY0MUQTcyrwSVrXFKhWX
	 CBn7G7K3lo61REFN7C7JdBcn10jfbVgFJ3b08Y0oRk3h0Bx8qjhlQvs6jTaTFsK9yS
	 f9k58uCkZYoo+Ra/EJYuyrt5MIO9w6xrxoyIi2NSs5NnLuM2xwDqfUNsb/CdvjZM/d
	 JETtlI3gh27thQHPdxaq1KcPhH5AltUEmbbN0xWXyDJlmH9wlogPe1kl50cb7gVy+t
	 jGq2rizVUdwqDG6eCfK9wfQvvIv1dDX/LWe2Q8vlJtso7M/wUcjnDO2c4IHIAUeg+m
	 GvOfNuKqrbf+g==
Date: Thu, 26 Mar 2026 11:43:46 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: lsf-pc@lists.linux-foundation.org, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Alexei Starovoitov <ast@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Kairui Song <ryncsn@gmail.com>, Matthew Wilcox <willy@infradead.org>, 
	Nhat Pham <nphamcs@gmail.com>, Gregory Price <gourry@gourry.net>, 
	Barry Song <21cnbao@gmail.com>, David Stevens <stevensd@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, David Rientjes <rientjes@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, wangzicheng <wangzicheng@honor.com>, 
	"T . J . Mercier" <tjmercier@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Suren Baghdasaryan <surenb@google.com>, Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Message-ID: <42e26dbb-0180-4408-b8a8-be0cafb75ad9@lucifer.local>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325210637.3704220-1-shakeel.butt@linux.dev>
X-Rspamd-Queue-Id: 997BD140005
X-Stat-Signature: 37ukkgcm7a4thittxd5w81dp9jmzqibs
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774525435-533588
X-HE-Meta: U2FsdGVkX1/z+hnqDMelLahUf7moowIauLO6FQHfoZeMsgkSbdxPLdePINWcvSUCTfWswrptlDWLemxQpnKnJ0KBMfwU3U4FDpo6Ckbbqqse8kJkXTXhN9HR51x2Lr2LUVbEG4W7ybl5PowBXSkN+IUsYH6FxX8ngvPjc1fJ2I6hi4exmUiW9XvDyafBFPOw+xDGzr8m0jc1YqyBPhI5B96rIuGOeAHDZKRkDoHPjEtSVM2JPxn4zTFnPKeihtOOnVl4oCcnpsZW1UwTm0BSr5NXQbJpSrzrtawL0uP6FqCaBlUO92ZsfJJCD59qGntu6+u4K+F8KFiCL8i8h7ukTG7ZyCj5aOUkDxcf6KqJwFcXtXPv4OruxreVFeNnvLtyrJqivR9WPrND/bnJjko8cMDBHCEd9FcL1GlQj3OXjL08js3aITlRJZEfoxRps9jJ8VwJxESye6sHFcnSD8M8fjl65zQ40pI5srlu2bDvbvuPAd2M2tNGwBq2j6PIp48Sp96ReCnmkvkyQMiKOOeYPHY+t+HoTvoAIorPyngvWKD7WFrLaZwMi2Kz1x3eWucInKc+ce9yBKQz4c6v6NZtwwe5X8W5xWqgrrwlIbr6Ktw1wMr7bQVkPk/o4QkuK5xVmFuKiF8Xb9UMyMliQbT1cAIucXZ/1kJgs8REwHojuE4RilXd/tYBu59kUk2QpXL1TuXY0GNGWf5za/AM2N7NL0gARBBEbLqJ8lbC9dcHsXKuTZ6+/7nuNEVYf/U9KYxobKJNmtvvwpcRPiUt/NQXN2ZVKVUNuMmlAjDgC5Bg4AKTPDt8KHKVd9Sohqc2sRq7l1fQ3v8ALN6ic0+Pp0WZ7ZYcq4qXxAteUL/PjCgeF/SxpBdnE8jguwh9/Qxz4O3CGeG/UbmktKqyTlOPdoqN9nfPd/c5IRFBkvndbknC9kX1OQcbchrN5rhWa3zmJUCJ94b1OcBjnMpZ214Nics
 /EyRHX+y
 WEhHAh201TVPwQaKsJ9dxduax56mVP1GbjD+0KN6i3Hs4NFpDaPjXLRd7r0+IGmKJMG/AkZ42Zgogtj4FEJEQzjSw5kNLSz6EaY9fWyWu/GgLS2B3VAb5lSVZxxW5470cDm2Mrp3rV/DZOTV4RfGQrTZx0F7Mo8lxp3U6RIgYhEOO+EOoXxubeenG2z4UrZ/hPiGgIifn54kNohKb3v74kC7UZWqoMQeKH4sHlUgiYyRhaodSPWwpBviWGTwPQ/M767W0pckSnCeetuaWSE06ID0RyUiDoOgJmXHGLLDAf6zc5Uxu2zGAb/3uSQUD1vUc6OvohGKXJ2MoA1vq1a1CCo+YRq291MQ0x0gDIzuxp7WiR1U27v86ubJFyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 02:06:37PM -0700, Shakeel Butt wrote:
> The Problem
> -----------
>
> Memory reclaim in the kernel is a mess. We ship two completely separate
> eviction algorithms -- traditional LRU and MGLRU -- in the same file.

Agreed :)

> mm/vmscan.c is over 8,000 lines. 40% of it is MGLRU-specific code that
> duplicates functionality already present in the traditional path. Every
> bug fix, every optimization, every feature has to be done twice or it
> only works for half the users. This is not sustainable. It has to stop.

Yup.

>
> We should unify both algorithms into a single code path. In this path,
> both algorithms are a set of hooks called from that path. Everyone
> maintains, understands, and evolves a single codebase. Optimizations are
> now evaluated against -- and available to -- both algorithms. And the
> next time someone develops a new LRU algorithm, they can do so in a way
> that does not add churn to existing code.

Yup. I mean it's less churn more duplication which is a lot worse.

>
> How We Got Here
> ---------------
>
> MGLRU brought interesting ideas -- multi-generation aging, page table
> scanning, Bloom filters, spatial lookaround. But we never tried to
> refactor the existing reclaim code or integrate these mechanisms into the
> traditional path. 3,300 lines of code were dumped as a completely
> parallel implementation with a runtime toggle to switch between the two.
> No attempt to evolve the existing code or share mechanisms between the
> two paths -- just a second reclaim system bolted on next to the first.

Yeah, I don't love that we accepted it in this form.

With review far sharper now I would hope in future there'd be pushback in at
least having better separation in future.

>
> To be fair, traditional reclaim is not easy to refactor. It has
> accumulated decades of heuristics trying to work for every workload, and
> touching any of it risks regressions. But difficulty is not an excuse.
> There was no justification for not even trying -- not attempting to
> generalize the existing scanning path, not proposing shared
> abstractions, not offering the new mechanisms as improvements to the code
> that was already there. Hard does not mean impossible, and the cost of
> not trying is what we are living with now.

Yes. Agreed very much so.

>
> The Differences That Matter
> ---------------------------
>
> The two algorithms differ in how they classify pages, detect access, and
> decide what to evict. But most of these differences are not fundamental
> -- they are mechanisms that got trapped inside one implementation when
> they could benefit both. Not making those mechanisms shareable leaves
> potential free performance gains on the table.
>
> Access detection: Traditional LRU walks reverse mappings (RMAP) from the
> page back to its page table entries. MGLRU walks page tables forward,
> scanning process address spaces directly. Neither approach is inherently
> tied to its eviction policy. Page table scanning would benefit
> traditional LRU just as much -- it is cache-friendly, batches updates
> without the LRU lock, and naturally exploits spatial locality. There is
> no reason this should be MGLRU-only.

Right.

>
> Bloom filters and lookaround: MGLRU uses Bloom filters to skip cold
> page table regions and a lookaround optimization to scan adjacent PTEs
> during eviction. These are general-purpose optimizations for any
> scanning path. They are locked inside MGLRU today for no good reason.
>
> Lock-free age updates: MGLRU updates folio age using atomic flag
> operations, avoiding the LRU lock during scanning. Traditional reclaim
> can use the same technique to reduce lock contention.
>
> Page classification: Traditional LRU uses two buckets
> (active/inactive). MGLRU uses four generations with timestamps and
> reference frequency tiers. This is the policy difference --
> how many age buckets and how pages move between them. Every other
> mechanism is shareable.
>
> Both systems already share the core reclaim mechanics -- writeback,
> unmapping, swap, NUMA demotion, and working set tracking. The shareable
> mechanisms listed above should join that common core. What remains after
> that is a thin policy layer -- and that is all that should differ between
> algorithms.

Yeah, this all really speaks to the review simply not being sufficient at
the time.

Given the data given by Mike at [0], it suggests the recent sub-M changes
have made a really big difference to this (I'm genuinely pleasantly
surprised by that!) so hopefully this is something we'll avoid in future.

[0]:https://lore.kernel.org/linux-mm/acJEFArj6uw2Z_2e@kernel.org/

>
> The Fix: One Reclaim, Pluggable and Extensible
> -----------------------------------------------
>
> We need one reclaim system, not two. One code path that everyone
> maintains, everyone tests, and everyone benefits from. But it needs to
> be pluggable as there will always be cases where someone wants some
> customization for their specialized workload or wants to explore some
> new techniques/ideas, and we do not want to get into the current mess
> again.

OK so I was with you up until the pluggable bit :) it's like you're
combining two things here, obviously - unification and pluggability.

I think we should consider both separately.

I also hope that as a result of this those who are involved in unification
gain understanding and some at least are able to perhaps become _active_
co-maintainers/reviewers? As this is a major concern see [1].

[1]:https://lore.kernel.org/linux-mm/aaBsrrmV25FTIkVX@casper.infradead.org/

>
> The unified reclaim must separate mechanism from policy. The mechanisms
> -- writeback, unmapping, swap, NUMA demotion, workingset tracking -- are
> shared today and should stay shared. The policy decisions -- how to
> detect access, how to classify pages, which pages to evict, when to
> protect a page -- are where the two algorithms differ, and where future
> algorithms will differ too. Make those pluggable.

Again you're saying sane things than adding on 'pluggable' :)

Let me address pluggability concerns further down I guess.

>
> This gives us one maintained code path with the flexibility to evolve.

I like 'maintained' here :)

> New ideas get implemented as new policies, not as 3,000-line forks. Good
> mechanisms from MGLRU (page table scanning, Bloom filters, lookaround)
> become shared infrastructure available to any policy. And if someone
> comes up with a better eviction algorithm tomorrow, they plug it in
> without touching the core.
>
> Making reclaim pluggable implies we define it as a set of function
> methods (let's call them reclaim_ops) hooking into a stable codebase we
> rarely modify. We then have two big questions to answer: how do these
> reclaim ops look, and how do we move the existing code to the new model?

Hmm, I'm not so sure about that. But it depends really on who has access to
these operations.

The issue with operations in general is that they eliminate the possibility
of the general code being able to make assumptions about what's happening.

For instance, the .mmap f_op callback meant that we had to account for any
possible thing being done by a driver. You couldn't make assumptions about
vma state, page table state, etc. and of course things happened that we
didn't anticipate, leading to bugs.

So I guess it's less 'no ops' more so 'what do we actually expose to the
ops', 'what assumptions do we bake in about how the ops are used' and very
importantly - 'who gets to populate them'.

If they're _exclusively_ mm-internal then that's fine.

Reclaim is a _very_ _very_ sensitive part of mm. At the point it's being
activated you may be under extreme memory pressure, so a hook even
allocating at all may either fail or enter infinite loops.

We are also very sensitive on things like rmap locks and also, of course, -
timing.

It's not just a perf concern, if we are too slow, we might end up thrashing
when we could otherwise not have.

Also there ends up being a question of how much now-internal functionality
we end up exposing to users.

So we really need a good definition of who we intend should use this stuff,
and how any such interface should be designed.

I mean, if sufficiently abstracted, and with very carefully restricted
constrainst perhaps we could work around a lot of this but we have to tread
_very_ carefully here.

>
> How Do We Get There
> -------------------
>
> Do we merge the two mechanisms feature by feature, or do we prioritize
> moving MGLRU to the pluggable model then follow with LRU once we are
> happy with the result?

Absolutely by a distance the first is preferable. The pluggability is
controversial here and needs careful consideration.

Eliminating redundancy and ensuring broader community maintainership is
easily more important.

>
> Whichever option we choose, we do the work in small, self-contained
> phases. Each phase ships independently, each phase makes the code
> better, each phase is bisectable. No big bang. No disruption. No
> excuses.
>
> Option A: Factor and Merge
>
> MGLRU is already pretty modular. However, we do not know which
> optimizations are actually generic and which ones are only useful for
> MGLRU itself.
>
> Phase 1 -- Factor out just MGLRU into reclaim_ops. We make no functional
> changes to MGLRU. Traditional LRU code is left completely untouched at
> this stage.
>
> Phase 2 -- Merge the two paths one method at a time. Right now the code
> diverts control to MGLRU from the very top of the high-level hooks. We
> instead unify the algorithms starting from the very beginning of LRU and
> deciding what to keep in common code and what to move into a traditional
> LRU path.
>
> Advantages:
> - We do not touch LRU until Phase 2, avoiding churn.
> - Makes it easy to experiment with combining MGLRU features into
>   traditional LRU. We do not actually know which optimizations are
>   useful and which should stay in MGLRU hooks.
>
> Disadvantages:
> - We will not find out whether reclaim_ops exposes the right methods
>   until we merge the paths at the end. We will have to change the ops
>   if it turns out we need a different split. The reclaim_ops API will
>   be private and have a single user so it is not that bad, but it may
>   require additional changes.

Yup this to me renders this totally not an option.

>
> Option B: Merge and Factor
>
> Phase 1 -- Extract MGLRU mechanisms into shared infrastructure. Page
> table scanning, Bloom filter PMD skipping, lookaround, lock-free folio
> age updates. These are independently useful. Make them available to both
> algorithms. Stop hoarding good ideas inside one code path.
>
> Phase 2 -- Collapse the remaining differences. Generalize list
> infrastructure to N classifications (trad=2, MGLRU=4). Unify eviction
> entry points. Common classification/promotion interface. At this point
> the two "algorithms" are thin wrappers over shared code.
>
> Phase 3 -- Define the hook interface. Define reclaim_ops around the
> remaining policy differences. Layer BPF on top (reclaim_ext).
> Traditional LRU and MGLRU become two instances of the same interface.
> Adding a third algorithm means writing a new set of hooks, not forking
> 3,000 lines.
>
> Advantages:
> - We get signals on what should be shared earlier. We know every shared
>   method to be useful because we use it for both algorithms.
> - Can test LRU optimizations on MGLRU early.
>
> Disadvantages:
> - Slower, as we factor out both algorithms and expand reclaim_ops all
>   at once.

Much preferable thanks. I'd rather we deferred the pluggability stuff.

>
> Open Questions
> --------------
>
> - Policy granularity: system-wide, per-node, or per-cgroup?

Well, we have varying levers to pull at least per-cgroup/system-wide.

I wonder if we could add improved documentation on this overall by the way
:) just a thought.

A general reclaim page that mentions cgroup stuff also (can link back to
cgroup pages) so a 'one stop shop' for reclaim/(perhaps also)
reclaim-adjacent writeback, etc. controls could be useful.

> - Mechanism/policy boundary: needs iteration; get it wrong and we
>   either constrain policies or duplicate code.

> - Validation: reclaim quality is hard to measure; we need agreed-upon
>   benchmarks.

Yes, it'd be great to get some standardised set of tests to ensure correct
behaviour, though how we set those up might be tricky.

Perhaps somehow some qemu/libvirt configurations with very tightly
specified environments intended to trigger various reclaim behaviours, with
some specific measurements (bpf, ftrace, procfs, etc.?) to correctly
observe the behaviours in place?

> - Simplicity: the end result must be simpler than what we have today,
>   not more complex. If it is not simpler, we failed.

Yeah that's a nice aim :)

> --
> 2.52.0
>

Thanks, Lorenzo

