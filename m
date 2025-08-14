Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 794D5CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 10:14:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1054F900131; Thu, 14 Aug 2025 06:14:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B6AF900121; Thu, 14 Aug 2025 06:14:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC04B900131; Thu, 14 Aug 2025 06:14:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D267F900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:14:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9588BC060C
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:14:21 +0000 (UTC)
X-FDA: 83774953122.23.FBBC8EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id CDA3A140009
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:14:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SmpX8PXu;
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755166460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SxVJ7EcVndf9TgWXko8eFo+h8Krf23TH2nyXAvhfQkE=;
	b=0/3MpSGUF7XmQp2Baogsrx2ZKUn34cJG5gqjJto8t2Gqfn0kxH3y3X71YpfMwDxLXVUuMp
	gyvAxDGfHOQaQt7+ljL/PAX9AEXO+cPxXXEH7F0QCqDYmBlwFdrt137c32yYw5MJa1Fux7
	Jpnjs8We6zsyGwUrrq+uOn5CBbe7YGY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SmpX8PXu;
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755166460; a=rsa-sha256;
	cv=none;
	b=F0G6DH6yZxt5Xh/FzmjBwAld+SDqbyYJ+Engs0ow8Y8+cbuF+k0Ts+Mbg7hRBpL9VvJf6i
	OVAhMS9W+G7lbIudmjLEkTJB2YG/sesUu3VjmPz9/3yj1WfIQvLuVwAJcTBZdVO0pPrYhJ
	WjHwIDHtdTi2oy6tAZi3h65iD+h8GHE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B0AEE45FFC;
	Thu, 14 Aug 2025 10:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5592C4CEFC;
	Thu, 14 Aug 2025 10:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755166458;
	bh=we72YOP3RUYaEE6ejOmXbWl+ckHyZi8LIoo6/UPYld4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SmpX8PXuuxNsaz49Sv/BhvNODQ4TzMXqNubGzpKjR0dsA/JlegVIW7ZYpMP3neeXo
	 6ysow+joFGXbris2T1w1bPKLajBRqw5mhLds3i95hlC6XAjezXtulUZr+VABJIMJSB
	 yhFjt55CINSHs1xWT301t//Fwqm4P0mYOLiPWlay2oiADWpapVZRRShOUUaHscpQjR
	 5pWPQPUWCmWT7zKihbu48EPfLMT5IfO3LiRbfS9Hm//Sx73FEjHbqulbxA5564Lw33
	 eHtpUKmiASaPE+/oHNo1MnUXBlXVI6jC0cH/9L6mOtLxocU6cjNTRKKr/AIXiTa6VY
	 iPn1oycvVDCKw==
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
Subject: [PATCH v2 08/16] kmsan: convert kmsan_handle_dma to use physical addresses
Date: Thu, 14 Aug 2025 13:13:26 +0300
Message-ID: <fb43d745ff8fd822622932f6eb813621b75b2499.1755153054.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755153054.git.leon@kernel.org>
References: <cover.1755153054.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CDA3A140009
X-Rspam-User: 
X-Stat-Signature: 5seaayydy8xfju4umgwrfj3pmtku9yoo
X-Rspamd-Server: rspam09
X-HE-Tag: 1755166459-647808
X-HE-Meta: U2FsdGVkX1/kkcVEUQ8LPp6BKn4kSQwIqih90Sz9hVWFCXgeYb8HP9zphWfqWGH6V8HcmpUkWR+f4raGW+yPaqArAtjPPeqnt7XA8N2fswTcvsc30hruIm+CTf5cVAcWrsrLt6uW8uA6Gba8hyPLMm3UxKzUFZ14JWx/0UmE1AL1hvGNaLpiE80rXXtF0IIPBtYIZzCgRGTPyBSIQSl6rbRJ2jZTsUMsXoorw1AxqgASFqAt1mgauDxuO+U3W++Kj4F7wpsBh0YM0dcrnqI9109Sw0u9HDWK8z0YGjh/2kfySh93PjjGCXlLQAxxamFutKWi7EYUnabb3P55jdG/4CHcrYZe8pdGzbYbbMqyEMZ8pJBHGvaXOednoXqog75DZaSyuB2nFF61Cu4Y07NhEweB+2C6CB6QLIXVq3RCRKrImfjbZLuK7hlJbILjjtzEnLnFSr7ytB0g2AQwbXPKWanc1yup3XlxR40oyup2uXT3jdSrz8dcmKYgr3IaGOgXUSKqCsMe5LAsy/8AfmqUY01S4D84axB1PgST3KcHMvKRMrfik3JK087LoMwde7Nack4J+YcDdDEMFbnuwWn6LSK+W/QtyrpJ5M39BVUFCP7njP+cr0SNiSEmpiw7lntflmZiGei6ej6/nZQI6F3AoMDK9hMxTRL5VqG3WcX83yLN9HlwmjDuyK0hnXNvlCzL5lNTyXyQwrAldSE2lYtg9zA67lXTJJwOdlQZqP9PG4qvU0wAu6Edbri198WWe6e4Rq4WE8BCRvZXXkzeEfgonZkTPMCXDw1aaVqC6JCpKoRDZIqdRv4cQaUTNGdGaLQJ4CHwGzNLq/hBPlL79RAJNHtNZPiuhagYBGKCYAx9Lus8NzMn+6iYRKf6jif3e4aZyR0Y7UvmJ55p446Mk60lYW+epUI1XyQtR9T92tM14JXTHTUQFVj3GvOPosCdS+/erKR5spenV/Y30MZqVqC
 jcgxr/04
 /BB/8z2i3KLIRd2XDPjnh1bxXsr/GY2xDKrHshDjGj0jeoPFqKRh2gyMzs96Zhtyt/y8pNGIdx89jgCrERpveoJno+Sw1pgMpJcD78+S8jiaFCuprQ+4SkU4J6NMZakX8OruWOjZdsjL+bxwtTw836TAky5SHau3ACxvl8YT6k9O9U/ulg05LTfYTlBz1ySpY4tqvo8gfmOqHtTkqJftOdwbswfIZ+FDsbB8jBv3jsaQ6avBz9LyTCf1Ec3IvHruihxUPn/Fth80RyFCYymX4x5NKaUtalkewYDBqPRsvNLRmhYlOc5se3eJuoOSjUXY7qvWA4VHiM44TekOe+KF8/wO+vuCewKbT7T8CeTMkh8wZXPzrJyN9uvUrRwT9362gkN21Ie75h6rhbMs=
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
size_t size). A PFN_VALID check is added to prevent KMSAN operations
on non-page memory, preventing from non struct page backed address,

