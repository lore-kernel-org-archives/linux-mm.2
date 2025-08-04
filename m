Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB5A4C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:44:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88D3F6B009B; Mon,  4 Aug 2025 08:44:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83E076B00BF; Mon,  4 Aug 2025 08:44:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7053C6B00C0; Mon,  4 Aug 2025 08:44:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C2F16B009B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:44:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 27DA51A02D5
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:44:35 +0000 (UTC)
X-FDA: 83739043710.07.455C648
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf28.hostedemail.com (Postfix) with ESMTP id 924AEC000C
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:44:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D+O9BFW9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754311473; a=rsa-sha256;
	cv=none;
	b=H7y8RMmDsbAZKJ9DKyouzdQGvKNiPmLAzC5Q6dmYG0H3JYsO+aaU1akNSrWQdipzOxL2S7
	v+/A0BGwL4gCbQLbuzLPq51OGNzAh3Z8bpy45XAyOrGYXGOEt6tbeHWnNQl6uXXrmkuLQV
	WPrFQdmJEaUVxBBGW+VPMDYcHwUBmkA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D+O9BFW9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754311473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rR472IjdMKe4w8RfO8gWCXyzwltO7zaZbCaEciZCZH8=;
	b=71W8xCuEsIZvBqgogWHf5vu8d/CzxYVwoOzc5mMZuRXJPsYl7ihjHeeDHZh0CYA9LRESdR
	BzP+JcD4Ku8duBC8PrXx5YowRQqI+E3/rv+w/Ik03zzR1FVPD4Ra+3fdE2HuTyvkoiifeX
	I7D5hYibCs5KoWojXXFR+TI/WTv5cwA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 10CE7A5586C;
	Mon,  4 Aug 2025 12:44:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBA4C4CEE7;
	Mon,  4 Aug 2025 12:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754311472;
	bh=Aje2MY5jLtJJ+XC6L21HodqK1MreNzlcX3KM+Qptt24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D+O9BFW9G3EUN02UNr+9W1wRCdRDfRkf0x3nKVoSKF3qgFSYQkjSJdutDyO+/GaXc
	 LGLcj33SDyJqVULCEM37MXdFVYsGALxSAZY0nHbzSQZTnFerxjcv8C6TboBXWH4naX
	 6ZVZnkDzbfO3eKo22J8zcBZLzmo4T9kxSkmi7f07Z+UGaRwrQIMopajJOg4vYfLx6+
	 jnSQUAfHfWhVCjNaPp3bPAtogKMoVHj2Hvn4dfigZthAzfffhOXJp1Yoe3nvVjUnC/
	 ShnNJR9ewOfC+QlOtWiwtM5Xx2GVbLWurX258r+SmOzIeAJTmd4uYs98RHNcdlwqdj
	 Y4q80UzvzmD6g==
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
Subject: [PATCH v1 15/16] block-dma: properly take MMIO path
Date: Mon,  4 Aug 2025 15:42:49 +0300
Message-ID: <d9b092cde0f42bc6a8a1cb36ffee3478c46a3599.1754292567.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754292567.git.leon@kernel.org>
References: <cover.1754292567.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 924AEC000C
X-Stat-Signature: 9wekmcm7wg4jo9k3n16emhuhcdp1u6kq
X-Rspam-User: 
X-HE-Tag: 1754311473-53059
X-HE-Meta: U2FsdGVkX18YGWyv2yIgADpo0e9u3b4rniUSAVuHgnop5TcvGa24G4dGcRNjfsRHkeRysQXA5dEbNRq/xYtF7hKWpQqIRLYu6tvtwfhf3bDF45zxhiaZlQuaeiJSSySumuGoE5cIwiUBmjl3PmucR2virm+iIzgj3PDMDVFZHD3EVnWbu2aW4MtWjLm4khmvk5fDqjvhkXVy4CAD3+jciyHyUKTIPtFeKe9qLLC41X6shschtLd3TgMipRJxJ6wYNIqrLHGOyiCxpu9g/hDnqatJXxwGgAItuKaitXmEbhJewON8ITZNpYf3g6yff0E8wKx81imG0SwNUKmXCoLqBE7Mf0HShbQNr/nkTMtjH+CFpICAFKvecoLgGCHj9/jgEb7UUaRMz0pIxCBg9FibDhgV2flXQ10o8bX+1w4UoBW8hFRJQfh0lU9zf4McbFlJiDq368cmWAb2BB6aMXIJFQgIEojsOTE2zvCi3V8QIhy18FpP9d2XIqtKGMhbyCwaMWP414yDLX7JRAtZz3Q/hLO2SRIR9M8yyMbiLFj4/s1hP8/lfrFfk2OswnpXYYw7Iu9uA4RzBtqn3+MFcy/V5HSuaGpzT70GaupC2vA1BlmMlWWS41cb8JBoHb3S69hLcQ7AOnH+fqdbGoxFB2aOThObjPvxGGRTYGZmW2w8X5to8R9NvOisQDTWFZvO4iCoalc3jPmKXkIbqzD4kXSQEZWRYQI7db+EniK4IhXhNtRIPLzww+pBUEnszrpP1dIZy4BXQwbatLV+TmJt7sb6PGdfJG/V27kdcJ3SLfd5uWkce7KMRUJLPxVfAqpqi0S1YW3Fu7/KNQMRAackNsCL29ETVW7xoUj9K53sR5tqTRa9wUZEi5VnVPHubD4TTTYF1wLyyagoJcx5ac2tdnUDwGVZllLaTfYKF3NlnTS6bYGwJYijUg5J/44mvxrdZURHuEafRhTL9MNIDNDABU3
 oEgqLYgc
 uUKRVNKrggBjwVRvVBB97QjNu1e92J/o9rBhr+GPbyHrOtkTfIq8bz68+Fz8jOs/yY3RYNVra7VcsQ1OI3QwZEgybCUksW9e0MLeMBUkav4atq6jZnyv5cY6ji31fnuvwmHmrLC38Kqe1jinBoRIVjiZWn8/WiInKLltOg5Fq+q6kNRSEMrhKZ++2n1+LWOXigPRBntc/OAM2WnomPzvssxeRYgO/k3gUggS6O0jbaarpfpbCV2DdOeWjFchN1Rk6huArMwvcgqSkwZ+XKEewGth555vmm9jcehlaSi3l1Z2fZ8PpFg4kKpXypjxHgsXceslwkwQ7Q/FeI48nlTCjTk5NQg==
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
index 37e2142be4f7d..d415088ed9fd2 100644
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
index c26a01aeae006..6c55f5e585116 100644
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
index 09b99d52fd365..283058bcb5b14 100644
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


