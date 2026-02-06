Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70D3EEE208C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 11:06:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 632F16B0089; Fri,  6 Feb 2026 06:06:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60B1B6B0092; Fri,  6 Feb 2026 06:06:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5168D6B0093; Fri,  6 Feb 2026 06:06:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3EFFD6B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:06:39 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DE7191C846
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 11:06:38 +0000 (UTC)
X-FDA: 84413753676.02.EB3AF5A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 32166160004
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 11:06:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PocMkmj7;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770375997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=swMtx99+ng93HYvdrYd1nTUeGrPslWx90vUU4ljumHY=;
	b=tdR4Be+doOnphN4hoJqyw7xtF6JUKsYzO51AbAOJhXlMswgYjZvz+jlLpXEQwXgivtGUl8
	dvwkkptCgmws3TiRFzxpc5ZCoTDo/UD2Ury6DAlstMbMhcJww3GHmMx4zzrFzfh6FOSaYP
	XojfGQqFi6L6nI5o7bfnC3e/2DQyQz8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PocMkmj7;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770375997; a=rsa-sha256;
	cv=none;
	b=DWo2upf5KOGN/2uCtCAlL4SYJossA/BW6Pu/Fp7xYzCg8hdCPraeBNPVCVYdk9YqJA6gma
	HQtl0r8LAHJo3UDereRDMjS8P+KD1HteuX9AQEEU1pcKMkQvJ02S4ni6cAnaO56r98Of0e
	wewK0uPFhuuRgtS0YUzXE2S+RwzvOkQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7928060051;
	Fri,  6 Feb 2026 11:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E49FC116C6;
	Fri,  6 Feb 2026 11:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770375996;
	bh=FfLhWVGDPHejmrWqxyZFCbJibVEgdoAEGrtSIPxShgc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PocMkmj7+7sN8yXHuhV/63yFz8Ku98DVQk6ZAMCytQnKdG6p6j+k3QriS+8Zmiur/
	 YO5L+sacJmF/7mrYHzJTvVLTaaB6d6nN6vO1fB1Mh9Ci76/g/f9TyRv3kISd60numH
	 EVGD7oVOT8ClRWYUpxU16WOKi7A40bZDccyIpOEciwiIr+m0e5xzsuGmzw2txucZjn
	 KJLQR2TzAidtcunf1WZXUkcjtM7Ipn5pYEPhzxUBNaAX7Hrv9rPb3+RNrz9ydFZTTv
	 afYQ5iWZHwlXPol/+rICg1T/1ZV/Cu3fagguZZnihVZWFTHM9xht08M/kJrHDBYPFP
	 9fXuNssE74guQ==
Message-ID: <a404e9ec-35ff-44b1-b321-9cc4fbf72060@kernel.org>
Date: Fri, 6 Feb 2026 12:06:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/8] mm: convert __HAVE_ARCH_TLB_REMOVE_TABLE to
 CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE config
To: Qi Zheng <qi.zheng@linux.dev>, andreas@gaisler.com,
 richard.weiyang@gmail.com, will@kernel.org, peterz@infradead.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, dev.jain@arm.com,
 ioworker0@gmail.com, linmag7@gmail.com, akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, sparclinux@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1769515122.git.zhengqi.arch@bytedance.com>
 <5ebfa3d4b56e63c6906bda5eccaa9f7194d3a86b.1769515122.git.zhengqi.arch@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <5ebfa3d4b56e63c6906bda5eccaa9f7194d3a86b.1769515122.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 32166160004
