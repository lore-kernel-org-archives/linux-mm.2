Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CC3ECA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 09:16:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D76FC6B0088; Mon, 12 Oct 2026 05:16:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D28166B008A; Mon, 12 Oct 2026 05:16:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3EB26B008C; Mon, 12 Oct 2026 05:16:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 911496B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 05:16:37 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 03C84C09C5
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 09:16:36 +0000 (UTC)
X-FDA: 85313418834.14.84CE220
Received: from mta1.migadu.com (out-147.mta1.migadu.com [95.215.58.147])
	by imf09.hostedemail.com (Postfix) with ESMTP id D4198140003
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 09:16:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BM93IkYJ;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.147 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791796595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aBURXRQxHSXJAmnyi6ikJ0BGjpngzxqLsINdXGewM5E=;
	b=wN8QjYwd6ubTgt47vrYAdl7UCh38mIsSV994n5gh+Xq3orsq52lra4H77GEhCNELlm9DLi
	4gsC58V5o275iNBy5ruZtdTtIBPkFSdZdk6I/WsIYNqvkrY9pejyocA+NEI5PD5qGN9n+2
	BGuXGELn1s/fqnHihA5dkxbg/XtywG8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BM93IkYJ;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.147 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791796595;
	b=FAq5FuaYvhUQMfi26jYRsclDHB81CH6zZEw99fjvoeUaQY7Ke1AGzmeCIZ/RBjRxNRAAdT
	m7YP8DmfiWQokbTImJI8Ap7tKfLmcroCaii/MTfvYgqdjO3SKKsSuy8/LMcZX+mC5iYKOP
	s8ArlEaXOQ1P7+/AUc74TstXScQmRiw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=69YtGiardfA9MwaWyqxmYX4WlfVGtuCzQQDaVfCNu2k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791796593; v=1; x=1792401393;
 b=BM93IkYJ8R8KSxfDfnJ6DOKPCN4QyojQrtcWpyGI8fmxEDx6SeCZzwGd2GT1njpVenaRO38D
 qvYwfZ1wuKctTzbdllSUx8s87+cwaIsH7WB+cfWo5aVfh5d5kSFlIghWlxtnblMx5gMm665A18G
 +nl+iqRLU6pdIhdUakS9Elao=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 4ebed4ed4dfe5b5b;
	Mon, 12 Oct 2026 09:16:33 +0000
X-Mizu-Trace-ID: 4ebed4ed4dfe5b5b
X-Migadu-Flow: FLOW_OUT
Date: Mon, 12 Oct 2026 17:16:22 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Klara Modin <klarasmodin@gmail.com>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, nphamcs@gmail.com, baohua@kernel.org,
	youngjun.park@lge.com, yosry@kernel.org, shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev, david@kernel.org,
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Subject: Re: [PATCH v4 00/14] mm, swap: extendable swap devices (xswap phase
 I)
Message-ID: <asylV5YyyaHs8rP3@fedora>
References: <20261003003136.750633-1-hebaoquan@kylinos.cn>
 <asZt7-8mcxqc1a02@soda.int.kasm.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asZt7-8mcxqc1a02@soda.int.kasm.eu>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D4198140003
