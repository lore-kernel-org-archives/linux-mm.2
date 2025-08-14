Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB5B9CA0ED1
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 10:14:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E7CF90012E; Thu, 14 Aug 2025 06:14:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52201900121; Thu, 14 Aug 2025 06:14:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9BA90012E; Thu, 14 Aug 2025 06:14:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 27534900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:14:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C7D4A117A90
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:14:09 +0000 (UTC)
X-FDA: 83774952618.29.EF2EDA0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1BC40C0011
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:14:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l8H3hC3C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755166448; a=rsa-sha256;
	cv=none;
	b=X3WzzcIu5DaQcdIG+k0zSA6b5kSceAg9Is0rV3sKjhyN0j4MSe64V7xCRyc9vlHsz7fqZK
	g/kxNhPxpDbRyLDmn90njwkB0rsQ4QuTI0JyViECtESsQh9NcK5rsteqKb1evManQTSqev
	v8gFP8zK5cA8uavEcPIDLevgJy46b0Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l8H3hC3C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755166448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kCJU29SWd1OR3k6ZUoBci43zBS+gLO8fdMAUUcFIoOc=;
	b=XgRzrLcQ8LJwGg+VPuaee75idzc3Emf88cvHTlWsLwPRdAbugHiRO4e8pMvXe1XwB/L2qu
	EoQ7UDxLgQ96SYJhjtdli0ETNR0+QQpxgBrPumc314WhCyradbrVZRSpHUQ+3Ui/99vTSP
	Dd3s6DyedQuP3qz9fQZyIW47vlpnAyY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 93F086020A;
	Thu, 14 Aug 2025 10:14:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0047C4CEF1;
	Thu, 14 Aug 2025 10:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755166447;
	bh=0MhcGdVdXvKtqKaQ8KaQcBZJnClPr0/vCjOFn/qCf0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l8H3hC3CjEl6BCwNcqyxvNiYmfJQLYKEGm/RvFitKwNuwx6TJYzahZowNjL9i0Ke6
	 KrX0qziEzGa0F7rawYiszEV1hUNO8e46rgAAwQJjM8EuuhToG+QPmsqhd9NUmg1Cb0
	 MeXaJwPLBdYIxTIGDpAUnVYLuihRZ3Chs1SLe+ElVPH7Pg2KMdTNPvlx5+VrVcBl6y
	 JuyYHiJNs/B/OqwV3LBytYgnPcl6Iib3gLgjvtZoF2joRBbDhky90sPwleJVrTC8BV
	 76Y8J7RmDHpObUCux5+KqewgFwP8W536d8nvOmUOeoda640vtvoD8rd9O+aFvhc9nh
	 rHzyxDvdvQRjg==
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
Subject: [PATCH v2 05/16] iommu/dma: rename iommu_dma_*map_page to iommu_dma_*map_phys
Date: Thu, 14 Aug 2025 13:13:23 +0300
Message-ID: <cd872c32c32bed2cc406ccdde9023b4db155f43c.1755153054.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755153054.git.leon@kernel.org>
References: <cover.1755153054.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 1BC40C0011
X-Stat-Signature: eoup467pb4b3qgziopxtcuk6ze8e1m3j
X-HE-Tag: 1755166447-670108
X-HE-Meta: U2FsdGVkX1+SX5+96E3SvwdKKN93eivWRQZrbEf9xywRgWrS8NCQGid8PxOr7Z5r3QGZMYuYyVc3uyd4GUxSSZUMujzTEzo1oN4lncpZjS4Rl4RE4vgIYQBx6qVzRVv9jrzbRiAJ0jlaSQVh/eWEoG6XSG/PaIpSSCKLHP4MjWg6HbVeI9+IOrMl/1ualZKLJJAdo9dh7fwc0eKfqUOnVgNACxVWaOPxoZ1Zh8ULj7dgSs+FwQwy9IHI/wNT8TDaKxoelWOtlrr2ct/dgNkyuJId7ZSgVn0J2lr5A6F9yHio7KZEL93eMj/qRgW6/89MYaW0uSDz+P8yK00aAFY3ks8QwWn1d44xoeV25ztCWiUw0cXadgbBAE8N/Rv8IPWz1mW1d0sM4QxLBQ6jRt42NRSBlpLHml+DdNiDYs1AgFqhcPgeywdAYS/02tStbRjFldaRdYGJj4gMoe4jzBgGws28P0FaTNVbZOFuf05lRekuFSNkpP82lC9dqh6UNzvCmH4oxmBSGqEx5BVe4skAdp2RUn8o2NG1o+xJwJlFogSl9ZY+7yadPvcRTzPFIA3sHiZEsCyOrb6adM5xbK8NhwTUrX3wftiFvPcF6gLcAA0lPyzRAoAM+cyvMpC8BGVaCLbEEEJ1e6/49fEzayo2SCF9phoWdkt1O/0J68dJT2CB6pagR5swZgu6yLtCajd56S6o8je1rs1Zoth5bHXSWlqSEtyeHZzMEE0BHo0kKyxPPxY/AAi3bY5UvI5fuWzxr2O1Tr+teZpDb22J7rp/Yyk2oHGugvPnElO6m1QSkvD2gdMQmKJUdM8QZcbz/gEfytR5tyScEGVjbv7Wn9rXk2MLg1q2nxxKKgHhogu5eVVFpGAtcbyj0Zhi9UmSNuHUunkwDwnbNt3EpnpDw3Vl9y7WxbZSgcxRcGBwM1mz9hoIzg5/IE6XmHfYbZesacTPf4ShVHDwiW6y0KO+VlQ
 n8ScGXbB
 IxWDrn/wtcvalvX9je9omvukGAC57oRxiMFoNzeNDrD6Xvd/+p/O21V2v38ulYoAGzo88bI7zhFs8nOUKvMG6ZU33PA3W7Owycx/ZKHCUpCRd5TGh+i+VzomKhVO1VUzixSPcjU2xfwJcqA1xtVGT2vyvlFZMFpkoEhOHDIBQo+nErcOxCfLXuliySwkmXkSoP8q0Mso78/LmekWWMWpPo+NaV3zwm1XjkMlz7SmjxjHwjpTTg6SAchStOihNA3OrnyiL9afJNGGt579J84yt/p09B9doSerT3Szki2nIACSlc813GENuPaU+c/wcRrtepzLia8HJyHzGdFtCrSv87JEGUrU0WrTgW6ri
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Rename the IOMMU DMA mapping functions to better reflect their actual
calling convention. The functions iommu_dma_map_page() and
iommu_dma_unmap_page() are renamed to iommu_dma_map_phys() and
iommu_dma_unmap_phys() respectively, as they already operate on physical
addresses rather than page structures.

