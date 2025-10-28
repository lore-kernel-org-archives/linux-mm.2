Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FDD1CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 13:57:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDB028014A; Tue, 28 Oct 2025 09:57:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E64708013F; Tue, 28 Oct 2025 09:57:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7A828014A; Tue, 28 Oct 2025 09:57:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C7D1D8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:57:45 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 70AB514043C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:57:45 +0000 (UTC)
X-FDA: 84047676090.08.66D35EA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id E947540010
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:57:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ilq1sMQj;
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761659863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1hqcLTFSFJa32UdZBca8XVOOo6ca/YUGze1PkGPNkVo=;
	b=hXyDr0azfN6hg47AztnhRJhJ2WvG18iy1XA7j5J/pO7DEjYSY/tTR1WUPvDcwzQ+JOiPzy
	jhMRfqdwND5OlqIGIoXXX1bK6XcwKJNRSWKwqq2wrp8sS25/cZdUGLQDUcHkeQOEj00F/Z
	ZCmEJuHo7WIk/4oRme5oenSuLzn+xKY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ilq1sMQj;
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761659863; a=rsa-sha256;
	cv=none;
	b=gwu6Hc6MZHp9el2/ySMhIr+unWE3ycCNmMQshQn7/CNVfFtldRJ7V0/cIrU/JnuF1vSo0g
	rYI6zTNwDhCxlbptQB6aKsrKB2KYS9APtvqcWwYq3iRAMX2wfeKe48hZfDna5lzckIfoHB
	wHvzemHlNU9+haWYOyx2Nd06Ogqybpw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761659862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1hqcLTFSFJa32UdZBca8XVOOo6ca/YUGze1PkGPNkVo=;
	b=ilq1sMQjzDxxv0FTTVTpZ/G/WqzhAuiq5Vd/a/WjEm5evM8e1cACrPq7M3/jKyHqzsNlnT
	Dx/2+dy7eQqIUl123ctFjHeB4R8YJ1r6WEmOZLTo3nbsF2ai7WmLiZAfPEoEMzl7Nbll50
	7s7Z0jEVc1EPIKojp3Xj0ptk9Mck81A=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-463-GSNM6wNvNa2QP_Jc22NcCQ-1; Tue, 28 Oct 2025 09:57:40 -0400
X-MC-Unique: GSNM6wNvNa2QP_Jc22NcCQ-1
X-Mimecast-MFC-AGG-ID: GSNM6wNvNa2QP_Jc22NcCQ_1761659860
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-63e1a3f7635so7709332d50.2
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:57:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761659860; x=1762264660;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1hqcLTFSFJa32UdZBca8XVOOo6ca/YUGze1PkGPNkVo=;
        b=QuxY+eb8mlZO3UBEfEtafCyricnpy00DDfBWjDYi+QtE1/if0QjgEAfVbaTh6WFfDA
         7adzDxNKz+u3wwgh4l1O+u0NDAAS9/LbaXlbbXYln7n3nqK20rhfOnrAAAPduyoJBoyl
         BBRRTtrl7RoflFKUYIwdp+lX4Ml1aBYM9YSGxeyEr8EoaRGpwhV32hUgYe0KcoXZBYh4
         4fb37fJ0WfkpQtsUcSm9B+eobetN9o5xZkbtei1M25zKVI0NXMSyBLOw+lMY3BWpBd9P
         7vAtQ6X5XS6prRUZMLKRu50DuPErQCVamBjRA2IIYzF7yXcWpz3ieez1xtl7pbSu59d8
         btOw==
X-Forwarded-Encrypted: i=1; AJvYcCUTmwEpCEkX/PUsONL4s3HKW6xZoVcugsKP3u9Ew6dxPeYVT7SAvdGf4Ic7hpGSTw+z5+ksWJ9jOA==@kvack.org
X-Gm-Message-State: AOJu0Yz04h846j1H2wDCtSG/8DctZf/5BWCV0GoFO2t8yFV7K0ffiY7k
	mMxn9JPO5S+5sN3FKBzywN8ZJDE45OtWvhYN1jkqJDkohGMt0T05wX3Q0dOw3VX3j9iOHeVwVU5
	CLeTAgC6RRICKq6ZMDDJlnNGl0U8ZZB3zOgYDC/148DHlGM9Aa8rpTilrLMEjc4bzAGG4GuP8r2
	yKVBRsg0AEITUdeoeWGynpYIyP+k4=
