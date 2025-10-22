Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D296CCD195
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 04:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E510F8E000A; Wed, 22 Oct 2025 00:09:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E01278E0002; Wed, 22 Oct 2025 00:09:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC8F28E000A; Wed, 22 Oct 2025 00:09:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AF5798E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:09:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4D1781A0701
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:09:01 +0000 (UTC)
X-FDA: 84024419682.14.807CD49
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 75E1B12000A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:08:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YLsO8+dd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761106139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=URErFMYOLyHpAjEwaEXcwkMOPsj73MCltrwJY2rXne8=;
	b=S6SxCun1nv5/EiU5AVed/8pjTUUTEJ1HowMDc6nKRoVscUAKCIv6RSWWN15ugMvoNs/ENo
	WgmczmrObk6zmX2GGFyb0NLWzX8b8PjwLoY83lyr9bhZQRwUPElX6XcyOV3lCHLvWqcG8y
	nQz063ClupkphvJ/RVp2bj6L6MUnF5w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761106139; a=rsa-sha256;
	cv=none;
	b=GAkYE06qcqLLxC8aq92n1cxUAQ+y8Q+cO8kj7zzi+FMqlsmSbR5YcWdFDwicLLX0fBiA2J
	FTm2Fi9VZ5EI1ePhbK9XmLWWJnIPHxEz2Q7XTvBNujYXW/Br2GEvCDHljR3l7b0zlpiQaE
	zw9P0rhsa2C6dtT5wSEbIMJ/qI5xoeY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YLsO8+dd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-88e456972d5so1157258085a.3
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 21:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761106138; x=1761710938; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=URErFMYOLyHpAjEwaEXcwkMOPsj73MCltrwJY2rXne8=;
        b=YLsO8+ddYqfM855OC/MgPfUhtDK/YddVOPECL9KhuhnPkTzxz8j/R11hLaa9KTfEyJ
         E2SJFJpkcXteFn+PDHYCOzSQxWCnOBaKYXCWzmiy4BAgIhwCbeqWDFUhnRLFRaDx0OYR
         W5rLvyu0IezwB6FZpxCRQ4R0fOmP33Ghp6i+Kp+dDMXX0udLihYJksJ9tPkBNsj5fXzU
         KqG3ZPDKgJve5Cdi7KTvQIcka6bD7Y8Ibz6EHhZ8ZhEyN8r8AI71ocdw079PR2ytnROS
         48rgCqkobGFQhvtTfPENfeMJrziP7X9uupUp+fMwKAgqBxOYh/i+T8OrnmmF2qgg16IS
         gZtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761106138; x=1761710938;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=URErFMYOLyHpAjEwaEXcwkMOPsj73MCltrwJY2rXne8=;
        b=AxSn7YTw8WAUYQuif53Y3wRlGVpjyEeTB9Vbx42lFLSV5W78PhEKJXbDRP4hZv7s9P
         NZZYF3NRoGvhAkNDVL/AJ+EZWPmwOJ1LJanwgM1SKypI26/fDkPPcctxkMIQ1LWdiSzw
         PRy5hLar9QuJgq3KwA7DeF/isbsdMW/FeIIA/vd9N2Nkr0FcfuyK+UXw5bbKNuPGEe8O
         FGaPjkzVbzMg1Ny4+eYi7Vv01WfVM7k3ez+hBVHruV0/mreiUIStmZqPYZoDhJYonPjD
         7X9fGKEH6gMBf7Is2AQl9xorIJJ7KxbQlwpSuzk2NRN3JM7OpgDGVIhUdQElQuovkBHo
         J2eg==
