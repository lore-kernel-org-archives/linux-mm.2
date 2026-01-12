Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7E65D26D97
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 10:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B6446B0088; Mon, 12 Jan 2026 05:09:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 063E56B0089; Mon, 12 Jan 2026 05:09:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB23D6B008A; Mon, 12 Jan 2026 05:09:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9B196B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 05:09:24 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7D0311A0888
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:09:24 +0000 (UTC)
X-FDA: 84322889448.24.3E24B99
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id B8B8420004
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:09:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768212562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qv/eGBqq8WULMM06skS1XKdZJ3kxniLHJU1u4eJXS14=;
	b=zkZZEX88SQOKROTrMP8WtkMmkDXOaBo4ggUi/0Ro6eO+a8P0HmCGlPVuHJnGoqGnkYf9zC
	ZJnFoZQZrAEjyALpo5BnLOYkGVEHsKgsIFic9vUzMrT2nRfsqQmm9Me93aKu8Zf9TnuCDF
	YgPP2jb11jjb4G8C2JmexrxkqnHaMXY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768212562; a=rsa-sha256;
	cv=none;
	b=ygHFC1km7D/8CXX15K1CdNkb6qnkGm06PNLBq5rN5Sq1TrmGKt+YMV32BkPOiSjMA3XFtY
	2F1hDQjRnV9Wmfg011FLWa09axdoEQDbzT9A3iCb0rpMYgFURn2E5JhqblpMY4tSxeQrSO
	oY6IWQ9ceXE2YynuDM2PvpUezrzofvI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 325ED497;
	Mon, 12 Jan 2026 02:09:15 -0800 (PST)
Received: from [10.57.48.185] (unknown [10.57.48.185])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AD67E3F5A1;
	Mon, 12 Jan 2026 02:09:20 -0800 (PST)
Message-ID: <3ae6e07c-c99e-476e-b9d8-49b999e87197@arm.com>
Date: Mon, 12 Jan 2026 11:09:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] sparc/mm: export symbols for lazy_mmu_mode KUnit tests
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 "David Hildenbrand (Red Hat)" <david@kernel.org>, sparclinux@vger.kernel.org
References: <20251216201403.4647a4f9861d3122ee9e90d7@linux-foundation.org>
 <20251218100541.2667405-1-kevin.brodsky@arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20251218100541.2667405-1-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: om9q64z14j3zxaccf6jp1egqfcuga6xn
