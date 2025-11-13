Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43CFECD5BCE
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 11:45:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A36368E000D; Thu, 13 Nov 2025 06:45:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0DC38E0002; Thu, 13 Nov 2025 06:45:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 923FF8E000D; Thu, 13 Nov 2025 06:45:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7FEF28E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 06:45:30 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4D0211409AF
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:45:30 +0000 (UTC)
X-FDA: 84105403620.26.4F4B4EC
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf09.hostedemail.com (Postfix) with ESMTP id DA3A8140004
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:45:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf09.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763034328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=arFwy/V3Rv/VFcy1vUg8mGhePq1Xa4fv1C+fsBrOObc=;
	b=SExyVpuEZQWcroF/S+BibaHJeOlZaS7EJNcGjOqSltptf+KqCA9mkW5+bKC0ydSP2RgRgk
	AZa18XIb/5729KXtByk1OxxsjDDXfu+g98yGOWwgrpLl24D2GxoOwL3Nr//0fOzji7XjFc
	Uh2aO9ifTzkW9QGswm/EZdaxVhgUezs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf09.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763034328; a=rsa-sha256;
	cv=none;
	b=FddiOBgMjOduGAPWzuUQUnLP/vZbXpEzZ2np4XUlZj90Nc8gjGWj3V29DiDUIqDQ3akcJu
	7FTUPjE4XOvqoRYropzRSBJZgXeikK6x9vpLOOazwUvuGMoKrM66uTJERck3CDOAJKYLmr
	6BkVbDdtH8+wY5U4oERxS6RdR7sge04=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 13 Nov 2025 20:45:22 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 13 Nov 2025 20:45:22 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, chrisl@kernel.org, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com
Subject: Re: [PATCH 1/3] mm, swap: change back to use each swap device's
 percpu cluster
Message-ID: <aRXE0ppned4Kprnz@yjaykim-PowerEdge-T330>
References: <20251109124947.1101520-1-youngjun.park@lge.com>
 <20251109124947.1101520-2-youngjun.park@lge.com>
 <CAMgjq7AomHkGAtpvEt_ZrGK6fLUkWgg0vDGZ0B570QU_oNwRGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMgjq7AomHkGAtpvEt_ZrGK6fLUkWgg0vDGZ0B570QU_oNwRGA@mail.gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DA3A8140004
