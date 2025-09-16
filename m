Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB8F8CAC59B
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 18:07:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6B68E0008; Tue, 16 Sep 2025 14:07:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2962E8E0001; Tue, 16 Sep 2025 14:07:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18B7B8E0008; Tue, 16 Sep 2025 14:07:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 00FD88E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:07:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9A9DEB7B27
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:07:10 +0000 (UTC)
X-FDA: 83895895020.03.CD615AB
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	by imf16.hostedemail.com (Postfix) with ESMTP id B886E180008
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:07:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QrO23Ogj;
	spf=pass (imf16.hostedemail.com: domain of zokeefe@google.com designates 209.85.166.174 as permitted sender) smtp.mailfrom=zokeefe@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758046028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/KjGjO8XGxVvCKmZIwlHy8ncxZnVLCCocyJUuVml/u0=;
	b=o14t5p40IT61K3WNO08dl2L/pmXcv5/rxbkBEr+2ago/lkjSR2ZKbOC5tPV1woYXGnKex7
	CyIBPo+aToeWcr/q/p+MuAlToCSzV0yT0gl9Ko9FZGyjBD5jR9qkcmswQObyi80pdM1FKS
	0Rd+Q7wpMLBEsxq09ALXKxVm4j7tw4c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QrO23Ogj;
	spf=pass (imf16.hostedemail.com: domain of zokeefe@google.com designates 209.85.166.174 as permitted sender) smtp.mailfrom=zokeefe@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758046028; a=rsa-sha256;
	cv=none;
	b=KUunuYYhshQBkYT/KMdCFPJw93cpD3M9VkUiq07Y6TzoNabP3J2BoxC5N/hNJ+0QECfmYz
	AUsST0phVWBX9BWmFxSzJhi7eyTiTSHafyOuWBOxscftWZM17mHrrwRR00cG32Y3TueygM
	oLxHaIm5LyOv9o/NqN1NZtHcQtPhO+E=
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-424134d9924so24625ab.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 11:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758046028; x=1758650828; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/KjGjO8XGxVvCKmZIwlHy8ncxZnVLCCocyJUuVml/u0=;
        b=QrO23Ogjz4UJUvgstS8RjCBFR4rEncND8XpVRdoK13icT0i7vvxGPV2QuBQJoSaT0R
         5UiVPfHmzO1tO3P/damIlIcp2d27kewlLldg8kiZMg5mzol9Atfwid8KBmSQUu01/EtV
         uo0L0WBcI9aQF84AriPxFOSNOyc/xx350MmiSkl2f8KxS+PrUmAIzTutc3PY4+mTsjZN
         A+UZePYFxopm/yY7Ldvt+wr16tinCqeqpQLmd+xdvk+s22DG05hr+7+qjREB6jafkHkC
         +UbLM+QJ6GET4jnmzV6ruSZ6f798tgwefibdX7KbALsUVBuLfCx7POXO9YR5+muIMOqO
         FTOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758046028; x=1758650828;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/KjGjO8XGxVvCKmZIwlHy8ncxZnVLCCocyJUuVml/u0=;
        b=Wp4Cx29VB7g1NG4b35kkBw2nIOgDSqmOhU+TY5nDhd5bbfaGySEA4JARYzKcLfpHF2
         aISGiE1S8uIPhIQragEXrTsHIvNMb5+uzuTX6eJ9w4zdDAm1Cpms7V/L29qcRZYppZm1
         kmg4ljTgLqaC3CePJZ7lAc9CbYfULsyb5sz3FUy7tGE8aEihe2fqdZMxmJuCDCMV96a4
         yp2JAYLgIidteJKsHHHXX29s43saoSkwQkJszl/li3cDfVmDuygM9ntpVCqbWJucrSHv
         cyajx+VuUlezH3gIC0MbEGjbACtVILmg/r3wqZc0ri3B30ZiPJaiIgEE9I2xWVJKztP+
         llPw==
X-Forwarded-Encrypted: i=1; AJvYcCUl6AeSUdRzC4s+iTbBifH4ebshNcw/hoVHkvWvglQGLWaUqEzKCwBs/XuUbxREgLL4WHCvJDGZLg==@kvack.org
X-Gm-Message-State: AOJu0YxaQg4tHXd818000SjmH6in6PwbUdVYtn7LnlYcticiZrMwGTYU
	6emq5N0gxwbmU8usdvJCZkf9ruVw7KBVtlo2v7m/LRaPKl94j8KhxlaDmosh6dReooMgcUvvnY6
	s+9K4zoHHgBVM5w4E3MwWnsXOnIUyfH1x1EEsxD1p
X-Gm-Gg: ASbGnctnrdXNXZuXFpCvmk4BJ5aY1sQ+ckTMXpS8clpnZzN1Ov3UXpD9GWBZHUJlLWr
	ZWLcS4zwv5hXr5wAcnbZpLS+ATzseP/cKWqxgSEdfuCjOGDCQKdl+x97+6n2pe+YikV1C/Hgffc
	E0S3d53IBSS0CM73+HSXfKaLea5wpHnXvnc5dpbhz2NC7HDHZobin1o3RgEuV6TUqKnSUpNXkFp
	AnFXs8Tt+Fg2TQ=
