Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12174108B8F7
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 11:10:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DDB36B008A; Fri, 20 Mar 2026 07:10:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B5136B008C; Fri, 20 Mar 2026 07:10:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CAEB6B0092; Fri, 20 Mar 2026 07:10:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5CD136B008A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:10:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 318741B6CC9
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:10:00 +0000 (UTC)
X-FDA: 84566171760.16.565164F
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf13.hostedemail.com (Postfix) with ESMTP id EB1FE20004
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:09:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=ptyVoPWX;
	spf=pass (imf13.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774004998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pTmqpdf8GjnyZsUw8L2XfkacmPpa02J4Xau6gTuFHFk=;
	b=pvP9VSoS9Vn7cV7s4Tqi0uVF9BnzkrS6ofDkVqRmpc95skWylnOCro6cMHzTBYR4tvZzFR
	FU9zNMGArmrlE3XI1ioESEdFUCsyS2E9nhoGGRJ7Wk+yDpt4sh7/s8EbqJBbWawRSpOzn6
	v9SZof2J3XZFFPKMgav5AQbGkGqPqqw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=ptyVoPWX;
	spf=pass (imf13.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774004998; a=rsa-sha256;
	cv=none;
	b=706Q6/V2MzcrR4A5N+fWqIHv8+yaEYQPvmd+FoIF9Hk73+VHuVGVhHf13wVGbxkVVCAGFQ
	F4xrKqmWNB/lpm7exmXp+nIBvmuY6v2GF454keZm3ADVFCzSX/ouZWbPt1rs/yVDV4zZBd
	5J2QHhq7xDPPlWH2mQLUOKgzje6dYcQ=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260320110956euoutp0126bfd2afbb585e51d51908418ccf0d4f~eiCUS5pty0560705607euoutp01O
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:09:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260320110956euoutp0126bfd2afbb585e51d51908418ccf0d4f~eiCUS5pty0560705607euoutp01O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1774004996;
	bh=pTmqpdf8GjnyZsUw8L2XfkacmPpa02J4Xau6gTuFHFk=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=ptyVoPWXcBIi6CFajqz8jBHUc7QxmVLROBIa6B07X05T2gMHSAF3qJV+Mxu2faMdW
	 uAMswRdsBVr/P6CT4N9vFmq0zmpofYL/qZzw6yGNXtUr+3CNEGQBePtGtm+H/geV65
	 29SmHCE/UzvDdepCwlLyhLC/iO2gx/kPUCouI5Ys=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260320110955eucas1p27a53a87afc17b63b07866d088aeac78a~eiCUCPSBF0485504855eucas1p2p;
	Fri, 20 Mar 2026 11:09:55 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260320110953eusmtip1e57b08b4312207c095ed6eee93225c85~eiCR0ORyQ2928429284eusmtip1k;
	Fri, 20 Mar 2026 11:09:53 +0000 (GMT)
Message-ID: <b9bdd287-6bd7-4223-be06-7531845c5a19@samsung.com>
Date: Fri, 20 Mar 2026 12:09:52 +0100
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v3 0/8] RDMA: Enable operation with DMA debug enabled
To: Leon Romanovsky <leon@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>, Petr Tesarik <ptesarik@suse.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, Jason Gunthorpe
	<jgg@ziepe.ca>, Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
	<mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>
Cc: iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, virtualization@lists.linux.dev,
	linux-rdma@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20260316-dma-debug-overlap-v3-0-1dde90a7f08b@nvidia.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260320110955eucas1p27a53a87afc17b63b07866d088aeac78a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260316190712eucas1p27573f4514f2cf7dca5d58414b3c2b7e8
X-EPHeader: CA
X-CMS-RootMailID: 20260316190712eucas1p27573f4514f2cf7dca5d58414b3c2b7e8
References: <CGME20260316190712eucas1p27573f4514f2cf7dca5d58414b3c2b7e8@eucas1p2.samsung.com>
	<20260316-dma-debug-overlap-v3-0-1dde90a7f08b@nvidia.com>
X-Rspamd-Queue-Id: EB1FE20004
X-Stat-Signature: o9hthpzgfm9y16p7i3ak4i5iboxadfau
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774004997-431502
X-HE-Meta: U2FsdGVkX1++gW9VVnoIeNu0PA/sUo9tEUOABmv9axcLpV+7ittZ5FDKJMV6bp56xmB/MThJpa6C7nZB/jcCzm9rnOvEM6Vasw4eJiCP8KR+4T45jpbudNksaU5T0UqJvgwI9/zCdB1GvhxnwmDTfgYsP6UPz9co15noUmV37zE9gpTm8g7bCoNP3gHuqihv/GcxhLM8gyJzR6L4lJslsV00HSlQ5XBAt7wThg8ellcjIwHOkIoQ5jFaUIKagt1LhxXQzjjikn+Z6FdPDpWwxUuW1OPhqH9C11RLxeE7uPatzaEqY4NWKbyEg0DLJ3EgbOAUgYQ0rBb7Xpn3aGbEOVHofB2QclsnwGPQ5PnGOdqZLRT5cNcCQsAF13ffEuNmWYGR62j9ulFsWpZspj76IyXKFj2GANsZFqzi/KSoc8byjvz6fReMeNXXcxMFLu+15r0FtWaZ0JXss/oFHUHawsyw70rqKQ9X9ChqK+/Bi0ljizAcS/n9o3zhkXEKrra2Mqm0AhBdP6nZDiP58DEpRoQ2Hdu1VYgOkHCOUc4m2JLKWEVFpV67QrIAbblpMocHKlhbfYSZO5JrF60zkpQ+SpYhZPmPtKZZDmoEy5tRICVdjCfXixg0ZQ6TFztl7z8E1NeOLfAoqsUsAU2DeJ/92hyQ5quMF8KEeja+dVF1bFRPwnatT38alwyw6T7suCpj6zVbHsyLQS4RbGeJqZrFPO8KsijQvaeFjriYD74U9CkAX3lZTFo3z+AsNbOtmZV2Zts6aVjHuhiWYe8hlzgZUGkfvBOcQmpM+ec2YBYtA/1hF7ije6DUa1+kV4iW/j6lN5NWKiAMFZyS58WSkU/zQAZWNq8tsdV7hQyCY0qYFHIhd4TTFGsUwVsufINqKH13NPYNCgyHL4Z1goNY5NvLTi19t5VZT1dej8LnsTYAwjL4ATOwePILfq7/kLiS9YFV0RLXAYS/xgSduYhAKHe
 1LJ9BEok
 zeaHcGmgkA6XrsP4Zw3ZJsDvRJqlgw1ls9VIpjRZ7NFG2s/P/wBu9yDjuG5C87ps3bf8KV44NcfA3IlOZAyf/Mhr5UpaaziGXgzS8un0IW89iOH1uV1UJFx2VEXrtnfApYw/C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.03.2026 20:06, Leon Romanovsky wrote:
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
>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Applied to dma-mapping-fixes. Thanks!

> ---
> Changes in v3:
> - Enriched commit messages and documentation
> - Added ROB tags
> - Link to v2: https://protect2.fireeye.com/v1/url?k=9c1ba148-fd90b40f-9c1a2a07-000babff99aa-86ebd022a97425b3&q=1&e=3c8e10cc-4c34-4bf6-aa9d-c339877d6a27&u=https%3A%2F%2Fpatch.msgid.link%2F20260311-dma-debug-overlap-v2-0-e00bc2ca346d%40nvidia.com
>
> Changes in v2:
> - Added DMA_ATTR_REQUIRE_COHERENT attribute
> - Added HMM patch which needs this attribute as well
> - Renamed DMA_ATTR_CPU_CACHE_CLEAN to be DMA_ATTR_DEBUGGING_IGNORE_CACHELINES
> - Link to v1: https://protect2.fireeye.com/v1/url?k=cc0590de-ad8e8599-cc041b91-000babff99aa-07e4da206b7e0d97&q=1&e=3c8e10cc-4c34-4bf6-aa9d-c339877d6a27&u=https%3A%2F%2Fpatch.msgid.link%2F20260307-dma-debug-overlap-v1-0-c034c38872af%40nvidia.com
>
> ---
> Leon Romanovsky (8):
>        dma-debug: Allow multiple invocations of overlapping entries
>        dma-mapping: handle DMA_ATTR_CPU_CACHE_CLEAN in trace output
>        dma-mapping: Clarify valid conditions for CPU cache line overlap
>        dma-mapping: Introduce DMA require coherency attribute
>        dma-direct: prevent SWIOTLB path when DMA_ATTR_REQUIRE_COHERENT is set
>        iommu/dma: add support for DMA_ATTR_REQUIRE_COHERENT attribute
>        RDMA/umem: Tell DMA mapping that UMEM requires coherency
>        mm/hmm: Indicate that HMM requires DMA coherency
>
>   Documentation/core-api/dma-attributes.rst | 38 ++++++++++++++++++++++++-------
>   drivers/infiniband/core/umem.c            |  5 ++--
>   drivers/iommu/dma-iommu.c                 | 21 +++++++++++++----
>   drivers/virtio/virtio_ring.c              | 10 ++++----
>   include/linux/dma-mapping.h               | 15 ++++++++----
>   include/trace/events/dma.h                |  4 +++-
>   kernel/dma/debug.c                        |  9 ++++----
>   kernel/dma/direct.h                       |  7 +++---
>   kernel/dma/mapping.c                      |  6 +++++
>   mm/hmm.c                                  |  4 ++--
>   10 files changed, 86 insertions(+), 33 deletions(-)
> ---
> base-commit: 11439c4635edd669ae435eec308f4ab8a0804808
> change-id: 20260305-dma-debug-overlap-21487c3fa02c
>
> Best regards,
> --
> Leon Romanovsky <leonro@nvidia.com>
>
>
Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


