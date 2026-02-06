Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3571EE6B43
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 17:44:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 100F16B0098; Fri,  6 Feb 2026 12:44:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B77A6B0099; Fri,  6 Feb 2026 12:44:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDAA56B009B; Fri,  6 Feb 2026 12:44:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD3666B0098
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 12:44:35 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A63388AC78
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:44:35 +0000 (UTC)
X-FDA: 84414756510.05.A71A9A8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 272018000B
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:44:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Eua+VPO7;
	spf=pass (imf30.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770399873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+BF3+3nS/V8JxWcSboqH9V3mdaa6NoZICmA/Jv+aI30=;
	b=MNaZtmQTvoLz6hrgRTn/eQHz5wlY1ccvCM9P0DcS8BD1zYjmbfhoxAMK3HAusFhaOCusm3
	zkUoeqp5Gx7nrsivCaK8DZWTHf3s6kbqkgm1e7THz8n/U6jcB5BZsByHqKYvd+G4NCCzci
	wRuwx0k+l2AK1/qeTETD10opgZD0krw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Eua+VPO7;
	spf=pass (imf30.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770399873; a=rsa-sha256;
	cv=none;
	b=U5Q/LCM21wRy0+YMotD0zXBEJv/d19vKvbY/rPAUhskjUzJWmuprtGHsR6D7yBVvpggv5z
	Eef4dX0x8N8UXxAhJ9/KHeB9RzlfgInru3TalHCXMSY1Q5L630dGPXfXb0KhE5StVWCCJH
	mQJd/DhFyS0qMd2y+CxridkFTtuh5Ls=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770399871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+BF3+3nS/V8JxWcSboqH9V3mdaa6NoZICmA/Jv+aI30=;
	b=Eua+VPO7gSiffGYUKGiJ0v10eV+08gbEbrZXnw3b1cN30GhBUb7l31OZvs0aAxlZ7HkBvA
	Kea50FRvQD39s/Z53YOOwK+xCuPumfno4YgvUt7IPOFBWSqmXK+QgzdBSIWfCv8iVtWDwg
	KSObZsTIo0uCq5Ukw7m8Qk74LpcNq+E=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-Xc5WJW0yN8m0_ZUfR0znUg-1; Fri, 06 Feb 2026 12:44:30 -0500
X-MC-Unique: Xc5WJW0yN8m0_ZUfR0znUg-1
X-Mimecast-MFC-AGG-ID: Xc5WJW0yN8m0_ZUfR0znUg_1770399870
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-794fe16cc00so34866857b3.1
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 09:44:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770399870; x=1771004670;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+BF3+3nS/V8JxWcSboqH9V3mdaa6NoZICmA/Jv+aI30=;
        b=BhlobnE+0g06kZjFB96AkAR/g37tPU7/5sLATBkzGE/yl5PIPsNMQ8JNespClbQtQJ
         UT6v5xt89Oa83TsM5ZhgMl+UKKM6JPMMIOHeUUuTSKWlCMtGGCNswqKimQyIWJEWrw4d
         zQ8kGKqrxfohBRseNu1fREveA3fZn8lYMzHvOQcDVD3viDQcMzPCIPaG5mxJDte78Gek
         QfpZlNsUfyl5Z2u2gFpsChAmmektnKt2PLogMPLb8nZ2E12oB4IesGR5XPQnqR/xqJHw
         +kQlsncEG8OJmf+uLJCEN6ru5PpHG8Vo2hlkcEtSa/3SVIuao32as6OQuP56hfdOPfIG
         S0KQ==
X-Gm-Message-State: AOJu0YyGgchDxuXVBo6zjJcFRYrBjyWSz3+eCwIx89WlSRr3N+t1pHsB
	rn0E+Scry5T+TazRCSqEmSrEnoXkWgHfCk24VkJ4NzgaKft/RoLmqyAHq9LHgkTbmhNxMcczKIu
	+valEEuLnnqcNQ6QfbrPGY3TXEZPtumPkgqyXqoA70QmvXQ8uGc2Y227CGUMZrWvmn9Q85rRgOi
	7+Ij+fWi0omxTm6spRBEwms9p7E2Y=
X-Gm-Gg: AZuq6aKF6DSFlKkk3L3nKvsDv75GjA0ghfxx6SdiqXjVQdbdr1sQmnYwqc85bnbazNm
	tsQ6hNTGZc4Y9C+mkw3dD/oiyQZPUV87zfGagN1XGI9/NSX/cUCfTfuLT/EymIgoa1W6oNjKJ+U
	maNmXY5EEbbLeaA4XLFrKAdB6+S1nb1No4mlWxBop/43q0c878TCvWIoYttybJ37iBmbsn55tcr
	3RCbmfY
X-Received: by 2002:a05:690c:95:b0:794:dc33:bc17 with SMTP id 00721157ae682-7952ab3fb55mr32336887b3.34.1770399869722;
        Fri, 06 Feb 2026 09:44:29 -0800 (PST)
X-Received: by 2002:a05:690c:95:b0:794:dc33:bc17 with SMTP id
 00721157ae682-7952ab3fb55mr32336437b3.34.1770399869119; Fri, 06 Feb 2026
 09:44:29 -0800 (PST)
MIME-Version: 1.0
References: <20260122192841.128719-1-npache@redhat.com> <20260122192841.128719-8-npache@redhat.com>
 <db10946c-9743-49e0-a845-7f53a60778a6@lucifer.local>
In-Reply-To: <db10946c-9743-49e0-a845-7f53a60778a6@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Fri, 6 Feb 2026 10:44:03 -0700
X-Gm-Features: AZwV_QgCX_uZwp1i-uJAy0wyCUDEIyNfRNZ14VALyUVhoxl38w4ekqWKsufLGVM
Message-ID: <CAA1CXcBQWPD=AxX9mCOdAOv85LTk+FPJQeEudQur-ymg4vbp5g@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v14 07/16] khugepaged: introduce
 collapse_max_ptes_none helper function
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net, 
	rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, jackmanb@google.com, 
	hannes@cmpxchg.org, willy@infradead.org, peterx@redhat.com, 
	wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com, 
	vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com, 
	yang@os.amperecomputing.com, kas@kernel.org, aarcange@redhat.com, 
	raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com, 
	tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, 
	cl@gentwo.org, jglisse@google.com, zokeefe@google.com, rientjes@google.com, 
	rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gTpJIPLL8qB-JDXY9NTRGh_S14b7mULxTb9YrJizmbs_1770399870
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: p3apppw4cd4ctkyitqrw64a7z5j15adu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 272018000B
X-HE-Tag: 1770399872-806758
X-HE-Meta: U2FsdGVkX18Jf0U3UmVqmrgp77WhoPjKS27xKnKi8N++g6VPpBEqFRaI78JWLuxc6aCpMejq7avaLLOHl05YcOedeIFMaYZ7UTJe6WUDGx0EoRuI5RXSf2Bvf3l+NDK6uBUNow8HMHa44nYcIXof/j/YAoVSLHvFzfMR+95uJ2+8MBvs6eHY11zanvQMBbwu6G1Xp1w+ageBaNW8FTUIsJKpDvxRM2Gnq5iMRoL3NuQvKGBWbCch/uVB/oDWC3I8MmvSt15rHHvleQZl+AU8xLJu7DauwhVnhr/KNBfnOrNtbeHCqs/C7vQfCLHyNtJM6R3tceI3BKMWA/3u8c9YuvKSMNyP67tQ1vH4SsaUFB5l+WIsLYLc1PYVaOqVZVV6J1Pz6XrWZAbo3PlyM+zkQN8HYP57BKpr+T9rYAGvd6CkzqnQ3QF5DcbXhgm0vj6xIz/0Wj+VsyYqcpFe8w5nsoXv6F2h2PhTVS9nHDDiQSdg078WS2D3TfazDzYbQJNMT79UHahjS9J18cpTVvgWoVAPwi4umHWA3vmRF2AI3mxIgp/z5exaxU2BW4GEYZ33WEdqnaOoV6DunPRnWdpqt3AUsKzaJxVe1zayQdviE+sh4U+j6F5FbVvlRk+GbPj7QE1QZk5aC1+AQ1BHhUUTQZ+hr5Mit0y2UaxOpWak0an3V0zHuIwwVegQgukpI5Hv9rKJYMv/bdLVyTb5q6nMBvR8oM7rHCSCEoF53BUz/xxY9aPsz1jTL3EdwiTD7S8YEl+/YIzxt3Xr0KNcHw6D9xoN/vEHGdNCQF49IG3YUBkAxN0nsmdZxN8wPe2hDMWXYXn5xQULsUf0tB/+wGznxR3Ty5Ysjx5/LqeQhkzOHg9yQ6bQ53uSadtub2i5lKcUuCNWhd7AG4xvHDFm9vkrTikxjZOPd4q9l/V11t/qCCZHD9jPXN8XfoZR1Fzygarc9kTRG+GC2GtSxI16Cxp
 0vRW66L0
 aLNsaWj0nrxYTOBEaWM97cQPgzK7kPnz929zgVgCc3PkEVZgCReQCg8HzA1WCK/mKRIljCAs0WpHiGn4ZSkKk2V3AuaL1xVwSrRqTsUp2+3hLa19PzInplNiRaNgeMFhVK9hfbnZgz56Cw2/WnfNK6r3l8BvYUfsB8v60
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 3, 2026 at 5:09=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Thu, Jan 22, 2026 at 12:28:32PM -0700, Nico Pache wrote:
> > The current mechanism for determining mTHP collapse scales the
> > khugepaged_max_ptes_none value based on the target order. This
> > introduces an undesirable feedback loop, or "creep", when max_ptes_none
> > is set to a value greater than HPAGE_PMD_NR / 2.
> >
> > With this configuration, a successful collapse to order N will populate
> > enough pages to satisfy the collapse condition on order N+1 on the next
> > scan. This leads to unnecessary work and memory churn.
> >
> > To fix this issue introduce a helper function that will limit mTHP
> > collapse support to two max_ptes_none values, 0 and HPAGE_PMD_NR - 1.
> > This effectively supports two modes:
> >
> > - max_ptes_none=3D0: never introduce new none-pages for mTHP collapse.
> > - max_ptes_none=3D511 (on 4k pagesz): Always collapse to the highest
> >   available mTHP order.
> >
> > This removes the possiblilty of "creep", while not modifying any uAPI
> > expectations. A warning will be emitted if any non-supported
> > max_ptes_none value is configured with mTHP enabled.
> >
> > The limits can be ignored by passing full_scan=3Dtrue, this is useful f=
or
> > madvise_collapse (which ignores limits), or in the case of
> > collapse_scan_pmd(), allows the full PMD to be scanned when mTHP
> > collapse is available.
>
> Thanks, great commit msg!
>
> >
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Signed-off-by: Nico Pache <npache@redhat.com>
>
> This LGTM in terms of logic, some nits below, with those addressed feel
> free to add:
>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Cheers, Lorenzo
>
> > ---
> >  mm/khugepaged.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 42 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 0f68902edd9a..9b7e05827749 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -460,6 +460,44 @@ void __khugepaged_enter(struct mm_struct *mm)
> >               wake_up_interruptible(&khugepaged_wait);
> >  }
> >
> > +/**
> > + * collapse_max_ptes_none - Calculate maximum allowed empty PTEs for c=
ollapse
> > + * @order: The folio order being collapsed to
> > + * @full_scan: Whether this is a full scan (ignore limits)
> > + *
> > + * For madvise-triggered collapses (full_scan=3Dtrue), all limits are =
bypassed
> > + * and allow up to HPAGE_PMD_NR - 1 empty PTEs.
> > + *
> > + * For PMD-sized collapses (order =3D=3D HPAGE_PMD_ORDER), use the con=
figured
> > + * khugepaged_max_ptes_none value.
> > + *
> > + * For mTHP collapses, we currently only support khugepaged_max_pte_no=
ne values
> > + * of 0 or (HPAGE_PMD_NR - 1). Any other value will emit a warning and=
 no mTHP
> > + * collapse will be attempted
> > + *
> > + * Return: Maximum number of empty PTEs allowed for the collapse opera=
tion
> > + */
> > +static unsigned int collapse_max_ptes_none(unsigned int order, bool fu=
ll_scan)
> > +{
> > +     /* ignore max_ptes_none limits */
> > +     if (full_scan)
> > +             return HPAGE_PMD_NR - 1;
>
> I wonder if, given we are effectively doing:
>
>         const unsigned int nr_pages =3D collapse_max_ptes_none(order, /*f=
ull_scan=3D*/true);
>
>         ...
>
>         foo(nr_pages);
>
> In places where we ignore limits, whether we would be better off putting
> HPAGE_PMD_NR - 1 into a define and just using that in these cases, like:
>
> #define COLLAPSE_MAX_PTES_LIM (HPAGE_PMD_NR - 1)

Would a shorter name be appropriate? COLLAPSE_MAX_PTES_LIM(IT) is
quite long. Can we call it MAX_PTES_LIMIT or KHUGE_MAX_PTES_LIM?

-- Nico

>
> Then instead doing:
>
>         foo(COLLAPSE_MAX_PTES_LIM);
>
> ?
>
> Seems somewhat silly to pass in a boolean that makes it return a set valu=
e in
> cases where you know that should be the case at the outset.
>
> > +
> > +     if (is_pmd_order(order))
> > +             return khugepaged_max_ptes_none;
> > +
> > +     /* Zero/non-present collapse disabled. */
> > +     if (!khugepaged_max_ptes_none)
> > +             return 0;
> > +
> > +     if (khugepaged_max_ptes_none =3D=3D HPAGE_PMD_NR - 1)
>
> Having a define for HPAGE_PMD_NR - 1 would also be handy here...
>
> > +             return (1 << order) - 1;
> > +
> > +     pr_warn_once("mTHP collapse only supports max_ptes_none values of=
 0 or %d\n",
> > +                   HPAGE_PMD_NR - 1);
>
> ...and here.
>
> Also a MICRO nit here - the function returns unsigned int and thus we
> express PTEs in this unit, so maybe use %u rather than %d?
>
> > +     return -EINVAL;
> > +}
>
> Logic of this function looks correct though!
>
> > +
> >  void khugepaged_enter_vma(struct vm_area_struct *vma,
> >                         vm_flags_t vm_flags)
> >  {
> > @@ -548,7 +586,10 @@ static enum scan_result __collapse_huge_page_isola=
te(struct vm_area_struct *vma,
> >       int none_or_zero =3D 0, shared =3D 0, referenced =3D 0;
> >       enum scan_result result =3D SCAN_FAIL;
> >       const unsigned long nr_pages =3D 1UL << order;
> > -     int max_ptes_none =3D khugepaged_max_ptes_none >> (HPAGE_PMD_ORDE=
R - order);
> > +     int max_ptes_none =3D collapse_max_ptes_none(order, !cc->is_khuge=
paged);
>
> Yeah, the !cc->is_khugepaged is a bit gross here, so as per the above, ma=
ybe do:
>
>         int max_ptes_none;
>
>         if (cc->is_khugepaged)
>                 max_ptes_none =3D collapse_max_ptes_none(order);
>         else    /* MADV_COLLAPSE is not limited. */
>                 max_ptes_none =3D COLLAPSE_MAX_PTES_LIM;
>
> > +
> > +     if (max_ptes_none =3D=3D -EINVAL)
> > +             return result;
> >
> >       for (_pte =3D pte; _pte < pte + nr_pages;
> >            _pte++, addr +=3D PAGE_SIZE) {
> > --
> > 2.52.0
> >
>


