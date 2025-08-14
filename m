Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A02CCA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 10:13:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A813390012B; Thu, 14 Aug 2025 06:13:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A036F900121; Thu, 14 Aug 2025 06:13:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CBBE90012B; Thu, 14 Aug 2025 06:13:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7073C900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:13:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 22105117A90
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:13:57 +0000 (UTC)
X-FDA: 83774952114.27.E5E6A00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 52BFA4000E
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:13:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WhF8V3MQ;
	spf=pass (imf01.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755166435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KfgzUojTM/DB/MYkk7DA2Hi+SCW1x3wlstgTHhLqb3I=;
	b=CMgHMymXmC72qqFIHG90RQpH1O64HZHrJq+9ysurdLg3moKyJv7Ny+IiQBU0H5M7cQ6u5I
	23OA/GyhSMfAgKkWWkv6yXez2O+dsz64oXsO0UEJU3z+De7z0cKFetw6Tw4gMKvRzl0IFI
	JMLLuGrN7jhu+EK2XlgwcUi6GbX6x/8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755166435; a=rsa-sha256;
	cv=none;
	b=veNczzOCRPombd+6GKX3UyEqz5tvQkiSwThNKIMO3od+0DUawGL7JxbgXePrcFbxNIOnKV
	iyHnCkORpu+OT+18mEBPp1GdxSJjQZBtFvRqPR5qD0NWgyDbaqsEiWmF7Rn+orK3z8f+gb
	W1DWABW6Kapr9Swf29stvTrAoHVgvaU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WhF8V3MQ;
	spf=pass (imf01.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DEC1444F83;
	Thu, 14 Aug 2025 10:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B60C4CEED;
	Thu, 14 Aug 2025 10:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755166433;
	bh=mXPBKGOTAXMaA8YnIACrT4VeK6ColaZH6f/lOi0T5+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WhF8V3MQY1kDGquxRYbh0NmsCB2Br/5DNiI2oZxdSf0D7/1nzwXONLwHh3TQyJgYo
	 Zi4hNVXYHJbSNRl18JzHH5ePFjcnBukBnVvwIpOjEfuvBdbkdLDOz++Dx7brj0zL08
	 Z5yYKodFOLJKulPacHVmSFMdKJ+QXiC45zTRXFB7rXffkQrKIZgH0rJ7pT46IfLBpS
	 Omdc/djNuuIR/4wGVQ5lnMIWcYp+7ClehysztY3r0y0VbEWf8WYVok6B/wxvNx+zTH
	 hNMj5f2hrXhEDdzZJyn9hiO1cyolHcCJYmcJAvBOtiNMyKf85U/AhAwv9g4tigIlCj
	 wyOBJ0QRoptAQ==
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
Subject: [PATCH v2 02/16] iommu/dma: implement DMA_ATTR_MMIO for dma_iova_link().
Date: Thu, 14 Aug 2025 13:13:20 +0300
Message-ID: <4f39936e5a7319a848b1eebffe928c251e2ec0d6.1755153054.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755153054.git.leon@kernel.org>
References: <cover.1755153054.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 52BFA4000E
X-Stat-Signature: qjgmnk55sgo7aijtzaceug3mrwya4oyz
X-Rspam-User: 
X-HE-Tag: 1755166435-53396
X-HE-Meta: U2FsdGVkX1+phPXAb1QYH+Jkj+WkvUY+A+AwXWEhi8KjPi8lj17GzNKAuQhZZocDhN4h6NAkmsKI/aSasAanBHTdaz4Tkcf1HCowgCkrqSWbmw8ot55Y1BE7tZgJ/YRZjgH1GUAUM52Op+qnJfRGGtQJp1C5WJnbqV679FQEwR8/hCv/FQpaKxmZ1cCHsPz89pDqH4Edl2VkGyii8JPVMLTdQF5dCw9NghJBoxGAoVivcHyNrfneGspE58OSM1UHZ61wuuUTFHvrdoAFAIFMY7cAQv66nULgogrrU4zydX5QJzt0G4oxYTRqkFX92tJF9bNDq/506B3xjHuNCZI7VQJYYPLxA8QvA2mrURScYVzdW4VOsZqrpFYVqsCKG2qGrw+HOQ0IY/gDGp1IKsOXWYVx3BFfhrF4RG90owChT9Dr+v2QNo2IKZ7awTJXqi1sdJuNGiOQsxNpdWESRBejWxjDg8yj/nynwqVeTXXlfLYeCX+WcEOTWa3PIaZsZCP8o4eu2yQHUAvCdrAgjgpl+LPnJsOfCZzPmW3t0Cecxt0H+GJkieTFZoUxSnZ7To+xxuqSaPaGORneeQJfp+6ZIxdyG2LnDIW+8NwQg1ogYOZtdABwKbgz0X3TkTNLO1ACniRMVUoJTIfFrpQgF+mp1ym+DLj0UD2a/hj04XqyI76YTMp3jxMfawPLzedRHlx0kySZhJEp0jnTjb7HnOyB5WbMg8AaSGajxX4b71MvwkU4GTyWJva0qLIIFjNJAJj4RvEaC6kF33KZPC8lq0J/2Kz4ft+qWb3v/tORpaMCDp+orDwp0NFNVuv4CT0t7hw7NeDnHwg9qBnD06AEhiUaTQg5gCQ324m0eLk/gAoxmA5M6KhBKqPlvif8Zfgm+3aXfzB747V83K45t7BPmdm4E2aiRMdM9AcLhBlPDzcAUDSPsl8QjP2CzpKYQDn4Q4AKSadzUKC/aLBW1sy2GTC
 gtWDC0Wn
 Lv27OHt/r5tDVn72AkKmoaCt3ifimlfzrrTLIo9WHPY8cJrjJevbOM94SUvjOrlBCwubjUQq/6hy/s92U3goUVRD0v/LAd8rC/zm9KT4U8MDKqkB7GVRvJFypn6X/0amDtqzndJjuWPQ1eW0AXH0dLVuVlkJ7Q91o4bERqu9pHUv2GSASk7VTnkMi0CmwWJhMpJOgw9emmPMfxlkF6rejNFmks4w6RGd1+zT1y2voBJGEZRRrOnLMgU2jB8B+nM06CcaIKZnmahN571uEB9GSTfBB+SLoV4ZlG6/1eTmVHmg0rYRIyMlAkUZNmlv3w6Ty8GPk58R9jX23crCsp90lX3wbdaCZBbFqi/JE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

This will replace the hacky use of DMA_ATTR_SKIP_CPU_SYNC to avoid
touching the possibly non-KVA MMIO memory.

Also correct the incorrect caching attribute for the IOMMU, MMIO
memory should not be cachable inside the IOMMU mapping or it can
possibly create system problems. Set IOMMU_MMIO for DMA_ATTR_MMIO.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/dma-iommu.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index ea2ef53bd4fe..e1185ba73e23 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -724,7 +724,12 @@ static int iommu_dma_init_domain(struct iommu_domain *domain, struct device *dev
 static int dma_info_to_prot(enum dma_data_direction dir, bool coherent,
 		     unsigned long attrs)
 {
-	int prot = coherent ? IOMMU_CACHE : 0;
+	int prot;
+
+	if (attrs & DMA_ATTR_MMIO)
+		prot = IOMMU_MMIO;
+	else
+		prot = coherent ? IOMMU_CACHE : 0;
 
 	if (attrs & DMA_ATTR_PRIVILEGED)
 		prot |= IOMMU_PRIV;
@@ -1838,12 +1843,13 @@ static int __dma_iova_link(struct device *dev, dma_addr_t addr,
 		unsigned long attrs)
 {
 	bool coherent = dev_is_dma_coherent(dev);
+	int prot = dma_info_to_prot(dir, coherent, attrs);
 
-	if (!coherent && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+	if (!coherent && !(attrs & (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_MMIO)))
 		arch_sync_dma_for_device(phys, size, dir);
 
 	return iommu_map_nosync(iommu_get_dma_domain(dev), addr, phys, size,
-			dma_info_to_prot(dir, coherent, attrs), GFP_ATOMIC);
+			prot, GFP_ATOMIC);
 }
 
 static int iommu_dma_iova_bounce_and_link(struct device *dev, dma_addr_t addr,
@@ -1949,9 +1955,13 @@ int dma_iova_link(struct device *dev, struct dma_iova_state *state,
 		return -EIO;
 
 	if (dev_use_swiotlb(dev, size, dir) &&
-	    iova_unaligned(iovad, phys, size))
+	    iova_unaligned(iovad, phys, size)) {
+		if (attrs & DMA_ATTR_MMIO)
+			return -EPERM;
+
 		return iommu_dma_iova_link_swiotlb(dev, state, phys, offset,
 				size, dir, attrs);
+	}
 
 	return __dma_iova_link(dev, state->addr + offset - iova_start_pad,
 			phys - iova_start_pad,
-- 
2.50.1


