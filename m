Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CAA6CD5BC1
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 11:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D46538E000C; Thu, 13 Nov 2025 06:00:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF6C68E0002; Thu, 13 Nov 2025 06:00:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE5C78E000C; Thu, 13 Nov 2025 06:00:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A78A78E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 06:00:25 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4CC7A89C73
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:00:25 +0000 (UTC)
X-FDA: 84105290010.28.0B790B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 983F84001B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:00:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oWSMkeEz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763031623; a=rsa-sha256;
	cv=none;
	b=slQQbKJJSgUr6EZXFR8dMJFwl87xtO4aqkklF7qrjC1e+kHkMqAfwB/NYKQPKeNc1P+F0m
	sASzRta7ITew08FYlJzAj2XZsaH/Jrdy13FVHHg0g++GUhJeFMbn2/2l4LujVADneefDYU
	6vKXa9kL5i8gmB8g4ftjbxdhfwAN6Us=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oWSMkeEz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763031623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=enKa8R/aOg43tBn/TN1TJVmdvFJxqr+7gETGWCo6Mts=;
	b=ulFxxlfEPKRWp+ZJIC2+urwEUtCwJ2WsinQOGyJY31OjiXEpGiquYjc50ow6cQf2iEChxx
	n1uVgyhXo3cwjI+1H2rm5u48hWqD6bed6w/JNi2D44P3iWtt2a1ftKgmOgC+kIcZnEqenG
	FnZFsImfgb9XkbykREYq6MesPaLogrI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 11E1060217;
	Thu, 13 Nov 2025 11:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1FAC4AF09;
	Thu, 13 Nov 2025 11:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763031622;
	bh=sU+vpaFb7g3JamdPyyLQFH7lkaq5LNFLro/B2yJZ8D4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oWSMkeEziLzsMhyEQr+UK97S9luMDwyWNVRrH+XzbhgHPvSuA3m5VS6+J8auQIGEc
	 PdjlS4ykBGjKHM3phiQQCUjWphpTKqYeFFY1k4UGdCHRjAnnlEbYIUsRhL8tp2b0cM
	 lryaa72GaIK7Xyi9o+rV7u8w0A/vPvDP7WX0hGCC4HBdiunMjfc6Wq2KV2zWWIMX+c
	 a2+i1bF3bVS2Oh41uoThrsQDbZP7q4GkiE+mcAmE5N+3JAIq7r2Zlpt9q5gHH+1trM
	 ztiKDX3w+JWkxm6N1L4CN3cyvCwaglxI1rhXAdILefnNe+7Sp+2OGuTONTaDvEyBqE
	 qdVaPbrSZx8+A==
Date: Thu, 13 Nov 2025 11:00:15 +0000
From: Will Deacon <will@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, Qinxin Xia <xiaqinxin@huawei.com>
Subject: Re: [PATCH v2 2/4] drivers/iommu: Add calls for IOMMU_DEBUG_PAGEALLOC
Message-ID: <aRW6P7vhTIZvm2Qf@willie-the-truck>
References: <20251106163953.1971067-1-smostafa@google.com>
 <20251106163953.1971067-3-smostafa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251106163953.1971067-3-smostafa@google.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 983F84001B
