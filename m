Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C1E5CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 19:55:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0A796B0005; Mon,  8 Jun 2026 15:55:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABB4B6B0088; Mon,  8 Jun 2026 15:55:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A9F46B008A; Mon,  8 Jun 2026 15:55:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C6516B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:55:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 522C51A02B2
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 19:55:33 +0000 (UTC)
X-FDA: 84857800146.14.C05681D
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf17.hostedemail.com (Postfix) with ESMTP id 660C84000C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 19:55:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i28vDU+l;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of praan@google.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780948531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ns7tVcW9XWyLcZvttsJ0K9GITGIgrVGAf3TGrFOv8Tc=;
	b=MSCH2MjxclCh41fDGJQocCilKb1Eqdm34fyW8krPQv2JKKNbJz7xXVVz9Cvux1FNuEzjMX
	0rkbmEu0BrQPFn87zDhrgqD2gFS2wIKWdHxi7kD42znInbkfSulN7I3b04twwbS2g7Fl7c
	5vx4/EDZk8NlGtH/ggRzbWQQhDSkDPg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i28vDU+l;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of praan@google.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780948531;
	b=267dXsthApJvDDgW7Jhfp5wHaUulm4+JZM07HUX1btyPkHcRvp0YJ8nKuLZ/fnJbR4k0ra
	nxchhSW5bpHZGuS2gmrzUUnQoxqhNqY32TZe/LMyN8GLWw7/SmNcfyE67fOyxRw7bmzLAu
	1wah/tEbQ0/RVTM7iDlinr2IhLLa1js=
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-133362c30cfso33855c88.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 12:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780948530; x=1781553330; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ns7tVcW9XWyLcZvttsJ0K9GITGIgrVGAf3TGrFOv8Tc=;
        b=i28vDU+lDa6n6cPEvTpaukaBzF15ms0fsIMTbVIhtihQdTXodQcMtpMY4++0mhkx0j
         ZlAZL6CYHk4ltaqahxQpWeoGouZh9xYvbqSlFk7NG6vr/xcjs6Pf8hVhp1G0ixn969Ah
         ms54GQvBOyQ1jFOzVK++O6Wif3yyQ1VqVS5PNTXuwHIZkdZIR+A5Hqb8uTE6eF28Wosq
         md3WojOmKpUSOVdopZw1nc/cL/t8VkE0IP1jURV3XIF/R0BEQWIU8MEHJr6DQyJNLrsC
         ix5FaLFb/3NfjKqaHE011czg0YhOm4HCLVOlQvhIZkxiSD7Zivge+ecn7mKUMxDImVpx
         9+sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780948530; x=1781553330;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ns7tVcW9XWyLcZvttsJ0K9GITGIgrVGAf3TGrFOv8Tc=;
        b=mq3pLGxStCSRhQ+9uWSi7JaXsnKT2DpPc6ClzKPKP2sAIZ2YmeAWRc/eTdt/jUQ12r
         OH3AjVP3KKDXFRDEa4GKX/mPoZV7KPZplPYzFWODgjUHU7hRY6bMxYm3n/f/dFQbA7Ix
         T4L89e57wN32J66TYtovYe5kuXEeUTEc9IPF+Cpm6r1eR6iWPz8fMLtOIQX0TwTxthUy
         w4trwD6KAoFYybmKF4CJubLnTFGHoplqms/Xgt7wiWf2E9CrVWdVb3CdT8kNoOUhGBbR
         c5l0VDUsWdMVuxqFTA6NYfMuPMMyA2XfgkIuzWXkClPaFJzwHBoUlvgNbGyQHIFiRzwm
         1GhA==
X-Forwarded-Encrypted: i=1; AFNElJ9O0w+cJF6BRKj0F9IxWtQ8SmHzTqB84gTOhP+n6HTOYiyPG4I4jQPlyJ/RVDzdPkB6Z6s+L41hHA==@kvack.org
X-Gm-Message-State: AOJu0YwWCWj1khMpF+LIy0cHH9uIWhBZkkq8XwmLhYyxr5FnC8slNP0C
	+gE8J95SbzL9UPj3jKZYLCj0+dnOECLCgCNe9l+wQcuTBKmSWQs9EMf3KzjvGUTLQw==
