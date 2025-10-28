Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECC05CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 07:15:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26B4D80129; Tue, 28 Oct 2025 03:15:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 243B8800E4; Tue, 28 Oct 2025 03:15:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 158EE80129; Tue, 28 Oct 2025 03:15:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 03202800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 03:15:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 97D2288417
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 07:15:03 +0000 (UTC)
X-FDA: 84046661286.02.CE0DC62
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3274FC000D
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 07:15:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TeW+RFtf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761635701; a=rsa-sha256;
	cv=none;
	b=P25RpkV5BCKgrBTNQKL8UJKA7D+WE6PMffWgrM4ImNaYu5IM0ImVApsWY+v98hQNkuLybh
	u6y0amJBTVdd+LtOOAtJpo4nmPFJm4HfgmG+FN2btw3MOVzOaEVMxaFeHg6phpdVo7hkfx
	uk9tsELCF16cqbZSEYQf0/CZrpWFiRg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TeW+RFtf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761635701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/BC+XqbWq5096AWiK9aNRe/c1+A+9JNeT7isFf/BwWo=;
	b=WCCeQEijbdUqjrw1LIcvTRiHK2IcwahU8ip8HpeGt8UB/0izBJI5+LBNwZ4qTURRPNO0rl
	s3KcrOJeHf7IBjVTfUh5quii+6F1H5ajsVBPziMPkKrREeOAH13zvWVuu01IOBlogumVKJ
	GTwkF+aFEGW2RtAwoLRiUAnbs00AqOE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761635700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/BC+XqbWq5096AWiK9aNRe/c1+A+9JNeT7isFf/BwWo=;
	b=TeW+RFtfqMx15+iLDU6yQJZCSgLNizAZ8R+Rd2aUCHGe3dbyJX1fXll6LGqqZCbruVcbn0
	XMKbRLEqm9AF/EK7pMmHW5d2e0yyrUGqPAaqX5znQBt4WQ2FBFQ6eWXOKTdqmH/id0rR2S
	2u+4WNHH399E0hbV7wiwRiBpoz/PRYY=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-223-qXtuHy3yMtyC6TFxJe6_Kg-1; Tue, 28 Oct 2025 03:14:58 -0400
X-MC-Unique: qXtuHy3yMtyC6TFxJe6_Kg-1
X-Mimecast-MFC-AGG-ID: qXtuHy3yMtyC6TFxJe6_Kg_1761635698
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-651c94351e5so7774967eaf.1
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:14:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761635698; x=1762240498;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/BC+XqbWq5096AWiK9aNRe/c1+A+9JNeT7isFf/BwWo=;
        b=b8Qodmb3dBoZXIqJMH5KlB9SemHbkTr6RM7ZM9d0wyNgU28/Eu4NKJKEtlKYkBuXE6
         6UJXT6JwMq+gaP8Jblyl74SIKQT7QhZbY83CKoiHhbfzxNC95AkkIvLgXMR7V8t9g421
         xAzLcq2aFyotlzEZGGoVkpBUGkG10eqpY+L5ctMlxzqePot3m0d8R9S7JBiA6STbT5yo
         ceoSoVShYbviyVuT37Sop2AuPiuJ0p3BxF4ElSn/82wOpzzxwVMsGm/e7wV4U8A9BW11
         qZ0G2mSszfW8SlHpB1zR8FPUfKL4/iwr69cP0c+sSDxY5esgHduHlFsFQAPkngUyb8Pa
         jZRA==
X-Forwarded-Encrypted: i=1; AJvYcCXFjUU4ghPU6VbsUkt8KjdaBCwznlFnUKRZWcao5H6XOErYRRGbwn6XR2ifF2LY3BmMubE04Lw0HQ==@kvack.org
X-Gm-Message-State: AOJu0YwVN/XlGrYirTCcI/QNwOZRNwIBRtwTZkkiERyzZPKfpsfjmh82
	6hABGv2TCIxEDnWl3NovdqqICC5yD8ePEnTQU9sPlvgIWNzDualcdC4hgdbPSJVmdpSYmV1MbUp
	/LoCl7wg1CzK+3i/4/y5J8fTy1mlccMv1Q4Qmqe1JZAx37RSfbcKAKAX+vpcpzSQFzCbRiKg8j+
	EkWWsxGmFkDKBERQ+J2K9kHhDdy8w=
