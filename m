Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCC43CD6E6B
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 10:31:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 320636B0005; Thu,  4 Jun 2026 06:31:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AF4F6B0088; Thu,  4 Jun 2026 06:31:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14CBC6B008A; Thu,  4 Jun 2026 06:31:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F29466B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 06:31:42 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9302B140674
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:31:42 +0000 (UTC)
X-FDA: 84841864044.09.6F8E892
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1EC4420007
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:31:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IKmVPG11;
	spf=pass (imf13.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780569100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ry2RAH1nnTLnDNPvMeq1MqX3u4M2pRx4NfdhrWpgps0=;
	b=AhU+kIlGGpmcUvs/NA8lfEQIl0bx4F6hc+U2N34TWXRoTkc8t+YbLUQ/hFtmOrPPAqqRd3
	goUVLZlFGybKn7GGX9xlR9Exvusav7e2f82xP3Z+bbyZIC8XDKvbFV1dK2t4c9PPWtYnAR
	dVNrNwLbu1mkwB6GSn9LuV4+64RE1cA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780569100;
	b=i9ivn0mTONu0BwKfg5Qi++wc5YShkLBFrsHcV1bMFqYb5Fcy7adtoETgqCgR7Roc91Pi1J
	w5OMe1oXMQWDGj0OTmM2BfLHrat29f8HeFhyzvxwLb294krPLTAVn4rUde07+mDwFHSNBX
	a1mf0ba80gX+ihVJSn+wHrrhkH2osrc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IKmVPG11;
	spf=pass (imf13.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780569099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ry2RAH1nnTLnDNPvMeq1MqX3u4M2pRx4NfdhrWpgps0=;
	b=IKmVPG11v7OJwaxrmr+CQ71+/SZZbO4vwAhdVJFQFhMnKwXAT4ZjiNT5NXEtNy5NpNRvLi
	kMd2IvexhRLbt6cEMO1l2MuSxRLygyinJ/Ij8tEMwoDE4yZ6M0ySByhVd4RwKbgSg8OdqV
	G6MDwLCQCvtxjbUPhTYEKhaSil3jPCo=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-75-mSR2MVVGP1OTBxjAoLoWYQ-1; Thu, 04 Jun 2026 06:31:38 -0400
X-MC-Unique: mSR2MVVGP1OTBxjAoLoWYQ-1
X-Mimecast-MFC-AGG-ID: mSR2MVVGP1OTBxjAoLoWYQ_1780569098
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-660575c74f1so872528d50.3
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 03:31:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780569098; x=1781173898;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ry2RAH1nnTLnDNPvMeq1MqX3u4M2pRx4NfdhrWpgps0=;
        b=j5wegzuNWLx0wFdTUtwRxSYHVHf57L5femwhKORokn1RjCw8dlz+udXBq66PwbHD85
         mDGPhHADZZP9tGgT07gUFwREk2HeD4Xq2tm71cUFn32uwnkvb9PjlWt78ry8OhMx4cD0
         0W67pUx/jASqVrLrNU7qEFz8ImbaztJ4UM8kv4zO5QbsC1wj+sC1YyFJtaGMDvmzQUFB
         12Mb/ZNO7VDVpnfg14p0Bkj6Opx5tBWuIZbIpAsC80IYDymWoKHhpzkknedUys7OyLY8
         28yZ2VcCGIF1Hf5rjDtyL+CpSMF5VgIPDGSzIwpVPqrdZtX3e9NTCzKHbwmQtdtCNf4l
         VTpg==
X-Forwarded-Encrypted: i=1; AFNElJ/2vo8FTntlkzWKNJ2+IayystIeHvpY4gB+N4Rcky9FZsxGwYdO3lPZOyvM+Cmz1Rj9paoOx7y9cg==@kvack.org
X-Gm-Message-State: AOJu0YwK5pNgfsZ6uB5pWKe4OTyJlixZ0lT/M8xLqLfztCJwHpLH8T+K
	qk9gW67GZzWchNBhJ5ZFt+noOfdxLgZNBAjmkMa1wXqQ1CuVKLMkOyCj1FhYzh5h62AjdpYtfBX
	oW8hFWT32xucw7/0WDmXsBbm8seDDUYN029XH0UfieXMWb/ZtH8xB0gRmGwFGisD4HJBRS5g8OG
	LLHXypIDP/FlmR49pNr06PIXe8c2Y=
X-Gm-Gg: Acq92OFyjgq29iC38/FXcgdMkAp5LoVwNmTqd//RvTD9iJRn8xlMx9jzfhDncJhCSwV
	hlsADxiwDR0+WPW0dyEVDObAzaWuoEuGA3EBeX8tpdD3vdXyIyqQBCUlXQ6txbRbfrtrh4hiRji
	p1gmJeRVJL1IHnj+VCvYjyaApGnHWgDD0f6hUGKodO+BN+a/LulPXPe/CjCRT8xkqcB3M+Hlp+X
	wLD8r1hcjnqmx8=
X-Received: by 2002:a53:ac83:0:b0:660:880f:d4b0 with SMTP id 956f58d0204a3-660f49d55c4mr1725179d50.56.1780569097746;
        Thu, 04 Jun 2026 03:31:37 -0700 (PDT)
X-Received: by 2002:a53:ac83:0:b0:660:880f:d4b0 with SMTP id
 956f58d0204a3-660f49d55c4mr1725133d50.56.1780569097167; Thu, 04 Jun 2026
 03:31:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260522150009.121603-1-npache@redhat.com> <20260522150009.121603-7-npache@redhat.com>
 <aiFRVb4zhrRw-yw5@lucifer>
In-Reply-To: <aiFRVb4zhrRw-yw5@lucifer>
From: Nico Pache <npache@redhat.com>
Date: Thu, 4 Jun 2026 04:32:19 -0600
X-Gm-Features: AVHnY4IasN5dY4BofdW7dhoPG6s7sJ9rykDUz6PyiZlc4_mG46f1W0wasrl_R-A
Message-ID: <CAA1CXcA+Ez3W5DS6bj9um6neB2Qc3-koCdSLH_pmfOCQSYs_5g@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v18 06/14] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, 
	joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, 
	liam@infradead.org, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, 
	rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org, 
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org, 
	rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com, Usama Arif <usama.arif@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hvjM8MWQ6paVrbprP36WSulcDBrhGTbBqofCB8K5Ugg_1780569098
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1EC4420007
X-Stat-Signature: ruei4s6qetsm66upnfquose4knphdsbk
X-HE-Tag: 1780569099-833945
X-HE-Meta: U2FsdGVkX1/39nXwk6Z3rRg0XHTYVHg051UTXXaU3w2hgfU5WXi2Edx9wTHTc5AXaX3Pd4QyUc6Jx49D2YKpv16TWfBnSSDJxbDk4jmTZT0ZP7/0M4KD1ttqHlENGt+lYxecQJpkFUDgfAeNxT3SolEfWOPhy/hNpgoa33U1kOa8hjpdjuAcFB7dAda+CsPV4kxlKyS73LHmAYKiblyy1vqjbUsU6e5tIkn+tTDRrxoQeGELG3FpIvfo3lAKx5/Y9ftBE3CWSLmaUt7fT6ZNgaS6cCRUvk5aqLwSvmLTyfUpZPRIKTavJ2E8A1/Ynt951jHefqksQpCMj9T99gC/g08arjxqdVhSokePg+eOOIomrbojgjNiz8XVMi6k+LqH1SwdyQKkMEONGoiblM0Vz/6VJTyjcB9VKglZ/T8hbqJQbLxz6pCKknZ/x3GeFM5IiCIU/NivwGgMsrG3tdrUYLte1iqg5QuyIhHjfQaeTNfz7x0iaG/YVtDwCiKDNITvdTTER1givj5B3Z52uuJfOW3HCVBx8IHASUwwQNudJEgwBTeMgLvrrUhejhMbYzGxNebh0LUmOls1bD2hE9QxbLJxR4FRMD20ujctrUFFvPj+Ig12tw06LDxF9xwayBZFiELWdI+lMWMb83oByd0WmzExkfwPkjdJ4a1SorS8TV3BQo33IBdSSirRHLX0AZVL6A1GwuC4UBXAxl33mg0xDsOhZhMTTmcoJQdyVPjX5yQu0LZ/qtc8ZZOGDwGg7yr+l6Y8210PGkrVNLjI6mK6ONChoOglor4VO996HYGl3yDTmxkbhVE+ijuudpDTPAaKiNZY7R1VEf28uLI4GPEhHSYSDbFoSPeQIDPJyCajZwZAswOnDo0CKipEeZ6Sy0pmCBQXTtk5Z0672DtFBL0nO8y8THQtF+LugEFt4c5n88RfndGNrr+98AORZPEQIJ57Fbb4+cdFsGu+hNLIvFx
 3owC7OoJ
 PoMSKmglBmmX/oh5+Cs2b5BhyJdFkwCgpi3tIPRYFAzCnzA7OGSbop7AhRjESIx20FVpXaXwaru7xOne5X/kIHJBggNgGdFCHA2xHaypT/JK6q91n8ElCQOHjzc/Pu9su1Vj8GTUtrsUR/hRsH6yc0QTyG9YbbX6wcWoPnc/qkzTUP4Y6gg+vJiVEYC7T38EDnbF5zeULjEBPQWY4LBJbt4+l6on5hJ5oN7jJ+KSjFE1yPDXrXGyefsx/SWVTCOlNqQO/dzq2hpKq8UHydUxcFedggQsRIQs8EepjzvR43eiQEQUuKvCwUKP/Dpz2TcfNy4W8olhKA77omqo+D5hCKK13Pw/NfdSu76zwQreTS+totSxtG+30ILyNeok1l+Ln6U7PI5+shRIymbxW11qRCKngNinVgQC+ezU3eTHrGXTRdAoRTTHnNyKe7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 4, 2026 at 4:22=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> wro=
te:
>
> On Fri, May 22, 2026 at 09:00:01AM -0600, Nico Pache wrote:
> > Pass an order and offset to collapse_huge_page to support collapsing an=
on
> > memory to arbitrary orders within a PMD. order indicates what mTHP size=
 we
> > are attempting to collapse to, and offset indicates were in the PMD to
> > start the collapse attempt.
> >
> > For non-PMD collapse we must leave the anon VMA write locked until afte=
r
> > we collapse the mTHP-- in the PMD case all the pages are isolated, but =
in
> > the mTHP case this is not true, and we must keep the lock to prevent
> > access/changes to the page tables. This can happen if the rmap walkers =
hit
> > a pmd_none while the PMD entry is currently unavailable due to being
> > temporarily removed during the collapse phase.
> >
> > Acked-by: Usama Arif <usama.arif@linux.dev>
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >  mm/khugepaged.c | 93 +++++++++++++++++++++++++++++--------------------
> >  1 file changed, 55 insertions(+), 38 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index fab35d318641..d64f42f66236 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1214,34 +1214,36 @@ static enum scan_result alloc_charge_folio(stru=
ct folio **foliop, struct mm_stru
> >   * while allocating a THP, as that could trigger direct reclaim/compac=
tion.
> >   * Note that the VMA must be rechecked after grabbing the mmap_lock ag=
ain.
> >   */
> > -static enum scan_result collapse_huge_page(struct mm_struct *mm, unsig=
ned long address,
> > -             int referenced, int unmapped, struct collapse_control *cc=
)
> > +static enum scan_result collapse_huge_page(struct mm_struct *mm, unsig=
ned long start_addr,
> > +             int referenced, int unmapped, struct collapse_control *cc=
,
> > +             unsigned int order)
> >  {
> > +     const unsigned long pmd_addr =3D start_addr & HPAGE_PMD_MASK;
> > +     const unsigned long end_addr =3D start_addr + (PAGE_SIZE << order=
);
> >       LIST_HEAD(compound_pagelist);
> >       pmd_t *pmd, _pmd;
> > -     pte_t *pte;
> > +     pte_t *pte =3D NULL;
>
> Hmm, this part of the patch wasn't taken, and now we have uninitialised s=
tate
> being dereferenced (see [0])

Good catch, I was just looking at your report and wondering what
happened there. Hopefully, with the v19 we apply this correctly :)

-- Nico

>
> [0]:https://lore.kernel.org/all/aiFO1RlpZ7Ki44y1@lucifer/
>
> Did a review comment here somehow cause this to be changed in the patch?
>
> Andrew - was there an error in applying the patch somehow?
>
> Thanks, Lorenzo
>
> >       pgtable_t pgtable;
> >       struct folio *folio;
> >       spinlock_t *pmd_ptl, *pte_ptl;
> >       enum scan_result result =3D SCAN_FAIL;
> >       struct vm_area_struct *vma;
> >       struct mmu_notifier_range range;
> > +     bool anon_vma_locked =3D false;
> >
> > -     VM_BUG_ON(address & ~HPAGE_PMD_MASK);
> > -
> > -     result =3D alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
> > +     result =3D alloc_charge_folio(&folio, mm, cc, order);
> >       if (result !=3D SCAN_SUCCEED)
> >               goto out_nolock;
> >
> >       mmap_read_lock(mm);
> > -     result =3D hugepage_vma_revalidate(mm, address, true, &vma, cc,
> > -                                      HPAGE_PMD_ORDER);
> > +     result =3D hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=3D=
*/ true,
> > +                                      &vma, cc, order);
> >       if (result !=3D SCAN_SUCCEED) {
> >               mmap_read_unlock(mm);
> >               goto out_nolock;
> >       }
> >
> > -     result =3D find_pmd_or_thp_or_none(mm, address, &pmd);
> > +     result =3D find_pmd_or_thp_or_none(mm, pmd_addr, &pmd);
> >       if (result !=3D SCAN_SUCCEED) {
> >               mmap_read_unlock(mm);
> >               goto out_nolock;
> > @@ -1253,8 +1255,8 @@ static enum scan_result collapse_huge_page(struct=
 mm_struct *mm, unsigned long a
> >                * released when it fails. So we jump out_nolock directly=
 in
> >                * that case.  Continuing to collapse causes inconsistenc=
y.
> >                */
> > -             result =3D __collapse_huge_page_swapin(mm, vma, address, =
pmd,
> > -                                                  referenced, HPAGE_PM=
D_ORDER);
> > +             result =3D __collapse_huge_page_swapin(mm, vma, start_add=
r, pmd,
> > +                                                  referenced, order);
> >               if (result !=3D SCAN_SUCCEED)
> >                       goto out_nolock;
> >       }
> > @@ -1269,20 +1271,21 @@ static enum scan_result collapse_huge_page(stru=
ct mm_struct *mm, unsigned long a
> >        * mmap_lock.
> >        */
> >       mmap_write_lock(mm);
> > -     result =3D hugepage_vma_revalidate(mm, address, true, &vma, cc,
> > -                                      HPAGE_PMD_ORDER);
> > +     result =3D hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=3D=
*/ true,
> > +                                      &vma, cc, order);
> >       if (result !=3D SCAN_SUCCEED)
> >               goto out_up_write;
> >       /* check if the pmd is still valid */
> >       vma_start_write(vma);
> > -     result =3D check_pmd_still_valid(mm, address, pmd);
> > +     result =3D check_pmd_still_valid(mm, pmd_addr, pmd);
> >       if (result !=3D SCAN_SUCCEED)
> >               goto out_up_write;
> >
> >       anon_vma_lock_write(vma->anon_vma);
> > +     anon_vma_locked =3D true;
> >
> > -     mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
> > -                             address + HPAGE_PMD_SIZE);
> > +     mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, start_ad=
dr,
> > +                             end_addr);
> >       mmu_notifier_invalidate_range_start(&range);
> >
> >       pmd_ptl =3D pmd_lock(mm, pmd); /* probably unnecessary */
> > @@ -1294,26 +1297,23 @@ static enum scan_result collapse_huge_page(stru=
ct mm_struct *mm, unsigned long a
> >        * Parallel GUP-fast is fine since GUP-fast will back off when
> >        * it detects PMD is changed.
> >        */
> > -     _pmd =3D pmdp_collapse_flush(vma, address, pmd);
> > +     _pmd =3D pmdp_collapse_flush(vma, pmd_addr, pmd);
> >       spin_unlock(pmd_ptl);
> >       mmu_notifier_invalidate_range_end(&range);
> >       tlb_remove_table_sync_one();
> >
> > -     pte =3D pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
> > +     pte =3D pte_offset_map_lock(mm, &_pmd, start_addr, &pte_ptl);
> >       if (pte) {
> > -             result =3D __collapse_huge_page_isolate(vma, address, pte=
, cc,
> > -                                                   HPAGE_PMD_ORDER,
> > -                                                   &compound_pagelist)=
;
> > +             result =3D __collapse_huge_page_isolate(vma, start_addr, =
pte, cc,
> > +                                                   order, &compound_pa=
gelist);
> >               spin_unlock(pte_ptl);
> >       } else {
> >               result =3D SCAN_NO_PTE_TABLE;
> >       }
> >
> >       if (unlikely(result !=3D SCAN_SUCCEED)) {
> > -             if (pte)
> > -                     pte_unmap(pte);
> >               spin_lock(pmd_ptl);
> > -             BUG_ON(!pmd_none(*pmd));
> > +             WARN_ON_ONCE(!pmd_none(*pmd));
> >               /*
> >                * We can only use set_pmd_at when establishing
> >                * hugepmds and never for establishing regular pmds that
> > @@ -1321,21 +1321,24 @@ static enum scan_result collapse_huge_page(stru=
ct mm_struct *mm, unsigned long a
> >                */
> >               pmd_populate(mm, pmd, pmd_pgtable(_pmd));
> >               spin_unlock(pmd_ptl);
> > -             anon_vma_unlock_write(vma->anon_vma);
> >               goto out_up_write;
> >       }
> >
> >       /*
> > -      * All pages are isolated and locked so anon_vma rmap
> > -      * can't run anymore.
> > +      * For PMD collapse all pages are isolated and locked so anon_vma
> > +      * rmap can't run anymore. For mTHP collapse the PMD entry has be=
en
> > +      * removed and not all pages are isolated and locked, so we must =
hold
> > +      * the lock to prevent neighboring folios from attempting to acce=
ss
> > +      * this PMD until its reinstalled.
> >        */
> > -     anon_vma_unlock_write(vma->anon_vma);
> > +     if (is_pmd_order(order)) {
> > +             anon_vma_unlock_write(vma->anon_vma);
> > +             anon_vma_locked =3D false;
> > +     }
> >
> >       result =3D __collapse_huge_page_copy(pte, folio, pmd, _pmd,
> > -                                        vma, address, pte_ptl,
> > -                                        HPAGE_PMD_ORDER,
> > -                                        &compound_pagelist);
> > -     pte_unmap(pte);
> > +                                        vma, start_addr, pte_ptl,
> > +                                        order, &compound_pagelist);
> >       if (unlikely(result !=3D SCAN_SUCCEED))
> >               goto out_up_write;
> >
> > @@ -1345,18 +1348,32 @@ static enum scan_result collapse_huge_page(stru=
ct mm_struct *mm, unsigned long a
> >        * write.
> >        */
> >       __folio_mark_uptodate(folio);
> > -     pgtable =3D pmd_pgtable(_pmd);
> > -
> >       spin_lock(pmd_ptl);
> > -     BUG_ON(!pmd_none(*pmd));
> > -     pgtable_trans_huge_deposit(mm, pmd, pgtable);
> > -     map_anon_folio_pmd_nopf(folio, pmd, vma, address);
> > +     WARN_ON_ONCE(!pmd_none(*pmd));
> > +     if (is_pmd_order(order)) {
> > +             pgtable =3D pmd_pgtable(_pmd);
> > +             pgtable_trans_huge_deposit(mm, pmd, pgtable);
> > +             map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
> > +     } else {
> > +             /*
> > +              * set_ptes is called in map_anon_folio_pte_nopf with the
> > +              * pmd_ptl lock still held; this is safe as the PMD is ex=
pected
> > +              * to be none. The pmd entry is then repopulated below.
> > +              */
> > +             map_anon_folio_pte_nopf(folio, pte, vma, start_addr, /*uf=
fd_wp=3D*/ false);
> > +             smp_wmb(); /* make PTEs visible before PMD. See pmd_insta=
ll() */
> > +             pmd_populate(mm, pmd, pmd_pgtable(_pmd));
> > +     }
> >       spin_unlock(pmd_ptl);
> >
> >       folio =3D NULL;
> >
> >       result =3D SCAN_SUCCEED;
> >  out_up_write:
> > +     if (anon_vma_locked)
> > +             anon_vma_unlock_write(vma->anon_vma);
> > +     if (pte)
> > +             pte_unmap(pte);
> >       mmap_write_unlock(mm);
> >  out_nolock:
> >       if (folio)
> > @@ -1536,7 +1553,7 @@ static enum scan_result collapse_scan_pmd(struct =
mm_struct *mm,
> >               /* collapse_huge_page expects the lock to be dropped befo=
re calling */
> >               mmap_read_unlock(mm);
> >               result =3D collapse_huge_page(mm, start_addr, referenced,
> > -                                         unmapped, cc);
> > +                                         unmapped, cc, HPAGE_PMD_ORDER=
);
> >               /* collapse_huge_page will return with the mmap_lock rele=
ased */
> >               *lock_dropped =3D true;
> >       }
> > --
> > 2.54.0
> >
>


