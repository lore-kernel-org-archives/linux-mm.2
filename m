Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A928CCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 14:49:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14E216B0029; Tue,  2 Sep 2025 10:49:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FF628E0017; Tue,  2 Sep 2025 10:49:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0158B8E0016; Tue,  2 Sep 2025 10:49:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E55746B0029
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:49:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B9D90B6EA0
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:49:46 +0000 (UTC)
X-FDA: 83844594372.17.6224997
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2899920005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:49:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VKECAb+7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756824585; a=rsa-sha256;
	cv=none;
	b=2VJRt5Kot0c7P9zMizLJvxaAE+fGzHUOhYgvQ2D9v5HeLOKUZcT1K5uZIPQFEEJ05ONX0o
	ukcQ/IahtL0HB1GDrtaYuEl1QCr8JIv+e5OtNsmctPUnhQspMBrIErMnmuCk7uu391wZGZ
	q79lQMI69Hfw4SxoZ9xnWfWLYQhpg74=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VKECAb+7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756824585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6APT/ghoDYbBmlId4Kq2wmBlk0N08YJMkAHkbYOh2K0=;
	b=Tofm87awmQLQLToywYk/8DArJ14cO8Z3M5G8VotcI4E4OjGGXXqHMsQHuXggLQ7Q/Na13s
	SKWhglqkV3Z7540TFDB6ndunoIFWULkYpmK65HRl3VZdo4fPMZT6o0owR2tSFzBNj/Hju2
	sE8CDMhylAmCBS/JzTCDxxrFvwINO7Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A23706021B;
	Tue,  2 Sep 2025 14:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66F8C4CEED;
	Tue,  2 Sep 2025 14:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756824584;
	bh=2/thOeJ4NuvxSVVC3hxw/9bIX2PIBvboPgYtgi2/VE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VKECAb+7Sse52mYJL41SXOrXDFGCRiIF9tuTww+7tx8TF5Ejmreeh3HY00rHaazQn
	 aOTh2UXi0X7gB6XKiPuY2KJcOfZeTrAYxYVSBqbTN3F5Fl7eG0quZrJ/k42DqVVCsr
	 GwhvRXbAMz4CU6yoxiw2WzZdasqegGQPNyQKGXTE5/3T3HPR4sL/jxhRLhqbGHtIqp
	 Olwm6UL/KtvfA0rjsrKrcjQo7JfNFlEx+nnbC0Q+EsvdfGHJP1R+qDhsLnUhQ/x3ua
	 ilF/FQzSLWqW8sNqDmIhrghX9qmh9Vix0gO6Gy0buRmc6/knYwd5Ib7hdXL+VxUnMe
	 /kIUohye23SrQ==
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Danilo Krummrich <dakr@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	iommu@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com,
	Keith Busch <kbusch@kernel.org>,
	linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-nvme@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: [PATCH v5 06/16] iommu/dma: implement DMA_ATTR_MMIO for iommu_dma_(un)map_phys()
