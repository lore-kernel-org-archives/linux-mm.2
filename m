Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4675DCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 12:55:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92A1C8E000D; Wed, 10 Sep 2025 08:55:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 900C08E0003; Wed, 10 Sep 2025 08:55:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83DF28E000D; Wed, 10 Sep 2025 08:55:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 728D78E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:55:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1AE6913BEDC
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:55:04 +0000 (UTC)
X-FDA: 83873335728.08.B8CB70E
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id 02E7A12000B
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:55:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Xc21ZO+H;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757508902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UMkFEykw6CDHcCxpRG3Ctye5mxgPw1tmO5woFImiW2w=;
	b=HVnDXqSK87+GMMPwyiSVeLWnGf4dka9kYkWiubP+m1xQn9tHfaqwXwlWzlR57yeW79+X7l
	GzfqiwSAl1Ky+sMZlTK9W6g+z400TkN/Z7hND/Xh0X6ZfEQYmB90RGj5H2UCf3rTgIAeLD
	KM/+EemvW9EEqGgWAiaZaGYPeJfhglM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757508902; a=rsa-sha256;
	cv=none;
	b=JAl9Tsvf5C3Oz9q0z9vdaD4dN4S08tECQUWP8xBEZv5q9VLc3TGerTgAqLF/EWMPRcR3Re
	kdc9yw9ZKTnKb0E8m/O3+4GgD0ieTJPAL7Z7GJiLVUYO8urrvrTYFbadJp+o2kW5cEzO5v
	s9mDviecbncqtMiI6dpO+sRt7Ye0HXU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Xc21ZO+H;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Forwarded-Encrypted: i=1; AJvYcCXtu/wj6F9EHah/UEWb8WbsB9PtuykQDPSim+zga2VwsCzODdJcoKCuxKxiMEGtOHRQtc3yHMx8+A==@kvack.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757508899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UMkFEykw6CDHcCxpRG3Ctye5mxgPw1tmO5woFImiW2w=;
	b=Xc21ZO+HQGMapK8XIOVolZ/zAaLN3PCs40Mh0mZ9gB4wMHm9Q5+eD1Y5IncUnceOZrYfEi
	Enrrg5W8ZSDlqEW+AQVUxYJXwxEAzyR+mR/zIC0T9oA4WDn1q0XH/VNKviIAd6FcouCwxo
	onY9kbW474NLDsOWKS2wr5ycghJZhQ4=
X-Gm-Message-State: AOJu0Yzm79NV2TOBmmGEc70whUDVsExCr9OWAZbqdjbJozmIoRieCWBE
	pMSe0dAicL2WVgtcPGvUmIFGT1iH0TJOecHQlx2rhkvYfLiFCmQtJMeXRdrIEavKX2Axn9jfuPD
	+OecFclelY4YaqXU+3SL37qHwpBI61oE=
X-Google-Smtp-Source: AGHT+IEF3eQ6UlcRwDeEpxd1PL/TBSKLn4agQK0TqsOV7RfLeqWe4bZiUjFZd7iV35M7UX+D6Fe2DO6sCezbXMSn6Vw=
X-Received: by 2002:a05:6214:20a9:b0:727:e0b5:beaa with SMTP id
 6a1803df08f44-7391f3041a4mr162984186d6.6.1757508895553; Wed, 10 Sep 2025
 05:54:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250910024447.64788-1-laoar.shao@gmail.com> <20250910024447.64788-3-laoar.shao@gmail.com>
 <CABzRoyZm32HT2fDpSy_PRDxeXZVJD35+9YqRpn9XWix8jG6w8g@mail.gmail.com>
In-Reply-To: <CABzRoyZm32HT2fDpSy_PRDxeXZVJD35+9YqRpn9XWix8jG6w8g@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
Date: Wed, 10 Sep 2025 20:54:18 +0800
X-Gmail-Original-Message-ID: <CABzRoyYqGsABGVgXbH3Sts3yBsk7ED=BsKbcP3Skc-oWeFsN_w@mail.gmail.com>
X-Gm-Features: AS18NWAsoUIhBQUf1uoUzmIJVtw-dLaFewCMwdt6vFR159yx-71Dyff6aabB_sY
Message-ID: <CABzRoyYqGsABGVgXbH3Sts3yBsk7ED=BsKbcP3Skc-oWeFsN_w@mail.gmail.com>
Subject: Re: [PATCH v7 mm-new 02/10] mm: thp: add support for BPF based THP
 order selection
To: Yafang Shao <laoar.shao@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, hannes@cmpxchg.org, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, willy@infradead.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com, 
	rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com, 
	shakeel.butt@linux.dev, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, Lance Yang <lance.yang@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 02E7A12000B
