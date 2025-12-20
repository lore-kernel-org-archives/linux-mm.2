Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93960E668B8
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:16:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 698296B00A8; Fri, 19 Dec 2025 23:16:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 548A46B00A3; Fri, 19 Dec 2025 23:16:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B8FB6B00A4; Fri, 19 Dec 2025 23:16:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E1C176B00A3
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:16:16 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A5D038784E
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:16:16 +0000 (UTC)
X-FDA: 84238537152.23.B52FECC
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1102CC0007
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:16:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of houtao@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=houtao@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766204175; a=rsa-sha256;
	cv=none;
	b=723Mmjsy75mul7+D6v5LaVxbcR2FI82bql6iwXbPIf/nQ1z+mKa39jYZBjW6yAVnB7AuCD
	WHFNOHwK1gEoahAmE9oeS7X6aJXtnLQrTHP6c4zoFbszVys1uhGz6nO8G8sU8KQw+AGO5i
	i18c9pBmDy7k7hQAwwioOqCKzV66vWA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of houtao@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=houtao@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766204175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sVPlUgEnuuEygDp1iDPH+81XLBWMn3qlDgcAO6uzwGs=;
	b=kLmEzAE2heKzxmjS5glyxGQ8iEVp7ix/dXQiMJSSg6v4rLHZu1kIlIv4IC8pzWxHHXaI+w
	7LZzBPfDAw0yhPhWKvsD2wN5AH2MpRia+hbDX9MaP8IGVZBZIhXnNkoQznFCcknrnVXfsK
	1l6OffpK2WDcxBhDYvkFsRPoDSSBbiM=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dYB076Z8NzYQtgc
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:15:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 42E2040577
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:16:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgD3WPn5IkZpFwpFAw--.56015S11;
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
Subject: [PATCH 07/13] PCI/P2PDMA: create compound page for aligned p2pdma memory
Date: Sat, 20 Dec 2025 12:04:40 +0800
Message-Id: <20251220040446.274991-8-houtao@huaweicloud.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20251220040446.274991-1-houtao@huaweicloud.com>
References: <20251220040446.274991-1-houtao@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3WPn5IkZpFwpFAw--.56015S11
X-Coremail-Antispam: 1UD129KBjvdXoWrZF1fGF1xWrW3tryUtryrJFb_yoWkZFg_ur
	WxAwn7XF4kX3Zxtrn0kw1fZryjya97ur1kurs2qa4vyF18uan2vF9rAry5Xw18Ga1IqryD
	Cr47XF1I9r45KjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbgAYFVCjjxCrM7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r126s
	0DM28IrcIa0xkI8VCY1x0267AKxVW5JVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
	Y2AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14
	v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2
	WlYx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6xCaFVCj
	c4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4
	kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E
	5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZV
	WrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY
	1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67
	AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZE
	Xa7IU0FJmUUUUUU==
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/
X-Rspamd-Queue-Id: 1102CC0007
X-Rspamd-Server: rspam03
X-Stat-Signature: cqd4usc4h3sqopiei388ccjzwbmqj9on
X-Rspam-User: 
X-HE-Tag: 1766204172-360296
X-HE-Meta: U2FsdGVkX19um3JX3M0dyPg0btfk7/Nl5Ym67HnENUdGOn/I8rqNyCR/EUZ8xubPPYx6bZEMK3MgsswD/YWCHjRU6XLsGaW0DIvs7EbQijonP2GtyAOLle58PTlpn2GnNH2/JSPdXl4Qh6BdiClp2OSgc29/Yvrhndb1D0PBOx+HvxFlrqSitkb/WaLBL9Mk0LLEYh3XhxpeY8OxxPYcH2czuTmIP4808YmBAyC4r+GWceZGAcRLlX7RdF3U4wSYuqJWyxnfbX2EWABNjzG+DCgb+ryzZDZVtzodYVmH93IVI7PT1xzkOBLwXEuRCx5NxeVMB/ONrvVxZdlp4B3fOMb2pXN+8BkYIgO2VQK6ZaubWnX/Rfanx1qMb4kN0phi17Z82zPIACwN7YdwOklh/3P1FkeYwrYdfbrqzIWr8/aXWDosClLcc3afyAXLy+pjXq0KYzlgZ/GmGMXgJ3ViNhSE3DmKI9hMrr4Uj5Xnss94SZXyf5rgsKOqh0KFzK10gTSG6e7Bwlmp8hQuGHnXME1eGF883fggwiynmIPgzjisGKM51LTrchr0bJjIFLGid7I52m4H6Qj04CdvXRRtqqM4aQXBAfqAzS+QjaNNlF+PdMja0k20DWxC4lCh4CoQg02YXYrnTMh7rZq1UfSRMy2Y0tEX32bY4mcgivhDDyduKQpHw+UyLzVCWdpWAZWz6ztss4p6Mew0sgj0R3rYpGfB0eXoF9w48GVHZGW8fhLRRAAz5xgR6hItq8V3M4MVGyKXioQgqoF1GoJ7UM2goUBpTCtmz0g9ySm0sA96KYTyc6kHOlAW/KbIuvlpprscAA+StQXLfFUuo8vqJq2yeCVTJ3NGmgU5Hqp/cIKWAjvyT9ysImzznT6Q7TQ/BNUn8qPne4FdrEAZeeTUCVnYjXfZuO8faACUhfZm9YnJFuPPwRU5ZsBbftnNPYrgH+77IziGK1lCpYLbnJ7+O4i
 Y37xw1d/
 1Dtjn9ZFRYuGSmeo8h5valwzUWbXqKhz/KCqLwJbijUsl4QumtcMFQNLB/aXcL03JeWWq/Boa9CM5PFL+JgufMw1KxcDTJnixm1DA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hou Tao <houtao1@huawei.com>

Commit c4386bd8ee3a ("mm/memremap: add ZONE_DEVICE support for compound
pages") has already supported compound page for ZONE_DEVICE memory. It
not only decreases the memory overhead of ZONE_DEVICE memory through
the deduplication of vmemmap pages, it also optimize the performance of
get_user_pages when the memory is used for IO.

As for now, the alignment of p2p dma memory is already known, setting
vmemmap_shift accordingly to create compound page for p2pdma memory.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 drivers/pci/p2pdma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 70482e240304..7180dea4855c 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -447,6 +447,8 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 	pgmap->nr_range = 1;
 	pgmap->type = MEMORY_DEVICE_PCI_P2PDMA;
 	pgmap->ops = &p2pdma_pgmap_ops;
+	if (align > PAGE_SIZE)
+		pgmap->vmemmap_shift = ilog2(align) - PAGE_SHIFT;
 	p2p_pgmap->mem = mem;
 
 	addr = devm_memremap_pages(&pdev->dev, pgmap);
-- 
2.29.2


