Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1403C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 09:14:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E706D6B00A7; Thu,  3 Sep 2026 05:14:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E483F6B00A9; Thu,  3 Sep 2026 05:14:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D850B6B00AA; Thu,  3 Sep 2026 05:14:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC87A6B00A7
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:14:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2FCE4C0241
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:14:07 +0000 (UTC)
X-FDA: 85171889334.27.9DA4138
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 569C2C0006
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:14:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pWr0i6pJ;
	spf=pass (imf28.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788426845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c9DsEkBgu2jnZnRY8QQEWHZs0nZcCr7feDWc1ShWrQM=;
	b=klw9pWT+76RwA5qW46s+9w+FdrfjmCYkooeRARFERwl3yE+DnQN/yiDqtE1vymKaoYTLTu
	cxzbEgduo74MnhZHgz3zU8XwxbRYI1TkSAalKcU6ymeDKRqUT/gRdyFyR3+iUjWplOE06Q
	6E2db5BUzvsIC4aZvyA42gBnIXsFfxg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788426845;
	b=nQIpES3LN60p1UcpmQXoyLsmIqKH8vMyEWIVdWGDebeoN5LvmCYshSCRUAi9d5roktAYG7
	544WqQdQxCbQ7FVdzWk+ukRArCw2SlOP/XYwgXrjVB6eOO3AfrDHSoT/Ph4FSQ78rv3Rp/
	tR9g2WTCXh42vydIot977Gc2sdIbwvo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pWr0i6pJ;
	spf=pass (imf28.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B52E51596;
	Thu,  3 Sep 2026 02:14:00 -0700 (PDT)
Received: from localhost (a079125.arm.com [10.164.21.43])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BDF103FA32;
	Thu,  3 Sep 2026 02:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788426844; bh=6jwLKj7jhYtsSX186PaK9yCDtesokapjON4y/Vc8cE0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pWr0i6pJSQywxTkp4y67uTu1Uz+4OfYZRorRJvi0pLgHJR8J81nwbJUoeDUDJ01lN
	 gs+poUT8IJdSKiSw4my0FdJrFI4SIer8s1wLwlKM/GNiLPLLlPwuL4naZC7BLSWzF/
	 6XZSpSTvGCygqlsuwPJ7YWAPSD/ktcswEvNtsNaE=
Date: Thu, 3 Sep 2026 14:44:01 +0530
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
Subject: Re: [PATCH RFC v9 09/25] arm64: Enable kpkeys
Message-ID: <apk6WcSQyvPK_E6L@a079125.arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-9-743ad31b2c8f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818-kpkeys-v9-9-743ad31b2c8f@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 569C2C0006
X-Stat-Signature: am9jrg9bj6sx8nphpug5t5c4r8on3ja5
X-HE-Tag: 1788426845-509596
X-HE-Meta: U2FsdGVkX1+zN6V1lDobHG3eRNrsBAKqwIKuLdW0zXtZ0sQd3w0KWDcVQOVdmYAT38aA/TBzaYhrGZuWCRnzcZB8qM9xNXElWvjYGN9Oyb0q/qYl5DclLQdmF5O32CjVqGMNpTU8Hv0tWN6Cmuk+sdILzGswrlw+L1SnZ9HDiqTuECdB0Pwmrfr/gSn6yeO9EL5Uxx+Ut6k7KXIQrVeRA14OSJuXOXKIjl+CHLDmNJzhE4n0C//Q5oWlWLUXbJE/W2kDq1vEjS7Od5lt2WczvXnKfPby7ZKXWWaLi/s9i+qaXi5B2V9sLVKYcftAyMYIyaSxJVAF08FY3TqpWlzRBrIf8qV77wLBrPftwlsa7mgCQvM+FOY88wxY+i1T9agRpv8COGarEJljFhA1lcMipDwYC3mWRxrZv0NdsnDFveqNkbh9/OG+jS2WZA+mLNaaqHNjo6VXaKx9sKNrcZN7XFL49NoXIf+tqKSGOxq0RHrKSAXzSMbI5BNlJddWyg4OQFbBgoqWEAfxJyC4REQR1TiU+U6Yk+52YKerjxHkV0QrPh2sae4ukFMFyEQTEXfMNhYgWrauMBqbVtSmZQE5exQ/iqPvNShIPhaxDpjj0Of1wDehjRx5PLg40BNz04pLoVNK10Vn5sCBb+oKUYxG0M6SvlALbAayf98VoYSlHxEsGIQnzmjwxaoVAJUbLqPF7Iu0lwx/NBoGcrBvR8FUEc07XA0zVmbQBke3Le1q4IcR4X7m3WnP7eFk9d8u/ghRWuyQDHDjD/c9ZZ404ro3tmKjqRb9OusDBAZowGbRVt0PlWHluDt2hI55Xeb8q61OksT0uspwRhR5wDuGKyWjcncIcz2ng2KKCwNFDKk9ZKTf1+tStltoo8KRRMNmngratsMSWpKFtU3TtD9XqCjDRtorXItHnQ00dqCJPagKHm/ZRKROW66DuttgLp81fA21wdctaJsKHDBTiuPugbE
 0jgXGdQx
 /wb6clC+dhjE1vnmfWl1vMK+CXP4NBbRB4qCLeD//iAIKpXJqEb5KHnyLWWYpq3cPdwtrcEUAIKwphmwcjPcmYGWnE4uVxpsAFbiGKRC67TtjKT89mqQa1qGSYifqjwd1LiuIxGZIxWXB4gF812vbXv3J+wdnLrJHpMrqNCyLLz9KSLu/pZr8yY7wEafTxYZBwvXUsigU9CDmIhOMEP1in5ggZlIVy/ntfkoSesNuzrX86vpT4tTlQhEcmMnWYcYq7/rgmPXS9nUABl+F4KJNbY1FqcAqVukGVIPY4bwKhA4k+cepuFeiwlXsowLQaONq76SxTQoJw+YUAfr9NQSjcv/apuzM3bN9FDePy8MsT5M9XgA0uf1bT8N7CzFeiTr3Od/C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kevin,

On Tue, Aug 18, 2026 at 03:08:51PM +0100, Kevin Brodsky wrote:
> This is the final step to enable kpkeys on arm64. We enable
> POE at EL1 by setting TCR2_EL1.POE, and initialise POR_EL1 to the
> default value, enabling access to the default pkey/POIndex (0).
> An ISB is added so that POE restrictions are enforced immediately.
> 
> Having done this, we can now select ARCH_HAS_KPKEYS if ARM64_POE is
> enabled.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  arch/arm64/Kconfig             | 1 +
>  arch/arm64/kernel/cpufeature.c | 5 ++++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index b3afe0688919..0afa085c66be 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -2202,6 +2202,7 @@ config ARM64_POE
>  	def_bool y
>  	select ARCH_USES_HIGH_VMA_FLAGS
>  	select ARCH_HAS_PKEYS
> +	select ARCH_HAS_KPKEYS
>  	help
>  	  The Permission Overlay Extension is used to implement Memory
>  	  Protection Keys. Memory Protection Keys provides a mechanism for
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 9a22df0c5120..4f2f54007ed6 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -76,6 +76,7 @@
>  #include <linux/kasan.h>
>  #include <linux/percpu.h>
>  #include <linux/sched/isolation.h>
> +#include <linux/kpkeys.h>
>  
>  #include <asm/arm_pmuv3.h>
>  #include <asm/cpu.h>
> @@ -2463,8 +2464,10 @@ static void cpu_enable_mops(const struct arm64_cpu_capabilities *__unused)
>  #ifdef CONFIG_ARM64_POE
>  static void cpu_enable_poe(const struct arm64_cpu_capabilities *__unused)
>  {
> -	sysreg_clear_set(REG_TCR2_EL1, 0, TCR2_EL1_E0POE);
> +	write_sysreg_s(POR_EL1_INIT, SYS_POR_EL1);

May be we could move this to __cpu_setup. Please see comments on Patch 8.

--
Linu Cherian