X-Forwarded-Encrypted: i=1; AJvYcCV+6sOktOWz5HQkiyeN/H5wxkfPLaHBYpFKPuuTpWbfXQAt4x0zu486ol6GCSvTEONO7BiRoM+IDw==@kvack.org
X-Gm-Message-State: AOJu0YzAr7UEr+AM5zS3s4alOyMALHj14Qa+t4Rs1x+5/hnHUNGzH7XL
	iaclAl1feMutODOd8kixxy7qgwtsIWtlMIvcv77dDAItV6nJwYZf3+HLSxtN8I+ffFuwIRyG/ar
	9vu9CDHyNq+66yPDK+KZMxN8x5ct/l5s=
X-Gm-Gg: ASbGncvTx7NYcFuLupIUFCa9yo0fFtvv939ib1V8gG45UkdncNl5c45GfRpuf7IpS/Z
	Ctz4CV7Y5Fcaf0hr8lKM5JYo+l6Ymy26dRIYIVQa0CH3DEEMx4TXhoXwccGAl5/3fTDD8IvuwW0
	RNArbnizSd22ASvy3+p/xvxRpP208D7fYmTBl1cTGaw5t4imN/wv+vBE+gJWrJk5+Qlm02J1zvt
	RYFNtmF/H67wYYuZJu6UoBIPp8mBlWoOVb80Y270TamdOQR8C6qQmDlMMYY6H9Yt4nWx7zPrYvq
	0nY6Cz4RJJH+3/mV
X-Google-Smtp-Source: AGHT+IGH2SZ0WRdKh3j7EkOtPTZS6RKLKqRp7QWRcXCt+UnJ5XXc0fzRoyKcNi/2idgTj+GrP0UQbD3joeBzcCGF8bI=
X-Received: by 2002:a05:620a:394b:b0:85e:5fef:86fa with SMTP id
 af79cd13be357-8906e9a4759mr2627239885a.28.1761106138195; Tue, 21 Oct 2025
 21:08:58 -0700 (PDT)
MIME-Version: 1.0
References: <20251013092038.6963-1-ying.huang@linux.alibaba.com> <20251013092038.6963-3-ying.huang@linux.alibaba.com>
In-Reply-To: <20251013092038.6963-3-ying.huang@linux.alibaba.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 22 Oct 2025 17:08:47 +1300
X-Gm-Features: AS18NWC2SmOG0fXr6JtdNTOm9s8laV21PFicKhXafLS2YkktGrTmfAKkyqEoEAM
Message-ID: <CAGsJ_4xaA8QRjP9H=n1hQfEfGop7vOd5Y=J+KQzuOyfa8GK-kQ@mail.gmail.com>
Subject: Re: [PATCH -v2 2/2] arm64, tlbflush: don't TLBI broadcast if page
 reused in write fault
