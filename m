Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CD96FF885A
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 01:19:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DE2F6B00C5; Tue, 28 Apr 2026 21:19:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 767E56B00C8; Tue, 28 Apr 2026 21:19:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62F606B00C9; Tue, 28 Apr 2026 21:19:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 492BB6B00C5
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 21:19:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E4F6CC1E23
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 01:19:36 +0000 (UTC)
X-FDA: 84709835952.30.08578FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0F7D540006
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 01:19:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U2HXGRyN;
	spf=pass (imf17.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777425575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UhvBgo8tUgloI/FtcteZ1Njf53txxhGRs5V3z0ypTMI=;
	b=RkGYYkwK0IZyhm8pIQiEA8QGitzVwVga8J0ScsT4sV0e8upT4gmyYdi62d+e3ObIgn7Tta
	6uDkqEBLf9wrk6jOJhvQsDegGxU+5tv9Ma7Zh6diIlpHKt+9oDCACiWO4SFUJCPhv2PjVP
	1HYNcACCyJSUOWojecHe/KxCVYJeMlI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U2HXGRyN;
	spf=pass (imf17.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777425575; a=rsa-sha256;
	cv=none;
	b=wyAQVQb6VIAnK+kAT4WWqj51/IZwwYbsOuBAkGm3zp2JnYmHwbtRBDUpJ+bWdNegMX2j0b
	zWB9cN0IIkbUAKZCwid/IEFdPI1OSU00ZcyHOxzxLCnclbiQ+BdR1UhVvWb1mGqKLtNjBq
	EbXfTb/9Bpyo0IcU1gGDHseF6ZJs6JY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 961C4439AF;
	Wed, 29 Apr 2026 01:19:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD97C2BCC4;
	Wed, 29 Apr 2026 01:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777425573;
	bh=5u2n5uiidrc/ba7ICjvr957WS6UnVj/1HAyWPhqIkyA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U2HXGRyNaAVwZMgCPSQ0t8YQhhTWoh6lKK5SdFcUUlmiu12bxvhNz/HIkA/X7ZqAY
	 6jpbZWWUEhNkQSLy8DjBpKof4zyG+9KyFB2NsRggOpPlB/oSiId0eyaKFu067YDACV
	 TBBrsn96jdOJ6cg1e/9/Oy5ddfp2DNyuK4DMDoGPJyx5qkc1rECBswT3tZRrGNP3Ri
	 rv8ZrVqzK2oA7O2oOy9KBH+9mYDQv74KJv6w/x529zK661pKTfVB1LKR1EosAqmjYg
	 9Vk0+Usm1NwHiRNnptSPjuSmeMYzMXGB4Q9GgGKoCchDOkBu4uFlTe35eReg0rVcoF
	 Lu4gkVOSy4tLw==
Date: Tue, 28 Apr 2026 18:19:31 -0700
From: Minchan Kim <minchan@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, brauner@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, timmurray@google.com
Subject: Re: [PATCH v1 2/3] mm: process_mrelease: skip LRU movement for
 exclusive file folios
Message-ID: <afFco71vwmpQy3pk@google.com>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-3-minchan@kernel.org>
 <aesg-sj6_VmXyqxb@tiehlicka>
 <7c7da8ae-cd39-4edf-b94f-c79ab85df456@kernel.org>
 <aevBRh08X4UTMUj9@google.com>
 <ae8NT0tLt7eBmH6j@tiehlicka>
 <CAJuCfpHQdA7C50V2WjNrdYcp7feV5ukgxJf+vMNEcp0P1SGEow@mail.gmail.com>
 <ae-Zu-VAzAA7SdLa@tiehlicka>
 <ae_roPR64e6sY_fN@google.com>
 <afBaJLLFigkdszov@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <afBaJLLFigkdszov@tiehlicka>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0F7D540006
X-Rspamd-Server: rspam06
X-Stat-Signature: fym7tzzok1gq6qu5fmjuewgrys1s5rj8
X-HE-Tag: 1777425574-398247
X-HE-Meta: U2FsdGVkX1+0sRbbhC3wrZYVZHxUtNAooFNrGIv7cX+DHaH+WS/jKZ2CNjoDc9zTNfXxT6PkQ6zt4qqUqh8oYU6jcFaqxcKMPNO1H7tFFgNVWPFPUcySWnNkkq3alaZcnhvPTW5s0/iywrU1kXp1Ofp33ER4VBwkp1aYVl/WdE6FBHZlKRDaAuRrcvPi/ivQrlxxrvKtmovEHaqNs9imsN6+224brgnyUJwLGE0455prWRoFQZafoMYRJTAIpDDgh7T22VVcIU+pVS6wqQ5s3/K+CPa8xzdRLkuAdBNz9nyb37eaRvDccLRgHFfA7971GI1PJ2HCHBcf15M2ZVBHV0+Xn7szoq2TUL/dTshfcRHLQZDFsWNVtmT8y6u0zPEGEsFKx0WAKmp5NHNgxyftymKsndO+KyoIglBhMJ1msv3qItzcLZ4FW4TYbVwwFzeYPDMYKukyj5XtJS/AQ5WoBtQWDML+kt1BMXo1W5erDEAUoQIbN9GLjZc3pPx7Agf6LNJ1Da/CLOPLptVdyE004ypHTfMclTGjGH4Z28vvyqFgDNhDzD0qb23UoBRHKkrsjqBfmJO+uvlCCIG/M6mXIB16hW9LEy8Z715SxD1olZeu99CeJTCXFlq/HB0gameeJSeXQwDp0SMSdQvkTod8FAnfpH8GL4cQ8JxgJcQmxq4cc/0V6i70HkkT15jhaM26aK5lXpkXvP/c8viUnzp0pk/sfw9y0fQeR2TwTLLwtpjSiT2QEkOfzZq2rJmaAIf5dO7Udcw7hyedYWbz4fAE5h1PciwBFlj/GmgSipE5NMAWXPdZ0B0gJZznj9J5IZye4MgV6lGeb7GQBTung6OWDsvYxNruPh340I+mOA9bDdb2UhjGhJyv/xF3JhU1zN07ccyHC8D9acN9PP/zPkyhxt1HdI55oZIRWDaKWk1pAmtWJnftXkjs0EILmMJ3TXKHLzCsQdfyJZ+KVey2NxQ
 ITeQpHHu
 0A7xuEnEdNsTYDYnzXPVa1Nm0OQ4sBWTXAT+75ImCY/S2Jl6tORowgCNj1+yAW5QwCqxWg47KCxG0nz3JWz/4WeBJmKk6GobY0yWN5mNMThtwsJ+hBD3TepNElr0EihJFvC+azM1Idv2g9FSWGp4t/36odht8EGr/JavBMIhnGpSo9gsEBa8edH/BP2oqbLJ7w6QrHShskR6PnPm6y6eWK1F7vsYTl8QisPpO3X6l/8OcLUNQFVEVF/+KcHiPQvhL4humGvwk3PlAhj2Eh7NC6iRHVwzMGJ9JmSmDrf1ZCPr+2sqTtOQes7cQvsc4oOUitDMOPmb3cM7+XVs71exeDT40PL4qktQMilL6fYug2Q2WL9rNO7KIn9U3oKCJ5RiQuMxlexIqZZ2UlPaZiMIBDI6F5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 08:56:36AM +0200, Michal Hocko wrote:
> On Mon 27-04-26 16:05:04, Minchan Kim wrote:
> > On Mon, Apr 27, 2026 at 07:15:39PM +0200, Michal Hocko wrote:
> > > On Mon 27-04-26 09:48:28, Suren Baghdasaryan wrote:
> > > > On Mon, Apr 27, 2026 at 12:16 AM Michal Hocko <mhocko@suse.com> wrote:
> > > > >
> > > > > On Fri 24-04-26 12:15:18, Minchan Kim wrote:
> > > > > > On Fri, Apr 24, 2026 at 09:57:16AM +0200, David Hildenbrand (Arm) wrote:
> > > > > > > On 4/24/26 09:51, Michal Hocko wrote:
> > > > > > > > On Tue 21-04-26 16:02:38, Minchan Kim wrote:
> > > > > > > >> For the process_mrelease reclaim, skip LRU handling for exclusive
> > > > > > > >> file-backed folios since they will be freed soon so pointless
> > > > > > > >> to move around in the LRU.
> > > > > > > >>
> > > > > > > >> This avoids costly LRU movement which accounts for a significant portion
> > > > > > > >> of the time during unmap_page_range.
> > > > > > > >>
> > > > > > > >> -   91.31%     0.00%  mmap_exit_test   [kernel.kallsyms]  [.] exit_mm
> > > > > > > >>      exit_mm
> > > > > > > >>      __mmput
> > > > > > > >>      exit_mmap
> > > > > > > >>      unmap_vmas
> > > > > > > >>    - unmap_page_range
> > > > > > > >>       - 55.75% folio_mark_accessed
> > > > > > > >>          + 48.79% __folio_batch_add_and_move
> > > > > > > >>            4.23% workingset_activation
> > > > > > > >>       + 12.94% folio_remove_rmap_ptes
> > > > > > > >>       + 9.86% page_table_check_clear
> > > > > > > >>       + 3.34% tlb_flush_mmu
> > > > > > > >>         1.06% __page_table_check_pte_clear
> > > > > > > >>
> > > > > > > >> Signed-off-by: Minchan Kim <minchan@kernel.org>
> > > > > > > >
> > > > > > > > As pointed out in the previous version of the patch. I really dislike
> > > > > > > > this to be mrelease or OOM specific. Behavior. You do not explain why
> > > > > > > > this needs to be this way, except for the performance reasons. My main
> > > > > > > > question is still unanswered (and NAK before this is sorted out). Why
> > > > > > > > this cannot be applied in general for _any_ exiting task. As you argue
> > > > > > > > the memory will just likely go away so why to bother?
> > > > > > >
> > > > > > > I think there was a lengthy discussion involving Johannes from a previous series.
> > > > > > >
> > > > > > > That should be linked here indeed.
> > > > > >
> > > > > > How about this?
> > > > > >
> > > > > >     mm: process_mrelease: skip LRU movement for exclusive file folios
> > > > > >
> > > > > >     During process_mrelease() or OOM reaping, unmapping file-backed folios
> > > > > >     spends a significant portion of CPU time in folio_mark_accessed() to
> > > > > >     maintain accurate LRU state (~55% of unmap time as shown in the profile
> > > > > >     below).
> > > > > >
> > > > > >     This patch skips LRU handling for exclusive file-backed folios during
> > > > > >     such emergency memory reclaim.
> > > > > >
> > > > > >     One might ask why this optimization shouldn't be applied to any exiting
> > > > > >     task in general. The reason is that for a normal, orderly exit or just
> > > > > >     pure kill, it is worth paying the CPU cost to preserve the active state
> > > > > >     of clean file folios in case they are reused soon. Preserving cache hits
> > > > > >     is beneficial for overall system performance.
> > > > >
> > > > > This is a statement rather than an explanation. Why is it worth paying
> > > > > the cost? What is different here?
> > > > >
> > > > > >     However, process_mrelease() and OOM reaping are emergency operations
> > > > > >     triggered under extreme memory pressure. In these scenarios, the highest
> > > > > >     priority is to recover memory as quickly as possible to avoid further
> > > > > >     kills or system jank. Spending half of the unmap time on LRU maintenance
> > > > > >     for pages belonging to a victim process is a bad trade-off. If speeding up
> > > > > >     the victim's reclaim by avoiding LRU movement and evicting cache negatively
> > > > > >     affects the workflow (due to immediate restart), it implies a sub-optimal
> > > > > >     kill target selection by the userspace policy (e.g., LMKD), rather than
> > > > > >     a problem in this expedited APIs.
> > > > >
> > > > > Your change effectively boils down to break aging for exclusively mapped
> > > > > file pages when those pages should have been activated. All that because
> > > > > the activation has some (batched) overhead. You argue that the overhead
> > > > > is not a good trade-off for OOM path because those pages are exclusive
> > > > > to the process and therefore they will go away after the task exits.
> > > > 
> > > > I think Minchan's argument is that mm reaping occurs only in special
> > > > conditions (under high memory pressure) and for a very specific reason
> > > > (to free up memory and prevent system memory starvation). Therefore
> > > > priority in such conditions should shift towards more aggressive
> > > > memory reclaim instead of normal aging. I can see both his point and a
> > > > counter-argument that this might cause more refaults in some cases.
> > > 
> > > The way I see this is that the standard memory reclaim under a heavy
> > > memory pressure would likely encounter those pages and aged them
> > > accordingly already. So this is effectivelly racing with that process
> > > and makes a potentially opposite decision.
> > > I suspect that a lack of memory reclaim, as implied by the other patch
> > > (to deal with clean page cache), is the reason why this one makes a
> > > difference in these Android deployments.
> > 
> > The claim that kswapd would have already aged these pages is just an
> > assumption; it is ultimately a matter of timing. We cannot reliably
> > predict whether kswapd has processed them, nor can we know the future
> > access patterns of a dying process.
> > 
> > Global system policies are not always optimal for every specific use case.
> > That is precisely why we have hinting APIs like madvise and fadvise.
> > 
> > While hinting APIs can indeed conflict with global policies, a negative
> > performance impact would imply that userspace is misusing the API, not
> > that the optimization itself shouldn't exist.
> > 
> > We should view process_mrelease() (and this flag) as a similar hinting
> > mechanism where userspace explicitly requests expedited, aggressive reclaim
> > for a specific target under memory pressure.
> 
> This is you bending definition of what process_mrelease is. And I
> disagree. There is nothing about aggressiveness for process_mrelease.
> There are no aging assumptions. We do not have an official man page but
> this is from the initial comment introducing the syscall
>         DESCRIPTION
>           The process_mrelease() system call is used to free the memory of
>           an exiting process.

"Free the memory of an exiting process" implies all memory, not just
anonymous. User cannot know it will free only anonymous, and I am trying to
make it work as intended by completing a symmetric reclamation path.

> 
>           The pidfd selects the process referred to by the PID file
>           descriptor.
>           (See pidfd_open(2) for further information)
> 
>           The flags argument is reserved for future use; currently, this
>           argument must be specified as 0.
> 
> Userspace oom killers are one obvious users of the interface.
> 
> > > Unless I am completely wrong and misreading the whole situation this
> > > might be very Android specific change. The question is whether these
> > > side effects are generally useful for other worklods. So we really need
> > > much more explanation of the actual behavior after this change for wider
> > > variety of workloads.
> > 
> > While the primary motivation comes from Android's LMKD, this optimization
> > is not active for normal workloads. It only applies to tasks that are
> > already being reaped by the OOM reaper or by process_mrelease() with the
> > special flag (via MMF_UNSTABLE).
> > 
> > Therefore, it is an opt-in or emergency-only behavior that will not hurt
> > a wider variety of general workloads unless they explicitly use this
> > targeted reclaim API. Any system with a userspace killer needing fast,
> > targeted reclaim can benefit from this.
> 
> But any user of this interface will see side effects of your
> implementation.
> 
> Look, you haven't convinced me that you are fully aware of all the
> consequences. Your arguments are weak and you seem to be uninterested
> about usecases beyond your specific Android LMK implementation.
> 
> So I am not in support of this change, same as with the page cache one.
> Again, I am NOT NAKing this patch but I do insist a) the patch
> description is damn clear about side effects and b) there is a support
> from other non-Android people using this syscall.

