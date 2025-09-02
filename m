Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F940CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 14:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D9EB6B0028; Tue,  2 Sep 2025 10:49:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B17B8E0017; Tue,  2 Sep 2025 10:49:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C7708E0016; Tue,  2 Sep 2025 10:49:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7C9336B0028
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:49:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 448471A0186
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:49:43 +0000 (UTC)
X-FDA: 83844594246.29.C596880
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 832D04000E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:49:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JZSrHfV5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756824581; a=rsa-sha256;
	cv=none;
	b=1Y0B/WD3En+cQmWmre9+hyHBuyeCDfVrZff50lofPLR90Mtd5GhsTOdF+ZXRz63YP+ikGj
	hzVuYeNS0Ay34Imu3mJQzetGwUwVGKC+vo2kBY9y+8WAFqK3TwJ9GHePB2ZcuqnzBgp4yB
	QHvV8RmTQjtHNXaoofMOpsWx17gNFGc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JZSrHfV5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756824581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RRu8Lpt58SWOttFC3+Kc87iiguBxiJbGcCvLScKWJG8=;
	b=2AMOIP1vbnKEJhmMgVRwrZictujBAEK2i9wPjeoyzBbgD4GFNYf5NjesorCutrmpx//UbF
	SypLJdOuik5loLjA6ZNjtHM8e5MNWtMNNqBoJ15RwzRogr3Zf2nWz+T6Trw3APAW9d7L6H
	4QtthgEkfvRLEfEhc4h+xLzFJN7wHVM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B8DC437CE;
	Tue,  2 Sep 2025 14:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B593DC4CEED;
	Tue,  2 Sep 2025 14:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756824580;
	bh=RB2ksoieyLntDs7HJ/RFuf6vwP6H3wdrcrPesmw+pyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZSrHfV5RjgP6FwDhcPDrLH1lW/wS4YlLapHJysxuEeYKBdTeEA7mwHWta+DUwvDK
	 8usdO9pm0G9OJcPH2r6xdHblIJrIO415RfC5Jo9IYcWrcDkjpHn2FwnkLHPhIz23St
	 wXHYoacDeswL+oFmO249wc5MuSyna3BF+sSD/rKFuhG8BkS8Swzg+mJ44CRMdKCVjJ
	 JT5Y2NQNPc+7xnLzw9pSQotk1nGvp4p1upES9s3UQSikhPHPq/nquZmZaXUq0AprZi
	 s3B+kTchlbCY1zBP+cxrbq6M9+mc7YC1+9T3u/HEsQcoDp2oijrmaAzD/IHheWAhET
	 7nxwjSwvkkL9Q==
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
Subject: [PATCH v5 09/16] dma-mapping: implement DMA_ATTR_MMIO for dma_(un)map_page_attrs()
Date: Tue,  2 Sep 2025 17:48:46 +0300
Message-ID: <098a7aace5780f8ad504ce021e7731dfe1f82dca.1756822782.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756822782.git.leon@kernel.org>
References: <cover.1756822782.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 832D04000E
X-Stat-Signature: o5n6y79xdfgzdcwinfdqhd7cjk5jfst3
X-HE-Tag: 1756824581-796301
X-HE-Meta: U2FsdGVkX18Wg5mRm/wrpmetDHPtAb9psVeb6GkwoA/WtM1xTmIB4VJTsuwqQDsodtb2bGPUyE3by/GDClWsiU9VO+m174XyGtMschVkVqCUW7gu5MMTxFHwjIdX8BHrI/hFNBakZNI9ED36n8DE0WzN7Kpkm1kFKQGF+lXDgAS1dneCsmp9wUFXdSZ+kaqd9DVIQ5dA3+wSYfOaria/kF3YZ6AMF+Z9VHhB6feZuqshbYzJiPwQiST+6pkl2vbh1cTsqzXtk6T7f4VSnrqzGHIDH4w3khAqvMxFB/XUErhKoAe5GkMB9OALnSi45JS5UdIFi5HQaV0Tt0qvEcGbefPJnxBB5uEpTA7RNY6Len0YIXLZXTFw0kcGeyudeC1YQsSuxXJf5ynbyc9sFyCAR86nThQpA06NNSIqRncEMLmt+ZTDZjcmo/denvrOiHpzMlRDlqAPknB8T+9q5N3EVO4eC1ZokBjJRau6UQaLs89u7XYGCq0dFx4Xw81fex+H9M+X2/o14cXQyvMPkNpgXFIpIK8CeXr5NhMZMWwigCL1PqlR0d7yIczZOoT/QLENXEWhA7pRe2elKoyUs0AtYXqfv1p/JchugM82zu2z2UbJcTohVzxcOVV1wx4lXrksdDq6Geo7SgcchJ4pZlxsd1CtBvLzVhYG7uupJejgXzhYtxXgH6TS/5TNOrTjQKtTk1CvtqPh+US9Qg+/p1J8Rz5dxvY6eZxDVXL/dAoaafLHL4Jm0xB6AhyRlhm0NQuCzJwwhhfoQQcBZeEOz+/aAf9YoccLlWruVL18Wj0y0Lvw6v/eY2BuKV/dKFoY1blLekuWOfk1D6uqEyS/Lf1TAY3LLrEF76aeb1l/ETx4yDijkICu7iN7UV2r7uXhfMitP4vXT8VXHx12Ei+z5TtflxrGu4fXotFlDURJcSIg1HDX8xoFC/Q0DbfwKq2USWw/jVwtHlYZEZg6rbUY0Lh
 N6X0lSIG
 F/ody749kf5AUT4gOoqShTOUn2bo0H93LyrLtOBSJZG8EvVRcN5eDH5y20iB2YUUQo5f19EiSKRRDSvAx+njp0XHrJ2VjPJJ46KolHpOgqUHx5ezsGWpAhk0ZVdvIDstfYM4sLKNOVxtnt1mmQwoMqX6Ax9YoNArNqNy6432qYrRuZjs99DKREtKbn5sJW2cnu+VGy1ZVhjpKrfD/vQcaC0mYtakisb76f/9ykLF0+mUmfYxkCbqVvRILFDy+AMgY3C0X3BCYyQNRrKTY1zS2OXTr0SStbQwAV2hLW9hq40FYQLAmlrGTBrbKk3JCPlKlbC8VePfdokI1TMoA17Uu1ASGOy180QBbcnV/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Make dma_map_page_attrs() and dma_map_page_attrs() respect
