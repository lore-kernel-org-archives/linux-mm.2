Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68EB9CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 13:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF47F8E000F; Mon, 10 Nov 2025 08:20:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7DE28E0002; Mon, 10 Nov 2025 08:20:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1E748E000F; Mon, 10 Nov 2025 08:20:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86EC08E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:20:55 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4A60FC0D9C
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:20:55 +0000 (UTC)
X-FDA: 84094757670.29.C3F9995
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id C6D1C180016
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:20:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F0D4k2mx;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762780853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=urxiosn/NbwpEI7+7ewd9/gyn1msOWD8+3UzRaHmJoM=;
	b=4vjeWF5ygR39Np1sRueOcD2zKeo/bt7pgtEflXr1WR2bC75TartiR3+itO7OV/zPBXrgFa
	Cicf6weAlPvtZORKiFt/6O0rgip83i9GIWdSxnoijHCpobncGtQCKMm0XoDAo96vUqBVwb
	ftmTktYshGX7c1TUdGUl5AOGX3ZH1JQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762780853; a=rsa-sha256;
	cv=none;
	b=l0PLVnyKKkhYPpW8oveVEP+Mxs9gvIZzhJUVQoRO0uMHrzwnQZQAl3u6rXReYi6Lytx8S4
	IOYZ5gcJj9Yr4BAzS8gNTq66NEOrFqJflNx8QJhPbGJ2v2Z7JynedPAvz1NpVEIcdzBONe
	Tam1DEHS2mdhLTdOGdvPVADzL5Z1xvk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F0D4k2mx;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762780852;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=urxiosn/NbwpEI7+7ewd9/gyn1msOWD8+3UzRaHmJoM=;
	b=F0D4k2mxdGZW4lL1p2jCzy2edVteB9YD0rq2wQfxv/wsy39t7OOhp5/k0ekS+UuFGhcGJb
	zc+/As5reKLoBteGe/eNBztBNa0YS3N6m4JWnGVHpxvggQjVU41Ae8YEcCjFrLqlEzmfX9
	5lLcptPbPG6Ammr08dIEh+oPtrvRGrY=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-S_AWoD8bNOOsc7zkMB1pTg-1; Mon, 10 Nov 2025 08:20:49 -0500
X-MC-Unique: S_AWoD8bNOOsc7zkMB1pTg-1
X-Mimecast-MFC-AGG-ID: S_AWoD8bNOOsc7zkMB1pTg_1762780848
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-63e1d6438e0so960912d50.3
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:20:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762780848; x=1763385648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=urxiosn/NbwpEI7+7ewd9/gyn1msOWD8+3UzRaHmJoM=;
        b=G6SRpwC1lsj/RMLwPL45228pO13XmgytTmw/9svPvoaTfyNPJNzWk50+nXOV8H3Ixv
         9nQ/HxwE4Ni7e0mCK8ocO6/ZJTIIEjt5Nqbb/f1YRV182XrAlIQuL97EM7AQ5EQVas02
         Oi6K1/0c81PBd1Ha/6hwBDZRIx6m8NK//TjukGpqJfWhmkR0fDF/2+wyyOc+PAtuF3hX
         n0uqQPlTbVHrFZtkDgclFzwy9Ajl6IVfKi3uCHW+/XSAzyj9KoFL2lzUylgeEwuoi9Gu
         WhD60aUppP3gmuHqNk6+ldmiCZ0+UL74kozPkKbYPcaK7z2nXpgv01279cWemy19MGEH
         BHzA==
X-Forwarded-Encrypted: i=1; AJvYcCUsfT5z+764DTgaW8A/d36XqB6VVWiUSqK1FVCX8pBsjI/Z5cpAeLs168u3zjbrItDo9CmJbYriWg==@kvack.org
X-Gm-Message-State: AOJu0YxKMk6xQKdrOEWpISRG+IMtvjyTpJa9WCL95sRdWEdSFcjryrBZ
	gbnnUdjG0VuMG5Y9iXww48laumw5QGj8YtBeAVVrNeKGUfIeP8GsZpqpwykRR3ZlmzrQB1mHVzc
	4J56VeTuK6Into9wYvZD5ZeMQO2R34LDeUS2ghCyCLsVouAUijkp3Q35tf4YfnBkXmJZ6qZ4BGU
	D/N3liLZNN2OPLDIOoGYPSPyfTHuc=
