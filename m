Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1957CAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 13:28:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EB278E0016; Tue,  9 Sep 2025 09:28:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C4488E000F; Tue,  9 Sep 2025 09:28:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D9158E0016; Tue,  9 Sep 2025 09:28:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BC3F8E000F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:28:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1601C0515
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:28:46 +0000 (UTC)
X-FDA: 83869791852.20.157FB1A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4A80F80005
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:28:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jgpKjl3W;
	spf=pass (imf02.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757424525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xhEMQr2SWkJmlxMyFOKNbyDmG9QYmuLcjXIMFwlZ4BU=;
	b=FG53bGCtmYRRNbBwgaCvtT47YoLkoDrODIaYrz9rsjq42Vk7Hrhu4IsikHH1dM6q5hZynH
	LBGCKjD4q9IQ0prqL+LkG4Lu+MdGzJh4LDPzlA3VDK9Gy7lmts/iNSDxDbhdXy9No7+1f5
	opAY0lhbe5LQA1PR5Jcz/3zwKZZnieA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757424525; a=rsa-sha256;
	cv=none;
	b=8TiJuNUW/TAKUSDHvT5xCvKZq6VRA6Ot7ip5ww9o0t7jqwPUlOzK3grUfXuX3/bK9sfhx0
	rBS/OflT8ZXrs4WgWhWtvz0ovGwUkN4pOTw5yLHmJTEXfhGcYj+AyQdgn9bnAWxVpmwLCm
	4y64l5pgsTgkL9N+OMXT10B1aqWd8/0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jgpKjl3W;
	spf=pass (imf02.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5024C433EF;
	Tue,  9 Sep 2025 13:28:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D52C4CEF4;
	Tue,  9 Sep 2025 13:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757424524;
	bh=az1vV9FS2ijQFCe2KnlGsCUm5py+7cz5M/t0oqZVEe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jgpKjl3Wzr18vmUsgRZQtN4//p8yXvKe2bqbeBF+tjCU7DiPUojq+IdDByulqXWaT
	 RoAAZFNISIIUjdOgETkxJvzlEMu06VIXfR7n+SDYVJ7snL//aFTqN5/n+wjwc9CKce
	 hgPzq2wz22D/FrFpA1h8MaExay5bJUjRXKU9I9qYxPPzy5vQjh6WVr5wv9ZdJETnxa
	 +RSkDK4c0tSR4Jg25A6+k+Nj48PdiVEpZ97m9rNszJ8IkgL9HIE++EJgXm7HweKW2n
	 Z/eO4I7jE8ssv546fCTIjcxZvbt+sSyTCV9kntGrGqjk4RietJ966th5LAGixlLyUg
	 ACSDJ7U85NKEQ==
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
Subject: [PATCH v6 08/16] kmsan: convert kmsan_handle_dma to use physical addresses
Date: Tue,  9 Sep 2025 16:27:36 +0300
Message-ID: <3557cbaf66e935bc794f37d2b891ef75cbf2c80c.1757423202.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757423202.git.leonro@nvidia.com>
References: <cover.1757423202.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4A80F80005
X-Stat-Signature: 9a8my6q9k1scmaac7y9ik4p1td6j11sn
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757424525-875698
X-HE-Meta: U2FsdGVkX18I3/UeylZs0wsM5ngppSRfmj4H6rkwTA3/pJkH8jUW81KKu7jT7M18Wh/JbZPwErjE5Gaam13IPMZua80IA6BHpKI10Wv1F+oH5Ykv07nMOLTNkiR9TBtQA9q/8nPh/o9NbQWd3ek3Q8goEBgyYrr2dp2cW3215R9qiinorGBeIVx5/ArY3CoORXDHhV87bv3tgvlZ+1py4VxTNR0NKvgSwOkueO5KI1PXqMlf5crP8rNpV8doiW5n45nzU7CvpngjloSXGPr0PaIXabam2zzGOyn9Fvoq1A4mpFlDAguJWvoAsHsoeaIK8eWtOfSY+ZvTJQ3o31mqXS3UoXca8xPRRucKPlWsmqr6GRlRKgQ4TQOuLVUNO2uoRztgWKclL/TFFb2UyGZfRViiQU+JfGr5XJhzxF3JmET5p3zZvDgc+h9iV1xYyOdP+HUApNQNC5AuaTCyobZRqfE76NSCZ0LmgtBYeBD78/lg/2eOvujrkV2R7wsY/grMdY5C1FexRnINg/hEqWJkKIIl8HhNhDqPJ4rhaO4FUY1BY2x4TB+RveVK2x5daztSJpzilCNd+342XyasiCBJF47faah4y2oXFfl26mCYhNIPwKg4TXzinNSxOlQlEpHlx1oN01eV+05xV/p1f0IlV1WNhTRmjdd8UyhYWjRviC1wXDyZUh63dZNZbSxcMQ1ByDs1oGQ3YfnmbZ2QjYzgvAfEhiIxLFoU0pXEk7An9NPUkt/K90sizWH2zoezeTzH3eXn4DRddZFq+BLYjFEQ1dqx0Dt52a94fXg3//1WL0XW/SSsarrefORLqZOY0YeqDBFHxqfmvGWZ1Yx7CmafjVIXICWCYr1ztayDh5EkSQaJBZJAsnVqjA3etRtvBDTE5QWzZVVFrkh4xUR8Ou9mNBiLeY3u5gqcNVBNLeZhP1hLP0mFfm3HwfJRS0IzDOaZ75XPeARlRozSRhuXuwW
 WDWHz30E
 iyh86aEG9CVIJiZpB7H1U97ZvR6AQxdjPUEeSN7IypHtrrDwmIkT9amn6BF70xo4gZd0SBpW7M8lGSHQ=
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

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/virtio/virtio_ring.c |  4 ++--
 include/linux/kmsan.h        |  9 ++++-----
 kernel/dma/mapping.c         |  3 ++-
 mm/kmsan/hooks.c             | 10 ++++++----
 tools/virtio/linux/kmsan.h   |  2 +-
 5 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index f5062061c4084..c147145a65930 100644
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
index 2b1432cc16d59..f2fd221107bba 100644
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
index 3ac7d15e095f9..e47bcf7cc43d7 100644
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
index 97de3d6194f07..fa9475e5ec4e9 100644
--- a/mm/kmsan/hooks.c
+++ b/mm/kmsan/hooks.c
@@ -336,14 +336,16 @@ static void kmsan_handle_dma_page(const void *addr, size_t size,
 }
 
 /* Helper function to handle DMA data transfers. */
-void kmsan_handle_dma(struct page *page, size_t offset, size_t size,
+void kmsan_handle_dma(phys_addr_t phys, size_t size,
 		      enum dma_data_direction dir)
 {
-	u64 page_offset, to_go, addr;
+	struct page *page = phys_to_page(phys);
+	u64 page_offset, to_go;
+	void *addr;
 
-	if (PageHighMem(page))
+	if (PhysHighMem(phys))
 		return;
-	addr = (u64)page_address(page) + offset;
+	addr = page_to_virt(page);
 	/*
 	 * The kernel may occasionally give us adjacent DMA pages not belonging
 	 * to the same allocation. Process them separately to avoid triggering
diff --git a/tools/virtio/linux/kmsan.h b/tools/virtio/linux/kmsan.h
index 272b5aa285d5a..6cd2e3efd03dc 100644
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
2.51.0


