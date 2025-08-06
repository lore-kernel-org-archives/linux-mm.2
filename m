Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89A9EC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 22:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DB3A6B0092; Wed,  6 Aug 2025 18:25:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B3506B0093; Wed,  6 Aug 2025 18:25:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C9086B0095; Wed,  6 Aug 2025 18:25:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ECF826B0092
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:25:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 966CB16058F
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 22:25:05 +0000 (UTC)
X-FDA: 83747764170.07.DD61C88
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 48F7E80004
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 22:25:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="bh9a1F/Q";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754519103; a=rsa-sha256;
	cv=none;
	b=rpKNQKlrgxKPPG2F8Nb3FaVjKWRgcEYja15zsSGUXy3I10O8vXfIIQ7O4EoNj8+gc5Hxl8
	gi0PqrXJSVu86NLd6A/L1lxRlWT3hM4gP3MxV+x3xJaVLIkCV06Km2KINSlnu3BGNx11ui
	Rm5nyS+gBhipQeR0slBNWLbkJid7YvA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="bh9a1F/Q";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754519103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2KWudinkIbXD4F4ulzK9/+oUi2avXDJW6sBf89lUWmU=;
	b=bF/LR69DAGfBk2lsXqbloY5o+z3t5Ovna0BrgJZk9f9mpTpTXuZ91Cct1LEBxAMAyeeDn7
	GeqSxnKd9Z48XXbKFnui+vP8avTvkUWWeTJ+X2j51FdLa7X+/mQSjXV418UK9eTwbkpCiN
	RnN41pnpv4HJM3WAzFnKhilILeVRRsU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754519102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2KWudinkIbXD4F4ulzK9/+oUi2avXDJW6sBf89lUWmU=;
	b=bh9a1F/QQZqimR8naHWs7xCUacLE+AxSbAHAEijZVyyquS0D9T2eFJ0G0hp0DDa1n9qNXp
	YJmz395QE9CrfZJ8Mqk+Fh/sa7Coqbv4/P3Mmrk2l3YyYXIOgIEN9dros7cP28LKQGa+eL
	HAC4VmznYjuYblq7jM72edaJ8bmTtvk=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-468-GrNuTXE2O5Wze_75eJI8tA-1; Wed, 06 Aug 2025 18:25:01 -0400
X-MC-Unique: GrNuTXE2O5Wze_75eJI8tA-1
X-Mimecast-MFC-AGG-ID: GrNuTXE2O5Wze_75eJI8tA_1754519101
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3e51bd62f3dso827705ab.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 15:25:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754519101; x=1755123901;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2KWudinkIbXD4F4ulzK9/+oUi2avXDJW6sBf89lUWmU=;
        b=eeJsLkAeebBmL7YYLWXZXc5q5f10fkKt8kAKzX4NTYe1nNvzhYl5hq3sdr/iGUHUoA
         kgFbrxQyqaoE1DbsQGZCWwargXI81ns2FZU8kb8jJoiLT2X/A4NSr19RC1c8WtiVwfpT
         ACvpkMuBuGpNQCVtKBcXBoOZnIcmu41uRs9rUYcThIzTSowA2A1PAkUJko2e1pu95kGh
         X9BNxsfEkN7FRCmdE+fN60au/NXMucpwUvT9cOZnezpkxNsa8mvjRujL7NV21KR+sktD
         XLCrMQhkVLqhv3TCQxXpmy/R4kAnGJroUdIvibAUKfFS+8oFkRFsguTUHzydzL0Gk1mM
         wRdA==
X-Forwarded-Encrypted: i=1; AJvYcCUhcmmycYjYXlmVBX+7ZCG97rQlfCefKLarZKTO7gIz8kwR/+C6LbKcStdhb9MlVl20z9aivEACiw==@kvack.org
X-Gm-Message-State: AOJu0YwP4g+88FBtITubPMdvHtC47DjZsbOvmE676ZjjJYycXQWSHtuY
	xDVmOXBHCgB2SYxwtYPPeupSF89/63JVjKvkgz8nJUKAxGiZDU7ZxZRxzTyeZw5nSISBkELrETK
	q+aZu2PRTb8py0i+DjkM7ujXuYLNiV7+vUBBWhpbOqtdtpEiNdB9H
