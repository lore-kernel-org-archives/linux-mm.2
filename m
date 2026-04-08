Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D5B0FD5F78
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 05:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 800FB6B0088; Wed,  8 Apr 2026 01:12:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D88D6B0089; Wed,  8 Apr 2026 01:12:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7158F6B008A; Wed,  8 Apr 2026 01:12:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 608916B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 01:12:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E1EDD1405C6
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 05:12:29 +0000 (UTC)
X-FDA: 84634218018.04.2F032A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 193788000B
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 05:12:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GZQDPPgv;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775625148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=neJ/GKtjb58QMYECRReU/bO0EFSkBS+um+/wTL9xxDY=;
	b=man4AapVzdB5u/8YfMFZFoNwvBP4FAsU5jRDw8TZNoXTwitZYK/RAWHGjA7AyRB7kNGsgC
	KtkYUtGJgofTI5wAteuohyub1FK8LE6JvPRQQVJG7DMwHFWNFq/70nOGioj+0gdrtlMCsZ
	nGiIRwqejTT7jbYIjtlgle5eMZcEKPM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775625148; a=rsa-sha256;
	cv=none;
	b=b4bLVGXj/n4KmUVZVjpY+6w+YPYOx+82SluUGH5YyHci5xT5XOtYK1Izi6pFNAG+qQpjUd
	gMnfxXN0dDPUs3aZizywP1UOi7FbMhTnGids/KtUp8L+lfk6DrMK5acaj96IxdwkWuiORM
	xeDeDZfNUCsw3coZ6hmtG62eVkBpkls=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GZQDPPgv;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3BD286013A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 05:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24C3C2BCB7
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 05:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775625146;
	bh=1bV2vvBKDGGRXH/+AVVCsAGHYI7nCauIoIuB3DkJz7I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GZQDPPgvAA6TMLBNu0BHbsu7WCoxozAeAcIlv7cauGTrYKP3djBwWnsiRDzf/He5u
	 xKCtEVGGHaJhJzoz1ZTDYFJ7JecGfzrV9XwdPTKWLwnMaOdHZmJIpkblA9q9UDQHKC
	 XjYNWFw5kuFct6Z9w8Ua/uzGmr5dIOFWv1Tel0Ktb/cnqBka8NyHHAGELliRBRz15+
	 9WM+9z6rnYksD3QsifgyOAsP4+i/9QSpcMFWL1sqJ0zLZsmevFKU4WK/rHe4Y3Wzuc
	 kBKeBsPIs9AvVrhVPEGaNx2symyAK90E6Ze+qpA7GYbS9wRMQ5k3wf11eDqq+RLRol
	 9MYPoAXrH5w9A==
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8a05c388b27so111807396d6.3
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 22:12:26 -0700 (PDT)
X-Gm-Message-State: AOJu0YxNGXrvPo9KxaQUGO+/1K9D1+KCULVZJjua42Veevg/hYJffI/W
	ArED9If83v1DV449IxeRKEipsy+b+4a2x2WNV1fnoM8imGyZq9FVmfYJiuxUM1kTcqjye+G8QEW
	wR7CUrL8CR7G4kzY4mrz+EwGMT9Ba17s=
X-Received: by 2002:a05:6214:212b:b0:89a:ff2:b8cf with SMTP id
 6a1803df08f44-8a7046df1f0mr323079226d6.44.1775625145985; Tue, 07 Apr 2026
 22:12:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260408025115.27368-1-baohua@kernel.org> <20260408025115.27368-6-baohua@kernel.org>
 <b297383a-731c-4efa-95b7-0f198b098d11@arm.com>
