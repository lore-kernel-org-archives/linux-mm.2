Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DBF2C624D4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 05:56:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2E776B00A6; Thu,  3 Sep 2026 01:56:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDFDE6B00A7; Thu,  3 Sep 2026 01:56:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCDA36B00A9; Thu,  3 Sep 2026 01:56:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 99AF06B00A6
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:56:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3A2F5A0484
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:56:36 +0000 (UTC)
X-FDA: 85171391592.30.EF3533A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5834B40002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:56:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jy33b5SC;
	spf=pass (imf27.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788414994;
	b=Ns+KM51MzU9YuE9cNAXB5GpTQPOMsAmXdxJQCQC/UWz0DJ9VuEE9TD6Us/AeWSgIVjjBfd
	RjhxgTlwDtnl2MJZVhVpWBhjaY9uy5LLq0jW2Df+oaQIdFmQM1+4Tu8Lkbx9ms02bnPew1
	H94a7GjMDsGAlxTqtGTbKLrjEWt55hc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jy33b5SC;
	spf=pass (imf27.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788414994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s15ArRWhYwwRxlZERGDJdbA8DisI2z+EevAmLakLImQ=;
	b=6154eVvGn1b+6qvuhfSAlhZrYRKVYGydldSSLk2n3ffce6CQaQo7L12OOMFcQ6VH+FIn69
	ybj42nmuHGxqamDyZEvtroMyz9pCED9kcLbBUlmPvlL1IcbrMd0gf3Q9qMpVD0mm+dv3Gk
	HPDCOzXjvvdMMjwb4G+b7L08ocEUYno=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8B4631596;
	Wed,  2 Sep 2026 22:56:29 -0700 (PDT)
Received: from localhost (a079125.arm.com [10.164.21.43])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8FDCE3F673;
	Wed,  2 Sep 2026 22:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788414993; bh=DY/csfhtR5YKRxNjL+v1oA5BkKG7eZTRM1aibwpAHZw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jy33b5SC5V6MzaplebERlNq+BFlc9TRUI4ImbVVvxIHngkHgnbxv0tzSSVfsfKXe3
	 im25pVnAOzQ05+j8tOYvftqbvXK5fe2BOtxDIf0L3t+U05xyFehzWRhUpXS4solPgf
	 W74ItVMEC3SFf0Ed9IfLCQ/BgE1K1Fiix7t9JZPo=
Date: Thu, 3 Sep 2026 11:26:29 +0530
From: Linu Cherian <linu.cherian@arm.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-hardening@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
	Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	=?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
Subject: Re: [PATCH RFC v9 08/25] arm64: Initialize POR_EL1 register on
 cpu_resume()
Message-ID: <apkMDaRKqX3TTINV@a079125.arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-8-743ad31b2c8f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818-kpkeys-v9-8-743ad31b2c8f@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5834B40002
X-Stat-Signature: hdrxcnhq56npuzyss8dyne1sdsd6eexs
X-HE-Tag: 1788414994-117171
X-HE-Meta: U2FsdGVkX1+ajMqI2ISiwqAZ2GPiuHJxA0VkPJGR5Tu7I/wrakFpuRo8AQrNjBUg/jdGZhr5pXSPLy+Q0k5c/iIZ675qHkRV9eoi+IcMB4hExrzOUNMpL1boDxNyUtpAFs/tnZslSwGel65hnVmlNWEYndxpJV9ZCEB+6M/qUu9tN6QMUxXIiQAf70FeQvuhQdA2zjH5BTPEpUMsme7evTU58nex3kwnfeAruLkJZFJkEsfYzq6IKzxbRAx3Ukv8Fz4gC3duzLB4puiXFFsxBnlmUjO1cx+KWje6hA+Yh+y+Au8dpH/qPMuJLwsAyVHZY6i+x0zFDDIPE+V26Y/EFJD52kgThvwmTI9rHJ9tLIqUsjBodgmsCA0e8chHDfm+H2LsKlnbQzmmTB6AUZy/4svs9Ga1YbB+CNXfXJoj+NrRDbrSRkorABBYrvwrGQyxfzBCSRgbscva6i4FFuhb0t/pJDpDxTomDgA/MGXNq6aiOfl0quQsTR9V9/Hnsnbxzp9j7+mc8xmweV8w0j5LQRC2D/xrCiYLTAcG7GRwBGidEQkKTZ/engEZWW6ouUAKi2misN4VKm4uuk6emdaNzFpY7G/OJwnblhoZwydSrF2/yFOmsU51I6/WqGNkrlpkslBfVxx2h17PCyJwYmRcn2d+S4diTRyRv0gSpZADPhdtjL3yGsQEKr3fKkTD6nXSlThyLUu/9IVDVjo7Mx+0wLAHZF9cGZJjQsUuMa5WI1WKmNDSopCdGsEwEkM66iOweDeQIfYHQswWU8UGlHUuRrVpKXRCLeDoDFPCSG10Hu75VcczwOpJVTKkvIVrWaYnd6yEgNxJ+faIpHMCrv423CVOBnwdSqeIfOE9qXYoUl6VvQvaYIC8nmVa8ZOB8D2l3jlDxi2D8VCYSlCwnG5dFCKBSey6Pg+Y574I67dX3jQA3LYjBqLBJWUO8VmAb7omrkIhPIz0WK/7hQqYxc/
 x13zuo6M
 dka4QrfId1txJj52GqgFEOqv7n1tyV3MH0BemNvHQTlV4npebJpb9aOCo8I1rDe3mAIgcxMWL/wDDHUq84OwtFmAFD+XXr922s2nZePdl8LRSIa9C91+ayNWZjRkVt0O5A54ZQTooH09HtvVrZUrX13mhTnJIopTVVjDcXmeuSrC2Mlt5o9r9paufVvJ0dtELrIfpOIi9QcNXGG75MJOQwlnsz6m2APrWXafjKlVoTKegVg54hu2F0Z5uZaBIhwjLxwCuZw9uCjMU/rvmoUEWnpLr9PmdvWfB3NrBvRbKm37dXtybrjtUln/L9e8NJrt61Vb4+jkWmBVQ4MDTjeD1RSr3qOZ6FQQ1BSZYW8/HncdlFz1v10I1fzb2lQh/CgulQUOySfJWBHQw92xB8ymdeUopW7YGSgukdeqDmoBqLrH9mzk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kevin,

On Tue, Aug 18, 2026 at 03:08:50PM +0100, Kevin Brodsky wrote:
> From: Yeoreum Yun <yeoreum.yun@arm.com>
> 
> The POR_EL1 register is reset to an unknown value after cpu_suspend().
> Since POR_EL1 always holds POR_EL1_INIT when entering cpu_suspend(),
> initialize POR_EL1 with POR_EL1_INIT before cpu_do_resume().
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  arch/arm64/kernel/sleep.S | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm64/kernel/sleep.S b/arch/arm64/kernel/sleep.S
> index f093cdf71be1..e0a6ad85cd24 100644
> --- a/arch/arm64/kernel/sleep.S
> +++ b/arch/arm64/kernel/sleep.S
> @@ -3,6 +3,7 @@
>  #include <linux/linkage.h>
>  #include <asm/asm-offsets.h>
>  #include <asm/assembler.h>
> +#include <asm/kpkeys.h>
>  #include <asm/smp.h>
>  
>  	.text
> @@ -134,6 +135,17 @@ SYM_FUNC_START(_cpu_resume)
>  	/* load sp from context */
>  	ldr	x2, [x0, #CPU_CTX_SP]
>  	mov	sp, x2
> +
> +#ifdef CONFIG_ARM64_POE
> +alternative_if_not ARM64_HAS_S1POE
> +	b	.Lskip_por_set
> +alternative_else_nop_endif
> +	mov_q	x2, POR_EL1_INIT
> +	msr_s	SYS_POR_EL1, x2
> +	/* isb can be skipped since cpu_do_resume() will do it. */
> +.Lskip_por_set:
> +#endif /* CONFIG_ARM64_POE */

Would it be better to move this under__cpu_setup ?

--
Linu Cherian

