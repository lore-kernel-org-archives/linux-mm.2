Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53863C5DF71
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 07:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97AD46B0402; Tue,  2 Jun 2026 03:35:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 904986B0404; Tue,  2 Jun 2026 03:35:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A5126B0405; Tue,  2 Jun 2026 03:35:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 643966B0402
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:35:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 250AD920F9
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:35:06 +0000 (UTC)
X-FDA: 84834161412.23.FD4E9E0
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2FE4A180005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:35:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZylLNKcw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780385704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ukVR+AuN0YlVKXcTRxC5DqtbC9esjl1rpJTgI/ymezA=;
	b=aECfB/+it0xq9UoUuPK6PQCq22Mb5WEAeLp/U6n/++ZsXEChJ/SW14RSA5HcY2jlueuse1
	O9aMN+X5rxotfwAn9ogSiQFPF38qTVD3ntIT0ND6768sPqt++uktrBbb3ML2IdZUlRbXT9
	qwZFKj2ZbVdCLKLXtRjxfOcwZDBc2F0=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZylLNKcw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780385704;
	b=sRoxS8QH0UlaszODhQEVgo/u9DaNZhJmvTu8sLT5gM6SXIqSAJ3ylEh+/LrCzv07kLx+FF
	nGIVbvN8EIOw6CSS1RNNrXrH/BPTAUuFjPWzmFFgAo9vln2bITXFYwqxLg2sqGjRe2jsS8
	rtZP9VrS4OKwxQD6WQYWKcrSM8m8aAM=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4903f7a90d1so98897405e9.2
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 00:35:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780385703; cv=none;
        d=google.com; s=arc-20240605;
        b=SN8UuEJIgnqb0vALlEDIQ6GDRVoqRYH+m4HDyPR9XtI+YiIY0/C52jXF57Cz14Uw/+
         rIA7sQYj/fqYWDV4UEx7TC6WofDQ8jG+YccdsTHmRIB0rg9Xh0FpD/wcHaCNgNoeOlLN
         4hAHGAsTXu8Ijr/oc2jtDFdhVIZ4jLoV1TDbeK1xjWJUc4N2bkggj+xtkdKJPh6NKF60
         Cs3xoLXgFZWrU/KLBhRQfGTJvcvi1mBBi93ef26iV0f6M4S517iSN3+CLT46+ciuZz+A
         /7EHRwCUPTdFX5T2FhQIeAPpxiQ6CN/HWHWzm14l/bcMn5gY2GEohlt9mMq83MRlfBvD
         imtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ukVR+AuN0YlVKXcTRxC5DqtbC9esjl1rpJTgI/ymezA=;
        fh=C8b6lZPtrB2LD7MBO+6F3n+PqcmJOfb95NDq1lhAU2o=;
        b=UKoLuVbuChyBGmU1EbeGlpZwawELaEKZsBzad6VFYwnoZcoYaqeoRj9/LO3wsMPgiX
         q5gG36RRY7259km6U25WEml3rRb6UlJ1OZ6tbnvNZBOdp+NHF37JALaUqR9QKEYC6I2c
         aUj0S3+qV8Fs6XBOz39jbxan7vS1CR+m4b36mMS0Nxr1W8VMAE+Ppo6w2JTYE1w1EaMl
         4R9s+KMBtKUrFdAmVobSNL929pLq0Pppl7gKK8V4FDOduFWkvIKBUOI0IQoflH4NEPrv
         uiYqfDmDtELypG2TbGtzVltyNGYVMj4I8YcHaO+hIZYdNb3l7Eb7phTtz1aWHmJsxu30
         FCJA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780385703; x=1780990503; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ukVR+AuN0YlVKXcTRxC5DqtbC9esjl1rpJTgI/ymezA=;
        b=ZylLNKcwNfJTDKTH0a4nHpAbic02ui6HKWMyOrFXd2k+DmowfsJzRZYPVxVdwYD8xQ
         NDYNMhI/pap2EjgkYkG6Rztyx7ZBOjm3fzZnGX+dc/4YLtEchZLYSjrGyxZ6K8MXEEey
         uWK4SCMAQuvMScX1Vpk6iVcpJ2cxYTwoLlGKKoTulyd+wy1azh7eAslGq7BZXkLrB2vx
         dCOs+setdolH7x8RLgvL5YQc+mN8agoGAVkMRennezLUUP76Uq4yYI7xE8gEma8LEpTc
         3mcgTYQUKiZoWQA5hQV6Rtmsagrv+v0/Lybc+CVAhyd9jpc5don9WBSsvyfaYkG8Oa9A
         K2mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780385703; x=1780990503;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ukVR+AuN0YlVKXcTRxC5DqtbC9esjl1rpJTgI/ymezA=;
        b=WbJ4Nau5vYX5lyqK9xfQsdNkr5xrTy4EyQFctYp+gVfGw3d7BiX6HnVZLuNJARu6wP
         Muc3nAZ7RYZHSrgeIMq9cqEi17YGfhZzUoD3CBGZR8VSjgOGOQbtcvqPfjX6vPtMUgjE
         LbfNpK5SRPfDcNiiLruVl6dijDtodE6B+zgV78UbCqm3xBL4Mvte+o33NdZTyyU1t3DH
         qxh5f3/zRRvQHoYZE2bXnXMMpvrWql2ATs/4FgfhsMD0ukZTOWvZUBK6E2CMdOU4QJsa
         uE1UBo6dwOvsrgk+MdfLe9/fRYLOtnJcNZ3G1mC6ZxZDCHPNt34fbacGmxxdKypVc1SZ
         ytrw==
