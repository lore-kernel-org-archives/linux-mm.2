Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20C65C624CF
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 11:03:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A1D96B0129; Tue,  1 Sep 2026 07:03:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 379AE6B012A; Tue,  1 Sep 2026 07:03:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B6CB6B012B; Tue,  1 Sep 2026 07:03:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E17B6B0129
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:03:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9652E16037B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:03:31 +0000 (UTC)
X-FDA: 85164907422.10.8996787
Received: from mta0.migadu.com (out-161.mta0.migadu.com [91.218.175.161])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7F4554000A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:03:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="q1TwJ2B/";
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.161 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788260609;
	b=uu6PyUCy0nDlHaVFXKIP/bVTXm7NZuYQdtF90x1aVPihlNfcawaCCPndEBXRoKZwpwWNkU
	x9xAZUytsMZLGtgX1gsxM+13wW9LGr2AgY2E51GcImeauAmKpM+mENxXhQh8sql3F2hjq5
	86Wh6RF5YmTQ866bbIG64Klwnflxj78=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="q1TwJ2B/";
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.161 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788260609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=duxTEeZ4LiqSB6Gs8qxr7VVyL8nQ+0huJFSffDQbF/E=;
	b=xgmGJ+eQZtp1VcwQDAZqsE+No3AM9XvEAGFXNwqt1ua1eHwt7Hl65P/RnBuHDIWLRNKMdo
	q/zuTwfBPkO6nOZfyFFGssetozjns79tfYrWx6sfDqNY9xJMJuorvuZz+ZBD09zTMZlRK6
	JVPnYpJLou5x0oXjHHUSqF0Obj2DBDI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=10BPoXSvNRKLCIsLAtRnqoN5RbDX+QNvv2CGSYHUBm0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788260607; v=1; x=1788865407;
 b=q1TwJ2B/gtG7qMg2uDlPvX6TgHNrLWXkAT6esVqTXUSybuEaj1lZKh1FfXsUlQPc01vqcrn/
 C6qkzRgGrAft4rNC/o3+0CHA1ZDZEdGwzVqYIKlc8kWwSrieXuAmZIJB6QhZv8maIH5QvdpJIT4
 0dluMRk7RcSP79nAsVuQ04L4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id e5b3d4cddfa1846c;
	Tue, 01 Sep 2026 11:03:27 +0000
X-Mizu-Trace-ID: e5b3d4cddfa1846c
X-Migadu-Flow: FLOW_OUT
Date: Tue, 1 Sep 2026 19:03:25 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Kairui Song <ryncsn@gmail.com>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com,
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev, david@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] xswap: extendable swap device backed by zswap
Message-ID: <apaw_XmqnEcY8sv7@MiWiFi-R3L-srv>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
 <apVNB2FRTFMDtvGP@KASONG-MC4>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <apVNB2FRTFMDtvGP@KASONG-MC4>
