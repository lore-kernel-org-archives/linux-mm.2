Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12CE2CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 18:02:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E85A8E0005; Fri,  7 Nov 2025 13:02:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C0108E0002; Fri,  7 Nov 2025 13:02:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F17888E0005; Fri,  7 Nov 2025 13:02:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E05CC8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 13:02:08 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 31D0C597B9
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 18:02:08 +0000 (UTC)
X-FDA: 84084579936.05.7C6DB13
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9417480004
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 18:02:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UCYoZ7bv;
	spf=pass (imf30.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762538525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o03EPvkF1Ee4HFaXHVj6CmMYvciS5SYoQDAqRDI5EK0=;
	b=NSHRqZEfuZ825SUq7T3n+WngnUD/Rn1gqhMFvMvcH/C72z5aoXc82s0tclho7NH8G5Pu9W
	AsTCVpuFnayxY//gt0CSHzmFyFWQDWLAfv1v/TqJjH9IAwcKeuxojvvJsmCUHMp9qmag4M
	M87Gu9VfpzB8KQ346HEB7Zm3I35HXIw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UCYoZ7bv;
	spf=pass (imf30.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762538525; a=rsa-sha256;
	cv=none;
	b=Uw/fbaFmo+SlVupf8kONB/56buLHu66t9dqzQwWBWXlgRPrFZ85Lw02ewgmfR0/loLUp2/
	6NsAMyWWqmGuAWbFWnFgYieazEyY8rHdEkREgRbYx/R054vZyN+BWfsXebmYxU+iLZhSt6
	hNVZIqSjT6JuX8UlDU4lBGgK6sSOf94=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762538524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o03EPvkF1Ee4HFaXHVj6CmMYvciS5SYoQDAqRDI5EK0=;
	b=UCYoZ7bvXG3l0NnK6oCdzRpz5MkC51SxaexdhD86CsQ+EUkCb30N8D/j8rm5ed71X2L0oJ
	exNoGOfOPhIu4CXHcmPdNCMYOtKN+jFb7WfUdeABAp8UpvFde8Gk6TlVu3G89seX95muep
	YV6DoiV0WLp1KtUS8EhuL4QOXw3bINY=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-442-VZCyFR9aNvat3N2NEmQGvQ-1; Fri, 07 Nov 2025 13:01:55 -0500
X-MC-Unique: VZCyFR9aNvat3N2NEmQGvQ-1
X-Mimecast-MFC-AGG-ID: VZCyFR9aNvat3N2NEmQGvQ_1762538514
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-63e324b2fd0so1398828d50.2
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 10:01:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762538513; x=1763143313;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=o03EPvkF1Ee4HFaXHVj6CmMYvciS5SYoQDAqRDI5EK0=;
        b=YIa8W+WSBtDbG7SXzoY1/UxzTIMcuxSOh66AhLXhk7RO7nHPiXcm/zpff3LcmZkAmZ
         FgYRXG8M3TnVXK//05dbcZih/5bl9QTzPFhTOFJifGj6hP724dlx/j8/8clR82p+jvnI
         X1W+2xvvFWqeRkGw8i4O3SVUn7i1QuMSOCHnBIJ55U4UULF6qq4wSsI6fn7ThH8fk5vh
         vCMbkpMhGEBMFfRzmed8fyxj1yNk5PgH0p9eRsCfqwto0cRBZ0vjA2r5rBNYQly/RngD
         eD3sKcK/5mTKjqSUxGD3ETK1+6H18sERmV8OrdCLwGHILv5pokwnwpP/B8baMxB9FHGm
         pnGQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4jfAjXC5S1qpihiXdxSK+IlKt6nMW+rP2i2m6GEW/z3iweFQQ6FlrX77u6YMGpVy2S3i0uX4qrQ==@kvack.org
X-Gm-Message-State: AOJu0YzMwyXHg5bBqOWzgoIA8lfB9YFqSli/uC8eFKQ7t8DOWC28pRvL
	+9Dw8Ry7vA2Jrytr0PuzpLmqIGFSruEmMTCKXxI7hhsYM5jZPxLmgIiSDO3t5KpOpx4evCf72VF
	CBvRjKbsg3fYOHASDefbnIQkeIMxknPpLRTBFHxPZLx3AVGfaqdgYxIlgPlM40g9AOI1kDc3Cda
	Y2K8aS08VfVBF3vi8pWIZiPnseS6wnWdEwywAbww==
X-Gm-Gg: ASbGncuO5iyb1gFSwfhRjkl+QWoUZcxuKCGYjlusvFWd/xP9oenGbmzwI3ixxZt1wwN
	j/wzOOsmzltac8YNwAAxjQqWkATQx9jN/FLXbjAglsQfeibp4jWEBPU8+jpHgFyU533mRQ8eGLc
	dOUVcr6md03tJ+jFP7xvtOwi8nHIQtN4aIN5xvi9og8Bk3Gc1b2haSgJhrirHLu2Gmr0uI0A==
X-Received: by 2002:a05:690e:2417:b0:63f:b4d8:1f3c with SMTP id 956f58d0204a3-640c42dac2dmr2587410d50.35.1762538512741;
        Fri, 07 Nov 2025 10:01:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGjLDv5pucIrLunFcmpT5DImh7xOQHAmSWOhb/WF5swQ3zC4ISlOHgSzClnhRgLhl4xOKSEVGJksfqOFQroVQk=
X-Received: by 2002:a05:690e:2417:b0:63f:b4d8:1f3c with SMTP id
 956f58d0204a3-640c42dac2dmr2587310d50.35.1762538511869; Fri, 07 Nov 2025
 10:01:51 -0800 (PST)
MIME-Version: 1.0
References: <20251022183717.70829-1-npache@redhat.com> <20251022183717.70829-12-npache@redhat.com>
 <5b2dbd05-094f-452a-8067-d342b2819af9@lucifer.local>
In-Reply-To: <5b2dbd05-094f-452a-8067-d342b2819af9@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Fri, 7 Nov 2025 11:01:23 -0700
X-Gm-Features: AWmQ_bnZCljbkWgTreWCIKIWGk5V1YSCEzkc_26ghNPznQVbhA9Vnvap7t_CMZI
Message-ID: <CAA1CXcDG8=89uPcptkRv23JfmczAGp6_KQMQOFhQ6Uivo-33kw@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 11/15] khugepaged: introduce
 collapse_allowable_orders helper function
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
X-Mimecast-MFC-PROC-ID: Srav3XxNkkiwlwihvkHHJi1vPsR7FEmWn80vXBKCohQ_1762538514
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9417480004
X-Stat-Signature: xdphiiucdjg4jd3fx1xtismijwtqae4f
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762538525-157636
X-HE-Meta: U2FsdGVkX19Xqgt+AKADF3Ysz4/rEnlxtQAjt79dfelzkAHm+lI6sKyc991cWIf8YAPCsqMQUWHNoZX0mHJmji4XRQejgWcX11lqzmEpqgRztuSm6cEI+O9QuivtKiw/S96JRcOE0En665C0ungdNZ+76QU1vRcbk32+V0DCzEQx1TxXwPf5pQAXfF5yd8GKHuztkSX+v6jYgPguwW2+gUPqWQnuHWstAz6Jw170hyiLBD2wR34H0e72jUFOnFmeKWiLhXg5LMe4LtZ1RQM7ccmIHw9eNpj2FaLuJXNunrz9VcU1cyV/28aHfA1GHTAJtU2AhCon2EdVN+p1Px/tu52daokDtnU5tYT+BGcyyt04O+N+iKaCXyKdcUBGzfhxGDnchobhhwj+g8Ygp++9caqKxQVc/5swgESwfRqTob5AMl0SYd0ACZsmKfXs/tU4gkyMNy1PX6eQbw3btKyLnoPtc2LqgvCmRtv/22Csc9M5LwDxiYRVSGcN6kbtjp8A5tE64ySjjgE14WvLDnGS1Ce8/+aL4Z3UCiJWIs6UJpBY5AXNIogwv2ocXo3MGLLpU4S05ZyegcVurdaLBsC8+0yGlTAuT6mefKYLH0VOiJtQ9p+Br95EahL1TNpVAPHvWeDDP4x/hvlSgobaQNhizxqTmiPBFWKwy/midmYQgbH+8lsoXppyp7qTHOQrhUTJbaDgoREM0z0+YwfElQ4chHIll8NpLOExMd91HIdXfcDCa4+f90uYDt4HctlrE27mCm3oQJfsVHesPTKB97gC58HLuWIaDOBCamRsY4gub8BbCpqrxZ8NNiEDxChHolkEYlppZ4y5WOp/fsyc4tQ+UwhUKrAdMSRvpXAvvb097HWMFSzdOhTRCJ1Zo8mWlx+UvHwB3LfLBhVc/TKkJPLqeDxDExMuGbzAXBJKeO21jcQ8wASbmvqleZqPu6fwZAtq5Gj/KBwK+zcN5F0hBXp
 M432ZznT
 +lhxqpCCb0GeLfuHMst0XLdHsu+RDH7YIWD4R5sCtGwxj8OPxWyvp/PHoVUcMiwpTHM+KVnu7v4v2saZZW0FmZJX7GXw3hFUpbWqhnmGemwzlWcVA6rv+5Rr0GxzD2tGpiEnAgrbAkfPvGYXnONVaeL/8BVZpl1O2b6dj080M4MYQPBR2hNqNmWXRvoAsBfGbnhiBtUriyEfzLAcjTZnKauB6WupJmlyozFF+hNnd9d24z9qKSG0A+s45bqM75zZAWKAUXjxIlXUGecKkPLd8SISul+X1VVYC5jRW1DnCs4cOy3MDk50HuYTot9XKlP2fFrgo7bCDVWEvtt3EwSDPu9LyzjITvx/GhIboQthk89KxzjZQLcfSHkgT6boeNQLYVh674DFvX4I6FcfilqYtkyRuMBZFe/XiLlAYxYZMBmGRtiFegsCUvbE+llRjaovh8ZCHGKvezSqAZIqrNjawyUMex1/xHGUeFx9msGIUyRO3Gbnmqly/vqqxUepJjOvGbfBBTsWQqPuJELHgsSddC6HQzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 6, 2025 at 11:51=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Oct 22, 2025 at 12:37:13PM -0600, Nico Pache wrote:
> > Add collapse_allowable_orders() to generalize THP order eligibility. Th=
e
> > function determines which THP orders are permitted based on collapse
> > context (khugepaged vs madv_collapse).
> >
> > This consolidates collapse configuration logic and provides a clean
> > interface for future mTHP collapse support where the orders may be
> > different.
> >
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Signed-off-by: Nico Pache <npache@redhat.com>
>
> With nits below adddressed, LGTM so:
>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Thank you!

> > ---
> >  mm/khugepaged.c | 15 ++++++++++++---
> >  1 file changed, 12 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 0dbbe04c31fe..89a105124790 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -489,7 +489,16 @@ static unsigned int collapse_max_ptes_none(unsigne=
d int order, bool full_scan)
> >       max_ptes_none =3D min(khugepaged_max_ptes_none, HPAGE_PMD_NR/2 - =
1);
> >
> >       return max_ptes_none >> (HPAGE_PMD_ORDER - order);
> > +}
> > +
> > +/* Check what orders are allowed based on the vma and collapse type */
> > +static unsigned long collapse_allowable_orders(struct vm_area_struct *=
vma,
> > +                     vm_flags_t vm_flags, bool is_khugepaged)
> > +{
> > +     enum tva_type tva_flags =3D is_khugepaged ? TVA_KHUGEPAGED : TVA_=
FORCED_COLLAPSE;
> > +     unsigned long orders =3D BIT(HPAGE_PMD_ORDER);
>
> Nit, but can const-ify.

It becomes a function of is_khugepaged in a later patch.

>
> >
> > +     return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders)=
;
> >  }
> >
> >  void khugepaged_enter_vma(struct vm_area_struct *vma,
> > @@ -497,7 +506,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vm=
a,
> >  {
> >       if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
> >           hugepage_pmd_enabled()) {
> > -             if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED=
, PMD_ORDER))
> > +             if (collapse_allowable_orders(vma, vm_flags, true))
>
> If we have a 'mystery meat' boolean parameter can we always use the conve=
ntion of:
>
> collapse_allowable_orders(vma, vm_flags, /*is_khugepaged=3D*/true)
>
> Please? Same goes for other invocations obviously.

Sounds good! I'll fix those up.

Thanks,
-- Nico

>
>
> >                       __khugepaged_enter(vma->vm_mm);
> >       }
> >  }
> > @@ -2567,7 +2576,7 @@ static unsigned int collapse_scan_mm_slot(unsigne=
d int pages, int *result,
> >                       progress++;
> >                       break;
> >               }
> > -             if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUG=
EPAGED, PMD_ORDER)) {
> > +             if (!collapse_allowable_orders(vma, vma->vm_flags, true))=
 {
> >  skip:
> >                       progress++;
> >                       continue;
> > @@ -2873,7 +2882,7 @@ int madvise_collapse(struct vm_area_struct *vma, =
unsigned long start,
> >       BUG_ON(vma->vm_start > start);
> >       BUG_ON(vma->vm_end < end);
> >
> > -     if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLA=
PSE, PMD_ORDER))
> > +     if (!collapse_allowable_orders(vma, vma->vm_flags, false))
> >               return -EINVAL;
> >
> >       cc =3D kmalloc(sizeof(*cc), GFP_KERNEL);
> > --
> > 2.51.0
> >
>


