Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1438DCD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:00:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63CE76B008C; Fri, 29 May 2026 10:00:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 614E36B0092; Fri, 29 May 2026 10:00:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 552186B0095; Fri, 29 May 2026 10:00:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 463B16B008C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:00:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E553F1A018D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:00:39 +0000 (UTC)
X-FDA: 84820617798.27.37B4F58
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id CFDE040011
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:00:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ENTBUfU9;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780063238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OPcYymHmOJpRusLXuWmZNY6VFZDOtwyJMTAW5ccYu6k=;
	b=Y3yzZfXGjXl3JNbwIIR2YcB0HKjjuo0qmNxbtkF9IeuzsDDBSVCCoc7n7TelRVETBpVOXz
	29yrwS84NBxk7s8HBOl0R5MaIn+1l8KBCbo8ZB3scaj7XlCtL7kGSesE7orLUyxX2N1c24
	ateDQo1J8rgePSj2oOlm3SvoEaIcW6g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ENTBUfU9;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780063238; a=rsa-sha256;
	cv=none;
	b=Ku+u66uudsE2voseinzh4Y+XBFRY/zV3Tu2+mE+d049UgNi0YEAac2L8Xn6jA+0OPepkm9
	2E/wZRIhxaV2bie8h0/ipNt8JLlcDTJFgdkiMrSnzi2EYPpKblhnsU62/eQKxf0WbdFMJN
	IiyJ9Mfx6v04RcXsY6uOZC40AvqUUlE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D8D19417DE;
	Fri, 29 May 2026 14:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02E91F00893;
	Fri, 29 May 2026 14:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780063236;
	bh=OPcYymHmOJpRusLXuWmZNY6VFZDOtwyJMTAW5ccYu6k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ENTBUfU9LnD7fAI5xU/4xcee1oNGvdMfii+swBtlaOam7bQBWxeIDOcQ+dZCC37zt
	 J4YgC4T2udD2L+XartNxejOiyD//y1noIpU3Y2VRbyqp9b+vTeOU8NNufBHz8d3x6G
	 0KG6KFuEG/duwIK/5kbXC0tsVQ/UVxdIVqNLQc1dE6AL63h5zyAYhW6daDHS35wlPJ
	 ZlC8eGvlxFfTIhfMgFktuFDMgy6JacSo6F+mMFk3V8tEN0KHkwdbeQ2mkoPkKOI9n9
	 zPG1YyhGatWfCJ548U9tm9hFuEKAYLkn/Jhlr78Djv5nCWrYlvLKIUCDa1da7WpLDa
	 GEZZm6tokEFTA==
Date: Fri, 29 May 2026 15:00:28 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, 
	david@kernel.org, surenb@google.com, vbabka@kernel.org, Liam.Howlett@oracle.com, 
	ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, seanjc@google.com, 
	pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, sj@kernel.org, 
	usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 08/18] mm: add VM_UFFD_RWP VMA flag
Message-ID: <ahmQCwG2xCSwO29k@lucifer>
References: <20260526130509.2748441-1-kirill@shutemov.name>
 <20260526130509.2748441-9-kirill@shutemov.name>
 <ahk60ViRq4q2g4uz@lucifer>
 <ahmM8LzrzX-qP_5s@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahmM8LzrzX-qP_5s@thinkstation>
