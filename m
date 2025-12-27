Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 352ECE8FDB1
	for <linux-mm@archiver.kernel.org>; Sat, 27 Dec 2025 01:51:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 521CB6B0005; Fri, 26 Dec 2025 20:51:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D9436B0089; Fri, 26 Dec 2025 20:51:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DA9C6B008A; Fri, 26 Dec 2025 20:51:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 289866B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 20:51:12 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 98B45C2058
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 01:51:11 +0000 (UTC)
X-FDA: 84263573142.04.2911B70
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf02.hostedemail.com (Postfix) with ESMTP id 74A6B80007
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 01:51:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wHQecvDr;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766800269; a=rsa-sha256;
	cv=pass;
	b=1ZpYeohs3AJYj9pSlYlnXPLuxcp7ruLbZGDmPh7npVG9nNao9sDKf8Uk1FldNO/2E3Ttuq
	gLL7dd4uj7orq7d3MigaoREghwKb+zPeqLuP4HviWwTjRagzCiH7r9VRbdJbm34dd1sYdE
	J65N+jefLZ5nA5IomcuhVN3SyMrrP4A=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wHQecvDr;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766800269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EkUTzcgLAusRejPGcfWEwmdTrvFrpoaTRiSAAFa0xXA=;
	b=RM3nh0iA2qgF1ca7f1vBjCUlBsLJF+ihEGxiX7VLcXFgNEeBeXHwQuC2vWGnhbjM/MdNrY
	MUQUesbGOz3d0H0Zd09s4WExY1hlz9dyVHYW+kN6/aaSOrNVzdu4+crzLtCm/4jNM/KWGX
	6gnf+2e1kzyc+niCq0WqyMsQr/Tx+5s=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-477a1c8cc47so526675e9.0
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 17:51:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1766800268; cv=none;
        d=google.com; s=arc-20240605;
        b=VUaRFXX+hhjxLm3fl5wRPg/se123HNsC46+zkiKfamZ0H/u3SEp6HqHlXmwTQ7oAjD
         vDT0X1duOdGmzJNtansUB6jeITRGPPHN869d2p0gpB+ziwlADVO+T6seGHM1SjbE4f7R
         JH7/wlqtxvCEYs0kY4zm20iLdV6gp6vY0blW/waolW4ALEIzMPvhIw3ZWUZCnzI7yiAQ
         ri1fw1gnzOHlG7TDGFFmPSwwB37hNflOuWG2nTmf9wA/Foc5j5CZaJuX9Eji/hLUPQdR
         +jt7lQ+ihOAtGjakJl7ZOwa+69xvW1ed0vIU/LyMlHrof011KAmRu6YHFwjwstOipodn
         tHvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EkUTzcgLAusRejPGcfWEwmdTrvFrpoaTRiSAAFa0xXA=;
        fh=ARMAYYiQPai054GQxGdMND8dFm6XCZHJHeP+gL+BO/w=;
        b=lE7BIK97RVCOW3zabtGCnQq9I5IFOnNvWnWm9N7tVVGMrQl5x2t3eMpexoW/rf+DVP
         2ae7wRhkBEa4ZNcTxpe0DRWVckZousKifoxduARcZiMtXyEeezwnPdalnjvESVB4vzAZ
         qohRsAZD/PJRLLVV4xyGnMS9Ojw9613rddGvZ+Rc4wllb9q6Y6ihv7GzfqJ/u+yIhF+Y
         KAVEKwsy+Vwf/WyA4PHOw4dKgLIU4GNcLY4ns/R/1bHCaBRaq77idfRRoLRFTjJpeGAe
         z7L/vRAB16l9+6SfhcN0PGVh2mESgOI1+IeZ2h49cr+X7h6fumPqQyfTip+Xug2CuYzU
         6fyw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766800268; x=1767405068; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EkUTzcgLAusRejPGcfWEwmdTrvFrpoaTRiSAAFa0xXA=;
        b=wHQecvDrjflsO8jRDxPax2X3vqXa7iTKjbNgipWiHMhdLpfMA4nygzbx2lMB0xxnAs
         sW4eh8gBSfZOiuHQ0BuuP9vhS2TBKgjskHxbZpbG6TM3Wr0YahG7XaqSI8KG0S8eXxcJ
         Aw2BBj9H3ae+nY0tBjsghGO52mriCLXQkRvFC1RkNpb6Ez/XnvCERA9rq+6CUPYT9BrD
         6AHiZVwnIx5+WGnu7jvBuBRUrO0PcFMOcYTrrq2BXIY28qrmKK+Sjny6cdx9ygiHd5UU
         N8QHntqz5qDlaUhgqJQoH53sf4Obsc2QWNk5sfetD7u6mRB9VB0g3q5+nDQ8hjgTgYkb
         246Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766800268; x=1767405068;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EkUTzcgLAusRejPGcfWEwmdTrvFrpoaTRiSAAFa0xXA=;
        b=DV5XgRlODNFNWEg0e2FppgBbhNtqpM19BvUg42TU1MLlKenOM0KsHVExZbY3ePqatS
         7hUQnu5PURpRizNA9/q9VHagGH6arGKN1tSAPBlWkEyGcwwB89n+t7B4AAtzfkUqBK3w
         q9e8p2xu1MZ+GbCf4psTpLE5JoNY2w9lR8EY+xp/KQcsT8Or3PTzHMOol71RhO5XjQlS
         rGvSejYyuJD63cVAylKVE44j4/MFHIMcBfUdZvx1p1AqNUxkJ75+XgOnwd8KH/HMlI1k
         u8pgKxnb4rn9njCvKZSpJRcwwehkMUmJY8U6FOYLhwaA+UoL+m+EpopvQuF97K0/BiHg
         5++Q==