X-Gm-Gg: ASbGncsUHZ4j2JCZUrdn8qQfVkB0SBji47POJNHdLg/3HXWJ14Bd7eIItQXCXM8LFyl
	47QsVSI/Bkseb1n3QCaBk1jtAClPPAPSMhCpdnK2BHkE5tx03rG3x5MAz5+m0zVm4uOK35PUnik
	/i+BQDHKJyzD0lRUj35Xdp8xSsinn1aigsD24WaP1JPgX35mLkaLFws6dDO3IxEmd5uTROqw==
X-Received: by 2002:a05:690e:4294:10b0:63e:2269:42eb with SMTP id 956f58d0204a3-640d45e44c7mr6043594d50.45.1762780848407;
        Mon, 10 Nov 2025 05:20:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHTRQESUUA3UUwtC2W4YtCmQg9mhvjmQTjoTx734yFEd98HC1RArMhT0g1T28Uas2i8mqc5JggC/bkNFhlknoM=
X-Received: by 2002:a05:690e:4294:10b0:63e:2269:42eb with SMTP id
 956f58d0204a3-640d45e44c7mr6043563d50.45.1762780847954; Mon, 10 Nov 2025
 05:20:47 -0800 (PST)
MIME-Version: 1.0
References: <20251022183717.70829-1-npache@redhat.com> <20251022183717.70829-6-npache@redhat.com>
 <c006138d-6d12-4f91-8a06-da279ae3795a@lucifer.local>
In-Reply-To: <c006138d-6d12-4f91-8a06-da279ae3795a@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Mon, 10 Nov 2025 06:20:21 -0700
X-Gm-Features: AWmQ_blTm6w8ib4f4NzgbzKAoQLgTz4lR-RJcVNY7GnUdXc1WfEKmfLTDuAagMs
Message-ID: <CAA1CXcBefDp4hzU6-jLf6XEWEaZaaX4SdCN0awxm1qz9RAWQFg@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 05/15] khugepaged: generalize
 __collapse_huge_page_* for mTHP support
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
X-Mimecast-MFC-PROC-ID: Bf4zzP3OHZGfU_LxbzJf2J6Yo18TW4ROeRmYfERzvEU_1762780848
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: C6D1C180016
X-Stat-Signature: payj71p77nu9pr7qbpeq7d8pd8oihp1g
X-HE-Tag: 1762780852-284443
X-HE-Meta: U2FsdGVkX18MSPSNzjbGvbL18yeFvCmWK2v+9fjKfx/TWPsMqFJqg/ucTCNxB/zGFeSZkV/TXJ6+eBp/ymM/XA6risW7ckqS66PhsiitLc2r1plZj0oNSK1jmOiDaUHa6kAAxlPMI9VGDWYv35ca27N0U7SjxFeJeFEtwoTyaiDii2j6q1Dz2jBWip+kG7RBhfIbxmiFYp1wgKwwq9qg1CN+20uUFDrLDtgN70b9nMePiUMGlqt5/OkdahzMv03K3rgwVMeg0ocM/w20hDtWYVANHU/jbinKAuWZzbo811y3sWP2T85hW0VpnKpAxqIm8HR1jqd4qURV5vuCAwjcOz61PB3HwpFYEnW6BdQcNB4TjMJsl1bLAwwmQibYjlpPiqI/8Kr1QppsQFz7laA7iIpXV0t55Bh6wFDaCVM0GfREOV3VkTYA78Q1/kl1seAbqRNLsITseD6sGD9Yx4MJGdvEHME1LN3asq558pPe3mMl/PxxUs/vHBOT82uY1OlorUqw2aWGfqihZhVYmeL4rWfPHEzf1syD05GIAw9rtIHl8SFwD7RBJw6SyUwmyydfFkZ5SkuM7V0N59SxAoJL4L6p5GjNd0NIrxK8a8np4PbMdYkWpstkKRtVeyQiA/Mp2jtLcelgqSh69d5PBZ+/g9ZeDvX8z9dZuiPCOYEmSdx4/8EmvsarXwirFZKuSH8YrFUQcrR1KTI7oE5k9lKX3eMIr6XEIZjGvlxkcOVg3ulN6sAfgrcOQBZlRGejp8OPSE4Hq2afls+IcAyAe7FfayWbtMp6HYqqLSnoXdUBZm6Gkw0TJdV4mz2RKNeuZLLN7YUrXpY3mWYFhTrz4xgi8rKbWspoCuQnW1WqnMInARN/sPzO1dvhaL0ysLwzHHSzN+fe1Uia95mXfELfqcSeTfm36gWWsa7ss919sPyXKKMwCmxxa/ahLMVi7u0PPl875ycwDYOOSQGRYvmby1U
 qF5VtlaQ
 tbXD0M12Hc/S7CftOOfty4w5kJKg5JnLLNJ4YAAJrKP0U84yJy/xNV25Zs804SJBN+I0eP486GatlkFTDnmufQ6nHTVPUqKbO6t3XOHzGdSPiPpb1e4nfkP0CrDGDPWe0bPeq93gdXumSOhQLrml30fwDaVZg9Zz+jtrr0ne08q0J5c6AdiSSwWA36kjWv0/1MAhXJvZinI9eYRz7z6LB+wzcqReB0u3/HpZmCYQuNdSdkNUmT450fiSViuiQ9q2WSOTS/YBA1QbMuxpb7JNZQajcvWnk8I3NdyYm5WjFX8a8JEzaiJ1WY8QLoDiVIMIknomGy3N5LBy8fQsKbyiH6ZN/1o7/1EX3XFTbOPTq1uhkTGYGFjmZwr5/IQcZXJgK0KvEGMIwHqheUHmudsI1vQEWXkl9CUI1bRse1aqjnu8yrg2Zntnlb1unKZIC5q9x6fzUf+TOX+HNQV2wNdFzw4OJGgcTTjTp93Y5t1W9u633sAPImEWWygUyFr5DB3KjsRm4AwSY41hazi+cTaO0gSh73vJx8wH4tv/zx62K2k8W0bf0lj64wDEl8hKw0xj1Y9qJpCKB+03WBPovDtW7kjq9Un0S7PQmE7RFezeEWH+ieVny4WuywPbUnA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 10:02=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Oct 22, 2025 at 12:37:07PM -0600, Nico Pache wrote:
