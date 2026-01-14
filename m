Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1E67D31A05
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 02:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD9276B008A; Tue, 13 Jan 2026 21:39:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B86126B008C; Tue, 13 Jan 2026 21:39:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8C276B0092; Tue, 13 Jan 2026 21:39:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 98F6D6B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 21:39:11 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 160638B500
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:39:11 +0000 (UTC)
X-FDA: 84329012502.02.5B5EDE2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id A68BB140007
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:39:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HVlavPBt;
	spf=pass (imf09.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768358348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GsaYDMAkcB1oPv2ajw72CMxvsVxtZEIcouIazzEAlDI=;
	b=E9iC1qVOFLL7mWPXKnCwfh5rzD7y4GfejDOLbWRZ7XbH0SUIKYM1wBKR3f+5Wwj244u8dk
	j/N6QYBCaF2woJGPUU0E+GoREoqmTCcHsbbInF1HbrSqC67yWIlJr4rnHXlxv7a9REqr+W
	VoYmhaP+uy8K0zya1nt0nT8oo+JYcDw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HVlavPBt;
	spf=pass (imf09.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768358348; a=rsa-sha256;
	cv=none;
	b=NoaAycH29vOjBwNG4/WT0TKS5X+EI1WqPioeJoTy465pf0m0KtKTpqFwbrdLGDNvPzNqZo
	nSei+000UqDxX2MsbR/TWITN35R8IiBQb3Nya5i3nkxezPd6b60JHbq3JXnU8pl1SgB75n
	b9+ZS8C22H7rQKC3Y1WyxUd03GyKvBA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768358348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GsaYDMAkcB1oPv2ajw72CMxvsVxtZEIcouIazzEAlDI=;
	b=HVlavPBtHTCqrvKaVa8Dc5qqCb5GHVRANSyprDH12RmbIsBfB21zzgI6kOgaVxyVgs5tDQ
	036iPpVKhtxAgSJ3512V+vmxEg1iEAR5ltbuNk+P3AslaBXLVwbIfoZ06SMU+m/3dsvNFu
	hWKB+lthr3/yZKvX3zH24oQOyGIdIvU=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-423-gvmSNH41OXq0IQ7RzGYwgw-1; Tue, 13 Jan 2026 21:39:06 -0500
X-MC-Unique: gvmSNH41OXq0IQ7RzGYwgw-1
X-Mimecast-MFC-AGG-ID: gvmSNH41OXq0IQ7RzGYwgw_1768358346
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-789535a89aeso134904847b3.2
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:39:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768358346; x=1768963146;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GsaYDMAkcB1oPv2ajw72CMxvsVxtZEIcouIazzEAlDI=;
        b=RHTRGB4iz7xFiBcsNaeJXFyO6+W+PrYlaYvqG4tnU5S0Q3xo7KEmqHURJpAcdukirG
         WOdtIMcAA4J1r9JJfhxfrtKzn8cegCpcY+iNgkcPZ6poojj9VJGwO77wGD+34IpJ7EsE
         tmq61DqGIuuDgowegYICXLvUj4/Weav50NR8EDYDx36Xg7mlkpz8IUGxZOawEzb7KDQ4
         envXKryFOMnoZsY6Kq9gAVrKifNQ17kO9P7bFpe1ckuXoZOySO2Tu0O7fmpByMAi4qB6
         3OlLIRr+ESMS491Km+SQshAkHc4i68eSlVbJqIhv90KsjTqoeH9gwZAGIwASnbirNGyG
         XHEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfPZrBrDaMagHMeKR7fta4EFgPPHhGK8MhQ7SMHDiLr8VVTzi2UUiO3nnQMfeUxHPR24thqN5ELQ==@kvack.org
X-Gm-Message-State: AOJu0YzOydBjfFPlNmvpIYKfSbMwvIfRkYhggOOLTxxR2Ia8OaPgWm6w
	8uHU1tLAWOES79bxrG6yzx69cBdZnQquQsQtDFKqDezfhOM+qep1Prvn/CEMcMIbHYdF/NrhP7D
	RD6WFFQf434O2T7dBnxcYiJJFmfnncX/tTj9c/4+SKxu8dYiW8OOoBc8SiNKmQEafhIamowx9Uj
	JJ1GanHGH2/mxlH+7TPwkZckuaZh4=
X-Gm-Gg: AY/fxX6IigstjB0MG9jZho1fz3l29cPjd/kNxsBnuaFCgX1R6+Nf1xuNcai2miOhqzm
	upqFNGcCUUOwcHLg0WkNpHnM2YUo+rQ3q97CVo0f4yDEQCjRqZbSe19sG77QckRLjbYwfHO72dH
	/BU7IieUiujqVEV7Ddt2pfcBXF8KRFJzpPYIf1Txgsjle1QYFy11wtlHmhY2GRgCuHWp96zPo8y
	ZpKDyBF
X-Received: by 2002:a53:b199:0:b0:63f:9928:3f85 with SMTP id 956f58d0204a3-64901b01ee2mr778921d50.62.1768358346211;
        Tue, 13 Jan 2026 18:39:06 -0800 (PST)
X-Received: by 2002:a53:b199:0:b0:63f:9928:3f85 with SMTP id
 956f58d0204a3-64901b01ee2mr778884d50.62.1768358345750; Tue, 13 Jan 2026
 18:39:05 -0800 (PST)
MIME-Version: 1.0
References: <20251201174627.23295-1-npache@redhat.com> <20251201174627.23295-6-npache@redhat.com>
 <CCE3840A-A46A-4F33-8412-FC55161A6D6C@nvidia.com>
In-Reply-To: <CCE3840A-A46A-4F33-8412-FC55161A6D6C@nvidia.com>
From: Nico Pache <npache@redhat.com>
Date: Tue, 13 Jan 2026 19:38:39 -0700
X-Gm-Features: AZwV_Qg4QcCHsWf9Yf2aqPxUCcKE6236uDrcuWobRoGZDAiQfOTpw9hN9JUYA5U
Message-ID: <CAA1CXcC9YsOKbsvyZpgOwLdE938VBcPUrLyF97uN024uM2uiPA@mail.gmail.com>
Subject: Re: [PATCH v13 mm-new 05/16] khugepaged: introduce is_mthp_order helper
To: Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org, 
	willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com, 
	usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, kas@kernel.org, 
	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com, 
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org, 
	dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, jglisse@google.com, 
	surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com, 
	richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz, 
	rppt@kernel.org, jannh@google.com, pfalcato@suse.de
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IsY082FIaortfI9NQq7voSDr9v52rJtSIiEXCgxnIFA_1768358346
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A68BB140007
X-Stat-Signature: wf9kdsgg3n6ekfie5p3633ck5i71swir
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768358348-285690
X-HE-Meta: U2FsdGVkX1+J5j4T0Lz6HskRSz97a0QPqPsFz9zhjZLe0men8iNKdvJUes99ZjgcATOQ2OaAPLBNreRE4YyX+q39nVPoJHqsqnHxyUR9GCFWPcCxeQBIIMUiuWnFFKMiAZIQx8sQKXqUcd1uDeWihsIOiXS1wfc2LPK59eA6l6QZ2IQbd37jZgfevZAnc7ECIv4BXLHqpXCH6erWs++V6rIdvBzonceWTm+lXtuuMqxsxVylhPyTmTRY4+ep4TRINwHyXTf5GhyQlPVZjHzUoO6/KBL9v5VrZ8hpFfy0iGfli6fhJQOEtZeJufIeJyHkJacuBtHjKgtS0j64VlQTN0bNFheV9SCinv2O1YB6473WIHTGiCvhmurJks4ddsqjPyLuffKU88QY9OQgG1YXr+wA/btSgzUl3JlvJq38DWJg1A8CS2Bd/IPfmiAl8WcPZYMpZqVpiL2gA1PkNHvGwSXRAR4ln+AnGslfOMjcQ8i/2XNLDo7jes2Ih98069iTSod9wt+HK5YPbrT5YtKBa/I75vqmZzLIMlnHC+OHMFwv6vSVaDlsCaAwVRh/p48Ev20eTN4GB6eghTJdLDl+MxajFJx67ZWDVbvt2CFPeWptjMFoNalKx2aPu+4qgQurK3ialnGTog067BT73V58kyT1z15VcsUZ4lTwPQL9ccylcsiiTPknyt9WxJxFDm8WwFrPX11oCiqqk5ofDc+DV4vE/Q6knaMXbZ+MEbZCnqqGurPwuqpYoMoumgYo/wbT6p5VhvUaUhVKCWXzmMv9YylhaDaNFG5hbSkLIAHODt0xVYmdE2buAFFJ8BP45ah45XXSpTiDyGrq1pQlOTsAqnHPFku5MeqmGor/kZLqxsqafnmvfjYiU91lhX6D5unDFraml9lT1itsRKHReNNSeiZOcUNxQNDK1BuBTvSGBRn15/wCUd9/UxD5wusnHg+UF9c03elnfapFL6/Yfgz
 x0GW/BY8
 /IFcLOpuHZrvV6wyA8r0Y+74OCmWDOaj6zGBcVg00aKNL90utrnsg8yOGLW9Rqa7kFn7CkAPaVPcvGVcHZrpj/gm8LyX1YUNRXLej5/8P0PC6g8astBVvmAklQaDiP6vjy+h7FTzYV8KJcBlOggFnCoVijFqcIS1WbCvw19zwvmzNttHKbYhX4q0PqGLgob8fYohQLX9ZpB5CWND0o9ZQ15VnDd0rbnqpyxxoi18tjQjf1LRjRju/XDsAx8bWYjZjI9m7GB3tsog7ye49kRDp+jMzvNcpCkTPXVIbbq10u+2/mSYW1R7dJHO+r3olA0rxUUmozjdY6F/I7PWratIXaFTIXIixwZjgTRpWtDC1srJrBMRba8VKMvbpmMAo4F7XCGMwZP+jM1c039X0SPHAuA7G40pbb9zCkQ005iwNLSphNZu875dHW/k5b4q+qKdRoVEkRaGksQPP8W4fWADFT9nTcZLyoSHysA2moXPe0mmwAnI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 2, 2025 at 8:13=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On 1 Dec 2025, at 12:46, Nico Pache wrote:
>
> > In order to add mTHP support, we will often be checking if a given orde=
r
> > is a mTHP or PMD order. Lets create a simple helper function to keep th=
e
> > code clean and readable.
> >
> > Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >  mm/khugepaged.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 8599c7fa112e..9c041141b2e3 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -338,6 +338,11 @@ static bool pte_none_or_zero(pte_t pte)
> >       return pte_present(pte) && is_zero_pfn(pte_pfn(pte));
> >  }
> >
> > +static bool is_mthp_order(unsigned int order)
> > +{
> > +     return order !=3D HPAGE_PMD_ORDER;
> > +}
> > +
>
> The code at the bottom of __folio_split() in mm/huge_memory.c
> can use this helper.
>
> The code in deferred_split_folio() uses folio_test_pmd_mappable()
> instead of order =3D=3D HPAGE_PMD_ORDER, but the code can be changed
> to use the helper.

static inline bool folio_test_pmd_mappable(struct folio *folio)
{
return folio_order(folio) >=3D HPAGE_PMD_ORDER;
}

Should we make the is_mthp_order() check all orders that are less than
HPAGE_PMD_ORDER.

ie)