X-Forwarded-Encrypted: i=1; AJvYcCVcpFktZbhRHr6OU7xC9LfqrkTyvXGLAiBdFvNaJzXBvXZtea2Ffd7zLNxcz7u4wkiA3r/8IKc5rA==@kvack.org
X-Gm-Message-State: AOJu0YzQC52LZr2d+fmYByWJk220czHsS5LtcTFKPjA1n4J0uc0fPgR0
	yAH9klMUH1zftc8grLujaMOgCcOvyvA62MASgtjlRm7neTgljaifqcgqYb2SiJlYgagaM8TI0ig
	/nwJ6bYQ2DOfrdScdBcP/2Il2O57LA+TjN/0cWxvL
X-Gm-Gg: AY/fxX4kH8XBbpHq7fDzlmPpWov+dnz3txq11WK5hB/ogQoUByQXOdvj8OlWoOpI1Xm
	zJLapoLrV47c+b8WHG58BnbJ4oZIJ1CeVYdSHuO7CJOUDZt3rCLm80xrk2PmenrjQAnm4swGslX
	qdutUhm/zkBIplqQ1b+88yip9ow5HgmuFsOHJdktIZtfsrlaCJPjQXWcjBWg1Apvtw/c1H+Np3Z
	32EHDnpI7925MCwGbCc6Mu9qklGUoPgIiYrtrptIwKBa4LT0bp14dDy9d4e8rzU7jnsOkSD5Dh7
	DZP0uLBJz4PznrUHHFjZg01qdDg+
X-Google-Smtp-Source: AGHT+IE2hi4B5KGs5o89NvRo4D+fW2Op3lZzRIDWK8Mc62SAMGPpYLtLgUiY+FEM8j8qzHNZz9s36aHlu//3jAh0mc8=
X-Received: by 2002:a7b:c842:0:b0:45f:2940:d194 with SMTP id
 5b1f17b1804b1-47d3c6ad02emr1728235e9.2.1766800267637; Fri, 26 Dec 2025
 17:51:07 -0800 (PST)
MIME-Version: 1.0
References: <20251219183346.3627510-1-jiaqiyan@google.com> <20251219183346.3627510-3-jiaqiyan@google.com>
 <1d42b98b-c7f9-f96a-1a8c-87943075ae1b@huawei.com>
In-Reply-To: <1d42b98b-c7f9-f96a-1a8c-87943075ae1b@huawei.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Fri, 26 Dec 2025 17:50:56 -0800
X-Gm-Features: AQt7F2qrArW9UPZ2_W3GFQ5r9GBM55bg5QJ5ketHOrGDiYAiv5aus4tAZkOR1os
Message-ID: <CACw3F52HkWL8NVMdrM6RBESqNKiSLTOJnrUPL1gpWOw5gsN1AA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm/page_alloc: only free healthy pages in
 high-order HWPoison folio
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: nao.horiguchi@gmail.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de, 
	muchun.song@linux.dev, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	harry.yoo@oracle.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 74A6B80007
