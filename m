Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C410E67480
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:16:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E3CF6B00A3; Fri, 19 Dec 2025 23:16:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61A316B00A7; Fri, 19 Dec 2025 23:16:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 333986B00A8; Fri, 19 Dec 2025 23:16:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E1F686B00A5
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:16:16 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A80AB140437
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:16:16 +0000 (UTC)
X-FDA: 84238537152.24.A9424A5
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id A74EC10000E
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:16:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of houtao@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=houtao@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766204174; a=rsa-sha256;
	cv=none;
	b=w+ZpRScGmwrwllRUBTNnXDEf6q5FzpHZ3ImiERglT8+M9zOQ/+xYeePfAa6LUAY3Ar7BZg
	0culAxxC0keahwnpDjR547mVq3BCzjbA16TJ9ynM3fvEwzwVU+wCVatVsrECXYsaDzg+yj
	W9lIVtIAmfee80cGwP03PHVeWF1VXq4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of houtao@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=houtao@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766204174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XKsnNvUSr27kee3JjeXFHI5WQ8OlSVuj58nXTCA4NXA=;
	b=KOasWz/eVURkMSBwcock1eaZAqONVM+DeLGeiPqS2NojUmkj/GbtpeTj0SjslSbrqTofF1
	l/Kp5gqLsApDdOPmmJmlEep6uPIsKcsclFjgsaHluzD39do5cJaxyVDtxOB3cIekRH2fkG
	gWtUhZwPCBf89E8qnLQqW++JBBTCHG8=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dYB074jCwzYQtfT
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:15:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 04B594058D
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:16:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgD3WPn5IkZpFwpFAw--.56015S8;
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
Subject: [PATCH 04/13] kernfs: add support for may_split and pagesize callbacks
Date: Sat, 20 Dec 2025 12:04:37 +0800
Message-Id: <20251220040446.274991-5-houtao@huaweicloud.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20251220040446.274991-1-houtao@huaweicloud.com>
References: <20251220040446.274991-1-houtao@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3WPn5IkZpFwpFAw--.56015S8
X-Coremail-Antispam: 1UD129KBjvJXoW7KrWUCw4fWFyfZw15Xr17GFg_yoW8KF15pF
	4fKw15XrW8W3s3Cr9xXF4kZ343t3s7Gay7X34fu3sYy3W3tFnIvFyFgr98Ar15AryrJr4f
	tw42yryYka15Ww7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPvb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
	Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
	rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
	AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E
	14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
	xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE
	7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262
	kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s02
	6c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GF
	v_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvE
	c7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67
	AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuY
	vjxUxubkUUUUU
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/
X-Rspamd-Queue-Id: A74EC10000E
X-Rspamd-Server: rspam03
X-Stat-Signature: y1s8o8big4drswxdgijwgc4uh8th7d4d
X-Rspam-User: 
X-HE-Tag: 1766204172-573578
X-HE-Meta: U2FsdGVkX18MfeY6bQvYaja/ldvHNOIxS1BFO0/Plr+KPV/Un6hQZaVpNMhnLNtUN9VjqgQosGklgPYZGFqxIMUUqdRWUntx4CLOY8QzKEnKnpXCIfJn8DD/1AaBbl/39eq92e14epH55CBbRbE/kJpkYPyNbUvW+pjCw7soQsYIhSXJlAN52O1QeRu1JZv/Cngm1+mKFpMI47lN1hHmDUj65vry3MzVWOhSdKffEfkNMQWOtieVIG9vU2KUk8HBWjOHSuSWmO3X9iwmCVAvWTspolo48ZwARPHnGDgTuw0U6OF1lg9kUD0ldBXcU8BwiwFDJPV7JaiozOFWju68E/hYuQMEvLKfSGB/5ptYXpGt57hLQQ7I97W6wHa2TsAnnme+XgBvCPq1tD4XTZ8fru+kkh7KsIjLvs6QaMZPNMxXhd+vQ5hSC5kw+aWNCGg12SfDNjo9Nsf1F8+8s92up4TAQLifBy3zXHnv7kOaHIDakxLWYMfOZOH8MfZqtsISvZCanmoeBmd50hZlyHk8e7BJwSxdu2Sx8FDIco7WIF/rKXwWobwIILHC1F8iEQEHj19StDVbVNHNsTDSov/Jbt2ttGwh7eX/lm9JkEvf1X+5ryJh1feyXZOf7yPXoRBRlPjW/YUkL0htuZmY4arovQ9xmdtnPta6EtcNUToP/rgMc90cOXDfoXXOFdFFtXrhigr9Y/3JNLSk8S8mqlApohcq81FzxalHq11Qk5IOony9kqgbabX4yjv7znYPM4ykCT4PLk+hlwdt5PQYdyPJnB2MHnhzdGQP+M/MdgeX8sG0R9CuEJAvE5PVgLeqlN3nJnbz7m7dIzKgv19XUiKfToHE5tSx7QKlU4fePoDN0Hbmva7eaUGz1Ia83ccrcQE46C4jGhOcV9ZEVnA0RFpm8TBcSaKWGQynY4K/ZJ2V2/uQbDM973dIVZ4Ri0OdAS3wNL3IS9szOep67f/mzgM
 AJOVpeUg
 i7MKT1r9z9r2oshP7enhZF5UmFjjF8L+l5L+H9loQB5BgL2nie1qxQnPnMMJOqGEjgPMX6m4hmofM/8EBbIK0tw8Noym2DcGpFHh3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hou Tao <houtao1@huawei.com>

