Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88412C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 21:28:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 693BE6B0095; Fri, 28 Aug 2026 17:28:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61D3B6B0096; Fri, 28 Aug 2026 17:28:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BE3A6B0098; Fri, 28 Aug 2026 17:28:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1AAA96B0095
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 17:28:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8C3BF120589
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 21:28:50 +0000 (UTC)
X-FDA: 85151968020.28.00545C7
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id 90BD6180006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 21:28:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="A/G3zIo3";
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787952528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XfoQYkUJ1a6ofEv+Dfeo9L9CV4SCZkh3Gjp5xqgjsQE=;
	b=Enmm4dB/0oIyCv4xtuWi4SE7nj7mFeGfFEBG4dTIShGnO9oMCkcW6sWejky+xsSFtQ5y+b
	VgvxKupjSOKzhWtnBjQOno+SxyJzC6dp6ThEII4xL1pfZXeRgQra+7hV852HgBHcYT1tru
	VdbEPSgUvi6FAncXcnnERldYll4N0Zo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787952528;
	b=eLTj6Ux/sqhw2lGFgyoNbgdSMJ1TAxBoXAJ5JoF2R+W8jNjt6YcDJYi8mPPSbP0E7wMdBS
	TGD0j4pQfqLwJjIs9Pfy05i7ZZ7ejQJ/t1Uw/5FZn2ThL0Wd8KpcIZfMTOUaSvtwLP2/bh
	U/g39/3I0euCDd5ZIAFJKe3MR9zIe58=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="A/G3zIo3";
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-52fac937235so29501cf.1
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:28:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787952528; cv=none;
        d=google.com; s=arc-20260327;
        b=b8rDP4rpZkww+GUbBGxR/psIwVaNj1JElpQU9EKYCvM+cMkGGrjqNoyDpObXGlt2t9
         s8bCwAd6qBcNFvXGCKBhuVc+xjtJSWNIWcYgiUGuNSBV1kmcYzi89AInWZpb3FGw1M39
         It8xCBJO7h5trT5FbklfbSn+APy4NFeqMx299KUM9DOEDzpbqHmKxIQfjkGVMn4vCyJi
         XzNeJ2aG26qW9j3vmKgVjDFEAKHp/qTr9Lmom7wNBOlcQvMRKQMMLn/1ce+MMBePS4ir
         irEX4/XIxk6Xv4SPe7NHWcF1gylZQRzZFjpJ8G4wpM+HVcik4eXEBXgYKcUlsT7xf4VY
         vlkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XfoQYkUJ1a6ofEv+Dfeo9L9CV4SCZkh3Gjp5xqgjsQE=;
        fh=eK0MVzWoVrUsjt+iI7rwdcAoVFUKQxD3hWtAaT+/ElI=;
        b=r2nVyZncY/ppgGF+SvPckA1/kpYof81HPNmwC79M0pUp0lKRYgH4jhsODLUbXxpWRg
         ydqixc8kPuv7o+a38hSeSCLA34vTgeKHboEgEDhQQKwDOYmf2FAIHmTN3KuTG3nby42K
         D2N27LTFQYFh+UQrR8d4G1SpxQdNabBRBS5KJVe029wNNFo44Q4FNJ20AfKsN2kXUvPS
         t38+5WzKbHvFXIftI4InDEYu8MgzUtK/G6M6QDqrguT+1HHN4OlfXWop2GMcOMUFF6Ob
         0FMNeIDWUxheYV/8ybhiyqEIZfhOFUVzzQLCneFUeqpu1QZDZ5HkHoulzqGqRa2aDh9H
         0F1A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787952528; x=1788557328; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XfoQYkUJ1a6ofEv+Dfeo9L9CV4SCZkh3Gjp5xqgjsQE=;
        b=A/G3zIo3ZED5dr/mBwaX7SaHsJWoLz3zeuS+MuOFZqsgIqBZHg/SMBuUzKnqPSB2te
         AiZ4mQ6/w9G8zEVTElT8h7fiBXm98cgPRJBpZNo9GwfikOoTUp0ujBZIiOS9U6ufk6+H
         HTTqVPOb+zjYrZYozUgZTAxb8eaP1ybEUP9zZMva16jbdIRq9paHV9BkQl/OpwbfVHj5
         RSItZ1JdBOP9lQt3VkCSQdpPGZkL/prOKCwZS+cxkLqYm8bh342a+T6aljmZRYPrB+sf
         tsajx1aQKEyVrbZQdIpJTuS3QhCqJzfmaao6bNPuMuUZ8hqNLevqyjwkzCVPJ6reHPRm
         Q+UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787952528; x=1788557328;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XfoQYkUJ1a6ofEv+Dfeo9L9CV4SCZkh3Gjp5xqgjsQE=;
        b=d0YLOVM1HWezj1WJuyw0du9AvtvPg+riK0n8/ntpOOM0VS2Dtgt3f4rEh/pJ9JrZ1N
         NPBn7G1BXqsuAQIAq0W1rEvsSFv//XGVm51MQLU0vu7UFfJa44KXckJhuGkk56K23Ttr
         vM7/wjcdX+obgDyfpUSHeziE6Yi4o3ZHvo8dDhA2Lcns7y5mpYxDUH+g6TVwRoZg6imL
         2pOo4qUvTJH0HuRQquQEOFKUA8H611qzj49Djxq7WpA6ZE096b8d1aHbNkd5xHM9z43G
         3VV3wEfUsuFMe4en+qIKe5bVsFgvNdIpO+Nx5MFvdFhGcmXZRcL2lEhh8EXOKa9PhQNg
         QYxg==