I am trying to isolate the new behavior under the new flag on
process_mrelease. What about this? (Need more changes from previous
feedbacks but it would be enough to show intention)

From cf292f8f8ead8df9161aad342c36633ffa90257f Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Tue, 28 Apr 2026 16:39:06 -0700
Subject: [PATCH] mm: process_mrelease: skip LRU movement and expedite clean
 file folio reclaim

During process_mrelease(), unmapping file-backed folios spends a
significant portion of CPU time in folio_mark_accessed() to maintain
accurate LRU state (~55% of unmap time). Furthermore, clean file folios
are left in the page cache, delaying their reclamation.

This patch bundles two optimizations targeting exclusive file folios
during such emergency memory reclaim:
1. Skips LRU handling for exclusive file folios in zap_present_folio_ptes()
   to save CPU time.
2. Proactively evicts clean file folios in free_pages_and_caches() to free
   up memory quickly.

To avoid polluting mm/swap_state.c (which deals purely with swap) with file
cache eviction logic, we replace free_pages_and_swap_cache() with a more
generic free_pages_and_caches() in mm/swap.c where the file eviction helper
is defined.

[Side Effects & Rationale]
A concern raised during discussion is that skipping LRU handling effectively
breaks aging for exclusively mapped file pages that might have otherwise been
activated. This implies that if the victim process is immediately restarted,
it may suffer from cache misses and refaults because its files were not
preserved in the active state.

