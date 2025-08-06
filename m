Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F55C87FDA
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 21:42:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 720256B0095; Wed,  6 Aug 2025 17:42:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D0B76B0096; Wed,  6 Aug 2025 17:42:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E6546B0098; Wed,  6 Aug 2025 17:42:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F5B36B0095
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 17:42:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C4F1D13657C
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:42:23 +0000 (UTC)
X-FDA: 83747656566.17.6CCFC73
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 696D6100003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:42:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OE3GN6TL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754516541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UEyeHS4HV3rZ/wSqVLFMAOzjnboPPP41DAzDFsrqTZs=;
	b=gdwPudSOELe3mrse8Ys3bg7Agmv/BXGRkqUMUkGPfT43IectQ+cl+rFq0w6oUBR4ez1OmT
	0fYZXv7efV3QJSCyC2MIKVy8yVfpi3ea+NqCDDMHwANcIduGRX/jDhJW5nGXbdVgirpgtA
	aDG87yw+luZLpcTr3reReNcLF3UNh/c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754516541; a=rsa-sha256;
	cv=none;
	b=rknwgaCwaxjeMY/o3WO3vDobh6BNI4exR64EGm6yHt2gyTcyl/INA4orJPigLpoC8guca9
	OQ5MxWPuggR4NnK+lnXeoas7ESU7Cf/q9mPUtmgQeU0TRFy/cL60CnpPwY+mSmdBHDe/Wn
	5I86RhknrawLKdwINUIBdLk66ufEqS0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OE3GN6TL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754516540;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UEyeHS4HV3rZ/wSqVLFMAOzjnboPPP41DAzDFsrqTZs=;
	b=OE3GN6TLpBLEBrJyrryxB2GnZdeFZ8p/1nKKy9W2TMUmRak/2ofbmrq5xOp8IaapvxOP3j
	7ib0etQpkD2Mfq8KzasnyuslPhleGCv2EPeHdw7a7rbtAZzirvHdPwhZTDOApNGyJdxb89
	aPhNq7bOpqpyOcHf2uavZ/rSXAPLc/k=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-1JUgULqVP9-NOgkX4MAAEQ-1; Wed, 06 Aug 2025 17:42:18 -0400
X-MC-Unique: 1JUgULqVP9-NOgkX4MAAEQ-1
X-Mimecast-MFC-AGG-ID: 1JUgULqVP9-NOgkX4MAAEQ_1754516538
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-742e3d0ad61so22627a34.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 14:42:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754516538; x=1755121338;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UEyeHS4HV3rZ/wSqVLFMAOzjnboPPP41DAzDFsrqTZs=;
        b=sUL8vg6ZCD0VYtaAHfZaofodifcc6Djh9jH4HeqVxX4LILUCsKfffHt9/TCz78OTJ/
         0L9QuMZZp7PDDYMooGNf93brzFG30+utjlK5s7/+/fGeqTFWXfsnVEvY5AI0s6xALXq+
         KPM7aoLghfk4RWkbMPA0wtrJ5jQ8UKcqUjjKqxp4wMbZOX9GHc1YbYdy5sjoo2BdbrMT
         KhQU0rAJPQYU5iED2tL7gKqX1RB4rJpEWVILUzIAgjEvzQhl17gMSLkuKOJIwqafvank
         J6/r9wSpI20/BuxPkE3OfVdnPxPZb3PsfDFV2Ugz/la6JKIaw6jYRGu628HgVtUkgDqt
         ApKg==
X-Forwarded-Encrypted: i=1; AJvYcCWdq6ulfGV/6y76VXO5y6XD2592CNlsi56cOCRp46au9EuZgNLiE0B00in748IGuiBr6N3zrXwr0w==@kvack.org
X-Gm-Message-State: AOJu0YxDgqRWIEXqfl+ifqDNfKm9XxRlVkRL7X3DkEWJtH0P5uZA/QmV
	HBwUYALD0b2yqerYsftBzfUxwM/sE/iuMoQhk5wbAESa3vz1zG2mpZfdCvnQ3ttVlMbabOcD9YN
	0Yzzmqyfj8bOO5UgVxHxSzWc0sOUC00Hmy/D3xv3tosyxgtErIN56
X-Gm-Gg: ASbGncuyxY/M+VmbSmfabPghpZZzC5vjGFRqQL8h7o3dsuAXcarFVmBmCBO+ld58J52
	rTHFWt34NMjRPc1L5iqvD3Fz41fAiwXXZx/sizH2CSMbvK/+A9l1vRrUp863huUWNHRBgejYiAb
	FkaM1zdaj39JBIR7P0SX/th48d980A7dJENOFAkWKtDbwAjeeD1MMdcNOkuk1BHsxQIutr6qYR1
	cH+d6CG5DZfUXVgGwCNr4e3yxLFVPvjtSy1QiStNAoOgld9NSkYL/q06xZjsof2oGoH07sMeysc
	dvZWR4ZUSxNSAryvFMtieoYanCRVdeBxjw1EtIb7CQI=