X-Forwarded-Encrypted: i=1; AHgh+Rql0xVy9nBhz3GNSKoGQoon/4HxNlhj5VJV8CTESXi6cg0Z4UyFD5lmo0pkHnhGu4Ia0dNb5b/mUA==@kvack.org
X-Gm-Message-State: AFuF++kUKQaQfvRVoZ6mRa+UvrR0qV8ihl/UvMzhCYjn+50p8sx0vTT6
	EBZo1fJV15NHWpQDtXk8reqlE0h9WEzgct91W2XENLzGRjyl2S24HxqXkMmI47IZoeczv7AyOPB
	rtb+3snjU5vqvj+x/yXJrAXRrma9sb5v973d0BgTs
X-Gm-Gg: AR+sD11jF3vt2bTsNUU6qqmGh3B93q3lCxO+YhDXhWnLZeAGxi+V7c5mFhx4bXpq533
	DJvbrL8bHLMjDS8or0Jj7ZJ6Yy0tbe9dGYALBqW63MZKqinuHn8rcDdCp9rseJB73Z/pBOB9Oc/
	IZMhI0ko1jcVjMxb5Dm0P9Aq8J6G/anK7OPPn7n1bjsCSrRB/oQ18GObFPHDmtLrGmM4rdfDG7+
	XKPN3lUA2VVL7Ptg9zI8wHxleg07gLlL0Hc08kiqeras2p/2+YBqaZYidUsSHdVqoaJB8Z1Mgze
	mCccDVr/INkxMdimxfc2IS+so9UYQl6y1ezyNNic1hA=
X-Received: by 2002:ac8:5fca:0:b0:517:64f6:3365 with SMTP id
 d75a77b69052e-52ff6f30a08mr4370101cf.4.1787952526545; Fri, 28 Aug 2026
 14:28:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260811025157.1632867-1-riel@surriel.com> <20260811025157.1632867-3-riel@surriel.com>
