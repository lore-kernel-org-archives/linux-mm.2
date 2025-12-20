Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BA81E668AF
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:16:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0EB66B00A1; Fri, 19 Dec 2025 23:16:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D75636B00A7; Fri, 19 Dec 2025 23:16:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB0866B00A1; Fri, 19 Dec 2025 23:16:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D5386B00A2
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:16:16 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5C39213AFDC
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:16:16 +0000 (UTC)
X-FDA: 84238537152.08.00F0569
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5C2DF20004
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:16:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of houtao@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=houtao@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766204174; a=rsa-sha256;
	cv=none;
	b=W4PwA+0dfUd8rLdPw3aV6LZj8Lo/Z9rmTT3QuKwsY92l/PzGKsN1iHcNXRss2mUJ6xvWRW
	GUx9jCkV/axrp8JZSoDM1SDgvJ7TLEiXtXgNTxQRvzMiDd+ESsNnJq/xFi8TTa5reQbwLq
	MkBZB9z9xLYBslPBRHPekRpMio/PwxY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of houtao@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=houtao@huaweicloud.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766204174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/HeiKf510T7dF9luYYlcRkhcXs1fjBv3Xku0UFjDXOs=;
	b=iLw/EfYeoP7AYu7lflbidkjOKOFQ28F6hsCHdjz1mP5+xTDaWH29O/1s+yCHN85WFQqTxb
	CEJ8pVXIibQpN5k5VtWYHNwfo1IOyxekEcQ+Tb9ExNsMjMxHjSFUeetKieIk72TKC6n9pw
	6WtxceysFOKbsSa6tG+lo/hgwQKSoKE=
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dYB0T4D4rzKHM01
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:15:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id BA0F94056E
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:16:06 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgD3WPn5IkZpFwpFAw--.56015S5;
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
Subject: [PATCH 01/13] PCI/P2PDMA: Release the per-cpu ref of pgmap when vm_insert_page() fails
Date: Sat, 20 Dec 2025 12:04:34 +0800
Message-Id: <20251220040446.274991-2-houtao@huaweicloud.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20251220040446.274991-1-houtao@huaweicloud.com>
References: <20251220040446.274991-1-houtao@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3WPn5IkZpFwpFAw--.56015S5
X-Coremail-Antispam: 1UD129KBjvdXoW7Gw4rWF1ktr4DJF45uw4fAFb_yoWDXwb_uF
	y2vrs7Z3yjkF1vkw1akw1fXryjyas5Wrs29F4rtF93ZFyrurykK3Wjvr98AFy8Gw4YqF98
	C342vF1xu347CjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbq8YFVCjjxCrM7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r18M2
	8IrcIa0xkI8VCY1x0267AKxVW8JVW5JwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK
	021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F
	4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0
	oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7V
	C0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI
	0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUVpVb
	DUUUU
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5C2DF20004
X-Stat-Signature: wdumrd8wozt9garcdx78cmu34i9np48m
X-Rspam-User: 
X-HE-Tag: 1766204171-327368
X-HE-Meta: U2FsdGVkX1/5jgOL51u7Y2JsOHMI5gX8EfQS0OoZp9T0IwpPdVDn390jUSYwhQXO35vSFSle3/8NqMM/JduHDBew/Os4q3tw/2XroLFsWRWlpcZk4YfkecK/iKMW+xYgggoKVG61T1wasB8Qb6uzlfwyajm5DnK9OnKAk7es7VicCwudnv6BPnfAyaBO/V5iNJuuPxxLinLWBi4fGmxwrHkufU91KxbpcqsNDefeIWhosD02y9fcLG8ucqLD1j2JWnbiaYHQfU8+8Dd75q9liWxj5AffFg9CwAQ9AXpcwuDdl83PsdVFvV4A77bQiSS4XFbzJxzU48DsAzAzB50EcIMS9JEmcOcwKpKYL2D67EoiSAu/twEpjIdQYM3d53CW5VRsZJ6jftUBOImtn1tbQWwyveTrhoQNJGU9NKTf65q1ii5UUvUI/MeTLLAUXh1Fg5JjqhQfdJ+4K1qwbPrv/hZjlLqFj4QvGX3yxLLS6OYKKGB77r5j7WhiqqIrZQ8E06PfrH282NAJRiH0W5pHRVKccl8OxDk63KSQ8oB6y4rqpclrLohA36mJrakDvgDscVccnHChvq0tu8ZX6feiXdaz/tgk6JID9Sp3Wr9Tdr/bDwivG3hj1s25lCu0yc694yd8zu/ukbpgueAWD/gliepmsMlLT3PccTTeYSClh4fCDeMW70lU0B9Z7r52/kQsfW5zFS3DPn5XYNJMZ7KGfreEfzUm8RzTFgdjLb3o9ZYCuBQvW+PFPKOQsFopnLIS8TQ68Xp6P1mpxkeZc9aVz5LiOfdleHSHO6BHAOLCRgi2qiVzdwXmZoRFPfoqomUHOpvgoW9n1ky1+oRG5snwAOknBSXXW9sRhFU179pTuJXp2LFoEGv/Dm4TdeNJCdib28Rw5+WKkdfQ4MwWRWSAwDLW/MBYEpijfgPXo6QYSR7mygaRu5gClRAmnJf/4c34fKnO8LN/Vc6blOC7T+E
 99j9J1ae
 A6h9MwQCpHTsUjKsB4L8sYtKiULLbZLdLDpsnJahUSU5Q0F5DAxckFWX9ql2/bhb0b12cHzTnse2q3b7yQodY1pbX36cx/TR4OKNTM0PKBKg+bapCM+Th3a9M2wrdva4SFaUyLTGYk4UZSAQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hou Tao <houtao1@huawei.com>

When vm_insert_page() fails in p2pmem_alloc_mmap(), p2pmem_alloc_mmap()
doesn't invoke percpu_ref_put() to free the per-cpu ref of pgmap
acquired after gen_pool_alloc_owner(), and memunmap_pages() will hang
forever when trying to remove the PCIe device.

Fix it by adding the missed percpu_ref_put().

Fixes: 7e9c7ef83d78 ("PCI/P2PDMA: Allow userspace VMA allocations through sysfs")
Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 drivers/pci/p2pdma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 4a2fc7ab42c3..218c1f5252b6 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -152,6 +152,7 @@ static int p2pmem_alloc_mmap(struct file *filp, struct kobject *kobj,
 		ret = vm_insert_page(vma, vaddr, page);
 		if (ret) {
 			gen_pool_free(p2pdma->pool, (uintptr_t)kaddr, len);
+			percpu_ref_put(ref);
 			return ret;
 		}
 		percpu_ref_get(ref);
-- 
2.29.2


