Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 993C01099B3C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 02:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C03296B0088; Fri, 20 Mar 2026 22:30:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8D9C6B008A; Fri, 20 Mar 2026 22:30:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7B3C6B0092; Fri, 20 Mar 2026 22:30:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 92B9A6B0088
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:30:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2B2B81D7FA
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 02:30:50 +0000 (UTC)
X-FDA: 84568492260.03.35AC938
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2F52420008
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 02:30:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=04GvdY59;
	spf=pass (imf13.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774060248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Gfomm5XVnSgWk3nONN7f9HLeWga4oKOLtba86qY7HSI=;
	b=PqCWoMq6o1/ceN91hsNGVcrIM830/bdzcldHmVSO5AlcR07xSO4dsIko49XnB5yx7oLjh1
	cjakaKnc4rbpryulj87gR1yPpYYWSWiH3IfbPpUOhkKXlhviD7xtJQg1Gf1tSYTKROkYdm
	DRbOVPUV+D9a5rrrc0frhWBC/qFlWOc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774060248; a=rsa-sha256;
	cv=none;
	b=YA8usD+CuQJquCrqHdpTcb8RwHK65aoWrCWYQL8kn87VMW6yH4qtyOqyviNNQNZV2pGXa+
	2FSzUMckXhDYS2V/JQlCP4O+LEetm7NOkWXePOOyY93RWcKhXqz0Es6xdr57fPOjjX6pmL
	2BvIDyN90MyjwHcXKA4ZpLT4pYkkBuk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=04GvdY59;
	spf=pass (imf13.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Gfomm5XVnSgWk3nONN7f9HLeWga4oKOLtba86qY7HSI=;
	b=04GvdY59+YwQQ4ZeCs+paAmmcZzVgQpKYoOgbgDAShWb6jiKbraBZL5bvHqKPzP9WMKO0KnOI
	oZHKPW8yQqkHdJT2jj/53OUBcu7mnLdRFyuOtplkYCNBU5VdUs9cA3Vlrs16W3NpESWmiGKiMwx
	nm7gbGvD5zTWRU2hRXSKxJg=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fd3FJ03K5zKm5N;
	Sat, 21 Mar 2026 10:25:40 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id D399A40565;
	Sat, 21 Mar 2026 10:30:41 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 21 Mar
 2026 10:30:41 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <muchun.song@linux.dev>, <osalvador@suse.de>,
	<david@kernel.org>, <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>,
	<linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH v2] mm/hugetlb: fix memory offline failure due to hwpoisoned file hugetlb
Date: Sat, 21 Mar 2026 10:10:31 +0800
Message-ID: <20260321021031.2240780-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Stat-Signature: ncf1c4wuopjergzuprkqf15nq46ankk1
X-Rspamd-Queue-Id: 2F52420008
X-Rspamd-Server: rspam03
X-HE-Tag: 1774060246-518943
X-HE-Meta: U2FsdGVkX19ezsoUi3YNnLaxp1LZXTfXhj9+dGs90FkVR4n0KhfrnNsM4ghMTQ+2wMygy/c0q2I13T3DMwWBnUvGLe9RB/JG02Q5p5QuJhlSUcU3c5uBHOjIkhgyY3NhU0M8QG+gZnDvnf6WtgbnWry8Klh4owyRLbzwFabZW7A3/fqisi7TFm1FNlyeI0QuPYN8SuTDqVEryStKiIkn3cnlYFhB+AILSIhm7bAkKsH9QsLYFTW/fNu8XdR1E7V/XtgRED2yW/KpmcmTvJ21MJ20akdMsVPyRZK7b9UZjlmh44xXBpQbKSokwDD1IT4OJydtwypsDLzBLGo5mF27Sx3LwGNhN4PfBR9MPwE+6ab9JJnQKy00XUB+GbJZznbmJV+CZ3Kq7v+u2DAUY50wQzojmzbGWJeYiWyt4NMTOFUaF/3DgS2D9Fg3W6aFhlBScjVvLYe6KqXGVpBmsRg/4X9QP8VlbGQuhI4Tk92jmJtTVvY1W3eqgSPgFA5OVYJI8MDfLkLN6gjcqFlmzjCpRQF38fFHLo2ZUqcIJqzCHlW2R+lWRgB3nJ6zWwsmwXppaxkWmwr1qaJRl3m4WHtiw6ZVv3ZKYgPhBJRWsoar+FQnxhQFE3CDmaaqVp7LVZwWP4uLjvfVEUrNpBkiKGrbpt6nrQGRgKFgWX1OfxQm9KJqoIg5pguWsFdisvkkZ7v2l5S3LZGbDvkx+X89i/hPwx3Ng833H0sao7puvuJ5EUqS7Pr850Y5hGyiR1ALcggcEc/Y+nhZWOoIg/t2WfBGkewTNLa1OIcsz5mELUMZXoT7r4JQX5sNrPqHbee+lphalnhgBCoD5Gcd7J3d47fCEw+JliQSDYMBKoYd7qWL4ZRp8xI5HYrB24USvjhXVpwmHIdCqDbndhPo/f7eECV9gP9siVzqkQvZObw85IyNnN0zPUW+Qr7PiAuNkhxBMVyODQQpjV0B8M+uUipCfSK
 6CdUQLrN
 1MHsQURCp2BSnJXZr5C0iHGCv9MxkN3avzdoGzM2r3/2nKDb+uHjb3GO9AfPvH9SwGBmgSxMz8hkvf3ltzX1y89XJsABlh+HeeRU46e3PQYerVY66KaCOq8g5JBAUG29qEbI3FRoTbWeNXG1ftymbfZVaquV9k3GrcazQETDIvdSsXE1htyIiGeyxYBuH3rMm84VgWgCo3dTzHNmGFBO+4tvv+Zrh7wJEZ/8nUGG6gwG1JYsOxAQWKJyYK/3PIxdbgjct88ny+mJCADYTN2+tfctVzuArN8He50V+7za359aFTq9qh/r/U5DnE8sh7Y48uDBm+adajTvDNMtpvMRmpYaaq/Md9cpTYRlDN0HFd/IpTQo=
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

To fix it, force to put ref of hwpoisoned hugetlb in memory offline, the
hwpoisoned hugetlb will be freed and succeeds to be dissolved. We couldn't
avoid races here, just like commit b023f46813cd ("memory-hotplug: skip
HWPoisoned page when offlining pages"), which force to skip hwpoisoned
page regardless of refcount.

Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 mm/hugetlb.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 327eaa4074d3..b7d6c905b4b1 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2115,6 +2115,15 @@ int dissolve_free_hugetlb_folios(unsigned long start_pfn, unsigned long end_pfn)
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += 1 << order) {
 		folio = pfn_folio(pfn);
+
+		/*
+		 * For hwpoisoned hugetlb, put the refcount increaed by
+		 * memory-failure, make it succeed to dissolve.
+		 */
+		if (unlikely(folio_test_hwpoison(folio) && folio_test_hugetlb(folio)
+				&& folio_ref_count(folio)))
+			folio_put(folio);
+
 		rc = dissolve_free_hugetlb_folio(folio);
 		if (rc)
 			break;
-- 
2.43.0


