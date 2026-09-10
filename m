Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD88CC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 04:05:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C02D16B00A2; Thu, 10 Sep 2026 00:05:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD9166B00A3; Thu, 10 Sep 2026 00:05:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B16346B00A4; Thu, 10 Sep 2026 00:05:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D4946B00A2
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:05:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C44AA1C224F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:05:09 +0000 (UTC)
X-FDA: 85196512338.15.317B65C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id B80DAC0002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:05:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tCD5v4VU;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789013108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cXhFOuqDM6JUeRauAhoieNZSOIkvbDqCyTIjuUkB6yk=;
	b=IJJ7mRZZMtCEfrYNNNf6amHW/Ksu68IAoOzGekjHmS7QUNSGHUk7TvxmFR5joZgTk02zCx
	/R35kpPF+yK4vuLqR1JKOQij0b77GlVc/mWwh0Xi3W6NX45XZQ2EtWAj5n0zC56GHh4LIX
	o7UEl/Coirtzky2nzJaXzkI0vzGuRpc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789013108;
	b=xaMla5ZULAZCO1+g/wOosyFuEaaS8InCQktuUuO1vJ9wF8SeUXM+5q97lypx4CSUAn6Cv3
	Sd5NyrS0IFyQWAPQVheI77COTXLiaEGzP4Mq4wslziCYLoIVimSNNktd2f90ziDTZXsJPb
	5T6wvAThlsCLEDSHTkUVB92sor8+37s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tCD5v4VU;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC607153B;
	Wed,  9 Sep 2026 21:05:02 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DAB983F7B4;
	Wed,  9 Sep 2026 21:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789013106; bh=rAWrnAEYwtxB463a6X/NBqTWvXFmxUTkIqzzvCsxG78=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tCD5v4VUvLSUKDwb09dHubBqZMyi0aXPHA7yJz72TlE/XLQq4uYoYeyVilQgXOZKc
	 UZ9s09iK+VC5GbdAALOudg5bQ05HkZVwdMpybiLdve6B2m/peyyq3TQ4200H8aRkIN
	 rt3JRDGreOcdVN26eSoiOLR5jUGp1QSoUaQLEVWQ=
Date: Thu, 10 Sep 2026 09:35:03 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH V2 1/2] arm64/mm: Move __check_safe_pte_update()
Message-ID: <u3uvjnmd7k7f7dijdvsykta3pcxyxhvztncu4apvg5eb6rvtyh@kmdgfebs6dns>
References: <20260909040005.4148136-1-anshuman.khandual@arm.com>
 <20260909040005.4148136-2-anshuman.khandual@arm.com>
 <04358f9d-3b64-47c0-94dc-f1ef19c22f78@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04358f9d-3b64-47c0-94dc-f1ef19c22f78@kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 8469yjwwwi5fcfrzrrzbyz1gor131e95
