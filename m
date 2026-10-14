Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6BADCC6B27
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 08:47:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBB056B0088; Wed, 14 Oct 2026 04:47:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6C676B008A; Wed, 14 Oct 2026 04:47:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B343C6B008C; Wed, 14 Oct 2026 04:47:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 90CB96B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:47:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AC7A61A0482
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:47:11 +0000 (UTC)
X-FDA: 85320602262.06.F9D8595
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id ADFCF100005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:47:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k4jIF0Wo;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791967629;
	b=dThnC2xw7vaHSlop989m8T2DqCLGsGX1IVsFHMWvv7TW9vsDB3JqYRGMVVzNevPjhxvjUd
	xfNdv/jIeMMP4W5/tEBRC4nv2uVu+tzOitziKeWS2GW1CNlA9AGkm7LaOgoaMPmwkc0f1o
	+LEclqcaRKIYZ8+trJhAR2ZJZcL+enQ=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k4jIF0Wo;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791967629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0cYhJsFY6GItBPWieM4stDAK2l4sudXXbycAkGrr3pY=;
	b=Bff1ZR4TeXiLIMVsQMBp2tfKmzgHm1K933Nri6vpS5ya6R8cjTlo0dbbEdtSH7RJwLNiGx
	6ItR45vGB5SzgMWKDxuLH7FUXGuSaU9B8SIF1Fukqtf07AOmmmlEmA8USn7ihC607adhWw
	dn9LD1YpVewp6ofe48053u3pFIFbOOg=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a17baef589so6085315e9.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 01:47:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791967628; cv=none;
        d=google.com; s=arc-20260327;
        b=UQ4ANifgx0MBC22kUxxc03q5J36a3MMeIJ4oSDknA8e3Uc/0dRUFjUdlB+Udkfz46b
         NPwWIMChTwvihjvJln0W8hgM3Cc6BP3nnV/MbIkQ4l3Si7drxFhtJXVcvhIRJ5aV0MQN
         6zaLpockB3C/yMEA22+vWE03aeyk+FbeSZZG+tGcevakgbwoKOC3cQGZ3fe8OiMz0pfS
         0NLnHwK98asKq2SIgNX6pZievAaYW7hvY3ojveoGFjRJwlYxq4kty3778bFzXOAUFQSN
         niZQiMwDPmVTD8z0PFCxdTv12h7LvBHWk5Z/Ux1Ai3y2j8PZ8BRylVUIHXmbwQkjTIWM
         mZzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=0cYhJsFY6GItBPWieM4stDAK2l4sudXXbycAkGrr3pY=;
        fh=XGUyDoI1cuaBqRu0EMl6i1JGSNIibLQhoqMWXmynTqQ=;
        b=HUSXZMc1hy2rR2HGoe05F64nCcBNwUrWq2FiWV3tfMyalQF3WTJj9E4EQpq629Zhle
         iex5aM6G3BjNdCnGhEg3d6MeAjwX9b4uKh8ZKeO87TyipByE5CG6RMMmXq3LEwVPDPYi
         K7XbFS74w1wJlIBVq2LO3Q3St7tEpeU/VozIWy1tI0v/SeqhCqdHmYIxipGG+/OIMjUT
         nMXVuqckuY7r88rww5dajDvyXXtkzu6dVA1GA+AtaJDTrjfwP7JlMpzStBAfGAW3BGrI
         5CtQ9oAkkSwFyLuR7n4iPtbsOSuLRrD0v8CjBizyynitw6YGeMuSoZrt/E2+9ZiUdgEI
         RLBA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791967628; x=1792572428; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0cYhJsFY6GItBPWieM4stDAK2l4sudXXbycAkGrr3pY=;
        b=k4jIF0WoAR1BQnVQhCJW5Sg/Wr9uQs/ZBqWNuN8Nc4TbKeHUONpgZtjHtq/thcf9EE
         g7plCGMh2ohJNr/BZEqthnxhiR7Gegma4roaaIKyWNRTxqG1hRHkJgjMo8ur0akqDmWF
         RJllSllulZk2fTeDOmiRfCSzzDiG51O2dWLXDQoPTqfHW6JROjBhUJ6mi29bf/F5Nsq1
         RahBHy153Q34Ro+BXB6PoKS1UVGsmGpwdR1bIr6ebKsVAafqvCVr8026K57tBvgPExtd
         JQ7ElrJLdmdyvd+0GkpsW2OWxL81lTFM9zg+Wq+e++ymIs2mTOgTegGCS0zsaopBHZHi
         7CHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791967628; x=1792572428;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=0cYhJsFY6GItBPWieM4stDAK2l4sudXXbycAkGrr3pY=;
        b=piyaHj2S3/mRqHbg37nEubuCm6w+DXH3E43ZRlG5BL5Sdhaip0Y73HJLfeorEN1Suq
         sPCwuWenHazCdL/ZF3V7Y49rJfB+SDj3/D7PvpAq2b0dBwuYhLzeZMf9nsn+LHm/YCX8
         4dN74paxf8ayfuBOQP/5lsJAGmuhgxuhVNEOeLZEfiNSDT6U26jJkl3DONtyXU4O+ibd
         gIGlqBDEppVynm6nK7WGsqRG4YMqXmxbZCv7rDHrNbV6HJfu6gEIFs8PuRwjv+7lIZJ3
         DfpjWEy4TUSncSM02QAT3INBCoJDVEqH1iVz8PoJndHdNgPEmMlxI7I1f45dk40sTTpR
         l0Lw==