X-Stat-Signature: 9bdzc5sshqonrk15d6rhprr6bsgmhnhy
X-HE-Tag: 1791796594-227073
X-HE-Meta: U2FsdGVkX1+M/hUI1JsOSmB2rZtCFRpPHe9mrGEUXDo07deG8M9Ti8heEqvCpx7gZFUELzA1qHMX0Yc47th5vSdlvHKFIxES67/PjQoAXn3etbXZ07L1lJIjcjd8Oj1Nc651Oelja33qDzTjASn0gp3CtIpSOGP3d0erUjj87ylCqrESwFVIoOhv9mEhfCQ2l/tbf3Q0uHfXmn29v7uK3hwdjjiwlRWN9uKmje+kZTsX1cHpnkGCAkF5BAh6eMMXqRiRScyINcvR9udlyjZDTPBbxdYXTnBlVkwCGLc9Z1urEWZetH3m9rVMucF18ZIk6644+QdqZQ+ty/P+Br4eP61WOUSxuabX1m0wqVh1l1V0y/lYHJia48F/fXKrc1DVh41v4tc0gV8vTvi6Vxq8fbR2zV9ckSXdjvq95hJzpO5kjMnJm22jd2jOsBLQCwI+aHStptryBo7wW+28nlAEzQMZpJW3rWHVGf9maq5U7DeU86YDLAK68espx+5qvOgfMk+1DfmA9cig/RH1pK4gm9QDsg/DWrXP78D/xZCw6mIlB8WEYDde47FUQ/O9zETAdDWGMwgy8YVO9LGJ8Perf9E+iAge6QIvJo7NtTPBCMU+PU42gU3L3c7wQxh+eaMZ2J3RosK7FeGjwGViYGgjuJFIYyRIRdgiuziz5om6cypUbNniI0wkR/6SObfBvhXhc5oa0rTm8dO7YAJyk9sSNw6d3dfB1BoZMOz/I3+3PEpBwatRIUpH4EzebN3+UoZ5cTS+jQoge7rL5b9ivvg8haXY20jfdFY0u6jQV2pwromtNujnDSDzmP8X7QpEf9avbaYl2zcJ9jM7IgeZhVcndNWj1TCTU/n0bnShU81doqKvpn8ov0VjeOhidUOpIa6cnB1Yz9Q4UTIvqbaxVY4xo78c1QivTEO8oiiEbKdL2lqpKE14TTZdXH+ar68kUGDbxFvtbEkApkaZjuNkBpT
 AYQ1rsOQ
 6AY2twdvfgV++7k6SH6PiUaBQ66/O7Ad934F9treanv24n8FgXS1rcmw+kpP4ScEqwb6LkPrsVopmp80tDVnY2IhUjHgM+pylof+5UKafG1Ye+eoZ/Vwdj46y7Wy/RexxIvAL++CfPk5M+dbjHcAJ6gT82WEj2zCT307h4NIcZFrVq8FVVLa2INemWZt1Qokz6my/FgzL4qEIileYZvBQIjN29angSDVdcQC+S4NmvINdH3nYVNCmoS409LIaaklp1vfKqv/nWjVcsrub9loZZNuM1sNtSGTE4aWe5erFGsxJz8oNWYX2RonVtzY2Bf9czOGc03prPaQxgo5IkB9hPcGMSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Klara,

On 10/07/26 at 06:28pm, Klara Modin wrote:
> On 2026-10-03 08:31:22 +0800, Baoquan He wrote:
...snip...
> > The only argument create takes is a priority. The size comes from
> > xswap.max= at boot, so there is one place to ask for a size and one to
> > ask for a priority, and a priority can be given per device while a size
> > cannot:
> > 
> >   # echo > /sys/kernel/mm/xswap/create          default priority
> >   # echo 100 > /sys/kernel/mm/xswap/create      priority 100
> > 
> 
> > The default is the highest priority, SWAP_FLAG_PRIO_MASK. An xswap
> > device is then the first one tried, ahead of any ordinary swap device.
> > Setting a lower priority is allowed.
> 
> Nice, this is now a good default which the user should not have to
> change.

Thanks a lot for careful reviewing, and sorry for late reply.

> 
> > 
> > The device does not move once it exists, so the address space cannot be
> > changed from this interface either. xswap.max= at boot and this together
> > are the whole configuration.
...snip...
> > Open items
> > ----------
> > 
> > - xswap_create() sets si->pages to the whole address space (twice RAM by
> >   default) and _enable_swap_info() adds it to nr_swap_pages and
> >   total_swap_pages, which is what __vm_enough_memory() uses for
> >   overcommit. That raises the commit limit by 2xRAM for a device whose
> >   real capacity is bounded by the zswap pool and by how well the workload
> >   compresses. The question is which semantics overcommit should follow:
> >   worst-case backing, or the address space.
> > 
> > - destroy takes a bare swap type. The type is an internal index that
> >   alloc_swap_info() recycles as soon as SWP_USED clears, so a value read
> >   earlier can name a different device by the time it is written. The
> >   swapoff ABI uses a path for this reason. It wants a generation or
> >   another stable handle.
> > 
> > - The new interfaces (/sys/kernel/mm/xswap/create and destroy, xswap.max=,
> >   the new type string in /proc/swaps) are not documented yet.
> 
> To me it feels a bit weird to have the interface split between a kernel
> parameter and sysfs, meaning I have to configure this in two places now.
> As far as I gather, there's also nothing that needs the limit to be
> fixed at boot since it is applied at creation. If we want to expose this
> limit to users (as xswap does) it would be nice to have a 'max'
> shorthand for tha largest possible value, i.e. SWAPFILE_CLUSTER *
> UNIT_MAX (or whatever it might be in the future). That would I guess in
> practice give the same behaviour as vm.overcommit_memory=1 which might
> or might not be desirable.

