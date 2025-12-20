Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35256E668AF
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54A7C6B00A6; Fri, 19 Dec 2025 23:16:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 454C26B00AA; Fri, 19 Dec 2025 23:16:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C75F6B00A7; Fri, 19 Dec 2025 23:16:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D2C4B6B00A6
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:16:16 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C778601EB
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:16:16 +0000 (UTC)
X-FDA: 84238537152.26.805DF60
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf01.hostedemail.com (Postfix) with ESMTP id 346534000A
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:16:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of houtao@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=houtao@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766204174; a=rsa-sha256;
	cv=none;
	b=mqedblIikdEcT14Mkadb/UF8AvSEmcW8UNvNWAzbzm7UEpgyzjezC49tvT4ErD+ZjVbmd3
	UMy6YkNTlEXvIAaOA4EkDxVScIRCr5M/QZfqJ6njZhO/kNYnjBvGzxUFF5N/nUib1hp4Kh
	JImdhkzPt/Olfww0w2KUIEOkOaqH3Fg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of houtao@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=houtao@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766204174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nHSxXsmvYGLR7vfZHfzfTQz8iHaAe/U5mySPzzgTYXM=;
	b=ijry6X0vCeKDCVi/bDQHBPD+GPIYQzyqpMDEG4Tyjetk66ik/Tqtrttru0uu7oVWW0teak
	q9e8kxRKF6rGr6EIDYPg+Wwkz3CmsjoKwzBxBKYFSMmHahUXp9151I2rcprXPxmFRtU529
	UVJz/g5OLy3LkxTO2IouuITxXYlUfQY=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dYB0T4lDkzKHM0K
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:15:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C997C40575
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:16:06 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgD3WPn5IkZpFwpFAw--.56015S6;
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
Subject: [PATCH 02/13] PCI/P2PDMA: Fix the warning condition in p2pmem_alloc_mmap()
Date: Sat, 20 Dec 2025 12:04:35 +0800
Message-Id: <20251220040446.274991-3-houtao@huaweicloud.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20251220040446.274991-1-houtao@huaweicloud.com>
References: <20251220040446.274991-1-houtao@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3WPn5IkZpFwpFAw--.56015S6
X-Coremail-Antispam: 1UD129KBjvJXoW7Zr18GF15tF13WF1DAr1DWrg_yoW8Ar13pF
	W3GF17GrWktr43JF4DJ3Z8ury5Aan3uFWUKFWUXw1UuF13urWjkw48tF95Jry5try8Ar1S
	qFs8ur1jyF1DAaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPab4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
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
	xXTmDUUUU
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/
X-Rspamd-Queue-Id: 346534000A
X-Stat-Signature: shey8g9jnjoee4z54rdw3ychqcgh31pk
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766204171-187608
X-HE-Meta: U2FsdGVkX18dqQaX73f+84gAitCund2tRwR5n4O/XXnpH1M9vWP/71QEMnUL8AGZb3QdMsYn70YrXZDHhdLyxzW9NQOidJXo1DVuK+rKuZSC21kCoPW1XjjlRE/R1xrQbB1RTBYUYDECfppy+h45a2KUSjBGBl4TfJti2HX5i5rGvAxGVVOnbF598Rw6izGg2gaDDu/dYQ5CVdoJsEdpSfW50iwz959AzoYytLYIn0XM2YYln3dDTbDS/8thoUxfkVUMJGFJZjDKx4hdnyEnHxIrNvmRXkQliZpGBdM0VGaXIsebCRvAXy0WecYIZg1UWT35NPIcMnurII2OaJqICATbinctLY5yMY+SJ5Lk+4IHbnnaE/RJUNgAZB3UxN8jXY8ADmsl9m8JxihHEGaHkhpnIJBeeN4fnjCABluj9BeDasuGrDtSHVQUjioLIlfled0CjVx4q8RFo4A/Hex3E2V273wEnmfBLF7ffBaAKxcUJ+531AYCvdWFJ35rQlwPeyWEs5wJRP9TknRR5sBlene7+giu1mmXfkDza/OQg0zsqEpt0lhmzaenwjK6kvTwo5fAxik2OiReNQJDzdDlJb0SWUA1QYAHpBGtsm+4dgoGaGC/96SvbzNFO3wq3cp6GXeevGc/48u5KuDpsN/odW76fjyxVKS0QlbHdVH0Dzq2osQqoIrAJycawwRAXb6db+L3KJjIPCHeUhMeGpRzd3qUCaKAnQtmWYdKftineE8GYfFjOYGVlYsoVzY7xJTBWgjOblX0MTkEnjOf0ARYsj0+IXEZp1OLI9dtOs92ciqhjB5mAbj6KzLRdXBZK+NnLiHgNn7gMlHjutu9Vj7nI8Xq8Y3jcBZH/uapnImhSXaxXJZ6chtFKDADr+5bUFN/FAU7EUTKmZhKZ1yw8zFbjjvJh5g74f0MU8uBRKJrig3OVXoXLkynHXKF15KiNdLW+O01LhFnsUSaB/5RwCu
 BgvB89Aj
 q47TEeVNZlA1SzuXC4n/QCdmjiz6SsbinwdCpw3FMSub/yTxgq24RjPsfO7AwqX18ptc3B6bm/WPRCdf6AaJtyZDTWHzxkiFbMhnNeznNfM7FeTVqcuI/dhL+DRhTwr+v0OCRJKzwmbWpNps=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hou Tao <houtao1@huawei.com>

Commit b7e282378773 has already changed the initial page refcount of
p2pdma page from one to zero, however, in p2pmem_alloc_mmap() it uses
"VM_WARN_ON_ONCE_PAGE(!page_ref_count(page))" to assert the initial page
refcount should not be zero and the following will be reported when
CONFIG_DEBUG_VM is enabled:

 page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x380400000
 flags: 0x20000000002000(reserved|node=0|zone=4)
 raw: 0020000000002000 ff1100015e3ab440 0000000000000000 0000000000000000
 raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
 page dumped because: VM_WARN_ON_ONCE_PAGE(!page_ref_count(page))
 ------------[ cut here ]------------
 WARNING: CPU: 5 PID: 449 at drivers/pci/p2pdma.c:240 p2pmem_alloc_mmap+0x83a/0xa60

Fix by using "page_ref_count(page)" as the assertion condition.

Fixes: b7e282378773 ("mm/mm_init: move p2pdma page refcount initialisation to p2pdma")
Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 drivers/pci/p2pdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 218c1f5252b6..dd64ec830fdd 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -147,7 +147,7 @@ static int p2pmem_alloc_mmap(struct file *filp, struct kobject *kobj,
 		 * we have just allocated the page no one else should be
 		 * using it.
 		 */
-		VM_WARN_ON_ONCE_PAGE(!page_ref_count(page), page);
+		VM_WARN_ON_ONCE_PAGE(page_ref_count(page), page);
 		set_page_count(page, 1);
 		ret = vm_insert_page(vma, vaddr, page);
 		if (ret) {
-- 
2.29.2


