Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71297C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 05:16:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 453366B008A; Tue, 14 Jul 2026 01:16:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42ABA6B0095; Tue, 14 Jul 2026 01:16:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 341A76B009F; Tue, 14 Jul 2026 01:16:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F105B6B008A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:16:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 748D3A0222
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:16:25 +0000 (UTC)
X-FDA: 84986221530.12.8DB56B8
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id 83DFD40005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:16:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PiSYkXv4;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784006183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iHbvi2QfhAaf34o+4KbfPlqiDqDZm9ft1GC/EbztkuU=;
	b=viwyhP2TWH+1bTVUAWWO6htujj6oK+2mAkBlPUOzO81xGgqIR2dG35Gwt9Cmybeii5m0Nw
	Foj8BKks0GATbHa+CpOZ8t42PKe1U1VQnSqdpMjL4JOOSbRarjVRXOIDEI/xfxHnnqRn2I
	Fg2H6ye8a+4FeFuKzF8iF5Cjv/4bP/0=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PiSYkXv4;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784006183;
	b=geBEzvPtEbU6yHNyhMpvo+2bBpgH9cf8W6y3efBq8D9qgBl8KaqZA5eKz5uMAq1569uRu9
	XWSiwSy0bp+CZL+u18fDshqfkfVlgjG0KyGdfv6PBTP6T9OS7tDPU4/2wy7bJP9jL+JqrN
	GfXjTfCQjY6LUEYl6AuFArHiHWi7DXk=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-471eeac43bfso3776801f8f.3
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 22:16:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784006182; cv=none;
        d=google.com; s=arc-20260327;
        b=dLUyhXYdT9c9xVofgEaKCwKOJqRy8wtGxsgTpbsS4QaE44vfEPJWfnNEZndZ2k+WRp
         EpRrl9FybqJCOVHFlqWH7bv313wGB1WfbFbhn8uJMR7PyNd/OZieJJl70bT7HJIcu1jB
         6DVXw1AuTjLhkLCElmTi/mEJX/WTxbemnmzkZx/fZXy/HoBAkwuWNuRk3J7rIzuqkmyo
         I7rAcDxWphCO6W0OKw9KaaMtXidK3TSnf5AJyQdE6aOyZlDJOaM/pw/QtczZPkUC1Bfh
         JUMp/K8q4qqLSPiatpAXSFrksu/zIDQ6PGW+l7PjcwTiDcIW1zVJb7UNYnSrY8UTURtp
         Mftw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iHbvi2QfhAaf34o+4KbfPlqiDqDZm9ft1GC/EbztkuU=;
        fh=OGKl1tQKrg4g0DZDaKv6Qqqcahp66vWVvowe573JCz4=;
        b=brdsToEdcYElIw37g9B/cPlJ0UNJ1++rtwMcqkCQrQzALG3m58kL1t4JH3GRHQdcPz
         OqwuKa2Wp7JrUYWj8YfLaLfksb/T2igR8yyFieUTy8U5P3zHbLiSORsExgosAstlBojg
         6I4WmpmZsOWCEmf8tU4F359MhdkOoNzCljI3MEGCPeTKHI7+ojjKedD4MPfderLYbFS3
         T7r3MotJMuA9xtD02GOfRDoEE2dGwJjo4kVeJcaHx99Ew/SxpExXorZY8gad++5Y0Siy
         uUp4K6FkMK5cfEV4/dO4Ms8vM2AiF3CoOFVzox7j69i226VcqBGjXERDoHog+PGDYHXN
         fWKA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784006182; x=1784610982; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iHbvi2QfhAaf34o+4KbfPlqiDqDZm9ft1GC/EbztkuU=;
        b=PiSYkXv4XrIWzgjvN3R9fRIK40V+9O0iGMcb80BYx4RxU8IHHSl1Pido4Y1Ux3QOmZ
         i1Wd8XBwxPivTVz4eDGH8k63R8w/JX5sCrKQtui+pk/NJcxBJbPTFSAoU/ZIrJbEp7tv
         fVtMcvCqGgoIpi/vs7zXn5ytFhfdmdr01X2Z6RD+iPVmIOPHAwGrr+JAiv/sVSy7v2/s
         k2hoURNeDemrVIphvClTiXpoak1CMTi/geAMeLVdIEHNhWQSj4/6jBxrUbYaRGkJdDa5
         GuypeydnnzH9yU2FGzhJjU1UzPo1dOwb3q9mzYfevbh4xRkJAhqchVGK6QrdchqzI/MN
         TTvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784006182; x=1784610982;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iHbvi2QfhAaf34o+4KbfPlqiDqDZm9ft1GC/EbztkuU=;
        b=crht05bUiCCOsEPHNjeziQ+dZcH2+0tlBLSfKPd7DXfi6/Oa8mgTmTGpkTHEK8xFaf
         MeZj4LJwDm8h1ObbMRZlx4BLQw33Gmn6tIBw4tbLP8DMo/1ir1Hoflmm/qNF1LB/AkQy
         aL/d19Jtym10M/dn+GazpgiNYcdvW/3gj6i7ZXpcOJIArhhC2xZh//X5xSHYet34Nqi9
         BLHLxM18cJwM+q5ks9EQwMF2MJs3BJYMLwzoDXK2jVfS+GsWA7FU3xpslKwQVe67h49k
         njzA6mNnOO9MnOJ2+7N5dIP9JMfXAv7kg8PGVHdnTJjg2rgtWGACmKTMD1sY4AFuJrqD
         3V2Q==