X-Gm-Message-State: AOJu0YxzsTyD7ulnA1IiBNiL+wzzEzyZvN5viEjh4DtcqpGwjOHoyrEe
	NWPAZhn8/aXF2EGjDJJUnaVT4gSOE3m7xsklrwiHh2cZ2jVNECPuA5xIvYKxSj7vko+YoCsSDpl
	8X2FebFiJstryAmqaBZjgtnQpW537lNQ=
X-Gm-Gg: Acq92OG+Hx7Xnkf0MWTF8BK4ch753EhnVZncw3rokG+A27CaAKfLf+TQ9q7cqld2zGT
	bFfC6M2rAmIQZjt7B8I/7PCeirP+ivdRUtg9XKuQdJCLxsvS6TVvBMFRZ3xla4VdPKZRvY/s4qk
	rOdRXlpH13z6x1KkOrkAP/fMpdMfknFH8wk+ycbwjUNo8CtFap2/aM060+CKdaYDvoc8IQfWtyI
	oAPQOSvAV51fJ5kTOuenrA3IdcI1QCYUqQvdR7ctRNailc12NF5EGIaUyLpq7hyIfFqgNCKZihu
	vUa+uhsQrMmnSl0sF+M=
X-Received: by 2002:a05:600c:4755:b0:48a:76a3:2b9b with SMTP id
 5b1f17b1804b1-490a2932eeemr240653885e9.17.1780385702416; Tue, 02 Jun 2026
 00:35:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
 <20260522053146.83209-6-jiangwenxiaomi@gmail.com> <340c811e-2501-46c3-8a55-19e955c5ae8a@arm.com>
 <CAHKocdHOT13DHdz+DsT2BaP0EJSKdoWU2NO-wjFwB9+--CqsHw@mail.gmail.com> <176c83fb-edf0-47b3-9823-21a92ea8b4c7@arm.com>
In-Reply-To: <176c83fb-edf0-47b3-9823-21a92ea8b4c7@arm.com>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Tue, 2 Jun 2026 15:34:50 +0800
X-Gm-Features: AVHnY4LgVm8w4_ESczsHZQk87y_kO30ZzPvvzVwnQPOt19ls2ZKI3bcH0bmh51g
Message-ID: <CAHKocdGezCccpA3u8W2f7p2ZjyuW84b8zb7xYgt7e8BuO3RJ+w@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
To: Dev Jain <dev.jain@arm.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org, 
	urezki@gmail.com, baohua@kernel.org, Xueyuan.chen21@gmail.com, 
	rppt@kernel.org, david@kernel.org, ryan.roberts@arm.com, 
	anshuman.khandual@arm.com, ajd@linux.ibm.com, linux-kernel@vger.kernel.org, 
	jiangwen6@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 7a8xjdeg84r98dmojyaz6b4ka6bxrkdk
