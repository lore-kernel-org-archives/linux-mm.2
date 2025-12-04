Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1554D1D870
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 06:52:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32C8C6B0011; Thu,  4 Dec 2025 01:52:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DCC96B0012; Thu,  4 Dec 2025 01:52:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F2896B0023; Thu,  4 Dec 2025 01:52:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0BCA76B0011
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 01:52:32 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C9A6C08C5
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 06:52:29 +0000 (UTC)
X-FDA: 84180870018.17.E5A05F1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 534A710000A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 06:52:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764831147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RqFa2b+K3fcKtemSHIfEKXbku0CciHAsPdEHPf8F7c8=;
	b=sU7AlkJSV/iYW3aSn7mdLDInmL+DBU8nkhBRfsOua3SkliGh9P6VZnEAvcAaiQfAvECVXH
	OdycqhbkO8XpzjRQRN5LbRQpw7QA+shdJ/adCEWGnUguOKM1ksiBi9mf5Lsnz1cql6Bd6V
	y1SzXZxk0NNicCOXPEtccqNv8aKn0p0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764831147; a=rsa-sha256;
	cv=none;
	b=Szaonhb4xkPtqKYue07ZDrN7vIit4Yja8q/CxmpG4o5Tlo0eqLeejxCvyCnWcfwCmnma1g
	bk4QisTQ8SkzyTAe4/G5DsGPYkrlpNpOHgX0vZvT3P4Z5jWYuMSDZwZlC+lPEkId5/hhGz
	dvJlQGwh5gBA/zXSjOVSs0cIHfyWYLg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AEABB339;
	Wed,  3 Dec 2025 22:52:18 -0800 (PST)
Received: from [10.164.18.78] (unknown [10.164.18.78])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3C0333F59E;
	Wed,  3 Dec 2025 22:52:16 -0800 (PST)
Message-ID: <89ecddb7-83ee-427b-823b-984204939ecf@arm.com>
Date: Thu, 4 Dec 2025 12:22:13 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/12] arm64: mm: replace TIF_LAZY_MMU with
 in_lazy_mmu_mode()
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
 <20251124132228.622678-10-kevin.brodsky@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20251124132228.622678-10-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 534A710000A
X-Rspamd-Server: rspam11
X-Stat-Signature: ji1qpaaze8bqs5t3syfa1ck1a1cnurn9
X-HE-Tag: 1764831147-644690
X-HE-Meta: U2FsdGVkX18Eiug9DR+53NoQ0ZD6+lKIxCMwCEfmUWm8GM9Nu6+CQ+DVufRfo/M4+WbSPZ2RyQSk5IR4TL2phJfWWquIOs5a4ba1KfIKTQv8EqdEr1WY9i3ZkVrAWgivWdCOD5/Gmg4mF7PJR+MhgChnytAWvbo3WhsiOrG2aLLytEuPqwWpX2DSpgTwn+uzQZM00q4MCUTjkZZvOxqO/JoQhA0/N/Jv2J35j1T+kIPJ/mr30zCArnMo+fp8S9CQVDFVpPI+gVVHw+iueKlagY5nFFknbv06klu8DuzZT6vfXxkys1VYs4VPB5VEsP6hIftYcFwVyZnTYGxcciK//wfl9lvC5mV8OI1N7H+ShCGiMVot0e9nhDlZtlCNif97DkTxWDrto5t8tSyfIHtgmc1Reqcj7cNvKuQoIvIMCcNdImBXT7sKEDgmcTvGTsvS+3C+g9Bmh4sCc2D2c7PTpQvkrAe8jFa7jcGJBFkWEkptw1/w7YjL1Kx+pN+qGbf++UpMg6QFQFTdId+GQyJQMDz2Lbrhf9KjMu9k3tusX9LjR8rftQXdOmjiObkT21HPcW/0iruKy/dGTa/+hBeW6k9ousyPLR2YPFXYz0XdhKE0/sczykwAo2AFS/u8iv7dG13DTxIiYsyg/9zS8UdCWvAxQWgns6rRGtFTgz5Em5/MX90ORVEPsJC2UxfGJov3mn4VU0QYEmH5GkBbcp9Fv+Cp3qbPRPAP+4FXM2K/lO67hYJLrxzESR/u1ASNjjH24acGHnDCUrASe5zoaKUxWewAGQ44C4VcRDUG9V2S7ZGqpBjiXAe/vNSqkzS+5WIieGjefPOuPuckMCPE8MkTG7nqB7vCkzZNB7BWCU4GYq/9CDJwVqYfdOZaY5PGj6FerWxIP6aeUXauZ81LmrCo9BuTRd0tgNDC97L7wMvhmqO8g2FlkN6JtJZPlfPZg9dc47Anbh8+G4KZsbKicpM
 cUlX6tTc
 DTjg7HgZERAzt4Y9RDLA9mYXv7UZpYa5Voh1G5VN14fDW2+oFhfVe97VtuiMypj1jB0zscv1H2EkBz1CXnJc8+kLdTf8MLLPzdpoNtxGJpvFUPWKeMIQtSEsV7k3YlKnVCG8Gv3w+ksKN6SUIGKpqzvJA9oCOezGXVFCHye+KZHYvisRwSLGvG3w30EWguloVflI7awme9RwekEYbSXqRD11OjeV1DK/Oa5YEF7U7hZUcPbp/TEUM99liljS/PudU/n9VfLUBjtEaH29nxQpS3LYHUCXs5jPHEzBtYVZ66N2UCQCI/Uyuhp9+7MJ9YLg0qkF2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24/11/25 6:52 PM, Kevin Brodsky wrote:
> The generic lazy_mmu layer now tracks whether a task is in lazy MMU
> mode. As a result we no longer need a TIF flag for that purpose -
> let's use the new in_lazy_mmu_mode() helper instead.
> 
> The explicit check for in_interrupt() is no longer necessary either
> as in_lazy_mmu_mode() always returns false in interrupt context.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  arch/arm64/include/asm/pgtable.h     | 19 +++----------------
>  arch/arm64/include/asm/thread_info.h |  3 +--
>  2 files changed, 4 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index a7d99dee3dc4..dd7ed653a20d 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -62,28 +62,16 @@ static inline void emit_pte_barriers(void)
>  
>  static inline void queue_pte_barriers(void)
>  {
> -	unsigned long flags;
> -
> -	if (in_interrupt()) {
> -		emit_pte_barriers();
> -		return;
> -	}
> -
> -	flags = read_thread_flags();
> -
> -	if (flags & BIT(TIF_LAZY_MMU)) {
> +	if (in_lazy_mmu_mode()) {
>  		/* Avoid the atomic op if already set. */
> -		if (!(flags & BIT(TIF_LAZY_MMU_PENDING)))
> +		if (!test_thread_flag(TIF_LAZY_MMU_PENDING))

A small nit - will it be better not to use test_thread_flag() here and just
keep checking flags like earlier to avoid non-related changes. Although not
a problem TBH.

>  			set_thread_flag(TIF_LAZY_MMU_PENDING);
>  	} else {
>  		emit_pte_barriers();
>  	}
>  }
>  
> -static inline void arch_enter_lazy_mmu_mode(void)
> -{
> -	set_thread_flag(TIF_LAZY_MMU);
> -}
> +static inline void arch_enter_lazy_mmu_mode(void) {}
>  
>  static inline void arch_flush_lazy_mmu_mode(void)
>  {
> @@ -94,7 +82,6 @@ static inline void arch_flush_lazy_mmu_mode(void)
>  static inline void arch_leave_lazy_mmu_mode(void)
>  {
>  	arch_flush_lazy_mmu_mode();
> -	clear_thread_flag(TIF_LAZY_MMU);
>  }
>  
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
> index f241b8601ebd..4ff8da0767d9 100644
> --- a/arch/arm64/include/asm/thread_info.h
> +++ b/arch/arm64/include/asm/thread_info.h
> @@ -84,8 +84,7 @@ void arch_setup_new_exec(void);
>  #define TIF_SME_VL_INHERIT	28	/* Inherit SME vl_onexec across exec */
>  #define TIF_KERNEL_FPSTATE	29	/* Task is in a kernel mode FPSIMD section */
>  #define TIF_TSC_SIGSEGV		30	/* SIGSEGV on counter-timer access */
> -#define TIF_LAZY_MMU		31	/* Task in lazy mmu mode */
> -#define TIF_LAZY_MMU_PENDING	32	/* Ops pending for lazy mmu mode exit */
> +#define TIF_LAZY_MMU_PENDING	31	/* Ops pending for lazy mmu mode exit */
>  
>  #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
>  #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)

LGTM.

Hence with or without the 'flags' changes in queue_pte_barriers() above.

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