X-Forwarded-Encrypted: i=1; AHgh+RoIBXDgUN0pX+XExZxdn9RAf/u5JCnTV7dNFyT3AwrDAqcHp+X9Byl8lnxlfVCyhBFkewEohCyVLg==@kvack.org
X-Gm-Message-State: AOJu0Yzw2xiz7XB2GbDY+7WxcnQ9MQksbDGjZEvWaKvaXWov59TeCjsd
	M5gGe3YFiYI4MDC1xwMwoV+zFm6JM/9xKd5dZ5kllRU83Ek7yCzOr7kA9usI2uQrqdIZA6gXrTx
	KCaLY/EXmwrdy6nVlcdJPZ8vjSNyc7mM=
X-Gm-Gg: AfdE7ckuBiV1Kg728g4miIiQTtbil/T3OA8qBBdVfDB2ZIxDfVUB+ogVXOSmkK4YEnU
	C5SZWiK8Kag3oK8+e4ZpGH/VLbu3wr2sasYKKDJawR5E8yCg1vstmuFPw/SOTqHdomC3JUYiBMm
	i0JTebEkgG8/PxrNuT3rv3RWKg7zuSIcqpAtu7+ochTSseZ3wbdOYMOUVXJiWXSfKFpm1HKlvu8
	HacSFCZF+L0h/Us53Z+7lJJc/U/EFO56wkBs3biSvCX0QA/WkusjUfMWBYfYaiwg07Z7y717w==
X-Received: by 2002:a05:6000:2013:b0:47d:f01e:83cf with SMTP id
 ffacd0b85a97d-47f2dd0a07fmr13768845f8f.58.1784006181734; Mon, 13 Jul 2026
 22:16:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260709073823.6643-1-jiangwen6@xiaomi.com> <20260709073823.6643-6-jiangwen6@xiaomi.com>
 <aa5d2aa2-89c8-4b6c-9a28-5c22143277b0@arm.com>
In-Reply-To: <aa5d2aa2-89c8-4b6c-9a28-5c22143277b0@arm.com>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Tue, 14 Jul 2026 13:16:12 +0800
X-Gm-Features: AUfX_mxsvUtzI2D0AgHPIRqMMW6_Ug3R10MrIF7o3aE9P-mmfmUpHGE00EZO9xk
Message-ID: <CAHKocdG7iO=S+pZLSs+mYO3GmVC_WvpC0V_1Tjj7RZ-YxWVh_w@mail.gmail.com>
Subject: Re: [PATCH v6 5/6] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org, 
	urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com, 
	ajd@linux.ibm.com, anshuman.khandual@arm.com, david@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	rppt@kernel.org, ryan.roberts@arm.com, 
	"Barry Song (Xiaomi)" <baohua@kernel.org>, Wen Jiang <jiangwen6@xiaomi.com>, Leo Yan <leo.yan@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 83DFD40005