It was also noted during discussion that if avoiding LRU movement and
evicting cache negatively affects the workflow (due to immediate restart), it
implies a sub-optimal kill target selection by the userspace policy (e.g.,
LMKD), rather than a flaw in this expedited reclamation mechanism. Userspace
is expected to use this targeted reclaim API for victims that are not
expected to restart soon.

One might argue that standard memory reclaim by kswapd under heavy pressure
would have already encountered these pages and aged them accordingly. However,
this may not always be the case and ultimately depends on timing. We cannot
reliably predict whether kswapd has processed them, nor can we know the future
access patterns of a dying process.

Therefore, process_mrelease() is an emergency operation triggered under
extreme memory pressure. In these scenarios, recovering memory as quickly as
possible is the highest priority to avoid further kills or system jank.
Spending half of the unmap time on LRU maintenance for pages belonging to a
victim process is a bad trade-off. We prioritize immediate CPU savings and
faster memory recovery over potential future cache hits for the victim's files.

Fundamentally, anonymous pages are already freed immediately during process
termination because they cannot be preserved. This patch makes the behavior for
exclusive file-backed pages consistent by proactively evicting them, completing
a symmetric and expedited reclamation path for both types of memory.

To handle shared address spaces safely and protect existing users from behavior
changes, these optimizations are restricted to only when the new flag
PROCESS_MRELEASE_REAP_KILL is used. We pass the signal down via
zap_details->ignore_access for the unmap path, and via a new flag on struct
mmu_gather for the freeing path.

