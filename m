Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CE09CA9ED0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 05:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A58E6B0088; Tue, 13 Oct 2026 01:12:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 656AF6B008A; Tue, 13 Oct 2026 01:12:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56BA36B008C; Tue, 13 Oct 2026 01:12:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E93C6B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 01:12:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2AA1040B01
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 05:12:14 +0000 (UTC)
X-FDA: 85316431788.17.A9F22E7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2FA3420006
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 05:12:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Gv3ipstp;
	spf=pass (imf13.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791868332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ixBrQ3Tz39hYV/OhNveeVgJyx6NRkGncCm+qWmedF4=;
	b=MklOBlnlM4mpGUJWur47MtWE7N2gFgZtTRq3xSY48ut4FuBUbzRWtx2bYqkTknd4VekRMm
	faIVnyeFt4vAC4rDHUgr3vpN56i7uWKkxEyfoAflu9as5B6sZHg4gG8FOvPs1FiV5L04RI
	IWV4Gl0sHYT0Z77Q2vSx1hBWrFDW924=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Gv3ipstp;
	spf=pass (imf13.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791868332;
	b=LtT42Cl6YOg9YF5W7aD37w0nesruSXz+pkjL9lwtjNFHILCUcfTm701PedVGFuipoG3oPS
	BJzFIsNP1NFlIva+Nr7zH8uHfWm3N/RPgDFwfUcwcgQev7lcG04lIO9WI+ChPG1dIEpY2g
	NX1Q1kcLYcT1kMTEqRfWkMIGYIAsXVM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DB22169C;
	Mon, 12 Oct 2026 22:12:07 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 245323F7B4;
	Mon, 12 Oct 2026 22:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791868330; bh=RLVpCA583elG6hUYQMlkousRsoX0X+NZ6XOSNvE/O4E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gv3ipstpbwQr3svLAPmYMebRUno9EQOqqkgpXH+OTYWKMfKbmMVwmlr9kzx2zu7V3
	 p6KWnKsUFUHbwwHopOAEoC3XlIVIjdcV0tEzOb7a/J/0+pNHjDK0dKk9jCnYyeNXQd
	 7wlK0u7oe0/2IaKwC7MHscVSAw9cnzCNPB8tMPJc=
Date: Tue, 13 Oct 2026 10:42:07 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kasan-dev@googlegroups.com
Subject: Re: [PATCH V3 1/4] arm64/mm: Use pmdp_get() for PMD accesses
Message-ID: <w6n3twi7dt35qzq7bwx5j7jx7plccrhbgyl5olcc4en7f4zd77@wzue6ripzv3c>
References: <20260924062214.1635078-1-anshuman.khandual@arm.com>
 <20260924062214.1635078-2-anshuman.khandual@arm.com>
 <asPCv5Icdm7Z9mWF@arm.com>
 <lqjq64vw6mlm27kp6ffms6auerj67avecc4ongedouumsrspjh@2f2eblm7wi4u>
 <asy-q5SBnrBQSadP@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asy-q5SBnrBQSadP@arm.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2FA3420006
X-Rspam-User: 
X-Stat-Signature: 6k8uz3p8gp347p8ixzcygif97auu3y88
X-HE-Tag: 1791868332-588289
X-HE-Meta: U2FsdGVkX1+KFhSVG7kYBPOiFwsZUTJcZLtSsFv/F7Mt5cUFrKFO4dOquidA8f5oCmezVl4T0vozDdEtIY26rb6R01zfZKU5Uf9MUOX9OKPX9Xyih4HP18XS1aWaeqCkCxz5ZIH0EjItz6kuVI3Sel37x/YOd4w0gibTU5pEdBaDZJHGMnYkTokCGSLfNKAzQUYzf30NzqG+n63dvCmtkLI+ok+ZL8bWjKAO8oXgZ0f0husodyTW0hqeGlFgKnAwiOdklOb/mF6bN/C51TMFSt3yguEAl0UbV/OmTChAU2ccdzg9n5pu5gnCMXrzj+DEuupujvWwwhGl/Uib6hmjbbvXJ7E/yil++1nI4ILLgzdKadT7/JMiQ9QNql9l7C6hwEM4pUZXzVAu50KXEGdH7mP5RE3BXb9JceS+WB5LUptUt2fcRrcDLDDBcM4BjBmdfyRbUevhLBsk1BumHaq1CtC0XoVwZLLFXD41PJT6eudFCEIf4unU6JZ42LbtgeIqWhCq+A2mTLlTz8bqiQaEbwWJUDyWO6HgkjaMxXahKP+zhcZO9ADA+gJkedLYzlPektGvDkXEQImQHSySdfm8TjJ35D+5ER5HWUDmolXmV5GFtLCYv7bgymKPPNzGOwBV2/wop1YM0s0BfLWMTtcWxnKTtFaYxaU+nCj/1iachqFF3y7WA6mLn/Qj6TNnYBDmTukHkcgtdWEGN03X13Q5r1NyBcntg9eW3I0J2BZEel2SCTQyY/uf0d/XZxp2u8ej3YS1Uw4IYcWlepiXcHQtTqd/XFZ8bc4OGxzd/C2JoYNaUn0DEhbbj+TPtCa77S+UaN8iBMebXBVQKfxsQcbmcrm3gByPGFknrCu0PJUn4lm4ogFzTrq3kqO3ZSpoFE4nvPZwwHtqzq5hsqDfoQjLOiD3Hhd/w7tiIhIsHlngUbHu41eE8s9WkhRCDRc+AARzclGs7A+OMSJBTbiNfgs
 gnbwhC1s
 i1t8yb8TlBDN6votpaAWAF2ZhYy3ESxuwJI0Pg4jtB6uQiv1SQVCgoBFc0bJ+znn+OON0qdFgIQY0egIq05Q/gYZl1KnJd7a7hN7wRLKnojaWqR+bM9N7vYMd2cYcAtQw79rECdk440CjDwzLGRBsPMvvc40Zq05sFG7AjbqAK1Ye5hD3XW8D/sCC/3JXh5efvXFJLj5Cg0zzCW9QxL4aj0CwyjieITaMo6MnmVBAYIq/zXv1ptnY2aE6NAqcA70QEUkr8oj2xV7tWYCj40ZfwPYHlCQE3H/iyCpbhAqecBRKtECNrJzDUjXE7oPJztR6HpJ0ZBSeoMJDAms1Id2M9g9flcT3zlbsNo8p48pelsMFzXA9qT8rbFLtSCOg/mGlwKMF3DJC8ecRdM/NMm41WL5uBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 12:04:11PM +0100, Catalin Marinas wrote:
> On Wed, Oct 07, 2026 at 08:11:52AM +0530, Anshuman Khandual wrote:
> > On Mon, Oct 05, 2026 at 04:31:28PM +0100, Catalin Marinas wrote:
> > > On Thu, Sep 24, 2026 at 11:52:11AM +0530, Anshuman Khandual wrote:
> > > > diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> > > > index 763c5a411d64..9ad2d03e86ad 100644
> > > > --- a/arch/arm64/include/asm/pgtable.h
> > > > +++ b/arch/arm64/include/asm/pgtable.h
> > > > @@ -84,6 +84,12 @@ static inline void arch_leave_lazy_mmu_mode(void)
> > > >  	arch_flush_lazy_mmu_mode();
> > > >  }
> > > >  
> > > > +#define pmdp_get pmdp_get
> > > > +static inline pmd_t pmdp_get(pmd_t *pmdp)
> > > > +{
> > > > +	return READ_ONCE(*pmdp);
> > > > +}
> > > 
> > > This is the same as the generic version. Does it need redefining?
> > 
> > Without this pmdp_get() override, replacing READ_ONCE() in pmdp_test_and_clear_young()
> > with pmdp_get() causes a build failure as pmpd_get() which is defined in the generic
> > pgtable header is not visible from inside platform specific pgtable header, even with
> > a forward declaration.
> > 
> > Earlier had moved pmdp_test_and_clear_young() inside arch/arm64/mm/mmu.c to avoid the
> > above described dependency problem. But then realised that pmdp_get() gets eventually
> > overridden on arm64 platform for D128, why not just redefine here it now as standard
> > READ_ONCE() to avoid the current build problem and the code movement.
> > 
> > Please find some context here from earlier discussions during V2.
> > 
> > https://lore.kernel.org/all/212067fe-1b16-4b87-87a7-4ce50847eb24@arm.com/
> 
> Thanks for link summary of the past discussion. I agree, for D128 we'll
> have to define our p*d_get() but I haven't decided D128 is worth merging
> yet (it depends on future hardware availability, I need to get more
> visibility into this).
> 
> For the time being, I'd keep the p*d_get() accessors generic and move
> pmdp_test_and_clear_young() to mmu.c.

OK.

Although there are similar cases involving [p4d|pud]_offset[_phys]() helpers
which would require code movement inside arch/arm64/mm/mmu.c file. Something
like the following. Will do all the necessary changes.

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index b9427e9d54dab..e03bb7017a57e 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2465,4 +2465,17 @@ pud_t *pud_offset(p4d_t *p4dp, unsigned long addr)
 }
 #endif /* CONFIG_PGTABLE_LEVELS > 3 */

