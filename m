Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92ADCCA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 14:50:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D84FE8E001B; Tue,  2 Sep 2025 10:50:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5BB48E0016; Tue,  2 Sep 2025 10:50:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C71B48E001B; Tue,  2 Sep 2025 10:50:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B812E8E0016
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:50:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 82AFAB6DFC
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:50:08 +0000 (UTC)
X-FDA: 83844595296.23.CFA5B0D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id ECD13C000F
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:50:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LKY9fKoZ;
	spf=pass (imf28.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756824606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uyX2HSlErhSx4hWPy535LrU8E2hScx2Y8ibgCTwqAm4=;
	b=48P4v/9a/1Qu2gbrMFMoS9oHZriBFmVpp1IH99iWHpMJNO6jZDhcpm2VQ8E0RYbJQnn1sc
	aEksuBGi7BZKrdiStriNS+PtLzLzAzh2G0pOEtHXkGX80E6fZcywjPDAxETVEfF1hFpcIE
	7WcNPaHJ4XUZUsNgZeOfK3FB3B925O8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LKY9fKoZ;
	spf=pass (imf28.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756824607; a=rsa-sha256;
	cv=none;
	b=FqvVmEsJlJdgojhPwp8m05mf7OLLlVdsPCBLKjINE44KcMRamYC4yPoY/A2ADvqifVDIh0
	JPgOtBbCD90r666RC5WTfLNPQ2i0IwEt9D4z/2J0zO/aN/kd5B4+HPTJa+cwGOV5BXGuBR
	CHlkfiyNeVb4pl0CCXcfkmLXMScgKpw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 63B9B60223;
	Tue,  2 Sep 2025 14:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36EC5C4CEED;
	Tue,  2 Sep 2025 14:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756824606;
	bh=LO26BwKAcM5bzAy5+YIJkrmuLLytzpcl+we8V4Bhs/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKY9fKoZOkueicaHrUccAoKo/BCx6mgGEeI1cqKthujBHZcr0grk1DET+0qz5Nn3j
	 X04UfMZEYGgOAdyBKbdv3EPfUfaCtaHmX0pkTRXBtHe1eSWe+6/4HHjjh1fCZIrwFI
	 9u4k+CxQYWnfdDbRqzv9VvChyCpccmAzs4QD4X/Tb26RvsKJ7RFD5Cp//R7boSucJj
	 9OjWn48Lw0oVFJJbBnM3GtjtMTkhWTqDbczjxsHp85mixuHu1ODHv+b4/ZI3zPt/sf
	 2V6wheinrYkzZWQgXJQybZfQtO7DZfnbugbPgpjLZrYH99wuatKrAavrSz5zlEbB2g
	 MSo533i8qyD0A==
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
Subject: [PATCH v5 15/16] block-dma: properly take MMIO path
Date: Tue,  2 Sep 2025 17:48:52 +0300
Message-ID: <a640e74c8f407ed46dcc51e0f704e0a128cb4d3b.1756822782.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756822782.git.leon@kernel.org>
References: <cover.1756822782.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fy6wpkijpmf6jafubbjqpii998b9nmfj
X-Rspam-User: 
X-Rspamd-Queue-Id: ECD13C000F
X-Rspamd-Server: rspam05
X-HE-Tag: 1756824606-807835
X-HE-Meta: U2FsdGVkX19Df9dmerbvX9lpR3UgKxE7qoTdMOnEy6Qb9pQ41c3oq8YZJtWpdU4PIDvu65YaMZw6HDrl7JSWfLRfhgCOqEcpZorKKqT8dD7OfFpbwOIfHxIFuWKHd4TLssG7HD0B+nowA8hkU2T4RZCe809ETHZwG5wBwwuK0eHUswHgE+me/hSqISVaGunYaKdYJTFwYpn/Pb2hOhWaxqLrVZwhYlMqXdbPxQQ2/3YHrdJNK2uwecS0mQllLZbTDTTIldvhpY39OLB7QyFU6+vDZQBvwpWEYnu/3Dkl7h8CQTQlR6uy3ZuFy857L6c+5/2mJ0SPnOm5LbY49G98aZE1wDgkWzFTgODcQoMceY50sw3klYZYfQys2FJL2+TYbBznSz+SoGoGi28iGN+pqlD+yVx0YfbqvLkLQohze7uUlgFIUEgFE9Bkc6J0ObzlEPQD/ACB0gLZ3SrtXmTiyXWIZBFeLEewXy2OLzrkK86YgyHM7uNFnnpbsKVhHKmlM52K3Ug4Sjx0mwNXR+y0gVzQc3ABT9IjfN/6U/WzzQ/GIA/w6aq/8ozy/E2PfFSMPE9SFkD95+7aYicy4UR+nqFNRhMHrmMY8egEuuBbH8NKKk8StlEWxH+PcHQUR+Q+UViL/dC0xucMozWEErGOxuOqVFlhlY7lLmmwGPyl3VtVzXXu4X/WzBXgK+Baq0xqgSoS+KWKSIK3rHaAcwIjPMQN4X07chfNQ7rUiUvwiw5SBv7mu6xgGsgZtZyzy1uCNtglFLoOWfwNu74BtQHPwqtPgHzVPfh/xmWPDfPSKknSE0LQxtEVK7XxV6Fc4iXZ7frRpPo9vSFDp578aUCw0mN9aTD53DWMXm1lBGVzHnV+Ts5v0lDWF7zvxWmdz7QZms7iMSUW+0D0Beat3QdKTrT66tThUmZq9svCuxInIM28oB+NFVoIfr8Z7hqIKuswGvw6HBlfacZCfLJQB9T
 UoIdDbUK
 4ledR9XukYPfaJ/Ab8yeNDRq+v2GsgBuQ+dh+2aYb9ysJXHvG/2vDLkUJPoML4itUv08bqNkqJN5vh5Z5ZQBCeYD/1y0912vfrtag73cYwrZBfp/WK9lYMJn3otQE9cC8QNSu+mz/2gJ9D63Y1OuSl9UPqsZG/+7C4YYIE1foBsyFsJ650EhBO9HJzT5Q7cBkdEyRx5wsvgADbRuthzMu57s+BEWch0S9qBDgDk5P94rS4YaffqjqaQilUGgoSTNXl+DC7Zxi44+/m0Bfj/QPPBNBd+g6LouHyzUjUigbcsM0ICvSQJQdgWdtKId11tFTFHUyaOqGqdBGP3NF3yfvCesSL8R+9z0fzUolqmmQyWYBxnY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Make sure that CPU is not synced and IOMMU is configured to take
MMIO path by providing newly introduced DMA_ATTR_MMIO attribute.

Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 block/blk-mq-dma.c         | 13 +++++++++++--
 include/linux/blk-mq-dma.h |  6 +++++-
 include/linux/blk_types.h  |  2 ++
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
index 37e2142be4f7..d415088ed9fd 100644
--- a/block/blk-mq-dma.c
+++ b/block/blk-mq-dma.c
@@ -87,8 +87,13 @@ static bool blk_dma_map_bus(struct blk_dma_iter *iter, struct phys_vec *vec)
 static bool blk_dma_map_direct(struct request *req, struct device *dma_dev,
 		struct blk_dma_iter *iter, struct phys_vec *vec)
 {
+	unsigned int attrs = 0;
+
+	if (req->cmd_flags & REQ_MMIO)
+		attrs = DMA_ATTR_MMIO;
+
 	iter->addr = dma_map_phys(dma_dev, vec->paddr, vec->len,
-			rq_dma_dir(req), 0);
+			rq_dma_dir(req), attrs);
 	if (dma_mapping_error(dma_dev, iter->addr)) {
 		iter->status = BLK_STS_RESOURCE;
 		return false;
@@ -103,14 +108,17 @@ static bool blk_rq_dma_map_iova(struct request *req, struct device *dma_dev,
 {
 	enum dma_data_direction dir = rq_dma_dir(req);
 	unsigned int mapped = 0;
+	unsigned int attrs = 0;
 	int error;
 
 	iter->addr = state->addr;
 	iter->len = dma_iova_size(state);
+	if (req->cmd_flags & REQ_MMIO)
+		attrs = DMA_ATTR_MMIO;
 
 	do {
 		error = dma_iova_link(dma_dev, state, vec->paddr, mapped,
-				vec->len, dir, 0);
+				vec->len, dir, attrs);
 		if (error)
 			break;
 		mapped += vec->len;
@@ -176,6 +184,7 @@ bool blk_rq_dma_map_iter_start(struct request *req, struct device *dma_dev,
 			 * same as non-P2P transfers below and during unmap.
 			 */
 			req->cmd_flags &= ~REQ_P2PDMA;
+			req->cmd_flags |= REQ_MMIO;
 			break;
 		default:
 			iter->status = BLK_STS_INVAL;
diff --git a/include/linux/blk-mq-dma.h b/include/linux/blk-mq-dma.h
index c26a01aeae00..6c55f5e58511 100644
--- a/include/linux/blk-mq-dma.h
+++ b/include/linux/blk-mq-dma.h
@@ -48,12 +48,16 @@ static inline bool blk_rq_dma_map_coalesce(struct dma_iova_state *state)
 static inline bool blk_rq_dma_unmap(struct request *req, struct device *dma_dev,
 		struct dma_iova_state *state, size_t mapped_len)
 {
+	unsigned int attrs = 0;
+
 	if (req->cmd_flags & REQ_P2PDMA)
 		return true;
 
 	if (dma_use_iova(state)) {
+		if (req->cmd_flags & REQ_MMIO)
+			attrs = DMA_ATTR_MMIO;
 		dma_iova_destroy(dma_dev, state, mapped_len, rq_dma_dir(req),
-				 0);
+				 attrs);
 		return true;
 	}
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 09b99d52fd36..283058bcb5b1 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -387,6 +387,7 @@ enum req_flag_bits {
 	__REQ_FS_PRIVATE,	/* for file system (submitter) use */
 	__REQ_ATOMIC,		/* for atomic write operations */
 	__REQ_P2PDMA,		/* contains P2P DMA pages */
+	__REQ_MMIO,		/* contains MMIO memory */
 	/*
 	 * Command specific flags, keep last:
 	 */
@@ -420,6 +421,7 @@ enum req_flag_bits {
 #define REQ_FS_PRIVATE	(__force blk_opf_t)(1ULL << __REQ_FS_PRIVATE)
 #define REQ_ATOMIC	(__force blk_opf_t)(1ULL << __REQ_ATOMIC)
 #define REQ_P2PDMA	(__force blk_opf_t)(1ULL << __REQ_P2PDMA)
+#define REQ_MMIO	(__force blk_opf_t)(1ULL << __REQ_MMIO)
 
 #define REQ_NOUNMAP	(__force blk_opf_t)(1ULL << __REQ_NOUNMAP)
 
-- 
2.50.1