This provides deterministic and synchronous memory recovery that userspace
killers like Android's LMKD rely on, while protecting normal workloads from
broken aging.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 include/asm-generic/tlb.h |  2 ++
 include/linux/mm.h        |  1 +
 include/linux/swap.h      |  4 +++-
 mm/memory.c               | 13 +++++++++++-
 mm/mmu_gather.c           |  4 +++-
 mm/oom_kill.c             | 10 ++++++----
 mm/swap.c                 | 42 +++++++++++++++++++++++++++++++++++++++
 mm/swap_state.c           | 24 ----------------------
 8 files changed, 69 insertions(+), 31 deletions(-)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 4aeac0c3d3f0..e0c7d3719c18 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -339,6 +339,8 @@ struct mmu_gather {
 	 */
 	unsigned int		need_flush_all : 1;
 
+	unsigned int		try_evict_file_folios : 1;
+
 	/*
 	 * we have removed page directories
 	 */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index abb4963c1f06..6f41f42d549a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2800,6 +2800,7 @@ struct zap_details {
 	struct folio *single_folio;	/* Locked folio to be unmapped */
 	bool even_cows;			/* Zap COWed private pages too? */
 	bool reclaim_pt;		/* Need reclaim page tables? */
+	bool ignore_access;		/* Skip folio_mark_accessed during unmap */
 	zap_flags_t zap_flags;		/* Extra flags for zapping */
 };
 
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 62fc7499b408..66435fe26b0f 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -414,7 +414,10 @@ extern int sysctl_min_unmapped_ratio;
 extern int sysctl_min_slab_ratio;
 #endif
 
+struct mm_struct;
 void check_move_unevictable_folios(struct folio_batch *fbatch);
+void free_pages_and_caches(struct encoded_page **pages, int nr,
+			  bool try_evict_file_folios);
 
 extern void __meminit kswapd_run(int nid);
 extern void __meminit kswapd_stop(int nid);
@@ -433,7 +436,6 @@ static inline unsigned long total_swapcache_pages(void)
 
 void free_swap_cache(struct folio *folio);
 void free_folio_and_swap_cache(struct folio *folio);
-void free_pages_and_swap_cache(struct encoded_page **, int);
 /* linux/mm/swapfile.c */
 extern atomic_long_t nr_swap_pages;
 extern long total_swap_pages;
diff --git a/mm/memory.c b/mm/memory.c
index 2f815a34d924..4f41a88c5259 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1640,6 +1640,8 @@ static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
 	bool delay_rmap = false;
 
 	if (!folio_test_anon(folio)) {
+		bool skip_mark_accessed;
+
 		ptent = get_and_clear_full_ptes(mm, addr, pte, nr, tlb->fullmm);
 		if (pte_dirty(ptent)) {
 			folio_mark_dirty(folio);
@@ -1648,7 +1650,16 @@ static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
 				*force_flush = true;
 			}
 		}
-		if (pte_young(ptent) && likely(vma_has_recency(vma)))
+
+		/*
+		 * For the process_mrelease reclaim, skip LRU handling for exclusive
+		 * file-backed folios since they will be freed soon so pointless
+		 * to move around in the LRU.
+		 */
+		skip_mark_accessed = details && details->ignore_access &&
+				     !folio_maybe_mapped_shared(folio);
+		if (likely(!skip_mark_accessed) && pte_young(ptent) &&
+		    likely(vma_has_recency(vma)))
 			folio_mark_accessed(folio);
 		rss[mm_counter(folio)] -= nr;
 	} else {
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index fe5b6a031717..6b737d179e9e 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -146,9 +146,10 @@ static void __tlb_batch_free_encoded_pages(struct mmu_gather_batch *batch)
 static void tlb_batch_pages_flush(struct mmu_gather *tlb)
 {
 	struct mmu_gather_batch *batch;
+	bool try_evict = tlb->try_evict_file_folios;
 
 	for (batch = &tlb->local; batch && batch->nr; batch = batch->next)
-		__tlb_batch_free_encoded_pages(batch);
+		__tlb_batch_free_encoded_pages(batch, try_evict);
 	tlb->active = &tlb->local;
 }
 
@@ -410,6 +411,7 @@ static void __tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm,
 {
 	tlb->mm = mm;
 	tlb->fullmm = fullmm;
+	tlb->try_evict_file_folios = 0;
 
 #ifndef CONFIG_MMU_GATHER_NO_GATHER
 	tlb->need_flush_all = 0;
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index efa6541b1c47..092e09498996 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -514,7 +514,7 @@ static DECLARE_WAIT_QUEUE_HEAD(oom_reaper_wait);
 static struct task_struct *oom_reaper_list;
 static DEFINE_SPINLOCK(oom_reaper_lock);
 
-static bool __oom_reap_task_mm(struct mm_struct *mm)
+static bool __oom_reap_task_mm(struct mm_struct *mm, bool try_evict_file_folios)
 {
 	struct vm_area_struct *vma;
 	bool ret = true;
@@ -556,12 +556,14 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
 						mm, vma->vm_start,
 						vma->vm_end);
 			tlb_gather_mmu(&tlb, mm);
+			tlb.try_evict_file_folios = try_evict_file_folios;
+			struct zap_details details = { .ignore_access = try_evict_file_folios };
 			if (mmu_notifier_invalidate_range_start_nonblock(&range)) {
 				tlb_finish_mmu(&tlb);
 				ret = false;
 				continue;
 			}
-			unmap_page_range(&tlb, vma, range.start, range.end, NULL);
+			unmap_page_range(&tlb, vma, range.start, range.end, &details);
 			mmu_notifier_invalidate_range_end(&range);
 			tlb_finish_mmu(&tlb);
 		}
@@ -599,7 +601,7 @@ static bool oom_reap_task_mm(struct task_struct *tsk, struct mm_struct *mm)
 	trace_start_task_reaping(tsk->pid);
 
 	/* failed to reap part of the address space. Try again later */
-	ret = __oom_reap_task_mm(mm);
+	ret = __oom_reap_task_mm(mm, false);
 	if (!ret)
 		goto out_finish;
 
@@ -1271,7 +1273,7 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
 	 * Check MMF_OOM_SKIP again under mmap_read_lock protection to ensure
 	 * possible change in exit_mmap is seen
 	 */
-	if (!mm_flags_test(MMF_OOM_SKIP, mm) && !__oom_reap_task_mm(mm))
+	if (!mm_flags_test(MMF_OOM_SKIP, mm) && !__oom_reap_task_mm(mm, reap_kill))
 		ret = -EAGAIN;
 	mmap_read_unlock(mm);
 
diff --git a/mm/swap.c b/mm/swap.c
index bb19ccbece46..7a6d3fb924aa 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -1043,6 +1043,48 @@ void release_pages(release_pages_arg arg, int nr)
 }
 EXPORT_SYMBOL(release_pages);
 