+#if CONFIG_PGTABLE_LEVELS > 4
+phys_addr_t p4d_offset_phys(pgd_t *pgdp, unsigned long addr)
+{
+       VM_WARN_ON_ONCE(!pgtable_l5_enabled());
+
+       return pgd_page_paddr(pgdp_get(pgdp)) + p4d_index(addr) * sizeof(p4d_t);
+}
+
+p4d_t *p4d_offset(pgd_t *pgdp, unsigned long addr)
+{
+       return p4d_offset_lockless(pgdp, pgdp_get(pgdp), addr);
+}
+#endif /* CONFIG_PGTABLE_LEVELS > 4 */
 #endif

> 
> > > >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > > >  #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
> > > >  
> > > > @@ -811,7 +817,8 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
> > > >  }
> > > >  
> > > >  /* Find an entry in the third-level page table. */
> > > > -#define pte_offset_phys(dir,addr)	(pmd_page_paddr(READ_ONCE(*(dir))) + pte_index(addr) * sizeof(pte_t))
> > > > +#define pte_offset_phys(dir, addr)	(pmd_page_paddr(pmdp_get(dir)) + \
> > > > +					 pte_index(addr) * sizeof(pte_t))
> > > 
> > > Why not make this change in the generic version?
> > 
> > Could you please elaborate on this ? pte_offset_phys() is arm64 specific helper which
> > is also local to this header file. AFAICT there is no generic version for this helper.
> 
> You are right, I got confused.
> 
> Anyway, I'd push this series post -rc1. It depends on the mm tree and
> it's getting pretty close to the merging window.

Sure, no problem.

Will rebase this series post v7.4-rc1 and repost as V4 with all necessary changes
discussed earlier.

> 
> -- 
> Catalin

