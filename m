Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 075CDC87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 09:04:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 990B18E0003; Tue, 29 Jul 2025 05:04:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 967C88E0001; Tue, 29 Jul 2025 05:04:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A52E8E0003; Tue, 29 Jul 2025 05:04:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F0C98E0001
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:04:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3EB8A13401A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:04:32 +0000 (UTC)
X-FDA: 83716716384.24.E024C25
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	by imf03.hostedemail.com (Postfix) with ESMTP id 51A5420004
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:04:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=J56PRHvD;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf03.hostedemail.com: domain of "prvs=298daa15c=acsjakub@amazon.de" designates 52.119.213.150 as permitted sender) smtp.mailfrom="prvs=298daa15c=acsjakub@amazon.de"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753779870; a=rsa-sha256;
	cv=none;
	b=4chxXz/x135PXPH5rHabUKTev3j0UN3UY6WGo/ZCpLFmC9c1CYyqO7mp8FILx3A+Gg5WiU
	aa8TP21wpDg0PjzcuaPMlU4jp1H8KedGKndcrj/lG1HlqobldEfFeGux/CK3BpwP7EAenp
	k/fl/NT/IB1teBHifg5LeghARUUILWE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=J56PRHvD;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf03.hostedemail.com: domain of "prvs=298daa15c=acsjakub@amazon.de" designates 52.119.213.150 as permitted sender) smtp.mailfrom="prvs=298daa15c=acsjakub@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753779870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=q3h1jVcZkOPlZ9Iqdiufq8QHLDIRYxNPqMVEVVeO8BM=;
	b=OjlIBM+4Y22K9FF1euAPINoOnHTDeaw6kJxSNL8B7i5Fj/urtILbWXjAQNzW0w/d6Gxq8P
	UTExrWu/vZ5jB5+l3+GFP5QOyKaAEmNqiIhBxeDKp8cN/7aWD8UHfablhfYMtfQynUDPWi
	FRGCdq8/rZFCj7buZJdqfL0fit17Tv0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1753779871; x=1785315871;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=q3h1jVcZkOPlZ9Iqdiufq8QHLDIRYxNPqMVEVVeO8BM=;
  b=J56PRHvDBa3hjw4L4CrzYUyWljWjbNmZybeSyo5yQuniktvKUtDW9tIc
   nV2uilOJQdc5tecwvE2UfxcohTE300JZ1hkP6JSFwP/Ir1c4MNbsrT/Xk
   4UEVQhpcCBhxbSPMm9JOzc5CAyHY1oxTjHQOhBvmO+/sDdJHbk88IAI+O
   /h+B5xkgDFH0A4F4rQlJQgbHjDZ8FJ5kpDxk0ky6spf93gEUZGZLIha2f
   neMMeQmGXmZl44Kb0XAyr9TvyfyaM8etecc0EAP0/AdzG8goKLbc2usL0
   GJAVzhXpRr7Fh7A50LCUthW6zp33Vr77KVMfns/WRxNMnvwz0WGP4rJnV
   g==;
X-IronPort-AV: E=Sophos;i="6.16,348,1744070400"; 
   d="scan'208";a="744631717"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 09:04:27 +0000
Received: from EX19MTAUWA002.ant.amazon.com [10.0.38.20:57416]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.2.204:2525] with esmtp (Farcaster)
 id 790c10b3-294c-4224-9d3c-12245aa7a732; Tue, 29 Jul 2025 09:04:26 +0000 (UTC)
