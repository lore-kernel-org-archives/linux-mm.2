Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3972C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 00:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A732E6B0088; Thu, 27 Aug 2026 20:22:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FD756B008A; Thu, 27 Aug 2026 20:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C5246B008C; Thu, 27 Aug 2026 20:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 643286B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 20:22:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DDA55C0233
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:22:21 +0000 (UTC)
X-FDA: 85148776482.25.96E41C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3DA3614000C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:22:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Esu5YeSZ;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787876540;
	b=JBc1g4UyuYeQocwgHiPi8jpUUSWuUNrj5RIzjYI8m52o7cnRsYpeAbKe3VqQoUXoYckRKW
	bgvYL+fgtVGsWgBifxql6ilOGY82fgBCiSfsOWHIrLJKPYqeROOBfVO5YWyWutpbyV9dkU
	vGenzXYvwSl3akJcJCR0DmuRkHKZqSU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Esu5YeSZ;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787876540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uuq5TYRcr4zdL+6SIrH3ElNXfBDv1DRk+u7g+8PVaIk=;
	b=RwUYRZnULaNuYBdb8TEjY1DgCMQmP+1FFLJG1qAj8CFsDW94ram3KFLDpvRFe1PFCHsyoI
	aGCmIcFRoKpBFNkHFqSDzHUoBtBWjTJp1L4caf5TwkeFbo1cEhnNgBn9Wlzr/PX1XDp5yv
	bLLHdjaY8ct934Za0g5NGxuGTXxP6ZA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 834F4601F5;
	Fri, 28 Aug 2026 00:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B511F000E9;
	Fri, 28 Aug 2026 00:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787876539;
	bh=uuq5TYRcr4zdL+6SIrH3ElNXfBDv1DRk+u7g+8PVaIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Esu5YeSZSNMWD9tBCB8DahS8k8M9uqUSF5bWl3RuhQKyrW/PTxWvALeZxk/QiIJA7
	 dZcm28dZW0IuSJKS3UniMrmUvEkrZtD06Fz+uw6dnV0Wb9OOssMzvRLwi3ehtI4PL+
	 KSEe+MxE40XZnFyBcb3dlPQvBv35/2kTqJUUy4imkkpf/UGnkkPlNvZ3DrK4AjtWjl
	 Nmg7vjm4DOG5somXIcNo2QbAYYbQX3a1ZdYHOPBiBBpH6H6CjJcTbKmGH95CKe0CwC
	 ZMHnKr/ONgrLy1woPLtV/lCmbnF2jTy11iDBMHDOHrO5ioIGtdNXiGrh7vResI7Rag
	 LdmKd3XSZI6HA==
From: SJ Park <sj@kernel.org>
To: Nathan Gao <zcgao@amazon.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	baolin.wang@linux.alibaba.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon: use a page-aligned sampling address
Date: Thu, 27 Aug 2026 17:22:11 -0700
Message-ID: <20260828002211.61987-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260827193821.46115-1-zcgao@amazon.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: p6uixh3st3bnk6qe578ginapo9nrug77
X-Rspamd-Queue-Id: 3DA3614000C
X-Rspamd-Server: rspam06
X-HE-Tag: 1787876540-287752
X-HE-Meta: U2FsdGVkX1+xcvFxHrXnKiFTzf8nggUE21XHfyH2UVonp2uSTpjwCLIsoiYTt4FQIk501uP9I/SA1IXZ6ZpL6XaNrBPVJHg8X3iX/fGmX8Vmb7PZ7dpdJ1a0wp1OTExrh/2Y9Yy7Slo08+aqy51IlKMRpDv586+wHLuNuxiF/ByK4BMKiihfZivjRoIMXZWLZQe9WbgGGkyW6/ETVxnOjZ0/cLl23RlcjS6vMI1S/H9eUoaA+u+niqYMo6RVCt+B2XXwu2qtXbVO+jVV/yv7gZdpRZHH5RcQ7IMHpIdYxZV0Bg8d4SCoeuoI2LV6+bPV9iudcZefVdOtMjOTr1dRTTFHJlb+J9hwVW4n7QKux0U4U25Xt1Jt722vLGSsx13HCQcHvoCQMSiKvGqyjHQoY3LnoJi56agqVqJNcu/35rFtA2xHe8XOU4dxWWSg/CbWiJP2eFklYYDN+wLdM5LYdpNeybcHOP7vkkJ8VGsSTmDSMZzIc7Mmekl7VvqeXs2B4QElSUE0G2BkNyR8w+2yCiRAUK0IuIcnUEG50farXwvrbh3pIHSKarGCrj/IHNTnWw/DdC1RPD3MAZR/7dmbgG4S40XJ3XgK+hQ5L14e4/kop2kCBI0q7M6wNeRo0pQsFvCVnShCArCwsbxmhhXsdxO6xx38ChLg17lhUKfRxMiRrB0DN/GGrTLUAPznm0WhS54F4A0V+NW+lS//mR5zzhqMgaD9Pd5W2BhWtTDrwH8UpM7bg2vnRZ85014ywZEMWEV2A6ziiP4K9dzhSzADJoiWnR2iz/xZQ1O9PJVAatOg6SH2DyUfboS5gXnBcBdEVck2aKW0feotIgWSpP/U2/Cx1+Pv/3QoqQ7vd4yMXojSqpkP2eKsASgkrhc9o6pZxwxUn3e8CKy66P1SwzQRA1IwqP14gpPwxaj3f5acvDWMVTfqsn8rBqkIuLJwUQuLwI1AQPfGROHU5p9ylPk
 0eq8PaiS
 QydkKWHVIU5WS/701D6ivtoRzHEjsXoG/JqnejOYs4K6E+lYz9jSHdJlEg9xXxHsJ1ryeG+J8JWYUgOkYHPh1nkTtP9zIOJojPrZWxh8et+hkQ0iVhM0dbjpEy1vL4BrTx5HVCs948cPLcWDzhr4nrl6BwIYzJb5KfnTZSubzqa3PW8rq8B/cHtCFP9iC10qKHBRwIfYBbIXxpC0RnCXIHofDfzFHfhlMfC5qHoACdyrEcvnf7hhhZvTcRJ84F8coLZG+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Nathan,

