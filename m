Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F756CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 11:01:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC38A6B0007; Fri,  5 Sep 2025 07:01:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B73E08E0006; Fri,  5 Sep 2025 07:01:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A89EE6B000D; Fri,  5 Sep 2025 07:01:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8FA5D6B0007
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 07:01:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 396441A06AA
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:01:22 +0000 (UTC)
X-FDA: 83854905204.24.F8F096E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4808720045
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:01:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U7+DnpZ0;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757070065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jWjfStJ6xVgrWeWyv/waZRzeET/q2kIvfT9KYMUeqWo=;
	b=eAKptYEgNXWGEbfrxIqL/yxOpNZRrMVLeLEA5I8QmTBAVcR0MHim9s5pnByoV9ebGBHtQw
	qARiGF1N51MVENuSXMgwTR+vf3wyaB+bK3gZvqaS1pYu170m/ZFRN5I2FRiXD00JMoMD9x
	mEPObhqhsa45P+FUSAFtSJgztKK/lJY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757070065; a=rsa-sha256;
	cv=none;
	b=7M6rnuZ4KRZeS3Suyh1guuLo+Bsn8ezfKycXY5LNg2ldtl10aL1Q83YKPQA1Zas73GLOea
	PDRHfFjchsD6pLI48UXb7P71P9fcrdy41cR8LZ2hBCtgq5AdFMb9k5TvT+IKzYccE27ROx
	C0h2KEDwdy4GhTf/sgop+k2kKpTtCI8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U7+DnpZ0;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CACB4442A6;
	Fri,  5 Sep 2025 11:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2257C4CEF1;
	Fri,  5 Sep 2025 11:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757070063;
	bh=YZ1wTIYoB930tSA5MeqtdhO0LxdCLchTUQFtsum00QY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U7+DnpZ0s1JKbZszxSjLy0wzG4FuSPqezXeI+JVM+MWhXKMk7hbSMLMR/Ap70xViw
	 Grd6dhed7yIRR8Yu73fJN0N7pkSYFsDBBJo92L9gty0NMlP0j/ofYzR8Udwhhqz0oh
	 CUbTDNzSsrto9aiXPTcXZ/bGs5k+wjoB6qyCquH8g/JPTbP7OqDNsG+bte2OrVpi4n
	 zx6H4iTAqk8cmGshjWzK/jnlqFQq/hJysU/x9N1c9QnwDh2XIGq4oxaydCWq1cwWGV
	 2fRPyoqYacVZpZfy0SFEibM7KjqfNwOBpyIxsFAfubouuDw7Z5Ombt9MKgcN6WzQfQ
	 4CK8xb4S08BQg==
Date: Fri, 5 Sep 2025 14:00:50 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH 1/7] mm: remove arch_flush_lazy_mmu_mode()
Message-ID: <aLrC4reKPAz6YFn1@kernel.org>
References: <20250904125736.3918646-1-kevin.brodsky@arm.com>
 <20250904125736.3918646-2-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904125736.3918646-2-kevin.brodsky@arm.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4808720045
X-Stat-Signature: asimr3sr4gbzggkhsx38adrkoaktrprx
X-Rspam-User: 
X-HE-Tag: 1757070065-770749
X-HE-Meta: U2FsdGVkX191DQV5iYJ1YhxviudnlcEzWlyGYp7WVMbM1z8hBhd42G46J1d4q2uKdVlHl6XrzR5uALqyT988AF2k9datLIwb65M3X+R4INTtYfzYsXCsA4lsEMIz1VpkfWfyPOYwTkuYLNOTrv7zWtm7ti7vt7Y4UbE/w3E3vk9K/WUQ0lYfgjv3Q5r9H5YKvdii51Vm/rcurUYz1Cm/7zxqxPC30JMFthGtS57f4Ef1xYc41r7nIdMi0khR/MQSACj3ai281k21WwWIcPCXCdA3K0S5PhJhPYA9q3gdqIqplLVEg5+0fdb1LXMmorGLRPS/lHDccCUPFLq21CtlxZ9njn/cNO6CYnFK5A9YlDOgkEtTapevztYwe4IB5mNQrWL5yPBTSjNX9Jsau9l/dZpvmttuURRx2qw9BsJPwnvUjg5wGihqoF8qBFNU96gO0npYdSJKV9vhf9QI8OlZ1SCSDb337pxJYc/oO+y4OmE8dZ3Aaqqwp8/hRVChOYg+ciiJX6kz/jORyHtW+VIhooft4GL0juVLbJWygDU6BYu2I4RMcCIDQUV+0NnhmRY+rstXw3YstDpEaCymbGeXck1lEQdA2xIKTQJj9XXdCWXYx8LI3+I6K0UlEaR+mPXhjMXzj1uPsqreLYKc2ofQl9+hTD8uxAE5UTGsxTz3OsI1vC99vV1n40ztNMy6ElZziLsf9cKvFPZwgxoAbYThIEElgHobdE+fMGp43jtjUdYFwH41viAbkDdFsdngHhlA0DE9wjs2TqR/ws7HR57gIXQOSo7LBX+bGmi3fvepiwlJLKzz1AFvNdqncX58hhUgTdhaBFm5bISWNhT/J8S/ifwuz+4TlSmsNPJiRPzgXjRZjBeApzhb+8PH/DqkdY3OwcTqu8Tnt2LBqnXMZeXPaR+2NtpOdCXwlWHXldwLGBwqV7KbmLxlK/eqN5jmKiSTqjpknMd3MJBeSbtsNVB
 bdV7Jbdn
 jiaWnnmEgZl1Fp4DgNocLf63mCvvcGXgP/HEgOfSiQ1BtaxrhCM3USAzd2nZONivGVqtAv+6ZV8VuMUIe6AeeaU8mvsSunq4k9HGvMgUuMNbzTBXIo3vxO7jMKGE8+6/xb2WGy2BTzs0y0VGEWKxKB4zDpuLXbhN41Fykf9yZFyw3jR0/I4hb7/dI9BOtPWFUzLbVdeETiHAP1FnqjaOgSH9WCnDgaM597XMpwvkVmmqtPQSZtKyUvNeq76XNX0ScIIIKuSPRJW6B50jP+8QD72UmEFyFFOhzCQAgksQyQU4CwxustUK+TgPkz1P8WtzLEqPCF98AukzhkGAL7TMlOvekuXoMYeE4oBGjPpx9y3LXihh4vw0OW5Yf1AbYXd6JboTWokyayFGqLyAnEdk/5wYi816/gFYRvj5R1+7no1PVKZymwz2Wt5yF1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 01:57:30PM +0100, Kevin Brodsky wrote:
> This function has only ever been used in arch/x86, so there is no
> need for other architectures to implement it. Remove it from
> linux/pgtable.h and all architectures besides x86.
> 
> The arm64 implementation is not empty but it is only called from
> arch_leave_lazy_mmu_mode(), so we can simply fold it there.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  arch/arm64/include/asm/pgtable.h                   | 9 +--------
>  arch/powerpc/include/asm/book3s/64/tlbflush-hash.h | 2 --
>  arch/sparc/include/asm/tlbflush_64.h               | 1 -
>  arch/x86/include/asm/pgtable.h                     | 3 ++-
>  include/linux/pgtable.h                            | 1 -
>  5 files changed, 3 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index abd2dee416b3..728d7b6ed20a 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -101,21 +101,14 @@ static inline void arch_enter_lazy_mmu_mode(void)
>  	set_thread_flag(TIF_LAZY_MMU);
>  }
>  
> -static inline void arch_flush_lazy_mmu_mode(void)
> +static inline void arch_leave_lazy_mmu_mode(void)
>  {
>  	if (in_interrupt())
>  		return;
>  
>  	if (test_and_clear_thread_flag(TIF_LAZY_MMU_PENDING))
>  		emit_pte_barriers();
> -}
> -
> -static inline void arch_leave_lazy_mmu_mode(void)
> -{
> -	if (in_interrupt())
> -		return;
>  
> -	arch_flush_lazy_mmu_mode();
>  	clear_thread_flag(TIF_LAZY_MMU);
>  }
>  
> diff --git a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
> index 146287d9580f..176d7fd79eeb 100644
> --- a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
> +++ b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
> @@ -55,8 +55,6 @@ static inline void arch_leave_lazy_mmu_mode(void)
>  	preempt_enable();
>  }
>  
> -#define arch_flush_lazy_mmu_mode()      do {} while (0)
> -
>  extern void hash__tlbiel_all(unsigned int action);
>  
>  extern void flush_hash_page(unsigned long vpn, real_pte_t pte, int psize,
> diff --git a/arch/sparc/include/asm/tlbflush_64.h b/arch/sparc/include/asm/tlbflush_64.h
> index 8b8cdaa69272..cd144eb31bdd 100644
> --- a/arch/sparc/include/asm/tlbflush_64.h
> +++ b/arch/sparc/include/asm/tlbflush_64.h
> @@ -44,7 +44,6 @@ void flush_tlb_kernel_range(unsigned long start, unsigned long end);
>  void flush_tlb_pending(void);
>  void arch_enter_lazy_mmu_mode(void);
>  void arch_leave_lazy_mmu_mode(void);
> -#define arch_flush_lazy_mmu_mode()      do {} while (0)
>  
>  /* Local cpu only.  */
>  void __flush_tlb_all(void);
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index e33df3da6980..14fd672bc9b2 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -117,7 +117,8 @@ extern pmdval_t early_pmd_flags;
>  #define pte_val(x)	native_pte_val(x)
>  #define __pte(x)	native_make_pte(x)
>  
> -#define arch_end_context_switch(prev)	do {} while(0)
> +#define arch_end_context_switch(prev)	do {} while (0)
> +#define arch_flush_lazy_mmu_mode()	do {} while (0)
>  #endif	/* CONFIG_PARAVIRT_XXL */
>  
>  static inline pmd_t pmd_set_flags(pmd_t pmd, pmdval_t set)
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 4c035637eeb7..8848e132a6be 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -234,7 +234,6 @@ static inline int pmd_dirty(pmd_t pmd)
>  #ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
>  #define arch_enter_lazy_mmu_mode()	do {} while (0)
>  #define arch_leave_lazy_mmu_mode()	do {} while (0)
> -#define arch_flush_lazy_mmu_mode()	do {} while (0)
>  #endif
>  
>  #ifndef pte_batch_hint
> -- 
> 2.47.0
> 

-- 
Sincerely yours,
Mike.