X-Farcaster-Flow-ID: 790c10b3-294c-4224-9d3c-12245aa7a732
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Tue, 29 Jul 2025 09:04:25 +0000
Received: from dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com
 (172.19.75.107) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Tue, 29 Jul 2025
 09:04:23 +0000
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
Subject: [PATCH 6.1.y] mm: khugepaged: fix call hpage_collapse_scan_file() for anonymous vma
Date: Tue, 29 Jul 2025 09:04:20 +0000
Message-ID: <20250729090420.19726-1-acsjakub@amazon.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
X-Originating-IP: [172.19.75.107]
X-ClientProxiedBy: EX19D032UWB003.ant.amazon.com (10.13.139.165) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 51A5420004
X-Stat-Signature: qf8uej86dsegxm1esr1jhghw5dzrg8mi
X-HE-Tag: 1753779870-90860
X-HE-Meta: U2FsdGVkX1/GVZBAB2YR6PaEz609IHH4kY5KLrc4SMwkJqOoVwAsLsOoXXzLUVXzQrqdGh8srtdk3WaB3XoEC40ER2xrWYu/P/uNuIq8ahoUtfZmSulzypFo/EivMomxZRo+mdYt25NQxIMCtBcYPgsUkwOo0EMx6NlftEPNZw33teJrnIvHoS9tqD24zYUTBLGeUl2nXiOtU86Y0GB8SHPQ1KxH2pTBpKk8uSBKbTCV4cHOjS9Q9qBX5BXsFzk8WvoorGaMkmxZpcYbTe/YpBuaLFsgj28JzVsvZOXmVsdn/pyxVRm7Nc4nkeAm2eEnW/a6L9KI2GwHY4zGjV4dIX7KagXqcjO9XvDeEBH7dxiGzDpqOX8wy9gy88N+sIo0NEtTyU98VFwgc0dg0Po8PZZbGOcNqS3seHCZv4CsuqYzA5nhrPIPlMf2tIiEJPXL+YQfF8pDJTWt7IYugbDadRd6/QqBmc/VHk74GqIIaW14+T40uMNN4583lot/zwMtnm4dpzZTEuSTILx8aUAzx5L8LOigFm+Os5+ns8B1m75RoVLUL3euNwh2PZ+GvLSbHUlE4yHvZi+HbrEmfulaWsb3UFb/2h1tVFC633wo9JqOJcDAoUglZvEFwQSoEnRlCPort7ZmUbjcRlD2mPWLlGUFxWphKcAsaGvyqQyGgNMSNlNu3aUX+IxqTmEEvRNeDZMbU+fFP00aGomD9UQfFnEW6J45jnu88EUGrGlw9NIqBTZ3eYCcj82oNQsk/TLW6CMEb6yuMM71kePdnK6660ASEC0VoqM96ifeRGSiaeEhYFr1D9fEAaKOU2fKb4+4+hMc8OrkgE1+FqOCihYKOnmVkCa3l6MzqxdKQwSHmKZoGD2A+iHXyMQ0gnrrxtsIfhq9WRwUffDO/XPIu3LAErDwjODOQ+tsrdLSfR9174qI9ik7I4CjPGzlTGvxHjDrvcd/ojFiPQMRVYzGZgG
 xoCfHBUr
 OMN0uDC5Yr1qZWRoSkX4+Jp4kKwiooi5jT6sjOndjfAVHtC/74D6UbsXaT/YmavXTuva6U9C7im42s9jO9YBzzbG6xsqE7gVX7LKsryvvDVLM277YV9UDd5Wyj/XYEbtoaaPAO88FoXMuXtGgl42kzihoiFqWYSZYd1fkhRBwfBi1KUarjVr7biHsZYzyaXGDqdByeUpeGmPuKXOriq0lcTyqZKKACQf3nGzaRoOIMOgokX1w/G97onw/VlzWl7kVSBSqhyWK8GmlAoBFYPaIYztmPWOJXnPMHN+BqXtOxNCybIyKhJ6W9CRfbZMI5COyPLFj/3zNu4qkfsFGRNc4XT/YQqErZEMknpWYW6Xli0q2cgrH5km7g/ZGD0Q3/JyM2r4VO76ixPPHvgNKNK8KUMnPXqF3CqROirWZguHQ4xP68DuGct66uFISaE2oEQINRBvydQUcFboTVZ0WS0IJcQUD/lWuymLzh2OoyHNWzL9w+nkWlpr/I4ufcQT48R8m9XrZX/WlhnOlGOwC8/R0MN4PtwVz7IM37XM0kaimW9G9h7s5L9OaRWDzL5qiXkD84ttjlzRhd1QuI+EYhzrSPXR5sIl3ArH234efYP0xviULHnB+Fj8ODaOcoABCgd4ttSdyxuxf7tieJSlgZlxBuzLQB55XMxAL2YZMyeQLPoFCtaEkZ+JyRjcGM2YDTDDoaCFwOzu1NRBUxwGZObwZ8kvVAl+32vMCju4+BEzyebO4KjT9o/FQWkmdNfdokd9hWv6awm63KQo6IwfVLAfmBbDVXXEq9HjTnMDCVUWc7rwyZL+LKJK3FjXaWfUhC6TqBs7jLXOTlQcXQrvPeMGLas+sKyendrjNtWegMiP3zaCpaRF8Tj51YCVQ50UA2btw2seXMHpL/6GJtffaB51vjC/6XRwybg99EPhVJuEmxBcBhBx5AoK/tVMkLghGBcDWamDMZE245ZCIOctbeLEyP7QD1A==
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
Cc: Jakub Acs <acsjakub@amazon.de>
Cc: linux-mm@kvack.org
---
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


