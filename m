Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37638CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:55:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C87D59001C7; Thu, 14 Aug 2025 13:55:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C394A900172; Thu, 14 Aug 2025 13:55:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B28C19001C7; Thu, 14 Aug 2025 13:55:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9DBE4900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:55:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 68E3D1385A7
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:55:12 +0000 (UTC)
X-FDA: 83776114464.14.C06736B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id E20CD8000E
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:55:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M2Mnp3BW;
	spf=pass (imf30.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755194110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CCfmBvMQcZnHpKPeupg0PVl7hYfqXMfZSFQbxGlwy/M=;
	b=uch/15zIihje+M2EJoMX1SWv0vdF5L3ffcoGb9PfFvSgqicuVeYDRztLrGGldeGxG268Id
	x8FdQcComwvSIUtxiNxK5E8heyUt2vaQSu2WrzK/G0/jDzpyLACkTpJb/oCVZPBOPFssTT
	bLLPrLnMRTZq524jts/u8+jhgvelaBg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M2Mnp3BW;
	spf=pass (imf30.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755194110; a=rsa-sha256;
	cv=none;
	b=qi97fQalcZyEjo1wqPH1K1fbzKbCIQ7LctaJIb16kPYdTuEX9aPs0qiebZSZQ3WMiPJePw
	tIToaF0WKnkZfoTLi/PWz0bmwBE0R94NhcD0YRZCKPbUIQ0jyMYumhK0KoNmKfd+W7UO9Q
	nNNHuPRSSgl150pLJIonmWCgA0toZGo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C823601D8;
	Thu, 14 Aug 2025 17:55:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765DEC4CEED;
	Thu, 14 Aug 2025 17:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755194110;
	bh=VNpaHZYPDKoIVZk7JizQ+fAc7bXMl6IIrMQIwsKC7lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M2Mnp3BW+NvPJt5C4Sa+m7N3xsVvI1PpeKOHABnYT/vsqBqQhN2aLvMQnNynxEeAf
	 jG+kWZtMh48W66QRgQVMl/nvjMqjsy9+E74nO/CD2HT4kLYU3Mpwjb6twcf8C3Hi4c
	 2+Posv9gcGORRKK5OlA0AbDJ7mN2IvDl/9m3YJLUUXqWT+rCGcxmptcDx464MwQkm6
	 RaeicrSrrijeM0dmFtQ16WUZR+XakQqQ7kOi0XQLbVsC9gFu1fGTGqeqj+8lEQxfmc
	 nPia317PiXQksGzD9LHJjd8h2SO8LgOmvjbc0XOA4r3NKpGeunr34rUdDB90w5gr0l
	 ihfxQKBWNsLcQ==
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
Subject: [PATCH v3 15/16] block-dma: properly take MMIO path
Date: Thu, 14 Aug 2025 20:54:06 +0300
Message-ID: <b82cf88cbe69db93a98bfdfc90f11121abb973cc.1755193625.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755193625.git.leon@kernel.org>
References: <cover.1755193625.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E20CD8000E
X-Stat-Signature: wx9xnfk53wn9ormntyfxzpcaecfp1g7u
X-Rspam-User: 
X-HE-Tag: 1755194110-846509
X-HE-Meta: U2FsdGVkX1/2Pod7x6ydi8Rx+Gl80sg79lf2niyW5k88OonPv8xvyr8ekgIzLXuG6fs7piv4N109dqt7W1TlrU9EZezrqVrnwuUQYM2z/q17CiuKOnCty4h3QmCHGvF4xwSpbK2S4rE3XCfDz1OP3KH2MgggJZEY9WKdfoi7zFfaVw/V85bQp7EPGmYDljUeFQm/bl764jts0FbHc3j/wogHKudq91nQRc8XDDdedrh49GFcMTY8TLM57ITNU9tRVVHqgRJykPC2ko+nLp7B5QvO/VxiPh40FhjUMC2haDoqGhnaJpVHHjrynqEugB7sR1Fe9f7TkoZ4UC4cBzqPcVASiDp+4LuU4fFxLEL5/+AaMYNaXijtqViah3qF7QM6Q/36KIecGud6pxUnQYzRKuVNqfI/B30euFYgbGNJQ2Oe8MBBsQjKywYmRm7kfVEis7sHZaFOfSI+CXbU3fFa0BopgdVH+pC9O89nfs2mllBXSqZVJRuvSvUOGFgjzmXV6IWsE3yfg8s8KKmUTdIgQ6LTTM7aPNhUbuLqHfGqYbHIEZ0Vr62i464WVEMKXdEM/HywPPO2MYd6q6OSDmRbm4tK8VzgaAkkeJx0ie+G5muSgx0231MAbK6Ll2/f7fSyHCC/nBbiZDvm9Q/8JNQRWzblHqCCTGPEFKw9qBykPkyelCAfr/LI+1OtU8YD3vO/DpTQNlOSrQD0ZCifNFHKNilhxLCUfE2V8et6fIhsDrE2v1ptoRCqk9B/b9DZWRa4cdTWmFzLz3mU5PGhhXCFjwy8lOACsvEN/CBqWlU61wpLJ/JftmzSTFJoD4yhNp5VRhRCWWwipIuwV/e2dIFRMSvBFXkNIILajrIHXs04te867vohSE0PmAkc34m9Krhrvc6EbALoUZosmml7LktwTSlUAlAbCZsUBmTnRg0qf9BGg226L8jAFqb+jxU8jaMiT8WWL6VyITReIhG/zT1
 7b2G6npR
 QO7/M2CowNMDFfgurBkIIzn/Br1aIBQZSZTozHO4I3XDiQFPdoKdpm+GrqWSRi1iP+3eJMwren0x/4Ms+he2CvXvb90UdpBgLxln5uVf+CuKkB6WyV4CGI9r8Vmecgaot7XRhVJv7Uf8U6IDHjtd5icLmyUqg9iPjcXj3yIKIbGuWcVOF3To6euUuD2GeSdjIm/yZMWskSHtQVDoHbSQOv03i1JNwmbFcDpkXXHFSDezlBp9pH7HUgIHiP5IlXxFNTk3AEOguZivXs17Njb+FYNfEfyRlgAtMXhIrw+GjtQVGDQb9qpxwvaUqQFqtO6rmhadph1x/f3T9Cklaa3dSnw4Htg==
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