Thanks for the comment.

Here xswap.max= is a global boot parameter, while not a per-device or
runtie knob. It sets the space space (si->max) of the xswap device
at boot and can't change at runtime. So on the two places: the size is
a global setting, fixed at boot; the priority is per device, it is in
the create interface. They are different things.

The default is 2xRAM. From our earlier discussion, this is the largest
size we think is sensible, and in practice I don't think it is not
reachable in reality. If a system has swapped out 70% of its memory, and
even more at 100%, it is already doubtful that it can still function
normally. So 2xRAM is an upper bound, not a target.

On the max short name: it would set the address space to the largest value
the format allows. As you said, that is close to vm.overcommit_memory=1,
and it is not a real capacity, so we may not want it as the default.

We keep xswap.max= only for special needs. Otherwise we may not need to
change it.

Chris suggested a CONFIG option for the size. While CONFIG is not friendly
to distros, you must rebuild the kernel to change it.

By the way, I remember you mentioned you ever did a test making swapped
out pages about 110% of system RAM, could you share your testing steps
or scripts so that I can give it a shot on my testing system? If it's
not convenient, then never mind.

Thanks
Baoquan

> 
> > 
> > Changelog
> > =========
> > v3 -> v4:
> > - Rebased onto the latest mm-new.
> > 
> > - Add boot parameter xswap.max= .
> > 
> > - The device has one size now: set at creation, fixed, with xswap.max= to
> >   ask for another one at boot. v3's runtime ceiling, the per-device limit,
> >   the clamp it wrote and the shrink to that ceiling are all gone as
> >   Johannes suggested (v3's patches 12, 13 and 14).
> > 
> > - v3's patches 2 and 4 are the new patch 3: neither builds a device
> >   alone. It also bounds find_next_to_unuse() and wait_for_allocation(),
> >   which walked up to si->max past the mapped range. Chris suggested
> >   this.
> > 
> > - New patches 11 to 13: a cgroup that cannot zswap is not given an xswap
> >   slot, swap_info_struct max and pages are unsigned long, and debugfs
> >   counters for the mapped range and the grow and shrink counts.
> > 
> > - v3's patches 1 and 3, and 5 to 11, are unchanged; the merge shifts them
> >   to 1 and 2, and 4 to 10.
> > 
> > - Minor comment and cleanup changes.
> > 
> > v2 -> v3:
> > - Rebased onto the latest mm-new.
> > 
> > - The grow path now honors the user-set ceiling (si->nr_clusters) instead
> >   of growing up to nr_clusters_max, and a ceiling below the mapped range
> >   is unmapped exactly instead of rounded to a chunk (patches 12 and 14).
> > 
> > - The limit write clamps the ceiling up to the clusters covering the pages
> >   in use, replacing the earlier WARN_ONCE; si->pages becomes mutable at
> >   runtime (patch 13).
> > 
> > - Minor comment and cleanup changes.
> > 
> > v1->v2:
> > - Patch 1 (mm: zswap: return -ENOENT when the swap device is gone) is not
> >   part of this series; it was posted separately.
> > 
> > - There is only one size knob now. The runtime ceiling and the debugfs
> >   per-device limit are gone. All that is left is the optional per-device
> >   cap, /sys/kernel/mm/xswap/type<N>/limit. Grow and shrink work without
> >   it.
> > 
> > - The shrink no longer keeps its own count of the free tail. It scans the
> >   tail instead, and dropping the counter also removes a call from the
> >   cluster allocation path.
> > 
> > - The priority is no longer a patch of its own. The create attribute
> >   takes it:
> >     echo 100 > /sys/kernel/mm/xswap/create
> > 
> > RFC v3 -> RFC v2
> > - Add patch 16 to support setting xswap device priority at creation.
> >   The create sysfs interface (/sys/kernel/mm/xswap/create) previously
> >   hardcoded every new device's priority to DEF_SWAP_PRIO, it now
> >   accepts an optional priority:
> > 
> >     echo "<percent> [<prio>]" > /sys/kernel/mm/xswap/create
> > 
> > - Bug fix: xswap_lock init ordering. mutex_init(&si->xswap_lock) was called
> >   after xswap_map_clusters() (which locks it), i.e. locking an uninitialized
> >   mutex. Init now before the first xswap_map_clusters() call. Thanks to Klara.
> > 
> > - Bug fix: Fixes a compile error in !CONFIG_XSWAP builds. xswap_debugfs_root
> >   is declared inside CONFIG_XSWAP ifdeffery scope, so the ungarded use
> >   caused error when CONFIG_XSWAP is off.
> > 
> > RFC v2-> RFC v3:
> > - Replace the "header-only swap file + swapon" creation hack with a
> >   proper file-less device created and destroyed via sysfs
> >   (/sys/kernel/mm/xswap/{create,destroy}).  This required the
> >   __swapoff() refactor and the free_swap_cluster_info() signature
> >   change (patches 4, 6, 14).
> > 
> > - Require zswap: refuse to create an xswap device when zswap is
> >   unavailable (patch 15).
> > 
> > - Split the unrelated zswap -ENOENT fix out of the series into a
> >   standalone patch (patch 1).
> > 
> > - Fix nr_free_tail over-counting on concurrent grow, shrink leaking
> >   detached clusters on early bail-out, a re-init race on cluster
> >   spinlocks in xswap_map_clusters(), the nr_clusters_mapped update
> >   ordering, and swapoff accessing the shrinker-unmapped cluster tail.
> > 
> > - Minor cleanups (checkpatch, /proc/swaps alignment, commit messages).
> > 
> > RFC v1-> RFC v2:
> > - Added __GFP_HIGH | __GFP_NOMEMALLOC to alloc_page() and kmalloc_array()
> >   in the grow path, plus memalloc_noreclaim_save/restore() wrapping,
> >   to prevent the grow path from consuming emergency memory reserves
> >   or recursing into swap under PF_MEMALLOC. This is folded into patch 3.
> >   This was pointed out by Nhat.
> > 
> > - Folded the mutex serialization fix into the cluster grow patch (patch
> >   3). This is suggested by Nhat.
> > 
> > - Fixed coding style issues: corrected indentation of declarations in
> >   xswap_unmap_clusters(), removed unnecessary block scope around the
> >   err variable in xswap_map_clusters().
> > 
> > - Rebased onto mm-unstable
> > 
> > Baoquan He (13):
> >   mm, swap: refactor free_swap_cluster_info to take swap_info_struct
> >   mm, swap: back the cluster_info array with a sparse VM_SPARSE area
> >   mm, swap: add sysfs create interface for xswap
> >   mm, swap: add xswap grow trigger on cluster allocation
> >   mm, swap: add xswap_try_shrink and shrink trigger on cluster free
> >   mm, swap: free backing pages in xswap_unmap_clusters
> >   mm, swap: defer xswap shrink to workqueue to avoid lock recursion
> >   mm, swap: refactor swapoff and add xswap_destroy
> >   mm, swap: require zswap for xswap devices
> >   mm, swap: do not give an xswap slot to a cgroup that cannot zswap
> >   mm, swap: widen swap_info_struct max/pages to unsigned long
> >   mm, swap: add debugfs counters for xswap
> >   mm, swap: let the command line set the xswap device size
> > 
> > Chris Li (1):
> >   mm: xswap support for zswap
> > 
> >  include/linux/swap.h |   16 +-
> >  mm/Kconfig           |    9 +
> >  mm/page_io.c         |   19 +
> >  mm/swap_state.c      |    9 +
> >  mm/swapfile.c        | 1221 +++++++++++++++++++++++++++++++++++++++---
> >  mm/zswap.c           |   11 +-
> >  6 files changed, 1205 insertions(+), 80 deletions(-)
> > 
> > 
> > base-commit: 9a0542b19a541eda3f82934ee747c61ec3f18847
> > -- 
> > 2.54.0
> > 

