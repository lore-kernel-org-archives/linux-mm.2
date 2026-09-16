Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B40DC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 13:41:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0482B6B00A1; Wed, 16 Sep 2026 09:41:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01F2C6B00A2; Wed, 16 Sep 2026 09:41:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E77426B00A3; Wed, 16 Sep 2026 09:41:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF9326B00A1
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:41:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 69C6980665
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:41:43 +0000 (UTC)
X-FDA: 85219738086.03.8BC5807
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B0C89140004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:41:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jlLD6yuF;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789566101;
	b=Ot73+rs4AOycw2ssFQQWHYnsjXCd5lD+7GOl+1XwYcuAiVXl37hIfjrWgS4ccLslQLsmBO
	+l/eFC21ytLVuC8HitPUjFBSJ7t4aAqCsxEkKrgwxT8qVGpL39CXSCc7UPsTCqaFoyAu4t
	v9g/u4XYidO1RCkpwW1/aJvgEX+PUP8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jlLD6yuF;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789566101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a6kjCxP9yBKoDCDGJpxropE2U03Q16iuU4HbhIBJf+A=;
	b=mvq12i4p6Xt4Y2Y/uIMgsU+8F2vJHrjNT8gbzLbLwwRO+wrowsutHK6FjpSfg6q1lMyxe4
	8/ymhoMVry1KqwdiOIiwDHt5mxKNX4F+be498Xs19Ktewb232fyTxllLVdS83Ca928kIYG
	GGJuncq6A4Ph5pcaoKIQKuctty67y18=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A9F3C41A21;
	Wed, 16 Sep 2026 13:41:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4001F000FF;
	Wed, 16 Sep 2026 13:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789566100;
	bh=a6kjCxP9yBKoDCDGJpxropE2U03Q16iuU4HbhIBJf+A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jlLD6yuFDosHEmd6JzFv/rPZm04Jd/L0IencJCYXxb65CisXMkNidUNhwaDOZsD5p
	 cM7KEQ8mbz1fxDWDQPDd02HLkioIVNmVIPX+9pme9NckO9RuD92oU52O33Y/0rLS5L
	 yp23VOHR8uJX3zOEqKf+Sst8wyQEgidw7WkMwhPW6M+bNXp8YU+/ztMXgqkpCIvvuv
	 +33wxUGO31GXBEGLK/j8nNTVK5CNaJsu61ffdl4mKBVty8Vv+K//kufvTaJ+E9+yfh
	 eFanxfBigamyNqn/1TCCvEiMOw4MINMe4k4fnxLc31nAxIeYFCX/Cb5czHSrTIsVzZ
	 hlJfasBj+UcZQ==
Date: Wed, 16 Sep 2026 14:41:34 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, 
	linux-arm-kernel@lists.infradead.org, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH V2 01/14] mm: Add read-write accessors for vm_page_prot
Message-ID: <aqqchzV9bgKYPPyn@gremlin>
References: <20260907035030.2839978-1-anshuman.khandual@arm.com>
 <20260907035030.2839978-2-anshuman.khandual@arm.com>
 <69a7987f-15fb-4793-81b6-cc436525224e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69a7987f-15fb-4793-81b6-cc436525224e@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B0C89140004
