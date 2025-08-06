Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C20BAC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 22:02:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 662896B0089; Wed,  6 Aug 2025 18:02:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 639D26B0098; Wed,  6 Aug 2025 18:02:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5508B6B0099; Wed,  6 Aug 2025 18:02:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 43E8F6B0089
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:02:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B0AC1C0642
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 22:02:17 +0000 (UTC)
X-FDA: 83747706714.20.66FFA9C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6B26DC0011
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 22:02:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EJ8HLaG3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754517735; a=rsa-sha256;
	cv=none;
	b=1mfuvlD/qWG3Os/3agLqs3UUaSwBQvxa94dNUtDp+AG4MwfKLM+3kU6DZU9BFmiKtZGOzM
	eGkvh4azgebpaN0nu4Wseuh7f4a68d0JJeP65dX8+GVYZk/c10DrGxRcMekkxXpqUoLQEZ
	ypAaQzmu+7GjSpnwnvqRL4khpj9SmzQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EJ8HLaG3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754517735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DPKtzeEHbCO/oC/mPOhJydcV6bGZHZZqGISB9ILuO/c=;
	b=Eq8Yl673X+GEyO6JsRH67h5fYWWuIkLdEbH4/ebUE7HCEzE843zV+mOtkPURcVvkVo2sIz
	sjDl/TpilLOspawm1RCvbRpD9vxbe+jp2tradKPFN5LRrmThU5bP+WLEhawHpcIVhVpTzB
	fviJjEHCWCX0YSJedEQXsznRICW4QSQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754517734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DPKtzeEHbCO/oC/mPOhJydcV6bGZHZZqGISB9ILuO/c=;
	b=EJ8HLaG3AmHORad18OoW/E1XyG5awLkhJZcl0Y0uR13QHaEoPiIk+SlokViCHzICYcmhr+
	0sDD0DBfVaIEVPhfD0mO0RTRqm5hF9mOR+OoxFQx46HfEkdcXm3XGqYZfXGIH4iskoxUHu
	ZQGydRPN+o0u/CJjV9RvicCzvoH0ChM=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-408-O_6eoIP8MYyTok_UG_xe5Q-1; Wed, 06 Aug 2025 18:02:13 -0400
X-MC-Unique: O_6eoIP8MYyTok_UG_xe5Q-1
X-Mimecast-MFC-AGG-ID: O_6eoIP8MYyTok_UG_xe5Q_1754517733
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3e3fdfa4b39so610065ab.2
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 15:02:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754517733; x=1755122533;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DPKtzeEHbCO/oC/mPOhJydcV6bGZHZZqGISB9ILuO/c=;
        b=kGAKhulPRNq3RUNYoWn7KVBiuSozBYreFSISKgYeP7+Dp7CWwd1TJR7/BDmttziIIO
         3mitGdv1oFnLTcsxmQvtTqaA45nsKlbYPQdZJk7tasJdbjhKQ+REA/vt0Fl1zHzfzqwN
         ATwNtUCilogePRYbx7vItZRpnxkzB1eLi9b5++hYfBHoMmBPAcYO7EquLHHeUkDmzP5l
         O0xikeAng7ywLe2l3+MNuBm69Sfev9tdBFJJ8jeAS23Nt4f27yiFXCcEM4ZHiM1mEcLx
         vfBR6vHp8Z8PegtavWyrVx03f4saSVmEI7aWoMpr0M54BAGwGcEjfkds37inIxNaYz2t
         xdew==
X-Forwarded-Encrypted: i=1; AJvYcCX9+en+jAUrQ6TuRXID/Sn9vPoJi2XFFyY0yxopybSvctxPGLAgFzZo+TpUvyPC31rSpGwh1kGF5Q==@kvack.org
X-Gm-Message-State: AOJu0YxvdR60iTE3LMUuRH6qC5cowjdoV56uM5TvuJcTC1ZK7+nRk3ik
	pFlyREx+3HgNdx+IgeN6Paqf9giBsttGLlBSee0Ng1l4MNti0q23W80kCErlssd/bOxzqX1ekT4
	c9Y6xgZ52098EQWoco5ASEcs1ge9kROIgFeR0Ejlk1/8MQNCRA/gb
