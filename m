Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68574CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 03:42:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A326D6B0213; Sun, 31 May 2026 23:42:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E3826B0246; Sun, 31 May 2026 23:42:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F88D6B0248; Sun, 31 May 2026 23:42:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7EB746B0213
	for <linux-mm@kvack.org>; Sun, 31 May 2026 23:42:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 26D8F161D55
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:42:38 +0000 (UTC)
X-FDA: 84829946796.17.B89C8D7
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf31.hostedemail.com (Postfix) with ESMTP id 984D120002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:42:35 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf31.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780285356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7uTILC6Kk59jBl93WZuBOrFk4uaabwDPnRmdkxjeJwY=;
	b=4niOwuvrjz9/pw2OhJYGOG7B5+WhvFfYwG1SOj/W0hlKMb3YEZVq2PeYZsl0iZLJPqgH4A
	MhXCd5caIi3NQwZ49/KcBVKDNw/g+MaXRFJbhyerxSZVUgEPPJx4n6cD5O4uHyA7291xBn
	e8BNbOMkJjkJDe2udX2OLWqNufTELbE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780285356; a=rsa-sha256;
	cv=none;
	b=QipH5oCC6XU3VEGKQ64nvZXhBZt2Ccd45GYtyJRYfB5b8QznMZpX4M4zTsvS2mTanJtm60
	cQsOh8ZwB98QdIJQ5YwIgJwsOoJVEhvETwM44k/LX1QteV8AAFG0Y6ASK769hCcUkTyq4Q
	sjjZjC5pgOZxrtyMr6yyjbpfbSTy0jc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf31.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 1 Jun 2026 12:42:32 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Mon, 1 Jun 2026 12:42:31 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	baoquan.he@linux.dev, baohua@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com,
	baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v7 0/4] mm: swap: introduce swap tier infrastructure
Message-ID: <ahz/p7oE6vDvKnPx@yjaykim-PowerEdge-T330>
References: <20260527062247.3440692-1-youngjun.park@lge.com>
 <CAKEwX=PkiWdgNtoHberaXafQDoDngw5kycfaXeU22MnrXBoAXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=PkiWdgNtoHberaXafQDoDngw5kycfaXeU22MnrXBoAXQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 984D120002
X-Stat-Signature: tp6ynyn4mp1rqjoc7zrrrx4sksk1yycd
X-Rspamd-Server: rspam06
X-HE-Tag: 1780285355-868763
X-HE-Meta: U2FsdGVkX1+eRoNetcTIBhpOXVxOX6ParKiRQadsHy/FwcalD5001g3HnnbiOTiXOGrSbX1j0hfeiJb8iaKPsRekLBYkSUViTjVvS5P0Nitx4dLeanFxgAMp1poE7FHTdxI4XPWFBDlAqj1rXSZusp2YPeaMY/HUdErZHzcMN0d1RJ3yF2Fza+twRyM8J5/2MYY/PvDnBIeE0uE37m5vNAeIvrk00FooNgnmO3jQlZEs1McRdURjZ1eE5eVnk6Ee40mj62SJPsR1HozIIqpmVbHfLEFiiIcLiTgeSxn91CXTGKKY5D6TP2yfR6qNB3vQc3JiXC1JBNL2V45FRG28JiO9nxMH7vS37vUZqnt3+iUzaJkr1N9CIxskkXZOOCj7dBqdZFyxlsz8rWOzAcs5ywA0i2tNxSUtoNOgK8prdcE93U6Cm0/J2oAn+SgYON1wLSQByHm3Af7oU9/tqMMrAWAzku/HiPtxihl4MEvN8WnqDQt6nsyKOr9JTaoZE3GwAUH5j/RZOoynkm74rNhK3WD7aKOwsdocaYQj9Fgwd1o+jtbnR3YfYBQyR3RBdgclkkqBlEbpC8q1oJpsm34YYGJOSYrUoL3jhNtY2v7qNB4VtxIWSYXaY9xU1IFVKpFoGRf4azfNWwcPipcNjIKM588XVwYK3zEdQiyMNwv4YhHD4R0XcfGpTkFui2roSOMeI4CfJktq6NKxiiJkMM0lzemFS36mOc2NOgLaWgjnazZAuY50WxjdJf7Unm4roVxOfkko+V2iTlMQocwVqsB+xBHhdCVScY0nLukygkMD/gkFXs3PfAIk3m+DwduVCG7mvnE6UqghCFMcjJZyE4k3P5Hvm52WEwGRC/lxzIr0aEipF4NB5ylVfNI+sZuiqt4xubfMQya6PD/ZHBjrrjO52HzkJpfjRPD5teAL2bb7x2pKZb9zpMYcckiKrg9eEkEj9VMs1lFwB+z09OKMFs+
 uKHpT3i+
 Uq53OxOteQFyJND/CaZfFm5/AzM/kyqWhfTwJzFPZ5eN71piPUiiN4i4X/Gy8+JSDrZUdfhHHRD1r4IsmjLDsa3PTfQK9T9QTwXdiHbMh+yH8mddbTedcquiXgo/2PAKRvRoIrneVgKZ8kNIPOVP9HmLjRakVOLpPLFp17s6SYVjLSum0DlOLENQGAS7uEsrLTFzWUXYgL0xa5Q/k+ucj7/5BhNi6a0XpYOznEGxmniTPMvYOoZgwNKP4SdMO8JxssUtjMKncspI0bBx/YgsDLzc4aPZVWxa5V7XLondZDso0wJvwysMs/bYSDsEHUiVkU2bTx/HseidAF98=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 30, 2026 at 11:02:03AM -0700, Nhat Pham wrote:
> On Tue, May 26, 2026 at 11:23 PM Youngjun Park <youngjun.park@lge.com> wrote:
> >
> > This is v7 of the swap tier series addressing review feedback.
> > The cover letter has been simplified.
> >
> > I revisited the design (see Design Rationale). Since our use case
> > fits best with a memcg-based model, the implementation remains
> > within memcg and preserves its resource accounting semantics.
> >
> > Alternatives considered:
> >
> > 1. A separate sysfs interface under swap. (Workable. But, it would still
> >    need to reference memcg paths, and fully decoupling it would add
> >    swap-layer logic to manage memcgs, making it secondary option.)
> >
> > 2. Making the feature non-default.
> >
> > Other interfaces were also reviewed. Aside from sysfs and BPF,
> > the options involve trade-offs and are largely design choices.
> > BPF was excluded due to possible disablement on our embedded
> > platform, though future extension remains possible.
> >
> > Overview
> > ========
> >
> > Swap Tiers group swap devices into performance classes (e.g. NVMe,
> > HDD, Network) and allow per-memcg selection of which tiers to use.
> > This mechanism was suggested by Chris Li.
> >
> > Design Rationale
> > ================
> >
> > Swap tier selection is attached to memcg. A child cgroup may select a
> > subset of the parent's allowed tiers.
> >
> > This
> > - Preserves cgroup inheritance semantics (boundary at parent,
> >   refinement at child).
> > - Reuses memcg, which already groups processes and enforces
> >   hierarchical memory limits.
> > - Aligns with existing memcg swap controls (e.g. swap.max, zswap.writeback)
> > - Avoids introducing a parallel swap control hierarchy.
> >
> > Placing tier control outside memcg (e.g., via BPF, syscalls, or
> > madvise) would allow swap preference to diverge from the memcg
> > hierarchy. Integrating it into memcg keeps the swap policy
> > consistent with existing memory ownership semantics. There are
> > also real use cases built around memcg.
> >
> > In the future, this can be extended to other interfaces to cover
> > additional use cases.
> >
> > I believe a memcg-based swap control is a good starting point
> > before such extensions.
> >
> > Use Cases
> > =========
> >
> > #1: Latency separation (our primary deployment scenario)
> >   [ / ]
> >      |
> >      +-- latency-sensitive workload  (fast tier)
> >      +-- background workload         (slow tier)
> >
> > The parent defines the memory boundary.
> > Each workload selects a swap tier via memory.swap.tiers according to
> > latency requirements.
> >
> > This prevents latency-sensitive workloads from being swapped to
> > slow devices used by background workloads.
> >
> > #2: Per-VM swap selection (Chris Li's deployment scenario)
> >   [ / ]
> >      |
> >      +-- [ Job on VM ]              (tiers: zswap, SSD)
> >             |
> >             +-- [ VMM guest memory ]  (tiers: SSD)
> >
> > The parent (job) has access to both zswap and SSD tiers.
> > The child (VMM guest memory) selects SSD as its swap tier via
> > memory.swap.tiers. In this deployment, swap device selection
> > happens at the child level from the parent's available set.
> >
> > #3: Tier isolation for reduced contention (hypothetical)
> >   [ / ]                    (tiers: A, B)
> >      |
> >      +-- workload X        (tiers: A)
> >      +-- workload Y        (tiers: B)
> >
> > Each child uses a different tier. Since swap paths are separated
> > per tier, synchronization overhead between the two workloads is
> > reduced.
> >
> > Future extension
> > ================
> >
> > #1: Intra-tier distribution policy:
> >   Currently, swap devices with the same priority are allocated in a
> >   round-robin fashion. Per-tier policy files under
> >   /sys/kernel/mm/swap/tiers/ can control how devices within a tier
> >   are selected (e.g. round-robin, weighted).
> >
> > #2: Inter-tier promotion and demotion:
> >   Promotion and demotion apply between tiers, not within a single
> >   tier. The current interface defines only tier assignment; it does
> >   not yet define when or how pages move between tiers. Two triggering
> >   models are possible:
> >
> >   (a) User-triggered: userspace explicitly initiates migration between
> >       tiers (e.g. via a new interface or existing move_pages semantics).
> >   (b) Kernel-triggered: the kernel moves pages between tiers at
> >       appropriate points such as reclaim or refault.
> >
> > #3: Per-VMA, per-process swap and BPF:
> >   Not just for memcg based swap, possible to extend Per-VMA or per-process swap.
> >   Or we can use it as BPF program.
> >
> > Experimentation
> > ===============
> >
> > Tested on our internal platform using NBD as a separate swap tier.
> > Our first production's simple usecase.
> >
> > Without tiers:
> > - No selective control over flash wear
> > - Cannot selectively assign NBD to specific applications
> >
> > Cold launch improvement (preloaded vs. baseline):
> > - App A: 13.17s -> 4.18s (68%)
> > - App B: 5.60s -> 1.12s (80%)
> > - App C: 10.25s -> 2.00s (80%)
> >
> > Performance impact with no tiers configured:
> > <1% regression in kernel build and vm-scalability benchmarks
> >
> 
> Bit late to the party - working on my review backlog right now :)
> 
> I see some parallels with this and memory tiering work being done. One
> future line of work could be considering how to ensure fairness when
> multiple cgroups share same tiers:
> 
> https://lwn.net/Articles/1073400/

Hi Nhat,

Thanks for bringing this up. I took a quick look at the link, and I agree
with your point. We could probably use a similar proposed mechanism (e.g., setting
min/max limits per tier) to handle promotion and demotion in the future.

This also suggests that keeping the swap tier limits inside the memcg
interface is a reasonable approach. It aligns well with such future work.
If it were implemented in other layers (e.g., prctl, sysfs, or BPF), we
would likely have to revisit its integration with memcg someday anyway.

> and occupy all the space in the faster tier(s), pushing the other
> colocated tenants to the slower tier(s). We might need to figure out a
> way to ensure fairness here (while letting cgroups occupy fast swap
> backends opportunistically if there is no resources scarcity).

Agreed. Ensuring fairness will be essential when we eventually expand
the promotion and demotion mechanisms across swap tiers.

Thanks,
Youngjun