X-Stat-Signature: 6jatyyu9ar5wss7dmurq37nh6ncescdk
X-Rspam-User: 
X-HE-Tag: 1763034326-773223
X-HE-Meta: U2FsdGVkX1/nJX20Apd1eRSXUPIcUZXZWIE4CRr3qgFCkM9+2rJiwbsDq2rWKbBx6zdSCdsX+5jolgrbVGOMiHv1wWgttNGO9daEzXEBtxLo9lO66HwKgGqZ6d7NoGsi3abicdpRS+5VJu2DYz5Cyc0cm7sSZlicgNho91gUIPrbfhXdi6yJ93Fx8AQXFBBiCGktPfM+mz/FHkxjqw2U7i4lHdd44ljX7xdaq1k8pS257H9kAZtHGEr2aESOfvNoYKr+8E9iTM2f7iDo+R/xuRT6g7CXOQeL2Q394GF3E8f37AZbNt50YgZOc0/8yozk8M84ommfxbttx8sQ98cT+sQOhzTv9kZOwBbGRZ9f1BxxTcHIP9J8vl5DyEMfc3zM/ADgc8OAupg7B8QDuJIMlEiVFg2vjvb8roI37n3CXBZOuF1Qwsl1bLf3AC7vpmvIAf8WxOWD34cLspweCyQ+IU4eV2TN3kipte+9QHa+XcPlMQVirncEaMrvPNmo2wsPgL97WMrvygAnX0o99/gOuxTPTEyaEXtWKk8vfXtg6sbfmrfT5D35e/wSwUmj61N8/XU0vOQeIiLIJEY8Sesl7MaPA8MV4Vp1qGDsKq37gDY4/0Xja5lN/L0vp8kp6r/9KzfcHm32jKFiLS1NUSwlqpglTQ5kfTJ/9/qpxgFMj36D0Wrkx6zB6ZTwpQQ8WNfpBWmS5Y7rzYtyHjI9yb677PiXsIrSLxsCslmYy5Y3m98PO9UQ2uh9pxIFgwRr0r1JRn1OWeWeATU7Jp54tBVj1QdOoFkGaSCHosNloNIoS3khRIco7AqOvV54uraR7WxTq7IGf7S6uqFSys/ahE5xcyInOM8LmmOVTNXVck4uiKXvcO5S/LQqw8f3cZI32VDD6YV6/e5YxobzJvITucClE77+gHQ4MZlPm2JdXsmwj1L2BBkqjzw7N21VtcLC0/oTwzU7BMZG4bMASMOlyq9
 OHCxdyJN
 K+s568RIkP/F2gOSmHsKYT5F7MM0qpa7d0elUqyZpV80aUEE8R6aRhSea5J0NLqmtZI4jI3CsY6g5HnNCpT6b2Puj/mi3NcgvNXT7j06/r/veKXfxnegvhoIm4/ZiOTZtMmT91K3FmkS0OWkVEDtvYtvkBO2CHqDudiPjsmEyM98fJCs79qFqx+bF9YC0RGAKT27G37cyEwI8CkGCK6Khq8nZ7Q/r4y48AUvFRfly5Kcn+3ClXh1i7dH6Ur7Dl7FgzAtbdDbul1KvRWrwHw+2u72b964VeSBTwMyawsBP8/TjybXKSkN6NskW0w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 02:07:59PM +0800, Kairui Song wrote:
> On Sun, Nov 9, 2025 at 8:54 PM Youngjun Park <youngjun.park@lge.com> wrote:
> >
> > This reverts commit 1b7e90020eb7 ("mm, swap: use percpu cluster as
> > allocation fast path").
> >
> > Because in the newly introduced swap tiers, the global percpu cluster
> > will cause two issues:
> > 1) it will cause caching oscillation in the same order of different si
> >    if two different memcg can only be allowed to access different si and
> >    both of them are swapping out.
> > 2) It can cause priority inversion on swap devices. Imagine a case where
> >    there are two memcg, say memcg1 and memcg2. Memcg1 can access si A, B
> >    and A is higher priority device. While memcg2 can only access si B.
> >    Then memcg 2 could write the global percpu cluster with si B, then
> >    memcg1 take si B in fast path even though si A is not exhausted.
> >
> > Hence in order to support swap tier, revert commit 1b7e90020eb7 to use
> > each swap device's percpu cluster.
> >
> > Co-developed-by: Baoquan He <bhe@redhat.com>
> > Suggested-by: Kairui Song <kasong@tencent.com>
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
>
> Hi Youngjun, Baoquan, Thanks for the work on the percpu cluster thing.

Hello Kairui,

> It will be better if you can provide some benchmark result since the
> whole point of global percpu cluster is to improve the performance and
> get rid of the swap slot cache.

After RFC stage,
I will try to prepare benchmark results.

> I'm fine with a small regression but we better be aware of it. And we
> can still figure out some other ways to optimize it. e.g. I remember
> Chris once mentioned an idea of having a per device slot cache, that
> is different from the original slot cache (swap_slot.c): the allocator
> will be aware of it so it will be much cleaner.

Ack, we will work on better optimization.