X-Gm-Gg: Acq92OHh552h4bnDnJ60+Nfyd3k3u0D5Dnyx5siL03cpleXONQJ3h8rSJhF6CYhdEKK
	ZOYSzvc7+ZAa5LzxM90ENek5nIKJNYX7RBGjZgCMUjD+qySvAtvuM+8qjXisAq5fKt3V0Isxlvh
	wLxcPxkjtqr5hWP/NLQhhT0yYRIh5dnYpAwTfUawRqwa6JnnD+oSRrSIsLItAHssJ7INWFgFCp5
	PS1ttqK24T+we4Ni5bf6LnJz9hWfAVJXtZczWHtHhz1BZJtf9aYBGaIHN/YuLBcZnqZFlSQ0utB
	5s7otKchNdUhH2v4ERkQdjGLu72N0Bqu7/PR358nwHp5SY4LGz64w5sjBsTavTN97a1is9PhDG2
	c6GhwRYiYJ6wzux+EweWAJyyxutTm1HEKZTC0hKsQObDN5ccQYkMGx1Q7pM/Q0AijerKYca3szo
	FQE7BWdKp6y/JBpsh9scEJltJYYVhG+CmOAYhtSlMQPTXlIWhUBGmfKtBItwbiDPijgWZWyxQ=
X-Received: by 2002:a05:7022:170e:b0:138:888:e99d with SMTP id a92af1059eb24-1380888eb22mr103345c88.32.1780948529234;
        Mon, 08 Jun 2026 12:55:29 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30791f6381fsm9666160eec.0.2026.06.08.12.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 12:55:28 -0700 (PDT)
Date: Mon, 8 Jun 2026 19:55:21 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>, iommu@lists.linux.dev,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vipin Sharma <vipinsh@google.com>
Subject: Re: [RFC PATCH 3/4] dma-direct: Add API to preserve/restore
 allocations
Message-ID: <aiceKYmc323G7tBs@google.com>
References: <20260505002737.2213734-1-skhawaja@google.com>
 <20260505002737.2213734-4-skhawaja@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260505002737.2213734-4-skhawaja@google.com>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: s4khi3n8j7n8gu76371yukmkn75zephk
X-Rspamd-Queue-Id: 660C84000C
X-HE-Tag: 1780948531-634678
X-HE-Meta: U2FsdGVkX1+/CrnbTtHv0kVUXNtyP1h03ff1sUcxQBSUY0xy752//zNDLZQoThpvcADPfMF+eynBxpzdPs+9XWNmdYm6//gLCwyNtKUmK+xXYYGNrVClMr+bdF+UMXDWaXtwwxqH6B3PB4HV1dh1FLzvAdQahqodEpw9MYcebrAbsHQh9H2pdMshgniIMz8aWRvGPzcIFHzplsHTSRmaigS3PdYxpLNACRKxOYbG96S4dJLFHNIgUDkZwY5a0jLrcCIUbteTrdtcMJfbs982PR4pUFfA9lllyY4cRvGApg9gyCOBN/cnuEh8RdSbtr1KmwsharMXu9HK2HyNdkU2jN9M3qRB59+P2Z5hBkYd/PS6RiW2eL72pg0nhwei5BUpsJFaduBBE1vAVwHSBW8lO4oI44/+gtWESZpYLcmNVN8WiqTKl1OE34VEaaKxOvcPsoeg5330DCIOtvRfHYF34YnVG6afuFPyWfg/pQwBNyKNQ9KtUgpXZTsEcjKH74OXZL7kScWZI/egZAUi3PY+ltgIfOoxphtX5sCXrax0/WuUxE/ShRLu1wpXRljlm+m13GlDE85B0hIYfQpBsQj7fAOWMeVPup3svK35ezyY+GjEg+KergOCtRjoniVd5TV6McGeNXXvZgFH99bNjfXxQM1y2dMaw7RpcmkjJcpax+Sm4BHfYJNmbqirI/MQ7E5n9CFfIuKHHoi5v183mOeGAjQQyY0xrIiV6CeNXgjA9euK2sZRABcKbsnPR3EguM2akpex7y+EU1+i5QQhs6uxP6KFyowvlmYcIo0YR+D+4d2NhnCNWqXoI1L5snjvGtDm77Ux/UE1sauG1I3Yv2RIBu7QSVba4YOYZnVUNbZqQB7ZbM30EugiDQSWoL4D8/2DBas9JWwGsoC4c52rgcCJjHXQAZDFE08FYq7ZII0bN9F0+3iF4s6zoPX9zoA8fD/HVDLPhCwXVmxdFQULKGI
 /Rcfj9so
 KuVWT+jmVTTNM1DufA5p6/8V4yKWdlHwkDSowczCl1+ohZ2tiDw7qsc6hO1hugpfl1zN64FWsojBkn8QJSm2XpdtHobr88T+y1upgn2VhttuwaoInjXXyetx4Cv659+ruQbXskTrVltEf78igQQA6lWJ162H0PmavVQxsfsSNpbFF1QwzK6NkyVF3oEOQs5lM51DOk+xkwcWSBeiwR1nxzZAUobFjrHmxFFJ++XFhkdAXLNQn+RH84nxFOIDsGvvTXrmqWGTGoDS0JvfsvXBNC4xUgqfuJ4SOBGYYUiY6ZR9Vpx2LyTqkQNWIPXCJ26pC5p5S0FupyPN1DU+VlcPbDnSSBl2c5Du3JFhgM2+sv8sj/XpxqRemAX9+dsaEd+1IYd99hznMJnJrhBeMd9t9CFPCS2aZz0YNMJtNJXm/xWePa99edS9rHxBS5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 05, 2026 at 12:27:36AM +0000, Samiullah Khawaja wrote:
