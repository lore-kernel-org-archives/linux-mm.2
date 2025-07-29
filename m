Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85932C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 09:04:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23C4A6B0098; Tue, 29 Jul 2025 05:04:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ED656B0099; Tue, 29 Jul 2025 05:04:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 129BB6B009A; Tue, 29 Jul 2025 05:04:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 026406B0098
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:04:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B5F01110F03
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:03:59 +0000 (UTC)
X-FDA: 83716714998.30.672E470
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	by imf04.hostedemail.com (Postfix) with ESMTP id CD7754000D
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:03:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=RcwSM5UC;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf04.hostedemail.com: domain of "prvs=298daa15c=acsjakub@amazon.de" designates 52.95.49.90 as permitted sender) smtp.mailfrom="prvs=298daa15c=acsjakub@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753779837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=q3h1jVcZkOPlZ9Iqdiufq8QHLDIRYxNPqMVEVVeO8BM=;
	b=LI9Saka6oWDNKaOCcRpchuwjSqQk3FT0V8+uQ/NHrkqdnVTwjQODC3nBKl9ub7balGK4sT
	h7q5cET+vgAuSZIZNhrWgHbzQpmw07aeHhiM7qW2eRWyznLUBFzt8kSM0R5SaVgqaB3wgJ
	C+o4XQcfe+gqKpLciuHxMnjzka66gNY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753779837; a=rsa-sha256;
	cv=none;
	b=M8c0Q37MUezQs4SC2Q69No39M+zcOYQxrPvDajGuAbQk2j0H2fLUQDrNflFBymjtyOlipk
	tNfuxfozLL0crVwSLnSp15dECnBUlHiDeFxspAkwKMafsoFjzMUrybPuRBHbug+yZ+PfVj
	ERh8GJeb3ubr/WjsUr48YrtkqUIewsc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=RcwSM5UC;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf04.hostedemail.com: domain of "prvs=298daa15c=acsjakub@amazon.de" designates 52.95.49.90 as permitted sender) smtp.mailfrom="prvs=298daa15c=acsjakub@amazon.de"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1753779838; x=1785315838;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=q3h1jVcZkOPlZ9Iqdiufq8QHLDIRYxNPqMVEVVeO8BM=;
  b=RcwSM5UCTMo3lvrnEuiosj8qfG/rnN3mo6rYQ/UqCUCoruNs2THgWSCy
   hcjmq/d4kHg/ZB+b8GHO+UO9wWD/Qna4J1rC+oLCc+vXU60l7BnRRqnSg
   uDzK5XbpeMGZPbTAJ9DvaZ8PfMvvVShksjQSUx6f4A7V8MgziT5vDOmNW
   e8jICK22WC6BWFdQ7sRKR9LnbAq2+WbMwW/UfIOxFXRtQeInbLrW4NhYd
   j3zv/4joWqe83FqrGfdPd2CKAmsFRmE/1c/H0flKYViUp0fFOnjhcGevP
   A/YZt2vfLETfAj0RqqS472eiv8EslpgO8zwH6wbpWpiWXb5/4cYZH8B/w
   w==;
X-IronPort-AV: E=Sophos;i="6.16,348,1744070400"; 
   d="scan'208";a="519243793"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 09:03:55 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.7.35:52595]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.62.141:2525] with esmtp (Farcaster)
 id c149ebea-93f8-47d5-a118-6e4489a8d76a; Tue, 29 Jul 2025 09:03:54 +0000 (UTC)