X-Rspamd-Queue-Id: 2FE4A180005
X-HE-Tag: 1780385703-154098
X-HE-Meta: U2FsdGVkX18Hz5qrp6f6P9iuAReImvtVsR+zH4kDvQ6SlLLWbX0yP32GrGJeyWCnzFxIWpJdARFCIdpgQZFY9bp8NiUGUxdRDOI2GyjZNymLlT8tOT/LQwGDjao/maLPKfwIMjZtp/nebcaFWjYHmKvL1Ddiy2ljxNwhjJGKSemwvls/ZBaqpEn4w9ETW2KHE9DLM4+MHugpmGX100HhclLYj8Y8WFHhBOm1VjIabJLB23a7Txv2F1RFi9TcA7qJeahlxRxnHtN0nIchiKY+HnyNVH3Dmv0V8dPd/Aa/Ky3EieHnSvy3rMnxU7/sbsK9TZPenkkteq9eW5NYuao0jcCe1Wz0jeNnZZ5G7HTvEaIRldzBLi+97r8OiLGbX8USS+ECFg+dYTxwbyZtwQgEQQlaFuR5uzRHiKsr64FIUOQZ+pxuKHcOlvdS3PeuL84gbXEC+j21fqU+3KFg4BY0xFyHay7dW0pW4SYTkVFToTxw1gQl3Nh0yXjm6G3ejPg4fXiTprp18rVZeUycq2yp/I6cdpce/7UStvVWiqaun+7rSriH8IozKp/GjjwFD5V2AkdxThGhjynFuMq/N53fYtK/HI2M23NMsbTj32IzASfC/YZ+fk8habCh/xNlF66UPNDaXYdZ2HNFB6OvQIuHzp59J/k+J4lrw5DwItO4HbM0u0zyHclGOGDe+k5IYfUUf6C4MqO+2SSxjdVy9LL3loYclmq8aQxRt1LngUSIjh9FCSXnTLqRJxBnvaKVJ/MCLYWTHHM2UnEVHB8Xab5vCZZpJFg+U2BDMAB70ZGx/UUKconzm6gnheZgJfcD8RDUsB1hfmVkBqSqacqgDV95SKEUqo7HW+D+QJoju9KwqrU+cgw3PGEVm1dgWNP+RhiMV2/Ajk/Z/PSOjNUaWMaeLIB4wLN4q8YQ4i7l9/SUn2lFWeymJJo0s2espSUUr/TW8Xn21Ly8Zs1h0NVZLVN
 gPECX+XR
 uPsSaooqcLuHkzzAsJUnNNQIK9qVTVbkTLNzDmwK1uwv5sUNjDK33MX8MOGABz6CPi8PL7Ifpaq47WeUp8eUHiNykh37YaYYLOVe33U3e9Cu/qXYPvF+/knpm6PrqABsCjOefR/qo0MNs96WWFwvYhu576JGVwpQ14T2mRsXStoeGixNaM34kuCcEEqJfvhiY9vEhfKzK62VDdmRqoeMQ6bRH6DXOPZvQFaLBvyXUcDjxSdYcqvnNY1/DALanBnFiGego4PoJEaASJ9wCCfZfIZDK/nPWZjyIkfq939x5hjO8cTf6+BUC+z8UEnqtc8aTYDVyASNN5JpX2NxETNiV7bUfeshGQkgVAJDBqWOpqiPQGd+bpIrk/jcItU96CeZhRb9bDtfYB0BUWWOsrT0rkme+uuEpRUG6fykaSDlS37+1ucqFGyw9NipOfygJJC5hWueFRROC+QHYUMB7T92pNpl6OHIh/zQMKFVGUT9g6MY1CXSjVqQs/RgPMk8QrlWZU0jw4MfrDHl3JEZZOOJVTg9P09Q8Xc+PV07ZscGukdehzZCoLzhX76rhnWi4wlv+ntsUWaqSVyFJHHGGiLT0FyFWEWKPP9JQB6/O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 29 May 2026 at 13:57, Dev Jain <dev.jain@arm.com> wrote:
>
>
>
> On 28/05/26 9:12 am, Wen Jiang wrote:
> > On Wed, 27 May 2026 at 16:28, Dev Jain <dev.jain@arm.com> wrote:
> >>
> >>
> >>
> >> On 22/05/26 11:01 am, Wen Jiang wrote:
> >>> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> >>>
> >>> In many cases, the pages passed to vmap() may include high-order
> >>> pages. For example, the systemheap often allocates pages in descendin=
g
> >>> order: order 8, then 4, then 0. Currently, vmap() iterates over every
> >>> page individually=E2=80=94even pages inside a high-order block are ha=
ndled
> >>> one by one.
> >>>
> >>> This patch detects physically contiguous pages (regardless of whether
> >>> they are compound or non-compound) by scanning with
> >>> num_pages_contiguous(), and maps them as a single contiguous block
> >>> whenever possible. The first page's pfn must be aligned to the
> >>> mapping order for the batched mapping to be used.
> >>>
> >>> Pages with the same page_shift are coalesced and mapped via
> >>> vmap_pages_range_noflush_walk() to avoid page table rewalk.
> >>>
> >>> As users typically allocate memory in descending orders (e.g.
> >>> 8 =E2=86=92 4 =E2=86=92 0), once an order-0 page is encountered, we s=
top scanning
> >>> for contiguous pages since subsequent pages are likely order-0 as wel=
l.
> >>>
> >>> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> >>> Co-developed-by: Dev Jain <dev.jain@arm.com>
> >>> Signed-off-by: Dev Jain <dev.jain@arm.com>
> >>> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> >>> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> >>> ---
> >>>  mm/vmalloc.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++=
--
> >>>  1 file changed, 80 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> >>> index deb764abc0571..50642246f4d40 100644
> >>> --- a/mm/vmalloc.c
> >>> +++ b/mm/vmalloc.c
> >>> @@ -3542,6 +3542,84 @@ void vunmap(const void *addr)
> >>>  }
> >>>  EXPORT_SYMBOL(vunmap);
> >>>
> >>> +static inline int get_vmap_batch_order(struct page **pages,
> >>> +             unsigned int max_steps, unsigned int idx)
> >>> +{
> >>> +     unsigned int nr_contig;
> >>> +     int order;
> >>> +
> >>> +     if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP) ||
> >>> +                     ioremap_max_page_shift =3D=3D PAGE_SHIFT)
> >>
> >>
> >> Why bail out on ioremap_max_page_shift =3D=3D PAGE_SHIFT? The code
> >> path for ioremap is different from vmap right?
> >>
> >>
> >
> > ioremap_max_page_shift is under CONFIG_HAVE_ARCH_HUGE_VMAP which
> > controls both ioremap and vmap huge mappings.
>
> I don't get it. So with this patch if nohugeiomap is passed on kernel
> cmdline, then vmap-huge is also disabled. That does not sound correct.
> Currently ioremap_max_page_shift does not play at all with the normal
> vmap code path. It is only involved in ioremap_page_range().

You're right, vmap path should not be affected by ioremap. I'll remove it.

> >>> +             return 0;
> >>> +
> >>> +     nr_contig =3D num_pages_contiguous(&pages[idx], max_steps);
> >>> +     if (nr_contig < 2)
> >>> +             return 0;
> >>> +
> >>> +     order =3D fls(nr_contig) - 1;
> >>> +
> >>> +     if (arch_vmap_pte_supported_shift(PAGE_SIZE << order) =3D=3D PA=
GE_SHIFT)
> >>> +             return 0;
>
> Also, for arches where this function does not do anything special
> (i.e return PAGE_SHIFT), we will effectively not do any huge mappings
> for them.

Agreed, I'll add PMD-level handling here. Will reference your vm_shift() he=
lper.

