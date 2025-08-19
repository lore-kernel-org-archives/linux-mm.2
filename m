Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD75CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 17:39:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF9898E0051; Tue, 19 Aug 2025 13:39:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA9C68E0045; Tue, 19 Aug 2025 13:39:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B72188E0051; Tue, 19 Aug 2025 13:39:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A03428E0045
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:39:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 67333137577
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:39:09 +0000 (UTC)
X-FDA: 83794218018.13.F434618
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id D5E64C0008
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:39:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IyxkIeqE;
	spf=pass (imf28.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755625147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CCfmBvMQcZnHpKPeupg0PVl7hYfqXMfZSFQbxGlwy/M=;
	b=tq0QBw75Ciue2lp6sNwzOsyvA+PnSzYl993GWLXnadJ7GxvDrhmSaxwIodnOQV3qy+ut3t
	EQ146gOCTBLRRw6UE8TFv+Tkl8Y+ps0G/FiTJnwxKY/t41Fdfq9ZQ1dAOVTSwSly7c+wdM
	VMaURcNOtun+K1sFGwA+FqClwhV2/Bk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IyxkIeqE;
	spf=pass (imf28.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755625147; a=rsa-sha256;
	cv=none;
	b=shEZnkW5yD++EnPQJydxLKx52ofdsjJlNKtQsIFNaKb0KCKKs9rs77uS0gjNB0YMJvdBrI
	IQKzjKk7xdJCGQt9tnVQO3TABR06g2Bcb2i3ThsP47e8qy0vBpROhsclBsePXhAX0lCn4+
	XV3B/mILX26FF1w2+YW6cnSNALwejKM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B2BD61426;
	Tue, 19 Aug 2025 17:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79912C4CEF1;
	Tue, 19 Aug 2025 17:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755625134;
	bh=VNpaHZYPDKoIVZk7JizQ+fAc7bXMl6IIrMQIwsKC7lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IyxkIeqET61j6L28Kxhyyfq3v5aCBRMD3pest0PD5Wdrjee2qJOVX3wtGKvoyv4Jf
	 fKb8DM9QeSElkknNC5Yn0qU4ikvLVS6YKQgcTDs4LrxIuG7ahLDDXTNguINLme7bL8
	 R45/81G/h5t5pFX5HgPXSAhQHYQzTElWkUeH+eN1xfrfgs/fdu6WAy3SQecMOmE4la
	 PqwB4Ypx82fCtwySYC38Ou7g6EFId6EEfFxK7AajpjwqYntToNbsCqOWjya3ep9MbZ
	 2xwiFtcEYrAsYFB002LS7F3RqkXxFxSvXOROm6dSDOFh1rkCW2YvNV3Q8WIt1qnxYY
	 2+4jMjfrMc56w==
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
Subject: [PATCH v4 15/16] block-dma: properly take MMIO path
Date: Tue, 19 Aug 2025 20:36:59 +0300
Message-ID: <642dbeb7aa94257eaea71ec63c06e3f939270023.1755624249.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755624249.git.leon@kernel.org>
References: <cover.1755624249.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D5E64C0008
X-Rspam-User: 
X-Stat-Signature: iqhj5qqy6xd3h9kaetap665hxqqgndtt
X-Rspamd-Server: rspam09
X-HE-Tag: 1755625147-955842
X-HE-Meta: U2FsdGVkX1/aP64pL7OWG+iy7KNXLEooyaMQNmf3evUeqFml6iuHFYlwCUIlgnUCryV3AhDj1upV9fL2hd7ApEW0tjw/AN0G+BRmhC5rL5jlpMD1DjV9aQO44n3mH1q1UJkCigTcI+Fvqg59s1OSN7B5H7Eb+g21HusIgkpark/Utm7w/pErV9xCJbO1uQfHzruVJz7P2h7IAM5/TWK+eMop/tu/ghzwnTrPmjf89zlAQA0vg9yBSejmKDr3H6ilaJVkI4KD9VDTW1CgqBSgospKea4ffUb5EHMB9AOaECG+wQ75QKSPDwEWevdLzhRDmjv0ADT8XkeeZDiKGuBnGsauNAOUuQsbtgYalx0bQpQB5seaZenyxRFpFEHG6cPpLb9Nz4KThO2dYXhO4IygSRHQ6v5CpjJ5bskBhYaV7pHHX7+b6LiTmwb0/QVBLrQ9o2cAi/9lbCWEUBLSD1uIGyRuLNoR+yggpggb39Q/qASwerLCQNyzSe9w7Pv10JbMGQqnQB8dbXFGZlx9OE/gvfxcRtHiqKhOV1IxSScvsOE2RdfRM/5PURSKsKhcKUcYLNzDE6Qbf0GqZVaF7THGWpM90jZvBx3TIvxWEpTH0gGEWwCTJOlJNK+WDsXeiJ4ih5I3SR/sEa3BZXbtYT2X84iWF7h8TAIYd9TL1W8G46aG1BQvyLYfMIlbQcEZTGzZ0jnc9SXjSuYmen4G1G61zDva1sJMCsMlHXuvupjebUlkzDZF4/duxmRJEGqwklpIG9+eV2ZLD8QkYKDJJm3UVO4KztHvtlbJAdJYKWFSR+YNIhg8eKv82W2iNnt7eRPd1/krq5vbB/D5LhG1VC66Mv/QAu+cLfqv2AeCxeCQd4eX+VbGf7ORvUSxLUbJSdhNmcqbePxq7lnCLCKMI2HVZqMsrNhlpfEEPB2MGn6vEUkg3S0V2QXYs4pwA36V3onG+YI48Q3Bjs+FLrgAx95
 ljp+zmFX
 T/Ut35OsFHl3/NE6jcMH7m8hntedLpF8VuRKUVknD7PFuoeF+UdycnYw/J7RHmG3IWLrJY3N6XU+MtviGOqwmWq5NEP/UBsf6Lh9O5Jf1y8vp8PhDj/vHdt9WRU9xM6oWI8o03a/gzesURj/Y3qeAh84D0nYKm9f8vHDzxLoBaHrSXddTkUxrN8NodmDVEuKqX0x8T/u07Ql/kR9eRQHdIWuoeSnxU2keMsJsESVjlCkneLIDSu1VXkC1wI0mEQk6I++B33nx/St9I1hIKM7VkMFlmlwEqT7Ub1bkQ8NPrUTHdakN9Sv0+yXBpv094AdzKLvNM8TC5irv5w4TdTTitXtKdg==
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


