Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57AFFC87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 02:37:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E86F26B0092; Tue, 29 Jul 2025 22:37:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5EA96B0093; Tue, 29 Jul 2025 22:37:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9BB56B0095; Tue, 29 Jul 2025 22:37:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CBE186B0092
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 22:37:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5976F1D9A83
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 02:37:24 +0000 (UTC)
X-FDA: 83719369608.05.510C8D7
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7DA0A140006
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 02:37:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BgbbbVwF;
	spf=pass (imf09.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753843042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=azm4H21bCSR8pRZXWBmM1Jjia6/6iWdiaPD1AcoRFgw=;
	b=5rIfQJWJTnLghao+FZMmRaW1uSWsBY3mAQo9LKTtJkaHGfTGkjzDW1i4O0x4cKHKpKkKeg
	h7Gt3i8tRV3daDpWqaBik+dVN0XhpKar4DiVf9SZPO0itmUzNR8QYPm8W2MOKrCz8URBWk
	52Np8vjJ4J10A5UMvNsZbj8BcdKVgHE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753843042; a=rsa-sha256;
	cv=none;
	b=Cbc4UmkNx9nWFxksLRR+fiZgTxGUYgRG9zrDfcIyFiLWgwmC7KkW7QbmKHr7ypvjzCZ8Qe
	8u8JiybLGraE8atnugDbJT9WTh7wCff0jHehoSmyj/puzBW556dT5Q1tDV16/TtsIs/mA/
	wfFG4JB6METCnMz4pZwCg4xq5hv6ylY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BgbbbVwF;
	spf=pass (imf09.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6facf4d8e9eso40135266d6.1
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 19:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753843041; x=1754447841; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=azm4H21bCSR8pRZXWBmM1Jjia6/6iWdiaPD1AcoRFgw=;
        b=BgbbbVwFrulT8BHAxPar9N9rMKD8A8NjeKRFnvTmT0RtHePrTZtMAVjdlgLgxf4OxP
         7Xg7XHnTFalFTw9CRG+ySFQqS59rWabCX6XBrF30lvwU13fBomBbpm9hC2Kl8MO8fM5m
         VjfIFbkSWC+RJfNctgKrRY31lcho6x+Y7ZPRyireMeKguwvFFbUX5b46y/kgdqKF0vyH
         fvSnBHVY5FN26Gha9dp/MsWke0dv5Bh0kJtzB2gPGmKAgbmeiQ+WVhf8y6ROQY+bX4Hg
         au5+Gf5ezXRZ8oidg7btwhVOQTph5YI7QxLX93rZpHMcljnWJ5/gAz+a+3GB8H4UXktl
         vw6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753843041; x=1754447841;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=azm4H21bCSR8pRZXWBmM1Jjia6/6iWdiaPD1AcoRFgw=;
        b=jKEpt0HhpvsvYG3CQzS8Hf/JSPNlxMAR8ABnvsx/omU7UEUse3dZ+pztmb0upN1YqI
         Ac23F9ETQJfffuP7hUfMAUFSFX0+HA45CKnjCFEjojrIowLzsgzxD/ILPWM1HaAaOHJC
         LR0xTo8wbBEfr+nj++uP8qKwf2NUw2m/j87r8Muku83sxnLJXnr2KO8TvvYqAOMz63zN
         25zuf/kMm/cB02gTqSCzxIVJimBwbl0SMU4pIYKVJmWnBof/lxBIRqarUCkVkFhe2blp
         9LZ1EYSKogHK3V+aGzcfp48Bt1e7YAEL9lxwfS6W+V2Ia06AQRB+8hrjtYnh/akvEl7n
         pw2w==
X-Forwarded-Encrypted: i=1; AJvYcCWmGCncZ5+s6R/PnpsP32aikz1p0hFnaBwcTRqpa91RXo2xmv9xKPWrfMYrFbGgWis1qsSTCsFvig==@kvack.org
X-Gm-Message-State: AOJu0YwetKy6TpunRhIqh0CpRuPS9LaFEaWGX7hVBItkmlUVL78lzyhq
	XT0cZ6c0g1+6lQDJIPuZRd6SdHWRGlYCxItxPCvvh7PeAzZnBIjHLBty9QxDsWH2KiQ5KuLfXQ2
	QwT4iMq/kJlLI81Qs0w/hr9Em8cMpq5E=
X-Gm-Gg: ASbGncvkIHva2kJSFW5KGKOXHs7F3KpJOlybx2wjcQSojW0oMbbfG5mGQVQ+DMPpfwK
	Nw5wXwbhMIfG2UPQcsP6Ul6pHZ7vbHfWIXIBkmIYnhRIcVzYxx+QgbD6LbF+6sRWf2wBhYrM/J0
	1SUZPj2H9KZXa2O6srldOEKvkSqwufjNWpbCyxD7vXoexjq6xJeU/37K99RbK/uwpbEJyGcKVpf
	oUbI93veR5B+GjRtw==
X-Google-Smtp-Source: AGHT+IHYPgqpkm23VSfrGkQqGIOsDFxmns71dpolrXxPBJhJSkFCDvaXOwvBV4ORQ7D6tW/54w+2GNPIVEP/NjbGTG8=
X-Received: by 2002:ad4:5764:0:b0:707:5067:4fbe with SMTP id
 6a1803df08f44-7076713a684mr27657556d6.13.1753843041393; Tue, 29 Jul 2025
 19:37:21 -0700 (PDT)
MIME-Version: 1.0
References: <20250729091807.84310-1-laoar.shao@gmail.com> <20250729091807.84310-2-laoar.shao@gmail.com>
 <F204238B-5B11-41DC-AF9B-4D2AC11ADF5E@nvidia.com>
In-Reply-To: <F204238B-5B11-41DC-AF9B-4D2AC11ADF5E@nvidia.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 30 Jul 2025 10:36:43 +0800
X-Gm-Features: Ac12FXwSZakNsNX1BWXdDUCZftrIpRp5UhqiepESjeMjAuDTr8_Dyj6y8V2y-K0
Message-ID: <CALOAHbDKHqnyz0w0fKtdCgA3ScQ2qXG7QwZUDRGQjjTb1UNTRw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 1/4] mm: thp: add support for BPF based THP order selection
To: Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, david@redhat.com, baolin.wang@linux.alibaba.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, bpf@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7DA0A140006
X-Stat-Signature: ms57wt49nmt9uzr3nzs3r1b1e91csn9e
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753843042-21220
X-HE-Meta: U2FsdGVkX192PVRhA8q5XH6LYmGxB+T5ZbgrZHMWWLXmYBSgM8q1oHdLwB8eGbW3sKlzql0xhxCXBr1TUezqjwlfMUdx7qS8Wh6sPFfW6Icf0Fb+xwiI3iFav5gFnFP5ZASPztf9ARey+ej122EIPh7x7K3N+kRCyGNxB0la6dcgF9i1p4Sp4gj+dH0tS2ZDVOP4D396+/WrWqHzOg9wn9zvnfNNadAorF9Df1PKpYVjDrEgdVHcQenDmaG1vlhKdbShDIe0oI6K8DGiykeA+zN1lv1UhDSxPiV8UitBiUjo8YFs8fIdMXrw28kGLc/YLx2MIKW3iA6PHJ70tgOJkkYjmUTlsH7m/uFyGG0cA9LFZglqFGSzT/edIK/ZatF2NMXmme045IO8+XAAUYMVvilfY1Dw/yMkFtd1aFKltUjWeqGg0EGmRg8hJIdroiISj7Z6+VFGteh+/FDK1AJpLm4I+QOCMwt2Rww/GLdSYtiNTL8BYyc1dW/pM9fEjBegQRiLJe3T37OLWykGOZ8FqCsa2whIxclXv0E2knxcJtNvAhhPiO2fKFEm1VJavkF1MonFFf3pkolKWnaTEdEnppsa2oQyz2Qi/wWfRZcrLiZMo13+IrvB4RncxulHgtjeRREwflRFpkJ4Ghhy+hN2odNWsCoK/IzQBDvHLwZga3JeoG6TX4muKv1tQajvdr5FB3+nyLKmQwdV2xIMcAs+QquierkVA1s9jRy6xLLm92h9K9ewbNn6pljK6AeTFjwMxE2syaBdxo0dHdxTuMCwIQsB7JPNnUB1o7qdOW8Rxd+ynPNdwikMtuF+4aqQoW6KxxrEsOxOOchIgZEQt0M3laQgO7XwC9ZQeNmKhDSke/8w4HVDhTuB0kZYIOx5tAu7qU4GZQWad+vrYNjgjXTbvVGohMlMRkuAWdIFK4Hzd7X7+914tKgS6R+oc8oY7fPvCtP0G2ee5/zxlD8T6vl
 vpu41/Of
 EvEERabij/cL3MiC26NRiZx1oH3dVgptGJT0dYu2DkaWgni36Gp32bVSSLtSB2bacTU7i3oBAwn+0cErXqwfP+S5HX1hmcw6EjHzT067/pBULZ6Kkylgkp9xOmOwzVtvADu+5wKRuDsdjmApZj6dmE80EjH4koZW+YzzCtZkwG4pM4inw5YZFnBMTJwA6SCguGATexVHbFgx9Kay6D9bl3lT2RguTG3EEZkc3/4edQogZvisCPeHsIjtEjLLR11WWye8a/HQj1DHHLbX4V7bLmh7lb+Eo5e41ivy75nkZJ8qnhXFSnsAXcIaX1yeS0QGJ8vYQBrxis7Imaf3Sr8kopud/dhLp4dwzpC7dQjStWgRROu2tAKz23WSDJpJDqViduuy5cW5/ruHTh2pbvygFB3CGrlKvpWXBftX1tgD0TgXLLqq2dA4fP1zhSzlRRCCRMszLqNORpgCJbIEe+nDfpOhbo6nQklYupAKW4bdDXNKcDDGchq3lMTGabUMAHvLbcexcYGBPb0ldF87meEyUxxu2HkpR19ZmmZmtpZi9310tVK2SfMZG61VsKw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 11:32=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On 29 Jul 2025, at 5:18, Yafang Shao wrote:
>
> > This patch introduces a new BPF struct_ops called bpf_thp_ops for dynam=
ic
> > THP tuning. It includes a hook get_suggested_order() [0], allowing BPF
> > programs to influence THP order selection based on factors such as:
> > - Workload identity
> >   For example, workloads running in specific containers or cgroups.
> > - Allocation context
> >   Whether the allocation occurs during a page fault, khugepaged, or oth=
er
> >   paths.
> > - System memory pressure
> >   (May require new BPF helpers to accurately assess memory pressure.)
> >
> > Key Details:
> > - Only one BPF program can be attached at a time, but it can be updated
> >   dynamically to adjust the policy.
> > - Supports automatic mTHP order selection and per-workload THP policies=
.
> > - Only functional when THP is set to madise or always.
> >
> > Experimental Status:
> > - Requires CONFIG_EXPERIMENTAL_BPF_ORDER_SELECTION to enable. [1]
> > - This feature is unstable and may evolve in future kernel versions.
> >
> > Link: https://lwn.net/ml/all/9bc57721-5287-416c-aa30-46932d605f63@redha=
t.com/ [0]
> > Link: https://lwn.net/ml/all/dda67ea5-2943-497c-a8e5-d81f0733047d@lucif=
er.local/ [1]
> >
> > Suggested-by: David Hildenbrand <david@redhat.com>
> > Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  include/linux/huge_mm.h    |  13 +++
> >  include/linux/khugepaged.h |  12 ++-
> >  mm/Kconfig                 |  12 +++
> >  mm/Makefile                |   1 +
> >  mm/bpf_thp.c               | 172 +++++++++++++++++++++++++++++++++++++
> >  mm/huge_memory.c           |   9 ++
> >  mm/khugepaged.c            |  18 +++-
> >  mm/memory.c                |  14 ++-
> >  8 files changed, 244 insertions(+), 7 deletions(-)
> >  create mode 100644 mm/bpf_thp.c
> >
> > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > index 2f190c90192d..5a1527b3b6f0 100644
> > --- a/include/linux/huge_mm.h
> > +++ b/include/linux/huge_mm.h
> > @@ -6,6 +6,8 @@
> >
> >  #include <linux/fs.h> /* only for vma_is_dax() */
> >  #include <linux/kobject.h>
> > +#include <linux/pgtable.h>
> > +#include <linux/mm.h>
> >
> >  vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf);
> >  int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
> > @@ -54,6 +56,7 @@ enum transparent_hugepage_flag {
> >       TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
> >       TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG,
> >       TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG,
> > +     TRANSPARENT_HUGEPAGE_BPF_ATTACHED,      /* BPF prog is attached *=
/
> >  };
> >
> >  struct kobject;
> > @@ -190,6 +193,16 @@ static inline bool hugepage_global_always(void)
> >                       (1<<TRANSPARENT_HUGEPAGE_FLAG);
> >  }
> >
> > +#ifdef CONFIG_EXPERIMENTAL_BPF_ORDER_SELECTION
> > +int get_suggested_order(struct mm_struct *mm, unsigned long tva_flags,=
 int order);
> > +#else
> > +static inline int
> > +get_suggested_order(struct mm_struct *mm, unsigned long tva_flags, int=
 order)
> > +{
> > +     return order;
> > +}
> > +#endif
> > +
> >  static inline int highest_order(unsigned long orders)
> >  {
> >       return fls_long(orders) - 1;
> > diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
> > index b8d69cfbb58b..e0242968a020 100644
> > --- a/include/linux/khugepaged.h
> > +++ b/include/linux/khugepaged.h
> > @@ -2,6 +2,8 @@
> >  #ifndef _LINUX_KHUGEPAGED_H
> >  #define _LINUX_KHUGEPAGED_H
> >
> > +#include <linux/huge_mm.h>
> > +
> >  extern unsigned int khugepaged_max_ptes_none __read_mostly;
> >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >  extern struct attribute_group khugepaged_attr_group;
> > @@ -20,7 +22,15 @@ extern int collapse_pte_mapped_thp(struct mm_struct =
*mm, unsigned long addr,
> >
> >  static inline void khugepaged_fork(struct mm_struct *mm, struct mm_str=
uct *oldmm)
> >  {
> > -     if (test_bit(MMF_VM_HUGEPAGE, &oldmm->flags))
> > +     /*
> > +      * THP allocation policy can be dynamically modified via BPF. If =
a
> > +      * long-lived task was previously allowed to allocate THP but is =
no
> > +      * longer permitted under the new policy, we must ensure its fork=
ed
> > +      * child processes also inherit this restriction.
>
> The comment is probably better to be:
>
> THP allocation policy can be dynamically modified via BPF. Even if a task
> was allowed to allocate THPs, BPF can decide whether its forked child
> can allocate THPs.
>
> The MMF_VM_HUGEPAGE flag will be cleared by khugepaged.
>
> Because the code here just wants to change a forked child=E2=80=99s mm fl=
ag. It has
> nothing to do with its parent THP policy.

Thanks for the improvement. I will change it.

>
> > +      * The MMF_VM_HUGEPAGE flag will be cleared by khugepaged.
> > +      */
> > +     if (test_bit(MMF_VM_HUGEPAGE, &oldmm->flags) &&
> > +         get_suggested_order(mm, 0, PMD_ORDER) =3D=3D PMD_ORDER)
>
> Will it work for mTHPs? Nico is adding mTHP support for khugepaged[1].
> What if a BPF program wants khugepaged to work on some mTHP orders.
>
> Maybe get_suggested_order() should accept a bitmask of all allowed
> orders and return a bitmask as well. Only if the returned bitmask
> is 0, khugepaged is not entered.
>
> [1] https://lore.kernel.org/linux-mm/20250714003207.113275-1-npache@redha=
t.com/

Thanks for the information.
It seems extending this to use a bitmask would better accommodate
future changes.
I=E2=80=99ll give it some thought.

>
> >               __khugepaged_enter(mm);
> >  }
> >
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index 781be3240e21..5d05a537ecde 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -908,6 +908,18 @@ config NO_PAGE_MAPCOUNT
> >
> >         EXPERIMENTAL because the impact of some changes is still unclea=
r.
> >
> > +config EXPERIMENTAL_BPF_ORDER_SELECTION
> > +     bool "BPF-based THP order selection (EXPERIMENTAL)"
> > +     depends on TRANSPARENT_HUGEPAGE && BPF_SYSCALL
> > +
> > +     help
> > +       Enable dynamic THP order selection using BPF programs. This
> > +       experimental feature allows custom BPF logic to determine optim=
al
> > +       transparent hugepage allocation sizes at runtime.
> > +
> > +       Warning: This feature is unstable and may change in future kern=
el
> > +       versions.
> > +
> >  endif # TRANSPARENT_HUGEPAGE
> >
> >  # simple helper to make the code a bit easier to read
> > diff --git a/mm/Makefile b/mm/Makefile
> > index 1a7a11d4933d..562525e6a28a 100644
> > --- a/mm/Makefile
> > +++ b/mm/Makefile
> > @@ -99,6 +99,7 @@ obj-$(CONFIG_MIGRATION) +=3D migrate.o
> >  obj-$(CONFIG_NUMA) +=3D memory-tiers.o
> >  obj-$(CONFIG_DEVICE_MIGRATION) +=3D migrate_device.o
> >  obj-$(CONFIG_TRANSPARENT_HUGEPAGE) +=3D huge_memory.o khugepaged.o
> > +obj-$(CONFIG_EXPERIMENTAL_BPF_ORDER_SELECTION) +=3D bpf_thp.o
> >  obj-$(CONFIG_PAGE_COUNTER) +=3D page_counter.o
> >  obj-$(CONFIG_MEMCG_V1) +=3D memcontrol-v1.o
> >  obj-$(CONFIG_MEMCG) +=3D memcontrol.o vmpressure.o
> > diff --git a/mm/bpf_thp.c b/mm/bpf_thp.c
> > new file mode 100644
> > index 000000000000..10b486dd8bc4
> > --- /dev/null
> > +++ b/mm/bpf_thp.c
> > @@ -0,0 +1,172 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#include <linux/bpf.h>
> > +#include <linux/btf.h>
> > +#include <linux/huge_mm.h>
> > +#include <linux/khugepaged.h>
> > +
> > +struct bpf_thp_ops {
> > +     /**
> > +      * @get_suggested_order: Get the suggested highest THP order for =
allocation
> > +      * @mm: mm_struct associated with the THP allocation
> > +      * @tva_flags: TVA flags for current context
> > +      *             %TVA_IN_PF: Set when in page fault context
> > +      *             Other flags: Reserved for future use
> > +      * @order: The highest order being considered for this THP alloca=
tion.
> > +      *         %PUD_ORDER for PUD-mapped allocations
>
> Like I mentioned in the cover letter, PMD_ORDER is the highest order
> mm currently supports. I wonder if it is better to be a bitmask of orders
> to better support mTHP.

I=E2=80=99ll look into it.

Regards
Yafang

