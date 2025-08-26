Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20F15CA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 19:36:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EFD88E0103; Tue, 26 Aug 2025 15:36:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C5FC8E00FB; Tue, 26 Aug 2025 15:36:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6035A8E0103; Tue, 26 Aug 2025 15:36:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C7FB8E00FB
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:36:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0DC02139218
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:36:03 +0000 (UTC)
X-FDA: 83819914206.04.0EF3414
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8BE80100010
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:36:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf05.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756236961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bhqILukENv/ledIyFSlAii39xkbLgWJ8CFSuI0YMkPY=;
	b=pRCnD0VDcSItNepbtW4jsRFuqvkOFQiowAAqJ79EiFbXnFXK3hr6WOPwLxfivV2sLfCzDR
	kdYlN4LlW7GB1mCmZ41B7VlNddz87grk8gI9NyETiY14qqToOmGioDT8J58tP5UWIJenG/
	FVpFKg/ozo70yx/Bv3TT/irZRrFOkgw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf05.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756236961; a=rsa-sha256;
	cv=none;
	b=d8fQP0vCTn1QmxgbkicQ+m15ZLhzgHXYouaqUYqI6e133AHpIqY/F2qPgE+EpD5HdrF9CC
	NnchG/pPDeJGfG27aGKuUTaLThkHLCy+vrbPRk/lErRLwgyYfhPodC3w+sow7PBAWLnDqX
	FmrV5ui9IHPnVEzDNx9TnOTcHamH8Ys=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E166601F5;
	Tue, 26 Aug 2025 19:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AEA5C4CEF1;
	Tue, 26 Aug 2025 19:35:47 +0000 (UTC)
Date: Tue, 26 Aug 2025 20:35:49 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: sohil.mehta@intel.com, baohua@kernel.org, david@redhat.com,
	kbingham@kernel.org, weixugc@google.com, Liam.Howlett@oracle.com,
	alexandre.chartre@oracle.com, kas@kernel.org, mark.rutland@arm.com,
	trintaeoitogc@gmail.com, axelrasmussen@google.com,
	yuanchu@google.com, joey.gouly@arm.com, samitolvanen@google.com,
	joel.granados@kernel.org, graf@amazon.com,
	vincenzo.frascino@arm.com, kees@kernel.org, ardb@kernel.org,
	thiago.bauermann@linaro.org, glider@google.com, thuth@redhat.com,
	kuan-ying.lee@canonical.com, pasha.tatashin@soleen.com,
	nick.desaulniers+lkml@gmail.com, vbabka@suse.cz,
	kaleshsingh@google.com, justinstitt@google.com,
	alexander.shishkin@linux.intel.com, samuel.holland@sifive.com,
	dave.hansen@linux.intel.com, corbet@lwn.net, xin@zytor.com,
	dvyukov@google.com, tglx@linutronix.de,
	scott@os.amperecomputing.com, jason.andryuk@amd.com,
	morbo@google.com, nathan@kernel.org, lorenzo.stoakes@oracle.com,
	mingo@redhat.com, brgerst@gmail.com, kristina.martsenko@arm.com,
	bigeasy@linutronix.de, luto@kernel.org, jgross@suse.com,
	jpoimboe@kernel.org, urezki@gmail.com, mhocko@suse.com,
	ada.coupriediaz@arm.com, hpa@zytor.com, leitao@debian.org,
	peterz@infradead.org, wangkefeng.wang@huawei.com, surenb@google.com,
	ziy@nvidia.com, smostafa@google.com, ryabinin.a.a@gmail.com,
	ubizjak@gmail.com, jbohac@suse.cz, broonie@kernel.org,
	akpm@linux-foundation.org, guoweikang.kernel@gmail.com,
	rppt@kernel.org, pcc@google.com, jan.kiszka@siemens.com,
	nicolas.schier@linux.dev, will@kernel.org, andreyknvl@gmail.com,
	jhubbard@nvidia.com, bp@alien8.de, x86@kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev,
	linux-kbuild@vger.kernel.org, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 01/19] kasan: sw_tags: Use arithmetic shift for shadow
 computation
Message-ID: <aK4MlVgsaUv-u7mS@arm.com>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
 <7e314394fc5643def4cd4c6f34ebe09c85c43852.1756151769.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e314394fc5643def4cd4c6f34ebe09c85c43852.1756151769.git.maciej.wieczor-retman@intel.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8BE80100010
