Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66183CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:54:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0042F9001BE; Thu, 14 Aug 2025 13:54:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF6F5900172; Thu, 14 Aug 2025 13:54:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE6D29001BE; Thu, 14 Aug 2025 13:54:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C9F9D900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:54:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7DCA756947
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:54:38 +0000 (UTC)
X-FDA: 83776113036.21.EA73D3C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 015691C0005
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:54:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pIdx8ZwA;
	spf=pass (imf20.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755194077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KfgzUojTM/DB/MYkk7DA2Hi+SCW1x3wlstgTHhLqb3I=;
	b=BJBqkCsM8UcQeOdauu7c8qIVrTnE38UbwJI0iNcRn1QF96VBO0MlqxxMTkHtFKJEzviF6E
	7rfO2uRBxrad9Iane4s2ceGZ41NJGkWHHKIxHEob1xEd2gNmyhKMkNJjFg+sh5VslG9/pN
	FW1mOmWvGAENinnGp50zVDKLHPYjVdc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755194077; a=rsa-sha256;
	cv=none;
	b=i0Y40e17Xzl8Ptyy6tT8jthQT5gQfVCWQuCsKn88pCFurVMwA/4smiYCUynpDGLluvfAzN
	eV6aZoJL9hIyWy0WH6GkisPCtxvZlvFExGtV1Za7Aj1Mq2qWC17o5bC5x8dSx1zsiikidH
	d/KEnsnBenoxNAc5yu+Mj9HTyp7tfVs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pIdx8ZwA;
	spf=pass (imf20.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 731A16112C;
	Thu, 14 Aug 2025 17:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73FB6C4CEF1;
	Thu, 14 Aug 2025 17:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755194076;
	bh=mXPBKGOTAXMaA8YnIACrT4VeK6ColaZH6f/lOi0T5+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pIdx8ZwArqOnC8H1WXZmJQviGN3PGljxwaImYvA1qdYzR2oZxq3BM7DrGyd+Zf4kP
	 Rd3GxG3TTrXgG4p3B8bnSvGoXzofBO6pR9DN5xqqJUqBkNiUODxcew5WfU2rcNXmuA
	 msiVJMJNHMiWaw7xktQtXRAejc40yXlJLZHm+8dGVrXFyuKeW1Gzk10A2714lELSbu
	 mW6vabq71pTXUgj0NwjVhP65AQZCzZMov1zm1TCRq9mnHTR7T1OH8xQrOi6VGMm03z
	 QAlg6gJCETG/pVwnhN3rm4ne2MlguCRzIbsgIodAK+qQM4i4CRjQu8fdnlnPNos/O4
	 PwKx8Ppt/xhjA==
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
Subject: [PATCH v3 02/16] iommu/dma: implement DMA_ATTR_MMIO for dma_iova_link().
Date: Thu, 14 Aug 2025 20:53:53 +0300
Message-ID: <62d9a6c3ca03037631f6d0640ebec5fbac41d547.1755193625.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755193625.git.leon@kernel.org>
References: <cover.1755193625.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 015691C0005
X-Stat-Signature: kktjaczus86668o9nox9otktnhfyz798
X-Rspam-User: 
X-HE-Tag: 1755194076-34134
X-HE-Meta: U2FsdGVkX18mminrpNTPi+C+po5Dx13dkYRqzwL9/zsnUVeZFJwcfAvkCOaH+h0OKSZHGB7qNLnZYeR0mLMX/4vVVZB0OC/euhWaGJ2M4Tcy5IxsWJx9pJaPWjUzsbxfoE8K6w99w2mcduD5s+BWNfZ+JujVtnJ/b7PieCwYKa1Ud9EFWqjU6lnDwHo0yvlkpuz2y37AcXRYEmAd3zkeSW7Qjg69Q9Q3xMEH/LE7Dl6/HUwZoxAb0oKJZrm+NF/Ll2+R6SE+YGNHZnU2zVNj3rNp4Wug8qU58d8boXNFox8fmL+ia4MxReoGo6O6BogNNkZIucltyF5zBf93h5LJT1gBBVvd3aMTxX/yMhfc3i03AzSrsp2HOuq0yTYgtsPyV8xWjTkYWz4VRhklNVzUzypRyhx2Jn2H4C0RwrHSJYZEvFA+51K8YrgGmGp8p7V44ixAUqo+Nk8pjIGoX21pHcqPrFJ9DfwCK7Ok8n2qOUYXFACAGVwwWI0hB1a42RPa0ZBybjBe76K1oinkURjlBpCEznAf7fD9SS7yBw9p/IAh2KFTZji5tDzdGS+FL9rNst/TAuc5Tj95l3YyClL0aIcksoqq624+BomZQAP/KE6rjRQtUlkide9LVE82JX7YgenD7lqJaf0kqG+LcWE39KomrfDBbLpDerLsUAQlm35TSjv770xq/zHiw/jxmGEMwRukQQ/Hi0OjUA9Hp79V1+Bm1Xl5FOqu3Jj/FleSqcOVQJeN2UI+sBHtdMWdIcmnE5I3ZjX4qsBhNOBo8iHC16/p0GIL2y6vep/Dz7C5Cu/GgJYKck09m7KEoGMq+J5zdFXalPpuD9PL8HK6OrvvB8ZqDMVeGEYoW+yJ0B2Zi/V7WYisCzoG3Z6ozCYT/9bWjw/I4++M5D2qbPM2ZniUJEAko9nk6yLZ+/mRUpXv4iG7Ib2gyb54EMIoGCm5Jh+NpAX7XTgW0JaB8uFk4Kl
 epxKhNuM
 8nIXYwxK03rSerf/qfTWScolSoM36UF0cXCsQNJFfgfodNEWiKOVb5kG2FI1gUxgEd0RSpTNgrvnAaV8uST1PrCckx6VuiLtLlmjkAXWfoVvzgRIUrlLnFUJZwzRZk6YlK5xZaMXgXLGZRePyqErX4ZJn/gk63++Zsj71g/WcHD3QDb9Wyno07zWEre5oDKRLUa61ICMZytFKpsePH8Kmt8u6BuYxKuKP2ad7scu/FmISi8EGD8dm/2UD7ORrHem70LrRH0Cw0rqtC1/rS7Jmzh/VM8FSwpx8caPT/iBaxQ8iwd9mM5RY4Tf8fiHlyPsBbVeORISagRekPZ+i+I+llZDdFQn87bRaNfmm
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


