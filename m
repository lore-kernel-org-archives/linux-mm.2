Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15D18C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:43:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A873E6B00A8; Mon,  4 Aug 2025 08:43:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A385A6B00A9; Mon,  4 Aug 2025 08:43:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 926306B00AA; Mon,  4 Aug 2025 08:43:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7E41F6B00A8
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:43:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1E3F1134F49
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:43:43 +0000 (UTC)
X-FDA: 83739041526.08.4C463D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 572C8140003
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:43:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hwpc/2Lt";
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754311421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yob5vGImG9Fz6Q3IIoENTL3tAbucLWfbEG7h2+LdGFM=;
	b=c3gecAOIiVr9pOEzZq7l/hNlvW2cbFTWtVJc+cjEoqdawEvlqm95q0yg+NLouXKQbdIS+X
	lIoTh9nH/cxmIL3E59Q23jfCF5TEsM1eJBnQQ8vTfYpUhQexIFfafAjonSfeScgYpZHriy
	jSysksdpLms/guS23EMZxFogi8V5nEM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754311421; a=rsa-sha256;
	cv=none;
	b=xY0bRxfXvWt9svEbbeOI64L5nJue6Y5YLTyrT7LZKkK7pc8d9gbUgvZvJGuUtLsSECra8h
	jclHIiGJzgeTIuXapxMq/hyvL9IcpVR1KtVLEi0r2XDn+XZxAI78RpD0MVgo3S4c5YxfXf
	kavEhgFD1iJaXiHRiwEJg0Nu8Btzdd4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hwpc/2Lt";
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5EDCF4423C;
	Mon,  4 Aug 2025 12:43:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6868C4CEF0;
	Mon,  4 Aug 2025 12:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754311420;
	bh=KuB85oQ1zEvHewxjvaa7TgR+vPeGP91gwiah2Yizc2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hwpc/2Lt2D3anuuHX/CywReJ+JevkzY6FynhQNLZcPcidH3a8z4Y3cZmYKqJx40aB
	 HuWBeZEysO6t3oSzFklaWg8fzR58b4rw4vPFNALiUc9A9irWH9TDeW0nOLlTcNMjg5
	 8y75jvY8oofTniAsxP4pz8Mu3KaSfgmilMiaTliZ/mjlKSNBhY+c10mFYtQHZ4AR/7
	 Xmk6xDyL82OWzMQWw/B3tiObakK+I7qRBS7g9Wgz6viepi3WB5CZHiWKKRcEEGPKzI
	 Kj0BbJnhOLGzRPSZ09k5YVjeQRC0y6mBjsRtkaL/iwYbfSRrLhH2F4a0OA4eEyJn4C
	 wZIRnvkij7dkA==
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
Subject: [PATCH v1 06/16] iommu/dma: extend iommu_dma_*map_phys API to handle MMIO memory
Date: Mon,  4 Aug 2025 15:42:40 +0300
Message-ID: <09c04e0428f422c1b13d2b054af16e719de318a3.1754292567.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754292567.git.leon@kernel.org>
References: <cover.1754292567.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 572C8140003
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 9tc8xnfnbj9us467fopsh14jjpfken5e
X-HE-Tag: 1754311421-693044
X-HE-Meta: U2FsdGVkX1+/qifh3OjZNGhK5gcqxP2VeIDukC3rYnZYegKb7Yt3GCHvZ4t5RSxH19ldgbMFxRwkzx1FiKbLxpBJ0VnSMrJNzdrRyFk2RtREVb9NFC6Sep92amc1DXdxsiNSERAbB7n4QkE5BJ8egk2TuiJ2m0dGvDL5CuBbkMQiRR0rf4yJR/3yKhIheoQQOUhlBwei28cbqKCkJuYfIY5fajV8rS9JpkW8n54nMxfJbASERLt8wZj9CwtLZRyTMlCG0ExaZEbXbxNAQp7kZ2dxkuiRulYPYB9V1Lg1GsTBtgGvz9TVP/J5a8C8rboftNx/lnkO1HiXygCaLS0DixNNSv52thUYb1R1iJBnlUnZVSu0qMw9dHdqbAr/5AU+JRyuGCdy6fLZsFgVnFvSG+vQNOO/HZL4/irctc/Cm8jPigwCWKeGmZr7+59innpMskzgZ24IfHVY2zuDWyF3ogeltWKHv8Dop+UqX6kchknyzF/2p5xghVn61JDujm34FSdI0igO9kLFrU7xmTaoTCK6ubVKkqXRtUW1YSOtzhFAU12txSTmBCtio0wVboGmaxsLyxtOMD5CsIRU1i0Tg42i4J6OP39Fkg+iwSe01q95O+qsnuZzv5zFb3oduYAEyDN2C7cGTTqHPT8rbsTyVrKCeVrqNEl/Syk9tzAHGc/ms5cCU0rVb7owt71CBUQYTzWY2wCwbWGUhXriBgwygtby7KJA7WIir+71iB/UDv/BZ4SuroSJIRvC2obKR0MoPokmtHqyXUycXlrng0yI1lMqcZ2YEKaadjdL/gSuOvwdCdGqHXyU45N2mjx1+6YDq4jCqy9E/dymy3255l8ITrSjQTD43rTsyvvwUMjaDVzjCfDhNjiOQCJff/Pz1uNrN2hrpdewbB6SfZhz+MaGPw3ZyIvaU1zYNN54RfAPAaxL5qvb037CUZ+Ocviml177cXbefNrpJl8Q832Dngz
 RvUrqzXj
 awH7gRbpMg/b3gM69WTiATzy5m1UP5zKQoe13Yy9PnVGWg9NOd/NBpqw8aNqggJJ6+CdRHysb5ol8m1J3XCZA8TSR9z62iy2eBdiBvSjvZTqdQ/vy8KGQ2IXc9jSMRBqZaudi8xJPYjRAMVH7JPU5mmcU/0rNS+VuJ1c5/o4/A+gWauxOPejaTctCglq1KDoMC2/m/5XFQmAzpIpRjOSB/yFa5fzzCzgppgDLVT6z5BvzhsCbkvbA/WG61FoLz0lv5wYoOdKGRL+FSZ65+ZPaYNvQy6/HGzMgX+Nxu2f025g7CTAt4hfCwi3sxWoOCigh7/1xbOYps+8N7artk14VTu7aKWUXFMs0PlkZ
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

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/dma-iommu.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 11c5d5f8c0981..0a19ce50938b3 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1193,12 +1193,17 @@ static inline size_t iova_unaligned(struct iova_domain *iovad, phys_addr_t phys,
 dma_addr_t iommu_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
 		enum dma_data_direction dir, unsigned long attrs)
 {
-	bool coherent = dev_is_dma_coherent(dev);
-	int prot = dma_info_to_prot(dir, coherent, attrs);
 	struct iommu_domain *domain = iommu_get_dma_domain(dev);
 	struct iommu_dma_cookie *cookie = domain->iova_cookie;
 	struct iova_domain *iovad = &cookie->iovad;
 	dma_addr_t iova, dma_mask = dma_get_mask(dev);
+	bool coherent;
+	int prot;
+
+	if (attrs & DMA_ATTR_MMIO)
+		return __iommu_dma_map(dev, phys, size,
+				dma_info_to_prot(dir, false, attrs) | IOMMU_MMIO,
+				dma_get_mask(dev));
 
 	/*
 	 * If both the physical buffer start address and size are page aligned,
@@ -1211,6 +1216,9 @@ dma_addr_t iommu_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
 			return DMA_MAPPING_ERROR;
 	}
 
+	coherent = dev_is_dma_coherent(dev);
+	prot = dma_info_to_prot(dir, coherent, attrs);
+
 	if (!coherent && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
 		arch_sync_dma_for_device(phys, size, dir);
 
@@ -1223,10 +1231,14 @@ dma_addr_t iommu_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
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


