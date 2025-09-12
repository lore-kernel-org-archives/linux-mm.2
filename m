Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E0A1CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:43:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77E0D6B0010; Fri, 12 Sep 2025 05:43:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 755F56B0022; Fri, 12 Sep 2025 05:43:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66B746B0023; Fri, 12 Sep 2025 05:43:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5642D6B0010
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:43:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E67065A17B
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:43:33 +0000 (UTC)
X-FDA: 83880110706.05.822B5C9
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0C97320008
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:43:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D9iFzv1G;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757670212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OETlIHZhLuu2YOWBlAPQ9XetW3Ixqb//beh5cOzY/AE=;
	b=aglEzrwYfRT6aHTNlovuVfPnmKd+wbpcCi96ZRZoeSphK7DvTaWETJxE0vEOHiESNh9Dn8
	jBMcCPI59XeKpO2X4TwTodxQcT6OBKApX06xxitGqwCaC9BIwOAo+95fQRUzfAu1i7ubGp
	yKbT3Gf6Zy0fxD+LX4/BaGd7if9og0M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757670212; a=rsa-sha256;
	cv=none;
	b=b9dTccH08nuuc4FRkG/iO/wohcT60j5FQ2hyNYe1iDFA2VlMMLgmLabU74BI4qP9rPdaPL
	COwFLs+qqcrHzQNg0cMi/PEP21juvTpEtowx6VovqR9oT8+rcjT5KqIZa78coj2E/5cYt/
	I6wwQaNQw1ynVGIMsi8366CTBzKENdU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D9iFzv1G;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-62ec5f750f7so2502435a12.3
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757670210; x=1758275010; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OETlIHZhLuu2YOWBlAPQ9XetW3Ixqb//beh5cOzY/AE=;
        b=D9iFzv1GMQzt/EoBy4tFU5TYHHiDG+fUFi3fYjO4PMpkVZ+ylSZ009oRa2+1NuncOB
         Q3d5G0pivp4E3RgYDeBwjl6mq1FZEKPCAJlWISfNr6QBAvBzB8AMx6FwBYxveZVo9Rxw
         UCsmDRwjOyWL+MM9MMZPtafCwt76xBCsaoel/RGGXHwwhS5+E+SkPWHz5GVIaVPAUr4a
         bRyRvO+1EdMniFG4f9ujRlt6J253jVNZ8afSu4+gmNAllb4GAkL1AsDxQ6qJYzFMJ3Xm
         SoILRtOr5BBdXwEPIx3lD9L8KniRvxDJeYUJGC+yjhQS9JYEwOX2iYfkNn50OcCDbFDN
         muuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757670210; x=1758275010;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OETlIHZhLuu2YOWBlAPQ9XetW3Ixqb//beh5cOzY/AE=;
        b=U16qYGE0GlAOaXPjhWcEyQZKFSLLbnEwPpz0Eb6ASG15rLMfsSW2RCfJJhbP/Ql3R0
         h/R/vSQO46lrsglrlISYzmOUdjJPtEPjiz79GAh7KdcCNYMMIvoaq6uX69HDBcPUbFS5
         Nx8zCLkNKb3r2psppkUD1UstwbmdgGuLlalS2j1LNWaFGb8lJkbQ7tqrKo8dzK+Cp7LY
         TGecKwrGWcCEM7qtigxMfbhQeOqQz4z2itPSRDJO8VslEhiQeQ3O479e7iy+WAGTWNTE
         mclxgkc77nD/InheS1x5Gax87Tbg1wB21OfVbRpKNIEk463L9pkefWy87THx9oVypEdX
         99HA==
X-Forwarded-Encrypted: i=1; AJvYcCU8dE4MSXOu7Xvz9NU8TpDjYleYUHSZ7GEz1IISgBgCIBUeHhgngucZgYpcogBSMIsGo5kEGt8KlA==@kvack.org
X-Gm-Message-State: AOJu0YzNbEUFq7iugDxh4u1YGUkRgOL9S5uXfrHN4NRx3pHJNPQCldVY
	8DXwk4HOwTrjYa4wDjQDRpcWtYqguhXMXRf+NhKJu7RYHWAT8spHwgZTBLhMtGelswpGw44TDfU
	qSu1fwSxvmHdaFPDGWSLHN8A90+kkg8E=
