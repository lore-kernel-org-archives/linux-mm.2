Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8613CCD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 13:33:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4F2F6B00BD; Wed, 27 May 2026 09:33:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D00436B00BE; Wed, 27 May 2026 09:33:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEE8D6B00BF; Wed, 27 May 2026 09:33:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA15D6B00BD
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:33:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4B2B3C213B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 13:33:09 +0000 (UTC)
X-FDA: 84813290898.28.95C20B1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0949F1C0018
	for <linux-mm@kvack.org>; Wed, 27 May 2026 13:33:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DS09TTNr;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779888787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rmb4mYY/tR6wAzo9c72UaF10jDbWAFm5WdiypbDuAek=;
	b=8b+9AU5uE5lNXk/QhSmzAilkbknYcQ5+C8jX+Z7f0Dw3F0wEuEnFDhFsTfS9KMJsf5zYVs
	v3zqJIFPFKPFpjce2yukGOU4AyOgJol8b/78HFaQja2hp9PmrzdZLjFqHw0mTv8qsfioZh
	f7hlek47gcA0dBbm6jPhxCEQ13nwImg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DS09TTNr;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779888787; a=rsa-sha256;
	cv=none;
	b=jhv6HcgD1XL012Q5FkG5ZyiBxnUXjG2Irwf8bgZWycQ0zqHr59FZh+BsHl6Jq3rNGl27Oa
	TvfJ60dubgpBermzpM+wn0LODi9i11iuYTYT4rZQOJwHh5KKNQZMiFsR0MfTOuvaC+wKH5
	IlvzvHf7OXtfEDNCw743ILZTSU6t4EY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ABFD62D97;
	Wed, 27 May 2026 06:33:00 -0700 (PDT)
Received: from [10.164.19.7] (unknown [10.164.19.7])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B50A13F7D8;
	Wed, 27 May 2026 06:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779888785; bh=3ivWgqiUQpM5lpUukOrYmMpxiPpqwEREWe2J1ceJJyQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DS09TTNr6G4NjbjAXlLHBx2vUIEabRA7TZV/BDCQgkCNcsiYvXLIIen3LoIszH4I0
	 I+o57N2wxdUw2rfue4Qw03PT2fcV9LWeRF3FGViXYm0CyHoOnqTkHvkS7PdSPgZKNy
	 V2AHs3nRZMnVjFppu6E4/k3ZV1W8cH28sq13xowo=
Message-ID: <e5a59b25-d8ce-4d78-aec3-ee1b6efccfed@arm.com>
Date: Wed, 27 May 2026 19:02:55 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/3] mm: make persistent huge zero folio read-only
To: Xueyuan chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 david@kernel.org, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com, lance.yang@linux.dev,
 yang@os.amperecomputing.com, jannh@google.com
References: <20260527035607.14919-1-xueyuan.chen21@gmail.com>
 <20260527035607.14919-2-xueyuan.chen21@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260527035607.14919-2-xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kjeet3gte3u33n5uki3bi1ztobzpoc14
