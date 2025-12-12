Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FBF9D43367
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 02:50:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE2816B0005; Thu, 11 Dec 2025 21:50:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A931C6B0006; Thu, 11 Dec 2025 21:50:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A9B66B0007; Thu, 11 Dec 2025 21:50:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 86A566B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 21:50:16 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 11A2AB8F55
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 02:50:16 +0000 (UTC)
X-FDA: 84209290032.02.6D5BBA6
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf16.hostedemail.com (Postfix) with ESMTP id ADB3B18000A
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 02:50:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fK0B1b5F;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765507814; a=rsa-sha256;
	cv=none;
	b=n45Lf4A8FzJxGLrXSvzqTVnFT7s0k4/opHhLR+NeabXnZvLpJJkpb2lluYS0rWQtAOYn/8
	E0lbjbjBtLWQtFgVcWy8884so2BnNiPzOBDaLQPI2JmaVmO+gacKreGTnq0hfv2dQCjOK3
	qibedYQpquPx/1RYhenhMB/4GhFRSE8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fK0B1b5F;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765507814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sn5bXUZ9CfBxwfGQomoxp+jKTEdCiXAXLkMqyUgILQw=;
	b=3OCc+1+MWjlOSWRt88uH0kM6TIvm7iB8YGQBf1xMHVgRB24hGYyHlh83ElX6Ih3+vXDSKK
	4ZN9n+FizzxmvSe6xlZ3OddnTPhXG7QyWCH6nyDwlWqKAx/grPDP4k/j9kRplLu4rpWE6c
	K+oeN9VcWiLKPpJwpwVdhdfhhwT5/+Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765507814; x=1797043814;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=g0azLKHQPuviLzNQ7aFttbhCLkEnPceuCV02p/FafUQ=;
  b=fK0B1b5FgV8W5AIkU0Z2y7P2lWdLpDRJ0yfVwYthBuwgdqxPEy2//lho
   tfiMvK5rShfLHTzeWuN0Gm+797dQEKr5ltn1Dl5TQnnW579lzmevVpcHK
   O3su75WSQmKjrtGX4rL+oM3kbrHVfvDx6xrBpdeGpaUc7hdJ7bZ8RPv/N
   RFwXULgxyefZ+NCIIOrin0xFJdZkg1kyxUwfsXzbGXlkDaaS5ibxgLZpO
   Hfncl3SKUEwSGQbRijjRbADQ3lb2rcYVjgO07+8ByS1+bu5Ov+3kWmQJm
   p5IEcxaw2qTwJXz3GNJJcWVo4RBf2d6bU3CAQQU1QtH+MRX3xkYCeWucg
   g==;
X-CSE-ConnectionGUID: OO+YJeC0Rpe9RHArQGozUQ==
X-CSE-MsgGUID: +cbMDK19TjiYr6edXHtiBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="67383777"
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="67383777"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 18:50:12 -0800
X-CSE-ConnectionGUID: BT9+dIZKSmaXQuTxaIAXYg==
X-CSE-MsgGUID: eM42Sz1IT66EE2en6ly2vQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="201380653"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 18:50:06 -0800
Message-ID: <dd62c21c-6ac5-4e30-b173-d1fa5dcf019f@linux.intel.com>
Date: Fri, 12 Dec 2025 10:45:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/4] iommu: debug-pagealloc: Track IOMMU pages
To: Mostafa Saleh <smostafa@google.com>, linux-mm@kvack.org,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, xiaqinxin@huawei.com, rdunlap@infradead.org
References: <20251211125928.3258905-1-smostafa@google.com>
 <20251211125928.3258905-4-smostafa@google.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20251211125928.3258905-4-smostafa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ADB3B18000A