X-Rspamd-Queue-Id: B8B8420004
X-Rspamd-Server: rspam04
X-HE-Tag: 1768212562-37291
X-HE-Meta: U2FsdGVkX1/xB9JH0Lw1V8jEN3amOJHPHRWFgczM5cv0tTRraZTJ/ut4PFV9h3LZr5QvKE1osiyNkIGyBwtdnbcV+TsNxarPh8F4GltinxVS7Zn9YKTtKxXGYhwD7hRFYtACRuRxqbQMlbJYslblAoDha3wq0nGvrXsvQ+AKMzJTmBoM0RBd8utI/ZJDctEC3Eee+SHTBwrjpaMI5wPPEawxVCJ0dwl0iQY+sYmAcMuhCz0BMRqVioVW2gOm+FMxhJLpAtdTGf9hZkcwvNwJFjSd8+RBOyHMuCcPAkyvYOi2HFraIcS/7GjkXYhxk+AfkbPFrh5oc5HZ8jUp7QG3si2HrTjueA1eCGkFITuOAFiqd4yqzbfCud7uSSvEOoN0oW/ihmuedvS8KT4tK+gdI0QTyZEJ+iNVM7lHcl4aEOe8Q+vVq6i9nk9Eqbn3PZ6IkTOqp3B9v3pWbY1xw/AlNay2a8v38L0s0b9UtJg9USfFV4D3iAVRKvt6PrxEjK2eBuYgP5/9NMJqrHnsZtefnDKPllVPZ/340dy5AiKB6b4jl2WReI3HuiKFD8cAUPvKlLSfBHnTT3Gs0TuqgMsSMmmdlNQUFWt/6VB+IKGTf1dCm4iu7JUri0KL1Ob62GVZAaIis9jZLRKVpCqFe4Zb8SyUoZsFKgOqwb2Mi+SeYRAyEidLRkXOcHIWi7rBt8Yny2hv+cQ6Xj8ZroHfRhQjxl4vNaHgY/SeaOVKWoXtoGACfiRuWnhcUPkXDDVX7O0AqT10uD0Xvx9XFSl1LqF23pkgpSGlXhNr1jadByJGXEncCOA0t+M2jq/pC91iWn5dOg5XfC1HH6KW3g5Sq5HXLIBhbqIn3gM7OVqFJ89bmK3sStM2Oq/QPKy738j3tVM7uR9oJgrJZURRuYlsbddHz6Tx2wn87/3GTGo8D64n25IF/UfH27TOkojaQQUZbEB0/t1M0fV64m3a/2rfufh
 Ela4UsoJ
 5bTtq0oW52D+0ajVbMrYCO0tv3p3EhElKZDM+IltvRuqF+3Qsu7UxbDFW/3m9jZXN507l4WPtdFzhKdtQ66JtsgKGklG2pLSv2r9BrffNIE29SpNnbAEkU4Ka59AhniIc9HkqU5SUqar6Fb0myUQu05BbXwG3E8VggCe0cl80xOEfYIHuTZH0GqiNcnt4zeotyPHnWgJHS4F6aL1huc4uUpG9wu1ycY4dLvi/haDwez8zioRlZu9J2p+YC+Ie9lE14CFJD/Pgvnizby1m31sxj1myc18tSOLA4yAP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/12/2025 11:05, Kevin Brodsky wrote:
> Upcoming KUnit tests will call lazy_mmu_mode_{enable,disable}.
> These tests may be built as a module, and because of inlining this
> means that arch_{enter,flush,leave}_lazy_mmu_mode need to be
> exported.
>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>
> The CI reports that sparc needs pretty much the same time treatment as
> powerpc... Here's another patch to take care of that.
>
> Andrew, could you please add it after the powerpc one? At this point it's
> probably best to remove the comment above MODULE_IMPORT_NS() in
> mm/tests/lazy_mmu_mode_kunit.c. Thank you and sorry for the noise!

Gentle ping - I think we need this patch in mm-unstable, the CI has been
complaining as well. Thanks!

- Kevin

> ---
>  arch/sparc/mm/tlb.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
> index 3a852071d260..6d9dd5eb1328 100644
> --- a/arch/sparc/mm/tlb.c
> +++ b/arch/sparc/mm/tlb.c
> @@ -11,6 +11,8 @@
>  #include <linux/preempt.h>
>  #include <linux/pagemap.h>
>  
> +#include <kunit/visibility.h>
> +
>  #include <asm/tlbflush.h>
>  #include <asm/cacheflush.h>
>  #include <asm/mmu_context.h>
> @@ -54,6 +56,8 @@ void arch_enter_lazy_mmu_mode(void)
>  {
>  	preempt_disable();
>  }
> +/* For lazy_mmu_mode KUnit tests */
> +EXPORT_SYMBOL_IF_KUNIT(arch_enter_lazy_mmu_mode);
>  
>  void arch_flush_lazy_mmu_mode(void)
>  {
> @@ -62,12 +66,14 @@ void arch_flush_lazy_mmu_mode(void)
>  	if (tb->tlb_nr)
>  		flush_tlb_pending();
>  }
> +EXPORT_SYMBOL_IF_KUNIT(arch_flush_lazy_mmu_mode);
>  
>  void arch_leave_lazy_mmu_mode(void)
>  {
>  	arch_flush_lazy_mmu_mode();
>  	preempt_enable();
>  }
> +EXPORT_SYMBOL_IF_KUNIT(arch_leave_lazy_mmu_mode);
>  
>  static void tlb_batch_add_one(struct mm_struct *mm, unsigned long vaddr,
>  			      bool exec, unsigned int hugepage_shift)
>
> base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8