X-Gm-Gg: ASbGncuwUmXEoO7XqhqreVMR1EUhXC2eC/xIMcJoHsn4SLoYh1yA9YX95BTDoAT9sSv
	4w5V6SJwvCzPwNFDscz0wKjtxS44atmIotD+kgZx5oYvpFL1gzQSvlQNL9m/6xjUQZp/6q8JO3L
	c7uuerzEMjtq8f2j0DMlFV7dFllTvtNT0ww6qkH0KXEd71n/3RoBcVAObu7nJ4Diuzv+/XdgT9q
	A2hEUPS1gxcnH2LUkgSSs5nk5Zwl8Qghm2DvoVRBbcF87BNdrDScji6O2ZBMnPg4WfMERjMRnIA
	2N5BUchgB2wjyP9wackidTSga/vXOoAKAvg+qLT670k=
X-Received: by 2002:a05:6e02:3193:b0:3dd:c927:3b4f with SMTP id e9e14a558f8ab-3e51b8854c1mr22432945ab.2.1754517727883;
        Wed, 06 Aug 2025 15:02:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHIzdy8eeJry7tYq6oPCO7e2LCNwpZ/0SyAUMoLDbyTlBwk+OaaK/N75sVSFjgffH+CpRQ7JQ==
X-Received: by 2002:a05:6e02:3193:b0:3dd:c927:3b4f with SMTP id e9e14a558f8ab-3e51b8854c1mr22432755ab.2.1754517727346;
        Wed, 06 Aug 2025 15:02:07 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e40297c389sm63783105ab.2.2025.08.06.15.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 15:02:05 -0700 (PDT)
Date: Wed, 6 Aug 2025 16:02:01 -0600
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
Subject: Re: [PATCH v1 08/10] vfio/pci: Enable peer-to-peer DMA transactions
 by default
Message-ID: <20250806160201.2b72e7a0.alex.williamson@redhat.com>
In-Reply-To: <edb2ec654fc27ba8f73695382ab0a029f18422b5.1754311439.git.leon@kernel.org>
References: <cover.1754311439.git.leon@kernel.org>
	<edb2ec654fc27ba8f73695382ab0a029f18422b5.1754311439.git.leon@kernel.org>