X-Gm-Gg: ASbGncvBmHiCWUSEm+3ayjdfYWxFfRaAwx+6oBZhwiwxkJrnkFBpestx+/g5FBEc1Z8
	blZoYkpX1ky47qgjzSXzkTNOX9JIgEOsVpy4mxQdG27Gkga055SjLPGwChzC7x8eLa47twLb7ks
	N2A5K0mWu0hrMCxhOpsKprV2+Jc50MDj2q52UW4H6oBnJr3coVzlptO1c7W62/83d5LwWeBs6Ft
	dZ1Be58LOa1qSE=
X-Received: by 2002:a05:6871:7a5:b0:343:a20a:3fd5 with SMTP id 586e51a60fabf-3d5d9b785bdmr1170095fac.40.1761635697816;
        Tue, 28 Oct 2025 00:14:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+T3cBcYqH+eb/J9R0CW4Xnl0EVw1yIHe+P3hMHhWTwp3oTJ/2o8LBuZieKwoUSV26edOHA0l0+TcIqBFEY1k=
X-Received: by 2002:a05:6871:7a5:b0:343:a20a:3fd5 with SMTP id
 586e51a60fabf-3d5d9b785bdmr1170068fac.40.1761635697477; Tue, 28 Oct 2025
 00:14:57 -0700 (PDT)
MIME-Version: 1.0
References: <20250610035043.75448-1-dev.jain@arm.com> <20250610035043.75448-3-dev.jain@arm.com>
 <726dcb51-82a7-49a7-a8e5-49bc3eb05dcf@redhat.com> <92327ea4-cd11-41d4-9a72-7040281e12af@arm.com>
In-Reply-To: <92327ea4-cd11-41d4-9a72-7040281e12af@arm.com>
From: David Hildenbrand <david@redhat.com>
Date: Tue, 28 Oct 2025 08:14:46 +0100
X-Gm-Features: AWmQ_bmyzDBtfw3Y7a7QvL2WNOYa7E1Yd2xIxnI6CpiB7wE4dSQrRg9oT5LzgMc
Message-ID: <CADFyXm4PaFQ4q_TA2_AUnmfeuH4M2PKeKeWbZevq3wtt9N890Q@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] mm: Optimize mremap() by PTE batching
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, vbabka@suse.cz, jannh@google.com, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	peterx@redhat.com, ryan.roberts@arm.com, mingo@kernel.org, 
	libang.li@antgroup.com, maobibo@loongson.cn, zhengqi.arch@bytedance.com, 
	baohua@kernel.org, anshuman.khandual@arm.com, willy@infradead.org, 
	ioworker0@gmail.com, yang@os.amperecomputing.com, 
	baolin.wang@linux.alibaba.com, ziy@nvidia.com, hughd@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Gf9PHo89kzSCebqvFxsPRbgVLvL2f_yMC4kZcPIKhN0_1761635698
