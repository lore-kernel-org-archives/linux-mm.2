Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 712EDC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 13:38:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71C0C6B00DC; Mon, 17 Aug 2026 09:38:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CD5C6B0153; Mon, 17 Aug 2026 09:38:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 595056B0154; Mon, 17 Aug 2026 09:38:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 297146B00DC
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:38:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B57C91A0600
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:38:52 +0000 (UTC)
X-FDA: 85110866904.05.1C08BD6
Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9C22F40003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:38:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="r dexEUL";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=aWVHY5am;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.140 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786973930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SEfs6ZWShiX/3hP/8l96aK7O9NMdD6RUbsJT4AxCCDo=;
	b=FnageEBYtOkekOhl/ePypBf7tgWrXPIyk8kldup/WbWsmIAYWPsllr1Y3zlNyeOt39CCKI
	mcFZVtjADqUlOZJDi71s8Z+Ejuu4qhBcN2TU9JC18FsRbfZAC2GswrxNE7JjTuJPgcgFVe
	lphrvVTiKglO0YxBfVOm+NmluFMPLKA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786973930;
	b=WFH+dZg/1gVxhi8TgVi06Ir18qZ5TLRR3V8BAat9vFIZPF+8zUPxQ2Md/8keCGWjE6uPhH
	y6O5axwpiR4WVpTgWyZbM3pVxkYkoIy+eP6JSd1EVwCK4u/MtvAqzdVUmVzAZAmQmqFmYr
	vyRvS4YQ10bws5J3iGG2Z/U1F3h8XDg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="r dexEUL";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=aWVHY5am;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.140 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id 6A8121300549;
	Mon, 17 Aug 2026 09:38:48 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 17 Aug 2026 09:38:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786973928; x=
	1786981128; bh=SEfs6ZWShiX/3hP/8l96aK7O9NMdD6RUbsJT4AxCCDo=; b=r
	dexEULdHkyXfd7yrvYdOedXzePPleAiAgsh93g2DuqQr+cNQK6ymCJDEj/HJC/Kx
	mgz2Kzm1iOZdrtzUP68v/CSxu1DRb71pp8ooCJBSO38ThNlS0Di/k4wh92iT+MiS
	KVGckTHvdEAW4uvG7pFEurHr5cVvTv526AREQojdjFb2JKTYAH98siOdryVF7ha1
	tX4kR4yZuinXbmv10NOrglWnKAGN9SLGq84VAzICI5u7Y6Y9k5FE1m7ybk3hlnGE
	gcILj+TsQFX43mwgsLugQvNuAAu0E7sAbaBIaRe5nhuE0hw22ieElxfUINYi0czS
	hxPofdOUGStUnck7ONQww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1786973928; x=1786981128; bh=SEfs6ZWShiX/3hP/8l96aK7O9NMdD6RUbsJ
	T4AxCCDo=; b=aWVHY5amW3c5uUPd0OT/i2gLjcf3L42ns4V9zAigHz5BPBhnU1C
	bjLutYxI9GlQ2RoJV+QY7xHBeC8RRwcs8rDPucMHfiPVzewGPzsE6VTZPGM6yRQC
	pRDifZsH9uKhpUpSKwJ7YlPr0ExVgC/xf8B8v4pd52ehghP2z67EEKWVJzswK4+Z
	uelsge8oqJ46P8FAakg9hgy0a3s0j5/hbm0bxE9G+L3mftCj4nX5KDKVypqw9pC5
	/h94En0MrcBIu9W6la+krVyOTGJI8T0hBWcduDol0AvU5SMi/ZESVaj5lhWbxc4M
	4eAHTVxEgqd6mbSYp0S/GKk8HeGv56qL87A==
X-ME-Sender: <xms:5g6DauS06NmOgpRdVcoC0905EUu7C6f9aiRq0pijS9p7EgyKaAtTZA>
    <xme:5g6DakNV3HP-K8cbA3snPAryVoGvCidlH3_0ZIE3NmhPCDrMgMShNlKdBIUfhP8tt
    aYmuzkkeWHbiUazyGEHScZVWRzAs7h73R92ds-KL5VSH0zE2f3rz8Ix>
