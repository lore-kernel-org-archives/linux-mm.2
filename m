Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89191D637B2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:16:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B9A76B00A9; Fri, 19 Dec 2025 23:16:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 490A36B00AA; Fri, 19 Dec 2025 23:16:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 345296B00AC; Fri, 19 Dec 2025 23:16:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1B9636B00A9
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:16:20 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C8BA7C07E2
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:16:19 +0000 (UTC)
X-FDA: 84238537278.21.33B29E4
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9DC8F1C0005
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:16:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of houtao@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=houtao@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766204178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KT8JjtzAf38iL8X+gBQNnh0tR7lsAFfn57Ng7z4QAak=;
	b=wHEjwO1japSzFkqHPkGIeaZyPLjSMryfniL47m2wZq3rfLJNTP49c5LN0V3CxNOPfPsa9u
	D9MvN9ifYIp+fkea8zsAS6eGpDgLPPwWlhE0RouuRq7UyQao0Ivr4lEMKrTlBErYim/YZq
	qGw+64ydCgued/1sA4WGTqyu6AsO+T4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of houtao@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=houtao@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766204178; a=rsa-sha256;
	cv=none;
	b=Bnz0+AwvlLG6mxDDYmEURe2iReCERgpaBCzThkfLEkOt6N8J8v6JpoIL1KLeFWnKPEwp+2
	4g9yKUG4Csb2qmdxxHJsEjxPXbOy0xSX+20PVwdCZ2R/9kTDSo4YmLjHysWcLVpj2YUmzb
	SNwPN6eA4kgYZeMEdKB3ulEojKRKYJw=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dYB0V4XdfzKHML2
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:15:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C671F4057D
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:16:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgD3WPn5IkZpFwpFAw--.56015S17;
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
Subject: [PATCH 13/13] PCI/P2PDMA: enable compound page support for p2pdma memory
Date: Sat, 20 Dec 2025 12:04:46 +0800
Message-Id: <20251220040446.274991-14-houtao@huaweicloud.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20251220040446.274991-1-houtao@huaweicloud.com>
References: <20251220040446.274991-1-houtao@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3WPn5IkZpFwpFAw--.56015S17
X-Coremail-Antispam: 1UD129KBjvdXoWruF13Jw1xKFWxGw48Zw4fKrg_yoWDWwbEvF
	4UZ34rXr4kGa42gFyqy34xZrW5tay8Wr1kWF4vya45ZFy09a1vvr1qvry5Xry8Wr97WF98
	CasrCF1I9ryjkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
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
	WrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF0xvE2Ix0cI8IcVCY
	1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67
	AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZE
	Xa7IU0FJmUUUUUU==
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/
X-Rspamd-Server: rspam02
X-Stat-Signature: f5ham46o97dwdmu8cge3bfew7bgigsd6
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DC8F1C0005
X-HE-Tag: 1766204177-52843
X-HE-Meta: U2FsdGVkX19Uvm0tjgmZaGQKUHfWCWlDveOnWpeJcxSgqFAyCY5zdaGtPKYdHHQc43gr7BY7XNZC4fk2lcThKpzD/73UNFzwBqXcC1dvaDRgLnjujmhWnXsFPonTqzfH+TJ+eyGccLgDfJ6o08pG4dDPovAtWEYZF69ORaPfSJ+6Y/dBHqoMVIwg7iHX56qf9chbaGQ2nMtq1hvn/ySYGVkQbohx6fLTeAsE/43tej9tHX36kJE32LWKMKZeyE6sUXxRltJGVIFr+gAIWoICZ8SRdJ/Ih+5wEwCkQyqLvbquCZVQWIB5FYOQQrfRqiqjq3dHtbdTBEdouQiC7eNzdkvO82frtoyjvnrvjNfAXN8l5cBF9Mr/n4HKfvKS6X3G+txKrRNT91GO4hG9X11HYmGqnQv9SDhMV+1P+Su5Mt/ONtcO8q4S7sOMXNTcbNlzvh6rLUwpooutZwZaxO3HzCE2/HfuWdFdfwo9MF6K7BQ65CD6C8Zc/UCJ7X+6Bu+m4D5TCqXGsYZTdazWpD0aqEgqzyRzTtlF7LFNZHZQ/OFSeRRxkEeUfIDlPvnYUuky/zrRPSXALTfwV+MXpzM6sV1qlkv4opYhAg/eKnBZKSomsjEWku+1LN3l66AYvN2E+vnuA/cZ5jd0tj5AfSN2foZxum2NkCKQxnlIgv3uhbgfwHBwGarrME+mLJ0Cv/xWFRKR4SA2lwAGJNZg7vKbdPSh+anVx5s9X6xQcZXftFr3c7xNGXnPrBnmjYpB4wU23H3uZT4YUCRUKpHcaSzIc4NMN+Qfi8ssmnZ4qC+xKYUUA+HqGkxmFA5AcXNXOV3bAqnpRlsQXC0rNhRP/SHK/QhYHk52fjvb04WAkbwZXCO9kNAs0mjK+KI6owU4qhb++2fPRvn5pRZosI0qiYuo/UzDYKjnNdmHHcqF8Kf2TszPn+g+IDSo8gBjheFXbalOhI5CjPi6zhZ+JsJCmTe
 ekSFaG+u
 ukdlwGvFrj956dw6lGlNf2/Y14Cd3FSiccewZ8rSpTT8TK++S5VFSaEmhsEbWO5Or4adohjNlsLDvlya1ghtLTrH1ajQsd9UjDHYD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hou Tao <houtao1@huawei.com>

Compound page support for P2PDMA memory in both kernel and user space is
now in place. Enable it by allowing PUD_SIZE and PMD_SIZE alignment.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 drivers/pci/p2pdma.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 4a133219ac43..969bdacdcf8b 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -452,9 +452,19 @@ static inline int pci_p2pdma_check_pagemap_align(struct pci_dev *pdev, int bar,
 						 u64 size, size_t align,
 						 u64 offset)
 {
+	if (has_transparent_pud_hugepage() && align == PUD_SIZE)
+		goto more_check;
+	if (has_transparent_hugepage() && align == PMD_SIZE)
+		goto more_check;
 	if (align == PAGE_SIZE)
 		return 0;
 	return -EINVAL;
+
+more_check:
+	if (IS_ALIGNED(pci_resource_start(pdev, bar), align) &&
+	    IS_ALIGNED(size, align) && IS_ALIGNED(offset, align))
+		return 0;
+	return -EINVAL;
 }
 
 /**
-- 
2.29.2