X-Gm-Gg: ASbGnct0fmDfZ59qHHHpbRaLcGLODoiP45jrrH/r3gV6UxL8DVBAIKiH8CejfHLFDyU
	bo/p+/crIAO/R82MFH8+uhiPcmkTaYYQ4iute27WrN6fuFqRH+odBfUpYkhxYwVAKVhZqGE3fmY
	zalNPremduPWyATGsmjR4pDqGh/pygt1uC7k9CuWUxS9cBR7m7gXqSF97rCJ6P0he5ADxs9w==
X-Received: by 2002:a05:690e:1517:b0:63c:e930:e37 with SMTP id 956f58d0204a3-63f6b85dae6mr3191137d50.0.1761659860153;
        Tue, 28 Oct 2025 06:57:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7wQtO7p9XKAJbsCFFUBPJozNFYSEBLszufJXdBbxLP1xoSCnNfIuAIoiYmgpey11vqdoL8hFkGT/3VWWSKMQ=
X-Received: by 2002:a05:690e:1517:b0:63c:e930:e37 with SMTP id
 956f58d0204a3-63f6b85dae6mr3191107d50.0.1761659859403; Tue, 28 Oct 2025
 06:57:39 -0700 (PDT)
MIME-Version: 1.0
References: <20251022183717.70829-1-npache@redhat.com> <20251022183717.70829-7-npache@redhat.com>
 <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local> <063f8369-96c7-4345-ab28-7265ed7214cb@linux.alibaba.com>
In-Reply-To: <063f8369-96c7-4345-ab28-7265ed7214cb@linux.alibaba.com>
From: Nico Pache <npache@redhat.com>
Date: Tue, 28 Oct 2025 07:57:13 -0600
X-Gm-Features: AWmQ_bmAeiF43OuC22PnYol5XtlIdWxaxVwsbCB3sXR0PVz85j57-tCDcLiOmdI
Message-ID: <CAA1CXcCvOM+ddk1-d=8d7aFG0ZZ+shKhNCa6ppewSxS8BHW0OA@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 06/15] khugepaged: introduce
 collapse_max_ptes_none helper function
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, david@redhat.com, ziy@nvidia.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
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
X-Mimecast-MFC-PROC-ID: HKWy7ZuLgO0vgmXWm5-MhNw12Jww5pzZ2KVl6xKfNRE_1761659860
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E947540010
X-Stat-Signature: oh6s9bnxand37t48168uswybzqutp6t3
X-Rspam-User: 
X-HE-Tag: 1761659862-60750
X-HE-Meta: U2FsdGVkX1+ceP+tw+mY5RtoDk3PgMzvmkCqXK/k+22R8wwn5HxDtBo2ASJgc0MCveXXgOh7wKuDdRi2xODMurus9TxADPI4QSdCHZXplo5cxBXbboabGY3HfdNP5KbmCGmhjJT40elbcKv4l0nCfqs+CE2e/U/+ZEWlcz/JYEgw4SHQ8+pACcBODlHzd3dXbhWUL6J1UvqWzJexErBiEp77g+nDqAmCjAJNbEWwj0maTEVG+zi4lZGQpxdfHi3fjAZ0sDxBfFpWt3vs+rci0egkYMwHGppCCzJU72NkdMz1UVoOIwIMAvQJNuuSgcDRSmQ/da9MteZKfeyNkrF7WfkfD2gulFtZGw9vCRQHoMgcVRdIkejdjVxFrIz4Wj00ltpAj6ZmzXamD7YY4lrYbJYLxhcr8Sv3S24XnKyZ0eGrxnbnliibTzDbODOJWWEAdlJ+QqyON50tRn7ofFCtFX4c8/CU36/pT+yFdXmU2E8KNsnXyzqEoIu6Bs6jH5Idgp5Y+FrfZvBxwFO7r/5PfkLlGo1fKeMZ1QF2GuzTkkF6EzSvzsdlqXLgaIicahKHjitnjeG9HcN3dFPKE0HgDP3Snb3RlYChKFVki7wnXi2iTbP3OLoievgFy7mts7Q9qLkrHtAGoJUX04z0liPB3uEKwulcLOC6LdziUC5q8O2dOSY99swmpsrB3e3bCGGGHu6wXTI0U9UL8vP1r9Nz+7piisIkLXQNeub7lCvHAOV++HkjYdACwF88OHMAP51JLlxoE9ykmEa/cDcznxTJ9E8blW+bgXefKjq+oKqxPbat8ufsMjBdHNJ+OLLAGlV9ZumS2v78KQipWYVvtQ6SQeADAWivK49q2s57GbHxSRxHvY7RSZ1xgu7o4thuKbtVgaFqz5wXpL6dKS4T0Czogvp50QNSIrEevXisScMahxcsNeCVmgYZB2n8VDZqwqjJG3xHbROQRi7vnJjvRZh
 QIxidqX1
 AzHmAMKV1daxiZPTCI5h6oDgvnWJ03E3lAgghSyLxO4Ro8kVkcYn5JgUE84zG/KBi4oJwDjclu549cbn2tam1xCFh7+UmgxFmY0Hey3HANRpLi6Em0DlN2mcyoVQEJpO5N2GZVXtm5k81eHJ92Kap+q5voMR1HdJpAVYYs9hpc98e32rFGOJd4QzPvcw5qB9U5CCoq3AolClfzGm77bt/mJkMEN3iucOL68hZpnMql/zIDqH8ptkgPsfTskl3KrecGdKiyADAQk8frvv1tdTbz2n0tY6eaSqJ3FhWz8faeJvTrHamVarO4Z7s8Xrj7xGL3OZpyPhTfqyP/uTwk0coYYxwOK6sKEo54LDfoEOI5h14bQ7oIQT5+DJPbG9HrEAal2hPud3D20qQ2XjjWeVJ2oEUWhHwHqlZym0d6eyx8HgKi6s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 4:10=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 2025/10/28 01:53, Lorenzo Stoakes wrote:
> > On Wed, Oct 22, 2025 at 12:37:08PM -0600, Nico Pache wrote:
> >> The current mechanism for determining mTHP collapse scales the
> >> khugepaged_max_ptes_none value based on the target order. This
> >> introduces an undesirable feedback loop, or "creep", when max_ptes_non=
e
> >> is set to a value greater than HPAGE_PMD_NR / 2.
> >>
> >> With this configuration, a successful collapse to order N will populat=
e
> >> enough pages to satisfy the collapse condition on order N+1 on the nex=
t
> >> scan. This leads to unnecessary work and memory churn.
> >>
> >> To fix this issue introduce a helper function that caps the max_ptes_n=
one
> >> to HPAGE_PMD_NR / 2 - 1 (255 on 4k page size). The function also scale=
s
> >> the max_ptes_none number by the (PMD_ORDER - target collapse order).
> >>
> >> The limits can be ignored by passing full_scan=3Dtrue, this is useful =
for
> >> madvise_collapse (which ignores limits), or in the case of
> >> collapse_scan_pmd(), allows the full PMD to be scanned when mTHP
> >> collapse is available.
> >>
> >> Signed-off-by: Nico Pache <npache@redhat.com>
> >> ---
> >>   mm/khugepaged.c | 35 ++++++++++++++++++++++++++++++++++-
> >>   1 file changed, 34 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >> index 4ccebf5dda97..286c3a7afdee 100644
> >> --- a/mm/khugepaged.c
> >> +++ b/mm/khugepaged.c
> >> @@ -459,6 +459,39 @@ void __khugepaged_enter(struct mm_struct *mm)
> >>              wake_up_interruptible(&khugepaged_wait);
> >>   }
> >>
> >> +/**
> >> + * collapse_max_ptes_none - Calculate maximum allowed empty PTEs for =
collapse
> >> + * @order: The folio order being collapsed to
> >> + * @full_scan: Whether this is a full scan (ignore limits)
> >> + *
> >> + * For madvise-triggered collapses (full_scan=3Dtrue), all limits are=
 bypassed
> >> + * and allow up to HPAGE_PMD_NR - 1 empty PTEs.
> >> + *
> >> + * For PMD-sized collapses (order =3D=3D HPAGE_PMD_ORDER), use the co=
nfigured
> >> + * khugepaged_max_ptes_none value.
> >> + *
> >> + * For mTHP collapses, scale down the max_ptes_none proportionally to=
 the folio
> >> + * order, but caps it at HPAGE_PMD_NR/2-1 to prevent a collapse feedb=
ack loop.
> >> + *
> >> + * Return: Maximum number of empty PTEs allowed for the collapse oper=
ation
> >> + */
> >> +static unsigned int collapse_max_ptes_none(unsigned int order, bool f=
ull_scan)
> >> +{
> >> +    unsigned int max_ptes_none;
> >> +
> >> +    /* ignore max_ptes_none limits */
> >> +    if (full_scan)
> >> +            return HPAGE_PMD_NR - 1;
> >> +
> >> +    if (order =3D=3D HPAGE_PMD_ORDER)
> >> +            return khugepaged_max_ptes_none;
> >> +
> >> +    max_ptes_none =3D min(khugepaged_max_ptes_none, HPAGE_PMD_NR/2 - =
1);
> >
> > I mean not to beat a dead horse re: v11 commentary, but I thought we we=
re going
> > to implement David's idea re: the new 'eagerness' tunable, and again we=
're now just
> > implementing the capping at HPAGE_PMD_NR/2 - 1 thing again?
> >
> > I'm still really quite uncomfortable with us silently capping this valu=
e.
> >
> > If we're putting forward theoretical ideas that are to be later built u=
pon, this
> > series should be an RFC.
> >
> > But if we really intend to silently ignore user input the problem is th=
at then
> > becomes established uAPI.
> >
> > I think it's _sensible_ to avoid this mTHP escalation problem, but the =
issue is
> > visibility I think.
> >
> > I think people are going to find it odd that you set it to something, b=
ut then
> > get something else.
> >
> > As an alternative we could have a new sysfs field:
> >
> > /sys/kernel/mm/transparent_hugepage/khugepaged/max_mthp_ptes_none
> >
> > That shows the cap clearly.
> >
> > In fact, it could be read-only... and just expose it to the user. That =
reduces
> > complexity.
> >
> > We can then bring in eagerness later and have the same situation of
> > max_ptes_none being a parameter that exists (plus this additional read-=
only
> > parameter).
>

Hey Baolin,

> We all know that ultimately using David's suggestion to add the
> 'eagerness' tunable parameter is the best approach, but for now, we need
> an initial version to support mTHP collapse (as we've already discussed
> extensively here:)).
>
> I don't like the idea of adding another and potentially confusing
> 'max_mthp_ptes_none' interface, which might make it more difficult to
> accommodate the 'eagerness' parameter in the future.
>
> If Nico's current proposal still doesn't satisfy everyone, I personally
> lean towards David's earlier simplified approach:
>         max_ptes_none =3D=3D 511 -> collapse mTHP always
>         max_ptes_none !=3D 511 -> collapse mTHP only if all PTEs are non-=
none/zero
>
> Let's first have an initial approach in place, which will also simplify
> the following addition of the 'eagerness' tunable parameter.
>
> Nico, Lorenzo, and David, what do you think?