> Add an API to preserve/restore the DMA direct allocation for liveupdate.
> The underlying memory is preserved/restored using KHO. During restore
> the memory is setup based on the device configuration, gfp flags and
> allocation attributes. Once restored, the driver can use the usual
> dma_free* API to deallocate the restored DMA allocation.
> 
> This API will be used to add support in dma_alloc* APIs to
> preseve/restore the DMA allocations.
> 
> Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
> ---
>  include/linux/dma-direct.h |  29 +++++++
>  kernel/dma/Kconfig         |   3 +
>  kernel/dma/direct.c        | 163 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 195 insertions(+)
> 

[...]

> diff --git a/kernel/dma/Kconfig b/kernel/dma/Kconfig
> index bfef21b4a9ae..d92852942c6c 100644
> --- a/kernel/dma/Kconfig
> +++ b/kernel/dma/Kconfig
> @@ -265,3 +265,6 @@ config DMA_MAP_BENCHMARK
>  	  performance of dma_(un)map_page.
>  
>  	  See tools/testing/selftests/dma/dma_map_benchmark.c
> +
> +config DMA_LIVEUPDATE
> +	bool "Enable preservation of DMA direct allocations"

Nit: depends on LIVEUPDATE?

> diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
> index ec887f443741..c2b98f91900a 100644
> --- a/kernel/dma/direct.c
> +++ b/kernel/dma/direct.c
> @@ -6,6 +6,8 @@
>   */
>  #include <linux/memblock.h> /* for max_pfn */
>  #include <linux/export.h>
> +#include <linux/kexec_handover.h>
> +#include <linux/kho/abi/dma_alloc.h>
>  #include <linux/mm.h>
>  #include <linux/dma-map-ops.h>
>  #include <linux/scatterlist.h>
> @@ -307,6 +309,167 @@ void *dma_direct_alloc(struct device *dev, size_t size,
>  	return NULL;
>  }
>  
> +#ifdef CONFIG_DMA_LIVEUPDATE
> +int dma_direct_preserve_allocation(struct device *dev, void *cpu_addr,
> +				   size_t size, dma_addr_t dma_handle,
> +				   unsigned long attrs, u64 *state)
> +{
> +	struct dma_alloc_ser *ser;
> +	int ret;
> +
> +	if (!kho_is_enabled())
> +		return -EOPNOTSUPP;
> +
> +	if (IS_ENABLED(CONFIG_DMA_CMA))
> +		return -EOPNOTSUPP;
> +
> +	if ((attrs & DMA_ATTR_NO_KERNEL_MAPPING) &&
> +	    !force_dma_unencrypted(dev) && !is_swiotlb_for_alloc(dev))
> +		return -EOPNOTSUPP;
> +
> +	if (IS_ENABLED(CONFIG_ARCH_HAS_DMA_ALLOC) &&
> +	    !dev_is_dma_coherent(dev) &&
> +	    !is_swiotlb_for_alloc(dev))
> +		return -EOPNOTSUPP;
> +
> +	if (IS_ENABLED(CONFIG_DMA_GLOBAL_POOL) &&
> +	    !dev_is_dma_coherent(dev))
> +		return -EOPNOTSUPP;
> +
> +	if (IS_ENABLED(CONFIG_DMA_COHERENT_POOL) &&
> +	    dma_is_from_pool(dev, cpu_addr, PAGE_ALIGN(size)))
> +		return -EOPNOTSUPP;
> +
> +	ser = kho_alloc_preserve(sizeof(*ser));
> +	if (IS_ERR(ser))
> +		return PTR_ERR(ser);
> +
> +	ser->page_phys = dma_to_phys(dev, dma_handle);
> +	ser->force_decrypted = force_dma_unencrypted(dev);
> +	ser->size = size;
> +
> +	ret = kho_preserve_pages(phys_to_page(ser->page_phys),
> +				 size >> PAGE_SHIFT);

Should this be `PAGE_ALIGN(size) >> PAGE_SHIFT` OR 
`DIV_ROUND_UP(size, PAGE_SIZE)`?

Otherwise, if size is small, say, size == 64-bytes, we preserve 0 pages?

Also, IIRC, even with PAGE_ALIGN, preserving just the requested pgcount
is not enough because buddy allocator allocates in order-N.

For e.g. if a driver requests 20KB (5 pages), the buddy allocator 
fulfills it with an order-3 block (8 pages).

Now, if we only tell KHO to preserve 5 pages, the remaining 3 pages are 
free in the new kernel. When the driver eventually tears down and calls
dma_free_coherent(), dma_direct_free() will call 
__free_pages(page, get_order(size)), which will attempt to free all 8 
pages, causing a double-free panic on the 3 unpreserved pages?

Should we be preserving exactly 1 << get_order(size) pages as per buddy?
Same applies to unpreserve, and restore.

> +	if (ret) {
> +		kho_unpreserve_free(ser);
> +		return ret;
> +	}
> +
> +	*state = virt_to_phys(ser);
> +	return 0;
> +}
> +
> +void dma_direct_unpreserve_allocation(struct device *dev, u64 state)
> +{
> +	struct dma_alloc_ser *ser;
> +
> +	if (!kho_is_enabled())
> +		return;
> +
> +	ser = phys_to_virt(state);
> +	kho_unpreserve_pages(phys_to_page(ser->page_phys),
> +			     ser->size >> PAGE_SHIFT);
> +	kho_unpreserve_free(ser);
> +}
> +
> +void *dma_direct_restore_allocation(struct device *dev, size_t size,
> +				    dma_addr_t *dma_handle, gfp_t gfp,
> +				    unsigned long attrs, u64 state)

