Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C8B1F36BAA
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 05:05:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 682A36B0005; Fri, 10 Apr 2026 01:05:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 633AF6B0089; Fri, 10 Apr 2026 01:05:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 549D96B008A; Fri, 10 Apr 2026 01:05:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 424296B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 01:05:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DBA9D8B672
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 05:05:44 +0000 (UTC)
X-FDA: 84641458608.16.F987296
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1728E16000B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 05:05:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=r0C8PVa9;
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775797543; a=rsa-sha256;
	cv=none;
	b=JfADwlMwuO/ANoN64k1+hrt06QnXyqW1YU/WFNmhEtKMEDec9fu4J6fXxx7ErSj0ypBcnr
	M2D5xDQlvu7nxovD9ZSHpCAINc1gDsG8nARJ2ySkCUMcOvtkqqbjE3P9B6fKVM3Z6WpOF0
	TbfgD0sJOVG1zbwCgpxb/8TF1Wl+jZs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775797543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DPCO8NIsXzNfPnxUN/lQvKa1Z8/vojZgcQtgG6QiMp8=;
	b=gxAqMu9mXLdV9Tc+D3TPyMlUyqq9d5o3OVKQgLextc2tTv2j0lhI6gRS5ND5KPOseDWWdH
	Yd66GsufPQPVOMeOvAMQG7W3ErM0eERmP29MIKRRhW+zzu3MnIOj5S5LuvhMIZtjZHYV6K
	g0W4M1bzyzNrYExswujPxxyo+3bXJ7I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=r0C8PVa9;
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 564602008;
	Thu,  9 Apr 2026 22:05:36 -0700 (PDT)
Received: from [10.163.181.174] (unknown [10.163.181.174])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3737E3FAF5;
	Thu,  9 Apr 2026 22:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775797542; bh=l0ZVxfWJ7gUGDjmiQGof6X1EzK424doNulI+ywEOOlY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=r0C8PVa9cbhsNuM+1PpHIQKCsYCQoxy2vSc5vm2DvE4BqKnMfgnHzBaPqLwsqkeXN
	 Pvu88Nyvsr+YBOTsMX/n/8n2l/4EAJOYo/gko4uK8gTzaz3ghCa7L2kqVNjZUppTRd
	 CdWX0tZv0gDQzLDfPWwgAxs6WyGl9PvrYDCalxpA=
Message-ID: <c490455f-084a-4f53-86b0-89c15669efb3@arm.com>
Date: Fri, 10 Apr 2026 10:35:35 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 07/16] arm64/mm: Convert READ_ONCE() as p4dp_get() while
 accessing P4D
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kasan-dev@googlegroups.com
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-8-anshuman.khandual@arm.com>
 <238ab437-06b1-43ef-86bb-9341c02040b1@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <238ab437-06b1-43ef-86bb-9341c02040b1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1728E16000B