X-Gm-Gg: ASbGncunMPV4EoC/0595Tkh1sZZyabuTXU3C9GjcO8NqDyxYbdDMmLwfzE8zuu9RNe1
	1F/NHBIsVwXDHH5couLAOXVXESbnwksHScPrT9R4Y/sFUYE1IkS5dqB8a+MTFesYtflwjErpWx6
	3iNWUjloPgbmxEi7joAlcXzrPK+CbL3+5k0GZ9yl0OLlkGbnDqZHylZTXDWUaXmyYAn4qVmzpi0
	VGCnXwOLvM=
X-Google-Smtp-Source: AGHT+IEzZL/B+m1oA93uBf6bciqzmOCInPrUEGceQPEbgzipBFvRN2q5E9EMf4RZciIhQg3sL5+cbhvs5JrscubJ+vY=
X-Received: by 2002:a05:6402:2553:b0:627:f96f:aa7a with SMTP id
 4fb4d7f45d1cf-62ed85204f8mr2284392a12.30.1757670210176; Fri, 12 Sep 2025
 02:43:30 -0700 (PDT)
MIME-Version: 1.0
References: <20250910160833.3464-1-ryncsn@gmail.com> <20250910160833.3464-12-ryncsn@gmail.com>
 <CABzRoyZc1zHHy5eFaO5hRY=bM36xsk3COd=r18KahmrP11tpSw@mail.gmail.com>
 <CABzRoyaAA3D0nfkQcBMjZ7crUckJXXpGmYfmq6ojQC+BQUigFw@mail.gmail.com>
 <CAMgjq7CtYpe4sEYaw2carqGskvchV9Z+1yn2Wa3nMP2VguV_eQ@mail.gmail.com>
 <223c560b-0234-4203-a11d-661656317808@linux.dev> <d5f84730-c7c0-4059-a5b7-061a9eaebc5c@lucifer.local>
In-Reply-To: <d5f84730-c7c0-4059-a5b7-061a9eaebc5c@lucifer.local>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 12 Sep 2025 17:42:53 +0800
X-Gm-Features: AS18NWCKrRyfpaANX_oyOUj3Wt6htqC4Oat1olLvElN275-UZVlguwjwLMwtUec
Message-ID: <CAMgjq7BbYmTCmA+NPS_jQ3iWM4DJR1mkDe925qTcYOMzbGwnGg@mail.gmail.com>
Subject: Re: [PATCH v3 11/15] mm, swap: use the swap table for the swap cache
 and switch API
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0C97320008
X-Stat-Signature: twed7m711yzj3scst35ax193ah4ae5o1
X-Rspam-User: 
X-HE-Tag: 1757670211-208107
X-HE-Meta: U2FsdGVkX1+C0i6ftIbrsY9Z6ZVMP5l7m+s4QQN2QRysN3yKvg0Zt40FgzNbqsABtIgC9JMXFV4afgrSMksFQSF2Z99L/Xd8P84yFkXFBvYW0Krvo+aRvrBA3KCQsFO98fmqgcLyd5vflU7+JFAy/KBvNINqoZuxLA2yBaTZ3cfnfiyzYSjDEZau0YLm8jYyc+c6YqdDF0HgXuCoHGdzOOkguiJbUIyJcv4Upr1eVzURjrOhGzU6fargZfipIea7yuJPErACMBY8Xen24jliFAPzhYUZ7zr/vRENx+mNLXXJZi7s6ZIXFh3DAESMMkw/DDtFcD2KAJOFcT/6nR11rYEMjg5aamc+4iPIYDH0ts+kH10hvMOr4TwimJgdVJngp4qNU1Xq3cHxuotvq9KVmEjVLCsimH/FUz060JKtGn5/uNJwKQCL76xH2XMu9y4nmi8VrQoSpZC1dR9Dux4glOENjO7BNbClVBPKn9xWDPgOCQks2OUG5H4YpqB4IXWcvzTnOpr8P+vQ2mbZWCnNfT7dpz4C/Tjol63V4J+zGULtBXdtkYTkiN6kSxI6pfVumjIbTJJaWHQE0HHecX25wCyThf99xW1VH2oEEMUwR0QFyROwekyz6ytmY3qAtDu/NQfEc5KpydEYiBAjtV++GYgJQ6ki2TUGOKcs9lE0lImppZ3gxxkqGPii10eCIokbMdfjiG+TWaKYlFx79Pb10FMNO/AG9iS/VDFc0wKCXvdxB9okjZH+AgIMWlHxUZZ1j8egcUKdMmYIalB0/Nz72NPD1DMzTw068yZlY1TmokxoWktVBqlHv/YsAi9XuGLbajSkjaZA+jJ5tOvoUUiPGUu2Uc+gRCPf4w/p6S8pXOCgbm8ncOrKPL04tUBjUzZFbtLoOptGAy1QRzX9b2HDH+0IGG7PKvposVo2HtRjw/FTZILM069tIY0oy8LtfAAt4xiOjSgnypaxzbFM73b
 jFsHrNyu
 6rWfauC98Ih+DUFDoN9gmgt5tSozwA4cHcDOr1av0UtZpVcMUvfsyPQtZfYk0wC5y8WfI4m1woCBCihEaGmyUZBPCb8esuCAwPwEj78NaNn8o5ktVii0B1eJmM0ASnze1G5Fx5Vfjec++RoW3R6m0mCdZwFIUjFIfiXaTGVB410Ys8Kw/OIs7sphcQq9EYQwbUsqvXw1iz3l0N8BWyUROs7geHhlLOw1RiXnnbIHG1TVC4G0Fls0GKh1aecm0bdSnjpWEX644xDuwwQ95dMtDAFFlqGYh1ouBVXFXlRnc7U/vlRU/DBPdjlpti5MTx3W65JPAR4a9JrCXI7/O5xBd7sklHyRN0QTAaxh/Oyj0SNpw3pmEw49haGyl8gntjMtH1p9PYWwUbJ8XQ3FFslVztsYnngB8PwTszJb5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 5:31=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Thu, Sep 11, 2025 at 10:54:19AM +0800, Lance Yang wrote:
> >
> >
> > On 2025/9/11 10:48, Kairui Song wrote:
> > > On Thu, Sep 11, 2025 at 10:34=E2=80=AFAM Lance Yang <lance.yang@linux=
.dev> wrote:
> > > >
> > > > On Thu, Sep 11, 2025 at 10:27=E2=80=AFAM Lance Yang <lance.yang@lin=
ux.dev> wrote:
> > > > >
> > > > > Hi Kairui,
> > > > >
> > > > > I'm hitting a build error with allnoconfig:
> > > > >
> > > > > In file included from mm/shmem.c:44:
> > > > > mm/swap.h: In function =E2=80=98folio_index=E2=80=99:
> > > > > mm/swap.h:462:24: error: implicit declaration of function
> > > > > =E2=80=98swp_offset=E2=80=99; did you mean =E2=80=98pmd_offset=E2=
=80=99?
> > > > > [-Wimplicit-function-declaration]
> > > > > 462 | return swp_offset(folio->swap);
> > > > >
> > > > > It looks like a header might be missing in mm/swap.h. Please let =
me know
> > > > > if you need any more information.
> > > >
> > > > Confirmed that just adding #include <linux/swapops.h> into mm/swap.=
h fixes it.
> > > >
> > > > diff --git a/mm/swap.h b/mm/swap.h
> > > > index ad339547ee8c..271e8c560fcc 100644
> > > > --- a/mm/swap.h
> > > > +++ b/mm/swap.h
> > > > @@ -3,6 +3,7 @@
> > > >   #define _MM_SWAP_H
> > > >
> > > >   #include <linux/atomic.h> /* for atomic_long_t */
> > > > +#include <linux/swapops.h>
> > > >   struct mempolicy;
> > > >   struct swap_iocb;
> > > >
> > > > Cheers,
> > > > Lance
> > > >
> > >
> > > Hi Lance,
> > >
> > > You are testing V2 not V3 right? The build error is in V2 and I can
> > > confirm that. But In V3 I've added "ifdef CONFIG_SWAP" for the
> > > swp_offset usage in swap.h. I've just tested allnoconfig and it
> > > works fine on aarch64 and x86_64.
> > >
> > > V2: https://lore.kernel.org/linux-mm/20250905191357.78298-12-ryncsn@g=
mail.com/
> >
> >
> > Ah, I was testing V2. My apologies for the noise!
> >
>
> OK so my bug is different then :)
>
> I think the issue is that you're not properly checking for:
>
> #ifdef CONFIG_MMU
> ...
> #endif
>
> This is v3 (I see the #ifdef CONFIG_SWAP) btw.
>
> So swapops.h is wrapped by #ifdef CONFIG_MMU which is why the declaration=
 is
> missing.
>
> The below fixpatch fixes things for me.
>
> Cheers, Lorenzo
>
> ----8<----
> From 5a3969a438af9c33422a45fe813a44068d784b2f Mon Sep 17 00:00:00 2001
> From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Date: Fri, 12 Sep 2025 10:28:40 +0100
> Subject: [PATCH] fix
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  arch/sparc/include/asm/pgtable_64.h |  3 +++
>  mm/swap.h                           | 37 +++++++++++++++++------------
>  2 files changed, 25 insertions(+), 15 deletions(-)
>
> diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm=
/pgtable_64.h
> index b8000ce4b59f..b06f55915653 100644
> --- a/arch/sparc/include/asm/pgtable_64.h
> +++ b/arch/sparc/include/asm/pgtable_64.h
> @@ -1050,6 +1050,9 @@ int page_in_phys_avail(unsigned long paddr);
>
>  int remap_pfn_range(struct vm_area_struct *, unsigned long, unsigned lon=
g,
>                    unsigned long, pgprot_t);
> +void remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pf=
n);
> +int remap_pfn_range_complete(struct vm_area_struct *vma, unsigned long a=
ddr,
> +               unsigned long pfn, unsigned long size, pgprot_t pgprot);
>
>  void adi_restore_tags(struct mm_struct *mm, struct vm_area_struct *vma,
>                      unsigned long addr, pte_t pte);
> diff --git a/mm/swap.h b/mm/swap.h
> index caff4fe30fc5..18651687fcd1 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -53,7 +53,7 @@ enum swap_cluster_flags {
>         CLUSTER_FLAG_MAX,
>  };
>
> -#ifdef CONFIG_SWAP
> +#if defined(CONFIG_SWAP) && defined(CONFIG_MMU)
>  #include <linux/swapops.h> /* for swp_offset */
>  #include <linux/blk_types.h> /* for bio_end_io_t */
>
> @@ -317,7 +317,26 @@ static inline int non_swapcache_batch(swp_entry_t en=
try, int max_nr)
>         return i;
>  }
>
> +/**
> + * folio_index - File index of a folio.
> + * @folio: The folio.
> + *
> + * For a folio which is either in the page cache or the swap cache,
> + * return its index within the address_space it belongs to.  If you know
> + * the folio is definitely in the page cache, you can look at the folio'=
s
> + * index directly.
> + *
> + * Return: The index (offset in units of pages) of a folio in its file.
> + */
> +static inline pgoff_t folio_index(struct folio *folio)
> +{
> +       if (unlikely(folio_test_swapcache(folio)))
> +               return swp_offset(folio->swap);
> +       return folio->index;
> +}
> +
>  #else /* CONFIG_SWAP */
> +
>  struct swap_iocb;
>  static inline struct swap_cluster_info *swap_cluster_lock(
>         struct swap_info_struct *si, pgoff_t offset, bool irq)
> @@ -442,24 +461,12 @@ static inline int non_swapcache_batch(swp_entry_t e=
ntry, int max_nr)
>  {
>         return 0;
>  }
> -#endif /* CONFIG_SWAP */
>
> -/**
> - * folio_index - File index of a folio.
> - * @folio: The folio.
> - *
> - * For a folio which is either in the page cache or the swap cache,
> - * return its index within the address_space it belongs to.  If you know
> - * the folio is definitely in the page cache, you can look at the folio'=
s
> - * index directly.
> - *
> - * Return: The index (offset in units of pages) of a folio in its file.
> - */
>  static inline pgoff_t folio_index(struct folio *folio)
>  {
> -       if (unlikely(folio_test_swapcache(folio)))
> -               return swp_offset(folio->swap);
>         return folio->index;
>  }
>
> +#endif
> +
>  #endif /* _MM_SWAP_H */
> --
> 2.51.0

Thanks for the info. But I think V3 should be good?

CONFIG_SWAP depends on CONFIG_MMU so if you have !CONFIG_MMU, you must
have !CONFIG_SWAP.

I didn't adjust the header in V3 and fixed it differently from what
Lance is suggesting, V3 wraps swp_offset with CONFIG_SWAP. It should
covers !CONFIG_MMU case too.

The folio_index in V3 (this patch) looks like this:

static inline pgoff_t folio_index(struct folio *folio)
{
#ifdef CONFIG_SWAP
        if (unlikely(folio_test_swapcache(folio)))
               return swp_offset(folio->swap);
#endif
        return folio->index;
}

I just tested !MMU and it seems fine.

