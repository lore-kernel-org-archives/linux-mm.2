Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D38ACCA100B
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 14:49:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 286B16B0027; Tue,  2 Sep 2025 10:49:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25E368E0017; Tue,  2 Sep 2025 10:49:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14CFC8E0016; Tue,  2 Sep 2025 10:49:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 049816B0027
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:49:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A1A651601F0
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:49:38 +0000 (UTC)
X-FDA: 83844594036.29.144637D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 154111A000D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:49:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CCnOPMO8;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756824577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Vl1Om3dLVLF61K9r5/nvBAzYD5mRA5wX9zobMvy048=;
	b=rv+O8/kwFILcJox2g26I77RXfGGmxnxqYNwElIqJclBY3m2FosFCJEKlhSnwmLOqBQfx85
	RF7a0hnKkjZNSizXFyX4XNmxDzaujAcB2dL/+RcyCQol/9op76ZhXH76VhylfIQRzuvqK9
	ujf5nZKYmoEgzLkgIyzcBbc8Y+MbJLs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CCnOPMO8;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756824577; a=rsa-sha256;
	cv=none;
	b=44onhrCny9slwUpaiPc3lVeXBQ4rZZePKTXbLBZ8wi0x1G2qyy0fLCxHbbAKvcYOLlAX5V
	SZn571WOsjjDVZ+DlYzTvutATCfsU4rvhgeRMdWm5NVaSybNTX9H0qzkLcnk3MuAgw/TSy
	PilmT7KjlMlBVKj16OAEDlAagSjy4EY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9473A60222;
	Tue,  2 Sep 2025 14:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CE2C4CEED;
	Tue,  2 Sep 2025 14:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756824576;
	bh=sM+8A+mz8+vtMpvBupjrACoA7oSb6yM+3fTTBdtuWbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CCnOPMO8OIfrdGQAw+IhIZhMZWCRKoDf4dQGPY29Dd/hDfXBfnF+b+xOpOG4qpI+J
	 AHBThBcabS43lQECzg9G+ilemXSQ+Y8oPbO5KYb+db4yDJGohbLypwTIReUbV3pDt7
	 b1zwjJ9TpAgB3K3eJ24kdhUiG+Wng+01rXNX+6t6LyxkcHwvqQWKSM1yPPkKgtMVlh
	 yn6Nuz2D3XZYCPtmAwCWYcE1iUpyYvDpJJafVUMXys4IVp1R9kAJAx1wKdWT2kOeAm
	 9vHzCM0WTGj6hP77HR+YyjtPFUvn0xAAW8QrPmD6XiDoAW9WhmKB8bAWqfa+hYHi6k
	 B/FMTB65CPigw==
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
Subject: [PATCH v5 08/16] kmsan: convert kmsan_handle_dma to use physical addresses
Date: Tue,  2 Sep 2025 17:48:45 +0300
Message-ID: <9f59c7c5ca21b39cdc90696f270ec6b04c92abf6.1756822782.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756822782.git.leon@kernel.org>
References: <cover.1756822782.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 154111A000D
X-Stat-Signature: 1dashbajo1egki5eqo7u49ubfnk63ik4
X-Rspam-User: 
X-HE-Tag: 1756824576-297136
X-HE-Meta: U2FsdGVkX1/dLFHIiTEJhZVzcdr7QxwKKA8S6fH87dDK0JNEfvPXnmd8xX7XRi3jb7XI65/DNZFpWrjCKG1t1slNwSWkGttLYngZx/JbG6B9E3VNjSe02Kz80a3uJazHozBKhncGNBOAfkaZ7wTyc5CODA6W16LF124Z89gYWhPvkmTsOTbxk8r/HvGNsKrHezN2seuV7ObdCvctXFv2yZLaXzQH1wIGnWtfY99p4KseTsbPQ4er9bNXQox5HSat85ZAS5iClODilr7szTRSyCxsRv9ZhEWz9K+SfuvaOUmVfRf8jWFTT3X5yL1+SQaKSgtH9X9YYw8C0tit9DVDQOZerNUl0sSOA3cns4rlbLrlOX2d+8GmTyBEmpBiQKQme/kumcHKN0vcVw8E9XdXrMh+cfv1Ja+CGCTo9KkFXxA6km8J7g6fyEQMvlYr4Rdqitth/0jx/kaDYPgPhgmCDjIKFrbeo0eatW6IS9oofAL75TrR3WrWEHu1wF7wvfFXLWm6iGAd+g5TtCt4J/gykyLtflrT5T8nam8ssbpUbuSVtRoa9jAwzDeyiBTvMcV659IOP3Qt54mWoWKYk9PPqG0wVBG3v8BWw9F9JC7O2jXrObffWhHaZxWp5/JpDVmfYP0hvQHOmdebMo65w+qlBeeBKK5ZlUTdJzmFU/hWtvvftserX6F258XaQzdd282yDr3jEVDOS7v2EfARwtjcPwxksF9DRbLcCi893pzW6IocsunclFy1bQdRX0TStkGAcKahgJAjEmziN6sFaUiP932RYn7p6W4RQVole4xpEf/HHnkBN0CRcespM7rMpzz+wvPugZ/sccA0w4tVIs+xKX6gfcS4VZ+rUDMcWTT6NCABFuYbNJ7DbG1XJ4HWnrHIkWkQluAihbJ3qskY5vLG29i4uXmRcmO40q845+87P2HQYqtMIqmKK91JlJFu+8ipK2BP0mLlFW0VEoLK/cP
 B9X5vU3V
 L2WK+U+qMGIwcG9kZ+567IYxle6fnzEvv/+cxDLxklUU3gFsJH7lE9YIZgmrIqFLbS3JLeJK4m69O4zTVJedHXyuc02sYLn8/oGUZq52UUqMJCVTThnWU+LV38SMXoFRnlqBAYy0t1oRU05sc++RBOhn44Yi9EohNlo6uR50aMnp7UokoPEMD4XrNmQG6UFId/f2hQpjmnOeSoH/XleGRamTkQOJQRGGVY6nKQyLIOhEKiHXaPZ2iZvQO6g378IVX0UiAoFS/CHRe+Sf8J6HiMtkcRU20JhQeU+rRKkesz3LGM2Fx2gOR8o8rGlNzY2jbjFUZ7VJ3z7CKuMaBIbNnRViG1cpmq6+kaFkRnDVK8A3pvt9exl4gg8rHMegU0fe1/VY4
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
 drivers/virtio/virtio_ring.c | 4 ++--
 include/linux/kmsan.h        | 9 ++++-----
 kernel/dma/mapping.c         | 3 ++-
 mm/kmsan/hooks.c             | 8 +++++---
 tools/virtio/linux/kmsan.h   | 2 +-
 5 files changed, 14 insertions(+), 12 deletions(-)

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
index 97de3d6194f0..ea6d1de19ede 100644
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
 
 	if (PageHighMem(page))
 		return;
-	addr = (u64)page_address(page) + offset;
+	addr = page_to_virt(page);
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


