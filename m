Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 338F210A1E77
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 11:10:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BA296B00BC; Thu, 26 Mar 2026 07:10:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36A786B00BF; Thu, 26 Mar 2026 07:10:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 258B26B00C1; Thu, 26 Mar 2026 07:10:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 116E76B00BC
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:10:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A22FC160CCB
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 11:10:38 +0000 (UTC)
X-FDA: 84587946156.02.07630EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0D5384000C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 11:10:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=px3KYKv3;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774523437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ksxNBxafjTmVCofFZmS/77PXYTqsqEzFTMsAwe+qK+I=;
	b=r4YLjR9uUWNOGad9Lsbdf/abW4WIHCutbYOOYBBeyyWDPTcqlRHXtOovMxaf9rJC+O3l18
	m2nxYvFHFLaBdIrdB7XxPFwnLQBAg6XKg5m8DRlWjTSj7cqDJID1wSOc3UjFdmm4/ZKsXt
	YHVeBBeWIcsCvYJGYvZoUcfcOJAlgZM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774523437; a=rsa-sha256;
	cv=none;
	b=Eu7ZcEPjP5PSgVOtLWotT18NN/o6eqFR78DofuOikZRCLd4+e8HVxGeDxs3kzXv9rRnXRA
	lTnoMvYdZYC/ff7HYsraSCCypog64yMzwyBbia/5mEEPU5e6jlhm4wkky/6gIsaMXt199g
	8tD94BU3BUtcibIpHPfQSZugsn6Hgcc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=px3KYKv3;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F68B60130;
	Thu, 26 Mar 2026 11:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A83C116C6;
	Thu, 26 Mar 2026 11:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774523436;
	bh=qfdbXfpkXTWqgQ8FqX+0E2eSdl6peEciH9K0TiM3LiY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=px3KYKv3RJT+LOvqiFgExnVdmCKebe4xPFh1tDNkC+R3Lpug2ZFS0Md2SRJjUw+HC
	 qNP1OTJa4/QIsQOC2S0GrzOPY1kJ4T/ph5XcTDVj2gE1pRBC7RkzAxHSTPU3wwJ7vp
	 O6q9k07csP33m4w24TbMuDMae0NbtEzmesgh802DrGOG3vPp7xhhkOcaw4kK6EQGkC
	 WFzUifCaoE8MK7JAhAUHHepnDddbI/ceFm8dX5dd+jDdIUrLkohrHyqqDI6j5OsGWJ
	 O6ltPecqlyOPBS5ybdDnjB8wGOn5G0/JVBHTyqO1rGK7SGg0sD8NaLtbBScnzaEZV3
	 EtH4pyMXOI3Yw==
Date: Thu, 26 Mar 2026 11:10:28 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org, catalin.marinas@arm.com, 
	will@kernel.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com, 
	willy@infradead.org, dev.jain@arm.com, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/5] mm: rmap: support batched checks of the
 references for large folios
Message-ID: <a0181a7c-d191-483d-bbc9-678bc355a984@lucifer.local>
References: <a4d7cf56-eab4-431d-886b-a32456e44736@linux.alibaba.com>
 <CAGsJ_4woBVQdYcCbN1Btr2vxOL8OAujaHkNZZ41=S-TdNh-wbw@mail.gmail.com>
 <d6820b1e-52ae-4ef2-8342-11818fdd0cb1@linux.alibaba.com>
 <43831628-a00f-4292-9797-cb96a029bb00@kernel.org>
 <e54e0ec1-b968-4e12-84a3-4e3d331b1c36@linux.alibaba.com>
 <86f611cb-1292-44e4-b629-6503135d33ca@kernel.org>
 <e5cb474a-a84d-4edc-8289-d68378feee7d@lucifer.local>
 <e3e374cc-ddf2-4112-b063-6cb1839ea566@kernel.org>
 <e227a7f7-0186-4d10-b7b4-c84ca8424bdd@lucifer.local>
 <bfd282b1-523d-4945-97a0-ec30fe1df577@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bfd282b1-523d-4945-97a0-ec30fe1df577@linux.alibaba.com>