X-Forwarded-Encrypted: i=1; AKwUvBxQSpjk7aVSYCqOkqmm92JuM4OELbZX7hF7gYBp2gi5BWW6CFiVuCJqKi/Kfzme7BMmDn2JBh4xMQ==@kvack.org
X-Gm-Message-State: AFq9FYKkAMSzXGFmnRopsR/BTbQWBfIPVEDsnDTYffUb6YCnBlXEFier
	cWUDZjLigMDXqR2NL+lI8UKvtx2qnBTvemaJBPGe6DNN7up81pd2ZZRSu8iliAMLl6qeRnDr433
	ex8/vWJ4tBKeEK3Ns2QQFtQSRtl8CMX0=
X-Gm-Gg: AYBFou197zrVsr1k/whT+f8RT/OMRqQG8c74hio8gMZTdS21/4P0I17yLIR2Aen4o/B
	PUCalzbwZB0dINZoXao6H6cCojqqs+C9XKNHrQO+QXtcG4bkY4mHmPCmPbv9Vl7NlzIj5SAEEFW
	rlGcU29E4yVTR560bTAMaeoy1Ospd4b/i0J3E3kx9AMVY9UOFAuiPKxKKFZiLzwIG7ZqfWtumqM
	dRz9ViZ8H5LdpiItlyGAXQyjoqooWfLvhI4XW5M0GyOUJHruX5DIb2i1NmusrtOADVfSH8k1GhI
	/Kpljag3gQjrjoifgtx4GkYE0k22NqJ0SPQQxEZXaFUjupj+Abaq4RcKtA==
X-Received: by 2002:a05:600c:83c4:b0:4a1:7367:5395 with SMTP id
 5b1f17b1804b1-4a18e446f4amr296569785e9.2.1791967627867; Wed, 14 Oct 2026
 01:47:07 -0700 (PDT)
MIME-Version: 1.0
References: <20261002090947.869220-1-jiangwen6@xiaomi.com> <20261002090947.869220-2-jiangwen6@xiaomi.com>
 <7b3c3a39-4cf3-430d-9fd3-ba83e5175e72@arm.com>
