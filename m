Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B639CA9ED2
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 07:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90D966B0088; Mon, 12 Oct 2026 03:34:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896E46B008A; Mon, 12 Oct 2026 03:34:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 738956B008C; Mon, 12 Oct 2026 03:34:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B5046B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 03:34:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BDE201A09B4
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:34:18 +0000 (UTC)
X-FDA: 85313160996.24.D0ACA3E
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf31.hostedemail.com (Postfix) with ESMTP id E5D8720008
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:34:16 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GFmetaA6;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791790456;
	b=TsFNvM1uulZkThi/QiMySoWZnmmOfh/24Cijm5oZ5Jjub83SuSL8BV1s0WUJe/pKApAwhX
	Gp0mSXXXDda+1w35O6GCr81zIeuenHLr8U4+LUMZTjQHACJhIQg1bIrWXpbBDnelGdNz7I
	ZlWTVxWOT9RamPSLMlnBNEzIiZ+HUTc=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GFmetaA6;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791790456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TB1tvVpc7k0BKK/tU4j4YuTf01twWs+L2M2upFeIsNA=;
	b=Y3ZKhrOLItnSQkdkjorXIFIXAwKJ/2NVQsLN+co4jELCCYd6cxuDak4PYsxkQcjKy2j7zm
	JL8JAywTsT1Ox6JtK5O16EL+/d5FleLESWxzhvKSIZ8+0JDDTb8wA8ZOXHJtfWlNvRoLiA
	ELCFmXLYrS3jfGYLf9rLsDfbXoEtX1k=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48b9d8055dfso1171483f8f.3
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 00:34:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791790455; cv=none;
        d=google.com; s=arc-20260327;
        b=lc7WT0ogUa21CaFbPutZeQsSPGUS+gj+A+P7gJNOT+h2lKroUdiH1SsTYV0Trcfdee
         gW9ZIKqi+beVoqePn8cvDm735dCtjhx56qkrjeOovK42qz2juR5zFnzVeQiaRMDMfjE6
         y3KqMg0qcQ7hFFV0JBtUOcK07W21iz/7EUXmTVrFzE0m0Xjbcn9EwdF9l8ubP1u5OEAz
         MufHBN5nl5ez4jMcuEZOAq5O5SDSP35uKIec+WEXu8Wo5blUFDye8IzQqLwzV8YyXIo0
         G5qpqgEE2JSDWrcyw+82+H1yql5QEASEP+qf9mIGA1UHuXRsHsVKwH+YTGjxMYTszd9H
         hu/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=TB1tvVpc7k0BKK/tU4j4YuTf01twWs+L2M2upFeIsNA=;
        fh=u4ThrIzeduKcG+YHlScBq60DIUG2gqBAmSRIRONrE1s=;
        b=CKbkPEluGYAn/JmsmCxordHZ/UgAanZlOviweMlAAy/fEb1LKb/u/ixpPUOi2Eb28W
         fRoLJAZya1XNHqiO4caS2ncoFgzET8bwj7SedbK/wryj1TCHb8Z2YiQY8yyyVgk125lK
         ODOINkKptkOZm3vy4bd0ZY6iSIQT0+OT12oDs8QD+Bvi1QiaQj0Gyx1QEW5rHDc3+dnI
         d1xEcOjHtp+GmMSMVTAFqdDYQVRy4uZicqczBeltU75ny5YlpfopD1YAZ/xN7QPHBxAn
         bkdhWZEhXyWowFcXY/BGaJoO45cIlNTzJYuweUtxwiYn5xcaEotl+3dMwcLSEkrk4Z60
         9SRA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791790455; x=1792395255; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TB1tvVpc7k0BKK/tU4j4YuTf01twWs+L2M2upFeIsNA=;
        b=GFmetaA6mAwt7GbGwnCm6NrML9t1R41W+soCFgwizTBjlkc3C9igrAYsSNPXgRbsFL
         gGxnuRCgB7lqIAzPuYk2q0JlvyM3pgouX+tefjgTfSaExhdPWYEZFF2GkIt8IXnSb8Sc
         UyMUXjmJsVV7m0PQ+mjRElZpVejGMAfZntayk2g1MUSAEcrsaiwQWEVz202kbgv6X37e
         MXeNVV3+aFxzYuDD0X6mvNYHfUuxOqv+GIJT1QYPLRLmfuNe/3jeyXhOkhYV3TDZiT3p
         CF9UNe429PICxexaW3ZWnR6XR7UhV/N/WsNhMRoJrTjdMpsZzfbBQbHXkw9o6AjkYmnT
         cotg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791790455; x=1792395255;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=TB1tvVpc7k0BKK/tU4j4YuTf01twWs+L2M2upFeIsNA=;
        b=lYyAFPWhXe+RMz52H1xaAA0FSnvyDr0nV70gy5tmaf4mzB8vp0AExHCJDCEFYMTbKt
         eHPLnx4IHqkWmCUOx1SQpWvdCHNw3pnAPZiP9UIf5tTj6hyeuidKeCMj+/dA1BaXbXBQ
         xLkIuy4Mm/geWM0NmxN6IKcL5KXATes0DcXsGMJj9WNO7bxAGak9zDmpW/z/Nt+YCAqW
         vBMk4//UgJz5rl0rSaPVsFL0bg18VFwxY4cLI7ZNVMsdm5U9JCPIy6XymDz7lKe4AFIL
         //xp8ICRb/HoKAOMPcVBhqkXNWyvetj1PMjGqE1EKPXjbQvUmrbfvY94R7rfkkE7VSkW
         x7JQ==
