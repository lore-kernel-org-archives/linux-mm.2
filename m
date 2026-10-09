Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D888CA6015
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 02:24:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F2096B008A; Thu,  8 Oct 2026 22:24:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A31C6B0093; Thu,  8 Oct 2026 22:24:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B93D6B0095; Thu,  8 Oct 2026 22:24:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4425C6B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 22:24:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BD35716021C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 02:24:21 +0000 (UTC)
X-FDA: 85301493522.15.B5099E5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8F4DE180003
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 02:24:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cdimGt4B;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791512660;
	b=VejnDoMhpFMh/4yPWFEXl+jV3cyxneKbKOcY/rYDzRK6DfuLXR/5qKVpVAmmIGJqcMKmAg
	quEd7s6qnHLsaa3Tfyb/J66zdN7CotoehkEjsXp9MIa2WTswLmhOkokfAVEbWelohIA0vN
	wG3HSzHCQusvO1DIwMNjWk3NgJU7H7k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cdimGt4B;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791512660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hPjRWEqA4h+QELW2/pkZVWJ2BIEGTsNOGSrmLEnqrIY=;
	b=NevL9iTKSOwHnu0JLY+IZ0C+niF2jsIlcD0g9KzFW1zHtGyMydpbK/mKn6UT+Po8PS/q/Q
	GY/DqFvUveo5Ln+Mhm+oR2d6LsUg9YEGqlFPeLn7vGhsxB7wc0qMkFgRsNp3RECl/2p1HX
	xlnGhz32QuzbskTQFBITxkAGVchHIZ4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0010F1692;
	Thu,  8 Oct 2026 19:24:14 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 99E593F66F;
	Thu,  8 Oct 2026 19:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791512658; bh=2QLRKUYyFp8S6i+UXZO3Wxnz517D73K9DyPKeDJE9KQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cdimGt4BwBkbC2kvqJXbpnU8+qL/O0F0HZ2Z0H4CpSxUOxCh+EcoJtLXctAWoTzrV
	 OtcAfxF5iREGuxkwM6scrG4vYN4mDhOT5dXuCp6y3UYQNkA+QiuO7WX1/GccVSzj2V
	 OoaC3kiLUtydOmdP9bIBEODXTrrr6BODQU57YXnw=
Date: Fri, 9 Oct 2026 07:54:15 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Andreas Larsson <andreas@gaisler.com>
Cc: linux-mm@kvack.org, samuel.holland@sifive.com, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, linux-alpha@vger.kernel.org, linux-snps-arc@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-um@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 8/8] mm: Drop pxd_ERROR()
Message-ID: <y4zwpwqqxnjtwzm2j5xrdnnmdle5eiih7tsn7quywur7w2beh4@z3lk5ztxdz35>
References: <20260831054331.625505-1-anshuman.khandual@arm.com>
 <20260831054331.625505-9-anshuman.khandual@arm.com>
 <c24fc419-7bee-4fe4-be12-9aa378d49af1@gaisler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c24fc419-7bee-4fe4-be12-9aa378d49af1@gaisler.com>
X-Stat-Signature: iss7epqac9bo3d3qow5knf36dw1yipcm
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8F4DE180003
X-HE-Tag: 1791512659-883696
X-HE-Meta: U2FsdGVkX19/l23ys1MPjL/jNIKByTGyTXUMGEVPmox+bGnE9YZIRMfzzFA34YBISLKwDKqCs4l4xM4P7zpC4ZCe/ar9zFCxmpLUBfAzcN0u7qvTadZepzzlLKiIWy7v2H2CrZPJcdCMYqwYqIr/UiDkgU9Nlhh2Gg9r16LGvIiHkfdtT2NR1u/OW59FEEP51hYsRc0+HbmlwcuOtzx1zNb8f66PruuJwEfEwkZy8+hW5mp/7+k72MVI16hsTwEw4pBtr9MM60KC04ETCFSy7xFpt2kVwsz62bLMtJyOKOSForWAYJ4/2Y29Urls2onGXS9rlTJ/iYJXnOzGeR9OJF8c0ucsA222GE96Y6BgByk3aKx42QW5dgQCNzAucO/jl8/cYX3PwxVjj6KaN/yExWahLquOVhGIcB5FAdnsBGpST1pt+yRTGnrHiHu4gI1IFI0HWPcMMaaiIYAzGHGgGTloVWYQWYA+aCSIqDTgQBQeT9RaCEU1wLhzgBFzEjmJYfRyM3Ft7DqyYhsxDxLRsDDe7djT+KIOCJ1avmnj63EHnDD5MVag+rgjW9WWOrPzFuO4eGCCvR3ZO1AT6rSeNl1MfOoK3nHt/q0phiErUnr9vrtJ6PIBQYkpKqFH0G8s3v4QzzSW/b2zhiuKNnhdELwDc3BOIQM8svyN5COAk/7ttuHwLrS4VYRwTKg2Z5RFwGMHayZcY28SKPWlxySD4yL7mqHEC00XQp1Is9aTuXXDIy88mlmX6JslmCoazgLM0IVWVC5jucLdSFdCOHHOgie2QtsQWpm6FwRJ9uCm9f0SwjcG8V3AWwfnaLKItpdIiwv04XlsxArkj4EHUBI7UrnMQq3ejeiiaicCSZHWTAPhGih5HTeLauEoLO8s56hz5H0KOcOdHLIxaS/nWf8ghjnosUzTfhj3vgflRfs2xRdF9h297rMBexTvPq1vKysqiWP79aG9h/cIfBqJKjQ
 QekiGUWT
 t144/5cl/ysD66/HnFogasr8Ak8yjKxfhsFwvl9VkB35wj9Ta9lpzwnSz35rQ+4n146GbBnXw+NBSUHl1TdLdKFHHAIZK65FYt4QLlpT1Y2b0JV0ZMfbw/6hw/zxDLp2wgFfmERB7eC3DPqaWxhy5Z8pvma4aiX/ep/+xVUC6uy+aQAVJZ+nx8fVE28zqU+0F8HDF2FwQwKK6p6qH9Y3fAjURpFEo/TPMPZTu7CNBNXvn0Gm3cDi8+sRnIu2jo+gUJ9OywsL5ZsPIn8f9ufxLlfFE/krhO5klvzLmEUm8baQtRytmrTWZgIQXRKJzFRycmdCkbxHXfPFvm18XKv3LmFo4QFZnbO0BiSqQ3qxCwY0N+3mR6vSCLiip8ktExAOzhc5gEINNvoMGrOyDMpn6dNlmI1+7vN1v4yKQO1m56+bASFKqDg/CCvOyDBboKWObr5P0qHysiOZRYIDWNKhRhkvXgr/YH5iprkPdDwbh86lP52FxaJZvUnbmguWLfT3TGjiuTMRyBYvfchj3gz8UKhhVy+qCtOExitBrITH8d9fQWuJ5PsijZrySC93Zz1W3M2B5EnvoDNpnv9DRgnUSxCX81Sshmcr6p8/0qHzzhJgWcu5roQ5ccVdSSpda/t61963Fq6/wu9/qNNlMX77CdJ7GaPX2p6/7qy0oM0+7B1Skv5VCORhYTeg/GMOq8/WloTbJmFVkyKgk37/NMttminb699195z9rsXNhcUazkeSNYVc9BCpmwfOAqk4mmpT+uDuiQeSWl0nhgu4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 08, 2026 at 11:20:14AM +0200, Andreas Larsson wrote:
