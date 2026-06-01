Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19838CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 10:52:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B54A6B031E; Mon,  1 Jun 2026 06:52:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 789566B031F; Mon,  1 Jun 2026 06:52:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69FEA6B0320; Mon,  1 Jun 2026 06:52:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 55D806B031E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:52:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D9AB5161D75
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:52:33 +0000 (UTC)
X-FDA: 84831030186.05.089C6F8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 14784100003
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:52:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PXvzdFZr;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780311152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ddZ4Cxr/JHWef23HUq6enll8EtpPZioHbQeLyG5b3yM=;
	b=NPxOP2QUldGB8sjZGWyosMNwq0a6YwpjG5h3892cCMMBojdRTTABAwOumNa+Db+26xhDGu
	Gc7IXLwMNVJ1Ppn9MjwYV011CVJEifgkRQTVEoqbX2bVrSNG2GQ7XlAmLdc2EZyElhkO8b
	MnsxHjjUQ6ZuiXkRTp3uiRVqU6STNXc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PXvzdFZr;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780311152; a=rsa-sha256;
	cv=none;
	b=GiWRWA+3wZdCWKENXp4tTamRLvQzvcCvt/51jPjHiNyBWFDyrWN+d5XDyTsf+gIqUG+Iw4
	lryklJ9gXgkHRW9JAdQoMnoPNevyCUNEHFVvKpKaiBbtwYw/FpRqqMxQpKKp6ew3HSfmFz
	2FOdkKUJJ95pjfVL7V45C32t3x8aXRc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 36253176B;
	Mon,  1 Jun 2026 03:52:26 -0700 (PDT)
Received: from localhost (a079125.arm.com [10.164.21.37])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 37CCE3F905;
	Mon,  1 Jun 2026 03:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780311151; bh=UjrGkaDhseC03+f0B0Jhh2lPATfx6lpV4JnTinESzMo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PXvzdFZrnKS59D70C3+d7nG3vdUdOGRub0Xj/YxDb49qUPEhSNidUEZYOiKWOn6pm
	 czPqruORnbkzukaW834oroIc9Q3fUTmIwApu21iNdWe5UE7kLigPaupx8w7RWyZk5o
	 o/P4J/QDwR5LhDNtVXVItlJM4u78s/yZiZDOMtCw=
Date: Mon, 1 Jun 2026 16:22:26 +0530
From: Linu Cherian <linu.cherian@arm.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Usama Arif <usama.arif@linux.dev>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC V2 14/14] arm64/mm: Add initial support for FEAT_D128 page
 tables
Message-ID: <ah1kanXHdkcUUn5Y@a079125.arm.com>
References: <20260513044547.4128549-1-anshuman.khandual@arm.com>
 <20260513044547.4128549-15-anshuman.khandual@arm.com>
 <6330f618-c3e1-4e44-9b3c-6607bae1ae5e@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6330f618-c3e1-4e44-9b3c-6607bae1ae5e@arm.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 14784100003
