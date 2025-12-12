Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6B31D41D74
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 02:38:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 218F16B0005; Thu, 11 Dec 2025 21:38:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C9126B0006; Thu, 11 Dec 2025 21:38:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B7986B0007; Thu, 11 Dec 2025 21:38:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EEA786B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 21:38:10 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 83CD98A43C
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 02:38:10 +0000 (UTC)
X-FDA: 84209259540.25.818A3D7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf14.hostedemail.com (Postfix) with ESMTP id B6BF4100008
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 02:38:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gzS6rJTL;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765507088; a=rsa-sha256;
	cv=none;
	b=DsCs3B8LUTtZRyGOnR67Suhsj5v75eFAoNuKEnQM57xg9dUowMF50zehfaBiQILoICYb9z
	Wio5FQu99cIT4e6AK+V8iWPekdknAogR3nqSqExFVHGJhKbjrzzeYG6RxZDnxesY8PTU6t
	vuV2wkxdvRlJ/8aSOYqfGqBr/mg2Blg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gzS6rJTL;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765507088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=17/9+fB9vk3AAoqpZk8SKdxU8Ih3sO1NGvsR+XnoZLA=;
	b=BSSuH96hVg+WNYw4NFmsg9Bd5ya4slGTL2TbWaorZ9eszy2cAm28LiQOQuFmPg4FneGDeY
	ImfBIJO2uM2r4Zc+GcAQVEmm0gWHl0RmuECvqjo3Nqm34e7V7WjTT4KfqmA/MY3cFWhdz9
	Ne25dvsDj3KQlIVW91lnE5MnNo5Bmfs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765507088; x=1797043088;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CxbZ+ZkeHIHwwVZs0wsMaxR2EAT5NzFU17ILwd374tg=;
  b=gzS6rJTLTp4wPME8c0t56m4qmC4dHXUMjXkN6AFp7M8A3Nn/ntm1CLMd
   4YmnnUUs469/Ite74tfDvfFjgwzVW+WlZ9j6wzAf1q4raWOOzyaD/Jo3U
   P9FDWwpo1PCvGrMBTa5wUQETFx7737gLPFQZh9hEKOgYZJyG3Wr80jQzj
   BQKxtbyiCI9wbqt2SF385WOXPwj60gf6I35HB+DRc/Xnce4yOkWTyFVKq
   Ryd6wDkcEqzgtXM+aQGmiwF8Zd/A0iQPvrUy/Tnucp4QDD/5wk0s9n2Oi
   a1W1E9Spjz0BDVv3e/St/bXiiguY/p49Gq2b73Iy4fVRJQTJCii2qwDDI
   g==;
X-CSE-ConnectionGUID: YtlRuciBTJiAIwLV/Bolqg==
X-CSE-MsgGUID: Oeq02QkmRJiJi5U+Yu3Odw==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="67428884"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="67428884"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 18:38:07 -0800
X-CSE-ConnectionGUID: cCt1EI17SoulFJ516oP8+A==
X-CSE-MsgGUID: paT5FfTpRjCzRzo8IAFUCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="197436429"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 18:38:01 -0800
Message-ID: <20e015d7-cb54-4a2a-bf62-a828e10e3126@linux.intel.com>
Date: Fri, 12 Dec 2025 10:33:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/4] iommu: Add calls for IOMMU_DEBUG_PAGEALLOC
To: Mostafa Saleh <smostafa@google.com>, linux-mm@kvack.org,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, xiaqinxin@huawei.com, rdunlap@infradead.org
References: <20251211125928.3258905-1-smostafa@google.com>
 <20251211125928.3258905-3-smostafa@google.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20251211125928.3258905-3-smostafa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B6BF4100008
