Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEEE6CD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 15:15:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 031F06B00BA; Thu, 21 May 2026 11:15:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F23EC6B00C1; Thu, 21 May 2026 11:15:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E60C06B00D5; Thu, 21 May 2026 11:15:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D584A6B00BA
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:15:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 767721612E8
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:15:44 +0000 (UTC)
X-FDA: 84791776608.18.B805C85
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 90F0240004
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:15:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gemme+ZS;
	spf=pass (imf04.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779376542; a=rsa-sha256;
	cv=none;
	b=dEeU+HokbucF80vPQFgoV2X+3cN4yNBj1S487lWyun0pwMIE2zC60w0QN+uo6XiVyG+Ad3
	oBnbOslNT0wYyNbSgbpku39aUG3+N4ITaTJk7q5dVY5WPWVrUu4kmaob8zUQxEzi2FqoEO
	WstnV9boIH/IM6+JIuXp81CclUBE74c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gemme+ZS;
	spf=pass (imf04.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779376542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HcV1OwQ0Yh5akBgTJL0ME6KR+ImXNjH1xF2/GGoWG0w=;
	b=scScnLGjTHbZoesWDEA8A0ASny3OUaRirRfKOemLOgfniz2voWRUoZV1iluAsvPeNB8cvy
	HWsrdi5EIifgqdZlk4QLvxe4Buf0dLFkEnfK0pBdmtvNa/SiJ+SJBRWAMtUYeqeUKYiXF7
	cP5WxwGfAABe/6kI61jo9VO79hzr884=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 357CD4A03;
	Thu, 21 May 2026 08:15:36 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C1B0C3F7B4;
	Thu, 21 May 2026 08:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779376541; bh=MNIY+H2hz8eNtjx2NQ8oK9Y7qZVnP9XLnCR/UB41CLM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gemme+ZSaLhd4Tk3MSmYUDcqmIj6z1xhnlwkLRuTm5nUM/ZDUx6VkmyUfM7ZolbPj
	 NBeJX8Ebd5phpr1NQ0osyFWnterTKoFrCzWNmJdA8mz8Os+o04XMj5cGTydavR+U5T
	 cC0ECiFd/6DCP8krzcEyfkEC6BDi3F1/zDtxgHGA=
Date: Thu, 21 May 2026 16:15:37 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Zeng Heng <zengheng@huaweicloud.com>
Cc: will@kernel.org, akpm@linux-foundation.org, npiggin@gmail.com,
	aneesh.kumar@kernel.org, peterz@infradead.org,
	linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-arch@vger.kernel.org, David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH] arm64: tlb: Flush walk cache when unsharing PMD tables
Message-ID: <ag8hmZ3kjtJINyIT@arm.com>
References: <20260521073011.4121277-1-zengheng@huaweicloud.com>
 <ag8fHYL-S26uO0yZ@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ag8fHYL-S26uO0yZ@arm.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 90F0240004
X-Rspamd-Server: rspam03
X-Stat-Signature: 3dguptszzbhxoatbzi7uciexj11yiqiu
X-HE-Tag: 1779376542-573619
X-HE-Meta: U2FsdGVkX18/Pnd+XEq366oon34ysolSO3h/ScvsdbXyzKvyl8eu6yuxDANsY9E3ZHZMLRX+yCWKX9rbLy64jo8XKtPgxapzk/LxpCCb/xTPvLB+QIyfyhdgyhF6f+WEopem9CK/02JzwN7TAwV61nFXl4g3lbRP7v49yf4t9+gZLjWmg6vT/Eb0SCusCs4O2Dn8jiR7cPho5WYd6xgV0U3vL5qLyaVc0tHqbcbMeMI88ITU1q5UqaZ+AP892Z9p5Uh1EZDb3s82NydtGPkyaUOZCOdfsfeKKEnBNvL8Hyqbdg6kzzuaeOCBMdTBtrLcHdbzubUmkE+//BI92iRuD0EyBAD7QveL/j8aXCjGu3vYViVUsM6nFzjabBx/91DTCyPrIZF/GUBYFFho14I/yfsigOpi1Wa1C6bjasDhpsx4UgMcoxnK9R0f3r3F0ee5kqA0aW7Ru2oUPDtgJ1uW1Bf06/y2zro42ZUtp+7M35Iv0/1kzpDUUFpffwYAlkuXJ/HRxcSJolELZfBP64yZSFFd0LE00yXQe8aIPWpsOa63bF+WTX7qR9+Hv0MidErIOqh2Xdi6XLPgEUWRytTUEttU957fHh46tLmzel3xtnpH5xW9PmtV5B/yAp2PotpTSKjJQGXFilSTHOwm128fuW8uiSJGVrZdZ6YN9twbalPouFl9TsQ8bNqy1vbL00p2v1jJlKYHbv6aqJ+ChpVVfANQ0mxrGsfVctPkq4N6zIlzMlmm0RzrDKRYDWv9CN2ZB2orUvm0Di3LCmQognTw4hSMaHbrBHBvA5Mro2oIZ9Z8fjj7wkBIu4K4N/tnCOvf29/nvsDLUzfBNMUzPESdYBbll4CjJPuNLQO/CkRYkx6t4kw4sRy1oN6OEar1Q5hErYplYBRcHhMqouFt0CfHZ8aSaKAWScu30a50IYDTIrK/V1YrdoKZGZl8CPw07Dui8f/kzf4m7h+Pm32PDu/
 CwnjO7Jl
 mZ8lVySSDdu7HUzygIDswInpBY7IxBAv2hHS40Me+UZH/0qXQasixc+gRVU00q1v74I+NGcplSSdRPptZAwjkN4LYxGsSHL6JQyBhnHNZ/fsphmExNOBP5bJ1fDxwgSUT5u5CQchuOxpYckZ3npQV66rfY6QD8NUIq/EOuOjz14Mp78AF8TUCNeN2M1TdzphF/NFPn7QklIf949NCFaxtvQs7vvPwFh/tFPecgl3hjjsQVRT5jkVhaBNyC+YhzYYZP748463tgCPcHhglEzT1jla+2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 04:05:07PM +0100, Catalin Marinas wrote:
> + David H.
> 
> On Thu, May 21, 2026 at 03:30:11PM +0800, Zeng Heng wrote:
> > From: Zeng Heng <zengheng4@huawei.com>
> > 
> > When huge_pmd_unshare() is called to unshare a PMD table, the
> > tlb_unshare_pmd_ptdesc() function sets tlb->unshared_tables=true
> > but the aarch64 tlb_flush() only checked tlb->freed_tables to
> > determine whether to use TLBF_NONE (vae1is, invalidates walk
> > cache) or TLBF_NOWALKCACHE (vale1is, leaf-only).
> > 
> > This caused the stale PMD page table entry to remain in the walk cache
> > after unshare, potentially leading to incorrect page table walks.
> > 
> > Fix by including unshared_tables in the check, so that when
> > unsharing tables, TLBF_NONE is used and the walk cache is properly
> > invalidated.
> > 
> > Here is the detailed distinction between vae1is and vale1is:
> > 
> > | Instruction Combination  | Actual Invalidation Scope                         |
> > | ------------------------ | --------------------------------------------------|
> > | `VAE1IS`  + TTL=`0`      | All entries at all levels (full invalidation)     |
> > | `VAE1IS`  + TTL=`2` (L2) | Non-leaf at Level 0/1 + leaf at Level 2           |
> > | `VALE1IS` + TTL=`0`      | Leaf entries at all levels (non-leaf not cleared) |
> > | `VALE1IS` + TTL=`2` (L2) | Leaf entry at Level 2 only                        |
> > 
> > Signed-off-by: Zeng Heng <zengheng4@huawei.com>
> 
> The fix looks fine but does it need:
> 
> Fixes: 8ce720d5bd91 ("mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables using mmu_gather")
> Cc: <stable@vger.kernel.org>
> 
> > ---
> >  arch/arm64/include/asm/tlb.h | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/include/asm/tlb.h b/arch/arm64/include/asm/tlb.h
> > index 10869d7731b8..751bd57bc3ba 100644
> > --- a/arch/arm64/include/asm/tlb.h
> > +++ b/arch/arm64/include/asm/tlb.h
> > @@ -53,7 +53,8 @@ static inline int tlb_get_level(struct mmu_gather *tlb)
> >  static inline void tlb_flush(struct mmu_gather *tlb)
> >  {
> >  	struct vm_area_struct vma = TLB_FLUSH_VMA(tlb->mm, 0);
> > -	tlbf_t flags = tlb->freed_tables ? TLBF_NONE : TLBF_NOWALKCACHE;
> > +	tlbf_t flags = (tlb->freed_tables || tlb->unshared_tables) ?
> > +			TLBF_NONE : TLBF_NOWALKCACHE;
> >  	unsigned long stride = tlb_get_unmap_size(tlb);
> >  	int tlb_level = tlb_get_level(tlb);

Do we need this as well?

diff --git a/arch/arm64/include/asm/tlb.h b/arch/arm64/include/asm/tlb.h
index 10869d7731b8..3f4ab38cfd6e 100644
--- a/arch/arm64/include/asm/tlb.h
+++ b/arch/arm64/include/asm/tlb.h
@@ -24,7 +24,7 @@ static void tlb_flush(struct mmu_gather *tlb);
 static inline int tlb_get_level(struct mmu_gather *tlb)
 {
 	/* The TTL field is only valid for the leaf entry. */
-	if (tlb->freed_tables)
+	if (tlb->freed_tables || tlb->unshared_tables)
 		return TLBI_TTL_UNKNOWN;
 
 	if (tlb->cleared_ptes && !(tlb->cleared_pmds ||