In-Reply-To: <20260811025157.1632867-3-riel@surriel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 28 Aug 2026 14:28:35 -0700
X-Gm-Features: AcwNN1X4MPS_sh7yGpNGpmSP2XBjw5e48badqaCge6FOPk40r-Ic2qiRSDUVs8o
Message-ID: <CAJuCfpG1bT90rZVZpG6TRD4bo4howpBbQg4tuPfvfinRgNNFZQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/8] mm/gup: convert follow_page_mask() to return a long
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 90BD6180006
X-Stat-Signature: 3jh9hgioa5icsexd7hoki1bp18hix5fx
X-Rspam-User: 
X-HE-Tag: 1787952528-629114
X-HE-Meta: U2FsdGVkX1+fdoWD9Jj5B8aq7pgMWgXUV3vyya/OST822m7bz7vzW96ou+E9oSgGQRecJC31rnfHWDOft50wv4bhezfuYY29embdJRFm+Y1eLSMtMnI7YGMXU/f0mKftc2IV6rJUeUFMoe/3uhyc9QR+eCIZRuMna8xVIX7Tryzia5RXiqLSZCUKn3SgRrvYA9V4zPlz0rn7bv9WNCqvV65YR5WK5SlICGdJpc39qnPrQR7Qw4lHyIzVWYp7wr2O6bkGY8CqIkLNajlicyY3Z3EWWnIZcDrytPgjhxzMTyV+ovPAqakycKQAaNri/Qe8Avjase9JkEsfQIhTkNTrjsFjg9qSTwb5JFd+Da6ySfeqU8YIEKHmbrQ2wHHWnsBvXdvNmN0mZbwwaavwB9++dgrD+nX/G9Udu0vv3IEZQWUWUhFLP8hS0GCKh+chSa3QIes67zfLAgeodZgvIgy83W+R0eNQFhWojP5ymtZhRmOYJE+iMwXVk8OyR9ASHqH6UfZMuiuNrtVpHhDi5urFq8pQWSr/gD9+WPXRYawFj8UeRkY6pBosPGrC0OpyPgZPAYMyDFdEQVgzLWDaQU53r44YbnmxhDLJigB+MpvrTah9YNUzl5875cvpYwY6cS2BV5An1JjrClJWNoT2uPvqGwa5RTKGTL9j27hQgzBujjyBIwG+MS+z8MWTcDb3YRo1eJmiSsnvHTnj/zCsSTnZx8svYb5R2hy+fp9xc1s4X06xT1V58aD/YwYvbIn3AH6/mNguvUF1Zu+2qw4zzy9iPhQsg01sFdIKXnh27e6ouS394GURuVtFqkraT4yCmZJ8T+lIWy+Q36wp3rrNQBfSN+DPiwWdVghruKrYavLzaupCS8i2zdifh6xrlD6sYq90jqII5yd0HZdKvQnXrPqkXprXi7l7MHd+gwn3mtsmMs9qZISlxAks544ML7R+hSdls1i+PyyX1qAkVj7mOUB
 ibdC7EF9
 8iEHdCkoUtjNhSbhqnklGVMNg9F2tNQDk0RPbVyZmh20zmHJo+FTFZQqvM83QJ5XBfk/IIdBEjJQCeWwRNrvXjGd8s2CV9UdlDayZzCCC1WDEvfe/jLJqnylTAgbOSfRHTASfPr3FMyph7Ic8GsUOiPoMVHY04g127VPbNhcsSZqiaF5zqLs6j6QHjGFtvMRJw/DXRnXHr26ndQlLBZAM3hVf7mHD2GB9skOHxVWJHaN76KDWWzr0zZbyzN9zYQFqsqT0zkzdHS2fVCQhB0u9o/eROjwpDtNyhu633ozmRe1/Iut8qx3/KNmSy5IoJrrSfmnQQT0iMt6DOlSnUr1YjRhvPuQD78Y/0QpOzysoZ/9pWJuzS6cSZcvBT/NV6i2M4cVjqYlEFqYQQYY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 7:53=E2=80=AFPM Rik van Riel <riel@surriel.com> wro=
te:
>
> follow_page_mask() and its helpers return a struct page pointer: NULL,
> ERR_PTR(), or the page found. Change the return type to long instead:
> 0, a negative errno, or 1 with the page stored in a new pages[0] slot.
>
> This lets the return value carry a page count rather than a single
> struct page pointer.
>
> follow_huge_pud(), follow_huge_pmd() and follow_page_pte() now fill
> their slot with gup_fill_pages(); __get_user_pages() reads pages[i]
> back to still expand a large folio's remaining subpages itself.

nit: the above __get_user_pages() explanation is a bit confusing to
me. Is there really a change in that part?

> The
> vsyscall gate area, which bypasses follow_page_mask(), fills its own
> slot the same way.
>
> *page_mask and __get_user_pages()'s handling of a large folio's
> remaining subpages are untouched, and mm/gup_test.c
> (PIN_LONGTERM_BENCHMARK) shows no measurable difference for 4 kB,
> 64 kB mTHP, or 2 MB THP.
>
> No functional changes intended.
>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Rik van Riel <riel@surriel.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>