Organization: Red Hat
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ymnn2nh6h1ZIcxDuWHX6N9kSKNM_RO_VrbyvzgPrlhw_1754517733
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6B26DC0011
X-Stat-Signature: wa3knc58wiem34burhe7hr4xkj5z15q3
X-Rspam-User: 
X-HE-Tag: 1754517735-153471
X-HE-Meta: U2FsdGVkX18S8q4YPKPVeXc09Oc/XzSeLKstKg9iopg8reUBb0tVmUOe87kYgDnRk+3MAT2aZboEiplS0ZfDSHiJH/dASfvl2xpW6jyteNIppR+IUq7lAwAGzzdKU2MK9pfdU+f5xeh8b3B3XUUvwlo8YsNnxx+22Kj4QmT9GMEV/adu2XgjmQ4hYmBRR1oxWMJngWOJC/k6OggGW37qqY1P1KIfwfHiySpSt//X54NjQM8WN6fQyhEXjLOB3xjuK0VZszmo9ylWIeNSxBIrgfTtGRyagOxE4SJoAO605rmFCoI6WY2CPkiKskZ2NMZQ5NKeAfXHfQkCN9PYjc5hOx1WQTT+ECV9n9quyk67d53na+KN5SaAua2xaPsZE+X7fL6M8AAjK+35JZC6/Bluj1fsw75rkvctMkdx/Nafc+JU8RPboThxyLqHvjRu0FoQM9L/Wc/peN3P5iX92PZuaN0cJGhe3S+3oxa4zdcVcO14Z8yqDtfRxVGDr1ZNmKOmZIkMPmJZ12Rn7x3xuW0oX8SpY01BVBPd3IdctJswP3irOncmg6+jN8kToRTvhyxAksUMKPxmlyUPqVMo7tdTwE9aTj+pDwQ92eW/Yc78JF+MUf0unwujtGJlHRl7/Dy+PWvocl/udWjfp2DXGAKnCt8U9gWOaJ2A5PAMZbxInKNBMLMEZ/8C+exyWz+Ui2iJDlUAw4ZoIKPQABMih/4xuiqVsJpaLkFPYjG+qHFmtb7qEt9TqOSOcjfw+9bgPGW6AwsQNNPP7mUaqpeM2DXFZuAhXe8jyqkSr4RNNlbk7XrHnSdh6WLJIZKNxSGUw/Ul8hAZtAAe8G4iAweIhcAqM5obNCcyBSlNkffG4TPFGzRKuiFbaKj7ksFoaJrJDc/yGQqtVbw2cekPZUtNZZVC1lubempWh+h6bNfw+16FstCgKETih1Jx2YvTLWq0kZp1+sHA0ozuJIz5oWfi/NL
 N2ykKowm
 HCpdq+MAZFg9v7Sf/plkWKJDfPKl0rxc+ChmL265AVac2eBw3HUMI0lMnwowKBrNCMFTSpA4XfMxy/QXsoRueU2XoFwcMRVp7QbT604K/PhnhRYob7kEPEUJbhW8g/TihSY1AnAOpIEYVX3NDpbuUFByef3LRc7A8REhV1dOVtjNsn3E4WEGz3lGkxRlh8KwidkheoR7335Ksz6eHuG6Qy63OSgiKylZeGeKVu79CyxFdlCree1Tu8ybgoi/klTH1vxcsoQsCay5+D0qBCJKMwe5enmJS4wTN1CRovowzR6qQa9Sfkku2xAxBoVOHAPPy7yirfbUFPkPVcObxfCJojdW3MJq6xLS+tAWklsq5BuyLHA52I7W3/TlVJ8HlldR092p+9Cv1N4l6VsjEAaiHh8uBiTEs6gGSmdgIqc7mIsUx6qaoL9baZVybEUjedGfC9CryHAR68PYUVCdw4EURao5eZWPY992l1cmFAtIBbFi9B9g1FzxuF+juNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  4 Aug 2025 16:00:43 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Make sure that all VFIO PCI devices have peer-to-peer capabilities
> enables, so we would be able to export their MMIO memory through DMABUF,
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 4 ++++
>  include/linux/vfio_pci_core.h    | 1 +
>  2 files changed, 5 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 31bdb9110cc0f..df9a32d3deac9 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -28,6 +28,7 @@
>  #include <linux/nospec.h>
>  #include <linux/sched/mm.h>
>  #include <linux/iommufd.h>
> +#include <linux/pci-p2pdma.h>
>  #if IS_ENABLED(CONFIG_EEH)
>  #include <asm/eeh.h>
>  #endif
> @@ -2088,6 +2089,9 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
>  	INIT_LIST_HEAD(&vdev->dummy_resources_list);
>  	INIT_LIST_HEAD(&vdev->ioeventfds_list);
>  	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
> +	vdev->provider = pci_p2pdma_enable(vdev->pdev);
> +	if (IS_ERR(vdev->provider))
> +		return PTR_ERR(vdev->provider);

I think this just made all vfio-pci drivers functionally dependent on
CONFIG_PCI_P2PDMA.  Seems at best exporting a dma-buf should be
restricted if this fails.  Thanks,

Alex

>  	init_rwsem(&vdev->memory_lock);
>  	xa_init(&vdev->ctx);
>  
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index fbb472dd99b36..b017fae251811 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -94,6 +94,7 @@ struct vfio_pci_core_device {
>  	struct vfio_pci_core_device	*sriov_pf_core_dev;
>  	struct notifier_block	nb;
>  	struct rw_semaphore	memory_lock;
> +	struct p2pdma_provider  *provider;
>  };
>  
>  /* Will be exported for vfio pci drivers usage */