DMA_ATTR_MMIO.

DMA_ATR_MMIO makes the functions behave the same as
dma_(un)map_resource():
 - No swiotlb is possible
 - Legacy dma_ops arches use ops->map_resource()
 - No kmsan
 - No arch_dma_map_phys_direct()

The prior patches have made the internal functions called here support
DMA_ATTR_MMIO.

This is also preparation for turning dma_map_resource() into an inline
calling dma_map_phys(DMA_ATTR_MMIO) to consolidate the flows.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 kernel/dma/mapping.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 891e1fc3e582..fdabfdaeff1d 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -158,6 +158,7 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 	phys_addr_t phys = page_to_phys(page) + offset;
+	bool is_mmio = attrs & DMA_ATTR_MMIO;
 	dma_addr_t addr;
 
 	BUG_ON(!valid_dma_direction(dir));
@@ -166,14 +167,25 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 		return DMA_MAPPING_ERROR;
 
 	if (dma_map_direct(dev, ops) ||
-	    arch_dma_map_phys_direct(dev, phys + size))
+	    (!is_mmio && arch_dma_map_phys_direct(dev, phys + size)))
 		addr = dma_direct_map_phys(dev, phys, size, dir, attrs);
 	else if (use_dma_iommu(dev))
 		addr = iommu_dma_map_phys(dev, phys, size, dir, attrs);
-	else
+	else if (is_mmio) {
+		if (!ops->map_resource)
+			return DMA_MAPPING_ERROR;
+
+		addr = ops->map_resource(dev, phys, size, dir, attrs);
+	} else {
+		/*
+		 * The dma_ops API contract for ops->map_page() requires
+		 * kmappable memory, while ops->map_resource() does not.
+		 */
 		addr = ops->map_page(dev, page, offset, size, dir, attrs);
+	}
 
-	kmsan_handle_dma(phys, size, dir);
+	if (!is_mmio)
+		kmsan_handle_dma(phys, size, dir);
 	trace_dma_map_phys(dev, phys, addr, size, dir, attrs);
 	debug_dma_map_phys(dev, phys, size, dir, addr, attrs);
 
@@ -185,14 +197,18 @@ void dma_unmap_page_attrs(struct device *dev, dma_addr_t addr, size_t size,
 		enum dma_data_direction dir, unsigned long attrs)
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
+	bool is_mmio = attrs & DMA_ATTR_MMIO;
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (dma_map_direct(dev, ops) ||
-	    arch_dma_unmap_phys_direct(dev, addr + size))
+	    (!is_mmio && arch_dma_unmap_phys_direct(dev, addr + size)))
 		dma_direct_unmap_phys(dev, addr, size, dir, attrs);
 	else if (use_dma_iommu(dev))
 		iommu_dma_unmap_phys(dev, addr, size, dir, attrs);
-	else
+	else if (is_mmio) {
+		if (ops->unmap_resource)
+			ops->unmap_resource(dev, addr, size, dir, attrs);
+	} else
 		ops->unmap_page(dev, addr, size, dir, attrs);
 	trace_dma_unmap_phys(dev, addr, size, dir, attrs);
 	debug_dma_unmap_phys(dev, addr, size, dir);
-- 
2.50.1