X-Received: by 2002:a05:6830:3145:b0:741:a217:720f with SMTP id 46e09a7af769-7430e2000b0mr942373a34.2.1754516537615;
        Wed, 06 Aug 2025 14:42:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH5QU5ZQlpYSxfTPMUFCWfqP/wnHyNw5oOZqDg/+tC9OzPbWJoK2cj/jTsdC9+aUwDUHNbnjQ==
X-Received: by 2002:a05:6830:3145:b0:741:a217:720f with SMTP id 46e09a7af769-7430e2000b0mr942353a34.2.1754516537077;
        Wed, 06 Aug 2025 14:42:17 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-74186cc4e1bsm3606901a34.21.2025.08.06.14.42.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 14:42:16 -0700 (PDT)
Date: Wed, 6 Aug 2025 15:42:14 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Bjorn Helgaas
 <bhelgaas@google.com>, Christian =?UTF-8?B?S8O2bmln?=
 <christian.koenig@amd.com>, Christoph Hellwig <hch@lst.de>,
 dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, Jens Axboe
 <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org, Logan Gunthorpe
 <logang@deltatee.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin
 Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v1 04/10] PCI/P2PDMA: Refactor to separate core P2P
 functionality from memory allocation
Message-ID: <20250806154214.1c2618e8.alex.williamson@redhat.com>
In-Reply-To: <cab5f1bfd64becafcc887107bb4386f2c8630ef3.1754311439.git.leon@kernel.org>
References: <cover.1754311439.git.leon@kernel.org>
	<cab5f1bfd64becafcc887107bb4386f2c8630ef3.1754311439.git.leon@kernel.org>
Organization: Red Hat
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OXtr_qiFbfgd5qaTT3LRN5r7J70EO2b2aObHfPUj4EQ_1754516538
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zxt8hg8bxenfmtwg1yt7br7i3pzma9iq
X-Rspamd-Queue-Id: 696D6100003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754516541-525977
X-HE-Meta: U2FsdGVkX19Rt+aZDKEyAcks6Dbx4yfxaB8bj0MGpmYeg+S+T1VDllJJrWPVO/nxl0fl/bbAawCKs0qS6ljhcV1ttwCaCXvmaoMnR4yiS/iTtERpFWJOmSMGuD9UqQREr5dIykGQ7kAfncvxR45vhDO29MGUrDoixtS2Q0CmKLUB571Z9LFPopuCuHBzmNEn6VZ1YQ4hNp2Cz+STRoNNYv5l0QCI5rwa5t9/Hpm7AZ6U6Pk5cEJXQZ5fdBm0rEBMIDC2PgyxlBbKq57/Jntoa6ywwvQXDNvckKR3opJGjZ0AsJpymPDDd7u0HEcMrmwqnExc0alkH0nHO+29GTlCzMezKJDGFXfd1uk2gSuleo6yuTOr9sB66FtyV+Z4/G7zgqbKi5fXXqPB+5GbKcVY2l7UStaXAa6RRgT3vxPiUKc5gNLinJ0Ltc3sQj/53Z2YMd7S8ZY6ljjReeBOO4YtTKc/ziPT3ZHfGpgAyIFSO8ndG9U4trciNCTfwFmlgDct9dktwYZgul0/S8PBLT6tHZZdThg4qSLA5s/TN4/oPvIJ7H3N2/kkQYmjZZm1JoHCaXWOUR/zGoK8uo6Jos8cS3bXT8iMuWbz6cmdkeLFAaCrRH8v/7brvycpdiy9TLwfNJ5MVDQsiS8bac+mzqnQEwwlsCzOAzpgGnjD2CcCZOYKeyfHGALPZIvSZIsqWyaarbKbQbI6/e361QP5xxeJdOPQg95dMDBIR4gSY5MTjpYmcgtG9q7/nfvaUjWM6kdmI8kAWJHnW3qx3dBUV573sRveRbQuq8Qfse2qjtzoBT0K2b6wxz8dfbdzWJFF/LZS1eF+AukkfDJP1lhSLilKYtjPQW0sYlqu/IfvBFSa1APikjwsoMLHu1SHrLOp6raASj6DIYX9rfHCTj6lJMsBca2FFJ4iuNhCyn1Obn+idcoD9OlyFJeDT03mxrllIGJsfCPYPOn4oAryPV+PEDK
 QKTFSeA0
 FgJFllVAgHWnd7mJT/miRgTEZIZtmZbk0RGJU/YCaFmnIc8LovncqipGxSwPgbBm+Qu9dakcN3Qp0jdKBIDiCAGbANPdM+0uXrrBaIiHANAHThgoM72PRVUcxSTy34fYtixWqnVxELycnhS2RJd2f5EPdWBqbBvdY5TQ5/vMznuC8k7kMZRuDchYlvDzWGxXZu+6OB3ephcHOTNmjGNDdFUOVEqGfPDsQVOOKFZrwhvvMK7gNqLWMsqWMP44FYPaIW0/rbnnwI/Hb8Nrc8gBkvUB3/Ww7BvHh9fUQ7LTX/KkmEpah72yocrKy6UybUWOb0pq+P4xoMIUUPp+pguGRAYHel7nXM6QagUgn+13SJZUVQGM3h165ew7fKneVcUAnpsfgCOpRnZ5G0Xq3SDSselXloy2mIW5UNq/RiBVZJVQ4TldzBnGw4hUxDDQ/yJelFGQpNUsCZAJF9smIW+czYSRWBb22IgbORnOtUxTrcO7u9Ono4SUqlIyJpNuXgPomEGOcjd3Qx+XkaghrYNdenW8vLZIwg0sfpbVqRJkGJHHqpII=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  4 Aug 2025 16:00:39 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Refactor the PCI P2PDMA subsystem to separate the core peer-to-peer DMA
