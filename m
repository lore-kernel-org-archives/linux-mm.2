Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75392E6FE26
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 00:43:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D1BE6B0005; Tue, 23 Dec 2025 19:43:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97FD96B0088; Tue, 23 Dec 2025 19:43:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88B756B008A; Tue, 23 Dec 2025 19:43:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7816A6B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 19:43:15 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1346513B432
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 00:43:15 +0000 (UTC)
X-FDA: 84252515550.06.C7B3E3D
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2B5A2180016
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 00:43:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qKujYfz3;
	spf=pass (imf24.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766536993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3p/NBqFZeLVjN6xggAhBjlG26Cbhd95DkUEqc0nS51M=;
	b=uIZOtRylXe28i3+HjlKRVo1YW6dPiLPsQJ04pRZRbQG3KzJmy43BKSDIbKCfNis0eWX6ec
	P2q7+GlTV+8pe1qHmPSlSLOjEiyk3psteaXuaZN9Tk2UmjAd0VjHngFAaTkKt3mS2QoJGZ
	khaeimARGtxA5a5dZMytpQ+8Oe3ZMg8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766536993; a=rsa-sha256;
	cv=none;
	b=Usth5zqzatOUZPbCB5II/+pXI+wcwn7vzOmTuUl9q5ZTLA0enYxBDfzfh70ckaSTZVODPO
	/wAusSD3G5OC7NyBGqKT2MiQTMdqnZYoNzTlzDcg65kFRvdhLJWBFT0UdP0auKcwIfZvF3
	vXjK0UMYhchTyla4KgbhRF5WY6AoGLY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qKujYfz3;
	spf=pass (imf24.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 24 Dec 2025 00:43:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766536990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3p/NBqFZeLVjN6xggAhBjlG26Cbhd95DkUEqc0nS51M=;
	b=qKujYfz3DzhT15fZcIF1ioBx4jguu4eGfWOe8iZC5y5m7JZeVIQ70f14oXwUvV3DnuBP4Y
	qfQPwgvD/pVENwjasoqTo1crCWs09DjGvVFg2E1G/mWBkuaq5JOS+inH4CZXy/KSP0FQB2
	a8wvniBYxCl3Ks+C73Fm+YCNFp3492Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com, 
	mhocko@suse.com, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
Message-ID: <llwoiz4k5l44z2dyo6oubcflfarhep654cr5tvcrnkltbw4eni@kxywzukbgyha>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <5dsb6q2r4xsi24kk5gcnckljuvgvvp6nwifwvc4wuho5hsifeg@5ukg2dq6ini5>
 <vsr4khfsp4unk73a75ky7i35nzdjqsbodyeeuxipu3arormfjr@awi2srdwawfu>
 <utl6esq7jz5e4f7kwgrpwdjc2rm3yi33ljb6xkm5nxzufa4o7s@hblq2piu3vnz>
 <7enyz6xhyjjp5djpj7jnvqiymqfpmb2gmhmmj7r5rkzjyix7o7@mpxpa566abyd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7enyz6xhyjjp5djpj7jnvqiymqfpmb2gmhmmj7r5rkzjyix7o7@mpxpa566abyd>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: r688z78cds7nwp1agqajsyem5dyf5izd
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2B5A2180016
X-Rspam-User: 
X-HE-Tag: 1766536992-8491
X-HE-Meta: U2FsdGVkX1+DErNKGX2NLF29nHDHk9cvEKE6b9+fp7RmdkmHE3LPqZvf9UqqB0bxgv6o8dyZTs1vbJlY06BPqPa5kwPmQ7R5zHVR53cglyEhQTqL+LS8t43rwfDw8FOCA0Hc07QZVC8GNOcO8wktedZlaXC+Mq+jk8BP7CdXoStFfdz564ReS7rfHHssny31jWBDgRNapr38O29FKrRhK9pMQ/C7ocMhXevusG6dnWkkZd9fvbLPzRq4x3oNaa+ZfvlwG6c9/POVQjlw1mI73ndo9kt9SWTZrci5BxjQNRji/QnBvIrNRbM9d7fn1Q4BfpvvoaJ37e8zL7PVvvVnS/TeHmWzu7D1FBXvyixZ/apY2uaMOS+uWEkKY4wsGlaRQG/6SkB2H6+3Cwoxo4ylsVgsLAoiMzJ4KfmpK0IDGQI7WVXvqglgWnc03QpUsiiBasVyItPLVOHBVimqN2coQ3DrOqhQ5w11/28Rsl/VniR/lwKbrk8xHwFHNbZdOdXJ3olWqXd5FmuU8JCy947eGdLxICRlQ/zOs/llxESICB9VqnvflA9ilYYwF4eKN5BPYTdBtxRhOrVckg9E8/mWwBwrBsVsvHaKvkWP1PE54NsH8qGRU+1bfmeOem2kgw3wlEqaYHQ3uNRZp0oxeKSPSFoPS0muNcWxwnDjs5/4gYvGkmeCTa8/YJXiiGG6VMc87VkLr7NbFPKE24yXb8VzF5k0j8lYIDRV+SgK9Xf90vm/VB7tZaH016NBYhU0rGUuvetjYZwfBTKuZDdHndr/A5Mv06HCm3uqAgahhPYR3zCNHGrPcQ0YpLcXDfF9PiHlH9QL0X9j8tcMd+Rkhqdw1ANhdobuUKoc5m3HN38LDwGK7bJvcNhraSvvdyHl0cS5yE0RKGJwoL920rq/hidjjuf8BxRf5F6HVISTwrGquMi5xP1q7d0n7ZJraluEHWRLq3j2x14RY6IDz3qfujm
 FqNZVqni
 jRsKGd694kV0ZOckyp/yx5L55fd/T7s3dyoslSLEAoaCpbsVBr5iH65NocGWcpEiGzGSGOCgjPXTo8BKeNyucAIMvRjZQkwMo/jv8IxIlZfROQ457hoYO+m4K0NJJzkMzN3LMx2MqQQ7ecYPGqG4suBb6n0zyW15Y3Vt3SdtH8awa7j6QCMbzv25Lf+w6krq6ceQUNNFOjRvqJKY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 23, 2025 at 04:36:18PM -0800, Shakeel Butt wrote:
> On Wed, Dec 24, 2025 at 12:07:50AM +0000, Yosry Ahmed wrote:
> > On Tue, Dec 23, 2025 at 03:20:47PM -0800, Shakeel Butt wrote:
> > > On Tue, Dec 23, 2025 at 08:04:50PM +0000, Yosry Ahmed wrote:
> > > [...]
> > > > 
> > > > I think there might be a problem with non-hierarchical stats on cgroup
> > > > v1, I brought it up previously [*]. I am not sure if this was addressed
> > > > but I couldn't immediately find anything.
> > > 
> > > Sigh, the curse of memcg-v1. Let's see what we can do to not break v1.
> > > 
> > > > 
> > > > In short, if memory is charged to a dying cgroup 
> > > 
> > > Not sure why stats updates for dying cgroup is related. Isn't it simply
> > > stat increase at the child memcg and then stat decrease at the parent
> > > memcg would possibly show negative stat_local of the parent.
> > 
> > Hmm not sure I understand what you mean here. Normally an update to the
> > child memcg should not update state_local of the parent. So outside the
> > context of dying cgroups and reparenting I don't see how state_local of
> > the parent can become negative.
> 
> We might be talking about same thing. When you said "memory is charged
> to a dying cgroup", it does not have to be dying cgroup, it can be alive
> child which died later. So to give an example, let's say a process in
> the child allocates a file page, NR_FILE_PAGES is increased at the
> child and next child has been rmdir'ed, so when that specific file page
> is freed, the NR_FILE_PAGES will be decreased at the parent after this
> series.

Yes this is exactly what I mean. Specifically, an update happens after
the cgroup becomes "dying".

> 
> > 
> > > 
> > > > at the time of
> > > > reparenting, when the memory gets uncharged the stats updates will occur
> > > > at the parent. This will update both hierarchical and non-hierarchical
> > > > stats of the parent, which would corrupt the parent's non-hierarchical
> > > > stats (because those counters were never incremented when the memory was
> > > > charged).
> > > > 
> > > > I didn't track down which stats are affected by this, but off the top of
> > > > my head I think all stats tracking anon, file, etc.
> > > 
> > > Let's start with what specific stats might be effected. First the stats
> > > which are monotonically increasing should be fine, like
> > > WORKINGSET_REFAULT_[ANON|FILE], PGPG[IN|OUT], PG[MAJ]FAULT.
> > > 
> > > So, the following ones are the interesting ones:
> > > 
> > > NR_FILE_PAGES, NR_ANON_MAPPED, NR_ANON_THPS, NR_SHMEM, NR_FILE_MAPPED,
> > > NR_FILE_DIRTY, NR_WRITEBACK, MEMCG_SWAP, NR_SWAPCACHE.
> > > 
> > > > 
> > > > The obvious solution is to flush and reparent the stats of a dying memcg
> > > > during reparenting,
> > > 
> > > Again not sure how flushing will help here and what do you mean by
> > > 'reparent the stats'? Do you mean something like:
> > 
> > Oh I meant we just need to do an rstat flush to aggregate per-CPU
> > counters before moving the stats from child to parent.
> > 
> > > 
> > > parent->vmstats->state_local += child->vmstats->state_local;
> > > 
> > > Hmm this seems fine and I think it should work.
> > 
> > Something like that, I didn't look too closely if there's anything else
> > that needs to be reparented.
> > 
> > > 
> > > > but I don't think this entirely fixes the problem
> > > > because the dying memcg stats can still be updated after its reparenting
> > > > (e.g. if a ref to the memcg has been held since before reparenting).
> > > 
> > > How can dying memcg stats can still be updated after reparenting? The
> > > stats which we care about are the anon & file memory and this series is
> > > reparenting them, so dying memcg will not see stats updates unless there
> > > is a concurrent update happening and I think it is very easy to avoid
> > > such situation by putting a grace period between reparenting the
> > > file/anon folios and reparenting dying chils'd stats_local. Am I missing
> > > something?
> > 
> > What prevents the code from obtaining a ref to a parent's memcg
> 
> I think you meant child's memcg here.

Yes, sorry.

> 
> > before
> > reparenting, and using it to update the stats after reparenting? A grace
> > period only works if the entire scope of using the memcg is within the
> > RCU critical section.
> 
> Yeah this is an issue.
> 
> > 
> > For example, __mem_cgroup_try_charge_swap() currently does this when
> > incrementing MEMCG_SWAP. While this specific example isn't problematic
> > because the reference won't be dropped until MEMCG_SWAP is decremented
> > again, the pattern of grabbing a ref to the memcg then updating a stat
> > could generally cause the problem.
> > 
> > Most stats are updated using lruvec_stat_mod_folio(), which updates the
> > stats in the same RCU critical section as obtaining the memcg pointer
> > from the folio, so it can be fixed with a grace period. However, I think
> > it can be easily missed in the future if other code paths update memcg
> > stats in a different way. We should try to enforce that stat updates
> > cannot only happen from the same RCU critical section where the memcg
> > pointer is acquired.
> 
> The core stats update functions are mod_memcg_state() and
> mod_memcg_lruvec_state(). If for v1 only, we add additional check for
> CSS_DYING and go to parent if CSS_DYING is set then shouldn't we avoid
> this issue?

But this is still racy, right? The cgroup could become dying right after
we check CSS_DYING, no?

