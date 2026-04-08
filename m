Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CAD81073CA5
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 12:17:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 859C36B0092; Wed,  8 Apr 2026 08:17:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80ACD6B0093; Wed,  8 Apr 2026 08:17:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F9F26B0095; Wed,  8 Apr 2026 08:17:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 629826B0092
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:17:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 28F378CB4E
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:17:30 +0000 (UTC)
X-FDA: 84635289060.20.EC73A77
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 500F510000F
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:17:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hf9bYJ80;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775650648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o7VsHLXptJ95COxSKs0ScfqIswvohnDgBMdUEw4P/Go=;
	b=kq9iV0BR2c+H1axm1rdLS4Lje/fWT8HXBjeicD6P774M3flHe5K0hzZ+JH9N0BU/gYUrta
	IaWZkcoTlmmBwI7fZojyRxngoKbD6M5YXTSnS1OcubT2M6LyP77r1WdTGGYN5p9v/vjCMp
	JQdeiWjxg+pmSx0zlEl5crQA+hc75XI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hf9bYJ80;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775650648; a=rsa-sha256;
	cv=none;
	b=QmRKf8i4Z/nbE9NL5hZsPqKjQS0c7PJfnIBda06vYzgbksNGTdtlzcE/Lb6Ss0Os3wyl5m
	6PK9oSvAcMwEMrSAlMRfLjlVsb8omCPIv7cTmxnsc9USQcAy5bc54nsTDeXnX0H1ZKCPD1
	r0HNlvlqXTiC5wotyj7aSvhknNQblXg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6DCA340A9D;
	Wed,  8 Apr 2026 12:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA007C19421;
	Wed,  8 Apr 2026 12:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775650647;
	bh=9RDpTJaswPF4RZD8fDr9UWPGxniVyHEL2oMP01MICtA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hf9bYJ80e8mo7uRTzk9PvAOXk24thjgM3Nx0h4knc6Ejt/QopDc0w/KMYiqTUqdSU
	 NV1Tu4lsemjq1nT95EK5hf9j8btk62yCVgGbOc5EgUh0OYMcpj5nT8S/Eazk4u3qGI
	 3IHexIj6haCdm0fEUCyTc3grx57THgzuz4aQE6HNINwx/Qp9AB0jZXRC1etuL4kcZu
	 Q+4aijjuRJwTHs0bbQuW69upCf/vnBWzXysURO54rAHDaPSh53SlJyjrjvaKy7oBWY
	 ALI1bhuzqXJ39DO3TOcmZyDw7dN1IKnRQTxGgCu5keCZko/9391eZtqCS8tED/nnjj
	 hO6me+Czimoow==
Message-ID: <238ab437-06b1-43ef-86bb-9341c02040b1@kernel.org>
Date: Wed, 8 Apr 2026 14:17:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 07/16] arm64/mm: Convert READ_ONCE() as p4dp_get() while
 accessing P4D
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kasan-dev@googlegroups.com
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-8-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260224051153.3150613-8-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 500F510000F
X-Stat-Signature: 4ypoid79jqznaty1we6umgws6ikueast
X-Rspam-User: 
X-HE-Tag: 1775650648-460419
X-HE-Meta: U2FsdGVkX1+03dIU/U3vICjx+RGTFXyBRTWtZchOlPOGIKzr9J/Xhnw0dgqSCib20rKgySh3lv7yzRF7jG/FcaSMoA9G39dvQ9uWwL5FFdpjn5KX35B4dGBtCfUOiJmXaesVlgcaqLz2mkCey2qzv/fdVLXzC5xW8EnxqU3+1WjM3pJvk8bAeDDLCuZlZk1YeRHSM85Ruoq3QOhIB2ZHBRdtRfGZBcbB0XTJCXLm/dqJxjYSAAlaD6d90rPtwkoTGlWBBrbaCd5YkTbMMHgqCuY1GCnaezHBT4AlR/wOQm0YEI3iG+qOrXJoW8wC9YKtIjivvBvtO0lgBBRnnN1eMkhpDqlFUZiUWMvke65Y1DG/BXcdZUTkoiutp5IFdR5QOB/3JCXtMqGGVo42oqeDi5rjyLSBvPfHVaieGPN8cvcnIQQuzi6f4RUSsg4obSXA3v3gMFuwdVci6/RkJJaR/CmY6OlOi9st/2lJmQ87/sZjKMsjbDYhd9ajlDn7t+Vul2X4bHM/qDxqWIAuWPHgp5Ro6ZYYXdcCahPsctJ4a3/f3Ble+6O8rftR6yxDYzPqskuDjCK3Xu3Ri8PiBil6ZBQEqXJGt9+Z5D1ZqMWNRhcltuu1GhZpQ1q3vIRR9cxmL3j8aP+8RccQHRAqjnX/ON3Y0phSWYo/bHUZkLOXTSSmPtuMxHrDpeVXpuvzByRzD7HO82mpEUI82SYjv2GPLI1SP+MFYwyTh0Nua0UEkZ5bciKcT8ZE/O2AjNP8SFqsx0MbeyUuLR8XKZ8Xi3l95ou1X/Nk4N8XL3EcKIJDXzi+Qx2YpGy/s4hAmFemxJ08s2cEy0r8b4kQ73vSHI9ZQYl1+9x+kL8jtHZApPUR/YqgwoGn7yPvbeY1/OAbe769omICyb30y+rj6l/zfhxjZ+chepQ9pYLQkT7A6FjQxAMznujZ3fCI6JBFEziJgOIbihscd22UXkNhHN9kPIS
 QnwFe6is
 MWLe6nMCMe2H/3mzxQ7bzmI8JRT0AdfrMwPGQWKCV8kJRz+oPdApabmX6e/WX2NJzK2xab8J/JDFEn9k0qJfbnOsz7yhCd9FH/zEdlCK6FR82z+VNauaVZUJwlYPMul20Q90LEq/aABgs+HuSRvwBHsUhcU/XfV9RYVMQ5sY1DRW1T4aD3gDO0Ygg51xwDwLatwE/LmbrqpoJcWQxyTyilQKLm0FbQUAlD1Jt8ukCG6kmIPRgS/U5+nM9PpDcSSXsFGirqweZJ4DmqeEGGhhKTbnoUhgPddp1wkStjSqwdjw4UNK1pcnhyPLqZISpG4UE32xs0gW/PkqgjudMcMGLHoMA/7L3XORPKZQ74UXSsF6kBYJ1Ske4qVt27mCuLe8p1CrZvqfv7HkeuyVbALc7ktF7bqraoBgHrsel2ofEKhuHdFhU2hnYsPyzrpbVoD3UQYGua0OwYh42FR9YzWJzl1DAKlNrOsuT+DT3qM5AJeXGk073venwPut46e0bukxVeF5+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 06:11, Anshuman Khandual wrote:
> Convert all READ_ONCE() based P4D accesses as p4dp_get() instead which will
> support both D64 and D128 translation regime going forward.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: kasan-dev@googlegroups.com
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---


[...]

>  static void __init kasan_pgd_populate(unsigned long addr, unsigned long end,
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index a80d06db4de6..16ae11b29f66 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -354,7 +354,7 @@ static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
>  {
>  	int ret = 0;
>  	unsigned long next;
> -	p4d_t p4d = READ_ONCE(*p4dp);
> +	p4d_t p4d = p4dp_get(p4dp);
>  	pud_t *pudp;
>  
>  	if (p4d_none(p4d)) {
> @@ -443,7 +443,7 @@ static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
>  	}
>  
>  	do {
> -		p4d_t old_p4d = READ_ONCE(*p4dp);
> +		p4d_t old_p4d = p4dp_get(p4dp);
>  
>  		next = p4d_addr_end(addr, end);
>  
> @@ -453,7 +453,7 @@ static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
>  			goto out;
>  
>  		BUG_ON(p4d_val(old_p4d) != 0 &&
> -		       p4d_val(old_p4d) != READ_ONCE(p4d_val(*p4dp)));
> +		       p4d_val(old_p4d) != (p4d_val(p4dp_get(p4dp))));

Same here, while at it remove the BUG_ON. (see below)

>  
>  		phys += next - addr;
>  	} while (p4dp++, addr = next, addr != end);
> @@ -1541,7 +1541,7 @@ static void unmap_hotplug_p4d_range(pgd_t *pgdp, unsigned long addr,
>  	do {
>  		next = p4d_addr_end(addr, end);
>  		p4dp = p4d_offset(pgdp, addr);
> -		p4d = READ_ONCE(*p4dp);
> +		p4d = p4dp_get(p4dp);
>  		if (p4d_none(p4d))
>  			continue;
>  
> @@ -1703,7 +1703,7 @@ static void free_empty_p4d_table(pgd_t *pgdp, unsigned long addr,
>  	do {
>  		next = p4d_addr_end(addr, end);
>  		p4dp = p4d_offset(pgdp, addr);
> -		p4d = READ_ONCE(*p4dp);
> +		p4d = p4dp_get(p4dp);
>  		if (p4d_none(p4d))
>  			continue;
>  
> @@ -1724,7 +1724,7 @@ static void free_empty_p4d_table(pgd_t *pgdp, unsigned long addr,
>  	 */
>  	p4dp = p4d_offset(pgdp, 0UL);
>  	for (i = 0; i < PTRS_PER_P4D; i++) {
> -		if (!p4d_none(READ_ONCE(p4dp[i])))
> +		if (!p4d_none(p4dp_get(p4dp + i)))
>  			return;
>  	}
>  
> @@ -2258,4 +2258,21 @@ int pmdp_test_and_clear_young(struct vm_area_struct *vma,
>  }
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */
>  
> +#if CONFIG_PGTABLE_LEVELS > 3
> +phys_addr_t pud_offset_phys(p4d_t *p4dp, unsigned long addr)
> +{
> +	p4d_t p4d = p4dp_get(p4dp);
> +
> +	BUG_ON(!pgtable_l4_enabled());

Heh, while at it, convert that to a VM_WARN_ON_ONCE() or anything else
that is not a BUG.

I strongly assume CONFIG_DEBUG_VM checks are sufficient.

> +
> +	return p4d_page_paddr(p4d) + pud_index(addr) * sizeof(pud_t);
> +}
> +

-- 
Cheers,

David