X-Stat-Signature: ixsgr9mhauw87eyrugjeiew7gpg3qn9k
X-Rspam-User: 
X-HE-Tag: 1765507087-467073
X-HE-Meta: U2FsdGVkX197m6JqWCz3Vqk2M8pZI1jeky6STRql0PVhY55fBT5DWRy+6VXdKLN9ypREkqC8hqu244bSHhWYu9JVB4remEpOfp5JcdgSbLMGOnosfWlauEX4j+TGFU6M5OqcgodXvyjhyTRaSyGRryYHuxcg8/qjCXS8RIsnD7Ez/z1vjgHuUMROvew37l7Fk9kRKLx5fFD2aNbTYu8e2eFQOIhvUv6DkHMu8rssFSpRf8ngXifxLl3KjTO2eha9OfJ/vgRYwL4YMMInf3NeYvEY2MTyhIny3yUWt2E+EBtL0WRAiJqemDBBjIYH27KVOl+BZ0LTMP4OwdxKbv/6lgHqwdyWfHr3GSfVy51pLaebHkASkPsu3hEPe9pPJeIAJCgcIBgPrUdarT21ef/xzLu8z0xer2stnS4ANr8TVpU3tRx0ZejcozsgHdfTi1tI9VelXakOy7Go9fvzRZdmAE3sl+VRvNYowkQv++Pnu2mnE+nmf3Cu412UqSWOrjIL5Ry0EATE/rHzMzNjf4cd3Vq3jzRftXqEeJb6vbk+d+2Ljcd9rxJefo13LFV8GXOlJ8uK9WUzUZKFZluywYm4juEHeq8CSxaJHbL7enHUOXPmJhM/2EErQs8engbabvoKcu0axdaTCjlx4YfAE16oXbqK7rz824/i2egWg3wuUyHiLGFl2KvU3lDUQu6VssxhDAb2wPyuWQr0aE/+203Lsx3GZ3GmwzXq9HKQ2Ac4saNGalXogBs1TTTKonOTP4+zZU9hnfQ8E6kybBlQUiJxUHIVmsyRT8TPH2w9ptPLgOGumaajBhlLcOIDuGg8E2Q7WmshzZ0zXCLHy4i9E6OyrMcGm5eZqAU3MlXdr1XlZGSnetJ6aYuNR3MU6Qt+BCNctROI0Zbhk8XuZkW/XfzeueMtlwcL/c9GL8pZN3C8L6WWx9AwwlxdljlCMS/0vwQLduDX4TSrsuy3r2Wnc4c
 Grt5DTlb
 BoLLJuhivPrnNwtMhj5dRJJweS4a7Oo2qL4cRB6ureKYL91OYzL499UnmaAog56aa3Awtae/+rip0es4l7tiHlznBv3KzmbXhaiMjSjGhLFlXNDECha/h38Xj5R3Rp0Fhs6F+vn1AUXgnAVqdymGhPrVjmHBOqomnrmGh20PydO7RZyrSLyTE5HGLdUdljs3rcF4N0uwYiBGWtCONWm13RbQJblJyUju4Xag8fzB49EXtTlM50Hq8C0VTwvKEpaiRVV1ekpHpFU9BiQZdI3rW+mwHRI5+nCeYpGdrI7pshb4diiDtQPHakgbI8FBryelgXZj8zZsX5pruIMdeHGbIRBlEog==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/11/25 20:59, Mostafa Saleh wrote:
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
>   drivers/iommu/iommu-debug-pagealloc.c | 28 +++++++++++++
>   drivers/iommu/iommu-priv.h            | 58 +++++++++++++++++++++++++++
>   drivers/iommu/iommu.c                 | 11 ++++-
>   include/linux/iommu-debug-pagealloc.h |  1 +
>   4 files changed, 96 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
> index 4022e9af7f27..1d343421da98 100644
> --- a/drivers/iommu/iommu-debug-pagealloc.c
> +++ b/drivers/iommu/iommu-debug-pagealloc.c
> @@ -5,11 +5,15 @@
>    * IOMMU API debug page alloc sanitizer
>    */
>   #include <linux/atomic.h>
> +#include <linux/iommu.h>
>   #include <linux/iommu-debug-pagealloc.h>
>   #include <linux/kernel.h>
>   #include <linux/page_ext.h>
>   
> +#include "iommu-priv.h"
> +
>   static bool needed;
> +DEFINE_STATIC_KEY_FALSE(iommu_debug_initialized);
>   
>   struct iommu_debug_metadata {
>   	atomic_t ref;
> @@ -25,6 +29,30 @@ struct page_ext_operations page_iommu_debug_ops = {
>   	.need = need_iommu_debug,
>   };
>   
> +void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size_t size)
> +{
> +}
> +
> +void __iommu_debug_unmap_begin(struct iommu_domain *domain,
> +			       unsigned long iova, size_t size)
> +{
> +}
> +
> +void __iommu_debug_unmap_end(struct iommu_domain *domain,
> +			     unsigned long iova, size_t size,
> +			     size_t unmapped)
> +{
> +}
> +
> +void iommu_debug_init(void)
> +{
> +	if (!needed)
> +		return;
> +
> +	pr_info("iommu: Debugging page allocations, expect overhead or disable iommu.debug_pagealloc");
> +	static_branch_enable(&iommu_debug_initialized);
> +}
> +
>   static int __init iommu_debug_pagealloc(char *str)
>   {
>   	return kstrtobool(str, &needed);
> diff --git a/drivers/iommu/iommu-priv.h b/drivers/iommu/iommu-priv.h
> index c95394cd03a7..aaffad5854fc 100644
> --- a/drivers/iommu/iommu-priv.h
> +++ b/drivers/iommu/iommu-priv.h
> @@ -5,6 +5,7 @@
>   #define __LINUX_IOMMU_PRIV_H
>   
>   #include <linux/iommu.h>
> +#include <linux/iommu-debug-pagealloc.h>
>   #include <linux/msi.h>
>   
>   static inline const struct iommu_ops *dev_iommu_ops(struct device *dev)
> @@ -65,4 +66,61 @@ static inline int iommufd_sw_msi(struct iommu_domain *domain,
>   int iommu_replace_device_pasid(struct iommu_domain *domain,
>   			       struct device *dev, ioasid_t pasid,
>   			       struct iommu_attach_handle *handle);
> +
> +#ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
> +
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

I am wondering whether it would be better if we move iommu_debug_map()
to iommu-debug-pagealloc.c,

void iommu_debug_map(struct iommu_domain *domain,
		     phys_addr_t phys, size_t size)
{
	if (static_branch_likely(&iommu_debug_initialized))
		__iommu_debug_map(domain, phys, size);
}

(Does it make sense to use static_branch_likely() here? Normally, people
  who enable CONFIG_IOMMU_DEBUG_PAGEALLOC would want to use this
  debugging feature. Or not?)

So that ...

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
> +
> +#endif /* CONFIG_IOMMU_DEBUG_PAGEALLOC */
> +
>   #endif /* __LINUX_IOMMU_PRIV_H */
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 2ca990dfbb88..01b062575519 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -232,6 +232,8 @@ static int __init iommu_subsys_init(void)
>   	if (!nb)
>   		return -ENOMEM;
>   
> +	iommu_debug_init();
> +
>   	for (int i = 0; i < ARRAY_SIZE(iommu_buses); i++) {
>   		nb[i].notifier_call = iommu_bus_notifier;
>   		bus_register_notifier(iommu_buses[i], &nb[i]);
> @@ -2562,10 +2564,12 @@ int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
>   	}
>   
>   	/* unroll mapping in case something went wrong */
> -	if (ret)
> +	if (ret) {
>   		iommu_unmap(domain, orig_iova, orig_size - size);
> -	else
> +	} else {
>   		trace_map(orig_iova, orig_paddr, orig_size);
> +		iommu_debug_map(domain, orig_paddr, orig_size);
> +	}
>   
>   	return ret;
>   }
> @@ -2627,6 +2631,8 @@ static size_t __iommu_unmap(struct iommu_domain *domain,
>   
>   	pr_debug("unmap this: iova 0x%lx size 0x%zx\n", iova, size);
>   
> +	iommu_debug_unmap_begin(domain, iova, size);
> +
>   	/*
>   	 * Keep iterating until we either unmap 'size' bytes (or more)
>   	 * or we hit an area that isn't mapped.
> @@ -2647,6 +2653,7 @@ static size_t __iommu_unmap(struct iommu_domain *domain,
>   	}
>   
>   	trace_unmap(orig_iova, size, unmapped);
> +	iommu_debug_unmap_end(domain, orig_iova, size, unmapped);
>   	return unmapped;
>   }
>   
> diff --git a/include/linux/iommu-debug-pagealloc.h b/include/linux/iommu-debug-pagealloc.h
> index 83e64d70bf6c..a439d6815ca1 100644
> --- a/include/linux/iommu-debug-pagealloc.h
> +++ b/include/linux/iommu-debug-pagealloc.h
> @@ -9,6 +9,7 @@
>   #define __LINUX_IOMMU_DEBUG_PAGEALLOC_H
>   
>   #ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
> +DECLARE_STATIC_KEY_FALSE(iommu_debug_initialized);

... we could make this static?

>   
>   extern struct page_ext_operations page_iommu_debug_ops;
>   

Thanks,
baolu