X-Farcaster-Flow-ID: c149ebea-93f8-47d5-a118-6e4489a8d76a
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Tue, 29 Jul 2025 09:03:53 +0000
Received: from dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com
 (172.19.75.107) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Tue, 29 Jul 2025
 09:03:51 +0000
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
Subject: [PATCH 6.12.y] mm: khugepaged: fix call hpage_collapse_scan_file() for anonymous vma
Date: Tue, 29 Jul 2025 09:03:47 +0000
Message-ID: <20250729090347.17922-1-acsjakub@amazon.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
X-Originating-IP: [172.19.75.107]
X-ClientProxiedBy: EX19D041UWB004.ant.amazon.com (10.13.139.143) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: e6hpdpy6kubk54kikniibszjtf5jzdqs
X-Rspamd-Queue-Id: CD7754000D
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753779837-747421
X-HE-Meta: U2FsdGVkX1/5aPLY/BIYqey6qxIi0DNn4VGkgA4f6qlHoBHhHQCBYddeYTu0x5AwqsRrhWlOy8Z8K6YGY4L0oJLG1suysQDOzdSJOynsilrnRtlURa5i8AO/IC4u2moz4tzC8ATx+6Rsf9e97tNy7yVOk5sUWnShl9vFqNksmcAY/0bGaLFHuWPOJsYL+HHgPgvR6+Gof8l9UxLIal9IMvC7c+yjwtYQFi9PfQcpr+e1huAHjMKeRO65GqjbFh6RYRtTnuxUhx90lS1/2HrhJGyvLL7ytFxHDto91zlw1TGCMPpusfmmEnI0GlmTdgtS+INsWrrXC99CLMSgH836Vc2036cC5tHZGMErF5xhUG6dZEMqQjeG1vLLye7Q605QWABdGOHY+uAaKBX3Ial1Kc+ft3o9pNcbD/OJvbSK0IESuBR1Frp6DZDAbHAMIoBdOOVZA6xiQDXIJOU9tWy12afqJhRTb+eIcSkg38uXt/BEhTiJ/wiLYAy6Jwe5Z42cRxyKUV5Uixad1kD3dJwID0eLU4Od6b6R5zT9ie+PTJe4dh5JiJ267rJPpbzyuPmH+TeV7z9wAQh4FHHXoOaVpsVMaVmzpurCjy3AccvkALOLkWiNytb1pFY8ShqYNlSf91iPts8M9otMINh9K9hHFoGzupPwLcsqWuZMpXQtE7u9f7qlU5wAx3ERrSNgsYN7ZXgCjgDHhqA8nQ/e7pcwZ6kj8VopPv+AtJAygNUV5Jrxer9X3pkUfXmgga8HGlHpxk+rr33Fj9hMAdmJQ3jb2cvVqoElVq5D8kfrFZc4UVtXTF3Q9BlbImdJBkP1egpiFLBjBPacpO4YnVB7oayXMJv2QhA8DuTX/HHCPfvbA4UANgOs54baqVrxuo1tDZL+KwokZ5Gs6YWz9OQ8WqMdf30Nvx4D0dAZSuof51Yaw6lwZSlGmw7j6RfBz5ET0Znso5v7cT/CpjGlne/DgCd
 cnoRx8Wg
 N7RuBKcIXU7VrwTx4MFZuiGzgQHIxCgCsbkaNzyRzuEBww8g2M6xAxeyAmevPhYLXYXi7gVRC3FY8Ywn12sOjeKwO5B14p658yqECO1UQj6wOvUZFj4N5LqsUrxx01m8YHQEIZdA3jN2W+4RkkqUuFkJeeZm/Gm66+Yecrn3gNDajsdfYekRZRMFjSjoOBvdY8txJHJaB+RkTYvVoBjg4CH+H3iuZ+dvZl+JIwWaJnKjW8SNCmWOPaqKciLfhFFiUXZ2FVymacmnSCttzcIy9eCFjQGatzazFGUdNQud77n65zSG/wCiIrO9zbf1PEfAzQw1pTxBBAiY80PQ3o4q3FyrHG9ftcTn37vNmfdgs1awwjC54ltyOwQJFlzJffACcBo5IgWUz1J3oBfbzurJCbJ8mWuHEBmPl5rv2CT3ToOWL+KMIinqV4wZl51FlAPAudeoS+/a69YslP6vGSOryDgPwIcrUEXlE69LsjNGx2nv7ui3Ps32vIBAVEKWz/JmO0ydZ/XloP/i8PFxQfoEOMRyfRV9z90vZPPGOcDQNXBe7cSq3FgaYIY17iO7zEFcggwT12llNnYhaHNG5BvLHqVePdxWEUSu4ZCnWZb8mGa9TU9Ghr2+HMLbfEhWC0l8IfIYQLsBCPsRRX3bAnzeZSBbqM0WoeZ62WXzEYXDbqbjVyIXAQ/RoIjVJr2KEvyI/omOeALOEepegmpgTxiHcFqNe9vEtiKrns66gDxh0Www3DsdJYfPMyKU33XhuojvQQn1WAG10VoZdQUk4CqXBkTConv+YI/qgg4fZjuE4jMASX2+as+IyvWdYB3L0c/PJ5M0sabd+/66YGyajPjA7fyB4QkTyJH4CzB8+8PZqEzvqGVr7q/+32imj5e9jf0cqhvUR1IPvpUjZDgBGfW0X8FD8zz8JHHEb79Iruslc71K1mxLFNcb6TShpMMitGAas+118Yndr+aHsQzA=
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