+static inline void free_file_cache(struct folio *folio)
+{
+       if (folio_trylock(folio)) {
+               mapping_evict_folio(folio->mapping, folio);
+               folio_unlock(folio);
+       }
+}
+
+/*
+ * Passed an array of pages, drop them all from swapcache and then release
+ * them.  They are removed from the LRU and freed if this is their last use.
+ *
+ * If @try_evict_file_folios is true, this function will proactively evict clean
+ * file-backed folios if they are no longer mapped.
+ */
+void free_pages_and_caches(struct encoded_page **pages, int nr,
+                          bool try_evict_file_folios)
+{
+       struct folio_batch folios;
+       unsigned int refs[PAGEVEC_SIZE];
+
+       folio_batch_init(&folios);
+       for (int i = 0; i < nr; i++) {
+               struct folio *folio = page_folio(encoded_page_ptr(pages[i]));
+
+               if (folio_test_anon(folio))
+                       free_swap_cache(folio);
+               else if (unlikely(try_evict_file_folios))
+                       free_file_cache(folio);
+
+               refs[folios.nr] = 1;
+               if (unlikely(encoded_page_flags(pages[i]) &
+                            ENCODED_PAGE_BIT_NR_PAGES_NEXT))
+               refs[folios.nr] = encoded_nr_pages(pages[++i]);
+
+               if (folio_batch_add(&folios, folio) == 0)
+                       folios_put_refs(&folios, refs);
+       }
+       if (folios.nr)
+               folios_put_refs(&folios, refs);
+}
+
 /*
  * The folios which we're about to release may be in the deferred lru-addition
  * queues.  That would prevent them from really being freed right now.  That's
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 6d0eef7470be..d948c1017d35 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -400,31 +400,7 @@ void free_folio_and_swap_cache(struct folio *folio)
 		folio_put(folio);
 }
 
-/*
- * Passed an array of pages, drop them all from swapcache and then release
- * them.  They are removed from the LRU and freed if this is their last use.
- */
-void free_pages_and_swap_cache(struct encoded_page **pages, int nr)
-{
-	struct folio_batch folios;
-	unsigned int refs[PAGEVEC_SIZE];
-
-	folio_batch_init(&folios);
-	for (int i = 0; i < nr; i++) {
-		struct folio *folio = page_folio(encoded_page_ptr(pages[i]));
 
-		free_swap_cache(folio);
-		refs[folios.nr] = 1;
-		if (unlikely(encoded_page_flags(pages[i]) &
-			     ENCODED_PAGE_BIT_NR_PAGES_NEXT))
-			refs[folios.nr] = encoded_nr_pages(pages[++i]);
-
-		if (folio_batch_add(&folios, folio) == 0)
-			folios_put_refs(&folios, refs);
-	}
-	if (folios.nr)
-		folios_put_refs(&folios, refs);
-}
 
 static inline bool swap_use_vma_readahead(void)
 {
-- 
2.54.0.545.g6539524ca2-goog


