Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 479DE10FC465
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 02:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A3096B0005; Wed,  8 Apr 2026 22:51:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22BEE6B0088; Wed,  8 Apr 2026 22:51:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 142236B008A; Wed,  8 Apr 2026 22:51:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 031236B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 22:51:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7EC93C1905
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 02:51:16 +0000 (UTC)
X-FDA: 84637490952.09.C3B6F2D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id BA250A0011
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 02:51:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=deUUMGAv;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775703074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rUhrmwHkBSqKrdYo6tw1hXwIm9BpheixKzYdy7cIPjQ=;
	b=2jns6tkcgTWfm8bIVZ3/0SoYMaEJ7SsQ8eUrl6Gs/3UAVc7H3fbzU/qgeY6V5HC6e1oTnM
	z/IC0LgBhn0rPkj+ukx99Z+xffZYcueRlsXokX8o6bFV7+9DwW9W8GuapWx2GUYLucQB7E
	2KdLkuhtj63FWkGMMHw+w2hudVhkDwc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=deUUMGAv;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775703074; a=rsa-sha256;
	cv=none;
	b=7pEBKnmONyGTFm7ablJjkfEDGXrFqMM+LsJTG8j/oHfWGvkNehKDUHMGdQ8wT1f5uMkDZR
	gchkFDrKrJjlBHyKZOvW7Y0bkAD1ATYf9nz9/H2C/24RIuuNr57MlMmfJwcxHQNfjLQSE0
	dAvigoZ6Hw7wAywIZG2r267MnOWMPeo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B4FFF43BEC;
	Thu,  9 Apr 2026 02:51:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2024C2BC9E;
	Thu,  9 Apr 2026 02:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775703073;
	bh=pb4X9hM5ZH85eVRwGPqpDeJTNycAfQb6SOBqEFeQrp0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=deUUMGAvKvkM3fUmHPRPbOH6ZJijZNulPZc1F7z2KcYxRxBw5VGezZ16h9X2E7Agd
	 Y2dx6IUIy5wn0L+z629ro6P7co/O9zEeC4E/EvBZsIXp+xVaIi+HElzyCiYRB+MSbR
	 wzGxaWsu0XlDs0IbhEwXZDfqw3nA3X4j7/AUJRo9LtPDAsQ8p4mGTP1Olt7Cy5F0dN
	 k+TduRW6aBiIl2Bbwedrkmgo+ygxIERs7FxilUjXPaDcYfMC4ytGe9ZZ943JsdAHNC
	 5aMGaadR8VUSsYzZwhbExZ5gBxnHxvNYREI+Rgtbb3Z7i/ALXlK++B10IxcWod0Lb2
	 /LZp0OShknESQ==
Date: Thu, 9 Apr 2026 11:51:11 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: "Denis M. Karpov" <komlomal@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, rppt@kernel.org,
	akpm@linux-foundation.org, Liam.Howlett@oracle.com, ljs@kernel.org,
	vbabka@kernel.org, jannh@google.com, peterx@redhat.com,
	pfalcato@suse.de, brauner@kernel.org, viro@zeniv.linux.org.uk,
	jack@suse.cz, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] userfaultfd: allow registration of ranges below
 mmap_min_addr
Message-ID: <adcUHx27oZLftSjS@hyeyoo>
References: <20260407081442.6256-1-komlomal@gmail.com>
 <adXJop1d0QdH2Mwm@hyeyoo>
 <CADtiZd3AcY2LwPfCkb782TaY1h50dTPpEzhfLSyMeQeXG6VXfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADtiZd3AcY2LwPfCkb782TaY1h50dTPpEzhfLSyMeQeXG6VXfA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: BA250A0011
