Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F287E6FE26
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 00:36:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C78556B0005; Tue, 23 Dec 2025 19:36:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2EF26B0088; Tue, 23 Dec 2025 19:36:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B82026B008A; Tue, 23 Dec 2025 19:36:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A5F546B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 19:36:30 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0C45F160563
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 00:36:30 +0000 (UTC)
X-FDA: 84252498540.16.C1A0C11
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id 45E842000E
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 00:36:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=obHAR9Xy;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766536588; a=rsa-sha256;
	cv=none;
	b=dYvxvpefVyoE1/P+3UKYkfl1xw0Rg3QCN+kSh2LCBluPzMJTe2PYKv534X39iL9Kn8nFqB
	db+zht7BhZL4vKcJZfZie26AUb2qrBCvdOTQdP2ScOqVWmGO/k+y3madm3Sg1lamc/uN4Q
	SdeiWXn/b3XKqEUdVTMVXgerf0bBTy4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=obHAR9Xy;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766536588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tvTruLv6Dhc42akl1jnVGxsC5c+HgJvahoPGXJ5OJlo=;
	b=8qrIJKI6OdpE/VV7erLhilYafDmBksW/JS48RsozmV3WIrGAELNVDRVS71yqzWtaSkc3iJ
	lwC0nlaRjBF68ELJKO+hW98ig+oj/HqWWexc392QUYxsA1z2HogI2FMozalaE3D97+J/u3
	nfdsqUpbbIvWPDzpV8Wza3NDRece6ag=
Date: Tue, 23 Dec 2025 16:36:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766536585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tvTruLv6Dhc42akl1jnVGxsC5c+HgJvahoPGXJ5OJlo=;
	b=obHAR9XyEqk3PowbYmJC/l/XhQ0RpW3LyXN8vgo9SnxT2aQOrSGCQkA4wFJiFyMuYvnqWM
	gXaDcvSyZrp6SjGvLJhTsU1zmKgXyqgbw8vw5RvhMpKMCT10qbKwoBJ7r/suj6192unExW
	J/CE1F/T/C64RuOhmVYACJw2csgHCqY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com, 
	mhocko@suse.com, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
Message-ID: <7enyz6xhyjjp5djpj7jnvqiymqfpmb2gmhmmj7r5rkzjyix7o7@mpxpa566abyd>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <5dsb6q2r4xsi24kk5gcnckljuvgvvp6nwifwvc4wuho5hsifeg@5ukg2dq6ini5>
 <vsr4khfsp4unk73a75ky7i35nzdjqsbodyeeuxipu3arormfjr@awi2srdwawfu>
 <utl6esq7jz5e4f7kwgrpwdjc2rm3yi33ljb6xkm5nxzufa4o7s@hblq2piu3vnz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <utl6esq7jz5e4f7kwgrpwdjc2rm3yi33ljb6xkm5nxzufa4o7s@hblq2piu3vnz>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 45E842000E
X-Rspamd-Server: rspam04
X-Stat-Signature: e4wb8m9j6ipdyh8154c8r48yysihjz9t
X-HE-Tag: 1766536588-608643
X-HE-Meta: U2FsdGVkX18ETI7R5OwZT74ArZJZOHShWNN4MAVrvnysrnv3Z66b+Ph43KUz1jsAdjLT3AkQ3un2Ex/cyLWnQzVimeq5IykbITAxhqkfl5LJF85kMjYI7CVqfeseiqNziUrYMteCZDUPumSGTusaGRuc5szG0BEWXHWAYEwNuduBlvHRaEYe1ub+ztGJlilF9cBg3sx3H6DSwtR+5xsNPm9x7EmHVR+Do6jcsMEO9S7P3420XkQA85WINLSWBVmPF7k3jgLOL2xm4o8nbcTu3k7nRhzU1mslZ6aenTcIb7BMNrqecLwh62xVS8CdK+OfeA19OjtAf3OJ6//TcwfqWc/hL89gNrRlJHn8VvjuU9TJb/+OSu2Kxpck6magKIok1y28FNQsDAjFk1eDDmvvf+pj7uN5blBtm31F3Ngbl+rDGhvXmzw/cMtmJD02U8dfFrskuU3BBtvltSKA0cTA5hEZqHzug96wCBBKI4rc0R+laB8B1WahDAYjn3OBIpqJlJWDm6S6OIVy5MDIiuB1B7HuL7RKe9ipJnSFmxMrdQiBI7KKIguHgc/TozJr/JYCXkRDVVPRoVCQS9lfLDS/PK7eynX+JJyz6S4+Y6HnYOUhnh07QHonxHMT6XjdWo5Z2JhVDTQKNG5H65xI/6xBv5mRMFw5Pt49gbhu5nd62b+Y7lbaol9K1YIOxB+TuUI+VQ3zkoco+6RNQozXIprDZCDrP860pkJpVcAJD+aMISQ0lyqLAqstdJwvYSZ4oEJ8N48YQjeudREanfttSzlAG3vH/ielOF+JtWSBEg01z24surgLzP8DHPJQISaq1LvFD9j5r1xYKCqwqu2U+fnBd0V41ayHh3JebQiXcDgKxewDXYRtb/AIrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 24, 2025 at 12:07:50AM +0000, Yosry Ahmed wrote:
> On Tue, Dec 23, 2025 at 03:20:47PM -0800, Shakeel Butt wrote:
> > On Tue, Dec 23, 2025 at 08:04:50PM +0000, Yosry Ahmed wrote:
> > [...]
> > > 
> > > I think there might be a problem with non-hierarchical stats on cgroup
> > > v1, I brought it up previously [*]. I am not sure if this was addressed
> > > but I couldn't immediately find anything.
> > 
> > Sigh, the curse of memcg-v1. Let's see what we can do to not break v1.
> > 
> > > 
> > > In short, if memory is charged to a dying cgroup 
> > 
> > Not sure why stats updates for dying cgroup is related. Isn't it simply
> > stat increase at the child memcg and then stat decrease at the parent
> > memcg would possibly show negative stat_local of the parent.
> 
> Hmm not sure I understand what you mean here. Normally an update to the
> child memcg should not update state_local of the parent. So outside the
> context of dying cgroups and reparenting I don't see how state_local of
> the parent can become negative.