X-Rspam-User: 
X-Stat-Signature: tjwwdewcci6pi6yntmuzn7ybp9pu4eum
X-Rspamd-Queue-Id: 7F4554000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1788260609-816277
X-HE-Meta: U2FsdGVkX1/D6f5zk2TI6rN4CNWgXI4xohbrt2rajB49VtkI2FiWTZzMCpMXGCp75Fdb4icacp4WQKNVUwROHyvXAnrnoN/cLYeGoGbKXTFrLr9VfvSZneKC3+Soel1nV+m5Ft2fK6zZ1VeCXYTXZryjZl41pwtDZ7nzVJgXViChPf5H8qSRMf/q343vh/DRrvNo1wbBW44k0J3h59QMzoz9aIIo/0fkmiFFJdUsjjKMqzMD6AGOHl31VTKePaj8tWkPaZOrgG5wC5AWtyDsJBMxDbDT7fUGp+KSyZ17XBaOJbXNu90Vuc14m7uQ+hWsLgs5WtRPxl0G7W0fR/kgo7NMlvCqSzbnqorVxdfr/XnL3YzBBWnaXHR6kx4eoqyRGHV4r2lfS0BEkQMV5xBH/e1nv8bVrEath92VV8vNyWKGUnXOo/0C076dqeDXR3ZD/I9mg3JNI9cDruNxKYyEr7hdWqw0730PKbGk3KR7O1Umell/qtWMFgSjbuiPFth693YLSYMG/ozIv94bZx1K3YK8/WD+mweEsB0dSoNbj3rlWNKY5kcp/7dSTZTT4EUi9eHNqlL+PawDrT/XLkSgT05HgX8EmNkuKTwXAcbfY3GDPcVnZ78rmT754P98/f4PqmWeyYCSbel3ILdAP/eR1pqTEzeP3/BE24m2P1WI6Q5BFkxzQt8b2pndVgwUMCtKC9t1loTbKF0cm+pOokHYn/vUptP2YUXQyPvWw7IUTew9lXQyK+UvRa78ZzZI7RJiFNvShbNn+2VK7YPYvPCRDauu2SIN3NIPRVUkJ/kyBigIcQV3FThI7r4TOaAwaLLy+UAu1OnEdI8Y0l+VIfTabG/mopWiT8pVAE5raqTlU2snUeuqfpuGbdSaIYDu2246xxPlmoXA8XTemq/8M+aVMwqRldDjeLlrHktytgxGtO5CjNrBgoy+P30pzS5U0+rKKY7uwAm9EuYFYJMRpZK
 0u9Wadyq
 eEpK5bl07dfKmQjmMvqsCvRsOqg8+VpxFuiXHGX5xdhqhs6nwyIcjjw2HTmglGJRVlqceVp9MnzSqkHp5t3lcpKwlPHxOnET1MbiHz+NVJ/zak2u9ICA6g5hGxw4MAC8qNFe92Fj+UZ6EArBUbuKIQe5nZ/5BZ6922HgbQj2k+q4r6U2CG6ZdIVkAhZNi0J/zKtuKuiqR83ziJbXUVIKLrQjGDmVD+rcqYpNUoVqLMLi+0aiubZAx6fntoi35LpWDSA1f71+peroX9sO3osGItvRxs8KOHdE5HMAuoi8a2jioo4t86oe8Igznx/lp0zYHz5xEISN6G925Ph6lCSq+CjTGNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/01/26 at 01:54am, Kairui Song wrote:
> On Thu, Aug 27, 2026 at 05:44:50PM +0800, Baoquan He wrote:
> > xswap is an extendable swap device with no backing storage. Swapped-out
> > pages live only in zswap, so the device wastes no disk space and its
> > size is independent of any physical device.
> > 
> > xswap decouples PTE swap entries from physical backing storage. The
> > cluster_info array is backed by a sparse vmalloc (VM_SPARSE) area that is
> > grown and shrunk on demand:
> > 
> > - Grow: when cluster allocation runs out of free clusters and the device
> >   is below its ceiling, more physical pages are mapped into the VM_SPARSE
> >   area and their clusters are added to the free list.
> > 
> > - Shrink: when contiguous free clusters accumulate at the tail of the
> >   mapped range (tracked in O(1) via nr_free_tail), they are unmapped and
> >   the backing pages freed.  Shrink is deferred to a workqueue to avoid
> >   lock recursion.
> > 
> 
> Hi Baoquan,
> 
> I didn't check too many details on how the implementation in previous
> RFC until now, After looking at it, using VM_SPARSE to setup the cluster
> info area is a really smart idea, really good job!
> 
> I think many info are missing in the cover letter though so I wasn't
> sure how this grow and shrink works from the description, after
> checking the code, it looks much cleaner to me now, correct me
> if I'm wrong:
> 
> Every xswap device will have a huge and fixed "hard limit"
> (si->max and si->nr_clusters_max), and practically can be considered
> large enough to hold any workload, and won't change once swapon
> is done.
> 
> The actually data (si->cluster_info) of xswap device is completely
> sparse and dynamic using VM_SPARSE, and so we don't need to change
> any existing routine. It grow/alloc and shrink/free automatically by
> the kernel, limited or driven by a "soft limit" (si->nr_clusters
> and si->pages) which you can modify using the interface below.

Thanks a lot for careful checking, and you are quite right about the
mechanism and details.

> 
> Once concern is that the "hard limit" is now the total RAM size. Isn't
> that actually a bit small? Will be better if that one is tunable too?
> With a parameter, and before swap on, as the hard limit is hard to
> adjust once swapon is done. Any thing limiting this?

