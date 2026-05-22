Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A93A2CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 10:13:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFE906B0093; Fri, 22 May 2026 06:13:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD69D6B0095; Fri, 22 May 2026 06:13:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A13336B0096; Fri, 22 May 2026 06:13:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0146B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:13:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2770E407FB
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:13:28 +0000 (UTC)
X-FDA: 84794643696.19.DD5DB8A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9D151160006
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:13:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WnPzawxV;
	spf=pass (imf08.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779444806; a=rsa-sha256;
	cv=none;
	b=52w2CkoTgwIzz2MoLsqILysB6OTRpJ0iZMlLZvnWl+WmbpkmR+ysZK7RtDaMsmtVAR+vXV
	ASHnr35PTziIfTfGAzis4cUIbBEDSFxQ9Yr8MWtRueXyHfbQapQEblpK0shd9apeL/Impy
	BhBOfYm/7Bx5/D6+g8vaGV4T/bI1vwI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WnPzawxV;
	spf=pass (imf08.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779444806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LteskIZGW5UeixZjAmhFHMTgcIbn328EvJysr5BwE5w=;
	b=rjUGwwINK2T5MVa2dSeMjEwAUEqmtqf54PBj0kRgDxazOw7YvEJ5UQ3rSCjQyBkGqZaHGk
	24xa37AVCJtY0Ksr93E02pv74vm4OlG1O6w8kMG/UkA7o/MnjjalVWea1WN5o1Ea0qOUpf
	E/7NeFOSIzLd4Gq6QrmU6q2HG4FjYEE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AC0471C0A;
	Fri, 22 May 2026 03:13:18 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 653EE3F85F;
	Fri, 22 May 2026 03:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779444803; bh=DNbpyntwF+hMLXGYG7QS6XgYK9N3tC6rW9pSIUZL2UQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WnPzawxVOZEsilVN+FrmjqG+d5EGMvtws0WvCEFdP0vTh8WmzqaQCT20F6/XSKi4Y
	 M4M+vtYWNuQY8ZNHie4OyF0sEuGltPkBQhiJ7hC+28iuovNettd25yWTfGENWI6CMX
	 oC5xoSsmgStsFj6eIQ7W50kH7UNJLX8uN3r3m4GE=
Date: Fri, 22 May 2026 11:13:17 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Zeng Heng <zengheng@huaweicloud.com>
Cc: yezhenyu2@huawei.com, zhurui3@huawei.com, will@kernel.org,
	akpm@linux-foundation.org, npiggin@gmail.com,
	aneesh.kumar@kernel.org, peterz@infradead.org,
	linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-arch@vger.kernel.org, David Hildenbrand <david@kernel.org>,
	zengheng4@huawei.com
Subject: Re: [PATCH] arm64: tlb: Flush walk cache when unsharing PMD tables
Message-ID: <ahAsPU00ZTTJV3Ye@arm.com>
References: <20260521073011.4121277-1-zengheng@huaweicloud.com>
 <ag8fHYL-S26uO0yZ@arm.com>
 <ag8hmZ3kjtJINyIT@arm.com>
 <b7098272-a348-d918-774a-d5d2645fc7f4@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7098272-a348-d918-774a-d5d2645fc7f4@huaweicloud.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D151160006
X-Rspamd-Server: rspam03
X-Stat-Signature: dco1np75e4b9ydcf8c1qpnk69uqxcqj9
X-HE-Tag: 1779444805-747640
X-HE-Meta: U2FsdGVkX1/7geu50iiMkJfytAhPDguDH/neHvjnbkwY5ElibMPFpDgLMgo8DeAxLxKIskDGAuH8E07E9hYGheLT4hricbm2j/8gARZ6s1bmVxJXIzvgK+OwlkeK+vTnFVj8B9I9onSW2oAU8/KOvx8oLovqTK+P5+4Sp1HaJLYoDf0kzEvdQlySySfCo211Fm0BcubDy3Cwwhe7wuprANco5cp0zsG2Ljnv/gw4z0mOHVGNlDTLNp+3LumAGxHm1iCYeJRm+Yi5n8S28SxisemzFusiVgMt7RaNQzyjE/oJyR5YSO75WQPm4DDuBkMmjHbIueRfgnyAwu1BoCCEIiKBgl3a/DDN3XSayPFVV8VfqfL4NBb8qLqFmDrYoGn4ewlMFoPghikQgqtSEMm5NKUDZTd7Pi0xaTkpGPb3cF56NMk6wD6REsnYiJ1Cf3YHA75G9XqLdHpeV3uywzjX0RrtdE9DUIsEBD6ABMum1P6ubnfSic25w/JqjFMzM5kpRL2G6QSLIxV/8RtI9GdhyuOH+Xo3JfYYra37ldNEgAb2AVmjsdJCYgTiOZ4kIWkwBpJFy991kAkicWQekR/BKdgsMVUo7vlX0vukWiglTylpVZCwNayhoJlV66aAaMi7976SsXvN3NOlfVBXdZ+abnWpXavjqU5qx/l0Z7FHWwpTUgbgKSAy4uqor30MzbwK23om430o+ugYTcipX5mRyiitcHP742rX+F34hm8uXz2wLxMwSHP4X46emV87GUBXTJpQPFZtdnogcur7pk2hSLLtv5KgvarJUb2vEAr/JOPF1v/l6swX90hogIwBcOHD2D1jDRp+6whoYCu7WnohzP+g+wLgIrDg7TWM/Ew0HMzV5OK6Cqhhn7cR3Y5a4Sjw648aI1wCZ27QRtCslhCe4f15DRDtAaW0wS5tD+DPUvUliYFz82Sg2fNEQ0vaFCFRupQLf+svKSuY/A422kf
 v55Sq62i
 Wfefkq8A2gqjitfHlvqAQ0v7kThM4OvdaDbDLluxPcxtJ0VHkah/mqkoVA5I0xOPKI9pqx/SzuZoQ3Cssrh2SEHqzUdZoMm1MAsa/ZOaQmhM1zdFLKiY3H8vshwcWv7EHcLTjFjvikHFEXK3oYAQTOYWmcv9QLGO0xbYSEJeJNHY9wefevxF5HmyKXho2GjSDqq97KprQJEzCq7UrBjKCTFxWZvZKokOJOkl5MuugsYV9S9pph6ym2YvINAAr2gXrYvFWrp57w+02aU0YGfb8YZQAIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 01:32:07PM +0800, Zeng Heng wrote:
> On 2026/5/21 23:15, Catalin Marinas wrote:
> > On Thu, May 21, 2026 at 04:05:07PM +0100, Catalin Marinas wrote:
> > > On Thu, May 21, 2026 at 03:30:11PM +0800, Zeng Heng wrote:
> > > > From: Zeng Heng <zengheng4@huawei.com>
> > > > 
> > > > When huge_pmd_unshare() is called to unshare a PMD table, the
> > > > tlb_unshare_pmd_ptdesc() function sets tlb->unshared_tables=true
> > > > but the aarch64 tlb_flush() only checked tlb->freed_tables to
> > > > determine whether to use TLBF_NONE (vae1is, invalidates walk
> > > > cache) or TLBF_NOWALKCACHE (vale1is, leaf-only).
> > > > 
> > > > This caused the stale PMD page table entry to remain in the walk cache
> > > > after unshare, potentially leading to incorrect page table walks.
> > > > 
> > > > Fix by including unshared_tables in the check, so that when
> > > > unsharing tables, TLBF_NONE is used and the walk cache is properly
> > > > invalidated.
> > > > 
> > > > Here is the detailed distinction between vae1is and vale1is:
> > > > 
> > > > | Instruction Combination  | Actual Invalidation Scope                         |
> > > > | ------------------------ | --------------------------------------------------|
> > > > | `VAE1IS`  + TTL=`0`      | All entries at all levels (full invalidation)     |
> > > > | `VAE1IS`  + TTL=`2` (L2) | Non-leaf at Level 0/1 + leaf at Level 2           |
> > > > | `VALE1IS` + TTL=`0`      | Leaf entries at all levels (non-leaf not cleared) |
> > > > | `VALE1IS` + TTL=`2` (L2) | Leaf entry at Level 2 only                        |
> > > > 
> > > > Signed-off-by: Zeng Heng <zengheng4@huawei.com>
> > > The fix looks fine but does it need:
> > > 
> > > Fixes: 8ce720d5bd91 ("mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables using mmu_gather")
> > > Cc: <stable@vger.kernel.org>
> > > 
> > > > ---
> > > >   arch/arm64/include/asm/tlb.h | 3 ++-
> > > >   1 file changed, 2 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/arch/arm64/include/asm/tlb.h b/arch/arm64/include/asm/tlb.h
> > > > index 10869d7731b8..751bd57bc3ba 100644
> > > > --- a/arch/arm64/include/asm/tlb.h
> > > > +++ b/arch/arm64/include/asm/tlb.h
> > > > @@ -53,7 +53,8 @@ static inline int tlb_get_level(struct mmu_gather *tlb)
> > > >   static inline void tlb_flush(struct mmu_gather *tlb)
> > > >   {
> > > >   	struct vm_area_struct vma = TLB_FLUSH_VMA(tlb->mm, 0);
> > > > -	tlbf_t flags = tlb->freed_tables ? TLBF_NONE : TLBF_NOWALKCACHE;
> > > > +	tlbf_t flags = (tlb->freed_tables || tlb->unshared_tables) ?
> > > > +			TLBF_NONE : TLBF_NOWALKCACHE;
> > > >   	unsigned long stride = tlb_get_unmap_size(tlb);
> > > >   	int tlb_level = tlb_get_level(tlb);
> > Do we need this as well?
> 
> The proposed fix has been validated against the issue scenarios and
> works as expected.
> 
> Per the ARM Architecture Reference Manual, whether only the last-level
> page table entry is invalidated is determined by the instruction used
> (vale1is for leaf entry only, vae1is for walk cache including leaf entry and
> non-leaf entry), rather than the TTL field. The TTL field merely specifies
> which level the leaf entry belongs to.

Ah, yes, you are right. The TTL is still 2 in this case for a huge pmd,
we just want the walk cache leading to it to be invalidated. So no need
for the additional tlb_get_level().

Thanks.

-- 
Catalin

