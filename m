Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8154CF394B
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 16:33:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55CDB6B0006; Wed, 19 Nov 2025 11:33:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50E0C6B0028; Wed, 19 Nov 2025 11:33:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FC836B00C1; Wed, 19 Nov 2025 11:33:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2EA716B0006
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:33:35 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D28FEC054A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:33:34 +0000 (UTC)
X-FDA: 84127902348.23.BF84B31
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1F3BA1C0005
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:33:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mafG8ZOF;
	spf=pass (imf18.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763570013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j6Y2dWwaeg6adQqBZ+ha60KY6v1Plo4xEx/hIjEVHpE=;
	b=prfMN0MxKFfcTGuGVMeYVfhfupTkhT/v3zqyDN8ClCnUaD8DTleYP65F+/DoW7W+y1UpmH
	4eRhe9IYDIzXom2YaF98PFJrSP8gAnUpjbId9HuB3XD2PgwFCxEv3V8q1inajEWjKOMJDe
	gNHrFTRTSKG8YBxPEK3uGh+r1/obti0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763570013; a=rsa-sha256;
	cv=none;
	b=n9Rf7AAoQPQRNl+tR5KMFxbJZvSFvBkTsMnXTCLmXYURBRRbixDei5f9oU7j7um+FT3KMm
	JvOmdfTPYwdeM82v7NWO/0mGuR7oVDxRwpkkgTvVvkQYv2ns1FZqxr27CsF21cMVjUreNF
	YKpNcSz8OQ4W+kNI6Z5XJgMPnkTogN4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mafG8ZOF;
	spf=pass (imf18.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 14CFF43BF9;
	Wed, 19 Nov 2025 16:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D05C116B1;
	Wed, 19 Nov 2025 16:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763570012;
	bh=SQB43V1lcm01gCfrVBWXeZWkfWYzDLNLnZu9KWeWJcg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mafG8ZOF8WzHpM0Ap0HV10HNQ+V26iii16RmNEh8xlVGt/3Fyif1MM/ooh0K/pfIz
	 szK/RWtsKgEJUAwJCF4Ei2amklh14ZMnM9irxppUQrCUJkvt/EZVFJcbPn28NcqEGY
	 H5mQcoOTZFTUtioKEvXhb//Hd+eC/e25r6Py2bHgQa/vmQ3b9ezpxZIBWcXV9ncmwt
	 7e2asxChIzWsMtQIBzyz1HCL0UngdmumU3R+J6sfLJMWs0oS7ZF4iSIBsph8VRgCK0
	 +t4iS375piSkus/kTsSOX82JCK0IrwbeeJvL9xKC8TF2BvGIttU+8sQ9kfioC2gTlg
	 KCxDuQf1gZvsw==
Date: Wed, 19 Nov 2025 18:33:26 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org, Alex Mastro <amastro@fb.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [Linaro-mm-sig] [PATCH v8 06/11] dma-buf: provide phys_vec to
 scatter-gather mapping routine
Message-ID: <20251119163326.GL18335@unreal>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <8a11b605-6ac7-48ac-8f27-22df7072e4ad@amd.com>
 <20251119134245.GD18335@unreal>
 <6714dc49-6b5c-4d58-9a43-95bb95873a97@amd.com>
 <20251119145007.GJ18335@unreal>
 <26d7ecab-33ed-4aab-82d5-954b0d1d1718@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <26d7ecab-33ed-4aab-82d5-954b0d1d1718@amd.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F3BA1C0005
X-Stat-Signature: grqqcc8k3c8jtk83ozdf5oidzdn3n3mq
X-HE-Tag: 1763570012-500816
X-HE-Meta: U2FsdGVkX19MKxXtBFDjtvyLFOee4ty/Jo0FsfOhL5plYqO25D+zKxrJ9ZrT1rYL6DkxxdT9JW65S1gtXUL+XEvJjFdv5aibQdNiwNAGUmorgVm1L/YF5EBmuWhaibZ7AdMzaUBDackWMnCqw1FFjewdogptSloKptYRGlCklq7F9DJzc9OJ7mrFN4JpSV6CNqU3QPot8IKOe5HnNFiFOXbMTaBwDdLwELqNDDcQMTNqFTdpgNUb4AmlTV5T/Us9rMeHOVw8vqFEcl7ACJDgciDF2Ea6dVelPRMePc7RPP2sh0Dy/HpOvt2BH93z0Soha09ZrCkhpF31Dwm1Fid9ARblRODddI6V9GBaBeTR2zO0HSPXc2K1bb2QMHVFIw41NPsAL7DTVde/ykta9NIxQ+/FSGf+l26SfV6nRBlIxMXnLDeu6sthISbO7ceh8T1+bH8P2PMr2joxxcXAe4CdedeAI6D9rSQuvUCfTI1vpFZXqjgUwxyf710QgbSGWFfi88EdT7OFtZK284VzxaBrTtP6I/DAoyq5iGMVSpz0rhvkGerrM1aYC/pWzUA0MahX/1XAHuYF8SGzXMfL7uuEG1sOhojQhU7YGEpiEpex/u6Hn8AXapiJoQA043weKvVGUdiHNGD0GEmO9aI1Kzi35Eoq8OxdAjItPVDY1eo9xsdE3PFe9ggCcH25ekvNX0lrnDSeDy5NfRS/GqDPVuKlcp3SYrDlK8qrxg4vs/uBENuXTMMBE7erTk92mpkAwqc15ONiuLESXz9SkmV+OlkSvxtV1ezWl00rDqd3VXqw4kptnZul0px4KZHBjhO6i4PW4z46sMlhqg943gSnl+Js0edc1dhE6YHgQoUxdCNdcnqWYqYD0ZnF49CO1X7nvrD9j7vQEBLXIg4AGzu1YCC8SywNi09HBPlxohYzBZovK2bo81644o1VCZzMKVMjcgQvE77sdIQWiah5/ZgaP/D
 fQ8q3H3J
 5Yt96nJSBlwGAxHKiqGS80ljaGPLBA62crTiCyD4z6WdTjFgQlZgye5qrRnUrQK3UqdCC0Ct54aTEwA2sXsb1cX4yGnLz+tF3NTWgkxlBlRPC59CQGHNxiaPZssPc1XELMLc0Rw9A0kW0DRlnWIYUSwH7Br1grlF4GtT/guaDCCex5Fi4axM4vSsSitIylctu80aRZhoA/FMKzRDAlU/psqcrRtSIfv76L9/DWspqNM83uYlrej22Pg2DWcOWxGb20loaM0UlA1gf9K943veknbcxT0b2mDrC63qxFTapbXNPGw2v5qq4MzIarRNXp8BBesQl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 03:53:30PM +0100, Christian König wrote:

<...>

> >>>>> +struct sg_table *dma_buf_map(struct dma_buf_attachment *attach,
> >>>>
> >>>> That is clearly not a good name for this function. We already have overloaded the term *mapping* with something completely different.
> >>>
> >>> This function performs DMA mapping, so what name do you suggest instead of dma_buf_map()?
> >>
> >> Something like dma_buf_phys_vec_to_sg_table(). I'm not good at naming either.
> > 
> > Can I call it simply dma_buf_mapping() as I plan to put that function in dma_buf_mapping.c
> > file per-your request.
> 
> No, just completely drop the term "mapping" here. This is about phys_vector to sg_table conversion and nothing else.

In order to progress, I renamed these functions to be
dma_buf_phys_vec_to_sgt() and dma_buf_free_sgt(), and put everything in dma_buf_mapping.c file.

Thanks