X-Rspam-User: 
X-Stat-Signature: 3boocgxbmtuadhcyc14id4dm474d9u5a
X-HE-Tag: 1789566101-977421
X-HE-Meta: U2FsdGVkX19OJW3YxkipNT2b/blLveageyXYKuVERVNvzYP1tO5a7wZ1R+V9aALuwkBzSxN/xIK3VNTkYNRBt0i5h1o8Sp853q3WitRO5YwWlB6g9v295k8z1lgy5FPD8V1hERViBRvq/xzmSqqfEv/gbeB6YCcwEAIXetZwuchHPCnTDYTM7kMaNcZ3J6zkwmeTqTL2W5udvwGA4AaMdAtGbIzfZzdc+kmCpM5yAbHK3OmIjff7udEoPtpLgCIbJBlicLRJbyP6Wg1j4SamzAea78ibT35jPEz5zc7l78X3DuPg1I7td4cPckL7koArHoAeXyQlP9A2FAEsvFZAWwomfFCQTBxI+1ECcxDIwjEe1iPLoOSvZRZhMvhG81xm1gzA12Ibsx7KNQzgDnxg+/lUpI1viBhsztDiIJHpBVnc4+5KJ2zRQuGA1MRU6TbpIcblAPwU4y7EOLcgboWKJUgfOqWjlFxmUnIMyhkY4k3HUCQ6zvOMejZ3Kb4xzrLvHFt9lltXASWK2KFhXsAgxeuqVM0K/htsMzw2VtIYeeD3yIYw2GTg7XUUW/2ayrdVVXcKTKJlG/VuqS5OtuKdJxWzDx4lbzRu260ENIHnnRZhmRzSNHFvrlDrBnTZ/KLmPPPVaqbygeMigeUKOOacK41Zdn1XBZPyb/E/ItJcf4QCoD8zD6I90e/1ODyh39pEBqW1o4Tbgd3IrQy+PFzjnPA+VfQNclTKirUGIVsB6iZ1Ber1ejUJHvnx19K9hpE/030dPBqwGjq/8vKQQvSfO9n8whS7ThDgNmTQwFu5xqAdYT7GQEAhtvJV+ePDauf6S65j59rRAJNArSP4b+QtnOSntLYq/YvTHWUNngDocyNLElHvC7O6gPfEJaJEEe9FZ9bkurfEawq44onpzCifZI3qq+b1tVY2nb9QMF830iVqV5N5qkOTsY1U/EhSFZC8EnbeCOFe/yRu/X2Ycxo
 MZt+h4IQ
 QSh/0+m/C1VjYQHz76APH89SvSyCq8052Jdo7cgrEu+ZaKPl+tVhoRZ4RAXWNVuq/xQ9wiEVbBlUe59C8eYCsnVeXN/XLDlrSGG8bKirS4L/dCV1uzjJThu+FJAtCIHg5c3OwkvbpgfLORQZ1wXk1hZEGFJhC7+Fzwbxgka4eLGe0T1eBx80J+EomXLGE6sus9I+PKLGOV/kLyYczxnVJ+5n8J8bO6fvUfALY5NXu8N1+ZhokoEGyEGK+sR4GZav9pkiThC5t0hGbm7hbv/BNOqyi/9g4aIw4SnRZ355peqA/2ZemKycvSqXor/cgaPM8Q3I3dqwK+lUGIeUfCxtr80ky8RRqUvLh17wE4ZVzWFNnfZLQJf32iQQq/aNb6DvFqmmVPKJEEIg5yqvzALOrtj2GVDVhh30q3mOnOwzV8nT44eQPqQF1y0P9f7nAbKxpv1ibsCUlJ92MAD2taqt6PLwduLy4BAovxBinTzhHTDVXOM0uDWqUNE4nBHVCYXfH5h/qDRUVP6u/pqUk/z/siJyq3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 03:23:13PM +0200, David Hildenbrand (Arm) wrote:
> On 9/7/26 05:50, Anshuman Khandual wrote:
> > Currently vma->vm_page_prot is safely read from and written to, without any
> > locks with READ_ONCE() and WRITE_ONCE(). But with introduction of D128 page
> > tables on arm64 platform, vm_page_prot grows to 128 bits which can't safely
> > be handled with READ_ONCE() and WRITE_ONCE().
> >
> > Add read and write accessors for vm_page_prot like pgprot_[read|write]()
> > which any platform can override when required, although still defaulting as
> > READ_ONCE() and WRITE_ONCE(), thus preserving the functionality for others.
> >
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Cc: Mike Rapoport <rppt@kernel.org>
> > Cc: linux-mm@kvack.org
> > Cc: linux-kernel@vger.kernel.org
> > Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > ---
> >  include/linux/pgtable.h | 14 ++++++++++++++
> >  mm/huge_memory.c        |  4 ++--
> >  mm/memory.c             |  2 +-
> >  mm/migrate.c            |  2 +-
> >  mm/mmap.c               |  2 +-
> >  5 files changed, 19 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> > index e3c8ab96941c..0df57a5c19ef 100644
> > --- a/include/linux/pgtable.h
> > +++ b/include/linux/pgtable.h
> > @@ -524,6 +524,20 @@ static inline pgd_t pgdp_get(pgd_t *pgdp)
> >  }
> >  #endif
> >
> > +#ifndef pgprot_read
> > +static inline pgprot_t pgprot_read(pgprot_t *prot)
>
> Try passing "const pgprot_t *prot" instead.
>
> [...]
>
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index 15b45832bcfa..579152cce502 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -387,7 +387,7 @@ static bool remove_migration_pte(struct folio *folio,
> >
> >  		folio_get(folio);
> >  		new = folio_page(folio, idx);
> > -		pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
> > +		pte = mk_pte(new, pgprot_read(&vma->vm_page_prot));
> I do wonder whether a
>
> ogprot_t vma_get_page_prot(const struct vm_area_struct *vma)
>
> where we hide the pgprot access would be a good complement for vma_set_page_prot().

Yes please! :)

>
> Just a thought.
>
>
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index 4bf26b0f1e6e..729bc244b317 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -89,7 +89,7 @@ void vma_set_page_prot(struct vm_area_struct *vma)
> >  		vm_page_prot = vma_pgprot_modify(vm_page_prot, vma_flags);
> >  	}
> >  	/* remove_protection_ptes reads vma->vm_page_prot without mmap_lock */
> > -	WRITE_ONCE(vma->vm_page_prot, vm_page_prot);
> > +	pgprot_write(&vma->vm_page_prot, vm_page_prot);
> >  }
> >
> >  /*
>
>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

