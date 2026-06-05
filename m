Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6257CD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 10:08:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F5946B008A; Fri,  5 Jun 2026 06:08:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17F2C6B008C; Fri,  5 Jun 2026 06:08:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06D626B0092; Fri,  5 Jun 2026 06:08:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E632A6B008A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 06:08:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 82F6F93CEC
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 10:08:15 +0000 (UTC)
X-FDA: 84845433750.13.A941DE2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id B263540009
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 10:08:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DE2kG58h;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780654093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I5VqecLRt7G5iGb70TpzMF2J4Qjuy+1vUMH27FXaf78=;
	b=Ft04IBymuSsgaDgv1dLvrHQOo23WU0mGf44NucCIq+vN5E3w6gLJT7auHoqEwVgAElbC/q
	GWUzHKvvpn0B34GaiYujcwDPzOsJ08T1Jyw03YLEPmnvCfOVwoTjQjwsloFe3kEvuVomBk
	Mo33hKx4BrifmTJx9/w7Ewl5WBJk83E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780654093;
	b=wLYlnPifuTkhYDBzBK3pAjudKWOqx6OhROwLesy5hI0UOmnVel7anPHtMeb1Gel73q+fuJ
	Yia4npXPggQ2jXdK0anrCmq/sablBOtwgA9HVI47voY7W5syMwrOcjhR4706gv71NhPDWs
	9s2qG5+BPZwB456cXkhDIYB4oWDT2MI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DE2kG58h;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B41CD408E8;
	Fri,  5 Jun 2026 10:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC571F00893;
	Fri,  5 Jun 2026 10:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780654092;
	bh=I5VqecLRt7G5iGb70TpzMF2J4Qjuy+1vUMH27FXaf78=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DE2kG58hMxthGFnLTKM9WgyXXW0z/Ih2lPXc1ijI95aFcx2R7AziaFPmXqsNZ3iEo
	 GJgPWk5slRIzPwDbGO0AL7r0+PbMGl0PHsUB5OtVy0oOTph7uJNMn8sFlSyIW/eDPU
	 VjOeQjH0eVcLx3V6XQwfaEW04TFaTMRsqDxImeXLXM9YGApwhre4/PuiZboowesG+q
	 PGQzllDWMEEz0pIBeeiWsdy05fSAGlpHIlKQTq4fd6LKW0Tej7F42wt9eTt8sQvn8V
	 Er3vsj+ZXmfqiQwrPrmtc0ZsIGnnYFk312C4Ww2XJq1lNttvuHNlzozmQErjtzci6D
	 fwBQzxAn0xlOg==
Date: Fri, 5 Jun 2026 11:07:57 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: xu.xin16@zte.com.cn, tao.wangtao@honor.com, catalin.marinas@arm.com, 
	will@kernel.org, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, akpm@linux-foundation.org, willy@infradead.org, 
	sj@kernel.org, kees@kernel.org, luizcap@redhat.com, 
	zhangjiao2@cmss.chinamobile.com, kas@kernel.org, hpa@zytor.com, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	jack@suse.cz, riel@surriel.com, harry@kernel.org, jannh@google.com, 
	jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, chengming.zhou@linux.dev, 
	nao.horiguchi@gmail.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, pfalcato@suse.de, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, damon@lists.linux.dev, shakeel.butt@linux.dev, ryncsn@gmail.com, 
	dvander@google.com, wangzicheng@honor.com
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Message-ID: <aiKd7tfrICFnlWxV@lucifer>
References: <20260604111035154Lk-9ZgwKY4Nlk4zz30U1t@zte.com.cn>
 <68a4aec0-72d4-4967-b063-b57cc7ee40cf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <68a4aec0-72d4-4967-b063-b57cc7ee40cf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B263540009
