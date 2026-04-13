Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BD2CF531CB
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 20:16:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B2726B00B2; Mon, 13 Apr 2026 16:16:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 663306B00B3; Mon, 13 Apr 2026 16:16:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 578D16B00B4; Mon, 13 Apr 2026 16:16:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 45ADF6B00B2
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:16:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD24F8AE85
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:16:25 +0000 (UTC)
X-FDA: 84654639930.28.8A8DA57
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id E18B72000F
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:16:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uWF/artp";
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776111383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ii618WCY4OPiNL7FtmIZQQ8wHuTxpWru2GswJI1aP9c=;
	b=MwPgisBozhz0oLvsfCFchcLjm9FHCL1otKl2vwE12tQ7Q77luZ5t/XtVoe3MUlPOcUEj3Z
	t2crxkBjBhdxku4Qll7XLJ5ZwXF2RtFbbk4YIvcwm7ub3cYVX2jFX8jYEaVPQUvdtFrhV1
	8Y5mKTOJ/GoVqaglpch/cTQGj33cntE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uWF/artp";
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776111383; a=rsa-sha256;
	cv=none;
	b=bQD2P7to6D+r7jq7wN4MhyVfQLwslId0YN+S5GX9r/xAFJ5fjh9ZSFtZ+IIN0XpHQpmi/P
	ykksGn9tfGvVN2eZcpogJkxLhg6F5XXRxoP7IzcE4zyhlde64MS1wz9vol0qvRbQNddCOL
	3IOCqEzcW68vnxv+n4GGVVzQoFRyEgM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 143AC6183B
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:16:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7BCC2BCB3
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776111382;
	bh=j114EYxMPzWh3j8156US6so/8rc9cDU/wlHx2kr7Y4s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=uWF/artpWbuUnSooqdOaYbgdDRAeFll3VhcPUYZa5vgqoQ7IhHEQlKE0KYTCM5l9t
	 ekRnDW2zc4gzX6D94EXcQ+tUAhrImnJ5HrNgbS+bQstwEXTsjiyKq/ecFsOA15fvu6
	 TRCCKvnMTxBWHA9zuYX5Fjzi0n2zC/gdP2HCCztGqwSf3v+nFjSnt9UKvgM+ZU5hNO
	 a8edlJASLhuAaPWYWK7F0H+tQC2HKmJwQUqJwT79FonWVculVyU4ssABo8CZzn+TUU
	 MS+uf6K4edg+MQdynF4XJfkqCG56ScCMxT8ITH+KR1XvpPyCjPVEtm28D7NhyH2rvg
	 FX64rcF/wpSTw==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8d67a483d3eso515351885a.1
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:16:22 -0700 (PDT)
X-Gm-Message-State: AOJu0YyM+6tGa9jFquDWHc/CKvLVbN4y7gRzkfFoP8lpHMrgP9SlG+pZ
	KNRcMiuQNvRMPq2w6RWBDmE+9VM2AIE+evA4J10VthV5KuUBwBaKxu8/Wsp6rTMJYlPZaRv2nQu
	dDXMagafHocWDM/JCxge5c9ojvFCmN6E=
X-Received: by 2002:a05:6214:4e85:b0:89c:806c:8c with SMTP id
 6a1803df08f44-8ac8628f246mr220911296d6.28.1776111382042; Mon, 13 Apr 2026
 13:16:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260408025115.27368-1-baohua@kernel.org> <20260408025115.27368-4-baohua@kernel.org>
 <ad0U-IEvZkFwpBsg@kernel.org>
In-Reply-To: <ad0U-IEvZkFwpBsg@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 14 Apr 2026 04:16:10 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wnUvknCzM=jpDEDrdUKcrAR5MA2EW6eqCfGKgQWF53YA@mail.gmail.com>
X-Gm-Features: AQROBzBvu5KJKBkdHpOmlCQrUcrzTZlrSvZUBKKBwmAj4xBiS0yTsNJwhuzfp74
Message-ID: <CAGsJ_4wnUvknCzM=jpDEDrdUKcrAR5MA2EW6eqCfGKgQWF53YA@mail.gmail.com>
Subject: Re: [RFC PATCH 3/8] mm/vmalloc: Extend vmap_small_pages_range_noflush()
 to support larger page_shift sizes
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org, 
	urezki@gmail.com, linux-kernel@vger.kernel.org, anshuman.khandual@arm.com, 
	ryan.roberts@arm.com, ajd@linux.ibm.com, david@kernel.org, 
	Xueyuan.chen21@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: E18B72000F