X-Google-Smtp-Source: AGHT+IEAMJII84irpmIS/OV0EYa+nFz8pldmS99mcGDbzc3y+pmYWTzZkT0LnGPBAy23zM64iVBtswHZSemYM9fDOxA=
X-Received: by 2002:a05:6e02:1947:b0:41b:96f1:7e04 with SMTP id
 e9e14a558f8ab-42418653a5dmr526845ab.14.1758046027304; Tue, 16 Sep 2025
 11:07:07 -0700 (PDT)
MIME-Version: 1.0
References: <v5ivpub6z2n2uyemlnxgbilzs52ep4lrary7lm7o6axxoneb75@yfacfl5rkzeh> <ecac1e7f-1709-4348-b8ff-fa1c0f087548@lucifer.local>
In-Reply-To: <ecac1e7f-1709-4348-b8ff-fa1c0f087548@lucifer.local>
From: "Zach O'Keefe" <zokeefe@google.com>
Date: Tue, 16 Sep 2025 11:06:30 -0700
X-Gm-Features: AS18NWC3dVBCWy9nf2z_yV-AQK7gFYe9HNxvrXs-9Ts5zi9RXbH5GvIfwGpTxSs
Message-ID: <CAAa6QmRaiKB2OOpZYjRx3EAQ+d8_G=MsVmV=9cc_MmHOYsikow@mail.gmail.com>
Subject: Re: [PATCHv2] mm/khugepaged: Do not fail collapse_pte_mapped_thp() on SCAN_PMD_NULL
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pbe7rrwddydtk7959xpeid9pafoyeusq
X-Rspam-User: 
X-Rspamd-Queue-Id: B886E180008
X-Rspamd-Server: rspam04
X-HE-Tag: 1758046028-364061
X-HE-Meta: U2FsdGVkX1/NwgH2LAYyVDGgwEJV79jrAfV93BeLsogK3Zzj/sTkVpoXkOvTkBhaG8k0FXQgoy0vRhNCSfZIvNZLsugayJB+McdB3yNK+xyVjmI+de31Ft8ig8gN/932wAwGYmJfxXJVQ8KSHuzK49sLCm8D+YDOIy4he+JaPJaQdxhdfp8nCOO2ORE4FX34uPnEq8BvxXx12+Bui3YKcAamZ/YbPoCbCtVx+OLhwHyQa805T2ALwR6eRygK6NbiJuEZa44E69wk2pUjOCr13Fks7Tg8UJqdidJJRlp/1oWGFdYbITrzf+hsBeq/fYKY3WlE+TRxJyrJkMj0+k1JFRbQPoi+b1kDKxOP366lhmdGBR5pQkek8NVgz2ApUyONIOLSSPE0MKXROH0EO6HxeoDaXgfwvh33mXnQDy/3GA4AspuPzE5CurtwoQV9A5ruGOXro+fo+3zi4TNv4/zNUHgbO6qjNZq9Nf92gJ8WNGbER7xoGtOGW7v5AvbpPX25mFxdEv6nB7L69NPx8bY/KvhEmJz35O68aQc9bP5JQU4bkUlHHc+bifLNKAIl3CSzpK1xH7nGXW9uQw4DkXpZ7b6nDRyY9OooLhosfAgYboelYAlrPTIMsWPXoTHAco+6Oy2WmN6FBayG/DegvNe3Wi8jmhO8D700xMPTBqlJd958mWryDFivKzbzxIaDMr/DvrE7zMNE1ckgRMW4kzKTNvnYU6BgCPdKlqNQT0ik1fXzuGlQlRDo5OAnqP5Q+XI8BB/duZH0W1c8Popv9JKHwsIkIBB9NDmyhyoT+fQ+8ZNUvj+DiHMkOicpM2EOwXBlot/eI3hBJNJKO5msrCzd6yU2n6kSno1EfbmXS6vwpN5+5mFFBx+JVlZhhvkpIF4xidYXy4oVN+ifIpO7HC/eIFwxspl1wVAlwU3uLZFMdU92vLzkuJyVrs4b/O4zhkWOdCMV5WCoDaRAfsYs+1g
 MrP0/eNz
 bE3n5OG4lcXN251B+tE2pCcDqhmg6PHC5V25B6QCCdNY4703Q1KKt0SatvQDe3dG7OQP2bdFl8yFDwKZmHkszLv2M9h5LjEpEY8TteN6S+L3tZaIeyKMMbz/rOgBDGXUVB/692Mnhec8lu+J669Hl0WBgSIph5cPyQP7WKqlDrdT1srwpHI3fkqdukv1dPDUhSrCpZHJKfOF8ewMSsqb2lV5tuBQX+gBQUf+BKmWpQl082S9FF54LBFhjKbgIjo2TO8Xz2T9YsopWX4obFNfv6Pb6uRgu1q1Cw1cK4Ze9+6uwQNj34oMpon3Y/WrfjZqtswav
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 2:54=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Mon, Sep 15, 2025 at 02:52:53PM +0100, Kiryl Shutsemau wrote:
> > From: Kiryl Shutsemau <kas@kernel.org>
> >
> > MADV_COLLAPSE on a file mapping behaves inconsistently depending on if
> > PMD page table is installed or not.
> >
> > Consider following example:
> >
> >       p =3D mmap(NULL, 2UL << 20, PROT_READ | PROT_WRITE,
> >                MAP_SHARED, fd, 0);
> >       err =3D madvise(p, 2UL << 20, MADV_COLLAPSE);
> >
> > fd is a populated tmpfs file.
> >
> > The result depends on the address that the kernel returns on mmap().
> > If it is located in an existing PMD table, the madvise() will succeed.
> > However, if the table does not exist, it will fail with -EINVAL.
> >
> > This occurs because find_pmd_or_thp_or_none() returns SCAN_PMD_NULL whe=
n
> > a page table is missing, which causes collapse_pte_mapped_thp() to fail=
.
> >
> > SCAN_PMD_NULL and SCAN_PMD_NONE should be treated the same in
> > collapse_pte_mapped_thp(): install the PMD leaf entry and allocate page
> > tables as needed.
> >
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

