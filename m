Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44023C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:44:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D957C6B00B0; Mon,  4 Aug 2025 08:44:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6D4D6B00B1; Mon,  4 Aug 2025 08:44:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0D856B00B2; Mon,  4 Aug 2025 08:44:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AEB646B00B0
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:44:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7BD3516018C
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:44:02 +0000 (UTC)
X-FDA: 83739042324.05.C644F8A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id B917540010
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:44:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=REzkJIVP;
	spf=pass (imf07.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754311440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rGuRtbHmiVjjoyecHucW808Sk+vwQ2t58s6Fmx6aNN0=;
	b=7OLUxNC70H7nYNa6bXhN57slGePWhpv7a+fCrfAjNw3QKYlvMvYB7p2nLfuB5ozizdhvXm
	S47nnYJ5FmbQKDDjVUai0af7V76FrV3RuTMh4kwo/eHLC2unzj9j/ReZmMD9H/y1WFMuEs
	SOtjIuo8t8wx3E9I3VdghT4qUJZagJ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754311440; a=rsa-sha256;
	cv=none;
	b=sKMaXBX6pQ49rvS6dYN1yB618Dv8/8nIMwihedhEs+JfP7JFjKgZqitg63TZHzK3IK7RyE
	7Wd5uDrSn6jPRpWMHKO7zMrSIiH3VNmkOH85FNlmdrfvC7JyKSUJtFL7/r2PyE1X7ws9UX
	1hpUCE9wNg1I1PkxfbIlHaRjUYv1rd8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=REzkJIVP;
	spf=pass (imf07.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BB55A43C23;
	Mon,  4 Aug 2025 12:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82117C4CEF8;
	Mon,  4 Aug 2025 12:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754311439;
	bh=KD5XpS99kfAtzNwNr0G2cKeknKa6uIV3HkFwkgt52Og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=REzkJIVPP9gFnq006IpzWA33deEBq3gq/L07hYxS4b9Co9lY/j51ovFGlZKxGO1e5
	 4+8sYBN0i9v9K0mgKzmZ/QHCuA9Q46V87wtCzHKFC0ANzBr9PuysZxQhOrNozb4Qyk
	 VihVy8omfI8O2IRdV4Tyl6d0KjHEM3acEvXoNbj8+O8OXRRPHQMKadb9piVN0E1Wap
	 K/UpRFgSWAcvtvvkCiTXu1nv84wDzdAsa9r8/C/wTH34YjDjAVJPlKm4jsTlVi+zRC
	 U+eUEQKpw0KzkD87pD1mxwxAbEEaEpX1KJV4/DAHcK3vw7alfBmL84qIH19KHyRx/5
	 kND7FSCrGya4g==
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
Subject: [PATCH v1 08/16] kmsan: convert kmsan_handle_dma to use physical addresses
Date: Mon,  4 Aug 2025 15:42:42 +0300
Message-ID: <5b40377b621e49ff4107fa10646c828ccc94e53e.1754292567.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754292567.git.leon@kernel.org>
References: <cover.1754292567.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B917540010
X-Stat-Signature: c3m3ko4epi55wgqmn16pazr61rpp8xuf
X-Rspam-User: 
X-HE-Tag: 1754311440-51246
X-HE-Meta: U2FsdGVkX18obpfVJx7vjz2GFPQa1PtqFYsT8ce8y/u1CU4oArLrYiQGPxQ4xXIpcfm9UgtpH9aFeT33urkvpGLOmlO/0UwWDoEp6u/f+z8gEv2XD52yJsE47OAnIcHuYDn6G7E+260O8vqs/HKWJQy+hFmnRv9SmlIo7pUESfwN3obV3J3GIOlXUypuaYtVtN6JPaXKbFG9xlTzqDPdU/hffsYqT0KwMKnbL/2fpSZA+e6Ov63Cg0gP2A9qDQUXR9osmjhigToa9SX57iLJ9U00n1UMMzommX7VHVg4sQwCxyzvmHCYmauQOjWyZ8ZZv+1FnJPZOrQwqmc2Kmks44CpMtKAYTvQ11w88+PJOwuf+tngeOc/rZuknFCFefgg/l9UtCYZxcxNdshrbPLY0tcZTExzyy0zvpyaq7m8OoETQ53I1Xs7t2UW01fIbcbban/RU1cfGXTeSCl5Xx8yG7/EoxoUhKTXpWb8gKi7G4gRmycIvEx1YZk2urCUh12UF9Ug2xQEzlq3ZJowkg8YtK+xB3mP7GOw4X55tsMJ5c/DyLYWtjemulHUVhQOSJPtH8YCDkcfhh7NTmofgQmpvIS4cDEv5lvdfMMtYyL+0G6tPWeShw2rHO7PEjzTzz1O29F2uhcjvR6P5s9310DX7fHVfOwHltt5ac3p7suKJrO9ry7mGLJnceGRvMiB57BJwv5ks2iUYQDvoTM9Fxx3bepoDcRk4PB7Ky0Cz8ANljvFYYpWddV2Zsp8RIvLTGdLad4OyUzojRwJ+5Q/zElWbDG2/VHN3rUfgg3lugSX3RBVeDxnCJCEkXFi0eeyGoR71vh6LZV1MhE+zuaYZF7OKEncEDhCRMVYZnrxnd1tBXi3JkXOOJfu72930Kw+gzGB/vlDXyujRgp5hI2eTSvseIzISf0wu4vQPNloVofqSOFDfsTR3CqupmmD9R2zrEfIisy7MxQHSrigAMrwQY8
 UdlqszDm
 lajtRhaIqpccZWmUPW328WrC+AifZpCRgw2W6cjP4wh1j3KHgBpvhTbBNcggawk9W9g9/erfRouRtXALyPai0i0EWQuTaBKYCtYBYA1ZwDEF3OdUzit9w3Rrf2APCQ76ZQblwJVToxAC6UKQ+39pH1LRvydY4FXBvoWEfC6g/uD7EpGK/OUFDBE1R2C9+/hHOb4xBhOrS1wHsPRyGp85iy7Zw0FjY0eUetPFvJhISIrc0hshgMi6uerTPK6T3LBY5E4juFCm2lwVEteYH62DGK7ezzIOcQLnzsnkw90IzYPw0GIw4viGB556OO4rlRew6vuC2o2gls5ImFlzcvUXDmpbGEbsprRpwLfaMJ0/VyPLsVMliLNVx0CSe8/J5BsGFp65X
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
index 2b1432cc16d59..6f27b9824ef77 100644
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
index 80481a873340a..709405d46b2b4 100644
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
index 97de3d6194f07..eab7912a3bf05 100644
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
2.50.1


