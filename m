Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49EBE1073C9A
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 11:22:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 855596B0088; Wed,  8 Apr 2026 07:22:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806B36B008A; Wed,  8 Apr 2026 07:22:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71C196B008C; Wed,  8 Apr 2026 07:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5EF0F6B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:22:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E7E41140ABE
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:22:53 +0000 (UTC)
X-FDA: 84635151426.17.EEBC3F7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 120F1A000C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:22:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PPEhc8iv;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775647372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZBBz0zyElyyPo220s38wUtaWriXRZkSB7Kq8OmzU/UE=;
	b=aCFkHWweBujKdumgJnsBcL7mV7U+Qe3xNSH0l+xue7hwl9+06koV9l5Gw+A9XzYc+7f+hM
	CS++/j3uZtQea+WkRgUoTV2aMlf2AyAC1kyz3XghKnAqMnFDNL6Yh+kcRtsSDzRtrbj7Dd
	b5ET1RJUsf5MI2l5JA8p7MxVBH6+tto=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775647372; a=rsa-sha256;
	cv=none;
	b=t0FSmWGnA0x8BdhIXrYqTDI2ord0/nqTHopP8gNEOv3dXH3Z9Gw+1bPnO1UQsDVl2UZmEz
	Lxur0xlGtNcFtoY6jin4qtaY6P3zF5mbr7vYBAHXW0t37Qt6KrwHKLRhfhsGIEP1Y2HTSA
	/n4zkJKLM14sIvrEg9T8x3nFXr9/KLI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PPEhc8iv;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 21B9A3161;
	Wed,  8 Apr 2026 04:22:45 -0700 (PDT)
Received: from [10.164.148.132] (unknown [10.164.148.132])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F7DA3F641;
	Wed,  8 Apr 2026 04:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775647370; bh=nzIVrbeTrgeSzO5p1iI/QcfcAw0k0mqxMISChqAnbUA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PPEhc8ivtH5b4J6aQHGJ6gK2qKV/d8CQBYCgbAcl99z1Iq3rO6mpIphCnlPABwMaX
	 GyEuSZ5QgyisBODqeYaDaIdmj24qpQMoUZtOnyBzd2E5ZgdeMGvFFaZh/dDAeBSY8W
	 Zj/Um9JYKwkF+CS9ETGFcWCesSiKaYaqarimpT4w=
Message-ID: <0805d765-31af-49a0-acb4-8a72843f1213@arm.com>
Date: Wed, 8 Apr 2026 16:52:42 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 5/8] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
 urezki@gmail.com, linux-kernel@vger.kernel.org, anshuman.khandual@arm.com,
 ryan.roberts@arm.com, ajd@linux.ibm.com, rppt@kernel.org, david@kernel.org,
 Xueyuan.chen21@gmail.com
References: <20260408025115.27368-1-baohua@kernel.org>
 <20260408025115.27368-6-baohua@kernel.org>
 <b297383a-731c-4efa-95b7-0f198b098d11@arm.com>
 <CAGsJ_4xCtFe=5ofj4FW6cqu-fgR+K9BM7FPZRdAWOGP3YKtNzQ@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAGsJ_4xCtFe=5ofj4FW6cqu-fgR+K9BM7FPZRdAWOGP3YKtNzQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: chqq368ptme836b56esia697q3ka15se
