Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4D53CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 19:33:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07F5B8E0009; Fri,  7 Nov 2025 14:33:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0570A8E0002; Fri,  7 Nov 2025 14:33:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAF578E0009; Fri,  7 Nov 2025 14:33:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D8ED38E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 14:33:44 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 84F4F594FE
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 19:33:44 +0000 (UTC)
X-FDA: 84084810768.01.0F99CF4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 24BC310000B
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 19:33:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZnlwQq+g;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762544022; a=rsa-sha256;
	cv=none;
	b=sei0/89lhBjucgUhukQTI/hxCQFhtuxhXcsBWd1WSsWT/NT/YilO1cjAZnrcF1Z97xgYCd
	+3mpmamWjbL5JcXm6uWStrC+4WLJpXf/Aa38QjLO4dYxoWD4Gtj/feq+aJg+Z/2OKfuVHU
	CygP7Zymte77QTVe3DinPs1ux8SF1Vk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZnlwQq+g;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762544022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=StDW+mFm4B1zB/6JzW+ZbuCOa9b6V2yTDmijVQpqjvk=;
	b=qLXX28cVAI8dXCYxjyS2aeUIdp/3h/9d4WziivrBThtxfc+JrgrjH9kIgd6mBKg790yrVU
	XVA7txNPOLf8haXgke0jQbthzJ4jjsIv37xzot7Wt6D5e5slEANjMm10Ynqse1EC89j7dF
	d2fTnez6+kk4dEwMmZ1IHIlvWUjH9q8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762544021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=StDW+mFm4B1zB/6JzW+ZbuCOa9b6V2yTDmijVQpqjvk=;
	b=ZnlwQq+gF3p1TrJ2ZYiHUellSdQiR9/ofHOIFbTSbFQLY/4QCEG2Z76pqf7jZpG4LCzeAM
	cls7c6WTx/R6cJIEH29/PPboDL2s1DPHLQXDi+xpUhPLav0nGJHjiB+LWPEm1zgIONlWEw
	+tGiKyyt1LFD0lE7ixcrjKbcvYWZpMw=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-299-REF3YVaBP8y0DGIExkgekg-1; Fri, 07 Nov 2025 14:33:40 -0500
X-MC-Unique: REF3YVaBP8y0DGIExkgekg-1
X-Mimecast-MFC-AGG-ID: REF3YVaBP8y0DGIExkgekg_1762544019
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-63e33859d16so1546916d50.2
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 11:33:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762544019; x=1763148819;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=StDW+mFm4B1zB/6JzW+ZbuCOa9b6V2yTDmijVQpqjvk=;
        b=gAHIcKY6DBq1HC9GP2HF56v74bVgS/WLHMblylzUorrVqgD3cflD44LOfO+aDYPohy
         4ErtRXAtJKe81f6GhBY78MHiarCfyJgHcSfV52TYyVBel9J5ITVw0TmwPWLCiS7IELxJ
         PSfSp+MtNTxvhcYDypmVqYvW3K0ty18DFMQOtzDkPEPOGIqNC4uHbkUpyD9qpE02NGsP
         +xJsLdH033shyWhSyJfSW/dgTxUi90cj6WJxmaGsI12Sd/ZpYfOsp+ufus085jO/WUNE
         d2YGT+MzUKf1GiP1m8R+oSkz41PRqP2tn4BJkq0dpjogaEk2SIXQMeaN6+eCCeUIDLSm
         MGYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCbYojDung9dDeLXZbBTnfi+rxbNgrItZ/0KJitG3Zfr8R9AMvCupREw4VRCVlZgjB1frAqyzcQQ==@kvack.org
X-Gm-Message-State: AOJu0Yw3z1ncOZPZu5lShEgnIU6gqx2HU5bnbJ8Pue/D6Dra3jLEHJ2/
	/nZMfI35DMfVVNZ70h/tJKApEAfC8smiL7Trt6fCkHLctQdli+jWFxzvQOXYGe+XENtPyJsHR/P
	wOYXRbr3IdAP+5lwcJ4cO38S889l0Oi8tjF+YyxGV/br/4vP5ZPi3b87GdeqSF7Fczxxnr3wuEb
	nDapPDfW59CfXL/kno8ITAa6d3HKc=