X-Stat-Signature: fd8s4wzo8oyocnj8kxw7cjc6y71rfgrr
X-HE-Tag: 1784006183-240019
X-HE-Meta: U2FsdGVkX1/wXVIRns4l+6Va8rNLtQtBPPqfkWqruA2qg709jE0cZuRnORlBe6i8bZIXH/bg3kF/JLjGC/YPVcLt1Ng9J/jueCSeXZvqPAVrYPilH+7tBhYLhMDfUQxE5MKcY5nyANm4/tZxqPxFgqCY71a6FnhFivqqtqKp9A7npouOUQZGKa0RJblOqmCj0Awo+MN4f9AKny8zqvRshUsBCo5WvR5ouL77dS+NaDButXphfza4ekDo+MnMyjyfOEJuF5t8c47XPeQT6qY9iFlwscAgc4hgJQRzQp7rxyg7XaErO+irG0sf/7NTf6lTCk/hEs6aJn04tSxTJ/xvOc17i7op+Ejable7EGilDIr3Sjri8ckmTGFIldavv1jg6cC9xSyVDUU7P9abZ9pDkiODGb3QlhQtv50OPKbJEjp/qujA8nK/pfN984Ua/MjaOowxWiADgHLZyQtgkvSSj2nTUtdQezTdz/JaNwabTsDja1JSBbO8z+hAvyQab6NKxdLWvvuZyE1unN8YOybLgYKuedKgE+G0UkWEzgBaC+HW7LeOgKDIbat3kPKxbUtbDwYF7dZYOR59ubS15m2NklUeudDe0RmLYQ7bK1uEwnJvVvhmvU1Hf1OyncsRZxy9qtyVdd4g4Su343XOzLP0y1jduAXIITQXw9Kio/WsVmY/1A5TG7DD0ZrGrr86EPVZ+E5AcD4C6VY+AdGGkOMmwaMzFpNJumIDlwRED6K7Y7A8UEU6iQxHc7HnbrkQoi+COT72ZzS44isj/NyxLtrEajeGh3FCAV4r/5c0hqhoiWhRdQZ9zZK+QoK2NSFWbSmUheWzItauNG5tf93U3vucjrapZ3STk9W3xJCL0atDz2qD3jz2JScrJuaklmWQQepDK/0LLog6Ie9n5z9vJOSdXrAN8ue72BnGmn+B3o1pRlUCkdocCGvGJZFDjXV/M1Qdsv/sH5kcBscqcWCtz3h
 a1L0pRdn
 F8AH+BIy/4i3jFo2/PP+55pu0OOC+ZmUFJWtV7sivLH8LVJhhrFVt0M5H7DFZJ5xQpYpD4xh9rhmiF2E4f3S4azvmsff8/V7Qxn4u9ZQ8qvIg1Aw+EThZwfX2kHypVsBIGI29+CXB4n3zqyI5p+nLUtP3vw6fDIHfPsiDZatjRc/oLiimwhIs/VpYGAjf16Xmx+ahYkkJWRH0O+MofEtiW2+2HnEaY5dvuGOTXc3W8G1rYUKxH/aager8xR/cxJX7lRPyycCFQ4wGB6PPtjH+JUlRHk8HUa+c/k/H+abT1ZaaofJAf9YFLueVtkufL3+eoSnE2GUgD+LzhupJWYG5mRjaq6PO5f9hu+lExrHwg4hAn0creKE71+Vy4JKjO2GQUZvOqPsKCqugzTGGTGHxVCDVidlc/UMsihfyoyE9e3qOEsGWl95Z/04mWISEkh++UZeTYk843M2bAIsPOAdLAb/13107WJVraZFDALSnQE/i36G3bX5G/HNxPb6ojOsrls/8kEZSXxkviejf/h/Sss3xtXPKfngExUMsyyZwbq0DPS+YfYOj0Q+3KO1HMn03hJBOrAho3UGnFqVd2SCHc0SqD7BYbP3veYIA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Jul 2026 at 23:19, Dev Jain <dev.jain@arm.com> wrote:
>
>
>
> On 09/07/26 1:08 pm, Wen Jiang wrote:
> > From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> >
> > In many cases, the pages passed to vmap() may include high-order
> > pages. For example, the systemheap often allocates pages in descending
> > order: order 8, then 4, then 0. Currently, vmap() iterates over every
> > page individually=E2=80=94even pages inside a high-order block are hand=
led
> > one by one.
> >
> > This patch detects physically contiguous pages (regardless of whether
> > they are compound or non-compound) by scanning with
> > num_pages_contiguous(), and maps them as a single contiguous block
> > whenever possible. The mapping order is determined by taking the
> > minimum of the contiguous page count and the pfn alignment, allowing
> > graceful degradation when pfn alignment is less than the contiguous
> > range.
> >
> > Pages with the same page_shift are coalesced and mapped via
> > vmap_pages_range_noflush_walk() to avoid page table rewalk.
> >
> > As users typically allocate memory in descending orders (e.g.
> > 8 =E2=86=92 4 =E2=86=92 0), once an order-0 page is encountered, we sto=
p scanning
> > for contiguous pages since subsequent pages are likely order-0 as well.
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > Co-developed-by: Dev Jain <dev.jain@arm.com>
> > Signed-off-by: Dev Jain <dev.jain@arm.com>
> > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> > Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > Tested-by: Leo Yan <leo.yan@arm.com>
> > ---
> >  mm/vmalloc.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 85 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index d2a4d649af549..db0492151ad08 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3543,6 +3543,89 @@ void vunmap(const void *addr)
> >  }
> >  EXPORT_SYMBOL(vunmap);
> >
> > +static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
> > +{
> > +     if (arch_vmap_pmd_supported(prot) && size >=3D PMD_SIZE)
> > +             return PMD_SHIFT;
> > +
> > +     return arch_vmap_pte_supported_shift(size);
> > +}
>
> Need to throw in a preparatory patch for this, which will (in addition to
> introduction of the vm_shift() function) do:
>

Hi Dev,

Your suggestion is to extract "vm_shift" into a separate patch, say
Patch 5, to make it a common utility function just like Patch 3. And
move the existing code that can use vm_shift into this new patch as
well, correct?

Thanks,
Wen

> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index afaa14ebf17bb..dac87e1cd484b 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4175,10 +4175,7 @@ void *__vmalloc_node_range_noprof(unsigned long si=
ze, unsigned long align,
>                  * supporting them.
>                  */
>
> -               if (arch_vmap_pmd_supported(prot) && size >=3D PMD_SIZE)
> -                       shift =3D PMD_SHIFT;
> -               else
> -                       shift =3D arch_vmap_pte_supported_shift(size);
> +               shift =3D vm_shift(prot, size);
>
>                 align =3D max(original_align, 1UL << shift);
>         }
>
>
>
> > +
> > +static inline int get_vmap_batch_order(struct page **pages,
> > +             pgprot_t prot, unsigned int max_steps, unsigned int idx)
> > +{
> > +     unsigned int nr_contig;
> > +     int order;
> > +
> > +     if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
> > +             return 0;
> > +
> > +     nr_contig =3D num_pages_contiguous(&pages[idx], max_steps);
> > +     if (nr_contig < 2)
> > +             return 0;
> > +
> > +     order =3D ilog2(nr_contig);
> > +
> > +     /* Limit order by pfn alignment */
> > +     order =3D min_t(int, order, __ffs(page_to_pfn(pages[idx])));
>
> You missed Sashiko's point here :) the pfn may be zero and this
> will blow up. You can just first derive the pfn and do the clamping
> only when pfn > 0.
>
>

Will fix this.

Thanks,
Wen
>
> > +
> > +     if (vm_shift(prot, PAGE_SIZE << order) =3D=3D PAGE_SHIFT)
> > +             return 0;
> > +
> > +     return order;
> > +}
> > +

