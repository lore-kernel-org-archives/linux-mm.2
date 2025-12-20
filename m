Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7AFFE668B2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:16:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49B706B00AC; Fri, 19 Dec 2025 23:16:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41C416B00AD; Fri, 19 Dec 2025 23:16:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CF566B00AE; Fri, 19 Dec 2025 23:16:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 156596B00AC
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:16:22 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B9C2F1A0430
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:16:21 +0000 (UTC)
X-FDA: 84238537362.22.1FCBA7A
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4D3641C0010
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:16:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of houtao@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=houtao@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766204180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=coPjan8U2JfRZyHmLaEhcYe8a9WJSP4/FpLVQVNG438=;
	b=bUkUfXfnWhfFKestqaJrpGK3hNWc5fC7UwbqNH9nU8Qqk9HjZDJBVrpDj9HdaV8tzLlD7d
	SXR7NLPPchegn9B5t8oXQrM1dJc4z1SoV144ecXnZm4C4F1J/7RPP56AhoNDYd1ghAvD6A
	enaDu0pEAx6PMMGgsX34Ug1TDg4kPTk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of houtao@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=houtao@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766204180; a=rsa-sha256;
	cv=none;
	b=jY3Un8vj3169z2lx2/gEKDMiFXvyzuROwf0BfUMUG5ipQItt8aYDeXB8s2WyTZcGiha4bJ
	io/kG56RxIKm7krk9iSF3o87GIrR1TQpFfq3c+VrWcgeyMoJ6whcHSMbOsY6bPDvCtnM+U
	JyYlbFoQC0B4F8LZNS7ivS6UrDZNRMI=
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dYB080rhpzYQths
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:15:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 72E1B4056C
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:16:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgD3WPn5IkZpFwpFAw--.56015S13;
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
Subject: [PATCH 09/13] PCI/P2PDMA: support get_unmapped_area to return aligned vaddr
Date: Sat, 20 Dec 2025 12:04:42 +0800
Message-Id: <20251220040446.274991-10-houtao@huaweicloud.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20251220040446.274991-1-houtao@huaweicloud.com>
References: <20251220040446.274991-1-houtao@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3WPn5IkZpFwpFAw--.56015S13
X-Coremail-Antispam: 1UD129KBjvJXoW7uw1UWFW5JF1UAF15GF15urg_yoW8Kr18pF
	WrtF98JrW8twsrKFWaya1DZry3Wwn5KryjkrWxK34a93W3GFnxWay5Aa4YqF13J34kW3W7
	tanIkr47urWDJ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4D3641C0010
