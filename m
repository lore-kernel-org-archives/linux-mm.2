Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC942FCD0CE
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 08:03:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 290126B011B; Wed, 18 Mar 2026 04:03:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26C936B011C; Wed, 18 Mar 2026 04:03:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A46A6B011D; Wed, 18 Mar 2026 04:03:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 08CA66B011B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:03:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CB0F4C2258
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:03:07 +0000 (UTC)
X-FDA: 84558443214.20.3F0CC70
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf26.hostedemail.com (Postfix) with ESMTP id 00272140009
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:03:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=QgHOLe5E;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf26.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773820985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5GOrx/bM09mWS7d4FWSxDkysESa+9H3SzC9X1DevVpM=;
	b=W0TKIOZnrWtWs6GQkQDZY1fhfxLbnfrIb2beENxzeN0qDQntHJ6KhW3SwL1EMI60zemg/z
	U6PnQ5JvKQ7E0rzsogYxE1a9rhTCaUJrYzGJ9uDelMR75gXq13m9/p+EBkyLjgB+PNFdGa
	ZvneUv8NcVUUACbebf5TV16+VGfONaw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=QgHOLe5E;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf26.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773820985; a=rsa-sha256;
	cv=none;
	b=4Ez8Oro+NngTHr3fYa/zABiuSakImEex5iZSGMqavHVcqxtOZa1J7eR7raRHpOWcYrKCvc
	T5SFl8tyjrG0flZJs8g1OOV15FW4Vc62xoFUQkuRCCRqzOwFrkzYWXEEzQUkkie3DKQkDw
	Wp4cRAv/hgGJiXjj8FVpJ28T6XG9LW8=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260318080302euoutp01c12cdd03f6ad40b564091bc73a8e4a81~d4Mkk9r1-0393903939euoutp01t
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:03:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260318080302euoutp01c12cdd03f6ad40b564091bc73a8e4a81~d4Mkk9r1-0393903939euoutp01t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1773820982;
	bh=5GOrx/bM09mWS7d4FWSxDkysESa+9H3SzC9X1DevVpM=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=QgHOLe5EykCGGsrBolTj2JuPKhQ1Bki0f6knoOEenxKjutlnI1f1a+IvYzTNANjPB
	 g3MbC1nXSFcfIo0O8YAnngJsBgO+mlGjP/L4WRyaF1fcYTT5wusxKKB3bQtIBpaz+e
	 S5X3ZWGOfil6XUIO2rZg9WqmuiJ2qfPQBkCSac3g=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260318080302eucas1p2c05885afc838bdc98d55972adc31ab96~d4MkRZpJ60631706317eucas1p2v;
	Wed, 18 Mar 2026 08:03:02 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260318080300eusmtip289c1a6818cde8d982e474c8d0c9ee8f6~d4Mi2Bedq1876518765eusmtip2G;
	Wed, 18 Mar 2026 08:03:00 +0000 (GMT)
Message-ID: <de23ccf6-75ef-48af-8c69-2f416c564f2d@samsung.com>
Date: Wed, 18 Mar 2026 09:03:00 +0100
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
In-Reply-To: <20260317190538.GD61385@unreal>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260318080302eucas1p2c05885afc838bdc98d55972adc31ab96
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260317190552eucas1p28f3e818f88d252b1e4161332be084177
X-EPHeader: CA
X-CMS-RootMailID: 20260317190552eucas1p28f3e818f88d252b1e4161332be084177
References: <20260316-dma-debug-overlap-v3-0-1dde90a7f08b@nvidia.com>
	<CGME20260317190552eucas1p28f3e818f88d252b1e4161332be084177@eucas1p2.samsung.com>
	<20260317190538.GD61385@unreal>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 00272140009
