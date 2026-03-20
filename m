Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D80A108B8F7
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 11:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1733F6B0088; Fri, 20 Mar 2026 07:08:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14C116B0089; Fri, 20 Mar 2026 07:08:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 039E26B008A; Fri, 20 Mar 2026 07:08:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E836F6B0088
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:08:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 90A2114019C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:08:42 +0000 (UTC)
X-FDA: 84566168484.05.D893109
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf20.hostedemail.com (Postfix) with ESMTP id C19851C0007
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:08:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="tC3YC+f/";
	spf=pass (imf20.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774004920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4qovv9+aD8RsPS13oGAV/y3xbW2UGToHDWte0hu5auQ=;
	b=h/+diPxFDMTtDfpAts7YbsFgKt3wPjl9DVJZq+7NVaEupsRsDtKVTiQmWWlWd6FPEWygQY
	Jj1Iw5wugvx6S3eCMNV31Q1posCdy0ub1uH0q37fgF5vs+XooPOUl3wUPMnbsv5FPo6cpp
	qkt2fl/ivPvMi/jN2mG1Lc74S75FrcQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774004920; a=rsa-sha256;
	cv=none;
	b=2OCaGzCDpdv8KcawNk5fZcc7U4oznv3n3oFf3s0eq1dwdGIGMqOMKN2sma/pyLILbDdj6f
	vjlf6Jb5+AfTuTbo01ijM0NtBpdXkKtgM3/8QY0IE6c6xarztgA4KFti9hygh6Hjk737DU
	v76PueQ2U70BObQjNGBkxwvUPsSUdJs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="tC3YC+f/";
	spf=pass (imf20.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260320110837euoutp01c2b4274b45ce446fd98f917050949fc1~eiBK_fFqV0248402484euoutp01G
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:08:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260320110837euoutp01c2b4274b45ce446fd98f917050949fc1~eiBK_fFqV0248402484euoutp01G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1774004917;
	bh=4qovv9+aD8RsPS13oGAV/y3xbW2UGToHDWte0hu5auQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=tC3YC+f/cwuKn2RlZKFwY2x8rUDgAsDAFY60UyBWpLPBL+67Y08nlVUxai1DNaN5D
	 sFUfqzCG/9wmcnOrRRU7vo76g8QFm1fOPCix13urNlB577UaZgeKHor7NP4Zw+PBBu
	 i0Qd/1bii8ZaKPiERbuc0j3N6JUtuaGTgrhxYrZ8=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260320110836eucas1p13ceb4f958f17b568b1b6a89ce9cdbea5~eiBKofPAW2282122821eucas1p1u;
	Fri, 20 Mar 2026 11:08:36 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260320110835eusmtip2ba021ee90f681f3ad044dd9fe0d2ed25~eiBI-eTqE1236312363eusmtip2w;
	Fri, 20 Mar 2026 11:08:35 +0000 (GMT)
Message-ID: <3fe54fb7-8192-4b0c-9f51-d04cb8ac1300@samsung.com>
Date: Fri, 20 Mar 2026 12:08:34 +0100
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v3 0/8] RDMA: Enable operation with DMA debug enabled
To: Leon Romanovsky <leon@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>, "Michael S. Tsirkin"
	<mst@redhat.com>, Petr Tesarik <ptesarik@suse.com>, Jonathan Corbet
	<corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Jason Wang
	<jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, Jason Gunthorpe
	<jgg@ziepe.ca>, Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
	<mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev, linux-rdma@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20260318081858.GE61385@unreal>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260320110836eucas1p13ceb4f958f17b568b1b6a89ce9cdbea5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260317190552eucas1p28f3e818f88d252b1e4161332be084177
X-EPHeader: CA
X-CMS-RootMailID: 20260317190552eucas1p28f3e818f88d252b1e4161332be084177
References: <20260316-dma-debug-overlap-v3-0-1dde90a7f08b@nvidia.com>
	<CGME20260317190552eucas1p28f3e818f88d252b1e4161332be084177@eucas1p2.samsung.com>
	<20260317190538.GD61385@unreal>
	<de23ccf6-75ef-48af-8c69-2f416c564f2d@samsung.com>
	<20260318081858.GE61385@unreal>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C19851C0007
X-Stat-Signature: 8p4n6mtkg538sixbbp3uy7gx48o3nnqh
X-HE-Tag: 1774004919-177082
X-HE-Meta: U2FsdGVkX1+1QuvuDS6WwqQyO4NoyHk1lVGvhXe+iiGGCDpLdciU/7ehhaNPeaFzlMcPRIpc6CWissAkirUpGbUbgFJZ1rOoWAsWasLhGRRYZnbcpWSBYAnLBt1x41mc6VYPa8x3CVuJIaE6ezem5UWUSy3VtpSfL0wOzEVHbJtZEaQZZyeZcKPFe6wc4c9ZNEWk23RR4R3qzo+8+6IP4gzCeyDUS2y5UXp4uECUx6GnWEBAsHz72408Ac0Y3OFwQgxWafoiLQErQ4zVW23JAve/SKh0Kdbv+oGseOmUlt/T9XrcVNB5MLEsQLVc89zZyZMkrI5vxGU8cHAbXe/a/RCgS1Hfmx6CNn1iwYegpTXxAlQHSLRWfUrICvMsRcoQCQPIHa1SfkPpri3lxBg6vEWfRyXetM43NPpQ1KgvrGzrnZWEjV2OpXqFc1mDcHIblAYtY8r5p0lIfJJJVlYvSrC8idItHQ4tSk9ZSDbsGgqrUXgqJYCwOU670+dxAVw2ZDub+ATp0e2ThlV+1y+GqFBluDCAG+xPKnJ99Iw8zAgAdf1dXAGAXmU8YDgsPUym6dKSR05Ku9mLQ4GFXLJfYu86Pt9/LYv/P5GAdBN9CvE218DJDGT1yzkk1UH32kZhF7lBSLkoc1Qxi3CcM9Rg66ixQUnAfIYa0OYdc152/Ab//3wp0iHAxsE6hfXEMayqQc2GvU9jtlIPuGDeWmzuCtMX3fB99oa7/H3N71xn90XCDOqAoRV8v+JFA5AVqkHlr3gPLqGrPnKJ/hlsz8ZMZyQvoHQUO9cumKDM76nzl/BJ09FdedUviRanhyvcXoTwFOaA2WoRqqApTCagpAKEEP26CZkX+5kMt/dahF07dPm+kCNmJLy3idkehXZ6QMPRyeVuihc+ibeolWb3iGjX8STQls97QmoX7xutyqcpSt0RNPZD2uVxomjddVwngZ/iCfbJ6Ok9MKmISnsGxfA
 YSDOAjhf
 v5VEiPFDVObrUtnIsDgmaJ9vcy3cJFIrJrlMMrFPs5zVa1Cgw7Ap4MPclRfwPlS3aBe42Jo7wGfYqOnEQ3Lg6dQrb8gWlr3VEfkrh4JFDpPG7aRBEqz9oSH/19Xf//zkmdju7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Leon,

On 18.03.2026 09:18, Leon Romanovsky wrote:
> On Wed, Mar 18, 2026 at 09:03:00AM +0100, Marek Szyprowski wrote:
>> On 17.03.2026 20:05, Leon Romanovsky wrote:
>>> On Mon, Mar 16, 2026 at 09:06:44PM +0200, Leon Romanovsky wrote:
>>>> Add a new DMA_ATTR_REQUIRE_COHERENT attribute to the DMA API to mark
>>>> mappings that must run on a DMA‑coherent system. Such buffers cannot
>>>> use the SWIOTLB path, may overlap with CPU caches, and do not depend on
>>>> explicit cache flushing.
>>>>
>>>> Mappings using this attribute are rejected on systems where cache
>>>> side‑effects could lead to data corruption, and therefore do not need
>>>> the cache‑overlap debugging logic. This series also includes fixes for
>>>> DMA_ATTR_CPU_CACHE_CLEAN handling.
>>>> Thanks.
>>> <...>
>>>
>>>> ---
>>>> Leon Romanovsky (8):
>>>>         dma-debug: Allow multiple invocations of overlapping entries
>>>>         dma-mapping: handle DMA_ATTR_CPU_CACHE_CLEAN in trace output
>>>>         dma-mapping: Clarify valid conditions for CPU cache line overlap
>>>>         dma-mapping: Introduce DMA require coherency attribute
>>>>         dma-direct: prevent SWIOTLB path when DMA_ATTR_REQUIRE_COHERENT is set
>>>>         iommu/dma: add support for DMA_ATTR_REQUIRE_COHERENT attribute
>>>>         RDMA/umem: Tell DMA mapping that UMEM requires coherency
>>>>         mm/hmm: Indicate that HMM requires DMA coherency
>>>>
>>>>    Documentation/core-api/dma-attributes.rst | 38 ++++++++++++++++++++++++-------
>>>>    drivers/infiniband/core/umem.c            |  5 ++--
>>>>    drivers/iommu/dma-iommu.c                 | 21 +++++++++++++----
>>>>    drivers/virtio/virtio_ring.c              | 10 ++++----
>>>>    include/linux/dma-mapping.h               | 15 ++++++++----
>>>>    include/trace/events/dma.h                |  4 +++-
>>>>    kernel/dma/debug.c                        |  9 ++++----
>>>>    kernel/dma/direct.h                       |  7 +++---
>>>>    kernel/dma/mapping.c                      |  6 +++++
>>>>    mm/hmm.c                                  |  4 ++--
>>>>    10 files changed, 86 insertions(+), 33 deletions(-)
>>> Marek,
>>>
>>> Despite the "RDMA ..." tag in the subject, the diffstat clearly shows that
>>> you are the appropriate person to take this patch.
>> I plan to take the first 2 patches to the dma-mapping-fixes branch
>> (v7.0-rc) and the next to dma-mapping-for-next. Should I also take the
>> RDMA and HMM patches, or do You want a stable branch for merging them
>> via respective subsystem trees?
> I suggest taking all patches into the -fixes branch, as the "RDMA/..." patch
> also resolves the dmesg splat. With -fixes, there is no need to worry about
> a shared branch since we do not expect merge conflicts in that area.
>
> If you still prefer to split the series between -fixes and -next, it would be
> better to use a shared branch in that case. There are patches on the RDMA
> list targeted for -next that touch ib_umem_get().

Okay, I will merge all patches to the -fixes branch then.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


