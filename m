Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EC6CCCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 15:29:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B50078E0008; Fri,  7 Nov 2025 10:29:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B27688E0002; Fri,  7 Nov 2025 10:29:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A642B8E0008; Fri,  7 Nov 2025 10:29:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9311F8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 10:29:02 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20C44C03F6
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 15:29:02 +0000 (UTC)
X-FDA: 84084194124.14.6AD8C9F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 32E224000A
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 15:28:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762529340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CbzUp7HLI49Fg8paD04i5ybzsDse9dFElebqMJiK6fk=;
	b=3hFLnIVIkJlqPZTTnFpP7mmChc0uXn3EeMcYQhg3ZB934O/hIbrQA9SYsq+c9JKTtozXMs
	cUeh7PCK/n4mOVc673L5LBo8cX+qXUGSSfUrIRly+4Qd1VZ/byALdONgU8XKhS0PgNVFv7
	1FswLyfqokNukdBbefzYf8uUdpP6JGw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762529340; a=rsa-sha256;
	cv=none;
	b=MQb8y24RotdFwiOe+WMegt3coYtnh5TrbySDAZzjLmF4swyZ3PY6a2wElMvvRkjqW2wOJi
	H1wb3yOa40SNDgeHz0882Sgh4mu+bZ3PLmkIp8IPu2ZDt9oAHjq/DoinP2y4AJ7Q8hWP0o
	ItWF6rCg1XeODGN0e5gQA7U2GkQQcLw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 55F981515;
	Fri,  7 Nov 2025 07:28:51 -0800 (PST)
Received: from [10.57.86.134] (unknown [10.57.86.134])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7C13D3F694;
	Fri,  7 Nov 2025 07:28:54 -0800 (PST)
Message-ID: <06026ad7-fb85-4a78-ba70-7fa1f5bca0cd@arm.com>
Date: Fri, 7 Nov 2025 15:28:53 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/12] arm64: mm: replace TIF_LAZY_MMU with
 in_lazy_mmu_mode()
Content-Language: en-GB
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
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-9-kevin.brodsky@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20251029100909.3381140-9-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 32E224000A
X-Stat-Signature: cns7mnahf3ey4fc7rse8h5u9ptopjfch
X-Rspam-User: 
X-HE-Tag: 1762529339-843112
X-HE-Meta: U2FsdGVkX19HhlIfBtuEvqX7AT7jmnAKFRgdv8LgffMmNjJUDnWYvpKuwJ4pYE5I1qsbMKFYj/saxsBu2t3XWdoX1bokE4XiTUFgECIdcMkgmp5u1Bwfb9b0PR78LRjVAdeOXAwonMCVgddVcM2E2MRBiKdrPz4CevIAsqojikBFpllCWh/D62owwrcttY9UT+1PKknI9iJ6wQtRPNDW2RQ5sOEgfmpkwq76bJjHbyYij2QviQqhedPiq31/LuLf3eySe0VGDJVbqtVbkbwORjNBkKYgzB2HFJbvr2p8eFGVEp0wPgz/sni0Q2c3tCvcbfyX9or+jrVpgp2AbIvaYI5jX1sXqGOcVhENnKUKTJ2okSYFtp0714rn+DE0BFxTtBwsmgtwJnu/WxoEmqHn3WiNnXFZe0Rn3+x2vvoe4WEnDPuFSgDXtmRRHt4h5US8bFfi1HsFva1Q86IPZqBGRNhneunNRJwJoZfggYb46LEjIf739U/6MhNmDcTfwUHy0UXBfD/jcKJpCmUtYUywmEsZpiYNY+16puC3HahF5tT8qH3zbxoQHrO57gHVcmBnADj7sz5z2yO4/P2i6lu1Ym6hsg4BNYNNdUadC7cROdrFQ8m4dkLTvONYalJ0vETRglVxddzusg42Xg2jNf/+h9ZtF0vW3JBIf8XWdY1SxQik2XbAFMhEiqM5aBxSr15gwR//02Mm3sUDpB2jaMthLfbpQbiroKDf/g9y2sg3/0a5lP8vvZriHOoccqDFz5sMfeu/ONVr5NZ/CRNAifqytSQu9mdisivU8n6NCTpIPfSx9aajRXZZGgtDelgC6MbkBsWU+fpF4Ibwc61uGnnIGDqGJ87Z0/TpX7CMTLcQ5iig/6Zj6dqYXoPLIMPp8CUKkT3raFSvUuXjMuEYlERlErftZZZPh1kYV8I09KGVkFZzpLndjuMRdLZFxpEqzcOCRLoKJyu7aLlYNKKk7e8
 ELm73eDZ
 dj/2YFrNWPo42QNZ++JKnJWGJxRJEKG0Sfhxg0e3XTDvs0kgKzteeOyZZHq5rOojz44ZWUH8c3avFQKBUl/0MR04FH67FAfLtJoSnyZOxYCHAKoj0dB9GGxynk4FP7jByXISQEtWoadbxzUGbmq/lZGwE+yQGsX+D4D6zFkw2yJcp7i/YDO+z9Cj5uY3W+nUp+jwVrYsGJTVH2yoJQghrjN4oBu/AiEynDbgsg93eRC5YQtaW1/KnTnabAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/10/2025 10:09, Kevin Brodsky wrote:
> The generic lazy_mmu layer now tracks whether a task is in lazy MMU
> mode. As a result we no longer need a TIF flag for that purpose -
> let's use the new in_lazy_mmu_mode() helper instead.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  arch/arm64/include/asm/pgtable.h     | 16 +++-------------
>  arch/arm64/include/asm/thread_info.h |  3 +--
>  2 files changed, 4 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 535435248923..61ca88f94551 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -62,30 +62,21 @@ static inline void emit_pte_barriers(void)
>  
>  static inline void queue_pte_barriers(void)
>  {
> -	unsigned long flags;
> -
>  	if (in_interrupt()) {
>  		emit_pte_barriers();
>  		return;
>  	}
>  
> -	flags = read_thread_flags();
> -
> -	if (flags & BIT(TIF_LAZY_MMU)) {
> -		/* Avoid the atomic op if already set. */
> -		if (!(flags & BIT(TIF_LAZY_MMU_PENDING)))
> -			set_thread_flag(TIF_LAZY_MMU_PENDING);
> -	} else {
> +	if (in_lazy_mmu_mode())
> +		test_and_set_thread_flag(TIF_LAZY_MMU_PENDING);

This removes the optimization to only do the atomic set operation if the bit is
not already set. I think that should remain.

> +	else
>  		emit_pte_barriers();
> -	}
>  }
>  
>  static inline void arch_enter_lazy_mmu_mode(void)
>  {
>  	if (in_interrupt())
>  		return;

Why are you keeping this test? Surely it can go?

> -
> -	set_thread_flag(TIF_LAZY_MMU);
>  }
>  
>  static inline void arch_flush_lazy_mmu_mode(void)
> @@ -103,7 +94,6 @@ static inline void arch_leave_lazy_mmu_mode(void)
>  		return;
>  
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