X-Stat-Signature: oxe4g7eakzqouaap4cyuco4ph7z6mjn5
X-Rspamd-Server: rspam06
X-HE-Tag: 1776111383-782210
X-HE-Meta: U2FsdGVkX195N+WCMQ8KMq0ElUanO6SMYdQ7077pkWwv7qmppiILxeBYjJXHxSBYTBAU7RWy2Q1C66TuCKR6ZqIrxbu3rrD5hS9X+FlnzOJ60dcKJ1bldQxJyoRC4IF7cjf8Myt4hGnW/5Nh7nUUwYZU2uqUCA0WKud1RE80+Aajj6dDd9kBasn7ojMfmSiSHzu+JuhFoWHWP5l0/GrINSM+EKpxMcuJr2SzM8dgSVE7o8YI1RtWNXNrSoUvsCs3nNV6oNxd1zhX2kbiS8iHXaJheyz9/fqXFGhVdj+wwiMU63gS8Zu7BmClF1HXnTAnJO925Ouf/m5usBrehzPHrzXSICT8pG+Uq1GoH80TsSYxVvffMfxUm7OeJ7xTWWHwuIJwLGHj4Nv7CPYRubutYPhP10AJEBGxh7ZXp9BULansfiOuRCE4uId+V1/7jM5HQo/tncMcfXIGWNctzZA5ZtqGhbRJeWCl8RLjNv32LDU/1KMKdBfrqkq9w6DVO++www2giv3dq4JOv6kPdqciLf85kz3z3OalEFxRUnDSMDCpmkp2YZpGKFDGKd9IdT6FlOA2sUQdpqb3vux5NH2z1Rr43B2LqfRpf5BfoFeLSwaSNqtNbrPQKhU4M/EOLOkvqhjuEj/3mVhOpBAn3Efl8v6kGHa+0fRduRlDIxP1SBf+5i39jZOP2U49yVGsXyVoDLAKPlEGtkOnLCqV4sLPLUkyhj7FlH9grCrIqUZGXNaOR/VLNeezjPCA6+G6eZxfM5ir5TA8yh03Dr1RhjZNVhILFWqnPQZ1gCWqRWlBjnyjgKv+GpaxNFgkHr5HU20NjxDG6CYNVurUCxQnttdQZ9NP64wsw6MbVwCbUjB8aq9CEjXhMEHBqkJi+ipXGPLEBWuCqGwE7EhN0cYgHIOC8Fu6sEb/dfY/H/WqUXBlgHaz2yMz2zf5q7+IYlYu9c9g+oi8I04q8hJLhWx7H6j
 bvaXtG0e
 FNloB+WoyPv3L3z/bPaO/96sOtzo7KBiH7mGy7b+TdETIrJ6Cqi9bYtRsilWGgU0tSPXsv9vTY+OQ3t8q563v5qxGo3UjILNiAFTY+P31d9+qKz7fnQIQ4X5ky+q+Xc6mIV/QyboJyVpliHz8IzT+vWy3H9sE/ryaUkJYjIV1zRUokSYnNyCf4HS1sSj88sBK4+UEaBgBr08iA3zg35m0B/oYH9y71MCQNWFOM5rycTFpqLkZxHlyJ6oep6KJ+BBunWuWhw0NPgbSm+sG6SD4pvHzqmNq/j/S+zCUVYyGZ7rAVW2Cz0AmwriQEEi5Z7awh8aFOzg3Zs8T2OW+XRuvxcdIEwF65CEGBW0T+Hf6MovoTsX5zP1+Z6La1nGrk+4/IW0K1XttAL9UAGdGKQrA9T7o6TB5yGuc7Ws22jfOdktqRKQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 12:08=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wr=
ote:
>
> Hi Barry,

Thanks for reviewing, Mike!

>
> On Wed, Apr 08, 2026 at 10:51:10AM +0800, Barry Song (Xiaomi) wrote:
> > vmap_small_pages_range_noflush() provides a clean interface by taking
> > struct page **pages and mapping them via direct PTE iteration. This
> > avoids the page table zigzag seen when using
> > vmap_range_noflush() for page_shift values other than PAGE_SHIFT.
> >
> > Extend it to support larger page_shift values, and add PMD- and
> > contiguous-PTE mappings as well.
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> >  mm/vmalloc.c | 54 ++++++++++++++++++++++++++++++++++++++++------------
> >  1 file changed, 42 insertions(+), 12 deletions(-)
> >
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 57eae99d9909..5bf072297536 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -524,8 +524,9 @@ void vunmap_range(unsigned long addr, unsigned long=
 end)