> > generalize the order of the __collapse_huge_page_* functions
> > to support future mTHP collapse.
> >
> > mTHP collapse will not honor the khugepaged_max_ptes_shared or
> > khugepaged_max_ptes_swap parameters, and will fail if it encounters a
> > shared or swapped entry.
> >
> > No functional changes in this patch.
> >
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Co-developed-by: Dev Jain <dev.jain@arm.com>
> > Signed-off-by: Dev Jain <dev.jain@arm.com>
> > Signed-off-by: Nico Pache <npache@redhat.com>
>
> Thanks for addressing the v10 stuff (didn't check at v11).
>
> Overall LGTM, so:
>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Thanks!
>
> Few minor nits below.
>
> > ---
> >  mm/khugepaged.c | 78 ++++++++++++++++++++++++++++++-------------------
> >  1 file changed, 48 insertions(+), 30 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 36ee659acfbb..4ccebf5dda97 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -537,25 +537,25 @@ static void release_pte_pages(pte_t *pte, pte_t *=
_pte,
> >  }
> >
> >  static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
> > -                                     unsigned long start_addr,
> > -                                     pte_t *pte,
> > -                                     struct collapse_control *cc,
> > -                                     struct list_head *compound_pageli=
st)
> > +             unsigned long start_addr, pte_t *pte, struct collapse_con=
trol *cc,
> > +             unsigned int order, struct list_head *compound_pagelist)
>
> This series isn't the right place for it, but god do we need helper struc=
ts in
> this code... :)

Well we have collapse_control! I can spend some time in a follow up
series to better leverage this struct.