X-Stat-Signature: wrh8eijw919jbupakzs5wm6bak7jd9oo
X-Rspam-User: 
X-HE-Tag: 1770375997-337140
X-HE-Meta: U2FsdGVkX1/lR/zQTFZj5pkB32aSkWm8pdKKO16GzH38fLUpYuo7fjbg9miQpPGej/aEFtUP4jmnmHBI9szc61cYp1wPD+vU44f7jfiy5a+bIy3QYE2LlwAPII3kzt99hjLYnUoqF9C1mKNGGUq5w1WyULWUvSM379vyGCUY34kJYkBbzUhYqXSEox+GL+CpzW9uFDBHHgicFQN4GU3/E+ItRSol31c7/GljzHoWZnc5nV8BkiN1AbsJJp8bmmW5sCt7sXL5fOi2+EfsfkoHalObaBcQ8L6YPT9EdNGANmk4xzxZACeETu1qXicD7hfnsQJqcinXoYvA1MyAth5yGdeldFbgj3URzqz2FrdA3Zg5bBuUkLtmr/ct2YLyK5cM9a3OZd1U7qAvYUScKnmksGfDhIULUx1NrWK2a9M7VcM5kDZdHUpGcXUqyxh7zIuK5vCMwZhBipbVrD4pk07kHWlGyeuyL4bVsVYlUmAirYk54TWSQ4N65Lz28WkuXGZqiavnLuEKDdeOQslkjRDrbKWdgdfn4eid2+xm+94Lif9dNunFugB7+1zLwxLFYta+7b1kD0FORwaRune4craDcaOuqDP//i+C5vT65VS3WGtm7C0GSMUz1844XDRbSGz3aCAMO82k53EqRIlRHJ/3i6xb0YeP7abqjwgZrIzj402N/8khkJp5Em/0aIBg2S2EOLfdjjk2/UrpXKyIYxAOo5TDm+itsUOq/KjeAOwyKsqVO7pEtvCDkV1l+34JLcvcP8DrEkTb/1m7ElQDaOasgNRfXaNjm/42xkvz9XyPOkl/BMnLkxWER3hSrw7tASzV4tlnKW1PAIepJfbpbvpyMF0mXpLqAT4YBW9hmJQc1yao9AKzod7mM8NA+j1n08rJKoE7zxd+3AQ1r+Y0j48NH/YbMl0uBtadlN/ivRR/S8Au9uUjWncuZU6tYMdCyqD9hpsNax6f3sIqVYrpIla
 ubPMcCVo
 6ZLUMtOORXtG/O+20dUV3IO1irpvYgbdIoAb6xdtrPER6a8hQJwkL7QEwyooGzJ3xsTweL1huG+HTP8NEd4wnEVDHFudMozYbD/dDEmCzbov29VJVIpzDm2T1eNdeEnLB+ZgdpepZ/ICHaYvfKLP753LFoN6ASrtqXth/TcWqrao2Wxxqsa6zCelTk5eseKO5AyEAJeMJZ1Mml9CkBz6x3Y/bjmkVIUCfT/8vJ5JoUCbZnnFD0XPTJpDryaojtECr1a8+mrt16UhtT3Bsk6PKAE6PgdUOk+1vFoiiEFKpZWfUkfzY1e5T+xGUCXng3d0nrNN54IHhkU07Dr/+CVt6aM+RCWidiBDOsVPrUBBGn7FpAQx3PgCD6Vqf6AbcmzRMFrFlINLrnW1rqsTNl9lvg1sSVTXIuPe6bldhmlh2GdIRSL0sPD3FEuH/Lw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/27/26 13:13, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> For architectures that define __HAVE_ARCH_TLB_REMOVE_TABLE, the page
> tables at the pmd/pud level are generally not of struct ptdesc type, and
> do not have pt_rcu_head member, thus these architectures cannot support
> PT_RECLAIM.
> 
> In preparation for enabling PT_RECLAIM on more architectures, convert
> __HAVE_ARCH_TLB_REMOVE_TABLE to CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE config,
> so that we can make conditional judgments in Kconfig.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>   arch/powerpc/Kconfig            | 1 +
>   arch/powerpc/include/asm/tlb.h  | 1 -
>   arch/sparc/Kconfig              | 1 +
>   arch/sparc/include/asm/tlb_64.h | 1 -
>   include/asm-generic/tlb.h       | 2 +-
>   mm/Kconfig                      | 3 +++
>   6 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 9537a61ebae02..b47aa8fd62742 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -304,6 +304,7 @@ config PPC
>   	select LOCK_MM_AND_FIND_VMA
>   	select MMU_GATHER_PAGE_SIZE
>   	select MMU_GATHER_RCU_TABLE_FREE
> +	select HAVE_ARCH_TLB_REMOVE_TABLE
>   	select MMU_GATHER_MERGE_VMAS
>   	select MMU_LAZY_TLB_SHOOTDOWN		if PPC_BOOK3S_64
>   	select MODULES_USE_ELF_RELA
> diff --git a/arch/powerpc/include/asm/tlb.h b/arch/powerpc/include/asm/tlb.h
> index 2058e8d3e0138..1ca7d4c4b90db 100644
> --- a/arch/powerpc/include/asm/tlb.h
> +++ b/arch/powerpc/include/asm/tlb.h
> @@ -37,7 +37,6 @@ extern void tlb_flush(struct mmu_gather *tlb);
>    */
>   #define tlb_needs_table_invalidate()	radix_enabled()
>   
> -#define __HAVE_ARCH_TLB_REMOVE_TABLE
>   /* Get the generic bits... */
>   #include <asm-generic/tlb.h>
>   
> diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
> index a630d373e6453..25fa2908d6152 100644
> --- a/arch/sparc/Kconfig
> +++ b/arch/sparc/Kconfig
> @@ -74,6 +74,7 @@ config SPARC64
>   	select HAVE_KRETPROBES
>   	select HAVE_KPROBES
>   	select MMU_GATHER_RCU_TABLE_FREE if SMP
> +	select HAVE_ARCH_TLB_REMOVE_TABLE if SMP

Why the SMP? At least in tlb_64.h, it was not protected by SMP IIUC.

Apart from that LGTM.

-- 
Cheers,

David