In-Reply-To: <7b3c3a39-4cf3-430d-9fd3-ba83e5175e72@arm.com>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Wed, 14 Oct 2026 16:46:55 +0800
X-Gm-Features: AclHuK-bFuc3dEYGYwD4zSgb8fq4NoGf2OiM-E1K3hrsnLGY-8dDIYkDzN8S8fw
Message-ID: <CAHKocdFOoDhjcuWXJatQ-AbSXyXuV+Q=sA1-iGiGrp7vhHZMBQ@mail.gmail.com>
Subject: Re: [PATCH v10 01/10] arm64/mm: add pte_set_huge() and pte_clear_huge()
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org, 
	urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com, 
	ajd@linux.ibm.com, anshuman.khandual@arm.com, baohua@kernel.org, 
	chleroy@kernel.org, david@kernel.org, jiangwen6@xiaomi.com, leo.yan@arm.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, mpe@ellerman.id.au, 
	npiggin@gmail.com, rppt@kernel.org, ryan.roberts@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: hssdadz4orihz1xbayteqip1xan469uy
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ADFCF100005
X-HE-Tag: 1791967629-50763
X-HE-Meta: U2FsdGVkX18GTC6S+aeCy0trp14+KqHQ48W2DQTu9GOY8Ew7WhzVWx+7uT5i3+1x9038EUcTYDFCHi0AC4MhsSq7XJrVZ64vbEYSHPx74C6gQyYlQ0Ixup0fiX5rHv/Xnxher7eINqAOUKG7+3j7nsjaiCns/1YJmP/4WopVedd+jedxlrN+KgjCEkuOFa75mfEJQQvegogu3eEUyEdauYNWy4T2soiGAPybR/WHVAZCmxGe57nRUNdzY3ObZjSXL6O4BxGOERYLNgP+bxdnqWlogRGOq7U8UqrPgVEzZBb21vO2uAmsIfVr51cK91GDLc9zu99dwnZgiapIOkyVzZv+GGSXx9YTruH6f/SXsn+BkLL2cLtJ//cuJU2WydBKUTTBXlCfqtpkJahb7ZuTWAztt1lGG6bpD7wTQFZ7VQT1no/P8Zfk557f/Dq9CwLJUKcm55Tj3XQPEt/Hi/zG2AkUYdd6pFZUWLXRbmzTzJSvfTk7nfFDgOChv5Fw1g5jbp4QKA6LTVkysvUCyTBdwl+K2tJMdupOXs0vExas+pMTG54n7xJNdTue4Hstp5MIZb6CbR3tzquDqf09t49tkT4Rax+R2PTy6uGGFzVvOt4c0VbzDerkeKOHgC+a9COneVkxHehi2Aw53UJ38g3guE62HvTOf6sRRxN5t186ByHyesTL9y9fx1/xSNV7jWhtfbGFpM+/kS/hYQbHoYbTSakF+nnioYzc4NH9YPnsxn9lCFxndh7keWHcMFbS/HvMrCr/kEpwqinFf0NBy1mkGUjc/srahg0Qt+R8vsK5e0EthDQ61LNS6ANiWWpyKxWx2r5venAg3PcIX/9qOp/NcUus/jC4WfG3BtSBZ3u6O9DkdMU4Y2OZdNoQiWlp1ls0ACor0CjiVERiB2ZSBnjOBlkFn7Lteve+ZutcY7UbAniYPNUlhCTD3V4JKh6L4f63gFChGJSzIRqHVvdHF2s
 v9h8vCOO
 Cut5PjnN0zWA6PF0UlvU4EGpDTvuFSXhhbqLaz3HcYIY5+dnQI4YAYAhQxONi1SuqLJoZhLmnJkhjhZSgkkxZE+xnG8ncbsn7iEkFci73L4J8YX5q1YhoKxVjvOdCaH2znYKpjSvRlIbh8naOrT3ZzlPiF9DzU6KgNvV+jxW+UqpwZ4WEJNOMVmyGhOAC56wogcbAg/wD3Jvpoo1T3gylO29bERt/dpgH2FDiVPWMt//n6sVaNIJl3BOPLjfXqkk9L8Qj8L09uci+2GB4hEpoPpc5vk8TZJWH+5twd0HfwLfO5StKUbLmzZuyKM/Bhz8EMQR7P/f+NgyqKZHFBotuaDe5C1y1vmY6Vy7RYQKS4sJ4g4pYf3n+hoICZocLfMNOH2jG81BTgye6vLF+lOxYevlktTTE5y12JRE8rPWcMJbMIf72io9Rk9BI4iaCqvJgv5pgTV+WhLugkte9pR6o0ixCsOk2Mnb2+/Mn76dzt/LzvKi4W4hxsa6zBGpDBUvtKj2PMWa1gvjhQ4SsYcrk77kIMU7gCeN+3dFrglcrYuwiH8UQjfnrA8kOWkOkYSBx8OvB/6OdEhZEZPQRMLifBjLlZHSN5tcHCdMYJ6QhsccYOhcPDDI4+y68ZYGycm+kUUnZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Oct 2026 at 14:03, Dev Jain <dev.jain@arm.com> wrote:
>
>
>
> On 02/10/26 2:39 pm, Wen Jiang wrote:
> > vmap installs PTE-level block mappings (PTE_CONT on arm64) by reusing
> > set_huge_pte_at() and huge_ptep_get_and_clear(), which are HugeTLB
> > helpers gated by CONFIG_HUGETLB_PAGE. This makes the feature silently
> > unavailable on CONFIG_HUGETLB_PAGE=n kernels and couples mm/vmalloc.c to
> > HugeTLB internals it does not otherwise need.
> >
> > Add pte_set_huge()/pte_clear_huge() to arm64, joining the existing
> > pmd_set_huge()/pud_set_huge() family in mm/mmu.c. They build on
> > __set_ptes() and __get_and_clear_full_ptes() directly, so they do not
> > depend on CONFIG_HUGETLB_PAGE.
> >
> > There is no caller yet: mm/vmalloc.c is converted later in this series,
> > once the generic fallbacks are in place.
> >
> > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> > Reviewed-by: Barry Song <baohua@kernel.org>
> > ---
> >  arch/arm64/include/asm/pgtable.h |  6 ++++++
> >  arch/arm64/mm/mmu.c              | 23 +++++++++++++++++++++++
> >  2 files changed, 29 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> > index 6000905a2e865..9b762eb68cff0 100644
> > --- a/arch/arm64/include/asm/pgtable.h
> > +++ b/arch/arm64/include/asm/pgtable.h
> > @@ -1978,6 +1978,12 @@ static inline void clear_young_dirty_ptes(struct vm_area_struct *vma,
> >
> >  #endif /* CONFIG_ARM64_CONTPTE */
> >
> > +#define __HAVE_ARCH_PTE_SET_HUGE
> > +void pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
> > +               pgprot_t prot, unsigned long size);
> > +#define __HAVE_ARCH_PTE_CLEAR_HUGE
> > +pte_t pte_clear_huge(pte_t *ptep, unsigned long addr, unsigned long size);
> > +
> >  #endif /* !__ASSEMBLER__ */
> >
> >  #endif /* __ASM_PGTABLE_H */
> > diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> > index 79d90226fd5dc..ae2f15618c97d 100644
> > --- a/arch/arm64/mm/mmu.c
> > +++ b/arch/arm64/mm/mmu.c
> > @@ -1912,6 +1912,29 @@ int pmd_clear_huge(pmd_t *pmdp)
> >       return 1;
> >  }
> >
> > +void pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
> > +               pgprot_t prot, unsigned long size)
> > +{
> > +     unsigned long pfn = __phys_to_pfn(phys);
> > +     pte_t pte = pte_mkcont(pfn_pte(pfn, prot));
> > +     unsigned int nr = size >> PAGE_SHIFT;
> > +
> > +     VM_WARN_ON(!IS_ALIGNED(size, CONT_PTE_SIZE));
> > +     VM_WARN_ON(!IS_ALIGNED(addr, CONT_PTE_SIZE));
> > +     VM_WARN_ON(!IS_ALIGNED(pfn, CONT_PTES));
> > +
> > +     /* For vmap, there is no valid -> valid transition */
> > +     VM_WARN_ON(pte_valid(__ptep_get(ptep)));
> > +
> > +     __set_ptes(&init_mm, addr, ptep, pte, nr);
> > +}
> > +
> > +pte_t pte_clear_huge(pte_t *ptep, unsigned long addr, unsigned long size)
> > +{
> > +     return __get_and_clear_full_ptes(&init_mm, addr, ptep,
> > +                                      size >> PAGE_SHIFT, 0);
> > +}
>
> I think we should have the same VM_WARN_ON() checks here, as for
> pte_clear_huge(), in addition to also warning for
> current->mm != &init_mm.
>
> We should make it clear that pte_clear_huge() gets called only for
> kernel mappings, and the range we operate on is definitely an aligned
> CONT range - which is why we do not go through get_and_clear_full_ptes ->
> contpte_get_and_clear_full_ptes, and possibly contpte_try_unfold(), but
> directly use __get_and_clear_full_ptes.
>

Hi Dev,

I'll add the alignment VM_WARN_ON() checks to pte_clear_huge() to
match pte_set_huge().

Regarding the current->mm != &init_mm check: these functions don't take
an mm parameter -- &init_mm is hardcoded in the function body.
current->mm would never equal &init_mm in practice: for user processes it
points to the process's own mm, and for kernel threads it is NULL.
So VM_WARN_ON(current->mm != &init_mm) would always fire.

The existing hugetlb helpers that vmalloc used before this decoupling
(huge_ptep_get_and_clear -> get_clear_contig) also take mm as a
parameter
and don't check current->mm either -- the caller simply passes &init_mm.

How about adding a comment to make the "kernel mapping only" intent
more explicit?
Something like:

 pte_t pte_clear_huge(pte_t *ptep, unsigned long addr, unsigned long size)
 {
+       /* Kernel mappings only */
+
+       VM_WARN_ON(!IS_ALIGNED(size, CONT_PTE_SIZE));
+       VM_WARN_ON(!IS_ALIGNED(addr, CONT_PTE_SIZE));
+
        return __get_and_clear_full_ptes(&init_mm, addr, ptep,
                                         size >> PAGE_SHIFT, 0);
 }

Thanks,
Wen

