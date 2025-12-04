Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20EEAD1D862
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 04:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 770F46B0008; Wed,  3 Dec 2025 23:34:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 748396B000A; Wed,  3 Dec 2025 23:34:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 685976B000E; Wed,  3 Dec 2025 23:34:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 568386B0008
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 23:34:22 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 623CC8ACC8
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 04:34:19 +0000 (UTC)
X-FDA: 84180521838.17.7842DAF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 984311C000D
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 04:34:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764822857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b2Ag9VGHjtd8hN53cp9DjV4/7coNBMtZPqugNMBysgw=;
	b=megr7SevY91rGBPpB0fKk/eE6XZRJYxFIb95XqsjGV67+KCVaMUJixtFFiS196FGBBEQvD
	oWgk/L8QZFpYqnOQpQqokcTKFfR1KOJRtpwVDEwgLaAQtAq9UfNSgR1V3VRZxW/KjcifUE
	H42NQ3kffQkQAYjLWXotBP8V+Tm5hBs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764822857; a=rsa-sha256;
	cv=none;
	b=tsAWi4aqv53NW+rvz+aS9aQcSBmu1P9yRD8AOLd7T7fn/yBPY8d0PKIAWbNKyQMb7+CxJf
	dCBSFBHnTDZ4d5By8HCefv36a3RT4t9Kb7ICZS0sj5N8TN2pqIhma/6PN8h3BOqpWHRmPf
	ibvM2uiALH7KnJuaX6vREY5zCen9bAc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 64906339;
	Wed,  3 Dec 2025 20:34:09 -0800 (PST)
Received: from [10.164.18.78] (unknown [10.164.18.78])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E05AF3F73B;
	Wed,  3 Dec 2025 20:34:06 -0800 (PST)
Message-ID: <565ac89c-1e7a-4e2f-a866-15039fbe22f6@arm.com>
Date: Thu, 4 Dec 2025 10:04:04 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/12] mm: bail out of lazy_mmu_mode_* in interrupt
 context
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, David Woodhouse <dwmw2@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
 <20251124132228.622678-8-kevin.brodsky@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20251124132228.622678-8-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 984311C000D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 5wodb4ozkzdmqb43iah6u5imjuypfkz7
X-HE-Tag: 1764822857-307669
X-HE-Meta: U2FsdGVkX19xjyRukcwu+AqzqYu8pS77UvC+V3/HxQ/qwz0zENb027vQiKd4NChK/QiQqGawPeZx0Rl+Zq8Pyj8cC7zUcLhJh6EzKbl2m1MjLX29obGVHH8d8zWyHr7KVyuLcIiZgqb0LoV2+bnKnfJUZNvSy8RUQIsXBA1Nd7bSPu01AEVTlNeYyAY3PrV3noqJCyD24FVRy1YO9ExZu0YQGm25WrjtijgYGkA6UX5UP8t6PUOQe6tCrit6tn3hyxyDn5IFaMALvuJ1vaRZ+S8izco1cnNhmsRs0CE8UMOJjkqzDV9SyQprL7zTy7Zhyw/MVlCIWefKA5qfiXYjjBE+iftlbQ2hgcMH+ABvsSMyWcegEvVeAOAbafFBxzlVirl/ggZSRDQ0BnroVytgSWCyM5/FoFiyaN4FRToW79m2dLWNm13F6fdOGNaMVZaFQdmg3IfyTVrBIhtpy2pjPxcyiTOCsW7F0g5cyNXBkvOPBKslJqieihMyB1plWxW+Yj5EbrJ92M6Xb1WSnokM9UjNwziXnK2dL0gWXAx8HuzYr5WcCt/ZteWVwwTuoE6fpe2gA3ZDKoFz4E/b95gekROFnLrdtIwTXpfPSAX6/tx9bZx4oIECgvSjdhXRC1e/7Lhtkv41lzGRwckOw3/kT/2gaUhiHH+2VUsdAr3VH+da8ArW7NvPG22gPu79f0S32yRgWAqs13m1G9MoR0SUgcZI4mDQHeWyAuR5U7KQDh5rLxhtpkjPINELYjiW8c15v0qXiKKELZfwq+ck3uZO1YcIfx11w4HZt/f3gJbK1r4Lur+wk5CsWHvkB7j2LxB7gAxpBdt8LMP5jEElm7S2uIE7xZYDb8vFrnfLSe8tS3jqpPx7kTlTLoua70LcGPCQcestFzoA4jEJ0c7shkzJ/qlRtIEjZXdXN/BLuG6QJWaKi5v5mnvspZET2743krGVHzfNOMF+JZ6bJuHFaDt
 5QE3mZbN
 BTVJNFXuqpsUmPHPIW8Lj3/H2LydoDm1RPBGl5dvJstiNtSpcD3yzadFwxAwCBojGVuFeDo5zccekh/38khN6MpXmSpfS+UU7jN/SbKMEH1elT43GukMEvyPRzEQ676slhOOJUqklazRdpLwSljsxN8FfeKCbPbO+KIMpGOV0b9ARkRQokJQZXEj/P0dszRI15r7l0gk3WazE0A+7dX4gtG+ls1ptBrZpbPWuq4o+F7ZQYdx6nGSErjG/5Bg00G7p98Vp/wzVkrsyjVNr9EQQpXhRTJrwJ4afaPzYUM1fo8XKY30HA4D3Fy/pQsesi1yqhMJwPzvJ8tfo7ltRpvl9HAYPSnNwFcawma5q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24/11/25 6:52 PM, Kevin Brodsky wrote:
> The lazy MMU mode cannot be used in interrupt context. This is
> documented in <linux/pgtable.h>, but isn't consistently handled
> across architectures.
> 
> arm64 ensures that calls to lazy_mmu_mode_* have no effect in
> interrupt context, because such calls do occur in certain
> configurations - see commit b81c688426a9 ("arm64/mm: Disable barrier
> batching in interrupt contexts"). Other architectures do not check
> this situation, most likely because it hasn't occurred so far.
> 
> Let's handle this in the new generic lazy_mmu layer, in the same
> fashion as arm64: bail out of lazy_mmu_mode_* if in_interrupt().
> Also remove the arm64 handling that is now redundant.

Ensuring a common behaviour across platforms such as this in interrupt
context bail out - can now be easily achieved now as there are generic
helpers that call the platform ones.

> > Both arm64 and x86/Xen also ensure that any lazy MMU optimisation is
> disabled while in interrupt (see queue_pte_barriers() and
> xen_get_lazy_mode() respectively). This will be handled in the
> generic layer in a subsequent patch.

Makes sense.

> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  arch/arm64/include/asm/pgtable.h |  9 ---------
>  include/linux/pgtable.h          | 17 +++++++++++++++--
>  2 files changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 54f8d6bb6f22..e596899f4029 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -94,26 +94,17 @@ static inline void arch_enter_lazy_mmu_mode(void)
>  	 * keeps tracking simple.
>  	 */
>  
> -	if (in_interrupt())
> -		return;
> -
>  	set_thread_flag(TIF_LAZY_MMU);
>  }
>  
>  static inline void arch_flush_lazy_mmu_mode(void)
>  {
> -	if (in_interrupt())
> -		return;
> -
>  	if (test_and_clear_thread_flag(TIF_LAZY_MMU_PENDING))
>  		emit_pte_barriers();
>  }
>  
>  static inline void arch_leave_lazy_mmu_mode(void)
>  {
> -	if (in_interrupt())
> -		return;
> -
>  	arch_flush_lazy_mmu_mode();
>  	clear_thread_flag(TIF_LAZY_MMU);
>  }
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index c121358dba15..8ff6fdb4b13d 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -228,27 +228,40 @@ static inline int pmd_dirty(pmd_t pmd)
>   * of the lazy mode. So the implementation must assume preemption may be enabled
>   * and cpu migration is possible; it must take steps to be robust against this.
>   * (In practice, for user PTE updates, the appropriate page table lock(s) are
> - * held, but for kernel PTE updates, no lock is held). Nesting is not permitted
> - * and the mode cannot be used in interrupt context.
> + * held, but for kernel PTE updates, no lock is held). The mode is disabled in
> + * interrupt context and calls to the lazy_mmu API have no effect.
> + * Nesting is not permitted.

Right - nesting is still not not permitted.

>   */>  #ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
>  static inline void lazy_mmu_mode_enable(void)
>  {
> +	if (in_interrupt())
> +		return;
> +
>  	arch_enter_lazy_mmu_mode();
>  }
>  
>  static inline void lazy_mmu_mode_disable(void)
>  {
> +	if (in_interrupt())
> +		return;
> +
>  	arch_leave_lazy_mmu_mode();
>  }
>  
>  static inline void lazy_mmu_mode_pause(void)
>  {
> +	if (in_interrupt())
> +		return;
> +
>  	arch_leave_lazy_mmu_mode();
>  }
>  
>  static inline void lazy_mmu_mode_resume(void)
>  {
> +	if (in_interrupt())
> +		return;
> +
>  	arch_enter_lazy_mmu_mode();
>  }
>  #else

LGTM

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

