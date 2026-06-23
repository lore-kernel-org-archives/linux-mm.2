Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0A42CDB47A
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 05:33:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42A566B0088; Tue, 23 Jun 2026 01:33:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DBBD6B008A; Tue, 23 Jun 2026 01:33:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CC756B008C; Tue, 23 Jun 2026 01:33:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E52ED6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:33:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 67CC41C2525
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:33:13 +0000 (UTC)
X-FDA: 84910059066.17.5DFE6AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9A305A0003
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:33:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UGWcdCAe;
	spf=pass (imf25.hostedemail.com: domain of dgc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782192791;
	b=N11WodFVLeLqsFmQ+vr61vkGNILfUhiypvpHiyO5G/JzjtGBcGgp7h9p/CICWSne+CfvWN
	fRsD5FsFGpmK1OqhVAR40UVDgqoBDfnjTAMxi3d9hYCKq9yDRolH9o6jOeb7DufBV1p1X2
	HaEnTl0MxAqaqDreDlUEiD/JsGYwgE0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782192791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZPxkD7F8ITxnRJZO4JYJC0JKAPV/wMzHOr5uq5/AI9E=;
	b=68GutGv237wzqQJADHzZ230ikZ9wt56L7YPUUcqzQRMGsxofiXhOnFqyb76b+Gc/CF21yI
	2yA02XOXXiKJnb3Dhhg9OPgnWlQz0aNChPhDeo6nuK2fYYJvp78B8snEm6LmZoDGbQivIM
	2jBlWXjY9n5K27aHrgdS6mOTj2kz1EU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UGWcdCAe;
	spf=pass (imf25.hostedemail.com: domain of dgc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 08EC46001D;
	Tue, 23 Jun 2026 05:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CA71F000E9;
	Tue, 23 Jun 2026 05:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782192790;
	bh=ZPxkD7F8ITxnRJZO4JYJC0JKAPV/wMzHOr5uq5/AI9E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UGWcdCAeFz7KJBjJYTpwOnCdP9C7RdIfgUkijpZS4cldZJ1uBEAWv1SU0KAdfXEj+
	 NNEUrmtvicpJSqM5Tn1H/dA7HkP3PVFWB4bhKwoEIc53L+073TWls3WsRZJP1m/P68
	 znwOJCpzVWi609urNj5fJLl41YBuTaUzwKqdlPPz5e/HDGZiqv4Oa2RVE5yZ3zON6t
	 CR53JGmlOY4BI7A145OsUVG9poe3djGCSCYGS4MHRM7xMOwcwiMEYmIN+jUxg7E3VF
	 Cob+HW62CAJ+A0bVghkIrQS7IGF4bbzpXzjWaeGVggTi9c0cTnx01sF4SwAEHmxhpO
	 RmhL53NsWzaGQ==
Date: Tue, 23 Jun 2026 15:32:58 +1000
From: Dave Chinner <dgc@kernel.org>
To: Matthew Brost <matthew.brost@intel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>
Subject: Re: [PATCH v6 1/2] mm: Introduce opportunistic_compaction concept to
 vmscan and shrinkers
Message-ID: <ajoaikDrKz7JGr5h@dread>
References: <20260617032218.1165929-1-matthew.brost@intel.com>
 <20260617032218.1165929-2-matthew.brost@intel.com>
 <ajnA83DxAFqeJ-sv@dread>
 <ajnOvdbT5/J6q3IN@gsse-cloud1.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ajnOvdbT5/J6q3IN@gsse-cloud1.jf.intel.com>
X-Rspamd-Queue-Id: 9A305A0003
X-Stat-Signature: dhnbfrws36r1tibj41mgmxqzswzkmdh5
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782192791-67284
X-HE-Meta: U2FsdGVkX19oddjRVj2Iiq9STfIq8RujWF1mSJqAALQw+kmzvm9hfVFWmoN0gmyKNYcwoW30+kTJ2rU8nhxQ+rAY3+Qg0XmIaSryPrjExfVnEaI7Cy7iYrAproaasj7iL+nS15jOA8bTFnWwQwbJeuGalHptR+M+Xo1aMqwDXNghsRw8fI1glbyHzgyNLaWlNieMe4hwX4NL35pNCnG4BprH8IUruPHIvNP1kxMy9q28/3l70HO1IwK15EjdLioxpT5GvmDuB9tdS8HrCoAucFblojGvoN4nYm8hUK6vtaDhonI7z/icQgMfhS33dXRqNhL6uk/BLh8kMk3vzKjXCUFkh7Lf8Jj9rhjcdUYBmPIODhuIr+qHI3PTkQX0cr6xpCVEDBiQBfEcDnzffHu3WfjUhpmKqhczMaEZHJGfvSPFIR6ttXLKRxM/fZ+ks/OZBtKzgYc8MTl5ybO36ix2eurqFBPWar7V0OJvjBZgyJvf/mSn/0lKgh+v4+2KXWtFU1n/JJDGDy00zGlhwosjuQrfNsMWlbdUwzUebRc5hXUifvD5nGGwh85PqLl5O/1UA/UcacEKxUmo1moyMMo2tMklJWK6m8id0VFYTwSu1UvOeIDJgX5t2z3jOd9gFS6HYzAm7qxgAlNJPGKylU/HTbfLcsNLgP/nEwJGgrf62C4FBSxCbNVuN597UFfPXq8W/Cph8iCYRFDSd0RQaVnCuXz4RiMx6oU1ULhKu+BXaCbWUlnCMoQy+nilQSYv7pFVL6ac9anAYhmhj6mWDDX7HOVSfBfk/x9sIMHB38/uHbnjREzEYdeKOCf22+QxnXly200lnHcAnYJJdxSmRHvcaZBWGCRzF+Aqq8eMeFUQSu8kNcgpJNB5wkL3DKBdGjzT5K0hp4QGG5hIX2iXr+miFTdmfkBozWtrGJlJkuJhTZ4Ma18AIesDB75lwNq7iYVyBid3vRxywY2t0aNhQY1
 9W91p1/0
 9hqYPQ9k9Xl2LQPSZWEeY7LHy7mABPdewcWOeA/DsxmVJ6IC+DQW6J/tmMWEa9rNobn7CAQltNUwAyfCZD5wtNFGjVdTQMqGcFI0wE6MR7XbQzbbDYYqHqByOKn9zHsOMhLa6MrTaJHU4Sarp1hrMoIlanL0F7F3vo5RyCTH8Tz4ViAX2NkJgn59DduEvloXyKkk3qMbanghW6LTi3Ky7yy7AxFN1tVo5KKv1glgOHNjdzhEqmKIDtKgkWpkJqLjq6hmzPDgUXDn6kMqjQOdvz601El96CVdbWprIv3NkVKIEpfuiKKTwVB6NCIF74hl3VulGf4IVOE+6y7vHzA4UnHDT+El58AcTh6AYPImXvksJpwpvIWOfxwMXis0N1vY3K/qApGtAjKb3cr2DC3p+1QIApA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 05:09:33PM -0700, Matthew Brost wrote:
> On Tue, Jun 23, 2026 at 09:10:43AM +1000, Dave Chinner wrote:
> > On Tue, Jun 16, 2026 at 08:22:17PM -0700, Matthew Brost wrote:
> > > High-order allocations using __GFP_NORETRY or __GFP_RETRY_MAYFAIL
> > > are often opportunistic attempts to satisfy fragmentation-sensitive
> > > allocations rather than indications of severe memory pressure. In these
> > > cases, reclaim may invoke shrinkers that aggressively destroy working
> > > sets even though reclaim is unlikely to materially improve the
> > > allocation outcome.
> > > 
> > > Some shrinkers manage expensive backing or migration operations where
> > > reclaim can result in substantial working set disruption despite the
> > > system having sufficient free memory overall. This is particularly
> > > visible in fragmentation-heavy workloads where reclaim repeatedly tears
> > > down active state while kswapd attempts to satisfy higher-order
> > > allocations.
> > > 
> > > Introduce an opportunistic_compaction hint in shrink_control that allows
> > > kswapd to communicate when reclaim originates from a high-order
> > > allocation context that may be fragmentation driven rather than true
> > > memory pressure. Shrinkers may use this hint to avoid destructive
> > > working set reclaim while still participating normally during order-0
> > > or stronger reclaim conditions.
> 
> Thanks for the input - this is a tough problem.

Yes, that it is.

> > To be honest, this seems like another "push a hint through to the XE
> > shrinker" mechanism under a different name. You seem so focused on
> > fixing the XE reproducer that the -systemic problem- that -any-
> > high-order folio demand causes is not being acknowleged.
> > 
> 
> I'm not exactly sure I agree here. Communicating via __GFP_NORETRY or
> __GFP_RETRY_MAYFAIL with a higher order implies that the caller can
> handle higher-order allocation failures, so the shrinker shouldn’t try
> too hard to obtain a large page (e.g., evict a working set). I agree
> that Xe is currently the only shrinker making use of this, but other
> shrinkers could also hook into it. This information simply isn’t
> available today.

Right, but "we are doing compaction" isn't information that tells
the subsystem shrinker what it needs to do. "memory compaction is
occurring" isn't a well defined action like "count reclaimable
objects" or "scan N objects and reclaim as many as you can without
blocking".

Directed high order object reclaim should be much efficient that
trying to use general memory pressure to age out enough objects to
reform contiguous pages. We need to help memory compaction, and we
can't really do that by layering heuristics over reclaim algorithms
designed to maintain working sets efficiently.

> > e.g. we use high-order folios extensively in the page cache these
> > days, and there are -many- cases where memory compaction driven by
> > high-order demand cause significant performance regressions for page
> > cache performance. To date, every single person who has wanted to
> > fix the problem they are seeing has effectively attempted to -turn
> > off compaction- via GFP flags.
> 
> So does that mean they clear __GFP_RECLAIM?

Usually __GFP_DIRECT_RECLAIM, as it's the overhead of direct
compaction that causes the performance problems.

> That isn't really what in DRM or Xe. In former case we have pools of
> lower order pages in TTM not in use that can be shrunk, potentially
> freeing multiple lower orders pages so a higher order page formed, and
> the later possible BOs (sets of pages) in Xe marked as purgable (not is
> in working set) which can also be shrunk. Other DRM drivers have purging
> concepts too.
> 
> I’m not very familiar with what other shrinkers or subsystems want, but
> presumably other shrinkers have pools or caches that aren’t currently in
> use, where they can say, “OK, I’ll give these pages up for opportunistic
> compaction, but I won’t give up my working set.” Of course, as mentioned
> above, if someone else explicitly requests large pages by avoiding
> __GFP_NORETRY and __GFP_RETRY_MAYFAIL, the shrinker should then give up
> its working set.

Most caches are slab-based, so there can be 10s of objects with
different life cycles per page. There is no almost possiblity that
shrinker reclaim will free pages without substantial
amounts of the cache being reclaimed.

> > I've even done that myself inside XFS to work around kvmalloc()
> > issues with a lack of GFP_NOFAIL support and doing costly high order
> > allocations that fail and trigger compaction before falling back to
> > vmalloc().  However, these issues have since been fixed in the
> > kvmalloc() code, such that it now does the right thing for most
> > calling contexts (i.e. tries high-order kmalloc() without triggering
> > compaction, then fall back to GFP_NOFAIL vmalloc()). This has made
> > kvmalloc() more performant and better behaved for -all users-, not
> > just XFS.
> > 
> > This is not sustainable - we need compaction to be robust and
> > performant in the face of high-order folio demands, regardless of
> > what subsystem is generating the demand.
> > 
> > So with that in mind, let me paraphrase the comment in the second
> > patch in the Xe shrinker implementation:
> > 
> > "Shrinker reclaim is based on implementation specific object sizes
> > so it is unlikely to ever acheive contiguous page reclaim in a
> > manner that will measurably improve compaction rates."
> > 
> 
> This might be slightly misworded—what I really mean is that I don’t want
> to give up my working set for higher-order allocations that are allowed
> to fail, but I do want to give up my cache.

Right, that's the core of the problem - compaction is the high-order
reclaim trigger, the existing shrinker infrastructure reclaim is for
the working-set maintenance reclaim algorithm the subsystem uses..

> > You also say:
> > 
> > > No functional changes are introduced for existing shrinkers.
> > 
> > Consider how many shrinkable caches the general statement above
> > applies to, and then think about the fundamental impedence mismatch
> > between the affected shrinkable caches and what this patch actually
> > fixes.
> > 
> 
> Yes, as mentioned above, I’m only addressing Xe here, and I agree that
> this is likely an issue. Do you know of other shrinkers that have pools
> or caches which can be shrunk under the conditions I’m introducing here,
> but also have a working set they would prefer not to give up?

The first that comes to mind is the xfs_buf cache. This cache holds
cached metadata buffers that have different sizes can each contain
up 64kB of contiguous pages. The allocation algorithm uses
optimisitic large folios allocation, but if that fails it falls back
to vmalloc. The working set is maintained by a prioritised
multi-scan LRU so that more frequently accessed metadata is held
tighter by the cache than less frequently accessed (e.g. btree roots
have higher retention priority than the lowest leaves).

It does not currently track buffer objects by size, by if there was
a benefit to doing so then it could be implemented. I'd much prefer
to have such tracking separate to the working set maintenance,
especially as they will likely need some kind of balancing to
prevent high-order buffers in the working set from being thrashed by
compaction demand....

I know there are other caches that have variable sized objects, but
I'd have to go look at the code to referesh my memory of which ones
they are...

> If so, a
> link on elixir.bootlin.com would be helpful so I can take a look. I’ll
> also try to go through other shrinkers myself.

cscope is your friend.

fs/xfs/xfs_buf.c contains the XFS buffer cache and shrinker
infrastructure, but looking at the code without any understanding of
the filesystem structures or how it interacts with the other XFS
shrinkable caches probably isn't as useful as you might think it
will be. 

> > For example, what happens to slab-based caches if the XE cache is being
> > excessively reclaimed under high-order page demand? e.g. the slab-based
> > cache may have tens of objects per page and holds a system-level
> > performance critical working set of objects. How do these caches
> > handle the excessive reclaim demand being generated by compaction
> > thrashing?
> > 
> > Yup, they don't.
> > 
> 
> Agree.
> 
> > In the case of filesystem caches, the "reclaim and repopulate"
> > pattern you describe causing the XE perf problems causes internal
> > slab cache fragmentation. Not only does this not improve compaction
> > rates, it also results in more memory fragmentation because slab
> > pages get pinned by a small number of long lived objects and they
> > won't get freed until the cache is largely emptied.  IOWs, things
> > get -even worse- from a memory fragmentation POV when compaction
> > thrashing causes the working set of a high-object-count-per-page
> > slab cache to thrash....
> > 
> 
> Got a link to the code which you are referring to?

Do a lore search for "dentry cache defragmentation". You should be
able to find discussions that go back to around 2006 about
discussions on identry cache fragmentation and approaches like
slab-page based object reclaim to support internal defragmentation.

The fact that we don't have slab cache defragmentation despite many
years of people wanting such functionality should tell you how
complex the problem is.... :/

> That seems like a problem similar to another issue in DRM/Xe. We found
> that the process of shrinking actually drove fragmentation by splitting
> folios down to order-0 and then backing pages up one at a time. I have a
> separate fix in flight for that.

Possibly, though the life cycle differences I'm talking about can be
a few milliseconds (temporary file) vs weeks (long running database
instance holding it's table files open the whole time it is
running).

> Could the filesystem detect these hints and avoid shrinking in a way
> that causes fragmentation?

Not really. The fragmentation problem is caused by physical object
placement in the slab pages at allocation time, not the act of
reclaiming the object.

i.e. we don't know what the expected cache life time of a dentry or
an inode will be when we allocate it, so it just gets allocated in
the next free slot in the current partial slab page. When you get a
mix of dentries that are pinned by open files in long running
applications and dentries for access-once files in the same page, we
end up with reclaim freeing all the object slots that contained
access-once files. However, the pages are still pinned by the
objects for the open files that are in active use.

IOWs, LRU-based reclaim can free >90% of the objects in a cache that
held millions of objects with mixed lifetimes and still not free any
memory at all. There's nothing reclaim can do about it because the
problem is created at allocation time when lifetime is a complete
unknown.

> Alternatively, could it perform shrinking in
> a way that doesn’t shatter folios, or detect long-lived objects so it
> understands that shrinking isn’t going to help reduce fragmentation?

Referenced filesystem objects are not on the LRUs, so the shrinkers
aren't even aware of such long lived objects. And, as per the
"dentry cache defrag" comment above, we can't ask the slab to
reclaim or move objects because we don't track the owners of
external references to the objects themselves.

> 
> > This isn't isolated to individual subsystem thrashing.  If we run a
> > file-based workload that generates high-order folio demand and hence
> 
> What GFP flags are typical used for file-based workloads?

Mostly GFP_KERNEL, with a mix of GFP_NOFS. non-blocking paths also
tend to add GFP_NOWAITS, and memory reclaim sensitive paths often
use __GFP_MEMALLOC to prevent reclaim recursion. Some filesystems
also make extensive use of GFP_NOFAIL (e.g. XFS).

> > compaction (e.g copy tens of GB of files between two XFS, ext4 or
> > btrfs filesystems), that will -also- trash the Xe working set via
> > the shrinker being hammered by memory compaction try to free up
> > contiguous pages for the page cache.
> >
> 
> I could see this.
> 
> > Similarly, if we run a Xe workload that generates sustained high
> > order folio demand, that will trash the working set in the dentry
> > and inode caches and any other shrinkable slab-based cache.
> > 
> 
> I could also see this but DRM / Xe will set __GFP_NORETRY or
> __GFP_RETRY_MAYFAIL on higer-orders so those caches should be able to
> not trash its working set if looked for this hint. 

This relies on all the allocation code everywhere always doing
exactly the right thing so that memory reclaim "behaves". That is
what I've been saying is not a sustainable approach - all it takes
is one allocation or one shrinker not to do the right thing, and
we've got another mole to whack.  i.e. memory allocation should do
the right/best thing for the system with default parameters.

> > Hence the abstracted case of the problem we need to solve is this:
> > shrinker reclaim is based on x-byte objects is extremely unlikely to
> > acheive contiguous page reclaim in a manner that will measurably
> > improve compaction rates.
> > 
> > This is a problem that has to be addresses by the high level
> > infrastructure level, not worked around by individual shrinkers.
> > 
> > IMO, compaction shouldn't trigger shrinkers unless the shrinkers are
> > specifically flagged as being able to release contiguous pages of
> > memory in short order. I don't think there's very many shrinkable
> > caches that even hold a significant quantity of objects larger than
> > a single page, so it's clearly questionable as to whether compaction
> > based reclaim should run shrinker reclaim to begin with.
> > 
> 
> Yes, sort of do this in Xe by changing '->count_objects' based on the
> hint.

I know. That's the problem - it's relying on the infrastructure
passing down a specific internal context hint in an existing
interface so a specific subsystem can work around a specific
problematic behaviour.

Indeed, for compaction we don't actually care about the count, what
we largely care about is whether the subsystem has any objects the
same size or larger than the current compaction demand. Efficient
object reclaim for compaction has a different control variable set
(e.g. find objects larger than, objects physically near to, etc),
and this can't really be properly fitted into the existing
count/scan shrinker reclaim algorithm.

Hence I think it needs new shrinker methods to implement
effectively.

> > i.e. a subsystem that can track high order folios in a shrinkable
> > cache should probably have a "->compaction_scan()" method that is
> > run directly from compaction context to try to free high order
> 
> When you say “compaction context,” which parts of the code are you
> referring to? I’d like to explore this option, but I need a bit more
> context.

kcompactd does background compaction, similar to how we have kswapd
to do background memory reclaim.

Direct compaction (part of direct reclaim) via
__alloc_pages_direct_compact() that will be called before direct
memory reclaim in the case of a high-order allocation.

> 
> > folios. This provides a direct opt-in mechanism for a subsystem, and
> > it allows subsystems that can track low- and high- order objects
> > independently to efficiently free objects in a way that will help
> > improve compaction rates without impacting the entire working set of
> > objects in the cache.
> 
> 
> Does this help if, for example, the cache is holding onto two order-8
> folios that could be freed and merged, while the caller really wants an
> order-9 folio? This seems like a possible scenario in caches and is
> certainly true in TTM pools.

Depends on how the interface is implemented.

IIUC, the direct compaction code will return a right-sized page
early if it creates one via compact_zone(). Hence if that path can
call into shrinkers to do high-order scanning that results in two
mergable order-8 objects being freed and merged into an order-9
object that fulfils the compaction requirements, then it will result
in compaction succeeding where it currently fails.

And I think that kcompactd will run until certain watermarks are
met, so again having a high-order shrinker that directly impacts the
high order page watermarks would be much more efficient that trying
to use general memory pressure to randomly shoot down enough objects
to reform contiguous pages.

> > IOWs, this patch to inform kswapd about it's trigger (doesn't it
> > already have a "reason" parameter, though?) is likely a necessary
> > part of the solution - we don't want kswapd running shrinkers if it
> > has been triggered to reclaim pages for compaction. This patch would
> > allows kswapd to elide normal shrinker passes when it has been woken
> > purely for compaction purposes. Given that the compaction code would
> > be running the high-order reclaim capable shrinkers itself, this
> > would avoid trashing the working set of most shrinkable caches -by
> > default- under high order allocation demand....
> >
> 
> I’m trying to parse this—are you suggesting that, one way or another, we
> introduce a heuristic where shrinkers can act on a hint (whether it’s
> what I have here or a new ->compaction_scan() vfunc), and then attempt
> to fix all shrinkers in this series?

I don't want existing shrinkers to be touched at all.

What I want is for memory reclaim (both direct and kswapd) to elide
the shrink_slab() calls into shrinkers when memory reclaim is being
driven by high order allocation failure.

i.e. high-order allocation failure should not generate shrinkable
cache memory pressure because shrinkable caches in general cannot
return contiguous memory that will allows compaction to make
progress. The existing behaviour has more negative affects on system
performance than positive, so we need a fix for "everyone".

I think we should provide a new opt-in ->compaction_scan() method for
compaction aware subsystem shrinkers that is run from compact_zone()
context. This allows subsystems that can manage high order objects
to optimise the return of high order objects to the free space pool,
thereby significantly improving the chance for compaction to
succeed without adversely impacting the rest of the shrinkable
caches in the system.

Further, we should not kick kswapd because of compaction failures
because kcompactd will already be running ->compaction_scan()
capable shrinkers from it's callouts to compact_zone() in the
background that will do this work as efficiently as possible.

> I’m open to trying to fix other
> shrinkers as well. Do you have any particular ones in mind? I count
> around 45 shrinkers in Linux, so it’s unlikely I can fix every single
> one, though or all shrinkers need to be fixed.

They'd all need to be fixed, which is why I suggested a new method
to be added. Avoid calling the existing shrinkers in the adverse
situation, call the new one from the right context where it actually
benefits compaction and high-order memory allocation.

> On a side note, I just noticed that struct shrinker has count_objects
> and scan_objects as individual vfuncs rather than using a const struct
> shrinker_ops *ops. Should we change that? The latter seems cleaner and
> is typically how things are done in Linux.

We probably should - the current structure is largely historical and
there's only ever been two methods. If we are adding another method,
then it would probably make sense to add an external ops structure
to reduce the memory footprint a little.

-Dave.
-- 
Dave Chinner
dgc@kernel.org