X-Stat-Signature: r6ze83jtpzraqytsw3m4syj9ax1f4trm
X-Rspam-User: 
X-HE-Tag: 1765507813-266687
X-HE-Meta: U2FsdGVkX18dNKU5yx6ssnmJ4WGZdsHrmtpocwap0iUGTLLwWRg/ZcPGoqUxfJYcrKC76Lqi+8ksHnwc/QdVnf1OgopuSpS+WYISH91HmH0t9N3BR2X3PUYfjoRJmCqbf3kxH6rRy08MevLVAmaUmrEwUcUiBkkYIFCowVQCG71CgjoDqHwOmrGfDKbkAF8PXdXBqSiFl4QGwx7R5MYi1LEa0E90t+kzBkSA6oWxq6vVNYBB/OotaTeFNBfQ2qRF4NviB/B/qPLg7RmRAtfjfBypGnYxBgoOY5TiaqzhJwB8J9QQWwYx/grbSEMeR+s2n1JT9uxxDpos2ysp9icSkFRFBS7PZxj3zy1hgTogODKkrCDpu1OYbOKMFMk139AM8ZVO2GJ4mkaYayxOr6i96OHisq7//3Nl6KQxBicDyXObrEVvCjQQQt9Mwad68JsSjHT+1d6pqy0vTppBFfEJw/hEAxm5Me/qNYQTmP5CBIH5RyBUZ/rle9bKQsh6hPWgkZ2B3QG/iaHMECCIgIR5mj08oO9VxnIeD8f32OnRbvng0LVXT/59GKZeps/agCbB/UxbwmZzFkO4CFhiI6Dd7RXCRkQebX9ZcN2yY4yhykCTOcWK/mWuEex/MZyc9kUeomy7taO/YgYkXtfJzpNczdidixJo6f4qvu4xPsRzucoU/5u8gQEqHj547hy1UtJVGA6+fqnOmwJiKWp4F4xrOvIt4zxRdr7oC1LRO9poisuzcwRcNZd1uqfHI3O/mhYH9tu63SepPfAEn1EkootGNWbfnnatl00BSU3COZKNbg8aDcE3Y8+KUlgquF6QDBSARl+1Xx7toGLLJkCGo9as9oeUg8eCeiIGsXWvjqxAMBqiPz8bI5Yp9OVmGGCma2L1SypdkF0Oc8kcXYIv8Kepo2w2PDx8X3KpM7U/0w7DzbgHmcQwG2yYoL9uOPEq+13vVBKF5AgtdHopLXn3voL
 V3rsfe9D
 3RcOYgDemcxGepba2J8TZwSG83DhREhFF9lPGcZ9c89S71bKCvUsxVB6QV6mTak60e1f7OFIoRb7TF5WuXLMwaD7vZCuGoyV+wR0aSEHt4eZ/ce2gwvNpiNtrG6w4cJHDVR6LGVKLEPM4stgfr4eTKjUB4RVzir2MYU5/fDyym6Keb1oep/pxBqm0ImjwwAZWWGm2rEWfsS38NmKRIJpaIrzHQR2aLgE0I3gIyYO+wisEMwYukvzLFTM4Jw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/11/25 20:59, Mostafa Saleh wrote:
> Using the new calls, use an atomic refcount to track how many times
> a page is mapped in any of the IOMMUs.
> 
> For unmap we need to use iova_to_phys() to get the physical address
> of the pages.
> 
> We use the smallest supported page size as the granularity of tracking
> per domain.
> This is important as it is possible to map pages and unmap them with
> larger sizes (as in map_sg()) cases.
> 
> Signed-off-by: Mostafa Saleh<smostafa@google.com>
> ---
>   drivers/iommu/iommu-debug-pagealloc.c | 91 +++++++++++++++++++++++++++
>   1 file changed, 91 insertions(+)
> 
> diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
> index 1d343421da98..4639cf9518e6 100644
> --- a/drivers/iommu/iommu-debug-pagealloc.c
> +++ b/drivers/iommu/iommu-debug-pagealloc.c
> @@ -29,19 +29,110 @@ struct page_ext_operations page_iommu_debug_ops = {
>   	.need = need_iommu_debug,
>   };
>   
> +static struct page_ext *get_iommu_page_ext(phys_addr_t phys)
> +{
> +	struct page *page = phys_to_page(phys);
> +	struct page_ext *page_ext = page_ext_get(page);
> +
> +	return page_ext;
> +}
> +
> +static struct iommu_debug_metadata *get_iommu_data(struct page_ext *page_ext)
> +{
> +	return page_ext_data(page_ext, &page_iommu_debug_ops);
> +}
> +
> +static void iommu_debug_inc_page(phys_addr_t phys)
> +{
> +	struct page_ext *page_ext = get_iommu_page_ext(phys);
> +	struct iommu_debug_metadata *d = get_iommu_data(page_ext);
> +
> +	WARN_ON(atomic_inc_return_relaxed(&d->ref) <= 0);
> +	page_ext_put(page_ext);
> +}
> +
> +static void iommu_debug_dec_page(phys_addr_t phys)
> +{
> +	struct page_ext *page_ext = get_iommu_page_ext(phys);
> +	struct iommu_debug_metadata *d = get_iommu_data(page_ext);
> +
> +	WARN_ON(atomic_dec_return_relaxed(&d->ref) < 0);
> +	page_ext_put(page_ext);
> +}
> +
> +/*
> + * IOMMU page size doesn't have tomatch the CPU page size. So, we use

s/have tomatch/have to match/

> + * the smallest IOMMU page size to refcount the pages in the vmemmap.
> + * That is important as both map and unmap has to use the same page size
> + * to update the refcount to avoid double counting the same page.
> + * And as we can't know from iommu_unmap() what was the original page size
> + * used for map, we just use the minimum supported one for both.
> + */
> +static size_t iommu_debug_page_size(struct iommu_domain *domain)
> +{
> +	return 1UL << __ffs(domain->pgsize_bitmap);
> +}

The changes look good to me,

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