Are we relying on the caller to pass same attrs? So, a buffer with 
non-coherent attrs can be mapped with coherent attrs in the new kernel.
Could this cause side-effects? Should we check for such driver bugs with
a WARN here while comparing older attrs with the newer ones too?

Coherency breaking due to subtle driver bugs is very painful to debug :/

> +{
> +	bool remap = false, set_uncached = false;
> +	struct dma_alloc_ser *ser = NULL;
> +	struct page *page;
> +	void *cpu_addr;
> +
> +	if (!kho_is_enabled())
> +		return NULL;
> +
> +	ser = phys_to_virt(state);
> +	page = phys_to_page(ser->page_phys);

[...]

> +
> +	/*
> +	 * Remapping will be blocking so return error. The preserved memory
> +	 * might be already decrypted in the previous kernel, but the decryption
> +	 * call is not guaranteed to be non-blocking so return error always if
> +	 * decryption is required.
> +	 */
> +	if ((remap || force_dma_unencrypted(dev)) &&
> +	    dma_direct_use_pool(dev, gfp))
> +		return NULL; 
> +
> +	/*
> +	 * Encryption scheme changed between two kernels and this might cause
> +	 * issues if device/driver is not handling it properly.
> +	 */
> +	WARN_ON_ONCE(ser->force_decrypted != force_dma_unencrypted(dev));
> +
> +	/*
> +	 * arch_dma_prep_coherent() should make sure that any cache lines from
> +	 * the previous kernel, if the device was coherent previously or cached
> +	 * mapping in this kernel during init are not problamatic for
> +	 * non-coherent allocations.
> +	 */
> +	if (remap) {
> +		pgprot_t prot = dma_pgprot(dev, PAGE_KERNEL, attrs);
> +
> +		if (force_dma_unencrypted(dev))
> +			prot = pgprot_decrypted(prot);
> +
> +		arch_dma_prep_coherent(page, size);
> +
> +		cpu_addr = dma_common_contiguous_remap(page, size, prot,
> +						       __builtin_return_address(0));
> +		if (!cpu_addr)
> +			return NULL;

Should we be kho_restore_free-ing on all these error paths?
We only seem to be kho_restore_free-ing on the success path.
Same for kho_restore_pages.. if we return an error here, we don't
restore the preserved pages? Are we leaking those too?

> +	} else {
> +		cpu_addr = page_address(page);
> +		if (dma_set_decrypted(dev, cpu_addr, size))
> +			return NULL;
> +	}
> +
> +	if (set_uncached) {
> +		arch_dma_prep_coherent(page, size);
> +		cpu_addr = arch_dma_set_uncached(cpu_addr, size);
> +		if (IS_ERR(cpu_addr))
> +			return NULL;
> +	}
> +
> +	*dma_handle = phys_to_dma_direct(dev, ser->page_phys);
> +
> +	/*
> +	 * Cannot free the restored pages on error here as these might be in use
> +	 * by a device with direct allocation in the previous kernel.
> +	 */
> +	WARN_ON(!kho_restore_pages(ser->page_phys,
> +				   ser->size >> PAGE_SHIFT));
> +	kho_restore_free(ser);
> +	return cpu_addr;
> +}
> +#endif
> +
>  void dma_direct_free(struct device *dev, size_t size,
>  		void *cpu_addr, dma_addr_t dma_addr, unsigned long attrs)
>  {

Thanks,
Praan

