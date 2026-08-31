Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41638C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 08:19:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 641916B0095; Mon, 31 Aug 2026 04:19:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 618A56B0096; Mon, 31 Aug 2026 04:19:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52EAE6B0098; Mon, 31 Aug 2026 04:19:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39AC36B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:19:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 57443803CB
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:19:46 +0000 (UTC)
X-FDA: 85160865972.10.59E8A03
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id AD68680004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:19:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UTm+JG3e;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788164384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cxHnScIhHfJHoR2y29MnW5qLoEsZ/nki/OaUtMHaDgo=;
	b=scaGFXw9rkCUiJcmaOO+RY+O0RlgTmoQxlLRHow2dUogtLoPRz0TcE5aJYzYceiR2kmNTM
	lJodIBFuTwrO+6vXANMHVSN4Pug2PkU7pfnIT3Sh7yiGk3WbSpzINiLwR4tyXsVzm5g2w4
	XYACESQsdH13lbzDlA31E/4ygEj3clk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788164384;
	b=KS3PW+LtPHksQGzgQkefdrRHjQlDFsgVpKii8AA3e4GThE3JrHAppaPLSqcOB+5vIyvb2O
	uPw4jlm2T6CwEggbbBXhkfGIK6qwEvKI49eWYJDhhblgiR/DW/3/RS1zOWI3oPbH2mSoxq
	BIPAXjA9398ndzlXb7gneSxuFUTjsP0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UTm+JG3e;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D4BA143B3D;
	Mon, 31 Aug 2026 08:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2641F000E9;
	Mon, 31 Aug 2026 08:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788164383;
	bh=cxHnScIhHfJHoR2y29MnW5qLoEsZ/nki/OaUtMHaDgo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UTm+JG3eWDTLXG6NArCPK/X08xuXmdV8frCPHlr+6nB2p60BXkeNN150Og2Z3jrHu
	 iHoGe+lwA3siYhqI/nbZcpMaihDEqragIlngcYXYehv4hX/bnZGdPFTMIfpQiZBLhm
	 7Kx0WCQITGP/FfmvzU9MMsIFPa8kZp/9gC71gid61pUMc7O/u93tr4j3VvDsPBvC+i
	 7ooIPxDiz6Dt74H9w2n0hS3OReI1R3cav97CNaaoWAjIjt5twSJWrx0ioSe0rP3BrN
	 SW77tfc7YP3mD9kJFNBzRrNqpwlBAkZM1e+r0B6bNKbLSbz03txdhSz6Z1ncWn3+SW
	 eJztJIHWuYvsg==
Date: Mon, 31 Aug 2026 09:19:37 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: KunWu Chan <kunwu.chan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, sashiko-bot <sashiko-bot@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/mremap: account mm->locked_vm correctly for
 MREMAP_DONTUNMAP
Message-ID: <apU5ErQKpDNqEuW3@gremlin>
References: <20260828-mremap-fix-locked-vm-v1-1-c80be7505d1e@kernel.org>
 <CAN_Opa9CZUTUyvveTnVXK7Wy9Xq-9wc=QkASceLv5hTE-NiNnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN_Opa9CZUTUyvveTnVXK7Wy9Xq-9wc=QkASceLv5hTE-NiNnw@mail.gmail.com>
