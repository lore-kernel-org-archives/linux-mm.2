Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F10AC4453C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 20:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 685716B00A3; Wed, 22 Jul 2026 16:18:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60F5D6B00A4; Wed, 22 Jul 2026 16:18:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B1E76B00A6; Wed, 22 Jul 2026 16:18:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E0BD6B00A3
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:18:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7DC82802DF
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:18:49 +0000 (UTC)
X-FDA: 85017525978.03.4827F6C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 62CB61C000C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:18:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aiMgIq3l;
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784751527;
	b=C7lCGWb3iYPtAQphDhjiBFpKn/vGa+nkgbcX56jL8Gb+vabfjy7w6zUPBM6JBGWGjcDpM1
	SAK1tdMg2396OzdzBcRAI6iX2ODAOgf271Ljh9pEle3XKxTOpXbYA7r7dRW7iLrz8HDo+R
	bPeRMO5i/zN/cRhE5mN1Eyw2u9Dc7Pk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aiMgIq3l;
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784751527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Yj2QHINfstPVmZJ83T3JrPK/jTLJiiFABqDfKNFz4Q=;
	b=OxZlplvuAQufnDw94X844F0ZqigFkqZ/sKB1hBvkaTxEC2JtgsYiLUnymqC+zDufLHn04C
	kobovVxFJSzrGrbAgelcyPFFrWGoc6lK64LZ71tctOwh5lLtCctV3gDTOGsJpNjSlzlf0T
	DMpL+hA8ynimBBJNKzsEF4ZytlKAc20=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED3061595;
	Wed, 22 Jul 2026 13:18:41 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 066363F59E;
	Wed, 22 Jul 2026 13:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784751526; bh=ov7c+9CWDC2LAyEksO+C2pB8mXtkAOCi10JJO6wa1g4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aiMgIq3lU/qztGdY5ckcEtoH4sGXiubpcTNstTvwu98UOWWePxdJNyZ59CI4DTUgx
	 yDvv0SQFD+xDj41NppNkZJE85iCi+rKzLxJK7D5KIdXE5wBFK4aLMoc9apSCP5Bf3x
	 lWhfLdLFiXooDHH9+ISqgCgK1LUPPRLrHnct3Y6Q=
Date: Wed, 22 Jul 2026 21:18:36 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Russell King <linux@armlinux.org.uk>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonas Bonn <jonas@southpole.se>,
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
	Stafford Horne <shorne@gmail.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-openrisc@vger.kernel.org
Subject: Re: [PATCH RFC v2 14/20] x86: mm: skip pud setup when using generic
 compile-time folded pagetable
Message-ID: <amElnEbvRTjv2hyU@e129823.arm.com>
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
 <20260722-dummy_ptxp3-v2-14-d9e4bad31e0a@arm.com>
 <0ea931f1-4801-4d32-b6ce-4787a8d3daa9@intel.com>
 <amD7ab_KuJPdBQBh@e129823.arm.com>
 <6f5060a7-0a64-49fc-81a3-ae88729ef794@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f5060a7-0a64-49fc-81a3-ae88729ef794@intel.com>
X-Stat-Signature: z4pefy5md89ixyyzipytmfsu3op9p6dy
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 62CB61C000C
X-Rspam-User: 
X-HE-Tag: 1784751527-965687
X-HE-Meta: U2FsdGVkX1+n+BXh56enJOu+lkFSlaeAv5XyHold6g4Eof3oCtiXj1bLqdUOK48L2F3utBzItloe3/0ASdIZrazAgfFUbbDEZFN6zf+g/y2dGRPqmCEv3TUF2Tjt3QXj+Ud4y2t6agGFYIEY7GAI6+FYMwna8eIDrBM6Ral3VxdeMoBsJrirZtWKLygqr74CX5tq1YWUd5N/EXt3lp7/7fTBBCMJh5X9BDBnNy0SXqvyPBnz03Xg62DvrkQrKuxNtyzbPq+UAMYlAS8xeEMTeMMP3qSRSMNC5+Ptb5LkgRA52ayFD+2kVq9C1jNB0Lv+oijAUXyyXMu59vfVnmr9J/4H7pKIrswLB7Z9nM+D1EiDTXx78ablZXGkOramLOqiu3RGKtX/Fq8mXbyLa58PGTAONfQLhKAImEzqTxWHaThsfbZ9ksAIxNEZp+XKwkgeDqwSHnTH7WfS18N922OXIAMY39Z4C4RO0R3TloPWVkT/f0g9CSIvE3Gz8mSTEZEDOTxt+OGkC94F+8SAafgcGBFL19DwyX+J68hBixA2xuPY6ollAQKCFRVbX/Bw3ASMukBADeM0kR8k0lLptcODrhhnnXGE+bAWCsrVuMBR5fEuY2QOIxRvC9dfYj5YTh03tlvMAJMtJmHwHbqYFduD8FF4nICJugqkay08FXZs1fWSr+ThInpxBkFT2ggAyl6/j9txMXc1TFK9S2JEFbccx8u2f9J3ZU7AzUVyM4jnH7XpTxL8GenCdSS4gnOqRPPt8EgVyHxdjcVG85w5KAJMkUSZDs52E+43h+aLza46kEeDtJyIUf5H1EF3aFwNnH/t2/fzmap9LVsHw+/5irz0QBm1lCviNcYjsC9TLZ+J/Yp1jGCYN9fz8NbVPgRMNnyz9TQKHIq1Q5ya4xZqwfdvaoXR/oNf4XHwHGnWVZPam2EyoZ2ElgO/U/2AA3sRZsnrS/tJrrKCDIB2XAt8UHs
 Hy6nXGQe
 kBnmCoaW8f2fCYKR3HlyViEyccaO9105g+PFD2FHV7ODb98qS5iz1wnTjadUoE57bVS5PyL0fD2eZ4GPp8W9zCLGNwMiCycqgW9cdkaGtPeaTNoeG68bq6ALJRup23XeoEzRDxRE1nPOnCDbW23OZ0hg3K3J2ouKGTIsWZOop3EexL3WVXpUpMIw5wK+Wn/lnzDEemXvqt/QgMlw2qbZdPguSCHcFz7ZOWkm8iQZmWhCGmq8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On 7/22/26 10:18, Yeoreum Yun wrote:
> >>> @@ -1730,7 +1730,8 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, p4d_t *p4d,
> >>>  	/*
> >>>  	 * Map everything starting from the Gb boundary, possibly with 1G pages
> >>>  	 */
> >>> -	while (boot_cpu_has(X86_FEATURE_GBPAGES) && end - start >= PUD_SIZE) {
> >>> +	while (CONFIG_PGTABLE_LEVELS > 3 && boot_cpu_has(X86_FEATURE_GBPAGES) &&
> >>> +	       end - start >= PUD_SIZE) {
> >>>  		set_pud(pud, pud_mkhuge(pfn_pud(cpa->pfn,
> >>>  				   canon_pgprot(pud_pgprot))));
> >> This is an OK approach. But there's a way to fix this site *and*
> >> optimize a non-zero amount of other code at the same time. Add this hunk
> >> to arch/x86/Kconfig.cpufeatures:
> >>
> >> config X86_DISABLED_FEATURE_GBPAGES
> >>         def_bool y
> >>         depends on X86_32
> >>
> >> That will turn the boot_cpu_has() check in to something that can be
> >> resolved at compile time. It has the added advantage of compiling out
> >> all of the code under X86_FEATURE_GBPAGES everywhere else in the tree.
> > Does it? when I glimpse check, this wouldn't be compiled since
> > there is no bit for X86_DISABLED_FEATURE_GBPAGES and defining the
> > DISABLED bit for FEATURE_GBPAGES seems odd since bit X86_FEATURE_GBPAGES
> > is already defined.
> 
> x86 is a special snowflake here and all the similarly-named things glued
> together with magic makes them hard to grok.
> 
> Our X86_FEATURE_* bits normally compile down to a bit in a bitmap in
> memory. But, there are also some optimizations in the helpers that
> access those bits. The optimizations turn bit checks like:
> 
> 	if (bitmap[N] & bit)
> 		...
> 
> into a compile-time check:
> 
> 	if (__builtin_constant_p(bit) && DISABLED_MASK_BIT_SET(bit) ? 0:
> 	    (bitmap[N] & bit))
> 		...
> 
> The DISABLED_MASK_BIT_SET() macro magic check if (for instance)
> X86_DISABLED_FEATURE_GBPAGES is around. Some processing of the Kconfig
> variables produces a header with X86_DISABLED_FEATURE_GBPAGES defined.

Sorry. But do you mean check with cpu_feature_enabled() not with
boot_cpu_has()?
IIRC, the boot_cpu_has() doesn't use the DISABLE_MASK_BIT_SET() but
uses REQUIRED_MASK_BIT_SET() and I don't expect it wouldn't make
an optimisation to constant check which is contrast to DISABLE_MASK_BIT_SET().

> > Instead of CONFIG_PGTABLE_LEVEL > 3, as above, would it be better to
> > add check IS_ENABLED(CONFIG_X86_DIRECT_GBPAGES)?
> 
> That would definitely change the behavior. It honestly might be the
> _right_ change, but I'm ignoring that for the moment because even if it
> is best it is fodder for another patch, not this one.
> 
> Please just keep the check against X86_FEATURE_GBPAGES for now.

Okay. In round, we can remove CONFIG_PGTABLE_LEVEL check too since
it wouldn't make a compile error right now.

-- 
Sincerely,
Yeoreum Yun

