Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12B39C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 13:49:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BC636B0095; Wed, 23 Sep 2026 09:49:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1664C6B0096; Wed, 23 Sep 2026 09:49:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A4306B0099; Wed, 23 Sep 2026 09:49:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E2FB46B0095
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:49:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7851E1207A3
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:49:15 +0000 (UTC)
X-FDA: 85245158670.27.FE8B0AD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id A45C3160005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:49:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="mQ/W8ZyC";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790171353;
	b=fBj3XphX5G5OwfMyBu8YiCEHng6XT+/pMpW8rvfsCFqwUH70YgiHmhX7sw/QY0HTxu2rah
	YSklyvt67bDYxZAf6RkPP4p1fpiqAT1vmOd5QLWjAPvCwycnbr1BEcjl6F3pvtDqZz4NjY
	Dar1kcrY2E9BiJOJxKi5JRmPTqEouTU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="mQ/W8ZyC";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790171353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KLfb2r43LhpOq5XaDQidvHA9iO5v22wjpIkEIg1fwG4=;
	b=g2mlISLm8r5zFJSchR6hGAWzrUqaIy3LzDzwE9eW8vL1kWJZhYw1P1sjndlqCZ3Z4hKAb6
	JCJ1ZiyrNxG4vJQnN/jQaF40n9G/Fg0/WQVYhADDuiclMGd2NAleSw3YH6kHnPQ2PxyyTC
	1r+ff8sImOBuNsBzuJV/9iGdMZYkHGk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1F5BE1516;
	Wed, 23 Sep 2026 06:49:09 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 115DE3F86F;
	Wed, 23 Sep 2026 06:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790171352; bh=XZjpz87fWuq0xeTRn18TokdKjnI48O4gDE75aIXRo/8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mQ/W8ZyCxdppzKi6TjFPjx+SnN6nJs1Q0ck64jZseOqja959/n3ZX/3vuBXryqiVy
	 OL6BsCU2pOXRu8nZ7Rw2k3kSXnD9/Eum+CdiLMgaM+zfOhJSn9F4DHjrcdbTXpAfoQ
	 tqz7RvO89PTGnZD7MrNYoOLeOeYFrJCzF3uTP37o=
Date: Wed, 23 Sep 2026 14:49:07 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	christian.koenig@amd.com, Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v7 06/13] dma-contiguous: Accept an explicit minimum
 alignment
Message-ID: <arPY05E2xYflek07@arm.com>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-7-aneesh.kumar@kernel.org>
 <arOrgRfi1k12clT7@arm.com>
 <yq5a33v02nmn.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5a33v02nmn.fsf@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: tuciugom3mri9zwfbxou449ee8wmfjnj
