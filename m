Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7F0EE668AF
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:16:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84D396B00AD; Fri, 19 Dec 2025 23:16:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B94F6B00AE; Fri, 19 Dec 2025 23:16:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 698AA6B00AF; Fri, 19 Dec 2025 23:16:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D3496B00AE
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:16:22 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 28B941A0422
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:16:22 +0000 (UTC)
X-FDA: 84238537404.07.361AFD0
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id 49B2C40004
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:16:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of houtao@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=houtao@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766204180; a=rsa-sha256;
	cv=none;
	b=ykxjINfgX5vhZBXQD8rW+emQfiOTdBn4hPW9yuVddjxZ/pk7pk9JnkJUUf/jhsTzUnxFBU
	jxeT8Hv1xfZ/cnEVNIo45h8SsmJELEXJW+jBrlX5TNapw4Ni6zgpx1x7rdjd13UOztG624
	jUXiKoY7W1T7cBQSBFlD0xC6MuJ/lZM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of houtao@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=houtao@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766204180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=52FytA84TX05ZJauWansx1ZnrZwF9IDwipMMg6E/ADU=;
	b=et9KDmBVwQrm5/PHi6u3ez+T4S/D5n2GQ/sBmE3YGLleY3Um4sKcccyrAMBVv8stI4sj1b
	ESxSkOLRQ6ECn2Nku4jbcqiZoV4rgWk1VWIpN9PQ1gf01YEOtYsTmlTGygGMSpliV/qVEj
	C4TaoRllcdFw4le1pT7KJ98EyZgEYSI=
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dYB082pFGzYQtjT
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:15:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B6C114056B
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:16:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgD3WPn5IkZpFwpFAw--.56015S16;
	Sat, 20 Dec 2025 12:16:07 +0800 (CST)
From: Hou Tao <houtao@huaweicloud.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org,
	linux-mm@kvack.org,
	linux-nvme@lists.infradead.org,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Alistair Popple <apopple@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	houtao1@huawei.com
Subject: [PATCH 12/13] nvme-pci: introduce cmb_devmap_align module parameter
Date: Sat, 20 Dec 2025 12:04:45 +0800
Message-Id: <20251220040446.274991-13-houtao@huaweicloud.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20251220040446.274991-1-houtao@huaweicloud.com>
References: <20251220040446.274991-1-houtao@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3WPn5IkZpFwpFAw--.56015S16
X-Coremail-Antispam: 1UD129KBjvJXoW7AFykWw48tw1xKr1xWF43trb_yoW8try3pa
	4DZFn8XFWakF1ay3yaywsrZas8Zw4v93yUAFW3Gw17u347tFZayFyUGa4YgFy5WrWDuF13
	AF42kryxWay7AaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPlb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
	Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
	rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
	AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E
	14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
	xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE
	7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262
	kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s02
	6c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GF
	v_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvE
	c7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aV
	AFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZF
	pf9x07j4fO7UUUUU=
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/
X-Rspamd-Queue-Id: 49B2C40004
X-Rspamd-Server: rspam03
X-Stat-Signature: 7p1owsgkpbe86gsg4mrsou8n8rgytt5h
X-Rspam-User: 
X-HE-Tag: 1766204178-95552
X-HE-Meta: U2FsdGVkX1/WpeyGJkk8mqQT7E+nTzBi+OIkMGKnemtzO2vHGVfNOeu45/3RmYwDtdLiKigM3hwIZ9GyoSs/8owuB4j/StvVWII9jkElygrUUWsCTvJJjpZ6nBC97ETO/F8bAHAVgX/dq96SneAFLH0BahlBqMQSYR7bXPNxjpo4asvYlmTG4Tt2+RajfprUMuE5UVHDHc1/1DlLMAwAeG9qoJUUk71M7c4inhgP4elbxmQqqhGj4vZkroP/mj9QrOYr14wqTMGQDN1sXcuFb2ipI5o509T2+CAT94xExdwjHuUW54RqVd2uvX1YKqdInoO6VMIknvR3xfou5B/RRTKNLN/7CYQPk92d/QSNynqQwUFrMWf3lheaTcviDNenb87X8trW1qb2Jy8eKqqObgFuw+alPOSXYRBOLHl4yRMMoZo4F1dLowkQ12j5PUL6n/iugkKFFtngt6rSQQaZsuSx7eaaBXbYBsEOB8xUYY36gySgHadCYU7+yU48OBLGvbJzvnBlHGmEFKJnDqOlHaLXVghg0QYRDJ40Ifb2aB6Fddem25hNW66ez/eFVmpM3jGPHxejbMFQBVxjzqe65iKZhz1CJe+I0IIN9UAF+w5Vrenp0c2YLsk7dxoMN1XMHGJBWxhHYhqjMEycGYgbkKgVtyEDlV5O2HxlfUoMcILUDuzl3mC9uQJujA/c4Qw+9BOXeoob8FxzDqvVzwT7P0OVcoVjzR1fkpnnkEhGpWblYAKCc2/nWRBlaJlNizd4kf19GPwR6vTo2QwB2CUx/AhRJB6pAiCvqddEvVxa7bYpDP97NztY6CwcauCjBKKW7X/0bYX/XNWgIS6QAS/dHPuk/AiwygSdKr7p7MeG8CtXdGZkk+YpKVMMAqUHu1qQGOkXxGFeaypfEJ/UcLYPa5dzOlLW+iyQoMoNCgW/LkEhaHxS2Pf7Cfmt9pZuZi1Ggq/PdUaXOf4pTbYOYoH
 ofp6yx4S
 VZoXU/gKXGOySKwXrZfkKHWod4GKuFKDl2mvhZH2IEITwB93nSab8wIYxvmzQuaMqo7acXz+Fn1siqCJC+4e4U7sFpohkcgdfwilhah0oM4KN2/rv79vsMg/3J/lU4eFnnUGdDmOt6f/cI2E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hou Tao <houtao1@huawei.com>

