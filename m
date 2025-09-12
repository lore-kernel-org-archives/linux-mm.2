Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03CB8CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 20:06:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C7358E0003; Fri, 12 Sep 2025 16:06:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29ED38E0002; Fri, 12 Sep 2025 16:06:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DB8C8E0003; Fri, 12 Sep 2025 16:06:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 106C18E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 16:06:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AE45C1A088A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 20:06:53 +0000 (UTC)
X-FDA: 83881681506.03.A69E444
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf25.hostedemail.com (Postfix) with ESMTP id A6B25A0011
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 20:06:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=fb.com header.s=s2048-2025-q2 header.b=hoEvy0Wr;
	spf=pass (imf25.hostedemail.com: domain of "prvs=535097c470=amastro@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=535097c470=amastro@meta.com";
	dmarc=pass (policy=reject) header.from=fb.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757707611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XDrxit+4/wDzPk/43t+MgtkBccOuXiTPH9TtU4SBEDs=;
	b=EYyra0IpJOvj+LXsRN/pa1Ohbo63ho+oj7g5MCMRigUE9umN/PsYFtGV/ySPgCmdLmPjfu
	EtGSDoEjIo2207OoCoI7f7QtpWik0bZkhga47ZvCbUFfceMxF9IGSYYoTYunDD7Q2K9crD
	gE28B28ctYzfC4R+NbPjQ/WMHwWUvxQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=fb.com header.s=s2048-2025-q2 header.b=hoEvy0Wr;
	spf=pass (imf25.hostedemail.com: domain of "prvs=535097c470=amastro@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=535097c470=amastro@meta.com";
	dmarc=pass (policy=reject) header.from=fb.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757707611; a=rsa-sha256;
	cv=none;
	b=06I1/JnXyYsS4awJ2Rp4woF+AMhvGBKHXX7WRiL7NOV+PXMHUgMZ3VExzvMcK417HRhJuf
	d/5zrZbC2JyNtY30rV5gmeaLE50cXxqkEzXrxm0o51yuENRC089uU0KWji0gdmUrFXNaXk
	huXk2HNwK3HUDYLsIcv3hqZq9Bt2B/8=
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 58CJ7v1l2663110
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:06:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=XDrxit+4/wDzPk/43t+M
	gtkBccOuXiTPH9TtU4SBEDs=; b=hoEvy0Wr6Zma2xPs7AUSnoWBbsogAwmkUU4l
	9YUFY1ov5IqQAKGk1y/yrxb4k/EKe9rLtpDJtTA0Q/STSSkAZR9a9bEyT1K0XUoo
	3RZuxAi0GUunhBRKlj1yMSscuuUiM8QZWfYQzqdl4Wara0I251WNa5oEeVgALGqV
	2O6oBKyGNKKwn9uQzSO14jA3S/ADSOcX/1VunVrgeeVIsn4qJ8tX6Rs5mBk3g8PQ
	MeiDyRIeFPHoEuC9dNDKabtQq+dY1RMdGfhugq9dXEWyVihp+Aa6nrUTZw8lNqz8
	KYjiizQMxvqyeNV4sHhhWU5Lv59scMG8iHO1JMnrnR1VVtw5aA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 494ppvsu43-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:06:50 -0700 (PDT)
Received: from twshared28243.32.prn2.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Fri, 12 Sep 2025 20:06:36 +0000
Received: by devgpu015.cco6.facebook.com (Postfix, from userid 199522)
	id 7B405DDAB9B; Fri, 12 Sep 2025 11:55:29 -0700 (PDT)
Date: Fri, 12 Sep 2025 11:55:29 -0700
From: Alex Mastro <amastro@fb.com>
To: Leon Romanovsky <leon@kernel.org>
CC: Alex Williamson <alex.williamson@redhat.com>,
        Leon Romanovsky
	<leonro@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
        Andrew Morton
	<akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christian
 =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Christoph Hellwig
	<hch@lst.de>, <dri-devel@lists.freedesktop.org>,
        <iommu@lists.linux.dev>, Jens Axboe <axboe@kernel.dk>,
        Joerg Roedel <joro@8bytes.org>, <kvm@vger.kernel.org>,
        <linaro-mm-sig@lists.linaro.org>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-pci@vger.kernel.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Marek
 Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Vivek Kasireddy
	<vivek.kasireddy@intel.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v1 10/10] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <aMRsoUx/NH/Dspm9@devgpu015.cco6.facebook.com>
References: <cover.1754311439.git.leon@kernel.org>
 <5e043d8b95627441db6156e7f15e6e1658e9d537.1754311439.git.leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5e043d8b95627441db6156e7f15e6e1658e9d537.1754311439.git.leon@kernel.org>
X-FB-Internal: Safe
X-Proofpoint-ORIG-GUID: GAaXQjBvE3G87BJHWZAj1VM4UyYO5OoL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEyMDE4NCBTYWx0ZWRfX+FAPD3oIbNYM
 fInFKTafIVOLLf28uSROS91+mXpSKuY0OdCEj01c/0BDSwQLgwq2Vu3eCj9jj5SZXTVcA/VfhwO
 NC6ex5T/TRe8IViHns4Lkd9TXKzpsHlHx6GdXYhLx6jIW4Wug59uXB4LHufKpqASp4VrLqn7CRy
 d546fIKForNDgA+hZnpYjhwkXAA+sLNbWL0kB/Ft7Al79xKAQOr68xxookGUxsbm5l3h3WrBXs5
 ORveSHvEbEjkgtENUOArqcOLAPKTBSkeUK0UJn/C1Zed+wCzKMoLajUjorYLHJxOWPyaMH/9coz
 6/TLhwLppI0Ii/6Lmzwp5lqZacMFAfD8xTK4lNbchEXfx81fLaLtcoPxTHNIX4=
X-Authority-Analysis: v=2.4 cv=TdKWtQQh c=1 sm=1 tr=0 ts=68c47d5a cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=1ZiGsszX2omsYK9W0xoA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: GAaXQjBvE3G87BJHWZAj1VM4UyYO5OoL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_07,2025-09-12_01,2025-03-28_01
X-Rspamd-Queue-Id: A6B25A0011
X-Stat-Signature: pc16d8boogjyk8j4r5yj9x5em4q8zixt
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757707611-528775
X-HE-Meta: U2FsdGVkX1+6KRcXqKIyeMANQgFxHYWw8KCBAAjhLdcXwA+Qk+e02WhvJlmQVBJ/KQPBF9P3ydF7daJGa8lOV9iMUi0Gw/w2ezf4ARkWw7txq5KDQUACTBwbLxw4tXA+PJZ/Bwz//qP7eyFRtcHlGkAZsNz3AzwW5FY1Re6dMt9M+nDjL+tDMzKuaOFzgtTHHP0XGWG+PtTgcr7yMXGous5b59FJVo3lPKNZpNqgrlddI2o9h94XwOC0YinCdgBvaKpEw37+9FnHqSO3QmTR7qOUoCDHIum7Qz5QQ0HGQIej4IMcQgJdV0B7fB6KXWPuHD2TQdRYLDDvF4ao7BoHUM92ctvEQN1YhE4VCGqNQcKb+i1t1jccHqT2T/J2laqWutdui5i+KP7OQLg05y2PRCDInYMS9Iv03zfn/wKDj2j1HuM5Aozp0ZbhbwcubHHZHdV+UgFZwqNrv/5OzYyeYpH3I2hPq6ItRKWpQBncvVCZZFDahxuaPMJ1EkCFszaXiQeQyo7ev5KvOfCpAD0xRq/lMnmtlMBQ+kXJ7TLHTPXYZ1vFqImsDrIfkeAS5J6fIkijIuxUArnM2zZSGbczwt38ve35B9wjXmhCMh1HFClAa6v3bo7sXqrnCJ3KdsOuUTk2OP/ahN8LPShU7lktfy5wuAf990bosTxTuLrLTgxv+4a7/haw7iwu3CC0y7M+wumsnVeUKTWhJGhwmTB04vZ/ONbsledT8ZxxSQdOLJIgjaVGscIPzzTxsgVj220h///oegrFSN1qsN5ECCmPnqTiaDjBhCaSlmg8YPxPyhGDl5J/LDFJduuHqalZONccjJ0lDtkIGDCCjaPdWHzKYctcmTWxYIQ0K877VrjgTC8pYC7fv0fhom+DqCRA58Yg6kFmHn5SnPqVslRiXuzXS3GLutE83zVtPAvQvzJ1/wuW0GGKgj9tIDltlizweE7cya6H+io5LobPrC5SFB8
 hUqPZWhB
 w1aEJJvb9WKcNtywERZRNBGDL7vMiDluA57WSc4WuiZsHe61C4Uu8n8dZPyemVpVgpO+hle1/7K2zrcEaPzmgp+7+L6UGqokq9BNxNx+z7qruQX59OXIIdivxWaMq+WFalT/C+rNs0dxrdiMGKjtUTXVaj35Iv/XLjjOAvQyEcRfufcr4C1Qp/ejKHIbgB1ge/SMLgNHsPcvTms9mA2QjfGrZbSR99BsyDXyMhCpW5iaPgZ/OJ4l8pvCn2X8B6rL4TKnkFW1x0KJB3Zz7t2lUAI/ONnMl1InbiX3w3chtA9CrqUnefUd0GzmNgQxGnIflE811a3cyoUC91wXo5L12khus/iqpqz9CC4BJzTyfAKyC/uChm7lPOQek4TXouSSFGVWJ0L2TktXhTciskVFOv3zaZKQ2gXE7rETYAEZVYYEtZFM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 04:00:45PM +0300, Leon Romanovsky wrote:
> +static void dma_ranges_to_p2p_phys(struct vfio_pci_dma_buf *priv,
> +				   struct vfio_device_feature_dma_buf *dma_buf,
> +				   struct vfio_region_dma_range *dma_ranges)
> +{
> +	struct pci_dev *pdev = priv->vdev->pdev;
> +	phys_addr_t pci_start;
> +	int i;
> +
> +	pci_start = pci_resource_start(pdev, dma_buf->region_index);
> +	for (i = 0; i < dma_buf->nr_ranges; i++) {
> +		priv->phys_vec[i].len = dma_ranges[i].length;
> +		priv->phys_vec[i].paddr += pci_start + dma_ranges[i].offset;

Is the intent really to += paddr? I would have expected a plain assignment.

> +		priv->size += priv->phys_vec[i].len;
> +	}
> +	priv->nr_ranges = dma_buf->nr_ranges;
> +}

...

> +	priv->phys_vec = kcalloc(get_dma_buf.nr_ranges, sizeof(*priv->phys_vec),
> +				 GFP_KERNEL);
> +	if (!priv->phys_vec) {
> +		ret = -ENOMEM;
> +		goto err_free_priv;
> +	}
> +
> +	priv->vdev = vdev;
> +	dma_ranges_to_p2p_phys(priv, &get_dma_buf, dma_ranges);


