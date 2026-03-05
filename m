Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85EB1F30924
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 09:38:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE6E36B008A; Thu,  5 Mar 2026 04:38:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBF2E6B008C; Thu,  5 Mar 2026 04:38:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE82F6B0092; Thu,  5 Mar 2026 04:38:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD2B46B008A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 04:38:58 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 716371A08F7
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:38:58 +0000 (UTC)
X-FDA: 84511510356.27.0AA7D73
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf21.hostedemail.com (Postfix) with ESMTP id 507BE1C0004
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:38:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=DMN7BrRa;
	spf=pass (imf21.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772703536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AQZLec4BAneo8BhInQA5agN2qdzjXNpGaV/sLShC5Io=;
	b=hkBd5Blecg2FAFAlv3XW0KUWH8Zfxi6cHp9PdnmcTuuYhqWtKf/aWw0kRb95xYjLs3wK+H
	78rD5tgp3y9mkycNMc9RZK0Q9R+W6DHUd02IC8gUwODdEUQWHq4lrBGaxIOrqbC6fVHSUd
	WYpnPAOxQsW9HCSCNUyXiaqBWCW2lB4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=DMN7BrRa;
	spf=pass (imf21.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772703536; a=rsa-sha256;
	cv=none;
	b=4A6auZolwWKAKkE3BM34M92CQ+zi96j2XmNL9LqJitbmD5Ze0zgg6tFe/NMUlEXDpfMU5h
	I72Srm8r+CC3OYB6DyXpbWlTu+DTz3L0PUn33qFCsSvOKYor8DFS1+qYiDZYjI+7JONDKL
	ln6tFA2zMJ9xh8cSayhvqJ/Lu3EJoBM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=AQZLec4BAneo8BhInQA5agN2qdzjXNpGaV/sLShC5Io=;
	b=DMN7BrRaySUoQIncAzgL91m7t6EL8KkrdjCtskwDaAvv0bqFp5mIGOekePkbVmNmpwY3NzwFl
	4zZKHzJPpaN9HV9Xtms61DIJ6ktWBzLnKwD4JdbFX0v1kAzFgOeKvTIUXoscdDvqOaZSAatS4GD
	w+pbrCszYAfWyYaFETZX/bI=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fRPW932C4znTWB;
	Thu,  5 Mar 2026 17:34:13 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 77BFF402AB;
	Thu,  5 Mar 2026 17:38:49 +0800 (CST)
Received: from [10.174.179.248] (10.174.179.248) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 5 Mar 2026 17:38:47 +0800
Message-ID: <e8d5ba16-3071-4b4a-b6a1-d492cc46e8c2@huawei.com>
Date: Thu, 5 Mar 2026 17:38:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 2/4] mm/pgtable: Make pfn_pte() filter out huge
 page attributes
To: Matthew Wilcox <willy@infradead.org>, =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?=
	<jgross@suse.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <david@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <tglx@kernel.org>,
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
	<baolu.lu@linux.intel.com>, <conor.dooley@microchip.com>,
	<Jonathan.Cameron@huawei.com>, <riel@surriel.com>, Kefeng Wang
	<wangkefeng.wang@huawei.com>, <chenjun102@huawei.com>
References: <20260228070906.1418911-1-yintirui@huawei.com>
 <20260228070906.1418911-3-yintirui@huawei.com>
 <5eaf3846-01db-471e-9903-b0b239d7838d@suse.com>
From: Yin Tirui <yintirui@huawei.com>
In-Reply-To: <5eaf3846-01db-471e-9903-b0b239d7838d@suse.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.248]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 507BE1C0004
X-Stat-Signature: p9nkgh41frwi5fpdbdfzdef1jkb55bn7
X-Rspam-User: 
X-HE-Tag: 1772703534-435324
X-HE-Meta: U2FsdGVkX1/p7PPIo3ckbRkSYwa3V48ZlnDr5MIc0nkX5RH5iJUC/cucDlXBPfDdgrrn5IToRX50RFNKlU5pKASYhXc5bfUnY9anrswZ04y3sJasjwFQUfKHUn4uHXWVY0gTCXDd4p7bAD7GBMsCSm3nwUon+K1pyw/haVrMHsomHuftZuug69A+LmTd6mFLbK6vd2Wf0Q0EJvuTT3EFA4ZWaBwJ86mZQe0ObT8sNiqcbdaWxYEGc3WeG6p59S3aeMtIDO41H7488ryEjTcAEL/2QYLrXf/who/hFYNhm9vLyz2g/8KT3iWflnNKULuIYfXcsbmOEKL0vA7ka+tN3ywISfXH+PIenOnctDVeZylWarZ/VbvKEcEq5Rp10zlGOW3xHWyUVZVX9Q6nzhqW9dGnMc2EdT6W6k+8bMmHJi9PR3dZtK6VXMRtfBA2Qrdp6AwHMFJ8A6Iim5tNKVelv7K22ursnhz/tUOAR3jKltwev8CmCGWjnW8URdI1VYWvq6kTmu2rEAyOpNzDnfQTW4E2WSqdi2M43USVXsRP2a0M0wcEbhXWLmoB3Rc8S6kR6cNd1w54QQx7aZYBVn/SIj1j4zSwLf3v8F4Pt4Q/DziISZYnK+NIfyP1UJAIegz+vWUe7i63xJqkadwaGf/pkji++p4/YsHCeZnFcZ4oQSXs9ja99lvOB/MEo1mWDtxXnPUYc37TuvrrNO+3KfmxULmGZQS4m+9QskDNi0YtZUImHlLLdydw2PBBtYOUJCkoMSvuC984DsdkrwUX6QSZ50Yh7+4HNX/Rmm5oC6lrBiYYJZkl9vxTjaKlkm3yOokG+IS6aPIJY0OD/DRlGh14P0V4NXAtCrqWnKAQ6dYvjWaud5+SSdiiZ2JXu0iohJd4oGwdnpyIltt5UwCTpk46sOLNYtwid8CMbmEqyyXVOXF+cX81Trw3g85KfvPI0BgrzXoxy7eWQfx/nFkDx3G
 jWHs3OPW
 Wh6pWn7J78tUe/BCKOZhD9UVu9tmbnEoPMS506TqWqf6QJ2GhJWFDWXQjd1eiFZHPhGtshGLxVse4rmhO7DxF/RqP4B+0Ulj3lD10zW34cIZy26QpPiOJigDsiTIxAtAyF4mvIdXfGjVf0A88YfZMsdQ3hLa75Suy+yAcadt7/UDj4omSrALBeKF3SQ8LC8PwdPJpvkR1FqexnMM/Z0fAVzO0NDBJQQPTkugO4dBEz4TTHk1BTh7uLIteAexJLRIPtg4kokjhPbfPC9rSIT5ASkGLWk63od7XMmqwZCW4Ov41KIlv6YbhF1o7LJ4Epp98eBKt202c9/v+oYwNyJqPN9yl6dJx4FlV9AYdeJ+Qd1+XvUvS2V4+oxnkALEKO5YhyFIekFzxyENAP4+kjlWZnYrJh+RvxxLxywod
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

