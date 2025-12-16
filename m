Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB5E1D637B3
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 23:27:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 153C56B0088; Tue, 16 Dec 2025 18:27:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 101926B0089; Tue, 16 Dec 2025 18:27:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F172F6B008A; Tue, 16 Dec 2025 18:27:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC1D36B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 18:27:28 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8F8811360E5
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 23:27:28 +0000 (UTC)
X-FDA: 84226922976.10.732ACC4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 38301140006
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 23:27:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WbpMveA0;
	spf=pass (imf23.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765927646; a=rsa-sha256;
	cv=none;
	b=xK/OkbHEQwTxBonG2mPMDreLddOR+65KHyLZ3dx09pPMOlac699GnNyDpg5sk8ZFjJmn4N
	nEkFcHmhffnrynGjx1dlJ2CuWY7RCUAfRncPoY5a7YmHPU7KUnCMAjdedNQTenGDN1GcTw
	GzUQgF1rg7g1DlZkjaM/rYKNlcDgA4c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WbpMveA0;
	spf=pass (imf23.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765927646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EKXCsKPTv+XkNeXWtY2Ss72qFYFJMdd6YX+r4JT7Hy0=;
	b=kRLqumgtc4HmVJUa9xCwcsMhHVBdYBOa+Q81K2ngBfdmaRvLo5XByFxxjDxHtLYZ33bpSt
	ju9f2xyHoed+VqABup3OiBF54btkasFRB9TlgoYYRmUWdqyI7dRE8Sic4xyXkbEeRTROGV
	Eow9K7k1O9YuLTfLdZj7uBeqAdFMVfk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765927645;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EKXCsKPTv+XkNeXWtY2Ss72qFYFJMdd6YX+r4JT7Hy0=;
	b=WbpMveA0v7vkkZvqw42EPc1C4Cr/AdMq6PIhRYiQacn6S3sKZaayzoYiJNws8jR8xsfxaf
	n4himtxnOR24r7AGFnrw6Tc/w7jG2/zE8W/eNapMsTjn2iZk2RP8DOCScWitV9OHWh+EZz
	qUhJ83UiP6BDyg7jE5Qn4YjHUHcb0AQ=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-495-yjLa_HkaM2-3zaASvG-1oQ-1; Tue, 16 Dec 2025 18:27:24 -0500
X-MC-Unique: yjLa_HkaM2-3zaASvG-1oQ-1
X-Mimecast-MFC-AGG-ID: yjLa_HkaM2-3zaASvG-1oQ_1765927644
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-63e324b2fd0so8962495d50.2
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:27:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765927644; x=1766532444;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EKXCsKPTv+XkNeXWtY2Ss72qFYFJMdd6YX+r4JT7Hy0=;
        b=Y28OFgO9lUyDu8oUTJk52qrJ4Tg1eM/6hFx/4ypf1R+v6l6TyCXmtWKc1jMn3QaoN7
         G9/89YI+k975BqrpcZDmqLs7CZiZUmZFCDXwj+sFN7qPVqY+4uEkyY7/MkvvcJsReori
         JYQHPdM7TK4tXqqetrzO7gMnpiO9Az+DRtkP4gSkvJFTlcw4CvdRmlsHsH6laO4AuHVJ
         CqlOOrlOkZ9b1tUDUxWlOZSF9y36WBfj4r0iuFnaUzROdgT7a/cCb9YQj7Aj5VSTXa2k
         ojLfTukHn1YVu4aPBtZ5tVcvQNl2D/eNWZAqYN0RxmJHAv8UCNWUXIJBf5R+pb+/b/vm
         PIyw==
X-Forwarded-Encrypted: i=1; AJvYcCVWw/92UTtyMio4sWFPooam1e7FJV/3aF/gWlqJlqlmofpj9SK8A+K/NgoF7d247Ioe2LqOQsto2w==@kvack.org
X-Gm-Message-State: AOJu0Yyo19BJC2XLPgz4GC2NHYB7t7cBhI04UrQqzkP9h2v9dfwCPOzw
	IHN3iKkyXjfx2MIJ5JQWJ1U0tKcKu89kioyAhEOKCoBBaovVeeNICrqOF0Z1cEDN1AURe4sfwNx
	TPDMr60KVeTckGjAudKrQp7Fb05vllIjiG67XQlWCTQTcJqju89cPZV8B2blDoHvYDOdAy8prBH
	PQ2DcXHEiKosfG0XS7JcmAFzOqP0E=
X-Gm-Gg: AY/fxX4uy5XfnkYmpUyqnPq2EHWsY8gcUvIj9XTj+WTusIYj0lOulcSKNKwjmOoxwfJ
	TfsxSqarc/nyvAYD8PmgxXMRVR7+ZkwQm8BlYfy3oEek56OsAY+1CH8Dx5iqQf1eZvA4uB7MAyI
	59yOnnhrqcUl0WBQyEB3gGWOg27bWRpcccgyB55mr6TIff4WCtmZ89O0w+cc+8hnAF//A=
X-Received: by 2002:a05:690e:1505:b0:644:60d9:8679 with SMTP id 956f58d0204a3-645556807a8mr10997273d50.94.1765927643886;
        Tue, 16 Dec 2025 15:27:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEGPptQk13QsvmOa5ZHpogOK1FLJvsnDQ3rrdzWxnJedT+7pDWOuGlSfHFv7sLII7QbkA9GW4MowA4H4/Vq3XI=
X-Received: by 2002:a05:690e:1505:b0:644:60d9:8679 with SMTP id
 956f58d0204a3-645556807a8mr10997248d50.94.1765927643468; Tue, 16 Dec 2025
 15:27:23 -0800 (PST)
MIME-Version: 1.0
References: <20251201174627.23295-1-npache@redhat.com> <20251201174627.23295-8-npache@redhat.com>
 <95b1403f-3ddb-43ff-b481-2ecc6ab8352f@linux.alibaba.com>
In-Reply-To: <95b1403f-3ddb-43ff-b481-2ecc6ab8352f@linux.alibaba.com>
From: Nico Pache <npache@redhat.com>
Date: Tue, 16 Dec 2025 16:26:57 -0700
X-Gm-Features: AQt7F2p-rngtJz0og9IaebCiPEhh7WjpdRAgI0DfLNPmmyQ8daD3M_WcJSO7CnI
Message-ID: <CAA1CXcCtp2OwTmm-1EYUpOhsey1sv7CRFu8454m16C=k9iaN6g@mail.gmail.com>
Subject: Re: [PATCH v13 mm-new 07/16] khugepaged: introduce
 collapse_max_ptes_none helper function
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com, 
	ziy@nvidia.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
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
X-Mimecast-MFC-PROC-ID: Eu633Y0uaZhpjJ8Ctvg0xLokJOeugpsf52LJCxezK5Y_1765927644
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 38301140006
X-Rspamd-Server: rspam04
X-Stat-Signature: amryy9nt64iwp97n5oes7gng9m6toa84
X-HE-Tag: 1765927646-886208
X-HE-Meta: U2FsdGVkX1+4z64MbH5eATwJBK8LMYPQhBKwFNDfBx9rRSg9cvF+WXhXbXJh3cyhh2563UIMdXsespgXxJzDOgPXOpBlpOqEpqMR8OAy45QLLzwZl+skj7aLrfpQlAfNhd7fB3ATpdKM1XbCsYl+WceA4plJyXzh65RSnuYc5+utDAexjfQW+7YGDWDup3reRWQifVaQC5tTQ6CrU0NQmLwejFlkUxxVSmzPSRMX5MdRywLdVmJ09blrmECYQoDAj0u1ktN6UVM+Y1czuYh1p2LN4zkc78iUDoYJdkaK5DEWPosl2wmxntQoQ3KpWsiWe2hYfoSrAWlIDmH+MqvF1WLVur8nQTKtQFzKVgMbVaKxxMWJix8ngZkmVGHcABRQF53fVrx521U6tP+XKrKTIgEd7E5IraoSxoO7KRe6T9yRhaBFpKJHQZt7GLADSNykMEevP1nl0xv/OWTbhKeTlsiZI2F9Uy6s8IMbQTYBtI8wGN4+2RprBmAaUKj2+EtPsFeYLf8rLIhKl4jR9gCoVgOiHRFh8cnxyrr7ZyQYD9Y3PXSr2w5Jqw3oqdC3VyCYeZpP15ongAo7164NjlfO5C7ii8w5aOijdO4LDF2Qn5DCJIKB5NA9jWRwzdXjxNPvP8+v8mW/BxS+rHs33Bz296MBiV66iKptcGcu5maPXbXRBhf2a0dv5W3OwGarr8D+sFR5fkMfmRe971mixET8/maP+ZvMlTQh+7om9tLmj3A49fG3SKk9skvuqyeifrOJ81DbfJBIsXGpuetZzWwG0RgIzzbiwEZQvYMjpFWZljdeEpoop8lzNXM57w9RhCx6xdBc+n4f61Vrc542zb7n1z+Ou2SJOcaTZw0mVjSHyp1XERFW5OF4BvdJsu/rTL1lPcnKtVsbgIiKMovDxdl9aR3M6PgrhfKCnwtd9rEzoBWb4YukxeEmyibQMW4RAqvjcwl2OGE/F3jCqj8u0DA
 zR7aHyl3
 QkaTjVNg9vnDXvI5euEwvFk7CeniWqu5DxUHHsKU/+A1MEcPjXgLJYsU3WhY7A7CfTN+Xj1MbEiPDSns6i+8k9b24vTXVUyGoL9QlFjc5Yb9KY/2QuIplD7ObjQurimvyw5u/5tbRpzB8gf3HKlOme9Q0N5KTK9TUzUSPHAFhQxp12V6FhoquMNApXkfVWk8AGYccv+SRmq1tRP3O4UuPA+5PoD4sp3iBNgR+XvqytNM/P4ZTDodfOAHkGz6vWZValQf3dypwk5CIhWoCIYKfVDlhD5GyklWsQ/U1z8vZx50DYOqDZ0W/DtQ/y5LyRw9mRRd/4nHScfGLQUkDZ4lt11j0657fb/rHBby/AnUkb7qY7GZgSHcZocKn/28jQuIDu6VNeujn94rwVC0X/aSt/Pela5rZtg/YhM24qlMhxcrd1z6SkwTsiPC/Qd2UDaBYOQjwu5dhRtCNAeMZ9Khax4HS7DMVAhzYIB/rmuYNVH0MwzC/xQqrNFysGsKHSgLYpg/b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 1:12=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> Hi Nico,

Hi Baolin! Thanks for testing :)

Did you happen to test with the changes I asked Andrew to append to
this commit?

Either way, I think your fixup makes more sense than mine.

Cheers,
-- Nico


>
> On 2025/12/2 01:46, Nico Pache wrote:
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
> >    available mTHP order.
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
> >
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >   mm/khugepaged.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
> >   1 file changed, 42 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 8dab49c53128..f425238d5d4f 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -463,6 +463,44 @@ void __khugepaged_enter(struct mm_struct *mm)
> >               wake_up_interruptible(&khugepaged_wait);
> >   }
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
> > +
> > +     if (!is_mthp_order(order))
> > +             return khugepaged_max_ptes_none;
> > +
> > +     /* Zero/non-present collapse disabled. */
> > +     if (!khugepaged_max_ptes_none)
> > +             return 0;
> > +
> > +     if (khugepaged_max_ptes_none =3D=3D HPAGE_PMD_NR - 1)
> > +             return (1 << order) - 1;
> > +
> > +     pr_warn_once("mTHP collapse only supports max_ptes_none values of=
 0 or %d\n",
> > +                   HPAGE_PMD_NR - 1);
> > +     return -EINVAL;
> > +}
> > +
> >   void khugepaged_enter_vma(struct vm_area_struct *vma,
> >                         vm_flags_t vm_flags)
> >   {
> > @@ -550,7 +588,10 @@ static int __collapse_huge_page_isolate(struct vm_=
area_struct *vma,
> >       pte_t *_pte;
> >       int none_or_zero =3D 0, shared =3D 0, result =3D SCAN_FAIL, refer=
enced =3D 0;
> >       const unsigned long nr_pages =3D 1UL << order;
> > -     int max_ptes_none =3D khugepaged_max_ptes_none >> (HPAGE_PMD_ORDE=
R - order);
> > +     int max_ptes_none =3D collapse_max_ptes_none(order, !cc->is_khuge=
paged);
> > +
> > +     if (max_ptes_none =3D=3D -EINVAL)
> > +             goto out;
>
> After testing your patchset, I hit the following crash. The reason is
> that when 'max_ptes_none' is -EINVAL here, it shouldn't goto out to call
> release_pte_pages(), because the '_pte' hasn't been initialized at this
> point, and there's no need to release folios either.
>
> After applying the fix below, the crash issue is resolved. I'm not sure
> whether Andrew will help fix this or if you will send a new version to
> address this issue.
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 8cffaf59ced8..2e8171a6d7df 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -646,7 +646,7 @@ static int __collapse_huge_page_isolate(struct
> vm_area_struct *vma,
>          int max_ptes_none =3D collapse_max_ptes_none(order,
> !cc->is_khugepaged);
>
>          if (max_ptes_none =3D=3D -EINVAL)
> -               goto out;
> +               return result;
>
>          for (_pte =3D pte; _pte < pte + nr_pages;
>               _pte++, addr +=3D PAGE_SIZE) {
>
> "
> [  565.319345] Unable to handle kernel paging request at virtual address
> fffffffffffffffa
> .......
> [  565.319409] swapper pgtable: 4k pages, 48-bit VAs, pgdp=3D0000001f8549=
a000
> [  565.319416] [fffffffffffffffa] pgd=3D0000001f85f2a403,
> p4d=3D0000001f85f2a403, pud=3D0000001f85f2b403, pmd=3D0000000000000000
> [  565.319427] Internal error: Oops: 0000000096000006 [#1]  SMP
> .......
> [  565.326733] pc : release_pte_pages+0x68/0x178
> [  565.326960] lr : __collapse_huge_page_isolate+0xc0/0x748
> [  565.327232] sp : ffff800083593910
> .......
> [  565.331476] Call trace:
> [  565.331664]  release_pte_pages+0x68/0x178 (P)
> [  565.331940]  __collapse_huge_page_isolate+0xc0/0x748
> [  565.332249]  collapse_huge_page+0x4cc/0xa70
> [  565.332510]  mthp_collapse+0x254/0x2a8
> [  565.332754]  collapse_scan_pmd+0x5a0/0x6d8
> [  565.333010]  collapse_single_pmd+0x214/0x288
> [  565.333275]  collapse_scan_mm_slot.constprop.0+0x2ac/0x460
> [  565.333617]  khugepaged+0x204/0x2c8
> [  565.333992]  kthread+0xf8/0x110
> [  565.334368]  ret_from_fork+0x10/0x20
> "
>
> >
> >       for (_pte =3D pte; _pte < pte + nr_pages;
> >            _pte++, addr +=3D PAGE_SIZE) {
>