To: Huang Ying <ying.huang@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Yang Shi <yang@os.amperecomputing.com>, "Christoph Lameter (Ampere)" <cl@gentwo.org>, Dev Jain <dev.jain@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Yicong Yang <yangyicong@hisilicon.com>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Yin Fengwei <fengwei_yin@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: tj4mx7gco3huxaq111mcbrybmzoajoiu
X-Rspam-User: 
X-Rspamd-Queue-Id: 75E1B12000A
X-HE-Tag: 1761106139-608579
X-HE-Meta: U2FsdGVkX18PdJuYUZJkH44RhJR5veyLR7R0Cw7+BkeaZgbp3s3OJqvTIyytgX3469jmmiA+/E72UYg1Cvmx/Id94G8eNrmpTjoc/jUoeH7XNJwBe9ZveH9vBP/vAmBMBLhecwtegEPum97AiTRysv9yvWo0a/fHyN0vwvaMeb/Z6yk7wwIb/o3gobt0yT9M178H/epe1y/atA8t5h779rJH8ASP+BK3FU1esiLJfqaB21zq2WLqn4X/SARDdaI3DJ9SbiC6Z2LzivGFHbjPu1A5ROzPqC9bvtHIsej9t0uD1OsdoQWUp5BmxZq6jJAn2kxr2liobApD2kuPURs86jhSi/EJxp2zc7lKAXg7ydn9yerQLCdKGMjWvfkTKT7HGjYv5EBDm1hJBP/n/xCR8/P5Cf6A2Wm+AzNXnnbzJB0UxO/wHO96lOATkoj/MQV81NXb7dHq0QT56BfUEC+eMXDOFRTQ1y21fETU9+3NLWtcQSJHPMTga6/6bAWXshGw+D7R5e9Owjw96l34NFNWS2q4nGY9i48r81A4ZrLFulugWKQGY3lSL46w9iEmwikQAtmleRRY+2VC/Kr4cy/5vDTi14Nvq1KgNtz+T7vFGDKJKw10uqIIBQnf3VYNeqaTVZA0qUoezWJLB2OSozjJpqulU6t+LyiP0k/kDZQWSfyjRUj5uE5FQ1mrkiN1T2qViUhhEsykjoPQWUVLxtToonhZ16uJDxAYwATiBAfOa5UJ985BTHACQczp3EbX5m5Bpn3FvnyDcHxEvITUN8O9IewTf/Nm7z88HgkDnTKuk6lByxBgKuS+kX0o/XV7ZwTjSe4bw2fonUDssrGs8rhToau3ldj3mGPZ1JXZwQM7Yr0VyMV+95pUS5APLYWbE5X8Or/21UxU8CDae7msEhYNpPXY4pS37NruqrHrOgwksvFgy3ZrdxmWt3PGkq5mr+eK8rESJ+UEd3L4NYlKeRY
 xQS1NWrt
 wRNXdNUSXiNVNwS3vjxyb2SbO9YxLyUS7otsAoYEvXrhIWbUvM1Y15IqFqK1kdPvgb4b1ztEYSna8tHgrwoW0ZtakYfhHwwaiuNuzUw6cNsAwvvJPDee2tG+h5VDHUpsQQhr5H0+DBXZ4OVlZJerHMNlMEsG2bDQDddNOfDSAVcD6BEfVwdBqmMrIviV1Ao5ZJ4MPQtwxxp55qObwx5t/cSlv+mc0Av0LrTvGlUFngONL/esxua2WSDV1lBUJarprI9BwuP6Mmi+s6r4CHNk4xZhptlGIrPcTzcOSvKeTaruFyS83MMEenOytK8ejvOFNc6TOmSrvb+eS2ztB5l9XBbD89OptELpdLXsLqHkKeT6tOIg5CHFce41ES5mZH2+RLD4uZ5I5xiPupo8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pg=