X-Stat-Signature: xm3ynpaxkoaz46rmfew7n7g81sp87648
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CFDE040011
X-HE-Tag: 1780063237-886157
X-HE-Meta: U2FsdGVkX19C/HOAWWND1DwsV9qN54KnQdqslMJe1rvKeBhBXeaz/gqm7agAHMc4NCJHaZ/bndctuXYeOzOBL0EpSczWgFVZ5LLg4hbr6J0hqlgUKRUHbU3FnRHEfmSz6i0LXJIuX5ayiXt2FHugSSvY3SYkBr5NO4MwQ46tXApNoLyfk70aUaergI9QxzqG71qhWB6RqIDcu7jTuILS7SCtH9CtVvh40YROsZhRvyVvSeWlpYbJv3Vr1eZl+u6KXgSMl92Y6GdC+94IaoAQ7YxcHZZmoEL6c6Z7CHsKiXPttNKcJxBjip27DNz4qo4EnRwbD7BklNTkhmdKPl5UgM/pY/ECTj5xpFxm0aFhpaKFhZt/fV7rfsKOXTWB4GNkwjEMuWUI81FTyvWoDWyAt5wO4wFeulXBCbprd3JaurxLjsxgYgHec8567kuSKa1ljz+3wMQV1wVyEJzZx1W6SMJvFdWGpzrpIPHmFYLEeO0npUUXuXtHJECKecIWhQyFLypB+NHCT2AsexMCGKNXKlNKaRyeqrgbNmZ9br12UYg47mKWaWg6T0Q6dFKHIKxr2rk4fdBiFDbA2kjLUC9Y4ilqFSxTJtX6Dv9zkfYFC3XltisxN7ccTxYclHpVrlPepzW3owsp0uwVhbgNE67IzW7j0qZIkKVKWOxnXlYzd5wbV0N1UlqchvZdbPvF/cklM962gS8ZysG8fG8Ak6m+hCl6n0NlxY72LmyaLmfhUxW5XUCoLWxB6M04uG1FvlpM1EIqnojAR0hyCVuP23dMlTQ/99dqc5AJErdSzCEu0IisPG2I1b1wguTZFcr/bgHLJUHkCUSAqkBSX4wwWpgtRTCdJuxDp4bFv/UPgLauJ09+U3qVMvZqb0kAj4BORVu9cqvTP7AoUBqMjczqp9lG4T545r/f+Blt81EHGZVqkAHkQjJUmEDsyfjoKY3CnEpDVKzAVOVkoItJIG0KU6Y
 J46f0yog
 0TjDFIJXMrbFdLTEBzp1IraIpiQ/3Dod/Q1dHh3OFklzLP9N81VwPG5PVqtE+C3vpLuZVpIudLfFaM0Hv6c1Aeo9rwGpwCh1HWpM5pMfhLjBxQ28MsdEwVdTZgrLfK9nmlJ0tIYM/W4MdyrMat4zcxuvL7b9OQ6NcXdPsUhoabxLxPSy/N8bDBKbiUGyE+LRkg5bxfM7cVyJ1WKi/xRVCXyAlMCWwEC6WlxEWt7l3/h7FHygC1XcIab1QnZnQPNY53zklpOMCnJtHsXLf3j6wwoaw+FrjmcokYqCC3GTPmx1DJFZ68mDXoJ+4l+P/ELBYEhMQjPndoIS4uJZ0IXBLpQJdQ8qEm41d3tLyVZtAMrH7wJA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 02:07:16PM +0100, Kiryl Shutsemau wrote:
> On Fri, May 29, 2026 at 08:24:55AM +0100, Lorenzo Stoakes wrote:
> > On Tue, May 26, 2026 at 02:04:56PM +0100, Kiryl Shutsemau wrote:
> > > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > >
> > > Preparatory patch for userfaultfd read-write protection (RWP). RWP
> > > extends userfaultfd protection from plain write-protection (WP) to
> > > full read-write protection: accesses to an RWP-protected range --
> > > reads as well as writes -- trap through userfaultfd.
> > >
> > > Reserve VM_UFFD_RWP, add the userfaultfd_rwp() and
> > > userfaultfd_protected() helpers, and wire up the smaps "ur" entry and
> > > the trace-flag table the rest of the series will use. The flag is
> > > gated on CONFIG_USERFAULTFD_RWP, which is introduced together with the
> > > UAPI in a later patch; until then VM_UFFD_RWP aliases VM_NONE and
> > > every downstream check folds to dead code.
> > >
> > > Nothing sets or queries the flag yet.
> > >
> > > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > > Assisted-by: Claude:claude-opus-4-6
> >
> > Hm, if you've just used claude to bounce ideas off, I'm really not sure if
> > it's necessary to disclose, though I respect your thoroughness for doing so
> > :)
>
> I've elaborated on how I used Claude in reply to Andrew:
>
> https://lore.kernel.org/all/af5eALk9yO8pPcHv@thinkstation
>
> It is more than bouncing ideas.