Hi Willy and Jürgen,

Following up on the x86 _PAGE_PSE and _PAGE_PAT aliasing issue.

To achieve the goal of keeping pfn_pte() pure and completely eradicating 
the pte_clrhuge() anti-pattern, we need a way to ensure pfn_pte() never 
receives a pgprot with the huge bit set.

@Jürgen:
Just to be absolutely certain: is there any safe way to filter out the 
huge page attributes directly inside x86's pfn_pte() without breaking 
PAT? Or does the hardware bit-aliasing make this strictly impossible at 
the pfn_pte() level?

@Willy @Jürgen:
Assuming it is impossible to filter this safely inside pfn_pte() on x86, 
we must translate the pgprot before passing it down. To maintain strict 
type-safety and still drop pte_clrhuge(), I plan to introduce two 
arch-neutral wrappers:

x86:
/* Translates large prot to 4K. Shifts PAT back to bit 7, inherently 
clearing _PAGE_PSE */
#define pgprot_huge_to_pte(prot)    pgprot_large_2_4k(prot)
/* Translates 4K prot to large. Shifts PAT to bit 12, strictly sets 
_PAGE_PSE */
#define pgprot_pte_to_huge(prot) 
__pgprot(pgprot_val(pgprot_4k_2_large(prot)) | _PAGE_PSE)

arm64:
/*
  * Drops Block marker, enforces Page marker.
  * Strictly preserves the PTE_VALID bit to avoid validating PROT_NONE 
pages.
  */
#define pgprot_huge_to_pte(prot) \
      __pgprot((pgprot_val(prot) & ~(PMD_TYPE_MASK & ~PTE_VALID)) | \
             (PTE_TYPE_PAGE & ~PTE_VALID))
/*
  * Drops Page marker, sets Block marker.
  * Strictly preserves the PTE_VALID bit.
  */
#define pgprot_pte_to_huge(prot) \
      __pgprot((pgprot_val(prot) & ~(PTE_TYPE_MASK & ~PTE_VALID)) | \
             (PMD_TYPE_SECT & ~PTE_VALID))

Usage:
1.  Creating a huge pfnmap (remap_try_huge_pmd)
pgprot_t huge_prot = pgprot_pte_to_huge(prot);

/* No need for pmd_mkhuge() */
pmd_t entry = pmd_mkspecial(pfn_pmd(pfn, huge_prot));
set_pmd_at(mm, addr, pmd, entry);

2. Splitting a huge pfnmap (__split_huge_pmd_locked)
pgprot_t small_prot = pgprot_huge_to_pte(pmd_pgprot(old_pmd));

/* No need for pte_clrhuge() */
pte_t entry = pfn_pte(pmd_pfn(old_pmd), small_prot);
set_ptes(mm, haddr, pte, entry, HPAGE_PMD_NR);


Willy, is there a better architectural approach to handle this and 
satisfy the type-safety requirement given the x86 hardware constraints?

-- 
Thanks,
Yin Tirui