X-Gm-Gg: ASbGncsZPMnL++pHi0dHtvsIxUn6SdnfrG7NPneRzSCiwhaCnzepztfj9WDZlD48LvI
	EqNwn36HR985vV4X9NlDe0yQjk+zaEck+BrjtqpgPkGrFrOOn4jCy80NCJt87o9fXWVTsTF4i3b
	/UpBzMGXc6QcV+Rj5aajuJTLZ4ISZ5oreiSkp+pIzC3JfQlO5imKPpGBeH853EUAcQ2Oo7VQ==
X-Received: by 2002:a05:690c:6a86:b0:786:3ca8:6bd9 with SMTP id 00721157ae682-787d5352819mr9277877b3.4.1762544019257;
        Fri, 07 Nov 2025 11:33:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF/wePSCYoFiuPUYaG6vNEfVbvXaBDb4foa4OK6cvBklbOiXBfnlY9Qr/9YKRMaaxuGVocof8h7p00xVDVrnJE=
X-Received: by 2002:a05:690c:6a86:b0:786:3ca8:6bd9 with SMTP id
 00721157ae682-787d5352819mr9276887b3.4.1762544018681; Fri, 07 Nov 2025
 11:33:38 -0800 (PST)
MIME-Version: 1.0
References: <20251022183717.70829-1-npache@redhat.com> <20251022183717.70829-8-npache@redhat.com>
 <7b6b5c6b-0298-47c1-ae48-17d603401bac@lucifer.local>
In-Reply-To: <7b6b5c6b-0298-47c1-ae48-17d603401bac@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Fri, 7 Nov 2025 12:33:12 -0700
X-Gm-Features: AWmQ_bltE5rJ2Dc3Hgs0lQ2hBABm5R6HcCeN6L8-qACUELwbvrw1HYInXV8jcCk
Message-ID: <CAA1CXcBe2dApvHDXFNNUS0anuzMNh3N9cFQY4J3vs4hnfcq+7Q@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 07/15] khugepaged: generalize
 collapse_huge_page for mTHP collapse
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org, 
	peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com, 
	sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, kas@kernel.org, 
	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com, 
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org, 
	dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, jglisse@google.com, 
	surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com, 
	richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz, 
	rppt@kernel.org, jannh@google.com, pfalcato@suse.de
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vkYkHSIPvB5jnpONWIwDFdzCUzDNqWYLwIYK4UA1-CU_1762544019
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 24BC310000B
X-Rspamd-Server: rspam07
X-Stat-Signature: qudiy1ih6h9oyxuzyiutkbhuouunct1t
X-Rspam-User: 
X-HE-Tag: 1762544021-172904
X-HE-Meta: U2FsdGVkX1+7ZC0m5hh5EUqm+TLrSJRPgv23gMSxwH5pXKYz9HZOLuZdTmElSJ8sBWWu1f5dwEt/JnwzN+EyC12yGm0bKNURpHctb/kZMhrxccBAuqcpKpXxNYUeKCJZE4YIEq+35W9gE5IrHINtkeHQYRwXR6hnMmPooImYaMk68tVkyeQT/borryGpBtNxXd5tg9KhJrPC4bzL/enK8XyYigtJfvn57jv6V5GZCDti6ZrO5DRmLf8BRmXgq/ZkPkU6lPv3W4MC4qyfHdpJybu+gRaCdZoEHb9YtG/CS/KifbvbmsOhELLp/cV1nJX7rQBJcSu+4k8U8PvXF8+hnjNZ61w3TPYt4ZUdytaFDJl/Kw3Mi+WQzyQ5g2d0lIRHXqhxew0at+VBSb3+zPmyB4acgWKv5dmKJ9E2Qb9pnXg4gEj0CqXdKHwVLaJRl70E/wRsERNg4Q2xw80Mb9PcHO5bBW1sDyZJWlz5FKk4iJNo4FcWjkq5T1bZb2A1v8E8dc0PePUoF+TQe8wqFtPY/ij4i1bIrZwgov51SFOMVy4F8VKiV0Agas6/wruNR8pzf+qYjuLj3nd0lfwdmcmnviesZIHxDx3pf3PoVgCvMB4ydavFAIRwPABsb1ndsHTX9EYo+7z0IbAaGk4mops2wvKH6WbxN9Dxu5cT4ChNpWIld1nu7px7uRyDARfaLxZWy1GPqF8Ynfb3Nm4cYd7f9zisp0oQigePr+QRcAMhmS0U7m+AyP+lTUSG4+D79DQWAnXkvNINqEiMBFwxdLPonw9Rbr0+q7bN/IF6GRZQwuBXeYLKyu7uDXOFKzc5Omy27zH+XgVZQQQ9CgoV73QrtJKNxy3sGY/8ZDrvsa9H/Thxdp1h6QBO2oQZJoEBp+blqMXReccfl3rN6iIPRlO41HftjzpLBlj8tcalJM5uEdujuhnY1k022d3V15oj33H4B/XFl56zf3q+EXuCkJR
 i4p2Ji5v
 qSgGXSBXcBoC6rBrcCMN57zVlKG4ob3oVs6cxYd/QMP8RY9Du+DlJzjiJw6V98KldqsRs7u1tn+eEJVUqtYRq9lakKId2U+nvWOyXbf3cJd3cLOdaN051wza32lDlmW+++9zH9BIZLewdXHGSaJblCDZZkQEa9GuTMKVgk+F7jQg7tkSHv005nEwNsgIFVZLaea2tcScWqS1zJ/7K8jdUPa0CgUtBw++2OJ7EtrtqND7GTiPRWSpox8lIgV1XNlvb3h0vxNAcJYyg3BPb+ATMv6Z0/iNmtdMdCeWBLvZdOaUoD6aKIDWgRJqiO/m37W4nIs6mCXOetfV6zhBwnx2dwomYh6qK6tOMMIfi9QwWPU7FokPZpw1vI6Z9hC0r/0IromzFEXR1hrt1ysF1oW6tv4yZkLnqfXJLw2glJy8O3OX3PCIRscx+4D2Cqks6vHtYRoWM81+4NZxwaW4RcUgVOLf9lgpMGArZcMhCCnCOse7IqNPlgl6xXdssCpfW2dV1a58Hxg+W1MsQIJtW5lwPwnauDABfaNfW3v6L
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 6, 2025 at 11:15=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Oct 22, 2025 at 12:37:09PM -0600, Nico Pache wrote:
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
>
> NIT but is this -- a typo?