X-Stat-Signature: qgoa6cfshoi6xo179y1zpqobis8sukg9
X-Rspam-User: 
X-HE-Tag: 1757508901-372266
X-HE-Meta: U2FsdGVkX1+U6rJkdsdOg17WuE/IdsmZKjbzo9acIPyy4lnAWUhL+GbA8Nv7Ady8liVnbdR5rSOI3L9iVtf39ba3ASCGUIlLl6dgti25BFCX239s7TdxaWQOExaf8gQHucelTMIU8C85cZjt0NBr3MZXMjL1kqcLmh1mZh9EDjWlHoZWwwCIvivfUlT5LB3bmjUGdCzd8jnfchQw/uOT8CeetaDxRyfGBUYP1ITP5gV2q9MF4WUcdW07Pxo/9B//ESI/rWi1onVtMDcyKY/Fmqi268hVFz0volTXV3NFvR1FsicbLm+HgYUmyGUSyUrmQbrAS1SgMglF2qB+VVst4VQIAuzUMMF68sEG8UiMKDBUS3CjIjps5wl0T+QyFWoceLglFpN5+DvnuMK+2IcP2wcVHWgPHmEu36B6uXgCdTaU7D1V5vNy18yOsJA6PbLnGBZxMEVNaKtRZtZmE/qGEkMDYUJRCGLqka8YAc7bm9/Vrb4xYcwCZj+nRbcZ4bGr+8dEYNyu4k1RS8YPZ5RsGLBs3LNY3em6KRDp+ikgkGybK0iBpbS6BWI9ZruF3mLizBQYag9VR1xpcWOF2CWEFjAq8U0HTFw6RwlDAD05FICy+fXkIb21kp7MBYnUDrI7KPl4KzVvy3d7/I3vGCZ46wZpeWOM7eIVyeMxglaR1omCGPj8EjpVULpV6hZlFIJsmF1HjD42EYWZp+yLQ+SPwql5ZEdUDfbWipyuNYT2cEiSc62h2PxRHoOFtGaJPV36CMJC27GEGUq9GM+Zvdmu+Y//qvgAvWJFxGDf7/xzltgJjsGDqk+dkmGPB29Y7OZFM7J+AIyHC/qQ+IEp1BEbS3eAlv0h7RESxKvai7gpf//lF/cMHkncRcUHGmRGqc9eU8M6mkWWyxNxAIVSVpKCuQnSQqw4Stxy24wdSIxzAWkO5o4sL7DUI42z8Xr+xSo5/O1oDnyKKK091735No2
 +cre3E3M
 uiGC1lHv54E+rSJ3LpbNFa6hApT6b4g/7Xlffh2kceyBywy9u5t6vWVMnaU0F+18YK0WN/7DsJIqI1slIbcxedyQ0TCja1qbybIhvKMwV3C2SFdZl1j4u+/jIOD/x9JSMO1GQkkImHSJUiBYjBcghcyytGtzKSTnoCDzFnkfDaDNfIEUNFVsqmUGiMS8D+WL1T5qGdHSY7VAuVmQ89sTLQs+0OEp27yY0lCA+v+iPIVE6v+FLTftxtJvN6KYZTajpT9C9+ShhXywMofQExK9FrxzbKbKtRFVOONJQxiequZVVCZYRJUYZIv6bv59kVVCczBOT/1DagnZfnbHam1cToHGTXA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 8:42=E2=80=AFPM Lance Yang <lance.yang@linux.dev> w=
rote:
>
> Hey Yafang,
>
> On Wed, Sep 10, 2025 at 10:53=E2=80=AFAM Yafang Shao <laoar.shao@gmail.co=
m> wrote:
> >
> > This patch introduces a new BPF struct_ops called bpf_thp_ops for dynam=
ic
> > THP tuning. It includes a hook bpf_hook_thp_get_order(), allowing BPF
> > programs to influence THP order selection based on factors such as:
> > - Workload identity
> >   For example, workloads running in specific containers or cgroups.
> > - Allocation context
> >   Whether the allocation occurs during a page fault, khugepaged, swap o=
r
> >   other paths.
> > - VMA's memory advice settings
> >   MADV_HUGEPAGE or MADV_NOHUGEPAGE
> > - Memory pressure
> >   PSI system data or associated cgroup PSI metrics
> >
> > The kernel API of this new BPF hook is as follows,
> >
> > /**
> >  * @thp_order_fn_t: Get the suggested THP orders from a BPF program for=
 allocation
> >  * @vma: vm_area_struct associated with the THP allocation
> >  * @vma_type: The VMA type, such as BPF_THP_VM_HUGEPAGE if VM_HUGEPAGE =
is set
> >  *            BPF_THP_VM_NOHUGEPAGE if VM_NOHUGEPAGE is set, or BPF_THP=
_VM_NONE if
> >  *            neither is set.
> >  * @tva_type: TVA type for current @vma
> >  * @orders: Bitmask of requested THP orders for this allocation
> >  *          - PMD-mapped allocation if PMD_ORDER is set
> >  *          - mTHP allocation otherwise
> >  *
> >  * Return: The suggested THP order from the BPF program for allocation.=
 It will
> >  *         not exceed the highest requested order in @orders. Return -1=
 to
> >  *         indicate that the original requested @orders should remain u=
nchanged.
> >  */
> > typedef int thp_order_fn_t(struct vm_area_struct *vma,
> >                            enum bpf_thp_vma_type vma_type,
> >                            enum tva_type tva_type,
> >                            unsigned long orders);
> >
> > Only a single BPF program can be attached at any given time, though it =
can
> > be dynamically updated to adjust the policy. The implementation support=
s
> > anonymous THP, shmem THP, and mTHP, with future extensions planned for
> > file-backed THP.
> >
> > This functionality is only active when system-wide THP is configured to
> > madvise or always mode. It remains disabled in never mode. Additionally=
,
> > if THP is explicitly disabled for a specific task via prctl(), this BPF
> > functionality will also be unavailable for that task.
> >
> > This feature requires CONFIG_BPF_GET_THP_ORDER (marked EXPERIMENTAL) to=
 be