X-Stat-Signature: uqq6imxo14somszdtq6ekhjgs6k9d6ha
X-Rspam-User: 
X-HE-Tag: 1756236961-298812
X-HE-Meta: U2FsdGVkX18wb2P2kEQKz64NWT3Qg7UATvW2u9V3p7uQHU53uQsRS6vq2arPsZUKi0w2vmmUFCY2dldByOUE1FAFGbgD069HQdbYyR+WbhoR7WIdwwmhAmi71ilsq7tC5mkEpXotevLiYqh0nM+SzM2oP07rIcoAR0MrdxhaJISXWJIug6zD1x8kwMsA2RzxXQt+1BhUp54GmR92xOI+I9hSIxrCGdGZ30rqnBn3jlABoF2ioIc8CVbNHibUkYeT+NpArlpPSZ25PVdYYZh3Nq6733pdg883bGiSJp49jsZWNNorRoUcM7gtsbkfJiPEeWE6T0jEj+f0VjobBaXc8CHhEnIM4Lp/+/B1+4J1YUBiNK0s99cWt56jnoDtiEcpIFxC19WJmIRg59cy423GZ2q0L0yYV88mLHI0QwBXSZuDbX+NTkXsBrl+I+wxw9hIjxGG6V5bxzLZa+4m2TPww3ZjAlhozZ2A0BYGdhGS93isDluikjSuk6IRVwGbwS4iPmFE749DwyEyUks/L0lcOGtqz/QKRxlOZtPpZWo4CQVdVc2q18o5iMsE3znWv1jRQLBbkrcNiWC/9ks+YopAf2VGoAvDZ80Is1Sx0ZwGg3d+Wxex9hYsY0CGY1hAqIt4UnEDLPHeJaFDHAS2c2A65Kxj7Ry60PFvarGsPuWJ3cAjeUsN+P+cdsXhr8XoEEw6Z8RcX6BTJK1iLLs8NX5AoTVf025j51yLW/9/chrKuYjaBAaqeMdHX5SbFkgjeaHtNFHTg9GyaiGpgh7OtSF7XqtdMEBos5iW/kZyeB34KBTO+WNvfgKBLqwEa1l7pT4bMcNvsLiNYLP3FH89wgmPikAj/FmrKb5gpnO5q8WtqKxml8ehpeu2fyE9w0BYOUNSKiWP5p10yz8p7ni6YAvvyjfA+hlUN7UU41acCmq+JHJ6LkmipnjG2TKnubn2XclQaWL+8kZdfxzAGC1jX/P
 U2QmcDkP
 vbkJofKegHMl5UkSr03cq5hDw7HnrA8J/lAaeJv3+P3WKgmCxBf2r1rjp6GBu5vBbmcEqhgN3ddDGrNmlPaucvVHlK1zgb1RJL/HESCsrs9of0RTQaCbeMoa3uLpMmXw5sugbMWCoGXQy7CZk2F9puHGqyPNx84wMOTjAksYCffW+K6P1NWWGKKMx65zjipFp45jclrQhkYBsm7XATU0C4H35NqezFtOa6virf62X1cTdcemH5NXVNFCClzzctWDOuLX3tNZCcV4Bryo5PV/oSgygoD4dycNEP/d9bS/6lJ2EWDjurJ2gfb4vpN4Pw+VfOYzb5/MjjSiLGzsqUyEnmu/oMY+4ubdfwTD9tqTLM4wX69+Y1AfiPTLqT8mPzpGu4wY9E0lQZHgDiiE5qvItbLZhHMTs1E8nbe0SGerv3Z8aCSLl4lvqjyBv4zHjX+D7jEHgu+tDVPFBoq5+fKfphczURx0OwzxLHFrDBOXMnZjIKNztX4O/hOsCy8P4Orw2cRo9BD/ATGfkLeDs2qo5HWlpTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 10:24:26PM +0200, Maciej Wieczor-Retman wrote:
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index e9bbfacc35a6..82cbfc7d1233 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -431,11 +431,11 @@ config KASAN_SHADOW_OFFSET
>  	default 0xdffffe0000000000 if ARM64_VA_BITS_42 && !KASAN_SW_TAGS
>  	default 0xdfffffc000000000 if ARM64_VA_BITS_39 && !KASAN_SW_TAGS
>  	default 0xdffffff800000000 if ARM64_VA_BITS_36 && !KASAN_SW_TAGS
> -	default 0xefff800000000000 if (ARM64_VA_BITS_48 || (ARM64_VA_BITS_52 && !ARM64_16K_PAGES)) && KASAN_SW_TAGS
> -	default 0xefffc00000000000 if (ARM64_VA_BITS_47 || ARM64_VA_BITS_52) && ARM64_16K_PAGES && KASAN_SW_TAGS
> -	default 0xeffffe0000000000 if ARM64_VA_BITS_42 && KASAN_SW_TAGS
> -	default 0xefffffc000000000 if ARM64_VA_BITS_39 && KASAN_SW_TAGS
> -	default 0xeffffff800000000 if ARM64_VA_BITS_36 && KASAN_SW_TAGS
> +	default 0xffff800000000000 if (ARM64_VA_BITS_48 || (ARM64_VA_BITS_52 && !ARM64_16K_PAGES)) && KASAN_SW_TAGS
> +	default 0xffffc00000000000 if (ARM64_VA_BITS_47 || ARM64_VA_BITS_52) && ARM64_16K_PAGES && KASAN_SW_TAGS
> +	default 0xfffffe0000000000 if ARM64_VA_BITS_42 && KASAN_SW_TAGS
> +	default 0xffffffc000000000 if ARM64_VA_BITS_39 && KASAN_SW_TAGS
> +	default 0xfffffff800000000 if ARM64_VA_BITS_36 && KASAN_SW_TAGS
>  	default 0xffffffffffffffff
>  
>  config UNWIND_TABLES
> diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> index 5213248e081b..277d56ceeb01 100644
> --- a/arch/arm64/include/asm/memory.h
> +++ b/arch/arm64/include/asm/memory.h
> @@ -89,7 +89,15 @@
>   *
>   * KASAN_SHADOW_END is defined first as the shadow address that corresponds to
>   * the upper bound of possible virtual kernel memory addresses UL(1) << 64
> - * according to the mapping formula.
> + * according to the mapping formula. For Generic KASAN, the address in the
> + * mapping formula is treated as unsigned (part of the compiler's ABI), so the
> + * end of the shadow memory region is at a large positive offset from
> + * KASAN_SHADOW_OFFSET. For Software Tag-Based KASAN, the address in the
> + * formula is treated as signed. Since all kernel addresses are negative, they
> + * map to shadow memory below KASAN_SHADOW_OFFSET, making KASAN_SHADOW_OFFSET
> + * itself the end of the shadow memory region. (User pointers are positive and
> + * would map to shadow memory above KASAN_SHADOW_OFFSET, but shadow memory is
> + * not allocated for them.)
>   *
>   * KASAN_SHADOW_START is defined second based on KASAN_SHADOW_END. The shadow
>   * memory start must map to the lowest possible kernel virtual memory address
> @@ -100,7 +108,11 @@
>   */
>  #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
>  #define KASAN_SHADOW_OFFSET	_AC(CONFIG_KASAN_SHADOW_OFFSET, UL)
> +#ifdef CONFIG_KASAN_GENERIC
>  #define KASAN_SHADOW_END	((UL(1) << (64 - KASAN_SHADOW_SCALE_SHIFT)) + KASAN_SHADOW_OFFSET)
> +#else
> +#define KASAN_SHADOW_END	KASAN_SHADOW_OFFSET
> +#endif
>  #define _KASAN_SHADOW_START(va)	(KASAN_SHADOW_END - (UL(1) << ((va) - KASAN_SHADOW_SCALE_SHIFT)))
>  #define KASAN_SHADOW_START	_KASAN_SHADOW_START(vabits_actual)
>  #define PAGE_END		KASAN_SHADOW_START
> diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
> index d541ce45daeb..dc2de12c4f26 100644
> --- a/arch/arm64/mm/kasan_init.c
> +++ b/arch/arm64/mm/kasan_init.c
> @@ -198,8 +198,11 @@ static bool __init root_level_aligned(u64 addr)
>  /* The early shadow maps everything to a single page of zeroes */
>  asmlinkage void __init kasan_early_init(void)
>  {
> -	BUILD_BUG_ON(KASAN_SHADOW_OFFSET !=
> -		KASAN_SHADOW_END - (1UL << (64 - KASAN_SHADOW_SCALE_SHIFT)));
> +	if (IS_ENABLED(CONFIG_KASAN_GENERIC))
> +		BUILD_BUG_ON(KASAN_SHADOW_OFFSET !=
> +			KASAN_SHADOW_END - (1UL << (64 - KASAN_SHADOW_SCALE_SHIFT)));
> +	else
> +		BUILD_BUG_ON(KASAN_SHADOW_OFFSET != KASAN_SHADOW_END);
>  	BUILD_BUG_ON(!IS_ALIGNED(_KASAN_SHADOW_START(VA_BITS), SHADOW_ALIGN));
>  	BUILD_BUG_ON(!IS_ALIGNED(_KASAN_SHADOW_START(VA_BITS_MIN), SHADOW_ALIGN));
>  	BUILD_BUG_ON(!IS_ALIGNED(KASAN_SHADOW_END, SHADOW_ALIGN));

For the arm64 parts:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

I wonder whether it's worth keeping the generic KASAN mode for arm64.
We've had the hardware TBI from the start, so the architecture version
is not an issue. The compiler support may differ though.

Anyway, that would be more suitable for a separate cleanup patch.

-- 
Catalin