no its an em dash. I can replace it with a period if you'd like, but
both work in this context.

>
> > the mTHP case this is not true, and we must keep the lock to prevent
> > changes to the VMA from occurring.
> >
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >  mm/khugepaged.c | 108 ++++++++++++++++++++++++++++++------------------
> >  1 file changed, 67 insertions(+), 41 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 286c3a7afdee..75e7ebdccc36 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1142,43 +1142,50 @@ static int alloc_charge_folio(struct folio **fo=
liop, struct mm_struct *mm,
> >       return SCAN_SUCCEED;
> >  }
> >
> > -static int collapse_huge_page(struct mm_struct *mm, unsigned long addr=
ess,
> > -                           int referenced, int unmapped,
> > -                           struct collapse_control *cc)
> > +static int collapse_huge_page(struct mm_struct *mm, unsigned long pmd_=
address,
>
> Presumably pmd_address is the PMD-aligned address?
>
> > +             int referenced, int unmapped, struct collapse_control *cc=
,
> > +             bool *mmap_locked, unsigned int order, unsigned long offs=
et)
>
> It'd be nice to pass through a helper struct at this point having so many=
 params
> but perhaps we can deal with that in a follow up series.
>
> If PMD address is the PMD-aligned address, and mthp_address =3D pmd_addre=
ss +
> offset * PAGE_SIZE, couldn't we just pass in the mthp address and get the
> PMD address by aligning down to PMD size and reduce the number of args by
> 1?

Yeah that seems like a good idea. Thanks

