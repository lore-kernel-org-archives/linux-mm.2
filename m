Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A95D4C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 11:39:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 955216B0088; Thu,  9 Jul 2026 07:39:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DF666B008A; Thu,  9 Jul 2026 07:39:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 781716B008C; Thu,  9 Jul 2026 07:39:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46E816B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:39:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D3084166814
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:39:16 +0000 (UTC)
X-FDA: 84969042312.02.1ECF7CC
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9ECD9C0009
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:39:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Yddf6CYv;
	spf=pass (imf28.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783597155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2+0CMz74OTc2uduve0AH5zq/sAPYYSAi9CmWx8qrG8c=;
	b=MxhYd+DNcLCrjuO4bwHhb0EH4sb9yd0JYjN38xpezVjBCN7j++qTH44kAF0pR+MzYYPWln
	/TsK/xHvcRZtf1yJrXe8VOOa88WBkcN0sFyEMk093wfj2fkV1wwbzlYKoi4h/mwzIVNC+B
	YRuDib45QC9m9523k+fiXscCzvODIFQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Yddf6CYv;
	spf=pass (imf28.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783597155;
	b=hfCUfsqCdDWLIkI3RIipvJhbZz+hMlMTcktxetuPpihWq63zLLoJ3tI4KzHuQnNQEbd/nX
	avS0CyhyA9pGfCzsWtIFY7d52SzCTSkk8eaYxyu9Xjrq8fvfbIPyXDRU1pj5H5EiETCwf4
	mwKvsXgTbtnCRpOY1l7BfoNFa3TmX98=
Date: Thu, 9 Jul 2026 19:38:51 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783597151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2+0CMz74OTc2uduve0AH5zq/sAPYYSAi9CmWx8qrG8c=;
	b=Yddf6CYv95Il95DagSO2rkL6G5KuvItxo8lRM6AS0BBvH2aJgY0C1/i8DB00l4h0oGhzaC
	+zFF0csDVs1gZgo5jF0dZgjgcn6oTwoTRS+yOJX4zpNqA812aG7bNwYPbiLsSunD4FXmKH
	NU2wK9+PdTI8ASRO901UF6r0mn7SVO0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org,
	youngjun.park@lge.com, hannes@cmpxchg.org, yosry@kernel.org,
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/10] mm/swap: ghost swapfile with backend switching
 via Redirect entries
Message-ID: <ak-IS61GeP85Jnxg@MiWiFi-R3L-srv>
References: <20260707082614.95030-1-baoquan.he@linux.dev>
 <CAKEwX=P50av2rfocpsqZoDQowZ=EEhQ-5vj5tBykbNz8vtKTzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=P50av2rfocpsqZoDQowZ=EEhQ-5vj5tBykbNz8vtKTzA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9ECD9C0009
X-Stat-Signature: uu4qubkr5rcb4gw1cshp8onwyea33nsd
X-HE-Tag: 1783597154-64446
X-HE-Meta: U2FsdGVkX19aL87IXdp5oM/MGS1t7dZIQVxj4szd+Q9LfKkjdAVNklbLoMde2g/eEAAnQCCBDvK1+0Cl13odjPxuha7plCFqqVgtMGCSPRSmOe+QgMHlfmLB7zuxypyCken9RkEbbFntw9jP6YqHno4Pm60qxElYnBznFpBDA8oMi/AZ3vKZ7Pz2z7PPOdmnFK8iGcJXRfcMNLkEjQhO7BgoJ4R4zVL8jnlNkW78E/ytbjrUyV7SZM5Pv+CTIsuAHwTyH3wp4IGbO5OHNb+YOYjgBm3rdCfC63jFm3hljaox9/b27l9N0mwJrQHXa7ut6zRRdvoB2ip4TGGmcjYcC28eRu5U3LNMhoPgOhi/NN/tDfptsRaHMlHEJU1EQ6BqW713ohPrZp9pKhfmBcIeBGMnpr8ap9+IsRqqJvsOFC3wmaUQqzHU99z+3PxqmulLzqZNBs5VXlUBFy7LVYietHeDCLMXTGNeL4sZpGdTDlsYpB0/6/RV6q6jXYH9tUItOAud6ySUABkJskt5N+tUH01NCEeJ4iTDSlKhTxbOi2ecHgmXZ3nOKy5X/5Pd0d/AGVh/tcAjRiIknAVl4P60hCYCAL/NX4j67gRGBAAD/13rxJskfU5Nfd05W5CrrmYtZ3kTxyJ9XXwKEnKiBgvDxKRIytIRpoc5AqqeLAOcVW4WMc2Mo0yy65CIJbpTFBVA8ETemKwKHXiQYOlDfR/3gbumDNjA0IkXUUKULwJxRW+xDVBZjvcX4nL9BdTMMI3MjJY3EQU4NTSEtgj0M18VcF4E7Tjewpa84jRckvlnGEnUT67uXR09vtQrJs/63Vxs1BGdGX6ZgxkngdzCMbkiVbHyyaRt4XNkCssLvxBKNH69dNYMNsz4/8wYsD5hc/ZHrb6Kc1iSGODnEX7eCcLgS8HIKcWSyEVRPs6uyMMs89/wG5Mx3YlG2y/IhrKrusdWdxw5y3wk1tcUDSPGEVU
 bcUbT+Dl
 QwyC1QngiGUnDoxjfLi7La9xEBGgMq0hcx37z8ponCl7g+z5pmlq4+BZ3k/DXlGJHoKC3IoN1lEciW+JLIBPhaz4dVisefejafOE9oGr6FlHwPcKPkHx1+c0YtJRgkZ98EiyBB6kpVNPQi7JPN6k9JI99eL87cP8oNK3ocCotcQWNu0FDLqfGeY5aPSDtNFuR4fYzRamMBYdx0WOdd2nte78917OvwoHUa3f3h9cyQnArdboOoHVxT1H+rSvIz+Gzg3Nx7a2e61ggf8lmA3CTRtB8kQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/07/26 at 02:23pm, Nhat Pham wrote:
> On Tue, Jul 7, 2026 at 1:26 AM Baoquan He <baoquan.he@linux.dev> wrote:
> >
> > This series introduces a virtual "ghost" swapfile that can be backed
> > by multiple physical swap devices, switching between them at runtime
> > using a new "Redirect" swap table entry type.
> >
> > Motivation
> > ----------
> > Physical swap devices have fixed, large sizes but a machine may only
> > need a fraction at any given time.  Ghost swap decouples the logical
> > swap capacity from physical swap allocation: it presents a large
> > virtual swap device to userspace while lazily mapping slots to
> > physical devices only when data must leave zswap (writeback).  This
> > enables overcommit of swap capacity without wasting physical disk
> > space, and allows the ghost device to grow dynamically at runtime.
> >
> > Ghost swapfile characteristics
> > --------------------------------
> > Ghost swap decouples logical swap capacity from physical swap allocation.
> > Key properties:
> >
> > - No backing store required.  A ghost swap device can operate purely
> >   as a zswap container — compressed pages stay in the zswap pool without
> >   ever touching a physical swap device.  No physical swap device needs
> >   to be attached.
> >
> > - Optional physical backing.  One or more physical swap devices can be
> >   swapon'd alongside the ghost device, acting as writeback targets when
> >   the zswap pool needs to evict cold pages.  The Redirect entry in the
> >   ghost swap table links each evicted slot to its physical destination.
> >
> > - Dynamic size growth.  The ghost device can be extended at runtime via

Thanks for the thorough review, Nhat.
> 
> We don't want to put additional operational burden on users. Besides,
> expecting userspace to react to swap space being filled, especially
> under memory pressure (at which point userspace processes might be
> stalling already), is tricky.

The manual sysfs extension is the minimal viable interface for the RFC,
not the final choice. But even in its current form, it is a dramatic
improvement over the status quo.

Today, to use zswap you MUST provision a physical swap device of the
same size as the swap capacity wanted — even though most of that disk
space will never be touched.  With ghost swap, you swapon a ghost
device at whatever size you expect to need (e.g. 64 GB), and if your
workload grows, you grow it via sysfs.  That is already a step
change in operational simplicity: no disk pre-provisioning, no wasted
storage, and a one-line resize when needed.

Automatic growth can be considered later if it's really demanded.

> 
> This is especially bad when redirection entry still eats up space in
> the upper level (ghost zswap) swapfile. You will run out of zswap
> space really fast under concurrent zswap store and zswap writeback.

I think there is a misunderstanding here.  A Redirect entry does not
consume an *additional* ghost slot.  Before writeback, the ghost slot
held a Pointer entry (zswap).  After writeback, that same slot holds a
Redirect entry (pointing to the physical device).  It's a state
transition — one slot, one entry — not an extra allocation.  The ghost
device's total capacity is unchanged by writeback activity.

> 
> >   sysfs, up to a current maximum of 1TB.  This is implemented through
> >   lazy vmalloc: a sparse 64MB virtual address space is reserved at
> >   swapon time to cover the full 1TB range, but physical pages for
> 
> This range seems a bit small, especially from something essentially fixed.

The 1TB limit comes from a conservative 64 MB sparse vmalloc reservation
in RFC. It certainly can be redefined as a bigger one which is more
reasonable in reality. For most real-world deployments today, 1 TB per
ghost device — with support for multiple ghost devices — is more than
sufficient.

> 
> >   cluster_info[] structures are allocated only on demand as the device
> >   grows.  The cluster_info pointer never changes, so all existing
> >   accessors (__swap_offset_to_cluster, cluster_index) work unchanged.
> >
> > - sysfs control.  Each ghost device exposes attributes under
> >   /sys/kernel/mm/ghost_swap/ghost_<N>/:
> >     path (RO) — backing device name
> >     max  (RW) — current max pages; writing a larger value triggers
> >                 swap_ghost_extend_max()
> >
> > Design overview
> > ---------------
> > A swap table slot can now hold a Redirect entry:
> >
> >   Redirect: |----- physical swp_entry_t -----|101|
> >
> > This stores a plain swp_entry_t pointing to a slot on a real (physical)
> > swap device.  The low 3-bit mark (0b101) distinguishes it from Pointer
> > (0b100), PFN (0b10), Shadow (0b1), and NULL (0) entries.
> >
> > The lifecycle is:
> >
> > 1. swapon a ghost device — reserves sparse vmalloc area (64MB virtual)
> >    and physically backs only the initial range.  The device starts with
> >    no physical backing store: pages swapped out go to zswap, and zswap
> >    pool evictions go to any concurrently attached physical device.
> 
> If you think this data structure is superior to the xarray for dynamic
> swap address, it's a fairly simple change on top of what I had in the
> virtual swap RFC, no?

I appreciate the suggestion. However, the difference between the two
approaches goes beyond the cluster allocation strategy — it's
the overall architecture:

- Virtual swap introduces a mandatory, always-on vswap device (CONFIG_VSWAP).
  with per-cluster virtual_table arrays, xarray-backed dynamic clusters.
  per-CPU allocation caching.

- Ghost swap extends the existing swap device model with one new entry
  type (Redirect, 0b101) and one new flag (SWP_GHOST).  It reuses
  swapon/swapoff, the existing allocator, and the swap cache
  essentially unchanged.  No Kconfig option is needed.

These are two explorations of the same problem, while virtual swap goes
far beyond the problem itself, the decoupling of physical swap and
virtal zswap. We can discuss and choose one approach.

> 
> It can be grafted on top of what I had in a subsequent patch, or
> squashed into my first patch. If you have concerns with me
> implementing your idea here, I'd take your code if it proves to be
> superior.
> 
> >
> > 2. zswap writeback from ghost: when the zswap pool needs to evict,
> >    zswap_writeback_ghost() allocates a physical slot from any real
> >    swap device, writes the data there, and plants a Redirect entry
> >    in the ghost's swap table pointing to the physical slot.
> 
> What if user swapoff the physical swapfile, whose slot is backing a
> redirection entry of a ghost swapfile, rather than a PTE. Has this
> been handled yet?


This is a gap in the current RFC.  Both swapoff and physical-slot
reclaim would need a reverse mappingfrom the physical slot back to the
ghost entry to be handled robustly. This can be added in a future version
if there is consensus that writeback-to-physical is a necessary part of
the design.

I think the primary motivation for ghost swap is to enable zswap
usage *without* a backing physical swap device at all — the "No backing
store required" mode described in the cover letter.   In that mode,
writeback never happens (there is no physical device to write to), so
the swapoff and reclaim questions do not arise. Ghost writeback to a
physical device is an optional extension for users who want the safety
net of disk-backed swap. Surely we can discuss and decide if we need
add it or not.
> 
> Similarly, say the physical swapfile is full, and you attempt to
> reclaim a physical swap slot that is swap-cache-only (swap count = 0).
> Say this physical swap slot was allocated from a previous zswap
> writeback attempt, i.e it has a redirection entry in the ghost zswap
> swapfile associated with it. Did we handle it somehow?
> 
> My apologies if I missed it somehow.
> 
> >
> > 3. Swap-in from ghost: swap_read_folio() detects the ghost device
> >    (SWP_GHOST), resolves the Redirect to the physical swp_entry_t,
> >    and forwards the read I/O to the physical device.
> >
> > 4. When the swap cache folio is removed, the Redirect entry is restored
> >    from an xarray (redirect_xa) that persists the mapping, so
> >    subsequent reads still find the physical backing.
> >
> > 5. When the physical slot is freed, the ghost slot is also freed,
> >    cascading through swap_range_free().
> 
> I don't get how *any* of this is simpler from what I had. If anything,
> it's more complicated. With a vswap device, you just allocate a
> physical swap slot (which you also did), change the backend, submit
> the IO (which you also did), and that's it. No need to juggle this
> redirect_xa entry. What does this redirect_xa buy us?

The redirect_xa persists the ghost→physical mapping across swap-cache
folio teardown.

Ghost: redirect_xa[offset] = phys  (only allocated when Redirect
       is active) + swap_table[slot] = Redirect(phys) once the
       swap cache folio is removed

> 
> Not to mention now it entagles generic swap logic into
> backend-specific code, unnecessarily. And we have more state in the
> state machine to consider: With a generic vswap device, vswap -> disk
> swap directly is the same state as vswap -> written back zswap entry.
> With this zswap ghost swapfile design, you have to treat the latter
> separately, as there is a redirection entry involved, which means
> concurrent swap operations interact with it.

I'd argue the opposite.  Ghost swap touches the generic swap paths in
very few places:

  - swap_read_folio:    one SWP_GHOST branch → resolve Redirect
  - __swap_cluster_free_entries: one Redirect check → cascade free
  - __swap_cache_do_del_folio:   one redirect_xa lookup → restore
  - zswap_writeback_entry:       one SWP_GHOST branch → ghost writeback

Ghost swap only affects behavior when a ghost device has been
explicitly swapon'd, and even then only on the paths listed above.

This is different than virtual swap which is more ambitious. As I said,
ghost swapfile focuses on the problem itself, and based on the swap
table.

> 
> So it's more complicated, and achieve less - this is specific to
> zswap, whereas what I provide is something generic to swap
> infrastructure, which can be extended for future backends. I would
> understand if it resulted in less overhead (which was the argument for
> my pre-swap-table vswap design), but this seems like it's just virtual
> swap, with similar space overhead (technically a bit worse since you
> added redirect_xa xarray to physical swap cluster too), and with more
> complications?
> 
> >
> > Note:
> > ------
> > Ghost swapfile is a proof of concept. Compared with the other patchset:
> > [RFC PATCH v2 0/7] mm, swap:  Virtual Swap Space (Swap Table Edition),
> > it explores a different approach to implementing virtual swap on top of
> > the existing swap table infrastructure, with a simpler implementation.
> 
> You neglected to mention that this "simpler" implementation lacks a
> lot of design choices. Just on top of my head:
> 
> 1. Certain optimizations for cases when vswap points to disk swap.

Ghost swap's Redirect entry directly encodes the target swp_entry_t, so
the swapin path resolves it with a single cluster lookup — no extra
indirection through a virtual_table.  For the hot swapin path, this is
an optimization, not a missing feature.

> 
> 2. No reverse mapping, or at least some mechanisms to handle the case
> where you have to go from physical swap slots to the upper layer.

Acknowledged — a reverse mapping can be added in a future version if
writeback-to-physical becomes a priority.
> 
> 3. Charging behavior difference, and deduplication of metadata when we
> have multiple swap levels. (In fact, you seem to be double charging a
> writtenback entry here towards the swap counter, not just duplicating
> the metadata space)

There is no double-charging.  A ghost slot is charged to nr_swap_pages
when the ghost device is swapon'd.  When zswap writeback allocates a
physical slot via alloc_phys_swap_slot(), the physical device's own
inuse_pages is incremented — but this is the physical device's
independent accounting, not a double-charge to the ghost device.  The
two devices have separate si->inuse_pages.  That said, we agree the
swap counter semantics need to be clearly documented in the cover
letter and will do so.

> 
> 4. Infrastructure to make sure allocation from this swap device and
> allocation from the backing swap device does not invalidate each
> other's per-cpu allocation cache. You seem to just go for the slow
> path with alloc_phys_swap_slot() for zswap writeback?

Yes, alloc_phys_swap_slot() uses the slow-path allocator
(cluster_alloc_swap_entry), which is correct for this low-frequency
operation.  zswap writeback is not a hot allocation path — it runs
from the zswap shrinker under memory pressure, typically hundreds to
thousands of operations per second at most.  The fast-path per-CPU
caches remain dedicated to folio_alloc_swap(), which handles the
high-frequency swapout path.  There is no cache invalidation problem
because the two paths use different allocation mechanisms on different
devices.
> 
> It's fine to disagree with any or all of these design choices of mine
> - I'm receptive to discussion. But it's misleading to say you have a
> simpler design here, IMHO. My design choices resulted from multiple
> thoughtful iterations (a lot of them could be found in my
> pre-swap-table version of vswap) and real production pains.

You're right that "simpler" needs qualification, and I'll update the
cover letter accordingly.  What I meant — and what I should have stated
explicitly — is that ghost swap is less invasive to the existing swap
infrastructure:

  - It does not require a Kconfig option.
  - It does not create a boot-time device that lives for the kernel's
    lifetime.
  - It does not introduce a new per-cluster data structure
    (swap_cluster_info_dynamic / virtual_table).
  - It does not add a separate per-CPU allocation cache.
  - It does not split the swap entry namespace into "vswap" vs
    "physical" — a ghost device is just another swap device with one
    extra flag and one extra swap-table entry type.

I think VSS goes beyond solving the "zswap without backing store"
problem — it is fundamentally an architectural restructuring of the
swap subsystem, with virtual swap as a first-class abstraction layered
above physical devices.  That is both its strength (comprehensive,
future-proof) and its trade-off (more invasive to existing paths).
I respect that.

My goal with ghost swap is different: address the immediate pain point
with the smallest possible change to the existing infrastructure.  Both
approaches have value, and I hope the community discussion will help
identify the right balance.

Thank you again for the detailed review — it has already clarified
which parts of the design need more thought and documentation, and will
make the next version stronger.

Thanks
Baoquan