X-Gm-Gg: ASbGncsoliveiuIzay7yq8wInPs6vDbdRxovz7EgK2yMtUWplfgQVfqd/OLe4nqXgGh
	e9dxoNfAJeJsfFYG/PFUMgpYeQ62uejo1JxdIibgLi2LjOZcyt2wJNekp1WNVe06xqPiYM+E/ps
	VeF13S7xBeaH51BHY+HJimbnZZGZwY9v1gbgD/cOvuSBfRaufmFFt+WTlHe7RK7eQNd2SnS4EnQ
	XJJbRlsntX3O61/vpWUSb9RxouV1FRVlgiGRiui45sL4Y4X0NIcrfAZcmlrejNu0CL6wb5alGW3
	4DCLVS6jIdqMq5H8wiEOi2ajvW+QdPzB6HM4HDa27dU=
X-Received: by 2002:a05:6602:148a:b0:85d:9793:e0d8 with SMTP id ca18e2360f4ac-8819eddca30mr265750839f.0.1754519100563;
        Wed, 06 Aug 2025 15:25:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJbvSuwj5vna+ENO4HZHTFh+EQIF6Bqd2408Pfz1T06ISMEQUJO+65aGvhO/KGJJ7KSEu0KQ==
X-Received: by 2002:a05:6602:148a:b0:85d:9793:e0d8 with SMTP id ca18e2360f4ac-8819eddca30mr265749739f.0.1754519100087;
        Wed, 06 Aug 2025 15:25:00 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-88175b2e0c6sm314280239f.31.2025.08.06.15.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 15:24:59 -0700 (PDT)
Date: Wed, 6 Aug 2025 16:24:55 -0600
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
Subject: Re: [PATCH v1 10/10] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20250806162455.350f73a4.alex.williamson@redhat.com>
In-Reply-To: <5e043d8b95627441db6156e7f15e6e1658e9d537.1754311439.git.leon@kernel.org>
References: <cover.1754311439.git.leon@kernel.org>
	<5e043d8b95627441db6156e7f15e6e1658e9d537.1754311439.git.leon@kernel.org>