> ---
>  mm/gup.c | 254 +++++++++++++++++++++++++++++--------------------------
>  1 file changed, 134 insertions(+), 120 deletions(-)
>
> diff --git a/mm/gup.c b/mm/gup.c
> index 7bb40be89529..e4e6d0993424 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -608,15 +608,15 @@ static inline bool can_follow_write_common(struct p=
age *page,
>         return page && PageAnon(page) && PageAnonExclusive(page);
>  }
>
> -static struct page *no_page_table(struct vm_area_struct *vma,
> -                                 unsigned int flags, unsigned long addre=
ss)
> +static long no_page_table(struct vm_area_struct *vma,
> +               unsigned int flags, unsigned long address)
>  {
>         if (!(flags & FOLL_DUMP))
> -               return NULL;
> +               return 0;
>
>         /*
>          * When core dumping, we don't want to allocate unnecessary pages=
 or
> -        * page tables.  Return error instead of NULL to skip handle_mm_f=
ault,
> +        * page tables.  Return error instead of 0 to skip handle_mm_faul=
t,
>          * then get_dump_page() will return NULL to leave a hole in the d=
ump.
>          * But we can only make this optimization where a hole would sure=
ly
>          * be zero-filled if handle_mm_fault() actually did handle it.
> @@ -625,12 +625,12 @@ static struct page *no_page_table(struct vm_area_st=
ruct *vma,
>                 struct hstate *h =3D hstate_vma(vma);
>
>                 if (!hugetlbfs_pagecache_present(h, vma, address))
> -                       return ERR_PTR(-EFAULT);
> +                       return -EFAULT;
>         } else if ((vma_is_anonymous(vma) || !vma->vm_ops->fault)) {
> -               return ERR_PTR(-EFAULT);
> +               return -EFAULT;
>         }
>
> -       return NULL;
> +       return 0;
>  }
>
>  static void gup_fill_pages(struct vm_area_struct *vma, unsigned long add=
ress,
> @@ -663,9 +663,10 @@ static inline bool can_follow_write_pud(pud_t pud, s=
truct page *page,
>         return can_follow_write_common(page, vma, flags);
>  }
>
> -static struct page *follow_huge_pud(struct vm_area_struct *vma,
> -                                   unsigned long addr, pud_t *pudp,
> -                                   int flags, unsigned long *page_mask)
> +static long follow_huge_pud(struct vm_area_struct *vma,
> +               unsigned long addr, pud_t *pudp,
> +               unsigned int flags, unsigned long *page_mask,
> +               struct page **pages)
>  {
>         struct mm_struct *mm =3D vma->vm_mm;
>         struct page *page;
> @@ -676,25 +677,27 @@ static struct page *follow_huge_pud(struct vm_area_=
struct *vma,
>         assert_spin_locked(pud_lockptr(mm, pudp));
>
>         if (!pud_present(pud))
> -               return NULL;
> +               return 0;
>
>         if ((flags & FOLL_WRITE) &&
>             !can_follow_write_pud(pud, pfn_to_page(pfn), vma, flags))
> -               return NULL;
> +               return 0;
>
>         pfn +=3D (addr & ~PUD_MASK) >> PAGE_SHIFT;
>         page =3D pfn_to_page(pfn);
>
>         if (!pud_write(pud) && gup_must_unshare(vma, flags, page))
> -               return ERR_PTR(-EMLINK);
> +               return -EMLINK;
>
>         ret =3D try_grab_folio(page_folio(page), 1, flags);
>         if (ret)
> -               page =3D ERR_PTR(ret);
> -       else
> -               *page_mask =3D HPAGE_PUD_NR - 1;
> +               return ret;
>
> -       return page;
> +       *page_mask =3D HPAGE_PUD_NR - 1;
> +
> +       gup_fill_pages(vma, addr, page, 1, pages);
> +
> +       return 1;
>  }
>
>  /* FOLL_FORCE can write to even unwritable PMDs in COW mappings. */
> @@ -715,10 +718,10 @@ static inline bool can_follow_write_pmd(pmd_t pmd, =
struct page *page,
>         return !userfaultfd_huge_pmd_wp(vma, pmd);
>  }
>
> -static struct page *follow_huge_pmd(struct vm_area_struct *vma,
> -                                   unsigned long addr, pmd_t *pmd,
> -                                   unsigned int flags,
> -                                   unsigned long *page_mask)
> +static long follow_huge_pmd(struct vm_area_struct *vma,
> +               unsigned long addr, pmd_t *pmd,
> +               unsigned int flags, unsigned long *page_mask,
> +               struct page **pages)
>  {
>         struct mm_struct *mm =3D vma->vm_mm;
>         pmd_t pmdval =3D *pmd;
> @@ -730,24 +733,24 @@ static struct page *follow_huge_pmd(struct vm_area_=
struct *vma,
>         page =3D pmd_page(pmdval);
>         if ((flags & FOLL_WRITE) &&
>             !can_follow_write_pmd(pmdval, page, vma, flags))
> -               return NULL;
> +               return 0;
>
>         /* Avoid dumping huge zero page */
>         if ((flags & FOLL_DUMP) && is_huge_zero_pmd(pmdval))
> -               return ERR_PTR(-EFAULT);
> +               return -EFAULT;
>
>         if (pmd_protnone(*pmd) && !gup_can_follow_protnone(vma, flags))
> -               return NULL;
> +               return 0;
>
>         if (!pmd_write(pmdval) && gup_must_unshare(vma, flags, page))
> -               return ERR_PTR(-EMLINK);
> +               return -EMLINK;
>
>         VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
>                              !PageAnonExclusive(page), page);
>
>         ret =3D try_grab_folio(page_folio(page), 1, flags);
>         if (ret)
> -               return ERR_PTR(ret);
> +               return ret;
>
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>         if (pmd_trans_huge(pmdval) && (flags & FOLL_TOUCH))
> @@ -757,23 +760,26 @@ static struct page *follow_huge_pmd(struct vm_area_=
struct *vma,
>         page +=3D (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
>         *page_mask =3D HPAGE_PMD_NR - 1;
>
> -       return page;
> +       gup_fill_pages(vma, addr, page, 1, pages);
> +
> +       return 1;
>  }
>
>  #else  /* CONFIG_PGTABLE_HAS_HUGE_LEAVES */
> -static struct page *follow_huge_pud(struct vm_area_struct *vma,
> -                                   unsigned long addr, pud_t *pudp,
> -                                   int flags, unsigned long *page_mask)
> +static long follow_huge_pud(struct vm_area_struct *vma,
> +               unsigned long addr, pud_t *pudp,
> +               unsigned int flags, unsigned long *page_mask,
> +               struct page **pages)
>  {
> -       return NULL;
> +       return 0;
>  }
>
> -static struct page *follow_huge_pmd(struct vm_area_struct *vma,
> -                                   unsigned long addr, pmd_t *pmd,
> -                                   unsigned int flags,
> -                                   unsigned long *page_mask)
> +static long follow_huge_pmd(struct vm_area_struct *vma,
> +               unsigned long addr, pmd_t *pmd,
> +               unsigned int flags, unsigned long *page_mask,
> +               struct page **pages)
>  {
> -       return NULL;
> +       return 0;
>  }
>  #endif /* CONFIG_PGTABLE_HAS_HUGE_LEAVES */
>
> @@ -816,15 +822,16 @@ static inline bool can_follow_write_pte(pte_t pte, =
struct page *page,
>         return !userfaultfd_pte_wp(vma, pte);
>  }
>
> -static struct page *follow_page_pte(struct vm_area_struct *vma,
> -               unsigned long address, pmd_t *pmd, unsigned int flags)
> +static long follow_page_pte(struct vm_area_struct *vma,
> +               unsigned long address, pmd_t *pmd, unsigned int flags,
> +               struct page **pages)
>  {
>         struct mm_struct *mm =3D vma->vm_mm;
>         struct folio *folio;
>         struct page *page;
>         spinlock_t *ptl;
>         pte_t *ptep, pte;
> -       int ret;
> +       long ret;
>
>         ptep =3D pte_offset_map_lock(mm, pmd, address, &ptl);
>         if (!ptep)
> @@ -842,14 +849,14 @@ static struct page *follow_page_pte(struct vm_area_=
struct *vma,
>          */
>         if ((flags & FOLL_WRITE) &&
>             !can_follow_write_pte(pte, page, vma, flags)) {
> -               page =3D NULL;
> +               ret =3D 0;
>                 goto out;
>         }
>
>         if (unlikely(!page)) {
>                 if (flags & FOLL_DUMP) {
>                         /* Avoid special (like zero) pages in core dumps =
*/
> -                       page =3D ERR_PTR(-EFAULT);
> +                       ret =3D -EFAULT;
>                         goto out;
>                 }
>
> @@ -857,14 +864,13 @@ static struct page *follow_page_pte(struct vm_area_=
struct *vma,
>                         page =3D pte_page(pte);
>                 } else {
>                         ret =3D follow_pfn_pte(vma, address, ptep, flags)=
;
> -                       page =3D ERR_PTR(ret);
>                         goto out;
>                 }
>         }
>         folio =3D page_folio(page);
>
>         if (!pte_write(pte) && gup_must_unshare(vma, flags, page)) {
> -               page =3D ERR_PTR(-EMLINK);
> +               ret =3D -EMLINK;
>                 goto out;
>         }
>
> @@ -873,10 +879,8 @@ static struct page *follow_page_pte(struct vm_area_s=
truct *vma,
>
>         /* try_grab_folio() does nothing unless FOLL_GET or FOLL_PIN is s=
et. */
>         ret =3D try_grab_folio(folio, 1, flags);
> -       if (unlikely(ret)) {
> -               page =3D ERR_PTR(ret);
> +       if (unlikely(ret))
>                 goto out;
> -       }
>
>         /*
>          * We need to make the page accessible if and only if we are goin=
g
> @@ -886,8 +890,7 @@ static struct page *follow_page_pte(struct vm_area_st=
ruct *vma,
>         if (flags & FOLL_PIN) {
>                 ret =3D arch_make_folio_accessible(folio);
>                 if (ret) {
> -                       unpin_user_page(page);
> -                       page =3D ERR_PTR(ret);
> +                       gup_put_folio(folio, 1, flags);
>                         goto out;
>                 }
>         }
> @@ -902,24 +905,27 @@ static struct page *follow_page_pte(struct vm_area_=
struct *vma,
>                  */
>                 folio_mark_accessed(folio);
>         }
> +
> +       gup_fill_pages(vma, address, page, 1, pages);
> +       ret =3D 1;
>  out:
>         pte_unmap_unlock(ptep, ptl);
> -       return page;
> +       return ret;
>  no_page:
>         pte_unmap_unlock(ptep, ptl);
>         if (!pte_none(pte))
> -               return NULL;
> +               return 0;
>         return no_page_table(vma, flags, address);
>  }
>
> -static struct page *follow_pmd_mask(struct vm_area_struct *vma,
> -                                   unsigned long address, pud_t *pudp,
> -                                   unsigned int flags,
> -                                   unsigned long *page_mask)
> +static long follow_pmd_mask(struct vm_area_struct *vma,
> +               unsigned long address, pud_t *pudp,
> +               unsigned int flags, unsigned long *page_mask,
> +               struct page **pages)
>  {
>         pmd_t *pmd, pmdval;
>         spinlock_t *ptl;
> -       struct page *page;
> +       long ret;
>         struct mm_struct *mm =3D vma->vm_mm;
>
>         pmd =3D pmd_offset(pudp, address);
> @@ -929,7 +935,7 @@ static struct page *follow_pmd_mask(struct vm_area_st=
ruct *vma,
>         if (!pmd_present(pmdval))
>                 return no_page_table(vma, flags, address);
>         if (likely(!pmd_leaf(pmdval)))
> -               return follow_page_pte(vma, address, pmd, flags);
> +               return follow_page_pte(vma, address, pmd, flags, pages);
>
>         if (pmd_protnone(pmdval) && !gup_can_follow_protnone(vma, flags))
>                 return no_page_table(vma, flags, address);
> @@ -942,28 +948,28 @@ static struct page *follow_pmd_mask(struct vm_area_=
struct *vma,
>         }
>         if (unlikely(!pmd_leaf(pmdval))) {
>                 spin_unlock(ptl);
> -               return follow_page_pte(vma, address, pmd, flags);
> +               return follow_page_pte(vma, address, pmd, flags, pages);
>         }
>         if (pmd_trans_huge(pmdval) && (flags & FOLL_SPLIT_PMD)) {
>                 spin_unlock(ptl);
>                 split_huge_pmd(vma, pmd, address);
>                 /* If pmd was left empty, stuff a page table in there qui=
ckly */
> -               return pte_alloc(mm, pmd) ? ERR_PTR(-ENOMEM) :
> -                       follow_page_pte(vma, address, pmd, flags);
> +               return pte_alloc(mm, pmd) ? -ENOMEM :
> +                       follow_page_pte(vma, address, pmd, flags, pages);
>         }
> -       page =3D follow_huge_pmd(vma, address, pmd, flags, page_mask);
> +       ret =3D follow_huge_pmd(vma, address, pmd, flags, page_mask, page=
s);
>         spin_unlock(ptl);
> -       return page;
> +       return ret;
>  }
>
> -static struct page *follow_pud_mask(struct vm_area_struct *vma,
> -                                   unsigned long address, p4d_t *p4dp,
> -                                   unsigned int flags,
> -                                   unsigned long *page_mask)
> +static long follow_pud_mask(struct vm_area_struct *vma,
> +               unsigned long address, p4d_t *p4dp,
> +               unsigned int flags, unsigned long *page_mask,
> +               struct page **pages)
>  {
>         pud_t *pudp, pud;
>         spinlock_t *ptl;
> -       struct page *page;
> +       long ret;
>         struct mm_struct *mm =3D vma->vm_mm;
>
>         pudp =3D pud_offset(p4dp, address);
> @@ -972,22 +978,22 @@ static struct page *follow_pud_mask(struct vm_area_=
struct *vma,
>                 return no_page_table(vma, flags, address);
>         if (pud_leaf(pud)) {
>                 ptl =3D pud_lock(mm, pudp);
> -               page =3D follow_huge_pud(vma, address, pudp, flags, page_=
mask);
> +               ret =3D follow_huge_pud(vma, address, pudp, flags, page_m=
ask, pages);
>                 spin_unlock(ptl);
> -               if (page)
> -                       return page;
> +               if (ret)
> +                       return ret;
>                 return no_page_table(vma, flags, address);
>         }
>         if (unlikely(pud_bad(pud)))
>                 return no_page_table(vma, flags, address);
>
> -       return follow_pmd_mask(vma, address, pudp, flags, page_mask);
> +       return follow_pmd_mask(vma, address, pudp, flags, page_mask, page=
s);
>  }
>
> -static struct page *follow_p4d_mask(struct vm_area_struct *vma,
> -                                   unsigned long address, pgd_t *pgdp,
> -                                   unsigned int flags,
> -                                   unsigned long *page_mask)
> +static long follow_p4d_mask(struct vm_area_struct *vma,
> +               unsigned long address, pgd_t *pgdp,
> +               unsigned int flags, unsigned long *page_mask,
> +               struct page **pages)
>  {
>         p4d_t *p4dp, p4d;
>
> @@ -998,7 +1004,7 @@ static struct page *follow_p4d_mask(struct vm_area_s=
truct *vma,
>         if (!p4d_present(p4d) || p4d_bad(p4d))
>                 return no_page_table(vma, flags, address);
>
> -       return follow_pud_mask(vma, address, p4dp, flags, page_mask);
> +       return follow_pud_mask(vma, address, p4dp, flags, page_mask, page=
s);
>  }
>
>  /**
> @@ -1007,6 +1013,9 @@ static struct page *follow_p4d_mask(struct vm_area_=
struct *vma,
>   * @address: virtual address to look up
>   * @flags: flags modifying lookup behaviour
>   * @page_mask: a pointer to output page_mask
> + * @pages: array to receive the page found, refcounted per @flags, or NU=
LL
> + *         to walk the page tables (e.g. to fault pages in) without
> + *         collecting or refcounting them
>   *
>   * @flags can have FOLL_ flags set, defined in <linux/mm.h>
>   *
> @@ -1017,17 +1026,17 @@ static struct page *follow_p4d_mask(struct vm_are=
a_struct *vma,
>   *
>   * On output, @page_mask is set according to the size of the page.
>   *
> - * Return: the mapped (struct page *), %NULL if no mapping exists, or
> - * an error pointer if there is a mapping to something not represented
> - * by a page descriptor (see also vm_normal_page()).
> + * Return: 1 with @pages[0] filled in if a page was found, 0 if no mappi=
ng
> + * exists at @address, or a negative errno for a mapping to something no=
t
> + * represented by a page descriptor (see also vm_normal_page()).
>   */
> -static struct page *follow_page_mask(struct vm_area_struct *vma,
> -                             unsigned long address, unsigned int flags,
> -                             unsigned long *page_mask)
> +static long follow_page_mask(struct vm_area_struct *vma,
> +               unsigned long address, unsigned int flags,
> +               unsigned long *page_mask, struct page **pages)
>  {
>         pgd_t *pgd;
>         struct mm_struct *mm =3D vma->vm_mm;
> -       struct page *page;
> +       long ret;
>
>         vma_pgtable_walk_begin(vma);
>
> @@ -1035,13 +1044,13 @@ static struct page *follow_page_mask(struct vm_ar=
ea_struct *vma,
>         pgd =3D pgd_offset(mm, address);
>
>         if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
> -               page =3D no_page_table(vma, flags, address);
> +               ret =3D no_page_table(vma, flags, address);
>         else
> -               page =3D follow_p4d_mask(vma, address, pgd, flags, page_m=
ask);
> +               ret =3D follow_p4d_mask(vma, address, pgd, flags, page_ma=
sk, pages);
>
>         vma_pgtable_walk_end(vma);
>
> -       return page;
> +       return ret;
>  }
>
>  static int get_gate_page(struct mm_struct *mm, unsigned long address,
> @@ -1391,6 +1400,7 @@ static long __get_user_pages(struct mm_struct *mm,
>         do {
>                 struct page *page;
>                 unsigned int page_increm;
> +               long nr;
>
>                 /* first iteration or cross vma bound */
>                 if (!vma || start >=3D vma->vm_end) {
> @@ -1417,8 +1427,12 @@ static long __get_user_pages(struct mm_struct *mm,
>                                                 pages ? &page : NULL);
>                                 if (ret)
>                                         goto out;
> -                               page_mask =3D 0;
> -                               goto next_page;
> +                               gup_fill_pages(vma, start, page, 1,
> +                                              pages ? pages + i : NULL);
> +                               i++;
> +                               start +=3D PAGE_SIZE;
> +                               nr_pages--;
> +                               continue;
>                         }
>
>                         if (!vma) {
> @@ -1440,10 +1454,11 @@ static long __get_user_pages(struct mm_struct *mm=
,
>                 }
>                 cond_resched();
>
> -               page =3D follow_page_mask(vma, start, gup_flags, &page_ma=
sk);
> -               if (!page || PTR_ERR(page) =3D=3D -EMLINK) {
> +               nr =3D follow_page_mask(vma, start, gup_flags, &page_mask=
,
> +                                     pages ? &pages[i] : NULL);
> +               if (!nr || nr =3D=3D -EMLINK) {
>                         ret =3D faultin_page(vma, start, gup_flags,
> -                                          PTR_ERR(page) =3D=3D -EMLINK, =
locked);
> +                                          nr =3D=3D -EMLINK, locked);
>                         switch (ret) {
>                         case 0:
>                                 goto retry;
> @@ -1457,7 +1472,7 @@ static long __get_user_pages(struct mm_struct *mm,
>                                 goto out;
>                         }
>                         BUG();
> -               } else if (PTR_ERR(page) =3D=3D -EEXIST) {
> +               } else if (nr =3D=3D -EEXIST) {
>                         /*
>                          * Proper page table entry exists, but no corresp=
onding
>                          * struct page. If the caller expects **pages to =
be
> @@ -1465,49 +1480,48 @@ static long __get_user_pages(struct mm_struct *mm=
,
>                          * for this page.
>                          */
>                         if (pages) {
> -                               ret =3D PTR_ERR(page);
> +                               ret =3D nr;
>                                 goto out;
>                         }
> -               } else if (IS_ERR(page)) {
> -                       ret =3D PTR_ERR(page);
> +               } else if (nr < 0) {
> +                       ret =3D nr;
>                         goto out;
>                 }
> -next_page:
> +
>                 page_increm =3D 1 + (~(start >> PAGE_SHIFT) & page_mask);
>                 if (page_increm > nr_pages)
>                         page_increm =3D nr_pages;
>
> -               if (pages) {
> +               /*
> +                * This must be a large folio (and doesn't need to
> +                * be the whole folio; it can be part of it), do
> +                * the refcount work for all the subpages too.
> +                *
> +                * NOTE: here the page may not be the head page
> +                * e.g. when start addr is not thp-size aligned.
> +                * try_grab_folio() should have taken care of tail
> +                * pages.
> +                */
> +               if (pages && page_increm > 1) {
> +                       struct folio *folio =3D page_folio(pages[i]);
> +
>                         /*
> -                        * This must be a large folio (and doesn't need t=
o
> -                        * be the whole folio; it can be part of it), do
> -                        * the refcount work for all the subpages too.
> -                        *
> -                        * NOTE: here the page may not be the head page
> -                        * e.g. when start addr is not thp-size aligned.
> -                        * try_grab_folio() should have taken care of tai=
l
> -                        * pages.
> +                        * Since we already hold refcount on the
> +                        * large folio, this should never fail.
>                          */
> -                       if (page_increm > 1) {
> -                               struct folio *folio =3D page_folio(page);
> -
> +                       if (try_grab_folio(folio, page_increm - 1,
> +                                          gup_flags)) {
>                                 /*
> -                                * Since we already hold refcount on the
> -                                * large folio, this should never fail.
> +                                * Release the 1st page ref if the
> +                                * folio is problematic, fail hard.
>                                  */
> -                               if (try_grab_folio(folio, page_increm - 1=
,
> -                                                  gup_flags)) {
> -                                       /*
> -                                        * Release the 1st page ref if th=
e
> -                                        * folio is problematic, fail har=
d.
> -                                        */
> -                                       gup_put_folio(folio, 1, gup_flags=
);
> -                                       ret =3D -EFAULT;
> -                                       goto out;
> -                               }
> +                               gup_put_folio(folio, 1, gup_flags);
> +                               ret =3D -EFAULT;
> +                               goto out;
>                         }
>
> -                       gup_fill_pages(vma, start, page, page_increm, pag=
es + i);
> +                       gup_fill_pages(vma, start + PAGE_SIZE, pages[i] +=
 1,
> +                                      page_increm - 1, pages + i + 1);
>                 }
>
>                 i +=3D page_increm;
> --
> 2.55.0
>
>