>
> >  {
> >       LIST_HEAD(compound_pagelist);
> >       pmd_t *pmd, _pmd;
> > -     pte_t *pte;
> > +     pte_t *pte =3D NULL, mthp_pte;
>
> mthp_pte is only used in a single if () branch and can be declared there
> AFAICT?

ack!

>
> >       pgtable_t pgtable;
> >       struct folio *folio;
> >       spinlock_t *pmd_ptl, *pte_ptl;
> >       int result =3D SCAN_FAIL;
> >       struct vm_area_struct *vma;
> >       struct mmu_notifier_range range;
> > +     bool anon_vma_locked =3D false;
> > +     const unsigned long nr_pages =3D 1UL << order;
> > +     unsigned long mthp_address =3D pmd_address + offset * PAGE_SIZE;
>
> Do we ever update this? If not we can const-ify.

ack!

>
> >
> > -     VM_BUG_ON(address & ~HPAGE_PMD_MASK);
> > +     VM_BUG_ON(pmd_address & ~HPAGE_PMD_MASK);
>
> NIT: Be nice to convert this to a VM_WARN_ON_ONCE(), as VM_BUG_ON() is no=
t
> right here.
>
> >
> >       /*
> >        * Before allocating the hugepage, release the mmap_lock read loc=
k.
> >        * The allocation can take potentially a long time if it involves
> >        * sync compaction, and we do not need to hold the mmap_lock duri=
ng
> >        * that. We will recheck the vma after taking it again in write m=
ode.
> > +      * If collapsing mTHPs we may have already released the read_lock=
.
> >        */
> > -     mmap_read_unlock(mm);
> > +     if (*mmap_locked) {
> > +             mmap_read_unlock(mm);
> > +             *mmap_locked =3D false;
> > +     }
> >
> > -     result =3D alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
> > +     result =3D alloc_charge_folio(&folio, mm, cc, order);
> >       if (result !=3D SCAN_SUCCEED)
> >               goto out_nolock;
> >
> >       mmap_read_lock(mm);
> > -     result =3D hugepage_vma_revalidate(mm, address, true, &vma, cc,
> > -                                      HPAGE_PMD_ORDER);
> > +     *mmap_locked =3D true;
> > +     result =3D hugepage_vma_revalidate(mm, pmd_address, true, &vma, c=
c, order);
> >       if (result !=3D SCAN_SUCCEED) {
> >               mmap_read_unlock(mm);
>
> I don't really love the semantics of 'sometimes we set *mmap_locked false
> when we unlock, sometimes we rely on out_nolock doing it'.
>
> Let's just set it false when we unlock and VM_WARN_ON_ONCE(*mmap_locked) =
in
> out_nolock.

Ok that sounds like a good idea! thanks

>
> >               goto out_nolock;
> >       }
> >
> > -     result =3D find_pmd_or_thp_or_none(mm, address, &pmd);
> > +     result =3D find_pmd_or_thp_or_none(mm, pmd_address, &pmd);
> >       if (result !=3D SCAN_SUCCEED) {
> >               mmap_read_unlock(mm);
> >               goto out_nolock;
> > @@ -1190,13 +1197,14 @@ static int collapse_huge_page(struct mm_struct =
*mm, unsigned long address,
> >                * released when it fails. So we jump out_nolock directly=
 in
> >                * that case.  Continuing to collapse causes inconsistenc=
y.
> >                */
> > -             result =3D __collapse_huge_page_swapin(mm, vma, address, =
pmd,
> > -                                                  referenced, HPAGE_PM=
D_ORDER);
> > +             result =3D __collapse_huge_page_swapin(mm, vma, mthp_addr=
ess, pmd,
> > +                                                  referenced, order);
> >               if (result !=3D SCAN_SUCCEED)
> >                       goto out_nolock;
> >       }
> >
> >       mmap_read_unlock(mm);
> > +     *mmap_locked =3D false;
> >       /*
> >        * Prevent all access to pagetables with the exception of
> >        * gup_fast later handled by the ptep_clear_flush and the VM
> > @@ -1206,20 +1214,20 @@ static int collapse_huge_page(struct mm_struct =
*mm, unsigned long address,
> >        * mmap_lock.
> >        */
> >       mmap_write_lock(mm);
> > -     result =3D hugepage_vma_revalidate(mm, address, true, &vma, cc,
> > -                                      HPAGE_PMD_ORDER);
> > +     result =3D hugepage_vma_revalidate(mm, pmd_address, true, &vma, c=
c, order);
> >       if (result !=3D SCAN_SUCCEED)
> >               goto out_up_write;
> >       /* check if the pmd is still valid */
> >       vma_start_write(vma);
> > -     result =3D check_pmd_still_valid(mm, address, pmd);
> > +     result =3D check_pmd_still_valid(mm, pmd_address, pmd);
> >       if (result !=3D SCAN_SUCCEED)
> >               goto out_up_write;
> >
> >       anon_vma_lock_write(vma->anon_vma);
> > +     anon_vma_locked =3D true;
> >
> > -     mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
> > -                             address + HPAGE_PMD_SIZE);
> > +     mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, mthp_add=
ress,
> > +                             mthp_address + (PAGE_SIZE << order));
> >       mmu_notifier_invalidate_range_start(&range);
> >
> >       pmd_ptl =3D pmd_lock(mm, pmd); /* probably unnecessary */
> > @@ -1231,24 +1239,21 @@ static int collapse_huge_page(struct mm_struct =
*mm, unsigned long address,
> >        * Parallel GUP-fast is fine since GUP-fast will back off when
> >        * it detects PMD is changed.
> >        */
> > -     _pmd =3D pmdp_collapse_flush(vma, address, pmd);
> > +     _pmd =3D pmdp_collapse_flush(vma, pmd_address, pmd);
>
> Not your fault but so hate this _p** convention. One for a follow up I
> suppose.
>
> >       spin_unlock(pmd_ptl);
> >       mmu_notifier_invalidate_range_end(&range);
> >       tlb_remove_table_sync_one();
> >
> > -     pte =3D pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
> > +     pte =3D pte_offset_map_lock(mm, &_pmd, mthp_address, &pte_ptl);
> >       if (pte) {
> > -             result =3D __collapse_huge_page_isolate(vma, address, pte=
, cc,
> > -                                                   HPAGE_PMD_ORDER,
> > -                                                   &compound_pagelist)=
;
> > +             result =3D __collapse_huge_page_isolate(vma, mthp_address=
, pte, cc,
> > +                                                   order, &compound_pa=
gelist);
> >               spin_unlock(pte_ptl);
> >       } else {
> >               result =3D SCAN_PMD_NULL;
> >       }
> >
> >       if (unlikely(result !=3D SCAN_SUCCEED)) {
> > -             if (pte)
> > -                     pte_unmap(pte);
>
> OK I guess we drop this because it's handled in out_up_write. I assume no
> issue keeping PTE mapped here?

Correct, I dont think there are any issues here. The checks for pte
and anon_vma_locked in out_up_write should keep everything in order.

>
> >               spin_lock(pmd_ptl);
> >               BUG_ON(!pmd_none(*pmd));
> >               /*
> > @@ -1258,21 +1263,21 @@ static int collapse_huge_page(struct mm_struct =
*mm, unsigned long address,
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
> > +      * rmap can't run anymore. For mTHP collapse we must hold the loc=
k
> >        */
> > -     anon_vma_unlock_write(vma->anon_vma);
> > +     if (order =3D=3D HPAGE_PMD_ORDER) {
> > +             anon_vma_unlock_write(vma->anon_vma);
> > +             anon_vma_locked =3D false;
> > +     }
> >
> >       result =3D __collapse_huge_page_copy(pte, folio, pmd, _pmd,
> > -                                        vma, address, pte_ptl,
> > -                                        HPAGE_PMD_ORDER,
> > -                                        &compound_pagelist);
> > -     pte_unmap(pte);
> > +                                        vma, mthp_address, pte_ptl,
> > +                                        order, &compound_pagelist);
>
> Looking through __collapse_huge_page_copy() there doesn't seem to be any
> issue with holding anon lock here.
>
> >       if (unlikely(result !=3D SCAN_SUCCEED))
> >               goto out_up_write;
> >
> > @@ -1282,20 +1287,42 @@ static int collapse_huge_page(struct mm_struct =
*mm, unsigned long address,
> >        * write.
> >        */
> >       __folio_mark_uptodate(folio);
> > -     pgtable =3D pmd_pgtable(_pmd);
> > +     if (order =3D=3D HPAGE_PMD_ORDER) {
> > +             pgtable =3D pmd_pgtable(_pmd);
> >
> > -     spin_lock(pmd_ptl);
> > -     BUG_ON(!pmd_none(*pmd));
> > -     pgtable_trans_huge_deposit(mm, pmd, pgtable);
> > -     map_anon_folio_pmd_nopf(folio, pmd, vma, address);
> > -     spin_unlock(pmd_ptl);
> > +             spin_lock(pmd_ptl);
> > +             WARN_ON_ONCE(!pmd_none(*pmd));
> > +             pgtable_trans_huge_deposit(mm, pmd, pgtable);
> > +             map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_address);
> > +             spin_unlock(pmd_ptl);
> > +     } else { /* mTHP collapse */
>
> As per above, let's just declare mthp_pte here.

ack

>
> > +             mthp_pte =3D mk_pte(folio_page(folio, 0), vma->vm_page_pr=
ot);
>
> Hm, so we make a PTE that references the first page of the folio? I guess
> the folio will be an mTHP folio so we're just creating essentially a
>
> > +             mthp_pte =3D maybe_mkwrite(pte_mkdirty(mthp_pte), vma);
>
> In set_pte_range() we have a whole host of other checks like dirty,
> uffd_wp, etc. I wonder if we need to consider those?

I dont believe so because those checks are coming from fault handling.
Here we are doing almost the same thing that the PMD case was doing
with some influence from do_anonymous_page()

>
> > +
> > +             spin_lock(pmd_ptl);
>
> We're duplicating this in both branches, why not do outside if/else?

ack

>
> > +             WARN_ON_ONCE(!pmd_none(*pmd));
>
> Hmm so the PMD entry will still always be empty on mTHP collapse? Surely =
we
> could be collapsing more than one mTHP into an existing PTE table no? I m=
ay
> be missing something here/confused :)

We remove the PMD entry to ensure no GUP-fast call can operate on this PMD.

pmd_ptl =3D pmd_lock(mm, pmd); /* probably unnecessary */
/*
* This removes any huge TLB entry from the CPU so we won't allow
* huge and small TLB entries for the same virtual address to
* avoid the risk of CPU bugs in that area.
*
* Parallel GUP-fast is fine since GUP-fast will back off when
* it detects PMD is changed.
*/
_pmd =3D pmdp_collapse_flush(vma, pmd_address, pmd);

pmdp_collapse_flush removes the PMD
pmd =3D pmdp_huge_get_and_clear(vma->vm_mm, address, pmdp);

In the PMD case we install a new PMD, in the mTHP case (and in the
failure cases), we reinstall the same PMD once we are done/exit.

>
> > +             folio_ref_add(folio, nr_pages - 1);
>
> If we're setting the refcount here, where is the ref count being set in t=
he
> PMD path?

Both folios are initiated with a single ref. PMDs only need 1 ref,
while mTHPs need a ref for each PTE; hence why we increment by
nr_pages  - 1.

>
> > +             folio_add_new_anon_rmap(folio, vma, mthp_address, RMAP_EX=
CLUSIVE);
> > +             folio_add_lru_vma(folio, vma);
> > +             set_ptes(vma->vm_mm, mthp_address, pte, mthp_pte, nr_page=
s);
> > +             update_mmu_cache_range(NULL, vma, mthp_address, pte, nr_p=
ages);
>
> Prior to this change the only user of this are functions in memory.c, I
> do wonder if this is the wrong abstraction here.
>
> But maybe that's _yet another_ thing for a follow up (the THP code is a
> mess).