> >>> +
> >>> +     /* Ensure the first page's pfn is aligned to the order */
> >>> +     if (!IS_ALIGNED(page_to_pfn(pages[idx]), 1 << order))
> >>> +             return 0;
>
> This condition is a bit fragile. It may happen that we have, say 2^8
> contigous pages, but they are aligned to only 2^4. We are operating
> on a page array and have no idea if the caller has passed some
> random subrange of the array.
>
> I think the purpose of these checks is this - to do an early bailout
> if arch does not support huge mappings, or the alignment is not correct,
> instead of finding this out very deep into vmap_pages_range_noflush_walk.
>
> So you could do something like (completely untested and may miss some edg=
e cases):
>
> order =3D ilog2(nr_contig);
>
> order =3D min(order, __ffs(page_to_pfn(pages[idx])));
>
> order =3D vm_shift(PAGE_SIZE << order) - PAGE_SHIFT;
>
> Where vm_shift() is the helper I had used in my patch.
>

Will adopt this approach in v4.

Thanks for the through review!

> >>> +
> >>> +     return order;
> >>> +}
> >>> +
> >>> +static int vmap_batched(unsigned long addr, unsigned long end,
> >>> +             pgprot_t prot, struct page **pages)
> >>> +{
> >>> +     unsigned int count =3D (end - addr) >> PAGE_SHIFT;
> >>> +     unsigned int prev_shift =3D 0, idx =3D 0;
> >>> +     unsigned long start =3D addr, map_addr =3D addr;
> >>> +     int err;
> >>> +
> >>> +     err =3D kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
> >>> +                                             PAGE_SHIFT, GFP_KERNEL)=
;
> >>> +     if (err)
> >>> +             goto out;
> >>> +
> >>> +     for (unsigned int i =3D 0; i < count; ) {
> >>> +             unsigned int shift =3D PAGE_SHIFT +
> >>> +                     get_vmap_batch_order(pages, count - i, i);
> >>> +
> >>> +             if (!i)
> >>> +                     prev_shift =3D shift;
> >>> +
> >>> +             if (shift !=3D prev_shift) {
> >>> +                     err =3D vmap_pages_range_noflush_walk(map_addr,=
 addr,
> >>
> >> It would be worth documenting vmap_pages_range_noflush_walk() that
> >> it can take an array of pages which are not all contiguous, but it
> >> may have contiguous chunks, as hinted by page_shift.
> >>
> >> Otherwise this looks good.
> >>
> >>> +                                     prot, pages + idx,
> >>> +                                     min(prev_shift, PMD_SHIFT));
> >>> +                     if (err)
> >>> +                             goto out;
> >>> +                     prev_shift =3D shift;
> >>> +                     map_addr =3D addr;
> >>> +                     idx =3D i;
> >>> +             }
> >>> +
> >>> +             /*
> >>> +              * Once small pages are encountered, the remaining page=
s
> >>> +              * are likely small as well.
> >>> +              */
> >>> +             if (shift =3D=3D PAGE_SHIFT)
> >>> +                     break;
> >>> +
> >>> +             addr +=3D 1UL << shift;
> >>> +             i +=3D 1U << (shift - PAGE_SHIFT);
> >>> +     }
> >>> +
> >>> +     /* Remaining */
> >>> +     if (map_addr < end)
> >>> +             err =3D vmap_pages_range_noflush_walk(map_addr, end,
> >>> +                             prot, pages + idx, min(prev_shift, PMD_=
SHIFT));
> >>> +
> >>> +out:
> >>> +     flush_cache_vmap(start, end);
> >>> +     return err;
> >>> +}
> >>> +
> >>>  /**
> >>>   * vmap - map an array of pages into virtually contiguous space
> >>>   * @pages: array of page pointers
> >>> @@ -3585,8 +3663,8 @@ void *vmap(struct page **pages, unsigned int co=
unt,
> >>>               return NULL;
> >>>
> >>>       addr =3D (unsigned long)area->addr;
> >>> -     if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
> >>> -                             pages, PAGE_SHIFT) < 0) {
> >>> +     if (vmap_batched(addr, addr + size, pgprot_nx(prot),
> >>> +                             pages) < 0) {
> >>>               vunmap(area->addr);
> >>>               return NULL;
> >>>       }
> >>
>