As part of this change, support for highmem addresses is implemented
using kmap_local_page() to handle both lowmem and highmem regions
properly. All callers throughout the codebase are updated to use the
new phys_addr_t based interface.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/virtio/virtio_ring.c |  4 ++--
 include/linux/kmsan.h        | 12 +++++++-----
 kernel/dma/mapping.c         |  2 +-
 mm/kmsan/hooks.c             | 36 +++++++++++++++++++++++++++++-------
 tools/virtio/linux/kmsan.h   |  2 +-
 5 files changed, 40 insertions(+), 16 deletions(-)

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
index 2b1432cc16d5..6f27b9824ef7 100644
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
@@ -191,8 +190,11 @@ void kmsan_iounmap_page_range(unsigned long start, unsigned long end);
  * * checks the buffer, if it is copied to device;
  * * initializes the buffer, if it is copied from device;
  * * does both, if this is a DMA_BIDIRECTIONAL transfer.
+ *
+ * The function handles page lookup internally and supports both lowmem
+ * and highmem addresses.
  */
-void kmsan_handle_dma(struct page *page, size_t offset, size_t size,
+void kmsan_handle_dma(phys_addr_t phys, size_t size,
 		      enum dma_data_direction dir);
 
 /**
@@ -372,8 +374,8 @@ static inline void kmsan_iounmap_page_range(unsigned long start,
 {
 }
 
-static inline void kmsan_handle_dma(struct page *page, size_t offset,
-				    size_t size, enum dma_data_direction dir)
+static inline void kmsan_handle_dma(phys_addr_t phys, size_t size,
+				    enum dma_data_direction dir)
 {
 }
 
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 80481a873340..709405d46b2b 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -172,7 +172,7 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 		addr = iommu_dma_map_phys(dev, phys, size, dir, attrs);
 	else
 		addr = ops->map_page(dev, page, offset, size, dir, attrs);
-	kmsan_handle_dma(page, offset, size, dir);
+	kmsan_handle_dma(phys, size, dir);
 	trace_dma_map_phys(dev, phys, addr, size, dir, attrs);
 	debug_dma_map_phys(dev, phys, size, dir, addr, attrs);
 
diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
index 97de3d6194f0..eab7912a3bf0 100644
--- a/mm/kmsan/hooks.c
+++ b/mm/kmsan/hooks.c
@@ -336,25 +336,48 @@ static void kmsan_handle_dma_page(const void *addr, size_t size,
 }
 
 /* Helper function to handle DMA data transfers. */
-void kmsan_handle_dma(struct page *page, size_t offset, size_t size,
+void kmsan_handle_dma(phys_addr_t phys, size_t size,
 		      enum dma_data_direction dir)
 {
 	u64 page_offset, to_go, addr;
+	struct page *page;
+	void *kaddr;
 
-	if (PageHighMem(page))
+	if (!pfn_valid(PHYS_PFN(phys)))
 		return;
-	addr = (u64)page_address(page) + offset;
+
+	page = phys_to_page(phys);
+	page_offset = offset_in_page(phys);
+
 	/*
 	 * The kernel may occasionally give us adjacent DMA pages not belonging
 	 * to the same allocation. Process them separately to avoid triggering
 	 * internal KMSAN checks.
 	 */
 	while (size > 0) {
-		page_offset = offset_in_page(addr);
 		to_go = min(PAGE_SIZE - page_offset, (u64)size);
+
+		if (PageHighMem(page))
+			/* Handle highmem pages using kmap */
+			kaddr = kmap_local_page(page);
+		else
+			/* Lowmem pages can be accessed directly */
+			kaddr = page_address(page);
+
+		addr = (u64)kaddr + page_offset;
 		kmsan_handle_dma_page((void *)addr, to_go, dir);
-		addr += to_go;
+
+		if (PageHighMem(page))
+			kunmap_local(page);
+
+		phys += to_go;
 		size -= to_go;
+
+		/* Move to next page if needed */
+		if (size > 0) {
+			page = phys_to_page(phys);
+			page_offset = offset_in_page(phys);
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(kmsan_handle_dma);
@@ -366,8 +389,7 @@ void kmsan_handle_dma_sg(struct scatterlist *sg, int nents,
 	int i;
 
 	for_each_sg(sg, item, nents, i)
-		kmsan_handle_dma(sg_page(item), item->offset, item->length,
-				 dir);
+		kmsan_handle_dma(sg_phys(item), item->length, dir);
 }
 
 /* Functions from kmsan-checks.h follow. */
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


