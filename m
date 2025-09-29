Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E109CAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 21:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFB558E0025; Mon, 29 Sep 2025 17:17:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E850A8E0002; Mon, 29 Sep 2025 17:17:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4DC48E0025; Mon, 29 Sep 2025 17:17:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BA9528E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 17:17:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 765A51404F8
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 21:17:53 +0000 (UTC)
X-FDA: 83943550026.20.D451A73
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 32BF1A0016
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 21:17:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eSzIvrH3;
	spf=pass (imf15.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759180671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pary30BmU4/NqakwYdG1eNkY0RiL1NyFW4TmIsuJ5GE=;
	b=rrKVMb6pLzfn00HteG38k+1oRN7Xeb27DmK0gtl9170DFEizENvQ3F2JmkAPCOC5+ZnGkQ
	u6XLbO2HnPeIU4WrfDDShmo7GWWVHIViDeDnSBG4lg5kRO/IRsSTExq1aDtA4joYakeNRb
	uYdlHqi0rA+y94JADQ5orJBsp/SBV1o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759180671; a=rsa-sha256;
	cv=none;
	b=IMJfugS2BipxARVhfVcFJSziKj9VUwAGRzXiIvJ4sRvKDX0/m6JpRR5bdtnVCkSC0TuEa5
	vt8mLBDnEVkZmpZjMWlPeH7WNUa5EzaQcecXA7kDvs1AmKtZHtTJ2OMDE6Zhs8fWWXjYf/
	dvsfohfQBBXEZix6MXATx1/tefE1MwQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eSzIvrH3;
	spf=pass (imf15.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759180670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pary30BmU4/NqakwYdG1eNkY0RiL1NyFW4TmIsuJ5GE=;
	b=eSzIvrH3TgR0u/E7xT35nD+af8z61fl3d06j8oab4bPnIAOmHnplVN848Li+daD8aG2NUl
	eo9ppaNIkhWD0cfULhpqQAOKXbhi3NB/3F3Q77eGKJqGllFgASG+czUoRAp9Mk3BRKkKmM
	PaGkjgchT4tV6RFaWyNW7XHFmxsUftE=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-kS1B4gpvOjimKQFeukoh4g-1; Mon, 29 Sep 2025 17:17:49 -0400
X-MC-Unique: kS1B4gpvOjimKQFeukoh4g-1
X-Mimecast-MFC-AGG-ID: kS1B4gpvOjimKQFeukoh4g_1759180668
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-42b2a51fab6so3496305ab.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 14:17:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759180668; x=1759785468;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pary30BmU4/NqakwYdG1eNkY0RiL1NyFW4TmIsuJ5GE=;
        b=xKWFXbcfFh45M5mECg1/jLl9El5Qb7WNLvSg6WPj9DTkSCJFnTnDpYktJLEvRvMU30
         QocFqb4AmnYF6uQOV9u3mA52cBp0SdFb32lB2oLph8IbaxdUfZz8wAE28yXdqW2EWI4o
         S4cbe4mJtJAaC5sL7inkyG6q5NwdEyXWVJkFJwuGlurcbQE28S7BmYzZl6iX2kClnui8
         s0CwsaQBM/5F3SzEUhAan+Z7FOVvPv9ew+VBqV4CknXi3+swLd3lQLGAzZFQL6qB9AMU
         LkaBg3fVPDfrJMph3DkECZx5izsxbZKzb4+NfonFEDO8jNdSMBjUw/oZV1lm4p5eqw/i
         vcrQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9jcFsqQmJeDqLnzHQ39Zny+ZmL/cqYpCWsEDDdiHUK9b7n7gXEkf1WpQ/IqnG2NtJhK9TXGMnJQ==@kvack.org
X-Gm-Message-State: AOJu0YyehVCMxgxX0ZEb6ZgAEjiB3WxmB1n+wFdv6CifIKyE4zYsrnFq
	SXjA2iCpJJ3Y6Ks0ZBWhYcccCw//QEoq+6DVfO0V/OCn+qoXVHK/bTEN3U9CJX58yCrsYg5n+xV
	LSoopnpBR+WPw0Zv9yGmPh7cKj+8N/Zu/FKGBAFlkoAU3JM+whR9m
X-Gm-Gg: ASbGncvuSSDgW2U0YuPyc87sagyomWr81cvnpUVmjDFWp3SFQuhUZSB76Xf3Brn6iwz
	3fmUOzLKNeUxgyPLjHvPcl1rxdlvYDUdO2YKJRMTaArTTgKQOe2Onm3z2ijfBgnnqYS7QkB5JRH
	ir4pQM9d/jkQTR14Lw4DooFtMJVljnjGWZz2ZdNhfyiSoCGQ6EZozXVK87MkjiDfBXZdk7Ra3Wb
	i8JUDWkEbREPv13IprZiO/zrRfV2BYqM1AA8B7hde6FrSoo9V8DEOQElBOREvEs21yX7M3o/Pow
	olfc2XGPkrQmEUw0N2c+iAPqH+sVhpGFTbJZl8yzsWA=
X-Received: by 2002:a05:6e02:1b08:b0:424:6c8e:6187 with SMTP id e9e14a558f8ab-425955e4dfdmr95833755ab.2.1759180668374;
        Mon, 29 Sep 2025 14:17:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHE31/4ZuuqxcHY5C8RvKg6dnDpxm6QWjHiIpet9IRXNGlsIsGmjCxy18kHCIW8dgbK0MWZ9w==
X-Received: by 2002:a05:6e02:1b08:b0:424:6c8e:6187 with SMTP id e9e14a558f8ab-425955e4dfdmr95833605ab.2.1759180667942;
        Mon, 29 Sep 2025 14:17:47 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5753c50a188sm920778173.31.2025.09.29.14.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 14:17:46 -0700 (PDT)
Date: Mon, 29 Sep 2025 15:17:45 -0600
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
Subject: Re: [PATCH v4 08/10] vfio/pci: Enable peer-to-peer DMA transactions
 by default
Message-ID: <20250929151745.439be1ec.alex.williamson@redhat.com>
In-Reply-To: <ac8c6ccd792e79f9424217d4bca23edd249916ca.1759070796.git.leon@kernel.org>
References: <cover.1759070796.git.leon@kernel.org>
	<ac8c6ccd792e79f9424217d4bca23edd249916ca.1759070796.git.leon@kernel.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qsCgLiSsEGAHe-YKdKCsY5cF3TC9ov0EPkTRPj6sJ6g_1759180668
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 32BF1A0016
X-Stat-Signature: 7kju7c16691i5556bonh6a7yiap4n1zj
X-Rspam-User: 
X-HE-Tag: 1759180671-851806
X-HE-Meta: U2FsdGVkX1/GrJ0tfIR23JEBK9MtQh501JX07keUu3mtMOvk+jhzXTlv6OHOAnO/Jy8zPxksE35Snf593c/S9IBaM5iqeMKCn8P1W6gfSU/np6+vbyMOH0srB2uFiSbxVKkbG3T6YBBsGW5+5t8tixFfTyrJhR8WvWYacigNSNAdQh14dSRQM6VHWalBDbHkGAV20UvYVP4XdrAInxMT+WHVv8P53W5E5UYGP/9YOxMC74yyCl+ZXfL4tNuDrUEvPf7lj2bq9YSe23FB0jnRxA4IuLWc5WFhkfKrQ2WJk4aS4ZYlF3RhiaWNKnMgpxJ5aCJmQTkNXOvvP8Lie13BogMubgNaF8wAvjIFPth+OmbdsMTJ/eWUnvGy4DPkOzrATktoOhyKD7tk2ZUXgyW/E4HGe0GbDnNx0HJ6HUUSgXCSm2MfCxNsQSn8SqSKB+MVSuboQA5qCyfshulm5b8Uu3wHAsuhf84BhzK+6KOvBPBWSzvusoYOFeHUJ5g/hfB0oj8k7e1BEs+5lYWIPO3OvSZIILygo0jYCWZQTXPW0NEgxCr/McTd+CTp019xjM17iAVHAQV8iHXjD7nTzsLdUgA9XL+m4QRsg95RqFckfVM5zZj3Qu9vfNlzYoyOd9BuoyDOmoUDPZgYqPHO9kyjwU2bsejqb7HeYZzdz/+IyDZA5/M3sVscFxrR96VR5uOYuICLR9k+4P55T6/1semArHm3JA/EVioN+LwqnwtXWqWpmiSvAytQf5YLCWRMmYQN40lycTT/JmGVveuZtFc7q36RYYijcF86LDB1wTj9Arhhr4Ni0VJzzQVTYmLnYP/qE53PYHbFA6zE8PReMdSA4oSwfTHyDXDZlSOQeztj77i9mq4ol/mgcZM3mizQY9aFP1V4Gz/g6S/fKXMP/ry8gByAVtYUKqGqFcS1pkyvgPQKB/LJ7zLo79FOLb4K5OYihvKJrvT/vC00quy4hSn
 c74gGPkj
 Vq7jyD6HrgG263m+Kog6d/KirF+oaGV9FmmfDAfyK4HAZHFWS5ZUZTypMvuyCM320KBq2c/FRXAZbrqXmOfZ4WvoayFMJqVoszeePYLfxL3ZPJZYllKkVx64yEE1YZFuAWAL5r0jjxf/DvX1gQtCjkPEheyu5Mf9q1wrLF2Oli4Klh1Trr624+ERiXchk6Bk2odMwZCKDKsej0djd8cRSY5fFqJuqUwnLTgtAWhQnzNQ+/BFfi6ovUeQp5qQnaiswM6WbvvVwNj5KRj9kDY7wPSPAriyuVRrioO6wLR35ZXyo4sSDouX5skI59Mys11MBJljWqj9V2/pexpPLk2j3A7jDww0JXV27rRdD6FcK2HEO9k5l4m6G5Wdfx8H3V5QOH/b2U1hqyMU0bA8QNhQrjcU7+jAREVbcbF1aelcDmo0MKuZL8Pzw01gpff3B1PGjhCsL7bwVENYMT5L3Y46Kb4qc3GuWIn9JWxqTn4Ffci8JR7w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 28 Sep 2025 17:50:18 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Make sure that all VFIO PCI devices have peer-to-peer capabilities
> enables, so we would be able to export their MMIO memory through DMABUF,
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 7dcf5439dedc..608af135308e 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -28,6 +28,9 @@
>  #include <linux/nospec.h>
>  #include <linux/sched/mm.h>
>  #include <linux/iommufd.h>
> +#ifdef CONFIG_VFIO_PCI_DMABUF
> +#include <linux/pci-p2pdma.h>
> +#endif
>  #if IS_ENABLED(CONFIG_EEH)
>  #include <asm/eeh.h>
>  #endif
> @@ -2085,6 +2088,7 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
>  {
>  	struct vfio_pci_core_device *vdev =
>  		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +	int __maybe_unused ret;
>  
>  	vdev->pdev = to_pci_dev(core_vdev->dev);
>  	vdev->irq_type = VFIO_PCI_NUM_IRQS;
> @@ -2094,6 +2098,11 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
>  	INIT_LIST_HEAD(&vdev->dummy_resources_list);
>  	INIT_LIST_HEAD(&vdev->ioeventfds_list);
>  	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
> +#ifdef CONFIG_VFIO_PCI_DMABUF
> +	ret = pcim_p2pdma_init(vdev->pdev);
> +	if (ret)
> +		return ret;
> +#endif
>  	init_rwsem(&vdev->memory_lock);
>  	xa_init(&vdev->ctx);
>  

What breaks if we don't test the return value and remove all the
#ifdefs?  The feature call should fail if we don't have a provider but
that seems more robust than failing to register the device.  Thanks,

Alex


