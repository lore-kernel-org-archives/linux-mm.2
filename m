Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FD77E668B2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:16:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E27F26B00A7; Fri, 19 Dec 2025 23:16:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDCFC6B00A9; Fri, 19 Dec 2025 23:16:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB5586B00AA; Fri, 19 Dec 2025 23:16:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B19126B00A7
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:16:19 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 85447B981B
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:16:19 +0000 (UTC)
X-FDA: 84238537278.02.6800B48
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1C73F180002
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:16:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of houtao@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=houtao@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766204177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SJkD/tBeeEEJmstxapoYxLUzG9IOFg4LsR8Q3wzbbGs=;
	b=RECprWADzi07XEd0JUZZxdsH5wCfqc+89oA8OrLKcze5CMpBV8ucghwl4+xTTzY3coj+1E
	b1KmqS7F1z0gmspROiKkUJLnNuFOuP4OejbRje0QOE5P0o6SYmfgEwee8U9P+cNoue8UyB
	oaUAK2xtxiriRqmcDh3/0yGP8jCiDXI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of houtao@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=houtao@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766204177; a=rsa-sha256;
	cv=none;
	b=mj02hcNpeWLFwaFU6LAlydBqBwdId+Jj1DDiOiRvCgzJ69DbJEJCBbF8b420UcV8pe2HNj
	+ggGwYPrz6N6CjFVngBiGBXZsW7FRrYAW4aYpegnCTdJ0KO346+oLsHgw+Uuowx6i0WnBg
	oFxIBqjs1Ki2Vd3vArU/o3IjagSEm0I=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dYB0T6tftzKHM0f
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:15:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 22B8840577
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:16:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgD3WPn5IkZpFwpFAw--.56015S9;
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
Subject: [PATCH 05/13] sysfs: support get_unmapped_area callback for binary file
Date: Sat, 20 Dec 2025 12:04:38 +0800
Message-Id: <20251220040446.274991-6-houtao@huaweicloud.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20251220040446.274991-1-houtao@huaweicloud.com>
References: <20251220040446.274991-1-houtao@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3WPn5IkZpFwpFAw--.56015S9
X-Coremail-Antispam: 1UD129KBjvJXoW7uF48Xw1DWw45tr1rXFy8AFb_yoW8uF4rpF
	sYk343XrZ7G3srKr9xAFW5W343KwnrGr1q9rZ2g343AwnrtF9Ig3yjya15JryrJrW8Cr1x
	KF429ryYkrW5G37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	v_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvE
	c7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aV
	AFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZF
	pf9x07j4fO7UUUUU=
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/
X-Stat-Signature: 6hmqqki9ujazku75eftazwamgmk4mh5e
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1C73F180002
X-HE-Tag: 1766204176-579274
X-HE-Meta: U2FsdGVkX186mz+1bJnoxbtQ78NTBXMr0nxeafKQ7eIWWGfcI3ToPARtmbX7/q6RGicau3osXBAYHkOrP8v/UMXsJy2RCkI9hkC8K95vfFHyxalDjrZfpKNr2xIPVvxwqd01uP+Q+BCpko+0rBtfgyRfGov9FFfahHHuQPXfCTX4axDzZPgXYdXLgeklwEVkyE9PmV59J4nrHnbZBcZlr1riOgEmshyMGu6v9niV18a3JPh/im8hDbXScbQnyINJlwK6y9KY+D+8h0H7iewp7IBIP2OY7ONPNbMCddMAn1VXtbWuONXo/GDUYvpEvRw4NEsq1fotAk3tzLGaflcmeXW8lGuO3BXsD2cltoeL8H0yXiWA0ZMah2wfuvLeuIzW6d88zE9LbzxU1efPK5IvBhkJ7AnHCDt5tJcpgSmTeLIEkaRXVAfTBydwDdzpuHv+MkYFZ2H0mTmbwIB8bqaQiZu9NBBLZXZ4SSZRFPdZPX9+Et2KpCJ/jQ6AkMPTod6Db7qyj0m2VPbeI/pWiE4jcpOdTh//1Uh/iYN9YVFEHpFNcBFRmMg9qdsA91TM9lIcAEQFW7mXUCM1q2ZuIlfwGem9CkvjBEGr892EDCr0RLUnFR7LFdJT3PcaseYsgLWbaCAA/iJ5o6/oYS92iGNaxTucMUFZ3Y4pnkxsxckh8Ttg1Y8+/fZxErAXkuZxGwAjiKIQNxWOmRyO6mnJqmYHDA4mCPajmu0fzf1+pweyS9mcqQaNbQKCBeHd3fshDZHzutuipaLd7EsL4vL3wCaj3sg7sKhHgC5QdE7PerbQ5aHzSjfMm5TVtZ70sXkpFMkcNVECGQpRtouPKJxPicp6uX3qsSnnmighgWjCNTLtblgRS0jAgZBRPzKYVib2540oCFdJh6SRnmTC/6aBrMJGGNi5d6NeOz/MfsGtiFXw1xgfa0mXl2xibgIVkgitWpNMOXfcjhQGSUnWkeglnR9
 OhIhFKVu
 0EinecqF3dZcis2aq5ojWoyVKuyNa5dvqL81OuvwFEI+Qu4UiHw2R3D+U+1EYOkn7/6+oTPnM+tRZTca9j1yfJNkmM7x6uIf6A6fC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hou Tao <houtao1@huawei.com>

