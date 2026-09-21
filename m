Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCFA5C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 08:00:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BED116B00A1; Mon, 21 Sep 2026 04:00:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B76D86B00E7; Mon, 21 Sep 2026 04:00:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB3B36B00E8; Mon, 21 Sep 2026 04:00:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 869CB6B00A1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 04:00:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EE48FA05AB
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:00:02 +0000 (UTC)
X-FDA: 85237021044.12.C0F59CC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id D4B2E40006
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:00:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oOow57Ti;
	spf=pass (imf07.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789977601;
	b=49lJuru18PYnX+4zarVHwBLvH7wtkI0DRWmkPzt87AGdIFpp4iYTxIv6Wu+f/wy/LBwE4i
	H/XXfpHSsMJiZ2KUzpPRFXwOUyPMCGVYj8ZTWs6i3oqdzUE9aQprprqH+1vsHke+SwJclB
	TSQNT73Wlsn4cQUK09X/RQ1361WY/fk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oOow57Ti;
	spf=pass (imf07.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789977601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/7znNeXgHNQuMnlCx6KpxREHOt8qDXTTPWARfe0tBfo=;
	b=jumJHu726qjfoobXLTf78uipZQih86B2A9cCVGbItS4OIWm+kyhsyKwTIpKMNZloPl+b3B
	+1OFS3LPPpG1g+zFd+sKCUnKi8MqDG3oZMUQghVcavYkhbvJBwGJi5wn7Bn46wsumvki6N
	B96GHo/ssaIVTQJsR5P1dk3tuGGBqZU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D9E7143D;
	Mon, 21 Sep 2026 00:59:56 -0700 (PDT)
Received: from [10.57.83.12] (unknown [10.57.83.12])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC76C3F86F;
	Mon, 21 Sep 2026 00:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789977599; bh=uRgzAnJkCmIi+snQIbSmkHF+wLnwLOyY5X1yVPOvLlY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oOow57TiAT2tB/NkK8hmGQp1DapcKPuzLjk1RccTkIyvjhT+W62/wiLiQQhfRtFKc
	 4KXMyKWVtD0nlgizdDb0ZyrNReJpgNSJDCbQsOVPjvF3xkgEDDT/Lgpbx6mFtal5hX
	 fPGGW5nNp3gYVFvgixCsuIVC77t3fq9WFJPKKwuc=
Message-ID: <3e3e8b33-cf24-4b09-a64c-f9b2bbe604e7@arm.com>
Date: Mon, 21 Sep 2026 08:59:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] arm64: use hw_pte_t for HW PTE pointers
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
References: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
 <20260914-pte0_arm-v1-1-bb53b663e396@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260914-pte0_arm-v1-1-bb53b663e396@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D4B2E40006
X-Stat-Signature: y1hi7ertgh888bkyusd7bq9to4x869d7
X-Rspam-User: 
X-HE-Tag: 1789977600-369916
X-HE-Meta: U2FsdGVkX19kNjaMNGCApvo7U8MYgYCeiSoqQsb07Hr+T8i8O07pNrRjFJLBZTzmQzFY5GPtwMxgMO79AzTbVD47R1hFl3LyS1jEtByhsRwY/TJJpkRQ7pVgAJU28bdh1RNjB5nHipACZjFwS7GUxNKp1I9iOiF58qd+lZPV5fUg5FAWG1JiJRK6qgphhh/mXXzXQTh5e+LWtlJpvB52xeQB5YOILYh2XSTz62jeKzASZhHQgHV0Ki1ua5nAi5vCZi5TeXntsGQBYxO4X67Dygkx2uded07HYTa4gUP0ruhCOzW3kQh0OTB7BeaQznvlCUZZiT7sgantIXqpXYxxLC/8hdhNCrh6HjRjCavzM2SvIAiawgWVaABduHNTnMf4Utn4ELeHEMqULpCmic2HhQqVwPTEnJpYNJEL4VIJeeRW9pObctttzc8xnXRe4NRrrPxNz6fOGf0cixAUiw5fL8TtpQLbqM82xZZss2MSS4kcONniaW5ogaxWUQ6SQQL78GN8WNJtkrlpiJEeDknS19B2ag7n4ixNht9wQuTWY5odKTHG7Y+lDGzz3ZkoLn9swj69aSLGwn+x5i1VYNNTd70mh5PylOs5QzoS8T8QDpoZLYnE3A9jPmzPaq27fR4Wx0S9765TM0dWw2e0aq5jRGasMlkTLIizUe7ScRoWQTHU4vj41hZKwCqFT0MKy1dQWOQLgWe6StBDhjO4gIv5XgJXStVHPi7n/q8kssEtxVfNDzMOmNJ5lKq2DlHgLRPczgUn+xCfRMCAiBbRW8rs+/AOQCkvYZXk6YqMDbYnDX/e6dfXR/NnAqBHDN1br6ZsJ4vm0JO/GGdgJ2kp5BxaCy3SgATaNnDp3P/QcQyQTIlwL/XMMlOe0fioZP6QMEirYSDZNv/PK/oywxQiZaOkicyEWbIOyJKaHYNR9Kc6pZTGKK6/IEN/2CXkQQqYWWHSuyfaLlEeZwTpXDtLRJp
 dIwKRpfD
 kNSUPFyf7G0XFlLwgvqjEO+x1Kz4LX+xVkAK8nFu3Q18TU5QUKY9Z8t81Mn6P7JvW8ktoPev+Q0j6EV1JZuhYu4NotLvKc+OKAz+H/FLad2CUBf1mnMxQdZJ51960bWZ4Vwb2tacFmA27VZHpYT5a+bh4+zWU7aAGsPayK/r6dBtMHgpoMxthqG8VlHPTjX/BgquwYhabS8odKKWt8cEtKgX2m27aCgtjFrzKKz7wLXp0Y80XUa3oGQVKuKglKKCAQe5+iyI37tbxwNmidkqXp7mf0senXgVAH6+Im8Z8GBiY8jNk0DuoOBGc3dlXfgei9AB4wyUodcdbMwuoQbVxiduryCVAcTdTUusxUK2l1E2vdynqr2WiavJjrqT2Ww311bOeitc8Br7H60xKAv0gERTBjhIuX6+wp3nR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14/09/2026 14:51, Muhammad Usama Anjum wrote:
> With pte_t * used for HW PTE pointers, the compiler cannot distinguish
> them from SW PTE value pointers. The generic HW PTE interfaces already
> use hw_pte_t *, so arm64 HW PTE pointers must use that type before
> ARCH_HAS_HW_PTE_T can make it distinct.
> 
> Convert HW PTE pointers to hw_pte_t *, retaining pte_t for SW PTE
> values. Helpers shared with PMD and PUD operations keep explicit casts
> because this series does not introduce distinct entry types for those
> levels.
> 
> arm64 still uses the hw_pte_t alias in this patch. The new pointer
> spelling therefore denotes the same type until the final opt-in.
> 
> Include linux/pgtable_types.h in pi.h to make hw_pte_t visible.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
>  arch/arm64/include/asm/hugetlb.h  |  19 ++---
>  arch/arm64/include/asm/pgalloc.h  |   2 +-
>  arch/arm64/include/asm/pgtable.h  | 143 ++++++++++++++++++++------------------
>  arch/arm64/include/asm/vmalloc.h  |   2 +-
>  arch/arm64/kernel/efi.c           |   3 +-
>  arch/arm64/kernel/pi/map_kernel.c |   4 +-
>  arch/arm64/kernel/pi/map_range.c  |   9 +--
>  arch/arm64/kernel/pi/pi.h         |   3 +-
>  arch/arm64/mm/contpte.c           |  49 +++++++------
>  arch/arm64/mm/fault.c             |   5 +-
>  arch/arm64/mm/fixmap.c            |   6 +-
>  arch/arm64/mm/hugetlbpage.c       |  48 +++++++------
>  arch/arm64/mm/kasan_init.c        |   4 +-
>  arch/arm64/mm/mmu.c               |  46 +++++++-----
>  arch/arm64/mm/pageattr.c          |   4 +-
>  arch/arm64/mm/trans_pgd.c         |   4 +-
>  16 files changed, 190 insertions(+), 161 deletions(-)
> 

[...]

> diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
> index f66a0016dd02d..237a9136bc73b 100644
> --- a/arch/arm64/mm/fixmap.c
> +++ b/arch/arm64/mm/fixmap.c
> @@ -35,7 +35,7 @@ static pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __bss_pgtbl;
>  static pmd_t bm_pmd[PTRS_PER_PMD] __bss_pgtbl __maybe_unused;
>  static pud_t bm_pud[PTRS_PER_PUD] __bss_pgtbl __maybe_unused;
>  
> -static inline pte_t *fixmap_pte(unsigned long addr)
> +static inline hw_pte_t *fixmap_pte(unsigned long addr)
>  {
>  	return &bm_pte[BM_PTE_TABLE_IDX(addr)][pte_index(addr)];

How does this work, given you haven't yet converted bm_pte? You're returning a
pte_t* where you need a hw_pte_t*. Either the compiler is implicitly converting
(which would defeat the whole purpose of this series) or this patch doesn't
compile until you convert bm_pte later on (which I suspect is more likely).

>  }
> @@ -43,7 +43,7 @@ static inline pte_t *fixmap_pte(unsigned long addr)
>  static void __init early_fixmap_init_pte(pmd_t *pmdp, unsigned long addr)
>  {
>  	pmd_t pmd = READ_ONCE(*pmdp);
> -	pte_t *ptep;
> +	hw_pte_t *ptep;
>  
>  	if (pmd_none(pmd)) {
>  		ptep = bm_pte[BM_PTE_TABLE_IDX(addr)];

Same problem here?

Thanks,
Ryan