In-Reply-To: <b297383a-731c-4efa-95b7-0f198b098d11@arm.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 8 Apr 2026 13:12:14 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xCtFe=5ofj4FW6cqu-fgR+K9BM7FPZRdAWOGP3YKtNzQ@mail.gmail.com>
X-Gm-Features: AQROBzBupWrjwY7intWq5A_SlPJS8N_3bOz8PdEQF8tDX-ZW2xXsYcoJ6gZ70D0
Message-ID: <CAGsJ_4xCtFe=5ofj4FW6cqu-fgR+K9BM7FPZRdAWOGP3YKtNzQ@mail.gmail.com>
Subject: Re: [RFC PATCH 5/8] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
To: Dev Jain <dev.jain@arm.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org, 
	urezki@gmail.com, linux-kernel@vger.kernel.org, anshuman.khandual@arm.com, 
	ryan.roberts@arm.com, ajd@linux.ibm.com, rppt@kernel.org, david@kernel.org, 
	Xueyuan.chen21@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: pmm96rhjwz47q36k7csx1exmnuwhxdmn
X-Rspamd-Queue-Id: 193788000B
X-Rspam-User: 
X-HE-Tag: 1775625147-219823
X-HE-Meta: U2FsdGVkX1/mBeMtcYu8u5W8pVmOGxk8PXHr6AYdKZu/qnTeDM7ix/6LClAfQxfjwpiLJ7D+qRzJpn/nZUT3dKI0JJ2cR+oAIdm3ZyP8Rw5qAjK7i07bZKJEj2AJFS49jfYNM9Ysucg91kZNzZWo33M5eA2Xkh3Rxfa/nJanZXblv3D/RR+Q9JT/sSoPTJr+lCnCSxdIELzjLmDtFv/EDyHM3bTtYAWoKSShb59O4pK6h04si94S11Av0YFuQXY6wokXgT8z4RVlA5x1opuTdNcch5VIfHLravfjMZ0iUy4z9OwjvhpUkiFmslaSAsCgD5aMpbmrC+eul7e8nkGIN1p53PbfX2uhwJ0cPZ618sY9y8n34GSIPTiaNQzFClJkvJ0Hh5xuYIRyj9JACP37U6w/Wl/tKJf/mPxilVg785ChWkZG5Yt0i/toKirAbjvojXIwWUmC2XFJh5k+fbCcGYTeUXvc+I7+FVFTMcgKCidy90va18ipWobVRVst1Og6+lzBArO/JNQuxCndFmUPbTaGKiMQPzReRPAHVM2tNUd41Y2AcL1IbbacOTqRUC5eO0heYhRZxMsx4R7GGlMqBeWHuLYmbv2VSkFFlyWOj8lPSHruSSM6qxbr7d8IAn1YGw+mHMYHeEsMhqxH4TfiYL/q5UndYLXIL5T5MFru9stWtRKmFokus5Dd1q1vV9wmrH33I6Ad+qQ6dPyCJ9BbNAlKxiLgB2HX/CcJ3agZddbbesqEEApHdDiB2xv3WsWJLtTTlk/D/H89caVipA/WEJTqBVCbRXDTMyYynt5KW4WXSmPQcTWDHvZ9KC5aukpQ3Tq9T1aTM+YGb7Ti9SwC5/kUY/T9S+G8rDDkZttl1zsY7x0EHx5g3K32+xkQNOx1gLXcxPhhVi0LWM5QQNSmDOI7ssOfv6z9hW3VSJ8JP3j0w1/JOFJ3LJd9ugTbzTY857NQg5LuPmbUi/N1lcN
 Svy3LAad
 39iXDdHBwmyXXaWbsGj+6kH5YYJUshXYMQB6aENBAjZOZJzDRxeyWsg+x1x8/G8giQYjvgtTWpCyZ0HmK6gzgZ7PaXJ8fwvwFWmKHQgsR+7/mI1el2HL0qxJvID7OQHw+v5gP1Q1Y+JYQTyRvC8Ni82lXMXGYsDeHUklNvBKaKgYYWfbIW7Jwy+cBofzSdLOHnTdLeUkiLEGn/gEMkjmGa2KUuYT9JJ3tORx/M4IlKqRQq9TiEiLMeLiP9LyQikUeBj9AxxarVEWdpppbHCn71x0K/cBj2pvzzjYmSwtFx14z8zsAwsSTfN15jdtZEu6/ucBsxr3oglncurvbQCRtep7RH+9d+Ok/sw0S2u5iNNWvy/THwjcA9XFmFL7f13EejuuHk5rDRj886WYAcoR6WIb/2RN0jemlGfp3luIOGzooHjHR56vTE2GqcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 8, 2026 at 12:20=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