We might be talking about same thing. When you said "memory is charged
to a dying cgroup", it does not have to be dying cgroup, it can be alive
child which died later. So to give an example, let's say a process in
the child allocates a file page, NR_FILE_PAGES is increased at the
child and next child has been rmdir'ed, so when that specific file page
is freed, the NR_FILE_PAGES will be decreased at the parent after this
series.

> 
> > 
> > > at the time of
> > > reparenting, when the memory gets uncharged the stats updates will occur
> > > at the parent. This will update both hierarchical and non-hierarchical
> > > stats of the parent, which would corrupt the parent's non-hierarchical
> > > stats (because those counters were never incremented when the memory was
> > > charged).
> > > 
> > > I didn't track down which stats are affected by this, but off the top of
> > > my head I think all stats tracking anon, file, etc.
> > 
> > Let's start with what specific stats might be effected. First the stats
> > which are monotonically increasing should be fine, like
> > WORKINGSET_REFAULT_[ANON|FILE], PGPG[IN|OUT], PG[MAJ]FAULT.
> > 
> > So, the following ones are the interesting ones:
> > 
> > NR_FILE_PAGES, NR_ANON_MAPPED, NR_ANON_THPS, NR_SHMEM, NR_FILE_MAPPED,
> > NR_FILE_DIRTY, NR_WRITEBACK, MEMCG_SWAP, NR_SWAPCACHE.
> > 
> > > 
> > > The obvious solution is to flush and reparent the stats of a dying memcg
> > > during reparenting,
> > 
> > Again not sure how flushing will help here and what do you mean by
> > 'reparent the stats'? Do you mean something like:
> 
> Oh I meant we just need to do an rstat flush to aggregate per-CPU
> counters before moving the stats from child to parent.
> 
> > 
> > parent->vmstats->state_local += child->vmstats->state_local;
> > 
> > Hmm this seems fine and I think it should work.
> 
> Something like that, I didn't look too closely if there's anything else
> that needs to be reparented.
> 
> > 
> > > but I don't think this entirely fixes the problem
> > > because the dying memcg stats can still be updated after its reparenting
> > > (e.g. if a ref to the memcg has been held since before reparenting).
> > 
> > How can dying memcg stats can still be updated after reparenting? The
> > stats which we care about are the anon & file memory and this series is
> > reparenting them, so dying memcg will not see stats updates unless there
> > is a concurrent update happening and I think it is very easy to avoid
> > such situation by putting a grace period between reparenting the
> > file/anon folios and reparenting dying chils'd stats_local. Am I missing
> > something?
> 
> What prevents the code from obtaining a ref to a parent's memcg

I think you meant child's memcg here.

> before
> reparenting, and using it to update the stats after reparenting? A grace
> period only works if the entire scope of using the memcg is within the
> RCU critical section.

Yeah this is an issue.

> 
> For example, __mem_cgroup_try_charge_swap() currently does this when
> incrementing MEMCG_SWAP. While this specific example isn't problematic
> because the reference won't be dropped until MEMCG_SWAP is decremented
> again, the pattern of grabbing a ref to the memcg then updating a stat
> could generally cause the problem.
> 
> Most stats are updated using lruvec_stat_mod_folio(), which updates the
> stats in the same RCU critical section as obtaining the memcg pointer
> from the folio, so it can be fixed with a grace period. However, I think
> it can be easily missed in the future if other code paths update memcg
> stats in a different way. We should try to enforce that stat updates
> cannot only happen from the same RCU critical section where the memcg
> pointer is acquired.

The core stats update functions are mod_memcg_state() and
mod_memcg_lruvec_state(). If for v1 only, we add additional check for
CSS_DYING and go to parent if CSS_DYING is set then shouldn't we avoid
this issue?