X-ME-Received: <xmr:5g6DatQVkakMfAWnD8gJbAh7hM_l8Ik7YUhyXhLNQ0ZXlfm6is845JI-RHo>
X-ME-Proxy-Cause: dmFkZTFHDVGILOD2xcTq+/CoO5C+XuPBjrc2MONKiZETyeSg+7Oqn8vyO73k6E6OkxlzU1
    E4Z7tj1vL0d79MKvgfZB4GZnOsSkcX1F51tL/5L12VNAADGXdOXYSCUOPdy25Q7cUIk5Q5
    g0OG32L2oElG27Qupnk64aOm0Wi77s3x8uFBEy4S4cbWvnnAc/JUV4tZnnghs79RWrY8rz
    kHzAuOb6xNYF3ODVV+SUQP4iBDERmoL9a3LllnBTcHu+6537hXhy3KjDUrnA0TmfQWc96i
    UVb2ozp660NxgolIz8qZGOtMSacwUGliJSycff8Trj97WAEB9FTDgB1ZOuN0n3cqcyiVkK
    ZQSCzsRO4YSZFfC6dFKpbwnYwKN/23q7b0zI7b+F+DSht8HgAysEwylBrckoZMvuRgTvLZ
    oGG2NqVqxFFMbxptY83UObDw+y2EkWuN2q5NWNUqX2rp0KCgnA+TYbMmOJ9mikxrT75mbX
    Wp+bWYxnpXjgiW9+9wqV4NfgyLYNsJJNhJQDDv69Xgt4j8UDLzlHAl8WW+9Y2uvcHHzHHu
    IE7flWz6Mv5qsQdZVpxE9oB7zY4sHqHiLOQxjp95AOV8oL3h1PoElAEwWN76G7/zF01sDu
    KNyD2c3HVV/aP6rrmBXEpue2eyLwscgGzbjmsiEPeK2CBhRGwD9llLVk1tnA
X-ME-Proxy: <xmx:5g6DaqDqfbDuio8gfYIV139JsmyjouycWk7sXRvTSUq0lH_YwXrCbw>
    <xmx:5g6Dam4SeFuOpIbCrnE0F9rGr_4qPoX2YATINnBSE87gStM5D9bBdw>
    <xmx:5g6DavDnofxzixPucUW8pa3aqTmcDNvue4S08OSk2CdlUbP4k5FxLg>
    <xmx:5g6DaqdzD_M0LESewjQPpQ0zfZUopCP8cDSEQXTreP2LGht1DOPY9Q>
    <xmx:6A6DalqkYipgtd16wMoeU_d1Ds7n7B1baHPL6wEpmXY9xtTJYN8FaTU8>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 17 Aug 2026 09:38:45 -0400 (EDT)
Date: Mon, 17 Aug 2026 14:38:44 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jannh@google.com, willy@infradead.org, pfalcato@suse.de, rostedt@goodmis.org, 
	mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 00/57] mm/collapse: rebuild collapse on migration
 primitives