X-Rspamd-Server: rspam03
X-Stat-Signature: uj9doxx94wrzz6rqsez6fprh1fmkkk31
X-Rspam-User: 
X-HE-Tag: 1766800269-499530
X-HE-Meta: U2FsdGVkX196SL29xhQ8stB3pQ/Z4AraSDQEVGxEXIPt6nOZ1+UKAYD4qwcdAvfYuMJneOr0j/QaIXtRyBpw7MIWtbHpVkz6uGUgDdj9twnCLelty4WDjMsUG6khYWVmhmadMH4G1sirS3Qmuu8drSalfpviv3fHBiuOGF5rwtasrlo9f3QCdMAjiNXSETGZ8njmJuAodeeEhC2GAotTNMb1RSSjmlv8s6G0S6JUma65Sjxh/5LyY4GiTAxPuHRZBU3TTLvDC4MzFvKkHYknRe1IFUB1A74PprspcFQ+p1JpgRu4ZUcXIawKcRS28/MlTEXc4QAeERGvaCXbPCxjxG0raJ7iRfvRb/Fg8yluTQMitT7+xVBR5UKnlGWQZgZaFQH+jKYrmGk8P25S73RgYhr52lQ+AsWcMOWE6+Vh4SV2iUw1pIZL0RmrpxAhLKhlH9DOoUa6y4rDFaYL4iclPge2uIVr+SBqAdN5Ukm0JBo7b3xCn7kyrWRIpjmSjd4s+c2e9I/uCu/eYjw8bkqg4gWCXKnB4Tcd4X4IBGf306gey+F1Cw1tp/h8YSO35c8buzU0jv43BHHdRdhjpSX1MmdnzHtkTR+tiYUFPTN78ajhN9cjtdi/CuQbk21+oAZQuJU5Jf2Y7/l9jsjrFHRRBpSvn+5kqbDgavdi8GgP24qC14sy1/rBsk2Je4CBrf6DSnVMBY9NW/N26xoYTy79GPAYBsyLoZd96QLxRvKxb8ART6B7ht+nzXi0sbSCva8AZArr6aVPF2YIe+WTqDiM84+qM8fa9W0HU2zN/UQHI/3EESmWCgLTaS0AF9ETYHSgvXpVgTyjxvo0JtjLDtqV1wEQbgN7LNAmgw/8rPzgx9aJTzLrUbS3Ju70vL/vJcqSsF0wtlMIoLYs+GTt286KKUimvTYHpzB3CpQRXg3w5hru/EL+CEFFY8g9jx2S4HoEuogFQzfa68vKnoCoCuP
 Kgnfby4T
 H+RpjSBG/Bzj2liRMryzNE34sfzcla25AuWgjPWrglluO2Qz4EKqo9liCYqi2wRvz8lQ4K3jIfcr/iKscuUO2e/sz5z68vDVMuDylf8K/f5FMAbn2NDDsfWUX5peGg7eO7YbQN3/MiaF8djl4BuwS5otZHLtz/2O311u5FT8IQmV35LU44iQ9H9nXE5YDvi+jc3F0njNWmKiizY/YeZWDWfEMwaFkedmsryS2RWoO2ZEAArkqI8jcxcOnqZsIVp6ywXoNvemmrIRKP43Xc042+r3i+Py3yZQxdKjSXGyDCnkFJwzecUTDa1XAtTC72u5MivWWkENw7yCl1Gv5ly0ZdqftyI4OEIV1Dg9hhuoWeV06/lFxOmhZjG9LubWHF0aBoGVZTDny4AtfaOVmOM6b2G1F1bse2bb+bswn1HtCXUE+NiWTmknzK+8N344qcWeedodLZdgjIjfuKjH9atsu1OUN9ZUOXIdy6M0q8fchmaQQItQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 22, 2025 at 11:45=E2=80=AFPM Miaohe Lin <linmiaohe@huawei.com> =
wrote:
>
> On 2025/12/20 2:33, Jiaqi Yan wrote:
> > At the end of dissolve_free_hugetlb_folio that a free HugeTLB
> > folio becomes non-HugeTLB, it is released to buddy allocator
> > as a high-order folio, e.g. a folio that contains 262144 pages
> > if the folio was a 1G HugeTLB hugepage.
> >
> > This is problematic if the HugeTLB hugepage contained HWPoison
> > subpages. In that case, since buddy allocator does not check
> > HWPoison for non-zero-order folio, the raw HWPoison page can
> > be given out with its buddy page and be re-used by either
> > kernel or userspace.
> >
> > Memory failure recovery (MFR) in kernel does attempt to take
> > raw HWPoison page off buddy allocator after
> > dissolve_free_hugetlb_folio. However, there is always a time
> > window between dissolve_free_hugetlb_folio frees a HWPoison
> > high-order folio to buddy allocator and MFR takes HWPoison
> > raw page off buddy allocator.
> >
> > One obvious way to avoid this problem is to add page sanity
> > checks in page allocate or free path. However, it is against
> > the past efforts to reduce sanity check overhead [1,2,3].
> >
> > Introduce free_has_hwpoison_pages to only free the healthy
> > pages and excludes the HWPoison ones in the high-order folio.
> > The idea is to iterate through the sub-pages of the folio to
> > identify contiguous ranges of healthy pages. Instead of freeing
> > pages one by one, decompose healthy ranges into the largest
> > possible blocks. Each block meets the requirements to be freed
> > to buddy allocator (__free_frozen_pages).
> >
> > free_has_hwpoison_pages has linear time complexity O(N) wrt the
> > number of pages in the folio. While the power-of-two decomposition
> > ensures that the number of calls to the buddy allocator is
> > logarithmic for each contiguous healthy range, the mandatory
> > linear scan of pages to identify PageHWPoison defines the
> > overall time complexity.
> >
>
> Thanks for your patch.