Chris and I talked about this, we both think the total RAM size is a
good hard limit. Because xswap is similar with zswap/zram in essence by
compressing memory content to save memory. So the real limit is the
zswap pool, not the slot count. In fact it's never able to utilize the
total system RAM, right? Making it larger than system RAM is
meaningless.

Memory hotplug is a case in which system RAM can be enlarged during
system running, while that can be taken into account later as a enhanced
feature if it's really wanted.

> 
> And I think these details better be mentioned bit more too.

Sure, I can put these thoughts into cover letter or patch log for
reference.

> 
> > A per-device ceiling (nr_clusters) bounds growth and is adjustable at
> > runtime via debugfs.
> > 
> > Interface:
> > 
> >   /sys/kernel/mm/xswap/create           write "<percent> [<prio>]" to
> >                                         create a device; percent is a
> >                                         percent of RAM (0 for the default),
> >                                         prio is an optional swap priority
> >                                         (default DEF_SWAP_PRIO)
> 
> With what I have read so far, the mandatory percent limit here is kind of
> strange, even with 0 as default. Why not make both args optional and just
> let it grow without any limit by default? It looks more "fully dynamic"
> that way.

I'd like to clarify why we default to a soft limit rather than "no limit".

The soft limit is the administrator's deliberate size choice, similar
to how zram requires an explicit size. On a multi-TB system the
cluster_info array is not free, so planning how much of it to allow is a
real decision. The current behavior is: grow up to the soft limit as usage
demands, then stay there. We do not shrink on idle, and shrink only happens
when the admin lowers the limit. So there is no grow/shrink oscillation in
normal operation.

A default of "no limit / fully dynamic" will instead let the device grow
without restriction under memory pressure. While allocating cluster_info
pages exactly when memory is scarce, relying on shrink to reclaim afterwards,
which is the oscillation we want to avoid. So we'll make both create arguments
optional, but the default will be a sensible ceiling rather than unbounded.

> 
> >   /sys/kernel/mm/xswap/destroy          write a swap type to tear down
> >                                         a device
> >   /sys/kernel/debug/xswap/type<N>_cluster_limit
> >                                         read/write the per-device
> >                                         cluster ceiling
> 
> Having a lot of type<N>_cluster_limit in a seperate debug path
> looks a bit odd to me too, and the _cluster_limit doesn't look
> like a debug interface, we will be relying on debugfs for setting
> the limit, also see below.

Agreed on both — it's a real interface, will move to sysfs, and will
use size (pages/MiB) instead of cluster count.

