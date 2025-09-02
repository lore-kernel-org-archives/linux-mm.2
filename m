Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91305CA100B
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 14:50:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0AB78E001C; Tue,  2 Sep 2025 10:50:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE2B18E0016; Tue,  2 Sep 2025 10:50:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1FB28E001C; Tue,  2 Sep 2025 10:50:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFBD58E0016
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:50:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8C861139D31
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:50:13 +0000 (UTC)
X-FDA: 83844595506.20.AFEE014
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id B5CD840008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:50:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XDqouYHc;
	spf=pass (imf04.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756824611; a=rsa-sha256;
	cv=none;
	b=WcaJUBVbyGotrCTuseJGJzyedHcUHl4Vdawm9+FdxBX7qqVfZW5OGuQoi7cTSdvOsVzHu+
	ElLezVutfw3yAjd9X26D9A6SEe/JdZQXOkEwBB9LbNHQsByZ2ZdkJCYbN6Q5SQF7qSNHk1
	4P872IDPgi8/OpRlO8bFAdiMn4c3RA0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XDqouYHc;
	spf=pass (imf04.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756824611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BsyS7NotPIOQVUQ3M3BiMUXsFzrtiEBx/U47oNkGY1A=;
	b=G0kV9elujV2neI7kHvkOmzhSWm+gvN5cBPbbgQOTvArHCy/zjP3fkLEvwsyjrAhF8zqdFk
	jBRkJwNbGppMSuKj1bBn6lUaeGVhBIfdoTNDTFQZIeZ0frtKKWdGRB65EN5KM57aVc2mVY
	3ZH7i8uzmW7MzMWEsumzT9oCUq2Dr3s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D3F4C41994;
	Tue,  2 Sep 2025 14:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF152C4CEED;
	Tue,  2 Sep 2025 14:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756824610;
	bh=loKqVytyVDIeLrj3FO1P5XlYadT3usoA9sJi/ZhWYE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDqouYHc8vRB0ajJZqK4lwxspBtMW6b4AWggjQsPi5/K2g2R10AjUbWT8azo/7M7O
	 N6Jh6bQk4hBxULYIt59wnr7HzVq+T18QfRotRvkr6SqeRycgt3KrMgeI2f9YoYF65R
	 AMah6TQRO20arumHElmz/9xJv71VS+55KKRTzUhrWxBMRXKYC/ULWECIEily7rCTXe
	 eS9NQqKv9qVWkNYpMk5mwrAgRsMMcEg2+JJNlzJdw/9SSH0fatvocB6pT/Dy/lfKbD
	 W+rnlIzxGxfqLNVSwZwF1T0salbWquRx/dFWfgfMqcj//UlZSSQb08JaE3KYrMoHxH
	 hxEoSoVhdeDtQ==
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
Subject: [PATCH v5 16/16] nvme-pci: unmap MMIO pages with appropriate interface
Date: Tue,  2 Sep 2025 17:48:53 +0300
Message-ID: <fedc4cb3d79c81dae7d8b4ef45b5b3373f6a8bad.1756822782.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756822782.git.leon@kernel.org>
References: <cover.1756822782.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B5CD840008
X-Stat-Signature: g4aygsnisuhxw3f66yb4eh6exhn4zjd1
X-Rspam-User: 
X-HE-Tag: 1756824611-938717
X-HE-Meta: U2FsdGVkX1/1JSF3tP9oI6WfT2cZX20nSUUtwziaEApUORh3yDrtGXC5leLy1DTrEkuT/TuDpcIMMdBfdyG3fxVd+BcaNzW6rf4NuDWe/D3x7GBzFE/tVB9DRyQQfhSC8hzOI7t7ac2f7kT5flLnR9AkPUw+kBEoy78mIYGlUksTIA7V7m2oOc0O1meQyHTG5LTjHRReW4z47uAkVmGrLNloxEFYEjFpC++R9WAXlmI1o/CeGK4FaPC4YB7HXPr1GAvyny9IjBRcKIFEs3ioGLWUzuDdROw1+zWL+wIANgL9SQmngBv2qvzvQL1LPskNDHM1VjWGMoT2mHI34WemqNz+mtASTUuTURDN+qHlq2mTYYYP/qs/t1r24tGcm591MiFDYIIe0Uz6i+cCG6Er0v5ELDj4dnv1yWyzwb19OYMZc53eKp8GqeCrIkrNu0iOIfY0rUQ1KOtv0kMhIaZczFQMS/Nh8ULhpTjbPZMTrH23IAAavcAYiBX2lPVM+9464y/Hr9sSylY/OrMgUhUGKsh8mdS4wp6FuiGX7FQCN/7vW07CXK/4FIPOIcvL2nKvNj4cVHKWO6NwOpLvxhKw6Qsz6nLjgMW+R1Oeb8hMHH8WSXPZ01PiidK70P3QDFZSn11WQ37XtK23nDywk1xgahA3/eF8j8JsxMeBUsoBFmblg+lYH1IiJLfdsnDuV+61jVUNKA/Wq4TpDf88BTBg+UuKlbTnk9pUr0aiVbm6GHqyaHaGCBWrcauohbaPoF5QudmnB7kB7Coe/jRnqtscjf5+86s1ZgOUVjPPLpWtEzCRBo6x/PrNhQ+7mHMHm02e3f3N5S3wz/dtWiHCiat5dcqCyePRmDICO1+xfcxnEchVq2dbzJAORDKWJbaPEt4BexKxwa3VoiTSvnyWNNNjXIPG4RHSK5sNxkQ4igztqWSxjG28tD5czKuL/AFyB+sOikzzWUo9D2HeekyhmH4
 9tkyPfMD
 7ZxUpzwtpPCG+tS/0r3t2aqh2//Hz6g69ErW5KMqaNFVco6uXv4DlxP9SU1MlJnPZngOXBS0L0XzCAGzon1QAn7puS2k6yBeU0cCM2PXZWdUdMOrKxBVp0uZH4yCgRZNBX4K7gP/KZT83Ct/YfWDE6f+Hf2I8r44vZQFkGnCBhIn3cKwmi9TATmN5Gen5N0bqjTsJCu5gwZK3ugO8GFEopLCUdx8Sdj3khIuIi+9gAa+3dxMJ8hmSC4IFOK4/DxYWvJbEo9s28/Y+7IJEklS55ioFf8ZbXEhTiztYGQ/tGyhasohandqX9z/dUHv8+1iPZgV6xnehT9sHrhw=
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

Reviewed-by: Keith Busch <kbusch@kernel.org>
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