>
>
> On 08/04/26 8:21 am, Barry Song (Xiaomi) wrote:
> > In many cases, the pages passed to vmap() may include high-order
> > pages allocated with __GFP_COMP flags. For example, the systemheap
> > often allocates pages in descending order: order 8, then 4, then 0.
> > Currently, vmap() iterates over every page individually=E2=80=94even pa=
ges
> > inside a high-order block are handled one by one.
> >
> > This patch detects high-order pages and maps them as a single
> > contiguous block whenever possible.
> >
> > An alternative would be to implement a new API, vmap_sg(), but that
> > change seems to be large in scope.
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
>
> Coincidentally, I was working on the same thing :)

Interesting, thanks =E2=80=94 at least I=E2=80=99ve got one good reviewer :=
-)

>
> We have a usecase regarding Arm TRBE and SPE aux buffers.
>
> I'll take a look at your patches later, but my implementation is the

Yes. Please.


> following, if you have any comments. I have squashed the patches into
> a single diff.

Thanks very much, Dev. What you=E2=80=99ve done is quite similar to
patches 5/8 and 6/8, although the code differs somewhat.

>
>
>
> From ccb9670a52b7f50b1f1e07b579a1316f76b84811 Mon Sep 17 00:00:00 2001
> From: Dev Jain <dev.jain@arm.com>
> Date: Thu, 26 Feb 2026 16:21:29 +0530
> Subject: [PATCH] arm64/perf: map AUX buffer with large pages
>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  .../hwtracing/coresight/coresight-etm-perf.c  |  3 +-
>  drivers/hwtracing/coresight/coresight-trbe.c  |  3 +-
>  drivers/perf/arm_spe_pmu.c                    |  5 +-
>  mm/vmalloc.c                                  | 86 ++++++++++++++++---
>  4 files changed, 79 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/hwtracing/coresight/coresight-etm-perf.c b/drivers/h=
wtracing/coresight/coresight-etm-perf.c
> index 72017dcc3b7f1..e90a430af86bb 100644
> --- a/drivers/hwtracing/coresight/coresight-etm-perf.c
> +++ b/drivers/hwtracing/coresight/coresight-etm-perf.c
> @@ -984,7 +984,8 @@ int __init etm_perf_init(void)
>
>         etm_pmu.capabilities            =3D (PERF_PMU_CAP_EXCLUSIVE |
>                                            PERF_PMU_CAP_ITRACE |
> -                                          PERF_PMU_CAP_AUX_PAUSE);
> +                                          PERF_PMU_CAP_AUX_PAUSE |
> +                                          PERF_PMU_CAP_AUX_PREFER_LARGE)=
;
>
>         etm_pmu.attr_groups             =3D etm_pmu_attr_groups;
>         etm_pmu.task_ctx_nr             =3D perf_sw_context;
> diff --git a/drivers/hwtracing/coresight/coresight-trbe.c b/drivers/hwtra=
cing/coresight/coresight-trbe.c
> index 1511f8eb95afb..74e6ad891e236 100644
> --- a/drivers/hwtracing/coresight/coresight-trbe.c
> +++ b/drivers/hwtracing/coresight/coresight-trbe.c
> @@ -760,7 +760,8 @@ static void *arm_trbe_alloc_buffer(struct coresight_d=
evice *csdev,
>         for (i =3D 0; i < nr_pages; i++)
>                 pglist[i] =3D virt_to_page(pages[i]);
>
> -       buf->trbe_base =3D (unsigned long)vmap(pglist, nr_pages, VM_MAP, =
PAGE_KERNEL);
> +       buf->trbe_base =3D (unsigned long)vmap(pglist, nr_pages,
> +                        VM_MAP | VM_ALLOW_HUGE_VMAP, PAGE_KERNEL);
>         if (!buf->trbe_base) {
>                 kfree(pglist);
>                 kfree(buf);
> diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
> index dbd0da1116390..90c349fd66b2c 100644
> --- a/drivers/perf/arm_spe_pmu.c
> +++ b/drivers/perf/arm_spe_pmu.c
> @@ -1027,7 +1027,7 @@ static void *arm_spe_pmu_setup_aux(struct perf_even=
t *event, void **pages,
>         for (i =3D 0; i < nr_pages; ++i)
>                 pglist[i] =3D virt_to_page(pages[i]);
>
> -       buf->base =3D vmap(pglist, nr_pages, VM_MAP, PAGE_KERNEL);
> +       buf->base =3D vmap(pglist, nr_pages, VM_MAP | VM_ALLOW_HUGE_VMAP,=
 PAGE_KERNEL);
>         if (!buf->base)
>                 goto out_free_pglist;
>
> @@ -1064,7 +1064,8 @@ static int arm_spe_pmu_perf_init(struct arm_spe_pmu=
 *spe_pmu)
>         spe_pmu->pmu =3D (struct pmu) {
>                 .module =3D THIS_MODULE,
>                 .parent         =3D &spe_pmu->pdev->dev,
> -               .capabilities   =3D PERF_PMU_CAP_EXCLUSIVE | PERF_PMU_CAP=
_ITRACE,
> +               .capabilities   =3D PERF_PMU_CAP_EXCLUSIVE | PERF_PMU_CAP=
_ITRACE |
> +                                 PERF_PMU_CAP_AUX_PREFER_LARGE,
>                 .attr_groups    =3D arm_spe_pmu_attr_groups,
>                 /*
>                  * We hitch a ride on the software context here, so that
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 61caa55a44027..8482463d41203 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -660,14 +660,14 @@ int __vmap_pages_range_noflush(unsigned long addr, =
unsigned long end,
>                 pgprot_t prot, struct page **pages, unsigned int page_shi=
ft)
>  {
>         unsigned int i, nr =3D (end - addr) >> PAGE_SHIFT;
> -
> +       unsigned long step =3D 1UL << (page_shift - PAGE_SHIFT);
>         WARN_ON(page_shift < PAGE_SHIFT);
>
>         if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
>                         page_shift =3D=3D PAGE_SHIFT)
>                 return vmap_small_pages_range_noflush(addr, end, prot, pa=
ges);
>
> -       for (i =3D 0; i < nr; i +=3D 1U << (page_shift - PAGE_SHIFT)) {
> +       for (i =3D 0; i < ALIGN_DOWN(nr, step); i +=3D step) {
>                 int err;
>
>                 err =3D vmap_range_noflush(addr, addr + (1UL << page_shif=
t),
> @@ -678,8 +678,9 @@ int __vmap_pages_range_noflush(unsigned long addr, un=
signed long end,
>
>                 addr +=3D 1UL << page_shift;
>         }
> -
> -       return 0;
> +       if (IS_ALIGNED(nr, step))
> +               return 0;
> +       return vmap_small_pages_range_noflush(addr, end, prot, pages + i)=
;
>  }
>
>  int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> @@ -3514,6 +3515,50 @@ void vunmap(const void *addr)
>  }
>  EXPORT_SYMBOL(vunmap);
>
> +static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
> +{
> +       if (arch_vmap_pmd_supported(prot) && size >=3D PMD_SIZE)
> +               return PMD_SHIFT;
> +
> +       return arch_vmap_pte_supported_shift(size);
> +}
> +
> +static inline int __vmap_huge(struct page **pages, pgprot_t prot,
> +               unsigned long addr, unsigned int count)
> +{
> +       unsigned int i =3D 0;
> +       unsigned int shift;
> +       unsigned long nr;
> +
> +       while (i < count) {
> +               nr =3D num_pages_contiguous(pages + i, count - i);
> +               shift =3D vm_shift(prot, nr << PAGE_SHIFT);
> +               if (vmap_pages_range(addr, addr + (nr << PAGE_SHIFT),
> +                                    pgprot_nx(prot), pages + i, shift) <=
 0) {
> +                       return 1;
> +               }

One observation on my side is that the performance gain is somewhat
offset by page table zigzagging caused by what you are doing here -
iterating each mem segment by vmap_pages_range() .

In patch 3/8, I enhanced vmap_small_pages_range_noflush() to
avoid repeated pgd =E2=86=92 p4d =E2=86=92 pud =E2=86=92 pmd =E2=86=92 pte =
traversals for page
shifts other than PAGE_SHIFT. This improves performance for
vmalloc as well as vmap(). Then, in patch 7/8, I adopt the new
vmap_small_pages_range_noflush() and eliminate the iteration.

> +               i +=3D nr;
> +               addr +=3D (nr << PAGE_SHIFT);
> +       }
> +       return 0;
> +}
> +
> +static unsigned long max_contiguous_stride_order(struct page **pages,
> +               pgprot_t prot, unsigned int count)
> +{
> +       unsigned long max_shift =3D PAGE_SHIFT;
> +       unsigned int i =3D 0;
> +
> +       while (i < count) {
> +               unsigned long nr =3D num_pages_contiguous(pages + i, coun=
t - i);
> +               unsigned long shift =3D vm_shift(prot, nr << PAGE_SHIFT);
> +
> +               max_shift =3D max(max_shift, shift);
> +               i +=3D nr;
> +       }
> +       return max_shift;
> +}
> +
>  /**
>   * vmap - map an array of pages into virtually contiguous space
>   * @pages: array of page pointers
> @@ -3552,15 +3597,32 @@ void *vmap(struct page **pages, unsigned int coun=
t,
>                 return NULL;
>
>         size =3D (unsigned long)count << PAGE_SHIFT;
> -       area =3D get_vm_area_caller(size, flags, __builtin_return_address=
(0));
> +       if (flags & VM_ALLOW_HUGE_VMAP) {
> +               /* determine from page array, the max alignment */
> +               unsigned long max_shift =3D max_contiguous_stride_order(p=
ages, prot, count);
> +
> +               area =3D __get_vm_area_node(size, 1 << max_shift, max_shi=
ft, flags,
> +                                         VMALLOC_START, VMALLOC_END, NUM=
A_NO_NODE,
> +                                         GFP_KERNEL, __builtin_return_ad=
dress(0));
> +       } else {
> +               area =3D get_vm_area_caller(size, flags, __builtin_return=
_address(0));
> +       }
>         if (!area)
>                 return NULL;
>
>         addr =3D (unsigned long)area->addr;
> -       if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
> -                               pages, PAGE_SHIFT) < 0) {
> -               vunmap(area->addr);
> -               return NULL;
> +
> +       if (flags & VM_ALLOW_HUGE_VMAP) {
> +               if (__vmap_huge(pages, prot, addr, count)) {
> +                       vunmap(area->addr);
> +                       return NULL;
> +               }
> +       } else {
> +               if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
> +                                       pages, PAGE_SHIFT) < 0) {
> +                       vunmap(area->addr);
> +                       return NULL;
> +               }
>         }
>
>         if (flags & VM_MAP_PUT_PAGES) {
> @@ -4011,11 +4073,7 @@ void *__vmalloc_node_range_noprof(unsigned long si=
ze, unsigned long align,
>                  * their allocations due to apply_to_page_range not
>                  * supporting them.
>                  */
> -
> -               if (arch_vmap_pmd_supported(prot) && size >=3D PMD_SIZE)
> -                       shift =3D PMD_SHIFT;
> -               else
> -                       shift =3D arch_vmap_pte_supported_shift(size);
> +               shift =3D vm_shift(prot, size);

What I actually did is different. In patches 1/8 and 2/8, I
extended the arm64 levels to support N * CONT_PTE, and let the
final PTE mapping use the maximum possible batch after avoiding
zigzag. This further improves all orders greater than CONT_PTE.

Thanks
Barry

