Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21EF5CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 19:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF0EE6B009B; Wed, 24 Jun 2026 15:00:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA14F6B009E; Wed, 24 Jun 2026 15:00:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D90A26B009F; Wed, 24 Jun 2026 15:00:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB2086B009B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:00:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0FEFC8DF5A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:00:24 +0000 (UTC)
X-FDA: 84915721968.20.4747831
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id 152D31A000E
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:00:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="dxkro/eu";
	spf=pass (imf19.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782327622;
	b=6kIZ9dZIVUVLM8B+Lcncl9La9yHK6PpNiZPEAanw+MNp7OABBdnAscjQKPwVLIHQor2m73
	y94+eKaZxU+TkL7vSm1Zw/QlhyNFim9HeVweIhNUR5KTe1qgBq24mpKpIHVHnMOcdEpKIu
	zGD8nkxNTiyaF8eABcrae71dkMlkeJI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782327622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uyPzc/lVYNWutlEG7aHFYV3dkzH3OXj7mqtnKUaIHcc=;
	b=hppEBK59O7ilEf8isPPOKsxKToHze9iEgFc5sEgNqvNOBIzEJFPGOy3QLTz1mv7FY5sVB/
	pvSv58rk+BPp+EBbcwZYdCtzX+aQ/mdvIyLsARMI/E0SADoxht322AoYz4dUbUUgkFEU+L
	ExMginNXXVDqKS5XOn28uDWrLmAb2dc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="dxkro/eu";
	spf=pass (imf19.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2c6b7bd4e8dso9065ad.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782327621; x=1782932421; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uyPzc/lVYNWutlEG7aHFYV3dkzH3OXj7mqtnKUaIHcc=;
        b=dxkro/eucXdHeDAUrhYpX3cuL+b3n+Yjw6eEi5kYRASIjXwUq2LSA7ERjcuWNgx1Ph
         WnfT4N4NVZXqnlAliOV9QyZFOkKujj3D0fFf2PLt3Tp1JjI34/L7W1kh4oApksskfpRn
         vENfj9sj1h0D2+Vj866ps8MHGOeQHxA+SwSLwdhC6hfbs/5wakGIsju+IelUpaCBuHAN
         7b1TFUWuktvdKa0ll7hhwZ1aDJZ9i7Kx+ktEcXdaYc6ghs7SD0P2KfSe7ScWnyksLZXH
         srADetVDo0rz1yNJ+4FhOh5DPKGmfKoOs9r6csdt4tfqVS/wayyDWTlwMxYO8j+erjdZ
         LXPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782327621; x=1782932421;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uyPzc/lVYNWutlEG7aHFYV3dkzH3OXj7mqtnKUaIHcc=;
        b=r9fEZcWWiqiidoooxiUPxOplsHAYhDrb4x/j3F8/bYWGwaRDthjPFJaMUArvf9AWwe
         u2UdmPLrPzh0z4xD+qcysMnHu6IYFCJY8VE7fz+hyL8UNir3q/HHGWy4NHORPm52t63O
         YhDzcdQDCl/5sMro42OPIOuwkh93ucJoE59ZY7qrxlLzlnPi/auvOXt44EKViGuWfTFK
         rwiY2XMuuJ66U11AlOEI8EX36vWw+qRXMleLUPZjDMs7igRbORFskMc9NUrqBTYdFTY7
         235tYJzK644xL00KU+nmYUSpEZSS4c0wuPfXVvTZUlp+iTPkTIbr1nKDc8LGscsy7Uin
         Uh+g==
X-Forwarded-Encrypted: i=1; AHgh+Row2ybJLGRtLhMlh1JeALhbJW54Moh2WoPXPKw85l2tCJpR5t8h5r8GMASLUMXn9bB+F8pP+/L7Qg==@kvack.org
X-Gm-Message-State: AOJu0Yx2qjbdiA3BhV+tNLA0geDdbtkRBQ3N0ADyr9jDk4/DzoagpoWs
	EuHRpGuFf6PEKRXjko2UrLS43ghNqFFES4LfTT0vBfb4u0WdOEBBc6ceFSLZsRUmPA==
X-Gm-Gg: AfdE7cnys6CuLqs6n7ekV+I/5pb3JnSwS0ORR14x74fjgGS7rX2fO3z1cYpZVkYnXmE
	tjx+iMUANK/gPxKYF5L48D+L7cWrdlzIjjReXerqllDKbIZQGFXMTlvEwaQxSGs0ah0wxcO6XTb
	T2Ru1OWJRNf0g/rKON1yGWmnXWPLpGii+4Rupe2uE98X7fHkgrVJXhW4fHSFO7g+DCPWd8ohV/3
	nadPpdB6+V69o1E3oX2ae+jlAnygcdH9hKyuaO3pjIHmho9oF4PKoOCiQgMFgowqn3haOAzvwYH
	pLbqRq7m7C6YYCP4rNyDaWI1E4yhHgEYGcaP5ZIjQpODqDlOD4hcS2I+fPbbENfL7g+gz5RwtLg
	7sLMYNyuvwcgKw2NIEc7hoGRl3OZtRyNj5CajOGE3OHSgpRi3XNwPGSCuku9CeEZQ1fOapJRgAX
	iwsS3U/9GB4A0AsxQg1XMSvbdXY5WVo5+kW9KMRPNUpZdPQCT/31p21DLRAEvTygt47agMk/5f8
	VI/Cw4S
X-Received: by 2002:a17:902:c952:b0:2ba:6518:e4d8 with SMTP id d9443c01a7336-2c7f77b6733mr402135ad.20.1782327619882;
        Wed, 24 Jun 2026 12:00:19 -0700 (PDT)
Received: from google.com (25.75.145.34.bc.googleusercontent.com. [34.145.75.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845a40d23ccsm3593388b3a.36.2026.06.24.12.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 12:00:19 -0700 (PDT)
Date: Wed, 24 Jun 2026 19:00:15 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Pranjal Shrivastava <praan@google.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, 
	Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Robin Murphy <robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>, iommu@lists.linux.dev, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vipin Sharma <vipinsh@google.com>
Subject: Re: [RFC PATCH 3/4] dma-direct: Add API to preserve/restore
 allocations
Message-ID: <ajwmXYOW080zVRLw@google.com>
References: <20260505002737.2213734-1-skhawaja@google.com>
 <20260505002737.2213734-4-skhawaja@google.com>
 <aiceKYmc323G7tBs@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aiceKYmc323G7tBs@google.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 152D31A000E
X-Rspam-User: 
X-Stat-Signature: a88jyryrwzpm9qxbtjiwzyo41j3njgiu
X-HE-Tag: 1782327621-505772
X-HE-Meta: U2FsdGVkX18sI9Ll/yJEI8phiMy8+hny7xJ1TMimues3WMA78Rm+nWjVGH9mRl0Q+Fn7zMUMJ+daFF0wBRVlTQ2uGh/4thWblUfeXzX/VHtUXeM06xqOgdBXvU2Rmb2wZZIdMNuNLyee2TfWFVve3ZdaMBTc6IRm2YAfVAGhywYVAZNC3ZmagiBn9qXEE8kE77NXRx/engFsNSL7OkVTR9iqVzXwDwxobTpdYv3lMNa7f+vB9OPNWTK1ARQ9qJnsM75kXhY0bo2YdbqOqwTidYMSAHgGIBFL3gXfBgQr5Zh9jgt2A3/jQ4ciSqsISds/yvQst/b/Io63FYKIo8NDlllGnQ6OsazRhodRK7N5WB/lq2EuzF3RatxxAwcojSTqWCqNn1lgkpKhK/RW1C6ZQSDXko/LHrvciq7eJvd5j4C8BTM/2RXL2PBwOflkWNmKelH0/mwfz5pY6mTRiD09zps1HRDsMxIS3N+Q6HHzBSgcxLa9Dnxq8p1HWnyqEGrKeMrzqmFEKRvGFgvc1bNC0RKSeEJuzHJPVZzxZLyfGK/lJhSfkPXqt311F4HR/mVZn6h6HH8l4cfE93PGKh3CIqhXw9SSrl8768UsL+Hc3e6KRt6wXxm1qNZ2XAA/2eJh900DmT3zT3Q9XdXQ7aY+OFsIkMLwsuGrrqA4h5UBMfpKz94feTbcJW++oHbzjO70HnfzZAFajrNRciVdMc1ZgWeOflMngZsRcIVybGnW++/KeNCQzRzabDNQJxkn4HTgt2pLaoUCgUf2Lsl21roLi2HKbw+axw5xsZD2zfMJgJLPe+WxZZQVQfQI2czcJmOa4wXajE9aYfveb/JThLWRg+pQeZglZI03UGAj1LNUM94QL7Qb5zscfHjgfOEIKjMN7Yv99jMcapIrk2B+fs/2CmHFz8URTRuwwIEPLG8+Euug2MJtzMgnFq2hStlE/T/pXfzCJIN+fJajRtxiUFi
 IHB9o0Ke
 XUGpqdLHVo5tzZt0XuLiqXPgACpHjG7Hp1mWHmxml00hCmeqsRMK+WpskSHCcD0WdNr4M7fE60oERToMxr7t1SB6fY+Zqf6ymTX3FpA4+Bm8RN+Ac98I9GvpCYHtqYsdxzf9c/ucHGpuxAHQo6jdmABLmYJvVD+V/fbiBZ41KwNrnGWQgsyw6cCK2ROC/8qkDe3d1LzcajLBG6TZDRTuD2K1xBOXy66ldUEQsUCAaJAepVwKrXhA0H6pykQhuKeBWco7GaJuudIfdieAUmg32HxLa+skBRH1j7+UVy2RtrKWx1R2q1Jo21KK07ni/mYfP+k4TEnUISE673aTjfLrfPdQ595nlx8r3eSVk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 07:55:21PM +0000, Pranjal Shrivastava wrote:
>On Tue, May 05, 2026 at 12:27:36AM +0000, Samiullah Khawaja wrote:
>> Add an API to preserve/restore the DMA direct allocation for liveupdate.
>> The underlying memory is preserved/restored using KHO. During restore
>> the memory is setup based on the device configuration, gfp flags and
>> allocation attributes. Once restored, the driver can use the usual
>> dma_free* API to deallocate the restored DMA allocation.
>>
>> This API will be used to add support in dma_alloc* APIs to
>> preseve/restore the DMA allocations.
>>
>> Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
>> ---
>>  include/linux/dma-direct.h |  29 +++++++
>>  kernel/dma/Kconfig         |   3 +
>>  kernel/dma/direct.c        | 163 +++++++++++++++++++++++++++++++++++++
>>  3 files changed, 195 insertions(+)
>>
>
>[...]
>
>> diff --git a/kernel/dma/Kconfig b/kernel/dma/Kconfig
>> index bfef21b4a9ae..d92852942c6c 100644
>> --- a/kernel/dma/Kconfig
>> +++ b/kernel/dma/Kconfig
>> @@ -265,3 +265,6 @@ config DMA_MAP_BENCHMARK
>>  	  performance of dma_(un)map_page.
>>
>>  	  See tools/testing/selftests/dma/dma_map_benchmark.c
>> +
>> +config DMA_LIVEUPDATE
>> +	bool "Enable preservation of DMA direct allocations"
>
>Nit: depends on LIVEUPDATE?

Agreed I will add this.
>
>> diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
>> index ec887f443741..c2b98f91900a 100644
>> --- a/kernel/dma/direct.c
>> +++ b/kernel/dma/direct.c
>> @@ -6,6 +6,8 @@
>>   */
>>  #include <linux/memblock.h> /* for max_pfn */
>>  #include <linux/export.h>
>> +#include <linux/kexec_handover.h>
>> +#include <linux/kho/abi/dma_alloc.h>
>>  #include <linux/mm.h>
>>  #include <linux/dma-map-ops.h>
>>  #include <linux/scatterlist.h>
>> @@ -307,6 +309,167 @@ void *dma_direct_alloc(struct device *dev, size_t size,
>>  	return NULL;
>>  }
>>
>> +#ifdef CONFIG_DMA_LIVEUPDATE
>> +int dma_direct_preserve_allocation(struct device *dev, void *cpu_addr,
>> +				   size_t size, dma_addr_t dma_handle,
>> +				   unsigned long attrs, u64 *state)
>> +{
>> +	struct dma_alloc_ser *ser;
>> +	int ret;
>> +
>> +	if (!kho_is_enabled())
>> +		return -EOPNOTSUPP;
>> +
>> +	if (IS_ENABLED(CONFIG_DMA_CMA))
>> +		return -EOPNOTSUPP;
>> +
>> +	if ((attrs & DMA_ATTR_NO_KERNEL_MAPPING) &&
>> +	    !force_dma_unencrypted(dev) && !is_swiotlb_for_alloc(dev))
>> +		return -EOPNOTSUPP;
>> +
>> +	if (IS_ENABLED(CONFIG_ARCH_HAS_DMA_ALLOC) &&
>> +	    !dev_is_dma_coherent(dev) &&
>> +	    !is_swiotlb_for_alloc(dev))
>> +		return -EOPNOTSUPP;
>> +
>> +	if (IS_ENABLED(CONFIG_DMA_GLOBAL_POOL) &&
>> +	    !dev_is_dma_coherent(dev))
>> +		return -EOPNOTSUPP;
>> +
>> +	if (IS_ENABLED(CONFIG_DMA_COHERENT_POOL) &&
>> +	    dma_is_from_pool(dev, cpu_addr, PAGE_ALIGN(size)))
>> +		return -EOPNOTSUPP;
>> +
>> +	ser = kho_alloc_preserve(sizeof(*ser));
>> +	if (IS_ERR(ser))
>> +		return PTR_ERR(ser);
>> +
>> +	ser->page_phys = dma_to_phys(dev, dma_handle);
>> +	ser->force_decrypted = force_dma_unencrypted(dev);
>> +	ser->size = size;
>> +
>> +	ret = kho_preserve_pages(phys_to_page(ser->page_phys),
>> +				 size >> PAGE_SHIFT);
>
>Should this be `PAGE_ALIGN(size) >> PAGE_SHIFT` OR
>`DIV_ROUND_UP(size, PAGE_SIZE)`?
>
>Otherwise, if size is small, say, size == 64-bytes, we preserve 0 pages?
>
>Also, IIRC, even with PAGE_ALIGN, preserving just the requested pgcount
>is not enough because buddy allocator allocates in order-N.
>
>For e.g. if a driver requests 20KB (5 pages), the buddy allocator
>fulfills it with an order-3 block (8 pages).
>
>Now, if we only tell KHO to preserve 5 pages, the remaining 3 pages are
>free in the new kernel. When the driver eventually tears down and calls
>dma_free_coherent(), dma_direct_free() will call
>__free_pages(page, get_order(size)), which will attempt to free all 8
>pages, causing a double-free panic on the 3 unpreserved pages?
>
>Should we be preserving exactly 1 << get_order(size) pages as per buddy?
>Same applies to unpreserve, and restore.

Agreed. I will update this and also make sure it is covered in the kunit
tests.
>
>> +	if (ret) {
>> +		kho_unpreserve_free(ser);
>> +		return ret;
>> +	}
>> +
>> +	*state = virt_to_phys(ser);
>> +	return 0;
>> +}
>> +
>> +void dma_direct_unpreserve_allocation(struct device *dev, u64 state)
>> +{
>> +	struct dma_alloc_ser *ser;
>> +
>> +	if (!kho_is_enabled())
>> +		return;
>> +
>> +	ser = phys_to_virt(state);
>> +	kho_unpreserve_pages(phys_to_page(ser->page_phys),
>> +			     ser->size >> PAGE_SHIFT);
>> +	kho_unpreserve_free(ser);
>> +}
>> +
>> +void *dma_direct_restore_allocation(struct device *dev, size_t size,
>> +				    dma_addr_t *dma_handle, gfp_t gfp,
>> +				    unsigned long attrs, u64 state)
>
>Are we relying on the caller to pass same attrs? So, a buffer with
>non-coherent attrs can be mapped with coherent attrs in the new kernel.
>Could this cause side-effects? Should we check for such driver bugs with
>a WARN here while comparing older attrs with the newer ones too?
>
>Coherency breaking due to subtle driver bugs is very painful to debug :/

Hmm... this is interesting. The dma_alloc API relies on the caller to
have consistent attrs accross allocation and free. But when updating
kernel where driver could have been updated, we have to be careful.

Agreed.. I will handle this properly by making sure that the new attr is
compatible with the preserved attr.
>
>> +{
>> +	bool remap = false, set_uncached = false;
>> +	struct dma_alloc_ser *ser = NULL;
>> +	struct page *page;
>> +	void *cpu_addr;
>> +
>> +	if (!kho_is_enabled())
>> +		return NULL;
>> +
>> +	ser = phys_to_virt(state);
>> +	page = phys_to_page(ser->page_phys);
>
>[...]
>
>> +
>> +	/*
>> +	 * Remapping will be blocking so return error. The preserved memory
>> +	 * might be already decrypted in the previous kernel, but the decryption
>> +	 * call is not guaranteed to be non-blocking so return error always if
>> +	 * decryption is required.
>> +	 */
>> +	if ((remap || force_dma_unencrypted(dev)) &&
>> +	    dma_direct_use_pool(dev, gfp))
>> +		return NULL;
>> +
>> +	/*
>> +	 * Encryption scheme changed between two kernels and this might cause
>> +	 * issues if device/driver is not handling it properly.
>> +	 */
>> +	WARN_ON_ONCE(ser->force_decrypted != force_dma_unencrypted(dev));
>> +
>> +	/*
>> +	 * arch_dma_prep_coherent() should make sure that any cache lines from
>> +	 * the previous kernel, if the device was coherent previously or cached
>> +	 * mapping in this kernel during init are not problamatic for
>> +	 * non-coherent allocations.
>> +	 */
>> +	if (remap) {
>> +		pgprot_t prot = dma_pgprot(dev, PAGE_KERNEL, attrs);
>> +
>> +		if (force_dma_unencrypted(dev))
>> +			prot = pgprot_decrypted(prot);
>> +
>> +		arch_dma_prep_coherent(page, size);
>> +
>> +		cpu_addr = dma_common_contiguous_remap(page, size, prot,
>> +						       __builtin_return_address(0));
>> +		if (!cpu_addr)
>> +			return NULL;
>
>Should we be kho_restore_free-ing on all these error paths?
>We only seem to be kho_restore_free-ing on the success path.
>Same for kho_restore_pages.. if we return an error here, we don't
>restore the preserved pages? Are we leaking those too?

This is purposefully leaking the memory here. This is because during
liveupdate, this device could be using this memory and freeing it means
that this might cause a memory corruption that would pretty difficult to
debug.
>
>> +	} else {
>> +		cpu_addr = page_address(page);
>> +		if (dma_set_decrypted(dev, cpu_addr, size))
>> +			return NULL;
>> +	}
>> +
>> +	if (set_uncached) {
>> +		arch_dma_prep_coherent(page, size);
>> +		cpu_addr = arch_dma_set_uncached(cpu_addr, size);
>> +		if (IS_ERR(cpu_addr))
>> +			return NULL;
>> +	}
>> +
>> +	*dma_handle = phys_to_dma_direct(dev, ser->page_phys);
>> +
>> +	/*
>> +	 * Cannot free the restored pages on error here as these might be in use
>> +	 * by a device with direct allocation in the previous kernel.
>> +	 */


Check this comment that explains the logic behind not freeing. I think I
will move it up.
>> +	WARN_ON(!kho_restore_pages(ser->page_phys,
>> +				   ser->size >> PAGE_SHIFT));
>> +	kho_restore_free(ser);
>> +	return cpu_addr;
>> +}
>> +#endif
>> +
>>  void dma_direct_free(struct device *dev, size_t size,
>>  		void *cpu_addr, dma_addr_t dma_addr, unsigned long attrs)
>>  {
>
>Thanks,
>Praan

Thanks,
Sami

