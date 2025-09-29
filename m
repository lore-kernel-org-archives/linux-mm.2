Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29B94CAC5B9
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 21:18:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86B778E002A; Mon, 29 Sep 2025 17:18:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 842C18E0002; Mon, 29 Sep 2025 17:18:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7801C8E002A; Mon, 29 Sep 2025 17:18:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 68DB98E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 17:18:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1DE9DB946E
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 21:18:01 +0000 (UTC)
X-FDA: 83943550362.24.4CA5D8C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id E87ADA001A
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 21:17:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="RkrDBj/m";
	spf=pass (imf15.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759180679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tBEzt7vDi7cQon8pe4PxgzLkANUC3bHfRN0ntBJldU8=;
	b=XFUhs4FFXPKMUSNbuRsZJR9zcdUfWtY5e2X1eS8sB+v2r3ZloljxaasXERemBg+6KzeRsS
	FiyAadZX9LRVR8jw72ndGuiJVWNyL9ksdFV2KXfxLD4zzAWK6ojxWk9Z/E4RzJ34lCNsva
	nR/BmIE0V4w5gmH2PSHXUqhIiOQToWA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759180679; a=rsa-sha256;
	cv=none;
	b=M5h4htvboW6k04XTL/dR6rZSZZn6lFlnkU1AQLAwV3MpK3PHLtTe2w98p/LI4y2XF9YtJX
	WOAQfQ8fYeDMCtmR3MkoIGbsV4zdJPHKUMNN0k061Y6QsDwZw2h1nGzyTUqQmIl3q7202A
	g9ZI+pPw7waOnnGm4OGHuATEwE2Sj5w=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="RkrDBj/m";
	spf=pass (imf15.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759180676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tBEzt7vDi7cQon8pe4PxgzLkANUC3bHfRN0ntBJldU8=;
	b=RkrDBj/mQQk4PuIztoKVAa3F2+AgcdomwVixFGYufQg5Deu8Zu98l2VqcGwMvtnlXwzK2H
	cG9/BomPpzqSUCEikh5TuwzGREP/mQVr8dmbK1XBjwWdJsIQZE0NO5BIWnnTE64b90C+eF
	fxqqlsuusBPTCfMUM0qyIVLL7DJf8y0=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-694-JnWIcOpMNuinSdJghUovPg-1; Mon, 29 Sep 2025 17:17:53 -0400
X-MC-Unique: JnWIcOpMNuinSdJghUovPg-1
X-Mimecast-MFC-AGG-ID: JnWIcOpMNuinSdJghUovPg_1759180673
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-42b18fa4b81so5192905ab.1
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 14:17:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759180673; x=1759785473;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tBEzt7vDi7cQon8pe4PxgzLkANUC3bHfRN0ntBJldU8=;
        b=WhTbqquWUFXU6D/gs/g8ymAdaCalCcW+6ifZyzBtyatfoZw0tX8tTVUiBHK24I1nQh
         lSSHTTwppojin6ZrfezRqxif9UDgys1FpiSW5fvsLcVVHKguzSh/b9Vm4B8y2P51w+J1
         gRH3kIAuNQzb5vMHl5DfHo+YqKbGnTZ4axP5MAqMqJbUvxPkuoAeVxuTYLhMX3aNkL6i
         O/vzyn5cqVk4ibmlawYkFmEVNPBwyzgXKUcdTzP/3unz9SRtis6bDHmYVfoXuOErFFYA
         O6C+bSr11O1COKZqo+OTuVrJup/cN+fVgKT3JfFBXyPU7SQK6YjqEDE49r6w7Ccal3SG
         AVzw==
X-Forwarded-Encrypted: i=1; AJvYcCVw553ZFwXL4UqjJ/A5x6ainRKNfB5sNZsbmRC4TWGs0CXuV6sxAo5EjuBrYlYcb0Zs3weHQztzmQ==@kvack.org
X-Gm-Message-State: AOJu0YxoHujsxaP+klVf9LNJxOclWvCN9izaDBZYNZ8gr6g7soGW90nz
	PQR4kN9O/z66us0lIAEo7wCMi0Jnz9uj36W1DtWgF/C3DxSAGla+vW7WqsXZOnusPLDn9tmYusy
	mIJmbkD9dvLoxPgzXBVUfINUv7RDu3BmL8yzmvjBb7lkBqdHzPWJF
X-Gm-Gg: ASbGncvCt9veaSxHG06iLWKIpFawmD31K5lMnP+INk7S+38vtLlqgbmiu2akEhgurbC
	GmKY9S1tcaCBAF3rOSMQCCIgFwUtRjV9ewrLLGTAwIFX8o3ernPJWGb1Kac4YV0eSK7a5k6S9qf
	A3eVzejhPFDuOfcl8QQnNPbExZVvuHimFguH6Ctv35b4Sz4SgdS52Gn4n9UQZtYZTYBF9AJjuzG
	zJIotN3i0y7cKoHu4XY9J+FCFkrXxWB25aMyDScNnbJgnoEIahyo0DH+SfRt5iYCfhvLbthXXv0
	qpkrj3xj55UFIAtvmPuSXYiTG85MzvSSfl0Js8mOSMM=
X-Received: by 2002:a05:6e02:1523:b0:425:9068:4ff with SMTP id e9e14a558f8ab-425955c8eb5mr97782485ab.1.1759180672735;
        Mon, 29 Sep 2025 14:17:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFTF4nahZRRX2gicTqxhxWdWKeUzRDCgsQQuCRfxHGJ4HNrczL75firr5hrFe4LKeaKRuPCNA==
X-Received: by 2002:a05:6e02:1523:b0:425:9068:4ff with SMTP id e9e14a558f8ab-425955c8eb5mr97782155ab.1.1759180672251;
        Mon, 29 Sep 2025 14:17:52 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-425c05476fasm62141985ab.43.2025.09.29.14.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 14:17:51 -0700 (PDT)
Date: Mon, 29 Sep 2025 15:17:49 -0600
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
Subject: Re: [PATCH v4 10/10] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20250929151749.2007b192.alex.williamson@redhat.com>
In-Reply-To: <53f3ea1947919a5e657b4f83e74ca53aa45814d4.1759070796.git.leon@kernel.org>
References: <cover.1759070796.git.leon@kernel.org>
	<53f3ea1947919a5e657b4f83e74ca53aa45814d4.1759070796.git.leon@kernel.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Fb6qiBjhLYGdzzlrX7AT-U8S50dIosaT5HclIEgTJ7k_1759180673
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E87ADA001A
X-Stat-Signature: 5fwcrbpwsqjs94xpe7gc3ngkn3j7inf8
X-Rspam-User: 
X-HE-Tag: 1759180678-657283
X-HE-Meta: U2FsdGVkX18Zunlpwp+8BvuQv6CJ0s3dP2YAUXWf2BUNFNsLsV9TL/OnjEP+VV4HCTddesgr7ehcxQ9mNLgYprBiYhO59zHuPMd2R5e+8p7382FP05pPZDPFN5GU4dt4plhELC6u27ZyY3u2t9UQlD9Y4tSqwjtB7BAHt3fRaXaezKe2dzzFzDHhEuJ1PnJEFgpve87kEw+1uq9KyW6FgfIlvfsHIQR3ZdorlthwWPC1JA0+Yd2Pdew6m5TKjge9enI3My5hUgL0DzRHoa2qTD9ojxMbUcGwe8sGipI0LNjzyjU2C4IloYYETobJ0yqPJ70OEQBlw8WwViPr8lz1oyB/emGQSOM2Ffk3nkpCPo+jqOtLsCIZUxLZC+d2mHXrNyG9mNXaqVetv1/aNvSNFd/3orsp+gfpu7E1xFLkUbQymeOOkyla+cI2Leg0CVLdcy7hwYoOhRKR1nMH2F82V1KdjqrOx7W9/fEzQ9qUfjt/G+2emveM8VCWGo93hsZyHkL5m4AW0Q3jPLUFxUWKwxPM2D2eLWSxm4T7YDbQG1F9j24jwBSpd01KlxsytH7dg/sQgG33hq9B/fUBecBdeppr1S579qsaa3vxlPoVZsgyMq1zNQ2UqufVHhLWFeFni9hPEXhtHKGoxztzPuqyuWAa4IdthOK66BawynD6r4gkyCj3hJa/nK+WxDO+xY6PvXAbqpwJ4gPCIjaUoCZkRrBE9aTkaw8cDYWkgRsfDVqNwt7YHYX0DZlC1GR2DC0TIAL/sWlkWoAgFbtde9JDtc2HI5KDjmz6WHnSBYmzA4FmyEb9iuAvUaKwOlWrJDZtVabdBeN3JHx/AV6XnIegWGuREzs7XaNagXs2QvNhTGE3GvyiGODISBcxog+ot4XWxItuwbYWtfQpLbdZjrXmSR0LZeD4uI2/3bb5Q8XFdrP86mMpHs/8cWCcn3S4Iz/PzgmI0Ojh6vyJ6UCKX5W
 zsPaM3pT
 1wQ2wBECPwPCSdaKbyY8iXawy0t8q/fyFz1JDr8bk6NxA7Cpq1KrodUNjHymE5j0gIFV+skH7TXibhS8DLaa4nuMLdGdl3fXK0yrgiBDOiMc/kCPWnmIQAbd3ITksakYP5VQMQiQmFKGI0l5CrNJn8Zbr42ORu+Uj+JcvntD/JPdKdCYO1xAXKDe+awOjuCN8SzyoPovbVYebhpLfNYB13K4M3Hy4C2KtftHcXhO/4hbOZ7N3yqTn+pMSauaDwuukBt0nUbV8IYPECrEIdm2zUftIWHYhK2C3d8mGAFZ36VqkWZmrmg+EcPxk7FdLJCyv8LcVhdb2FZ2AhDCvJqdevMErs/o3Q43dJO1Z0WcY3B7+5BwTfyQzQqay7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 28 Sep 2025 17:50:20 +0300
Leon Romanovsky <leon@kernel.org> wrote:
> +static int validate_dmabuf_input(struct vfio_pci_core_device *vdev,
> +				 struct vfio_device_feature_dma_buf *dma_buf,
> +				 struct vfio_region_dma_range *dma_ranges,
> +				 struct p2pdma_provider **provider)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	u32 bar = dma_buf->region_index;
> +	resource_size_t bar_size;
> +	u64 sum;
> +	int i;
> +
> +	if (dma_buf->flags)
> +		return -EINVAL;
> +	/*
> +	 * For PCI the region_index is the BAR number like  everything else.
> +	 */
> +	if (bar >= VFIO_PCI_ROM_REGION_INDEX)
> +		return -ENODEV;
> +
> +	*provider = pcim_p2pdma_provider(pdev, bar);
> +	if (!provider)

This needs to be IS_ERR_OR_NULL() or the function needs to settle on a
consistent error return value regardless of CONFIG_PCI_P2PDMA.

> +		return -EINVAL;
> +
> +	bar_size = pci_resource_len(pdev, bar);

We get to this feature via vfio_pci_core_ioctl_feature(), which is used
by several variant drivers, some of which mangle the BAR size exposed
to the user, ex. hisi_acc.  I'm afraid this might actually be giving
dmabuf access to a portion of the BAR that isn't exposed otherwise.

> +	for (i = 0; i < dma_buf->nr_ranges; i++) {
> +		u64 offset = dma_ranges[i].offset;
> +		u64 len = dma_ranges[i].length;
> +
> +		if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len))
> +			return -EINVAL;
> +
> +		if (check_add_overflow(offset, len, &sum) || sum > bar_size)
> +			return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +int vfio_pci_core_feature_dma_buf(struct vfio_pci_core_device *vdev, u32 flags,
> +				  struct vfio_device_feature_dma_buf __user *arg,
> +				  size_t argsz)
> +{
> +	struct vfio_device_feature_dma_buf get_dma_buf = {};
> +	struct vfio_region_dma_range *dma_ranges;
> +	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
> +	struct p2pdma_provider *provider;
> +	struct vfio_pci_dma_buf *priv;
> +	int ret;
> +
> +	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_GET,
> +				 sizeof(get_dma_buf));
> +	if (ret != 1)
> +		return ret;
> +
> +	if (copy_from_user(&get_dma_buf, arg, sizeof(get_dma_buf)))
> +		return -EFAULT;
> +
> +	if (!get_dma_buf.nr_ranges)
> +		return -EINVAL;
> +
> +	dma_ranges = memdup_array_user(&arg->dma_ranges, get_dma_buf.nr_ranges,
> +				       sizeof(*dma_ranges));
> +	if (IS_ERR(dma_ranges))
> +		return PTR_ERR(dma_ranges);
> +
> +	ret = validate_dmabuf_input(vdev, &get_dma_buf, dma_ranges, &provider);
> +	if (ret)
> +		return ret;

goto err_free_ranges;

Thanks,
Alex