> > ---
> >  include/linux/swap.h |  13 +++-
> >  mm/swapfile.c        | 151 +++++++++++++------------------------------
> >  2 files changed, 56 insertions(+), 108 deletions(-)
> >
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 38ca3df68716..90fa27bb7796 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -250,10 +250,17 @@ enum {
> >  #endif
> >
> >  /*
> > - * We keep using same cluster for rotational device so IO will be sequential.
> > - * The purpose is to optimize SWAP throughput on these device.
> > + * We assign a cluster to each CPU, so each CPU can allocate swap entry from
> > + * its own cluster and swapout sequentially. The purpose is to optimize swapout
> > + * throughput.
> >   */
> > +struct percpu_cluster {
> > +       local_lock_t lock; /* Protect the percpu_cluster above */
>
> I think you mean "below"?

This comment was originally written this way in the earlier code, and it
seems to refer to the percpu_cluster structure itself rather than the
fields below. But I agree it's a bit ambiguous. I'll just remove this
comment since the structure name is self-explanatory. Or change it to below. :)

> > +       unsigned int next[SWAP_NR_ORDERS]; /* Likely next allocation offset */
> > +};
> > +
> >
> > -/*
> > - * Fast path try to get swap entries with specified order from current
> > - * CPU's swap entry pool (a cluster).
> > - */
> > -static bool swap_alloc_fast(swp_entry_t *entry,
> > -                           int order)
> > -{
> > -       struct swap_cluster_info *ci;
> > -       struct swap_info_struct *si;
> > -       unsigned int offset, found = SWAP_ENTRY_INVALID;
> > -
> > -       /*
> > -        * Once allocated, swap_info_struct will never be completely freed,
> > -        * so checking it's liveness by get_swap_device_info is enough.
> > -        */
> > -       si = this_cpu_read(percpu_swap_cluster.si[order]);
> > -       offset = this_cpu_read(percpu_swap_cluster.offset[order]);
> > -       if (!si || !offset || !get_swap_device_info(si))
> > -               return false;
> > -
> > -       ci = swap_cluster_lock(si, offset);
> > -       if (cluster_is_usable(ci, order)) {
> > -               if (cluster_is_empty(ci))
> > -                       offset = cluster_offset(si, ci);
> > -               found = alloc_swap_scan_cluster(si, ci, offset, order, SWAP_HAS_CACHE);
> > -               if (found)
> > -                       *entry = swp_entry(si->type, found);
> > -       } else {
> > -               swap_cluster_unlock(ci);
> > -       }
> > -
> > -       put_swap_device(si);
> > -       return !!found;
> > -}
> > -
> >  /* Rotate the device and switch to a new cluster */
> > -static bool swap_alloc_slow(swp_entry_t *entry,
> > +static void swap_alloc_entry(swp_entry_t *entry,
> >                             int order)
>
> It seems you also changed the rotation rule here so every allocation
> of any order is causing a swap device rotation? Before 1b7e90020eb7
> every 64 allocation causes a rotation as we had slot cache
> (swap_slot.c). The global cluster makes the rotation happen for every
> cluster so the overhead is even lower on average. But now a per
> allocation rotation seems a rather high overhead and may cause serious
> fragmentation.

Yeah... The rotation rule has indeed changed. I remember the
discussion about rotation behavior:
https://lore.kernel.org/linux-mm/aPc3lmbJEVTXoV6h@yjaykim-PowerEdge-T330/

After that discussion, I've been thinking about the rotation.
Currently, the requeue happens after every priority list traversal, and this logic
is easily affected by changes.
The rotation logic change behavior change is not not mentioned somtimes.
(as you mentioned in commit 1b7e90020eb7).

I'd like to share some ideas and hear your thoughts:

1. Getting rid of the same priority requeue rule
   - same priority devices get priority - 1 or + 1 after requeue
     (more add or remove as needed to handle any overlapping priority appropriately)

2. Requeue only when a new cluster is allocated
   - Instead of requeueing after every priority list traversal, we
     requeue only when a cluster is fully used
   - This might have some performance impact, but the rotation behavior
     would be similar to the existing one (though slightly different due
     to synchronization and logic processing changes)

Going further with these approaches, if we remove the requeue mechanism
entirely, we could potentially reduce synchronization overhead during
plist traversal. (degrade the lock)

I'm curious what do you think about these possibilities?

Youngjun Park