X-Stat-Signature: inz4t1ud7fhrpsyt6xazj74f7yqhog8p
X-HE-Tag: 1766204178-641207
X-HE-Meta: U2FsdGVkX1+e/Qzho6DT+F+PDoxNx+MXBNXL0Td1hRFfKJIdKlMEckKNIIK7Y0Qk/7vH8avZVt2IM+Jm/5i4srko4CM0VK0hoJ/mtB79e2H8YarfMT0aEkUYkj2CQ3XFJsAgSjsEkb71sHt1J5sbiU8vAWtkXTGY0DNmxtqxSRXiiNCFy4mE35/7byYGi+VqjXfrtmmRshitMVXTKWdRdhJRgTGdWVhodY1fcwPJYP9qdrqncOL7yo65wUETkbStzHj/FEkA9y9ivFuRK6at+lnTDRMmw+H3ZnPWt/657B9lVxIDUUuSgjS0MsQtkxcS0Bxn00SUvF50bQ2lvHDMTj3LWKO/UwmEzlntbI8osppoveKBeVN3gNLfeGZG+YLdH2h8Zf5nARRtpvwgsxfTQQ/oi59j9ibcQ8k/oCLCxLiOp0hUGSSAO1A8m+e3MaKKvoDX4na1CIr6pDfOFmh81wFim/yz/f7J/g9IGFJwbKCLRj4p4jZNDYXVxgB8TckvwqsA/m/2Du0ZNBL2aTgWT5jrC8MjeQKBlSzT8Z+DhYyplKleKt5IF6cTXdlBF/KqRtR2XdlaYxHWSFjiamd3Zyb6ebb375ilGMaog2RWoKaBJAQjy8UAb4UhzvS9xUvtQmcZZas4k2WY7jf0SclxibnqIbdtD8sw+aiD+ovpGdn2dPAWmHjELzC2Xw4/X8/vYbYbWfcEELWMLiY8fGwpbn/P3CHhCTvpvKRwzAxkqNeuo2eof26cQWpKKc/9pykOsPKJyUk6LYapx3yzZP+Lg0Fj3GA5BlFUgwaLEstEvqFZTiRH8wdkVj+IQ75QOM+oxPpAfk8j5ExTL+LL0pJfZ7tKeuQjLlaSiLPTc3aPzSgB9e/L077bUKmqYuxdM2JnNjpG7k2nKPuELxGgVNTEo38otAMbtiJG+ORQ/nCzDPBsoueYKx4CyfBeRTKEN4cxPPdKiHAHcqeZv0Zs313
 zhxctmfU
 8Tr93XqwSqoYwio2evvCNjH6DP6qkqlqwOLu2JICLrWFgoJdME3Z0p48lDBHm21cFmlT5No8218KU5vSx5kRNYAXk7uvzE4svJ69Hj2iABrlzwG+xJoAQUdKE5u0Yk3NToKlcseIIVJ4J+DU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hou Tao <houtao1@huawei.com>

P2PDMA memory already supports compound page. When mmapping the P2PDMA
memory in the userspace, the mmap procedure needs to use an aligned
virtual address to match the alignment of P2PDMA memory. Therefore,
implement get_unmapped_area for p2pdma memory to return an aligned
virtual address.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 drivers/pci/p2pdma.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 7180dea4855c..e97f5da73458 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -90,6 +90,44 @@ static ssize_t published_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(published);
 
+static unsigned long p2pmem_get_unmapped_area(struct file *filp, struct kobject *kobj,
+					      const struct bin_attribute *attr,
+					      unsigned long uaddr, unsigned long len,
+					      unsigned long pgoff, unsigned long flags)
+{
+	struct pci_dev *pdev = to_pci_dev(kobj_to_dev(kobj));
+	struct pci_p2pdma *p2pdma;
+	unsigned long aligned_len;
+	unsigned long addr;
+	unsigned long align;
+
+	if (pgoff)
+		return -EINVAL;
+
+	rcu_read_lock();
+	p2pdma = rcu_dereference(pdev->p2pdma);
+	if (!p2pdma) {
+		rcu_read_unlock();
+		return -ENODEV;
+	}
+	align = p2pdma->align;
+	rcu_read_unlock();
+
+	/* Fixed address */
+	if (uaddr)
+		goto out;
+
+	aligned_len = len + align;
+	if (aligned_len < len)
+		goto out;
+
+	addr = mm_get_unmapped_area(filp, uaddr, aligned_len, pgoff, flags);
+	if (!IS_ERR_VALUE(addr))
+		return round_up(addr, align);
+out:
+	return mm_get_unmapped_area(filp, uaddr, len, pgoff, flags);
+}
+
 static int p2pmem_alloc_mmap(struct file *filp, struct kobject *kobj,
 		const struct bin_attribute *attr, struct vm_area_struct *vma)
 {
@@ -175,6 +213,7 @@ static int p2pmem_alloc_mmap(struct file *filp, struct kobject *kobj,
 static const struct bin_attribute p2pmem_alloc_attr = {
 	.attr = { .name = "allocate", .mode = 0660 },
 	.mmap = p2pmem_alloc_mmap,
+	.get_unmapped_area = p2pmem_get_unmapped_area,
 	/*
 	 * Some places where we want to call mmap (ie. python) will check
 	 * that the file size is greater than the mmap size before allowing
-- 
2.29.2