Organization: Red Hat
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: z-JURFSIqVxvYiU0EdYceFiGgJmULPg52EkVEpQYcho_1754519101
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 48F7E80004
X-Stat-Signature: 4sw8th534wjqsaknoo9f6g33bzo177ak
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754519103-896616
X-HE-Meta: U2FsdGVkX18NlVtIiHzNN9Nv37AmiFaiAZEo8agv3GGL0m501FFw3QlnDBsi+ZIdu9bZ9EfxeKf0EdTWD2mQwVQpnrND82GUbMuvZWRJcufgOUzB5T3TXZgS3gHPeJuMXHGtBX6dS0HGer85Y7WbjEpFdjhCoShosBRI1Ft4Px6GHNX9yR6V8DSHHxyXt6RdH6hh2NVal1WP3mHozrSQX9RObmJd53zfqk/8OvYyR2MJAvqEEKsX9zE4R02x4UjWEtdjV4Wsr7yXjJdo4ykUsaqrJUKGjSXUS5fgnRozTYAxK7Wqa5Cr/bNVGeL0uCXY4JyuRZtFgq3lPHKYFk/pe47JOzV392hLcgLHUgVZY150Vlbam4Vl19ImD1igJJATncxxPelVEt/ZTXk5RMIoyxbMhKhCws1v88ib4A1E7VufZtQ1rkxVDpE6j17u6VSB4nOYU40dcqhceWhgVTFSstZ3bVZvByO0OXYnh8SFGxeIUfDCwNie2VnNPBGMLuNtmZ1/qt8jZKI2ZBA1qHZjZvJa7AAbt1LMof1n60qRa1U+MnIch1AhouVVc+ho/5T3NoV3RA4B+2zo6tMkWI8+NAJIPNF/4qcBu0EowstlAoQnOu0YRH+S2h2ruVXpZgAPW0stDU1/z5uRgjEBHHEdLc3cDhu1Cns2InD3R2cgbQl0OIlUzHdPXggtBRtmcRGnBGAUm+LrRuqMc4v6jKeJmbgQehzJFbZ1yd5YNesGhrTgUGlc3YAfic8+6Jqhe2SkKPjegXmjcFVcgIGiRhXRInUi09i1fiPeFIjDbOv5XD+tbRWu9JZJ0Q7c0/j2m0M3Iu13/beGkti0MYR+HSH2DSmEuMTFZDw71wbDGwlxZkI5PhI09JlnW/M/P6OzqRU5LApxPp2Zz5QF62iGPhFxShXrlzQHlOrJ3RDjR7IOBfw0NxdkPwwQWOE7Pjn9D018hN6eWwLQ0hgYA0UfMC5
 ANWDe57Z
 PDZmNEmwtA3sdbuS2DpOUz6CjaQvbULOp/uG/egjQJa+DzmuK15eiiWiFbWvX6khdemb0/iSG/BSIvdHnQnJihmvQlS5JH0GAIRkyUiXXNVeamNtO87CP6aFnpSlCJjO8F3uPB7PaL14Z/Yv2FjGQxElZJGhXXJ7ju1wtpxZLM5FgrPEIP44AIVdyspwle6tj17AMMg1EDC6ND/hVYcCIv/K7yAXyUHM0ILg+y7bgH0W0+4G+5kHJqVGnHr9WqEWOVRXcM3msAIH0jkn6O//5bW2a+H3LRQ20t8arqFLi3VXv55CX7kGoIsG5WpGht2R0mvuv1kOjbLu0t4U8bMEBbze/gYlakC2bz137Uljb5c1Svvk8wUOOzxptkLiQ9kBjLRiX5pk3EkWuvRfwGlR07CqaYsDwHzFv/mPiHKdTgmwhMOyFmDO0Yv12aqZm9c8MeZt5q4fwcKRAtydvgH43QGqYuaC+4dFjrG49mamP6Fw2wIgIjYA+fgU3P3M7bG4EpVdQ83IzAd9ZAUlQBhVLzCQYVLooevb0W974kdToasvxlLxge0W7ev6rSRwxQMUBLBunxgaVbE8ecFY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  4 Aug 2025 16:00:45 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Add support for exporting PCI device MMIO regions through dma-buf,
