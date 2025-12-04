Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAF70D1D86A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 06:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1511A6B0026; Thu,  4 Dec 2025 01:17:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 128086B0027; Thu,  4 Dec 2025 01:17:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 065676B0028; Thu,  4 Dec 2025 01:17:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA27A6B0026
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 01:17:16 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 95C851331FE
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 06:17:16 +0000 (UTC)
X-FDA: 84180781272.12.3E676B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id C6D5D180008
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 06:17:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rRStUzRD;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764829034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gn1VRYVqjPDCBe/3B+3c2qEZ1R46oEbsGe4ohLKwUDM=;
	b=mZ4MZw11gfBGcLOK7PThN00cot3eQhCdBJDe3hAjereThE71w2mVR70gpVLLr9e6aV5RAc
	VCEAVfJC+W/KW6Y/J1xo5rLbvd6owulpTE6D6gKIYLpaD/35kQ0WlNGN2MaVHO1xCB1uRk
	SOcMiceS/IuY03j83WesvzQb2SBV1sQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764829034; a=rsa-sha256;
	cv=none;
	b=oxqRTePNpguYrb2ZGsffH3l0pE+qdwPIBDyieMO8WJVgPapRQhf5/ePtUkFgeN7ik1aC7e
	FN2REznEmvejnc3nGvyzaq/pXhtNMAId6YK1J1TfJCyByfYFLQbipEE91Hw5sB6ARltXAk
	uIUTAgVWNifZKALiisF8VGplwUeMT5U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rRStUzRD;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CF5B444244;
	Thu,  4 Dec 2025 06:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBAE8C113D0;
	Thu,  4 Dec 2025 06:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764829033;
	bh=Q8MUdHMvEgmjaaGlAO28ILhZXpbj6vh8gSr4j+aWy4I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rRStUzRDg7J6StefxqN06Vm3l470tFr4uFpW1lkwsXV2CHlF9G032x1MxsBtD9JlT
	 kQDVwHTeTi1uRkYUBZLXDH2im/vhjY0njrN203gT3IAcTpfmAxGMa72lSZ4+s0jduq
	 ZG6Ukj3IG3DwHWpuBKiePeewSA9ri5xvMStsLZnbEK6IFCYkJ22HgCsrduq/CoKNYN
	 fU0Qrx94BoGuQVSY1SEZ3Gkm0WxfNgt3pl072vbPl2mXFemK895uribiDls4nD1U8N
	 r1uGyYf+nomV0bFuGqyVJUdUSwpZahS6so2CHBXGx6YkplS1GWzKoqtZ9AZ26SsVtM
	 G3gf9HY/zaOrg==
Message-ID: <0b007374-1058-487c-8033-4f0d2830dc89@kernel.org>
Date: Thu, 4 Dec 2025 07:17:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "mm: fix MAX_FOLIO_ORDER on powerpc configs with
 hugetlb"
To: Shuah Khan <skhan@linuxfoundation.org>, akpm@linux-foundation.org
Cc: maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
 christophe.leroy@csgroup.eu, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, masahiroy@kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251204023358.54107-1-skhan@linuxfoundation.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251204023358.54107-1-skhan@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C6D5D180008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: 619gpmcg1i94tegg8kamuz6n9aotemst
