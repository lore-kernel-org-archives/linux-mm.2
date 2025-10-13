Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7638CCD18D
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 15:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 195478E005A; Mon, 13 Oct 2025 11:26:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 146108E004E; Mon, 13 Oct 2025 11:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 034FD8E005A; Mon, 13 Oct 2025 11:26:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E26BB8E004E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:26:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AE6D61A0439
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:26:57 +0000 (UTC)
X-FDA: 83993468874.13.6E6FB77
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2F52B8001C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:26:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="XGXUL/n8";
	spf=pass (imf30.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760369216; a=rsa-sha256;
	cv=none;
	b=pZnC0nJ3FYflOcm/EfA2TTWBqST53Tm2lijtDocE6gWo3O//sWuxMwVfYDmg7yhsv+jStm
	sDM3226jLxCgNl79riIfCuW1f7fpG+Ub8WzwLMWN/7Ecmta4W/YVAKHFGS/BKGb6/jQg9/
	jzF3WP1FfA36dK4OD7BdY9CouqMo8SU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="XGXUL/n8";
	spf=pass (imf30.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760369216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X8Lvu5o5p6XDbVkFuAp5XNw+4Tn/weOLOgFdyd4rHHE=;
	b=VLCHt3WuJYKPESKDkvdvDzqAWbYWa9APMTOEJHGtoATqvOKWFV6RKjQmtmDwFrfjBTO1eO
	sQh1j96GcNPYNlcamKRfufclKg14Cy6D3VGAWYVsnoEywteMl7pTrgOUXEiDsZWIIS4xQA
	+51oRKjdbEjxbPTS5z1DbFuRP2Q1fzc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 995A861DEC;
	Mon, 13 Oct 2025 15:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26A2C4CEE7;
	Mon, 13 Oct 2025 15:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760369215;
	bh=sWj2rZyT42J/OYfkx+qu79O+85llJ4XsbCx+y5qZzZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XGXUL/n8MebGFtbArYlkLWAwshlP7BxUyDbGFrxA7tRPbb+hqW7iPQf3vxeSnj6r2
	 qyMXiIj9C9BDcZ2F0nCo6bRuMbB008fDQprxf9k+4qs/28tmANmSNOnpCu/cxJGrb+
	 COka5HjkPCsWuwfgYVTAypLDEUbTY3kHhsnZpd3gQRea5XwLPJaHRqkEh3G7FaaNbI
	 ckYAcFzI41VXtx3lufS5D1zKrJ1bnuqUWNCR9gTdAgyY2tIgLBP5DHqOmKUy/rRpZu
	 dVHYyq/1RY2yPEja3+Lqr0G5FINVgnG7peq1zjmqJ9aem6yi9JJ+JJggSh0tyZTh4g
	 E6DP1eCMSd9Wg==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v5 8/9] vfio/pci: Enable peer-to-peer DMA transactions by default
Date: Mon, 13 Oct 2025 18:26:10 +0300
Message-ID: <a04c44aa4625a6edfadaf9c9e2c2afb460ad1857.1760368250.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1760368250.git.leon@kernel.org>
References: <cover.1760368250.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 9pufiwhz15nruujuyr7hqn9xczpk3rf4
X-Rspamd-Queue-Id: 2F52B8001C
X-Rspamd-Server: rspam09
X-HE-Tag: 1760369216-552207
X-HE-Meta: U2FsdGVkX1/24p8Mq0DAOFcACbw1SQhoz7/TYrhr8gISpePhPUtxpoF2+bIGKutYdYKQL5eEbG02MZ0nzV1QLIvrCQAyv2A5LiEU3sSF8CyrAckDeF7gZQktZhYcWUApod192JZPi3nfaHOfHJrnC699EFw8YPNsEXhIaZgl7GExRu4+P+ihOUBpGXwdAggtVAmvCohb3Qe83gSI8BWnnlDrcP7r6OVZXAZ635JwwPyzIAAzsj12QP4ULKlndfVfR7Cb7fs3M928+2vni2LvMtFq7Sipnkn7AEL3Va7YlMjQu1bS38JiRQSdGD4vzHMqINTmfoW7GMJPPg6oym3EQWlRTR2gOrDY1yJBsZiB8kpmDaYUT8vGY9oUCCLkeIrXT5aUaYl1dA/4Z+bKhfQeu9OTptZ55RixBz5e8PW/WhrOT8TpgDU+68UJ7/lmzN65oCJPaWmjq8R1Idyaex62E5rnv7RoJH7wJO4gfLDjHJKOaenudP/ApTKt+5VOjG8jHFG82GuKsDHQOsjr0M7PsFxQaoww9QYRj6NMLH5NJswLCvIzMvK15Z0ZnI83T8Egac2HrQu+ruyP/Qn0cFpQYebcXKWStkMQcWGnSbUPMEjnFageLDxckeX632APXIDXiD8c6flKf9Dks4+hl5CCq9L0B7Dev3jIH01ZxV64w17idnXZZ8QsQ3ya1HYY4dgoVH1Jjs/4OqeWDgR1vlMV/ErBhuG7qmAiOh6T19Q4bPInQBFJrdfbYIc926NMGg86E/vFjTwRoMa23410yjdZEzkZeBEUR0Hu8hRgD1PBgux15hQ1kKIErcCwwnrL5DvCpgnYEXBCVixyHbrQ/cBa2O/MWh13GB6gVaereTKNTgexAe7ry9GCKSc9X0OnFuyf6J66E03Dk/S3pUUX2VYmJHI0TLRVUNUzuYjWQmO8UnXF1ekEDEojPK4XJBc08MEUoNSzsGOZ0TCg0Gpupfv
 pX5bPIPw
 nXl3bybCEW+pfxHulLM9ZaofYPB/BKuRNYOw4IJgDXavTOB6vtJOPlfxf5cmnCLmfoi5izE1TMvGavZt7yiIThV2zw1MyKYC713S87qi7+wyb+6vICrOanVWhmKAnA93Q+m3VKdwdXyCxdla43CR9mcYfi3IpxPq/cOiKUwzUBzmvcUvf/LNZdcYJuWzP8Q1ON2jEUepxn/OsPmg57Tvz/zi+Y0uhdl4K/o8n/Yk2cGvKSRNQfGwDSwFyOM5W4jVAPNmSbSHPScBkoTkOlm6BCO/CqBuOmpMplHdFZTEsybeTNRs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Make sure that all VFIO PCI devices have peer-to-peer capabilities
enables, so we would be able to export their MMIO memory through DMABUF,

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index ca9a95716a85..fe247d0e2831 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -28,6 +28,7 @@
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
 #include <linux/iommufd.h>
+#include <linux/pci-p2pdma.h>
 #if IS_ENABLED(CONFIG_EEH)
 #include <asm/eeh.h>
 #endif
@@ -2081,6 +2082,7 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	int ret;
 
 	vdev->pdev = to_pci_dev(core_vdev->dev);
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
@@ -2090,6 +2092,9 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 	INIT_LIST_HEAD(&vdev->dummy_resources_list);
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
 	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
+	ret = pcim_p2pdma_init(vdev->pdev);
+	if (ret != -EOPNOTSUPP)
+		return ret;
 	init_rwsem(&vdev->memory_lock);
 	xa_init(&vdev->ctx);
 
-- 
2.51.0