X-Stat-Signature: fpu4j4fn7cojt1f1qk4wgpzhds47kif8
X-Rspamd-Server: rspam06
X-HE-Tag: 1775703074-672429
X-HE-Meta: U2FsdGVkX1/7HpHDP/kci4wTxLZAkabw2nNV6L/mY3Ayh4spTlYWnUivJ59dW3AGk2+9hsA9VNrxDxRcTsM6L3tJfG/IvB8tsOHfxfnWb0nVnbAfGUld5X5EAHCDnmmitz3j5yHsNTSU6/GFBuyUxF4b7M6j0k8IGTR/KqQbv3t4BPlUao4JW0CSOaJh3mPWZ7vphTGO8n8Iikt64hB66GTxtlPac2RM1SZKVnRRCJ+MYRcT18WgUy5EU/F98vlULE8sdwQ9Xz8rSnESVoQohlNn5SPRbOFXkSslr44ZRdkov+yGgHydxEW77R5tjLoFMrJx6KRnHQ0y63rzVl36yDn5AzUn4DlAQOev10hed08WY1rASf7T7z4EXGsTId9i9htvWTVgqki4OvT4jJv9Z9ufTcpV+2863OBEDNGu53NTvTo9uvV4sDgchCLNz/N2TXOz+0W0Z7Hjxd4gfQ1yvlg/Ud2kin1KIxJuMfaWh92S9sJLEPbVMttlDntcONQmFZEDT7z6YedjHBKvRrw65GiHzXaTEhB321G6GtwyeUGvXBu2NtdEjMoDvz+7HII4NgKplsiBL6ovJvxMiwDRBPMiQrk1xfydwdzRi0UNFc5gwkhmoYxBUaYMi+ddTC/0HqMtDNsdJPtqwQTU4ZC9ZRZEoUI8F8gLF1B/GwY72uASauVVH5an+v37DMrkPVPf68Se2P6pGkdJlsuS84DNiTGz7kXaQWUCr7HZm8fMVIleTafiUYR1wyVu7PRDj3laAk4u+cDUoNPEsB20RjWaGqaKWqPta7jsGHcHSVIemAOLCSMLzzixgb7627upAzvYTD8WTiQ9dy4ov7B0vEEA3iFgFwHa/K48bFbHE9gNhHV4aWk0rQZGYB6lwZww13NH+1vgsWBaSYv/BLSnAphwqpV0xiGgwhYbP6H2E725pvT4cYLySiSPT8fvgWENC4hYTjKFZ88FDDIUHQ34Cx1
 qjk3Dly5
 6HZJ1nfL0uSoGGM2iErvx3I9FUaXIa7t6LXh/jX5YlL7I7faZIF6Ple8tnqx6WSVTwi3gopCdQABDQ3o3unOdK2YtVrBskW99eHZEUZ+cFvUtkfMvReePZjdcwaQMYdEYHHus3tWzJEDL3o9LBVVJNs8dqSKbWqwLiywZHR0LMlJqUg7b96/IorAd24Do9ETcf8DtyzFpbhYF1+dpdWojyeB6e9uVv5TMkdfssYyxP6d/f4DuQ3FDVEKn+fXrLjLg9rq3tj7E3VEvVnEyjYfmWXtW+54YpceJva1qQPLl1V1um//DlH/J1WH8nrT8j/VLHwY1jCgzCGg2JaM7yOjuqCVOfphGXEw7vJmrJYHZfPULBCVA4Gi9GXjx9XkzqWdqZGrbKx0W+qWhGeVeagPkzW3V+FGBMJ9mU8t8RihqbsR5NQ76nOOedsMj8h9prCLxx50qlV8+gwAOdNfSypOVe+h2CoJuiMg4/Xe1YzsfBqFvUdY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 11:09:00AM +0300, Denis M. Karpov wrote:
> > Hmm but it looks bit strange to check capability for address that is
> > already mapped by mmap(). Why is this required?
>
> Actually, it's not obvious to me either, but I may miss something.
> My intent was to replace the current restrictive check with a more flexible one.

Technically, it's less restrictive only if start < mmap_min_addr
(setting aside the discussion of whether this is an appropriate check).

Otherwise (start >= mmap_min_addr) it's more restrictive? (now, the process
should have the capability when registering an existing VMA to userfaultfd)

> I think performing this check here allows us to deny invalid requests early,
> before locks or VMA lookups occur.

But we're not trying to optimize it and we shouldn't add checks without
a proper explanation for the sake of optimization.

> Removing this check entirely would also allow using UFFD in cases where a task
> drops privileges after the initial mmap(). This seems reasonable because the
> VMA already exists, i.e. kernel already allowed this mapping.

Yeah, that seems reasonable to me.

IOW, I don't think "creating a VMA on a specific address (w/ proper
capabilities) is okay but once it is registered to userfaultfd,
it becomes a security hole" is a valid argument.

And we don't unmap those mappings when the process loses the capability
to map them anyway.

