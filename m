Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8430ACD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:35:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E656B6B0384; Mon,  1 Jun 2026 08:35:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E177F6B0385; Mon,  1 Jun 2026 08:35:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D06B56B0386; Mon,  1 Jun 2026 08:35:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC0F56B0384
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:35:25 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 656C91A064B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:35:25 +0000 (UTC)
X-FDA: 84831289410.29.BE3AB06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id BF93F1A000A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:35:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LeJxeT58;
	spf=pass (imf19.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780317323; a=rsa-sha256;
	cv=none;
	b=X431fMn+zCNyW6yKNphV631FFutey2WOZfS3IulFzmzy+iYZAQ4sStgiF0tA5Y9cuhiK84
	C6XsDT82N2ondsN48YEtdZLmi5sdeQ4oT/glujsbNios779Wml/F0MAEfXcp3mBiATgizb
	Pu7TPsZ/Hn7Kp67EYoZiSBGD6QCoBzU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LeJxeT58;
	spf=pass (imf19.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780317323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4D8mKmK+s+4sL4bhA99fPLjzqV9Yidvpyfe324Qy2BE=;
	b=DEO8dUSkHZee+A10zLWWOBJ0j1Ns9sSNj7HfqY1y9asH+LDkR6jjGoWB0kw8KLSkU2gZJr
	ArTR07OvqY7Pwry/iGbjGC+sobgZ3MCPs2FIYsaP8OZMalxnFfwkkSlHWDBglzuD+HKCp6
	NbAPoxT1pRu/cz5qpvg16l7TSF0Lceo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D308840E2F;
	Mon,  1 Jun 2026 12:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B771F00898;
	Mon,  1 Jun 2026 12:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780317322;
	bh=4D8mKmK+s+4sL4bhA99fPLjzqV9Yidvpyfe324Qy2BE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LeJxeT58apk3aiYwTcDP8ZuwOqZlxtg6xsRxAvAegwmbFCDWBr1iXRhj/SzfUMjtg
	 ctd1IuB9RXeyJf73H5q5jKeChTLAWYcR+1nbgKUR4qKmsdz81nh3zUoFDzYbS2ERXF
	 Y3hdyA82gVLA+0qtbBuD6/x2Rds6PCzBM4hgiJpPdmalG12vhHakoRTCQDN2nAjOW0
	 0NhnDNlQdED8swk7O1onCeGs2OQ1ePSxqpK8cEUmqZ96lA55xvPKzhRTt83806PL5b
	 Y3RTz2PHWzhSlpIYI8NjtPR4c1MnsuNAg64LpWlb/TYnFk8mhgdoa1+lY6ZFc8dT/H
	 d8hAdyuD2phxQ==
Date: Mon, 1 Jun 2026 13:35:16 +0100
From: Will Deacon <will@kernel.org>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>, iommu@lists.linux.dev,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pranjal Shrivastava <praan@google.com>,
	Vipin Sharma <vipinsh@google.com>
Subject: Re: [RFC PATCH 3/4] dma-direct: Add API to preserve/restore
 allocations
Message-ID: <ah18hDhjSLxIvb-Y@willie-the-truck>
References: <20260505002737.2213734-1-skhawaja@google.com>
 <20260505002737.2213734-4-skhawaja@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260505002737.2213734-4-skhawaja@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: BF93F1A000A
X-Rspamd-Server: rspam03
X-Stat-Signature: zwtd3w5m3pbrqg9qrpiqu3s63jkqxzi3
X-HE-Tag: 1780317323-59184
X-HE-Meta: U2FsdGVkX18a84DNnybeIqzUcHMKzduz3QivZXqGlJ05AV0YE2TjcQQF3u04p7sDwXGFP3jMKIfM0WfnYAQdrP30ELQ3EMZgxoos0gQVXsLMmd/oZLtYXsQeQnSs3Ufwc5udBB0oeWwamKfZf56qO7wOV5H4dQzX+ed6Ihdld4EYcw+bPMe3M5xb1ql3l+0a4kywIvihVtaiY0s1xjqmLAMRDyRBwb1LDKFXmXuMV7yIY+xD8bvCia8E1MqtuGF96B3/grlISzHzW9yFkVtDdzTLT7nttWkgX2HuqfUZfGapVejpqmM5Yk/P5IKV10c2g+43jyLeQdy21pS03AEw30KvFvqa+9SlzdqDnOyuQsDFMUsgrr9n1brLujK6f5p8A52rQ2N2F4zELZrCN2ghnsWI+Hayf+J8yoquVFJgj0cYGCy2EP858iLHB9ONFwcty0hfjw8S3e7C0vBSl1GxparJSfsMGvW0qC0LJTR+Dzw71ZjGzU2eeUlGXFembeljR3MO+RRNJY/Bn0xKHcuSi0mGqEb6pUT4JgmtNsUlX0DUoXIOYhMNIP0GbgnMrvLnyltrFHIdwdRlfZRje7gDpi+5W2R/In16tzjQBvq0IrfApff23G47e7owSskDLzVe5cesSrF4Eu7CMvLd8TMzQWHVkm9GErtfA/AAcVg6Y+/SMzsCVkfTFimLx1uRM05MTRQDVVPEvE2SQj7V3IDFkDfrB1rxmQA/NNGNzUeYK5WMQ25o/7W5YpgFntvNQwmtkwfV3i9NqUjqdjtSp9Io3NMtFmG/xZPaWic0SByZvh1JEbjXeaK+rUjuc3LoLWGjhXF2oUEYrNxVPWCk8a3XHC3t8AMmW3EmQ/Oc0+EZUWRNqsXGB43MId4vq9jUdKAIRu0TFop5/QhcokbDnUjGIKxAFXKXMcXCFy9kqyjFJU1HVL+FUYVgkKVq0RoSiRZTbiKzgJHTQQoJnNKMnn3
 67i0/oVu
 lr9z2F9gpHkrXBF1xEoB0nrO4BE8ragXKtOxKafoYZI6GrA1zY54HQy1memw+QnPTUTyLaovB7Ez40fnevEArwta1PS8l/LT5w8b/qYzLS3wZc+AnH7N2Fv745uhT9r/Yzbhf+NjaOmScmS551RtbCcrL9CtOpwFlGqP5cMItkAEIFofIHmDYW/6uDSBZ/oRz2Z4rQV7h4MkVomO5X47EbgnCh3VlpoX755CcE1JE8h1cQ4trtBU/4IThc1pcntHKYmq+pyeTsLLmJE7Kx7WPq6OnvC066R62j+y5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 05, 2026 at 12:27:36AM +0000, Samiullah Khawaja wrote:
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

Hmm, it seems a bit overkill to do this just because CMA is compiled
in, especially as it's user-selectable in kconfig.

Maybe you need to iterate over the CMA areas using cma_for_each_area(),
similarly to how you do with the pools?

Will