P2PDMA memory has supported compound page. It is best to enable compound
page for p2pdma memory automatically accordingly to the address, the
size and the offset of the CMB, however, for nvme device, the p2pdma
memory may be used in the kernel space (e.g., for SQ entries) and it
will incur a lot of waste when a PUD or PMD-sized page is enabled for
nvme device.

Therefore, introduce a module parameter cmb_devmap_align to control the
alignment of p2pdma memory mapping. Its default value is PAGE_SIZE. When
its value is zero, it will use pci_p2pdma_max_pagemap_align() to find
the maximal possible mapping alignment.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 drivers/nvme/host/pci.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index b070095bae5e..ca0126e36834 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -79,6 +79,10 @@ static bool use_cmb_sqes = true;
 module_param(use_cmb_sqes, bool, 0444);
 MODULE_PARM_DESC(use_cmb_sqes, "use controller's memory buffer for I/O SQes");
 
+static unsigned long cmb_devmap_align = PAGE_SIZE;
+module_param(cmb_devmap_align, ulong, 0444);
+MODULE_PARM_DESC(cmb_devmap_align, "the mapping alignment of CMB");
+
 static unsigned int max_host_mem_size_mb = 128;
 module_param(max_host_mem_size_mb, uint, 0444);
 MODULE_PARM_DESC(max_host_mem_size_mb,
@@ -2266,6 +2270,7 @@ static void nvme_map_cmb(struct nvme_dev *dev)
 	u64 size, offset;
 	resource_size_t bar_size;
 	struct pci_dev *pdev = to_pci_dev(dev->dev);
+	size_t align;
 	int bar;
 
 	if (dev->cmb_size)
@@ -2309,7 +2314,10 @@ static void nvme_map_cmb(struct nvme_dev *dev)
 			     dev->bar + NVME_REG_CMBMSC);
 	}
 
-	if (pci_p2pdma_add_resource(pdev, bar, size, PAGE_SIZE, offset)) {
+	align = cmb_devmap_align;
+	if (!align)
+		align = pci_p2pdma_max_pagemap_align(pdev, bar, size, offset);
+	if (pci_p2pdma_add_resource(pdev, bar, size, align, offset)) {
 		dev_warn(dev->ctrl.device,
 			 "failed to register the CMB\n");
 		hi_lo_writeq(0, dev->bar + NVME_REG_CMBMSC);
-- 
2.29.2