Date: Tue,  2 Sep 2025 17:48:43 +0300
Message-ID: <615b270dc8cd285c1b05cf3b9d3a969487049a5f.1756822782.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756822782.git.leon@kernel.org>
References: <cover.1756822782.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2899920005
X-Stat-Signature: nkjbp7g6di94xwi3sym743afhxg9mf51
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756824584-622190
X-HE-Meta: U2FsdGVkX1/LUHeqqW+Q2U8N7d+PNkIcnf7mSe0hmpUd2OpU9l5Px9CisaKPSzUAzCR5DfKvJXe9LdIrH45w+hgOQrua+CT5Qhp3oVN2oVLJ8ghyu3S5q5yHyzpvpiK0rT9AILp2usiIZiiMQwNDYt//Z4Bq7fYVmwlZAUbVyw+MUtlbIB4Nv8ou9SZi2BqE5jfALImZnK2HOg6BN5Wvw7no988p4ACHX6w/OYG+QZn5AOpcG6SYWlJ4UxMkscLit6yKJ+U2/8HsoYldMqxwc9yEGjv78u7Af3MKOUH3InfiZFdgeyzzAmqNALfP//zJn7CRQIBAzalBBiCt+UYf1VbAZzLLJuGffJVXbuoAwux4oS31odsONqLXXRNTwGd5/W6Egtt9Dnawc6ckFhA/3H+ilJYZQIdXSEgWV8uoz/tckB82hPE3HkZ+9rbAWaPNSXo4vYIF5YBvAXfhsvc1vhAcG+51zlOZb6Xk4zr0PV3tN5ZO/yGhfFStCiYxSYjtTmA7LAkwoSEYXzFmfjTFdmTV/gdNbzmY39B63KwYRpFMTUuHarK2oBWvA58O2a+ILllEgBQlVdJ62kM5k3o2CjaX94kgA74QwBoThRKK+y75H55PDTsLZ1JezERPO5YQYYOsASaYHBL//IRBp8tv0+ssMLTJJEB4KnX4PTHoYclr8TBpjJ/EDejXMetKGUXerllZW50zqhKrKjXEzOyiOjvl2gL54ZiGst0+myjfrIMetMOk0bzFMdd0a/pMWE+ZdX9Iw53rREZUKiztlYC2f4DK3QJ67PqjXHGGH6KxUxvqcKL2WeERXnpFx+wNEQG03CFpqvmtgdAwrZ/Z6DZkfldQ8+jyaVXz7D3l8Fztzv2OOyeuTTB6Q6oR7DcUZoZ0T4SQDOoVgtQu6qW5iNPgwQ2qkHu7t30UbEksbU4XTiUQ+uQKxBr3+JL/hcJzPYfrAOq1ymMOlm8WfEWBiQm
 XSy+uok7
 qCNhCVF94tvcC1mDyEjLEKT317ZozTf7Z+L8T8e8jKHkZF+WCRw0Btp2iLpdbOS9dON7R9gtNd2XuLxqEdO/EriRWIIBB6CevwPPG2EZfweJGr400Dg7tpG+6Zppj1uqF6/yzrPiHDws+NAl8omuFkZbsnMe+dqNhHcXRn/Ks6omND9iUfKzYcGwOXuzDLfVEihJoCuts/YqgvDq9mATO6hLZ+uAssrbMOiBcYiH7d7aLo26fADY+O6jAV+ZojbzzIVtTIRMr9dqU3hD+j2+1oYyC6SuNriOryQzcfmpvxyq02iSd/UbOL6XbMFalB6AR6BVxS60E9gCt6uKo6Y4Z20tvIGjI5JrtPUuO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Make iommu_dma_map_phys() and iommu_dma_unmap_phys() respect
DMA_ATTR_MMIO.

DMA_ATTR_MMIO makes the functions behave the same as
iommu_dma_(un)map_resource():
 - No swiotlb is possible
 - No cache flushing is done (ATTR_MMIO should not be cached memory)
 - prot for iommu_map() has IOMMU_MMIO not IOMMU_CACHE

This is preparation for replacing iommu_dma_map_resource() callers
with iommu_dma_map_phys(DMA_ATTR_MMIO) and removing
iommu_dma_(un)map_resource().

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/dma-iommu.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index aea119f32f96..6804aaf034a1 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1211,16 +1211,19 @@ dma_addr_t iommu_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
 	 */
 	if (dev_use_swiotlb(dev, size, dir) &&
 	    iova_unaligned(iovad, phys, size)) {
+		if (attrs & DMA_ATTR_MMIO)
+			return DMA_MAPPING_ERROR;
+
 		phys = iommu_dma_map_swiotlb(dev, phys, size, dir, attrs);
 		if (phys == (phys_addr_t)DMA_MAPPING_ERROR)
 			return DMA_MAPPING_ERROR;
 	}
 
-	if (!coherent && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+	if (!coherent && !(attrs & (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_MMIO)))
 		arch_sync_dma_for_device(phys, size, dir);
 
 	iova = __iommu_dma_map(dev, phys, size, prot, dma_mask);
-	if (iova == DMA_MAPPING_ERROR)
+	if (iova == DMA_MAPPING_ERROR && !(attrs & DMA_ATTR_MMIO))
 		swiotlb_tbl_unmap_single(dev, phys, size, dir, attrs);
 	return iova;
 }
@@ -1228,10 +1231,14 @@ dma_addr_t iommu_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
 void iommu_dma_unmap_phys(struct device *dev, dma_addr_t dma_handle,
 		size_t size, enum dma_data_direction dir, unsigned long attrs)
 {
-	struct iommu_domain *domain = iommu_get_dma_domain(dev);
 	phys_addr_t phys;
 
-	phys = iommu_iova_to_phys(domain, dma_handle);
+	if (attrs & DMA_ATTR_MMIO) {
+		__iommu_dma_unmap(dev, dma_handle, size);
+		return;
+	}
+
+	phys = iommu_iova_to_phys(iommu_get_dma_domain(dev), dma_handle);
 	if (WARN_ON(!phys))
 		return;
 
-- 
2.50.1