Yes, I tried to do something similar to the new
map_anon_folio_pmd_nopf, but it proved to be harder than expected. The
other cases that do similar operations all differ slightly so unifying
is going to be tricky/require more testing.

>
> > +
> > +             smp_wmb(); /* make PTEs visible before PMD. See c() */

>
> Feels like we could avoid open-coding this by just using pmd_install()?

The locking seems to differ which may make that tricky.

>
> Also are we therefore missing a mm_inc_nr_ptes() invocation here, or do w=
e
> update mm->pgtables_bytes elsewhere?

If I understand correctly, we already have accounted for the ptes when
we alloc'd them and their parent PMD. Since we are operating on an
already allocated PMD, I dont think we need to handle accounting for
PMD or mTHP collapse. Ill send some time confirming this before
posting.

>
>
> > +             pmd_populate(mm, pmd, pmd_pgtable(_pmd));
>
> Why are we referencing pmd in PMD branch and _pmd here?

I explained it a little more above, but we are reinstalling the
original PMD entry, which was removed for gup race reasons.

>
> > +             spin_unlock(pmd_ptl);
>
> The PMD case does this stuff in map_anon_pmd_nopf(), could we add one for
> mTHP?

Yes but I believe we should clean it up after. Unifying most of the
callers proved tricky.

>
> This function is already horribly overwrought (not your fault) so I'd lik=
e
> to avoid adding open-coded blocks as much as possible.
>
> > +     }
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
> > +     *mmap_locked =3D false;
>
> See above comment about setting this prior to jumping to out_nolock.

ack

Thanks for the reviews!
-- Nico

>
> >       if (folio)
> >               folio_put(folio);
> >       trace_mm_collapse_huge_page(mm, result =3D=3D SCAN_SUCCEED, resul=
t);
> > @@ -1463,9 +1490,8 @@ static int collapse_scan_pmd(struct mm_struct *mm=
,
> >       pte_unmap_unlock(pte, ptl);
> >       if (result =3D=3D SCAN_SUCCEED) {
> >               result =3D collapse_huge_page(mm, start_addr, referenced,
> > -                                         unmapped, cc);
> > -             /* collapse_huge_page will return with the mmap_lock rele=
ased */
> > -             *mmap_locked =3D false;
> > +                                         unmapped, cc, mmap_locked,
> > +                                         HPAGE_PMD_ORDER, 0);
> >       }
> >  out:
> >       trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
> > --
> > 2.51.0
> >
>


