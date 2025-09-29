Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7459CAC5B9
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 21:17:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CA3E8E000B; Mon, 29 Sep 2025 17:17:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07A618E0002; Mon, 29 Sep 2025 17:17:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAB268E000B; Mon, 29 Sep 2025 17:17:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D57E68E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 17:17:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 672D81DF690
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 21:17:51 +0000 (UTC)
X-FDA: 83943549942.12.7839954
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 01F651A0007
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 21:17:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WPsZ2uOK;
	spf=pass (imf19.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759180669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pvJsfDbbmraa6iCCkjoqVoBB3Mb9XdjPoCcVP3qHFzU=;
	b=UvWOuK41HhpUzCYTtpou+3w6e1stTDeG4dxRi9CywShmvJBX6fslpOqVWFYcWnaDyVJr8D
	oi6dNRPlYbdV+bDrg90/I46t7fwBZunWtkJYgGtr3arQBeTymVPVWD3RrknS9Z1T39Fit1
	DpRbeI/tjwITKxJ12K3yt5AE4s466d4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WPsZ2uOK;
	spf=pass (imf19.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759180669; a=rsa-sha256;
	cv=none;
	b=RpfyOeyHNdC+9dgle2CyDpceKg4lWPZ4f0v99eYj65wzEqkF9MEaGZsKjDKJkXk61cis+h
	pP5jaurkeBcO5QfBDRhGqZQWKRPYzEb7G0nG5GDZDwhUr0w6R/U5QkQd0kdmlTtMOZXOmX
	Ws2Lu4ukBX1yRo4J1UG2v4WwtJISNCs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759180668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pvJsfDbbmraa6iCCkjoqVoBB3Mb9XdjPoCcVP3qHFzU=;
	b=WPsZ2uOKVqLQETBTtPI36pbF0fAxED6UkoBsRTJc8vHtRaFEZDfFfPLQP4ljacqDJheZ5W
	Y2DEBoMwKaz+PbrPOZllAvla0F8AGl+z0U2IkumRHuyBNeNJKaAk7AkouWXYCg5LnrrMk+
	dGbbTCtYvPQFnwpVJmRFJ0nwxKf4mZs=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-423-0algKbxbMMys6U1N1D4Fng-1; Mon, 29 Sep 2025 17:17:45 -0400
X-MC-Unique: 0algKbxbMMys6U1N1D4Fng-1
X-Mimecast-MFC-AGG-ID: 0algKbxbMMys6U1N1D4Fng_1759180664
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-4264c256677so13488735ab.3
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 14:17:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759180664; x=1759785464;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pvJsfDbbmraa6iCCkjoqVoBB3Mb9XdjPoCcVP3qHFzU=;
        b=C1lcYhktp9smz0sl9AyhHAoNTGBRTsMJeeKM+leQMnV5v69au5m5/RMVRYM3mpYKOZ
         OONcITrPlEa9oVt4+aeQCyGKsIZSF5FRSMnybVty/j0MQc3Fz8OC+ug6bMwikeUlNXwj
         MyI4AZft6EITjdxqrZvhNgytBqDf1Oa3jCVP9IU/a1f+G1hcHceBfVH8Lk5QmMTim+9E
         NC5RpFAzbFV1K6wVlZqgyPTcjkf/S2+dDcl0ZTLKTogS8g4VU1b1xbHiBhuzb7HR01SK
         gKCD8sfJEqs9fcCdtMz16ikQPzTHh9z7bpWcBZMbZTUioQ+elvP9GzdbFIVPzPjFe3n7
         hR+g==
X-Forwarded-Encrypted: i=1; AJvYcCXhgIJzXbxl8EXYvXH9Jv07cxFXQjLLP1RLpg6mtpVU3pyvP9EouSoNYAVtZwwixETkglcvcoha0g==@kvack.org
X-Gm-Message-State: AOJu0YxGwJs4hbojGA3QdvckiVPEPRQSTR12X2qLuaSJFhdVWVFXXaRt
	GgR/a4jN7EOVVVvjB644mQj8iyZR7cPEPuHuy5ee4WS8xES8lrN9ooeLZNjxT77Q4jm85zjukzW
	WX7+4qSdGkorGnp0EYVqC59ny274gh2Ckc7C+Xvdv0N1021ynaiD1
X-Gm-Gg: ASbGncv0BTPr7pJxYu4dM1KEKP76FxorriUnzPxf8fJCuHYpZbkLMDNbQVRd8RugfLu
	3cK3COR0hSqudawiPimVVRHPn6uQw0NXKirJMd1a6ANuXARzOTb3n4h9rMKn/SiX9U6K4Xop4OC
	q2NB7i/5YjFc3ZHHRsmktqj01tb04jE2bFdvCVZBIPGKa4bghOyNwBIN7UelbQ1EouCtjWnC/1P
	TDs/94TbStW4gZhhR3RtlZ1IUM6NLlQc+8vqDd3IMSkFZhkSWnHjtTfjTdX0VpvEvXry7avpUmb
	RMUk9Owl/So4YBTF8PwFY9eO/9AfuGMCzc5g8tHWvv8=
X-Received: by 2002:a05:6e02:1525:b0:408:1624:b2ee with SMTP id e9e14a558f8ab-425955e4f60mr87964875ab.1.1759180664144;
        Mon, 29 Sep 2025 14:17:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG3VrvxaH7k00bkTZJWrxcv/Xeuv7Ik/zOnPnH3ASkfKmA5ptZ34qoyLfGaDXRfunQjFfs8kg==
X-Received: by 2002:a05:6e02:1525:b0:408:1624:b2ee with SMTP id e9e14a558f8ab-425955e4f60mr87964675ab.1.1759180663680;
        Mon, 29 Sep 2025 14:17:43 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-57269f5d0c5sm1963571173.13.2025.09.29.14.17.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 14:17:42 -0700 (PDT)
Date: Mon, 29 Sep 2025 15:17:40 -0600
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
Subject: Re: [PATCH v4 07/10] vfio/pci: Add dma-buf export config for MMIO
 regions
Message-ID: <20250929151740.21f001e3.alex.williamson@redhat.com>
In-Reply-To: <b1b44823f93fd9e7fa73dc165141d716cb74fa90.1759070796.git.leon@kernel.org>
References: <cover.1759070796.git.leon@kernel.org>
	<b1b44823f93fd9e7fa73dc165141d716cb74fa90.1759070796.git.leon@kernel.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ofS-FHxVej_062jS65kjYPXSTsCVuzG4k-k9nrX_H-c_1759180664
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 01F651A0007
X-Stat-Signature: 9x38txeo6xa7pydpr6ibk7tgrbacse43
X-HE-Tag: 1759180668-894072
X-HE-Meta: U2FsdGVkX18u7Td3EcVdDkwuMs2G3hgnfZzj3+ydEQhVzKbbmxkSqAfPsFfXd9bWxqwf8gxXQYuO1PR2RoVY0JIrzmKe1p0mTLRclnas6F938MgqFmQrIPcbGBlyrpHMX+Lsz8IigwRm9wQplDP3SE/89r5QRVjso56NizRRZsYVTJo/Lky5h0o5PhMVUVy0JWJ5P+qTUYfLw2SIN3zROmtZVi91lVCvoOo+T4YUfeqpZqjxsjb8OYXzg81jB8iN03ut9yLfZtRroGu3pnHZIqA06YML7YSgNtQ4PlqN87IWg7DkxjYeSlq1vuo+nP8kyZGKrVqJghafwlbjzzjIqwHq8nnJ2KrYMsus+B8pceHJZFkQH/jXgFGiSn7yXNKjmXiC1Wh99OGPtiyE2Yym9iGxYSmYZasc/Vys/fBTOglNXlmfLqgI81uhNkO+qpfQRylS6G7bBFG5Zxf3Gh2j6Lt7juY5J6BKTD9qwGvt6QwnE6KuOz4ITATTXN/XNkLdOiEHh6krB04AzoH23JKFcAtjtmgjNoOtYuQQdf8GFRm7dJAhW+3kvyeYmWLoBfk/6ieIPQy7uT3vo06JVR1iaAssWvUHXjPLkmJzSYz9ysuXbZ93vQtEzgSQ+5bZlAhLpWCaa0Iqfs231mDumamKwfFIM/5+7W+r/X4/5MIHx+8pmnzApSjEhddEHwrrrphPSHvqDqNvT+vuawYggTJbydRGMHXv+epFYH/lrByB3nBPWRWZCgRbyO/Txm/3ua8WCiuQJY2XIZE6nGouFzSlM29PEsba8hwKevuQ5JbCpkZ6sp1YQ3uxd4QLrmfUdlQmpvfbYowTzxfMyCKinblXX50YPNRj7wW+98TTfL8SSvszx2oukR2O1n6mveHTQG6qAZMZcJybKzGUHyCxiaRju7Kl2Gix1RRtV3N2Vz+Y2574djkDns6/vKu/WzpEJXjqy2csvMKiU9bk5aIzvl4
 JyTtk9Wi
 i55GfC47t8sQLoXm1kMPgvzXC/R8PBZsYR1nYKtb/lhLMWrcsmyKZz+YFk2HMZPfM/zYdL79ymVkNFE/NXXkjU2DYm6xG16xspmiR/hO+ZTVg0wM8gR6dJAgQuAnHz4V2Pj6wTlkgqAwg7RDY6iZxWSFvTw1A4D2bNdvIcjDnNZiscLXwXUApmFx/q+PUOJfbp5oYy0cG7k+uiFYxSXsR0VXOXI5zvSJGQ4qLe+IA1zrRImRlEnDJ4KP7giZEHc0m8u4G9ng0IEhq1ZR9/RtSlYRWaO3U3BUDK4Va2FpWuK8/TJl+xz+Iqg/e+L/KFQZFkfbq2EFu03DOKtu7brbqC64ei/3OWzcwXU7durgZpkp0AgKUrFpsqJ/j0OEg2LbrGPDtSlqvh7Qu0Ww=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 28 Sep 2025 17:50:17 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Add new kernel config which indicates support for dma-buf export
> of MMIO regions, which implementation is provided in next patches.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/vfio/pci/Kconfig | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 2b0172f54665..55ae888bf26a 100644
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

This is only necessary if we think there's a need to build a kernel with
P2PDMA and VFIO_PCI, but not VFIO_PCI_DMABUF.  Does that need really
exist?

I also find it unusual to create the Kconfig before adding the
supporting code.  Maybe this could be popped to the end or rolled into
the last patch if we decided to keep it.  Thanks,

Alex


