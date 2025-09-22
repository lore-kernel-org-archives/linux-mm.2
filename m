Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD4EBCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 21:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A55298E000D; Mon, 22 Sep 2025 17:00:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05108E0001; Mon, 22 Sep 2025 17:00:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91AFE8E000D; Mon, 22 Sep 2025 17:00:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 79B208E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 17:00:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2A43C578EF
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 21:00:42 +0000 (UTC)
X-FDA: 83918105124.25.2283A9E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id C534940012
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 21:00:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HFIa6Hpz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758574839; a=rsa-sha256;
	cv=none;
	b=VCNVjHE/DAlUnkMMcm1EJcp7pej3/A0aJlmUt9fhRNJIefeVBxXugV0buc+J0ujx3VX9JA
	eaCsEIxhG41rnDn3aRugahT/EwjBcb2QBo4rw5mfmrUunFzbLXCO67IULrAnbB3r4+OuKQ
	D7utEuKXPh6HBamG27t/YVDYI9zyaC0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HFIa6Hpz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758574839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u976ILMXRioS/uyYdClouLABKNXfjZw/zLt8Qjs8X1U=;
	b=el8/UKPF34sY6zjyPTA6TY+ckABkQl5x73uW96s1jFPmTidrHEoJNgSbQFmy41zC7UxE1y
	8OV7A/JaBAvkJKehDrl/Pzp3BA7KSn0fi+DhH+hZbkvbxdipw85Kqzz5mwGDl4zm1EtkMJ
	0dsMHauaWbq+RiuIUQZAEBI3T1ZgQnI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758574839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u976ILMXRioS/uyYdClouLABKNXfjZw/zLt8Qjs8X1U=;
	b=HFIa6HpzWF1zoGAC8JpPdBSeIx6mcpBEaEB1Nloc5zvisEuvQ1ijgue2ncfNM6be+AR3/M
	fQz7TAHENWKc6D+Yfk7uVtUg8pYuqTeIUo136TTHY7+LiHdO1dBZ3u8CAL1UOnyMWSlVpr
	RcaIzT0zHByn7st6z8g83/KyFgIn/XA=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-kRb3ksZbMxuAjda1shhc_w-1; Mon, 22 Sep 2025 17:00:37 -0400
X-MC-Unique: kRb3ksZbMxuAjda1shhc_w-1
X-Mimecast-MFC-AGG-ID: kRb3ksZbMxuAjda1shhc_w_1758574837
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-4248bfd20faso7641245ab.2
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 14:00:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758574837; x=1759179637;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u976ILMXRioS/uyYdClouLABKNXfjZw/zLt8Qjs8X1U=;
        b=uj7MUkOSlRBXnC/0MoNf12S+CseRT4P3kkADoRHRa2urQB2/IKQFRQ/bNRdvbCu/eF
         KrYodfwSisqsE2qUBvS5di4NuVfLtgZ2eakbebu8NG1A2D0Q8gFyv9OzlcJE41k3Wx2S
         qIh3/C9TEgFxetUF3g1aVg2OpkF6ZiCGpDKNYugkwmulm7ppVbk8Le3WV0Pfp1GYAnhT
         iCez1tUwxLRgfrKWehZNphV9BiaCfnVFq1v1xcMwjA09OwpjVzZC8JaT5jPcELXZZJ8Q
         BjgHXCLig40DM6fYG9RyBHz0EP70gGDkVjwvnuoB8NicE/5mWLMFjmtoZUDW/havYmGZ
         wIAg==
X-Forwarded-Encrypted: i=1; AJvYcCXwXn5bs+P9zDBFdTvMJ4oxjDiylh2qH/SDjfiwMIG6pFG+3PBPhILoRsHljICKlL5Mfl/2SyzsTQ==@kvack.org
X-Gm-Message-State: AOJu0YyTMZwGnhCjvOcPyJRqDzlJC7ahgQf1lsxB48FhABvF0n7V7hf+
	tu6Z7gT5GBTpmUAR1wxjktBGiH8Z+ScbuUN7fCReAcjcO6ArmzwO1RWBjSoM/a2AWBYZ3CrrRuI
	y++kLB9yX6Oz8d9NcJHZnYhFgFd/Mm0oaxnQ8mg6mbH6sMKqrnwj6
