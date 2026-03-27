Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B424510F285E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 17:23:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F41236B008C; Fri, 27 Mar 2026 13:23:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF2236B0095; Fri, 27 Mar 2026 13:23:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2EB36B0096; Fri, 27 Mar 2026 13:23:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD0586B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:23:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5D9641B8EE6
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:23:42 +0000 (UTC)
X-FDA: 84592515084.26.FDD3BDF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9CB20140003
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:23:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HNCHYGGP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774632220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9NhTrkJRGClkqgsHXF+ZM+tLvbQyZWxF6uN08SIPt8k=;
	b=JGncj9t2vO/6O2caNAQW7YO0FribgjVZsczc6ZUqmmMfxGteaaO31hGdJGfx4bIEWHqcSg
	yjVLvWU5OrdYrZMtVZaV4RbEeD/0GUfuwrYaPTBzB3nAQZz09eIHI9/ptKYQQfQWluEP9k
	Iq9FG+sKiUJzbTcmQiL3Cmuv597lYKg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774632220; a=rsa-sha256;
	cv=none;
	b=XcxDk4u94IWO5R41jHbOLmZooGYxtDDdRwOhuV9PkNupIJJnve8Fj4YLFceI8uLGw03itl
	gW7oAPY2uKav08FcMAwwop0hefSNbOSlwqiMnM1FVYPUGR3lS2Y7ZOt4B+l3NYAXdeajkN
	D0sxqt6pSYEfg5cHauT+mAadmFaGGxU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HNCHYGGP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 89C8544524;
	Fri, 27 Mar 2026 17:23:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA4DC19423;
	Fri, 27 Mar 2026 17:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774632219;
	bh=LoOchEM2GvaQU0UW3QW6MbbvCC9O/qqhrAJClJpoxu4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HNCHYGGPgWiQAgkcynJCD/IJaQuDDouTkXWQZInqCQNdpvJRtJ/6j/MKJVojDfQaY
	 zbelBuWulqNyUmZXmCyq0NNF3GriNaxWMyLyf/EMEx7kJgcjcfBmMvCh/um/RoxyVA
	 MNJN8WL5rNgGkRkNCelbxtJFDnuyHLGkooTsqbHUSiV4EJylYAtGtEoBgAG5uPlC/D
	 GsJzkvcIMs2BE5pKbjw6EYCHhddZnbGBKmn7LX9wrrVAYx8bS2fuEBcPESbX6oyolB
	 yKUOCZcyw5S6FNAnsZCXWyZ6mFNgOB//n8v8gVdQdoOUNI8sLylXjmXvlghctxG/x7
	 SBr4OKna1kNTw==
Date: Fri, 27 Mar 2026 17:23:34 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Jeff Xu <jeffxu@chromium.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	antonius <bluedragonsec2023@gmail.com>
Subject: Re: [PATCH mm-hotfixes] mm/mseal: update VMA end correctly on merge
Message-ID: <5739bab8-d75f-404d-a3c8-a67f91e072a5@lucifer.local>
References: <20260327090640.146308-1-ljs@kernel.org>
 <d82c61ed-32ba-47ed-bb85-9facdee7c26f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d82c61ed-32ba-47ed-bb85-9facdee7c26f@kernel.org>
X-Rspamd-Queue-Id: 9CB20140003
X-Stat-Signature: wxxow6kx9akwoc87ohp36imn6eyu4mpq
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774632220-373924
X-HE-Meta: U2FsdGVkX1/IhVylo5HEkIeNoLLBoAMKPBwfyM2Iagyro9XYBg6BN6Ls6w5fPHavzM8mdoGuOIflRqLcfPlNwshNeX7LRxgLv1kfSH0WoUGTGqcRJQOkPL5HMRbwW+sui7JBx6YTtl2iK8+oxu+2m6ANCyXyPfFH/WFdzcKFuQEBnOnJeA669IUscQ2ONjN7ZNRh2opn02w6lHj4WyxpyvywI/7rPyuB7S3nc1O54/IniFQUj44vuq06OTNZu2mgzmQrMffaF2Fbwr63iMLRGwm69uDie2D0cUGw9eP2r8/sd3U3tY2Z0yciPKtJf+tg0nyEdH1Izf3HUYS474/PO/ZF+DjvdHUKW+PjqFCXL1Onk4wlOtDvvYb9vcTE/JpP8Vu/7PpD3c+PwdZJ9WUo6DLxKPHLVuCo6/Hs5fHh8NXWH+NWRFiGglBrkzpxrhspcWQZr2cPNIWiRN0J1Gpr7ntO4yEjvFAMNQA0/NusiQCkmBlGp66clvmfWcyxgGlGQHwfYcr+c8DMG0a7qUSU5CgmEzStu5AkjS0qkHFGVP6tREcWV/yQd0J0GFwZoXKd9wIP5OxwAhDfHhxKeSe0PrcfLv9g8DqV/rIi3QMSMUOAvznROn39MNZD7CS5olsWLQTPAuSqkHZC4tuM1hCMh2Zeozz9ev9zpSR6L/V+Y0l9Pj5GCfDdPtiwP6gAwB5jsL5cFJ3Bt1ZZvKah1foageTmLjmg9pi5asZ2DpB9FD+O2Q8TLPQA6XOp9RsYsGiQXRiYU9SlBw7y+zTilm9G/GmaRRqEBv499LWCrX1sDW8xgZ/1ztTgzNzfFz1ASLw7oMMPR8kP//gcBOT8jN0JrTvbkQWp4/thfQVQ4D9ENor2yFg0CFB/nG0tc/tGTj4+wAoYqF+SeVzwIqmJlAs22374tx9UBChdbcFDMBXh85e/EkIhDA7NVuZYLG6xFz1PbsrgJUsDLire1rrptK4
 OH1VAMKI
 hNn9y0ZAuV2v1jUIXuSSTzRrp9uUY/0SGmVIg7pjhc612VHvPxQNaa69PC7Uh0/6ty1FI5XxGB6hMJGCeMVf8rFIvO/2nEOjCPDzqiseVzNBAJw8sGoJBshwJo/0S6xKY+q5Qb5Lg8Sig28U0Gxu+dEZU6i+Am7UXfgNTskpe/BPGZmQtvJdka8KaSHNP4A//ArCuC8vu+Z2ZkW2yAWeOuyKuzrYI2A8YlPu6Z2ggPiA8h6/ooChpz82WTlIDhIxQjtAlv7/SKmt9TPUa1godlJOTSwlJN+uB4OT0dCj95mxe8QFACUT9ZmtKbpgE6nxvCCZh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 05:57:06PM +0100, David Hildenbrand (Arm) wrote:
> On 3/27/26 10:06, Lorenzo Stoakes (Oracle) wrote:
> > Previously we stored the end of the current VMA in curr_end, and then upon
> > iterating to the next VMA updated curr_start to curr_end to advance to the
> > next VMA.
> >
> > However, this doesn't take into account the fact that a VMA might be
> > updated due to a merge by vma_modify_flags(), which can result in curr_end
> > being stale and thus, upon setting curr_start to curr_end, ending up with
> > an incorrect curr_start on the next iteration.
> >
> > Resolve the issue by setting curr_end to vma->vm_end unconditionally to
> > ensure this value remains updated should this occur.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > Fixes: 6c2da14ae1e0 ("mm/mseal: rework mseal apply logic")
> > Cc: <stable@vger.kernel.org>
> > Reported-by: Antonius <antonius@bluedragonsec.com>
> > Closes: https://lore.kernel.org/linux-mm/CAK8a0jyHXqBpt8Xe8v9SNDbnRiwz7OthA8SKY=NLRY7smPEP3Q@mail.gmail.com/
> > ---
> >  mm/mseal.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/mseal.c b/mm/mseal.c
> > index 316b5e1dec78..2d72a15d8ea1 100644
> > --- a/mm/mseal.c
> > +++ b/mm/mseal.c
> > @@ -66,7 +66,7 @@ static int mseal_apply(struct mm_struct *mm,
> >  		prev = vma;
> >
> >  	for_each_vma_range(vmi, vma, end) {
> > -		const unsigned long curr_end = MIN(vma->vm_end, end);
> > +		unsigned long curr_end = MIN(vma->vm_end, end);
> >
> >  		if (!(vma->vm_flags & VM_SEALED)) {
> >  			vm_flags_t vm_flags = vma->vm_flags | VM_SEALED;
> > @@ -76,6 +76,7 @@ static int mseal_apply(struct mm_struct *mm,
> >  			if (IS_ERR(vma))
> >  				return PTR_ERR(vma);
> >  			vm_flags_set(vma, VM_SEALED);
> > +			curr_end = vma->vm_end; /* Merge may have updated. */
> >  		}
>
>
> I was a bit confused why curr_start is allowed to not start within the VMA,
> but before it. Then I recalled that range_contains_unmapped() checks for no holes.
>
>
> Would the following also sort out the problem and even simplify the code?
>
> diff --git a/mm/mseal.c b/mm/mseal.c
> index 603df53ad267..e2093ae3d25c 100644
> --- a/mm/mseal.c
> +++ b/mm/mseal.c
> @@ -56,7 +56,6 @@ static int mseal_apply(struct mm_struct *mm,
>                 unsigned long start, unsigned long end)
>  {
>         struct vm_area_struct *vma, *prev;
> -       unsigned long curr_start = start;
>         VMA_ITERATOR(vmi, mm, start);
>
>         /* We know there are no gaps so this will be non-NULL. */
> @@ -66,6 +65,7 @@ static int mseal_apply(struct mm_struct *mm,
>                 prev = vma;
>
>         for_each_vma_range(vmi, vma, end) {
> +               const unsigned long curr_start = MAX(vma->vm_start, start);

Yeah that's nice :)


>                 const unsigned long curr_end = MIN(vma->vm_end, end);
>
>                 if (!vma_test(vma, VMA_SEALED_BIT)) {
> @@ -82,7 +82,6 @@ static int mseal_apply(struct mm_struct *mm,
>                 }
>
>                 prev = vma;
> -               curr_start = curr_end;
>         }
>
>         return 0;
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>
>
> I might be wrong about that, I've been staring at the screen for too long today.

No this is better, I've mulled this over, this is much better :)

Sorry to be a pain Andrew - let me respin this right now.

I will retain tags as this is functionally equivalent, I have checked it
locally, confirmed repro solved, checked against AI review also.

>
>
> --
> Cheers,
>
> David

Cheers, Lorenzo