X-Stat-Signature: 3wb9a6cw94sncms6j16wr66gbe8j8jms
X-Rspam-User: 
X-HE-Tag: 1763031623-722843
X-HE-Meta: U2FsdGVkX19BP+dYF7PnXeHdlsoPVEwDChuldZoru1hBagQi/AYhRpnDf0Qc2NWZwSWJOlKZUujG2slI7WDYic7GpzqpRdnLBVm1SiyQOqvK/RzDxBclsgKu8q8Nt3FSlhj4xKXAjow3Tdby76sPUUnHOD2o57HNpkSZAoSIwnTllwJmaOzRvKG5YesszEo/u//2B3cHC0pi0U6gbstjEAtgr26gJl8W4QaHOyeHb0cirQuPcVPLOZhZ5nWYE2WeztuQ2ze0Ia/qcoINIxCfIa1r/zKrydkrAD+NnppmzxnosNQewmlX5j/U+R6dA1f3XSiLOdTfFWVffcyamwY/3He+OlL1AxuxpknZ2+QcV+EmWeejsqi/sq6gG+WKkjRoBseRJsomhgR5VWjYhOtnNwhwWitjgQkR1mIvx1obiAlrVpR47VCe6VHnD+KquGFZvGPgl7zx2aTpZOEjtdrsTjahLd9l2Iu3tI+/PonDzrMl6fLE3i/sVst+6GcsAm4gUBOa3OIkBLGxXZ2pbxv2XQK4WRwjPkyf9DG7DNoo+K6emeVBJXmdHJUI8h6n32k/YazWUkrWZamjAiquef+4T+eLq7J0ZIm8V+qN1rQ7kWdmc/PiWbbp1w0BINDg3dSD723AmjGRbyOHwXLNRau/vD4M4IbxvaEoLniuFjrbsD1hG7OoPX0F5M6jJuaafMn7JfBJWuoRZai/NF1bVYUq4aswwzQS8uNd8h6SODqjPdGHd8vGUcrFgUvhKwkJTKOQrvXuBYbUGbXHuwWD0VDFh8DDAH3OPfqnWc9hLFwx1LZuELiIF4zMinCBeI9Hyrs3L1jbuzaXAkM66+uDVh6coEDTjjn/hjHxzkPNJVM8vYz7In1j2TmN7ApSCKstLipeTWPt1a2uVq8IRL2ZCrMxLYZZD4B+GYYyvLRhtKVNoDKUpEXPEZWi1x0dLKQCCfuHAoshWtDoZKS/LmjtHg/
 jDVEOSbR
 Q2aTclfd7jdvfXODI2TlVGgkSYw1PPNIi7ovdE02OpTYsFphXmlAiSet4haaHc7/s5FPdjpa3oz8zUc3nm8f16zCiX+Pz9+a/ymoJw2MnUrnpONlBpgr7ab+C4bio1NrmjHtM3JDuZPlwKkC7fiEXH1cbH7t3P39Jmr3ywrTJYlJQAb4UvxJ350P6vxYgiD4bzfsNdfUy4f5+vdxsmnc0w7scHykhTWhzdojpx6dCQiembIgjwF1HG8/Wjn/ztbG2T2h3oO0PlevqYWrIHCLRjoe4wDvDbJzFmVOpTe6svfpYhhuj9UIoSQcEmg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 04:39:51PM +0000, Mostafa Saleh wrote:
> Add calls for the new iommu debug config IOMMU_DEBUG_PAGEALLOC:
> - iommu_debug_init: Enable the debug mode if configured by the user.
> - iommu_debug_map: Track iommu pages mapped, using physical address.
> - iommu_debug_unmap: Track iommu pages unmapped, using IO virtual
>   address.
> - iommu_debug_remap: Track iommu pages, already mapped using IOVA.
> 
> We have to do the unmap/remap as once pages are unmapped we lose the
> information of the physical address.
> This is racy, but the API is racy by construction as it uses refcounts
> and doesn't attempt to lock/synchronize with the IOMMU API as that will
> be costly, meaning that possibility of false negative exists.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> Tested-by: Qinxin Xia <xiaqinxin@huawei.com>
> ---
>  drivers/iommu/iommu-debug-pagealloc.c | 23 ++++++++++++
>  drivers/iommu/iommu.c                 | 14 ++++++-
>  include/linux/iommu-debug-pagealloc.h | 54 +++++++++++++++++++++++++++
>  3 files changed, 89 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
> index 385c8bfae02b..a6a2f844b09d 100644
> --- a/drivers/iommu/iommu-debug-pagealloc.c
> +++ b/drivers/iommu/iommu-debug-pagealloc.c
> @@ -5,11 +5,13 @@
>   * IOMMU API debug page alloc sanitizer
>   */
>  #include <linux/atomic.h>
> +#include <linux/iommu.h>
>  #include <linux/iommu-debug-pagealloc.h>
>  #include <linux/kernel.h>
>  #include <linux/page_ext.h>
>  
>  static bool needed;
> +DEFINE_STATIC_KEY_FALSE(iommu_debug_initialized);
>  
>  struct iommu_debug_metadate {
>  	atomic_t ref;
> @@ -25,6 +27,27 @@ struct page_ext_operations page_iommu_debug_ops = {
>  	.need = need_iommu_debug,
>  };
>  
> +void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size_t size)
> +{
> +}
> +
> +void __iommu_debug_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
> +{
> +}
> +
> +void __iommu_debug_remap(struct iommu_domain *domain, unsigned long iova, size_t size)
> +{
> +}

Since the IOMMU API doesn't really have a "remap" operation, I wonder
whether it would be clearer to have unmap_begin() and unmap_end()
functions instead? You'd probably want to call them as a pair, so the
check for unmapped < size would move into unmap_end().

Will