> functionality from the optional memory allocation layer. This creates a
> two-tier architecture:
> 
> The core layer provides P2P mapping functionality for physical addresses
> based on PCI device MMIO BARs and integrates with the DMA API for
> mapping operations. This layer is required for all P2PDMA users.
> 
> The optional upper layer provides memory allocation capabilities
> including gen_pool allocator, struct page support, and sysfs interface
> for user space access.
> 
> This separation allows subsystems like VFIO to use only the core P2P
> mapping functionality without the overhead of memory allocation features
> they don't need. The core functionality is now available through the
> new pci_p2pdma_enable() function that returns a p2pdma_provider
> structure.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/pci/p2pdma.c       | 118 ++++++++++++++++++++++++++-----------
>  include/linux/pci-p2pdma.h |   5 ++
>  2 files changed, 89 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index 176a99232fdca..24a6c8ff88520 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -25,11 +25,12 @@ struct pci_p2pdma {
>  	struct gen_pool *pool;
>  	bool p2pmem_published;
>  	struct xarray map_types;
> +	struct p2pdma_provider mem;
>  };
>  
>  struct pci_p2pdma_pagemap {
>  	struct dev_pagemap pgmap;
> -	struct p2pdma_provider mem;
> +	struct p2pdma_provider *mem;
>  };
>  
>  static struct pci_p2pdma_pagemap *to_p2p_pgmap(struct dev_pagemap *pgmap)
> @@ -204,7 +205,7 @@ static void p2pdma_page_free(struct page *page)
>  	struct pci_p2pdma_pagemap *pgmap = to_p2p_pgmap(page_pgmap(page));
>  	/* safe to dereference while a reference is held to the percpu ref */
>  	struct pci_p2pdma *p2pdma = rcu_dereference_protected(
> -		to_pci_dev(pgmap->mem.owner)->p2pdma, 1);
> +		to_pci_dev(pgmap->mem->owner)->p2pdma, 1);
>  	struct percpu_ref *ref;
>  
>  	gen_pool_free_owner(p2pdma->pool, (uintptr_t)page_to_virt(page),
> @@ -227,44 +228,82 @@ static void pci_p2pdma_release(void *data)
>  
>  	/* Flush and disable pci_alloc_p2p_mem() */
>  	pdev->p2pdma = NULL;
> -	synchronize_rcu();
> +	if (p2pdma->pool)
> +		synchronize_rcu();
> +	xa_destroy(&p2pdma->map_types);
> +
> +	if (!p2pdma->pool)
> +		return;
>  
>  	gen_pool_destroy(p2pdma->pool);
>  	sysfs_remove_group(&pdev->dev.kobj, &p2pmem_group);
> -	xa_destroy(&p2pdma->map_types);
>  }
>  
> -static int pci_p2pdma_setup(struct pci_dev *pdev)
> +/**
> + * pci_p2pdma_enable - Enable peer-to-peer DMA support for a PCI device
> + * @pdev: The PCI device to enable P2PDMA for
> + *
> + * This function initializes the peer-to-peer DMA infrastructure for a PCI
> + * device. It allocates and sets up the necessary data structures to support
> + * P2PDMA operations, including mapping type tracking.
> + */
> +struct p2pdma_provider *pci_p2pdma_enable(struct pci_dev *pdev)
>  {
> -	int error = -ENOMEM;
>  	struct pci_p2pdma *p2p;
> +	int ret;
> +
> +	p2p = rcu_dereference_protected(pdev->p2pdma, 1);
> +	if (p2p)
> +		/* PCI device was "rebound" to the driver */
> +		return &p2p->mem;
>  
>  	p2p = devm_kzalloc(&pdev->dev, sizeof(*p2p), GFP_KERNEL);
>  	if (!p2p)
> -		return -ENOMEM;
> +		return ERR_PTR(-ENOMEM);
>  
>  	xa_init(&p2p->map_types);
> +	p2p->mem.owner = &pdev->dev;
> +	/* On all p2p platforms bus_offset is the same for all BARs */
> +	p2p->mem.bus_offset =
> +		pci_bus_address(pdev, 0) - pci_resource_start(pdev, 0);

But not all devices implement BAR0, nor is BAR0 necessarily in the
memory space, wouldn't this calculation be wrong if BAR0 were
unimplemented or an IO BAR?  Even within memory BARs I can imagine
different translations for 32 vs 64 bit, prefetch vs non-prefetch, but
per the comment I guess we're excluding those.  Thanks,

Alex


