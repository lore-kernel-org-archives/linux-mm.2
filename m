Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B165CCA0EE4
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 15:41:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CECE48E0012; Wed, 20 Aug 2025 11:41:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8BCC8E0003; Wed, 20 Aug 2025 11:41:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7A358E0012; Wed, 20 Aug 2025 11:41:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9FB3A8E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 11:41:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2029F1DC396
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 15:41:12 +0000 (UTC)
X-FDA: 83797549584.07.5653479
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id DF65C8000E
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 15:41:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VJrhIgTx;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755704470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UYSofwZAlBuy0oyzsu8d75QQkZFfweO09q+8sQkHcvo=;
	b=GHPzbtSJ6BiAkbe2HebuoV5b9p2XqLmRrAc8NuUZeHPTTgITZjC/ziX+wnQGw1HKLOZoVH
	0ZNPR+ujPRa/S8KTT7W9jzaaUw7UlVOOtS6czOw8fDn7IYogCCADHODpyhauomnLh71t20
	fAUvcLHXAOVHCqli8TS3FFjSlh6xycE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VJrhIgTx;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755704470; a=rsa-sha256;
	cv=none;
	b=j2Ekn4Qds1gBvldL35hrcL2os9LLajNZJwKa48J/FUcU5Xie5FzBSBHUwabrT1i6zRWHXF
	NSfop4FYN7Rhw/xPh3B0S1NaFc75p0059dTNaKnqHWY4LBQZrCoRoLKkaZr0jLUUqBZtoC
	HCwKpBzOly/WXofC1+GzBm3avcFdfN8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755704469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UYSofwZAlBuy0oyzsu8d75QQkZFfweO09q+8sQkHcvo=;
	b=VJrhIgTxaKnHGn6SuA3yMtKCSbV3OFEFjot6akqx56EB5kZdI3V+PSe/o2gPejjtQssWrx
	JV8OXESnhrXsAktm4G2Bk94sIXl6sTXEHpLeKIcXYyaBUmk1qB1dGvs2F/dLEsYWjaHAXJ
	6lpAcCVXamLUWpmwAKB6+GO16gjR2Jw=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-mcpI3qwsMCGWt6UjB1uDoQ-1; Wed, 20 Aug 2025 11:41:08 -0400
X-MC-Unique: mcpI3qwsMCGWt6UjB1uDoQ-1
X-Mimecast-MFC-AGG-ID: mcpI3qwsMCGWt6UjB1uDoQ_1755704468
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-e934e7eda88so4616063276.3
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:41:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755704467; x=1756309267;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UYSofwZAlBuy0oyzsu8d75QQkZFfweO09q+8sQkHcvo=;
        b=HhbXfMacKBNHA7aMI1oRl/+sFudYFyIZQJ3y27zTkzLpTVea4zg79gPYujv2O6ttFO
         +vOfoGySymFcE7VnbLUMADuJcT7raEv+3Frx6weeuSOhy1F7r6nhvxRCpZe0/qGYF22y
         +pnm+hvjyCxSf3JlB/IgzoMSgYMW6kEYtwg0OHCq3EszZNC/MhCrfxzUaoruDxf1yDi3
         KSTvxP0l4lHgHzGdDl8d1aP+aJU4QKJgxlVESMgEK7wAmivTTxjYSqH79bxQ3ymb1I/0
         CVIu3nWtSeyCwO9pRTuKOkH+GSfXudfiTSrztb+qke1L0CMK/fYsTb0TSH2QbFvl+2P+
         P8Cg==
X-Gm-Message-State: AOJu0Yx17oAehG7KdLUVYiUCIVSRCEkzc4sTbzJD0VCrOB5GMiqE0fPy
	QeFgekawitXbZ1CO+hcrFlSq0NqQPYGaU5WvnTieY4bt/HxdNSs8UoZJbVYC7uz6BwWYlgotgM0
	iPkIaRRcNfXjdwlH6ZwUO79cWbTQqh0IHJZQD1FmOiSf+8cFHy1evI4+9PSh8tmn88yyB1tLFtn
	kREp1Z6vEUak2pbaptieJBPeZj8io=
X-Gm-Gg: ASbGncuZgxqf78MauTxpXyyeeO+j09JEtDcA7Mf6/HB2bTudCLV+Uj4J05EVkNezSje
	BqLuFDfWta9vbe3l/t/pfEFzVxg/YJs1C6ygGjxdG/xI4ZtH5+KwX/ZKpccJDUSYwdNKX0frqUo
	azbyKqoW9BuqxdnusAaK8ddq0=
X-Received: by 2002:a05:6902:4a84:b0:e94:25a2:f8f5 with SMTP id 3f1490d57ef6-e94f6539a69mr3281678276.3.1755704467454;
        Wed, 20 Aug 2025 08:41:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHOTBrpkhP4lXt+J3rPPABO3gkD8lKSX5VfjJLDUErExXxnxu+nUSNzUqoP1cAU7FTl4VV3oeWsS3Y6s5hhVS4=
