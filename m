Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56D99CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 12:45:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60D486B008A; Thu,  4 Jun 2026 08:45:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BDEE6B008C; Thu,  4 Jun 2026 08:45:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ACB96B0092; Thu,  4 Jun 2026 08:45:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 388766B008A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 08:45:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC374C2174
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:45:25 +0000 (UTC)
X-FDA: 84842201010.23.21DFEE9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1437940004
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:45:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DIR+y3YS;
	spf=pass (imf27.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780577123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9xUcbywLcE9NtRLDOc7hL0dY7/9kflpcYqqV0IQKR90=;
	b=CKr0Jnq150qXxFlg7sITueyUObvkI3o4L5wuK/A45uVnTQ/B4Z7+0dDERVrWfW+AYfm50f
	7T8Rj8Ia2Lsajyd07qsuuB+slI8TbpQQrKcYuTeCdqlUYjCodfQ6G98cR9887CEc2IBO7f
	fu7q+FuvaylHoWNGEwzib3+yj7DBNrg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DIR+y3YS;
	spf=pass (imf27.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780577123;
	b=ucaMz72EQ+XDoCJWJEZQhkFowoF4XOkok7d4PiA9VOM1JvhKwqSucryxWzbQv/g1DuZlEh
	IkzJD5rhnBHlY6xClEpov9gGyy5hJIpGTH4WNAghbr8mCEd01MY8VN1Gaei2p8qXIpJuGe
	YoLvEV8jWZxO4jRXcCJMDvZIW5i5oME=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780577122;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9xUcbywLcE9NtRLDOc7hL0dY7/9kflpcYqqV0IQKR90=;
	b=DIR+y3YSAtvzkYuseBN9v8COIRmg1tR+rjSZLPXdkn3jsWMQAUQh4j5Er4ddCBUGlzb4lq
	5+rPtq7ka1CiSZN4ZJuKwKi3mmjpnFmfjE8U+V53/vpW7UMXmpuDy06X2V2IG6AIXPEGhS
	i97DiTwEbhSrhkGqaQ7TO8dMrPwMdsY=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-hpcbyTn2Pha_coqXd6c_fQ-1; Thu, 04 Jun 2026 08:45:20 -0400
X-MC-Unique: hpcbyTn2Pha_coqXd6c_fQ-1
X-Mimecast-MFC-AGG-ID: hpcbyTn2Pha_coqXd6c_fQ_1780577119
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-660313cb3a3so823008d50.1
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 05:45:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780577119; x=1781181919;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9xUcbywLcE9NtRLDOc7hL0dY7/9kflpcYqqV0IQKR90=;
        b=MCmEOyTn9nC0AcWHwSCEJM/rRsFKWPQlV1rmXiKCBfIKS0jGvJH1dmzzawX0dt4muQ
         1zE1grhvtJBzOXuBmrjl0pmbD7ZlaKLYL6+kgz8UUt38cDJKU00gVmhLBv7koVErBbL0
         JlFGjT1uFHxqh5HvPyT/qhAnCLYw9bsOSQHrwz8RyBK3pgq1WlReK6uayRB9r2EStdgi
         w+6x2yv1przblu3JFO2WvxwqXUYgjIsVkRC3sKm6sjekBBSpha2b6LfQbCcgloTpZkSO
         glmn8tTmYtj/cDi6Qxf8Ap7B5m05fzvO0J+6Vlb6+HgcIqO+KDF1IjtnQK9fdlbN5vTK
         ux+g==
X-Forwarded-Encrypted: i=1; AFNElJ9q3km7/ZlXND99omady6UO9dh9DOPkGjdaAwN59/aXxPNX4mr5AO2fehS3M+RhsR0fceGa0DmpRw==@kvack.org
X-Gm-Message-State: AOJu0YzSjP3mYmTYTk2tBdVUbTfHdJcNrAITM61rJ4Jm05zUtT71F1iO
	CRfhtsvp5jgvmfEWJyuSrFRngCrwSB3cpNumDKNUHoDRi2zn3gk9eHda4iuOjCq17TUSsajLXEF
	lNDIEzkpd+cFYY/FC0s2OGTvSPgLzfzummnz8sUoT9PMqkTK5MTb24xt5XciWt59PETOML8fTTU
	2fhy9ykjKN04L5lsj1MZo4qtvyahI=
X-Gm-Gg: Acq92OFgDA+wZTjsvPPO0tAj1yYhXVVFAa/dfZc98hkPZeMTofW8ltzTy/qx0eZfsns
	QOHhMiWeeUGNbLJWi6X4uy3kKUgkWOKeYPo6eTCGq3duU7GwC32UK1Qf5S1iNV5+KIEQoo52ccC
	0J8wUXweN2HBjTP7hCI6+5eDFVZJ2hfE9WHvIlo+qU9oZD7PyM1cKZ+QVSg6plTybkpZcu1q8wU
	1O9f90lDzdnqVQ=
X-Received: by 2002:a05:690e:d5c:b0:660:a41d:d193 with SMTP id 956f58d0204a3-660dc2542a4mr6473966d50.33.1780577119408;
        Thu, 04 Jun 2026 05:45:19 -0700 (PDT)
X-Received: by 2002:a05:690e:d5c:b0:660:a41d:d193 with SMTP id
 956f58d0204a3-660dc2542a4mr6473930d50.33.1780577118704; Thu, 04 Jun 2026
 05:45:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260522150009.121603-1-npache@redhat.com> <20260522150009.121603-7-npache@redhat.com>
 <aiFTSLb0kkTR7I9A@lucifer> <aiFw80oLty6F_-8m@lucifer>
In-Reply-To: <aiFw80oLty6F_-8m@lucifer>
From: Nico Pache <npache@redhat.com>
Date: Thu, 4 Jun 2026 06:45:58 -0600
X-Gm-Features: AVHnY4LSO1OdqVIyL1dRF_W_uj5b-rkDdzIgCbEj_ORHLXIHBkb9A_fLOmITpQ8
Message-ID: <CAA1CXcDxZEmWtmGFiKDKSPSae8pN0at4vYV24FOs+t_GTGkZ6g@mail.gmail.com>
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
X-Mimecast-MFC-PROC-ID: jQMMfUJ58EOY3iO6S4LFHBpXXRqNfT4HCDAZg-bqoJY_1780577119
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1437940004
X-Stat-Signature: 6q71bg5ad6kaffhssjot13nxcwtzx566
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780577122-132430
X-HE-Meta: U2FsdGVkX19tMiOFYQ0fjZQckAEiBJO/6wFw819txn22Uv4xH5uJOVQIKswPPmdvC91JCyt4ZjmsNIw+uRMYi8CoKyGf1PUB7B2RxG5gHbdVkNBKEpdJOyjgeidUH0xpUEMby5b3PeNSk5duCNALzd8gSC6WUCgwLbZCnvP3f9aMf6zxZxxyYEKF4pLXHOQymQwMpu8T0YgiQOUwfeX9wedRChzNCzR1myYz05OfVj+HHYYkVvMdfzZUFjQTPWBOJE0OFx7Nq5nVPdCDenrmBalroQH3EYqY8dJ+F6+i0228mxPNQpsd+BUWHaKGSNYquJzHwaRZsXvMfCUI3X4mChDvL19KCdMteUwWQ9DM2oQTjZ2Iv4NrLJzpiNJFkTywFOcU7vD/W2O+kZQ69RdMjiwDikZCQ/Dp6ClUh35EE67qC1ihUVhVIwYNZMHy+/rtpjeLLnMqE6mklSinPuN+0KbLcu341/lTvNNsOEb1cf0NeDpYZHYg6ei2FpqjNA3bKnOb6eY1B6/4Xhr0Hxj0aVZMNt5BYYrckxCvQA2J3KPZwOdfyCzA5EjcMv+zc1yg5l5r6Aayho0QRbJMd6mFtRjM6LqqA+aEM9nZwOVLZL17RdwGI7iwQhONU0PNZxkZJrf3+Of25Qg31l30TTMRLtcDWqigIS6EMhiBbqOjzoilZVQ+cVVrp72RhS7zhwugYGKR4GGoo1EloUMlTWVnXdE3dz32Cbemw9p/ChlZXt/IrggFuCMv4Clj3/Am7o9mnB52TrK6u82kCFPTNTa5YSahy14nRQKBUOD4VZ32uyWDwQbjrpjM8IbLdl4fkq16A/R2dspv1Z4Lmyhkgtlz2KP8qsXlf1b9WvyClCuPgoZmtDFFqct3Ci3jPoSXxUSyJa22H2qsdjWtn1E2Z6GePQjaKODrlwSDk7QkWyhIvjiz8cS2cBmjIrqU8hlCOAkTD9GK7JLTHbf1ZXBiXDs
 VZTl6D32
 4LCg+g4Obuz6XSrxFpLbtenueCS1g7IBmMY5YsrnDog7wybvVJq3ExcCS220ljOm1kQrBjNHHAPrvIv0FfVGGRCqzK2x7Aap2g/vzR+4zpPUD+ZV7n7x7xC4vhHx8oGwik63pHVu37oDQb9zuA2lxdfjFHHZtNERlyLTQ0baJ6rJlYXuQwzRWHzqLP2BcdXKzcX9gjTaJYWC5UXuXdmv9MyM6XJX+f9qKqSnjMuzGP5mNfi2BQ1ZwqZ8UGhyuoqyEeUdLE/cwe6aAv/pJ3R/JJo6F5i3j8GEfd3RXh5dKK8m0HBXHS/G6RKRC1Z/IqPrMptM4Ul+oPUGstvmxOa+bkQtcJssMLKm2bnvKojkSplZ0UHPomLIWra+lklgyVQoJ5wkmTZDLpZLjqAKXFzFPqT6Q5UI4GslvXWJEI/QKEV3L3SoggcXdOgPnZaozf9o+fFQtYFcB5/GS2MC7OsqTfH78HA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 4, 2026 at 6:40=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> wro=
te:
>
> On Thu, Jun 04, 2026 at 12:38:30PM +0100, Lorenzo Stoakes wrote:
> > I will go review the thread about the cache maintenance separately and
> > respond about that.
> >
> > On Fri, May 22, 2026 at 09:00:01AM -0600, Nico Pache wrote:
> > > Pass an order and offset to collapse_huge_page to support collapsing =
anon
> > > memory to arbitrary orders within a PMD. order indicates what mTHP si=
ze we
> > > are attempting to collapse to, and offset indicates were in the PMD t=
o
> > > start the collapse attempt.
> > >
> > > For non-PMD collapse we must leave the anon VMA write locked until af=
ter
> > > we collapse the mTHP-- in the PMD case all the pages are isolated, bu=
t in
> > > the mTHP case this is not true, and we must keep the lock to prevent
> > > access/changes to the page tables. This can happen if the rmap walker=
s hit
> > > a pmd_none while the PMD entry is currently unavailable due to being
> > > temporarily removed during the collapse phase.
> > >
> > > Acked-by: Usama Arif <usama.arif@linux.dev>
> > > Signed-off-by: Nico Pache <npache@redhat.com>
> >
> > The logic LGTM generally, some questions for understanding below, and o=
f
> > course as per above I want to review the Lance/David subthread.
> >
> > Thanks!
> >
> > > ---
> > >  mm/khugepaged.c | 93 +++++++++++++++++++++++++++++------------------=
--
> > >  1 file changed, 55 insertions(+), 38 deletions(-)
> > >
> > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > index fab35d318641..d64f42f66236 100644
> > > --- a/mm/khugepaged.c
> > > +++ b/mm/khugepaged.c
> > > @@ -1214,34 +1214,36 @@ static enum scan_result alloc_charge_folio(st=
ruct folio **foliop, struct mm_stru
> > >   * while allocating a THP, as that could trigger direct reclaim/comp=
action.
> > >   * Note that the VMA must be rechecked after grabbing the mmap_lock =
again.
> > >   */
> > > -static enum scan_result collapse_huge_page(struct mm_struct *mm, uns=
igned long address,
> > > -           int referenced, int unmapped, struct collapse_control *cc=
)
> > > +static enum scan_result collapse_huge_page(struct mm_struct *mm, uns=
igned long start_addr,
> > > +           int referenced, int unmapped, struct collapse_control *cc=
,
> > > +           unsigned int order)
> > >  {
> > > +   const unsigned long pmd_addr =3D start_addr & HPAGE_PMD_MASK;
> > > +   const unsigned long end_addr =3D start_addr + (PAGE_SIZE << order=
);
> > >     LIST_HEAD(compound_pagelist);
> > >     pmd_t *pmd, _pmd;
> > > -   pte_t *pte;
> > > +   pte_t *pte =3D NULL;
> >
> > As mentioned elsewhere for some reason this was dropped in
> > mm-unstable. Maybe a bad conflict resolution?
> >
> > >     pgtable_t pgtable;
> > >     struct folio *folio;
> > >     spinlock_t *pmd_ptl, *pte_ptl;
> > >     enum scan_result result =3D SCAN_FAIL;
> > >     struct vm_area_struct *vma;
> > >     struct mmu_notifier_range range;
> > > +   bool anon_vma_locked =3D false;
> > >
> > > -   VM_BUG_ON(address & ~HPAGE_PMD_MASK);
> > > -
> > > -   result =3D alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
> > > +   result =3D alloc_charge_folio(&folio, mm, cc, order);
> > >     if (result !=3D SCAN_SUCCEED)
> > >             goto out_nolock;
> > >
> > >     mmap_read_lock(mm);
> > > -   result =3D hugepage_vma_revalidate(mm, address, true, &vma, cc,
> > > -                                    HPAGE_PMD_ORDER);
> > > +   result =3D hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=3D=
*/ true,
> > > +                                    &vma, cc, order);
> > >     if (result !=3D SCAN_SUCCEED) {
> > >             mmap_read_unlock(mm);
> > >             goto out_nolock;
> > >     }
> > >
> > > -   result =3D find_pmd_or_thp_or_none(mm, address, &pmd);
> > > +   result =3D find_pmd_or_thp_or_none(mm, pmd_addr, &pmd);
> > >     if (result !=3D SCAN_SUCCEED) {
> > >             mmap_read_unlock(mm);
> > >             goto out_nolock;
> > > @@ -1253,8 +1255,8 @@ static enum scan_result collapse_huge_page(stru=
ct mm_struct *mm, unsigned long a
> > >              * released when it fails. So we jump out_nolock directly=
 in
> > >              * that case.  Continuing to collapse causes inconsistenc=
y.
> > >              */
> > > -           result =3D __collapse_huge_page_swapin(mm, vma, address, =
pmd,
> > > -                                                referenced, HPAGE_PM=
D_ORDER);
> > > +           result =3D __collapse_huge_page_swapin(mm, vma, start_add=
r, pmd,
> > > +                                                referenced, order);
> > >             if (result !=3D SCAN_SUCCEED)
> > >                     goto out_nolock;
> > >     }
> > > @@ -1269,20 +1271,21 @@ static enum scan_result collapse_huge_page(st=
ruct mm_struct *mm, unsigned long a
> > >      * mmap_lock.
> > >      */
> > >     mmap_write_lock(mm);
> > > -   result =3D hugepage_vma_revalidate(mm, address, true, &vma, cc,
> > > -                                    HPAGE_PMD_ORDER);
> > > +   result =3D hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=3D=
*/ true,
> > > +                                    &vma, cc, order);
> > >     if (result !=3D SCAN_SUCCEED)
> > >             goto out_up_write;
> > >     /* check if the pmd is still valid */
> > >     vma_start_write(vma);
>
> Hmm actually I think we have another problem here.
>
> For PMD THP this is fine. Only a single VMA can span the range we need, a=
nd it
> will span the entire PMD.
>
> But for mTHP we have an issue...
>
> See below...
>
> > > -   result =3D check_pmd_still_valid(mm, address, pmd);
> > > +   result =3D check_pmd_still_valid(mm, pmd_addr, pmd);
> > >     if (result !=3D SCAN_SUCCEED)
> > >             goto out_up_write;
> > >
> > >     anon_vma_lock_write(vma->anon_vma);
> > > +   anon_vma_locked =3D true;
> >
> > I worry that we hold this lock a lot longer now? Maybe the algorithmic
> > change alters that, but Claude did suggest on the s390 bug that longer =
lock
> > hold might be an issue.
> >
> > I wonder if we'll observe lock contention as a result?
> >
> > Correct me if I'm wrong and we're not holding longer than previously,
> > however. Just appears that we do.
> >
> > >
> > > -   mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
> > > -                           address + HPAGE_PMD_SIZE);
> > > +   mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, start_ad=
dr,
> > > +                           end_addr);
> > >     mmu_notifier_invalidate_range_start(&range);
> > >
> > >     pmd_ptl =3D pmd_lock(mm, pmd); /* probably unnecessary */
> > > @@ -1294,26 +1297,23 @@ static enum scan_result collapse_huge_page(st=
ruct mm_struct *mm, unsigned long a
> > >      * Parallel GUP-fast is fine since GUP-fast will back off when
> > >      * it detects PMD is changed.
> > >      */
> > > -   _pmd =3D pmdp_collapse_flush(vma, address, pmd);
> > > +   _pmd =3D pmdp_collapse_flush(vma, pmd_addr, pmd);
>
> ...So we exclude VMA locked faults faulting in a new PMD entry for PMD-si=
zed THP
> but for mTHP we might have _another_ VMA that spans another part of the r=
ange
> mapped by the same PMD entry.
>
> So we clear this, but we do not have a write lock on any other VMA, and s=
o
> racing VMA read locks can install a new PMD entry.
>
> > >     spin_unlock(pmd_ptl);
>
> Especially since you unlock this :)
>
> And...
>
> > >     mmu_notifier_invalidate_range_end(&range);
> > >     tlb_remove_table_sync_one();
> > >
> > > -   pte =3D pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
> > > +   pte =3D pte_offset_map_lock(mm, &_pmd, start_addr, &pte_ptl);
> > >     if (pte) {
> > > -           result =3D __collapse_huge_page_isolate(vma, address, pte=
, cc,
> > > -                                                 HPAGE_PMD_ORDER,
> > > -                                                 &compound_pagelist)=
;
> > > +           result =3D __collapse_huge_page_isolate(vma, start_addr, =
pte, cc,
> > > +                                                 order, &compound_pa=
gelist);
> > >             spin_unlock(pte_ptl);
> > >     } else {
> > >             result =3D SCAN_NO_PTE_TABLE;
> > >     }
> > >
> > >     if (unlikely(result !=3D SCAN_SUCCEED)) {
> > > -           if (pte)
> > > -                   pte_unmap(pte);
> >
> > OK I seem to remember this is because we're holding the anon_vma lock
> > longer. That does imply that on e.g. x86-64 the RCU lock is being held =
a
> > bit longer also as well as the anon_vma loc.
> >
> > I guess it's also because we need to hold anon_vma and pte lock because
> > we're fiddling around at PTE level for mTHP not just PMD level as 'clas=
sic'
> > THP did.
> >
> > (Rememberings going on here :)
> >
> > >             spin_lock(pmd_ptl);
> > > -           BUG_ON(!pmd_none(*pmd));
> > > +           WARN_ON_ONCE(!pmd_none(*pmd));
>
> ...this will get triggered.
>
> I don't know whether we can safely hold the PMD lock across everything he=
re for
> mTHP?
>
> Maybe the solution would have to be to scan through VMAs in the range of =
the PMD
> and VMA write lock each of them?

I believe we've spoken about this before, but because we always make
sure the VMA spans the full PMD we won't ever hit this issue. If we
wanted to support mTHP collapse on regions smaller than a PMD, the
locking gets tricky (hence the design choice to not do that for now).

This is handled by the HPAGE_ORDER in hugepage_vma_revalidate().

/* Always check the PMD order to ensure its not shared by another VMA */
if (!thp_vma_suitable_order(vma, address, PMD_ORDER))

-- Nico

>
> That could cause some 'interesting' lock contention issues though? Then a=
gain,
> we will be releasing the mmap write lock soon enough which will drop the =
VMA
> write locks.
>
> > >             /*
> > >              * We can only use set_pmd_at when establishing
> > >              * hugepmds and never for establishing regular pmds that
> > > @@ -1321,21 +1321,24 @@ static enum scan_result collapse_huge_page(st=
ruct mm_struct *mm, unsigned long a
> > >              */
> > >             pmd_populate(mm, pmd, pmd_pgtable(_pmd));
> > >             spin_unlock(pmd_ptl);
> > > -           anon_vma_unlock_write(vma->anon_vma);
> > >             goto out_up_write;
> > >     }
> > >
> > >     /*
> > > -    * All pages are isolated and locked so anon_vma rmap
> > > -    * can't run anymore.
> > > +    * For PMD collapse all pages are isolated and locked so anon_vma
> > > +    * rmap can't run anymore. For mTHP collapse the PMD entry has be=
en
> > > +    * removed and not all pages are isolated and locked, so we must =
hold
> >
> > Right because some PTE entries be unaffected by the change.
> >
> > > +    * the lock to prevent neighboring folios from attempting to acce=
ss
> > > +    * this PMD until its reinstalled.
> >
> > OK. This is slightly annoying for my CoW context work as it means there=
's
> > another case where we need to explicitly hold an anon_vma lock for
> > correctness :)
> >
> > Anyway I will think about that separately, is what it is. And in fact
> > motivates to want this merged earlier so I can work against it :)
> >
> >
> > >      */
> > > -   anon_vma_unlock_write(vma->anon_vma);
> > > +   if (is_pmd_order(order)) {
> > > +           anon_vma_unlock_write(vma->anon_vma);
> > > +           anon_vma_locked =3D false;
> > > +   }
> > >
> > >     result =3D __collapse_huge_page_copy(pte, folio, pmd, _pmd,
> > > -                                      vma, address, pte_ptl,
> > > -                                      HPAGE_PMD_ORDER,
> > > -                                      &compound_pagelist);
> > > -   pte_unmap(pte);
> > > +                                      vma, start_addr, pte_ptl,
> > > +                                      order, &compound_pagelist);
> > >     if (unlikely(result !=3D SCAN_SUCCEED))
> > >             goto out_up_write;
> > >
> > > @@ -1345,18 +1348,32 @@ static enum scan_result collapse_huge_page(st=
ruct mm_struct *mm, unsigned long a
> > >      * write.
> > >      */
> > >     __folio_mark_uptodate(folio);
> > > -   pgtable =3D pmd_pgtable(_pmd);
> > > -
> > >     spin_lock(pmd_ptl);
> > > -   BUG_ON(!pmd_none(*pmd));
> > > -   pgtable_trans_huge_deposit(mm, pmd, pgtable);
> > > -   map_anon_folio_pmd_nopf(folio, pmd, vma, address);
> > > +   WARN_ON_ONCE(!pmd_none(*pmd));
> > > +   if (is_pmd_order(order)) {
> > > +           pgtable =3D pmd_pgtable(_pmd);
> > > +           pgtable_trans_huge_deposit(mm, pmd, pgtable);
> > > +           map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
> > > +   } else {
> > > +           /*
> > > +            * set_ptes is called in map_anon_folio_pte_nopf with the
> > > +            * pmd_ptl lock still held; this is safe as the PMD is ex=
pected
> >
> > PMD entry you mean?
> >
> > > +            * to be none. The pmd entry is then repopulated below.
> > > +            */
> > > +           map_anon_folio_pte_nopf(folio, pte, vma, start_addr, /*uf=
fd_wp=3D*/ false);
> >
> > So here we populate entries in the existing PTE _table_ to point at the=
 new
> > order>0 folio? With arm64 of course doing transparent contpte stuff?
> >
> > > +           smp_wmb(); /* make PTEs visible before PMD. See pmd_insta=
ll() */
> > > +           pmd_populate(mm, pmd, pmd_pgtable(_pmd));
> >
> > And then we reinstall the pre-existing PMD _entry_ from none -> what it=
 was
> > before?
> >
> > > +   }
> > >     spin_unlock(pmd_ptl);
> > >
> > >     folio =3D NULL;
> > >
> > >     result =3D SCAN_SUCCEED;
> > >  out_up_write:
> > > +   if (anon_vma_locked)
> > > +           anon_vma_unlock_write(vma->anon_vma);
> > > +   if (pte)
> > > +           pte_unmap(pte);
> > >     mmap_write_unlock(mm);
> > >  out_nolock:
> > >     if (folio)
> > > @@ -1536,7 +1553,7 @@ static enum scan_result collapse_scan_pmd(struc=
t mm_struct *mm,
> > >             /* collapse_huge_page expects the lock to be dropped befo=
re calling */
> > >             mmap_read_unlock(mm);
> > >             result =3D collapse_huge_page(mm, start_addr, referenced,
> > > -                                       unmapped, cc);
> > > +                                       unmapped, cc, HPAGE_PMD_ORDER=
);
> > >             /* collapse_huge_page will return with the mmap_lock rele=
ased */
> > >             *lock_dropped =3D true;
> > >     }
> > > --
> > > 2.54.0
> > >
>
> Thanks, Lorenzo
>


