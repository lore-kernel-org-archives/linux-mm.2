Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB59CE668AF
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:16:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EE246B00A5; Fri, 19 Dec 2025 23:16:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8164C6B00A7; Fri, 19 Dec 2025 23:16:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6845F6B00A9; Fri, 19 Dec 2025 23:16:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 52B1A6B00A5
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:16:18 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3008160077
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:16:18 +0000 (UTC)
X-FDA: 84238537236.01.1688103
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf26.hostedemail.com (Postfix) with ESMTP id CA04B140003
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:16:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of houtao@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=houtao@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766204176; a=rsa-sha256;
	cv=none;
	b=SC7gO9Nd5rgkJbjQfv2JKR8BWulOGnr1wh9xpLK9iVJaL96E1FXPep83OvXu/aJayx6k4G
	BigTFEY/Mn+u5CnuwcBd390Un0oeiK2WFVwoR18ZETAUpvs2m4U2oGPV1BekHnulLyPHxD
	2BO3GG/kejogDrSNGDLZjnSB+8acCVM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of houtao@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=houtao@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766204176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=hlsVE1RbKQ7XDTgD3HJi7vQWF8YzBkGh1fqJXl4Zaj4=;
	b=qsS0Mx9kb5195nuBQPpucT/jJy5EzSMKQ9xLtye6PEhKawzoXHpDTXwuJjkEBiM7h093Q8
	ubNe/TGIa96ny0MI3xV8ym1KQCXL6epsER9amImkJxnW/HOwG9EYbjhjP5aH2P/l8zUc8D
	kQkVfIRLCjEr/0SlvYvlmIkwJYIbIHw=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dYB072K0MzYQtFr
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:15:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A557040573
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:16:06 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgD3WPn5IkZpFwpFAw--.56015S4;
	Sat, 20 Dec 2025 12:16:06 +0800 (CST)
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
Subject: [PATCH 00/13] Enable compound page for p2pdma memory
Date: Sat, 20 Dec 2025 12:04:33 +0800
Message-Id: <20251220040446.274991-1-houtao@huaweicloud.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3WPn5IkZpFwpFAw--.56015S4
X-Coremail-Antispam: 1UD129KBjvJXoWxWF1rur4fWw13Zw4DGr4kZwb_yoW5Ar1DpF
	Z5KF98JrnrG342y3sxAa1DCr13Zw4rKFWUta4fK3sxCw13JF1Iv3yUtF15Xw1UXrsxG3WY
	qF4xZryxu3Z5XaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvIb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x02
	62kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s
	026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_
	GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20x
	vEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE
	14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf
	9x07j438nUUUUU=
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/
X-Rspamd-Queue-Id: CA04B140003
X-Rspamd-Server: rspam03
X-Stat-Signature: 7d9u6atiokbgdi6yc9odd7uboypw7eoc
X-Rspam-User: 
X-HE-Tag: 1766204174-641899
X-HE-Meta: U2FsdGVkX1+/CymLg9zypcng3dJXZLXqvpKIK0yMpOIBVjSnkF5Gde348z4uTsfdXUC4yyR5swwlvKRNK8UoSIKFfiC12AdXPOp9ncRUXdFVN30UulH20KUSm+hXDoCh+rnSoeYK1PnusCR0lUVsmzCnQ9plMuu06V4JxPD3m2q7kpwlaEPERwpRP0WQLA8bGpr4y1JZ9RngCf7kZoQ/UdjdQ3hTRTskZbTjnyHpLvQE9pyt1RQTMdBbClqpptlsEqyye3J1quzN3NeRI6FyJCjIsqANuXFrULNtoU30nOIgEyHrv5lfyiwq8oK2w6mHvUAKtB2TUepFMNdom/kx3fRbLUlDTsp88YzRvqlsSyv/zx5gPFwTpmKSO/jtp7EFO7FCW9+LK+nAaT4PSBtdYqUtyIw/ngHdmdm+yT/PGBfXkrCmvndF+4qRCaUqAmzbog7RhiZxAorLveutRpVvDTSEcYx12HbRmPy0HBOyl9qjuyHfbcPQu5FmYJTc76ioKES/EgsukuScRFAJAjHUKB0EJTUxqOkI/XXLRoinS3FXaA7csRyjh6mFPgNNArtqgXE+9ys9VnVYDovxWLxnTzI3uVAY9W8AQvxE3zYqF0JoCdLqO24kqNdAAhOqCCbvQfkjoHSeNiiT5KlKrE3eQ5XvXVmn3Sc99Zq2apnJd8oHKPKCYFd01m5Iuy1B9OtozTCctb+etsuITx5Dpfv3DVpAZHJQLLcrlmFLpyA8wbhj/qGFN4FkXFZmOkF6qKL2Bi4/FHHrIcMAfTbGDvn6nX3nttuULN7gkJFZKzxuHD/xC3RQRgoBfF0lnh5o4sescM6Gah8IJaujT1C9uYudkjwG5wRDdN1dfeNLiemCcgRbFYRYb0mLVX1plaRcgJGBVOlGKCO8xlMcLOFm+9EgcCPHsNKbNQF+Jg0rZDkqu2LysmLZg+SRl5EBBwgVIwNbgjtuLT9S2u9E/XuSV2F
 6D1pf0E4
 5INGE9Woy8wzy2emPyKEyibd6pXyHLSkUCkYQ07zbUF8bRoU6Mo1s6daAcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hou Tao <houtao1@huawei.com>

