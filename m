Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C83AE668AF
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:16:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DC536B00AA; Fri, 19 Dec 2025 23:16:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86EA96B00AC; Fri, 19 Dec 2025 23:16:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 784376B00AD; Fri, 19 Dec 2025 23:16:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5CD486B00AC
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:16:20 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 15F228ADC5
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:16:20 +0000 (UTC)
X-FDA: 84238537320.10.DC8D3A2
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf18.hostedemail.com (Postfix) with ESMTP id A0EEA1C000B
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:16:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of houtao@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=houtao@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766204178; a=rsa-sha256;
	cv=none;
	b=nww5iPA4/Hr7XmDva0VkkJUTzFS0xY031JnjcvAh+Hhm7qVfjK193r0BlhoYUVEPPVXAYB
	TywyK35aBry9aHns2t9Z2gdjTjbnoDW/VqWd5Z4WihLcaspp9Dz05vEzvAdyDVbO90Dj6+
	GulzWNf/AbTH+CcEbRKl2YcPBqAF7Fk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of houtao@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=houtao@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766204178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fd7QPU28XrpoVNC4vn0t7kuABEPBAgbJqdp0oaBXEnw=;
	b=e/UL3KvWqtpBDRwFiOLs4Je37lieHF+x+BQn4d58Kq1tvxHIsJ8ageF2plq3OL3TRZUFCz
	jwi3JUlkiSAdN85DV3YHUSbRfudtcC76haTkwjGrdNqOX3mQoI/Yt19W33vkKvQAXTDmOh
	V4IwxnPkfdURk6OiFXh9oMmO1w4W9F4=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dYB0V3Cn4zKHML7
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:15:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 9B0A04058D
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:16:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgD3WPn5IkZpFwpFAw--.56015S15;
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
Subject: [PATCH 11/13] PCI/P2PDMA: add helper pci_p2pdma_max_pagemap_align()
Date: Sat, 20 Dec 2025 12:04:44 +0800
Message-Id: <20251220040446.274991-12-houtao@huaweicloud.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20251220040446.274991-1-houtao@huaweicloud.com>
References: <20251220040446.274991-1-houtao@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3WPn5IkZpFwpFAw--.56015S15
X-Coremail-Antispam: 1UD129KBjvJXoWxJF15Gw1rWr1fKr48Xr48Crg_yoW8Ww43pF
	1kAFZ5Xr18KF47Ar9xA3Z0k3ZYvrs3Ca42krW3Kan7ZFy7Jws5Kr4UGF1Ygr1rWrWvkrWf
	JrsayF4Fk3sxt3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A0EEA1C000B
X-Stat-Signature: g44bo63j7po9npmtx8po696ghc6bxfh1
X-Rspam-User: 
X-HE-Tag: 1766204177-519793
X-HE-Meta: U2FsdGVkX18tFDUC5pkgzHAPh2UjIKkFkG9wGbPIuiVkd3sjAO4fSQwAy+nK3cBtP203odeXquxD9BdxAeiMT8VEcz3RiFbXUBjUknm/UBA6PvZgJYhSYhUp5hHJR1RZ6V3FDlsxhgtPhR703wbyUmBOprGRez92XX4Tw9pIK+o7kYU7INYqnEQiOorNTDfc41OQ31MURcmc4wShbJL7GtDAl2TfYwPWozhaiAUY3ZpEnapIpEBRCZ3GNkktB+GKdvMVnpwfj+vzhhdZCzcaGYWa+dwGFB59n1hfSvK20nrpCQ42OwDUPbokgfpSjhbeoezs63RmLutGGiYc1RL3YEc9xvgJq2RtoAF/ljSavVri6uOIBd3i/mEVpLL+VLnhRjiclEuS/bEqkuoMQByUoGnSrvY7oyMAUgiM5Y8I/hyRSF6ULFiEHL+RQBNenhqJWQ8nyLL4vEUK4+xE8nYorEp6i0lCpJlHRHIrI/YoE+/5CAzY6hhrSUD8FAO5JfIb8jhDKHtF8w9Dfn8mdjUBEFWOj5j8EXrf8grmlaPQGoM+pEeerrWiiODvU7EcPU6whFtCzqf4C5pZ5HHlj6ZdIGVv1PkkzqmvaYRA2JMeBdgMXrUbqpnxU0vALlqBux1Vqmg/JOGvda2MbWYB4nyLgWZixDSez4v+rkAQRerkwk5/wgucJUPunk1uCkz+HUkdUNY71d9mt60/TNYgSZZIjIenuZKca/H8EdRJzLyL9pj03XPIrG7ClFnFAYx2pQDRHkYT0zglvLepSDmYC2KzRxrmZoSQEgwxIRW9UX47aWXmjhoEWBlARsvhQQFg1VhJnhQLIQmJFUMOphNCwLVw/fGjE8ykAPiLr2QIEghLF+tq76JBvqjZQ+9SK9UlAwAfV26Gpxk0df9/qFJIOhHQ7wrZ4s91CA9KpcW3JIY3e1z13f+HQLoW2uf7VUbpG9uJ7slBn/7WFRownYx9IVx
 ucnks29W
 R+3CIXYdIb909f9yzamDYg3IwjG2sguYPEyNqeAHiiWeLBhbd51TtfJqq6+e0JIlEZNQNAGMfMJj7nyKHoCQkJtziELN4G5JsWyNPf/l1yKXcAZjufn7MyNZpzKiZSbwRlkB3d2Rn1rvsxUUrc5JRBGPNkpNMs2ANTot0jKTy/gBBmqnq8qiZ5tuHrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hou Tao <houtao1@huawei.com>

Add helper pci_p2pdma_max_pagemap_align() to find the max possible
alignment for p2p dma memory mapping in both userspace and kernel space.

When huge transparent page is supported, and the physical address, the
size of the BAR and the offset is {PUD|PMM}_SIZE aligned, it returns
{PUD|PMD_SIZE} accordingly. Otherwise, it returns PAGE_SIZE.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 include/linux/pci-p2pdma.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
index 2fa671274c45..5d940b9e5338 100644
--- a/include/linux/pci-p2pdma.h
+++ b/include/linux/pci-p2pdma.h
@@ -210,4 +210,30 @@ pci_p2pdma_bus_addr_map(struct p2pdma_provider *provider, phys_addr_t paddr)
 	return paddr + provider->bus_offset;
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline size_t pci_p2pdma_max_pagemap_align(struct pci_dev *pdev, int bar,
+						  u64 size, u64 offset)
+{
+	resource_size_t start = pci_resource_start(pdev, bar);
+
+	if (has_transparent_pud_hugepage() &&
+	    IS_ALIGNED(start, PUD_SIZE) && IS_ALIGNED(size, PUD_SIZE) &&
+	    IS_ALIGNED(offset, PUD_SIZE))
+		return PUD_SIZE;
+
+	if (has_transparent_hugepage() &&
+	    IS_ALIGNED(start, PMD_SIZE) && IS_ALIGNED(size, PMD_SIZE) &&
+	    IS_ALIGNED(offset, PMD_SIZE))
+		return PMD_SIZE;
+
+	return PAGE_SIZE;
+}
+#else
+static inline size_t pci_p2pdma_max_pagemap_align(resource_size_t start,
+						  u64 size, u64 offset)
+{
+	return PAGE_SIZE;
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+
 #endif /* _LINUX_PCI_P2P_H */
-- 
2.29.2


