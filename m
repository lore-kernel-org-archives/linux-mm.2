Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36564CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:55:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C60E99001C9; Thu, 14 Aug 2025 13:55:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C117C900172; Thu, 14 Aug 2025 13:55:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B015E9001C9; Thu, 14 Aug 2025 13:55:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 98412900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:55:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 55BC11A0775
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:55:20 +0000 (UTC)
X-FDA: 83776114800.24.4EA6541
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf08.hostedemail.com (Postfix) with ESMTP id C2C0D160013
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:55:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A2rSNS72;
	spf=pass (imf08.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755194118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o2CfBR34rERHeCycfJu/oeNhZ6WULnoBhGEgp0otVxA=;
	b=n3ru+Z0uOblp4bxPJ52Cjb7nZ3GP5TzkLTgre98zdZ5pxK1SZp5lIimXp6VZZKbO8le4Jv
	Fnp6gz5Azwx+l6AXF6WsnTLdV1wPfR9P0VzIGejB8ptJuaPua/12Vn+Gdhr+517Je9twCm
	eoFttse9GQtF2ZB6Iq2p17v9CxteTPs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A2rSNS72;
	spf=pass (imf08.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755194118; a=rsa-sha256;
	cv=none;
	b=G5FxCSBLO82YYm6csVNDmmjkx5/r+gXL4BIaBf9DR3rCwA4ZIHWhYKgFM17103Jfr+Z3kk
	XrApJQQ3cLSrweUNWXqbPU794M2EKr6ghE3x3HQuN8evqr8FrjKu/J1zWLw3OPkrD9GxbY
	K/hqj6P8YWGdg74kVxZZ1Wd+tChT9Ws=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id D46345C723C;
	Thu, 14 Aug 2025 17:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E86C4CEED;
	Thu, 14 Aug 2025 17:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755194117;
	bh=shzOb9LxCd4j9ffIAYJARd3Ll/bIHN63Rdsm8jF6HN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A2rSNS72zGetBKpBZhRpgqD/rhRKvperIaIjrbRs5wRy9RZU2ScEPi/IdUXlel8t2
	 hDgSN0G3a2Rr04NiqmiYV9jLKqGT5IVplnGBul4pnKCtb46Ped2E5ecDGN1YyZ9EdT
	 rXEjC1b3JvJImZhlMYQO6QlVt3EMPsCUGfWZr+AhLTcRk7pnn5IH6GnI2xlLYD7zEg
	 XZ0PFeMCvymXzBoe83iYKupWfZGsEJm8bskOyv5EZlnO8619JC8K6d0uu61BKChHoS
	 EV2FsRD9b3uIVJtaqF6rm99phCdO9U9AfY6/vt89TghuDzKHyGWoqQ9sfISwsumlQI
	 OJ+zBWNq9+6YA==
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
Subject: [PATCH v3 16/16] nvme-pci: unmap MMIO pages with appropriate interface
Date: Thu, 14 Aug 2025 20:54:07 +0300
Message-ID: <16e541279b4b030de54a0a2f1829e601b7923523.1755193625.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755193625.git.leon@kernel.org>
References: <cover.1755193625.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C2C0D160013
X-Stat-Signature: mmpowczr7h3d79qb4dojbriyintjo6qj
X-Rspam-User: 
X-HE-Tag: 1755194118-738631
X-HE-Meta: U2FsdGVkX1+t/w5dPk2cY0aTp+Q+oyMmYisJMelVNZawafmXaeZpFf7isaNmOtE+eSk9rkwL9pznueBSEU27fBkymoXh83l78pIAayzqr6pbsH8mvazXcGTVLW13t/pX3WcW9W8aSHcEjHLkNQ6u/OslAUevFiwlNN0yOwBDv1z5vG6Ed1J1rRWnrWg1V+gxRGt1Xr+LnDf16IdIH6gJRFbsCltPwoKjXkZD2Tr8SEX+8SRZhYWwzM+vKfpk55JzTi2vSqnzyxd65DWusUyvif1Yh6BxcZI1JhcufHHJdPAPC+0SSKzKMTUr2yUasm7d2IGmG8Y/rMW0zciSvUDy8Z5XjIsOuHB8OCNLZc24ztNowK9Cyr+aMe2sEmh93l6x3qAzPxYawtpQ5H1R7h0HvUTW+cXPEUQswlzztMjTMjFytpW8Lp93mVKSc/x2/7a9oSlNq+xj4CqWL7HKLz7xxCV9GF1ee7etVWuEzijcRPaR2p+JcxnK/ckVGGYiXw7d2zqm6MwvYqG7Ikvm6PI3c1BbjLWA09InzfFYBZnAsVGE6k7Q/LgXOvb8C8wvZfcipibZafRQCNT6NFTlXGCTzhmT2r9DOHAIJ9Wyo0tnjsOOYJviYX6O69+TfpwaDB8afEslMS2cbe/vxd2cVQyFH+0Sbj7QtjEK+M/cvuRSW8odIKeg1qnBlDUaySVXNDV6nVU3fIDQuGBX5Su9KT5/hyLqHunpPPlx9H35nPOJnX7jFFpTYOD9Nh/nVLtqpEC87RaGeVY4cFToMQRMNXCASDEv39GBUvbnsa4l9c89xxxgPFLavEMjbRfcirFfe5SM75G8uy9cQelq4E6Trb6u+R5fZpLn4+2n/+tpzorrZNwBNdMvtsYOiXn4fpDuup5s1pqJWR2XuQphoIKWi8AlT+xrBasufBO4+hn/vtr5tgTwELKTThRzBey56FJN13tR2rDilJni5PkhJtfVuCT
 Ux2T4MMr
 jIuJk2FEUndFenR5gQaaTnDr/X+CIBGrcmzbPl+V0LSlbEzsMOjrDl/qsoKo29d0grCFC
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