X-Forwarded-Encrypted: i=1; AKwUvBy44w7QgOUxedlhpKu0ly3YfTZFosmcEtZQH/TXsTTLQyCHucYXHmy31JSry8qf9Fi4plrB1O4iNA==@kvack.org
X-Gm-Message-State: AFq9FYJCc4Vgis6Q2yblN07j0065Ng0CJjpyJcXzoOUERbuOU1faxo13
	6rEUhhJ6FaS7JB0ZhkvwulFt18tIL8a1XdDm4lvSkA+k7GhUVYTPGz37GG+r561oXCnhbb4GbFb
	I1SHf4WTTenMYXo/N26QXH8Sraku1dlM=
X-Gm-Gg: AYBFou2PXHg8yanJa/5hMvvE99ENCfgLaR1ve1T0gN5rvBIrxB9N8z6B2vVVUG75ksz
	KlhHTHKUwlig5nLcHQE8AH9S/QXoDpjbdwwQr54MRajQdBJXmHXImqRoc2EfHb6sulKAeklW8ha
	APvUF1fP50oK1Ny2enD3VLeelpidyuhKFt56VUKq6HcJ1+Me61hoa1gE3hChmaotTCHXrb6M7+U
	c7I+IHwmuOkZuvv2H6NJVpUGxibAY8M5aWp7C+d4dudkSG7lL8GNjEZ83TtdGCUUm/NBqJ9SQ6+
	CELX/GCtRvOLiBVubOHCIUb0If+IlVYMTRq+ScKGYLlprDB1sg8WlbCs
X-Received: by 2002:a05:600c:154b:b0:49c:fed6:cd3f with SMTP id
 5b1f17b1804b1-4a18e4d0be2mr158510455e9.23.1791790455069; Mon, 12 Oct 2026
 00:34:15 -0700 (PDT)
MIME-Version: 1.0
References: <20261002090947.869220-1-jiangwen6@xiaomi.com> <20261002090947.869220-4-jiangwen6@xiaomi.com>
 <asudY_EhrT5fZGmZ@milan>
In-Reply-To: <asudY_EhrT5fZGmZ@milan>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Mon, 12 Oct 2026 15:34:02 +0800
X-Gm-Features: AclHuK_LlxXaCmKE3CgA4amsUlg18qyTu4ifi545sZ2ZwusM-AnLpZx1y3tgmDI
Message-ID: <CAHKocdH9Cmjb4oEVvZnxDhYRKfK+b00k3mm_YwWmSnO4fZ+qyg@mail.gmail.com>
Subject: Re: [PATCH v10 03/10] mm/vmalloc: use pte_set_huge()/pte_clear_huge()
 for PTE-level block mappings
