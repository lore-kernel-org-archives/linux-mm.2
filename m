Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E29FDC624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 05:58:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBD4A6B00A2; Thu,  3 Sep 2026 01:58:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C93EE6B00A3; Thu,  3 Sep 2026 01:58:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD24E6B00A4; Thu,  3 Sep 2026 01:58:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9670B6B00A2
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:58:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 18CCA140445
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:58:15 +0000 (UTC)
X-FDA: 85171395750.11.9616249
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2F7D11C0003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:58:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qCWpIZJy;
	spf=pass (imf20.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788415093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wPjV0xAt2X5xqXl6S8/1og+Gt7Br2ZKczWCCN82Xt7k=;
	b=lhyd7O2zwbNkyWt9SxXej9FEtA9IsMShaeXHxBZO052xqfEmtWKglN+Y3ev6nuw21jeA0G
	oUbQEh2agRSx1w1GFA+R1nT1ZawNWpxQUSMi7lUYxSXSqioBbcmBGaoDjajCMsaYqYjsv/
	0wTMHiKiQn1/IAWWkjkwvBruCuCPr5s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788415093;
	b=mqcvyojzGw3RO1WuuWZgQglrF+S7J3sX3njzVK2Md4Ak6nnD3umJj8o2l3ReMxKaUsVyr1
	FkLDTC/n4eL3C6J7W+IqDj/82lqX7K/P24z3MsWgIZoQptuzhG0Om3xcnctn/YSYPS/Nux
	hFFE96UQgXjkz6JlNHJwVz/rsiBTze0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qCWpIZJy;
	spf=pass (imf20.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9DB6F1596;
	Wed,  2 Sep 2026 22:58:08 -0700 (PDT)
Received: from localhost (a079125.arm.com [10.164.21.43])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A1AE43F673;
	Wed,  2 Sep 2026 22:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788415092; bh=pQigNQ0RH1x3B4WAmoTYWjrUAMlgt0klrdQWZzUN6Qs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qCWpIZJyle1CnxF0mfzL51ZZrc+lgi1FCWufg+fdD4C3LnAhAdqG+yOAQVUktlhQj
	 p1q2ujxe01GN/YlR+g5ypXIuoNQei3uuNybBMEsgxyF8q7twxpCp0dzAIf+vlZyrM1
	 xQJ0F5GV8r0lEw0yR9/mBskoHU06Y0xqJ3sjjJpQ=
Date: Thu, 3 Sep 2026 11:28:08 +0530
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
Subject: Re: [PATCH RFC v9 07/25] arm64: Context-switch POR_EL1
Message-ID: <apkMcHO_Y5Bu9G5o@a079125.arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-7-743ad31b2c8f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818-kpkeys-v9-7-743ad31b2c8f@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2F7D11C0003
X-Stat-Signature: f86m3exyajgk9q9g7wieoie4xegnbgxn
X-HE-Tag: 1788415093-294926
X-HE-Meta: U2FsdGVkX190jDTck8k18JqXBAjTiRbo3SWkjrgIGYwD61gvOOhc/pmMFhoAJE+X8fL59Y1MuB8ihQBFbOzZSDwebjeeTPZ7NWhTEfvjs+B8z1fsRc2pigJUMpTpGBGKNV4DXgZ+V01rfwdiA7RoL7xa5RlSLgpmf0wMOiuVBjudZwr6xdnnOA65WDUxTEuusb/wtIVLRUq3PTgEapjS7h1LtkRq3Nn3D0duDfDQdpDrYa/ZlXLHFgBNLpK7+Qhkx+l3CKG4EIIOsUnCWqSmvJ4lMumpCZHl+BM5YMTpUSMUnQNTNTin5M2IlmkubHaZPYrKtGBGngUzSrApXRH5/6zfqma/NSHx9uHVPvKycvAMtIm2jfhl/HMUHaNujrqcI53TNZ2tG8pPxUKMTRmVvFUpr6/vPxa+bJBESikt/Vp10ORzlRfBgqVaGoS4oHwrrE2tFMONYVcIrSsNSYu1QA8x/KuXocVBjZ4u0FeezVEh8ijhlMHBC0cdvg6BxvKkRWSARLC/23Ytnfqv6MLX/FUsCZAKwmUbx8kCV4YzV592To59CinoyayHdpDy8+CRYfAByDYQEXiKcb7cO/M8tvdVazOfIrWSvI/foO7Lhjai+EM4TQmklWZL4QPs3mWbb9aoI0R5+rmnf3KgaATT1c5ep9Z4K9w4caIegykkImiIdk93xmqdTiw6iMJhv0bIdlFoot4FDIuYHij4X0iNSSMsFac2K2r2tHHRLrjbAztS9Ke5uZsZbLbJx47/R85nMIIfaQu/bgfqkD7/V7NmN22wUMjT7nXU3L5xQmE3smvHQ9WTt5iUK9+ZgUBBrUo4iyTNPrZVy4qJSw2ARnn37RmMynMsUrXPkBur2/Snc5N2JJYItN3QhXHXEBTogi1NTQ2yMKGMFoAkH4w762q7H9CbPckX5eBUL2hek78xVXRMnaP1kos48P8CLizSBsqzqp/PEXtvaN25CrWr0qA
 SEMNrMIh
 +LntJvVE3k9YD57E2wrITyl7PyJ6rLimScN9tuSCIwZ4i8GxXDrewQUW3BbjTqLCBfM0eK4Sk1/CaIusdBGODdDIYWlksXdFYAOPSpFcOedYbMH+44d/cCfJwljJsIyo2OZz1e+VVV+6zZ1/NefRx3/0L2Zq4J9tTwiciApm1hRzcEc4ygVH6l5l8ERHvQbh7/hN2d3lAzvdTeAokDjU6vU/fXXconhg0XEm35dI+lmxVTk9ukMiW+kma7eZGpJavGFCFRpKOGtmaTt4cPBCGnbQrX6ki78ffAyNbJIOk3c3UZGOzss7a5mSWSR8I82tjFc/UT177MKl+veySraopn56e9GkSai4+MF6w9vGk0J9kKm5H/BVl1YdiwEsa0UTod7tVKMoA4BxHXPtmw0oGGibqzRKPbnNmYMA1NpbD1lPDBs8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Aug 18, 2026 at 03:08:49PM +0100, Kevin Brodsky wrote:
> POR_EL1 is about to be used by the kpkeys framework, modifying it
> for (typically small) sections of code. If an exception occurs
> during that window and scheduling occurs, we must ensure that
> POR_EL1 is context-switched as needed (saving the old value and
> restoring the new one). An ISB is needed to ensure the write takes
> effect, so we skip it if the new value is the same as the old, like
> for POR_EL0.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  arch/arm64/include/asm/processor.h |  1 +
>  arch/arm64/kernel/process.c        | 10 ++++++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
> index c2a627f39314..8d7fa479cd36 100644
> --- a/arch/arm64/include/asm/processor.h
> +++ b/arch/arm64/include/asm/processor.h
> @@ -195,6 +195,7 @@ struct thread_struct {
>  	u64			svcr;
>  	u64			tpidr2_el0;
>  	u64			por_el0;
> +	u64			por_el1;
>  #ifdef CONFIG_ARM64_GCS
>  	unsigned int		gcs_el0_mode;
>  	unsigned int		gcs_el0_locked;
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index 581f80e9b9b7..1dec143decf1 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -51,6 +51,7 @@
>  #include <asm/exec.h>
>  #include <asm/fpsimd.h>
>  #include <asm/gcs.h>
> +#include <asm/kpkeys.h>
>  #include <asm/mmu_context.h>
>  #include <asm/mpam.h>
>  #include <asm/mte.h>
> @@ -431,6 +432,9 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
>  
>  	ptrauth_thread_init_kernel(p);
>  
> +	if (system_supports_poe())
> +		p->thread.por_el1 = POR_EL1_INIT;
> +
>  	if (likely(!args->fn)) {
>  		*childregs = *current_pt_regs();
>  		childregs->regs[0] = 0;
> @@ -681,6 +685,12 @@ static void permission_overlay_switch(struct task_struct *next)
>  		 * of POR_EL0.
>  		 */
>  	}
> +
> +	current->thread.por_el1 = read_sysreg_s(SYS_POR_EL1);
> +	if (current->thread.por_el1 != next->thread.por_el1) {
> +		write_sysreg_s(next->thread.por_el1, SYS_POR_EL1);
> +		isb();
> +	}
>  }
>  
>  /*

Reviewed-by: Linu Cherian <linu.cherian@arm.com>


