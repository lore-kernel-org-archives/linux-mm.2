Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04CE0F417E0
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 14:28:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 578E56B0092; Mon,  9 Mar 2026 10:28:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 523E06B0093; Mon,  9 Mar 2026 10:28:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 425C06B0095; Mon,  9 Mar 2026 10:28:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2FFF36B0092
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 10:28:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F1BD61C156
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:28:13 +0000 (UTC)
X-FDA: 84526754466.12.5D1345C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5148D80012
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:28:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="tG/pGiO9";
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773066492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kH35TK/7qXNduI2zjo1n2JGOnjqKzdb7QkmSUlZ0deY=;
	b=0y/YXXbFKK8/I7hlDU/ZXs3oB5htJXq3egKMPoxqwk9nIk8OyCfvJdXZEA6g1bkkfP2Kpb
	MekNGrHPnTuCUWT+UpVUZqppiQdfaK0Jh/MLfjPCPfHjFVtEfG3ywaZ3j48hA3Cv6DtUP9
	7GCZys7Q1OTZ+dUdISlcq+sa5K8jxtc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773066492; a=rsa-sha256;
	cv=none;
	b=mROnUD99ldYSnl9feSW3+GBrBYmYEs7hVXa3y32BUujwiDPhHiwBPx5/7URjplnL9gJdoM
	G2HBtWPe33LSBAmjU4Gm7wKSFwV9/L9Msw/aCrYkDzB/JxQn0GSS1UvvnLwxBfTob6AKaQ
	u4vrJIqKWUQWHyh2UsAVQCGz6rtLByY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="tG/pGiO9";
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6722A4357A;
	Mon,  9 Mar 2026 14:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B8AC2BC86;
	Mon,  9 Mar 2026 14:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773066491;
	bh=7JXNJOMUJUG51xw/lDjwV9j46CypKr82OtNBQJLLoIA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tG/pGiO9hnbZk88Ow8KejU1Q2MK/j8Kkjr8IKz2pY4rbEyoaI9DzUa/4Xie4bC7RE
	 blTU3l3ZiLIQdn8aeVnObkUGo8IIiOyVtIum+na+R6a7kUzjgrYL+xhDCXOicSZCYP
	 ZvQpm0qw3Jf1RfR7ie9o9rdkx5hO6B/fDBjGT/PGT014CE6sI6zvtMHmioj+yVJyWU
	 cWhpH+xM3soBg1ykGQ6gJvQiMR3ZI28h6VxqYu0WzNzccGi2csXDTtra9DPOQhbiz2
	 fFJTdLMtVJ8G6OeVXtDnQEm7o+UOE63aFUrKRZ7zNMyCKl9OR1BEisTOs38rbXD5aY
	 0mB+HD5syWjGw==
Date: Mon, 9 Mar 2026 14:28:08 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, jannh@google.com, 
	pfalcato@suse.de, Jason@zx2c4.com
Subject: Re: [PATCH] mm: prevent droppable mappings from being locked
Message-ID: <53d66564-0596-45aa-b639-e2ea15356ae9@lucifer.local>
References: <20260306204550.8405-1-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306204550.8405-1-anthony.yznaga@oracle.com>
X-Rspam-User: 
X-Stat-Signature: ygnsyryqaag9so5ag4nyktzistd74dzp
X-Rspamd-Queue-Id: 5148D80012
X-Rspamd-Server: rspam03
X-HE-Tag: 1773066492-212423
X-HE-Meta: U2FsdGVkX1+Rmr1c3N+08Xv8/IobAI/nxo+fFb6RIfEQvhp5vA38gHdGl7a0oxQIcmknqwhFxrptYisuq6FOA+nGZ1e/Jpx97CyW6cCXIfO5N3Tgtxr2McoDiCZY/ZGtDkHk1XTCR85mAOAdoWrlWhlQxIy/Trocgtg7F1pXQe0wIwduM1dQzX3k80Oe3VcTbCi04folZQrVx1fI4Mj/N/Y2m9bPKK0gmEU39Gj2iGjbdP/CDx3Prpufg17wCu1VY9Mg5UXFye8fjVMeRfr3FwtGXkEXiF5pBNkUMn5h1+mSswTpmGoCWIG9BUUxQQvZG6oVMl6/Y07AaHKKS5QdoIwoTa+3QCjinrhxlezYzzCFqq85rWM82q8SI2ke0nXEspYi6wDRMT4TGZ+5lPSmzrgXmG/nC2YN6PJCUJ7dYVcEA0eOFIL2+Jqj1VfPnrCXkQtSigJlq2loclmyVkDVTieS/oF8AnQnjP8QbpsBPdn0j7bIezg30d4NmcgLRlx835VVoRzcdY+JiBf3MScneDQtaI6ZbM4q7FcmWl5VoDZ+NDjOtHtnEmjtdjk71NFkSabeCuDZ8ZQs/iO6QFiaR8NU1OTWlE1bEe8rjMmP4xKcrxQco4hBo4UzExyEnxC0O8I+f+zR6Zd5bsyDxEvQG7Nwqtej4N/E2u7HPzSPnFAydGK76bVEyAq93EYLhVfcyMC6vSc8KDsWyY03rtsL06GAtM5wD+w8YTTVUWBBZYElIpivlnskRVOOcYpewfiKHF9cLHHYaUTeliGCokh5NaT3khfMYg1+85ixCz5MRtCXn6bWyJMDiaONF63U0jG48FRynVCWsXUlWnkSwFmbMoNB/ec35tpnqMpiU/krQXgKVIcHGKWrq5xuAWpFVVW/L2FX3xBNXLqVpxFKxELRt9n439ngs4VIkGBrk0zfgDoi0gC0oMBWKW0JFm4wmLh30MqdxaXJXPNyTE9LFWW
 jFtDWwjy
 Dvx6u+OGsdFWGQZhgcd4hWALmcs01sblSO+bCcsLaF0pDT19CJACKMLt/Z4G0HklWJDLPkqDkmJbKye0PGoYlEdVaYRTpeD7qXubwdsEFFchaGW5hLtiwH2Y0uxb0Rnxj76Sdqxd7PyLW/RhQesVRbjqcFcuPFVNNEVoQeIJwJQfrsRxub3ViQxKEl/T4Rseg3BGHZP6PrDwhtGFPyh0sHmtYDR4BMUxCATovAp77gQy+NaE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