To: Uladzislau Rezki <urezki@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org, 
	will@kernel.org, Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, 
	anshuman.khandual@arm.com, baohua@kernel.org, chleroy@kernel.org, 
	david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com, leo.yan@arm.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, mpe@ellerman.id.au, 
	npiggin@gmail.com, rppt@kernel.org, ryan.roberts@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 4amronqk6dbzub1wpp61os85zzr6her5
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E5D8720008
X-HE-Tag: 1791790456-572717
X-HE-Meta: U2FsdGVkX1/eSEO6IAE3qTvAkh4mLtwK7F3Ted7h6NTK3OYtxPLkYIqXvtrOC2zDIp7jsoNVDcfodMEWCLLlo+lXbGee4jz7+m2Yc8kkcDq4TDElcIQARivw1loZrFloYN+cHdL8G8TRCul5G0PkRENbWwwd0MrBwzDGeva8V8tMicmAMPLoYpX8YNNOgrujD1+LYNC4AdC4XMXfCuJd9vRcYLNs22tti7HO1924rc0Hs0L528hXp7qIkIxDMj6FrUoZoevgbFoGdGBpaKsQpZXQtwgxi6h6A57/0FuMLOizby9RilEoKm/tP287PyL/+UGfHgKgH3d3ygb72bd5dyBrynyuLL+Vm6ZdRstfZpwvi8j+4I/a8zam+4/OtvFvpWVbUH/6V6Q4A6A/nSLICJv+ItwRQ56a1zfZ3sqM6HuPtGG/mHwqrSHbK7iF5pzc07C7iSk+MxP2NNmXhZ1idLuFLXXEnU/en5MO0ChZKkCavx87x+AyHWUKw25fIOwk08LA1c/KIf4N2JcvykxqrDj64VQTTEzO+/ASdVPr2SNfYrLmBK9zkw3b084ISkHnGCJr3or31LjyZTvjgFFQLT5nrlAusljBmSfW2r0bXLm1ADeAnddk/MmN7sFmpvgWnDsM3ly1IZ0xsakdqZ8ygAitPP2w09tIrLTmBDaKBAIYRI1djfwjSc3MXHUu2+1tiDPyF4ZoPNeAXbMW0MicfTtl7CbqZ6qIYSkOXzulN6hyhznN5VVac/f3fBh3qQG2KkwwHr6kF+UOenOHJN5y+u1IXQenHgGAz/0QGC4guZIeANt5LoNePQRuMMPKgOfusU/5t8Ju1ZQ1NkAOTVF0Cw6SQQaPdup/R/Bh3q3uRbaLkIGXx3NSU+QAVgRBgnP9Jd/RpoJ8SVueNVIIhlLjENL5pExx+806UnYhm97o0GeozEBg6uwAs5f6hbqDseku4J6mDs73LfruNcXLBmW
 yMB1lRhV
 ixkcvAqxv+MpEfOv12uL3WhtQCIZnx4zj7NIarxlGhyk7zVQWMj4IfPw4yw1d3UonZwnIRQCaWaazZxwqunA9En5l3BZwnBLYHg0Z5VDIJ2dTcxtee7MmKAbIhJIp8VrTJMwC3fwXV/a3aF8TkGutpVOeB/ScDUBRBjKg8uH5+p/tbPYvyf+k3G0QpD6t3ZEDSdKNGF5ovcOiwa6gLNaG8cFuFADN3930RAQysI59tqAumvslzRxSTokL8rZAKOUGrjTNkSqRYvZJorWnec86pl7ETb3kOb19KO0v6NMvyZ0nSMELaXxN6J1567TrYS1CGR8nSbZ6T3AdE4YheCd0kZIFUVa8NKG6S1EmFUELpDhSQnFrCQWV+Aen2quM2DUhnQYNedyDupaYcmmpWR0eZi572rUavNWG7brlNbEbrTnC4ESpWrKJ8mdo/OvqCgaGyClkPqYeYCIhinVKIs31iVe9WT8X1Vnbs86FA8RwKvjneGd2vroLEvvh+s8qkaE5J3qFl33sjH7RdUDbhs9nSBXh20849uHuK/XWa+aDxkkVcvZP05g9GXCMOjRubUmxKkGHvw6YxyAXgQWHuXW5VjbUAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 11 Oct 2026 at 22:29, Uladzislau Rezki <urezki@gmail.com> wrote:
>
> On Fri, Oct 02, 2026 at 05:09:40PM +0800, Wen Jiang wrote:
> > vmap installs PTE-level block mappings by reusing set_huge_pte_at() and
> > huge_ptep_get_and_clear() under #ifdef CONFIG_HUGETLB_PAGE. This makes
> > the feature silently unavailable on CONFIG_HUGETLB_PAGE=n kernels and
> > couples mm/vmalloc.c to HugeTLB internals it does not otherwise need.
> >
> > Now that arm64 and powerpc/8xx provide pte_set_huge() and
> > pte_clear_huge(), add the generic fallbacks next to the existing
> > pmd/pud_set_huge() family and convert vmap_pte_range() and
> > vunmap_pte_range() to the new helpers. The CONFIG_HUGETLB_PAGE guards
> > around the block-mapping paths are dropped, so PTE-level block mappings
> > now also work on CONFIG_HUGETLB_PAGE=n kernels, and mm/vmalloc.c no
> > longer includes <linux/hugetlb.h>.
> >
> > The fallbacks exist only to keep the build working on architectures
> > without PTE-level block mapping support. They are unreachable there:
> > the callers only run when arch_vmap_pte_range_map_size() or
> > arch_vmap_pte_range_unmap_size() return a size other than PAGE_SIZE,
> > which requires an arch implementation. BUILD_BUG() makes that
> > explicit rather than silently doing nothing.
> >
> > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> > Reviewed-by: Barry Song <baohua@kernel.org>
> > ---
> >  include/linux/pgtable.h | 29 +++++++++++++++++++++++++++++
> >  mm/vmalloc.c            | 19 ++++++-------------
> >  2 files changed, 35 insertions(+), 13 deletions(-)
> >
> > diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> > index 8c093c119e5a8..a7fd51fec8a17 100644
> > --- a/include/linux/pgtable.h
> > +++ b/include/linux/pgtable.h
> > @@ -2204,6 +2204,35 @@ static inline int pmd_free_pte_page(pmd_t *pmd, unsigned long addr)
> >  }
> >  #endif       /* CONFIG_HAVE_ARCH_HUGE_VMAP */
> >
> > +/*
> > + * PTE-level block mappings for vmap.
> > + *
> > + * pte_set_huge() only has to be implemented by architectures whose
> > + * arch_vmap_pte_range_map_size() can return a size other than PAGE_SIZE.
> > + */
> > +#ifndef __HAVE_ARCH_PTE_SET_HUGE
> > +static inline void pte_set_huge(pte_t *ptep, unsigned long addr,
> > +                             phys_addr_t phys, pgprot_t prot,
> > +                             unsigned long size)
> > +{
> > +     BUILD_BUG();
> > +}
> > +#endif
> > +
> > +/*
> > + * Likewise, pte_clear_huge() only has to be implemented by architectures
> > + * whose arch_vmap_pte_range_unmap_size() can return a size other than
> > + * PAGE_SIZE.
> > + */
> > +#ifndef __HAVE_ARCH_PTE_CLEAR_HUGE
> > +static inline pte_t pte_clear_huge(pte_t *ptep, unsigned long addr,
> > +                                unsigned long size)
> > +{
> > +     BUILD_BUG();
> > +     return __pte(0);
> > +}
> > +#endif
> > +
> >  #ifndef __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
> >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >  /*
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index bea9f76ed7e74..fb757d95bde25 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -38,7 +38,6 @@
> >  #include <linux/rbtree_augmented.h>
> >  #include <linux/overflow.h>
> >  #include <linux/pgtable.h>
> > -#include <linux/hugetlb.h>
> >  #include <linux/sched/mm.h>
> >  #include <asm/tlbflush.h>
> >  #include <asm/shmparam.h>
> > @@ -100,7 +99,7 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> >       pte_t *pte;
> >       u64 pfn;
> >       struct page *page;
> > -     unsigned long size = PAGE_SIZE;
> > +     unsigned long size;
> >
> >       if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
> >               return -EINVAL;
> > @@ -121,17 +120,12 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> >                       BUG();
> >               }
> >
> > -#ifdef CONFIG_HUGETLB_PAGE
> >               size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
> >               if (size != PAGE_SIZE) {
> > -                     pte_t entry = pfn_pte(pfn, prot);
> > -
> > -                     entry = arch_make_huge_pte(entry, ilog2(size), 0);
> > -                     set_huge_pte_at(&init_mm, addr, pte, entry, size);
> > +                     pte_set_huge(pte, addr, PFN_PHYS(pfn), prot, size);
> >
> As far as i understand, X86_64 arches do not use this path. This
> specifically is only for ARM64 or powerpc. pte_set_huge() makes me
> thinking about huge-page mappings(PMD/PUD/hugetlb). This helper is
> about mutli page mapping on the PTE level.
>
> Better naming? pte_set_large()?
>
> Any thoughts?
>

Agreed, "huge" is misleading here: on arm64 these are CONT_PTE entries
and the helper writes a range of PTEs rather than a single leaf, so it
is not a PMD/PUD/hugetlb huge mapping. I'll rename them to
pte_set_large()/pte_clear_large() in v11.

Thanks,
Wen