> 
> > 
> > Since xswap has no backing, swapped-out pages are stored compressed in
> > zswap: physical writeout is skipped, and zswap writeback is disabled when
> > every swapfile in the system is an xswap device.  xswap requires zswap, so
> > device creation is refused when zswap is unavailable.
> > 
> > Naming:
> > ======
> > I'm going with "xswap" (the "x" for extendable/extension) rather than "vswap".
> > Chris suggested this name, and this aligns with the "VFS-like swap layers"
> > direction Chris Li described in the first swap abstraction LPC talk
> > (co-hosted with Yosry) the swap ops and the xswap extension interfaces in
> > this series are moving toward exactly that. I don't have a strong preference
> > between xswap and vswap, so if reviewers object to the name, please comment.
> > 
> > Note:
> > =====
> > This patchset only build the base. On top of this, the subsequent core code
> > implementation of xswap writeback, rmap etc can be done more easily. E.g, we
> > only need add one field in struct swap_cluster_info to let xs_table point to
> > physical swap entry, or zswap entry etc. On top of this patchset, no need to
> > stir core data structure too much or introduce extra data structure.
> > 
> > --- a/mm/swap.h
> > +++ b/mm/swap.h
> > @@ -57,6 +57,9 @@ struct swap_cluster_info {
> >         u8 order;
> >         atomic_long_t __rcu *table;     /* Swap table entries, see mm/swap_table.h */
> >         unsigned int *extend_table;     /* For large swap count, protected by ci->lock */
> > +#ifdef CONFIG_XSWAP
> > +       unsigned long *xs_table;
> > +#endif
> > 
> > Testing (taken on qemu kvm guest with 8G memory):
> > =========
> > 1. enable zswap and create/destroy xswap device
> > ~# echo 0 > /sys/kernel/mm/xswap/create
> > -bash: echo: write error: Operation not supported
> > ~# echo 1 > /sys/module/zswap/parameters/enabled
> > ~# echo 0 > /sys/kernel/mm/xswap/create
> 
> Recent proposal have mentioned mm/xswap, and mm/swap/tiers, while we
> already have mm/swap and module/zswap. I think it's fine to use sysfs
> to organize things but will it be good to have it in unified way to
> put them all under mm/swap/? And will mkdir be prettier than
> echo > create? For these part, just an idea, no strong opinion here.


Creation passes percent+priority atomically; a plain mkdir can't. I'd
keep echo > create. On mm/swap/ unification, happy to align once the
direction settles, while keep this series as is for now.
> 
> > ~# swapon
> > NAME   TYPE  SIZE USED PRIO
> > xswap0 xswap 2.3G   0B   -1
> > ~# echo 0 > /sys/kernel/mm/xswap/destroy
> > ~# swapon
> > 
> > 2. create xswap device and tune the zswap size
> > 
> > ~# echo "50 10" > /sys/kernel/mm/xswap/create
> > ~# echo 0 > /sys/kernel/mm/xswap/create
> > ~# swapon
> > NAME   TYPE  SIZE USED PRIO
> > xswap0 xswap 3.9G   0B   10
> > xswap1 xswap 2.3G   0B   -1
> > 
> > ~# cat /sys/kernel/debug/xswap/type0_cluster_limit
> > 1990
> > ~# cat /sys/kernel/debug/xswap/type1_cluster_limit
> 
> Can we just use size instead? Calculating the cluster number
> seems not neccessary, only making it harder to use, if this
> is suppose to be a formal interface and not debug only.

As said at above, I will change to size as suggested.

> 
> > 1194
> > ~# echo 2048 > /sys/kernel/debug/xswap/type0_cluster_limit
> > ~# echo 2048 > /sys/kernel/debug/xswap/type1_cluster_limit
> > ~# swapon
> > NAME   TYPE  SIZE USED PRIO
> > xswap0 xswap   4G   0B   10
> > xswap1 xswap   4G   0B   -1
> > 
> > 3. under heavy memory pressure tune swap size or destroy xswap device
> > 
> > ~# stress-ng --vm 1 --vm-bytes 8G --vm-keep --timeout 120s &
> > 
> > ~# echo 1024 > /sys/kernel/debug/xswap/type0_cluster_limit
> > ~# swapon
> > NAME   TYPE  SIZE USED PRIO
> > xswap0 xswap   2G 2.6G   10
> > xswap1 xswap   4G 182M   -1
> > ~# echo 1024 > /sys/kernel/debug/xswap/type1_cluster_limit
> > ~# swapon
> > NAME   TYPE  SIZE   USED PRIO
> > xswap0 xswap   2G   1.4G   10
> > xswap1 xswap   2G 315.4M   -1
> > 
> > ~# echo 0 > /sys/kernel/mm/xswap/destroy
> > ~# swapon
> > NAME   TYPE  SIZE USED PRIO
> > xswap1 xswap   2G 1.1G   -1
> > 
> > I tried create/destroy and grow/shrink xswap device under heavy
> > memory pressure, all passed.
> 
> Do you have some performance reading on this? I remember you had
> some in your previous RFC, better to at least keep a link, I spend
> quite some time to find the previous zswap test result from you.
> I noticed this series is different from what you sent before as it
> only contains the foundation so there could be no performance gain
> currently but still, might worth mentioning what this could achieve.

The initial version is about removing xarray in zswap, that has a obvious
performance improvement data. This series is the foundation
(grow/shrink/destroy). I will think about ways to get some testing data,
e.g xswap vs zswap (no writing back).

> 
> Another thing is, maybe we can defer the implementation of shrink
> for easier understand and review? The memory consumption is totally
> acceptable even without shrink.

I understand the motivation, but I don't think it reduces the review burden
as much as it seems. When a device is removed (destroy/swapoff), its mapped
pages must be released regardless of shrink, otherwise they leak. And that
cleanup uses the same unmap-and-free code shrink does. So deferring shrink
removes only the runtime shrink triggers, not the unmap machinery, which
every device needs on removal. The nr_clusters ceiling and the limit knob
are also half shrink: without shrink, lowering the limit can stop growth
but never reclaim memory, leaving that interface only half functional. 

Thanks again for your careful reviewing, thorough considering and great
suggestions.

Thanks
Baoquan


