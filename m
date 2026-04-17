Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1A55F8E4A7
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 06:20:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFA5E6B0092; Fri, 17 Apr 2026 02:20:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAB7A6B0093; Fri, 17 Apr 2026 02:20:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC1626B0095; Fri, 17 Apr 2026 02:20:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B84CC6B0092
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 02:20:35 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5EA1813BACF
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 06:20:35 +0000 (UTC)
X-FDA: 84667048830.22.39535E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8644240008
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 06:20:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dJ0cuCPI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776406833; a=rsa-sha256;
	cv=none;
	b=eQoq5ktPh9DMEjbIQWIkzty8Iw0GKzsGxTeRyv93qw4thgqA9mOVZCSsKuZQOVsorRqnKR
	10aJgLdKWAKC1mZKzMNcOdveWSmtzmu0PXs6GfPcsZRa3eAnWZtMXjR1VNPH8MWJCyWgLU
	CXfl+5WyudkbW+M//mlslZAxA+14yH0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dJ0cuCPI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776406833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wm0USUqkkGHlxFl8H2+BkV/7X0400yG9aZjphG/IXMU=;
	b=RABLz7zyrznZiSMpYK6R4+pxkCtCcSQr4YXJrDfrqNQQFO7RIxaQxuF5EzOLPni1pnEncW
	aJ2Pf79iJYv3Q3D9XC+fL632oOJgifOoLk2VlXlj6RcG8h+iYzBa63btr6itluRQSfURvo
	JUkGtK3VHBa1zf6k7Gk+VyAoNxhAmvI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6973D43FA3;
	Fri, 17 Apr 2026 06:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12C7C19425;
	Fri, 17 Apr 2026 06:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776406832;
	bh=HL8SBgsd1DbHhFspQzwB04DyajD9b7vRoL4rZ+XH25c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dJ0cuCPItEytBujWNScwMbow17sgYJP80y4GN45GFHG1ge+NWiuyLVlmtwrCiOwrv
	 9VlCchDeSL/bbza5hNz5I6iFeU+kpxMamK5S1DpZG/JJfO50qnSOd/He4sISH9e+fx
	 dMiKA/gaEF6TnXze4xMSb6CIbXxkuw/TaNuhDuHpQdtuFhQcDlRJUyuRmPFPXM9Dpm
	 JZAf04qGe/7uEkoWQnYa7griK88JH+s/BQPwv9c4igPgfsTEvE1i61nsJoxcJxIJol
	 2fmK+2jXwOE12GMGcpioHFs4dbGgWcQ8otnAk3ws+CYU/ZyxGXcETYvmcQDt/XvtKS
	 pGqPKg1r8yVog==
Date: Thu, 16 Apr 2026 23:20:30 -0700
From: Minchan Kim <minchan@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, david@kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [RFC 0/3]  mm: process_mrelease: expedited reclaim and auto-kill
 support
Message-ID: <aeHRLv834FCAQlQ8@google.com>
References: <20260413223948.556351-1-minchan@kernel.org>
 <ad3ldU4DZxga_J2L@tiehlicka>
 <ad6c0DN7AGoOQ_Iq@google.com>
 <ad9AXVYxWCkHmh6J@tiehlicka>
 <aeAeqoJ_acUAza8D@google.com>
 <aeCHvYOKP1exBBns@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeCHvYOKP1exBBns@tiehlicka>
