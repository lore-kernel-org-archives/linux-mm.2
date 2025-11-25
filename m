Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 633F6CFD315
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 07:39:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACAE46B000A; Tue, 25 Nov 2025 02:39:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA2556B0022; Tue, 25 Nov 2025 02:39:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DF466B0023; Tue, 25 Nov 2025 02:39:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8D1266B000A
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 02:39:30 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38BE41607C6
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 07:39:30 +0000 (UTC)
X-FDA: 84148329300.27.8D96EC7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf06.hostedemail.com (Postfix) with ESMTP id 82CAE180002
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 07:39:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AfHNQDvJ;
	spf=pass (imf06.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764056368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U7hmjIIng/qmoaT13OoMVej8x9Bxk7kbUPv/FX/8LAU=;
	b=AvWlwbIYBm8TSX8CxMJGwAYtBmMk5gsXsj4+9qgzKPbrMLol/9v5E2cEpM/p1ZTV7Ggwhl
	Bo3Q7DAj92IrowuK/LS6gJt0oSlvpXTIaTvXL/dnTGjgr6Pc3/HC9t4sBK0GCTcwrbtlYx
	VclcoVJjG8QlRR0G+toDgN3WhBBmgjA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764056368; a=rsa-sha256;
	cv=none;
	b=BEb+CnDggD3OnTfJSJySjYerWmcp9ioIaVbgU93QXmowgB0xFQlr7c0pY6nUGtGSGs9ZWQ
	t52yjQxZt9ecpkhQ4d4td6oxuvGdzHH9wg3UgxSKso6urgIbKyXGPLWyqIeP0XXnekWlIB
	rU6iO0F3OpdOdfsbTfvt1Yibdm+g8+s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AfHNQDvJ;
	spf=pass (imf06.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764056368; x=1795592368;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xTFbS/Nr2mwt++HLPItIulcioAWqO4kkoCiqlajkTgo=;
  b=AfHNQDvJAa1hma17WgyiM1VHY+TCxp9fzZTfAB2WDOD2M1tAX0yMCesY
   wMbRV7m/9bZWBRmwtqr3H6eNrlHJDwt2V9ZW/Su1/GsXw+oG5S2TfFQBo
   Mvd/iyaJFAxw3LJR9pwFH1jboNXCZzYiv2c7NWHIadskKyk99NpE6q8VR
   KmVjEbnRxIyBL1zGemgK9jxw3YE+XixccTUalvmnv/3OhfUTA30xldCLi
   kEdIxR9wJHL6FLT/594pe+4VjBiTAPYpUwAn1dOxanZ1MsXjIlad1EvF4
   BxyiV8KN2T2F3XOEibkW/w41kpgZ41Ip21Yx1fYf84FZkCSk7ZWw/2rPo
   A==;
X-CSE-ConnectionGUID: c3EQeMibSLKS/gnT+o8Teg==
X-CSE-MsgGUID: CzCPdpBSTauglqZiGALk4A==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="77436427"
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="77436427"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 23:39:26 -0800
X-CSE-ConnectionGUID: dCqAkL8QT9+gDGbFn17ZCQ==
X-CSE-MsgGUID: Lo04VFdkTxeDsMlYPzCL4w==
X-ExtLoop1: 1
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 23:39:21 -0800
Message-ID: <07434771-3233-4c88-b505-ee02da72c905@linux.intel.com>
Date: Tue, 25 Nov 2025 15:35:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] drivers/iommu: Add calls for IOMMU_DEBUG_PAGEALLOC
To: Mostafa Saleh <smostafa@google.com>, linux-mm@kvack.org,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, xiaqinxin@huawei.com
References: <20251124200811.2942432-1-smostafa@google.com>
 <20251124200811.2942432-3-smostafa@google.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20251124200811.2942432-3-smostafa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 82CAE180002
X-Stat-Signature: ai871ewyjgdkemubfwdjti6ypw7mqmq3
X-Rspam-User: 
X-HE-Tag: 1764056367-505823
X-HE-Meta: U2FsdGVkX1/lc4cZgUcNt7L7GXKhCnmrGCEcdbHCK+7X2nkRUZzLKnVTL+Pya6GeFQW0oZUECHNFR2WVFmRykIc2zrmzLl7Q2uZqtsqFxMUu9aX1aknYfl1sWvP6kl2i1DeN+6rSmzIy8H47oy5tt1jmrr4icGxJse9xvVq242pAlMrfw348zwkgSKUydkcVBUXsAl1vlM/i0hWngG1eFjLDO4bzmUmCSg/ulfPbobxO1FHy8aqhhOyZcbkoPjnOhcy8dJFrOG7ak+s7ilyfgoqGAz5Qcjb1AEfUy5F1U9HhVwA/sChGZB9CWd06/dU+JqRwCRCXM+S5LAVcMXJRaI+lPY+aK3ZWGCqcJY8JJHk0R1RKntwbVVPL2GcqVRsdt1FtDgRqO8im9dYy+xncTB4FV1FQDoKzBDG1Vfk+ciusJDnFRMyJ4yuVr6Z2rL3b1Zw0KlutZZ12wYcGC4/eIXI+HNkeINecqvkPL0d712dk0CUtAZOTF1APmpkyjWPd7MayK8zQ5vN2poMaujOjPCO8kGzmWbQUD5mExXunz3AtZSWf40/JR2UnkHYDMZMk24o2C9uyYhxmjrotvx05wXQAlzhQEe5Kiky0naTJyKyh2V5+5Q//dHt6qxVMxFKg5okKkH4HuP/TpqlRysiMD3jslIdUqAwDW14HNQIInjH0vfMQvoEKlHLiklZpnRhY4wELEP/QtiMyqnBAcsbrmjQ3l9vWUZn3E83x7jPWStqdetcTE4tcWvEg3cZycQdeChTsbxd5jOpU/r66A3M2CnS6Io2inn8KuMf9jDpRrzt67znkZd7nP9kTeQUC0pNQMODIdAKFFaib7aDG+yr6xzHLCYQUX49Bj/rtZPg6wYl8Bx3F8sr/pmmOTiBKyE6+3AvTQXqu1wX5CSSIe5cbQwU6s9UJMzXJsVS0q7fDfiOS7Kf9J0fC2159q/siBqKcOCoqRfgS49RnE51KBIs
 MInysZHD
 l9F1LG5LXdUP2rfM5joKh4JBqMtfzAsui2ai0JOPx+Z2p/DYuHcCK+2wTb39cmadOTuJ1TOA/0kwTe+3yxnnGJTUoEZ9hrHfiBtTqMRIQT61wjCv9rZ5EGnps4nEZL07OO2dGx5jNJK7m/sUbP3Eme0NKPY8Qoxbung8rlMmNCJ0vOXKv3IcfUPokqbQkm3rHHwGQr1N+uYsFFvS2UXxwjB4Oj2BHnl0Ud7H/lFaExPaO0u44Jhd5ul41XHOeRdiEL63b9GLU5/eAg7Umfl1VdSZrWFhEOIwdFXp37hfamoTtWTggKfeUeMJY7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/25/25 04:08, Mostafa Saleh wrote:
> Add calls for the new iommu debug config IOMMU_DEBUG_PAGEALLOC:
> - iommu_debug_init: Enable the debug mode if configured by the user.
> - iommu_debug_map: Track iommu pages mapped, using physical address.
> - iommu_debug_unmap_begin: Track start of iommu unmap operation, with
>    IOVA and size.
> - iommu_debug_unmap_end: Track the end of unmap operation, passing the
>    actual unmapped size versus the tracked one at unmap_begin.
> 
> We have to do the unmap_begin/end as once pages are unmapped we lose
> the information of the physical address.
> This is racy, but the API is racy by construction as it uses refcounts
> and doesn't attempt to lock/synchronize with the IOMMU API as that will
> be costly, meaning that possibility of false negative exists.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>   drivers/iommu/iommu-debug-pagealloc.c | 26 +++++++++++++
>   drivers/iommu/iommu.c                 | 12 +++++-
>   include/linux/iommu-debug-pagealloc.h | 56 +++++++++++++++++++++++++++
>   3 files changed, 92 insertions(+), 2 deletions(-)
> 

Remove "drivers/" from the commit title.

$ git log --oneline drivers/iommu/iommu.c

[...]
> diff --git a/include/linux/iommu-debug-pagealloc.h b/include/linux/iommu-debug-pagealloc.h
> index 83e64d70bf6c..454303ec09c2 100644
> --- a/include/linux/iommu-debug-pagealloc.h
> +++ b/include/linux/iommu-debug-pagealloc.h
> @@ -8,10 +8,66 @@
>   #ifndef __LINUX_IOMMU_DEBUG_PAGEALLOC_H
>   #define __LINUX_IOMMU_DEBUG_PAGEALLOC_H
>   
> +struct iommu_domain;
> +
>   #ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
>   
> +DECLARE_STATIC_KEY_FALSE(iommu_debug_initialized);
> +
>   extern struct page_ext_operations page_iommu_debug_ops;
>   
> +void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys,
> +		       size_t size);
> +void __iommu_debug_unmap_begin(struct iommu_domain *domain,
> +			       unsigned long iova, size_t size);
> +void __iommu_debug_unmap_end(struct iommu_domain *domain,
> +			     unsigned long iova, size_t size, size_t unmapped);
> +
> +static inline void iommu_debug_map(struct iommu_domain *domain,
> +				   phys_addr_t phys, size_t size)
> +{
> +	if (static_branch_unlikely(&iommu_debug_initialized))
> +		__iommu_debug_map(domain, phys, size);
> +}
> +
> +static inline void iommu_debug_unmap_begin(struct iommu_domain *domain,
> +					   unsigned long iova, size_t size)
> +{
> +	if (static_branch_unlikely(&iommu_debug_initialized))
> +		__iommu_debug_unmap_begin(domain, iova, size);
> +}
> +
> +static inline void iommu_debug_unmap_end(struct iommu_domain *domain,
> +					 unsigned long iova, size_t size,
> +					 size_t unmapped)
> +{
> +	if (static_branch_unlikely(&iommu_debug_initialized))
> +		__iommu_debug_unmap_end(domain, iova, size, unmapped);
> +}
> +
> +void iommu_debug_init(void);
> +
> +#else
> +static inline void iommu_debug_map(struct iommu_domain *domain,
> +				   phys_addr_t phys, size_t size)
> +{
> +}
> +
> +static inline void iommu_debug_unmap_begin(struct iommu_domain *domain,
> +					   unsigned long iova, size_t size)
> +{
> +}
> +
> +static inline void iommu_debug_unmap_end(struct iommu_domain *domain,
> +					 unsigned long iova, size_t size,
> +					 size_t unmapped)
> +{
> +}
> +
> +static inline void iommu_debug_init(void)
> +{
> +}

I suppose that all these should go to drivers/iommu/iommu-priv.h, as
they are for use in other files inside the IOMMU subsystem.

> +
>   #endif /* CONFIG_IOMMU_DEBUG_PAGEALLOC */
>   
>   #endif /* __LINUX_IOMMU_DEBUG_PAGEALLOC_H */

Thanks,
baolu

