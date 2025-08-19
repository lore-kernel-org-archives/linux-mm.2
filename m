Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE10CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 17:38:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77B8F8E0005; Tue, 19 Aug 2025 13:38:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704618E0045; Tue, 19 Aug 2025 13:38:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CCAA8E0005; Tue, 19 Aug 2025 13:38:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 40DCC8E0045
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:38:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0FA6814019B
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:38:45 +0000 (UTC)
X-FDA: 83794217010.24.81AACDB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7854720002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:38:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mqPmNYet;
	spf=pass (imf13.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755625122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Py7VOBxcd4HwAc7HHDB+PTMRXMSLHO8b88vcAnVEU6A=;
	b=LK7IQOi86WF6FgqhQNiBIfTLy7oNmqQqB5VKZoBJzI8nSi+PkKf950/oyLjhVERADRFAaI
	uaiB1QTkr8FhcBzX1oEjWtuJj4oFdqYqeLKDqLCd84gicngeprVSSnf49xkqCzqW2ql53X
	96qfpyPh80CGlaDeIiZq4dXi/0h8mzY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mqPmNYet;
	spf=pass (imf13.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755625122; a=rsa-sha256;
	cv=none;
	b=YfQrSI+MDA6wXMY+JTDXBop63jTY3xIhTSSvWjQT93AVEz2dzpZi5ePN7QQU94VTJR3+TP
	Ybc+UlvWwXpOV5nJmhGKW8ag3kuV/0xW/rzlxGGCEGNT7ihJ1OkqvA0j+uka/y8PTUtrhn
	K4DudF2Gnm4KqENlHqzXqQ7/zmNwEV0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D42D360209;
	Tue, 19 Aug 2025 17:38:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B1EC4CEF4;
	Tue, 19 Aug 2025 17:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755625109;
	bh=0mJoy+46tPnckyRiCMrZ6rM11HgiRAqoXhfeDURewQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mqPmNYet1sH32wQnvqz+VvZ80hlj8hmAn5LZc210nMHXG8bXYuHHo6lQnpRQ7wdDm
	 AVkPPjVfSjLNW0DehbYvlIM2mXfpwOQAjPxs6e3RlPIo73ds9O4X7lgEElc8ORAi/f
	 C/x1WmcQqUdWnZImWQk08xqztT32jxKdhvXMOS9p8adbr0qesEwjEYXcIE7Gr89B9V
	 D5kxqWCfk0RMLfyN34FLwGfWViKqrxfYSCkMcFA4I+yentRF7/d5qM2RviS+FzeTgP
	 DNhrTd61vuyUNS97sahLp3RYlTbC6p901YEbBgWhZmWbk3sGcF6U+DBlT0qK2dJfvC
	 h1+6GBB7poGFg==
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
Subject: [PATCH v4 10/16] xen: swiotlb: Open code map_resource callback
Date: Tue, 19 Aug 2025 20:36:54 +0300
Message-ID: <babeeb62fcfbafa39f352da1040a5dfa9d2a2719.1755624249.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755624249.git.leon@kernel.org>
References: <cover.1755624249.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7854720002
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: s3xez56rozt3jke7wgzrp9qy5udbujnu
X-HE-Tag: 1755625122-848642
X-HE-Meta: U2FsdGVkX1+tL16EExhKJdHJYx8Tj199uHp9eMuiUcgXsYfoN9I8Q4FWsZtudN46g9QMCnzNN8I9DFvlEOuOWYm36LExLQlS/9x6nwud/SZZjiT5p+1n1RA42gBJzxwipBJmeuzEt7znhIhvav6as2ZlM2lpLD8g7qTTFs4fJL4dzCTe2ocC1OWRYLnoHvEeah2N17g0efsYEfs7d3GIwBNO2MRJXkQuOv1Co5J5YGJeOmKdQw97eq2WugrkldU7pV9r0WBcV+V0VqACkMXJLw5PktaPIFPtUTXMHy9yxNipkndqpilbl4oeOFXALfXAWrJ0ZbmsZ+V48WTkn8IjItG1rsk61zCA4qCnaKgHjKw0ZUboHs0Vfnxm0mhmHmeKcmuX1WfrhXXctWUEICcjVHSHngrHKhmeg45K0j7ylB7cXnMlNXXpsZb7fngMVl9Iocq4NV5tyBnlAaWQ5fUwp5611pQOQtr2f+UkZuYq3gGkg4kvfBB2YwEC82/pIwI/PcaYd5tSbf5sLgwuPpaj9IfVVH6YjTONk23iRqTGlJAwKdhVq3rolIT12s8JjL5bbU7NdnCK5Zxj8e1hTlFcCb0hSKG3Bgxrp5icDYq6Zike6p+EuM1k5UOmZbycMkHvKrsULXYvRcosV3BivqduYbPxTZiqkovDXd+EPZd+7VdZaaCNXi3P4IBeDXVBfOxfD2TM1kUzf1JZnXbRpZu/S5Fbk1q5aJ+NFqXsSEeGPN1WFAm4JhUJm5JCx3DTkSv1NHNWGARyMITY3sDzP5MFZyfdahTwudq1MOLQVjwB/qnhAEv6T0HOpBx7l74FPsEG5BK6mAYpY/URCZifrxVNWq9anU63x2+SO3bQXQI8iMz089J8MiDfON08Wo0jeM/m2C9+h8lJTc2u1ZmXMADjVzusvWy1ntblzzVYra9w9aeoh3PAdsMP2exInM7yVobpx7UKURDBs914CH5KJ27
 2s9rbrsv
 MNE+BrKXm1OumJJXH9TlO2zn84SJWm8AmMf1KqIckCyhOCfJKOJqcz7ckv+EHVkFMHDAbJXXm+fcu3e3ZClwgKu50rIVbT2VuJ13ISVeqRTOaR2QvpbwVGIUn4bwv+cd3NHun96i9yDGEMyJW8gHPdhxuNqUZONsEKhNSdVgj1BWqpjQB+9/dnud0lXHbwf1BTGZ3D5zeKJTIGY8CmT+4mA5sqW48KpdzQU3U6nXSQqa4UbZ17R6rToscvOF9l9NGNBulP7Dl1iFoedSqHrbtxLnQEStx2RG/r1HEEbpTw0x+PIlKh4uSO4sKbNkGEUJhPzbLwyN1fciDnMHl9y7w1r37AazIyj4CBOBKRZBkBm11avZcUTF/IiB5Y5x+Mbm/WF4RiEtSR94Y/XE/rgY4ZuwUwQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

General dma_direct_map_resource() is going to be removed
in next patch, so simply open-code it in xen driver.

Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/xen/swiotlb-xen.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index da1a7d3d377c..dd7747a2de87 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -392,6 +392,25 @@ xen_swiotlb_sync_sg_for_device(struct device *dev, struct scatterlist *sgl,
 	}
 }
 
+static dma_addr_t xen_swiotlb_direct_map_resource(struct device *dev,
+						  phys_addr_t paddr,
+						  size_t size,
+						  enum dma_data_direction dir,
+						  unsigned long attrs)
+{
+	dma_addr_t dma_addr = paddr;
+
+	if (unlikely(!dma_capable(dev, dma_addr, size, false))) {
+		dev_err_once(dev,
+			     "DMA addr %pad+%zu overflow (mask %llx, bus limit %llx).\n",
+			     &dma_addr, size, *dev->dma_mask, dev->bus_dma_limit);
+		WARN_ON_ONCE(1);
+		return DMA_MAPPING_ERROR;
+	}
+
+	return dma_addr;
+}
+
 /*
  * Return whether the given device DMA address mask can be supported
  * properly.  For example, if your device can only drive the low 24-bits
@@ -426,5 +445,5 @@ const struct dma_map_ops xen_swiotlb_dma_ops = {
 	.alloc_pages_op = dma_common_alloc_pages,
 	.free_pages = dma_common_free_pages,
 	.max_mapping_size = swiotlb_max_mapping_size,
-	.map_resource = dma_direct_map_resource,
+	.map_resource = xen_swiotlb_direct_map_resource,
 };
-- 
2.50.1


