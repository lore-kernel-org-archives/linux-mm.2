Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9445F10854CE
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 02:27:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5E336B00D2; Tue, 17 Mar 2026 22:27:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A35AB6B00D3; Tue, 17 Mar 2026 22:27:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94B536B00D4; Tue, 17 Mar 2026 22:27:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 846BA6B00D2
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 22:27:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 775A81403BB
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 02:27:18 +0000 (UTC)
X-FDA: 84557596956.29.B4C5F50
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf03.hostedemail.com (Postfix) with ESMTP id ED6C22000A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 02:27:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=EHtS3PkC;
	spf=pass (imf03.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773800836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=WkrgRNTo29sC937g3jumERzDlBLNyCohbTOYbnF0mqU=;
	b=BrMwFGFQFdKnm1HICS4mdBtB/gBY06ILK1zcFv9cPqT6JuqaFU8KTDO2md6G4XsQyS575Z
	XIXkQ7RCZlFq1xNdcbvXuspobpu5hERTOWRIenZZx7G61rIpMW82fpHyGRfrJGaQL56LfV
	7yr052vz8/M9hJFojzWhcdj2k/smw0k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=EHtS3PkC;
	spf=pass (imf03.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773800836; a=rsa-sha256;
	cv=none;
	b=JyELTs6Tdoi5frSRKoPbKKftIHzRon1kv/1sDSCu2iJ2C+GBnMwXwCdc84ATEArp1LY4YV
	jbefK3PYEruib/vVYnbIOouS/Pq184HavR+u5Aw81dVmq/XpvTKS8MUy2DFSBfY1vCG3wC
	TCnn5+eVwM6uN/7i3Mp2ASJIZ1nAc/Q=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=WkrgRNTo29sC937g3jumERzDlBLNyCohbTOYbnF0mqU=;
	b=EHtS3PkCfRLBEGwT/VWdUzx6OiItXKJm4shOdq672F6x8dfPAjhZJG3cCyG2sXZvS8eWCH6By
	OMd6i4fXwEKHZNv6ConV9Y2kZur322e8ivbTwiTHlYm7yU8XuMrrE7sr/hy+QcQsvEd5OxXOUQB
	VpxgS24zdvRIu+VNUvBU+O0=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fbCJg0SN3zKm49;
	Wed, 18 Mar 2026 10:22:11 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 17B4D40539;
	Wed, 18 Mar 2026 10:27:11 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 18 Mar
 2026 10:27:10 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <muchun.song@linux.dev>, <osalvador@suse.de>,
	<david@kernel.org>, <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>,
	<linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH] mm/hugetlb: fix memory offline failure due to hwpoisoned file hugetlb
Date: Wed, 18 Mar 2026 10:07:11 +0800
Message-ID: <20260318020711.3596947-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Queue-Id: ED6C22000A
X-Rspamd-Server: rspam08
X-Stat-Signature: wg9pi7ecyofryh9wpnskry69mzpqrony
X-HE-Tag: 1773800835-421531
X-HE-Meta: U2FsdGVkX192uuyZ5ev7QJZSmcLbZSXF+fVRWkpRB/Z9igdU8RizuwF013nUDKaZ80ZlqFHVsCChDlpfDfsRZK+LpUyaJVWNR8IzFZp3+NZr0cPEm/3cZQSeE7TsfBfx6z+SCFI04EMlwitKnhJAwwPYWHcoILmRWEAEK8aKEnItSPiCW77rawytuWDAl+HX2xc0E+aM8eSOnj+ZExO5HWM8FD8mmyg181X5itdCNncFGqgM1Xe5NwYahPbm7hwfKYU4Ww5/UiMaXWrGsiRRLLNzyGikMeOdgmQwwKCO1OwANE0rurb5a2QS67bbP+m1B0Wx/VMe8Q5C0owBMTln/917zEYVsMkBDTy+8llP71CluztSEB7PID6HCpin5YCpflPBybhMZysgaok8mzGSRAwkt/pODgE1PMR4kyiTEnl+jGv0fsXIs2QlP8nAG9ykMrrgiCBiIUg3EdoymxedKUCfLJbxNToeBqRx8zGn4NKJZBEC/yQ64W0+xn2UMwgxMBWwSNKv7UN42MhI9YHq3ntuVful9wHtUCgmB+IbKsb6N7esfU/rxL9UProwayCjXLikoh7E8ZEKDdlgC9+rBXo/+lOlzn/4sHOjHChiGfltp+FjqupfHoXGwDxAeoWNgysMyU6xDk6P4hWJmpSAUZNETIbxK/syY8Lh4lhtuLP4EXEz1GtD+cRXIU6AOkGpNPEIKT/D2p3BU70KacgO1YbJSSY/ek9wIaPgeZBsGTQ65RvjxmI6GEBM/bszgxKnE5L7QpKnbSiBN5YOQ+xP9R9Hm/u9F/e1ZSxD4fdFLzYUrM2UyQRCQbAt9sT+Hr5Kztm6u8FHxNbR0ZrVPS+o2+GsaWV5MpudIme3ab4p9xXKNCRLz2AxeghfOUw5qQ6ZYQOe6hRdRo+sbqFj5XDxyc1f8Zdp7I1C+My6n6i/LHnYwvzJozE4b6FZxWWLO+1LExJ6x8rWaG7zi69nsdn
 DzKnmoSa
 IkaBHI6s+XXdf5BWSIbjLbFW3MsY5arkXfSaBzLCWP1M5hogUuh/itoiZmvVkWj3nvWGeVHYYnu0GF8quf1nQEyApnXgrSY3QZq5pG5cSXOK7an8dF41uyCB14ctv3k3mjoQghzaGvghyvtK5mAPzZCwk1TZuLx1djphkw0CW65gRtYmT5zb+azP6iR83vY7Q2Il8fpx+H+sT0lKvEhl61bMA86INHlgRjRKQ9vJPqXAD4bAKMbTSQ4/BDLYjic0L0YRNezw3pQtv757p7fF9weJFCwEU0fzTDxTO+ZiRbLdj9H1BKE7BTBcSdIV/1I6g19KymgYQ9AwBWjpBPjNrO+pZyzMhTTNCO2LNx0bNT+wnuoM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a file hugetlb folio triggers UCE, me_huge_page() will keep the
hugetlb folio in pagcahe with refcount increased and PG_hwpoison set. Even
after the hugetlb file is deleted, the hugetlb folio is still leaked.

If we want to offline the memory block that the hwpoisoned hugetlb folio
belongs to, it fails in dissolve_free_hugetlb_folios() due to the
hwpoisoned hugetlb folio isn't free.

I can reproduce this issue with the following steps in qemu:
 1) echo offline >/sys/devices/system/memory/auto_online_blocks
 2) in qemu monitor:
       object_add memory-backend-ram,id=mem10,size=1G
       device_add pc-dimm,id=dimm1,memdev=mem10,node=2
 3) echo online_movable > /sys/devices/system/node/node2/memory136/state
 4) echo 5 > /sys/devices/system/node/node2/hugepages/hugepages-2048kB/nr_hugepages
 5) run ./hugetlb_file. This process will receive SIGBUS.
 6) remove the hugetlbfs file.
 7) echo offline > /sys/devices/system/node/node2/memory136/state

hugetlb_file.c:
  fd = open("/dev/hugepages/my_hugepage_file", O_CREAT | O_RDWR, 0755);
  fallocate(fd, 0, 0, HUGEPAGE_SIZE * 2);
  addr = mmap(NULL, HUGEPAGE_SIZE * 2, PROT_READ | PROT_WRITE,
		MAP_SHARED | MAP_HUGETLB, fd, 0);
  memset(addr, 0xaa, HUGEPAGE_SIZE * 2);
  madvise(addr, HUGEPAGE_SIZE, MADV_HWPOISON);

To fix it, when deleting hugetlb folio from pagecache, mark the hugetlb
folio temporary, and put the refcount increased by memory-failure. After
the hugetlb folio is deleted from pagecache, the refcount is decreased to
zero and the hugetlb folio is dissolved.

Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 fs/hugetlbfs/inode.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 3f70c47981de..6bebe2e67f3e 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -603,6 +603,11 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 							index, truncate_op))
 				freed++;
 
+			if (unlikely(folio_test_hwpoison(folio))) {
+				folio_set_hugetlb_temporary(folio);
+				folio_put(folio);
+			}
+
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		}
 		folio_batch_release(&fbatch);
-- 
2.43.0