Add support for ->get_unmapped_area callback for binary sysfs file. The
following patch will use it to support compound page for p2pdma device
memory when the device memory is mapped into userspace.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 fs/sysfs/file.c       | 15 +++++++++++++++
 include/linux/sysfs.h |  4 ++++
 2 files changed, 19 insertions(+)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 3825e780cc58..e843795ebdc2 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -164,6 +164,20 @@ static ssize_t sysfs_kf_bin_write(struct kernfs_open_file *of, char *buf,
 	return battr->write(of->file, kobj, battr, buf, pos, count);
 }
 
+static unsigned long sysfs_kf_bin_get_unmapped_area(struct kernfs_open_file *of,
+						    unsigned long uaddr, unsigned long len,
+						    unsigned long pgoff, unsigned long flags)
+{
+	const struct bin_attribute *battr = of->kn->priv;
+	struct kobject *kobj;
+
+	if (!battr->get_unmapped_area)
+		return -EOPNOTSUPP;
+
+	kobj = sysfs_file_kobj(of->kn);
+	return battr->get_unmapped_area(of->file, kobj, battr, uaddr, len, pgoff, flags);
+}
+
 static int sysfs_kf_bin_mmap(struct kernfs_open_file *of,
 			     struct vm_area_struct *vma)
 {
@@ -268,6 +282,7 @@ static const struct kernfs_ops sysfs_bin_kfops_mmap = {
 	.mmap		= sysfs_kf_bin_mmap,
 	.open		= sysfs_kf_bin_open,
 	.llseek		= sysfs_kf_bin_llseek,
+	.get_unmapped_area = sysfs_kf_bin_get_unmapped_area,
 };
 
 int sysfs_add_file_mode_ns(struct kernfs_node *parent,
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index c33a96b7391a..f4a50f244f4d 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -321,6 +321,10 @@ struct bin_attribute {
 			 loff_t, int);
 	int (*mmap)(struct file *, struct kobject *, const struct bin_attribute *attr,
 		    struct vm_area_struct *vma);
+	unsigned long (*get_unmapped_area)(struct file *, struct kobject *,
+					   const struct bin_attribute *attr,
+					   unsigned long uaddr, unsigned long len,
+					   unsigned long pgoff, unsigned long flags);
 };
 
 /**
-- 
2.29.2