The calling convention changes from accepting (struct page *page,
unsigned long offset) to (phys_addr_t phys), which eliminates the need
for page-to-physical address conversion within the functions. This
renaming prepares for the broader DMA API conversion from page-based
to physical address-based mapping throughout the kernel.

All callers are updated to pass physical addresses directly, including
dma_map_page_attrs(), scatterlist mapping functions, and DMA page
allocation helpers. The change simplifies the code by removing the
page_to_phys() + offset calculation that was previously done inside
the IOMMU functions.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/dma-iommu.c | 14 ++++++--------
 include/linux/iommu-dma.h |  7 +++----
 kernel/dma/mapping.c      |  4 ++--
 kernel/dma/ops_helpers.c  |  6 +++---
 4 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index e1185ba73e23..aea119f32f96 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1195,11 +1195,9 @@ static inline size_t iova_unaligned(struct iova_domain *iovad, phys_addr_t phys,
 	return iova_offset(iovad, phys | size);
 }
 
-dma_addr_t iommu_dma_map_page(struct device *dev, struct page *page,
-	      unsigned long offset, size_t size, enum dma_data_direction dir,
-	      unsigned long attrs)
+dma_addr_t iommu_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
+		enum dma_data_direction dir, unsigned long attrs)
 {
-	phys_addr_t phys = page_to_phys(page) + offset;
 	bool coherent = dev_is_dma_coherent(dev);
 	int prot = dma_info_to_prot(dir, coherent, attrs);
 	struct iommu_domain *domain = iommu_get_dma_domain(dev);
@@ -1227,7 +1225,7 @@ dma_addr_t iommu_dma_map_page(struct device *dev, struct page *page,
 	return iova;
 }
 
-void iommu_dma_unmap_page(struct device *dev, dma_addr_t dma_handle,
+void iommu_dma_unmap_phys(struct device *dev, dma_addr_t dma_handle,
 		size_t size, enum dma_data_direction dir, unsigned long attrs)
 {
 	struct iommu_domain *domain = iommu_get_dma_domain(dev);
@@ -1346,7 +1344,7 @@ static void iommu_dma_unmap_sg_swiotlb(struct device *dev, struct scatterlist *s
 	int i;
 
 	for_each_sg(sg, s, nents, i)
-		iommu_dma_unmap_page(dev, sg_dma_address(s),
+		iommu_dma_unmap_phys(dev, sg_dma_address(s),
 				sg_dma_len(s), dir, attrs);
 }
 
@@ -1359,8 +1357,8 @@ static int iommu_dma_map_sg_swiotlb(struct device *dev, struct scatterlist *sg,
 	sg_dma_mark_swiotlb(sg);
 
 	for_each_sg(sg, s, nents, i) {
-		sg_dma_address(s) = iommu_dma_map_page(dev, sg_page(s),
-				s->offset, s->length, dir, attrs);
+		sg_dma_address(s) = iommu_dma_map_phys(dev, sg_phys(s),
+				s->length, dir, attrs);
 		if (sg_dma_address(s) == DMA_MAPPING_ERROR)
 			goto out_unmap;
 		sg_dma_len(s) = s->length;
diff --git a/include/linux/iommu-dma.h b/include/linux/iommu-dma.h
index 508beaa44c39..485bdffed988 100644
--- a/include/linux/iommu-dma.h
+++ b/include/linux/iommu-dma.h
@@ -21,10 +21,9 @@ static inline bool use_dma_iommu(struct device *dev)
 }
 #endif /* CONFIG_IOMMU_DMA */
 
-dma_addr_t iommu_dma_map_page(struct device *dev, struct page *page,
-		unsigned long offset, size_t size, enum dma_data_direction dir,
-		unsigned long attrs);
-void iommu_dma_unmap_page(struct device *dev, dma_addr_t dma_handle,
+dma_addr_t iommu_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
+		enum dma_data_direction dir, unsigned long attrs);
+void iommu_dma_unmap_phys(struct device *dev, dma_addr_t dma_handle,
 		size_t size, enum dma_data_direction dir, unsigned long attrs);
 int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 		enum dma_data_direction dir, unsigned long attrs);
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index fe1f0da6dc50..58482536db9b 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -169,7 +169,7 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 	    arch_dma_map_page_direct(dev, phys + size))
 		addr = dma_direct_map_page(dev, page, offset, size, dir, attrs);
 	else if (use_dma_iommu(dev))
-		addr = iommu_dma_map_page(dev, page, offset, size, dir, attrs);
+		addr = iommu_dma_map_phys(dev, phys, size, dir, attrs);
 	else
 		addr = ops->map_page(dev, page, offset, size, dir, attrs);
 	kmsan_handle_dma(page, offset, size, dir);
@@ -190,7 +190,7 @@ void dma_unmap_page_attrs(struct device *dev, dma_addr_t addr, size_t size,
 	    arch_dma_unmap_page_direct(dev, addr + size))
 		dma_direct_unmap_page(dev, addr, size, dir, attrs);
 	else if (use_dma_iommu(dev))
-		iommu_dma_unmap_page(dev, addr, size, dir, attrs);
+		iommu_dma_unmap_phys(dev, addr, size, dir, attrs);
 	else
 		ops->unmap_page(dev, addr, size, dir, attrs);
 	trace_dma_unmap_phys(dev, addr, size, dir, attrs);
diff --git a/kernel/dma/ops_helpers.c b/kernel/dma/ops_helpers.c
index 9afd569eadb9..6f9d604d9d40 100644
--- a/kernel/dma/ops_helpers.c
+++ b/kernel/dma/ops_helpers.c
@@ -72,8 +72,8 @@ struct page *dma_common_alloc_pages(struct device *dev, size_t size,
 		return NULL;
 
 	if (use_dma_iommu(dev))
-		*dma_handle = iommu_dma_map_page(dev, page, 0, size, dir,
-						 DMA_ATTR_SKIP_CPU_SYNC);
+		*dma_handle = iommu_dma_map_phys(dev, page_to_phys(page), size,
+						 dir, DMA_ATTR_SKIP_CPU_SYNC);
 	else
 		*dma_handle = ops->map_page(dev, page, 0, size, dir,
 					    DMA_ATTR_SKIP_CPU_SYNC);
@@ -92,7 +92,7 @@ void dma_common_free_pages(struct device *dev, size_t size, struct page *page,
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	if (use_dma_iommu(dev))
-		iommu_dma_unmap_page(dev, dma_handle, size, dir,
+		iommu_dma_unmap_phys(dev, dma_handle, size, dir,
 				     DMA_ATTR_SKIP_CPU_SYNC);
 	else if (ops->unmap_page)
 		ops->unmap_page(dev, dma_handle, size, dir,
-- 
2.50.1