Message-ID: <aoLkMUtmzRVuv2Hx@thinkstation>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <aoLAly-oL2OAa4n8@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoLAly-oL2OAa4n8@lucifer>
X-Rspam-User: 
X-Stat-Signature: jq6u3hkgzhdgrs4kbpqnnrmozoihr4ps
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9C22F40003
X-HE-Tag: 1786973930-413917
X-HE-Meta: U2FsdGVkX19VtGkWNeVDwroeBWZygtkNEIGfssbc/c/hg7dZEB6/s/FZVJcP0aHMPekl/8tijlilODKk72tW/WmX4t9nH0CpwdjyKR6Wyou+fb+y9H2hCimidtYW/s7DEN/MrxJfZ0DvSb50xNdvDZRrRIdqMYIeuwhkvkeDJkTyinnjjonX0YrwK145SPzR/q9IbbBwiqhW2Fr0MpeUDn5zLCRTLyY8wKaaR07noxH89Z4WYAYHUq1Ty9STFfQqyqGvCgGqMWWErWd9sUgp0vFStw+3oXmey/WoDK7GPko1pcOl5iP1BcwGzw2lbv2EzDJ6Cr67qTUw72xZuoN/9Q7tgOslRZyJHKGVDBxMxUTsJyyhZdm8m30wcesl6LZyH1K3Bw2yTdcA1X05UrYTVDnCQI1VKqrELjxPe+oQ1FAJWEb0f+JUj2VWmOR9MWfMIp1oo3Np74W3J9yQqI82oEzz4e+g/Xh85LB74v7k1bb6SpWpqdT/qMNqCixOIPXwGDpADDeUBS4fTsgQi4HnzLgQY3bv3L/AuujZkYgXeHIZm5A6AyIT/1phBg3OgwF4vuRxu6YnxkY6IS7sGWXqDYyrmyU4k9dt15tXH9uuxdpGAppXjUeQ/K2VsWrD2wq1INViDnCSoPKWy1W6XE0xBsR0lVyloikPfCfB5zukr297kZG7pL+O57TNii5WsRTNKteCL0Apr5/Epa8fhDfPnJLj7gxHg4Ay7i1GH40SfYhivpFpClhIP7P0D9mx0dsJLIIgFgZstFlr8MmsI8o95wD5ghT/vbphgyOO7Zqr+YPmMsgvCQ496dqAJqNccIlqRtcXvxA8kn/nQCyl6s4El2/Bik76W5Rd9rF9SG3IgAxWo7cvso032xLgHVYz9tiDXFpaiBkZgL/CS0bfWbVgKRP2gMGCl5knMQ2F6+TYN76Dz0j2ooYZCJ9NjnkP1W7yytYm+0u/z0hbsH3LVMG
 oGhq9Ddk
 Iu8jrY1YhcVR1IhBVaAxNGdgqkw/pJJvq9E5Y/UsKUNWn58X0vEzBgi9gXfcXAHDyXFzDvd7EgIJ+fU+XSgBtFVCDyJbk32wvqsiAsARYkXHYas3nEucEYR5SQBxPqJomn9/oK9aaKFbnvWy58vfHiyTjDutzI/C90gXuC0QBXreHtMSXtibNh9wQ3jOg2TJmH7g1kmEtuGBXc36Ks7YKk0l6qRQdEoFapqSKnMBptO5iFrVvL4dJ7dXp6p2KJbfee9JX+ItsAIqoOxyz0N0H8zAl9pXy/KtUCs9HXwjK9+9RmKtqg529chpV4NqlRMUemW4wpjANCWgcJPJNJJRVa5PHZkEfj3aRu6MlHC5+hrre2jSN7lt/sIpvP/OiP23tjvd1XisJe5wLbV2AxVjALhQ8tHRttwvEetYbTLTARKHZJj99RPEtAOAr1JOBRnhdJNrcp/nwOgH5XC6oTRvr6utJWozGGCW+coZrCnM7drZrWMilIb0xbQxCliCP+RtGwVbGi73ZgIqikx8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 09:52:13AM +0100, Lorenzo Stoakes (ARM) wrote:
> We have a THP cabal meeting every couple of weeks where it would have been
> useful for you to raise this first.

Fair -- though my invite is on my old @linux.intel.com address.  Could
you forward it to kas@kernel.org?

> In any case - this series is not something we'd consider at the moment,
> even broken into parts.
> 
> David and I have put THP into feature freeze - until the codebase is
> subtantially improved we're not really interested in seeing significant
> development.
> 
> The technical debt is substantial and has to be paid down first.
> 
> See [0] for a rough list of TODOs in this regard.

I read the TODO list and I'll pick from it -- though I notice the
technical debt section includes "Literally all of the code in
mm/huge_memory.c and mm/khugepaged.c", which I'd argue this series is a
fairly committed attempt at :)

One clean up I wanted to do is consolidate code by functionality, not by
the THP/non-THP split.  Move all page fault handler code into mm/fault.c,
unmap code into mm/zap.c, fork's copying into mm/fork.c -- mirroring
kernel/fork.c, so the mm half of a subsystem sits under the same name.
Large folios are an integral part of mm nowadays and I don't think we
benefit from keeping THP in a separate file.  It is also an opportunity to
shift away from mm/memory.c being a kitchen sink.

David and I talked about this at LSF/MM.  I can give it a try if it fits
your idea of "feature freeze" -- and if it doesn't collide with the series
you have in flight, in which case I'd rather go after yours than around it.

> > Why
> > ===
> >
> > mTHP collapse landed in khugepaged in 7.2 and I was glad to see it.  We
> > at Meta run arm64 with 64K base pages, where a PMD is 512M: PMD-order THP
> > is of limited use at that size, and mTHP is exactly what we want.
> 
> Do you have some numbers that indicate to what degree mTHP khugepaged is
> beneficial?

Not from the fleet yet -- that experiment is still ahead of me, so I can't
give you order-by-order numbers.

What I can say is that on x86 we lean on khugepaged heavily to get THPs in
place; it is not a marginal contributor for us.  On arm64 with 64K base
pages we get nowhere near the x86 numbers without khugepaged being able to
produce mTHP at all.

I'll grant the other half of it, and more strongly than you put it: for a
64K mTHP on a 4K base page the TLB win is modest, and with today's
mechanism -- which clears and flushes the whole 2M PMD to install it -- I
can believe the disruption exceeds the gain and the net effect on a
workload is negative.  That is what I measured: a thread reading and
writing a region while khugepaged collapses it at order-4, read p99 3071ns
against 1023ns.  It shows the disruption is real and that it comes down;
whether the collapse pays for itself at that order is a separate question.