X-Rspam-User: 
X-Rspamd-Queue-Id: A45C3160005
X-HE-Tag: 1790171353-241785
X-HE-Meta: U2FsdGVkX1+3iCbDbZ+TRKij5SnGBVnOlOiB4XZLdAY9UfgI1/vO3zkSohGXMgVCaiKEOKKSje9fc49oDUjwtozp96y4j22QYrjNJkRnRhlAZTtlKiEjTZOvMUeVpQINMfI1S58eKyBy7+sv3vt8iajXld7UaaulYzGu/CG7wiMA5GkA9uv4TqvfcsJoMMpVeZ/9AKmy2+Z7AJNYpiKrN2om+HartwMJkfrCc1qvMQSL/sjqHMeQzHZG92nmW7S6Kzoix2GkrJO+ucq68rvgjQTI88/bAiXnXy2BqLvetyo5G/E9qg89vMB3VhHG44sygpl08fAIuWjdWltMDs0OGlWcWJmnCtKUIZet5wG5U4KpqT1VxxyU1AULY6amzQTocKXU/a2FtX5Hjg90kqj6MIzy32Ta9Iz8QkeXkCdnCVDFNPIH0CUgMaFU1yp1TRi9tUNztW6L1tSkH+KqVPCuCoK249jXT+uYQYepIOnMqMn+3UNyPY8gYBF4Q0a/V+fgWY+pTDBuBXrtHBcOmyTp8nCdeajL2SgwZUs1rNxpdTQaajefsc1fGsoE/ZywOS+u60xpcm0BjWl0NrFLqqkkgLVYH00g6I8YgVzVsa9q86LNDT+nt9kkt6SPG0BoKIfURET/tVKvpBgMk+iRQIYCj2R5s+bDsIXoyOJmtH+2p+clSDAuJ7XG7RxT3bf3qqE7FBWYaEUEEiULILnzEvLF2YETP34Ho/hX2SezMK7B7y+sVaIcHLeksYimW1TMGYKE7aEXc21M9e54HNcGh5cHj3Ec6xyo5iyIhmfoubWq+ISMFa55M8cIs8o9DO+nLUfl+R3M4lPJsOWFm9JH49f4dHlSMYU1vP7MhhZP7dcLy0AieUktb6f5v0LzTXu4tXLKy2RbebiDqk6925Uo9gLWRC4o5wZYdWvhDl14/O14ma+mH/y+hQ6ZuWxXPEBiTEHk2Aqhj9ec+wWVdfcAIt9
 P/QieE5N
 VZMIaJtjOsrX5UcOi4/lCAXB0Ixc6Fz8gLamZARmyG0RDToCP9mW8tHUHhzE9oc7pZ7ksoCOZXVwnyYy1+JuzRKVdMKRzDADFfXewGydXkkDPnYKhl7ZJUxdLvxhR/d1BXts1lPeiYcBuM27w2+UWR2vLbuZ3BZspnciUWLKbiOS0lCAPfkj3br+j90tKGUVXMKRcCRj6No84IiP4mrdxQi6FOytpcSWhjpo3+YdwOpalCT4c4l1o+ftQ/yVRWMzI3A9hhkf8QtQ0AW4Rei5Fme0T+vxeagS737JD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 05:19:52PM +0530, Aneesh Kumar K.V wrote:
> Catalin Marinas <catalin.marinas@arm.com> writes:
> > On Mon, Sep 21, 2026 at 08:18:40PM +0530, Aneesh Kumar K.V (Arm) wrote:
> >> @@ -125,7 +126,8 @@ static inline int dma_contiguous_reserve_area(phys_addr_t size,
> >>  	return -ENOSYS;
> >>  }
> >>  static inline struct page *dma_alloc_from_contiguous(struct device *dev,
> >> -		size_t count, unsigned int order, bool no_warn)
> >> +		size_t count, unsigned int order, unsigned int required_order,
> >> +		bool no_warn)
> >>  {
> >>  	return NULL;
> >>  }
> >> @@ -136,7 +138,7 @@ static inline bool dma_release_from_contiguous(struct device *dev,
> >>  }
> >>  /* Use fallback alloc() and free() when CONFIG_DMA_CMA=n */
> >>  static inline struct page *dma_alloc_contiguous(struct device *dev, size_t size,
> >> -		gfp_t gfp)
> >> +		gfp_t gfp, unsigned int align_order)
> >
> > Can we not just bake the alignment further down in these functions
> > rather than getting the callers to pass the {required,align}_order?
> >
> 
> But, we need this to be conditional on CoCo shared allocations. We could
> derive that from attrs and pass attrs instead of align_order, i.e.
> something like:
> 
> 
>  struct page *dma_alloc_from_contiguous(struct device *dev, size_t count,
> -		unsigned int align, unsigned int required_align, bool no_warn)
> +		unsigned int align, unsigned long attrs, bool no_warn)
>  {
> -	if (required_align > CONFIG_CMA_ALIGNMENT)
> +	if (!dma_contiguous_resolve_alignment(attrs, &align))
>  		return NULL;
> -	align = min(max(align, required_align), CONFIG_CMA_ALIGNMENT);
>  
>  	return cma_alloc(dev_get_cma_area(dev), count, align, no_warn);
>  }
> 
> 
> with
> 
> +static bool dma_contiguous_resolve_alignment(unsigned long attrs,
> +					     unsigned int *align)
> +{
> +	unsigned int required_align = 0;
> +
> +	if (attrs & __DMA_ATTR_ALLOC_CC_SHARED)
> +		required_align = get_order(cc_shared_granule_size());
> +	if (required_align > CONFIG_CMA_ALIGNMENT)
> +		return false;
> +
> +	*align = min(max(*align, required_align), CONFIG_CMA_ALIGNMENT);
> +	return true;
> +}

Yes, I think this would work.

-- 
Catalin