>
> >  {
> >       struct page *page =3D NULL;
> >       struct folio *folio =3D NULL;
> >       unsigned long addr =3D start_addr;
> >       pte_t *_pte;
> >       int none_or_zero =3D 0, shared =3D 0, result =3D SCAN_FAIL, refer=
enced =3D 0;
> > +     const unsigned long nr_pages =3D 1UL << order;
> > +     int max_ptes_none =3D khugepaged_max_ptes_none >> (HPAGE_PMD_ORDE=
R - order);
>
> Nit, but we should const-ify this too.

This gets converted to collapse_max_ptes_none in the future.

>
> >
> > -     for (_pte =3D pte; _pte < pte + HPAGE_PMD_NR;
> > +     for (_pte =3D pte; _pte < pte + nr_pages;
> >            _pte++, addr +=3D PAGE_SIZE) {
> >               pte_t pteval =3D ptep_get(_pte);
> >               if (pte_none_or_zero(pteval)) {
> >                       ++none_or_zero;
> >                       if (!userfaultfd_armed(vma) &&
> >                           (!cc->is_khugepaged ||
> > -                          none_or_zero <=3D khugepaged_max_ptes_none))=
 {
> > +                          none_or_zero <=3D max_ptes_none)) {
> >                               continue;
> >                       } else {
> >                               result =3D SCAN_EXCEED_NONE_PTE;
> > @@ -583,8 +583,14 @@ static int __collapse_huge_page_isolate(struct vm_=
area_struct *vma,
> >               /* See collapse_scan_pmd(). */
> >               if (folio_maybe_mapped_shared(folio)) {
> >                       ++shared;
> > -                     if (cc->is_khugepaged &&
> > -                         shared > khugepaged_max_ptes_shared) {
> > +                     /*
> > +                      * TODO: Support shared pages without leading to =
further
> > +                      * mTHP collapses. Currently bringing in new page=
s via
> > +                      * shared may cause a future higher order collaps=
e on a
> > +                      * rescan of the same range.
> > +                      */
>
> Yeah, I wish we could find a way to address this in some other way but gi=
ven the
> mire of THP code putting this comment here for now is probably the only s=
ensible
> way.
>
> > +                     if (order !=3D HPAGE_PMD_ORDER || (cc->is_khugepa=
ged &&
> > +                         shared > khugepaged_max_ptes_shared)) {
> >                               result =3D SCAN_EXCEED_SHARED_PTE;
> >                               count_vm_event(THP_SCAN_EXCEED_SHARED_PTE=
);
> >                               goto out;
> > @@ -677,18 +683,18 @@ static int __collapse_huge_page_isolate(struct vm=
_area_struct *vma,
> >  }
> >
> >  static void __collapse_huge_page_copy_succeeded(pte_t *pte,
> > -                                             struct vm_area_struct *vm=
a,
> > -                                             unsigned long address,
> > -                                             spinlock_t *ptl,
> > -                                             struct list_head *compoun=
d_pagelist)
> > +             struct vm_area_struct *vma, unsigned long address,
> > +             spinlock_t *ptl, unsigned int order,
> > +             struct list_head *compound_pagelist)
> >  {
> > -     unsigned long end =3D address + HPAGE_PMD_SIZE;
> > +     unsigned long end =3D address + (PAGE_SIZE << order);
> >       struct folio *src, *tmp;
> >       pte_t pteval;
> >       pte_t *_pte;
> >       unsigned int nr_ptes;
> > +     const unsigned long nr_pages =3D 1UL << order;
> >
> > -     for (_pte =3D pte; _pte < pte + HPAGE_PMD_NR; _pte +=3D nr_ptes,
> > +     for (_pte =3D pte; _pte < pte + nr_pages; _pte +=3D nr_ptes,
> >            address +=3D nr_ptes * PAGE_SIZE) {
> >               nr_ptes =3D 1;
> >               pteval =3D ptep_get(_pte);
> > @@ -741,13 +747,11 @@ static void __collapse_huge_page_copy_succeeded(p=
te_t *pte,
> >  }
> >
> >  static void __collapse_huge_page_copy_failed(pte_t *pte,
> > -                                          pmd_t *pmd,
> > -                                          pmd_t orig_pmd,
> > -                                          struct vm_area_struct *vma,
> > -                                          struct list_head *compound_p=
agelist)
> > +             pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
> > +             unsigned int order, struct list_head *compound_pagelist)
> >  {
> >       spinlock_t *pmd_ptl;
> > -
> > +     const unsigned long nr_pages =3D 1UL << order;
> >       /*
> >        * Re-establish the PMD to point to the original page table
> >        * entry. Restoring PMD needs to be done prior to releasing
> > @@ -761,7 +765,7 @@ static void __collapse_huge_page_copy_failed(pte_t =
*pte,
> >        * Release both raw and compound pages isolated
> >        * in __collapse_huge_page_isolate.
> >        */
> > -     release_pte_pages(pte, pte + HPAGE_PMD_NR, compound_pagelist);
> > +     release_pte_pages(pte, pte + nr_pages, compound_pagelist);
> >  }
> >
> >  /*
> > @@ -781,16 +785,16 @@ static void __collapse_huge_page_copy_failed(pte_=
t *pte,
> >   */
> >  static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
> >               pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
> > -             unsigned long address, spinlock_t *ptl,
> > +             unsigned long address, spinlock_t *ptl, unsigned int orde=
r,
> >               struct list_head *compound_pagelist)
> >  {
> >       unsigned int i;
> >       int result =3D SCAN_SUCCEED;
> > -
> > +     const unsigned long nr_pages =3D 1UL << order;
> >       /*
> >        * Copying pages' contents is subject to memory poison at any ite=
ration.
> >        */
> > -     for (i =3D 0; i < HPAGE_PMD_NR; i++) {
> > +     for (i =3D 0; i < nr_pages; i++) {
> >               pte_t pteval =3D ptep_get(pte + i);
> >               struct page *page =3D folio_page(folio, i);
> >               unsigned long src_addr =3D address + i * PAGE_SIZE;
> > @@ -809,10 +813,10 @@ static int __collapse_huge_page_copy(pte_t *pte, =
struct folio *folio,
> >
> >       if (likely(result =3D=3D SCAN_SUCCEED))
> >               __collapse_huge_page_copy_succeeded(pte, vma, address, pt=
l,
> > -                                                 compound_pagelist);
> > +                                                 order, compound_pagel=
ist);
> >       else
> >               __collapse_huge_page_copy_failed(pte, pmd, orig_pmd, vma,
> > -                                              compound_pagelist);
> > +                                              order, compound_pagelist=
);
> >
> >       return result;
> >  }
> > @@ -985,13 +989,12 @@ static int check_pmd_still_valid(struct mm_struct=
 *mm,
> >   * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
> >   */
> >  static int __collapse_huge_page_swapin(struct mm_struct *mm,
> > -                                    struct vm_area_struct *vma,
> > -                                    unsigned long start_addr, pmd_t *p=
md,
> > -                                    int referenced)
> > +             struct vm_area_struct *vma, unsigned long start_addr,
> > +             pmd_t *pmd, int referenced, unsigned int order)
>
> Nit, super nit really, but since other __collapse_huge_page_*() functions=
 have
> ..., order, param) as their last parameters, perhaps worth flipping refer=
enced +
> order here?
>
> Not a big deal though.
>
> >  {
> >       int swapped_in =3D 0;
> >       vm_fault_t ret =3D 0;
> > -     unsigned long addr, end =3D start_addr + (HPAGE_PMD_NR * PAGE_SIZ=
E);
> > +     unsigned long addr, end =3D start_addr + (PAGE_SIZE << order);
> >       int result;
> >       pte_t *pte =3D NULL;
> >       spinlock_t *ptl;
> > @@ -1022,6 +1025,19 @@ static int __collapse_huge_page_swapin(struct mm=
_struct *mm,
> >               if (!is_swap_pte(vmf.orig_pte))
> >                       continue;
> >
> > +             /*
> > +              * TODO: Support swapin without leading to further mTHP
> > +              * collapses. Currently bringing in new pages via swapin =
may
> > +              * cause a future higher order collapse on a rescan of th=
e same
> > +              * range.
> > +              */
>
> Same comment as above re: this, i.e. that it's a pity but probably unavoi=
dable
> for now.
>
> > +             if (order !=3D HPAGE_PMD_ORDER) {
> > +                     pte_unmap(pte);
> > +                     mmap_read_unlock(mm);
> > +                     result =3D SCAN_EXCEED_SWAP_PTE;
> > +                     goto out;
> > +             }
> > +
> >               vmf.pte =3D pte;
> >               vmf.ptl =3D ptl;
> >               ret =3D do_swap_page(&vmf);
> > @@ -1142,7 +1158,7 @@ static int collapse_huge_page(struct mm_struct *m=
m, unsigned long address,
> >                * that case.  Continuing to collapse causes inconsistenc=
y.
> >                */
> >               result =3D __collapse_huge_page_swapin(mm, vma, address, =
pmd,
> > -                                                  referenced);
> > +                                                  referenced, HPAGE_PM=
D_ORDER);
> >               if (result !=3D SCAN_SUCCEED)
> >                       goto out_nolock;
> >       }
> > @@ -1190,6 +1206,7 @@ static int collapse_huge_page(struct mm_struct *m=
m, unsigned long address,
> >       pte =3D pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
> >       if (pte) {
> >               result =3D __collapse_huge_page_isolate(vma, address, pte=
, cc,
> > +                                                   HPAGE_PMD_ORDER,
> >                                                     &compound_pagelist)=
;
> >               spin_unlock(pte_ptl);
> >       } else {
> > @@ -1220,6 +1237,7 @@ static int collapse_huge_page(struct mm_struct *m=
m, unsigned long address,
> >
> >       result =3D __collapse_huge_page_copy(pte, folio, pmd, _pmd,
> >                                          vma, address, pte_ptl,
> > +                                        HPAGE_PMD_ORDER,
> >                                          &compound_pagelist);
> >       pte_unmap(pte);
> >       if (unlikely(result !=3D SCAN_SUCCEED))
> > --
> > 2.51.0
> >
>