On Thu, 27 Aug 2026 12:38:21 -0700 Nathan Gao <zcgao@amazon.com> wrote:

> __damon_va_prepare_access_check() picks a random byte address within the
> region and stores it in r->sampling_addr. There are two users of
> r->sampling_addr in vaddr.c that pass it into a page table walk, and
> both use it as the address of a page.
> 
>   damon_va_mkold(mm, r->sampling_addr)
>     damon_va_walk_page_range(mm, addr, addr + 1)
>       damon_mkold_pmd_entry()
>         damon_ptep_mkold(pte, vma, addr)
>           ptep_test_and_clear_young(vma, addr, pte)
>           mmu_notifier_clear_young(mm, addr, addr + PAGE_SIZE)
> 
>   damon_va_young(mm, r->sampling_addr, &folio_sz)
>     damon_va_walk_page_range(mm, addr, addr + 1)
>       damon_young_pmd_entry()
>         ptep_get(pte)
>         mmu_notifier_test_young(walk->mm, addr)
> 
> test_and_clear_young_ptes(), which backs ptep_test_and_clear_young() on
> arm64, documents @addr as "Address the first page is mapped at".
> 
> For arm64, before commit 6f0e1142173a ("arm64: mm: support batch
> clearing of the young flag for large folios"),

The @addr documentation is also introduced by this commit.  This commit is
authored at 2026-02-09.

> the contpte helper walked
> exactly CONT_PTES entries from the aligned-down page table pointer and
> used @addr only to pass down to each entry, so an unaligned value was
> harmless:
> 
>         ptep = contpte_align_down(ptep);
>         addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
>         for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)

So, there was no issue before the commit.

> 
> Now the range to walk is derived from @addr instead: end = addr +
> nr * PAGE_SIZE, rounded up to CONT_PTE_SIZE. For a sample in the last
> page of a contpte block, the sub-page offset puts end just past the
> block boundary, so the round-up lands a whole block further and the
> walk clears PTE_AF in CONT_PTES entries beyond the sampled block. Seen
> on an arm64 guest running the DAMON selftests as random slab and page
> table corruption.

Thank you for sharing the finding with us!

> 
> Align the sampled address down to a page boundary. It is the address of
> the page to sample, so this matches its intended meaning and fixes both
> users in vaddr.c.

This indeed sounds like can fix the issue to me.  However, was it a clear rule
that we should pass only contepte-aligned addrss to
ptep_test_and_clear_young()?  And is DAMON the only ptep_test_and_clear_young()
caller that is mistakenly passing the unaligned address?

If not, it might make sense to make contpte_test_and_clear_young_ptes() support
unaligned adress again in my opinion.  May I ask your opinion, Baolin?

> 
> Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")

I think 6f0e1142173a ("arm64: mm: support batch clearing of the young flag for
large folios") would be mroe correct 'Fixes:', if there was no issue before the
commit.

> Cc: s6f0e1142173a ("arm64: mm: support batch
> clearing of the young flag for large folios"),table@vger.kernel.org
> Signed-off-by: Nathan Gao <zcgao@amazon.com>
> ---
>  mm/damon/vaddr.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index 2c1c1952c008d..e26e426a56af2 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -360,7 +360,8 @@ static void __damon_va_prepare_access_check(struct mm_struct *mm,
>  					struct damon_region *r,
>  					struct damon_ctx *ctx)
>  {
> -	r->sampling_addr = damon_rand(ctx, r->ar.start, r->ar.end);
> +	r->sampling_addr = PAGE_ALIGN_DOWN(damon_rand(ctx, r->ar.start,
> +						      r->ar.end));

If we need to have the fix in DAMON, this kind of change would be needed.

However, what happens if the address is backed by large folios?

Before the commit 6f0e1142173a, also, it was aligning to CONT_PTE_SIZE.  Should
we do same?

Also, I think we should pass aligned address to only the functions that
require alignement.  Making the alignment to the sampling address in general
sounds too much to me.  Particularly, we are working on supporting new page
access check primitives other than PTE Accessed bit, like AMd IBS.  In the
case, we might support <PAGE_SIZE granularity monitoring.  Aligning sampling
address in general will make it more complicated.

>  
>  	damon_va_mkold(mm, r->sampling_addr);
>  }
> -- 
> 2.50.1


Thanks,
SJ