So, since we are trying to aim for consistency here, I think we ought
to also support the anonymous case.

I don't have a patch, but can spot at least two things we'd need to adjust:

First, we are defeated by the check in __thp_vma_allowable_orders();

        /*
         * THPeligible bit of smaps should show 1 for proper VMAs even
         * though anon_vma is not initialized yet.
         *
         * Allow page fault since anon_vma may be not initialized until
         * the first page fault.
         */
        if (!vma->anon_vma)
                return (smaps || in_pf) ? orders : 0;

I think we can probably just delete that check, but would need to confirm.

And second, madvise_collapse() doesn't route SCAN_PMD_NULL to
collapse_pte_mapped_thp(). I think we just need to audit places where
we return this code, to make sure it's faithfully describing a
situation where we can go ahead and install a new pmd. As a hasty
check, the return codes in check_pmd_state() don't look to follow
that, with !present and pmd_bad() returning SCAN_PMD_NULL. Likewise,
there are many underlying failure reasons for
pte_offset_map_ro_nolock()=3D>___pte_offset_map() that aren't "no PMD
entry".

WDYT?

> There was a v1 with tags, you've not propagated any of them? Did you feel
> the change was enough to remove them?
>
> Anyway, LGTM so:
>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> > ---
> >
> > v2:
> >  - Modify set_huge_pmd() instead of introducing install_huge_pmd();
> >
> > ---
> >  mm/khugepaged.c | 20 +++++++++++++++++++-
> >  1 file changed, 19 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index b486c1d19b2d..986718599355 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1472,15 +1472,32 @@ static void collect_mm_slot(struct khugepaged_m=
m_slot *mm_slot)
> >  static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr=
,
> >                       pmd_t *pmdp, struct folio *folio, struct page *pa=
ge)
> >  {
> > +     struct mm_struct *mm =3D vma->vm_mm;
> >       struct vm_fault vmf =3D {
> >               .vma =3D vma,
> >               .address =3D addr,
> >               .flags =3D 0,
> > -             .pmd =3D pmdp,
> >       };
> > +     pgd_t *pgdp;
> > +     p4d_t *p4dp;
> > +     pud_t *pudp;
> >
> >       mmap_assert_locked(vma->vm_mm);
>
> NIT: you have mm as a local var should use here too. Not a big deal thoug=
h
> obviously...
>
> >
> > +     if (!pmdp) {
> > +             pgdp =3D pgd_offset(mm, addr);
> > +             p4dp =3D p4d_alloc(mm, pgdp, addr);
> > +             if (!p4dp)
> > +                     return SCAN_FAIL;
> > +             pudp =3D pud_alloc(mm, p4dp, addr);
> > +             if (!pudp)
> > +                     return SCAN_FAIL;
> > +             pmdp =3D pmd_alloc(mm, pudp, addr);
> > +             if (!pmdp)
> > +                     return SCAN_FAIL;
> > +     }
> > +
> > +     vmf.pmd =3D pmdp;
> >       if (do_set_pmd(&vmf, folio, page))
> >               return SCAN_FAIL;
> >
> > @@ -1556,6 +1573,7 @@ int collapse_pte_mapped_thp(struct mm_struct *mm,=
 unsigned long addr,
> >       switch (result) {
> >       case SCAN_SUCCEED:
> >               break;
> > +     case SCAN_PMD_NULL:
> >       case SCAN_PMD_NONE:
> >               /*
> >                * All pte entries have been removed and pmd cleared.
> > --
> > 2.50.1
> >
>