-cc old mail (this is going to take some time to propagate I realise :P)

On Fri, Mar 06, 2026 at 12:45:50PM -0800, Anthony Yznaga wrote:
> Mappings created with MAP_DROPPABLE cannot be locked via mlock() due
> to the check in mlock_fixup(). However, they will be locked indirectly
> if they are created after mlockall(MCL_FUTURE).

You need to add more details here.

For e.g.: 'in apply_mlockall_flags(), if the flags parameter has MCL_FUTURE set,
the current task's mm's default VMA flag field mm->def_flags has VM_LOCKED
applied to it. Therefore, in __mmap_complete(), extend the test for VM_SPECIAL
to include a test for VM_DROPPABLE'.

Do you have a test that can check for this? It'd be good to have a regression
test to assert that it now behaves correctly.

You could extend either tools/testing/selftests/mm/mlock2-tests.c or
droppable.c?

It's worth mentioning that mlockall(MCL_ONFAULT) is handled too, as
VM_LOCKONFAULT is always set with VM_LOCKED (the only difference being that,
when trying to fault in memory for VM_LOCKED ranges, gup exits early in
populate_vma_page_range() which has an explicit test for VM_LOCKONFAULT) , and
apply_mlockall_flags() will invoke mlock_fixup() which already has the
VM_DROPPABLE check.

>
> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")

Do we want to cc: stable here?

> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
> ---
>  include/linux/mm.h | 3 +++
>  mm/mlock.c         | 4 ++--
>  mm/vma.c           | 2 +-
>  3 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 5be3d8a8f806..bb830574d112 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -574,6 +574,9 @@ enum {
>  /* This mask represents all the VMA flag bits used by mlock */
>  #define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
>
> +/* This mask prevents VMAs from being mlock'd */
> +#define VM_NO_MLOCK_MASK	(VM_SPECIAL | VM_DROPPABLE)
> +

It'd be preferable to not use the legacy VMA flags implementation, but if we're
backporting I guess... However there's only one place you need to update, the
other already manually checks droppable, and it'd make my life easier for the
VMA flags conversions to not define a flag like this also :)

>  /* These flags can be updated atomically via VMA/mmap read lock. */
>  #define VM_ATOMIC_SET_ALLOWED VM_MAYBE_GUARD
>
> diff --git a/mm/mlock.c b/mm/mlock.c
> index 2f699c3497a5..fd35c1e88c4c 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -472,9 +472,9 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  	int ret = 0;
>  	vm_flags_t oldflags = vma->vm_flags;
>
> -	if (newflags == oldflags || (oldflags & VM_SPECIAL) ||
> +	if (newflags == oldflags || (oldflags & VM_NO_MLOCK_MASK) ||
>  	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm) ||
> -	    vma_is_dax(vma) || vma_is_secretmem(vma) || (oldflags & VM_DROPPABLE))
> +	    vma_is_dax(vma) || vma_is_secretmem(vma))

This obviously wouldn't be necessary without adding a new VM_xxx...

>  		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
>  		goto out;
>
> diff --git a/mm/vma.c b/mm/vma.c
> index be64f781a3aa..1334622e4a03 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2589,7 +2589,7 @@ static void __mmap_complete(struct mmap_state *map, struct vm_area_struct *vma)
>
>  	vm_stat_account(mm, vma->vm_flags, map->pglen);
>  	if (vm_flags & VM_LOCKED) {
> -		if ((vm_flags & VM_SPECIAL) || vma_is_dax(vma) ||
> +		if ((vm_flags & VM_NO_MLOCK_MASK) || vma_is_dax(vma) ||

For backport maybe just put an additional vm_flags & VM_DROPPABLE here?

>  					is_vm_hugetlb_page(vma) ||
>  					vma == get_gate_vma(mm))
>  			vm_flags_clear(vma, VM_LOCKED_MASK);
> --
> 2.47.3
>

Though I saw David suggested something different so that also addresses my review here :)

Cheers, Lorenzo

