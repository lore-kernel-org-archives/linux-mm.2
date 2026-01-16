Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 055D2C79FBF
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 14:28:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3124E6B0088; Fri, 16 Jan 2026 09:28:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F3796B0089; Fri, 16 Jan 2026 09:28:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EBC46B008A; Fri, 16 Jan 2026 09:28:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0CF166B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:28:50 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 61BAF138EEC
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:28:49 +0000 (UTC)
X-FDA: 84338058378.30.CAD60DF
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf15.hostedemail.com (Postfix) with ESMTP id B843EA000B
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:28:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XhTHhPJe;
	spf=pass (imf15.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768573727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oZMszV4Fo8yrNUR2DejJTxC4DKTXaJ4HLASWl15bV4E=;
	b=aXAjLE9qR96TI0aGa6Ahh/FRlSqo8FDzC5ZBCrGq8VUCLTpZnIOK9i9F38b6wdK2hBZexQ
	5YQmh7v9ZvXNO4lDS3CN9/93PSC1p9TJ6XrVmtdfO/xMHrLPMC2916j3EOzj+QAonNmpUA
	isMzqd5vZETS0Gs38tXxSn20fiKjoRY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XhTHhPJe;
	spf=pass (imf15.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768573727; a=rsa-sha256;
	cv=none;
	b=XaUK1o2n+StiCuIQWz2EAhPpTuymQPLsWq1K9GkugZbz8voFbTFKinH61cVjtxGsp3InhV
	TnuBcYtIlB06AfV38xgcfD3Ds5IHmnqoHaA1Z/uI+Uo2M0kXNL2uUZI7Xd7eAMUN4FsD8I
	a4wdn9NnrQrpeiQE3QV1XF7v1uKxeJE=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-502a407dabaso6448131cf.0
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 06:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768573727; x=1769178527; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oZMszV4Fo8yrNUR2DejJTxC4DKTXaJ4HLASWl15bV4E=;
        b=XhTHhPJeLlwdWFVAZf/vxcf/gzasb7cfNyzYifZ016GKspH1EAyh2lPwcPJEAHNYDG
         CJ87z6/d/N+svOKo1VgZcm+U1hz1h2VKa3Ue7bTgUuZqepeKLRDRrXsMwNWBVfAZ2zbg
         UaglbNzCuYz3sP9vneY/gffZ5u0O944vzR/RV7Kb5jb1KA8W/SKks862g08AvcaX0uZL
         0+9HYHRkB+HMsrKhRuEyhMkSVCNfl6PL1XcJOHKVUbOMkeI+uEck9yAdYsxbmYrGhcJP
         gWEA+CQ6CRYoqYL1ym6yRa00nlndstZBnwKMZ+52cmlDLM0zlXHktH/KsVUzNfh0YNEK
         UHmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768573727; x=1769178527;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oZMszV4Fo8yrNUR2DejJTxC4DKTXaJ4HLASWl15bV4E=;
        b=TFWZ3Y1DrZwbSecEsb4bW73KC7u1ATd7s1qs+lg3baZxTL1ZkldlZX69JTojacGtvB
         PeBOGtUTNfiRBemn7yLztUBG6bKf1hkYd86cbIGecRrNu98U0iniu1h3GHxK6flOlrkx
         NmlYEubAhsHHbSjINYeZDoTyiMwXYC7jeHI05ny9OnlTVo/wRUdZSWs847Ei3bNti9Lf
         P2MyXNGoOfMBuZe2FWquMtjI3zfGMmeEMX4b2x0syqW50pT2XwJT/UuHStcYyBgQChIP
         PD5D8Nd4cTgoxC5CyxsmAcVVfqKEJCm84Hjd8o+ugvFDSjo7Ue94znj6NZ4d+/xv38uo
         S/pg==
X-Forwarded-Encrypted: i=1; AJvYcCUhmtoPfyZjHPrdXILd0uFS2x9D8zSumi6AevN/PJfiQTz/j5ilCilGkoTXwdZsFXXSir8WFfxLMA==@kvack.org
X-Gm-Message-State: AOJu0YzBWQszwPPPqTNXIn3P2DWKGtIRGdlVP1nPt3IsouQs2dYg39VK
	aZcIC+icfsPc9jhpYnmNVkubBohmAvQxP0WBxGDkP9BH3kClIBUHT7AIqDumZz1jC5yZB2uqAoQ
	a9e37Yexrc3g4agiVRBzFMU6wT7Bqd10=
X-Gm-Gg: AY/fxX6c7LutFZLVHF3BgQD4QAE0yKSorT2UV8SetT+YlhyE3gzHiY3GX6OG6nlMIFA
	DurLRnqziUw10H1V08Y7B2s/FXE2J3nKW0bprlYVpuXWrrceaANwWatI3/TbPErGrr+Qf2DPxpW
	0qEG9PovPP3o+tknGZPRIOrC/e3sDxnl1AN9LFFjaXCb957EmbjK1mFcFiTY5rBUDn1S2NEnd7t
	Fz2YrwLY8EGJQbinVybFZXtWRhEl8YGI/ux56WQsW8koJtJsdAJHpRLRgUzwcX3ADySYznO9w==
X-Received: by 2002:a05:622a:1a8d:b0:501:4ca3:7420 with SMTP id
 d75a77b69052e-502a163bfcamr48413821cf.36.1768573726346; Fri, 16 Jan 2026
 06:28:46 -0800 (PST)
MIME-Version: 1.0
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
 <20260106132203.kdxfvootlkxzex2l@master> <CAGsJ_4yKRtyADU2ZxUMgvqdrhAEL4SpZxCMRt28gNJfUf--5zQ@mail.gmail.com>
 <20260107014601.dxvq6b7ljgxwg7iu@master> <db4d0a19-598b-48ff-accc-f5940a481035@arm.com>
In-Reply-To: <db4d0a19-598b-48ff-accc-f5940a481035@arm.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 16 Jan 2026 22:28:35 +0800
X-Gm-Features: AZwV_QhAYlc9A1PxMbnzWgj5BABlaY8S87UmSa5kP3_oO1pH5nag-DoPjw1j2qU
Message-ID: <CAGsJ_4yo-EE__1VzHqxE8ehDOFQuxqP9GXcskkeZ-WTTyz12_A@mail.gmail.com>
Subject: Re: [PATCH v5 5/5] mm: rmap: support batched unmapping for file large folios
To: Dev Jain <dev.jain@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com, 
	will@kernel.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com, 
	willy@infradead.org, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B843EA000B
X-Stat-Signature: dkk5gcg63d3c1ujhzqqufcybh5uzaas1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768573727-20352
X-HE-Meta: U2FsdGVkX1/FhZ4232FVgQt/d/mUu9/r85vtQ9mEDegoyVzeLvdwOXr58FdRvD0fGNJEeijxc38nq641IeIxMYI2VTarnljPUnYkIFBt+i3BlYESONPrg6h7Hrf8y6T0mxklJAMY2/or1uSr/4GA+pI0SnOWAyFpcDCy8c16+G9ehezlSCK5BAs/4gNkcvDLRvBPFM2bfd0mflxEQG+MbEIMYhl7OeCiDvjbWqsVj8qy+wR/SjPrRy7GbzUGJhY9YN+J6XVwCSIPmlPqWCiz5HrGsJEjE2EdHYzmaVcYPzNBLc33YzcGr/HiWmm/f2ihOa/lxgb03kg1kmyRGuluR0PdtB1a+q6i4OBTOhn25yS30DRJcoYniArOk9fs/mxpf1jh5QhPuSEHtW1OotIM7jUtKHYXYfxNkDwc+zZraEGdiPSf+2rg5IdIvj/7YddGrbDZ4ntWphq3x/QAL72WeteCpB1eQJH3jJVAWiYR14nALA/9PuZESo9JGjiZcdVYkb/0vO3+olU4qUdEKziOvo51ITKikvGU70d9O0/h4j1s0TAPOv5KicZES2Z9UzmEBSaLdIVsEbBRUjFfEK0EQeg8t+dnxwr5ffA4eC/Gxg1lf3Ls6C1ZV/RwRaAv3vcopephTxxy1XBBKl4a6SBr1R5Rrrz3+9j1ynVrukNaRNAJi1qJmSVBeMjhCrDI2sB2TutITq4WiqpLAEOcLYNeadoYEFqApD8E44I4AQHBp0Nh/J4tK2BblwDvTv62qRM41ui6N1U/NFcnmf9ykRRbKq5R/Wvl/cLRlQKhXgyF6PHavLeaC12Iqk6UiZQRy8gU+oNSZ/CqIVXPFJsIyP6Tdfc9stluV5xSctWvqcGf4C9gG992nhslK7ScFbSWqLRMuQrIJTdivj5eD5SZgTP+f+jjhNJYIftBZUpnAC/HB4rUlr8ycSmpq2w+U72xRwjNmWplw/UJbypGpBTIPTO
 rt7kH8bj
 NVZFAApqsO5/z678as3kALTD66zUlkVPLl5TCQ6v6Ws+PsoSKgYIZ+LdnnXzs40k6a4UtZ33BriTLnOzEasoSuZWjgw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 5:53=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
>
> On 07/01/26 7:16 am, Wei Yang wrote:
> > On Wed, Jan 07, 2026 at 10:29:25AM +1300, Barry Song wrote:
> >> On Wed, Jan 7, 2026 at 2:22=E2=80=AFAM Wei Yang <richard.weiyang@gmail=
.com> wrote:
> >>> On Fri, Dec 26, 2025 at 02:07:59PM +0800, Baolin Wang wrote:
> >>>> Similar to folio_referenced_one(), we can apply batched unmapping fo=
r file
> >>>> large folios to optimize the performance of file folios reclamation.
> >>>>
> >>>> Barry previously implemented batched unmapping for lazyfree anonymou=
s large
> >>>> folios[1] and did not further optimize anonymous large folios or fil=
e-backed
> >>>> large folios at that stage. As for file-backed large folios, the bat=
ched
> >>>> unmapping support is relatively straightforward, as we only need to =
clear
> >>>> the consecutive (present) PTE entries for file-backed large folios.
> >>>>
> >>>> Performance testing:
> >>>> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, =
and try to
> >>>> reclaim 8G file-backed folios via the memory.reclaim interface. I ca=
n observe
> >>>> 75% performance improvement on my Arm64 32-core server (and 50%+ imp=
rovement
> >>>> on my X86 machine) with this patch.
> >>>>
> >>>> W/o patch:
> >>>> real    0m1.018s
> >>>> user    0m0.000s
> >>>> sys     0m1.018s
> >>>>
> >>>> W/ patch:
> >>>> real   0m0.249s
> >>>> user   0m0.000s
> >>>> sys    0m0.249s
> >>>>
> >>>> [1] https://lore.kernel.org/all/20250214093015.51024-4-21cnbao@gmail=
.com/T/#u
> >>>> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> >>>> Acked-by: Barry Song <baohua@kernel.org>
> >>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> >>>> ---
> >>>> mm/rmap.c | 7 ++++---
> >>>> 1 file changed, 4 insertions(+), 3 deletions(-)
> >>>>
> >>>> diff --git a/mm/rmap.c b/mm/rmap.c
> >>>> index 985ab0b085ba..e1d16003c514 100644
> >>>> --- a/mm/rmap.c
> >>>> +++ b/mm/rmap.c
> >>>> @@ -1863,9 +1863,10 @@ static inline unsigned int folio_unmap_pte_ba=
tch(struct folio *folio,
> >>>>       end_addr =3D pmd_addr_end(addr, vma->vm_end);
> >>>>       max_nr =3D (end_addr - addr) >> PAGE_SHIFT;
> >>>>
> >>>> -      /* We only support lazyfree batching for now ... */
> >>>> -      if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
> >>>> +      /* We only support lazyfree or file folios batching for now .=
.. */
> >>>> +      if (folio_test_anon(folio) && folio_test_swapbacked(folio))
> >>>>               return 1;
> >>>> +
> >>>>       if (pte_unused(pte))
> >>>>               return 1;
> >>>>
> >>>> @@ -2231,7 +2232,7 @@ static bool try_to_unmap_one(struct folio *fol=
io, struct vm_area_struct *vma,
> >>>>                        *
> >>>>                        * See Documentation/mm/mmu_notifier.rst
> >>>>                        */
> >>>> -                      dec_mm_counter(mm, mm_counter_file(folio));
> >>>> +                      add_mm_counter(mm, mm_counter_file(folio), -n=
r_pages);
> >>>>               }
> >>>> discard:
> >>>>               if (unlikely(folio_test_hugetlb(folio))) {
> >>>> --
> >>>> 2.47.3
> >>>>
> >>> Hi, Baolin
> >>>
> >>> When reading your patch, I come up one small question.
> >>>
> >>> Current try_to_unmap_one() has following structure:
> >>>
> >>>     try_to_unmap_one()
> >>>         while (page_vma_mapped_walk(&pvmw)) {
> >>>             nr_pages =3D folio_unmap_pte_batch()
> >>>
> >>>             if (nr_pages =3D folio_nr_pages(folio))
> >>>                 goto walk_done;
> >>>         }
> >>>
> >>> I am thinking what if nr_pages > 1 but nr_pages !=3D folio_nr_pages()=
.
> >>>
> >>> If my understanding is correct, page_vma_mapped_walk() would start fr=
om
> >>> (pvmw->address + PAGE_SIZE) in next iteration, but we have already cl=
eared to
> >>> (pvmw->address + nr_pages * PAGE_SIZE), right?
> >>>
> >>> Not sure my understanding is correct, if so do we have some reason no=
t to
> >>> skip the cleared range?
> >> I don=E2=80=99t quite understand your question. For nr_pages > 1 but n=
ot equal
> >> to nr_pages, page_vma_mapped_walk will skip the nr_pages - 1 PTEs insi=
de.
> >>
> >> take a look:
> >>
> >> next_pte:
> >>                do {
> >>                        pvmw->address +=3D PAGE_SIZE;
> >>                        if (pvmw->address >=3D end)
> >>                                return not_found(pvmw);
> >>                        /* Did we cross page table boundary? */
> >>                        if ((pvmw->address & (PMD_SIZE - PAGE_SIZE)) =
=3D=3D 0) {
> >>                                if (pvmw->ptl) {
> >>                                        spin_unlock(pvmw->ptl);
> >>                                        pvmw->ptl =3D NULL;
> >>                                }
> >>                                pte_unmap(pvmw->pte);
> >>                                pvmw->pte =3D NULL;
> >>                                pvmw->flags |=3D PVMW_PGTABLE_CROSSED;
> >>                                goto restart;
> >>                        }
> >>                        pvmw->pte++;
> >>                } while (pte_none(ptep_get(pvmw->pte)));
> >>
> > Yes, we do it in page_vma_mapped_walk() now. Since they are pte_none(),=
 they
> > will be skipped.
> >
> > I mean maybe we can skip it in try_to_unmap_one(), for example:
> >
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index 9e5bd4834481..ea1afec7c802 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -2250,6 +2250,10 @@ static bool try_to_unmap_one(struct folio *folio=
, struct vm_area_struct *vma,
> >                */
> >               if (nr_pages =3D=3D folio_nr_pages(folio))
> >                       goto walk_done;
> > +             else {
> > +                     pvmw.address +=3D PAGE_SIZE * (nr_pages - 1);
> > +                     pvmw.pte +=3D nr_pages - 1;
> > +             }
> >               continue;
> >  walk_abort:
> >               ret =3D false;
>
> I am of the opinion that we should do something like this. In the interna=
l pvmw code,

I am still not convinced that skipping PTEs in try_to_unmap_one()
is the right place. If we really want to skip certain PTEs early,
should we instead hint page_vma_mapped_walk()? That said, I don't
see much value in doing so, since in most cases nr is either 1 or
folio_nr_pages(folio).

> we keep skipping ptes till the ptes are none. With my proposed uffd-fix [=
1], if the old
> ptes were uffd-wp armed, pte_install_uffd_wp_if_needed will convert all p=
tes from none
> to not none, and we will lose the batching effect. I also plan to extend =
support to
> anonymous folios (therefore generalizing for all types of memory) which w=
ill set a
> batch of ptes as swap, and the internal pvmw code won't be able to skip t=
hrough the
> batch.

Thanks for catching this, Dev. I already filter out some of the more
complex cases, for example:
if (pte_unused(pte))
        return 1;

Since the userfaultfd write-protection case is also a corner case,
could we filter it out as well?

diff --git a/mm/rmap.c b/mm/rmap.c
index c86f1135222b..6bb8ba6f046e 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1870,6 +1870,9 @@ static inline unsigned int
folio_unmap_pte_batch(struct folio *folio,
        if (pte_unused(pte))
                return 1;

+       if (userfaultfd_wp(vma))
+               return 1;
+
        return folio_pte_batch(folio, pvmw->pte, pte, max_nr);
}

Just offering a second option =E2=80=94 yours is probably better.

Thanks
Barry

