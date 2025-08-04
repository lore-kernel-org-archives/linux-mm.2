Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 937CAC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:44:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35C806B00BD; Mon,  4 Aug 2025 08:44:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30CFC6B00BE; Mon,  4 Aug 2025 08:44:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D5ED6B00BF; Mon,  4 Aug 2025 08:44:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D3756B00BD
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:44:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BCC921DA698
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:44:30 +0000 (UTC)
X-FDA: 83739043500.09.565DF4F
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf01.hostedemail.com (Postfix) with ESMTP id 257C140018
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:44:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QrNeSbr2;
	spf=pass (imf01.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754311469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TkPETycZvdzl425XaQeEjwXwnOxHyWl7Qf8kQUNymVE=;
	b=wh8r5H179dxMdKxpu7BywHEoxI/QuNWQLn720fHg6ZFjw8sCUtcdr9PzRB45qh50rBPt/D
	Z7vrFepQ+nPU3IymPvNiqR19nFZZ2tnL7uQ3MLLiqZhge/IyYHKBT6mWnvfp0ECsSLgkH4
	8OaO8Xr4JJK42h2yIGTlvPXhW3UK+RA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754311469; a=rsa-sha256;
	cv=none;
	b=x28L84bbO7O2QMnwbi+3sxdre2OGEqqtl3MTLFejGaR++oqKtW54KU+VD0zdvLaq+kichG
	YUyItR8rksqCXG2SHbXA3ty+pVOWDo5bwJtw0IWg1gyZymoE2Ud2W3b7T5WpbXLAnHBUoU
	YwSU16jg2BSrcV9lU2hXteYu7kuPFhQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QrNeSbr2;
	spf=pass (imf01.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 91E81A55869;
	Mon,  4 Aug 2025 12:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A0CC4CEE7;
	Mon,  4 Aug 2025 12:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754311468;
	bh=6qGcHzBt0dZoqM7CuRvm64zWhofh7owUAL+fgH12bgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QrNeSbr2ETjZG5USk2ip6Q5L+o73xniNPTNqJfZmeQ0KuyCuSNG0LJiusWyclzjKr
	 cFFoKUr822PG8QqKCLTd5BeFqtuT5Wy83EgwLas9lgxaOVGp8D6uZ1DZl2tq1dbKx/
	 L+omTL0ofNOzbXoE9fyZGuqE2CSvotiwsuOKLhXV08+L7k2MaQEDPsb6OddrmQRn4z
	 PSjtn3F5+SFZ4HUEL0cLcskl4nbzTgDtlLNFq79lO3atdeVNqKCn/0JzVgj9R/u+Y+
	 m0zCkfJHRbZiqlPJoau9al8Hd9lK5yTnnQg10fAI/hDh0sKrsDMMIbG+18uzswU+JQ
	 8ketKVA4tFFWQ==
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
Subject: [PATCH v1 16/16] nvme-pci: unmap MMIO pages with appropriate interface
Date: Mon,  4 Aug 2025 15:42:50 +0300
Message-ID: <5b0131f82a3d14acaa85f0d1dd608d2913af84e2.1754292567.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754292567.git.leon@kernel.org>
References: <cover.1754292567.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 257C140018
X-Stat-Signature: m4bd3144wdndp6564egscw6b9hu9cpkp
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754311468-67679
X-HE-Meta: U2FsdGVkX18lMIHDCTYYUGjMzIz/kq6vwcJwSuyyL7U5gmkqe32Dx5P40KPS4iet8pSDYEzfOuzSF0OQlo5E0XW6RWOTQUW9p5dbAZCLXzl0QAiLoH9cMh/LTErPVaXhwnrJgeniI1Llymm9rlFlEK199/SsL4B/wHPNGZ+kLbnp/ZyAi74boXaFXCzdkCkfxydJGNevp+KuM6XRVrGZxHQZRMNwd5OsLRjpTCTKA48kizct/xIpb6xbtapHfvUxBkNMeMxOtcIUTSws/Y+i1T+RT/bRHoDx60o6wnV5FT3E3aZalyVrluNGk/DrNfc6b9YtnpS+Jwmr+2YKrUgMVD7SWYaGi+GCQrEDxZXndN1qme8oCqkMMONV+usrbqacxQsH/IBiIbJ49iV2rdACRwNm6mTTAgfQDow6VV8sR2kT5P0i84SPfhcjPIhwbZ9lCSBmnMJFSnie+3405/URCse/D8aWE7sV6oBm939bZSd31h5WGA3biwYECZqfcrjVocMLCNB6wxY+HAeiN9IinJZTOZwcgW3T+xHBhD9F2jaXDPTRsX3oJ8Fsd4voEkx42BTxqOkfhGuqdAUm0GV9oDDzoa7faUHPdbP42VUQUjtmaJYdJ6atPSZZydwqLmwwu9CLBUpPvPjg3G4tnP3Z4IfF5SuQJsIzMaX77Y5KAGD+1ZbUucrmMh3llQOALkH94CLnRSLl5vZQX7SNGDB8APcN2QQX+Mz1kQUn1+YLnY0IZuGrpLHUy3CdUSDwX4s4l5U0fbj3uNZJJfL/+sMxS3ubDXxNtUpyulbxycd/rHyKTNRRcuC6tbpvACy/XRltXtP1t+qyBo+0AMVQm28Bp3fHSWDlc4VXoQdJLRPZkqyqyMAZvqPa5YE+mfrtKs8/2ivxf4TkyiSHMOd0gApnsl0RMx5SEp2Zbrq/T94S6IWcNSlT6yxf0t/Rp8bq5JCeQtD0zKUUN95CQsaZ8GE
 P6MKolYk
 sgw3GcrkbZMQpLJrGqSEz490dWzr6icb/o/2TbK02/OtDJHrRk2SCEPucoYUn5f8Ufbts+Yg4A0ccsv1R0BUnt5nxKIhI9J5rB5znrwOmxBSNvL/ss0Y2mM7PeAM96VJyne/yjZ8pKZzXzZZSvZhZWlvkl06WP9k7NRhW0QTZ9PfkjMrbdtyesSm5JgnCkhWeuVdgBvxWL8322BBansoGGx46lyuVqE6zMVWjLG4JUpvNaaRp2OBeTuXrNc3XNGg1nUAEpmVatIqKsSilFPxxVqhw8yUprBPlar3OKkrKzMmQRij0bkLz/Ly6/2FFoaQE4ShBisBI0j2aB0JXEQjiRhYnuw==
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
that memory with the appropriate unmap function.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/nvme/host/pci.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 071efec25346f..0b624247948c5 100644
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