X-Received: by 2002:a05:6902:4a84:b0:e94:25a2:f8f5 with SMTP id
 3f1490d57ef6-e94f6539a69mr3281610276.3.1755704466967; Wed, 20 Aug 2025
 08:41:06 -0700 (PDT)
MIME-Version: 1.0
References: <20250819134205.622806-1-npache@redhat.com> <20250819134205.622806-4-npache@redhat.com>
 <cd4dd743-679f-4c55-9635-6d32e6fa5ff7@lucifer.local>
In-Reply-To: <cd4dd743-679f-4c55-9635-6d32e6fa5ff7@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Wed, 20 Aug 2025 09:40:40 -0600
X-Gm-Features: Ac12FXzD1K71b8kZ8iPzUj6lIyXHh5PjcoNqYYPU597Q2ZwJYp0jVWP2zrGYIjI
Message-ID: <CAA1CXcDORXqm4JoHn4ZSEhT3ajsuY2MAPwefMXk3+YMXcpvqkw@mail.gmail.com>
Subject: Re: [PATCH v10 03/13] khugepaged: generalize hugepage_vma_revalidate
 for mTHP support
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org, 
	willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com, 
	usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, 
	kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com, 
	anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de, 
	will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, 
	jglisse@google.com, surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6CVaNtsGiwiZtNAiSHT8yzBWKS1aWAbtiNdasA8zxfo_1755704468
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DF65C8000E
X-Stat-Signature: s1rxf13j4fsr8t97ze4qwbuhbu4yxnsg
X-Rspam-User: 
X-HE-Tag: 1755704469-671016
X-HE-Meta: U2FsdGVkX1+KdzGQh7zOwCgspbF8pw4geN4JHD+otkY9SnMTc56o6zEb6xsEvwm0r72lihVbotLDTqhNZP39HmPTPTSbK8oDtdzXVeer9VCSprz1w9lv3Z7enPRbKz68XActT1deWsJPsw/teBggsVSCqbYSHSoaU8D+r5ErCghsikME1DLJh2Y27oW3Vm9m/t/vtOgFcDJ5687Mq9kv1Knp+e4LQic/q5xFzdlBazDxHde3SmOPaqaOIe9r8HHb/wKtxPXGAcDbBLaHZ0hGaOfm2vB38f/Z81Ex9Hp51YY2CRM6HwhKY7BXyVvUZ3w0MZ9gsNy0EPREmAUG4t+B6queK3lziK09G1hALjfWi3pqmUVhiS10YLstg46B2TNMX0Q8T3dQdIOIB4c8OEgu71yoTqd5dHUWpN1yT5nM7jbJPppP/Ea779FIHBUboEo5uc26ylMtjs9hj8INbwYZDQT7323qfIjYZ8O1Q10JreuvWmzL614A6TQvtFYArQ8jYXPiOdmpicwmY/TcjHle74URE9xVoyV0+s10gGhfVz/1D0IG7wwXDFSRIhCeRUbxuL+8Ay5iD4mgRCADsD1W9uM2ZYUl1oTEeYLoCVYk2VUsIBWbtRq7Q0p31wy6z+cIQFLd9+I61fXXRQAZwr5llnt8ykCs/g/f+/QeitpOuamoVY66MomKhsY9P4ZTjsMVD/ZMRv9+2kz3i1Mm+Mc2FWm3OD7/HLqunpRi1tw+xJ95WOxVKqk0gY2WdLNB23YIMozd4RnKlooN5L2xoTqb6z4p+Cw6Qgp4NAokbqRUn55UZMNxZCrIFqDC8BUHUTybOPeJMPHGsKNMl4VppSHMfTJU0PPGe+4rT9uQYupdbm4p6c7MnwwZAXYmGKiPd4zRgf4MO6PHR6iJuYPoQcsqmVWnm2iQi10XgZ9cuMBBjjjGMS4VwFgAjyoyHySN68cAv1Ku/L6dffZoe1WTff8
 oFWFqyM0
 59s71gV5gq+/eNHM/vF6+6rpHp3y/80c29tQu9UQEHr9EcUrDJtQUHddcAWFQyNZchPNeHS1jJQq65NkYCfA8JqB7GV1MdHDLt+6UQYnpHV8pT3xvZayDeWdcFeYzqhfgiqimNeb8u84u37NcSZj/2fecgefbZxpiRAFR6pQWCkhDZAsImoOvsjYb9c2z5SHQxGWqmgrPufz5BDn/Xl6Q2sNm/fGIDfWmBvFoA2sVo9+xf9ISAwnj+06NgoSBzJYM4SPDUWb5nTDRbfDbZTdBtJTjXFLSilxiwubUIFcocaj3H7LOOEPFeEzcJ79Oclcsql6iH8xxeZsmA8k33WV1psSzzTRNA3fgLR6z3hYEMeSn64cFQbheKfv5yoLJKfym2XDD+RQhkQNQiRJrmjC0itLffX3IwwfV5VxmHcvVfFAfgwcyfkH3dzOVZolmKEB9TPIsREhqXke3orZ9UO+A6f/yCdRWaWOKiX7fP5pv98TOPITyzjFKoKJmMgb8QZIZbWQ/wjvroV5WzZ2KMxr93jtygluZ7ezn3LE2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 7:25=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Tue, Aug 19, 2025 at 07:41:55AM -0600, Nico Pache wrote:
> > For khugepaged to support different mTHP orders, we must generalize thi=
s
> > to check if the PMD is not shared by another VMA and the order is enabl=
ed.
> >
> > To ensure madvise_collapse can support working on mTHP orders without t=
he
> > PMD order enabled, we need to convert hugepage_vma_revalidate to take a
> > bitmap of orders.
> >
> > No functional change in this patch.
> >
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Co-developed-by: Dev Jain <dev.jain@arm.com>
> > Signed-off-by: Dev Jain <dev.jain@arm.com>
> > Signed-off-by: Nico Pache <npache@redhat.com>
>
> LGTM (modulo nit/query below) so:
>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Thanks :)
>
> > ---
> >  mm/khugepaged.c | 13 ++++++++-----
> >  1 file changed, 8 insertions(+), 5 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index b7b98aebb670..2d192ec961d2 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -917,7 +917,7 @@ static int collapse_find_target_node(struct collaps=
e_control *cc)
> >  static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long=
 address,
> >                                  bool expect_anon,
> >                                  struct vm_area_struct **vmap,
> > -                                struct collapse_control *cc)
> > +                                struct collapse_control *cc, unsigned =
long orders)
> >  {
> >       struct vm_area_struct *vma;
> >       enum tva_type type =3D cc->is_khugepaged ? TVA_KHUGEPAGED :
> > @@ -930,9 +930,10 @@ static int hugepage_vma_revalidate(struct mm_struc=
t *mm, unsigned long address,
> >       if (!vma)
> >               return SCAN_VMA_NULL;
> >
> > +     /* Always check the PMD order to insure its not shared by another=
 VMA */
>
> NIT: ensure not insure.
ack, ill fix that!
>
> >       if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
> >               return SCAN_ADDRESS_RANGE;
> > -     if (!thp_vma_allowable_order(vma, vma->vm_flags, type, PMD_ORDER)=
)
> > +     if (!thp_vma_allowable_orders(vma, vma->vm_flags, type, orders))
> >               return SCAN_VMA_CHECK;
> >       /*
> >        * Anon VMA expected, the address may be unmapped then
> > @@ -1134,7 +1135,8 @@ static int collapse_huge_page(struct mm_struct *m=
m, unsigned long address,
> >               goto out_nolock;
> >
> >       mmap_read_lock(mm);
> > -     result =3D hugepage_vma_revalidate(mm, address, true, &vma, cc);
> > +     result =3D hugepage_vma_revalidate(mm, address, true, &vma, cc,
> > +                                      BIT(HPAGE_PMD_ORDER));
>
> Shouldn't this be PMD order? Seems equivalent.
Yeah i'm actually not sure why we have both... they seem to be the
same thing, but perhaps there is some reason for having two...
>
> >       if (result !=3D SCAN_SUCCEED) {
> >               mmap_read_unlock(mm);
> >               goto out_nolock;
> > @@ -1168,7 +1170,8 @@ static int collapse_huge_page(struct mm_struct *m=
m, unsigned long address,
> >        * mmap_lock.
> >        */
> >       mmap_write_lock(mm);
> > -     result =3D hugepage_vma_revalidate(mm, address, true, &vma, cc);
> > +     result =3D hugepage_vma_revalidate(mm, address, true, &vma, cc,
> > +                                      BIT(HPAGE_PMD_ORDER));
> >       if (result !=3D SCAN_SUCCEED)
> >               goto out_up_write;
> >       /* check if the pmd is still valid */
> > @@ -2807,7 +2810,7 @@ int madvise_collapse(struct vm_area_struct *vma, =
unsigned long start,
> >                       mmap_read_lock(mm);
> >                       mmap_locked =3D true;
> >                       result =3D hugepage_vma_revalidate(mm, addr, fals=
e, &vma,
> > -                                                      cc);
> > +                                                      cc, BIT(HPAGE_PM=
D_ORDER));
> >                       if (result  !=3D SCAN_SUCCEED) {
> >                               last_fail =3D result;
> >                               goto out_nolock;
> > --
> > 2.50.1
> >
>


