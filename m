Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1193CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 13:28:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C8B68E0010; Tue,  9 Sep 2025 09:28:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0796B8E000F; Tue,  9 Sep 2025 09:28:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA9C08E0010; Tue,  9 Sep 2025 09:28:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6C638E000F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:28:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B31C61604FD
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:28:37 +0000 (UTC)
X-FDA: 83869791474.27.6932688
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2078420004
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:28:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wi8yN8n2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757424516; a=rsa-sha256;
	cv=none;
	b=51STtf9UpJOTFIp/4nQMjKQROZlW8JIKdbpPyq6CcDgXy00WGltYmfrl61Ojuiru4ggC7s
	XZmmqn2UoHrOQl8Cjtzo3hHpc9blh74mUkPok+R9hnEc8vIVwAv9bXZLTSiZwCWS+b3KRr
	PyvgF2NkP8JFk4VQFy9oBPnrQVu1Yx4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wi8yN8n2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757424516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RXCiWDrz08Ry9Yhr+EUVani0x1mu5TIrqAP93p3Vkfg=;
	b=TwVD+QchYiwH2ILsyGg6h13IzNOb3+DY1/NuxBv6r4VrsN52T19NK4X3AUd9AhVWuZ0LLr
	Eu1aD+ced+ctWKrth48UYzaqReNZqaEmNvUlsi7cTEMul4EeRS/a/w2Y42xO8bL9I2kDbm
	7R4qzHLWGqPLmV+k7NpKKqbV/S3dAc8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A8146021E;
	Tue,  9 Sep 2025 13:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9385AC4CEF4;
	Tue,  9 Sep 2025 13:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757424515;
	bh=A63sCU1us486CfnvbybDoy2DvC4mWvbNv9XH5e8Grdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wi8yN8n22gc8EHttTIy6nTDZdyyXoXQ/Pldkc75H1b6hLRfWF7W91QongjbmQvASx
	 sv6rDJHl2MJSbLxPwGa3dmCMbrX9j01Em95NpNXM4cIDH7UJTEwX83geF/iBTaLFuP
	 z9936grIMWYOudFZFyWQaaATwNqlVd7G9UV/xV6GFF/aAOUbPO06Q/ST7pKHRaUbg7
	 zvG59sLnQHkzA0x5NeN55UQGwo5PwCywmKPSo//7gII1NKJ57XsBVOqW3xGebHV5Ho
	 GeffiYBcLO2jLid5aJ6HsuI1v5dL0okkwlGaoFgMfg5DtNWLYRKj5r9JHHMSD8Ink5
	 CRsGJPvVMTubA==
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
Subject: [PATCH v6 06/16] iommu/dma: implement DMA_ATTR_MMIO for iommu_dma_(un)map_phys()
Date: Tue,  9 Sep 2025 16:27:34 +0300
Message-ID: <acc255bee358fec9c7da6b2a5904ee50abcd09f1.1757423202.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757423202.git.leonro@nvidia.com>
References: <cover.1757423202.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2078420004
X-Stat-Signature: r53dqinx8r874q7ton3qriqaeet9qgxj
X-Rspam-User: 
X-HE-Tag: 1757424516-561831
X-HE-Meta: U2FsdGVkX19W4CTybPkeXEnX9MgvWuppO2wV8emtVCsrxcZxCyQhHTsZ6SakJwQtl+u9MyzB8KWSxMfkcIfFwuiVHqM65x4tOhKOYh2T6wtfOfmtrgYAlNonPpifFOUbzWZaAmE89+qeyGgqw3jsPo1+P8tr5wzEQK7a9bfBZqk8DlmfcHsW23iGrGsJMTxsYtf4l3d6yjNEMRtSvVq0BS+g/VP59mE980dXq//oK40HwL6wvQcTZvog9y3TIvt+Xmu/eI+4Mu6P7hxSZflu0Dl2VvM+z5j0DySrNu4/6mK04Mug4TCO4oqBJwJTRituuDcOYROujPq0g3nLDEAARqj+EnKCaMjCI5OrhpXJxb+ARdPM7vzdy8Cex3oNlxbupyY9ZEh7AzYDUibByQyT/LHHIOWfs8nmP0M95S9KkDf5+9fwXyLVcX53sklHpB5xD0HAlXyx4o6Y3MiX5D6LbuBcdJSkkCZLWYcZvejsycOdQwHJBYWpPLuKjoSw/wnKRafJrv0mvxBLRV5R21RSUTxMD/vNh6Hb+Dss6Ugc/RXY7Uetcsk+p0qPzsSEjFUbF9almvFmjBqlrY3WJyW9hvEigeMIEYHUt71j6zVelmTU11OM9l70bJLBddu/PaexaTFWD40B7CQBBheSrEUPyA+5sTkDmX/QHqPyC1WtPX2i7AH2SamryPUbJVsrtGrYYwk/1ucqkWBCHfDHgLv53fjMIMkwDkvEsgWj7n3vhMD2xPPcMUe3m7P5mBv2vhtIHcJkqgcZzsNk4SxP+VDndpeWfdQ+r/sEKlKtc/wyqggEaS2xtMW91tyhQypdzcGoAxrTvk4Wpwwc9l/T1wuq8p1FqnYyYEOKmYmVYU/F94IN21pdxot5QlZE16BdDjRPgpg0wnx5dfOXpLYYEm/i9FSqKZxq1P4JdoRnFgOr7nfEHQRBbkMKSMmK1UM1WCf5LCvzSjNOY5FNeF86Xkf
 6toCPGgf
 f5q8o+3qQ+O+2s+hVq8Ur90csOXdf00cGMyBVSa8AkCAgt+6saE/69E0SoSC61YYVYEi92wGywoCtPa1yCDp0u24pEDkin/DqLS6ir15++QCnRriJCrx1Vc7BRz2MEwbffpYiWxcWKe2QWD0jFgT+9dZrcRJlCmkYoB/e2qGPgo1MSplac/On0CsRbIb/a9hbUDTzFIzlO42boPDwaJYijzbflnc3V/7tHXcJzjP/13lFY82AX1HDxgVRA52lO+V9rEMr4VjDo72S9JAWuK+3rs6RZqzCP+q808nnjqNkuTPiIqFdwlnx0WfGdw==
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
index aea119f32f965..6804aaf034a16 100644
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
2.51.0


