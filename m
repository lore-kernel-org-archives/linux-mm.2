Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96E87C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 12:50:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E84A6B00AF; Thu,  3 Sep 2026 08:50:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 998F66B00B2; Thu,  3 Sep 2026 08:50:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 860AB6B00B3; Thu,  3 Sep 2026 08:50:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A4B76B00AF
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:50:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED4B3140529
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:50:06 +0000 (UTC)
X-FDA: 85172433612.29.33BD2C1
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf15.hostedemail.com (Postfix) with ESMTP id EB486A0004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:50:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="s/gvNVuW";
	spf=pass (imf15.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788439805;
	b=uH7IH9NDnW154iFi1ZzNDz/jX8Z1yyigBd7KgDGY625ZsPbTpUQXHSEfnrfep+gS8HD3y+
	UKi3pq4ey+mgcHfOt9qxuZI/ksLgapiaEQatSqtz9vvJlNjt6gB/QkDJvfgHWrTbO7UA9t
	mTHeb2QxcarrQig3jngQ8eWEc5Hm/BA=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="s/gvNVuW";
	spf=pass (imf15.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788439805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=59Wj+J6S9wt/dcmTRFnqS+5MGklja5S5ehnxj0FnuDo=;
	b=CQGGrk4AlmPi7E91JtY/MEDn1uWP8hQvgAKVzTJT2rvYtG7rrmFlQ+nn7SX/kQkHKxXFgj
	9QhprYK0owWat/EjKUR0pg468VlcNf9vCAHjaur37+89MpvCLxc5aK9JlMPWVgQP6HQw0o
	SdRuV4Pm4B2dSLDofkufvDtBrQYFGnI=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-499b10c86edso913875e9.2
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 05:50:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788439803; cv=none;
        d=google.com; s=arc-20260327;
        b=FfHxLqPgdWVSaTNBLFCVtYWhihSft45MnXo46acXAcisEymaR9ByjwWe7f41gVCKp3
         bE7pcZHEl5u2g/2XnfPMWJbIvezDHEfisLhlXXOUmktIggdi//9Yv3M+bkhG+hzbViS1
         urb16X0BQBH5t8vb1xKggmrvSKGiBbCVigR8BNopCFQ7u7ztZUaVvJKYqLVQxGWhIvdx
         bF//rfK70s+I1ZeytCIile6pBDg7raFctre6RSUGs24HbalyKQWmyqFp5iH0mrE5Wou5
         kgCGhANlRLiBZgAHkXCFi5M7NAUEgOUAtJq5FzpGwOz/9IkiAcjbD2FtkV2AiV6lFO5a
         cRzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=59Wj+J6S9wt/dcmTRFnqS+5MGklja5S5ehnxj0FnuDo=;
        fh=tNjvmhXDCX965OZUbuYy87fEA4ucQKvXKEm0SEpcRkQ=;
        b=efwybGlQe36g+uZTBz/SICu8SxefJ87+WtmfrSPPHq/qnlChCH21e/FNNYDvo/ym/Y
         rTeHoZ07h+arD5ztj7c/RDN1Qe6Ha1flgJO3w+YECvfVkvaOrhrq+OxmWMlrCTW04rDQ
         9nBx02Vd/iAwBkdCmzRqD28YJGbdxKSBlYmvxDfqpfpcKUE0qIwdmJgtDGsqk7NIGlPl
         Ga/Wi8w5qhn7aYfE/cSZNJ/W3lf3dBJI/WhIZDLv4Dms9G8WXJKackdrPgYxeUdY6oU/
         Q6mofRuoZECLRxVIS83Ssa1vWVN2WPhLOCX+iRS3+OreYTVLWajyFks1aSzvMzw6UtZu
         TDQQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788439803; x=1789044603; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=59Wj+J6S9wt/dcmTRFnqS+5MGklja5S5ehnxj0FnuDo=;
        b=s/gvNVuWA4fbIkMZRj012IpLff9tZZ6HzG3Ys4Ws2ZfiwMAlqb1NBSZfuri+WQTCuS
         TrH0exbASuNn/5JT1QY++qWAo+kvMbFMh5+IuXSOzyQbu0P6nvvRhk2ILUxng8xe2sTF
         C5Qxm9wi5VJkMtCB8CbQYBAJ5uQLCE9y0HnPzBmzXfqcsgwk5xVOz1E6/5+v/PozW5h1
         KT9TFqGKBpuHBkTS43GWcn/rGtlEBWeh6pq8y2ReAmo4wIzyC14+WDtxni5vGR+js7+F
         O7VZAtlQTr3GFk+FUh/odJaNcnFLAQZeVfoU1y8uR3MTcJlwjuLB7sbqTPUAUc5aKmaq
         0mRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788439803; x=1789044603;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=59Wj+J6S9wt/dcmTRFnqS+5MGklja5S5ehnxj0FnuDo=;
        b=V91mr1k8annFu97pnjPIxpXXJUInzaqWl0nqx3p+P9q9zNJ0M11/9FwjMJj3AtyncN
         4X9dCinwLewNOcOxfYsKo5uSwTkRHhQWhhh3aUQzZu6xBU9y1Er+zRfuDbvVWkV+gzPH
         KPp3UGOpPpoSUznbzh6iy9P2CNvpF4koDeax6n0Ee4QZeHDhw25QOS5gH7/HRTM1zx6R
         08rw35gv8G17X6fhtfgnNYcy+hqxjIn/MKBdgYeGcLYKc0ox1Z9iKvI/UnOHSOToQXYt
         SEod1e/MIN217bROWKOZ6Kgy51WMugIHGF1ui1su7OlA2d0ZjMwrWsNx/km0e2CrAtho
         O4Fw==
X-Forwarded-Encrypted: i=1; AKwUvBzTHLRthhKLuMH4zgyHkAcEQ/ZtttgbOXGjaLEISRdsQMgleBB2T6lzdv0G9vckey54fwnoZb21Zg==@kvack.org
X-Gm-Message-State: AFuF++lBAPvTGZckVLk5A5Rq6qLlS/3wc/2dlEUlMn3FF7VEtMqSjSJF
	F336vdA1D5tTk3grWnZNyq6YRlgmGLZsv7zcvjcvs8XuTpCarFLbOvch2/e854GHCo1LlMIbusI
	HR6SUyamFUznqqhaQlkLKn7o4h4tUVJ4=
X-Gm-Gg: AYBFou17RqvLiJpI9ejoMz4eRh2XuSOOVHVSTGMamxfxQa7iOw4ORGtABeb4k554Y9r
	r4DhjU+moSVAwVYJ1ObpQRYDP+dAdoxyhquCDY1tYRXNZbcG2Tc19Q/n2eH/EmjIRJFdAV3tSlY
	H5YNfO7IzRnj0olL18Q8J5tcjjsSqszJ72f181bWKUmBH+gASH6YV4+MUwLdKcrM74sjBlwK3AO
	f5JznaNtYT2VFK2fyCLxPCxPbT6XOY9Yd9VVs07QuFDzlQvwt6qVJqIT4fkmrhVMNVr/dGAMNxu
	yP/pByTBXtIy8jJJ2eGHJOLp2WfrBFC/nJFx1vYIO6gp+WsWHEpVSaHlqaDA5Cavikf8Lna9kW1
	FNUB6i7YL3m61HRFdmWfjtdtJoady
X-Received: by 2002:a05:600c:530c:b0:499:cef6:104c with SMTP id
 5b1f17b1804b1-49ce58369f4mr98184805e9.1.1788439802952; Thu, 03 Sep 2026
 05:50:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
 <20260901151818.3191443-2-xueyuan.chen21@gmail.com> <apk8ZRr6do_YAlzf@kernel.org>
In-Reply-To: <apk8ZRr6do_YAlzf@kernel.org>
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Thu, 3 Sep 2026 20:49:52 +0800
X-Gm-Features: AcwNN1UgFTYq7ea9-qGswA9Jf4fWjx8u_UTgGqrDxE_25OvzBaj7okOUxHJIdeg
Message-ID: <CA+qSx6wqd5VSR=9yarFFmyN1SyvLJqEHpA7BwmzuxNQTHbS=Xg@mail.gmail.com>
Subject: Re: [PATCH v7 1/3] mm: make persistent huge zero folio read-only
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	usama.arif@linux.dev, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, kas@kernel.org, 
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	linux-arm-kernel@lists.infradead.org, tglx@kernel.org, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	luto@kernel.org, peterz@infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EB486A0004
X-Stat-Signature: e8sndwdaonpbk7rtzbptg39s7kyfzjhu
X-HE-Tag: 1788439804-650257
X-HE-Meta: U2FsdGVkX19waDD16hH8pPD5km27jmhDI3WD9r+t/5MfOpU2Yvsl4xq8IHfU32TvMchqbElBc0UUKG68anoKjO+YolmOvQN5A0a+kJ3VjZ9pC3PbiZU04/DtpRsxuTqQXLBHbG5yLglUOAZGgYHG6l9P/MAB3TyA7f12lWFiR6p77dgAhjKDSuvgXI/MPpkDt9SPMfrXjsg+mRBgGbqePlFCIJZ+drH47exH74WRcIWGSX6Q7TotJhx4rzckd5y/sAW4B89MBTtts92Kj1YYYJdob/GasehCQ4EOlH5NqdCjv8wrC223eDb/lc76h5Zkw8WM50v+4t5lzj0tkGeTVt4vLtk7p7Ib8gl2ZKMW3AShXVHCBfU6esmZk2xVgboNJED2LfXsMHfh6XJVk83wa2DqRjxCsriZcgwFyLpsfIPrJTcVdoRIT/kJvkkDax172rlznMUVUeay/XScg9RW76XLIuuKJ4OAAHhXr11qfe7MJLZ05auTPMAcSxFB0GSBaQqP7C2k8lq+ie2kjHj9RWAJyWQpbSds8Aze236+Rh3A+7/TzER2Uhhfy9Yw/qhfLxU5RirCfr8r36kVaII04lvU3RobPthrxxCkb8f4VVGMw9PVOxfgvyQoXKtLQ1gfFfv0u2TfEc51gxoTwZRZLF1jAA/Y+wM0OlWP7f8xmxTUMkNgIeF9BaGM20Ify/ppyteQh4OqUZ9PCb4odr6sF7yBnqLA7KqLQI2bG8NUZO0Z2xIifZ/T6WLL5fiX9YikKc/UFUkD4hJnJu2Vv72KUJDxHRNZN18KBqWMoyYIoy/4SDEezy0CK+khR3yO/PtEfedNN0LEzsLgTprkGSozr+m+d1rCEfSiT5JLTxhdjabY41/sat9f95XXgQF6DKUswgGHG7MxivWSWRm5odMkPAGzqRA84UI5f6Zd7DlyxfYXIL6prdYRgHEf8rfK3WGhAtLalaLAlUL55R9k1eP
 7g572guq
 RdNT8WyvKl1DNbeDl2OIBjjGz0hR3Ah0TSW9Rv1myjyqYb/jaIjIMHT+QJ+yAk7+nNEeDL1Epjow02DbhBwbw082gbEwtmLIunvNl00V/41auzcV15AIIaK86N4apdAoEShP+t34sr1UUB6ArvpMzSYUlv/AlSfNCDdQkhpuNkbUi17qYJ3W+3eNs7SVRUbHYCTuTXpAgXS/TmDC6nJtchvJh/ups9R/K1XZzTreVn4ZxfUoTMCwMHcCh7vCLhHpJEOTsNVJdhT9sRRc0ZKHoj96WziA/vs6X3plNI/ZjDDkO2nI/+8KS6LqjEf0d3GqXeCLXAmTRRPaTG+WtyLq+xtHSLj0Us43EdWT11ruASMCvxQ0EemoHt+HxaTf6krfmm5BdG2ZC9kP8p3FDA7O8o2JpTp+k4Zdp76vr5ZeqfbJwEpA7Qr/ePgVqQ1NO9Y2iZ5VBdaSROV60ZUVWp7kU7+sTPhi/oi9MNsS+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 3, 2026 at 5:22=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wrot=
e:
>
> On Tue, Sep 01, 2026 at 11:18:16PM +0800, Xueyuan Chen wrote:
> > The persistent huge zero folio is shared globally and should stay zero
> > after initialization. As Jann Horn pointed out [1], kernel bugs have
> > ended up writing to pages that were meant to be read-only, including in
> > security-sensitive cases. Making the folio read-only in the direct map
> > turns such writes into faults instead of silent zero-page corruption.
> >
> > Add a page-based helper consistent with the existing direct-map interfa=
ces.
> > Handle TLB invalidation in the architecture implementation; unsupported
> > architectures retain their current behavior.
> >
> > Protect the folio after initialization. Skip highmem folios, which have=
 no
> > permanent direct-map mapping.
> >
> > Inspired by Jann Horn's read-only zero page work [1] and follow-up
> > discussion [3] with Yang Shi.
> >
> > Link: https://lore.kernel.org/r/20260508-ro-zeropage-v1-1-9808abc20b49@=
google.com [1]
> > Link: https://lore.kernel.org/r/0e5b23a6-4895-454a-9dfa-6dc21adc2991@ke=
rnel.org [2]
> > Link: https://lore.kernel.org/r/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=3DjDx9E6dL=
OULohnhBguvi9A@mail.gmail.com [3]
> >
> > Suggested-by: David Hildenbrand <david@kernel.org>
> > Suggested-by: Usama Arif <usama.arif@linux.dev>
> > Co-developed-by: Lance Yang <lance.yang@linux.dev>
> > Signed-off-by: Lance Yang <lance.yang@linux.dev>
> > Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > ---
> >  include/linux/set_memory.h | 17 +++++++++++++++++
> >  mm/huge_memory.c           | 13 ++++++++++---
> >  2 files changed, 27 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> > index 3fe293cfed8c..ed9ce04b18a1 100644
> > --- a/include/linux/set_memory.h
> > +++ b/include/linux/set_memory.h
> > @@ -54,6 +54,23 @@ static inline bool can_set_direct_map(void)
> >  #endif
> >  #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
> >
> > +#ifndef set_direct_map_ro
> > +/**
> > + * set_direct_map_ro - make a direct-map range read-only
> > + * @page: first page in the direct-map range
> > + * @nr: number of pages in the range
> > + *
> > + * Make the direct-map range starting at @page read-only and invalidat=
e stale
> > + * writable translations before returning.
> > + *
> > + * Return: 0 on success, or a negative error code on failure.
> > + */
> > +static inline int set_direct_map_ro(struct page *page, unsigned int nr=
)
> > +{
> > +     return 0;
> > +}
> > +#endif
> > +
> >  #ifdef CONFIG_X86_64
> >  int set_mce_nospec(unsigned long pfn);
> >  int clear_mce_nospec(unsigned long pfn);
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 54494c3fa983..742283b36d74 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -42,6 +42,7 @@
> >  #include <linux/pgalloc_tag.h>
> >  #include <linux/pagewalk.h>
> >  #include <linux/cleanup.h>
> > +#include <linux/set_memory.h>
> >
> >  #include <asm/tlb.h>
> >  #include "internal.h"
> > @@ -291,10 +292,16 @@ static int __init huge_zero_init(void)
> >       huge_zero_folio =3D alloc_huge_zero_folio();
> >       if (!huge_zero_folio) {
> >               pr_warn("Allocating persistent huge zero folio failed\n")=
;
> > -     } else {
> > -             huge_zero_pfn =3D folio_pfn(huge_zero_folio);
> > -             count_vm_event(THP_ZERO_PAGE_ALLOC);
> > +             return 0;
> >       }
> > +
> > +     huge_zero_pfn =3D folio_pfn(huge_zero_folio);
> > +     count_vm_event(THP_ZERO_PAGE_ALLOC);
> > +
> > +     /* Highmem folios have no permanent direct-map mapping to protect=
. */
> > +     if (!folio_test_highmem(huge_zero_folio))
> > +             set_direct_map_ro(folio_page(huge_zero_folio, 0), HPAGE_P=
MD_NR);
>
> Sorry, I don't remember if it was discussed previously, but why can't we
> use the existing set_memory_ro() here?

Hi Mike,

We want to change the linear map here, but arm64 set_memory_ro() only
works on vmalloc addresses.
So a new helper is needed on arm64, and x86 implements the same
helper to keep the two architectures consistent. On x86 it is
basically set_memory_ro() minus the alias check.

Thanks,
Xueyuan

>
> > +
> >       return 0;
> >  }
> >
> > --
> > 2.47.3
> >
>
> --
> Sincerely yours,
> Mike.