X-Rspamd-Queue-Id: B80DAC0002
X-HE-Tag: 1789013107-744975
X-HE-Meta: U2FsdGVkX1/akjAXvSu0E1gWqSudUH5X5OSzQrq4TC1eC4E5jXxrzlnRU4kYqvJzjwg8Ho62Dy5kBuTKHCPt65+V6f2MB/u6mF0L7Www00wiqV5qZoQ7utaNXwmDQNo8bvujZB2YY9npjVYAcflhXf6ICyyRTKX+O4JiRM+0lPpdHNG5Z38XN5gFXDgl+hOWjUJZK/00M4qOPjbhwb27K/ibIvVj0wzCk95Ocx26p26/8Xud97BsE3wM+KvxNGr5FkqSnLgPTt6o2XGWUmApGVJvnkQDYkRWI4GJKhFQGN5iiXWsBeED1BIZ+7BNM7PuF4KAPfwxNWM+Z1tUjSlx73j7VdZFk6Z3A/azzz6IwGRVaV+k1WB6uOuWNyGLkoRkdZdHabdEph7hlsvt4MQktxgrbf7iUV8P1NOGrqQme1JVexmQgwDH2xEdrw0esjKlMZB1ozfPLsx4Agc2UufppbljIrnyR7BXQhwduPKBP8bamRYWAzlfDGgxZHf4qXHOzEORtqBi2zQNdMm/w9aRYUpLEVzBbXQGJAvZYj+/LYy3X8T/piiqG8rHYfbGY3IiWWKKItUTyQNDvOob0saThW55sSK7YEjX2B30cnBBWXoCoCAk1KPaZEdAb2+rlB0yX5uGyEACoAB3lPsq+X5dpv0xAztfAOXnRqBptQyOUJ3DKUnLL8X10XybsmBydMcMFaIb1JuVlFXawTIv3zPnA7VnNlyaOv4xKWWH49/UsH+ScG8Oq8qqT0fBE1NZCD6D1KtkbIRjimGqcmbOrFaVIUcc7/SV9x+CAbhFo9XTfpkfppWh8m0gMn+wW3BOZnOEnZ2iWpjjkX1GhMtv87QshB0Vli+e6WKib1VF2Hg6ki+yDAsHpgkdnHiJgqQPQXR8VaTby0hpvO9Nh4MRi7Y75RDg/e87sKMo44C2G//1VqghOUSieE9wG395oEyabuoXqnQ6UF/3vrdcwab5XCW
 Tgfshitf
 xTDnOr7d/dyUnCJCi9E4llgcypDkaNn3z4JMEPtSxeCh9Y4HHAI7YBFL+dHlSs6FJzHNQ3S7SvhVq2P1/8GScJUb07vwsDZg1PkykN1AVubzPe1M70DkpEfWUyXiMHW/j4pvNzOlMKMV0GDpQjcOXEdyeHzjCrDsWtFDti9LkzwqKzURa2ZqMd0dWeCEeKxTw9szVEHmtwvem+c8xcw5rFhuyFLFf5YyTle+5NqMYTwt8EW6zY19OnrDKYQMS64MJpaDlXHLcJg4KRPPK1ME2Gk1vbhBkWD5Ct2dOiCkyruwWvxTJv55Fc+0uzJQ5z1jxJk/wZZgpv6JQajKZOgaBS9il8ZY096n/wZr2MbE/PzrVd2n7qz0t2Fx9eJnm0rCCEU17OvdTDo10w+fFvuQQGev7cB1yePqOGLu7kSrHpVfO5689G+1TYGjGIRgU9DKsrzyY9mntAi8xbp5qSWeVLwZl1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 05:12:24PM +0200, David Hildenbrand (Arm) wrote:
