Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E00BCCA5FE4
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:44:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BD4F6B008C; Sat,  3 Oct 2026 17:44:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66DBD6B00A4; Sat,  3 Oct 2026 17:44:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55EC06B00A5; Sat,  3 Oct 2026 17:44:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C3546B008C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:44:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ACB84160A08
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:44:53 +0000 (UTC)
X-FDA: 85282645266.09.8DBCA7A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4427B80007
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:44:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=4Kwn9ykj;
	spf=pass (imf02.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791063892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PRCu0Kt8JudtLQU7puVFYQ3X0LQWTWd0xA6QLuOvzi4=;
	b=PRwYD8XODktq3VAB4OcCaajz0jgm0DN0Ddj/JeVy3VdWrRZRVUJEhtDzMRiLqBk11D0r+L
	exD4lUYKhQM8MziLkNPw+y+Ig5DDVEgqxMExNtZ7yYn94D8RSUwfazmsLngxjjN3lgchub
	tyD+GF9MI3lDPPmjLljXPjZkpY7pnWE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791063892;
	b=33+wsI33xe31EoBRae24eVM7F1kgJd4u76Csor1ScPC52bTYBaXSPbx6QTfLGJZlBpGqsS
	3+gD9L3nlsgifHtaWMhkYQT64expqp5TMpd+Q+XUiKy/SQSlo6DNDUBsnpDg1e+5iZrCm0
	m/wFMyQ7594XO3umU8qpJD0icetiGvA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=4Kwn9ykj;
	spf=pass (imf02.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=PRCu0Kt8JudtLQU7puVFYQ3X0LQWTWd0xA6QLuOvzi4=; b=4Kwn9ykjncxT4a81L4rkYGMdWy
	fKJdEWHGSH5Ne5QIzNptseYoYOxSB54H6Zps6+hOKbHhCFJg/yTqIe+LgWucSspZJTaXCfbnhyKYO
	2eesTTy+4xU73OhrpknCWRKq+lk2D7VTmv2B/8wg0gfLksjaUYED+ogZ2BeLSELv4jPOi62JL97Fz
	aoTEA9GlrKzjCr7ea8mDQ5L5rc9r1I+j/R49PU7mJko+tsJnLrxvAs94J8zx1iozVfkGGW7SZzHHC
	SHCTjwI1Dvw4Ue/jCfFoBjXka9KE0ScDoOT4W+omS+YjuGwVryfBW0jFhOWF02oLzS5phgHIBvyvJ
	Iz6uEVmw==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xD7X2-0000000E5oE-0sGB;
	Sat, 03 Oct 2026 21:44:36 +0000
Message-ID: <7ce092a4-5c85-4391-809a-3d04b638a722@infradead.org>
Date: Sat, 3 Oct 2026 14:44:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC: DMA_PMD 01/22] iommu/dma: introduce CONFIG_DMA_PMD and
 metadata table
To: Luigi Rizzo <lrizzo@google.com>, Luigi Rizzo <rizzo.unipi@gmail.com>,
 Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich
 <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima
 <kuniyu@google.com>, Joshua Washington <joshwash@google.com>,
 Harshitha Ramamurthy <hramamurthy@google.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Tony Nguyen <anthony.l.nguyen@intel.com>,
 Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Michael Chan <michael.chan@broadcom.com>,
 Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev,
 netdev@vger.kernel.org, linux-mm@kvack.org, driver-core@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261003212241.3432303-1-lrizzo@google.com>
 <20261003212241.3432303-2-lrizzo@google.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20261003212241.3432303-2-lrizzo@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4427B80007
X-Stat-Signature: ekhutj5ymh8hy4u3ao3kbmswdqjw5581
X-Rspam-User: 
X-HE-Tag: 1791063891-247861
X-HE-Meta: U2FsdGVkX18vrjEq8JEhQ09uvZFJlNGtQ8L6vwzRzE6pvKOCGZpn9V2xCPUUchePverRI7MbjvAzQVS85Q7Bp5XJbOzQHoo1YOiExgCotg68eorgE8cQnWWA/oNEoiJL9lcq0fKx0MINQiDvNUeGG7/chAS9oobXcvTTDGAlSmWRCRU50g24C7dKdtJr11bJpoSkaTogFzccKsodZr8KG3ASt3jmY/iGn0Cd+WZGIBhZmoOgWlsykBky22lxr1fAVuXX+YWUm5E1sFwi4vbbwb6LW3pWIZio33RqtsXSL61zL21It/DlIeWg5csgNf08LwONNnRczx9qXJm51wUIHzZ1NcVSMMyU4xl3+U3gj3tOLmNjEc30kOSPIYt+uAGKRqGdVm4H2FxRV51JovQcN2M+qwPbUU5sZ6ypnzz8zWo6HC8sAnAfRyuHm1DOvEO99ZhRUt3x98ScyrJCtKeqQdOriQKwXbysmq1pwPtwdXa0yNETSL7FIW5GwOd/MNE2FligXjU1GNwsSom/wkHzVAYievK0MVjl4npRU7F9fTpsHISk8xmOvTZW85X8zKcmGsVABWKpABoD27ArCEG7F0NuPyc/h9yWqhkBa9t4fJt5PQI//y04JiYITkGN1q5tmIXORsCSoi+Drny1SwKB7R68AV4xkcmxXu2wPGjVi6pVgkJSCYQ4hviEic9ypRINbFG3IDYS/i146NCguvY1cuD0BX6JFabjyKQGDA3nrUCdqa+ma3NXwkdG/6vtp+zXWewtr6K/t4RRkpxu01yxgZ8lc5hnsY7PbG2jpHQ2q0mV4VnFRHfDdJVRXtReqJXfgW6Kfp2iIsf9ZTYXywxk5Nf+dmom5jygKaIGRW6JJbTPHzXPml4sVyvLdvLeZMZchco5WfVvnixl3PhwX8LrQ8CPgMLu9amq3MPLlMJGRkpFHqpfYjSS6vGnY7oKV+Xw6LVyHO6VuPn+3R1CRob
 xYb9fWEk
 h4gsmeOnB+2JdRHOJRqjJTtGbGxj+hZTndpuE4kfH1Ec/rpuM7FzXrQR5Ir7QNkoqszbF1ehx/rAGd/n21/0HE+B8Y/AF8dS9qe1k9Vv5o/wpAi5jpUSyd9JnIr94dpQMCn4Reg5rv6WYANxODsKQ5lQm/yt5xCY6zsEEgKGE7pIgY//95AQefrb/3NI6goKZhswnN1tqp6wApOP7gFQyn0i0DFsC98eWHaNHIlnI5v1b+1jmdB68hP8QddjqiXzXVoZPCc7mvMpanv/ClhXPANFD5dskPR5jdaF03NfgMFiBkavtgnu8B6uYLF+r4+kunHeenwysI8FJBAmzMO/VAa/8z1ntq1Y0s4BXBonbmnvBEcWnROjMhzFuWq9J0ewt4FBtYO1Na1w7ddqTRC1KaNPZLXrqjG3uFDjv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/3/26 2:22 PM, Luigi Rizzo wrote:
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index 6e07bd69467a3..1bb347fd9da4a 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -158,6 +158,38 @@ config IOMMU_DMA
>  	select NEED_SG_DMA_LENGTH
>  	select NEED_SG_DMA_FLAGS if SWIOTLB
>  
> +# PMD_SIZE IOMMU backing for DMA-coherent devices
> +config DMA_PMD
> +	bool "PMD_SIZE IOMMU backing for DMA-coherent devices"
> +	depends on IOMMU_DMA
> +	depends on X86_64 || (ARM64 && ARM64_4K_PAGES)
> +	depends on !PREEMPT_RT
> +	default y
> +	help
> +	  Hand out DMA buffers carved out of PMD_SIZE physically contiguous
> +	  blocks that the IOMMU maps with a single leaf PTE. Mapping,
> +	  unmapping and IOTLB flushing are done lazily to reduce CPU overhead.
> +	  The large mappings greatly reduce IOTLB usage. As in strict iommu
> +	  mode, pages are returned to the buddy allocator only when any existing
> +	  mappings have been removed and IOTLB flushed.
> +	  Costs 128KB of metadata per GB of DMA_PMD buffers, allocated on demand.

Paragraph 1 of the patch description says 64KB per 1GB, not 128KB.
Or am I mixing things up?

-- 
~Randy