> >
> >  static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
> >               unsigned long end, pgprot_t prot, struct page **pages, in=
t *nr,
> > -             pgtbl_mod_mask *mask)
> > +             pgtbl_mod_mask *mask, unsigned int shift)
> >  {
> > +     unsigned int steps =3D 1;
> >       int err =3D 0;
> >       pte_t *pte;
> >
> > @@ -543,6 +544,7 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigne=
d long addr,
> >       do {
> >               struct page *page =3D pages[*nr];
> >
> > +             steps =3D 1;
> >               if (WARN_ON(!pte_none(ptep_get(pte)))) {
> >                       err =3D -EBUSY;
> >                       break;
> > @@ -556,9 +558,24 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsign=
ed long addr,
> >                       break;
> >               }
> >
> > +#ifdef CONFIG_HUGETLB_PAGE
>
> Why is this related to HUGETLB_PAGE?

This is also a question I asked myself during development.
Currently, huge mappings in mm/vmalloc have an ugly
dependency on HUGETLB, as hugetlb provides the APIs for
mapping multiple PTEs. Right now, set_ptes() is mainly used
for large folios in userspace; if it can fully support kernel
page tables, I would be very happy to remove this dependency
on HUGETLB entirely, including in the ioremap case in
vmap_pte_range().

I recall Ryan once mentioned some issues with using set_ptes()
for kernel mappings?

Once that issue is resolved, we can entirely remove the
HUGETLB dependency in mm/vmalloc.c.

>
> > +             if (shift !=3D PAGE_SHIFT) {
> > +                     unsigned long pfn =3D page_to_pfn(page), size;
> > +
> > +                     size =3D arch_vmap_pte_range_map_size(addr, end, =
pfn, shift);
> > +                     if (size !=3D PAGE_SIZE) {
> > +                             steps =3D size >> PAGE_SHIFT;
> > +                             pte_t entry =3D pfn_pte(pfn, prot);
> > +
> > +                             entry =3D arch_make_huge_pte(entry, ilog2=
(size), 0);
> > +                             set_huge_pte_at(&init_mm, addr, pte, entr=
y, size);
> > +                             continue;
> > +                     }
> > +             }
> > +#endif
> > +
> >               set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
> > -             (*nr)++;
> > -     } while (pte++, addr +=3D PAGE_SIZE, addr !=3D end);
> > +     } while (pte +=3D steps, *nr +=3D steps, addr +=3D PAGE_SIZE * st=
eps, addr !=3D end);
> >
> >       lazy_mmu_mode_disable();
> >       *mask |=3D PGTBL_PTE_MODIFIED;
> > @@ -568,7 +585,7 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigne=
d long addr,
> >
> >  static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
> >               unsigned long end, pgprot_t prot, struct page **pages, in=
t *nr,
> > -             pgtbl_mod_mask *mask)
> > +             pgtbl_mod_mask *mask, unsigned int shift)
> >  {
> >       pmd_t *pmd;
> >       unsigned long next;
> > @@ -578,7 +595,20 @@ static int vmap_pages_pmd_range(pud_t *pud, unsign=
ed long addr,
> >               return -ENOMEM;
> >       do {
> >               next =3D pmd_addr_end(addr, end);
> > -             if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr=
, mask))
> > +
> > +             if (shift =3D=3D PMD_SHIFT) {
> > +                     struct page *page =3D pages[*nr];
> > +                     phys_addr_t phys_addr =3D page_to_phys(page);
> > +
> > +                     if (vmap_try_huge_pmd(pmd, addr, next, phys_addr,=
 prot,
> > +                                             shift)) {
> > +                             *mask |=3D PGTBL_PMD_MODIFIED;
> > +                             *nr +=3D 1 << (shift - PAGE_SHIFT);
> > +                             continue;
> > +                     }
>
> With this vmap_pages_pmd_range() looks quite similar to vmap_pmd_range().
> Any changes we can consolidate the two?

vmap_pmd_range() is for the ioremap case where we may have
8MB of contiguous memory. This is the case where we have
8MB total, but it is composed of 2MB chunks plus some
remainder. We might be able to extract some common code
though.

Thanks
Barry