X-Stat-Signature: gjqe81nczpbddjp16ox5ut993tywoskh
X-HE-Tag: 1775797542-959628
X-HE-Meta: U2FsdGVkX18RRojm8RVxFL4czaOGlUZGVNGc6FS+xHgRMQx/JX1609BtAITMnt+woYN8yTSFaQUX7+O7FQO/i0CPTisK5pPebhWhpJia9XqOrCnSYnq+DPsj276rgNXNvjDpBPGKIMsLELT3ZSO2CgTX5wqstv1ru9lu2G1KU5h7R7cFEJSG8zy88GGJpmI75oJhGNhuMw7p5ypUoZpIH1GGq3/1D46jKCjQrLbhi3uJSc2Qwfe/VAFDp+BK2jfqKXfXBhXMCPLZrDLNCQ4ZJQxcdo4sFWG4P+tORRx+zI5UcBRavpoU3Z0m7lznq2ykcW89vuUCsMGyiZPo2SyFXsgFiIga3YegWX4tC9T1WJXozTyifOI4qzuQz3+60QynYC+2WEuGi5i3Of+dzpLs9TVJMwQJIzk1+1DaWwpdpPyAUhSpv243bR9dvNwOnYoz3DEdrqbyoLFMgNm+xP4oLjPjb+ub89T2Nj7IeGBYvtkbF4QU/cPyNyXHHQL8n7sRQ5iBfvyJlOZ+LrhmOH/mW9zxoDU/IAItYNOLjdSHhiyuxMINfOHCXeNjdiw38I1B6mxiFXkkZGj83LouI5+QkgJIS8We2a8Mjp//2DadX9G4g4G4yf4Mwmd7nrYN7NXYZBILNI3aey4jo7Lsy+PQNmuWYiCfRwpdPikWfXqM9RXxfHCaQwdw9IsN/AqjvZ4U8/4pgCaMLQdBEULmjQLHdsNm7AfRTv+kvYcgsd7uW3oAX6dd5R5PBdzs5qKGTw0TpcwKAYVxuRO+6YbL4UK+ZqgC3/mGerSSXvlTmA67Gpypht6oz2QDvWJF7ceTB/Zs43A8LgiwKjEFk51nx1djBxQDy9SadLZH9gg//kL/HGGjVrx63wt/qFnh4L0exVUVSPintXPpo1xUZ6Xk3PwcBQPknbbhM4E7NJ6E0uZRbTEguDiXD5XalCUq6jbTS1S/skml5CHlB6w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/04/26 5:47 PM, David Hildenbrand (Arm) wrote:
> On 2/24/26 06:11, Anshuman Khandual wrote:
>> Convert all READ_ONCE() based P4D accesses as p4dp_get() instead which will
>> support both D64 and D128 translation regime going forward.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: kasan-dev@googlegroups.com
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
> 
> 
> [...]
> 
>>  static void __init kasan_pgd_populate(unsigned long addr, unsigned long end,
>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> index a80d06db4de6..16ae11b29f66 100644
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -354,7 +354,7 @@ static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
>>  {
>>  	int ret = 0;
>>  	unsigned long next;
>> -	p4d_t p4d = READ_ONCE(*p4dp);
>> +	p4d_t p4d = p4dp_get(p4dp);
>>  	pud_t *pudp;
>>  
>>  	if (p4d_none(p4d)) {
>> @@ -443,7 +443,7 @@ static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
>>  	}
>>  
>>  	do {
>> -		p4d_t old_p4d = READ_ONCE(*p4dp);
>> +		p4d_t old_p4d = p4dp_get(p4dp);
>>  
>>  		next = p4d_addr_end(addr, end);
>>  
>> @@ -453,7 +453,7 @@ static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
>>  			goto out;
>>  
>>  		BUG_ON(p4d_val(old_p4d) != 0 &&
>> -		       p4d_val(old_p4d) != READ_ONCE(p4d_val(*p4dp)));
>> +		       p4d_val(old_p4d) != (p4d_val(p4dp_get(p4dp))));
> 
> Same here, while at it remove the BUG_ON. (see below)
> 
>>  
>>  		phys += next - addr;
>>  	} while (p4dp++, addr = next, addr != end);
>> @@ -1541,7 +1541,7 @@ static void unmap_hotplug_p4d_range(pgd_t *pgdp, unsigned long addr,
>>  	do {
>>  		next = p4d_addr_end(addr, end);
>>  		p4dp = p4d_offset(pgdp, addr);
>> -		p4d = READ_ONCE(*p4dp);
>> +		p4d = p4dp_get(p4dp);
>>  		if (p4d_none(p4d))
>>  			continue;
>>  
>> @@ -1703,7 +1703,7 @@ static void free_empty_p4d_table(pgd_t *pgdp, unsigned long addr,
>>  	do {
>>  		next = p4d_addr_end(addr, end);
>>  		p4dp = p4d_offset(pgdp, addr);
>> -		p4d = READ_ONCE(*p4dp);
>> +		p4d = p4dp_get(p4dp);
>>  		if (p4d_none(p4d))
>>  			continue;
>>  
>> @@ -1724,7 +1724,7 @@ static void free_empty_p4d_table(pgd_t *pgdp, unsigned long addr,
>>  	 */
>>  	p4dp = p4d_offset(pgdp, 0UL);
>>  	for (i = 0; i < PTRS_PER_P4D; i++) {
>> -		if (!p4d_none(READ_ONCE(p4dp[i])))
>> +		if (!p4d_none(p4dp_get(p4dp + i)))
>>  			return;
>>  	}
>>  
>> @@ -2258,4 +2258,21 @@ int pmdp_test_and_clear_young(struct vm_area_struct *vma,
>>  }
>>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */
>>  
>> +#if CONFIG_PGTABLE_LEVELS > 3
>> +phys_addr_t pud_offset_phys(p4d_t *p4dp, unsigned long addr)
>> +{
>> +	p4d_t p4d = p4dp_get(p4dp);
>> +
>> +	BUG_ON(!pgtable_l4_enabled());
> 
> Heh, while at it, convert that to a VM_WARN_ON_ONCE() or anything else
> that is not a BUG.
> 
> I strongly assume CONFIG_DEBUG_VM checks are sufficient.

There are multiple similar BUG_ON() instances

arch/arm64/include/asm/pgtable.h:       BUG_ON(!pgtable_l4_enabled());
arch/arm64/include/asm/pgtable.h:       BUG_ON(!pgtable_l5_enabled());

arch/arm64/mm/mmu.c:                    BUG_ON(pmd_val(old_pmd) != 0 &&
arch/arm64/mm/mmu.c:                    BUG_ON(pud_val(old_pud) != 0 &&
arch/arm64/mm/mmu.c:            BUG_ON(p4d_val(old_p4d) != 0 &&

Shall we convert all of them as VM_WARN_ON_ONCE() in a separate patch
as a pre-requisite ?

> 
>> +
>> +	return p4d_page_paddr(p4d) + pud_index(addr) * sizeof(pud_t);
>> +}
>> +
> 


