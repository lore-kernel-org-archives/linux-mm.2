Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DC01CA1002
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 13:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04CE08E0002; Sun, 31 Aug 2025 09:13:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3F558E0001; Sun, 31 Aug 2025 09:12:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2E008E0002; Sun, 31 Aug 2025 09:12:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C947F8E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:12:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5A1791199D8
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 13:12:59 +0000 (UTC)
X-FDA: 83837092878.29.4712BCA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id E272F1A0002
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 13:12:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WMN3gtSJ;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756645978; a=rsa-sha256;
	cv=none;
	b=xawKsVdqt5fcYR80H5FkgHD6u1RsRf2/+5Lh80snpr9PrH/o0dujsBV3CMaWREKmWs44dC
	DyYns3TnFYQOkCSJ4adq1swjTYhtddfDCgNLCC5ht8vKMGVvTqPvpY2Tzvj9bO4I/W3qJz
	2Mpz8nU5rgPIijio+aGoCpupqp/iB0Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WMN3gtSJ;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756645978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ac+Ch9BPhurz6Qm+wFXw5b045ua0/xnlchZZPlAlRmQ=;
	b=uT2JuBj5S6GbNgsi2A4ZlXff2CNoFS9xpz7qLnWcmaI1gCRHma6hjlgBGirEj4flkGS5m+
	7fy5o9WBruKCUF8jAaWh8z//XnNXObyOpdH80IU/Iu8xn8zXm1iBi1Sw6e9KvF7jIKrEKn
	iyA1+DbXz3/2+l5nr0vqVO22uwiHHcc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D1202601AF;
	Sun, 31 Aug 2025 13:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2B1C4CEED;
	Sun, 31 Aug 2025 13:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756645976;
	bh=SVfffytdJ7l+FJFH+NQ2fAYz/jln+XvhXnCAv4vVciA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WMN3gtSJVf7yZJvH25PHoup176xzR4iH45PFd5WTaZl3P3yIlcpIRkfu5U3ulpn36
	 IKubxjRKitiVH7tEFGk0EvSWGehRo+3Ze6ErmIyU4uPo4HQlYX4MxtypCD8fFWeHBM
	 x5lx5bK4qJ+D+MLZSAMBnr8/dS6PtN2tAd1/pTiMLV/guQAHue805z1yqYSMaGWuq1
	 Airln6Bzle28Ohk7U9LgDEafLkaTwO2O0iuzeLmhUWu5F6SgZbC5gh8KCCHy3wqp2C
	 Hcv7g6EwqE5WnoDtEeiWuc9ndJyrHz9MWyHpBWe4DPcTvzNQTROEZWINBtgECoxCxA
	 rqMaDKHjRKGlQ==
Date: Sun, 31 Aug 2025 16:12:50 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	iommu@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>, Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com, Keith Busch <kbusch@kernel.org>,
	linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-nvme@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v4 09/16] dma-mapping: handle MMIO flow in
 dma_map|unmap_page
Message-ID: <20250831131250.GC10073@unreal>
References: <cover.1755624249.git.leon@kernel.org>
 <ba5b6525bb8d49ca356a299aa63b0a495d3c74ca.1755624249.git.leon@kernel.org>
 <20250828151730.GH9469@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828151730.GH9469@nvidia.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E272F1A0002