X-Stat-Signature: a1tai48747fgxyxnui7e6utqptakc1q3
X-Rspam-User: 
X-HE-Tag: 1773820984-380326
X-HE-Meta: U2FsdGVkX19jt1hemarPuLeUpewbnLbTrQniLFyh1t5Z2tgYk2ZmmlyM0KVEEowUk4ljXrE8M17BGV4eUe+qeWqhzl6iZs2lsS5tIT3QpC0ICPmzrUMEVcyse97iYhSaXs0gtpbeghjYZbipACrJUMIQ67okXgBAcVOW/GrDkFB0o6RmNa/06D5q2hxEqhdn1pOPfhPbzfo4xkg679iIoq6FwphK4McjXX5Oou3YTs0YSpTa/1Zfx8I6Qb8XXcHkf+Ue5g9cx13IdFvlLxNaozWNCCCmSq/VI3rVcYIFy9cbICJGu6BRGw7DX15jSeg2EVSJy14TnI0hYMUf5LY6coSnVHOuWTTMPdB9kADkYnVlUNZ0de5ZZkRFH7BoB2bxmWNejCVpGOW58ngm1u4oJwCPgrpcmke1VazoErxhJeuOBX8MxWSkwcxpcXVYXYluTku3Sn9ofehZ4XxfvJd1GdObExZw3ZyuPUgdSI2UmqP1XOoFa9WYLiSadqt5H+DW1ldc5CEhEkc3SoWI1p4ZgpFFkk5aLdN+7LE1rOM0IrZpjB/ZaZLJRzlRViOd+Zu5NaWVWuo4N2Gc1gGICC2wCgtkV3Ya426ZgYtwVTps638Ii8GILwZD8eHmK/6B8vJuipZEMg7MgL2dwCFEJpTgcJCIeLI5W2ZkkdP4rsMBJ8fWbIqClwuu0AdKK6Dk4FKnAJlkKSgagsCTsd54S/3A4xsaDbQ0nFmmXXYTtTBA3os98IuUcF5VCy90xrifkcAfhgHUNhBQj0WG8XJBshTICZeZtpL07G2MdjL4n4uSy/gqtsNZjpWqgtIYkWiP36O8TKXCQSENTmdM2oGDOzj+pQLl7dKrYbfL/gGhFMJUJRQu8vonAY7Els+vRTFK9V/tALZ3yLz0+VWI4zb3QuRurXVm8UawK9/a+CfZlNtZrX1RGtVd3gL4ribHBhkoNxu/Lzbrscd7f/7mcGPIB7i
 ACC7UmVB
 YyEcB4SEQInxQy3Oaf/549pYC0QT6Smj52s/JeyPMeu2GKipT4o1BbfNJ0hdLc23nb7yaQubmHaWzrl/y727dvAOQ5ofTOb3tpZj3B/GHfYeHK3uGfEdE0IQJvBxaiT+42u9H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Leon,

On 17.03.2026 20:05, Leon Romanovsky wrote:
> On Mon, Mar 16, 2026 at 09:06:44PM +0200, Leon Romanovsky wrote:
>> Add a new DMA_ATTR_REQUIRE_COHERENT attribute to the DMA API to mark
>> mappings that must run on a DMA‑coherent system. Such buffers cannot
>> use the SWIOTLB path, may overlap with CPU caches, and do not depend on
>> explicit cache flushing.
>>
>> Mappings using this attribute are rejected on systems where cache
>> side‑effects could lead to data corruption, and therefore do not need
>> the cache‑overlap debugging logic. This series also includes fixes for
>> DMA_ATTR_CPU_CACHE_CLEAN handling.
>> Thanks.
> <...>
>
>> ---
>> Leon Romanovsky (8):
>>        dma-debug: Allow multiple invocations of overlapping entries
>>        dma-mapping: handle DMA_ATTR_CPU_CACHE_CLEAN in trace output
>>        dma-mapping: Clarify valid conditions for CPU cache line overlap
>>        dma-mapping: Introduce DMA require coherency attribute
>>        dma-direct: prevent SWIOTLB path when DMA_ATTR_REQUIRE_COHERENT is set
>>        iommu/dma: add support for DMA_ATTR_REQUIRE_COHERENT attribute
>>        RDMA/umem: Tell DMA mapping that UMEM requires coherency
>>        mm/hmm: Indicate that HMM requires DMA coherency
>>
>>   Documentation/core-api/dma-attributes.rst | 38 ++++++++++++++++++++++++-------
>>   drivers/infiniband/core/umem.c            |  5 ++--
>>   drivers/iommu/dma-iommu.c                 | 21 +++++++++++++----
>>   drivers/virtio/virtio_ring.c              | 10 ++++----
>>   include/linux/dma-mapping.h               | 15 ++++++++----
>>   include/trace/events/dma.h                |  4 +++-
>>   kernel/dma/debug.c                        |  9 ++++----
>>   kernel/dma/direct.h                       |  7 +++---
>>   kernel/dma/mapping.c                      |  6 +++++
>>   mm/hmm.c                                  |  4 ++--
>>   10 files changed, 86 insertions(+), 33 deletions(-)
> Marek,
>
> Despite the "RDMA ..." tag in the subject, the diffstat clearly shows that
> you are the appropriate person to take this patch.

I plan to take the first 2 patches to the dma-mapping-fixes branch 
(v7.0-rc) and the next to dma-mapping-for-next. Should I also take the 
RDMA and HMM patches, or do You want a stable branch for merging them 
via respective subsystem trees?

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