->may_split() and ->pagesize() callbacks are necessary for the support
of compound page. ->may_split() will check whether the splitting of
compound page is allowed during mprotect or remap, and ->pagesize() will
output the correct page size in /proc/${pid}/smap file. These two
callbacks will be used by the following patch to enable the mapping of
compound page of p2pdma memory into userspace, therefore, add the
support for these two callbacks.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 fs/kernfs/file.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 9773b5734a2c..5df45b1dbb36 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -384,6 +384,46 @@ static void kernfs_vma_open(struct vm_area_struct *vma)
 	kernfs_put_active_of(of);
 }
 
+static int kernfs_vma_may_split(struct vm_area_struct *vma, unsigned long addr)
+{
+	struct file *file = vma->vm_file;
+	struct kernfs_open_file *of = kernfs_of(file);
+	int ret;
+
+	if (!of->vm_ops)
+		return 0;
+
+	if (!kernfs_get_active_of(of))
+		return -ENODEV;
+
+	ret = 0;
+	if (of->vm_ops->may_split)
+		ret = of->vm_ops->may_split(vma, addr);
+
+	kernfs_put_active_of(of);
+	return ret;
+}
+
+static unsigned long kernfs_vma_pagesize(struct vm_area_struct *vma)
+{
+	struct file *file = vma->vm_file;
+	struct kernfs_open_file *of = kernfs_of(file);
+	unsigned long size;
+
+	if (!of->vm_ops)
+		return PAGE_SIZE;
+
+	if (!kernfs_get_active_of(of))
+		return PAGE_SIZE;
+
+	size = PAGE_SIZE;
+	if (of->vm_ops->pagesize)
+		size = of->vm_ops->pagesize(vma);
+
+	kernfs_put_active_of(of);
+	return size;
+}
+
 static vm_fault_t kernfs_vma_fault(struct vm_fault *vmf)
 {
 	struct file *file = vmf->vma->vm_file;
@@ -449,9 +489,11 @@ static int kernfs_vma_access(struct vm_area_struct *vma, unsigned long addr,
 
 static const struct vm_operations_struct kernfs_vm_ops = {
 	.open		= kernfs_vma_open,
+	.may_split	= kernfs_vma_may_split,
 	.fault		= kernfs_vma_fault,
 	.page_mkwrite	= kernfs_vma_page_mkwrite,
 	.access		= kernfs_vma_access,
+	.pagesize	= kernfs_vma_pagesize,
 };
 
 static unsigned long kernfs_get_unmapped_area(struct file *file, unsigned long uaddr,
-- 
2.29.2


