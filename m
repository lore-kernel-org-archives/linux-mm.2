Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97BE1C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 13:01:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99D616B00B4; Mon,  4 Aug 2025 09:01:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 927676B00D3; Mon,  4 Aug 2025 09:01:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EF706B00D4; Mon,  4 Aug 2025 09:01:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6466C6B00B4
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:01:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 948E41DAFCE
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:01:44 +0000 (UTC)
X-FDA: 83739086928.02.C8B6EFB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D6F7D2000D
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:01:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oV6re8fi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754312503; a=rsa-sha256;
	cv=none;
	b=zqsYmrKwRFl7amiYGLu/5yCaD44loEkxUrsrFHSlag2zBE4Cql1qSfrUELaeXHgi4vou0V
	q/FN45Q5aho5HXisVQGoeyfxWOG1FR4lFi9VIqnA/BiTuuTqhRp4U4dSeegz4u4hVXgNwr
	Nj0tp+HH8cZ3JTDs7BSTzhO4E/n3SmU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oV6re8fi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754312503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xhDCw3chECUJ1KEQqqun6NxBg/LPVeW/HpMyukRWBN8=;
	b=7SFdAawitPEgKiPigPi+kAfsZL7xf2YWuNtgcf9z+V+YPLTsDbjD0H6LgGq31Zj1wySe2h
	6m2ecGE6nmXfP/xQNRXOYnfRfGokqxtQd+apOtwAtRZsH5k94p4lvuQ1QdvGbdVbm8F3eg
	PiroQ/izqiWMHTsf7C+u0oL1FTtczE4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B826B43F6C;
	Mon,  4 Aug 2025 13:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796FFC4CEF8;
	Mon,  4 Aug 2025 13:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754312501;
	bh=MSxBGzEUPE37zYCyYE4jEXpC4IceAGVrySCuVXBUCzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oV6re8fiGNwYDZzCzdRzp9XpjScFB7jHhr0bUqrsSd/RU8VD1+cDyB4db1ivcuz67
	 ZbqOoy4QDgWahTEBLZIkeuGoLDtCxufGY1mXb4uUNEIIogWWDZKxvNPNgmGAOQfthR
	 M88oaFlWV16G0mYbetwlnMeQOqlSTPkZtmJgNfx1DBxt8qHsi8vzBGtgUSwzfG/EF/
	 +feKrcxhDRe2w3XUDGmoRDhE/Z6LPttQLNSWEXlBJ9NMAhEVqOVOLoQfSfWwEFlJa9
	 t+8VS5mhktJavv7v+cSijhYGtO53nybwj4RxWUn/B2l2HWenabrQ2aR3U+cNT0+v2t
	 iMQ+fAg6U3ZtQ==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>,
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
Subject: [PATCH v1 08/10] vfio/pci: Enable peer-to-peer DMA transactions by default
Date: Mon,  4 Aug 2025 16:00:43 +0300
Message-ID: <edb2ec654fc27ba8f73695382ab0a029f18422b5.1754311439.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754311439.git.leon@kernel.org>
References: <cover.1754311439.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z8acrmsskz6gagigytaqhdr1f1r7qeih
X-Rspam-User: 
X-Rspamd-Queue-Id: D6F7D2000D
X-Rspamd-Server: rspam02
X-HE-Tag: 1754312502-564139
X-HE-Meta: U2FsdGVkX1/MKcuVSf+ybu+d0N5CozIy9R2tSnh0NExY9CgPMYSxnaRhJSKmLlGi1ZA0atxiHTDs5un8XkiXqkau4t5xYPvUL0raoO6cuxsUoc0u19a9cbAWpjAWmw2/YVZ3hjVgRykK36Qz9LXx2S1D6Um4w4XgqJcoFpMJqMlO2abEtY/5OFZ3kXEt1OhCARpUCZaIX+2cD6/84c4f4njgmRdp78qaXchHC6W8xqYCW+sKu0Jg0CZ3cHy2iH/hWSKxTEcEc10frYy9ycZkMp9xapUFmO4tzN+T3x/WSlgTJIJ9Q0rjTqiBw5WwvqeT3wW5xDoJ6aKaDpAmR1hOC5WqxR6vVF3pf+pO1a27nDIEWW5vgF0BAe3LCr6AB1OJj0Ah69QKj1wFHAzPDfdBiemR+LnVrqOVqfrcd6RTsK+Rqfh/Fp/Uvg+BJeRvwBl5EovZtBmevv5/EumBuaXBHs5M/zI0itJgbjapHSjy6ri5u1BNnVRZoJPUA7GNnKJHnrgGfoPr+toUbMsV0WajKtpZR4n/ySIbkMUki+Q5qLlIGi69bO0Q1f7zCtQ0bHLC9Yd0SZHXJArADU1F7q+2nEHaoibSR5PUEFasjPOLS12w6Zc/TKi666hjjJCh/p9fVCFNYBTRn9HXvE+KVHoYwID8YU0cbI5DOj4tglcykv8YnEqsV85+gObRqPvV/CyEjgM9jLMu2/XpYgeImui1FS7o7vAkUqFPRV3UfgymzXXvuIWHhKSlDsEydCWXEHvjbqJ+t4AUOdPyPf6GKvhvMudoYfmlh+bHjkmpJQKSzsBkUxxYrXSFIXCr5blN6SKss+sXF9AtjnKqU9IPSpCsCYZwH8dflT+2pCpHQ5w/lE2pQqjiY3/WmXOQh4zyIS3PCj0szcSNR8WsnGyoSKt/qd7IXf+YbFQgPtvyiichI3RL8NNuz/7FwVPsVxCOByxjlJNE2vmg/4hrNW5H4UE
 3PLluGSa
 5GQR2TT9fwiOsWAbb5smy4Nm0GikYIziFHIegmYuFmzE+oIpE649O9aM0SkpdWwDaW6V2XK6peZN5yWDg5pFA5d2WI+fkstPcGPAbdhGy13dvr19DMjp5gVMUjK1qpSjS563qklLJHxVMmi/IKidX/2SgE+2v+7RW10Anej1DEZ3VkSN5s3Um8s34hiRhNuYXJOXSCI6JT4e5gtdZLBUoH8utvD9jubXWKMvWaKK/hBJQUrj+Swjm+BmUbbPXD3Uqm3HdIhLAeEHab9/LBg0O/NZ/IMgxTYFh6WYPZsdQICa/dVE=
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
 drivers/vfio/pci/vfio_pci_core.c | 4 ++++
 include/linux/vfio_pci_core.h    | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 31bdb9110cc0f..df9a32d3deac9 100644
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
@@ -2088,6 +2089,9 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 	INIT_LIST_HEAD(&vdev->dummy_resources_list);
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
 	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
+	vdev->provider = pci_p2pdma_enable(vdev->pdev);
+	if (IS_ERR(vdev->provider))
+		return PTR_ERR(vdev->provider);
 	init_rwsem(&vdev->memory_lock);
 	xa_init(&vdev->ctx);
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index fbb472dd99b36..b017fae251811 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -94,6 +94,7 @@ struct vfio_pci_core_device {
 	struct vfio_pci_core_device	*sriov_pf_core_dev;
 	struct notifier_block	nb;
 	struct rw_semaphore	memory_lock;
+	struct p2pdma_provider  *provider;
 };
 
 /* Will be exported for vfio pci drivers usage */
-- 
2.50.1


