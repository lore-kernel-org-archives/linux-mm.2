Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 712B3C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 06:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F19996B0092; Fri, 18 Sep 2026 02:14:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBAB46B0093; Fri, 18 Sep 2026 02:14:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6AD96B0095; Fri, 18 Sep 2026 02:14:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AFEE36B0092
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:14:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47676C054E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:14:44 +0000 (UTC)
X-FDA: 85225869288.18.12FAE7E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 837A880003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:14:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=otP3upcn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789712082;
	b=b0/ap8S9Zgo0mLS0AZBcvP09PVRxpjK5DzQLpbAR9G0Am16Md4VkPo6CMfg8zfbLH2q1nR
	M56FNufkM5iqE7T3fE9j9EDODlJRI/Wfg2NbOxDoNP388SxL1hwXMmM6q/ctmPbQwZDdJ8
	jxsV+QraYb5WWjjs7ajPEbnpd+WO60g=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=otP3upcn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789712082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QW/2OE6ihA5SygTL3ENfiEwrR7oH0H/ao5/23GWCpoA=;
	b=kHGcVrpbgGOZqgz1lmfSk523IMxscl9EkKRImh3B2Ua30qASB1o3DHFuOUAUtIZ0y6ISO0
	xDib8rqrWDvbUSiKNL8WJqA9P5+3/N7ZxpkBzy7hrB7umH711WcAiZjhAgZ6UJimpfEpYy
	I7/gwKhEzRcAtaiCk30TxOyJz4YMPQk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B07CF41326;
	Fri, 18 Sep 2026 06:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD641F000FF;
	Fri, 18 Sep 2026 06:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789712081;
	bh=QW/2OE6ihA5SygTL3ENfiEwrR7oH0H/ao5/23GWCpoA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=otP3upcnF/PdMiljpfNt/pX7FBoUKThHlCjIOr4ocBN6YGLnvSzlu4n4le8nm2m7D
	 J/1HVEoYxd8AcLxccybfuBhL80HWwXeUPJvd1Z/eehiCpYux1nFjpGhm6yrNQgu8mk
	 f+m6E0/s7mYEkF49Oszhalv+9kvFP7F/rqUG+K4Y0rdY8Vvn63HPWeF2zBiTD1/Sx5
	 mMzOWD/fTEin1uB3zArAhRrJKlWnf5LFsp8Z5vr/I89NtAVxUmdYf4kKIpIxXxbgO1
	 n0EPKP0fHl/M+i3enV0AeM1z4tLsVDuOGqxUknUuhzdO8FlxTF7Yu8Ro735NFVk6hc
	 QB6YMAcTcHNIQ==
Message-ID: <58e3b456-7389-4752-8de5-1cc82964c3c7@kernel.org>
Date: Fri, 18 Sep 2026 08:14:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 02/10] powerpc/8xx: add pte_set_huge()
To: Wen Jiang <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com,
 will@kernel.org
Cc: Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, anshuman.khandual@arm.com,
 baohua@kernel.org, david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com,
 leo.yan@arm.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, rppt@kernel.org,
 ryan.roberts@arm.com
References: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
 <20260917052933.188679-3-jiangwenxiaomi@gmail.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260917052933.188679-3-jiangwenxiaomi@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 837A880003
X-Stat-Signature: tgte8endds389epc7i6ckynuhbh35hp6
X-HE-Tag: 1789712082-913267
X-HE-Meta: U2FsdGVkX1+chcVE0vwIs3f7bduQgdS72IsoN1IKmOj6BdnYrhKR2kvXqC8PYSz0SBkmBhaOs3GamWDJ8esp5HeYsO8YAXXkohkn7hpHZudETUM94EaakFrKxavJDydX6Zs9nty2K5GIZzzcfoCLku5JhUHBmLO7tbwOBigilBIfUCXEFMXMJRo3nzcDMxLCn2sbx61s69A2kqgQVj3mVCUz8biu9n4V/v2R8rp4i/czZErYTi3zkcBNP39zTG2P7rhnPa2ImLW6P7KH49GmFazEFhY/HEo4AJqrhZ4gOOBAjqXxW6BI5khbzKzqpXRECncxj80oMUFsPUHzfRRaKG4SaKb8pwMQ7MbpN5+6FiW2c4yTtg+/xvYDs9v2NBBeplgGzim2QwUBPUzjLydgjRWyG0x5CI3BD0t0Rvr1ijFjFL/zippk5OpgZpAVVLtez/Spag/5+NIrIrrRl1CyQY8442jKxS+8/wdecysNUZP25f0Vk0vTSqYp5grueb34MnoZp9c+jGdK4u6wDsX8i9QDexDTgCbkxmX1Y+oMgoMxgceb6+SsqexWk8Jk4z/5QC7bUJaReT63GuxN/RMMuAu2lOK+3X/4KUicxB2MQofta3zQe9FC0Z/2JXsCAT86V1SfXeGxLt0ufdA/g4kPlbgMmblyYGKwJRuY8bT+ZgCfQtmX7aAcmqkK5lhfukPE7g9cT1yx4oteX1S2vuajCarn+bNYOagr9p0ZGKOUzoMj7B40hTP5fM6kKBlK6ewe3Gnc31nh5Fmv5OUAVcXbNQxaCSDDK1nSkMXGPZ7lWGZoPEGKGGR5+GbgVerE3PUNm8MN5JOI4rAyLFNWEND2ces2Y2SgD1KvmgkLKQwxmJUVhXaIJ2630SPFk2R28KOQQyQK62Bpj0CPczf3VAgpKVMfv7cWVFeFPh+W9qWZKgppCdL5BULT7N49iFiOc6ZdacL2OxSvHNuw8E/zqvx
 bPFD9zPi
 ATkZDtNz8eFm3z1fiDZYklrYlhvHn/P2/tR9pJUPxanBnQhIluK8I6Wm4688B0Ofo2IeFOxwtaHt3OLBPSAQ/Kb5p6qwfYpc6/Z+tr6BSf/fcO/jI81mvho732bb5iyiP5DBP03UtJ7zreRbpUua9jHcmVF9mT+3rfrMKSOIF3DAL5rfRFwSYsfKE7WMpcHP7kBtZ33dhjadsWWm0witsE+CfmfdFzDcOEDAdpJ+e59Y1RjlpN+MiR8agWL3y1Lpkn/vqylsJJiWLPbs1FxSBHGy6Ukwrf/nikX0+X102vTUMY2g0sluKpIujQKHqszc24XohU/eTGQSGBGLZjArLu6722XI2gqFhql+zaEr3ghXSNQbE8PJnx6V2n/Zp7MJgpJSO0P9NqF+pKux95G3hh0SdPtabFJAAAPlhYSrom24oNZpI3+cB+aGOxFtdt/p6Gq4nafb1iPe2q+k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 17/09/2026 à 07:29, Wen Jiang a écrit :
