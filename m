Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB5D2CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 10:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 880D9900139; Thu, 14 Aug 2025 06:14:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BC1A900121; Thu, 14 Aug 2025 06:14:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AB0C900139; Thu, 14 Aug 2025 06:14:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 57089900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:14:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2B416117A7C
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:14:56 +0000 (UTC)
X-FDA: 83774954592.27.0E8BCAB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 76CAE1C000C
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:14:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RwtkFi9v;
	spf=pass (imf21.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755166494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o2CfBR34rERHeCycfJu/oeNhZ6WULnoBhGEgp0otVxA=;
	b=7LZnbPPzQoeFJedEQDrU+emYxQ0oZDXBz0GFGpp4BYQYsk82y8Cx1XjnLscziODos0+/ue
	U6JULtJs5VjYfW7COg2J/o/9kLzqmNwoC5aAXwT5nyyJmxlBKaSjjNdQbdxEPqKXkWKQSF
	e5gsIDePqzKG3+aBiYQEM1hVvDPfmbk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RwtkFi9v;
	spf=pass (imf21.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755166494; a=rsa-sha256;
	cv=none;
	b=VvdCf6EMUobwYToJWtcwGUjuPWd2s313eq3I1zAw75on2bsPtJ9qvUxyOf93dM6EGbyaq9
	4y7D0SAdzYHyXolf7/1wcPcYKfBF2zm2EIcvDqniMRlBsW2c+K9LNYQwHjzpdvCcT+7f/E
	SrgyIJA70hU1VZaD3hUOjkJ1uEoKo+w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E68E44BCF;
	Thu, 14 Aug 2025 10:14:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83831C4CEED;
	Thu, 14 Aug 2025 10:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755166493;
	bh=shzOb9LxCd4j9ffIAYJARd3Ll/bIHN63Rdsm8jF6HN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RwtkFi9vteB7SNnxOINAfVVUhLA75/hNiImenRxRpTUTI8TqYSofzsX3M8h/8rTIh
	 4QWP8THLxRW6gU+8S/mzSPOOG6x8rYFgcZDNCbhT7UxXPdUWuvEoyFaeJaY64pv3bf
	 aM2WilqB39uUngQc9QC3BxKpFRE2acHYaXIiBGXf96MZTIVvkc8hGE2g3GeVufaUAY
	 Pahp3cNRZAeYoYU4m5F0rhSekd6fRf9t4UXQyTjP60g4dbDAGjC6k0Mtx2HOptYqCe
	 dj3aQKRD06I0yUWhvM5pDgRBXBPVd/w98NGzhs5a7JOifOnDMl87vVTNIfrM2JZfyk
	 wh9OTiv5o0uyQ==
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
Subject: [PATCH v2 16/16] nvme-pci: unmap MMIO pages with appropriate interface
Date: Thu, 14 Aug 2025 13:13:34 +0300
Message-ID: <a097fc4adf58836287d451db6eb4527c6664f7ff.1755153054.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755153054.git.leon@kernel.org>
References: <cover.1755153054.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mjjzdsf5qz8zimundcq4an5ku99iraia
X-Rspam-User: 
X-Rspamd-Queue-Id: 76CAE1C000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1755166494-278376
X-HE-Meta: U2FsdGVkX18B9rEfieajLUaAXPu0ZBXNwS2tt5IAW2v4cBvuid+NANzD++/wLXJYzZgBbpQEYrpNzsl4aAvu6tnvlbejSu/GxsU1nxSGeIhZs4iXWhPGpv6nLrZiRGRJX/V2VZV16dU+1SvNXlA5nWSsuKUhydaoGr5NWEIAzuH4+2NKLLQK76j1SeBoAkWO7oR3BRQXQ6noSByjRp+m8/7il3wFIu/4qoGTdochahjFvmeYuO2v7xaVDcVtvdWD2oLr1w4T/UtFNMe4Fs+lIbxP4pzFuHoDwj0kYidFvovQINgibgPfd3a4agyfdTlM+AxaxoErEAIQYt7w9IjsxoCl3uJzGKs2QkCQydGLSJWS94zU84IUFO9fphyuGaE33Vn+J94thYPLU0aF3O7CWkqLq3DtDobEQYeZF6jbYYPFpYn4W32+vIphmDrwdIG4xqjqepTfvC1pCkHN9WJ9zhp/5ilA5fu+8RXnGwjgqQIdIU/mtaEh55LIYMwyBHDj+5zaUqWHHnWIWAwlBNy+ts6zywm3ETKughjc/AT3/HX+CJyk7kBc/oMSf+5tHrKv3njmvBmLvrJuvjHGp/qcQYSgmx8FoIl0z5RwYUOpj3gk8ULVn5pq/S5TmmoqcP4syigSei1Lus5f5PI3RWV+OOO0HED5djY6v7W5MpOWAdLheDs/uhK5H2B4s3JkiSxPMXcclGaJzbvIQzF5aoOvAjQxRKQWvGthUoTcdtRipZ1VFPC6p2Td2wkSU73TYSfIjRssk/b8Xjhijenmzhx9Z1vhQrZHdMeDm2WHqAwAPoPJQ1kvgkU3g1ElEP9HKx87d4vuFuMbC416am2z3/xLf1iwGb9/uclwEFnqGtBv4OtMzHP7qWWocFJTnVcDU1S6Y4WoWuMeDsCKKFqrRfzO4+8J0P7dmj/KJHofiZbYfj2uhHVfTnMqo3oVfSyQ/DLfAWNUQt5wGjyIlGJEaEc
 gb+9iOjD
 gR2Qkckw8ZvKhxLcwK9YzzTBS78Th3GQhof//L3cPyIpjf4zcVT66WI/QE16WlDgpbISdl9yxgYvEVX/RAaIiV9crEfKY4P5GAj3zhQLGYnyzFzyVB3Wuq9d81OtJjcDv32iCesIhdovmytXbScYZgEC0K7fAcaLL6f9ng8dvwbKYWAYT/LlpVNqX/qNLM1ls+oAU2NzQVnlC/x+xLTmR5rmUHweGtcM2j1cVGlW0l9cZHEXT5Am6HTisQb4MlLnwznA94TPlEATiOnKNzWwQinvls+lQtLEkF+IHC8TMKYNouqNb839HTD+SzAUOOeCH5ZJJHfhMl1Yo4aKBMJGZM/b0FA==
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


