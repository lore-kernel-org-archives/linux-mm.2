Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E46C6CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 17:38:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83E6C8E0041; Tue, 19 Aug 2025 13:38:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C6E58E0005; Tue, 19 Aug 2025 13:38:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 667EE8E0041; Tue, 19 Aug 2025 13:38:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4CE9D8E0005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:38:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05D47B6A8F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:38:32 +0000 (UTC)
X-FDA: 83794216464.05.70CCCFB
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6EAD880014
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:38:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oNMOGF7B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755625110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ka+259+K8Z6BWOMZtwtkOGNuLpWgpr7XEnb69sIe1wA=;
	b=P1GgTs1x7/y2yM+Mju1l3688pzLt81VSwf75zL/V/+BTR2n37WUlno+ZZHQVEQeIuLvT3k
	TLWvsE3GYU14UErkGL7vECPZ4f/OLckNyNn7h3lbpUT/x/K7Pa07itJCxkxIOdn3bI1es4
	1Ajsid8pv8iiNcH4s3i/fyH7U3ftIrU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oNMOGF7B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755625110; a=rsa-sha256;
	cv=none;
	b=FfMDKJ8X1HKka37260rqTVgudGiGxkDwgjlLM5pzmUtoXeLXm1Ddg4+CpXo39F6gK/m1lp
	xij+jnSkaCxwsMiK3WzKg5SDsOYFZ1wSoYoOsoSsxw5zfM7LQw6kxN0VPL36/V3dMHUe76
	P+04rRUBhpWN3cxcMJ1FqYdFpt4t7Z8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 9FCDF5C6338;
	Tue, 19 Aug 2025 17:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9ED1C4CEF1;
	Tue, 19 Aug 2025 17:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755625097;
	bh=KLKjw0HUWCAlCYBL21FG5N5qspieejASWPS5ip7uwpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oNMOGF7BydGVTevhYMQSzbeUeUqo3X5k1CxovpHSkGA8/jaiePBiX9OOrhENsdH4R
	 7iQWfe2b/d/0g9OrkJiy+fkXJNNgwHp9E/t2KxhkRC6Xvupy3dfvxRLkOUV6eTSZ3A
	 uAXIz8z2i47k+jghhdlvPBGJEjZ637z4/gxVNxHJS6CJCC26rLC3/iBCFiChfhik8E
	 uJKgIvsPhjEJ14VXVrqQ7eV73Mh1ABS3byCgHYlWGKQzqw7Fwc5HlIZU+usmrZHInt
	 JGWFTFFbeq8ckv3NjoQg57zVH1eKNg7U9Ry4zOulQ4rGFslisZm3zJdjHbMcDOIe9T
	 +IZ0yFZtXVoSg==
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
Subject: [PATCH v4 08/16] kmsan: convert kmsan_handle_dma to use physical addresses
Date: Tue, 19 Aug 2025 20:36:52 +0300
Message-ID: <f52ab055c9ffa4da854afe47232c7d06d109d8ce.1755624249.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755624249.git.leon@kernel.org>
References: <cover.1755624249.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6EAD880014
X-Stat-Signature: ydswn9rgzi4g1ppprdin63maiz3d6t9b
X-Rspam-User: 
X-HE-Tag: 1755625110-474725
X-HE-Meta: U2FsdGVkX199+Xaa6U0ciI2qEhUmx3ER31KxQmXjeB4pcUL1PMDgRRkinzwaAo/05BSmNu/iZmbTQ2weglgRa0nQKD78uetQtWj0+8c8lqxhOLgkwnkiK6MoAUTxo9hhx4DDJ8WfDG0R4ph1Az9T05j31jNGyN2QwOVqpbzJjY57ASKvMBC1BRQTQQnJ0E5Jrd0JfojsIyItwv/m2BMIgfO4BivmEf96KIZUjC3J1vk9lkJ4qtA38EFS31I6uwaQKD7ktRzLDHcDDxCtZOa8FNKkg55pWflfFYMFop/0ys1eWfxQzMuo4i4YCb5vRRSF0KA2IY4ZJFHvgTq/rKJao54uBTBvrxHHKXPLGuNExjI0VsAk5aMbFZx68YVR3q1kIIg+L0v+4YQF7ZeUEO7eTu5AWNYQdI/EQIusUDsIjtaXxepnNC5qvw/wdW92L742NW7tqRBrx1IkCL7V4PDcsq8tqhy7RFc0AET/Ve+EttfGPc7Yd7LQYLqwzwk2hCE66IXZpjff1+onnS+7Wc8Ky6Qi89aqcrgZaVQGu7EhVY7Z7lpGJoYtpWi3eApZQHdmj35GQu08wM76wpZ0ESgN5A3p3UuJ+1ehbrWBLkqYS3bmg6xNQZ4EK6+4GOourlti+/cwDRCl35DydA865xFrSW1Bjokxrn/3Bt+Pnw4LOdyWSexpv8wsqhAXdf/cUjN/u5+n7d+0QBiuacWlGkdGhSvuZ6tmqFHvuHz7Zo/qsZDq5zKzyY+bmGDa6w7jqyGzcBKzVdhe0Zj7oWebgCXK0j7pTa43izGoHc5W6jvmfvpIyu9Xs/vHPpNUrVDZrGm4jPNcFW941t0B/8zlM6Q8SzpFKSmFzcDZM1FX8T5sXoNOWOf/Sjq9jxO85fwieF609EP0QMGL8XRdSGIfPpzpEms/uzSbNFOAH0ds/BxhQXzva2TPBEMIpqww9qnFHyeSPPoPh0rSdPVxSHTz8Wt
 HwNAS241
 bz7yCKhszAG2F9bhKJfAJhv6HWkqhWkYMY3w352L4ya/pwUAXKfKA4zZYN4F+RH7zk1WHy3Txfj3jM+Cg6p5L3WmKOjDSaJiG65ws3JH64yIFkKA9ycH5CzbcXb3C+08jscilQNR59Ml/cQHzp6NuOYAAW3zRgZ+LhEVRyLHPff9J34wJXZM9r6EFkT1fe4esomhtLm0e1fEazz+fMMdYzyZ4CAlTRO1pzGsshncdFfTBp/PURa3HyQpHS0O8JUBK/u/MofnCtS0izbJR9sve5HxDxrHFTBe++nWXRjNs2WUTI2Xru+tyXTjPAjXTM2N7g4KRMxNWmtxlF0YCbyPC+8DTIDFGDFBxHNmce1Iwg+OW57+L0jIZVekiSaFXZubk8EoJ
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
 mm/kmsan/hooks.c             | 5 +++--
 tools/virtio/linux/kmsan.h   | 2 +-
 5 files changed, 12 insertions(+), 11 deletions(-)

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
index 97de3d6194f0..6de5c4820330 100644
--- a/mm/kmsan/hooks.c
+++ b/mm/kmsan/hooks.c
@@ -336,14 +336,15 @@ static void kmsan_handle_dma_page(const void *addr, size_t size,
 }
 
 /* Helper function to handle DMA data transfers. */
-void kmsan_handle_dma(struct page *page, size_t offset, size_t size,
+void kmsan_handle_dma(phys_addr_t phys, size_t size,
 		      enum dma_data_direction dir)
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