+static bool is_mthp_order(unsigned int order)
+{
+     return order < HPAGE_PMD_ORDER;
}

This way it's true to its mTHP nature being smaller than the PMD.

Cheers,
-- Nico

>
> >  int hugepage_madvise(struct vm_area_struct *vma,
> >                    vm_flags_t *vm_flags, int advice)
> >  {
> > @@ -1071,13 +1076,13 @@ static int alloc_charge_folio(struct folio **fo=
liop, struct mm_struct *mm,
> >       folio =3D __folio_alloc(gfp, order, node, &cc->alloc_nmask);
> >       if (!folio) {
> >               *foliop =3D NULL;
> > -             if (order =3D=3D HPAGE_PMD_ORDER)
> > +             if (!is_mthp_order(order))
> >                       count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
> >               count_mthp_stat(order, MTHP_STAT_COLLAPSE_ALLOC_FAILED);
> >               return SCAN_ALLOC_HUGE_PAGE_FAIL;
> >       }
> >
> > -     if (order =3D=3D HPAGE_PMD_ORDER)
> > +     if (!is_mthp_order(order))
> >               count_vm_event(THP_COLLAPSE_ALLOC);
> >       count_mthp_stat(order, MTHP_STAT_COLLAPSE_ALLOC);
> >
> > --
> > 2.51.1
>
>
> Best Regards,
> Yan, Zi
>