> From: Wen Jiang <jiangwen6@xiaomi.com>
> 
> vmap installs PTE-level block mappings (SZ_16K/SZ_512K on powerpc/8xx)
> by reusing set_huge_pte_at(), a HugeTLB helper gated by
> CONFIG_HUGETLB_PAGE. This makes the feature silently unavailable on
> CONFIG_HUGETLB_PAGE=n kernels and couples mm/vmalloc.c to HugeTLB
> internals it does not otherwise need.
> 
> Add pte_set_huge() to powerpc/8xx, next to the existing
> pmd_clear_huge()/pud_clear_huge() in mm/nohash/8xx.c. It builds the huge
> PTE and writes it into the backing cells directly, without going through
> set_huge_pte_at(), so it does not depend on CONFIG_HUGETLB_PAGE.
> 
> No pte_clear_huge() is needed: 8xx does not implement
> arch_vmap_pte_range_unmap_size(), so the vmap unmap path never takes the
> block-mapping branch.
> 
> In practice PPC_8xx selects HUGETLBFS unconditionally, so
> CONFIG_HUGETLB_PAGE=n does not occur there today; this is a decoupling
> cleanup rather than a new configuration.

8xx selects CONFIG_HUGETLB_PAGE because it uses set_huge_pte_at() to map 
kernel text with large pages. That was added by commit 34536d780683 
("powerpc/8xx: Add a function to early map kernel via huge pages")

But now pte_set_huge() could be used instead in 
__early_map_kernel_hugepage() and then CONFIG_HUGETLB_PAGE could be removed.

> 
> There is no caller yet: mm/vmalloc.c is converted later in this series,
> once the generic fallbacks are in place.
> 
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

> ---
>   arch/powerpc/include/asm/nohash/32/pte-8xx.h |  4 +++
>   arch/powerpc/mm/nohash/8xx.c                 | 29 ++++++++++++++++++++
>   2 files changed, 33 insertions(+)
> 
> diff --git a/arch/powerpc/include/asm/nohash/32/pte-8xx.h b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
> index e2ea8ba9f8cae..1ee3f8f0de974 100644
> --- a/arch/powerpc/include/asm/nohash/32/pte-8xx.h
> +++ b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
> @@ -235,6 +235,10 @@ static inline pte_t ptep_get(pte_t *ptep)
>   }
>   #endif /* CONFIG_PPC_16K_PAGES */
>   
> +#define __HAVE_ARCH_PTE_SET_HUGE
> +void pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
> +		  pgprot_t prot, unsigned long size);
> +
>   #endif
>   
>   #endif /* __KERNEL__ */
> diff --git a/arch/powerpc/mm/nohash/8xx.c b/arch/powerpc/mm/nohash/8xx.c
> index a9d3f4729eada..2518d2a6bdb41 100644
> --- a/arch/powerpc/mm/nohash/8xx.c
> +++ b/arch/powerpc/mm/nohash/8xx.c
> @@ -220,3 +220,32 @@ int pmd_clear_huge(pmd_t *pmd)
>   {
>   	 return 0;
>   }
> +
> +/*
> + * vmap PTE-level block mapping. Sets a present kernel mapping directly,
> + * so unlike set_huge_pte_at() it needs neither CONFIG_HUGETLB_PAGE nor
> + * set_pte_filter() (a no-op for non-exec kernel mappings).
> + */
> +void pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
> +		  pgprot_t prot, unsigned long size)
> +{
> +	pmd_t *pmdp = pmd_off(&init_mm, addr);
> +	pte_t pte = pfn_pte(PHYS_PFN(phys), prot);
> +	pte_basic_t val;
> +	pte_basic_t *entry = (pte_basic_t *)ptep;
> +	int num, i;
> +
> +	pte = arch_make_huge_pte(pte, ilog2(size), 0);
> +	val = pte_val(pte);
> +
> +	/*
> +	 * Make sure hardware valid bit is not set. We don't do
> +	 * tlb flush for this update.
> +	 */
> +	VM_WARN_ON(pte_hw_valid(*ptep) && !pte_protnone(*ptep));
> +
> +	num = number_of_cells_per_pte(pmdp, val, 1);
> +
> +	for (i = 0; i < num; i++, entry++, val += SZ_4K)
> +		*entry = val;
> +}