X-Rspamd-Queue-Id: 0D5384000C
X-Stat-Signature: 5s1znze1kdasdouez5qr5ub1q8ibh8qh
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774523436-213907
X-HE-Meta: U2FsdGVkX1/3VaMcnfMpokEZZnTJgbsjMx5U+o5QT/ctNluFKW+wIEiQnPOoE3ldStYg3Mi8Qt/GOkOwkx2vEMUhug1GKJorV4maybSDXmEo48ZlHJyuTW6c+rBqFs3Kbz3Bywjy5/MwNwoVK1/4TxjRy6dxFjrvlpbTZih1Om2S+hsfSkL//t/yYvFslpT3BvJO0h6gQ3u5ZqzKXwY4aLLlYt3zbAXBHnVepRuhgW3yOZ1dQIikmlBKS1SZccUr7UW1ZVwHz2EUQtwYgG2LX3Fa4dRvoKQU7l3ij9cqKfgUxSKW4AoXX3v+ZcyKRe99D5YB/QCtGvMbPjVPy0EMOO0ogy+aN2M6ez2155wjeZgrcvfs1rNGI8nqQzbG/2ZrXUy1OzkAIvrTvCm0JEkwboe664aD5iYYdxd7uikDEij10LKjyTd+k5wdvLACJuA54cZs1a91AMw6b1EBOzI1krhQEQBLqiBbeZhXjk5qMGjWM4HhPufc660i/Lah79kR26fdGUar9/ZyN3TuaNqe6fAALOI3DEycphsGl4h7mRzoGKt6Gyq7zkEs3fOlhz1d1TBwkNfjC1xUiJQL2TWN8u16MVfCyvEFiKeffBOGc8iiHDaRVhBojjVLOPRHM9UBYBIbwaWIrvrXYU+dM1oECVV0eEqc4tCiubsLQjD1h40eg/gnHJq56R7k6rL3XtM2s35vmxvWH9DItS/40MRckMTI278hNprsIebWUNPFP85mDOE6dgZW+QJw27iXCyaT134GUpI/vvT4dpvTlRRyOUihzoEWgwTIlSHsBGGQq2KWfH5HIrJjEz4E9tmnurpxddh9tdrq/muR0iYvqE971/mdw989unGIcDntaxUkqK8cIBM/AkFXyWiYuVK/kRANJTRfVmeX35dtIxqCuYy1E2VE0qPVsgIdPYvbZx4zEB2sPQDNWX/2jwHydOzBTaYEs49hHpO5O2IuabgOYmE
 zxrOy6zn
 GvHIcij780FEOZrZCovASKG6zlVY/t1/65qmCqKafzbA5qBcOWST4qt4+pUTIA9RmZ/z5duQlApHH6rAKNjzRDgzZA7/hxwC7HyPOTioq0I2jJY0CFAbzVXmBH/uY51b0jksPngIluKez0901nDzswRjjnB6we2o2yRtTiiXnlotMesF7A/YhxRz6pymhHhv2XitExTC1a/RW80wBDsC8PERgjXp1byx9voO9MLMVTSkOAeE425CE9Esd1Z+rMidi+9RnyV11mTlQ4BPBLwzcEk0RSfG6mXrLEs9K8c+jX7XiaP366pCBMDEEUsHRgrf2wnSPKIX9h1Sq9h8nXkPV6KWz+N7VVPI/hzIQSeOXsfOboOCunDQdu0SJUnFj6BmQDqXSIHaZB10wfdXACBR2MEFSZIhOlRRFUMwNpEonk3uEibk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 09:47:51AM +0800, Baolin Wang wrote:
>
>
> On 3/25/26 11:06 PM, Lorenzo Stoakes (Oracle) wrote:
> > On Wed, Mar 25, 2026 at 03:58:36PM +0100, David Hildenbrand (Arm) wrote:
> > > On 3/25/26 15:36, Lorenzo Stoakes (Oracle) wrote:
> > > > On Mon, Mar 16, 2026 at 03:15:18PM +0100, David Hildenbrand (Arm) wrote:
> > > > > On 3/16/26 07:25, Baolin Wang wrote:
> > > > > >
> > > > > >
> > > > > >
> > > > > > Sure. However, after investigating RISC‑V and x86, I found that
> > > > > > ptep_clear_flush_young() does not flush the TLB on these architectures:
> > > > > >
> > > > > > int ptep_clear_flush_young(struct vm_area_struct *vma,
> > > > > >                 unsigned long address, pte_t *ptep)
> > > > > > {
> > > > > >      /*
> > > > > >       * On x86 CPUs, clearing the accessed bit without a TLB flush
> > > > > >       * doesn't cause data corruption. [ It could cause incorrect
> > > > > >       * page aging and the (mistaken) reclaim of hot pages, but the
> > > > > >       * chance of that should be relatively low. ]
> > > > > >       *
> > > > > >       * So as a performance optimization don't flush the TLB when
> > > > > >       * clearing the accessed bit, it will eventually be flushed by
> > > > > >       * a context switch or a VM operation anyway. [ In the rare
> > > > > >       * event of it not getting flushed for a long time the delay
> > > > > >       * shouldn't really matter because there's no real memory
> > > > > >       * pressure for swapout to react to. ]
> > > > > >       */
> > > > > >      return ptep_test_and_clear_young(vma, address, ptep);
> > > > > > }
> > > > >
> > > > > You'd probably want an arch helper then, that tells you whether
> > > > > a flush_tlb_range() after ptep_test_and_clear_young() is required.
> > > > >
> > > > > Or some special flush_tlb_range() helper.
> > > > >
> > > > > I agree that it requires more work.
>
> (Sorry, David. I forgot to reply to your email because I've had a lot to
> sort out recently.)
>
> Rather than adding more arch helpers (we already have plenty for the young
> flag check), I think we should try removing the TLB flush, as I mentioned to
> Barry[1]. MGLRU reclaim already skips the TLB flush, and it seems to work
> fine. What do you think?
>
> Here are our previous attempts to remove the TLB flush:
>
> My patch: https://lkml.org/lkml/2023/10/24/533
> Barry's patch:
> https://lore.kernel.org/lkml/20220617070555.344368-1-21cnbao@gmail.com/
>
> [1] https://lore.kernel.org/all/6bdc4b03-9631-4717-a3fa-2785a7930aba@linux.alibaba.com/
>
> > > > Sorry unclear here - does the series need more work or does a follow up patch
> > > > need more work?
> > >
> > > Follow up!
> >
> > Ok good as in mm-stable now. Sadly means I don't get to review it but there we
> > go.
>
> Actually this patchset has already been merged upstream:)

Err but this revision was sent _during_ the merge window...?

Was sent on 9th Feb on Monday in merge window week 1, with a functional change
listed:

- Skip batched unmapping for uffd case, reported by Dev. Thanks.

And then sent in 2nd batch on 18th Feb (see [0]).

So we were ok with 1 week of 'testing' (does anybody actually test -next during
the merge window? Was it even sent to -next?) for what appears to be a
functional change?

And there was ongoing feedback on this and the v5 series (at [1])?

This doesn't really feel sane?

And now I'm confused as to whether mm-stable patches can collect tags, since
presumably this was in mm-stable at the point this respin was done?

Maybe I'm missing something here but this doesn't feel like a sane process?

Thanks, Lorenzo

[0]:https://lore.kernel.org/all/20260218200016.8906fb904af9439e7b496327@linux-foundation.org/
[1]:https://lore.kernel.org/linux-mm/cover.1766631066.git.baolin.wang@linux.alibaba.com/

