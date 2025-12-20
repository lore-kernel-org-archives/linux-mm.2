Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4803E668B2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FB526B00A4; Fri, 19 Dec 2025 23:16:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BF596B00A9; Fri, 19 Dec 2025 23:16:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67BF76B00A4; Fri, 19 Dec 2025 23:16:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA7D46B00A9
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:16:16 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BAEA36020A
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:16:16 +0000 (UTC)
X-FDA: 84238537152.18.FF7A00C
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id 749838000B
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:16:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of houtao@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=houtao@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766204175; a=rsa-sha256;
	cv=none;
	b=i29jE5yH8BuP8pdSUSpHs34NqJHq6eyRiEKR9aEKwe6uZRsIC3r84Pi1DhPZe/n5XgHrwW
	w/ABiz21bdnweUTu90CC6VkFQnmaD5svczIvp7w2GYpO54SIwd3EfoiVnO1BZFYtKwEkA1
	6lJMvlraTchuF3q4Rhb5f5zQRj5sF1Q=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of houtao@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=houtao@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766204175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I5FerDu7RqzrPbgAgjJW0uMWeVImqYUIaYQGRqAYz8k=;
	b=1j666IAfJTHFlLrF68mVJ2AgO2pqHirCnT/7YCTKnbwblnCbc+x2pWjNHPfnV+N3MNeZ/O
	kv1A3/K1/2E3iwGH27gxENO8GmcQ8T2Ycu3pr95SOEEf8iCPZDPATK1BSNjiFSjdwuVprC
	nHXeSWWNe4hwhNNoXnyXeJzYzbEpC3w=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dYB074JDczYQtdx
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:15:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E75A740575
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:16:06 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgD3WPn5IkZpFwpFAw--.56015S7;
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
Subject: [PATCH 03/13] kernfs: add support for get_unmapped_area callback
Date: Sat, 20 Dec 2025 12:04:36 +0800
Message-Id: <20251220040446.274991-4-houtao@huaweicloud.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20251220040446.274991-1-houtao@huaweicloud.com>
References: <20251220040446.274991-1-houtao@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3WPn5IkZpFwpFAw--.56015S7
X-Coremail-Antispam: 1UD129KBjvJXoWxArWDZr4ftw1DCry8urWrGrg_yoW5CrW8pF
	s5KryYqrWxJr92kr13JF95Zr1av3s7Ka42va4Ig3sYyw1jqFnxXr4Y9F98Gr1rX34rAw42
	yanFgayYkw45JrUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPab4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWw
	A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkE
	bVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7
	AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_Wr
	ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxV
	WUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU
	xQzVUUUUU
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 749838000B
X-Stat-Signature: 4q93xy3op9ku8d63oo4sjhiy7o4ag7fr
X-HE-Tag: 1766204174-591968
X-HE-Meta: U2FsdGVkX1+0OOwMG+j28nmTKR4dfZqbTwkffjY46DBgfXidZ5T7OoY7RJZ0lKlHzqMnvEuZmqc1D0/FMVRg6rm9kse8UqRjiNHiO5w2yAYUbR6uKP9LMT69/MrJaEGIF8dOF0yoNv6DXmeiKOq0yBzkJYEYki+bup5KhkC3LLrNIqWOl8owUBhui7K2dbFnCM3f6vn3FlF4yL9FZopilryD7cw7khG2ME06XcjHY8fyVV9MHkYMTIViNULe7gw9qXyfiR3AWMhyX66mBHty3VD9FMUM8p4iwgYkh1c8esnm7YxK///08K64Y5JZrn/hmHql+LzNEra7eFDU3iXPFyIK+o3ECuiR6MQWHTht3XZkxZr6zSybCulC9NZTMUgphFkJdIXVMaNspfwAel4BO7wmKCIg4Zv8R/eIzLxdf5BpTdGQv4F0j1R693g5IGiFUlVKgWRVOP7L0OPbOWnGHsej+FlppPkgJSTkM02CA1NF573IUjmMzUKZKwVdDbBy346oBlp+GHWOXm4m5YBUylIAzd8huX3MTpGhOh99In+CACMpWn2/ihxJ5IrSXpwkXD5STYPyuv11wr4aFcC41wKm4PXHvxtKIL7BWptvTxZ2hMBZ9QGoT/BQp72KJ3bCG3jImfOv+mTy6jZe6gAJnHSa4R8ssG3ZDp0YrBCA2ygIh8lLbaEPVrO8ilbEruaSIDyE02jBB+hIlSFoi+h0QrUCFQE7uCY8JlgLwJYzJt6IyeiZanSmiJTVCuWL7xe/QEj5ebdEr/POEDJe4c6sWCsai/SZStcmQ3xxMATQEc9t/f4KoE8JmI9vIMWNTLvND6FRhvIIB/97twhpyHb/cJ0AfRjPKPZ9J2GQSdTWR2ICShvMrZJeiw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hou Tao <houtao1@huawei.com>

