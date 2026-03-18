Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4788EFCD0D0
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 08:19:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE5056B0123; Wed, 18 Mar 2026 04:19:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABC396B0125; Wed, 18 Mar 2026 04:19:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F9536B0126; Wed, 18 Mar 2026 04:19:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8F2376B0123
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:19:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 30D981BE32
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:19:07 +0000 (UTC)
X-FDA: 84558483534.30.6EA4EAC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8508340005
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:19:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LaorMzDl;
	spf=pass (imf01.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773821945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4yO53cixPB19PQ3LpCPf5YUln3Azu/pzcFxRLupKC9Y=;
	b=MXU1qYA/H6nsMWR7/5lLvKuRuApFHAUfIDwbzTar4tUA+Le2z8o0lK4a5uBXMahVE/+PB2
	vgYnQ0bLQlIQUAGSqPtmQdAhvh1pz1d1Xom7dKvPLM73QczoSCwn3QfkO1rF3WynF6OK24
	hMx+Z8r+6LFWojs4HbxXrj1Rg6JrdQM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LaorMzDl;
	spf=pass (imf01.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773821945; a=rsa-sha256;
	cv=none;
	b=4iWKt9w1LFKbRKbaa+yBuIftj+ouje1Q+cvA4NDtW3GQlq0k4LAJ/UdFuMJqEAFk45y1rb
	ZBidQ+XTz+oMJZBxWRTsN7mxWDsA1oRooVkpAgaXaK0zNBrrP5XUYR9NEw2pKTispr1PAq
	is+auEgsvK3I3Pt9UvhOsf04ttYUyOY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 03B8A600AE;
	Wed, 18 Mar 2026 08:19:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78818C19421;
	Wed, 18 Mar 2026 08:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773821944;
	bh=jVeQZp0h7g+obL73Q3BKVJM80mNeyIKHbMpYvZlI/EM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LaorMzDlLJ2+D0bII3A53j63hnSxrjJGHbtDoCBjpAfjf52OE/no45FdOEDejAHRh
	 Q4Z76a9d8zbmglulrhmHrYtmvPsrWYnsRaZkSI/UchSyQrCmizli9RDszWfk6XXFKt
	 aranseGkN99fprSjS157PfMdIHUFwsV2p1bAi2UFxZXFIz/EAYgiB/URpZ5JbOxNxe
	 jW+7XnQhbRstMMHYEsKG+lGQMl3YAciYRQ7GWy9pBq2l+Zz9MXxxmoueb7kjGBHVgf
	 +ldwzEHFsYidjsNvg3b12ZQyiYT4f22PXh5B2feb8k0aRkk7Bo+Kv5lcBkdpLlf4BE
	 alySAZY/1b4Lw==
Date: Wed, 18 Mar 2026 10:18:58 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>,
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
	Andrew Morton <akpm@linux-foundation.org>, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev, linux-rdma@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/8] RDMA: Enable operation with DMA debug enabled
Message-ID: <20260318081858.GE61385@unreal>
References: <20260316-dma-debug-overlap-v3-0-1dde90a7f08b@nvidia.com>
 <CGME20260317190552eucas1p28f3e818f88d252b1e4161332be084177@eucas1p2.samsung.com>
 <20260317190538.GD61385@unreal>
 <de23ccf6-75ef-48af-8c69-2f416c564f2d@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <de23ccf6-75ef-48af-8c69-2f416c564f2d@samsung.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8508340005
X-Stat-Signature: 5dpk7dfront6awfyy7otraxhpx9ksj6k
X-Rspam-User: 
X-HE-Tag: 1773821945-624309
X-HE-Meta: U2FsdGVkX18b0NI4IBAQFfTOwAxNkhiyjLqy+BKNsth84V7GNx2Lnj/FYvpdvJStGtS/mtqe+PPdlVFm+vtFDutQTQU5Qab9KkEgsCOkS+n/qoAzjZQRFeq3Rzamhmu8fQk8z2Q3dYYt7652ldEfFDzm8nfhAVE2xzMW8THr+SeRvQuSSMCJojP01hanBLPEFnzu0lli3ctZjWvkus7NoFjUtKT+DzASJbCsumC7Fjh8eozUvE018Y3HkgSOfi5MQEksSu0viGhOv14BB0hInZXabDhbRFOnfY6UzfY7kbes+E900ckv6ktmdAPcddr1IrMv7bzEuYCUAavth485ozWBSudwU5qRXeQHRG5reLbhAjsAgKUI2J6sDHxo7ng066PfVyZo2Ho03Uizenfpc+gTEXtdcnsI+z+vaUw012fSeK1cj3vtWh4/T7xhHOfDx1yCSXc8Mn3mXOAv4rHhEW6PD78gIOfSN0CgM+mqYjxjal/8eccMSfzQiKvz+VQRasORQI4xnD2Esileu0IPRVOkzGfVoYOigtkkLd7Tf39WR9MMy/VGnTfNetJAb0tjE/P6lNqV93ii7dP9IJyLvLmRtX8zVF1VlbTOM73DgyZJ1HFu2w5P1FzONn0GppcnWZ8cJaPQS+Zu15b9Ul5MGjeNhl0ugmsfq+CsnFZl94Kjn7uueZUyLjcGQ4HYR6DpqEP4FPBH6AhgImxmhvWVrbupfD9KKA2KpP2P3+xqPBgh3Po5pUSgMIqfyQvC6qZmP1O3jC0fwJ4Kfg8+82Vvh3JbPMvWc5D3b4/+zuQ9phidyAZW2M1ENX8FXtZ4eXplb2IHoVtzzAALcAZbr0Hxf5uxuGH3LrQyrpwvn99HxguHbP/lMFLMbq9x2aKcHzWItRCFqAN5do8gUTex0IhFQ6TMrwbobKJXLijfflDnGiRAX3qxpAC3gwXWFOr1T9VDMCPPEsdb8q9Cus8WpR3
 tR7Mbl+T
 PNasC73phZwaQaGobRdcdtvx9pEj3e52Y2XezuxPjC1giKHG7Yzw5Mz7uIdxXIVO8zrIDHaRW67Nrk8ByDZdtrcBiRt4Bu+Ot6NSO9qbiTasJLtr0c4Gv61nBlMXEcredejxamy0gy/kTTbDggGRlBlcwEdzsGxkGbU1Cr4N5+vtEqIXysd/VgMAe9vMbMd+OjEeGZW44iXzNWSPVgOa41mwCb5Mc8llMBaRldJsf1JRLhHPo8nREU4cmeZWB2CacGgBGRPe1/uoXLcNzrSLTD0wLfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 09:03:00AM +0100, Marek Szyprowski wrote:
> Hi Leon,
> 
> On 17.03.2026 20:05, Leon Romanovsky wrote:
> > On Mon, Mar 16, 2026 at 09:06:44PM +0200, Leon Romanovsky wrote:
> >> Add a new DMA_ATTR_REQUIRE_COHERENT attribute to the DMA API to mark
> >> mappings that must run on a DMA‑coherent system. Such buffers cannot
> >> use the SWIOTLB path, may overlap with CPU caches, and do not depend on
> >> explicit cache flushing.
> >>
> >> Mappings using this attribute are rejected on systems where cache
> >> side‑effects could lead to data corruption, and therefore do not need
> >> the cache‑overlap debugging logic. This series also includes fixes for
> >> DMA_ATTR_CPU_CACHE_CLEAN handling.
> >> Thanks.
> > <...>
> >
> >> ---
> >> Leon Romanovsky (8):
> >>        dma-debug: Allow multiple invocations of overlapping entries
> >>        dma-mapping: handle DMA_ATTR_CPU_CACHE_CLEAN in trace output
> >>        dma-mapping: Clarify valid conditions for CPU cache line overlap
> >>        dma-mapping: Introduce DMA require coherency attribute
> >>        dma-direct: prevent SWIOTLB path when DMA_ATTR_REQUIRE_COHERENT is set
> >>        iommu/dma: add support for DMA_ATTR_REQUIRE_COHERENT attribute
> >>        RDMA/umem: Tell DMA mapping that UMEM requires coherency
> >>        mm/hmm: Indicate that HMM requires DMA coherency
> >>
> >>   Documentation/core-api/dma-attributes.rst | 38 ++++++++++++++++++++++++-------
> >>   drivers/infiniband/core/umem.c            |  5 ++--
> >>   drivers/iommu/dma-iommu.c                 | 21 +++++++++++++----
> >>   drivers/virtio/virtio_ring.c              | 10 ++++----
> >>   include/linux/dma-mapping.h               | 15 ++++++++----
> >>   include/trace/events/dma.h                |  4 +++-
> >>   kernel/dma/debug.c                        |  9 ++++----
> >>   kernel/dma/direct.h                       |  7 +++---
> >>   kernel/dma/mapping.c                      |  6 +++++
> >>   mm/hmm.c                                  |  4 ++--
> >>   10 files changed, 86 insertions(+), 33 deletions(-)
> > Marek,
> >
> > Despite the "RDMA ..." tag in the subject, the diffstat clearly shows that
> > you are the appropriate person to take this patch.
> 
> I plan to take the first 2 patches to the dma-mapping-fixes branch 
> (v7.0-rc) and the next to dma-mapping-for-next. Should I also take the 
> RDMA and HMM patches, or do You want a stable branch for merging them 
> via respective subsystem trees?

I suggest taking all patches into the -fixes branch, as the "RDMA/..." patch
also resolves the dmesg splat. With -fixes, there is no need to worry about
a shared branch since we do not expect merge conflicts in that area.

If you still prefer to split the series between -fixes and -next, it would be
better to use a shared branch in that case. There are patches on the RDMA
list targeted for -next that touch ib_umem_get().

Thanks

> 
> Best regards
> -- 
> Marek Szyprowski, PhD
> Samsung R&D Institute Poland
> 
> 

