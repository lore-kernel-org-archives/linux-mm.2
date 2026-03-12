Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EAC5105A591
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 12:19:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 738906B0095; Thu, 12 Mar 2026 08:19:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E5A06B0096; Thu, 12 Mar 2026 08:19:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E3AC6B0098; Thu, 12 Mar 2026 08:19:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B6FB6B0095
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:19:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CE7E2C0D9C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:19:42 +0000 (UTC)
X-FDA: 84537317004.28.A310566
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id DB5C7A000F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:19:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=k+VMyglD;
	spf=pass (imf25.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.172 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773317981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0lXptsQPO/2bR1nDOk4C8coAYtgdswQIgAW2nY2lBKk=;
	b=LDYww0vxQSP1IJHQeMm9PCjgiPE5ZblfNe3Opm75EoQHz/rdSoQhQ98JxQj9QLHylrryFN
	1cXOP7vsmgyIAaPQK2ZsryQkDvV/wDTEiNP0RSJCQsc5rQl+Pj5k7wUpJyDpeV7qABws47
	kUduSHPDuVfpWZdQ2HeCHz9xS7tNF60=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=k+VMyglD;
	spf=pass (imf25.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.172 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773317981; a=rsa-sha256;
	cv=none;
	b=FMtaAROz/f8o95Trav9RdeDscA9DYTjW0BLv8OWySmh+cPO+of67LRYhcMj6VwV+igOnjX
	p9Z73v+eVnd0/6c2HerIzYZdt2E3UrCeOmUD5sl22YuJIB0TjZqIfh1z+BGvHKmGmfvj5r
	a4hnJ6OoYC+Wz7NqqI1ZmGMp5lP4674=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8cd7aab92dfso118245985a.0
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 05:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1773317980; x=1773922780; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0lXptsQPO/2bR1nDOk4C8coAYtgdswQIgAW2nY2lBKk=;
        b=k+VMyglDPsNrJPtlLxTS3BIlNQ6/wkj4m+/+0Am8uP9KVdPtGc+fXZpyZtCmKbj0EF
         rb/CIx7qLZqABAFKCmUTDe41Xy5ZvCobAuY8VxETaET77OzUQNupAxgX3f5rHb+N2gaw
         VpEaDlsEYYu5kjfg7mKbLMcTlKTHx3gFXE1lU08n0Dxd9UL1we/cy24+ZvK02MiePc5z
         zXwr8ISAyR5Tszlsvcxc55vWrUeT+8d5P8KkVOWgzZqJyuhOU4okoag+U0w8b20f4ehp
         q2jp0QG9SE/+ebR4Rcha8CP8TP5zdwLAxQyNRyE+sw2MJHM4G1cxKDVwvHEMMtO4sWXX
         wHuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773317980; x=1773922780;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0lXptsQPO/2bR1nDOk4C8coAYtgdswQIgAW2nY2lBKk=;
        b=B68+4HoUbtRUE8xlYEiqe4a4d4Oc1eUxPTwKPrkVR1mQeuESvaOiGBWPzT1lc+RivP
         DzWq+mzViIsn+iHDBlos0/4Mv8dIL/CnSfGhvdlMTWD7ghjrLsYjybgzkz4jjyPcUSlk
         G4NnmmrMgmMH3Tbm2NBPLCbOnm9UVA9Jp4ZJrvBGMarHbsPibKSboIgMKLuaqObZjo6I
         vA1Mp3BSaMnlTvfjx37HJDhHr21i+p/Yv8OSkU13YYXpZfvqK4wFAt53kyrGkWEcENtH
         OOv7QYltYOYPCdXlEsW/NFTfo644/MLKMOUTg3YupSXW1Wa+wHhG2Fv5npqTGaMV0vWA
         yU9w==
X-Forwarded-Encrypted: i=1; AJvYcCVxbhcKmnq0SOhE8n9lwuUce42YOQ75CZQ0aFt+gTZZH5kMNSsiaStE0tsZZGuM7IWO8QLs3Xp6+A==@kvack.org
X-Gm-Message-State: AOJu0YxCkxMkus7KNC87rAuFOFhlv330AhQ7ET44W7C/SmQQe7wncqzY
	K9ffDswA7mAyySqBKRq9M+fjQSb1V3GUKWaO+y9C7AjSW0Kr4h8C8XF7g2cteRUzy2A=
X-Gm-Gg: ATEYQzzy2pLw2VX9eujTt2+4fXyIeY81ptYToITzvflucqoc1LwfjQLiGvnFPm1+N2Y
	uV5b0wINeDZe73We9xLsKTjttsuNk4YP9QakEgfsUQUVW/3CgOQbUIJ4vXJBO7bMrnVcugQltsg
	k70XJSOeuA6VlcAreYobN8yVjfQzol937Tai1RYI5tXkkEPTzABWTQsf+iqYnnBjU/MsS+d56ct
	SSbCHwizCirFuS071Cxu2Y3sbQdRwii2UXkvmUke0vdTDLOjv8exkdC0BDWT4mUFexYPjlfBjjt
	9L51Rg7upg2E9zITaB0pMW1NI4Xej0gqL6NVhJfV4vDyLzlrS2+c7SM3q+vJvPBQgcaAY7Lyc3f
	oNe/LBt31v5jNRtIiN6+bFGe8dQQ8NsO0L6B1mb/ee9BS6J+AKyFufXO9DljfCqc92KWk4iPiNP
	iinKpp13N2h94q377e1ZNNgb735SI6VcR7mIOHODnyHRq4SAcZE28igRnBrEYGTeNPnTRnncunq
	yahes58
X-Received: by 2002:a05:620a:4041:b0:8c7:3ff0:d472 with SMTP id af79cd13be357-8cdaa7b6b03mr382866785a.15.1773317979843;
        Thu, 12 Mar 2026 05:19:39 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cda21346a0sm321675885a.34.2026.03.12.05.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 05:19:38 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1w0f0r-00000006esN-1WXU;
	Thu, 12 Mar 2026 09:19:37 -0300
Date: Thu, 12 Mar 2026 09:19:37 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Petr Tesarik <ptesarik@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev, linux-rdma@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 4/8] dma-mapping: Introduce DMA require coherency
 attribute
Message-ID: <20260312121937.GD1469476@ziepe.ca>
References: <20260311-dma-debug-overlap-v2-0-e00bc2ca346d@nvidia.com>
 <20260311-dma-debug-overlap-v2-4-e00bc2ca346d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311-dma-debug-overlap-v2-4-e00bc2ca346d@nvidia.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: DB5C7A000F
X-Rspamd-Server: rspam08
X-Stat-Signature: u3s5zwutujkw7xf5gudnbwauag67w8za
X-HE-Tag: 1773317980-80609
X-HE-Meta: U2FsdGVkX19XNAL3JnsocGLTNNOw49+LzqcJkjBNdHUW5E6I13K1IYHNL9noYFV7nOnF2WCVGYRoaWQQCTuHpqddKPrk1LYdAUggaVB+dm9gOI/2kD21d3h9mg1U0XBxTcOI3VOAdlXi0xThM811ed2XmpV8+vX6vl2OUbVTSNTcAZd4hffl93mHgErr8ijMXA872VKmfsh4PxEPZUVahmy1+NWILFJvfLa6+9AeHILiAEc/kwwqeaTsrE+SaA9pJmcIVs109XwuNwA31TaYHqrhv6A0vlARi1xIe+n2MGueeq6YQvzSPKp5dJXfxO3NTlUWrQBC/DQUPI1WKen2f5PQH817qXS3ehH9nyJmpnYANh3aooq0fiOJzJj6Bo34uOVFDusSYPg0oe4m4DQCqOEV2sZrm313zROW12lsjaUnd2OII0vH8YA9MDe1aLhq4qOKUbg6p9QRbogiGzIRDjTNxq1E7Sp91SP01BCvcFCfsVwsZZvllRGSwVta3e/mjnUownoMtvY/SSQXASd8tY58si8dEoKnDf2Owbz7sQSBjeEIvYTWJSv6fzvzsBptL7s+ce3ha2bVNBuW5ZsjTiF8v73OgBT+T9QnCkRupT/3GfcTCHX6+228GV/xxHiqd3rsn+ssczvHMPemOALzFw15gDYwLxDowtgq1MrtD9ZidkUkGzA+b08MMVnWZ+y9ab7jgFWjmf7DtbN9na/9IrJD2yRWX6egk2PnKc0ClpC0MowRxvNpKIsuLz3Dy0QN60ZvR9F4DxA3H23RNGXp92/1qf3gL6PqHDHtEwfOIc7Fu8YcEW6Tp+LvlZuwJ4RTurJ+D1S//G5K6ZfRewrQFqnIK0xUvk7MIFZWhZykswyS+OKwXvYXQLZcKy3H1Kv3QjvaU3FaqvAMiJDmKytPkW10p2mQPBMIagE36x7ZkHwvVvuB0QU4jQbxzrAD7mCeWcUvwz711GILVYT8aiv
 HL0IOdzY
 tobmSkmBNmG+vDGo+NO1ElBVjm1UBn+Shy6M63kGLopczypHyKU6i4sgdvbg20+4xAyyNejlwHdUQZxadd7N93+pLyFVO0kyU+Ezwhok1z7ENexKlExakmzbwmGocj3WLVdGPPaCPqR08pFbmTCNJ92pdZzduNFIw/9jPLe/SA5ma4QJF+AKCkd8FCbjYO8dXaIU9oqvXAe96Uuu+NpFvsCoxyCZAzVN+YCcCJOe1Cr+65rjVPQYczX8bC/+CeYGSgMII/WRiGcTqrnJiK/jHSKxv7gutEreQ/xSf4PNepSmD2DfFUZ4O9PTIGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 09:08:47PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The mapping buffers which carry this attribute require DMA coherent system.
> This means that they can't take SWIOTLB path, can perform CPU cache overlap
> and doesn't perform cache flushing.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  Documentation/core-api/dma-attributes.rst | 12 ++++++++++++
>  include/linux/dma-mapping.h               |  7 +++++++
>  include/trace/events/dma.h                |  3 ++-
>  kernel/dma/debug.c                        |  3 ++-
>  kernel/dma/mapping.c                      |  6 ++++++
>  5 files changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/core-api/dma-attributes.rst b/Documentation/core-api/dma-attributes.rst
> index 48cfe86cc06d7..69d094f144c70 100644
> --- a/Documentation/core-api/dma-attributes.rst
> +++ b/Documentation/core-api/dma-attributes.rst
> @@ -163,3 +163,15 @@ data corruption.
>  
>  All mappings that share a cache line must set this attribute to suppress DMA
>  debug warnings about overlapping mappings.
> +
> +DMA_ATTR_REQUIRE_COHERENT
> +-------------------------
> +
> +The mapping buffers which carry this attribute require DMA coherent system. This means
> +that they can't take SWIOTLB path, can perform CPU cache overlap and doesn't perform
> +cache flushing.

DMA mapping requests with the DMA_ATTR_REQUIRE_COHERENT fail on any
system where SWIOTLB or cache management is required. This should only
be used to support uAPI designs that require continuous HW DMA
coherence with userspace processes, for example RDMA and DRM. At a
minimum the memory being mapped must be userspace memory from
pin_user_pages() or similar.

Drivers should consider using dma_mmap_pages() instead of this
interface when building their uAPIs, when possible.

It must never be used in an in-kernel driver that only works with
kernal memory.

> @@ -164,6 +164,9 @@ dma_addr_t dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
>  	if (WARN_ON_ONCE(!dev->dma_mask))
>  		return DMA_MAPPING_ERROR;
>  
> +	if (!dev_is_dma_coherent(dev) && (attrs & DMA_ATTR_REQUIRE_COHERENT))
> +		return DMA_MAPPING_ERROR;

This doesn't capture enough conditions.. is_swiotlb_force_bounce(),
dma_kmalloc_needs_bounce(), dma_capable(), etc all need to be blocked
too

So check it inside swiotlb_map() too, and maybe shift the above
into the existing branches:

        if (!dev_is_dma_coherent(dev) &&
            !(attrs & (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_MMIO)))
                arch_sync_dma_for_device(phys, size, dir);

Jason

