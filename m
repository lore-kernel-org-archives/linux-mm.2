Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C39FF417E3
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 14:31:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E6786B0093; Mon,  9 Mar 2026 10:31:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 690BB6B0095; Mon,  9 Mar 2026 10:31:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BDC66B0096; Mon,  9 Mar 2026 10:31:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4CDA96B0093
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 10:31:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E42EE160212
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:31:32 +0000 (UTC)
X-FDA: 84526762824.27.355FDDA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 345FF1C000E
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:31:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fD8z0n94;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773066691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kr/5ThKivQFdJzXEU9F7nnGTIkjnqSsxpz+D+a6mImI=;
	b=LY4ZRwVcjCXa5GZw9mx44XjKDSVEF72TcMzB7HCHPSeoITDOfplIMGKjTEaftB7PQ0qsf6
	pkugugwoqrQq/gLHkoB+/BWzr8TfUziUebVLwNvNO6c0nhgZK8hTNYjiQ8qrHK3WNTSIX2
	YR/DHn1FV7QLgvOf4wGYTfqffgeK3Sg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773066691; a=rsa-sha256;
	cv=none;
	b=uWw+L9x9YrOQmqLOfHLxhIsxv1hL8OinaX4NLUmMmWzbWo8DZQEENbxueTA6gzaupvGHov
	5f5DcxCVU7CSJmX94idcaY2LqKGCCv0EPDQmgq/hyBW+U//ed2TVTmHahVKrwOIGwuWFtK
	yIn4WWZl6IDh2/XkCcBfHuhySzYwoyA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fD8z0n94;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3281443B75;
	Mon,  9 Mar 2026 14:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79179C4CEF7;
	Mon,  9 Mar 2026 14:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773066690;
	bh=11S7fCwzp8bMaQluirI+BWvva5ZwY/s8Lezv4k9qpkk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fD8z0n94M31wKotXwnmb6/WQwChNvmqT2ZEZMBCPbXnMm2rtKAbS1lRU7dd2EiKUR
	 Kr7BU0P4LyKX3CVN7ng2qOZnD+yOUBGwUayE7Qwkz8RTlLxZE/DYjJCgQDHEibSVWH
	 fePyM4zxWCdmlTo/Wqy0W+VokKWvzuihShdr9U7y9oC3kLf+mPWoQpVJwy/aSOP39y
	 SevD9nqQn4BHUw3AancjMKMFpXYHMRyBTN7gTrM+0dZ8UOXBpC0IuKeWe8T7HwLlfl
	 +RQz8RqlYX/jVqo/EQyMHpuc09ab5DMZLHQ0jZv/GkY1wIg0qiJyMXAnlXAwOtXMk4
	 0aI3gVogMJi2w==
Date: Mon, 9 Mar 2026 14:31:27 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Anthony Yznaga <anthony.yznaga@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, jannh@google.com, pfalcato@suse.de, Jason@zx2c4.com
Subject: Re: [PATCH] mm: prevent droppable mappings from being locked
Message-ID: <2cd5fcf4-9094-486c-b74d-e2db77c4fc00@lucifer.local>
References: <20260306204550.8405-1-anthony.yznaga@oracle.com>
 <7c1db5ef-2457-46ff-ab20-dd4090570fb6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c1db5ef-2457-46ff-ab20-dd4090570fb6@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 345FF1C000E
X-Stat-Signature: qzo5rjp7wwcywqt1rrdjxt5ro7hy9cn5
X-Rspam-User: 
X-HE-Tag: 1773066691-740817
X-HE-Meta: U2FsdGVkX1/i47TJOqbPYAzDJmdxFCGno/76zCrxtBWRGnqV8VRJytsL3EO8INSH1/R3sN+1YiavR4VQhjADqM2n25nosZsT+Id8z87UY7Icqj/3i08vFhmVe0PNB5zDKB/LYqYtE0p0oI3WB+5uaxkD/fGDJG36W37rO5B9xKrG8158H/8klSVikm1ZnqLT8JEBAJVEAv5oXCbd1GCaiuHvTAgFZ+CsNflpCFcUCRpkDaX3STWN4hkA5l1o08oEkb104GOp30sJ9X2xVB/jszeCrQBxqE0CXbfAGD1zJXcvLM4k0GOqPAyPXZMZUFqV1/f4wmyD98Sk2RD5orFHHe7OJv5Jk5UxcOVjUje3OZXICyi5GY3E9IxbaW2uFX+bGDfDTEg+IQKbvhqW7BBhv+7Gao0NkXKle2HTxryI5SPgX94n0phVUk3JfhodzI8eXmIvbOpLS5f2cOomWpqhjKU2C6mU63zg2txVUOML4003JkoXF88IRoWAbP58TO9xN7sIQoBCpwqKSYMYZOeWHq4HYsMuENZ/sRJD73kJVFFq5eahccVpp0vH6VJhPFX7MUY6hudRIW+xeyGfOTLbd02fmHTnxEss9GpV/gdrS4wozebZr3uO8/mLFJua6CCf+fXtUCZUfIEF4EPdFLP1OSgYNam606or/0nnt+HenuRWIJF3cWyi4S9vrGh3IqUDGjViRjhDopVqu73m6ACl1hzbEmVL91DupiroENvJEsBrBCWInhlN09EujDOUUqE11OLuLbMPA49TITOhfmFOiJ/WnL5HZ+Gh0EvOvP7DJUeLLFiTt28gbJOMf2DXuAVvR3Y9LzQQcOHmF+7nI0FTOu6ORYUiHJgtHJtb1AYRuyIjnTv7rRc3ugb+qsFKbxDw21ZRXpXC8yGszsMOMT7hWwNLgSCb9NNRSGu/xjrV+Yd0kh10B33/l3gbFwFUKgo/bZ/dOodjWBSz7YEHfPi
 DXqX+opc
 rlp0Aouorw+hY9Dm+TW4HPccm9Tzcy4Kp7wMZE7jHfgAZC0RRqHlsY5cLhGrX5Ur2C9PTizVguHwbhtPlNUhCmndVheeYd34LkY5IrKiYM4TWbscsM5pmZ12X+qcFmB25yLTRJSxVtg52rmrQKZuM+77DdVNjSjqF7UISiRQJAMmEl3rLGUpHz+fgsV2gRQjw3aEkGe95TSG4tZlqgMjlKS4crMxWfEvnsfP0h8JAHg3Tje8YRicSPKzs6Vi5P/IOvawaQfuR77zYAhs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 03:15:24PM +0100, David Hildenbrand (Arm) wrote:
> On 3/6/26 21:45, Anthony Yznaga wrote:
> > Mappings created with MAP_DROPPABLE cannot be locked via mlock() due
> > to the check in mlock_fixup(). However, they will be locked indirectly
> > if they are created after mlockall(MCL_FUTURE).
> >
> > Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
> > Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
> > ---
> >  include/linux/mm.h | 3 +++
> >  mm/mlock.c         | 4 ++--
> >  mm/vma.c           | 2 +-
> >  3 files changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 5be3d8a8f806..bb830574d112 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -574,6 +574,9 @@ enum {
> >  /* This mask represents all the VMA flag bits used by mlock */
> >  #define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
> >
> > +/* This mask prevents VMAs from being mlock'd */
> > +#define VM_NO_MLOCK_MASK	(VM_SPECIAL | VM_DROPPABLE)
>
> Instead of adding that, could we cleanup further by doing something like the following?
>
> The usage of "vma->vm_mm" must be double checked, and we'll have to take care of making
> the tools/testing/vma test happy.

Yeah Anthony - please do a simple:

$ cd tools/testing/vma
$ make && ./vma

To make sure that your changes don't introduce anything that breaks that.

If you need to add duplicate header defines put them in
tools/testing/vma/include/dup.h, if you need to stub stuff out put in stubs.h
and if you need to customise something for testing purposes, put it in custom.h.

>
> Not even compile tested, so will require some more work.
>
>
> diff --git a/include/linux/hugetlb_inline.h b/include/linux/hugetlb_inline.h
> index 593f5d4e108b..755281fab23d 100644
> --- a/include/linux/hugetlb_inline.h
> +++ b/include/linux/hugetlb_inline.h
> @@ -30,7 +30,7 @@ static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
>
>  #endif
>
> -static inline bool is_vm_hugetlb_page(struct vm_area_struct *vma)
> +static inline bool is_vm_hugetlb_page(const struct vm_area_struct *vma)
>  {
>  	return is_vm_hugetlb_flags(vma->vm_flags);
>  }
> diff --git a/mm/internal.h b/mm/internal.h
> index 6e1162e13289..b70ebbdafe00 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1242,6 +1242,15 @@ static inline struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf,
>  	}
>  	return fpin;
>  }
> +
> +static inline bool vma_supports_mlock(const struct vm_area_struct *vma)
> +{
> +	if (vma->vm_flags & (VM_SPECIAL | VM_DROPPABLE))
> +		return false;
> +	if (vma_is_dax(vma) || is_vm_hugetlb_page(vma))
> +		return false;
> +	return vma != get_gate_vma(vma->vm_mm);
> +}

Yeah this is nice.

>  #else /* !CONFIG_MMU */
>  static inline void unmap_mapping_folio(struct folio *folio) { }
>  static inline void mlock_new_folio(struct folio *folio) { }
> diff --git a/mm/mlock.c b/mm/mlock.c
> index 1a92d16f3684..e16b2ea234f7 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -472,9 +472,7 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  	int ret = 0;
>  	vm_flags_t oldflags = vma->vm_flags;
>
> -	if (newflags == oldflags || (oldflags & VM_SPECIAL) ||
> -	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm) ||
> -	    vma_is_dax(vma) || vma_is_secretmem(vma) || (oldflags & VM_DROPPABLE))
> +	if (newflags == oldflags || !vma_supports_mlock(vma))
>  		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
>  		goto out;
>
> diff --git a/mm/vma.c b/mm/vma.c
> index e95fd5a5fe5c..b7055c264b5d 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2589,9 +2589,7 @@ static void __mmap_complete(struct mmap_state *map, struct vm_area_struct *vma)
>
>  	vm_stat_account(mm, vma->vm_flags, map->pglen);
>  	if (vm_flags & VM_LOCKED) {
> -		if ((vm_flags & VM_SPECIAL) || vma_is_dax(vma) ||
> -					is_vm_hugetlb_page(vma) ||
> -					vma == get_gate_vma(mm))
> +		if (!vma_supports_mlock(vma))
>  			vm_flags_clear(vma, VM_LOCKED_MASK);
>  		else
>  			mm->locked_vm += map->pglen;

Very much preferable!

> --
> 2.43.0
>
> --
> Cheers,
>
> David

Cheers, Lorenzo

