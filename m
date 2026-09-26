Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EEACC98318
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 09:51:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64C926B0088; Sat, 26 Sep 2026 05:51:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FD536B008A; Sat, 26 Sep 2026 05:51:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EE8A6B008C; Sat, 26 Sep 2026 05:51:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 22FFE6B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:51:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 977DD1607C2
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:51:53 +0000 (UTC)
X-FDA: 85255446906.11.4DC37E5
Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
	by imf17.hostedemail.com (Postfix) with ESMTP id 65D1B40004
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:51:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of tsbogend@alpha.franken.de designates 193.175.24.41 as permitted sender) smtp.mailfrom=tsbogend@alpha.franken.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790416312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jLm14wwT78D3fRqE14YsUEacOjW5oSmhj5QH3Xv7xTE=;
	b=kyFkTFJ8PYwn57UNfZNrMdJVtBkYp0ON5qTtHpQREj2hXwPwj2uRLNvoz2GU75L0pfdkiV
	Wi+EpRR8OoKStiOUbyXaDmfsm//j9OI7iufPwTPEKS6nZfjnIUwow5lNdpakUfOifUHnRv
	6xjNXogL8bAtxY5w+81gylWnMtAPcD8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of tsbogend@alpha.franken.de designates 193.175.24.41 as permitted sender) smtp.mailfrom=tsbogend@alpha.franken.de;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790416312;
	b=7ynTPhfWhM7/n2i2etujxXUMcV58anE7nYOYB92aKRGzw8P/8xH35XUFOxrHALXbigmSiu
	Dnzh7O9DlitbTUH5yPDYFwKe6Oyz+ALuIdjV4I1QNEMBfTaBxMJ3e6XZ6qRCoFjzhTPsjF
	hTO12UDWivQIGH2YbTc+RUJEXPKnHcE=
