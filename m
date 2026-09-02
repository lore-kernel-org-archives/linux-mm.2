Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4581EC61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 04:39:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E66EA6B0088; Wed,  2 Sep 2026 00:39:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E17866B008A; Wed,  2 Sep 2026 00:39:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1E4B6B008C; Wed,  2 Sep 2026 00:39:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFA226B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:39:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 339221C2539
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:39:05 +0000 (UTC)
X-FDA: 85167567450.01.7E7F94A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 530164000A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:39:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uL0K6Pk8;
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788323943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/TuIAy7R2R+vWDnEH5tOb3LwFoYJyYluhSYrJLbDs80=;
	b=HVhK85XrjyF3tLKinfoGUBycNdHJolaoofN9JOEPruhx5QxFN3M7R+tF01285mC0cFFsMC
	micHVKAn8u0L1lgHnhF0rOs+9TbbWHUc9eqPrFfOhGydHWS5wouD6NugbF1fao7vkAqbq7
	4Nxv0bIy/o+FncXEeUSoTtPmMvaSvL4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788323943;
	b=ZucDK23j+/GzcAfQx+gTNa8ZjsZFBkyvWeMQTuFuFJtfpH+BjTc2aVM0SC0kPixxa5fDoR
	EDxtka+g6kR2FxtJF9R9hfEv+t4TL69SDjkE33fBKu91maV3lBgtrlAh6HsZyqeVlvFuGH
	8gfObLlM5JfGKL4PTs0i/UJQY8G1LSI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uL0K6Pk8;
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78ADE1596;
	Tue,  1 Sep 2026 21:38:58 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7692D3F7D8;
	Tue,  1 Sep 2026 21:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788323942; bh=lsYDvIHWzI7Z9foYuzRf+3oBreuXwlUShNlsSn4ADPM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uL0K6Pk8Tssm6JHp0t8VZ4HINef7UJdYngfT3+Wl0ltc3Z0oEPcirHdU2lPXKwQTH
	 Fdq8I9j6i/SHqQ7ILgZ9Bm2Fk1YEoHiN9nlM0NIl7tfOIEzvCErbM5DC0yL0MukMlF
	 U+5WcylKG0URS5kCkwvLgmPSmzaOPqyRsyPuy6NA=
Date: Wed, 2 Sep 2026 10:08:58 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: hugetlb: fix BBM for mprotect() on contiguous PTEs
Message-ID: <xwyaihtgvjonk4wqmllsnzkq2ch63bhfzmvh6353ds6tpjuaww@lmu7ltps4il5>
References: <20260901131823.15799-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901131823.15799-1-kmehltretter@gmail.com>
X-Stat-Signature: 49jsa7d79szku946du3f41g17ghff77e
X-Rspamd-Queue-Id: 530164000A
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788323943-224732
X-HE-Meta: U2FsdGVkX19bfi/1RjwcM/QbFxsoe74BhU5uwViEHowvocEDZkjL3lwzwoufcCmAYpMgPBKEIfYYx1WXXwcLuxTcioCdQynTrqsBgdAlrMxD7mtNdgSuamQBEQShJ7oBVp60k3T3WKm0s3WEbvPdc9H9QKKz98GjfzGea+j1JYXioONKtdJutn8aX3r0y9cgse7JTXp7KmxzeS754w1qHPphMY8cDRa6YUrCa3Y1dCjKfOU0iV38zZWIG9CYGk1aabjQbP7wDb6MVq7BO9pbzX2qWryacb18tzK7nQqP22se22KhgltlAJbWQAeN5wNcNWGq+id5YgmjRn6LppB3P1ZCQW2LU2NaIQ3NpBo5HbY77MUhzTY7ptjiI8yT3Tyjt0M0oDFBhKU8J4LnIB98eClY6mx/EOVAgIEcur1D7P6fEIQukp29BMqMLq2WvzGA+qNMEVlknRNktFtbKIVmMXxNdXkrtv+Vutv/i0zlicEOv2lMTegVWumOnnU5N2/JCXYSJopBIltL2hAJnMHr0odqRigjRclvh3LUBarQI6w52lFf2tHFGg3NquKlPvtYbnhFyDSiXvnbyZ9YHldvSe4F85tMEJbbN4iVUmgsv4T2G5vd0wiCp0negn8Eu8OR4AldJtQfSDaZuV8jMr9CvAKg5AKXvgpQ6gKhsiDXncxJKM/M268h9xc7uM52+INAzhHSU8u6he4vC8N9EnxU1psVnjGNxIDD1qfapS5yCBKVSlrJ7hBPEkuTnNTtlXrozhNcJ2OiG4j8wFO1SLr/VI3RLA9PuwRFGUDAtx17pbm6F1HghO3h9DoJxYbW8EeeOd6ch2rgPNPRKsTqEVqpMrduyiT+An/1SX7uLOShIdERVyFR9H/jpKA6EE3xm8ANQVHGVsfwvoU02IRItAezIUFnONpY5+7mrgN1hDC3pM9OB0n014YXiZXIWlk7TazpqmPVsRJYgBey9cS+pht
 R/VVBDEX
 r6PJrz612VmP6YsLvyuO/srIgsmZd8PNzKE4JonOvTuyWl8Zd/tGmWJNIqb7INA/crH5xI4AJ9t74JB4K9V+0fyR0ghJBup+WecvwAW+tyj0p6/uZlOS5PuoaI5wo1KxjAmVclZDLWODB/FGWQCdkdb1qiAO2YhSx38O9UEfw/A8/WbmSkKL2urz/6bu8YIh4xumTP0CCE0oS1MRSUAEJzXUv8qcaMF80jQsgk78fHRwYhBWhHr2y5lDjIQQtALbOay36ApanqB1UBdvZXTt9DNcNiTx6xJGcrgJ2v0L9URlHKRYOjlFNhYjOsjpkGJm1jXk2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 03:18:23PM +0200, Karl Mehltretter wrote:
> huge_ptep_modify_prot_start() clears a hugetlb entry before changing its
> permissions. For contiguous PTE mappings, break-before-make (BBM)
> requires a TLB invalidation after clearing the set and before making any
> entry valid again.

Agreed.

> 
> Commit fb396bb459c1 ("arm64/hugetlb: Drop TLB flush from
> get_clear_flush()") removed this invalidation, relying on the deferred
> flush from the core code. Commit 410982303772 ("arm64: hugetlb: Restore
> TLB invalidation for BBM on contiguous ptes") restored it for
> huge_ptep_set_{access_flags,wrprotect}(), since a deferred flush is too
> late for the break step. The modify-prot path has the same problem.

The commit 410982303772 ("arm64: hugetlb: Restore TLB invalidation for BBM
on contiguous ptes") should also have fixed huge_ptep_modify_prot_start()
while at it ?

> 
> Use huge_ptep_clear_flush() for contiguous entries so that the TLB is
> invalidated during the break step. Leave huge_ptep_get_and_clear()
> unchanged because it is also used by teardown paths, where the deferred
> flush is sufficient.

Makes sense.

> 
> Fixes: fb396bb459c1 ("arm64/hugetlb: Drop TLB flush from get_clear_flush()")

Probably OK as the earlier commit 410982303772 also blames the same.

> Assisted-by: LLM

So you did not actually see this problem on a system ?

> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
> An instrumented QEMU detected the missing break-step TLBI on an unpatched
> kernel and none with this change. A fork() control exercising
> huge_ptep_set_wrprotect() remained clean. No user-visible failure was
> reproduced.

No user-visiable failure was reported even without this change ?
Missing TLBI as seen in QEMU is the only clue here ?

> 
> The QEMU checker was exercised with 4K and 64K base-page kernels. The
> patched kernel passed the LTP hugetlb tests with both -cpu max and -cpu
> cortex-a72 (16 TPASS and no failures).
> 
> Testing on Neoverse N1 hardware would be welcome, as it can use the
> contiguous hint and can be configured to report TLB conflicts.

But you have not seen any real TLB conflicts even on custom QEMU ?

> 
>  arch/arm64/mm/hugetlbpage.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> index 8e799c1fe0aa..bb53a04b73b2 100644
> --- a/arch/arm64/mm/hugetlbpage.c
> +++ b/arch/arm64/mm/hugetlbpage.c
> @@ -517,6 +517,11 @@ bool __init arch_hugetlb_valid_size(unsigned long size)
>  pte_t huge_ptep_modify_prot_start(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
>  {
>  	unsigned long psize = huge_page_size(hstate_vma(vma));
> +	pte_t pte = __ptep_get(ptep);
> +
> +	/* The break step for contiguous PTEs must include the TLB flush. */

Probably helpful to mention here that subsequent huge_ptep_get_and_clearI()
in the function depends on deferred TLB flush mechanism which would not be
accurate for contig HugeTLB pages.

> +	if (pte_cont(pte))
> +		return huge_ptep_clear_flush(vma, addr, ptep);
>  
>  	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_2645198)) {
>  		/*
> @@ -524,7 +529,7 @@ pte_t huge_ptep_modify_prot_start(struct vm_area_struct *vma, unsigned long addr
>  		 * when the permission changes from executable to non-executable
>  		 * in cases where cpu is affected with errata #2645198.
>  		 */
> -		if (pte_user_exec(__ptep_get(ptep)))
> +		if (pte_user_exec(pte))
>  			return huge_ptep_clear_flush(vma, addr, ptep);
>  	}
>  	return huge_ptep_get_and_clear(vma->vm_mm, addr, ptep, psize);
> 
> base-commit: 786262be6048deab760f68c8acc2c85607165894
> -- 
> 2.53.0

Overall LGTM but will need some more testing.

