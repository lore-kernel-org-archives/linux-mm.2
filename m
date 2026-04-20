Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65640F5581D
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 11:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB0A46B0005; Mon, 20 Apr 2026 07:43:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A615E6B00A8; Mon, 20 Apr 2026 07:43:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 976F66B00A9; Mon, 20 Apr 2026 07:43:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 864EE6B0005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 07:43:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 157DD140A27
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 11:43:41 +0000 (UTC)
X-FDA: 84678749442.01.337D786
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7C48080004
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 11:43:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=r8etD1aG;
	spf=pass (imf30.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776685419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A9DayyiGCs7J5S4uoemxf+H1vRd9DRT+SAr6sjgTgzo=;
	b=DUR108+rgEzwKIx9S0uXG83/Kv3nDGkJY39Ax1J0Sc6njwtXp//r/IwxLwbQ9DUmAxuInT
	zrMwsDYrgoKLI4AnFGhRbq6AkD1TRp2v3Q4GfEz8DFqS4BKdwcxITlFYSeDVszlFbHnpnR
	KNINaWuTDRPrfOltkWlG01UoMRcDiCM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=r8etD1aG;
	spf=pass (imf30.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776685419; a=rsa-sha256;
	cv=none;
	b=T2awW9NnEqyoSFVzMdepKzyAq8HnySHUL25Xm3169O5KJAYbydvhVY70cjLztTHufBOIj/
	sBqJn34+Q3O6wQhmeuklMyjG9RL8EJ3ZkubOTUhRzFvUJEc4cRoD3oipfA/doXR4WbCW7w
	ProWQnDkteoB3CPT8Wk46zUxGgAeBlc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=A9DayyiGCs7J5S4uoemxf+H1vRd9DRT+SAr6sjgTgzo=;
	b=r8etD1aG+Mc7JjIr4DZoc+k7bzpFfJnAXZ85nO514eN8BXYo5noW3gM83UgYjqWHyDRfs7ebD
	0kEmWu+ahgPRPlCGy/at6tBU6Mc6RyE2mSAVExXGFPe5vWknmlZGE4h63mAgE0fR/tsMLaialxw
	6r+vbgF/46AoS+hYJ+H4nCM=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4fzk3p6tkxzLlYX;
	Mon, 20 Apr 2026 19:37:10 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id A1F0D40573;
	Mon, 20 Apr 2026 19:43:31 +0800 (CST)
Received: from [10.174.179.248] (10.174.179.248) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 20 Apr 2026 19:43:29 +0800
Message-ID: <b46b82b7-a99d-49b0-8d4d-1a3f788489ca@huawei.com>
Date: Mon, 20 Apr 2026 19:43:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 2/4] mm/pgtable: Make pfn_pte() filter out huge
 page attributes
To: Will Deacon <will@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <willy@infradead.org>,
	<david@kernel.org>, <catalin.marinas@arm.com>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<akpm@linux-foundation.org>, <lorenzo.stoakes@oracle.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <Liam.Howlett@oracle.com>,
	<npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
	<baohua@kernel.org>, <lance.yang@linux.dev>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<anshuman.khandual@arm.com>, <rmclure@linux.ibm.com>,
	<kevin.brodsky@arm.com>, <apopple@nvidia.com>, <ajd@linux.ibm.com>,
	<pasha.tatashin@soleen.com>, <bhe@redhat.com>, <thuth@redhat.com>,
	<coxu@redhat.com>, <dan.j.williams@intel.com>, <yu-cheng.yu@intel.com>,
	<yangyicong@hisilicon.com>, <baolu.lu@linux.intel.com>, <jgross@suse.com>,
	<conor.dooley@microchip.com>, <Jonathan.Cameron@huawei.com>,
	<riel@surriel.com>, <wangkefeng.wang@huawei.com>, <chenjun102@huawei.com>
References: <20260228070906.1418911-1-yintirui@huawei.com>
 <20260228070906.1418911-3-yintirui@huawei.com>
 <aeXoY7lrRJev0P83@willie-the-truck>
From: Yin Tirui <yintirui@huawei.com>
In-Reply-To: <aeXoY7lrRJev0P83@willie-the-truck>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.248]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Stat-Signature: t7xw9ujzedru45tdhiwwoo51ruidcrh7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7C48080004
X-HE-Tag: 1776685417-185366
X-HE-Meta: U2FsdGVkX18hNHOuXgAZwwFpTWMA+HHrFScCY4WI90NNFpRoN2p463tYwQGWiDNO0T9HogUsswBqONssxqC062Wc7aYi4wBUXk6c8fLdUAvSVPmL+1sYyXsIM2ydOj0b9OmSXEQ+z/X9zPj8F7ryjNUEuj6/J+nHAKjdxnGKNPOk0xPBuG8T9dU5argg12/6t0KUc1TuRSxGoCHNKNYgAmYZ7DBNA0vGpif2TfyeOVnIlwasJYVJmHNNTd8WfqfPuPRgZWVCf2HFyko/0UKoOrc6FQ7cZRHKRBYfKVbtqekslM6SaYW5xioSD7Y5NfXzTPj6Ce0bk8OGqaE26uRJYY/QW+inVCGcG4grGvxpZi4YrCz3l5kOsmI3i+MzroT5D5XBkXJebX0dUQRdNBT0YBNMCOuhOLf9R9PaAml/blKGlMv0M0c63Vi/nu4EfsfKRZzkUC9r15S7/qnfph+aVkMT0mEveyZPwggHIYvhtHtksckjQR/EDdz3wZoqLtaRf+pMuN0snT/kg9KErujyyBuM60oRbzMIRF+DdBqtMa7pgBDFS1ydp6HLm41VcR6qFxR8tr5egoAyh64O/gWcZ4trIs+V9NjgV17rJSt6VGesyxg4SEvMPxRDlrKeFavS2LPyLM++b4/qYYxNZ+OqeW/97dcI8MdxJxARGB7rZHr/6w/eaq9SbPz6bxZmYmqUfhz81xyUGcIZyBgs0LozHPiFslqhn91Ykrr6LzkNCb80FFJS/cYH0RKqVYTQXkONSc11eUzkNNYSvi+LSOskM1K5RuNcNBX+WdIcieGEgqM9gXRv7Hw1OjI2mLuAF50sW82ttryotUiWeTxr5QjeM6PD1biJYUeIYoH/tY2ztktMPcx3HDVttUTedOUe133MSHrt9oW8nnygsAYACwstvR9VrXF/Qrlc6IKPOGDGhxA768qSb9y0cXJn1gadN1KZfbX7fwgZ/G4XZ7f8Hll
 HRl8SUg8
 vRuDq9p7uvpBLYK2iWfkoA25U8aJjM0FquP5TNrO3Ckh9/mLM4uizkjeMW3bNE1ilgGzCuA4NIAi9TLasC3I8l0odCTdnbNO42uIESm9HZD8xM9ad+scJ27EDzLdayWpfT4zAyvSkYJl3UxOzJTYkE3KwUuj6bpjJCnDGseWp8JxmqowKt/P0/hkvmixb2aE2X/PWQP8V4BF0nNFUXHixKG4ubJoBneeFUl0FZHO7qGoE3rvba/8FKNluIzEPvpq3K1k9ney/01Us3ktiuGj6/yhmT8v4ysbEL8Hbtjbqki8QSG7C4b1jqzRme6gmQkqdUSkghYtJ+TUSap9Ma1qliCrkvhz9c6qKXxBUa2IYp1D3hgyU075bGXAuZBUoFIDam6TjzIHA8+D1WMsKxk29DhO7x9wufV2L7p+apj1enH4My/6iK2rCxVNVCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Will,