> In the [BUG] thread discussion

Was it a private discussion? I can't find Andrea's emails on the thread.

> Andrea Arcangeli also suggested adding a check for
> FIRST_USER_ADDRESS to handle architectural constraints.

Again, what's the point of checking this on the VMA that is already created?
*checks why FIRST_USER_ADDRESS was introduced*

commit e2cdef8c847b480529b7e26991926aab4be008e6
Author: Hugh Dickins <hugh@veritas.com>
Date:   Tue Apr 19 13:29:19 2005 -0700

    [PATCH] freepgt: free_pgtables from FIRST_USER_ADDRESS

    The patches to free_pgtables by vma left problems on any architectures which
    leave some user address page table entries unencapsulated by vma.  Andi has
    fixed the 32-bit vDSO on x86_64 to use a vma.  Now fix arm (and arm26), whose
    first PAGE_SIZE is reserved (perhaps) for machine vectors.

    Our calls to free_pgtables must not touch that area, and exit_mmap's
    BUG_ON(nr_ptes) must allow that arm's get_pgd_slow may (or may not) have
    allocated an extra page table, which its free_pgd_slow would free later.

    FIRST_USER_PGD_NR has misled me and others: until all the arches define
    FIRST_USER_ADDRESS instead, a hack in mmap.c to derive one from t'other.  This
    patch fixes the bugs, the remaining patches just clean it up.

    Signed-off-by: Hugh Dickins <hugh@veritas.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

Oh, ok. there might be a raw mapping without VMA below FIRST_USER_ADDRESS.

Adding such a check wouldn't hurt... but if there is no VMA, you can't
register the range to userfaultfd anyway?

> Andrea, could you please comment on this? Specifically, would a
> check against FIRST_USER_ADDRESS sufficient here, or do we still
> need to check caps?
> 
> On Wed, Apr 8, 2026 at 6:21 AM Harry Yoo (Oracle) <harry@kernel.org> wrote:
> >
> > On Tue, Apr 07, 2026 at 11:14:42AM +0300, Denis M. Karpov wrote:
> > > The current implementation of validate_range() in fs/userfaultfd.c
> > > performs a hard check against mmap_min_addr without considering
> > > capabilities, but the mmap() syscall uses security_mmap_addr()
> > > which allows privileged processes (with CAP_SYS_RAWIO) to map below
> > > mmap_min_addr. Furthermore, security_mmap_addr()->cap_mmap_addr() uses
> > > dac_mmap_min_addr variable which can be changed with
> > > /proc/sys/vm/mmap_min_addr.
> > >
> > > Because userfaultfd uses a different check, UFFDIO_REGISTER may fail
> > > with -EINVAL for valid memory areas that were successfully mapped
> > > below mmap_min_addr even with appropriate capabilities.
> > >
> > > This prevents apps like binary compilers from using UFFD for valid memory
> > > regions mapped by application.
> > >
> > > Replace the rigid mmap_min_addr check with security_mmap_addr() to align
> > > userfaultfd with the standard kernel memory mapping security policy.
> >
> > Perhaps worth adding
> >
> > Fixes: 86039bd3b4e6 ("userfaultfd: add new syscall to provide memory externalization")
> >
> > > Signed-off-by: Denis M. Karpov <komlomal@gmail.com>
> > >
> > > ---
> > >  fs/userfaultfd.c | 4 +---
> > >  1 file changed, 1 insertion(+), 3 deletions(-)
> > >
> > > diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> > > index bdc84e521..dbfe5b2a0 100644
> > > --- a/fs/userfaultfd.c
> > > +++ b/fs/userfaultfd.c
> > > @@ -1238,15 +1238,13 @@ static __always_inline int validate_unaligned_range(
> > >               return -EINVAL;
> > >       if (!len)
> > >               return -EINVAL;
> > > -     if (start < mmap_min_addr)
> > > -             return -EINVAL;
> > >       if (start >= task_size)
> > >               return -EINVAL;
> > >       if (len > task_size - start)
> > >               return -EINVAL;
> > >       if (start + len <= start)
> > >               return -EINVAL;
> > > -     return 0;
> > > +     return security_mmap_addr(start);
> >
> > Hmm but it looks bit strange to check capability for address that is
> > already mapped by mmap(). Why is this required?

-- 
Cheers,
Harry / Hyeonggon