X-Stat-Signature: 4fmpyts5adaugefhzmy5fbdrbrwyq3on
X-Rspam-User: 
X-HE-Tag: 1780311151-943632
X-HE-Meta: U2FsdGVkX1/G0NW6fvIPTOleNPL4UMOlZJ9aeFpG9hQQA2crh3eFFlbE3virHGxHtxoJLIYYXCtiXuzpD1GIXRdTSjIX2/n1X0bOl13SZm08hCxJ6iQXdAUM8aD9GDFM+m+1uo15Bu2vil0rO/2yx+tKHNPUrUcHzK8tF5zCJhiF/NxNE7IF5pJvxTRlFiqOT+wQ7kPtVG3YfaGFoqF0Y6HRAG0fHJtJ1xI/EA1tACtHlwPHEv1z45wYTEp9Fyw09/40xwjq9Yv/ue96QCUo2DvPqO9y0z2UIfa35D1CSJJo+S/rFt4xV0wetqXiN0KtFnfllV+xLF1mPpXmn1sRIfuKLhaQr5QStBSuTyw9LoW2rGcSQ5oBiYfbsRRGIXSoMe1q5F4yAmhaTNMytciiWyma082UOwxlPzlZEnJUYSQCm/qjCMMeS6T44YBUehNKgGQ+k8PpI0y/Qg7ZwzQgf95Lq1kqCuvBanIo7pHN0O9e0OjHq2xt0zOma/kLwbbcDsiHe5kAJe0PRu70jGKtRqOtez6jQGeCqAMscgX5rroVMYYWvl6GF1Fd2jDyJaEswnISBBjp5xhyJaF9B/Rpq9u81N1Nu1h4HxsQoT5n6CnBI0xv4X76WVDeE5meouLJ+MhwdgR0muHw/Y1N+ML2eqopezx7mLmow5oqtmgYP/Bejig07Fp1sfakldt+OK5xTqWsR9ePnfuEwKjvRHKnQ04mqRv6gwRNXnaMfCbI/r+uM2SpTFFDISc0+I4fA07tQbmRhjF3K8hgvwQCAwlFbUosClZNBF1bX+wDs18PHCz6b5mHHZCzSJDpnC8BfeIHZ23WnEMxlYI9ETJa1uj9w+DMgsZ8gGA5MBX0R/itXFUPGdnC+hvmSfgBXgRY8d/ypFGVLj7JtX2GEiMDybK3vkG3buZkQ8A7/hoGPRMu8fQv9Hj5A+d3doyipOX7sNpBJwdN8klIRMxVT8P6Alm
 NQHjwGEz
 xDC5fCZS+l/W/B++YYhm7kiZf3+PGz/Zi1vIOV61hVn80bJO6+mvA+sUVQFHpXwtvR6TCiF1zV9llo7/mbzATC224sZc/gJwSq2zxwPvIxlURsL3eqEK21QSyu6y7zviB1AXM/l6OsnMCyl2+XXAGX0DYgqQStVWR6lruKx0CeYeoAF957WBTGthvBqABtRxbLnomy0J1XVoPW2aFjBpyEi5bmukTa7T2W0CQGHxKnerhfUDOzYPdcldVrcT7ZvtI3A0l/bvCPpqRy8STrdlOElcAVdTvmM3sFAvZf3T/WFdUR6eIL3nIET7WgWK7RuZ2jHBB+mT1/z1QQDJotbycyNjjRqe6jQ71GV4LAG/zzvL4NeoPf2Gbp0reqkdwaz99VMziUIWCLX61Z6LKfsNtWtEXhNthmQKsjOXr9AXBxS68RC8muKJw1j77lzEe/W227bQioU2aNTrKBN7J2zLixXMSbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ryan,

