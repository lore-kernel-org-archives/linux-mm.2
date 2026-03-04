Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27B2FEB7EB5
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 10:08:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6855D6B0088; Wed,  4 Mar 2026 05:08:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65D8D6B0089; Wed,  4 Mar 2026 05:08:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55CCE6B008A; Wed,  4 Mar 2026 05:08:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 454986B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 05:08:27 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EA54914053B
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:08:26 +0000 (UTC)
X-FDA: 84507955812.23.572652D
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5A1651C0007
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:08:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=3Sd8e7Il;
	spf=pass (imf18.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772618905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+3GcVJzJOaMrQj6u+FGtRxjCJVOJSzeAFf3bB9pddjs=;
	b=NzfJcudfYaJdykoiSn9WAaaTfrt+6k7nHaz3BF1+oF1d1cGwgXn1tXuYl6X6Edbj7oXqHL
	SOywpewHqxy5ghK6VGRoHQzelzrAaT65H/kACc5CXULc86g2xGSdm2GIKPx6EMg9fAaIsY
	M/M7DTtIflod7ZWUoVY24aasseq4Bsw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772618905; a=rsa-sha256;
	cv=none;
	b=Qvn53qLUghIJjdYKBjcKJRupnVvhqN3pxQRMzDnwzHAijwG3Hq5aV3RVuZHGn9IWMyzntC
	Q85TzqOMtyRBQib2HcaX0Ssor5pOMvW+CC2ZJ/4EbIl0SGoB+Q9+6z7m+P2rQgDO9177t3
	DNljBwDahdNNpdUaiX5BDaEshC16mYc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=3Sd8e7Il;
	spf=pass (imf18.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=+3GcVJzJOaMrQj6u+FGtRxjCJVOJSzeAFf3bB9pddjs=;
	b=3Sd8e7IlxgM+6czm7SzeGmkr1MLLDXO3tCM90f/PRMZbGdwZOlHMpSuUd0Q7wVWYXYDDWFnoe
	ifUJTiBz8rrZ+72EuC7XFQzC7tBFGqehMQ2spOylh/k/yN9fCSWrN12T24KcxcjdV8ejC7I90vW
	4/cJZkYdSaqj2n/xxhpwW1g=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4fQpCJ5647z1prkr;
	Wed,  4 Mar 2026 18:03:24 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 2A63C40363;
	Wed,  4 Mar 2026 18:08:18 +0800 (CST)
Received: from [10.174.179.248] (10.174.179.248) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Mar 2026 18:08:16 +0800
Message-ID: <204de22f-335a-46f3-8f96-f1cbdcf7f2bf@huawei.com>
Date: Wed, 4 Mar 2026 18:08:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 2/4] mm/pgtable: Make pfn_pte() filter out huge
 page attributes
To: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <willy@infradead.org>,
	<david@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <luto@kernel.org>,
	<peterz@infradead.org>, <akpm@linux-foundation.org>,
	<lorenzo.stoakes@oracle.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <Liam.Howlett@oracle.com>,
	<npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
	<baohua@kernel.org>, <lance.yang@linux.dev>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<anshuman.khandual@arm.com>, <rmclure@linux.ibm.com>,
	<kevin.brodsky@arm.com>, <apopple@nvidia.com>, <ajd@linux.ibm.com>,
	<pasha.tatashin@soleen.com>, <bhe@redhat.com>, <thuth@redhat.com>,
	<coxu@redhat.com>, <dan.j.williams@intel.com>, <yu-cheng.yu@intel.com>,
	<yangyicong@hisilicon.com>, <baolu.lu@linux.intel.com>,
	<conor.dooley@microchip.com>, <Jonathan.Cameron@huawei.com>,
	<riel@surriel.com>
CC: <wangkefeng.wang@huawei.com>, <chenjun102@huawei.com>
References: <20260228070906.1418911-1-yintirui@huawei.com>
 <20260228070906.1418911-3-yintirui@huawei.com>
 <5eaf3846-01db-471e-9903-b0b239d7838d@suse.com>
From: Yin Tirui <yintirui@huawei.com>
In-Reply-To: <5eaf3846-01db-471e-9903-b0b239d7838d@suse.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.248]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5A1651C0007
X-Stat-Signature: h7nrys5ftsssdrm3n5xaqr6h8596ftr3
X-Rspam-User: 
X-HE-Tag: 1772618903-646842
X-HE-Meta: U2FsdGVkX18WM/zwuZHL9eCJP23gukfhEKuCluC4S+wmH5S5sYeHvioC8pLfwnhXehHy/Fbf26lsaw7MzahlMNkagDCA4mAAQimLOnQ6pPlr+h257gUqKloCiz1hmaKNp3/V6L7fEMPVIl19qHZkcPqS65lICGnsyx+82lXDZvr3Rhm7ykUFWQce8rQKZNYKN9WUvAP6uRXV/IW9oP0iG+qB6cNpzRoBHfBap81QZvYMb820T2/ySvTXnlfmHuyKzF3T01fQcb2YdnUUrSC9DqTiErQVMakLhJ0EPP4OGgArBry7Cth05vHt034GwiX0T1080WE0vg4MZik52w1+pff9lnpbxn66pOUFMxvrxoWh/jNrwUgYGrBDzN5P2h03XFwcefe1J8F5OiqyxmImffsLoZ7HAgXYzF/vak9VYeo0o3xNanqlm8+eAjBOCtg9c9OdLnZAKKrjd0Hv0ChR2Kjnl3R2xBFZUNYhVOuJkanYvs9QZY9IB0cq2mACxnKexPH/H3FaCK3K8GMqq0GaO198pZtiDxWjGQH3jBVj3BbMQ+pX/nYCpZ3uuWLJh8iJ5/4VulKSFfbCGFAtx4N4VLpzEc+OW9vpF/6zNwy+2uZGBFovFintnue3OH90W/mPhijg1/pmBcU4vAZ92Vr+qWEmmpIHTKXRAZJrVKrg5sJ/HxGqNLKew8i/5LPpP6HIJncS1qVMeK4tkMcUb+ceezI3WbbMYb3rMSuuyByWFgdsjRZf2m5DZLP9e1L7ZWN7EIn08a0lBEGyp1GXKUYw+XNYnmT52NIkgQlbc5oI4tvp8E8MeZdnHlLWthaOZ2pilc/ObbAKTHyvgenmv/G9sVdJo+aBjAba2v7myq8nbfDXX/Vzi6zrUagdPY73iibYSg7kywIykRB/Q5Pv/WrYI6/zFUyrr8Gl0txrajYJlQrHH8vI5Hya6vy6GcPUk3+RG4oNm2xRF/ijLzJr7JM
 cwEZZ/YJ
 siHwILQxEzuWxKDqZ3lZsvD+hxxn4kqy+BwX+ADJdvhyZ/VQtmMxHZC2nyRj7DX9oPrj5kF5AJtz8EmPQr1Q8oe41Bs3qpTbH9/aLNnc3WkOMN74jQImy60uulm5D21OW6K7egTzDpoDvKc2hyAanrJ7qmIcix9A281+6vcRlXPR1/X1ZC65kfQl4hxIfM/nOFGRQWLmgZcspNv8Isi5oBjfGXVgLAgDMNj6Fmm0TNLBoS3WD5kXLx8KplH8gQGV3zGfj46lG3ShjAovzhHU7UcK/tLA8SnG7EbeOB+bdYLDEBsRIqqfCfiDspZ5ab4C7nyNe/kfWgeoF8NGCYcTgjTsBc8xsT/T54Y1bExYFn37H/YfZlWkX9+rnTfqdK491+E3+5hVoXrxgYmWocmhZC9XvLTHtsQ0BYxsT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/4/2026 3:52 PM, Jürgen Groß wrote:
> On 28.02.26 08:09, Yin Tirui wrote:
>> A fundamental principle of page table type safety is that `pte_t` 
>> represents
>> the lowest level page table entry and should never carry huge page 
>> attributes.
>>
>> Currently, passing a pgprot with huge page bits (e.g., extracted via
>> pmd_pgprot()) into pfn_pte() creates a malformed PTE that retains the 
>> huge
>> attribute, leading to the necessity of the ugly `pte_clrhuge()` anti- 
>> pattern.
>>
>> Enforce type safety by making `pfn_pte()` inherently filter out huge page
>> attributes:
>> - On x86: Strip the `_PAGE_PSE` bit.
>> - On ARM64: Mask out the block descriptor bits in `PTE_TYPE_MASK` and
>>    enforce the `PTE_TYPE_PAGE` format.
>> - On RISC-V: No changes required, as RISC-V leaf PMDs and PTEs share the
>>    exact same hardware format and do not use a distinct huge bit.
>>
>> Signed-off-by: Yin Tirui <yintirui@huawei.com>
>> ---
>>   arch/arm64/include/asm/pgtable.h | 4 +++-
>>   arch/x86/include/asm/pgtable.h   | 4 ++++
>>   2 files changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/ 
>> asm/pgtable.h
>> index b3e58735c49b..f2a7a40106d2 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -141,7 +141,9 @@ static inline pteval_t 
>> __phys_to_pte_val(phys_addr_t phys)
>>   #define pte_pfn(pte)        (__pte_to_phys(pte) >> PAGE_SHIFT)
>>   #define pfn_pte(pfn,prot)    \
>> -    __pte(__phys_to_pte_val((phys_addr_t)(pfn) << PAGE_SHIFT) | 
>> pgprot_val(prot))
>> +    __pte(__phys_to_pte_val((phys_addr_t)(pfn) << PAGE_SHIFT) | \
>> +        ((pgprot_val(prot) & ~(PTE_TYPE_MASK & ~PTE_VALID)) | \
>> +        (PTE_TYPE_PAGE & ~PTE_VALID)))
>>   #define pte_none(pte)        (!pte_val(pte))
>>   #define pte_page(pte)        (pfn_to_page(pte_pfn(pte)))
>> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/ 
>> pgtable.h
>> index 1662c5a8f445..a4dbd81d42bf 100644
>> --- a/arch/x86/include/asm/pgtable.h
>> +++ b/arch/x86/include/asm/pgtable.h
>> @@ -738,6 +738,10 @@ static inline pgprotval_t check_pgprot(pgprot_t 
>> pgprot)
>>   static inline pte_t pfn_pte(unsigned long page_nr, pgprot_t pgprot)
>>   {
>>       phys_addr_t pfn = (phys_addr_t)page_nr << PAGE_SHIFT;
>> +
>> +    /* Filter out _PAGE_PSE to ensure PTEs never carry the huge page 
>> bit */
>> +    pgprot = __pgprot(pgprot_val(pgprot) & ~_PAGE_PSE);
> 
> Is it really a good idea to silently drop the bit?
> 
> Today it can either be used for a large page (which should be a pmd,
> of course), or - much worse - you'd strip the _PAGE_PAT bit, which is
> at the same position in PTEs.
> 
> So basically you are removing the ability to use some cache modes.
> 
> NACK!
> 
> 
> Juergen

Hi Jürgen,

You are absolutely right. I missed the fact that `_PAGE_PSE` aliases 
with `_PAGE_PAT` on 4K PTEs.

The intention here was to follow previous feedback to enforce type 
safety by filtering out huge page attributes directly inside 
`pfn_pte()`. However, doing it this way obviously breaks the cache modes 
on x86.

I agree with the NACK. I will drop this approach and rethink how to 
handle the huge-to-normal pgprot conversion safely for v4.

-- 
Thanks,
Yin Tirui


