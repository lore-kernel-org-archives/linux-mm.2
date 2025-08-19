Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14519CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 17:39:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAFF38E0053; Tue, 19 Aug 2025 13:39:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3A918E0045; Tue, 19 Aug 2025 13:39:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9012A8E0053; Tue, 19 Aug 2025 13:39:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7910A8E0045
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:39:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 49B88826AC
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:39:14 +0000 (UTC)
X-FDA: 83794218228.12.14D1118
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id DD73CA0011
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:39:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hP0G8Q00;
	spf=pass (imf15.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755625152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o2CfBR34rERHeCycfJu/oeNhZ6WULnoBhGEgp0otVxA=;
	b=HX7x0Bjgztn4P7Tp6/QxhqwbwZEVynWVhF3UfOh85afhIZH3qEbXgsJ8sXngzv0AnfThjl
	5Qxt3hUS+jN58NZVynXcnFwXMXmD3BbNOeEm3z0hyctbckvQioHD2hFHnAiJPBqnIFf2oL
	y6f7WCFcFN621nkeu/Xp1OTXI0nh9TQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hP0G8Q00;
	spf=pass (imf15.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755625152; a=rsa-sha256;
	cv=none;
	b=UC4P3nrslSLvzVE302zjkM3df+qp2M6alNI9StuROw4lPeRfaEk4EWcQELrcN+o2bOOv3J
	+LfTFSynN0BthebQ3koRCS3kg68LDxneCPS5oK2Sv66BRxT3zhtRVvYYQX8vOGO/qYEBLK
	dLF3FQ+3Z6bFguMyo5DdFcMiq9iJAJ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A73A61437;
	Tue, 19 Aug 2025 17:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44ECC113D0;
	Tue, 19 Aug 2025 17:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755625141;
	bh=shzOb9LxCd4j9ffIAYJARd3Ll/bIHN63Rdsm8jF6HN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hP0G8Q00yNTh5FfM8EvmXjWXPCW1VAkoQrIqWO2opf8nY5Pp8kyRoAQ5sJbskFxHe
	 Dpw2oE6bb6R9DP3zDSAoqrpgkr4LknFTjksf2ZVtrQBA00wb60mjNgoeDWPO1iTMvR
	 mOZkqJAPBVE7i3vpf3SqAKzTQw9K5Rc7DptngH5viddKvezFNMaYxTj51UPsnXjIa2
	 zH66GE5Ky5jjWEuNnqpxi+DfDo3WTnC7VWe1CnDp489D3vz6rDN4s4/RlMVvekkmmH
	 q8YXIBSj9tnBwBYbvKw41cRhfgSA56D3XB40ha8nKdeMey7WqJRapAA4sbPWPZyDe2
	 vdbwCoOpeQYmA==
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
Subject: [PATCH v4 16/16] nvme-pci: unmap MMIO pages with appropriate interface
Date: Tue, 19 Aug 2025 20:37:00 +0300
Message-ID: <545fffb8c364f36102919a5a1d57137731409f3c.1755624249.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755624249.git.leon@kernel.org>
References: <cover.1755624249.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DD73CA0011
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: btqdzydw6nbw6uct7r1f7nkmyq5tiuoa
X-HE-Tag: 1755625152-814157
X-HE-Meta: U2FsdGVkX19Qfs1DdIVgjx0pkejd+QoSo7G5zfkgetpwPn9bZNtlUIumhvUiHWKOhdSjHdcETcechbrpLi7Nc923JkgCkq5ZsbJe4WkCjQ7n8RU++rbhsuuoDr1j7A6QZe0wkfYahfc3KlMSJtuap60ir5Jc+GsKaAn5n1BGPXdGTKKdAMxgIuvVdjTspPqxFYF/i5v9d2yvHwBLS/EZbY4Ol3fwOk51O15VODZKkGVVhaQahXpaI1nPUZEm7ZawgdvVTYlvB/8OaR9rJ/D6BYCcP2fkEzv3ufSvONcNas2FUz1UxMdpst3V6Tbp9C5jeK/jv2ohK2JFGz9jAKY0u0KTvHypG4KjfMNJhahDAkNFaWCtR9F10PAoxeTVzcAuvbo+UHENopWXW1e53R4WTHOnGRGrLab13KDDsVjNH5IvGZ6UMfw/4hEwYO/sc2zaFjqKRDTn82RL6V7IFcx6HjxB3Rh+vJr3IIebJ49QPjDv96QEknh7N8cmix3XuN9mGPrrZdrYxfM0HvteT9/fg0WouQwMnyDwry+V4NKaPIaEKccBlUkmlSZ50VZq/ABOePUBzqXfEu0X4UaPKVwc6JAQRfTB2NaYzLVqlaoSPKvzktfzZwIn0o0aEfeUlvouctcFLOGMEms4hS/j1+HarozKq6p/lsxF6O1VMzuemMtce7kqYkm1sQ9SA1C6iAqT+yGSgn/vTYQ/E8fapQKzrhEsFyK3yFayRoY16o2YSDEP4U88INH1InaU+zoMEAKTvZXj6FvQsF2bs1QV8Y+UGqdk9WSNKUqJlJYwCvJ6F4yh7zffQ+l3iO/8Y/RugSZpuMXPvjxHH33JpqCmDliMzIfQgbq5/GljkK1sfBy6o/idr45HcRDJJ8upoWw/9GPAtmFYFDASWgbT9H5JIvcYH+JU7rLWEM5/RRe/BKbXkozPFlYHjsKy3mJe3+Xw/ZBtdlpts4W+Z8Ap+r8kcXs
 uDsFbQ0o
 P7pehgANq5XiFlzFbMTtlVWOX5ziqNAPY7sqNKmkDaYW+oSEYl9BSvO9ctxnRiB/zlj1B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Block layer maps MMIO memory through dma_map_phys() interface
with help of DMA_ATTR_MMIO attribute. There is a need to unmap
that memory with the appropriate unmap function, something which
wasn't possible before adding new REQ attribute to block layer in
previous patch.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/nvme/host/pci.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 2c6d9506b172..f8ecc0e0f576 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -682,11 +682,15 @@ static void nvme_free_prps(struct request *req)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 	struct nvme_queue *nvmeq = req->mq_hctx->driver_data;
+	unsigned int attrs = 0;
 	unsigned int i;
 
+	if (req->cmd_flags & REQ_MMIO)
+		attrs = DMA_ATTR_MMIO;
+
 	for (i = 0; i < iod->nr_dma_vecs; i++)
-		dma_unmap_page(nvmeq->dev->dev, iod->dma_vecs[i].addr,
-				iod->dma_vecs[i].len, rq_dma_dir(req));
+		dma_unmap_phys(nvmeq->dev->dev, iod->dma_vecs[i].addr,
+				iod->dma_vecs[i].len, rq_dma_dir(req), attrs);
 	mempool_free(iod->dma_vecs, nvmeq->dev->dmavec_mempool);
 }
 
@@ -699,15 +703,19 @@ static void nvme_free_sgls(struct request *req)
 	unsigned int sqe_dma_len = le32_to_cpu(iod->cmd.common.dptr.sgl.length);
 	struct nvme_sgl_desc *sg_list = iod->descriptors[0];
 	enum dma_data_direction dir = rq_dma_dir(req);
+	unsigned int attrs = 0;
+
+	if (req->cmd_flags & REQ_MMIO)
+		attrs = DMA_ATTR_MMIO;
 
 	if (iod->nr_descriptors) {
 		unsigned int nr_entries = sqe_dma_len / sizeof(*sg_list), i;
 
 		for (i = 0; i < nr_entries; i++)
-			dma_unmap_page(dma_dev, le64_to_cpu(sg_list[i].addr),
-				le32_to_cpu(sg_list[i].length), dir);
+			dma_unmap_phys(dma_dev, le64_to_cpu(sg_list[i].addr),
+				le32_to_cpu(sg_list[i].length), dir, attrs);
 	} else {
-		dma_unmap_page(dma_dev, sqe_dma_addr, sqe_dma_len, dir);
+		dma_unmap_phys(dma_dev, sqe_dma_addr, sqe_dma_len, dir, attrs);
 	}
 }
 
-- 
2.50.1