Hi,

device-dax has already supported compound page. It not only reduces the
cost of struct page significantly, it also improve the performance of
get_user_pages when 2MB or 1GB page size is used. We are experimenting
to use p2p dma to directly transfer the content of NVMe SSD into NPU.
The size of NPU HBM is 32GB or larger and there are at most 8 NPUs in
the host. When using the base page, the memory overhead is about 4GB for
128GB HBM, and the mapping of 32GB HBM into userspace takes about 0.8
second. Considering ZONE_DEVICE memory type has already supported the
compound page, enabling the compound page support for p2pdma memory as
well. After applying the patch set, when using the 1GB page, the memory
overhead is about 2MB and the mmap costs about 0.04 ms.

The main difference between the compound page support of device-dax and
p2pdma is that p2pdma inserts the page into user vma during mmap instead
of page fault. The main reason is simplicity. The patch set is
structured as shown below:

Patch #1~#2: tiny bug fixes for p2pdma
Patch #3~#5: add callbacks support in kernfs and sysfs, include
pagesize, may_split and get_unmapped_area. These callbacks are necessary
for the support of compound page when mmaping sysfs binary file.
Patch #6~#7: create compound page for p2pdma memory in the kernel. 
Patch #8~#10: support the mapping of compound page in userspace. 
Patch #11~#12: support the compound page for NVMe CMB.
Patch #13: enable the support for compound page for p2pdma memory.

Please see individual patches for more details. Comments and
suggestions are always welcome.

Hou Tao (13):
  PCI/P2PDMA: Release the per-cpu ref of pgmap when vm_insert_page()
    fails
  PCI/P2PDMA: Fix the warning condition in p2pmem_alloc_mmap()
  kernfs: add support for get_unmapped_area callback
  kernfs: add support for may_split and pagesize callbacks
  sysfs: support get_unmapped_area callback for binary file
  PCI/P2PDMA: add align parameter for pci_p2pdma_add_resource()
  PCI/P2PDMA: create compound page for aligned p2pdma memory
  mm/huge_memory: add helpers to insert huge page during mmap
  PCI/P2PDMA: support get_unmapped_area to return aligned vaddr
  PCI/P2PDMA: support compound page in p2pmem_alloc_mmap()
  PCI/P2PDMA: add helper pci_p2pdma_max_pagemap_align()
  nvme-pci: introduce cmb_devmap_align module parameter
  PCI/P2PDMA: enable compound page support for p2pdma memory

 drivers/accel/habanalabs/common/hldio.c |   3 +-
 drivers/nvme/host/pci.c                 |  10 +-
 drivers/pci/p2pdma.c                    | 140 ++++++++++++++++++++++--
 fs/kernfs/file.c                        |  79 +++++++++++++
 fs/sysfs/file.c                         |  15 +++
 include/linux/huge_mm.h                 |   4 +
 include/linux/kernfs.h                  |   3 +
 include/linux/pci-p2pdma.h              |  30 ++++-
 include/linux/sysfs.h                   |   4 +
 mm/huge_memory.c                        |  66 +++++++++++
 10 files changed, 339 insertions(+), 15 deletions(-)

-- 
2.29.2