X-Stat-Signature: 55etci8c66pyr4bwc6tkmjsgy1msb37m
X-HE-Tag: 1780654093-8902
X-HE-Meta: U2FsdGVkX19O+F01qsTU2pNX4fwWufi6Wh4chtKWgUjjNwNuA0XLSvOFYPH0lg9YiWqBpOZltIRnYMn4tR7TkN52xr4dKLbMNAg6vIl9pwh4TAi+QXmDJuKOF4XFAoQ936IYanZ0hxjJE+s8Yf/eogAboDZy5cjDSJcGD6vqnS6ZmYVLsHa9Y3n/vKM7g/Xqv9qHc4+4+YlEy4dOtduf8kxnAKBfylMTtacU8eFSPo+vqAtNyjvbEEFQOJVCaG55kldBXAvYDp97cu6oNI582PcnYPt/cFMwk7ULlEWGPwJ5PFGs4P82aTLkbmxxEOm8qP0ljnmBcARJbapHvW1+CVERZ5ShFaMlvJeksEd3xNIBnf52tudkOPvJAizQ54oiatWOnr439uoqex6UPIp3DYZ0Af3yPUk/24iovzKVXhJV11kKSDjvUruc8KB8SkYCGYk6ahUku0ovjYb8ffXV4dtS0y9XA/jWE2Xu2EQqQVBcfL/72/9AbPa7yeHOxjWCX/FEeaxH0mmDRJioG3Bbe4228FVmH7YsmwyRqV7E70im9UyySSRUrysQohyiNGSQKvPSgfFEX0T3I0DeyFAsFuEbhZHIQsXIKm54TEGpdu/PavgitPFkUvilnxQmEOPPecxWKd7xOJrewBQCG7WyZgzaHXHmzH26ZhAXypvNHhiXKtAUGr7eKw72OqsumrGwrg0yl4sJsQTusoz70Hy8a5ZfT59kyBMgdEF0wQJKF2J442XpA5BrludyhTdTEn0ztIsiiIuMT15lujHKS06u4Ltd4NZF2p6fY5cY1uJKD5juL5qlnez5VjtoP6WvEeO1Gi+xarhBcExcizwmQpXhSVTQku7rcU2PuUCuXLz7xWVVBa1oMZUuXcdUb1An4X2SSU6vI65V1EOucyzZD28q19QK/lwKTPZZsgyUlrBtrdP4puv0dxk18U5qLZOROxXZ+o3i9qvylB1eZO8ha90
 4qZ8UX93
 F+5TTyg8LXs/dkExk4bQ5habWm+OqXymAd4VdpeWJlQzOaPW2m+2rX9PQJ1ZnAGPeDeTkydVfjqPry2CHYh9N8Cijc4J2isNsY3eTFaEQE8Ksl9OdedcfE9tGwSlPvMP5lHwTo9uc5Jgm1y8cMEDAZxFWSzjEde1cqIwqYSbKsMI9xgIzkaneNiPEyWingIZTJQul1kIzmW3du1OmHKpqT1GYLvxojZaAYOhBhs57KH2+2buVX9BdzQHq+Th6C3ZNyhaB6fnq2YtMe9qepFPJ+FkLIL5Q+PYo39eF1d9u+AZhtQnDxHaIiqsr3upMY88xYMt1U0xK1reKn3+ecmUZrNXPK/Bpre0U5OKMEEFz2oReP6Bm9Iba69FE1N+RDDd3hDt4tRsRD8T8Mvu2pzUnEjpvwELR9xHBNrru2WjHIzpBV0gDLPrXAd5qzanDHFyvoHb5fxvJN9AEF/Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 11:38:52AM +0200, David Hildenbrand (Arm) wrote:
> On 6/4/26 05:10, xu.xin16@zte.com.cn wrote:
> >>>
> >>>  arch/arm64/Kconfig         |   1 +
> >>>  arch/x86/Kconfig           |   1 +
> >>>  fs/proc/page.c             |   6 +-
> >>>  include/linux/mm.h         |  38 ++
> >>>  include/linux/mm_types.h   |   9 +-
> >>>  include/linux/page-flags.h |  34 +-
> >>>  include/linux/pagemap.h    |   2 +-
> >>>  include/linux/rmap.h       | 165 ++++++++-
> >>>  mm/Kconfig                 |  22 ++
> >>>  mm/damon/ops-common.c      |   4 +-
> >>>  mm/debug.c                 |   2 +-
> >>>  mm/debug_vm_pgtable.c      |   2 +-
> >>>  mm/gup.c                   |   6 +-
> >>>  mm/huge_memory.c           |  16 +-
> >>>  mm/internal.h              | 171 +++++++++
> >>>  mm/khugepaged.c            |  13 +-
> >>>  mm/ksm.c                   |  43 ++-
> >>>  mm/memory-failure.c        |  11 +-
> >>>  mm/memory.c                |  19 +-
> >>>  mm/migrate.c               | 126 ++++---
> >>>  mm/mmap.c                  |  15 +-
> >>>  mm/mremap.c                |   4 +-
> >>>  mm/page_idle.c             |   2 +-
> >>>  mm/rmap.c                  | 690 ++++++++++++++++++++++++++++++++++---
> >>>  mm/vma.c                   |  76 ++--
> >>>  mm/vma.h                   |   4 +-
> >>>  mm/vma_exec.c              |   2 +-
> >>>  mm/vma_init.c              |   1 +
> >>>  28 files changed, 1279 insertions(+), 206 deletions(-)
> >>
> >> Hi!
> >>
> >> When I saw the diffsat I was concerned. Going through the patches made me ...
> >> more concerned :)
> >>
> >> This is a lot of complexity. On top of something that is already so complicated
> >> that I fail to grasp most details without regularly taking a look at the nice
> >> figures Lorenzo created recently.
> >>
> >> For example, I read above "since child VMAs do not need to allocate anon_vma"
> >> and wondered how that could be part of something that is just done lazily. Then
> >> I had to learn in the patches that there is some additional "Child VMAs
> >> are created as ANON_VMA_TREE_PARENT and do not allocate anon_vma" -- excuse me,
> >> what? :)
> >>
> >> Reading about VMA refcounts made me shiver. Reading "Holding only
> >> folio_lock(folio) cannot guarantee that the split
> >> operation completes atomically." confused me. Learning that we have to invent
> >> interesting ways to make page migration mutually exclusive to free_pgtables()
> >> concerned me. Figuring out that there are arch-specific config options and
> >> runtime toggles is a clear warning sign.
> >>
> >> Seeing test_folio_unmapped() was funny, though (why?! :)).
> >>
> >> I think this patch set has a noble goal of reducing anon_vma overhead when anon
> >> pages are not shared during fork. However, using anon_vma for them actually
> >> makes the overall implementation (e.g., rmap walks, locking) more consistent and
> >> simpler.
> >>
> >> Even if we could be convinced that most of this here is correct, how should we
> >> reasonably maintain this increasing level of complexity here?
> >
> > Indeed, it's very complex, but having the changes of 15 patches scattered across
> > various subsystems is really frustrating for reviewers. It took me a whole day to
> > read through the entire patch set, which made an already complicated matter even
> > more complex (maintaining such complex code in the future will be a pain).
> >
> > However, overall, I think the original intention behind Tao's patch is innovative
> > and valuable, and Tao could definitely make this patch set simpler and more
> > readable, because the core changes actually start from PATCH 10.
> >
> > I believe that if Tao had done the following, things might have gone better and easier
> > for reviewing. In fact, I understand the motivation behind the patch is quite simple
> > at its core (just wanting to avoid allocating the anon_vma structure when a VMA hasn't
> > been truly forked, and instead put the VMA information directly into folio->mapping):
> >
> > 1) You could actually simplify your patch significantly — without adding a lot of wrappers
> > and helper functions that introduce extra review overhead — and keep only the most essential elements.
> >
> > 2) Provide complete test code (in tools/testing/selftest) that covers the affected functionality,
> > such as VMA, huge pages, KSM, etc.
> >
> > 3) Use the RFC tag to start a discussion.
> >
> >
> > I would be very glad to see if Tao could post a simpler v2 version that does not alter the rmap
> > core data structures too much and does not introduce excessive complexity, no matter whether
> > it can be merged finaly.
>
> I'm afraid, the overall complexity would increase in any case.
>
> So to quote myself "But fundamentally, I think we want to find a new design that
> is just naturally simpler."

In general I'm prioritising my work, and hope to ship something within the next
month, even if it might just be some early bits of work on this to plumb stuff
in, and certainly the main ting will be an RFC :)

So keep an eye out for this which will hopefully address people's needs!

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