X-HE-Tag: 1764829034-148354
X-HE-Meta: U2FsdGVkX1/66JvP6pnzhYxqH/5o40FVZmnv3rOaEVzK59jQaauQliLaGWaJWXKgJozQZMvn+0s/+lM099uJ/ny9G/1Z/I15YphjburKJguwIXVlpRU0M1nWJgicEhti0VOUIbNbey56veLWWGMJ/RrE9cFm6UyiFJQGkKuePyGdm5jFV/PKD3p6CgkQ3Hvq7TWEQOHbIxmGeANe/g+dcFKYuqvi3R1UAY09WqU8ZhTzDkbO00pbIk2G1kvF1WEXN0jutDNTYOyypYgO0Y5M6xBpuUzm8EdyeRbbmIZH4uha6cmc26a4AAi7fxNpvoYgdcntir1xeDlj7koHtBE74ATPX7dIotnCgb+jJS6FU9C4hpCBH2j/JS49gO/lMH1Ec7+gAb39BNXb9B/YWw2Tb0UvmvBOh6CtlD4rxolu0abyhoBr/OgrJaJMpQy+YRiSJ3InEFJ7qNUd231gpu5uaYOosti67bbnUv9I061j0h2Hb3TYMga0/MZ6Tk44jsFMhIpA1K5XAdfuJQmrAJZMg02VVzgNTvH9Pzpn+36LPfeEqmALUcoeOSEevCB/HJuh7Wr7D1rxHRS7oX0fYtq548UaYNwwP39lxdY7CvGkJNEeEAoPH7U7ErVQswcz7237jh4lgkr6rK0P6GKhO1qsATuDjvV0Znhydx03vyHcBz6DP19bm4HCmQiG4g3jerLtY7CHloiQsgu7L+k8FI7Pa+rVMJuY5vbShkX3drBgW8qT8aMa5He5RmqD97H6Z10T/S3IbuE34vnl+RXvyO5GPhPKJY762Y/YVNFcS8BHLYxX6EHy2XrUA3Ov/3eNxjgrujQkLhRtx8zt1mBbFQfXMr4dOXvx3gqn3u9V/9Wi3B+EA4MZYzxjpQbWQayWwnnFXU7zoLeBZui9tHkiHS1KAytKm10VsqR7Ez9lcfO1ahBtYb7Z64z0m7hZH+tX01sFXKAdzDPajJsDuDEqBoM
 VgmZ3os9
 7Yj64mp/94xpfXJVCWlLBHwrofZR7nbh4Cf5ss+2/hrHmSl8LPutnLxTI19SzusqliaWILuKerxwK3oUcpLZzyh8w5IoLph3dGm40q09AOMVkCbH44wTzwy5DynP4rKbDOcHWcyTsF9LZd6gRE4qFOo7mc3nBDs2UXEzqo+I7ccpinqk2DJn4VlZLRPmSoN6EWBch/AOB4uToM8z8yQ2bnL0fUX+R/ExRvCemLLRNgoZ2HhWNJTSfDiRiWN6YTWzD4ySfCW+RQ2oG6u1VcZC1/e1hGJIb8ml1NaEOcDzX9pIjVB5YKGhv9+PDD9iR6ykNPBHJ3YNO46ZfYg94a4b1cGr5JKG9VFgLuPh0Z4zQXhELNFLfG9iscaf1S2jF+eH6lK1pydA4LZSjbVo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 12/4/25 03:33, Shuah Khan wrote:
> This reverts commit 39231e8d6ba7f794b566fd91ebd88c0834a23b98.

That was supposed to fix powerpc handling though. So I think we have to
understand what is happening here.

> 
> Enabling HAVE_GIGANTIC_FOLIOS broke kernel build and git clone on two
> systems. git fetch-pack fails when cloning large repos and make hangs
> or errors out of Makefile.build with Error: 139. These failures are
> random with git clone failing after fetching 1% of the objects, and
> make hangs while compiling random files.

On which architecture do we see these issues and with which kernel configs?
Can you share one?

> 
> The blow is is one of the git clone failures:
> 
> git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git linux_6.19
> Cloning into 'linux_6.19'...
> remote: Enumerating objects: 11173575, done.
> remote: Counting objects: 100% (785/785), done.
> remote: Compressing objects: 100% (373/373), done.
> remote: Total 11173575 (delta 534), reused 505 (delta 411), pack-reused 11172790 (from 1)
> Receiving objects: 100% (11173575/11173575), 3.00 GiB | 7.08 MiB/s, done.
> Resolving deltas: 100% (9195212/9195212), done.
> fatal: did not receive expected object 0002003e951b5057c16de5a39140abcbf6e44e50
> fatal: fetch-pack: invalid index-pack output

If I would have to guess, these symptoms match what we saw between commit
adfb6609c680 ("mm/huge_memory: initialise the tags of the huge zero folio")
and commit 5bebe8de1926 ("mm/huge_memory: Fix initialization of huge zero folio").

5bebe8de1926 went into v6.18-rc7.

Just to be sure, are you sure we were able to reproduce this issue with a
v6.18-rc7 or even v6.18 that contains 5bebe8de1926?

Bisecting might give you wrong results, as the problems of adfb6609c680 do not
reproduce reliably.


The confusing bit is that MAX_FOLIO_ORDER is mostly used for warnings:

$ git grep MAX_FOLIO_ORDER
include/linux/mm.h:#define MAX_FOLIO_ORDER              MAX_PAGE_ORDER
include/linux/mm.h:#define MAX_FOLIO_ORDER              PFN_SECTION_SHIFT
include/linux/mm.h:#define MAX_FOLIO_ORDER              get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
include/linux/mm.h:#define MAX_FOLIO_ORDER              PUD_ORDER
include/linux/mm.h:#define MAX_FOLIO_NR_PAGES   (1UL << MAX_FOLIO_ORDER)
mm/hugetlb.c:   BUILD_BUG_ON_INVALID(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
mm/hugetlb.c:   WARN_ON(order > MAX_FOLIO_ORDER);
mm/internal.h:  VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
mm/memremap.c:  if (WARN_ONCE(pgmap->vmemmap_shift > MAX_FOLIO_ORDER,
mm/page_alloc.c:        if (WARN_ON_ONCE((gfp_mask & __GFP_COMP) && order > MAX_FOLIO_ORDER))


And MAX_FOLIO_NR_PAGES (derived from MAX_FOLIO_ORDER) is only used in a debug helper

$ git grep MAX_FOLIO_NR_PAGES
include/linux/mm.h:#define MAX_FOLIO_NR_PAGES   (1UL << MAX_FOLIO_ORDER)
mm/util.c:      if (ps->idx < MAX_FOLIO_NR_PAGES) {


> 
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> ---
>   arch/powerpc/Kconfig                   |  1 -
>   arch/powerpc/platforms/Kconfig.cputype |  1 +
>   include/linux/mm.h                     | 13 +++----------
>   mm/Kconfig                             |  7 -------
>   4 files changed, 4 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 9537a61ebae0..e24f4d88885a 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -137,7 +137,6 @@ config PPC
>   	select ARCH_HAS_DMA_OPS			if PPC64
>   	select ARCH_HAS_FORTIFY_SOURCE
>   	select ARCH_HAS_GCOV_PROFILE_ALL
> -	select ARCH_HAS_GIGANTIC_PAGE		if ARCH_SUPPORTS_HUGETLBFS
>   	select ARCH_HAS_KCOV
>   	select ARCH_HAS_KERNEL_FPU_SUPPORT	if PPC64 && PPC_FPU
>   	select ARCH_HAS_MEMBARRIER_CALLBACKS
> diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
> index 4c321a8ea896..7b527d18aa5e 100644
> --- a/arch/powerpc/platforms/Kconfig.cputype
> +++ b/arch/powerpc/platforms/Kconfig.cputype
> @@ -423,6 +423,7 @@ config PPC_64S_HASH_MMU
>   config PPC_RADIX_MMU
>   	bool "Radix MMU Support"
>   	depends on PPC_BOOK3S_64
> +	select ARCH_HAS_GIGANTIC_PAGE
>   	default y
>   	help
>   	  Enable support for the Power ISA 3.0 Radix style MMU. Currently this
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 7c79b3369b82..d16b33bacc32 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2074,7 +2074,7 @@ static inline unsigned long folio_nr_pages(const struct folio *folio)
>   	return folio_large_nr_pages(folio);
>   }
>   
> -#if !defined(CONFIG_HAVE_GIGANTIC_FOLIOS)
> +#if !defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE)
>   /*
>    * We don't expect any folios that exceed buddy sizes (and consequently
>    * memory sections).
> @@ -2087,17 +2087,10 @@ static inline unsigned long folio_nr_pages(const struct folio *folio)
>    * pages are guaranteed to be contiguous.
>    */
>   #define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
> -#elif defined(CONFIG_HUGETLB_PAGE)
> -/*
> - * There is no real limit on the folio size. We limit them to the maximum we
> - * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
> - * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
> - */
> -#define MAX_FOLIO_ORDER		get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
>   #else
>   /*
> - * Without hugetlb, gigantic folios that are bigger than a single PUD are
> - * currently impossible.
> + * There is no real limit on the folio size. We limit them to the maximum we
> + * currently expect (e.g., hugetlb, dax).
>    */
>   #define MAX_FOLIO_ORDER		PUD_ORDER
>   #endif
> diff --git a/mm/Kconfig b/mm/Kconfig
> index ca3f146bc705..0e26f4fc8717 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -908,13 +908,6 @@ config PAGE_MAPCOUNT
>   config PGTABLE_HAS_HUGE_LEAVES
>   	def_bool TRANSPARENT_HUGEPAGE || HUGETLB_PAGE
>   
> -#
> -# We can end up creating gigantic folio.
> -#
> -config HAVE_GIGANTIC_FOLIOS
> -	def_bool (HUGETLB_PAGE && ARCH_HAS_GIGANTIC_PAGE) || \
> -		 (ZONE_DEVICE && HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
> -
>   # TODO: Allow to be enabled without THP
>   config ARCH_SUPPORTS_HUGE_PFNMAP
>   	def_bool n


-- 
Cheers

David

