Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55563CA0ED1
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 10:15:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E74F490013A; Thu, 14 Aug 2025 06:14:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E259B900121; Thu, 14 Aug 2025 06:14:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEC8390013A; Thu, 14 Aug 2025 06:14:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B7210900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:14:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 785651384C6
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:14:59 +0000 (UTC)
X-FDA: 83774954718.10.E90EFE8
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf05.hostedemail.com (Postfix) with ESMTP id EF6D910000D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:14:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sgcAjNmQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755166498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CCfmBvMQcZnHpKPeupg0PVl7hYfqXMfZSFQbxGlwy/M=;
	b=lab5eN1rf81fZPX0gpbrKSRCaYBMIU8Z03KzAZ/wa5QIPR5GiHhqV64Q2BbknerhXZiopz
	aMnn3IsbJVmVImLnCm7THe25w2QZMeY9+rX4tbB/O8Um16vsEFkBIwHxdUchfCYGvp2Uwz
	L5o5KH08+XA3T/kPiy3PYAENFL1xK7U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sgcAjNmQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755166498; a=rsa-sha256;
	cv=none;
	b=owPRa5gm1MC9OxWbjckpXS0fstPkCQz4P4jegZ5k+u1hjGPemZqXLUk7ceBN0zM4ns8CHa
	jAlcgc2K4cmZuDDXa7NIzNgqnJvkn38WQHZT9LjTfBn5IVWBoU4hOf2GwVcvcBx7+k3A34
	gZ3WTCv9H4HHYh/9k5J56v4m4xUPEek=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 6F71EA5685E;
	Thu, 14 Aug 2025 10:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E732C4CEED;
	Thu, 14 Aug 2025 10:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755166497;
	bh=VNpaHZYPDKoIVZk7JizQ+fAc7bXMl6IIrMQIwsKC7lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sgcAjNmQ4H9PR9eNw1PcsrGYJZDdCoIhSA00MB1PlPh4PY294zzHjmBNp/Feerkz5
	 onfh+H4AOnhzfctRKBnuKCZx/TKbia4qDj/ZGv49iPN8pTjetV2F9L2VUkgOWdWDRc
	 XlrdyafRknSjL//iLlaNOBweJcYzh6FKt3CyXPCoJvTLjW4fEmAhBIfd9+UAEg8Pzu
	 GT/aO6y+QSatuf+mIF+REo7cmsN0/u40Aqx/jFMMVRttbv3XnuIdoCIUPj7ks/cy6e
	 xakUo8h2pDLy9UhEDhcLSzeOH+G0q/blCWi158fJN5vnT8J/3Fmo24+nsmO++3Zqz5
	 MlYCBR+W1ikrA==
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
Subject: [PATCH v2 15/16] block-dma: properly take MMIO path
Date: Thu, 14 Aug 2025 13:13:33 +0300
Message-ID: <87b7d3a0e3f6be9da49947923d52355ed0835833.1755153054.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755153054.git.leon@kernel.org>
References: <cover.1755153054.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EF6D910000D
X-Stat-Signature: maqnncofa6w6wsiuug9fkcbxsp4cijnb
X-Rspam-User: 
X-HE-Tag: 1755166497-877965
X-HE-Meta: U2FsdGVkX197PNzha2CK6oehCysWdM0CVj8/9nIH4EdkvILiiBSAeN3cQarFDKOaYFXJpiP6iRj9u9x5uPkNh7vOE+FtMDy67H4BzcKxBNECJw3NdeQ3DNKch1OZ2bmpD/7D/FYRqZFbxRwrQRTeTi0KiGA6HSQsPoTRDPMVm7+eUa5MRl9mwnPrMxIJbXSZWjfVYGixhH/MacmVnF8re2mxkSRpoi3Q4DH9/ol3wxX2Ak8VHmLtw5x+UF6NaUto+gaJ88UiDiVHT3k3XPj/zBGK0AQcQZmLSVPMQ148EWPkoZmYs7XiV/Kc6OnF9riFHARb1x1xSvP0MZboS3BOqtl0+GI/I/jplwyNrgqvGaydBVPfLFN+3AtfG+ul0+pBccPDW3tLZP+SC99PXdfg15Fv7TtamTSpYESqndH7/iPN7iOrOT78vLTguZjnCLUzVp8Hf4JCQLjxDD+FKB8oNCopTwvJo0Bd0VZywll/8eZICziMmiD6TJ+Ml16e1+ZH8VqzGbxS430/39vSFQWD793RQbubNKXrxN4GrwLsL08t0Jjnb+25VpinLP5kxIVjndu+y6hcDxYQZXM7Zijpdhib2IhQ6z+W72WLjUXeLmFtDn8Rel0Cqby6X4slvTwez+oCCWjKqzgofmE+Nv+lvKMZtXmJsUOc0wt00q4rgK3G5fYoYrIvRW9ZvWU4ulC4XO2xQtQJfMJW7g5/hCWi9qPPY7MTcgckPjaZA4iUTBUVX88u678awoPEnrJCAzeZ6wy6ztVoQGJL6AoSCWd0tujNepm1kLl7Fplw+VKOc/l1NRDSJXrBj7eaIG1Oq3CYcIp5cHTb81HhoFMLoQcCeX3GVUUQZkrhXtefOTH3JWXBUZ4FyuX4QOidVgUqdfkBefn8bs8VibbwZXJaV9lpmSU+WDqIZJtxofX+B2UIMhVCc7SSZfS0/z7zbd/2Vbn0PJSp5s9zR9HETLE2Xh8
 7vVE/IdL
 CTKmVN3OEzNw2ssoImwKQ2JUW5M6A50jO0/LjRQOMS3jbUBxHKX7Aa59ue+q2NjLU3qndgG7BG7GJOjh0CcSRfcmuccuhJod8FmBRHqspXSyKkIJ1e1orw2iKwyeqTiOT19C1i4j8b1Z6e1IQcHMdldQzf59veNXMvfojiOGp+RZGeEq2UYrtPlpGaJfZIYCJX9fqAoCbFqA14KntmDMP/t5uN/BpwBXp2Fa0qHXWO6jS7KkqkQIQNs/1SJ20BEqD3/EIwB2/pQVvJK2+OPacaJ9mLMHLxugfSreKubcCzBAZAN6dyk6oNSziC1xUTf6NrKSc/htNkMLviPhYAs/iQkrcLg==
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


