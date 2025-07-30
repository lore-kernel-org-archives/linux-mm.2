Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E855C87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 07:39:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 796476B0088; Wed, 30 Jul 2025 03:39:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 747AC6B0089; Wed, 30 Jul 2025 03:39:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65D816B008A; Wed, 30 Jul 2025 03:39:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 519816B0088
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 03:39:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CE8F4C035B
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 07:39:44 +0000 (UTC)
X-FDA: 83720131488.05.9E8B32A
Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	by imf09.hostedemail.com (Postfix) with ESMTP id 96CAF140006
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 07:39:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=GQ2kgXWi;
	spf=pass (imf09.hostedemail.com: domain of "prvs=2993f5a26=acsjakub@amazon.de" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=2993f5a26=acsjakub@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753861182; a=rsa-sha256;
	cv=none;
	b=iw0Nz1Id9OpsoxpBP31RJVNbAb3NRv9qpUvjAWB7vaVpz3i6lH0z/JnSOXTxO5FiKE3QnD
	98wwE0+ojxa0uS2lwlRjVxqLBOLKuOIOnoRaj+aNZwsa1rxI4snZ4VSpdvRoOBwVcpch39
	B7kgJQQSuK6kbqrVyzP4OS8+PUlCGeY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=GQ2kgXWi;
	spf=pass (imf09.hostedemail.com: domain of "prvs=2993f5a26=acsjakub@amazon.de" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=2993f5a26=acsjakub@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753861182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oVpHujIKEbwnOnxA22ZIgd8V/890VYrstz1N5qLXglg=;
	b=n4QEPCLF3Uq2wfLLE/KElAbPOqe4JU/9lY+uqOuOQH1aMJslyUIJGNy3YaoEo/cYCMQOfz
	oD78C6hD4SEZ1sN8cRz38NMUvS7r36L0hsRYKTmBt3Rr+2icbBn80ZW06B8aA4Pqb9yhIV
	kJxsIpbDTz35in8VyhFrktxoqDv9akg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1753861182; x=1785397182;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oVpHujIKEbwnOnxA22ZIgd8V/890VYrstz1N5qLXglg=;
  b=GQ2kgXWiks6BQ/FTjdlWEa2HWm/AhVV831OW36yklm9gNvOmcpO6EWkq
   9JHXEc2KME5yPDBNyZulcbY+JTdOvaIO8OGjqoBN/lA5xQMT1t+7QJEko
   c4xZwTm04VbS3qVHmX/xi7/ZgPFxsjDEPpaHmfByBKvwH/7kZRRfrVO2b
   vQPUpvnoF50KN7Nn8X25E+LlUNivB7CA0wn5/+kouVer1UbxPR9PHJGm6
   fcJy28JCA4bMnPdRMhgMjQ27HDF/KoiPgxya0o3Xe5aGGQ84m75XQ8l18
   r6FK573o6YfM9UhaSMzoefPWsRPxm/6/2ZP37bMioG9idhXdr1Gc6yXfJ
   g==;
X-CSE-ConnectionGUID: sxu57Rh3Tsu3wsYfVIeVZg==
X-CSE-MsgGUID: s5qnUr5aStSFIy7rCXS9Og==
X-IronPort-AV: E=Sophos;i="6.16,350,1744070400"; 
   d="scan'208";a="484926"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 07:39:39 +0000
Received: from EX19MTAUWC002.ant.amazon.com [10.0.21.151:37472]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.22.29:2525] with esmtp (Farcaster)
 id 5ce5c615-36c0-4a07-90cb-41fc505535f6; Wed, 30 Jul 2025 07:39:39 +0000 (UTC)
X-Farcaster-Flow-ID: 5ce5c615-36c0-4a07-90cb-41fc505535f6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Wed, 30 Jul 2025 07:39:39 +0000
Received: from dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com
 (172.19.75.107) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Wed, 30 Jul 2025
 07:39:36 +0000
From: Jakub Acs <acsjakub@amazon.de>
To: <stable@vger.kernel.org>
CC: <acsjakub@amazon.de>, <gregkh@linuxfoundation.org>, Liu Shixin
	<liushixin2@huawei.com>, Yang Shi <yang@os.amperecomputing.com>, "David
 Hildenbrand" <david@redhat.com>, Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>, Mattew Wilcox <willy@infradead.org>, "Muchun
 Song" <muchun.song@linux.dev>, Nanyong Sun <sunnanyong@huawei.com>, Qi Zheng
	<zhengqi.arch@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>,
	<linux-mm@kvack.org>
Subject: [PATCH v2 6.1.y] mm: khugepaged: fix call hpage_collapse_scan_file() for anonymous vma
Date: Wed, 30 Jul 2025 07:39:27 +0000
Message-ID: <20250730073927.27312-1-acsjakub@amazon.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
X-Originating-IP: [172.19.75.107]
X-ClientProxiedBy: EX19D033UWA004.ant.amazon.com (10.13.139.85) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 96CAF140006
X-Stat-Signature: fe6yzu1fo178hjhcoziogrqxyok17hgm
X-HE-Tag: 1753861182-23080
X-HE-Meta: U2FsdGVkX18eIa3DBJjBsp0yFP/TTQJlFj8Ympv2HVGTCIqeq+Znj0w+U1J+HEq2OrDg0M+a7gBji1mjR8OGYVjEDwqeSdzVuJG0MeIoZEN3nKK/gBmXJVI2d8ME6XXXSraM3ut+4hmvZT9sfYkRRCb6rgGZmG0pMctnFbxYNg3Y0Ih6IXSqKpN94Y3AqfAjTI+64hDCKJc1fbGe5BvvlQaeCxn0xJRkSfqXci4WtU94BSVk/lCBlQp8T4KS/B/mc6pXsjQyEY/5i9N+m1rZ198K0a+vOVsc2F8uIXcvWjI18MH5mTiVtyLNfhnDgZejwmLe7QKuX/JmrgTFnHPjx4vdeWfLEDbi2nYW8ZLH58Wmxxw06WGD0GucmAyjzpXO9TtkwRpaMd5pTV94s/PZdOHNhTCBD7PceO02nf6l0YbW/hz5+rB6BruWtMSeXoggRZLP1kADVpB4M/I6tnz2BuNKkYA+Qp+2INDx9ScfHtHDhyPfDlU2soCK7+eMBit5FAD9zyKv8QnNEFsJ9gdmFNScVDmRGw16xwkbHBo5y7lJ4TbpyfYFajhVyTSUIpnOwnJNfrBJ9orXBYS2zxh5mi2m9pytsY/V0BXMUaT4p0Et5IPFbnOwPZsDjFBSMktjXK/SJN7MjeOw/k8xBjyrNaehpz5hR+7lPzrXV5ET0UQJKV197FiwihVB8LGRAW2xonfb7v7imjho8/8FyrIfLNafG0KppDlb0m4lNIMjKQEgXFy1XPXzyA6ULsdIDr8hp5lxZNGr/sIrnM6mk3HA2JDJixutbF5M2dUKjva+OzNBojFKbQCppwkDy45iDPKP/qdIpMirSPxGeRgf07kIE3HgUAsax1iHHlhRSHZ+zyUBxvV7VYhNNKJBGQADo4gnWU8nj5hyTRu2bBb4y+SbXCvIGn09BP1aT9Vyf0NYiyowc9M+EiTGToZQJmAe9F9dykqHRSSRaqiEiFLydw3
 PzUwanKy
 DeXLzWabLB6zTcVBekiHDte85916saqG3lgBOTOtV01LGsGZ6f7C1TQKqKVvyP5eNGf/kOc48Tznn0I3c63mDshi6wFDum3IFLrHcKR/yj+jg4SdKNV3RO0Hr9a2r5Xm9OodwMLCulhb1CYoTLlwntNqryZquk9W3lXuuudVEhU6M7yCc4gpmMR022SIWVdLXDK+vf5KPEOKv8ABwq/nqSZ7dfBHXs9Lqm5huhw4XdvI85TXja2fMHzvMu4bJ8cuCS6KsHoNaf0CLtbf+22BoR8yQRgAVocD4PoNSvRyHPdA1ppoApzE5nLDb56vvUEy+brXJ5qQMg4Yqe+tkFK8qhPRWdYRdEyJ7p1rUyDIPjEke6KKwDMinI7DLkI1YUNzBITy6v+AEbmzd2wRzRwq7lMuGaBRQnf1QaWML2GhVzIe2XyHvzr2NELxTyLj7VkpsWPKeLjFRugYTrybgsXnC00ZqlD0N5sLDuZq1ijVcOvsFDZ/xAArX7bg/KsGHUYvMejOB6BQ8LbTUXosBd1fEg+/cRSOC7iY3ROyPMNKsGLRuncbpTSaa4gFpjoel7m3jsAe9qbMUVNWHN2pj8P6V5XQFuGSQmnXDc/kha2lZCMXz0W1tf6JkJS5s7o6AGkbJVlp++r29SHZe0PNz30kIP23mdh6ydlVel07qKoCHu9avPe9Kv1h7etqB1bJnwLJ11bfnpSUueaONR92/Z/mLBT7JvoX7JIN4tbT8jHD8zbrUw2zOIYOYL8xzn6sTyFqgYG+dzK/twsLGYEt2Kl8B4ZvAQ9uQbdu3AZA4iIc+Et/wBi+E6pNx5tzwakXi/GcQCX/PWiOCPjU/+52bbd2csXFK/8P9oCa3O2rYo5vTY0PIuroQWkxXTi/eR47k7zmy9DvwTOXAHAetGLJBfOZtb8fXRJS/47Wf1U4UkppiE1a230FAOwW5bAPIj6Vnd9AIkXw+H4zw4OA1rf+lW/xAXYzgHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Liu Shixin <liushixin2@huawei.com>

commit f1897f2f08b28ae59476d8b73374b08f856973af upstream.

syzkaller reported such a BUG_ON():

 ------------[ cut here ]------------
 kernel BUG at mm/khugepaged.c:1835!
 Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
 ...
 CPU: 6 UID: 0 PID: 8009 Comm: syz.15.106 Kdump: loaded Tainted: G        W          6.13.0-rc6 #22
 Tainted: [W]=WARN
 Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
 pstate: 00400005 (nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : collapse_file+0xa44/0x1400
 lr : collapse_file+0x88/0x1400
 sp : ffff80008afe3a60
 ...
 Call trace:
  collapse_file+0xa44/0x1400 (P)
  hpage_collapse_scan_file+0x278/0x400
  madvise_collapse+0x1bc/0x678
  madvise_vma_behavior+0x32c/0x448
  madvise_walk_vmas.constprop.0+0xbc/0x140
  do_madvise.part.0+0xdc/0x2c8
  __arm64_sys_madvise+0x68/0x88
  invoke_syscall+0x50/0x120
  el0_svc_common.constprop.0+0xc8/0xf0
  do_el0_svc+0x24/0x38
  el0_svc+0x34/0x128
  el0t_64_sync_handler+0xc8/0xd0
  el0t_64_sync+0x190/0x198

This indicates that the pgoff is unaligned.  After analysis, I confirm the
vma is mapped to /dev/zero.  Such a vma certainly has vm_file, but it is
set to anonymous by mmap_zero().  So even if it's mmapped by 2m-unaligned,
it can pass the check in thp_vma_allowable_order() as it is an
anonymous-mmap, but then be collapsed as a file-mmap.

It seems the problem has existed for a long time, but actually, since we
have khugepaged_max_ptes_none check before, we will skip collapse it as it
is /dev/zero and so has no present page.  But commit d8ea7cc8547c limit
the check for only khugepaged, so the BUG_ON() can be triggered by
madvise_collapse().

Add vma_is_anonymous() check to make such vma be processed by
hpage_collapse_scan_pmd().

Link: https://lkml.kernel.org/r/20250111034511.2223353-1-liushixin2@huawei.com
Fixes: d8ea7cc8547c ("mm/khugepaged: add flag to predicate khugepaged-only behavior")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: Yang Shi <yang@os.amperecomputing.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mattew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[acsjakub: backport, clean apply]
Signed-off-by: Jakub Acs <acsjakub@amazon.de>
Cc: linux-mm@kvack.org
---
v1 -> v2: fix missing sign-off

Ran into the crash with syzkaller, backporting this patch works - the
reproducer no longer crashes.

Please let me know if there was a reason not to backport.

 mm/khugepaged.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b538c3d48386..abd5764e4864 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2404,7 +2404,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 			VM_BUG_ON(khugepaged_scan.address < hstart ||
 				  khugepaged_scan.address + HPAGE_PMD_SIZE >
 				  hend);
-			if (IS_ENABLED(CONFIG_SHMEM) && vma->vm_file) {
+			if (IS_ENABLED(CONFIG_SHMEM) && !vma_is_anonymous(vma)) {
 				struct file *file = get_file(vma->vm_file);
 				pgoff_t pgoff = linear_page_index(vma,
 						khugepaged_scan.address);
@@ -2750,7 +2750,7 @@ int madvise_collapse(struct vm_area_struct *vma, struct vm_area_struct **prev,
 		mmap_assert_locked(mm);
 		memset(cc->node_load, 0, sizeof(cc->node_load));
 		nodes_clear(cc->alloc_nmask);
-		if (IS_ENABLED(CONFIG_SHMEM) && vma->vm_file) {
+		if (IS_ENABLED(CONFIG_SHMEM) && !vma_is_anonymous(vma)) {
 			struct file *file = get_file(vma->vm_file);
 			pgoff_t pgoff = linear_page_index(vma, addr);
 
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