I still believe capping it at PMD_NR/2 provides the right mix between
preventing the undesired behavior, and keeping some degree of
tunability, as the admin guides suggests max_ptes_none should be used.
I would be willing to compromise and take this other approach until
the "eagerness" is in place. However, I do believe David's idea for
eagerness is to also cap the max_ptes_none at PMD_NR/2 for the second
to highest eagerness level (ie, 511, 255, ...). So in practice, we
won't see any behavioral changes when that series comes around;
whereas setting max_ptes_none=3D0 for mTHP initially, then adding
eagerness will result in a change in behavior from the initial
implementation.

With that said, Lorenzo, David, What's the final verdict?

-- Nico

>
> Code should be:
> static unsigned int collapse_max_ptes_none(unsigned int order, bool
> full_scan)
> {
>          unsigned int max_ptes_none;
>
>          /* ignore max_ptes_none limits */
>          if (full_scan)
>                  return HPAGE_PMD_NR - 1;
>
>          if (order =3D=3D HPAGE_PMD_ORDER)
>                  return khugepaged_max_ptes_none;
>
>          /*
>           * For mTHP collapse, we can simplify the logic:
>           * max_ptes_none =3D=3D 511 -> collapse mTHP always
>           * max_ptes_none !=3D 511 -> collapse mTHP only if we all PTEs
> are non-none/zero
>           */
>          if (khugepaged_max_ptes_none =3D=3D HPAGE_PMD_NR - 1)
>                  return khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER -
> order);
>
>          return 0;
> }
Side note: Thank you Baolin for your review/testing of the V12 :)
>