X-Stat-Signature: kimztmjz6c5zbiuhjhh3z5k1jrjwt8fj
X-Rspam-User: 
X-HE-Tag: 1756645977-739178
X-HE-Meta: U2FsdGVkX18HZGZfhvrWlp/CYoyWrqi2gDU3O+L5mH3olR/cMeAgmrHmOcH64yrps94EprSgr7L60eVd0rruqKPla4M0X5EOfEMxxY/dc9sIGAnoQzjuVk1wl+IBwO0Wbn9AfV38rVKQU78sZJ5Fc2RMXKxffD2aKkzDHCilWjrtxyKT7NQwiaDSq0o9+/UV3OKxtPfoVu2HDhcFUccrBd19Rtqpq4qZrr9PsxfB+CWuwXFI69PObgj2fwqEqVbnWFGFlWChyLJmU0Qv9efSITmZzvRh5TPonJs7iq5XWt825pH0nTNQeN3cO0xMd5u9zKo0YEJ1YxUnY4t59zZEe4LDV76UV6CzWLu0zMwOzrZDAhML/961xiTYp/K6j3bRWz+J9IG2t2f6FMB3YxxgRdOjCsRpKZdTrN0Ox0eIKgau/K1iaBvxpN2UQlU1cuVYgStzY1/LK2TYVFSSGrbSZKvLbkL9/Mz/p4GCtoIkD651yOAGACgn63X4f0YTgkSnPxeMfa+YKVk+hf/TjHSsBmAqymQZDdk/XHnbRsaT35jBSnZ0jg9VemY0xC0LCvCpBsL8j5Awoe8wkCWaKwqaIjAAidtcp+vnD2xYQpwtzsCOfqKbcsmW8LhEBqFuqJjjAQuAN5vGVfyPy7mqGdk8UvCWKt5g3B4q/cl+3e8W83JN8mnFVxCR7VJSqSZSIVBGT3RJWntrtITJ8PiJHmN2TnEMGaW5PS882IgobwkFRTyZ3KPP4Now5pAKem0ZNGaW3QbnDVSVOD1LZhwlpOaonJFMzVvp3V38R9NnbfnnbAXES2y2hUCGrKygC46DIRFcLPWKg7cB1auDvw/u+dIkDKeArM0I6CCjwSyybZmajK8Qi1Y4go2FqjsSwZZPPxG0Pvb5ayf3vQ68L8z40HOAnHowezSRkXMz9QFYiF6cSebfV3gSzfcuA3iOyMeQDGtIaYgds0TkyobuTh+jpw/
 phC438Ug
 RcL3BE4nZdxAlH40XbLLcR30fAY91sVUAjCFJJb033R6q1pVxR0C/qDR75X3hwCrdW7cQHIGwPLCfW2M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 12:17:30PM -0300, Jason Gunthorpe wrote:
> On Tue, Aug 19, 2025 at 08:36:53PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Extend base DMA page API to handle MMIO flow and follow
> > existing dma_map_resource() implementation to rely on dma_map_direct()
> > only to take DMA direct path.
> 
> I would reword this a little bit too
> 
> dma-mapping: implement DMA_ATTR_MMIO for dma_(un)map_page_attrs()
> 
> Make dma_map_page_attrs() and dma_map_page_attrs() respect
> DMA_ATTR_MMIO.
> 
> DMA_ATR_MMIO makes the functions behave the same as dma_(un)map_resource():
>  - No swiotlb is possible
>  - Legacy dma_ops arches use ops->map_resource()
>  - No kmsan
>  - No arch_dma_map_phys_direct()
> 
> The prior patches have made the internl funtions called here support
> DMA_ATTR_MMIO.
> 
> This is also preparation for turning dma_map_resource() into an inline
> calling dma_map_phys(DMA_ATTR_MMIO) to consolidate the flows.
> 
> > @@ -166,14 +167,25 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
> >  		return DMA_MAPPING_ERROR;
> >  
> >  	if (dma_map_direct(dev, ops) ||
> > -	    arch_dma_map_phys_direct(dev, phys + size))
> > +	    (!is_mmio && arch_dma_map_phys_direct(dev, phys + size)))
> >  		addr = dma_direct_map_phys(dev, phys, size, dir, attrs);
> 
> PPC is the only user of arch_dma_map_phys_direct() and it looks like
> it should be called on MMIO memory. Seems like another inconsistency
> with map_resource. I'd leave it like the above though for this series.
> 
> >  	else if (use_dma_iommu(dev))
> >  		addr = iommu_dma_map_phys(dev, phys, size, dir, attrs);
> > -	else
> > +	else if (is_mmio) {
> > +		if (!ops->map_resource)
> > +			return DMA_MAPPING_ERROR;
> 
> Probably written like:
> 
> 		if (ops->map_resource)
> 			addr = ops->map_resource(dev, phys, size, dir, attrs);
> 		else
> 			addr = DMA_MAPPING_ERROR;

I'm big fan of "if (!ops->map_resource)" coding style and prefer to keep it.

> 
> As I think some of the design here is to run the trace even on the
> failure path?

Yes, this is how it worked before.

> 
> Otherwise looks OK
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Jason

