Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E80B5CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 15:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 306E46B00BB; Thu, 21 May 2026 11:05:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B7F36B00BD; Thu, 21 May 2026 11:05:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F5D06B00D6; Thu, 21 May 2026 11:05:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0F3FD6B00BB
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:05:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BABE51C1A82
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:05:08 +0000 (UTC)
X-FDA: 84791749896.05.71DB265
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 887F5180016
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:05:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KFzIoCPE;
	spf=pass (imf24.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779375907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3huswgNUf/BOHYyOt3fYAFM4vt9HaltyoTjrFBxGES4=;
	b=bZxFidfKKVazQ65imGkXE/p/cUFZROosQRQT/Om4fGdNx68DjDKXh+WOZqUZCiFDrty91b
	7UJAPIIFkNmASjy3dicgKQR5t62mp4U9sfEbiuBRAdRzTJbPeI+EeNFWRRbBzdKmMRCb6x
	Idpqjth1zWSefYIy8pYhBFWKIye7be4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779375907; a=rsa-sha256;
	cv=none;
	b=rKyc7xMhbzupmhdE/dXFbJswCK+Xf+q9YJy3UtIyWSh+MoYNlfR7QJnfAlTKG2mxibpj/f
	0DK9nvh5D9kKxFUUtfz1S4apgnqFV4YTxfwetw6SjpV2Q0a73MIyBI+4aVb8HP5S3A8CDZ
	EIJOYj5hS71UkPNXhrtGvsxuTe8NxII=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KFzIoCPE;
	spf=pass (imf24.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 458243AEC;
	Thu, 21 May 2026 08:05:00 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CDC6C3F7B4;
	Thu, 21 May 2026 08:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779375905; bh=Q7O9TQ82OHo1p5kXqghd2ovKAQGxVssYtzqC81EqQEI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KFzIoCPEPcx3cVuWH0SZMeEuo77BiH520eb+dYLqeaDbD/oRUXkOuPqannRIsIY2W
	 PwaKHVrvBNC0I6regX8avJTj5BiGd1Aj6A7NJVA8/UCd9HTnM2lzMd5teeqs1Cvl3Y
	 Nf0BUfFMD37qrdrXDow+8UloD884B3iKyoK9quVk=
Date: Thu, 21 May 2026 16:05:01 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Zeng Heng <zengheng@huaweicloud.com>
Cc: will@kernel.org, akpm@linux-foundation.org, npiggin@gmail.com,
	aneesh.kumar@kernel.org, peterz@infradead.org,
	linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-arch@vger.kernel.org, David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH] arm64: tlb: Flush walk cache when unsharing PMD tables
Message-ID: <ag8fHYL-S26uO0yZ@arm.com>
References: <20260521073011.4121277-1-zengheng@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521073011.4121277-1-zengheng@huaweicloud.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 887F5180016
X-Rspam-User: 
X-Stat-Signature: 8rm87wmhohu7cox7tby18muukmp4ofqz
X-HE-Tag: 1779375906-395851
X-HE-Meta: U2FsdGVkX1/Qdudi9hKIvrPQnpMCl53MupzC9JOcVCTU9AjmG4c6SW7ghPbZrJ0EIKW56MUQ6AYsKok8BkSJ9yKSCo9dwq/f2ijy2sbvNIJWo8v06YaOfz92JHI9TYN1PsX50QO3HXW8XDLSUGJs7d4xD1RIkqznsQv3u5UBJjYCxfWLW5gTntXUbQGO+YKdNrGcpJ07QJOrnnJUz+XP3X67V06kP076ABIe4EIKudZyDRA4SaQNwCB6UrL4Dyx66V+DEDtnwHOoul2VY1VsssrxOXiPxwHWaXA+qJbiAYnLXfnzP+uGpjgVMX9LmzK+u/na3ivjZqifRwIUWeLHo8Hx6ordb3gaeA1aU6PN2V8/f7i/5EugV2vp12DpUnFYyEMz5bi6JbtquC4YsH0MEEoCayBVW67x92cVIruEaDr6xabRBIeBwi4OXV1ug0Bi8HnQ72YO41L0Q5AuBQ97YMRzvCOQ5qNOQzItp2wApDZyBsNqDugfeGCNgrFZaOhekY1bf4yzprY2+1M0faux2uevRWfD+agxy8wZc+qVRfucEVZywDnAhWAQF/1HoVyezuw4JX26WX/sjWnLJc7tkMTx2gNU6l73i7dCJyicXntH3tnsDrseJmHallKux+QOGcHUgC1puGdjUrPSmBXeeBHLQOlDViUKOPoke+l+PKx05eSs42L8a9qQZc6jHf7lIrkICk+nG9yWPBGnWS39xmPvEt+d3j4/k8PtnBbHYtoedxrWKNyRglQ/cmBbXD/2/RpPGFCiTd3boYaFkxbK2rRFfrDRrxij+TdNGOrg85Wgp8oU/RfnEUcPWemWEM+yopAdJ8wJldv1jA/KerPlq0FshNzX8s+5BYmRzI4vxjlvlbeHPrxYhiLvLtH/VJZm4rasry9O2KoJf3GQSoNBQnZa5wQ05kuWH41EW3F1eSbkYHDXjy8xeZoj+5EShk5bo3lLXlDKwdS5UjyZqjb
 E2HDzheX
 u2rhUL0SzNt46IWyjFf0ShSZhWsWzujtGSKp8d+9xkmgBVSV2iiYo3V1OD6AhlPvuJU6NSbKRcZ0qWEl4tfL5PYd1/foDuBwGKJsLasDAndLfmlamuJ9BoAMfsI2T6BB9/dyZA74pVtf66Gw2ePDM9K3NufuO74xg/futRA/TrxsmwcxjIgOfMuzxftsmaeDAvJAoK6kw8Ex7PkA83sRJ+LVkbBygBT8xqXKCwJj0+rsKz7sKPNx+9mvLZGtTxbMDsuuVHqBPHjpRHygsvEzvp+Lmng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ David H.

On Thu, May 21, 2026 at 03:30:11PM +0800, Zeng Heng wrote:
> From: Zeng Heng <zengheng4@huawei.com>
> 
> When huge_pmd_unshare() is called to unshare a PMD table, the
> tlb_unshare_pmd_ptdesc() function sets tlb->unshared_tables=true
> but the aarch64 tlb_flush() only checked tlb->freed_tables to
> determine whether to use TLBF_NONE (vae1is, invalidates walk
> cache) or TLBF_NOWALKCACHE (vale1is, leaf-only).
> 
> This caused the stale PMD page table entry to remain in the walk cache
> after unshare, potentially leading to incorrect page table walks.
> 
> Fix by including unshared_tables in the check, so that when
> unsharing tables, TLBF_NONE is used and the walk cache is properly
> invalidated.
> 
> Here is the detailed distinction between vae1is and vale1is:
> 
> | Instruction Combination  | Actual Invalidation Scope                         |
> | ------------------------ | --------------------------------------------------|
> | `VAE1IS`  + TTL=`0`      | All entries at all levels (full invalidation)     |
> | `VAE1IS`  + TTL=`2` (L2) | Non-leaf at Level 0/1 + leaf at Level 2           |
> | `VALE1IS` + TTL=`0`      | Leaf entries at all levels (non-leaf not cleared) |
> | `VALE1IS` + TTL=`2` (L2) | Leaf entry at Level 2 only                        |
> 
> Signed-off-by: Zeng Heng <zengheng4@huawei.com>

The fix looks fine but does it need:

Fixes: 8ce720d5bd91 ("mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables using mmu_gather")
Cc: <stable@vger.kernel.org>

> ---
>  arch/arm64/include/asm/tlb.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/tlb.h b/arch/arm64/include/asm/tlb.h
> index 10869d7731b8..751bd57bc3ba 100644
> --- a/arch/arm64/include/asm/tlb.h
> +++ b/arch/arm64/include/asm/tlb.h
> @@ -53,7 +53,8 @@ static inline int tlb_get_level(struct mmu_gather *tlb)
>  static inline void tlb_flush(struct mmu_gather *tlb)
>  {
>  	struct vm_area_struct vma = TLB_FLUSH_VMA(tlb->mm, 0);
> -	tlbf_t flags = tlb->freed_tables ? TLBF_NONE : TLBF_NOWALKCACHE;
> +	tlbf_t flags = (tlb->freed_tables || tlb->unshared_tables) ?
> +			TLBF_NONE : TLBF_NOWALKCACHE;
>  	unsigned long stride = tlb_get_unmap_size(tlb);
>  	int tlb_level = tlb_get_level(tlb);
>  
> -- 
> 2.43.0

-- 
Catalin

