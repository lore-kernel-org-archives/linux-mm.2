Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 785D1D59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 03:35:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 747A96B0006; Sun, 14 Dec 2025 22:35:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D21D6B0007; Sun, 14 Dec 2025 22:35:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C0AC6B0008; Sun, 14 Dec 2025 22:35:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45A976B0006
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 22:35:36 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BECEE5D5CE
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:35:35 +0000 (UTC)
X-FDA: 84220290630.06.59DBDC0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf28.hostedemail.com (Postfix) with ESMTP id D7035C0009
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:35:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RItAd07u;
	spf=pass (imf28.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765769733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ooeKvgYllG8chlJmKk3P5Eia7Rk3XNjccx19p97+0N8=;
	b=msYPgvjUVou1RI0ezQmBNOLy/q01zwkNWzaZJMHPILsYnG7XjnzCJuuKtg2wGg32LParWB
	RyBRljUghdxI6kuYYtTog1+GKN5KRUlY4AoWHyBqCnQrIxeIIOZk3tCgTT2fsR1VRIaaDI
	o05iu5CM/kKSKLW4qt1I4YcwqGZwPnw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RItAd07u;
	spf=pass (imf28.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765769733; a=rsa-sha256;
	cv=none;
	b=mI/L8HU9cpt/YjRJsly3O7ZBgnJJxCXIjd37S1Y4OLXC3/cdZvJz/1wlRZi+/pFmXy9NDh
	lxNh4BQ1IEk6Iac+Ju2szlQYchv3qSxX9vzBa8t1e/EktyHhpW80RFhCOuQwa/1GIxYf6Y
	NBTd4GI2RT2uq5dFwAC4WSaFUnw+nUM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765769733; x=1797305733;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=k0d0WY5WB86HA23RXY6Mrnj8g+i5RzNN7D6VuIy886k=;
  b=RItAd07uKvfxizNudvnBQeO6wqJmg+UgCc28PXcGD3YtwZnEyw7KPnKN
   KJG1HqNXp2jMyJXD74qtE3U1mxu5lY6G89Uau2y3M+4UjG9MWJePKcX8W
   VYiSnvSVgwjWw042I96EsG19MPfyBoLiq/DqVrVqtfpDkgbnfGQa2vaKn
   NgNZPFEpKYer9zFnLt5q33ybJBtNEoTHSN1OBGbuRKFuAgjVlQeTXOSW5
   wD021f8Dna1pi7nkcrQIGOjbykUVDb6stm/IaU0DW3n1v8dDd4JwfOO1G
   XcnwOv5CZic5SWzwC7UzuGpAFgguRKmKR7DiurF6gLSBcp4KFgiBfl837
   Q==;
X-CSE-ConnectionGUID: Jj7kItLoT3q6azhdOp+8Gg==
X-CSE-MsgGUID: pp9D22wUTfS9l0AFyJNR8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11642"; a="70247991"
X-IronPort-AV: E=Sophos;i="6.21,150,1763452800"; 
   d="scan'208";a="70247991"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2025 19:35:31 -0800
X-CSE-ConnectionGUID: Ov4Ez70WS2iVEsI0s1KPLg==
X-CSE-MsgGUID: xGKqUxKKQH+p43hn9drWLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,150,1763452800"; 
   d="scan'208";a="201797741"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2025 19:35:27 -0800
Message-ID: <7186caa3-13c0-4629-a07f-162c00138ad9@linux.intel.com>
Date: Mon, 15 Dec 2025 11:30:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/4] iommu: Add calls for IOMMU_DEBUG_PAGEALLOC
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org, will@kernel.org,
 robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com,
 rdunlap@infradead.org
References: <20251211125928.3258905-1-smostafa@google.com>
 <20251211125928.3258905-3-smostafa@google.com>
 <20e015d7-cb54-4a2a-bf62-a828e10e3126@linux.intel.com>
 <aTxiefxT08hbUPsd@google.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <aTxiefxT08hbUPsd@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: g4wskedm88pot1hwqn9xfo4t43g7niz6
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D7035C0009
X-HE-Tag: 1765769732-704673
X-HE-Meta: U2FsdGVkX19QqZVMQ9eX940vK5IELmMQ1gPhENcccuBpryTUhVxBjY7Q4Zvijpvev83szfRf6AiReD2XK8h7hm52kzmUkHQlLv5D1vfOBbctfvadYl0q0SRY6jc0oDu/GiZ+Z3X+07kPd2bvUNz4+MeDFOcne1EwwBLMGD/b43ILKiowDJdIKUUOXXkNogsTttQf822nVr6QbjVon2CitRQygEvyQvenZ/7vmv3s9ETmROIa7mC0B0KfMYl+7qki8o9VA1TvkbGPFkyqGPHROOzXS7dP4m54H+NzocN4AszxZbhgQmM0u076PYm0XLQGeEMXFBo6yI6xaOG+Mc2Dp8sOA9OuP+Kvqvm8D0rpjTre61RNMlbrBQIyvnzvPpdbysR+acb0xGdfac8BbKM8LDMoR9vv9psScjxp24JlRBXD4tdHaNG2wufDGTgHYfhQWUYnQHjGLW+48iP5DjrnU57Fp+5WXbf4Ud5UYsXuKhx/cWgi/0xCEbuTNXvQ9TMtEUwYDEUZWLhtW0l4ieKPKZ6ZNRGQFvaj6HaKJ2jpWBW9HHqwDsQuFdhAdHuZb8YV8FqTCmM7gMT3DSHoRLiu6jrygPk/0vucLg+ZT3JQVAPt6/HCn4lV9xTUTqmnB3xoSxwV75ggtW/lgqTFndRzMymaxhoFTpdqdNHFW8R66V0r4DOM6AgnPR1SvvRtSkvV2RqobEanGyHLOX4sdHXjO6jy38/rfJ8G1HQlf38oDBXuzFtEkzJdWGrtK1c9DN6Zbwhq09Zpdc094b+bOKPm9QdSn6YqYwcrT8c813YwZI5hoW9rrHUvyuZ/z9h2nva6lyIfSmD146oFQZvKLTdZDm4NBCSzBegDLQUBrVnX3oMCARAGbdMLBHBiD5+g4YlnqdcGswJwxB3wom1SSNOuTlirPsTJe76Eb1ymtdGCphRn+nYpfp0ghZBPzk8ClzCPj6GZ9emAuhyc26Golbk
 8kBHmSPJ
 c6rLVc25+93KpOWEtozMmyuWoZPlS1ft3kTgm+256PWON5lm9npThAzVMQ+CPcG1jK/0nbfVjW9hn7M+SvfRMG4PUayFewMrzQTtrPczCkxbTpOQ1R3SFHcCeBXrIhUnBR6GtbE3YFxL+LjOScBOnL61gOPHhzLvemcduBaHg+EB/T+GjcKULV7jh7d54pUE/JMplYjJzyj4/jN8QvimTaYJ/ASx9Yufel+Cz+Q1eTiMPw2Ed13sAlfKeWW1ZakeK/UbFU2viUnwNHP8aoJJ5YzpwvlPXKv3v9LN5J+d/U5y991mAp8njxnm53xT18SppVRz1ERXyPYWDFjR/h8Wb+iwrlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/13/25 02:44, Mostafa Saleh wrote:
> On Fri, Dec 12, 2025 at 10:33:20AM +0800, Baolu Lu wrote:
>> On 12/11/25 20:59, Mostafa Saleh wrote:
>>> Add calls for the new iommu debug config IOMMU_DEBUG_PAGEALLOC:
>>> - iommu_debug_init: Enable the debug mode if configured by the user.
>>> - iommu_debug_map: Track iommu pages mapped, using physical address.
>>> - iommu_debug_unmap_begin: Track start of iommu unmap operation, with
>>>     IOVA and size.
>>> - iommu_debug_unmap_end: Track the end of unmap operation, passing the
>>>     actual unmapped size versus the tracked one at unmap_begin.
>>>
>>> We have to do the unmap_begin/end as once pages are unmapped we lose
>>> the information of the physical address.
>>> This is racy, but the API is racy by construction as it uses refcounts
>>> and doesn't attempt to lock/synchronize with the IOMMU API as that will
>>> be costly, meaning that possibility of false negative exists.
>>>
>>> Signed-off-by: Mostafa Saleh<smostafa@google.com>
>>> ---
>>>    drivers/iommu/iommu-debug-pagealloc.c | 28 +++++++++++++
>>>    drivers/iommu/iommu-priv.h            | 58 +++++++++++++++++++++++++++
>>>    drivers/iommu/iommu.c                 | 11 ++++-
>>>    include/linux/iommu-debug-pagealloc.h |  1 +
>>>    4 files changed, 96 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
>>> index 4022e9af7f27..1d343421da98 100644
>>> --- a/drivers/iommu/iommu-debug-pagealloc.c
>>> +++ b/drivers/iommu/iommu-debug-pagealloc.c
>>> @@ -5,11 +5,15 @@
>>>     * IOMMU API debug page alloc sanitizer
>>>     */
>>>    #include <linux/atomic.h>
>>> +#include <linux/iommu.h>
>>>    #include <linux/iommu-debug-pagealloc.h>
>>>    #include <linux/kernel.h>
>>>    #include <linux/page_ext.h>
>>> +#include "iommu-priv.h"
>>> +
>>>    static bool needed;
>>> +DEFINE_STATIC_KEY_FALSE(iommu_debug_initialized);
>>>    struct iommu_debug_metadata {
>>>    	atomic_t ref;
>>> @@ -25,6 +29,30 @@ struct page_ext_operations page_iommu_debug_ops = {
>>>    	.need = need_iommu_debug,
>>>    };
>>> +void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size_t size)
>>> +{
>>> +}
>>> +
>>> +void __iommu_debug_unmap_begin(struct iommu_domain *domain,
>>> +			       unsigned long iova, size_t size)
>>> +{
>>> +}
>>> +
>>> +void __iommu_debug_unmap_end(struct iommu_domain *domain,
>>> +			     unsigned long iova, size_t size,
>>> +			     size_t unmapped)
>>> +{
>>> +}
>>> +
>>> +void iommu_debug_init(void)
>>> +{
>>> +	if (!needed)
>>> +		return;
>>> +
>>> +	pr_info("iommu: Debugging page allocations, expect overhead or disable iommu.debug_pagealloc");
>>> +	static_branch_enable(&iommu_debug_initialized);
>>> +}
>>> +
>>>    static int __init iommu_debug_pagealloc(char *str)
>>>    {
>>>    	return kstrtobool(str, &needed);
>>> diff --git a/drivers/iommu/iommu-priv.h b/drivers/iommu/iommu-priv.h
>>> index c95394cd03a7..aaffad5854fc 100644
>>> --- a/drivers/iommu/iommu-priv.h
>>> +++ b/drivers/iommu/iommu-priv.h
>>> @@ -5,6 +5,7 @@
>>>    #define __LINUX_IOMMU_PRIV_H
>>>    #include <linux/iommu.h>
>>> +#include <linux/iommu-debug-pagealloc.h>
>>>    #include <linux/msi.h>
>>>    static inline const struct iommu_ops *dev_iommu_ops(struct device *dev)
>>> @@ -65,4 +66,61 @@ static inline int iommufd_sw_msi(struct iommu_domain *domain,
>>>    int iommu_replace_device_pasid(struct iommu_domain *domain,
>>>    			       struct device *dev, ioasid_t pasid,
>>>    			       struct iommu_attach_handle *handle);
>>> +
>>> +#ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
>>> +
>>> +void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys,
>>> +		       size_t size);
>>> +void __iommu_debug_unmap_begin(struct iommu_domain *domain,
>>> +			       unsigned long iova, size_t size);
>>> +void __iommu_debug_unmap_end(struct iommu_domain *domain,
>>> +			     unsigned long iova, size_t size, size_t unmapped);
>>> +
>>> +static inline void iommu_debug_map(struct iommu_domain *domain,
>>> +				   phys_addr_t phys, size_t size)
>>> +{
>>> +	if (static_branch_unlikely(&iommu_debug_initialized))
>>> +		__iommu_debug_map(domain, phys, size);
>>> +}
>>> +
>>> +static inline void iommu_debug_unmap_begin(struct iommu_domain *domain,
>>> +					   unsigned long iova, size_t size)
>>> +{
>>> +	if (static_branch_unlikely(&iommu_debug_initialized))
>>> +		__iommu_debug_unmap_begin(domain, iova, size);
>>> +}
>>> +
>>> +static inline void iommu_debug_unmap_end(struct iommu_domain *domain,
>>> +					 unsigned long iova, size_t size,
>>> +					 size_t unmapped)
>>> +{
>>> +	if (static_branch_unlikely(&iommu_debug_initialized))
>>> +		__iommu_debug_unmap_end(domain, iova, size, unmapped);
>>> +}
>> I am wondering whether it would be better if we move iommu_debug_map()
>> to iommu-debug-pagealloc.c,
>>
>> void iommu_debug_map(struct iommu_domain *domain,
>> 		     phys_addr_t phys, size_t size)
>> {
>> 	if (static_branch_likely(&iommu_debug_initialized))
>> 		__iommu_debug_map(domain, phys, size);
>> }
>>
>> (Does it make sense to use static_branch_likely() here? Normally, people
>>   who enable CONFIG_IOMMU_DEBUG_PAGEALLOC would want to use this
>>   debugging feature. Or not?)
>>
>> So that ...
> This actually was the v1 implementation [1], but Jörg suggested to move
> it to a header file as a function call would have an overhead if this
> feautre is disabled.
> 
> I believe the priority would be to keep the performance overhead minimal
> with CONFIG_IOMMU_DEBUG_PAGEALLOC and the commandline disabled, so people
> can run with the config in production and only enable the commandline
> it to debug problems, without having overhead on the typical case.

Okay, fair enough.

Thanks,
baolu