X-Rspamd-Server: rspam10
X-Stat-Signature: hn1iktyei7iuqe5kxy91fxijbnhwziub
X-Rspam-User: 
X-Rspamd-Queue-Id: 8644240008
X-HE-Tag: 1776406833-647414
X-HE-Meta: U2FsdGVkX19mY7jf/E4InoSnQGrizid4VBGEvzg4yKdb3IEldIQTCBEeqLieotONGPxPT7IqIe/V5qHtRIRhoEUjGlXTa39L/j7YN88CRNoDa8Ah6RwGWyc0KWY2KvGjPeoBAs6t/3VRMmvWeEmpBCFbcdvti6qWw50NMW4SBc/pw0xnnuqsdTFXLPvmHSiFf5aOkvfadcnJYXkJN3uLgXOYPBrKdqc8LWOpZ1Mk3Z1gFDaerI9qr+eXoP0IwYCchG8iWTxyrwZMrBFdy6zPTUvBh/53Zvjd5d1nLoEN1yykhlIKUyPanFvtqJW93O22l2OauP/PvwOsxn7IOQX0upqPK0I8WkteY4CM4pdXLzk4sz7xnsLOhH++W9RB7sCIqvJvoGLaWF/fnyY2RHu39yj/xoRSoIEdHQs1VN9RL6wT1Gv9SCozNt1rJDX6lSH85m3mrDbrb0XKqtjv5158TtOlQ5asD5btWZB0UQxwFsDLkzy/4b3lSRroZXBsjdJd8lOO2LIPq21RmgNrRi0wDTolPotcrVnB9VlJEse7aL29yqYkmW1t+/Qbs1VDV/4SrUEbBPxRa2NVAaHw47PwjgQAMUze0J5AZfj1oBf+0ONgJEytW0vYcqm5sXfA2bn8E3iyu4aSeTv2bYANDCpIciibWaUy8yxtchgdfwiIds7D8lsEHuWhUX4usoTlnJuLrPLqvP3/EJiEehSxwrI30OGdBQ090SxlmW3BTbbu4+ENuI8gY0lw3FmQ8mguTSsVnlx5ItsqZMUOC7Cm0NP7jld01b+nzPwvgUUPrRQZ+5hCLkiDa84h4/TTSZod81cC9WKj9R+Xy9HuWNAj2GkNRW0G3xSIQAzmuBVu8IQaCU73Zh1gM9eeq0tXVqoaVa+EqQsHhDfNYXMgxyoIy947XHI7f6/InILfGajICLTXGV7bWEbL05Qe56EGMoy5NzTR+0UJa8HPR5fyj04ludM
 aEWnvXY7
 S+vbsgNWK8Mwc56z0vEvwVrTs9CG538T/Z3/Cnue9O02/dmo7Iseh9ThMRa3DKBlATkNZkHAJwsfH/ozfAy2emWZ5IiVtDuczUufLKaoqxXsLA8uj9UvSMW/cHXty7LZL/xFcyApgfJpdf4k7Capk7Ys/CLwJ2TqznMTbo9Jo36zS0Li8NANbdN2yC6QsQmS8yJjmjuGY9UlX1TSmXL016Wr2kHy4NLL2SGpfsVj6Wg1obkGHNCz+aFArorpHYM5KuZIoNxD/CSWRj1HaMaWyzDmOUiU7XKmhbAtJ0dBEwAGLHF9yCQQzsbYrtn3X42n77ervtmgwCzlLmxg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 08:54:53AM +0200, Michal Hocko wrote:
> On Wed 15-04-26 16:26:34, Minchan Kim wrote:
> > On Wed, Apr 15, 2026 at 09:38:05AM +0200, Michal Hocko wrote:
> > > On Tue 14-04-26 13:00:16, Minchan Kim wrote:
> > > > On Tue, Apr 14, 2026 at 08:57:57AM +0200, Michal Hocko wrote:
> > > > > On Mon 13-04-26 15:39:45, Minchan Kim wrote:
> > > > > > This patch series introduces optimizations to expedite memory reclamation
> > > > > > in process_mrelease() and provides a secure, race-free "auto-kill"
> > > > > > mechanism for efficient container shutdown and OOM handling.
> > > > > > 
> > > > > > Currently, process_mrelease() unmaps pages but leaves clean file folios
> > > > > > on the LRU list, relying on standard memory reclaim to eventually free
> > > > > > them. Furthermore, requiring userspace to send a SIGKILL prior to
> > > > > > invoking process_mrelease() introduces scheduling race conditions where
> > > > > > the victim task may enter the exit path prematurely, bypassing expedited
> > > > > > reclamation hooks.
> > > > > > 
> > > > > > This series addresses these limitations in three logical steps.
> > > > > > 
> > > > > > Patch #1: mm: process_mrelease: expedite clean file folio reclaim via mmu_gather
> > > > > > Integrates clean file folio eviction directly into the low-level TLB
> > > > > > batching (mmu_gather) infrastructure. Symmetrically truncates clean file
> > > > > > folios alongside anonymous pages during the unmap loop.
> > > > > 
> > > > > Why do we need to care about clean page cache? Is this a form of
> > > > > drop_caches?
> > > > 
> > > > The goal is to ensure the memory is actually freed by the time
> > > > process_mrelease returns. Currently, process_mrelease unmaps pages, but
> > > > page caches remain on the LRU, leaving them to be reclaimed later
> > > > by kswapd or direct reclaim.
> > > 
> > > Correct. This was the initial design decision because there is not much
> > > you can assume about page cache pages which are very often shared. Even
> > > if they are not mapped by all users.
> > 
> > Fair point. However, that's the trade-off:
> > 
> > Leaving unmapped caches to be reclaimed asynchronously keeps system memory
> > pressure high for too long. In Android, this delay forces the LMKD to
> > unnecessarily kill additional innocent background apps before the memory
> > from the original victim is recovered.
> 
> OK, this is really not clear to me. How come you end up triggering LMKD
> (or any OOM handling) when there is a considerable amount of clean page
> cache?