On Wed, May 27, 2026 at 03:54:03PM +0100, Ryan Roberts wrote:
> On 13/05/2026 05:45, Anshuman Khandual wrote:
> > Add build time support for FEAT_D128 page tables with a new Kconfig option
> > i.e CONFIG_ARM64_D128. When selected, PTE types become 128 bits wide and
> > PTE bits are mapped to their new locations. Besides the basic page table
> > geometry is also updated since each table page now holds half the number
> > of entries (aka PTRS_PER_PXX) as it did previously.
> > 
> > Since FEAT_D128 exclusively supports the permission indirection style for
> > page table entry permission management, given kernel compiled for FEAT_D128
> > requires both FEAT_S1PIE and FEAT_D128. If these architecture features are
> > not present at boot, the kernel panics just like it does when there is a
> > granule size mismatch.
> > 
> > TTBR0/1_EL1 and PAR_EL1 registers become 128 bit wide when D128 is enabled,
> > thus requiring MSRR/MRRS instructions for their updates. Because PA_BITS is
> > still capped at 52 bits, MRS/MSR instructions are currently sufficient for
> > the register accesses that basically operate on the lower 64 bits. Although
> > entire 128 bits for these registers get cleared during boot via MSRR.
> > 
> > Add support for TLBIP instruction for TLB flush macros with level hint and
> > address range operations. Although existing TLBI based TLB flush would have
> > been sufficient given PA_BITS is still capped at 52, but then it would have
> > lacked both level hint and range support.
> > 
> > This enables support for all granule size, VA_BITS and PA_BITS combination.
> > 
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: Ryan Roberts <ryan.roberts@arm.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Linu Cherian <linu.cherian@arm.com> (TLBIP instructions)
> > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > ---
> > Changes in RFC V2:
> > 
> > - Updated ARM64_CONT_[PTE|PMD]_SHIFT both for 16K and 64K base pages
> > - Adopted TLBIP implementation to recent TLB flush changes
> > - Renamed __PRIpte as __PRIpxx per David
> > - Renamed all ptdesc_ instances as pxxval_ instead
> > 
> >  arch/arm64/Kconfig                     |  51 ++++++++-
> >  arch/arm64/Makefile                    |   4 +
> >  arch/arm64/include/asm/assembler.h     |   4 +-
> >  arch/arm64/include/asm/el2_setup.h     |   9 ++
> >  arch/arm64/include/asm/pgtable-hwdef.h | 137 +++++++++++++++++++++++++
> >  arch/arm64/include/asm/pgtable-prot.h  |  18 +++-
> >  arch/arm64/include/asm/pgtable-types.h |   9 ++
> >  arch/arm64/include/asm/pgtable.h       |  56 +++++++++-
> >  arch/arm64/include/asm/smp.h           |   1 +
> >  arch/arm64/include/asm/tlbflush.h      |  68 ++++++++++--
> >  arch/arm64/kernel/head.S               |  12 +++
> >  arch/arm64/mm/proc.S                   |  25 ++++-
> >  12 files changed, 374 insertions(+), 20 deletions(-)
> > 
> 
> [...]
> 
> Some comments on tlbflush.h only:
> 
> > diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> > index 361d74ef8016..7831759b98e1 100644
> > --- a/arch/arm64/include/asm/tlbflush.h
> > +++ b/arch/arm64/include/asm/tlbflush.h
> > @@ -41,6 +41,25 @@
> >  
> >  #define __tlbi(op, ...)		__TLBI_N(op, ##__VA_ARGS__, 1, 0)
> >  
> > +#ifdef CONFIG_ARM64_D128
> > +#define __tlbip(op, arg) do {		\
> > +	asm (ARM64_ASM_PREAMBLE		\
> > +	".arch_extension d128\n\t"	\
> > +	"tlbip " #op ", %0, %H0\n"	\
> > +	: : "r" (arg.full));		\
> > +} while (0)
> > +
> > +#define __tlbip_user(op, arg) do {		\
> > +	if (arm64_kernel_unmapped_at_el0()) {	\
> > +		arg.low |= USER_ASID_FLAG;	\
> > +		__tlbip(op, (arg));		\
> > +	}					\
> > +} while (0)
> > +
> > +#endif
> > +
> > +#define TLBI_ASID_MASK		GENMASK_ULL(63, 48)
> > +
> >  #define __tlbi_user(op, arg) do {						\
> >  	if (arm64_kernel_unmapped_at_el0())					\
> >  		__tlbi(op, (arg) | USER_ASID_FLAG);				\
> > @@ -162,9 +181,15 @@ static inline void sme_dvmsync_batch(struct arch_tlbflush_unmap_batch *batch)
> >  
> >  #define TLBI_TTL_UNKNOWN	INT_MAX
> >  
> > +#ifdef CONFIG_ARM64_D128
> > +typedef union __u128_halves tlbi_args_t;
> 
> I wonder if you could just define this as u128? That would make things a bit
> neater I think? - You should be able to do normal bit twiddling I think?

Having it as two 64 bit halves would make it easier to make use of
the bit field macros FIELD_XXX (which supports only the 64 bit)

> 
> > +#define __tlbi_wrapper(op, arg)		__tlbip(op, arg)
> > +#define __tlbi_user_wrapper(op, arg)	__tlbip_user(op, arg)
> > +#else
> >  typedef u64 tlbi_args_t;
> >  #define __tlbi_wrapper(op, arg)		__tlbi(op, arg)
> >  #define __tlbi_user_wrapper(op, arg)	__tlbi_user(op, arg)
> > +#endif
> >  
> >  typedef void (*tlbi_op)(tlbi_args_t arg);
> >  
> > @@ -211,17 +236,28 @@ static __always_inline void ipas2e1is(tlbi_args_t arg)
> >  	__tlbi_wrapper(ipas2e1is, arg);
> >  }
> >  
> > -static __always_inline void __tlbi_level_asid(tlbi_op op, u64 addr, u32 level,
> > -					      u16 asid)
> > +static __always_inline void __tlbi_update_level(u32 level, u64 *arg)
> >  {
> > -	u64 arg = __TLBI_VADDR(addr, asid);
> > -
> >  	if (alternative_has_cap_unlikely(ARM64_HAS_ARMv8_4_TTL) && level <= 3) {
> >  		u64 ttl = level | (get_trans_granule() << 2);
> >  
> > -		FIELD_MODIFY(TLBI_TTL_MASK, &arg, ttl);
> > +		FIELD_MODIFY(TLBI_TTL_MASK, arg, ttl);
> >  	}
> > +}
> > +
> > +static __always_inline void __tlbi_level_asid(tlbi_op op, u64 addr, u32 level, u16 asid)
> > +{
> > +#ifdef CONFIG_ARM64_D128
> > +	union __u128_halves arg;
> > +
> > +	arg.low = FIELD_PREP(TLBI_ASID_MASK, asid);
> > +	__tlbi_update_level(level, &arg.low);
> > +	arg.high = addr >> 12;
> > +#else
> > +	u64 arg = __TLBI_VADDR(addr, asid);
> >  
> > +	__tlbi_update_level(level, &arg);
> > +#endif
> >  	op(arg);
> >  }
> 
> It would be a neater change if you could get away with something like this. If
> you typedef tlbi_arg_t as u128, will FIELD_MODIFY() work? Not sure...