X-Rspamd-Queue-Id: 120F1A000C
X-Rspam-User: 
X-HE-Tag: 1775647371-383980
X-HE-Meta: U2FsdGVkX18hJG0202r+pTezSf4TpkA5zfawgo+HNXAi69Zs2UNpH9AdXZsoVWAN7NfypWkDJBx8VkFbrJYeJa6VkQuqnw/PUNyGS9g+w0mSD8sPPWvQPggog6Q3gA/JjUCVYeF0pK5Z8PkQk7DQlNBwIHDMTx6qfhspebDoC0tM9xtrIO68+w2S3MHKfK945UAgvZVR9uGApdbJ8e2TQYuEEpno+ujrg2RaXPIX4njhsWqa4p/jGenFhgCyHSUZOu/w2I9wu0NFaLNv8KE4Hfa5audt9aD8Eh19ErPiM5IKTIpQDLnd0IbLWe7Tb/xe7DIkagiGN+u4ZiOsM3Wvw9fm10nBprMQTAx3CM0yZZvDxSdk6RgGqTZ+V4Pk1Atd0dFkhkY9W3kjwKnNsePMBydx5CmZw+R+ff4b8sHLssjf2z4CHaBm+V/ZmDiM/qyVIp/ebRVre1oxZj2ULWl4pYxcNRf58wQniCNGX5/WN0r3xHUb8jHTjQyTS7dCx+ThDT+vDUtEW3JrQN1QN9V0gMQWyFjaVl1H8Bnq5yCgUFYruL85gyGTM9VtSupAcWkedU/AzZXPgaGD7AKw50njVCV9ViUHlBN75ymlhlFHhwNJQv0F+4Ebgu8D/OSCnRK8TwEkYg7/j+Iqisz326oRu96IesvOmbM0kuTrgeKM/Xc8Hj4p71k7WPn5HDOl9FqGABrTxvaf7XIxbsn2CbuPmDDtRg6zEcpiCQl7U9JF4We4VuU1GiGWI08VQcEO5LGCULesWeAvohhFX4/W28/ygcwwZ9OB3uwszpLlc3elQRveebgvOduwTid5KOEaAS9jNLhrzUG8qN/ZCvd/Z4Tx2q4L3TNEwspq1fxBSSp0rRPwugCpCHxmMy1Lhh7Z68HBSKKj9NLg2Jmxzf5BRCn24ufPiuRg6va16aqyp/lVnwALP39wzXyFvoDWkZRnHqIdMHFY6E/s2Da9WSLCPBC
 X2NZCp9p
 CwFQjE24Ob+t5dzn38WiCE8lkbcrVrqdn4kF9AGM0ISQRbf03LEs2jc6hOU+fPBRm9rXI4XeS4o1RQThc13uoVO/B/Gx9F7imDFzoV7eIoYHyEiH6Ksa0CJ4NvJTdxhAwZkji/9YepcSVaEfzlhX5DNnC+kLS0NyVJ1Q3ZVocU7tEDJYgdvLVsC0IHw4kFzAYmUnLi6vMHzkX2iQdBLr+rDPQvd1wmGEOYOgHFYNmKtwgTZZLL5PmbIqNx81FVwIkU0jX4cKsaVXWxtc8caOc2kuG6F6nSwpL9Hg3jQ0SGX4ppwpjgPOw+kp40oh2bT4PFjMnaft4hEMKZzUUklkrfmde7UwmHv/wrkzn+13zETi7zUE2WwWJCPnaqmWpJrD3MolAJ2eIBcUQYGEoTnePB0BAMjc9rLKCoBwF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/04/26 10:42 am, Barry Song wrote:
> On Wed, Apr 8, 2026 at 12:20 PM Dev Jain <dev.jain@arm.com> wrote:
>>
>>
>>
>> On 08/04/26 8:21 am, Barry Song (Xiaomi) wrote:
>>> In many cases, the pages passed to vmap() may include high-order
>>> pages allocated with __GFP_COMP flags. For example, the systemheap
>>> often allocates pages in descending order: order 8, then 4, then 0.
>>> Currently, vmap() iterates over every page individually—even pages
>>> inside a high-order block are handled one by one.
>>>
>>> This patch detects high-order pages and maps them as a single
>>> contiguous block whenever possible.
>>>
>>> An alternative would be to implement a new API, vmap_sg(), but that
>>> change seems to be large in scope.
>>>
>>> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
>>> ---
>>
>> Coincidentally, I was working on the same thing :)
> 
> Interesting, thanks — at least I’ve got one good reviewer :-)
> 
>>
>> We have a usecase regarding Arm TRBE and SPE aux buffers.
>>
>> I'll take a look at your patches later, but my implementation is the
> 
> Yes. Please.
> 
> 
>> following, if you have any comments. I have squashed the patches into
>> a single diff.
> 
> Thanks very much, Dev. What you’ve done is quite similar to
> patches 5/8 and 6/8, although the code differs somewhat.
> 
>>
>>
>>
>> From ccb9670a52b7f50b1f1e07b579a1316f76b84811 Mon Sep 17 00:00:00 2001
>> From: Dev Jain <dev.jain@arm.com>
>> Date: Thu, 26 Feb 2026 16:21:29 +0530
>> Subject: [PATCH] arm64/perf: map AUX buffer with large pages
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  .../hwtracing/coresight/coresight-etm-perf.c  |  3 +-
>>  drivers/hwtracing/coresight/coresight-trbe.c  |  3 +-
>>  drivers/perf/arm_spe_pmu.c                    |  5 +-
>>  mm/vmalloc.c                                  | 86 ++++++++++++++++---
>>  4 files changed, 79 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/hwtracing/coresight/coresight-etm-perf.c b/drivers/hwtracing/coresight/coresight-etm-perf.c
>> index 72017dcc3b7f1..e90a430af86bb 100644
>> --- a/drivers/hwtracing/coresight/coresight-etm-perf.c
>> +++ b/drivers/hwtracing/coresight/coresight-etm-perf.c
>> @@ -984,7 +984,8 @@ int __init etm_perf_init(void)
>>
>>         etm_pmu.capabilities            = (PERF_PMU_CAP_EXCLUSIVE |
>>                                            PERF_PMU_CAP_ITRACE |
>> -                                          PERF_PMU_CAP_AUX_PAUSE);
>> +                                          PERF_PMU_CAP_AUX_PAUSE |
>> +                                          PERF_PMU_CAP_AUX_PREFER_LARGE);
>>
>>         etm_pmu.attr_groups             = etm_pmu_attr_groups;
>>         etm_pmu.task_ctx_nr             = perf_sw_context;
>> diff --git a/drivers/hwtracing/coresight/coresight-trbe.c b/drivers/hwtracing/coresight/coresight-trbe.c
>> index 1511f8eb95afb..74e6ad891e236 100644
>> --- a/drivers/hwtracing/coresight/coresight-trbe.c
>> +++ b/drivers/hwtracing/coresight/coresight-trbe.c
>> @@ -760,7 +760,8 @@ static void *arm_trbe_alloc_buffer(struct coresight_device *csdev,
>>         for (i = 0; i < nr_pages; i++)
>>                 pglist[i] = virt_to_page(pages[i]);
>>
>> -       buf->trbe_base = (unsigned long)vmap(pglist, nr_pages, VM_MAP, PAGE_KERNEL);
>> +       buf->trbe_base = (unsigned long)vmap(pglist, nr_pages,
>> +                        VM_MAP | VM_ALLOW_HUGE_VMAP, PAGE_KERNEL);
>>         if (!buf->trbe_base) {
>>                 kfree(pglist);
>>                 kfree(buf);
>> diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
>> index dbd0da1116390..90c349fd66b2c 100644
>> --- a/drivers/perf/arm_spe_pmu.c
>> +++ b/drivers/perf/arm_spe_pmu.c
>> @@ -1027,7 +1027,7 @@ static void *arm_spe_pmu_setup_aux(struct perf_event *event, void **pages,
>>         for (i = 0; i < nr_pages; ++i)
>>                 pglist[i] = virt_to_page(pages[i]);
>>
>> -       buf->base = vmap(pglist, nr_pages, VM_MAP, PAGE_KERNEL);
>> +       buf->base = vmap(pglist, nr_pages, VM_MAP | VM_ALLOW_HUGE_VMAP, PAGE_KERNEL);
>>         if (!buf->base)
>>                 goto out_free_pglist;
>>
>> @@ -1064,7 +1064,8 @@ static int arm_spe_pmu_perf_init(struct arm_spe_pmu *spe_pmu)
>>         spe_pmu->pmu = (struct pmu) {
>>                 .module = THIS_MODULE,
>>                 .parent         = &spe_pmu->pdev->dev,
>> -               .capabilities   = PERF_PMU_CAP_EXCLUSIVE | PERF_PMU_CAP_ITRACE,
>> +               .capabilities   = PERF_PMU_CAP_EXCLUSIVE | PERF_PMU_CAP_ITRACE |
>> +                                 PERF_PMU_CAP_AUX_PREFER_LARGE,
>>                 .attr_groups    = arm_spe_pmu_attr_groups,
>>                 /*
>>                  * We hitch a ride on the software context here, so that
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index 61caa55a44027..8482463d41203 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -660,14 +660,14 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>>                 pgprot_t prot, struct page **pages, unsigned int page_shift)
>>  {
>>         unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
>> -
>> +       unsigned long step = 1UL << (page_shift - PAGE_SHIFT);
>>         WARN_ON(page_shift < PAGE_SHIFT);
>>
>>         if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
>>                         page_shift == PAGE_SHIFT)
>>                 return vmap_small_pages_range_noflush(addr, end, prot, pages);
>>
>> -       for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
>> +       for (i = 0; i < ALIGN_DOWN(nr, step); i += step) {
>>                 int err;
>>
>>                 err = vmap_range_noflush(addr, addr + (1UL << page_shift),
>> @@ -678,8 +678,9 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>>
>>                 addr += 1UL << page_shift;
>>         }
>> -
>> -       return 0;
>> +       if (IS_ALIGNED(nr, step))
>> +               return 0;
>> +       return vmap_small_pages_range_noflush(addr, end, prot, pages + i);
>>  }
>>
>>  int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>> @@ -3514,6 +3515,50 @@ void vunmap(const void *addr)
>>  }
>>  EXPORT_SYMBOL(vunmap);
>>
>> +static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
>> +{
>> +       if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
>> +               return PMD_SHIFT;
>> +
>> +       return arch_vmap_pte_supported_shift(size);
>> +}
>> +
>> +static inline int __vmap_huge(struct page **pages, pgprot_t prot,
>> +               unsigned long addr, unsigned int count)
>> +{
>> +       unsigned int i = 0;
>> +       unsigned int shift;
>> +       unsigned long nr;
>> +
>> +       while (i < count) {
>> +               nr = num_pages_contiguous(pages + i, count - i);
>> +               shift = vm_shift(prot, nr << PAGE_SHIFT);
>> +               if (vmap_pages_range(addr, addr + (nr << PAGE_SHIFT),
>> +                                    pgprot_nx(prot), pages + i, shift) < 0) {
>> +                       return 1;
>> +               }
> 
> One observation on my side is that the performance gain is somewhat
> offset by page table zigzagging caused by what you are doing here -
> iterating each mem segment by vmap_pages_range() .

I recall having observed this problem half an year back, and I wrote
code similar to what you did with patch 3 - but I didn't observe any
performance improvement. I think that was because I was testing
vmalloc - most of the cost there lies in the page allocation.

So looks like this indeed is a benefit for vmap.

> 
> In patch 3/8, I enhanced vmap_small_pages_range_noflush() to
> avoid repeated pgd → p4d → pud → pmd → pte traversals for page
> shifts other than PAGE_SHIFT. This improves performance for
> vmalloc as well as vmap(). Then, in patch 7/8, I adopt the new
> vmap_small_pages_range_noflush() and eliminate the iteration.
> 
>> +               i += nr;
>> +               addr += (nr << PAGE_SHIFT);
>> +       }
>> +       return 0;
>> +}
>> +
>> +static unsigned long max_contiguous_stride_order(struct page **pages,
>> +               pgprot_t prot, unsigned int count)
>> +{
>> +       unsigned long max_shift = PAGE_SHIFT;
>> +       unsigned int i = 0;
>> +
>> +       while (i < count) {
>> +               unsigned long nr = num_pages_contiguous(pages + i, count - i);
>> +               unsigned long shift = vm_shift(prot, nr << PAGE_SHIFT);
>> +
>> +               max_shift = max(max_shift, shift);
>> +               i += nr;
>> +       }
>> +       return max_shift;
>> +}
>> +
>>  /**
>>   * vmap - map an array of pages into virtually contiguous space
>>   * @pages: array of page pointers
>> @@ -3552,15 +3597,32 @@ void *vmap(struct page **pages, unsigned int count,
>>                 return NULL;
>>
>>         size = (unsigned long)count << PAGE_SHIFT;
>> -       area = get_vm_area_caller(size, flags, __builtin_return_address(0));
>> +       if (flags & VM_ALLOW_HUGE_VMAP) {
>> +               /* determine from page array, the max alignment */
>> +               unsigned long max_shift = max_contiguous_stride_order(pages, prot, count);
>> +
>> +               area = __get_vm_area_node(size, 1 << max_shift, max_shift, flags,
>> +                                         VMALLOC_START, VMALLOC_END, NUMA_NO_NODE,
>> +                                         GFP_KERNEL, __builtin_return_address(0));
>> +       } else {
>> +               area = get_vm_area_caller(size, flags, __builtin_return_address(0));
>> +       }
>>         if (!area)
>>                 return NULL;
>>
>>         addr = (unsigned long)area->addr;
>> -       if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
>> -                               pages, PAGE_SHIFT) < 0) {
>> -               vunmap(area->addr);
>> -               return NULL;
>> +
>> +       if (flags & VM_ALLOW_HUGE_VMAP) {
>> +               if (__vmap_huge(pages, prot, addr, count)) {
>> +                       vunmap(area->addr);
>> +                       return NULL;
>> +               }
>> +       } else {
>> +               if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
>> +                                       pages, PAGE_SHIFT) < 0) {
>> +                       vunmap(area->addr);
>> +                       return NULL;
>> +               }
>>         }
>>
>>         if (flags & VM_MAP_PUT_PAGES) {
>> @@ -4011,11 +4073,7 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>>                  * their allocations due to apply_to_page_range not
>>                  * supporting them.
>>                  */
>> -
>> -               if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
>> -                       shift = PMD_SHIFT;
>> -               else
>> -                       shift = arch_vmap_pte_supported_shift(size);
>> +               shift = vm_shift(prot, size);
> 
> What I actually did is different. In patches 1/8 and 2/8, I
> extended the arm64 levels to support N * CONT_PTE, and let the
> final PTE mapping use the maximum possible batch after avoiding
> zigzag. This further improves all orders greater than CONT_PTE.
> 
> Thanks
> Barry