Received: from uucp by elvis.franken.de with local-rmail (Exim 3.36 #1)
	id 1xAP4O-0007LN-00; Sat, 26 Sep 2026 11:51:48 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
	id D0EB9C0C84; Sat, 26 Sep 2026 11:37:12 +0200 (CEST)
Date: Sat, 26 Sep 2026 11:37:12 +0200
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: Orgad Shaneh <orgads@gmail.com>
Cc: linux-mips@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, osalvador@suse.de,
	stable@vger.kernel.org
Subject: Re: [PATCH 2/2] MIPS: mm: do not write a huge TLB entry when the
 probe misses
Message-ID: <areSSGHptMhgnXQ3@alpha.franken.de>
References: <20260915071329.15125-1-orgads@gmail.com>
 <20260915071329.15125-2-orgads@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915071329.15125-2-orgads@gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 65D1B40004
X-Rspam-User: 
X-Stat-Signature: nug6i71dpzyfyyc9sbua56twmbgc6inu
X-HE-Tag: 1790416311-425193
X-HE-Meta: U2FsdGVkX1+XfZZVxqDQ+zr143qJWbmS7CBjzLm+EfmRatuszGaPGoQBktq+l5CW3W1GnJcdO/MBD+1cuAqJsaQAHyPCXB1hw+v6S8f5CUptCLfVVjl+xwoXTEGdSnsjDuQnTTWllFvwvLvfYBc1ew0Njt2OxzCJk8urZVJc1KMoR9L2ixHuzG8ct2TsZiPRfTGIZ+q7v/likQVj/0Of2EQfQyKmWbeTFLlBqcdfy/SiCFSSj9R2H4Mgq/eMKI5k3qSEyv+yl0IgUmWxzXoTWmb70GDUB4xD6u56VIGHbiCl1sJm+n58B4xVWvNi6PWJshbhVrh5Jsb4ygcxVpnKHRfLqmmWR92opxIZziqqRzb5HMmTq7C7y4TK8+xxCzMErdl5kMl0w6AqugGx5M1Ajx2kKifkXvW1M7AtG0gIVDoRBswvYV9zhCC9nNtnczLLXBsQOYdo94AcjmOQdTeJR+wT3zLE4mTs8jrrHjzzczEmkCRjQcgm00i8P3A7Y6WoCP3dQ5n8eohXek/6TSqylHZID1wwLQ4v7kCtmaoSlBE5G4nvWOSYcuiTkbAFIQou3gZn+TilPokliCL8jf8nfSrM32MOFU1d3crBqkGRIYCs9TtuVKoaSn4aQTExzMDgTagB7lU4p8aIncvLYt6LJwBxk3oi1M2Q3X/xAlKGXSQ9PdeAsuS7Gn8cwUT3Sbn11H1kFvPAcC0Ufh5yGGBwRwxdzJklBEKp3gva+K4lGT4ZLBJt/EUQzm/LgT/yz3Xi5xH9nYlnEvO63kkx6TWUZXL7xwEBtGxmKOHKDLcpdQHJXlGW76g2jFd/UbWVMt+8yH6mpPw+5p73dZBexTv4kfinpVRmD9xu3lpkN2aFw9QHPTnNy45oIYa6Tfh6CtWE6+D/9Zl/k4IW0s5TdRjxtJL4lYoRX9Vl7MPH2ZNcJP1M6tRK1AOX2vm9E+/mfLsDTlVDzuJMwcgZlw2+QXa
 7K8eg287
 9/W+6Y2FlEl9f8Ctm47aGjcEIfcmmxFiwVbTUQP4m59e8JqSCiGgySg1cvPtCd2zD3hxrIv6J+ZZFZGSiWla4OWqoJ8kYZ8YAaMly
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 07:13:25AM +0000, Orgad Shaneh wrote:
> __update_tlb() probes for the 8K pair at the address it is given and,
> for a huge pmd, writes the huge entry with tlbwi at the probed index or
> with tlbwr when the probe misses. That works only if the caller passes
> the faulting address, so that the probe finds the 4K entry the refill
> handler loaded for the faulting page and the huge entry replaces it.
> 
> update_mmu_cache_pmd() is not called that way. do_set_pmd() has always
> passed the huge-aligned address, and since commit ebcfc63d6bca ("mm:
> abstract THP allocation") the anonymous THP fault path does too
> (map_anon_folio_pmd()). The probe then misses the stale 4K entry, which
> sits at the faulting page somewhere else in the 2 MB range, tlbwr adds
> a huge entry next to it, and the TLB holds two entries matching the
> faulting address. Octeon raises "Machine Check exception - caused by
> multiple matching entries in the TLB" on the next refill of that page;
> a process on a CN63XX board died this way within a second of start, on
> the first anonymous THP of its bss.
> 
> Skip the write when the probe misses. The refill and TLBL/TLBS handlers
> probe the faulting address themselves and rewrite the stale entry with
> the huge one (they also set the software young bit), so the entry is
> installed on the next access at the cost of one exception.
> 
> Fixes: fd062c847a8c ("MIPS: TLB support for hugetlbfs.")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Orgad Shaneh <orgads@gmail.com>
> ---
> diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
> --- a/arch/mips/mm/tlb-r4k.c
> +++ b/arch/mips/mm/tlb-r4k.c
> @@ -332,6 +332,19 @@ void __update_tlb(struct vm_area_struct * vma, unsigned long address, pte_t pte)
>  	/* this could be a huge page  */
>  	if (pmd_leaf(*pmdp)) {
>  		unsigned long lo;
> +
> +		/*
> +		 * The probe above only covers the 8K pair at @address, and
> +		 * a huge mapping is installed with the huge-aligned address
> +		 * while the refill that started the fault left a 4K entry
> +		 * for the faulting page elsewhere in the range. Writing the
> +		 * huge entry to a random index would leave two entries
> +		 * matching the faulting address; leave it to the refill and
> +		 * TLBL/TLBS handlers, which probe the faulting address.
> +		 */
> +		if (idx < 0)
> +			goto out;
> +
>  		write_c0_pagemask(PM_HUGE_MASK);
>  		ptep = (pte_t *)pmdp;
>  		lo = pte_to_entrylo(pte_val(*ptep));
> @@ -339,10 +352,7 @@ void __update_tlb(struct vm_area_struct * vma, unsigned long address, pte_t pte)
>  		write_c0_entrylo1(lo + (HPAGE_SIZE >> 7));
>  
>  		mtc0_tlbw_hazard();
> -		if (idx < 0)
> -			tlb_write_random();
> -		else
> -			tlb_write_indexed();
> +		tlb_write_indexed();
>  		tlbw_use_hazard();
>  		write_c0_pagemask(PM_DEFAULT_MASK);
>  	} else
> @@ -380,6 +390,7 @@ void __update_tlb(struct vm_area_struct * vma, unsigned long address, pte_t pte)
>  			tlb_write_indexed();
>  	}
>  	tlbw_use_hazard();
> +out:

If CONFIG_MIPS_HUGE_TLB_SUPPORT is unset, the not needed out: gives
a warning. I've fixed that while applying.

>  	htw_start();
>  	flush_micro_tlb_vm(vma);
>  
> -- 
> 2.47.0

applied to mips-next

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]