> > khugepaged only ever looks at PMD-aligned windows, and it is not an easy
> > limitation to lift.
> 
> Yes. This assumption is very much baked in.
> 
> I guess this is coming from the perspective of having ranges that are
> neither PMD-aligned nor sized (far harder to achieve with 512 MiB PMD size
> obviously).

Right, and it is the size rather than the alignment that bites.  The real
requirement is that a VMA contain a whole PMD-aligned, PMD-sized range,
which at 2M most anonymous mappings of any size manage and at 512M almost
none do.  That is why the limitation was easy to miss until the PMD got
big.

> > Fixing the alignment is a one-line change, but what it feeds assumes the
> 
> Hmm not so sure about that... especially given how baked in these
> assumptions are.

I think we agree -- that was the setup, not the claim.  Dropping the
ALIGN() is the one line; the point of the sentence is that it buys nothing
on its own, because what you then hand a sub-PMD range to still clears the
whole PMD and still demands the VMA span it.

> Which by the way, all speaks to the need for rework.
> 
> The first stage in my view would be to improve the code to the point that
> these kinds of assumptions fall out of it, which then lays the foundations
> for future changes to eliminate the assumptions.

For the plumbing, yes -- policy, file layout, the scan/run split all
improve by refactoring in place.

I don't think the locking model gets there that way, though, which is why
I built a second engine rather than morphing the first.  The old safety
argument is "hold the address space still"; the new one is "make the
sources inert".  They are not two points on a line -- mmap_write cannot go
before something else holds the sources still, and doing that inside
collapse_huge_page() means replacing the copy, the install and the rollback
at the same time, which is the whole function.  Every halfway state has
neither argument in full.

What is gradual here is the review rather than the mechanism: the engine
arrives one pass at a time, each reviewable alone, with the old one live
until one patch switches over.

> > PMD everywhere that matters: collapse_huge_page() clears and flushes the
> > whole PMD whatever order it is collapsing, installs a PMD leaf because
> > that is the only thing it can produce, and keeps everyone out with
> > mmap_write_lock, anon_vma_lock_write() and an IPI broadcast while it
> > does.
> 
> To be clear - the anon path. I think important to clarify :)

Yes, anon only.  The file path moves into collapse.c and picks up the
scan/run split, but its mechanism is untouched.

And you are right that "installs a PMD leaf" is wrong above: only a
PMD-order collapse installs one, a sub-PMD collapse repopulates the table
with PTEs.  What is order-blind is everything around it -- the PMD is
still cleared and flushed first.

I would like to bring it into the engine as well, and with it the private
copies in MAP_PRIVATE file mappings, which neither path collapses today --
the anon side requires vma_is_anonymous() and the file side works on the
page cache.

I stopped because I wanted to keep the patch count in double digits. :P

> And yeah it does IPI for any sensible arch (with
> CONFIG_MMU_GATHER_RCU_TABLE_FREE) via tlb_remove_table_sync_one(). The
> other arches IPI anyway on TLB invalidation.
> 
> [Though I intend to make all page table freeing RCU relatively soon which
> should? Eliminate the need for this, possibly?]

That would suit this well, and it is worth covering deposited page tables
in it if they are not already in scope.  Today PMD collapse has to deposit
a freshly allocated table rather than redepositing the one it detached,
because a deposited table must be safe for zap_deposited_table() to free
immediately.  Make that free RCU-deferred and the detached table can go
straight back -- one allocation less per PMD collapse.

> However we have to remember that a lot of the user-visible API assumes PMD
> sizing and so the code has to clearly reflect this and make it clear that

Your sentence got cut off, but if this is about the tunables then let me
flag what the series does with them.  max_ptes_none, _swap and _shared are
counts out of a PMD, and a range smaller than one has fewer PTEs than the
budget, so a raw comparison can never refuse it -- a 64K range on 4K pages
is 16 PTEs against a max_ptes_shared default of 256.  For swap and shared
the engine therefore compares fractions: count * HPAGE_PMD_NR against
max * nr_scanned.

max_ptes_none stays as mTHP collapse has it, all-or-nothing: 0, or
everything at that order.  That is deliberate -- allowing holes at an order
below the largest enabled one lets khugepaged fill them and collapse the
result at the next order up, which is the ratchet max_ptes_none exists to
bound.  There is room to scale it at the terminal order, where there is no
larger order to creep into, but I have not done that here.