Ah interesting! Fair enough then.

>
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index 71b11945e4fc..6499cfb61dc4 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -362,6 +362,7 @@ enum {
> > >  #endif
> > >  	DECLARE_VMA_BIT(UFFD_MINOR, 41),
> > >  	DECLARE_VMA_BIT(SEALED, 42),
> > > +	DECLARE_VMA_BIT(UFFD_RWP, 43),
> >
> > I'm guessing CONFIG_USERFAULTFD_RWP is predicated on CONFIG_64BIT?
>
> Yes:
> 	depends on 64BIT && ARCH_HAS_PTE_PROTNONE && HAVE_ARCH_USERFAULTFD_WP
> >
> > It's a silly situation and once my VMA flags stuff is done it'll be
> > eliminated but for now... :)
>
> Yeah. I actually would appreciate your take on 04/18. It is related.

I'll reply there.

>
> > > diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> > > index f4cf5763f92c..0aef628514df 100644
> > > --- a/include/linux/userfaultfd_k.h
> > > +++ b/include/linux/userfaultfd_k.h
> > > @@ -21,10 +21,11 @@
> > >  #include <linux/hugetlb_inline.h>
> > >
> > >  /* The set of all possible UFFD-related VM flags. */
> > > -#define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_WP | VM_UFFD_MINOR)
> > > +#define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_MINOR | \
> > > +			 VM_UFFD_WP | VM_UFFD_RWP)
> > >
> > >  #define __VMA_UFFD_FLAGS mk_vma_flags(VMA_UFFD_MISSING_BIT, VMA_UFFD_WP_BIT, \
> > > -				      VMA_UFFD_MINOR_BIT)
> > > +				      VMA_UFFD_MINOR_BIT, VMA_UFFD_RWP_BIT)
> > >
> > >  /*
> > >   * CAREFUL: Check include/uapi/asm-generic/fcntl.h when defining
> > > @@ -178,7 +179,7 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
> > >   */
> > >  static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
> > >  {
> > > -	return vma->vm_flags & (VM_UFFD_WP | VM_UFFD_MINOR);
> > > +	return vma->vm_flags & (VM_UFFD_MINOR | VM_UFFD_WP | VM_UFFD_RWP);
> >
> > While we're here we might as well switch to using the new API?
> >
> > Can do:
> >
> > 	return vma_test_any_mask(vma, __VMA_UFFD_FLAGS);
> >
> > One unfortunate thing is using bit values means we can't do the VM_NONE
> > trick, but if !CONFIG_USERFAULTFD_RWP then VMA_UFFD_RWP_BIT wouldn't be set
> > anyway, same for minor so this should be fine?
>
> I think we need to decide first if the 04/18 direction is right.
> We can define VMA_UFFD_RWP_BIT to VMA_NO_BIT if !CONFIG_USERFAULTFD_RWP.

Yeah I don't think that approach is workable unfortunately (see my reply
there).

But I suggest some workarounds there with VMA_UFFD_RWP.

>
> > >  }
> > >
> > >  /*
> > > @@ -208,6 +209,16 @@ static inline bool userfaultfd_minor(struct vm_area_struct *vma)
> > >  	return vma->vm_flags & VM_UFFD_MINOR;
> > >  }
> > >
> > > +static inline bool userfaultfd_rwp(struct vm_area_struct *vma)
> > > +{
> > > +	return vma->vm_flags & VM_UFFD_RWP;
> > > +}
> >
> > Can be:
> >
> > 	return vma_test(vma, VMA_UFFD_RWP_BIT);
>
> Yep.

With the approach suggested in 04/18 we could do this as:

	return vma_test_any_mask(vma, VMA_UFFD_RWP);

Which is a bit fugly but will work.

>
>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

Cheers, Lorenzo

