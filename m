Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F4DFCA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:54:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B32B9001C2; Thu, 14 Aug 2025 13:54:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1631E900172; Thu, 14 Aug 2025 13:54:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02CB89001C2; Thu, 14 Aug 2025 13:54:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D20B2900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:54:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A96975916B
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:54:53 +0000 (UTC)
X-FDA: 83776113666.16.BDF8C25
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1507D4000F
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:54:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uzys0fct;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755194092; a=rsa-sha256;
	cv=none;
	b=tk9T1Ihmqk0GW2GpoCC2HnAOvzgXJwAb8MegUiYa+on91/aTNCGxY6S88ob145IqE80woO
	TU/KiccxBa4bXla3caPDb2SgCvrZD/4qI0tUwAljpBxc0rJ4opFp3NIgPgnBezX6C7UYpY
	ktywe8c4lMi7UjNxceGjV84D1sssT9k=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uzys0fct;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755194092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+qkotKjA29uhp00A8rkqHQXkiTzDF9Aqh1SY8eRdGdo=;
	b=4jlBYdZwrxTK1IlkoLsJStZcP4W6Qi7Y/OXeG4WOYxhJqsE85IHiK28MfF9FCWEzyYqfJR
	nyy3gRLpQhymh8xIY8QykV37x+qTHW3uzgUGv6nwgMVLtMvlmt51pG1tKNLzoHCYL0oi74
	Wb8W6nyg6eW9Ozq/caaOQW2uLEzN4t4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 5A698A56B3C;
	Thu, 14 Aug 2025 17:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E02C4CEED;
	Thu, 14 Aug 2025 17:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755194091;
	bh=dJuAJRFwFKXIJkybNGJNx5df3xqMYXp7O5ndEMDZg04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uzys0fctaKduRyxRgFcqqWB9TJX8pmDHxUeerVSmc9hyJder8/7gFl3wfN/unHZ2C
	 S5CzVr+5GYaSUOFs9bmQ75Ecqcu9Pu4Whd8sbfjlhm2XOYZLIhCbef/DMcn3CTb45+
	 GiznNYOI/+RzFM5PLcTzNPRM35pJT6rtglK+OdmUleRbcbftiNpy2RaoYN+398HPlI
	 EdMAoWucl5y3/7eOxc13vugzgtDg65qJbFLVFBCCc/G5s+GnSm+p2hysDhRiLfbghA
	 f5DgNGtveHYzPp98rPtOh2sXpm5HgOwAFNALlZh24t/cDF5EYiXAKJyn8L22WCuZ0B
	 PilBrOf3zwuYA==
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
Subject: [PATCH v3 06/16] iommu/dma: extend iommu_dma_*map_phys API to handle MMIO memory
Date: Thu, 14 Aug 2025 20:53:57 +0300
Message-ID: <4f84639baf6d5d0e107fd2001dff91b6538ff9ae.1755193625.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755193625.git.leon@kernel.org>
References: <cover.1755193625.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1507D4000F
X-Stat-Signature: g337b9m85wacec78ktfpw9r3i1hhpapz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755194091-472900
X-HE-Meta: U2FsdGVkX1+INRY/Lm1EHC3wW7Qr5b8GjlffDlcRBxKPzpN3K1oKbxBxD/1aeR7xGyFzg6l5gQmwkAvk5YV9c9W5PfnXeYXJX4Ytvu5yyX2JrAXGvQfQewSd778xE3HXAZelKq5Rp6KUSaKVG5fM3s1ggyo23DJsksRvokP/dobRoB8Noa9tObGTpifUJ0UY+Ko/kmq2YIjSVn7IrB90liIDRGhEcamknRI1ryf79pWaTzSWsaJbt35uPTCpo0CgSDfogW3BInEawRtt9v8IDiwrApA09S3jUfH8XxMrQq1npNccqOlK/9UH+9ySFx4h+w8N+nLSJS7UCFZ083Cf61Jtnp0HSvY5pHc3RRryAJCBtnXyDKNE8yp2XZ07gyB12QnENmzO7GKKpwUsejPNUBAH4Zc75oVY4d9+8rGRPcfRsvMKFN69ZuOWfjGLhGIVuC2roopcxxo1XSIRE5gW+OCogiRWmt9MdX855C9vd7I2LHV6eql43T9FRTbLLKhOypWBGmTSn2IWku1V9qzDBs1wC83TM0SztVk+DbbJZfhJOXiZPSHTkIaWqC2mB9zdor1UkoTNU7bsS4c99VogjUWxUMvDyPmxr8DkGKne8xs8tySPR5n5oOU2OZi4dC9SZZWtgk2s0QYlMokZhEKkTSgS/U2gmM8e+ALjSGhRClml6836k/u2NPf8rE4o8o1s3sc0+KMt4Ke2FIbdPD+om6M6a5Lpif79QBue+i/7T42bTq7rZNiPYxMGc+eCc6YkNOh0z3j2C/cIQ9is22FZLAsnSKe7jhWjobpNAFdX9EH7APGbrFIOGc0szaRbC7xbsOa6mTGBmXMu73PYVXI6Zti5NNG4Cyuf/MIspexKT+trWEISFYPVjd6Yx5ITR17cD1UgxpKFivfkOXxUsg0GWpcpaEkKJKqlgds2RS3BOmlK9vQF8m7x+ST6e+lMzY/tpu+E5Qle5/GkQPFXQoK
 8FAXx5M8
 Sqy3uRB3WkIEs0knYHz92BFKsrXhI6jA+e7XWs3GUWVr92AtHRL95GzBW1VBGrxDMLaBoUPrYKIulJbGdw0LLQUDf/fFJfpQThYYIJ1EekgfE9Mp1z1LPe/uev2j9k79eiPJHYunpZPFBIsFbtm/SrU27krGKukTOqVSa0Ua2TptsCLyo4L//0R13OECT/zUkHLJD1DHk27NJjNpfMAE2Rw6icINVAdny4IVM4sqSt1Fm8uqCj7/5GRqmVeMNH5hjVR8NrddxXKQgJIjiNq/V2BtqBRvRlCodZVN6usiPX8XJERpi9sMnYrM6Dgkxj61gYwdPizVYbWPY1sZObWvDLhrlJ097zFijCgQB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Combine iommu_dma_*map_phys with iommu_dma_*map_resource interfaces in
order to allow single phys_addr_t flow.

In the following patches, the iommu_dma_map_resource() will be removed
in favour of iommu_dma_map_phys(..., attrs | DMA_ATTR_MMIO) flow.

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


