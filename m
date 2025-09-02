Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61F3FCA1009
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 09:29:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBE018E000A; Tue,  2 Sep 2025 05:29:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B95768E0003; Tue,  2 Sep 2025 05:29:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD2BF8E000A; Tue,  2 Sep 2025 05:29:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 999048E0003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 05:29:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 53D0A140AB0
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:29:30 +0000 (UTC)
X-FDA: 83843787300.20.1CC7CE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 873AA180010
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:29:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u+YP0LKc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756805368; a=rsa-sha256;
	cv=none;
	b=dbfPqwnMv5HrN92cqRaYKLrve8+wwQo4FelNnlse1kLVAXlR/L0l5ZPAQ0WVB70Uelae+C
	fAUhYY2QHuMjVuWVpXRveSBx5/RN5zQrrm0ONH1xsWME8Lh85b7xdoCByn491ClHhod/Av
	IouDx5BBkF7PRwFkkUpTX/doB8L9mPM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u+YP0LKc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756805368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RUP9TtL1xAhoFb9CaSEK22nm8Sa8vb9894tliSqEP4U=;
	b=Ja/LGyXE3w5Xsk63EvhFQ76HqwHDheXC+hwJjDFyQcFCg0zUj9WQt7zTxEPTr4kexkDs5X
	kK+uXTtbQMaTY5bpFpnF7UlVc7BGQXlZ21lzWGbt4WMn063wkQnGHfp/E2/fipL5PLs2xR
	xsSz6QpaEgUM9gr9s9Hw2O+E6EuXKP4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6678F43E7E;
	Tue,  2 Sep 2025 09:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793FEC4CEED;
	Tue,  2 Sep 2025 09:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756805367;
	bh=DnDVES5Jg8WrIGoMPMfvxV9Wox20mcRcpnotwmcTmTg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u+YP0LKc7Ca9KSEGyhHI9LWKXOpYxDkmlx+xi/d94i28PXwnbkADYdG/kMj0eiK5B
	 zd/GooYAccyXKqdo2LtN0swNMmhiizGQIgjHrkSZ2IAXK/1jBPSRk3StbcZycbdrVP
	 g5quZtmGQMVEWVOV9clnOLPmMIcFNqak1dVeFhnzWaY1VIAyIlM9TCnw1bUSOb10fT
	 eYPBFQEGyOkOZzS7K5YPtS3dmkawe2LLvJU33SWPAwVjDdMQDDLsS8LD6Qfe4rZdHI
	 wki/IP/V+av0oWZTHcazqMPHDSPlXAIhw9qhWxKa10uhggFEbKZZEF+GYaHO+zcGYb
	 634HFrNZvr1dg==
Date: Tue, 2 Sep 2025 12:29:20 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Abdiel Janulgue <abdiel.janulgue@gmail.com>,
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
Subject: Re: [PATCH v4 00/16] dma-mapping: migrate to physical address-based
 API
Message-ID: <20250902092920.GE10073@unreal>
References: <cover.1755624249.git.leon@kernel.org>
 <CGME20250828115738eucas1p24f3c17326b318c95a5569a2c9651ff92@eucas1p2.samsung.com>
 <20250828115729.GA10073@unreal>
 <26bd901a-0812-492d-9736-4a7bb2e6d6b4@samsung.com>
 <20250901222302.GA186519@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250901222302.GA186519@nvidia.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 873AA180010
X-Stat-Signature: 9edua8dw84qzbkt3tw6n44ay6s8pi7qf
X-HE-Tag: 1756805368-111420
X-HE-Meta: U2FsdGVkX1+QDwCKd8wlgc8RDq1aga21SiWPf7leh8h9aWLdCRM84wFzTPzWRDQopjiwSccMnwaEQ1CrfmgK0BI6/K7jMTvMiqdkz133X1wCjK7slemHsY2nyZHA5JalMkNHhflOQ1ydE9e2CBdKPlf1n3xM17nMouew+y9RUZZfoI1nDMsKnVjBaGtxZQ9K9DTBULdw5fwk/PBmdLQjm+zh4n0fX6uKK+CVWQJZXYKNTxO2+Xi3Gl8ShWdu5vUz7l3SYGShrnABIUs+y9SJNRoIp3MGyR3GJo8U5UdSE4h7wYb11v3OUTLpouxHT3BF3ms0/IZAM8cC9H+DouhvEDfJHHU64tgYuTqMLv5T0ihwfDTplp1DhiXNedTEp3cCbHD6a3RUAzPSlP1P16VVjHxabhYcwVSiimN/sendvMI3fuUHlKWgwQdQNGIhslEJQ22B2x7nt4GelMs7JpxfgWT0hJqqUNhYuxrvbmNX5UcjiDfBBBL4RXRvG/nC2ehKGVmFhaojcRVBHNR3n5oThW5zxBEWnp3JoXadUSCgpErFSc6OvykMay8+NxOwZhOBVI1MMcB7BADlZ8vJl59VYIKUA3NjFoPwdhtjGkBkFT/KS5uxcg2hBJZVtf4S/E5N/G34IWMo5vKaZdt087LoG2P+x6zhlGx1yyIzdOseH1bUlfdXy5sqX63oNQQ4H68T++fG/w5kU5zQZa+lURnJVRrSp6becV46dLyBKje5VFkLiJNK4n/+2toTbEkVsRQLEZRr5yS3cN12fi5osoRSez8iq8mvJ0/Xr3fuAoXbwlgk3yBoXBPeHEstbw3vEuWukUqUJN0Fo25LczBSCtzfUZw6XwCly1rGVFqAAfU7tusCovVyRAHQiXe+DT+lKwMJ+7R0YA7IZ8kpHz/VVkYetCKKf/ZcwUd9klzDF6G9Z+priEath8hL9IBNL0k8/ngJWezS7+BZ1tcv8faouSw
 liFwtM16
 6u7MlCTsr34ikscd6ueWdYK8JWBBwU/ZBNpKW+JktH3it3xu7sTlApmUGaj8xM14v2OuqYf6Tbo4jy0PCKQLP6v1QLcYyKmp21Hb9+rLHDfdqNRNrzsOBKzU4XpZx4QStJXkLFUfx2uw6Ythwwf8Xl4ZGkY3YuaHV57EsWxaMvtij5upb9fGowdNZqgPXNnsp5LxmhYaUMWNWSGb5JXh6FwrnuZCRgXwY3LxtYM8eyV9DV1/8aElhIL7hQL+w8y8LB+6f5P92ptL9RfqmrXNbUVdkl/y6HtiaD6GYLRrsHlF2NQbXHMAaWsHF8jTVrTPdPDB0ebX+251gPep0jiz64wKF03vBcbdGCuRvnu+zQN4XoWahvK33+w1SVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 01, 2025 at 07:23:02PM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 01, 2025 at 11:47:59PM +0200, Marek Szyprowski wrote:
> > I would like to give those patches a try in linux-next, but in meantime 
> > I tested it on my test farm and found a regression in dma_map_resource() 
> > handling. Namely the dma_map_resource() is no longer possible with size 
> > not aligned to kmalloc()'ed buffer, as dma_direct_map_phys() calls 
> > dma_kmalloc_needs_bounce(),
> 
> Hmm, it's this bit:
> 
> 	capable = dma_capable(dev, dma_addr, size, !(attrs & DMA_ATTR_MMIO));
> 	if (unlikely(!capable) || dma_kmalloc_needs_bounce(dev, size, dir)) {
> 		if (is_swiotlb_active(dev) && !(attrs & DMA_ATTR_MMIO))
> 			return swiotlb_map(dev, phys, size, dir, attrs);
> 
> 		goto err_overflow;
> 	}
> 
> We shouldn't be checking dma_kmalloc_needs_bounce() on mmio as there
> is no cache flushing so the "dma safe alignment" for non-coherent DMA
> does not apply.
> 
> Like you say looks good to me, and more of the surrouding code can be
> pulled in too, no sense in repeating the boolean logic:
> 
> 	if (attrs & DMA_ATTR_MMIO) {
> 		dma_addr = phys;
> 		if (unlikely(!dma_capable(dev, dma_addr, size, false)))
> 			goto err_overflow;
> 	} else {
> 		dma_addr = phys_to_dma(dev, phys);
> 		if (unlikely(!dma_capable(dev, dma_addr, size, true)) ||

I tried to reuse same code as much as possible :(

> 		    dma_kmalloc_needs_bounce(dev, size, dir)) {
> 			if (is_swiotlb_active(dev))
> 				return swiotlb_map(dev, phys, size, dir, attrs);
> 
> 			goto err_overflow;
> 		}
> 		if (!dev_is_dma_coherent(dev) &&
> 		    !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
> 			arch_sync_dma_for_device(phys, size, dir);
> 	}

Like Jason wrote, but in diff format:

diff --git a/kernel/dma/direct.h b/kernel/dma/direct.h
index 92dbadcd3b2f..3f4792910604 100644
--- a/kernel/dma/direct.h
+++ b/kernel/dma/direct.h
@@ -85,7 +85,6 @@ static inline dma_addr_t dma_direct_map_phys(struct device *dev,
                unsigned long attrs)
 {
        dma_addr_t dma_addr;
-       bool capable;

        if (is_swiotlb_force_bounce(dev)) {
                if (attrs & DMA_ATTR_MMIO)
@@ -94,17 +93,19 @@ static inline dma_addr_t dma_direct_map_phys(struct device *dev,
                return swiotlb_map(dev, phys, size, dir, attrs);
        }

-       if (attrs & DMA_ATTR_MMIO)
+       if (attrs & DMA_ATTR_MMIO) {
                dma_addr = phys;
-       else
+               if (unlikely(dma_capable(dev, dma_addr, size, false)))
+                       goto err_overflow;
+       } else {
                dma_addr = phys_to_dma(dev, phys);
+               if (unlikely(!dma_capable(dev, dma_addr, size, true)) ||
+                   dma_kmalloc_needs_bounce(dev, size, dir)) {
+                       if (is_swiotlb_active(dev))
+                               return swiotlb_map(dev, phys, size, dir, attrs);

-       capable = dma_capable(dev, dma_addr, size, !(attrs & DMA_ATTR_MMIO));
-       if (unlikely(!capable) || dma_kmalloc_needs_bounce(dev, size, dir)) {
-               if (is_swiotlb_active(dev) && !(attrs & DMA_ATTR_MMIO))
-                       return swiotlb_map(dev, phys, size, dir, attrs);
-
-               goto err_overflow;
+                       goto err_overflow;
+               }
        }

        if (!dev_is_dma_coherent(dev) &&


I created new tag with fixed code.
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/tag/?h=dma-phys-Sep-2

Thanks

> 
> Jason

