Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 619AFFEDA0F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 19:05:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 943E66B0096; Tue, 17 Mar 2026 15:05:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F4CD6B0098; Tue, 17 Mar 2026 15:05:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80A706B0099; Tue, 17 Mar 2026 15:05:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F7B36B0096
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:05:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 36ACE13A42E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:05:46 +0000 (UTC)
X-FDA: 84556484292.11.F2C94E5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8D8D5C0002
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:05:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VRWgTDqb;
	spf=pass (imf28.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773774344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=inV/tXyTEKWdCfYJg7Qync+7HkKGnW+PK4sn/riZ7uo=;
	b=vFTc5vIAFY6hZkkXKUJ6kRTfwp580/lqlb3Y696BnWb9VHkDKMrGqDYH88pvw3TgIRPJjj
	NkvSDhBa0WYFvaUMH18H1Z0kXErmkfeOgHkPPI6OF6TibkPnIx1x9dHCS3PzEswQVlrQNa
	2MCqdH6UOFkoy2G3/YQklIjsvxqKPic=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773774344; a=rsa-sha256;
	cv=none;
	b=u7pKtkmAu1qNi4Sdnb7TXlOIo5lYwHUyKAgTtI0e6+tjmjBZPDt0s1Dd8Adbwj53c3okqK
	61syR31Q25umqV9HDuiAT1ZqcEHR3Z6vHnichh/1C4xvAJCiXNJI0q+MXRWjs3F1TQjKuc
	liPMFT0yZuIvAlkPi1MIGEoIWsP306A=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VRWgTDqb;
	spf=pass (imf28.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CDAB860018;
	Tue, 17 Mar 2026 19:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F64C4CEF7;
	Tue, 17 Mar 2026 19:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773774343;
	bh=syW3z0x80IUsDkJqDO1sfU4YY8HBrpHtA77ObK08ZFo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VRWgTDqbWe3Q1W3JoxRORGEv9cJSyULlIC1z8Bw/dttRqK0xrUjV3jcLj+FCNIlhA
	 yfquFZi5RuoGYh094bwpTEqzMSy1oi20VB/mwVmDasAQXUEDUj69QwmFrLNkzzaaEW
	 TxL4IoR2tfqmdocyZECPzry0Flux1xfTuoo78wga02G7HX9CfQP86SEbWHmeki3bnG
	 fQQPAweWzmsOQWPyYRrr1vn+O2GeAM0lXjxVoRUKicNl0fMpfX0u90da1igsahAgWD
	 lVpeDEoTnLCevj3RHVAGT/mI6ZPAnZpFvQykUFfbUgqTYwv27pZul8kECdVX2mxKrW
	 MJpheC1EsGxUQ==
Date: Tue, 17 Mar 2026 21:05:38 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Petr Tesarik <ptesarik@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, virtualization@lists.linux.dev,
	linux-rdma@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 0/8] RDMA: Enable operation with DMA debug enabled
Message-ID: <20260317190538.GD61385@unreal>
References: <20260316-dma-debug-overlap-v3-0-1dde90a7f08b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260316-dma-debug-overlap-v3-0-1dde90a7f08b@nvidia.com>
X-Rspam-User: 
X-Stat-Signature: rwazteq1cw3ea8hyndywm53f9bdmjzyh
X-Rspamd-Queue-Id: 8D8D5C0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1773774344-598688
X-HE-Meta: U2FsdGVkX18ZOnnN0CotlR50PQ3WkvpTb6jlPRJhaVMi7lGMGG8SG9KjX/DXV2ys98CVOydF33y2tp+55ib7HvDFDET91EeWGcSNk8y7q2JJ/tYn6+kGLufPKDMIBRdQTv8ZMIaKhC2oIGgFhw0FvSILuLBrhTTGEAQ3mcELmfuYQgxw7JhscpuWkoxyvQZ2y/2uTHGZaN40eCzBW/g5U6c/6MnUA/lv60mNcGISOKVWeT58olw39OmfcQXLpdZzj5GWZf1IJJmxR2dvH+2WKhDNydlVKXTV/IzsyKG3wWa9q6n6MQ29E6iab+Ejl5FosgvSie0oQ0GexPCV5jPAYikhvOw/vQWT+EHHQ79g+FiApPIAITcrPDBLz5Wla4zk3Q1vGLEO3He/tpzc6rVHvyELRYI7a7Ft3Ar5/3l2akBzmJ61kVqWPsQfQmUCROJSz/qU2kAAHCbzm8X6W1klA/9QryLqYMxS2r3bb8f8kCz5IT+0t5I4/NCJvRVK+DH3yVlWQ0hbWD5XGAb26x/WO2aC4u/CkKHThpEGOjitdvw/kVnG6rowfbIRc5WY9/H3wzRWIJpjiONV1aqAFe1tzit3KH/Ugthp7Qn64YZxSSd5oDy6M94ZJodijqLVg1LcX2F3BAAu2GP8mJdiTym/5Z6+GsyGry9gU2Cng3WOB6SnetTUDZcD26OJWfyRJTqBWluXpJZRydx6WlcefahQxSO2knqsH0GAnkuRgMgP8LJ/rr72AHH8D5g7Pya0nauGx9xjY8kkqS1d9QRP3O7H+kuPi4WEPwNj/Di6JQm+5T7XpmosSy+U5YXasDlo2haCgFwlFGUUGXBQn2wxqLsiMXZfYQtYiMM8AoPt3rqlvp1bgl2fdZUJiadehHBX/ux5I79pMo/ZxjHc/ZVBjrIIzv/ektJkfPi30QOpqoqPYbO9V+Q7CjA9iPqy6eC6EzJrs7LGwLR2YXU6FudswOC
 focS6YT2
 upZnGZVpgjTjuYoJC8gbCuzaZWjkT3zmnQZbdsuAAUzeG3yXCZ6GtFCbeaIG2xAKaP6WZRjOV6Kei/4s+SzglHjs4v8DfoWnTmJLn7qCAitTqF1+f6ANwT4YEx5DNu+s7o6+nyyeRdfjTIrRzNpAzhPUatZnd0/1z4cHCKqE3KpMm8MyyjA/mdZtoDZqY32eTbz+44op6cQdCc60S+h/UeFFO7D/JmmzTHdPjtzs1LEsvw9SS5Czy/j+ucTJw+mxSSs7PSn4hGuC3f3Rf8DL/Dup69jTJ1Nxe01g67Q49bqBWwEE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 09:06:44PM +0200, Leon Romanovsky wrote:
> Add a new DMA_ATTR_REQUIRE_COHERENT attribute to the DMA API to mark
> mappings that must run on a DMA‑coherent system. Such buffers cannot
> use the SWIOTLB path, may overlap with CPU caches, and do not depend on
> explicit cache flushing.
> 
> Mappings using this attribute are rejected on systems where cache
> side‑effects could lead to data corruption, and therefore do not need
> the cache‑overlap debugging logic. This series also includes fixes for
> DMA_ATTR_CPU_CACHE_CLEAN handling.
> Thanks.

<...>

> ---
> Leon Romanovsky (8):
>       dma-debug: Allow multiple invocations of overlapping entries
>       dma-mapping: handle DMA_ATTR_CPU_CACHE_CLEAN in trace output
>       dma-mapping: Clarify valid conditions for CPU cache line overlap
>       dma-mapping: Introduce DMA require coherency attribute
>       dma-direct: prevent SWIOTLB path when DMA_ATTR_REQUIRE_COHERENT is set
>       iommu/dma: add support for DMA_ATTR_REQUIRE_COHERENT attribute
>       RDMA/umem: Tell DMA mapping that UMEM requires coherency
>       mm/hmm: Indicate that HMM requires DMA coherency
> 
>  Documentation/core-api/dma-attributes.rst | 38 ++++++++++++++++++++++++-------
>  drivers/infiniband/core/umem.c            |  5 ++--
>  drivers/iommu/dma-iommu.c                 | 21 +++++++++++++----
>  drivers/virtio/virtio_ring.c              | 10 ++++----
>  include/linux/dma-mapping.h               | 15 ++++++++----
>  include/trace/events/dma.h                |  4 +++-
>  kernel/dma/debug.c                        |  9 ++++----
>  kernel/dma/direct.h                       |  7 +++---
>  kernel/dma/mapping.c                      |  6 +++++
>  mm/hmm.c                                  |  4 ++--
>  10 files changed, 86 insertions(+), 33 deletions(-)

Marek,

Despite the "RDMA ..." tag in the subject, the diffstat clearly shows that
you are the appropriate person to take this patch.

Thanks.


> ---
> base-commit: 11439c4635edd669ae435eec308f4ab8a0804808
> change-id: 20260305-dma-debug-overlap-21487c3fa02c
> 
> Best regards,
> --  
> Leon Romanovsky <leonro@nvidia.com>
> 