> > enabled. Note that this capability is currently unstable and may underg=
o
> > significant changes=E2=80=94including potential removal=E2=80=94in futu=
re kernel versions.
> >
> > Suggested-by: David Hildenbrand <david@redhat.com>
> > Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> [...]
> > diff --git a/mm/huge_memory_bpf.c b/mm/huge_memory_bpf.c
> > new file mode 100644
> > index 000000000000..525ee22ab598
> > --- /dev/null
> > +++ b/mm/huge_memory_bpf.c
> > @@ -0,0 +1,243 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * BPF-based THP policy management
> > + *
> > + * Author: Yafang Shao <laoar.shao@gmail.com>
> > + */
> > +
> > +#include <linux/bpf.h>
> > +#include <linux/btf.h>
> > +#include <linux/huge_mm.h>
> > +#include <linux/khugepaged.h>
> > +
> > +enum bpf_thp_vma_type {
> > +       BPF_THP_VM_NONE =3D 0,
> > +       BPF_THP_VM_HUGEPAGE,    /* VM_HUGEPAGE */
> > +       BPF_THP_VM_NOHUGEPAGE,  /* VM_NOHUGEPAGE */
> > +};
> > +
> > +/**
> > + * @thp_order_fn_t: Get the suggested THP orders from a BPF program fo=
r allocation
> > + * @vma: vm_area_struct associated with the THP allocation
> > + * @vma_type: The VMA type, such as BPF_THP_VM_HUGEPAGE if VM_HUGEPAGE=
 is set
> > + *            BPF_THP_VM_NOHUGEPAGE if VM_NOHUGEPAGE is set, or BPF_TH=
P_VM_NONE if
> > + *            neither is set.
> > + * @tva_type: TVA type for current @vma
> > + * @orders: Bitmask of requested THP orders for this allocation
> > + *          - PMD-mapped allocation if PMD_ORDER is set
> > + *          - mTHP allocation otherwise
> > + *
> > + * Return: The suggested THP order from the BPF program for allocation=
. It will
> > + *         not exceed the highest requested order in @orders. Return -=
1 to
> > + *         indicate that the original requested @orders should remain =
unchanged.
>
> A minor documentation nit: the comment says "Return -1 to indicate that t=
he
> original requested @orders should remain unchanged". It might be slightly
> clearer to say "Return a negative value to fall back to the original
> behavior". This would cover all error codes as well ;)
>
> > + */
> > +typedef int thp_order_fn_t(struct vm_area_struct *vma,
> > +                          enum bpf_thp_vma_type vma_type,
> > +                          enum tva_type tva_type,
> > +                          unsigned long orders);
>
> Sorry if I'm missing some context here since I haven't tracked the whole
> series closely.
>
> Regarding the return value for thp_order_fn_t: right now it returns a
> single int order. I was thinking, what if we let it return an unsigned
> long bitmask of orders instead? This seems like it would be more flexible
> down the road, especially if we get more mTHP sizes to choose from. It
> would also make the API more consistent, as bpf_hook_thp_get_orders()
> itself returns an unsigned long ;)

I just realized a flaw in my previous suggestion :(

Changing the return type of thp_order_fn_t to unsigned long for consistency
and flexibility. However, I completely overlooked that this would prevent
the BPF program from returning negative error codes ...

Thanks,
Lance

>
> Also, for future extensions, it might be a good idea to add a reserved
> flags argument to the thp_order_fn_t signature.
>
> For example thp_order_fn_t(..., unsigned long flags).
>
> This would give us aforward-compatible way to add new semantics later
> without breaking the ABI and needing a v2. We could just require it to be
> 0 for now.
>
> Thanks for the great work!
> Lance