table.h
> index aa89c2e67ebc..35bae2e4bcfe 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -130,12 +130,16 @@ static inline void arch_leave_lazy_mmu_mode(void)
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>
>  /*
> - * Outside of a few very special situations (e.g. hibernation), we alway=
s
> - * use broadcast TLB invalidation instructions, therefore a spurious pag=
e
> - * fault on one CPU which has been handled concurrently by another CPU
> - * does not need to perform additional invalidation.
> + * We use local TLB invalidation instruction when reusing page in
> + * write protection fault handler to avoid TLBI broadcast in the hot
> + * path.  This will cause spurious page faults if stall read-only TLB
> + * entries exist.
>   */
> -#define flush_tlb_fix_spurious_fault(vma, address, ptep) do { } while (0=
)
> +#define flush_tlb_fix_spurious_fault(vma, address, ptep)       \
> +       local_flush_tlb_page_nonotify(vma, address)
> +
> +#define flush_tlb_fix_spurious_fault_pmd(vma, address, pmdp)   \
> +       local_flush_tlb_page_nonotify(vma, address)
>
>  /*
>   * ZERO_PAGE is a global shared page that is always zero: used
> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/t=
lbflush.h
> index 18a5dc0c9a54..651b31fd18bb 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
> @@ -249,6 +249,18 @@ static inline unsigned long get_trans_granule(void)
>   *             cannot be easily determined, the value TLBI_TTL_UNKNOWN w=
ill
>   *             perform a non-hinted invalidation.
>   *
> + *     local_flush_tlb_page(vma, addr)
> + *             Local variant of flush_tlb_page().  Stale TLB entries may
> + *             remain in remote CPUs.
> + *
> + *     local_flush_tlb_page_nonotify(vma, addr)
> + *             Same as local_flush_tlb_page() except MMU notifier will n=
ot be
> + *             called.
> + *
> + *     local_flush_tlb_contpte_range(vma, start, end)
> + *             Invalidate the virtual-address range '[start, end)' mappe=
d with
> + *             contpte on local CPU for the user address space correspon=
ding
> + *             to 'vma->mm'.  Stale TLB entries may remain in remote CPU=
s.
>   *
>   *     Finally, take a look at asm/tlb.h to see how tlb_flush() is imple=
mented
>   *     on top of these routines, since that is our interface to the mmu_=
gather
> @@ -282,6 +294,33 @@ static inline void flush_tlb_mm(struct mm_struct *mm=
)
>         mmu_notifier_arch_invalidate_secondary_tlbs(mm, 0, -1UL);
>  }
>
> +static inline void __local_flush_tlb_page_nonotify_nosync(
> +       struct mm_struct *mm, unsigned long uaddr)
> +{
> +       unsigned long addr;
> +
> +       dsb(nshst);

We were issuing dsb(ishst) even for the nosync case, likely to ensure
PTE visibility across cores. However, since set_ptes already includes a
dsb(ishst) in __set_pte_complete(), does this mean we=E2=80=99re being over=
ly
cautious in __flush_tlb_page_nosync() in many cases?

static inline void __flush_tlb_page_nosync(struct mm_struct *mm,
                                           unsigned long uaddr)
{
        unsigned long addr;

        dsb(ishst);
        addr =3D __TLBI_VADDR(uaddr, ASID(mm));
        __tlbi(vale1is, addr);
        __tlbi_user(vale1is, addr);
        mmu_notifier_arch_invalidate_secondary_tlbs(mm, uaddr & PAGE_MASK,
                                                (uaddr & PAGE_MASK) +
PAGE_SIZE);
}

On the other hand, __ptep_set_access_flags() doesn=E2=80=99t seem to use
set_ptes(), so there=E2=80=99s no guarantee the updated PTEs are visible to=
 all
cores. If a remote CPU later encounters a page fault and performs a TLB
invalidation, will it still see a stable PTE?

> +       addr =3D __TLBI_VADDR(uaddr, ASID(mm));
> +       __tlbi(vale1, addr);
> +       __tlbi_user(vale1, addr);
> +}
> +
> +static inline void local_flush_tlb_page_nonotify(
> +       struct vm_area_struct *vma, unsigned long uaddr)
> +{
> +       __local_flush_tlb_page_nonotify_nosync(vma->vm_mm, uaddr);
> +       dsb(nsh);
> +}
> +
> +static inline void local_flush_tlb_page(struct vm_area_struct *vma,
> +                                       unsigned long uaddr)
> +{
> +       __local_flush_tlb_page_nonotify_nosync(vma->vm_mm, uaddr);
> +       mmu_notifier_arch_invalidate_secondary_tlbs(vma->vm_mm, uaddr & P=
AGE_MASK,
> +                                               (uaddr & PAGE_MASK) + PAG=
E_SIZE);
> +       dsb(nsh);
> +}
> +
>  static inline void __flush_tlb_page_nosync(struct mm_struct *mm,
>                                            unsigned long uaddr)
>  {
> @@ -472,6 +511,23 @@ static inline void __flush_tlb_range(struct vm_area_=
struct *vma,
>         dsb(ish);
>  }
>

We already have functions like
__flush_tlb_page_nosync() and __flush_tlb_range_nosync().
Is there a way to factor out or extract their common parts?

Is it because of the differences in barriers that this extraction of
common code isn=E2=80=99t feasible?

Thanks
Barry

