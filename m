Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0141F433CD
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 23:26:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B36A56B0088; Wed, 15 Apr 2026 19:26:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE79B6B0089; Wed, 15 Apr 2026 19:26:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FCF96B008A; Wed, 15 Apr 2026 19:26:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8FECD6B0088
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 19:26:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3547BE430A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 23:26:39 +0000 (UTC)
X-FDA: 84662376918.27.280EF93
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 71C09140003
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 23:26:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t6YBxQJO;
	spf=pass (imf23.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776295597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S6viq7gPTvD2KTcxO4tiZuB7VP5NY9ihXQ+Lnzkx8Mo=;
	b=qFf+BWUvubVFEXDkNcUSCmVoqxde4J8iHI4eKIR+hz736bkLS1zcWkKG0prKqxg9uGJ90t
	gU4ybSq5bHwvfP+KyVAls5pfo57AyAlJA2BR1dmYd/uxq5BUdNeHFCiMGR9j8WKz5QWjbA
	2EqateeINTaKleznTr95kCJJV0f6uU4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t6YBxQJO;
	spf=pass (imf23.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776295597; a=rsa-sha256;
	cv=none;
	b=yHHgoLeKbPy/ppxZ05vh3RfCe7QKpakRdYEFCROkOhBatbzMnoVKNe43B2wKvwHmfIxUqZ
	0HiPP7rF9xDfc2Q5cKldLsaPLETjHpbwdDxDW/rijcG/PsmJLeyr8uBQu0HNHd8v+LsnZw
	SYJV6VCg/D9AkA2/2MumKTIxAFMl3p4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 221CE40E07;
	Wed, 15 Apr 2026 23:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D69C19424;
	Wed, 15 Apr 2026 23:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776295596;
	bh=R76toBFGdOsNAA62zbclsRCQOGUew+TGKnY/JICakrI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t6YBxQJOGV4LhVce4mTi6PnYNk2GhZ/Az5e2O7ok/l/SplZSW6v+Xj73SA099agbw
	 UB4mlsI7MX8+jXYcF2Z7w9uGDQpSufJBPwgxX6bgwWKqGGSpvEcUb0zjHwWoqrsPbz
	 HqpiClp/DipoRNWFVGgjFBS7MzUGXyfFkbbZ6Szm1e4svQKJb0iZkDkNYHuauTxtEh
	 u7IIoeax6bVJlk9zWOPVXC3EN5o96PKiIiMK/9xpjDoKQ/fHj18mBYD7pNsWooGVaH
	 uheulakQCygVZI4/jyJPskol6QtWI8nyxjznpfKxUob3yZTri82659JLTELrOdjgzY
	 vm0GMxf9qvKCQ==
Date: Wed, 15 Apr 2026 16:26:34 -0700
From: Minchan Kim <minchan@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, david@kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [RFC 0/3]  mm: process_mrelease: expedited reclaim and auto-kill
 support
Message-ID: <aeAeqoJ_acUAza8D@google.com>
References: <20260413223948.556351-1-minchan@kernel.org>
 <ad3ldU4DZxga_J2L@tiehlicka>
 <ad6c0DN7AGoOQ_Iq@google.com>
 <ad9AXVYxWCkHmh6J@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ad9AXVYxWCkHmh6J@tiehlicka>
X-Stat-Signature: yiwmd4o1qnc1qatfmozf66u1unatgt5w
X-Rspamd-Queue-Id: 71C09140003
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776295597-838127
X-HE-Meta: U2FsdGVkX19mrTCX7orZ0tIGu/TRwbojUHDB5AgK5oZJWzfVkU8FxR4KW7z9iYgudMkVxC5j8r+B7+fckhK35vm9t+kC8txLw6iZXyWNhnQeyg9KNWcCauX2pYpFDzRWuPPEtScE+LDdsiNJHnroZVvZ9htRLFsw1SVCd6Jv+x+iWiZTYAU5OzoQl1rmKM1sfXzYPdBMjyt7xT1J6dTau7/eXoeI1khiv2bDQHip181yFL0fKLampU+h9B2BpaqiaOKXTm9zoAlOC3iY+yXQOgtMnxgOyz9/uDalTy0oHEcN081DBvp4eH+RVo74UHuYSmtzaFD4HiIfkKS2a1dhWEWw67/wv5H92wPX68ngbsCUvIvdwCJNOQkCKdHXTZHrmFGDjb7fW6r3wRdge+oYo/NBU2ICWsFOf/e7ItvMTD8urq3AhMhqjwV/g3m0ixeDoAM+nsTsrM5IUIT05N/BUrFPKrA0zmpoDnf8Cevqaha216Aw9pPQ98KCWUuqGm/uHBHlvIr7ppJacDTTt2ChnJyAG+UWbFJiESOPTcMeVYnyojEB/Q3pjGI2Oyi7cDkE7ri50RVDOPQ2Skzw8iYktT00EDVwiTLIsJBuXgekg8ERK6n44duDF59WPPVL9X7+IiDz9VTwPgWfN/8w6pRD+huyzmhuiyPaQMgyrgZfwE98QdvP2BFQjubhhcT9mKmD0HkUAyYMftoXBqOuWymqz3xGqbkVJ069hbY29oq5igrmBK1Zhyep2cDwwhGP7lMh6N2hD6FYZvOYRnOb+qJjIVfJ7A8XNz/+hY3ceePtSnkvtFGigTj20jXuYvQ4aW0RfW1T1IDTdb6sAM3xziggl7MOkCGFUqmTyT+sF+TdR/wXoQovzslYhFrNySa+R5kdNfEIEOmu7lrM38Rx1iFXgdkuAD9Nm7/mUnl9YrCROKaV/gy+M0W14qyRO6La9pfK7lVQ+giq9i3/2XlkvS1
 9TcehBi3
 /ZVixMKYpFTbVd0WvEitrEqdflwgsYn9YDZ404yW2amo48FF+rnhBRegKwWk6ETpT6bUsT2DRMELz3rzhQ455JwkyKtHpqNhctz2CRZD2XabT1otGZNl/9vF1TpOvdvPc/W6gyz/7VgX8K8AuAw+FznxC65mr2PYYGm2yJRm8bjba7tfTnaVM5kAtbAgVgEYXkjZMpJRzkISISXT9tg8Rma93DMaipzZjl4Mr0lHjVsn6qlR0l5pT7yU7xr3PzQODhj6G9AytAuPEX46Z9lELxZWOHAlh37HLLX8QYR412yawh/kucCUaAjJUVAxe6+eqFSyCE5PJg1FjkpKJisLip9ZRUS/gwsjP50ZT/THhvXxGijk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 09:38:05AM +0200, Michal Hocko wrote:
> On Tue 14-04-26 13:00:16, Minchan Kim wrote:
> > On Tue, Apr 14, 2026 at 08:57:57AM +0200, Michal Hocko wrote:
> > > On Mon 13-04-26 15:39:45, Minchan Kim wrote:
> > > > This patch series introduces optimizations to expedite memory reclamation
> > > > in process_mrelease() and provides a secure, race-free "auto-kill"
> > > > mechanism for efficient container shutdown and OOM handling.
> > > > 
> > > > Currently, process_mrelease() unmaps pages but leaves clean file folios
> > > > on the LRU list, relying on standard memory reclaim to eventually free
> > > > them. Furthermore, requiring userspace to send a SIGKILL prior to
> > > > invoking process_mrelease() introduces scheduling race conditions where
> > > > the victim task may enter the exit path prematurely, bypassing expedited
> > > > reclamation hooks.
> > > > 
> > > > This series addresses these limitations in three logical steps.
> > > > 
> > > > Patch #1: mm: process_mrelease: expedite clean file folio reclaim via mmu_gather
> > > > Integrates clean file folio eviction directly into the low-level TLB
> > > > batching (mmu_gather) infrastructure. Symmetrically truncates clean file
> > > > folios alongside anonymous pages during the unmap loop.
> > > 
> > > Why do we need to care about clean page cache? Is this a form of
> > > drop_caches?
> > 
> > The goal is to ensure the memory is actually freed by the time
> > process_mrelease returns. Currently, process_mrelease unmaps pages, but
> > page caches remain on the LRU, leaving them to be reclaimed later
> > by kswapd or direct reclaim.
> 
> Correct. This was the initial design decision because there is not much
> you can assume about page cache pages which are very often shared. Even
> if they are not mapped by all users.

Fair point. However, that's the trade-off:

Leaving unmapped caches to be reclaimed asynchronously keeps system memory
pressure high for too long. In Android, this delay forces the LMKD to
unnecessarily kill additional innocent background apps before the memory
from the original victim is recovered.

Furthermore, this approach maintains safety: mapping_evict_folio() will
naturally fail if the folio is still actively shared by other processes.
Yeah, that's not perfect but minimal safety net.

I believe preventing redundant background app kills is a highly beneficial
trade-off than adding more IOs since user can keep listening their music.

> 
> > This delay defeats the purpose of
> > "expedited" release. It’s not a global drop_caches, but rather a
> > targeted eviction for the victim process to make its memory immediately
> > available for other urgent allocations.
> 
> Clean page cache reclaim should be quite effective. Why doesn't kswapd
> keep up in that regards? Or is this more a per-memcg problem where there
> is no background reclaim and you are hitting direct reclaim to clean up
> those pages?

So many reasons: Cannot say everything how kswapd is inefficient compared
to memory allocation.

1. kswapd is CPU hungry.
2. Out of control which core(big, midlle or little) kswapd will run
3. Allocatoin is super fast than the memory reclaim
4. Kswapd is stuck on some lock
5. Kswapd is doing swapping out since anon/file reclaims are serialized

> 
> > > > Patch #2: mm: process_mrelease: skip LRU movement for exclusive file folios
> > > > Skips costly LRU marking (folio_mark_accessed) for exclusive file-backed
> > > > folios undergoing process_mrelease reclaim. Perf profiling reveals that
> > > > LRU movement accounts for ~55% of overhead during unmap.
> > > 
> > > OK, but why is this not desirable behavior fir mrelease?
> > 
> > In Android, lmkd kills background apps under memory pressure and then calls
> > process_mrelease. If the memory release is slow due to LRU overhead (~55% as noted),
> > it cannot keep up with the allocation speed of the foreground app.
> > This delay often leads to "over-killing" - killing more background apps
> > than necessary because the system hasn't yet "seen" the memory freed
> > from the first kill.
> 
> OK, I see. More on that below.
>  
> > > > Patch #3: mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL flag
> > > > Adds an auto-kill flag supporting atomic teardown. Utilizes a dedicated
> > > > signal code (KILL_MRELEASE) to guarantee MMF_UNSTABLE is marked in the
> > > > signal delivery path, preventing scheduling races.
> > > 
> > > Could you explain why those races are a real problem?
> > 
> > The race occurs when the victim process starts its own exit path (after
> > SIGKILL) before the caller can invoke process_mrelease. If the victim
> > reaches the exit path first, the caller might lose the window to apply
> > these expedited reclamation optimizations.
> 
> Isn't this the problem you are trying to solve then? You are special
> casing process_mrelease while you really want to expedite the process
> memory clean up. 
> 
> The same situation happens with the global OOM and your approach doesn't
> really close the race anyway. You send SIGKILL first and the victim can
> hit the exit path right after that before you start processing the rest.
> That is not fundamentally different from doing that in two syscalls,
> race window is just smaller.

No, this approach completely close the race.

When it invokes do_send_sig_info(SIGKILL) with the KILL_MRELEASE code,
the kernel sets the MMF_UNSTABLE flag on the victim's mm_struct in the signal
delivery path (kernel/signal.c) *before* the task begins processing the signal.

When the victim gets scheduled and wakes up to process the fatal signal,
the MMF_UNSTABLE flag is already set.

This guarantees that the victim's own exit path (do_exit -> exit_mmap) will
utilize the expedited reclamation optimizations automatically, regardless of
whether the reaper or the victim gets scheduled first.

For the OOM, we can use the same idea.

> 
> All that being said, I do not think those special hacks for
> process_mrelease is the right approach. I very much agree that the
> address space tear down for a dying process could be improved and we
> should be focusing on that part.

I think process_mrelease is crucial here because relying on the exit path is
non-deterministic.

The mm_struct can have its reference count increased by other tasks
or kernel subsystems. When a process exits, the actual address space teardown
(exit_mmap) is deferred until the mm's reference count reaches zero.
If any component holds a reference, the tearing down is delayed indefinitely.
We have observed the problem in the field quite a lot.

This is precisely why process_mrelease was introduced in the first place.
It allows an external reaper to bypass the reference count delays and
synchronously reap the memory of a dying process on demand.

Improving the regular exit path alone cannot substitute for this,
as it would still be stalled by outstanding reference counts.

I don't know what alternative ideas you are thinking about, but please share if
you have a better approach.

