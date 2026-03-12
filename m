Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24E8E106ACCF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 16:50:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DCA66B0005; Thu, 12 Mar 2026 12:50:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BE1D6B008C; Thu, 12 Mar 2026 12:50:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E8486B0092; Thu, 12 Mar 2026 12:50:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FB3D6B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:50:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C40B11B726E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:50:44 +0000 (UTC)
X-FDA: 84538000008.24.B36F514
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0FB5C180010
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:50:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="X/Ncuhpr";
	spf=pass (imf24.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773334243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tZYJawjeNtWURdWLRbSNP97psX6D4OkHvoqcfUOfJXE=;
	b=Qs9pO/chFOGSuJ+ZiNI0QsIFtJ1UrTYShlUbAiWW6SbrQFuQVBfc99u5HPsIUKs8zdrGu/
	UkPJSCT1ujBSXi9A9c+J02hamTXFQkXq8bdO1iIeB6ygRd9W3TUDo2agwIN4nID8y57gjJ
	jEqwZs2ee/+1/fxqN51vHW2KTxqK6No=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773334243; a=rsa-sha256;
	cv=none;
	b=z/gD8mBzWd7iNd9yF9TZ5zwSsQY/BCwBqZsgnvI9Rr1VaOCdvDCBSXui9AaTfcyxFoLUix
	7e1Q1eg+aVmU/j2gHoR161OoZNAUPKC0Pxe6xDzpcBfNhBmiFfNDRZaSgEWfY8DpCodNBM
	BF/gzriI0+aVOkyocHJoDm62pV08WsU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="X/Ncuhpr";
	spf=pass (imf24.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6430561338;
	Thu, 12 Mar 2026 16:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70359C2BC87;
	Thu, 12 Mar 2026 16:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773334242;
	bh=I7ohnXz5SQWGkR4iqkJFGqlNZU7QTgaFdwYwVFc0xzE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X/Ncuhprz30y2xAin6UFvnTvzocNQuIqes6ui7gpDr2Q7sh24Z5OkTNZJtridjidu
	 qHJA5XMMmx34FwJfNQTd9eWNuC/TsCnuMW0QQw2WMFgajgUTOtCfMLOlkV7P3EYHhH
	 Nx4YTBgI13YFouzZbuB9ZuPbGPAZ2nHx5tpawOo/y4xbwSwX4qBFaw+N1s+ukFqidC
	 0py6Mr7JAg2AnYENLQ57jutZWMr2iGKWHhZqFgi67nenSrz73gVlv8Eod4sKTgKCrr
	 cy/u7fNxZj8vYe+9tPI3ClTIVdvGPi/HMv2yRFXiddhyGIhxb0pVk4KDsI95EkyaWL
	 rkkqouFhYoZ0w==
Date: Thu, 12 Mar 2026 18:50:38 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Petr Tesarik <ptesarik@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev, linux-rdma@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 8/8] mm/hmm: Indicate that HMM requires DMA coherency
Message-ID: <20260312165038.GB12611@unreal>
References: <20260311-dma-debug-overlap-v2-0-e00bc2ca346d@nvidia.com>
 <20260311-dma-debug-overlap-v2-8-e00bc2ca346d@nvidia.com>
 <20260312122645.GG1469476@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312122645.GG1469476@ziepe.ca>
X-Rspam-User: 
X-Stat-Signature: 63s7553kjiug6hi57q1mqd1ss7aems1s
X-Rspamd-Queue-Id: 0FB5C180010
X-Rspamd-Server: rspam03
X-HE-Tag: 1773334242-306784
X-HE-Meta: U2FsdGVkX1/5dMpNO6dXuGLzpE155kck/ey+Rq06nDmg5+ZDavVUMVg+wBK5CTnPIHjaYfWvPIta/QvtX3PbH7Z51vwejysnoz8+SXOZmhRJINpgIZSvUT6kY0gpWU3FN4jjAEs0/XLUQZADLfvmYhSISZsJQKZgOa6+9mJbpR7xQ/6RXjGHcxa9uxT9H571nTWdcWT/YCAeH4owUM17lPQ71/4f1GWyfIZ2J0ftOXlScxnET6SOkL47PFTlPXecz68dD8OeDRyatN8iLx6veh3cw3GA5WwtzhT/a3IRvDdeDcgH8ytoFhuk7CM/NSb5EMzxeeAof9OLKNUUfWgcCzkYbkG1qXhe4S9weGNk1odb2oButvqTuviNRfctMzc/R3t/c8yRON7AJ2YN2uSkWNXiT6ljwMl2YhhCPa17jzV00wxT96LNtthi+Y0Chpaujy91w3dGZtzxdAA9/PRLomYvIP4prwapCoQBqq13MUbHGE+Put3BuaHNt5+1eWyBN3QcBpnREaxS1zxYa7CipSrnCN+lNRPLSed9Tikn7ifMQU7BJF9NZ6ld4Lg60X3E6avptuvZJpmEnq/NodhsMF5tAKhrTKT3kJPDJhDximd2HwW1rvxbtneMtZo4bMbqw8HbAaggdbwlY0D86G+LjYANiholEW+JCDymMAr0ZabM0BHEwLraYDBf5FGBCtp1+XKkzTEUJt//wABETLSNtVI6g9OTADD/jtxAgZHCENL5/fHL0ElshAXWtpB7RxMZ8tkb6Kebsdfb/FJCvijIAbiyit/yjZEYZb/PcDnE0aaEDkhRCwT3fQMF4j8TvLKbqR++OcaOV0I+5Zf5GTujfqGpSqwPpm97YndejY+hMbOubOAAMPQCil0sZQJmcaJiHAibHvqVdP5c2VB84n1pMDwXiY3vztefMZQ0KKHRrAiyNJ8ZDiEkWu6gnDv5ktBj2BLJ6f5N/zQwMd3wqdX
 oSvX4aVA
 77vZyqA/sibIQUZaTXoTmfXlXHaJKt0oaQ6E152KlwFMFhsRM/xLzai4f7jN8XqzSP9J1cq8YipGuHVAvOegcD9Dgs9WdIdw71UhIWt4nCpd9dhIAqYs2MFDJBGl3y8g0WvBsMd71Pw5/tZHqQxbEnKKNxdTa7DAHawZ1Vh39fG0MdmqTPjsM1TIzvZdJ0VI1443IMAIiJPlmG1KEPsa2hq5FWfhNAKpByERiYvcVKw7GJllz4UXFl+ODhNwIwUJlmruT2laympy/X0vQvB0zIxJJ8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 09:26:45AM -0300, Jason Gunthorpe wrote:
> On Wed, Mar 11, 2026 at 09:08:51PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > HMM mirroring can work on coherent systems without SWIOTLB path only.
> > Until introduction of DMA_ATTR_REQUIRE_COHERENT, there was no reliable
> > way to indicate that and various approximation was done:
> 
> HMM is fundamentally about allowing a sophisticated device to
> independently DMA to a process's memory concurrently with the CPU
> accessing the same memory. It is similar to SVA but does not rely on
> IOMMU support. Since the entire use model is concurrent access to the
> same memory it becomes fatally broken as a uAPI if SWIOTLB is
> replacing the memory, or the CPU caches are incoherent with DMA.
> 
> Till now there was no reliable way to indicate that and various
> approximation was done:
> 
> > int hmm_dma_map_alloc(struct device *dev, struct hmm_dma_map *map,
> >                       size_t nr_entries, size_t dma_entry_size)
> > {
> > <...>
> >         /*
> >          * The HMM API violates our normal DMA buffer ownership rules and can't
> >          * transfer buffer ownership.  The dma_addressing_limited() check is a
> >          * best approximation to ensure no swiotlb buffering happens.
> >          */
> >         dma_need_sync = !dev->dma_skip_sync;
> >         if (dma_need_sync || dma_addressing_limited(dev))
> >                 return -EOPNOTSUPP;
> 
> Can it get dropped now then?

Better not, it allows us to reject caller much earlier than DMA mapping
flow. It is much saner to fail during UMEM ODP creation than start to
fail for ODP pagefaults.

> 
> > So let's mark mapped buffers with DMA_ATTR_REQUIRE_COHERENT attribute
> > to prevent DMA debugging warnings for cache overlapped entries.
> 
> Well, that isn't the main motivation, this prevents silent data
> corruption if someone tries to use hmm in a system with swiotlb or
> incoherent DMA,
> 
> Looks OK otherwise
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Jason
> 

