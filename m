Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 176CCC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:48:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00F766B00D0; Tue,  1 Sep 2026 10:48:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F020B6B00DD; Tue,  1 Sep 2026 10:48:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF15C6B00DE; Tue,  1 Sep 2026 10:48:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B85036B00D0
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:48:44 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A9537C044B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:48:43 +0000 (UTC)
X-FDA: 85165474926.22.659FB9D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id C89601C0005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:48:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JEltKYEX;
	spf=pass (imf20.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788274122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H9GxEc7XssMRAghG8DyBdsxTfLc1nEoVFJVs0vitzQY=;
	b=mhJalWN386jB0eg4m1osseBIBxowWjADZT0P7I6QT/+JjZUF6+Ql5xsDMl8EWJTmMCWmyC
	6ViIeAjApatgWvWEYBvo/I+Zv5Y9ae9OLyqfZzPybjT+RG/2vvGaBm0x9uT4WvTdjFncWZ
	14tyUEoDVpFFm3f3DOXbYgahYFarJC0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JEltKYEX;
	spf=pass (imf20.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788274122;
	b=m9ncvW+fRMbzKx8GILLqYVgzPXZfg2hwPfuoXp9Kz1OrMFpmcklLU5a3AzhDTfAfRkH26t
	UDFw7D7rZP4WuAXO2S6Blhog0CYvACjvY6/t3hBWf8wtHZC0fxuWT1/di2a8A30ZtgkE1N
	wjjZWrRLLOzB8+ZnbpkKdDODlRr9bPs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 283171756;
	Tue,  1 Sep 2026 07:48:37 -0700 (PDT)
Received: from localhost (a079125.arm.com [10.164.21.43])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2AFB33F882;
	Tue,  1 Sep 2026 07:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788274120; bh=5GY+SQc88euWmJgqoN2XFz/ZgVOv0qHEWYmDyZeK5BE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JEltKYEX2C5ZZ/qepJmekcgZuDMHGo871Mo2hrh8BH4KmIGGofzXJ6IGQtgJXDhPp
	 zKBCcEQPeq+Gu3WEP8GTg8CE3pXDpUyOQkTV05I4itu+glLuCCh7BuPty9T7FfTbkD
	 rDKNjPsACVDZtvgM45KURU6FeTlEBy96apb3J4g8=
Date: Tue, 1 Sep 2026 20:18:37 +0530
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
Subject: Re: [PATCH RFC v9 05/25] arm64: Implement asm/kpkeys.h using POE
Message-ID: <apblxUah9EcQox-Y@a079125.arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-5-743ad31b2c8f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818-kpkeys-v9-5-743ad31b2c8f@arm.com>
X-Stat-Signature: 8qz4hrm8dxxj34hsks9a3ceczfgsfojj
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C89601C0005
X-Rspam-User: 
X-HE-Tag: 1788274121-919616
X-HE-Meta: U2FsdGVkX18gjHwMK7ZKje5fAvLdvGUBIODnlX6SSYYkAbqSGQqr/Kpq/r0RdYUC6900kzHHWZsy6o0BGOCuwEjqE8c3vvDlbWAYzRF626tZf69wqinDJ2iZ2lroNrF2xolxd2Dn3RQqXQjiuDqOUMrpJxdzmwZtGYLTLqUV9FFBVUBwbBx18dl5F5shYXSydWgrDEk/9MIXc0bq44JM9KoBDio3YVGzaZI60k+8hLfe+qY2ae+UriTtnI+Qud+PpspkOXrWloGwVySe5bS9thlO0y42868kGcBB/IOK2oFBLAaYXdoDE1A9+jAc2doJ5GKg0YDtSB6YoA/SFFmplqqDndWKWDOwIQ3eb5dXdAEuqfRWL61rrU1MOxZNCLpm+Hkxqwds35h88UI6Byx11FUtOt+nGefOp3M79uCwHOs6lnSxTGXL5WG+Qz8tbSaeO9qnXqqEjE9wfjBkh94hnRYyr/2pLl/6O3/7X9snMvTwxv6NvOdpLmyHEYkaeuGSAaXBIyBkVeDcpkYMDzzLAKjtDogMMeJ4+/IsOJ7FWnvRo9NgdcjxuRXODI7AZyITJV1UoXGter0Y35ox12fBjQBqoCb0SdM6JziTCsaf+7kqcTblIcGmPHDyhKS2lq3XPh/G2PwbvjVfj3hX8MrMVLMBjR2RHtyP07ptXK5efrR0PnhZ6pTclAB/i7kds2wToohcIzpllElqR38ZKaml5KxIADJ5L1D8d4xC6cQCfks5umRj+qOSu0ArcN2TiZ9LJPPw849cLW3VKGhbGRdHDOF3TjIJqLtKIVSjlzGZ6+s5gdF7ViDD7SpGdA5inMzohzPzY40yx19pZmrxS5YBSs0jP8od1fQbB8V7HZv7M/DIeLbaQe0V7BR4xyDDmrQ9shsEHiDpKwPK582B2dfYc+pC4xlL/GVPf6JFk3idj0cObbr+n/G/+6H3EcnrMXKL5jLTvUMmCVnYx6PhaN2
 OTL5OCjb
 yFTrz+VReSL0q11kevo0gxTtFQiyxyHyTiLJqgcGTb64/+lYuoTgx+0T06emscFWUY+aXwUIcIE9wrQ/8ABH6muE8/LnSNMJnfGb6zQCwz6rXd2R8eJlIESGWATvU9zZz9qDreDLkK6FspjdQY1rhl28mtA4ACQIAM6zwQfgCYYTh7phqdGZdIAgBcsoHM6gLLTo/fPc8RL0lFIh4eoj+2ulZjPvR4xSs1WKoB4V46Y406r1yHhgX5ibCAVuluEGRuRaFvu1HThW+TcxRU/53pJ75QXphRmGTwF55hbrbmxZaTk20KfataJCMYdXCkrDWULckDJGsZTN3/pCs6m9SDo7WlkibfBiN34mT6UdgiJq6zoFOLV0XgJqquBh2q1THh0Xe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kevin,

On Tue, Aug 18, 2026 at 03:08:47PM +0100, Kevin Brodsky wrote:
> Implement the kpkeys interface if CONFIG_ARM64_POE is enabled.
> The permissions for pkey 0 are set to RWX as this pkey is also used
> for code mappings. POR_EL1 is left untouched if we have already
> entered the requested context.
> 
> To allow <asm/kpkeys.h> to be included from assembly, also add
> appropriate #ifdef's to <asm/por.h>.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  arch/arm64/include/asm/kpkeys.h       | 67 +++++++++++++++++++++++++++++++++++
>  arch/arm64/include/asm/kpkeys_types.h | 15 ++++++++
>  arch/arm64/include/asm/por.h          |  4 +++
>  3 files changed, 86 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kpkeys.h b/arch/arm64/include/asm/kpkeys.h
> new file mode 100644
> index 000000000000..09fd5a849cb0
> --- /dev/null
> +++ b/arch/arm64/include/asm/kpkeys.h
> @@ -0,0 +1,67 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef __ASM_KPKEYS_H
> +#define __ASM_KPKEYS_H
> +
> +#include <linux/kpkeys_types.h>
> +
> +#include <asm/barrier.h>
> +#include <asm/cpufeature.h>
> +#include <asm/por.h>
> +
> +/*
> + * Equivalent to por_set_kpkeys_context(0, KPKEYS_CTX_DEFAULT), but can also be
> + * used in assembly.
> + */
> +#define POR_EL1_INIT	POR_ELx_PERM_PREP(0, POE_RWX)

IMHO, moving this macro defintion to "arm64: Enable kpkeys" , would be better as
this patch is about implementing arch helpers. 

> +
> +#ifndef __ASSEMBLY__
> +
> +static inline bool arch_supports_kpkeys(void)
> +{
> +	return system_supports_poe();
> +}
> +
> +#ifdef CONFIG_ARM64_POE
> +
> +static inline u64 por_set_kpkeys_context(u64 por, enum kpkeys_ctx ctx)
> +{
> +	por = por_elx_set_pkey_perms(por, 0, POE_RWX);

Guess, we would want to set the pkey index 0 only when,
ctx == KPKEYS_CTX_DEFAULT and it need to be set only once.
IIUC, we wouldnt want to deal with that every time we set a new
context. ie. update only what is relevant. 

--
Linu Cherian
 