X-Rspamd-Queue-Id: 0949F1C0018
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779888786-250479
X-HE-Meta: U2FsdGVkX18jvCL7ZtOXDkqC5QXFwJYhfELGExvpDoLpo5QOxmXNE/YC/g8jzP5EbcGZ+3X9jfX4Op8saBGytE3yzAQkZdU5S2Zs8bxhm75rSo3rYH8xUw3rt0jm4844APvg0t34xDNC5YJhHziyn6JDRI+6RvBjGS+PlibOxMQ+heo8uJntF3qcMdwZzBjFG4KO1W+8MK/gcQoT4I3tKYIip6GKXC8oG9u72LDG0WsMEU00bz5Tqfqd2KTaCQQo4BWTSFOmd4jZ8wZSCyGZhpk40XYyC42CKT84PNZRnOcrVeveTgSn1RbX3cOdiFimA8GfXwq8R8JSlU7tV2LKi9MKu8newq0iARvl9V2BJWd495UlhBxDdJ16VRaXoRpQQ7mN+5TPwvQxU7iSb8xuqYkW+5MtpxetCyBmLSjHgPoDvZvVzZL/NdoARGcuF3G5a/wCbJS1hk2SRKl2TAB4wRzT6Du/15rUJmep9+Vtqp+SuMwxKkdeCQDf/1bFk8k69acSZG0wW7jc2p1nl7+r0MNbz1BkpTLB+5M9J7PAs3SxwW0+hpTsnqhzMXrFPG3ZhsSTgALJgLiJqhWiUkcNQA1pcmeW7M6GqaRE6THI007Hp00h2weqUxH5kg18fRhGFpTBsNGwh63eegg2IjS3qxbbb2zKnpwyJRtETWzcvuEpix8v4gSfRFWL5Oh+UHGyIVhuYCAOhVBVGnlCECSZn8NiZW+MsBZnrDqu3a/g90mByVPlaRRuWb2F33tbVbxeabbvqi0PmMGE0VlBRkepTfnmv5iOQwbV4ETWVmlyY+0iyvB0EkYw3laTqGW8QLYW05mRIOSQhU0x4hhbAALrCrI6YOvU/0EfbK6ETcT6JorSLN2Eimoo5vQap8TkoI0IUt0HQnhI1j9OHIZXYjT2WUCW0qKpx98tKT5QCk3wXZKcQSTCCB258LAb2WSUGxvsyd9uTEVjFIIWWobSKtE
 ZYJ5g5kH
 7leDtQ65ZV41pW8KK3AfL/qF2mHqVnXFqM45p2+xYkigUc/yeL35EwrZjPC2EFon/qQd9la6Ti9JyiofTVWTex+jQlepMwdVw7hCtBa5ICYxibl/xoj5Q3kJXNhYyeovdCoJhlSD46AN37zs1Jz5bBULPZNoLg3jcmVOOlpdkSNMoi8GKKXJhGS4FrT5bMP5BGp83ldncaPvxLUb/pRVBwjX73QrdtCxA8fhmd1o8Khur34D9n4o+OpCxrjCxZdLqcea086vGIzDIhhy5ziQW+UhNEXVvyGc6/QX9RHxJfcLIu2/u8WZbzvK3NScRtBxskXVef7mEdgIawxNTP4IiXUcMe2pYIaKJh+CgUIPvkREZFK//iIocxSekb6xjh1Ah8uUk4jW5PsBGg+c2mGPnQCzX3zPgAcTEXOWv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 27/05/26 9:26 am, Xueyuan chen wrote:
> From: Xueyuan Chen <xueyuan.chen21@gmail.com>
> 
> The huge zero folio is shared globally, and its contents should never
> change after initialization. As Jann Horn pointed out[1], the kernel has
> had bugs, including security bugs, where read-only pages were later written
> to. If the huge zero folio is read-only in the direct map, such writes
> fault instead of silently corrupting shared zero contents.
> 
> For the persistent huge zero folio, set this up once after the folio is
> allocated at boot.
> 
> The permission change is best-effort. If the architecture cannot safely
> make the direct map read-only, keep using the writable persistent huge zero
> folio.
> 
> While at it, mark the huge_zero_folio pointer itself __ro_after_init.
> READONLY_HUGE_ZERO_FOLIO depends on PERSISTENT_HUGE_ZERO_FOLIO, so the
> pointer is initialized during boot and never replaced.
> 
> This was inspired by Jann Horn's read-only zero page work[1] and follow-up
> discussion[2] with Yang Shi.
> 
> [1] https://lore.kernel.org/linux-mm/20260508-ro-zeropage-v1-1-9808abc20b49@google.com/
> [2] https://lore.kernel.org/linux-mm/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com/
> 
> Co-developed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  include/linux/huge_mm.h |  5 +++++
>  mm/Kconfig              | 17 +++++++++++++++++
>  mm/huge_memory.c        | 25 ++++++++++++++++++++++++-
>  3 files changed, 46 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index edece3e26985..45d1352619d1 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -5,6 +5,7 @@
>  #include <linux/mm_types.h>
>  
>  #include <linux/fs.h> /* only for vma_is_dax() */
> +#include <linux/init.h>
>  #include <linux/kobject.h>
>  
>  vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf);
> @@ -554,6 +555,10 @@ static inline bool is_huge_zero_pmd(pmd_t pmd)
>  struct folio *mm_get_huge_zero_folio(struct mm_struct *mm);
>  void mm_put_huge_zero_folio(struct mm_struct *mm);
>  
> +#ifdef CONFIG_READONLY_HUGE_ZERO_FOLIO
> +bool __init arch_make_huge_zero_folio_readonly(struct folio *folio);
> +#endif
> +
>  static inline struct folio *get_persistent_huge_zero_folio(void)
>  {
>  	if (!IS_ENABLED(CONFIG_PERSISTENT_HUGE_ZERO_FOLIO))
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 776b67c66e82..f31200816646 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -787,6 +787,23 @@ config PERSISTENT_HUGE_ZERO_FOLIO
>  	  Say Y if your system has lots of memory. Say N if you are
>  	  memory constrained.
>  
> +config ARCH_HAS_READONLY_HUGE_ZERO_FOLIO
> +	bool
> +
> +config READONLY_HUGE_ZERO_FOLIO
> +	bool "Map the huge zero folio read-only in the direct map"
> +	depends on PERSISTENT_HUGE_ZERO_FOLIO
> +	depends on ARCH_HAS_READONLY_HUGE_ZERO_FOLIO
> +	help
> +	  The persistent huge zero folio is shared globally, and nothing
> +	  should ever change its contents after initialization.
> +
> +	  When supported, mark the folio read-only in the direct map so such
> +	  writes trigger a fault instead of silently corrupting the zero contents.
> +
> +	  If the permission change is not supported, the kernel keeps using
> +	  the writable persistent huge zero folio.
> +
>  config MM_ID
>  	def_bool n
>  
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index bf9b480bb3b0..c568755dd58e 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -75,7 +75,11 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>  static bool split_underused_thp = true;
>  
>  static atomic_t huge_zero_refcount;
> +#ifdef CONFIG_READONLY_HUGE_ZERO_FOLIO
> +struct folio *huge_zero_folio __ro_after_init;


Can we guard this with CONFIG_PERSISTENT_HUGE_ZERO_FOLIO? Since
in that case too the pointer is never written after init.

> +#else
>  struct folio *huge_zero_folio __read_mostly;
> +#endif
>  unsigned long huge_zero_pfn __read_mostly = ~0UL;
>  unsigned long huge_anon_orders_always __read_mostly;
>  unsigned long huge_anon_orders_madvise __read_mostly;
> @@ -305,6 +309,18 @@ static unsigned long shrink_huge_zero_folio_scan(struct shrinker *shrink,
>  	return 0;
>  }
>  
> +#ifdef CONFIG_READONLY_HUGE_ZERO_FOLIO
> +static bool __init make_huge_zero_folio_readonly(void)
> +{
> +	return arch_make_huge_zero_folio_readonly(READ_ONCE(huge_zero_folio));


I think READ_ONCE is not required since no one is going to change the
pointer after allocation?


> +}
> +#else
> +static bool __init make_huge_zero_folio_readonly(void)
> +{
> +	return false;
> +}
> +#endif
> +
>  static struct shrinker *huge_zero_folio_shrinker;
>  
>  #ifdef CONFIG_SYSFS
> @@ -965,8 +981,15 @@ static int __init thp_shrinker_init(void)
>  		 * that get_huge_zero_folio() will most likely not fail as
>  		 * thp_shrinker_init() is invoked early on during boot.
>  		 */
> -		if (!get_huge_zero_folio())
> +		if (!get_huge_zero_folio()) {
>  			pr_warn("Allocating persistent huge zero folio failed\n");
> +			return 0;
> +		}
> +
> +		if (IS_ENABLED(CONFIG_READONLY_HUGE_ZERO_FOLIO) &&
> +		    !make_huge_zero_folio_readonly())
> +			pr_warn("Making persistent huge zero folio read-only failed\n");
> +
>  		return 0;
>  	}
>  