X-Mimecast-Originator: redhat.com
Content-Type: multipart/alternative; boundary="000000000000f8dd46064232c539"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3274FC000D
X-Stat-Signature: erf8p6ktbnbpfp4t1gbmppikb5bmzwc9
X-HE-Tag: 1761635701-745571
X-HE-Meta: U2FsdGVkX19EIU0uplkIAmzM2eCFTfEIAQbazi7iIP0xluxLZ3B1ah70Gi1KXncx3EJcAuxevxBAHPBbTQgaMLqsIZ+4f1f935F+C1JaFZZm6zjX39snrxyHIxot7gWkpNv5mq4+sUI/f3jz+4oSqGBUS4ySvGsMVDgr73D8qXdwqb8YtmMtqwtd/r6lcL2fUbkjQ73Vr7k0ZUVBa9FDD8aN0iu+VSg+WOkbp90fUWhTmeB9JDFO5dul4G8EeyYrz8qMY7/Tiy6i5u1oPtKcnvwWOTdtKnSli7o532wCAOiLObZtmcdAUGq0cAF0PAss0psNaYQW5zZSVH9m6eWzfwYtDEpgkksYuoRDIFqCThLYmk1FiJ7PuUyAas3Adzej7aBRcDFq1/U5q6aVH86cRm0cZd0NnmoAkkD6aXWG1WX4du3pfvL8P9Yy90igngotpxF2zcauo7WZwK/Abg71OT+Ec0Z/RrCYHTnkTCvrABIITRv1rIlRg3Fqrp9oVd4NvESyG9Oxwr1xHf6Dy8WfMWA3wOKnXFzmFc7tCr8laL+ygoaLL9kXcoNZZlWtXRNFSnrFnYFdWbVp9DdDr3R0DCnU8iPhvRk+DZvZgaxS6PrzYxnt2dH2XhsOgEE9E3TLsoGQOeDpdDi21Ekie4g42+dCRgAevM8FdIkVe382qUSEWus+kN8QhbnaGc7GzrxzSo/wrKooq+MdbNCy9YyhBYWT+xIxn9vWpONlFbDY16Pqfzosok7DHmU+pgCufpXUHtlxcfKJ4L/RaacURxMoH3T0iLPW/m+2NyW+m/W/hcA4Wp+nLTFWD+1+l9wjxLE3w6MY32abCULynCiqZTPOr6lsT+Ux6UUCfMxRcXdZtwcEabrWkWcCJw5gAEuysXsxwXJm8krsKCZiZMbwnk+fLFad6zQfpP0pQNsQij97tQ2YPUNYrS4203FEYJ/FmXu5GlgrIPL6ywWCFuFpyUb
 jF4hUva3
 yndqCQggCNigp8A53cAjzUffPxUnjtTPF/I4dPU8CkBQZd7WEMPdNaQJxrAQmyPrAl3PGocRO21TIrNG2DUWupVTrlOrY7Jb97CP8zlfW7tp4INK1nRBh6ob2T2H+19Pi1rJ5+VdV46IipEsiiJb0CJ0vjCT9yf5U6MBU3J8Pr/c9g8szWSCBGffH6mppecpsiGmPrrCe/6Yd0kYwE54vMMPX1thsyb0c3C0bcKrXltxp5DGXf1SsE6fhs7ikQvhixpW6/KknB3XVLMB0C/r3j5fppVN3S6Tq9f6swER1ZUQnV2NLzSreezIj94oqM481KttergvxN98+d27bHMWYN9fLGpHiZa1ekWlrLbgOFTE6QSglpGRR3E8L4c2RwB9x911cEnYkwCaVB8RfJ+HJ9u3nRbPi/qzz75yv+NJlPjeYAEYCV8z7rS8aNp5LdM3Y+isjLa44FMa+eFWitmSbqEDDTDIDsU+B1643K77mK4RcfLHtJEqlp6IMIGqFu1LHdYV9+VlkM02I1OPY9k7BiGBFtHtNb3c2bU2jzFb0nDpd9lCw1aEn9eTLlXmZi8/9NBh3/xas2xWibVrH9EwqMcqoHwZQC9KZaTmWmHMvjyPdaXzMPiEcr0h28QPUzIuY7Ss3aFMO9NDrsy0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000f8dd46064232c539
Content-Type: text/plain; charset="UTF-8"

Dev Jain <dev.jain@arm.com> schrieb am Di. 28. Okt. 2025 um 06:32:

>
> On 28/10/25 3:10 am, David Hildenbrand wrote:
> > On 10.06.25 05:50, Dev Jain wrote:
> >> Use folio_pte_batch() to optimize move_ptes(). On arm64, if the ptes
> >> are painted with the contig bit, then ptep_get() will iterate through
> >> all 16
> >> entries to collect a/d bits. Hence this optimization will result in a
> >> 16x
> >> reduction in the number of ptep_get() calls. Next, ptep_get_and_clear()
> >> will eventually call contpte_try_unfold() on every contig block, thus
> >> flushing the TLB for the complete large folio range. Instead, use
> >> get_and_clear_full_ptes() so as to elide TLBIs on each contig block,
> >> and only
> >> do them on the starting and ending contig block.
> >>
> >> For split folios, there will be no pte batching; nr_ptes will be 1. For
> >> pagetable splitting, the ptes will still point to the same large folio;
> >> for arm64, this results in the optimization described above, and for
> >> other
> >> arches (including the general case), a minor improvement is expected
> >> due to
> >> a reduction in the number of function calls.
> >>
> >> Signed-off-by: Dev Jain <dev.jain@arm.com>
> >> ---
> >>   mm/mremap.c | 39 ++++++++++++++++++++++++++++++++-------
> >>   1 file changed, 32 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/mm/mremap.c b/mm/mremap.c
> >> index 180b12225368..18b215521ada 100644
> >> --- a/mm/mremap.c
> >> +++ b/mm/mremap.c
> >> @@ -170,6 +170,23 @@ static pte_t move_soft_dirty_pte(pte_t pte)
> >>       return pte;
> >>   }
> >>   +static int mremap_folio_pte_batch(struct vm_area_struct *vma,
> >> unsigned long addr,
> >> +        pte_t *ptep, pte_t pte, int max_nr)
> >> +{
> >> +    const fpb_t flags = FPB_IGNORE_DIRTY | FPB_IGNORE_SOFT_DIRTY;
> >> +    struct folio *folio;
> >> +
> >> +    if (max_nr == 1)
> >> +        return 1;
> >> +
> >> +    folio = vm_normal_folio(vma, addr, pte);
> >> +    if (!folio || !folio_test_large(folio))
> >> +        return 1;
> >> +
> >> +    return folio_pte_batch(folio, addr, ptep, pte, max_nr, flags, NULL,
> >> +                   NULL, NULL);
> >> +}
> >
> > Dev, I think there is another bug hiding in here. That function ignores
> > the writable bit, which is not what you need here, in particular for
> > anonymous folios in some cases.
> >
> > Later set_ptes() could end up marking ptes writable that were not
> > writable
> > before, which is bad (at least for anonymous folios, maybe also for
> > pagecache
> > folios).
> >
> > I think you really must respect the writable bit through something like
> > FPB_RESPECT_WRITE.
> >
> > I patched out the "pte_batch_hint(ptep, pte) == 1" check we have upstream
> > to make it reproduce on x86_64, but the following reproducer should
> > likely
> > reproduce on aarch64 without further kernel modifications.
>
> You are right. Thanks! I recall during the mremap/mprotect stuff I had
> completely
>
> forgotten that batching by default ignores the writable bit and
> remembered it during
>
> the last version of mprotect series :(
>
>
> Thanks for giving a reproducer; for some reason I am unable to reproduce
> on my machine as-is.


(Writing from gmail app, probably it will mess up html)

I think leaving only a single page unshared is not sufficient. Try with 16,
such that they will be pte-cont and make the initial hint check happy.


>

--000000000000f8dd46064232c539
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div><br></div><div><br><div class=3D"gmail_quote gmail_quote_container"><d=
iv dir=3D"ltr" class=3D"gmail_attr">Dev Jain &lt;<a href=3D"mailto:dev.jain=
@arm.com">dev.jain@arm.com</a>&gt; schrieb am Di. 28. Okt. 2025 um 06:32:<b=
r></div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border=
-left:1px #ccc solid;padding-left:1ex" dir=3D"auto"><br>
On 28/10/25 3:10 am, David Hildenbrand wrote:<br>
&gt; On 10.06.25 05:50, Dev Jain wrote:<br>
&gt;&gt; Use folio_pte_batch() to optimize move_ptes(). On arm64, if the pt=
es<br>
&gt;&gt; are painted with the contig bit, then ptep_get() will iterate thro=
ugh <br>
&gt;&gt; all 16<br>
&gt;&gt; entries to collect a/d bits. Hence this optimization will result i=
n a <br>
&gt;&gt; 16x<br>
&gt;&gt; reduction in the number of ptep_get() calls. Next, ptep_get_and_cl=
ear()<br>
&gt;&gt; will eventually call contpte_try_unfold() on every contig block, t=
hus<br>
&gt;&gt; flushing the TLB for the complete large folio range. Instead, use<=
br>
&gt;&gt; get_and_clear_full_ptes() so as to elide TLBIs on each contig bloc=
k, <br>
&gt;&gt; and only<br>
&gt;&gt; do them on the starting and ending contig block.<br>
&gt;&gt;<br>
&gt;&gt; For split folios, there will be no pte batching; nr_ptes will be 1=
. For<br>
&gt;&gt; pagetable splitting, the ptes will still point to the same large f=
olio;<br>
&gt;&gt; for arm64, this results in the optimization described above, and f=
or <br>
&gt;&gt; other<br>
&gt;&gt; arches (including the general case), a minor improvement is expect=
ed <br>
&gt;&gt; due to<br>
&gt;&gt; a reduction in the number of function calls.<br>
&gt;&gt;<br>
&gt;&gt; Signed-off-by: Dev Jain &lt;<a href=3D"mailto:dev.jain@arm.com" ta=
rget=3D"_blank">dev.jain@arm.com</a>&gt;<br>
&gt;&gt; ---<br>
&gt;&gt; =C2=A0 mm/mremap.c | 39 ++++++++++++++++++++++++++++++++-------<br=
>
&gt;&gt; =C2=A0 1 file changed, 32 insertions(+), 7 deletions(-)<br>
&gt;&gt;<br>
&gt;&gt; diff --git a/mm/mremap.c b/mm/mremap.c<br>
&gt;&gt; index 180b12225368..18b215521ada 100644<br>
&gt;&gt; --- a/mm/mremap.c<br>
&gt;&gt; +++ b/mm/mremap.c<br>
&gt;&gt; @@ -170,6 +170,23 @@ static pte_t move_soft_dirty_pte(pte_t pte)<b=
r>
&gt;&gt; =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return pte;<br>
&gt;&gt; =C2=A0 }<br>
&gt;&gt; =C2=A0 +static int mremap_folio_pte_batch(struct vm_area_struct *v=
ma, <br>
&gt;&gt; unsigned long addr,<br>
&gt;&gt; +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pte_t *ptep, pte_t pte=
, int max_nr)<br>
&gt;&gt; +{<br>
&gt;&gt; +=C2=A0=C2=A0=C2=A0 const fpb_t flags =3D FPB_IGNORE_DIRTY | FPB_I=
GNORE_SOFT_DIRTY;<br>
&gt;&gt; +=C2=A0=C2=A0=C2=A0 struct folio *folio;<br>
&gt;&gt; +<br>
&gt;&gt; +=C2=A0=C2=A0=C2=A0 if (max_nr =3D=3D 1)<br>
&gt;&gt; +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 1;<br>
&gt;&gt; +<br>
&gt;&gt; +=C2=A0=C2=A0=C2=A0 folio =3D vm_normal_folio(vma, addr, pte);<br>
&gt;&gt; +=C2=A0=C2=A0=C2=A0 if (!folio || !folio_test_large(folio))<br>
&gt;&gt; +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 1;<br>
&gt;&gt; +<br>
&gt;&gt; +=C2=A0=C2=A0=C2=A0 return folio_pte_batch(folio, addr, ptep, pte,=
 max_nr, flags, NULL,<br>
&gt;&gt; +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 NULL, NULL);<br>
&gt;&gt; +}<br>
&gt;<br>
&gt; Dev, I think there is another bug hiding in here. That function ignore=
s<br>
&gt; the writable bit, which is not what you need here, in particular for<b=
r>
&gt; anonymous folios in some cases.<br>
&gt;<br>
&gt; Later set_ptes() could end up marking ptes writable that were not <br>
&gt; writable<br>
&gt; before, which is bad (at least for anonymous folios, maybe also for <b=
r>
&gt; pagecache<br>
&gt; folios).<br>
&gt;<br>
&gt; I think you really must respect the writable bit through something lik=
e<br>
&gt; FPB_RESPECT_WRITE.<br>
&gt;<br>
&gt; I patched out the &quot;pte_batch_hint(ptep, pte) =3D=3D 1&quot; check=
 we have upstream<br>
&gt; to make it reproduce on x86_64, but the following reproducer should <b=
r>
&gt; likely<br>
&gt; reproduce on aarch64 without further kernel modifications.<br>
<br>
You are right. Thanks! I recall during the mremap/mprotect stuff I had <br>
completely<br>
<br>
forgotten that batching by default ignores the writable bit and <br>
remembered it during<br>
<br>
the last version of mprotect series :(<br>
<br>
<br>
Thanks for giving a reproducer; for some reason I am unable to reproduce <b=
r>
on my machine as-is.</blockquote><div dir=3D"auto"><br></div><div dir=3D"au=
to">(Writing from gmail app, probably it will mess up html)</div><div dir=
=3D"auto"><br></div><div dir=3D"auto">I think leaving only a single page un=
shared is not sufficient. Try with 16, such that they will be pte-cont and =
make the initial hint check happy.</div><div dir=3D"auto"><br></div><blockq=
uote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc =
solid;padding-left:1ex" dir=3D"auto"></blockquote><blockquote class=3D"gmai=
l_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left=
:1ex" dir=3D"auto">
<br>
</blockquote></div></div>

--000000000000f8dd46064232c539--