FIELD_MODIFY expects the arguments to be of 64 bit.
Atleast the bit shifting depends on ULL,
	#define __bf_shf(x) (__builtin_ffsll(x) - 1)
Guess, this might work for modification in the lower 64 bit
but not for the higher 64 bit.
IMHO, it doesnt looks okay to use it unless the FIELD_XXX
macros support 128 bit arguments with higher 64 bit field
modification. 

> 
> 
> static __always_inline void __tlbi_level_asid(tlbi_op op, u64 addr, u32 level,
> 					      u16 asid)
> {
> 	tlbi_arg_t arg;
> 
> #ifdef CONFIG_ARM64_D128
> 	arg = FIELD_PREP(TLBI_ASID_MASK, asid);

Essentially, here we have to make an assumption that FIELD_PREP
is always for the lower 64 bit, which is not evident from the code.
Would that be okay ? 

> 	arg |= (addr >> 12) << 64;
> #else
> 	arg = __TLBI_VADDR(addr, asid);
> #endif
> 
> 	if (alternative_has_cap_unlikely(ARM64_HAS_ARMv8_4_TTL) && level <= 3) {
> 		u64 ttl = level | (get_trans_granule() << 2);
> 
> 		FIELD_MODIFY(TLBI_TTL_MASK, &arg, ttl);



> 	}
> 
> 	op(arg);
> }
> 
> 
> >  
> > @@ -507,19 +543,33 @@ static __always_inline void ripas2e1is(tlbi_args_t arg)
> >  	__tlbi_wrapper(ripas2e1is, arg);
> >  }
> >  
> > -static __always_inline void __tlbi_range(tlbi_op op, u64 addr,
> > -					 u16 asid, int scale, int num,
> > -					 u32 level, bool lpa2)
> > +static __always_inline u64 __tlbi_range_args_encode_comm(u16 asid, int scale, int num, u32 level)
> >  {
> >  	u64 arg = 0;
> >  
> > -	arg |= FIELD_PREP(TLBIR_BADDR_MASK, addr >> (lpa2 ? 16 : PAGE_SHIFT));
> >  	arg |= FIELD_PREP(TLBIR_TTL_MASK, level > 3 ? 0 : level);
> >  	arg |= FIELD_PREP(TLBIR_NUM_MASK, num);
> >  	arg |= FIELD_PREP(TLBIR_SCALE_MASK, scale);
> >  	arg |= FIELD_PREP(TLBIR_TG_MASK, get_trans_granule());
> >  	arg |= FIELD_PREP(TLBIR_ASID_MASK, asid);
> >  
> > +	return arg;
> > +}
> > +
> > +static __always_inline void __tlbi_range(tlbi_op op, u64 addr,
> > +					 u16 asid, int scale, int num,
> > +					 u32 level, bool lpa2)
> > +{
> > +#ifdef CONFIG_ARM64_D128
> > +	union __u128_halves arg;
> > +
> > +	arg.low = __tlbi_range_args_encode_comm(asid, scale, num, level);
> > +	arg.high = addr >> 12;
> > +#else
> > +	u64 arg = __tlbi_range_args_encode_comm(asid, scale, num, level);
> > +
> > +	arg |= FIELD_PREP(TLBIR_BADDR_MASK, addr >> (lpa2 ? 16 : PAGE_SHIFT));
> > +#endif
> >  	op(arg);
> >  }
> 
> And you could do the same thing here, keeping a single function with only a
> minimal diff.

Similar to above, the concern here is whether to use 64 bit and 128 bit arguments
seamlessly with FIELD_PREP macros with the assumptions that the field
range being limited to 64 bit.


--
Thanks,
Linu Cherian.