Thanks for your review/comments!

>
> > [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-=
mgorman@techsingularity.net/
> > [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-=
mgorman@techsingularity.net/
> > [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> >
> > Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> > ---
> >  mm/page_alloc.c | 101 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 101 insertions(+)
> >
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 822e05f1a9646..20c8862ce594e 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -2976,8 +2976,109 @@ static void __free_frozen_pages(struct page *pa=
ge, unsigned int order,
> >       }
> >  }
> >
> > +static void prepare_compound_page_to_free(struct page *new_head,
> > +                                       unsigned int order,
> > +                                       unsigned long flags)
> > +{
> > +     new_head->flags.f =3D flags & (~PAGE_FLAGS_CHECK_AT_FREE);
> > +     new_head->mapping =3D NULL;
> > +     new_head->private =3D 0;
> > +
> > +     clear_compound_head(new_head);
> > +     if (order)
> > +             prep_compound_page(new_head, order);
> > +}
> > +
> > +/*
> > + * Given a range of pages physically contiguous physical, efficiently
> > + * free them in blocks that meet __free_frozen_pages's requirements.
> > + */
> > +static void free_contiguous_pages(struct page *curr, struct page *next=
,
> > +                               unsigned long flags)
> > +{
> > +     unsigned int order;
> > +     unsigned int align_order;
> > +     unsigned int size_order;
> > +     unsigned long pfn;
> > +     unsigned long end_pfn =3D page_to_pfn(next);
> > +     unsigned long remaining;
> > +
> > +     /*
> > +      * This decomposition algorithm at every iteration chooses the
> > +      * order to be the minimum of two constraints:
> > +      * - Alignment: the largest power-of-two that divides current pfn=
.
> > +      * - Size: the largest power-of-two that fits in the
> > +      *   current remaining number of pages.
> > +      */
> > +     while (curr < next) {
> > +             pfn =3D page_to_pfn(curr);
> > +             remaining =3D end_pfn - pfn;
> > +
> > +             align_order =3D ffs(pfn) - 1;
> > +             size_order =3D fls_long(remaining) - 1;
> > +             order =3D min(align_order, size_order);
> > +
> > +             prepare_compound_page_to_free(curr, order, flags);
> > +             __free_frozen_pages(curr, order, FPI_NONE);
> > +             curr +=3D (1UL << order);
>
> For hwpoisoned pages, nothing is done for them. I think we should run at =
least
> some portion of code snippet from free_pages_prepare():

Agreed, will add in v3.

>
> if (unlikely(PageHWPoison(page)) && !order) {
>                 /* Do not let hwpoison pages hit pcplists/buddy */
>                 reset_page_owner(page, order);
>                 page_table_check_free(page, order);
>                 pgalloc_tag_sub(page, 1 << order);
>
>                 /*
>                  * The page is isolated and accounted for.
>                  * Mark the codetag as empty to avoid accounting error
>                  * when the page is freed by unpoison_memory().
>                  */
>                 clear_page_tag_ref(page);
>                 return false;
>         }
>
> > +     }
> > +
> > +     VM_WARN_ON(curr !=3D next);
> > +}
> > +
> > +/*
> > + * Given a high-order compound page containing certain number of HWPoi=
son
> > + * pages, free only the healthy ones to buddy allocator.
> > + *
> > + * It calls __free_frozen_pages O(2^order) times and cause nontrivial
> > + * overhead. So only use this when compound page really contains HWPoi=
son.
> > + *
> > + * This implementation doesn't work in memdesc world.
> > + */
> > +static void free_has_hwpoison_pages(struct page *page, unsigned int or=
der)
> > +{
> > +     struct page *curr =3D page;
> > +     struct page *end =3D page + (1 << order);
> > +     struct page *next;
> > +     unsigned long flags =3D page->flags.f;
> > +     unsigned long nr_pages;
> > +     unsigned long total_freed =3D 0;
> > +     unsigned long total_hwp =3D 0;
> > +
> > +     VM_WARN_ON(flags & PAGE_FLAGS_CHECK_AT_FREE);
> > +
> > +     while (curr < end) {
> > +             next =3D curr;
> > +             nr_pages =3D 0;
> > +
> > +             while (next < end && !PageHWPoison(next)) {
> > +                     ++next;
> > +                     ++nr_pages;
> > +             }
> > +
> > +             if (PageHWPoison(next))
> Would it be possible next points to end? In that case, irrelevant even no=
nexistent page
> will be accessed ?

Thanks for catching that. Let me avoid access end as a page at all,
both here and in free_contiguous_pages.

>
> Thanks.
> .