> On 2026-08-31 07:43, Anshuman Khandual wrote:
> > There are no more users left for any pxd_ERROR() either in generic MM or in
> > the platform MM. Hence all these platform macros along with their generic
> > fallback could be dropped across the tree.
> > 
> > Cc: linux-alpha@vger.kernel.org
> > Cc: linux-snps-arc@lists.infradead.org
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-csky@vger.kernel.org
> > Cc: linux-hexagon@vger.kernel.org
> > Cc: loongarch@lists.linux.dev
> > Cc: linux-m68k@lists.linux-m68k.org
> > Cc: linux-mips@vger.kernel.org
> > Cc: linux-openrisc@vger.kernel.org
> > Cc: linux-parisc@vger.kernel.org
> > Cc: linuxppc-dev@lists.ozlabs.org
> > Cc: linux-riscv@lists.infradead.org
> > Cc: linux-s390@vger.kernel.org
> > Cc: linux-sh@vger.kernel.org
> > Cc: sparclinux@vger.kernel.org
> > Cc: linux-um@lists.infradead.org
> > Cc: linux-arch@vger.kernel.org
> > Cc: linux-mm@kvack.org
> > Cc: linux-kernel@vger.kernel.org
> > Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ...>  /*
> >   * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
> >   * are !pte_none() && !pte_present().
> > diff --git a/arch/sparc/include/asm/pgtable_32.h b/arch/sparc/include/asm/pgtable_32.h
> > index f89b1250661d..5a5f54a090f5 100644
> > --- a/arch/sparc/include/asm/pgtable_32.h
> > +++ b/arch/sparc/include/asm/pgtable_32.h
> > @@ -40,9 +40,6 @@ void load_mmu(void);
> >  unsigned long calc_highpages(void);
> >  unsigned long __init bootmem_init(unsigned long *pages_avail);
> >  
> > -#define pte_ERROR(e)   __builtin_trap()
> > -#define pmd_ERROR(e)   __builtin_trap()
> > -#define pgd_ERROR(e)   __builtin_trap()
> >  
> >  #define PTRS_PER_PTE    	64
> >  #define PTRS_PER_PMD    	64
> > diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
> > index 0837ebbc5dce..44d1333065a6 100644
> > --- a/arch/sparc/include/asm/pgtable_64.h
> > +++ b/arch/sparc/include/asm/pgtable_64.h
> > @@ -96,16 +96,6 @@ bool kern_addr_valid(unsigned long addr);
> >  #define PTRS_PER_PUD	(1UL << PUD_BITS)
> >  #define PTRS_PER_PGD	(1UL << PGDIR_BITS)
> >  
> > -#define pmd_ERROR(e)							\
> > -	pr_err("%s:%d: bad pmd %p(%016lx) seen at (%pS)\n",		\
> > -	       __FILE__, __LINE__, &(e), pmd_val(e), __builtin_return_address(0))
> > -#define pud_ERROR(e)							\
> > -	pr_err("%s:%d: bad pud %p(%016lx) seen at (%pS)\n",		\
> > -	       __FILE__, __LINE__, &(e), pud_val(e), __builtin_return_address(0))
> > -#define pgd_ERROR(e)							\
> > -	pr_err("%s:%d: bad pgd %p(%016lx) seen at (%pS)\n",		\
> > -	       __FILE__, __LINE__, &(e), pgd_val(e), __builtin_return_address(0))
> > -
> >  #endif /* !(__ASSEMBLER__) */
> 
> Perhaps a bit of a pity to lose the printing of the address of the pxd
> that a number of architectures did before this series, but i have no
> strong opinion.
> 
> Acked-by: Andreas Larsson <andreas@gaisler.com> # sparc

Thanks Andreas.