> On 9/9/26 06:00, Anshuman Khandual wrote:
> > The page table entry print helpers and related macros which are defined in
> > <linux/pgtable.h> will not be accessible in platform <asm/pgtable.h> which
> > is basically caused by cycling dependency.
> > 
> > Move __check_safe_pte_update() inside arch/arm64/mm/mmu.c as a preparation
> > for subsequent usage of the afore mentioned generic MM helpers. While here
> > drop IS_ENABLED(CONFIG_DEBUG_VM), although wrap __check_safe_pte_update()
> > inside #ifdef CONFIG_DEBUG_VM that preserves the current code optimization
> > which is achieved via the static inline functions.
> > 
> > This does not cause any functional change.
> > 
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > ---
> > Changes in V2:
> > 
> > - Moved __check_safe_pte_update() inside #ifdef CONFIG_DEBUG_VM
> > - Added empty stub for __check_safe_pte_update() when !CONFIG_DEBUG_VM
> > - Dropped IS_ENABLED(CONFIG_DEBUG_VM) from __check_safe_pte_update()
> > 
> >  arch/arm64/include/asm/pgtable.h | 49 ++++----------------------------
> >  arch/arm64/mm/mmu.c              | 44 ++++++++++++++++++++++++++++
> >  2 files changed, 49 insertions(+), 44 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> > index e89ec5f4787b..281a512f1fc6 100644
> > --- a/arch/arm64/include/asm/pgtable.h
> > +++ b/arch/arm64/include/asm/pgtable.h
> > @@ -387,52 +387,13 @@ static inline pte_t __ptep_get(pte_t *ptep)
> >  extern void __sync_icache_dcache(pte_t pteval);
> >  bool pgattr_change_is_safe(pteval_t old, pteval_t new);
> >  
> > -/*
> > - * PTE bits configuration in the presence of hardware Dirty Bit Management
> > - * (PTE_WRITE == PTE_DBM):
> > - *
> > - * Dirty  Writable | PTE_RDONLY  PTE_WRITE  PTE_DIRTY (sw)
> > - *   0      0      |   1           0          0
> > - *   0      1      |   1           1          0
> > - *   1      0      |   1           0          1
> > - *   1      1      |   0           1          x
> > - *
> > - * When hardware DBM is not present, the software PTE_DIRTY bit is updated via
> > - * the page fault mechanism. Checking the dirty status of a pte becomes:
> > - *
> > - *   PTE_DIRTY || (PTE_WRITE && !PTE_RDONLY)
> > - */
> > -
> > -static inline void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep,
> > -					   pte_t pte)
> > +#ifdef CONFIG_DEBUG_VM
> > +void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte);
> > +#else
> > +static inline void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte)
> >  {
> > -	pte_t old_pte;
> > -
> > -	if (!IS_ENABLED(CONFIG_DEBUG_VM))
> > -		return;
> > -
> > -	old_pte = __ptep_get(ptep);
> > -
> > -	if (!pte_valid(old_pte) || !pte_valid(pte))
> > -		return;
> > -	if (mm != current->active_mm && atomic_read(&mm->mm_users) <= 1)
> > -		return;
> > -
> > -	/*
> > -	 * Check for potential race with hardware updates of the pte
> > -	 * (__ptep_set_access_flags safely changes valid ptes without going
> > -	 * through an invalid entry).
> > -	 */
> > -	VM_WARN_ONCE(!pte_young(pte),
> > -		     "%s: racy access flag clearing: 0x%016llx -> 0x%016llx",
> > -		     __func__, pte_val(old_pte), pte_val(pte));
> > -	VM_WARN_ONCE(pte_write(old_pte) && !pte_dirty(pte),
> > -		     "%s: racy dirty state clearing: 0x%016llx -> 0x%016llx",
> > -		     __func__, pte_val(old_pte), pte_val(pte));
> > -	VM_WARN_ONCE(!pgattr_change_is_safe(pte_val(old_pte), pte_val(pte)),
> > -		     "%s: unsafe attribute change: 0x%016llx -> 0x%016llx",
> > -		     __func__, pte_val(old_pte), pte_val(pte));
> >  }
> > +#endif
> 
> [...]
> 
> > +#ifdef CONFIG_DEBUG_VM
> > +void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte)
> > +{
> > +	pte_t old_pte;
> > +
> > +	old_pte = __ptep_get(ptep);
> > +
> > +	if (!pte_valid(old_pte) || !pte_valid(pte))
> > +		return;
> > +	if (mm != current->active_mm && atomic_read(&mm->mm_users) <= 1)
> > +		return;
> > +
> > +	/*
> > +	 * Check for potential race with hardware updates of the pte
> > +	 * (__ptep_set_access_flags safely changes valid ptes without going
> > +	 * through an invalid entry).
> > +	 */
> > +	VM_WARN_ONCE(!pte_young(pte),
> > +		     "%s: racy access flag clearing: 0x%016llx -> 0x%016llx",
> > +		     __func__, pte_val(old_pte), pte_val(pte));
> > +	VM_WARN_ONCE(pte_write(old_pte) && !pte_dirty(pte),
> > +		     "%s: racy dirty state clearing: 0x%016llx -> 0x%016llx",
> > +		     __func__, pte_val(old_pte), pte_val(pte));
> > +	VM_WARN_ONCE(!pgattr_change_is_safe(pte_val(old_pte), pte_val(pte)),
> > +		     "%s: unsafe attribute change: 0x%016llx -> 0x%016llx",
> > +		     __func__, pte_val(old_pte), pte_val(pte));
> > +}
> > +#endif
> 
> #endif /* CONFIG_DEBUG_VM */
> 
> Might be helpful here.
> 
> Consider the same in the case above

Sure will update the same both in here and also for the declrations
in the header file as well.

> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks for the review.

> 
> -- 
> Cheers,
> 
> David