X-Gm-Gg: ASbGnct1W0vHTxz/haYkstDuDYWRq2XpRnT2WMVYDJTOfXWbgpNig5vabgOdI1Xfy8q
	8TOpGrmWsx1jrjT//2P9fnyP7VyAg9IG7q1r0IhwLEzv09YvC/MbWOqjfg0IvCEYAjbeEbMzuZe
	KYVlJXW3p1iXD+DaM1o3j/r/7szKEf/NwUeAxPt/xNlMwsgXX268SbQhQvJbfLFC6K+TSq0YNEB
	kTh7eyeiPKx/P9DvavWqznVAcJemZ7leElJir0hjA5tuI6sy+0/0mpEjr0S7fKO2yY5IqHXSZmW
	bVD1VyKEehzLw1DRXtXl1djDt6KpHtOmyOPBiboZQZY=
X-Received: by 2002:a05:6e02:1564:b0:424:1774:6908 with SMTP id e9e14a558f8ab-42581d411aemr2507415ab.0.1758574836520;
        Mon, 22 Sep 2025 14:00:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEHevCmO0qja9+CaJmqTAnyT70ByyebOs+GgzBvQQPshgkX8jExSjBAAuoPEqWA6rRJFVM2cg==
X-Received: by 2002:a05:6e02:1564:b0:424:1774:6908 with SMTP id e9e14a558f8ab-42581d411aemr2507095ab.0.1758574835992;
        Mon, 22 Sep 2025 14:00:35 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-53d3e337bebsm6192605173.28.2025.09.22.14.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 14:00:35 -0700 (PDT)
Date: Mon, 22 Sep 2025 15:00:32 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Bjorn Helgaas
 <bhelgaas@google.com>, Christian =?UTF-8?B?S8O2bmln?=
 <christian.koenig@amd.com>, dri-devel@lists.freedesktop.org,
 iommu@lists.linux.dev, Jens Axboe <axboe@kernel.dk>, Joerg Roedel
 <joro@8bytes.org>, kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-media@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org,
 Logan Gunthorpe <logang@deltatee.com>, Marek Szyprowski
 <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Sumit
 Semwal <sumit.semwal@linaro.org>, Vivek Kasireddy
 <vivek.kasireddy@intel.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 03/10] PCI/P2PDMA: Refactor to separate core P2P
 functionality from memory allocation
Message-ID: <20250922150032.3e3da410.alex.williamson@redhat.com>
In-Reply-To: <1e2cb89ea76a92949d06a804e3ab97478e7cacbb.1757589589.git.leon@kernel.org>
References: <cover.1757589589.git.leon@kernel.org>
	<1e2cb89ea76a92949d06a804e3ab97478e7cacbb.1757589589.git.leon@kernel.org>