X-Stat-Signature: bnjq9j3tpp63crj4hzag1xyigc6xs8ze
X-Rspamd-Queue-Id: AD68680004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788164384-384185
X-HE-Meta: U2FsdGVkX1/qjSLrHmkyXy26YRNlhPfIbnY2eyJIsvdY6U2sNAwTbnqf9u1+R2FmAQX1Xqx1XUheV6y8pdpZSIHrlmQyjWawlTYhDyjY3E+z6qZ/iWHDk+qqjcLUSTaSeidlvAIxhvd3VdCmm3E9u5yxkN4hsMXkWPfs72dsTjFvMKHxJq5LbE4q3hrwuaMYS/KiSWjS4vT/a3KtApf2E2IOEAu/XVxiJ936GddpKwIPxLLuaABwfxMVzkaO8jD2QJr6X9PFOTgdEti2aG+Z3FMKGzYs8mp5E4FsLGVMC6cir6wt6kdpKJS7S7doukyA8FJlkeSwOlC//naHujRlI98yWKrEioLbil1TB9wVG6Ts3G9nu/Dcq3lyXwwOxETt54eTxmHuQO9FsbQMV6bGgd0yrLsvAJSwVAFj956MswVUJT/8NKdsPWxeZzcx8EVYc4H15Pz7fPS9mGw/MIJePXOIzTNExTAGGWGYQ0pHk1rHt+clAwrF25JTOlrih70XXJMXSaJ8j22SHM/1VCd+iATTPbKU9Jp1jAFvfu3SFt0zeSuxmfOnXUg/VpQaqLb45JBYnM+QWRoMzfImcL6D64SkIlSwtdy3pk+8rUWco0ygjd90GdOiGP47BwUDKdsms8vdGYZeLMoIZs6OQrQNJxqgY1W/+wRfRoAjI/nKJPiq/EoKW2VdUXCC/0pWjSasQ1oVMA5xYkif9/noJGxI5NN2w0T/OaxWreaQSboko93vBB5AMAqVp66K5gWp8kXNm4cvvzdTuojFajaSjDK1qfX7yzghjgJe14PtmshYKmXx+rKn2Kp16u0J8ViEfP0zpmGs/SszpVQcqsEKrW37TSU6KOAB5O0tBX18vSRafIVzoZ1MJ0TxxBfQUrDRDjidNOuL/3sphd2a4+VrXKBNWhaXTejriEUWlDMhUe46Vz9YqCRtrAtWteYRX1lyeiO6oG2Dm3KOoxfAt7KjvS/
 JH/bzFPC
 emDxBEtJhzJ5uh3Gvp3xSo7Ys8pYrdLPAr1rLNpTs0+k79uD23a5CgtmkGJmdGKm7Jo53RsPFrghHTL+lUua3rvmBY4BjONRvPXX6+sZYjblmJ4/CntJQ/0A0Y4shsMQaaoMiF/YFrUKs8LEnjivv22F1WnAYpSq2yy73UnS4AltP4lZ6Zpb52e4HsHOH4DDX7tnVepXYHj/ZeI1lZCh9By1waNsYqjwC6apegf3p6lH/2eFlFMWw5Z0Q7cbvO7H/ua4Y1b/JxVbr2Mnfi9gzsPF+jPfklbGEZposTqC3j8LcyMbigNdcDoktjfzvvRzuEQ3M7Qf4UmbBn0rvr1llEJqUOTwNhb1EgclxFDywBH5olMJfzMhAbSR1AarzXFJ0835orrAds/PSO3nPhx4fPKs9eq+ADCsLu6zfUgf+GdtTrozLJ5Uw7gsB/SJQsLl/Zbrsk+gYKpw0886QzeaU0vTKGB+G4aew8wBY9WjkGaI/OQmTBqRuhzty8+SDD7Bi2M3o0K4DOAY6fAyuTjmxq/IJAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 29, 2026 at 10:37:11PM +0800, KunWu Chan wrote:
> Hi Lorenzo,
>
> Thanks for the fix. I agree this is a very clean solution.
>
> On Fri, Aug 28, 2026 at 7:20 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > When a VMA is mremap()'d with MREMAP_DONTUNMAP set, that results in the VMA
> > being copied, but the source VMA not being unmapped.
> >
> > If the VMA is mlock()'d this is a legal operation, though the source VMA
> > has its VMA_LOCKED_BIT cleared.
> >
> > However this is done in dontunmap_complete(), after mm->locked_vm was
> > incremented via vrm_stat_account(), resulting in double-counting.
> >
> > Worse, this is not even corrected when source VMA is unmapped, due to
> > the VMA_LOCKED_BIT flag having been cleared.
> >
> > This all works fine in the usual mremap() case (without MREMAP_DONTUNMAP),
> > as the source VMA is unmapped with VMA_LOCKED_BIT intact, at which time
> > mm->locked_vm is decremented accordingly.
> >
> > Resolve the issue by invoking vrm_stat_account() only after
> > dontunmap_complete() has run.
> >
> > Note that MREMAP_DONTUNMAP requires old_len == new_len, so no need to
> > account for a delta in size in this case.
> >
> > The bug was introduced by commit b714ccb02a76 ("mm/mremap: complete
> > refactor of move_vma()") which incorrectly reordered the accounting and the
> > clearing of the VMA_LOCKED_BIT flag.
> >
> > Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> > Closes: https://sashiko.dev/#/patchset/20260825-fix-mremap-dontunmap-pgoff-v1-1-39a40b2c98b3@kernel.org
> > Reported-by: Kunwu Chan <kunwu.chan@gmail.com>
> > Closes: https://lore.kernel.org/all/20260828094823.594279-1-kunwu.chan@linux.dev/
> > Fixes: b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/mremap.c | 9 ++++-----
> >  1 file changed, 4 insertions(+), 5 deletions(-)
> >
> > diff --git a/mm/mremap.c b/mm/mremap.c
> > index 2b4b523a86b8..7c368440fafe 100644
> > --- a/mm/mremap.c
> > +++ b/mm/mremap.c
> > @@ -1355,12 +1355,11 @@ static void dontunmap_complete(struct vma_remap_struct *vrm,
> >                 if (vma_is_anonymous(vma) && !vma->vm_file)
> >                         vma_set_pgoff(vma, pgoff_unfaulted);
> >         }
> > -
> > -       /* Because we won't unmap we don't need to touch locked_vm. */
> >  }
> >
> >  static unsigned long move_vma(struct vma_remap_struct *vrm)
> >  {
> > +       const bool is_dontunmap = vrm->flags & MREMAP_DONTUNMAP;
> >         struct mm_struct *mm = current->mm;
> >         struct vm_area_struct *new_vma;
> >         unsigned long hiwater_vm;
> > @@ -1401,10 +1400,10 @@ static unsigned long move_vma(struct vma_remap_struct *vrm)
> >          */
> >         hiwater_vm = mm->hiwater_vm;
> >
> > -       vrm_stat_account(vrm, vrm->new_len);
> > -       if (unlikely(!err && (vrm->flags & MREMAP_DONTUNMAP)))
> > +       if (unlikely(is_dontunmap && !err))
> >                 dontunmap_complete(vrm, new_vma);
> > -       else
> > +       vrm_stat_account(vrm, vrm->new_len);
> > +       if (!is_dontunmap || err)
> >                 unmap_source_vma(vrm);
> >
> >         mm->hiwater_vm = hiwater_vm;
> >
> > ---
> > base-commit: aeddb4d52acfcc5ce5e988acd48f2906fe966ca3
> > change-id: 20260828-mremap-fix-locked-vm-b8991ffc4181
> >
> > Best regards,
> > --
> > Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >
>
> I tested the patch with the following tests [1]:
> 1: test-vmlck.c — Andrew Morton's test for basic locked_vm accounting
> with mlock()/MREMAP_DONTUNMAP.
> 2: test_mlock_onfault_nofault.c — MLOCK_ONFAULT with no pages faulted in.
> 3: test_mlock_onfault_fault.c — MLOCK_ONFAULT with pages faulted in.
>
> All three tests passed with the patch applied.
> Tested-by:  Kunwu Chan <kunwu.chan@gmail.com>
>
> The fix also looks correct to me.
> Reviewed-by:  Kunwu Chan <kunwu.chan@gmail.com>

Great thanks! :)

>
> [1] https://github.com/KunWuChan/vmlck_test
>
> Thanks again!
>
> Best,
> Kunwu

--
Cheers, Lorenzo

