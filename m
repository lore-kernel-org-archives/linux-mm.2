Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F407CA5FFF
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 02:42:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D6536B0088; Tue,  6 Oct 2026 22:41:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 382506B008C; Tue,  6 Oct 2026 22:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 297FD6B0092; Tue,  6 Oct 2026 22:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0856C6B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 22:41:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 78487A0425
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 02:41:58 +0000 (UTC)
X-FDA: 85294280316.06.4914A55
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7ADF2C0004
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 02:41:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aw1QVinr;
	spf=pass (imf22.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791340916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0eVl9lZHm9sVTf50aIP8REHCgGFCjCWE1HzF4LMsxFY=;
	b=eDcWIPD5RKdl93W3pEw7H2FXzfWEBiE1Vth7AuyOU5a63I4iJfJ076abhGlhd9tWskoDhq
	CzTPeCkP6DV0nkEF1ZWURXfTbtkLEYyICyBwWw5Cvlm7u7h/+NajL2tg4zD17mX4Glsf/s
	4vkbrfalApTRORdWgo1p3G4mW7DA9XE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aw1QVinr;
	spf=pass (imf22.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791340916;
	b=uRnQtrJFTlQOAa0sjvjLRex9s1JjrmE0+Hjf2MzksJGwT2X5xdxPuEdKEsfPqCJSnTHLvf
	kQH8jrCz3VTqE7NSpVYI6PJEdtMCkWlbbxlCax9XkEJuX1QXcrEVUu4baFHANvLV+f5GwV
	ZUVc62zWY+Kl1mlrLjBOw3qJGpq//bQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 136BF152B;
	Tue,  6 Oct 2026 19:41:52 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C0AB63F86F;
	Tue,  6 Oct 2026 19:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791340915; bh=s760qSaiBVVuc/LlAknuKVghmlM0TMznspZHDm1DREY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aw1QVinr2aO2c2FZnGj7T7Kqjx9TOzGUooCiuw2agzb1q4f/FKMKf13h2fkYMtblQ
	 MBrdedFXgG4ie9YnrLy1Nkc8/1quegvgmIIJkrQ5/A/44y3he0uM8VSA20x9PXwziZ
	 PwAKmcDr6d3jYWiZhWfNFUOp2n0arCI2kMqgP0Ww=
Date: Wed, 7 Oct 2026 08:11:52 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kasan-dev@googlegroups.com
Subject: Re: [PATCH V3 1/4] arm64/mm: Use pmdp_get() for PMD accesses
Message-ID: <lqjq64vw6mlm27kp6ffms6auerj67avecc4ongedouumsrspjh@2f2eblm7wi4u>
References: <20260924062214.1635078-1-anshuman.khandual@arm.com>
 <20260924062214.1635078-2-anshuman.khandual@arm.com>
 <asPCv5Icdm7Z9mWF@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asPCv5Icdm7Z9mWF@arm.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7ADF2C0004
X-Rspam-User: 
X-Stat-Signature: pst4yiq354zf3h56u1bjb155ngrn5aj4
X-HE-Tag: 1791340916-128094
X-HE-Meta: U2FsdGVkX1/aGRUihKdS2Pp2WVamefZyPNgXjvpM44Uxbck8bVfZzm/Va1Zo7U3JAI0VopiuoKvWaa1ivUthCmM+3NfAJyOQdsJp19al5XSm9+wbE6N/HRwmfVsleuIc35DpoOVIp0a+1/qLGTALedWhP2Y+KIaeCsmh7foqbjmTvesGUC8WhoOHhxIvogD2Fhlu/QYc+8AMjSN13ArTz8agXlgvb2iA0dxMYlpHsfotoPLk2cnTVkLh7DiPftRjiZYqjsZhDuStAc3LWsWno2DMMKz/olutQ0f0mq34L01yKsHpMUPQxFOrRaKeD0qtBcJyDoXlsdCwtQ7F1PBP7AaX/CwvWe6Rtj0O9KrnP03oyHYaCyPxDrGjYq9tEO4lJNOhxLSOgW3P0mjrxEXTMFDFVu4eMFC/0XDDoRqclmiaxueUT8o2jL7AcCqlX/KMkX5o2Cfrc7IAamMbTSOzlIgrXlOItiTVh5TZjcMX2dyoKqip/Fg2Cu4vyuYVnPoHFTZ61K0TMtKoHbTsUMPWn0SrZ7MUqS5qtWfdF4/8JGlHi0c1Smqq2Cfk+SwZzDcbhikkf/oltyUYEURjHVHEpR/Uf5iF/855JwgV+WV/pdEk8tVDnaY+UIF4za6YfUmZPJ1aEhgnL7ylwMf94T4qDOp8t78QhNEJQ//AvYDJcQBslDRe1Vh8FdrLOSUhA4c/QGxQbiWjCnv/k45YjGrvSkK8bH+SxxNlV7LEoLgjY04IyXKaZCce4RgTm9UZ7EhkOVG6yMeLfUajuFo0xytlhqGaQUSH3DeYkdUpBZYk13X7mHGBrWFE17oWS56oqcrd8wZzMWiuKQHAVZqcb2BHkRNe03nSHImPcSzRNoK1eALTLezoUPEYsVi+Xlx5e9b5yWg8giCUi+AUfsHbxLmFXVNpr3dasMFmAt0nyXb2yirNEq7++CeQJLl+uI1RvP2OYO123jmYHje14f+f09S
 iqvHbi49
 ptAAM729oa3rzSjisVpmgdbYugVkWw1bqX9FYkqZsd+QCT8u0FXmNu2YURAH1ENf0A0Oi0F2e3UY82kJM4ejUij9w7BZx8ZBHoElVAZKptn9Om/vgymHxPOSiQtwXZz7GxaSg4yc+jRzNOS0kgzlUfxO0n0eovssLO9t/ZIcPZdXKp7G5m04fjdFjeE2DEHKodSe9EZa5ZlTsIZ0+d3BM3g76mxygEycOtgeWcXBWKNG21NzpFityWqbRJGji15qycfL5LZGCwlH7M7dkV6C25vfJbSXhOfFl/c5Y3/q5tm8GAbNMtwtvdpybLmR9/i5fX58ay0gT1aPFDWSq+MZO8a7LBb64VrF0pGsIlKPvopd1zhoPrXJm/OOZKlSY5Hz6EkobEjIW6i35oflkHNmcqjpyGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 05, 2026 at 04:31:28PM +0100, Catalin Marinas wrote:
> On Thu, Sep 24, 2026 at 11:52:11AM +0530, Anshuman Khandual wrote:
> > diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> > index 763c5a411d64..9ad2d03e86ad 100644
> > --- a/arch/arm64/include/asm/pgtable.h
> > +++ b/arch/arm64/include/asm/pgtable.h
> > @@ -84,6 +84,12 @@ static inline void arch_leave_lazy_mmu_mode(void)
> >  	arch_flush_lazy_mmu_mode();
> >  }
> >  
> > +#define pmdp_get pmdp_get
> > +static inline pmd_t pmdp_get(pmd_t *pmdp)
> > +{
> > +	return READ_ONCE(*pmdp);
> > +}
> 
> This is the same as the generic version. Does it need redefining?

Without this pmdp_get() override, replacing READ_ONCE() in pmdp_test_and_clear_young()
with pmdp_get() causes a build failure as pmpd_get() which is defined in the generic
pgtable header is not visible from inside platform specific pgtable header, even with
a forward declaration.

Earlier had moved pmdp_test_and_clear_young() inside arch/arm64/mm/mmu.c to avoid the
above described dependency problem. But then realised that pmdp_get() gets eventually
overridden on arm64 platform for D128, why not just redefine here it now as standard
READ_ONCE() to avoid the current build problem and the code movement.

Please find some context here from earlier discussions during V2.

https://lore.kernel.org/all/212067fe-1b16-4b87-87a7-4ce50847eb24@arm.com/

> 
> > +
> >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >  #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
> >  
> > @@ -811,7 +817,8 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
> >  }
> >  
> >  /* Find an entry in the third-level page table. */
> > -#define pte_offset_phys(dir,addr)	(pmd_page_paddr(READ_ONCE(*(dir))) + pte_index(addr) * sizeof(pte_t))
> > +#define pte_offset_phys(dir, addr)	(pmd_page_paddr(pmdp_get(dir)) + \
> > +					 pte_index(addr) * sizeof(pte_t))
> 
> Why not make this change in the generic version?

Could you please elaborate on this ? pte_offset_phys() is arm64 specific helper which
is also local to this header file. AFAICT there is no generic version for this helper.

> 
> -- 
> Catalin