Organization: Red Hat
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 85MuWFkLC-7n7zfBLmKOaB334p76cWK1hTb0xfHHZCc_1758574837
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C534940012
X-Stat-Signature: kdxgsa9d9z138tqcxi6gk4apu78nq1h6
X-Rspam-User: 
X-HE-Tag: 1758574839-210651
X-HE-Meta: U2FsdGVkX18KvcF5TZMZzUc2X6D5vyKSHldt6V0kjq0yg6FoZ1ZhUg/8jrP2gdla/yHTGbZgIMVBQILMyytIU9V5j1rKvIoqNEu0XZcvvtPtkr/0OozqjBaqJtg5FiCqv6ydLeT4GINSDORT8wtq5ozPc1VYWoW/XBMocXi+JkEwPbl7sTSDNqD34L4+ZGu8x68SNSAmpo6Xoz/0n7hOcNB701Ux26bX4Gz9t3IFnX4nv2kVOL8X0wgQpF1CHnLMQ6fuUW+3VoD8u5UndDj6nz1yUzCAqFGJIeh3oRkIZE2C250Tr/xXiM0xOYdvgF6uG8zjKJh1LBJwpnpzALSiGWM2mPQl9924kdcNK+T6s3P06FBZMMcmqYAR/IjGLzeF3GNbHJWdQt80UEBs5Y7rMrjPjdyEwZKknaLqY1dwVsMOmWI1BU4x/ocZ6J7Sk1CGURRmHJFbxzKCGOJ1ES6v6ewCeqnxsD6kyQbPTq1JbyqD1Zvtt4Zu5rzrQ3wJzNIk1n3HHnM3xoeFilk9fEwVS1yk+tdS4uUH/NlIJMc0wXVF6VWfZ3oI1nyRqdWeE2vKajsDDYITpmPsAXNayocVcE3sMVuvgy42r+Kz5Wch9uAbw6Lmw1MhlTnrN53RkBypFc5pwTpfLN9ZPqcamB/gX4MIr3zWbnzsmTooAliO6a7oF4NIEWc7kVmYrQeHxxfNR7F8tWKoT9sr2qcsk4wAxTvr6yE9sZh+QbaJXd9YyRXj9/JtXpb1asaOCb6Q9NpNIBmsgYV5ywMqOi489HnX2PyCr18KrDta26eJ/5jcoyxNp01/dyLmlH+A3rreFoXrTxS7P0LTqsSOiZfkrNPmU4mbO8poGChjdcb6nMZCIurTR+sVXibRcvModr27U2rP/l81pAYa2H/J6ShJA8mC3zDUilR4yTHSwZ3d1EGE5vyoBv/N/on5UQ77ZrvdH79B0EAnuvJJi5mz93UUOkg
 dQJyyuX4
 XUrHQ28lLcdv/2cnTtd81yxyae41scx/qrKJvQukjmKVohocxtw89p6EOJIu+ZdLpxhuH0sK1VWJqMGc8qvOn0X003+4y4HK0aEqQzsoCWU/OR1xGwwGJvS2ES+yTfAm/VTPHWKNj0s+oO/v8Hu2vR6myTg8y+Au5Hz8ieUlthn8gnbkP/2YXVB6LGvzurhpKfmV1XPJasRwmqGn2rrq2AQtG9ee9IJZMkHixjyJ1UwFrtxt6H2DjdCiCS3o6556rBWVXtpJ619xeHRZrFgnJI5tRIJMgoVRmDa0GnkVykgpftKiMVQyfNLxrVX2sT2up4UB3O+MM7u8EDvCFAEX29DcluKs/7OHc5Ely+AQ2OXFDLxoPt80dLG5nFPYq9W6YS9+68pK19WTnVRUNprOk1nheaONgb6qXnL1t7TpmstigoqvsOoPjHtWQtg9I4Uua6Rt/35nUPtQWjHV6rvW1y7TqcFD7IJq+z4HUMd85N8HADXUxaP40CTCoPG/mqisuj9ZeK8F1KlCU6NK4ZS05PkeLIZ/txTCjWKwjc9HPyikPInhU0Ayi+5kYrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Sep 2025 14:33:07 +0300
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
>  drivers/pci/p2pdma.c       | 129 +++++++++++++++++++++++++++----------
>  include/linux/pci-p2pdma.h |   5 ++
>  2 files changed, 100 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index 176a99232fdca..c22cbb3a26030 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -25,11 +25,12 @@ struct pci_p2pdma {
>  	struct gen_pool *pool;
>  	bool p2pmem_published;
>  	struct xarray map_types;
> +	struct p2pdma_provider mem[PCI_STD_NUM_BARS];
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
> @@ -227,44 +228,93 @@ static void pci_p2pdma_release(void *data)
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
> + * pcim_p2pdma_enable - Enable peer-to-peer DMA support for a PCI device
> + * @pdev: The PCI device to enable P2PDMA for
> + * @bar: BAR index to get provider
> + *
> + * This function initializes the peer-to-peer DMA infrastructure for a PCI
> + * device. It allocates and sets up the necessary data structures to support
> + * P2PDMA operations, including mapping type tracking.
> + */
> +struct p2pdma_provider *pcim_p2pdma_enable(struct pci_dev *pdev, int bar)
>  {
> -	int error = -ENOMEM;
>  	struct pci_p2pdma *p2p;
> +	int i, ret;
> +
> +	p2p = rcu_dereference_protected(pdev->p2pdma, 1);
> +	if (p2p)
> +		/* PCI device was "rebound" to the driver */
> +		return &p2p->mem[bar];
>  

This seems like two separate functions rolled into one, an 'initialize
providers' and a 'get provider for BAR'.  The comment above even makes
it sound like only a driver re-probing a device would encounter this
branch, but the use case later in vfio-pci shows it to be the common
case to iterate BARs for a device.

But then later in patch 8/ and again in 10/ why exactly do we cache
the provider on the vfio_pci_core_device rather than ask for it on
demand from the p2pdma?

It also seems like the coordination of a valid provider is ad-hoc
between p2pdma and vfio-pci.  For example, this only fills providers
for MMIO BARs and vfio-pci validates that dmabuf operations are for
MMIO BARs, but it would be more consistent if vfio-pci relied on p2pdma
to give it a valid provider for a given BAR.  Thanks,

Alex

>  	p2p = devm_kzalloc(&pdev->dev, sizeof(*p2p), GFP_KERNEL);
>  	if (!p2p)
> -		return -ENOMEM;
> +		return ERR_PTR(-ENOMEM);
>  
>  	xa_init(&p2p->map_types);
> +	/*
> +	 * Iterate over all standard PCI BARs and record only those that
> +	 * correspond to MMIO regions. Skip non-memory resources (e.g. I/O
> +	 * port BARs) since they cannot be used for peer-to-peer (P2P)
> +	 * transactions.
> +	 */
> +	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
> +		if (!(pci_resource_flags(pdev, i) & IORESOURCE_MEM))
> +			continue;
>  
> -	p2p->pool = gen_pool_create(PAGE_SHIFT, dev_to_node(&pdev->dev));
> -	if (!p2p->pool)
> -		goto out;
> +		p2p->mem[i].owner = &pdev->dev;
> +		p2p->mem[i].bus_offset =
> +			pci_bus_address(pdev, i) - pci_resource_start(pdev, i);
> +	}
>  
> -	error = devm_add_action_or_reset(&pdev->dev, pci_p2pdma_release, pdev);
> -	if (error)
> -		goto out_pool_destroy;
> +	ret = devm_add_action_or_reset(&pdev->dev, pci_p2pdma_release, pdev);
> +	if (ret)
> +		goto out_p2p;
>  
> -	error = sysfs_create_group(&pdev->dev.kobj, &p2pmem_group);
> -	if (error)
> +	rcu_assign_pointer(pdev->p2pdma, p2p);
> +	return &p2p->mem[bar];
> +
> +out_p2p:
> +	devm_kfree(&pdev->dev, p2p);
> +	return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL_GPL(pcim_p2pdma_enable);
> +
> +static int pci_p2pdma_setup_pool(struct pci_dev *pdev)
> +{
> +	struct pci_p2pdma *p2pdma;
> +	int ret;
> +
> +	p2pdma = rcu_dereference_protected(pdev->p2pdma, 1);
> +	if (p2pdma->pool)
> +		/* We already setup pools, do nothing, */
> +		return 0;
> +
> +	p2pdma->pool = gen_pool_create(PAGE_SHIFT, dev_to_node(&pdev->dev));
> +	if (!p2pdma->pool)
> +		return -ENOMEM;
> +
> +	ret = sysfs_create_group(&pdev->dev.kobj, &p2pmem_group);
> +	if (ret)
>  		goto out_pool_destroy;
>  
> -	rcu_assign_pointer(pdev->p2pdma, p2p);
>  	return 0;
>  
>  out_pool_destroy:
> -	gen_pool_destroy(p2p->pool);
> -out:
> -	devm_kfree(&pdev->dev, p2p);
> -	return error;
> +	gen_pool_destroy(p2pdma->pool);
> +	p2pdma->pool = NULL;
> +	return ret;
>  }
>  
>  static void pci_p2pdma_unmap_mappings(void *data)
> @@ -276,7 +326,7 @@ static void pci_p2pdma_unmap_mappings(void *data)
>  	 * unmap_mapping_range() on the inode, teardown any existing userspace
>  	 * mappings and prevent new ones from being created.
>  	 */
> -	sysfs_remove_file_from_group(&p2p_pgmap->mem.owner->kobj,
> +	sysfs_remove_file_from_group(&p2p_pgmap->mem->owner->kobj,
>  				     &p2pmem_alloc_attr.attr,
>  				     p2pmem_group.name);
>  }
> @@ -295,6 +345,7 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
>  			    u64 offset)
>  {
>  	struct pci_p2pdma_pagemap *p2p_pgmap;
> +	struct p2pdma_provider *mem;
>  	struct dev_pagemap *pgmap;
>  	struct pci_p2pdma *p2pdma;
>  	void *addr;
> @@ -312,15 +363,25 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
>  	if (size + offset > pci_resource_len(pdev, bar))
>  		return -EINVAL;
>  
> -	if (!pdev->p2pdma) {
> -		error = pci_p2pdma_setup(pdev);
> +	p2pdma = rcu_dereference_protected(pdev->p2pdma, 1);
> +	if (!p2pdma) {
> +		mem = pcim_p2pdma_enable(pdev, bar);
> +		if (IS_ERR(mem))
> +			return PTR_ERR(mem);
> +
> +		error = pci_p2pdma_setup_pool(pdev);
>  		if (error)
>  			return error;
> -	}
> +
> +		p2pdma = rcu_dereference_protected(pdev->p2pdma, 1);
> +	} else
> +		mem = &p2pdma->mem[bar];
>  
>  	p2p_pgmap = devm_kzalloc(&pdev->dev, sizeof(*p2p_pgmap), GFP_KERNEL);
> -	if (!p2p_pgmap)
> -		return -ENOMEM;
> +	if (!p2p_pgmap) {
> +		error = -ENOMEM;
> +		goto free_pool;
> +	}
>  
>  	pgmap = &p2p_pgmap->pgmap;
>  	pgmap->range.start = pci_resource_start(pdev, bar) + offset;
> @@ -328,9 +389,7 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
>  	pgmap->nr_range = 1;
>  	pgmap->type = MEMORY_DEVICE_PCI_P2PDMA;
>  	pgmap->ops = &p2pdma_pgmap_ops;
> -	p2p_pgmap->mem.owner = &pdev->dev;
> -	p2p_pgmap->mem.bus_offset =
> -		pci_bus_address(pdev, bar) - pci_resource_start(pdev, bar);
> +	p2p_pgmap->mem = mem;
>  
>  	addr = devm_memremap_pages(&pdev->dev, pgmap);
>  	if (IS_ERR(addr)) {
> @@ -343,7 +402,6 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
>  	if (error)
>  		goto pages_free;
>  
> -	p2pdma = rcu_dereference_protected(pdev->p2pdma, 1);
>  	error = gen_pool_add_owner(p2pdma->pool, (unsigned long)addr,
>  			pci_bus_address(pdev, bar) + offset,
>  			range_len(&pgmap->range), dev_to_node(&pdev->dev),
> @@ -359,7 +417,10 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
>  pages_free:
>  	devm_memunmap_pages(&pdev->dev, pgmap);
>  pgmap_free:
> -	devm_kfree(&pdev->dev, pgmap);
> +	devm_kfree(&pdev->dev, p2p_pgmap);
> +free_pool:
> +	sysfs_remove_group(&pdev->dev.kobj, &p2pmem_group);
> +	gen_pool_destroy(p2pdma->pool);
>  	return error;
>  }
>  EXPORT_SYMBOL_GPL(pci_p2pdma_add_resource);
> @@ -1008,11 +1069,11 @@ void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
>  {
>  	struct pci_p2pdma_pagemap *p2p_pgmap = to_p2p_pgmap(page_pgmap(page));
>  
> -	if (state->mem == &p2p_pgmap->mem)
> +	if (state->mem == p2p_pgmap->mem)
>  		return;
>  
> -	state->mem = &p2p_pgmap->mem;
> -	state->map = pci_p2pdma_map_type(&p2p_pgmap->mem, dev);
> +	state->mem = p2p_pgmap->mem;
> +	state->map = pci_p2pdma_map_type(p2p_pgmap->mem, dev);
>  }
>  
>  /**
> diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
> index eef96636c67e6..888ad7b0c54cf 100644
> --- a/include/linux/pci-p2pdma.h
> +++ b/include/linux/pci-p2pdma.h
> @@ -27,6 +27,7 @@ struct p2pdma_provider {
>  };
>  
>  #ifdef CONFIG_PCI_P2PDMA
> +struct p2pdma_provider *pcim_p2pdma_enable(struct pci_dev *pdev, int bar);
>  int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
>  		u64 offset);
>  int pci_p2pdma_distance_many(struct pci_dev *provider, struct device **clients,
> @@ -45,6 +46,10 @@ int pci_p2pdma_enable_store(const char *page, struct pci_dev **p2p_dev,
>  ssize_t pci_p2pdma_enable_show(char *page, struct pci_dev *p2p_dev,
>  			       bool use_p2pdma);
>  #else /* CONFIG_PCI_P2PDMA */
> +static inline struct p2pdma_provider *pcim_p2pdma_enable(struct pci_dev *pdev, int bar)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
>  static inline int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar,
>  		size_t size, u64 offset)
>  {


