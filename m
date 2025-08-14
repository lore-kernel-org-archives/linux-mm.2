Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2356ACA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:54:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B28DF9001C0; Thu, 14 Aug 2025 13:54:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB2D7900172; Thu, 14 Aug 2025 13:54:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92CC89001C0; Thu, 14 Aug 2025 13:54:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 765A3900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:54:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 24695140716
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:54:46 +0000 (UTC)
X-FDA: 83776113372.22.827C194
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8C0744000D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:54:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iIPdKT0a;
	spf=pass (imf17.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755194084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pzRaznYWcPEPErIBBlcoY/4/ZIrl67NZIXZ6kqZ6GFg=;
	b=2LoRkV4h6/GvDCb51pzYo7YqEQjEgtWq8e0svpqZAPnMvNEtEynXvMztQUuImb5NnoV12S
	MUtHUW/CNyFC5kR7DqYOpuyOAZD0YGdF78hqB3wKR5LVIbOtND/m0E2CowW7TpDOT7x7Sj
	Q0V5VXb40xTFdgTAZqBbOb8gaGCLcO4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iIPdKT0a;
	spf=pass (imf17.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755194084; a=rsa-sha256;
	cv=none;
	b=Pd+zXP534mh14YdhKYkTvzqUbP/swUWuq7oPQAMvaz6OPDjOQZTdqJRh7yA5lMw8qniO/T
	+CsQHqSVI/UasMMD+Wgkd0+a1UNk1l2ZmJSw42dEse4VMDKRloLkDBXW0AaIHh4LtD2l1O
	RvHHz/UsQAAhAjd8i/p3OPo0PIausm4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id DD020A573EF;
	Thu, 14 Aug 2025 17:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D180CC4CEEF;
	Thu, 14 Aug 2025 17:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755194083;
	bh=R7qBwFAm9izbrLVrPILQ9w37/FtDeJtTkRXoDvtS1CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iIPdKT0aBIcYkeb/LiN0KqK3Xncf9eZZsRXFgIanpuSaYiJCb/1rKUprk4/hACv32
	 BbT/YJJLOF1rEPaztLA0oAft4rdkYqJNcaKExvnXyxrjj7rUbZ403eWhTwUzzvGabi
	 afIjuWmko6gtMe1wRQTcqQriX67Lbt8bIC9fmmy6DUCNJKHtMEbqhw+L7qlcixBxn7
	 fjPsiNM1dAf4aRYRmpsTtAuBGONpGleKAROv8v+xxiaCx8/8uPPJxUSnIphNqZvuBJ
	 CCEQXBAUhxVm9aEvfsThLZHa6lCGABl4QFyBMxqqn6Dy4rhPlrIWIYiWRRD23CPfu6
	 oSidLdWzGZhIw==
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
Subject: [PATCH v3 08/16] kmsan: convert kmsan_handle_dma to use physical addresses
Date: Thu, 14 Aug 2025 20:53:59 +0300
Message-ID: <38de1c5ffb567c5705826f14742fcaf54522c083.1755193625.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755193625.git.leon@kernel.org>
References: <cover.1755193625.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mhb5mez6kfyzujo1e5qe9xemjtyhsr6i
X-Rspam-User: 
X-Rspamd-Queue-Id: 8C0744000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1755194084-745078
X-HE-Meta: U2FsdGVkX18PTYuFhWDkxkwFTfm1UyCXMNNu5KAZl/YbCzJLvlVTqI2yqoGxVeGH5jDX77AqZRCLMeuKgSqWakrgpKkPbTmAzyeIf7kJWhEmOJM/nVzSU0crnBxY9s18kf+x9rzHVTppD7eam8KUYg4s8yRZIHxrSTgo5iYPXOZfIcCA7YfgDjsttwwggXOFnl31X2qogM7dFOuXRg4ZAvF9GjVvOeIHBpvHBd/kET426dErV+czFFO+GaRauBZPhUr9q2EDy+DnVq5GRYsclmbk4Pr9MOZyMnO4vkTTFpgC6gaOFarz6ATDGzSnXvRMnYagJ3nml9xluhiQEm2NAo0bVY0YLqYsFL6DFR5C2bijZX0hrGrME3RcMdMnURJkXwX3URp/RzqXKWi8bgsNzkx0hFArxoZ1OxPKDKXOWb2Zn+F6MhkU9oCNhcVtV8j9TuggChQ6oCQsD7rH854p8PsukBu7dQ+Ym3WJuW/9pWh3SVWsaZ6oaJcg7vIrnjpfV7HiOkDJnkzMAp3lFXvHH2lY734LuFsQzB9WP06Cz434GEYctuGKNDFiZeXBJnbnWArseT17fcyl4AdXqjDzYcTDy9zGigldRt+buPDeC/A+kZeWKaHcVze7xEvZ+5pjcGz2CTZw1Z/Mgdufezw3jVFbVpvZC6BcncY9NYM/H5m9kDNpI4hkh4ijPGaSnCvB9W7TZ2o/1WCgemF+mTgPGpYUWflTYJdmem4sPJOCVqkCQET2R9PPFftguMTCrH99fXJM91PZR718mExOvwBCU3HmNW2nbX/nCBTKcKkqYf6Yi07+5bPNLph7BqCCwGR67D6TZwtZLehB9hj9XrZoL6RS66MBOcRNk+onRx3ZrHI1iOjZEi2xfWQrwolcsznwSKfzhnUHa1NaMnzhEj9V6GLoJX/SbxO39qKPMOEkL4CRr7SQ/4eGTW3KpybXpnHOedw2+t95CAJA+2mmRVO
 FAb9ruPs
 iCKv2d12mDvhOI50VwH3gVhAoagJOdq5F7q6PGRT3DeO6u0pI7YQO+s4JIgacJj+cj3C2QcWe/aBpFs0HSpz70R/NhuHcKuVwSsbK3qdVenlCcLE4FvUhntx+gQvdgl9aE3RIn+QUm70XJhEaFJCDb+jLFpUFO3hzwIpqwY3Lqilq52LZsYNbWfpWYe1IXPeZUMN0kdHArHl4slxJcJezdW38oIjU/qtktUMx9mHQmF13MPrVGwAsBPkXdmyR8avS+fYxV0C2obMAsZx1M8i1hyRJ0pvE5cor/yNv6DimMRggl8RDHwijy05tUK1NGWVHnsOlx90dMYH2BiwtvuUfzSSOy+KqvUS1GZkO++uhOm4MuZVnL6VEHiphYlT5NSz+taWD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Convert the KMSAN DMA handling function from page-based to physical
address-based interface.

The refactoring renames kmsan_handle_dma() parameters from accepting
(struct page *page, size_t offset, size_t size) to (phys_addr_t phys,
size_t size). The existing semantics where callers are expected to
provide only kmap memory is continued here.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/virtio/virtio_ring.c | 4 ++--
 include/linux/kmsan.h        | 9 ++++-----
 kernel/dma/mapping.c         | 3 ++-
 mm/kmsan/hooks.c             | 7 ++++---
 tools/virtio/linux/kmsan.h   | 2 +-
 5 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index f5062061c408..c147145a6593 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -378,7 +378,7 @@ static int vring_map_one_sg(const struct vring_virtqueue *vq, struct scatterlist
 		 * is initialized by the hardware. Explicitly check/unpoison it
 		 * depending on the direction.
 		 */
-		kmsan_handle_dma(sg_page(sg), sg->offset, sg->length, direction);
+		kmsan_handle_dma(sg_phys(sg), sg->length, direction);
 		*addr = (dma_addr_t)sg_phys(sg);
 		return 0;
 	}
@@ -3157,7 +3157,7 @@ dma_addr_t virtqueue_dma_map_single_attrs(struct virtqueue *_vq, void *ptr,
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
 	if (!vq->use_dma_api) {
-		kmsan_handle_dma(virt_to_page(ptr), offset_in_page(ptr), size, dir);
+		kmsan_handle_dma(virt_to_phys(ptr), size, dir);
 		return (dma_addr_t)virt_to_phys(ptr);
 	}
 
diff --git a/include/linux/kmsan.h b/include/linux/kmsan.h
index 2b1432cc16d5..f2fd221107bb 100644
--- a/include/linux/kmsan.h
+++ b/include/linux/kmsan.h
@@ -182,8 +182,7 @@ void kmsan_iounmap_page_range(unsigned long start, unsigned long end);
 
 /**
  * kmsan_handle_dma() - Handle a DMA data transfer.
- * @page:   first page of the buffer.
- * @offset: offset of the buffer within the first page.
+ * @phys:   physical address of the buffer.
  * @size:   buffer size.
  * @dir:    one of possible dma_data_direction values.
  *
@@ -192,7 +191,7 @@ void kmsan_iounmap_page_range(unsigned long start, unsigned long end);
  * * initializes the buffer, if it is copied from device;
  * * does both, if this is a DMA_BIDIRECTIONAL transfer.
  */
-void kmsan_handle_dma(struct page *page, size_t offset, size_t size,
+void kmsan_handle_dma(phys_addr_t phys, size_t size,
 		      enum dma_data_direction dir);
 
 /**
@@ -372,8 +371,8 @@ static inline void kmsan_iounmap_page_range(unsigned long start,
 {
 }
 
-static inline void kmsan_handle_dma(struct page *page, size_t offset,
-				    size_t size, enum dma_data_direction dir)
+static inline void kmsan_handle_dma(phys_addr_t phys, size_t size,
+				    enum dma_data_direction dir)
 {
 }
 
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 80481a873340..891e1fc3e582 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -172,7 +172,8 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 		addr = iommu_dma_map_phys(dev, phys, size, dir, attrs);
 	else
 		addr = ops->map_page(dev, page, offset, size, dir, attrs);
-	kmsan_handle_dma(page, offset, size, dir);
+
+	kmsan_handle_dma(phys, size, dir);
 	trace_dma_map_phys(dev, phys, addr, size, dir, attrs);
 	debug_dma_map_phys(dev, phys, size, dir, addr, attrs);
 
diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
index 97de3d6194f0..a080400290e7 100644
--- a/mm/kmsan/hooks.c
+++ b/mm/kmsan/hooks.c
@@ -336,14 +336,15 @@ static void kmsan_handle_dma_page(const void *addr, size_t size,
 }
 
 /* Helper function to handle DMA data transfers. */
-void kmsan_handle_dma(struct page *page, size_t offset, size_t size,
-		      enum dma_data_direction dir)
+void kmsan_handle_dma(phys_addr_t phys, size_t size,
+		      enum dma_data_direction dir, unsigned int attrs)
 {
+	struct page *page = phys_to_page(phys);
 	u64 page_offset, to_go, addr;
 
 	if (PageHighMem(page))
 		return;
-	addr = (u64)page_address(page) + offset;
+	addr = (u64)page_address(page) + offset_in_page(phys);
 	/*
 	 * The kernel may occasionally give us adjacent DMA pages not belonging
 	 * to the same allocation. Process them separately to avoid triggering
diff --git a/tools/virtio/linux/kmsan.h b/tools/virtio/linux/kmsan.h
index 272b5aa285d5..6cd2e3efd03d 100644
--- a/tools/virtio/linux/kmsan.h
+++ b/tools/virtio/linux/kmsan.h
@@ -4,7 +4,7 @@
 
 #include <linux/gfp.h>
 
-inline void kmsan_handle_dma(struct page *page, size_t offset, size_t size,
+inline void kmsan_handle_dma(phys_addr_t phys, size_t size,
 			     enum dma_data_direction dir)
 {
 }
-- 
2.50.1