It's not simple to explain all the heuristics, but basically, LMKD is triggered
by PSI pressure (usually contributed by kswapd rather than other components
like refault, kcompactd, or workingset operations).

It then checks the current free memory against system watermarks. Depending
on the free memory size, file cache, and free swap, it decides to start
killing background apps.

In other words, LMKD acts as a "userspace kswapd" to assist kernel kswapd's
reclamation speed. It is smarter than kswapd because it has high-level knowledge
of which processes are okay to be killed rather than forcing slow, unnecessary
paing out.

Whenever LMKD is running, kswapd is usually running alongside it. You might
wonder why LMKD kills background apps even when there are plenty of clean file
pages. That's because the system cannot predict current memory allocation rates.
If the allocation is bursty, kswapd can never catch up with the allocation speed.
This forces the foreground apps into direct reclaim, resulting in visible
UI jank. Android prioritizes UI smoothness and chooses to kill background apps.

Furthermore, when LMKD kills a background app, it expects immediate memory relief.
If the clean file pages of the killed process are left on the LRU to be reclaimed
asynchronously later, the system's memory pressure (PSI) remains high.
This forces LMKD to unnecessarily kill *additional* background apps before
the memory from the first victim is fully recovered.

Again, this is why I want process_mrelease expedite clean file reclamation
synchronously.

> 
> [...]
> 
> > > > The race occurs when the victim process starts its own exit path (after
> > > > SIGKILL) before the caller can invoke process_mrelease. If the victim
> > > > reaches the exit path first, the caller might lose the window to apply
> > > > these expedited reclamation optimizations.
> > > 
> > > Isn't this the problem you are trying to solve then? You are special
> > > casing process_mrelease while you really want to expedite the process
> > > memory clean up. 
> > > 
> > > The same situation happens with the global OOM and your approach doesn't
> > > really close the race anyway. You send SIGKILL first and the victim can
> > > hit the exit path right after that before you start processing the rest.
> > > That is not fundamentally different from doing that in two syscalls,
> > > race window is just smaller.
> > 
> > No, this approach completely close the race.
> > 
> > When it invokes do_send_sig_info(SIGKILL) with the KILL_MRELEASE code,
> > the kernel sets the MMF_UNSTABLE flag on the victim's mm_struct in the signal
> > delivery path (kernel/signal.c) *before* the task begins processing the signal.
> 
> OK, I have missed this part. I haven't really looked into specific
> patches at this stage. I am still trying to understand the motivation
> and your reasoning. So effectivelly you want to get SIGOOMKILL more or
> less.

The fundamental problem with signals is their unpredictability. The time
between sending a signal and when the victim task actually handles it is
highly non-deterministic. Furthermore, as mentioned earlier, outstanding
reference counts on the mm_struct can delay the teardown indefinitely.

> 
> > When the victim gets scheduled and wakes up to process the fatal signal,
> > the MMF_UNSTABLE flag is already set.
> > 
> > This guarantees that the victim's own exit path (do_exit -> exit_mmap) will
> > utilize the expedited reclamation optimizations automatically, regardless of
> > whether the reaper or the victim gets scheduled first.
> > 
> > For the OOM, we can use the same idea.
> > 
> > > 
> > > All that being said, I do not think those special hacks for
> > > process_mrelease is the right approach. I very much agree that the
> > > address space tear down for a dying process could be improved and we
> > > should be focusing on that part.
> > 
> > I think process_mrelease is crucial here because relying on the exit path is
> > non-deterministic.
> 
> I suspect you are missing my point. I am arguing that those special
> hacks in the address space release path shouldn't be process_mrelease

I am a bit confused now. Do you mean you want to apply these expedited
reclamation optimizations to ALL dying processes in the common exit path,
rather than making them specific to process_mrelease?

I don't think so since you mentioned below "process_mrelease might ..
right syscall" but I wanted to clarify what you means.

> specific. I do recognize the value of the sync tear down need. I am also
> in favor of something like SIGOOMKILL. process_mrelease might even be
> the right syscall for that purpose.

I am glad we are aligned on the necessity of this feature.