> enabling safe sharing of non-struct page memory with controlled
> lifetime management. This allows RDMA and other subsystems to import
> dma-buf FDs and build them into memory regions for PCI P2P operations.
> 
> The implementation provides a revocable attachment mechanism using
> dma-buf move operations. MMIO regions are normally pinned as BARs
> don't change physical addresses, but access is revoked when the VFIO
> device is closed or a PCI reset is issued. This ensures kernel
> self-defense against potentially hostile userspace.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/vfio/pci/Kconfig           |  20 ++
>  drivers/vfio/pci/Makefile          |   2 +
>  drivers/vfio/pci/vfio_pci_config.c |  22 +-
>  drivers/vfio/pci/vfio_pci_core.c   |  25 +-
>  drivers/vfio/pci/vfio_pci_dmabuf.c | 390 +++++++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci_priv.h   |  23 ++
>  include/linux/dma-buf.h            |   1 +
>  include/linux/vfio_pci_core.h      |   3 +
>  include/uapi/linux/vfio.h          |  25 ++
>  9 files changed, 506 insertions(+), 5 deletions(-)
>  create mode 100644 drivers/vfio/pci/vfio_pci_dmabuf.c
> 
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 2b0172f546652..55ae888bf26ae 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -55,6 +55,26 @@ config VFIO_PCI_ZDEV_KVM
>  
>  	  To enable s390x KVM vfio-pci extensions, say Y.
>  
> +config VFIO_PCI_DMABUF
> +	bool "VFIO PCI extensions for DMA-BUF"
> +	depends on VFIO_PCI_CORE
> +	depends on PCI_P2PDMA && DMA_SHARED_BUFFER
> +	default y
> +	help
> +	  Enable support for VFIO PCI extensions that allow exporting
> +	  device MMIO regions as DMA-BUFs for peer devices to access via
> +	  peer-to-peer (P2P) DMA.
> +
> +	  This feature enables a VFIO-managed PCI device to export a portion
> +	  of its MMIO BAR as a DMA-BUF file descriptor, which can be passed
> +	  to other userspace drivers or kernel subsystems capable of
> +	  initiating DMA to that region.
> +
> +	  Say Y here if you want to enable VFIO DMABUF-based MMIO export
> +	  support for peer-to-peer DMA use cases.
> +
> +	  If unsure, say N.
> +
>  source "drivers/vfio/pci/mlx5/Kconfig"
>  
>  source "drivers/vfio/pci/hisilicon/Kconfig"
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index cf00c0a7e55c8..f9155e9c5f630 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -2,7 +2,9 @@
>  
>  vfio-pci-core-y := vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
>  vfio-pci-core-$(CONFIG_VFIO_PCI_ZDEV_KVM) += vfio_pci_zdev.o
> +
>  obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
> +vfio-pci-core-$(CONFIG_VFIO_PCI_DMABUF) += vfio_pci_dmabuf.o
>  
>  vfio-pci-y := vfio_pci.o
>  vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index 8f02f236b5b4b..7e23387a43b4d 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -589,10 +589,12 @@ static int vfio_basic_config_write(struct vfio_pci_core_device *vdev, int pos,
>  		virt_mem = !!(le16_to_cpu(*virt_cmd) & PCI_COMMAND_MEMORY);
>  		new_mem = !!(new_cmd & PCI_COMMAND_MEMORY);
>  
> -		if (!new_mem)
> +		if (!new_mem) {
>  			vfio_pci_zap_and_down_write_memory_lock(vdev);
> -		else
> +			vfio_pci_dma_buf_move(vdev, true);
> +		} else {
>  			down_write(&vdev->memory_lock);
> +		}
>  
>  		/*
>  		 * If the user is writing mem/io enable (new_mem/io) and we
> @@ -627,6 +629,8 @@ static int vfio_basic_config_write(struct vfio_pci_core_device *vdev, int pos,
>  		*virt_cmd &= cpu_to_le16(~mask);
>  		*virt_cmd |= cpu_to_le16(new_cmd & mask);
>  
> +		if (__vfio_pci_memory_enabled(vdev))
> +			vfio_pci_dma_buf_move(vdev, false);
>  		up_write(&vdev->memory_lock);
>  	}
>  
> @@ -707,12 +711,16 @@ static int __init init_pci_cap_basic_perm(struct perm_bits *perm)
>  static void vfio_lock_and_set_power_state(struct vfio_pci_core_device *vdev,
>  					  pci_power_t state)
>  {
> -	if (state >= PCI_D3hot)
> +	if (state >= PCI_D3hot) {
>  		vfio_pci_zap_and_down_write_memory_lock(vdev);
> -	else
> +		vfio_pci_dma_buf_move(vdev, true);
> +	} else {
>  		down_write(&vdev->memory_lock);
> +	}
>  
>  	vfio_pci_set_power_state(vdev, state);
> +	if (__vfio_pci_memory_enabled(vdev))
> +		vfio_pci_dma_buf_move(vdev, false);
>  	up_write(&vdev->memory_lock);
>  }
>  
> @@ -900,7 +908,10 @@ static int vfio_exp_config_write(struct vfio_pci_core_device *vdev, int pos,
>  
>  		if (!ret && (cap & PCI_EXP_DEVCAP_FLR)) {
>  			vfio_pci_zap_and_down_write_memory_lock(vdev);
> +			vfio_pci_dma_buf_move(vdev, true);
>  			pci_try_reset_function(vdev->pdev);
> +			if (__vfio_pci_memory_enabled(vdev))
> +				vfio_pci_dma_buf_move(vdev, true);

@revoked true -> true seems wrong.

>  			up_write(&vdev->memory_lock);
>  		}
>  	}
> @@ -982,7 +993,10 @@ static int vfio_af_config_write(struct vfio_pci_core_device *vdev, int pos,
>  
>  		if (!ret && (cap & PCI_AF_CAP_FLR) && (cap & PCI_AF_CAP_TP)) {
>  			vfio_pci_zap_and_down_write_memory_lock(vdev);
> +			vfio_pci_dma_buf_move(vdev, true);
>  			pci_try_reset_function(vdev->pdev);
> +			if (__vfio_pci_memory_enabled(vdev))
> +				vfio_pci_dma_buf_move(vdev, true);

Same.

>  			up_write(&vdev->memory_lock);
>  		}
>  	}
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index b1863d84b11aa..8e840ac413e9b 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -28,7 +28,9 @@
>  #include <linux/nospec.h>
>  #include <linux/sched/mm.h>
>  #include <linux/iommufd.h>
> +#ifdef CONFIG_VFIO_PCI_DMABUF
>  #include <linux/pci-p2pdma.h>
> +#endif
>  #if IS_ENABLED(CONFIG_EEH)
>  #include <asm/eeh.h>
>  #endif
> @@ -287,6 +289,8 @@ static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev,
>  	 * semaphore.
>  	 */
>  	vfio_pci_zap_and_down_write_memory_lock(vdev);
> +	vfio_pci_dma_buf_move(vdev, true);
> +
>  	if (vdev->pm_runtime_engaged) {
>  		up_write(&vdev->memory_lock);
>  		return -EINVAL;
> @@ -370,6 +374,8 @@ static void vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev)
>  	 */
>  	down_write(&vdev->memory_lock);
>  	__vfio_pci_runtime_pm_exit(vdev);
> +	if (__vfio_pci_memory_enabled(vdev))
> +		vfio_pci_dma_buf_move(vdev, false);
>  	up_write(&vdev->memory_lock);
>  }
>  
> @@ -690,6 +696,8 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
>  #endif
>  	vfio_pci_core_disable(vdev);
>  
> +	vfio_pci_dma_buf_cleanup(vdev);
> +
>  	mutex_lock(&vdev->igate);
>  	if (vdev->err_trigger) {
>  		eventfd_ctx_put(vdev->err_trigger);
> @@ -1222,7 +1230,10 @@ static int vfio_pci_ioctl_reset(struct vfio_pci_core_device *vdev,
>  	 */
>  	vfio_pci_set_power_state(vdev, PCI_D0);
>  
> +	vfio_pci_dma_buf_move(vdev, true);
>  	ret = pci_try_reset_function(vdev->pdev);
> +	if (__vfio_pci_memory_enabled(vdev))
> +		vfio_pci_dma_buf_move(vdev, false);
>  	up_write(&vdev->memory_lock);
>  
>  	return ret;
> @@ -1511,6 +1522,8 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
>  		return vfio_pci_core_pm_exit(vdev, flags, arg, argsz);
>  	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
>  		return vfio_pci_core_feature_token(vdev, flags, arg, argsz);
> +	case VFIO_DEVICE_FEATURE_DMA_BUF:
> +		return vfio_pci_core_feature_dma_buf(vdev, flags, arg, argsz);
>  	default:
>  		return -ENOTTY;
>  	}
> @@ -2085,9 +2098,13 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
>  	INIT_LIST_HEAD(&vdev->dummy_resources_list);
>  	INIT_LIST_HEAD(&vdev->ioeventfds_list);
>  	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
> +#ifdef CONFIG_VFIO_PCI_DMABUF
>  	vdev->provider = pci_p2pdma_enable(vdev->pdev);
>  	if (IS_ERR(vdev->provider))
>  		return PTR_ERR(vdev->provider);
> +
> +	INIT_LIST_HEAD(&vdev->dmabufs);
> +#endif
>  	init_rwsem(&vdev->memory_lock);
>  	xa_init(&vdev->ctx);
>  
> @@ -2470,11 +2487,17 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>  	 * cause the PCI config space reset without restoring the original
>  	 * state (saved locally in 'vdev->pm_save').
>  	 */
> -	list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list)
> +	list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list) {
> +		vfio_pci_dma_buf_move(vdev, true);
>  		vfio_pci_set_power_state(vdev, PCI_D0);
> +	}

The revoke should have happened at the time the BARs were zapped.
Thanks,

Alex

>  
>  	ret = pci_reset_bus(pdev);
>  
> +	list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list)
> +		if (__vfio_pci_memory_enabled(vdev))
> +			vfio_pci_dma_buf_move(vdev, false);
> +
>  	vdev = list_last_entry(&dev_set->device_list,
>  			       struct vfio_pci_core_device, vdev.dev_set_list);
>  


