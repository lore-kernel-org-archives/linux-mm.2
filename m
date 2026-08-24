Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86D25C5DF97
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 02:10:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C75B6B0095; Sun, 23 Aug 2026 22:10:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 078436B009B; Sun, 23 Aug 2026 22:10:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECF966B009D; Sun, 23 Aug 2026 22:10:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF7466B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 22:10:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4E3E8A041B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 02:10:08 +0000 (UTC)
X-FDA: 85134532896.17.D54989C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 492D0140002
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 02:10:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=a4JUlAZ+;
	spf=pass (imf23.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787537406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AfPStIpgfPQ828sbkc2DizowrhJEfyzKkm1fDCnlU2Y=;
	b=4MJ5QOTPl/wSu+7RirF+GWFpMVwSMzPsrctR8jKWjVp+JZtyXP2qD4K8yFDAhYobyW64lj
	h+5vCqh0zhCZXwF53OSELmpk3jGcXVqAbzNQHPuQtAdmpS1+JoN6mFQl87D6e8E6zfjZCv
	fx6PigM45/XfYbrpaE5miBB3ZsdVh4w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787537406;
	b=Sfp+9QReRjElF1gbiM9I/pLHRL/x4+8+N8pNwacE8Zt+AiC9NWf1AKACOSTQOmJaik/FYf
	8tWrTjmHJpShB6EzJ+XP//9mUWxkG3IIB73E5Hs7sNlkdtILv3FmOHceKN8/JvawnLaogW
	jJ4lQ1TMOBndEAcFD4JSsfiEITtFHAw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=a4JUlAZ+;
	spf=pass (imf23.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 42EDD16F2;
	Sun, 23 Aug 2026 19:10:01 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5E7523F85F;
	Sun, 23 Aug 2026 19:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787537405; bh=eOGK0wvkltA8yYZNmhWeTsiSVqPQxkng2Itm3Z60Z6Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a4JUlAZ+vGxifClv9CUQ6YhHZnMJIW47duH2wh57oz+0yuijrZVwRAh9yAD5nNS16
	 aHbgrzFWqMVd9B/mBLWI7ialac2s/E3e5i2TALgA9ogkPmX6xn+19TlregiL4AYNJl
	 eDLwVjZMZgsmICpyyUT+/RWvzafQ0urjffAc3AKw=
Date: Mon, 24 Aug 2026 07:40:01 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] mm: Drop pxd_ERROR()
Message-ID: <on4gs65rttqkuw2zomuswauqrzal33wel7cmeep4yw3hpodyqd@zkrqwu4sxmnz>
References: <20260806080639.1916749-1-anshuman.khandual@arm.com>
 <aoqYS9eFTPqtgFMn@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoqYS9eFTPqtgFMn@kernel.org>
X-Rspam-User: 
X-Stat-Signature: yizcn4k9tk3hnjqiysk8rx6p7bfhmwp6
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 492D0140002
X-HE-Tag: 1787537406-9043
X-HE-Meta: U2FsdGVkX1/UT1jKRLexUtBFqvXDf5+gwpie58kqLd7hLhlG00m9slmaxVOZsO+OXZExwM+3nFqc4TMDCLM+lGAF9NiAqpwpGe5WP40jZDTq0VPx6y4yKYvupr6yvt+o0bfND39hfF1+zjdVHui1aTg3uWu2tmTFDnjBzwXyZ12ZaaJOos58s9gJiX/E8IuA1MMtT1zC7HqMvmymZT/RD/ysu7MpIfN38g/OPKyzEZgaQJGAB2EA5sCtHC1r65x2A54nsRQ5ag5HOFUicNTl8JLweWVdJzB3YVyD80frtMeHWiXtM3eoN4uwBiBoNmTt0tKN0vgl55hlfCCqsFgvSLAtEfFdqlarVGeQC89F3g9HcTc6rCo4jIr4FsJ0mVn5QDrXn1I8HW5mcws2UhwtozKH2uT4EQkB39sEXQ2phIgPIGjtS6JfeHYRPT9GDije9OZhzyK4h2RaOuMMK33VL8W+gBX+oU5inPRXmH20eyHfqxv0nD1x1QvRISaj3ZLbl3VBvXApmA90OUzN4TzYJT76Dog+bUUjwE2j7sXvl5DvV/AgrgR5CrkjuXcaUhmMW1AVWMPyWGWwzOJRm1ywTJ7ivhlse6Tl6MbTnMtZ6c429e+gGPgJ8MRP9VYsxh/Meu6tNjUdP6ay5O/PKDjQWJvevl3fFDxSHYb9oe/pTNHYXMiavbND664W/nWiG/lolWe/zKmzq2io0wk0b+HvXcWxXZhzZiB6scOL6n2ywI6W67lb0VGU067FLckucO+bVkFCNU6BhZ/BAp8PHa6OYI0Li+b/g0Y7edzuNdpdZ7oIJAMtIdQiKA4S2/iHxvZrqT63aKxJGp23lw9pw17YKnkukPLqLpwbawIJ5H9UkXx9WupuNlCFSxSzVdLoIj5lyCSnAhEBiNMCYwcrUxXOavk01p9pmTYgXgGZPrT8EJupEa3BvZ3ji5JvwuzDu0iSzbqxJ4cYR/aib4hLbjn
 CE7yd1LA
 05+T0CoG+NsPR9pgr/FKKYkH50zlqPUhlpz9PLqR/xy2fHpUlRZtvrsjvRqJq0Ui90260Z9gXA0ti47lFO9qTK5LQjj2cBNXJZIFYY+sssmmW/qfEfPRekwGtfO1t8vfL3g/jyXROAuNRCri8qvH7QepEUudyObm+PgihMuWmxucJLZbQam8eCTryU55d+juGN+KRU06M84IRCBBl1jBdYPJaEbqKE6mZX2to01QC78ItYm6fRK7Y0tm7XlcEALKHDJLuaXRtThPOrJTrSAb340MSXKJYEmsNa1hlUPPOkvkpUbY3Ssyk3RNVRR+PwQeha44kHQOB3oogwkL3S9tXV6E7Tj/DycP8N1BwEBqoDGkkaTEY3ExoufgvAZUdRu0FIE7SubEYDgydXk65eFLGh0G3E7wxPbLwe6g0GaBjNDaUmKLxe9eiR4nnRDMoEyuzJqd/Xb2JGfTPJ+IDK1MqPw0uUCcwZ/tF3dSTVHe6o6UxupNT2fS0xZ/zKKxSox+uKH/wWF3wRLA6j04=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 23, 2026 at 09:50:51AM +0300, Mike Rapoport wrote:
> On Thu, Aug 06, 2026 at 01:36:39PM +0530, Anshuman Khandual wrote:
> > pxd_ERROR() has been used in generic mm just to print the page table entry
> > in pxd_clear_bad() before clearing those out with pxd_clear() later. These
> > pxd_ERROR() macros have been provided by all platforms which basically did
> > the same thing.
> > 
> > Make pxd_clear_bad() use recently added ptval_to_str() instead for printing
> > page table entries thus completely dropping dependency on platform provided
> > pxd_ERROR() macros which can then be dropped off. First move all required
> > helpers in core MM into a header file which could then be used else where.
> > 
> > Although some platforms still use those macros internally as well. In which
> > case just move these macros inside the platform for now.
> > 
> > Cc: David Hildenbrand (Arm) <david@kernel.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org> 
> > Cc: linux-arch@vger.kernel.org
> > Cc: linux-mm@kvack.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > ---
> > This applies on v7.2-rc6 but after the following patch
> > 
> > https://lore.kernel.org/all/20260709044334.1741263-1-anshuman.khandual@arm.com/
> > 
> > Would it also make sense to just drop __FILE__ and __LINE__ from the output
> > in pxd_clear_bad() helpers as they always print the same details regardless
> > the error path and does not add much value.
> 
> Maybe replace them with the caller address?

Hi Mike,

Thanks for your review but the latest series can be found here.

https://lore.kernel.org/all/20260818040041.1891769-1-anshuman.khandual@arm.com/

- Anshuman

>  
> > Build tested for various architectures.
> > 
> >  arch/alpha/include/asm/pgtable.h              |  7 ----
> >  arch/arc/include/asm/pgtable-levels.h         | 11 -----
> >  arch/arm/include/asm/pgtable.h                |  7 ----
> >  arch/arm/kernel/traps.c                       | 17 --------
> >  arch/arm64/include/asm/pgtable.h              | 15 -------
> >  arch/csky/include/asm/pgtable.h               |  4 --
> >  arch/hexagon/include/asm/pgtable.h            |  3 --
> >  arch/loongarch/include/asm/pgtable.h          | 10 -----
> >  arch/m68k/include/asm/mcf_pgtable.h           |  6 ---
> >  arch/m68k/include/asm/motorola_pgtable.h      |  8 ----
> >  arch/m68k/include/asm/sun3_pgtable.h          |  7 ----
> >  arch/microblaze/include/asm/pgtable.h         |  7 ----
> >  arch/mips/include/asm/pgtable-32.h            | 10 -----
> >  arch/mips/include/asm/pgtable-64.h            | 13 ------
> >  arch/nios2/include/asm/pgtable.h              |  7 ----
> >  arch/openrisc/include/asm/pgtable.h           |  7 ----
> >  arch/parisc/include/asm/pgtable.h             |  3 +-
> >  arch/powerpc/include/asm/book3s/32/pgtable.h  |  2 -
> >  arch/powerpc/include/asm/book3s/64/pgtable.h  |  7 ----
> >  arch/powerpc/include/asm/nohash/32/pgtable.h  |  2 -
> >  .../include/asm/nohash/64/pgtable-4k.h        |  3 --
> >  arch/powerpc/include/asm/nohash/64/pgtable.h  |  5 ---
> >  arch/riscv/include/asm/pgtable-64.h           |  9 ----
> >  arch/riscv/include/asm/pgtable.h              |  4 --
> >  arch/s390/include/asm/pgtable.h               | 11 -----
> >  arch/sh/include/asm/pgtable-3level.h          |  6 +++
> >  arch/sparc/include/asm/pgtable_32.h           |  3 --
> >  arch/sparc/include/asm/pgtable_64.h           | 10 -----
> >  arch/um/include/asm/pgtable-2level.h          |  7 ----
> >  arch/um/include/asm/pgtable-4level.h          | 13 ------
> >  arch/x86/include/asm/pgtable-2level.h         |  5 ---
> >  arch/x86/include/asm/pgtable-3level.h         | 11 -----
> >  arch/x86/include/asm/pgtable_64.h             | 18 --------
> >  arch/xtensa/include/asm/pgtable.h             |  4 --
> >  include/asm-generic/pgtable-nop4d.h           |  1 -
> >  include/asm-generic/pgtable-nopmd.h           |  1 -
> >  include/asm-generic/pgtable-nopud.h           |  1 -
> >  include/linux/mm_types.h                      | 40 ++++++++++++++++++
> >  mm/memory.c                                   | 41 +------------------
> >  mm/pgtable-generic.c                          | 21 ++++++++--
> >  40 files changed, 65 insertions(+), 302 deletions(-)
> 
> This is nice :)
>  
> > diff --git a/arch/parisc/include/asm/pgtable.h b/arch/parisc/include/asm/pgtable.h
> > index 467b8547ac8b..cca30bf11b4c 100644
> > --- a/arch/parisc/include/asm/pgtable.h
> > +++ b/arch/parisc/include/asm/pgtable.h
> > @@ -75,12 +75,11 @@ extern void __update_cache(pte_t pte);
> >  
> >  #endif /* !__ASSEMBLER__ */
> >  
> > -#define pte_ERROR(e) \
> > -	printk("%s:%d: bad pte %08lx.\n", __FILE__, __LINE__, pte_val(e))
> >  #if CONFIG_PGTABLE_LEVELS == 3
> >  #define pmd_ERROR(e) \
> >  	printk("%s:%d: bad pmd %08lx.\n", __FILE__, __LINE__, (unsigned long)pmd_val(e))
> >  #endif
> > +
> 
> Stray whitespace change?
> 
> >  #define pgd_ERROR(e) \
> >  	printk("%s:%d: bad pgd %08lx.\n", __FILE__, __LINE__, (unsigned long)pgd_val(e))
> >  
> > diff --git a/arch/sh/include/asm/pgtable-3level.h b/arch/sh/include/asm/pgtable-3level.h
> > index d1ce73f3bd85..3cfbec15de2f 100644
> > --- a/arch/sh/include/asm/pgtable-3level.h
> > +++ b/arch/sh/include/asm/pgtable-3level.h
> > @@ -28,6 +28,12 @@
> >  #define pmd_ERROR(e) \
> >  	printk("%s:%d: bad pmd %016llx.\n", __FILE__, __LINE__, pmd_val(e))
> >  
> > +#define pud_ERROR(e) \
> > +	printk("%s:%d: bad pud %016llx.\n", __FILE__, __LINE__, pud_val(e))
> > +
> > +#define p4d_ERROR(e) \
> > +	printk("%s:%d: bad p4d %016llx.\n", __FILE__, __LINE__, p4d_val(e))
> > +
> 
> I'd expect that all arch changes would only remove code. Why sh needs
> those?
> 
> >  typedef union {
> >  	struct {
> >  		unsigned long pmd_low;
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index b18c2b2e7d2c..1025b9140c0b 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -2001,4 +2001,44 @@ static inline unsigned long mmf_init_legacy_flags(unsigned long flags)
> >  	return flags & MMF_INIT_LEGACY_MASK;
> >  }
> >  
> > +static inline void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)
> 
> include/linux/pgtable.h seems more natural home for this
> 
> > +{
> > +	if (WARN_ON_ONCE(buf_size < entry_size * 2 + 1)) {
> > +		snprintf(buf, buf_size, "overflow");
> > +		return;
> > +	}
> 
> -- 
> Sincerely yours,
> Mike.