On 4/20/2026 4:48 PM, Will Deacon wrote:
> On Sat, Feb 28, 2026 at 03:09:04PM +0800, Yin Tirui wrote:
>> A fundamental principle of page table type safety is that `pte_t` represents
>> the lowest level page table entry and should never carry huge page attributes.
>>
>> Currently, passing a pgprot with huge page bits (e.g., extracted via
>> pmd_pgprot()) into pfn_pte() creates a malformed PTE that retains the huge
>> attribute, leading to the necessity of the ugly `pte_clrhuge()` anti-pattern.
>>
>> Enforce type safety by making `pfn_pte()` inherently filter out huge page
>> attributes:
>> - On x86: Strip the `_PAGE_PSE` bit.
>> - On ARM64: Mask out the block descriptor bits in `PTE_TYPE_MASK` and
>>    enforce the `PTE_TYPE_PAGE` format.
>> - On RISC-V: No changes required, as RISC-V leaf PMDs and PTEs share the
>>    exact same hardware format and do not use a distinct huge bit.
>>
>> Signed-off-by: Yin Tirui <yintirui@huawei.com>
>> ---
>>   arch/arm64/include/asm/pgtable.h | 4 +++-
>>   arch/x86/include/asm/pgtable.h   | 4 ++++
>>   2 files changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index b3e58735c49b..f2a7a40106d2 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -141,7 +141,9 @@ static inline pteval_t __phys_to_pte_val(phys_addr_t phys)
>>   
>>   #define pte_pfn(pte)		(__pte_to_phys(pte) >> PAGE_SHIFT)
>>   #define pfn_pte(pfn,prot)	\
>> -	__pte(__phys_to_pte_val((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
>> +	__pte(__phys_to_pte_val((phys_addr_t)(pfn) << PAGE_SHIFT) | \
>> +		((pgprot_val(prot) & ~(PTE_TYPE_MASK & ~PTE_VALID)) | \
>> +		(PTE_TYPE_PAGE & ~PTE_VALID)))
> Why are you touching arch/arm64? We don't implement pte_clrhuge() afaict.
> What does this actually fix?

Originally, this patch aimed to ensure that pfn_pte() always returns a 
PTE without any

huge page attributes by embedding the logic of pte_clrhuge() directly 
into pfn_pte().


However, we found this approach doesn't work well on x86, so we've 
abandoned this design.


Following Matthew Wilcox's suggestion, the current approach is instead 
to have pmd_pgprot()

return a 4K–formatted pgprot_t (i.e., without huge page attributes), and 
then explicitly add the

huge page attributes when constructing a PMD via pfn_pmd().


I've already implemented this in my recent commit:

https://github.com/torvalds/linux/commit/5b8ce6d33822dd7776432e03a08fe6d2dedac079


>
> Will

-- 
Yin Tirui