kernfs has already support ->mmap callback, however it doesn't support
->get_unmapped_area callback to return PMD-aligned or PUD-aligned
virtual address. The following patch will need it to support compound
page for p2pdma device memory, therefore add the necessary support for it.

When the ->get_unmapped_area callback is not defined in kernfs_ops or
the callback returns -EOPNOTSUPP, kernfs_get_unmapped_area() will
fallback to mm_get_unmapped_area().

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 fs/kernfs/file.c       | 37 +++++++++++++++++++++++++++++++++++++
 include/linux/kernfs.h |  3 +++
 2 files changed, 40 insertions(+)

diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 9adf36e6364b..9773b5734a2c 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -454,6 +454,39 @@ static const struct vm_operations_struct kernfs_vm_ops = {
 	.access		= kernfs_vma_access,
 };
 
+static unsigned long kernfs_get_unmapped_area(struct file *file, unsigned long uaddr,
+					      unsigned long len, unsigned long pgoff,
+					      unsigned long flags)
+{
+	struct kernfs_open_file *of = kernfs_of(file);
+	const struct kernfs_ops *ops;
+	long addr;
+
+	if (!(of->kn->flags & KERNFS_HAS_MMAP))
+		return -ENODEV;
+
+	mutex_lock(&of->mutex);
+
+	addr = -ENODEV;
+	if (!kernfs_get_active_of(of))
+		goto out_unlock;
+
+	ops = kernfs_ops(of->kn);
+	if (ops->get_unmapped_area) {
+		addr = ops->get_unmapped_area(of, uaddr, len, pgoff, flags);
+		if (!IS_ERR_VALUE(addr) || addr != -EOPNOTSUPP)
+			goto out_put;
+	}
+	addr = mm_get_unmapped_area(file, uaddr, len, pgoff, flags);
+
+out_put:
+	kernfs_put_active_of(of);
+out_unlock:
+	mutex_unlock(&of->mutex);
+
+	return addr;
+}
+
 static int kernfs_fop_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct kernfs_open_file *of = kernfs_of(file);
@@ -1017,6 +1050,7 @@ const struct file_operations kernfs_file_fops = {
 	.write_iter	= kernfs_fop_write_iter,
 	.llseek		= kernfs_fop_llseek,
 	.mmap		= kernfs_fop_mmap,
+	.get_unmapped_area = kernfs_get_unmapped_area,
 	.open		= kernfs_fop_open,
 	.release	= kernfs_fop_release,
 	.poll		= kernfs_fop_poll,
@@ -1052,6 +1086,9 @@ struct kernfs_node *__kernfs_create_file(struct kernfs_node *parent,
 	unsigned flags;
 	int rc;
 
+	if (ops->get_unmapped_area && !ops->mmap)
+		return ERR_PTR(-EINVAL);
+
 	flags = KERNFS_FILE;
 
 	kn = kernfs_new_node(parent, name, (mode & S_IALLUGO) | S_IFREG,
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index b5a5f32fdfd1..9467b0a2b339 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -324,6 +324,9 @@ struct kernfs_ops {
 
 	int (*mmap)(struct kernfs_open_file *of, struct vm_area_struct *vma);
 	loff_t (*llseek)(struct kernfs_open_file *of, loff_t offset, int whence);
+	unsigned long (*get_unmapped_area)(struct kernfs_open_file *of, unsigned long uaddr,
+					   unsigned long len, unsigned long pgoff,
+					   unsigned long flags);
 };
 
 /*
-- 
2.29.2