> > Design
> > ======
> >
> > The old mechanism holds the address space still because it has nothing
> > else stopping the sources from moving under the copy.  The new engine
> > makes the sources themselves inert instead, with the two barriers
> > migration already uses, raised in that order:
> >
> >   1. migration entries replace the source PTEs.  Faults and GUP-slow
> >      now wait on the source folio's lock, which is taken before the
> >      first entry becomes visible.
> >   2. the source folio's refcount is frozen to its expected value.
> >      GUP-fast, pfn walkers, reclaim, compaction and memory-failure all
> >      fail folio_try_get() and back off.
> >
> > Between the two, nothing can reach a source, so the copy runs with no
> > lock held at all -- and the address space is left alone while it does.
> 
> Hmm, are migration entries the right mechnanism here? Are you actually
> migrating the pages to a large folio here, or using them to get the
> behaviour you want on fault/GUP?

Both, and I would argue the behaviour is not a side effect: what a
migration entry means to a waiter -- this page is going away, sleep on its
folio lock and look again -- is exactly true of a source under collapse.
Fault, GUP-slow and rmap then all do the right thing with no new code,
which is the case for reusing the entry rather than inventing a marker
every waiter would have to learn.

What is not reused is mm/migrate.c.  A migration entry encodes one PFN, so
it cannot name an N:1 destination of a different order; the engine takes
the hold-still half and does the remap itself at install.  It is a
migration in substance -- contents move to another folio, the old mappings
are replaced -- but not one migrate.c could drive.

> Same question in general for the freezing.

folio_ref_freeze() means nobody may take a new reference, which is the
property the copy needs, and is why migration and split use it too.

> > What that removes from every collapse path:
> >
> >   mmap_write_lock              -> mmap_read
> >   anon_vma_lock_write()        -> nothing: an rmap walk needs the folio
> >                                   locked, and the engine holds that lock
> >                                   from freeze to putback
> 
> I do like the idea of eliminating uses of the rmap lock like this, not only
> for contention's sake but also for scalable CoW purposes which introduces
> challenges with regards to holding these.
> 
> In fact, migration and huge memory collapse are the really problematic
> areas.

If that is about their rmap complexity, collapse gets easier here rather
than harder.

The engine takes no rmap lock and walks no rmap.  A page shared with
another process is unshared before anything is frozen -- the fault-in
pass breaks CoW, exactly as a write would -- so by freeze time a source
is exclusive to this mm and its only live mappings are the ones being
replaced.  Migration has to cope with a folio mapped from many mms; this
never sees one.

If what scalable CoW needs is that collapse stops messing with rmap,
that is what this does.

> 
> >   tlb_remove_table_sync_one()  -> nothing: one ranged flush per round
> 
> Aren't we reliant upon this synchronisation for correctness?

Not in the new engine.

In collapse_huge_page() the IPI is what makes the *detached* table safe
to use: it pmdp_collapse_flush()es the PMD and then copies out of the
table it just detached, so it has to know no lockless walker is still
inside it.

The new engine never does that -- a sub-PMD window is collapsed in place
under the page table lock, so nothing is detached, and at PMD order the
table is detached, never touched again, and freed with pte_free_defer().
The synchronisation is still there, it is RCU rather than an IPI; and on
the arches without RCU table free the flush itself IPIs, as you say.

> >  - A table that cannot become one huge page still yields the largest
> >    windows inside it, where before a single disqualified PTE gave up
> >    the whole table.
> 
> Are you permitting collapse of ranges that straddle PTEs?

No -- a candidate never crosses a page table or a VMA.  A round works
within one table, and each candidate is validated against the VMA at its
own order.

> Though in general I'm confused by the single disqualified PTE here -

Taking that literally is how I meant it: collapse_scan_pmd() goto
out_unmap's on the first PTE that fails any of its checks -- uffd, non-anon,
clean lazyfree, off the LRU, unexpected refcount -- and mthp_collapse() only
runs if the verdict came back SCAN_SUCCEED.  So one
such PTE anywhere in the table means nothing in that table collapses, at
any order, even at an order whose windows avoid it entirely.

> > There may be a way out -- a PMD migration entry over the table during
> > the window, so the CPU never caches a walk to shoot down -- but that
> > means teaching every pmd-level walker a new kind of entry, and I have
> > not tried it.
> 
> Hmm this seems like complexity on top of complexity...

I find it rather elegant, and expect it to be minimally intrusive: let such
a PMD be walkable exactly as a present one is, so software descends through
it as usual while the CPU sees a non-present entry and caches nothing.
Transparent to software, opaque to the CPU.

Out of scope for this patchset either way.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

