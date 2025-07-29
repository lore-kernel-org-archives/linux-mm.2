Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E201FC83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 09:04:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 830098E0002; Tue, 29 Jul 2025 05:04:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E0B08E0001; Tue, 29 Jul 2025 05:04:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F6C38E0002; Tue, 29 Jul 2025 05:04:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 626A88E0001
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:04:15 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED02E59185
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:04:14 +0000 (UTC)
X-FDA: 83716715628.18.121A2BE
Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3228510000A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:04:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=AMZhx524;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf05.hostedemail.com: domain of "prvs=298daa15c=acsjakub@amazon.de" designates 52.119.213.156 as permitted sender) smtp.mailfrom="prvs=298daa15c=acsjakub@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753779853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=q3h1jVcZkOPlZ9Iqdiufq8QHLDIRYxNPqMVEVVeO8BM=;
	b=dnSb4+Wr7bh62GaikkYD9Aj8UnG1fw1CyUcR9TkC4jJMgYi22cZaNrWDIFNsXZVQRUzMNd
	FlNSu8EE59UrRs11ZhzbvQwE67MTgbnQpVotOLtvEWd7eqEyNAn1LUbji+rTp38TEJyTSu
	qgRsm3rer4NI2OhU0lutLZNcwTCFhh8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753779853; a=rsa-sha256;
	cv=none;
	b=YUOCgucBg59HgTn+YLWyZaFTuJ7Rcq2JisPFNlVfD4XKpKSsT0gp+Zun3q5HrqkOn6xSrm
	nK5z24gRMGz/jAW9EzbRADV0dSLmPChNH651P9DZ6X/d41AqJMRfejHlxTDgz/MEsd9aMM
	6JEkfcOihA9eouSQJ/YcZJfIJN1qA+0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=AMZhx524;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf05.hostedemail.com: domain of "prvs=298daa15c=acsjakub@amazon.de" designates 52.119.213.156 as permitted sender) smtp.mailfrom="prvs=298daa15c=acsjakub@amazon.de"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1753779853; x=1785315853;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=q3h1jVcZkOPlZ9Iqdiufq8QHLDIRYxNPqMVEVVeO8BM=;
  b=AMZhx524xprm3gX3kvYKQ+rWcfqSz96zEZWAQddjoaJmSZhx3lkLknU2
   HuvfGnft+EHDu0E7bejS2UebZ7wAdh6DtptkgVvJeHIyqvDMxSBQMt0+7
   wV31DHR/lFq93psuEiq9SY5ue+Ezztoz8E6lL9riOdLK7Corhcqjfbuma
   3sXTjZT19H8CgpynjmNjLmsWDhsAezlBAPI9L5GZ0iUbX6FaJ70f/Ed8v
   P2ksPMeBeGh9dhJQoweseQVsfGPfbUnV2NuLHKAiCZhmfV5vNdYKggPCH
   aIFrFJhV+RWUsNOFJFYOxHzb4Xu8+wVhWlv7mXLp4PBVpneg/NY26+2sG
   Q==;
X-IronPort-AV: E=Sophos;i="6.16,348,1744070400"; 
   d="scan'208";a="766742606"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 09:04:09 +0000
Received: from EX19MTAUWB002.ant.amazon.com [10.0.38.20:59488]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.52.124:2525] with esmtp (Farcaster)
 id 92270030-f242-4756-a15e-c972c16f08fb; Tue, 29 Jul 2025 09:04:08 +0000 (UTC)
X-Farcaster-Flow-ID: 92270030-f242-4756-a15e-c972c16f08fb
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Tue, 29 Jul 2025 09:04:07 +0000
Received: from dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com
 (172.19.75.107) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Tue, 29 Jul 2025
 09:04:05 +0000
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
Subject: [PATCH 6.6.y] mm: khugepaged: fix call hpage_collapse_scan_file() for anonymous vma
Date: Tue, 29 Jul 2025 09:04:01 +0000
Message-ID: <20250729090401.18684-1-acsjakub@amazon.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
X-Originating-IP: [172.19.75.107]
X-ClientProxiedBy: EX19D031UWC003.ant.amazon.com (10.13.139.252) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: g8w5wwobohtea6u8f4kmzhfne63jwgmn
X-Rspamd-Queue-Id: 3228510000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753779853-831352
X-HE-Meta: U2FsdGVkX182UqKasgYWzK/ROOqkgCYroLDvF+BnACFL59MPfGHO3q2Vd5IYJj7XU4KwDe43sN1Fe9IHcnBBrDIpQnT1IY+0gTjGqRKjjMtSn4IBLSv3nrVaSxXkGwuKqSWp2zzvCc5p/0DS6StjrNY3f+Uo0AX4pgs1CBVtaPKpGFM0t5eP/FrsUoEHmVTmLzDgKsePlQWex0UuVa5eP4+NSvXzkLxs5vHyIfxFRjMrYeEmb6r8yAFYicwj8N+R+KzCBhhQbHLw5YCePaL7Sq3uHnkKrIahIocqk4jE6PDVpx7qEml+wIQ5ahyLhaudwSdQ+Q7kmgYypu8o5PzWgzIaUbyWHNzZwo7NG4oxS2t8NfI97sjkcMbkGewmcdhFLgEIkT6MemS3R+iV2h4ty4PYcdurRwpAAE0/AKWUtC/vU56JGxZ26AQ3JGR3nh7ETYp1mSGZ1OcW6Fb6J8A/wMpRDoLIB8bGfMnjWwkZyUnvZWsYg3qeXNyXbMXw7AQWdWAQ2jIbLZeON9KrnVScnSt9s2gcJMCDBdJLgoRJgMrfF/rC53ikEKfUONPL3aBK78QXWo42VX+9eukyIgeNvPzm8DWitUQwUBsKCN0GNZr6LJbwgeCjV6t3f6xRsJc+10mIya7eB2NmfHS+l6ICGdYgxfUWCVGgkLHf5wH7HbZBuPrtoMreyW1TzM1uwfxp6PKVhoxd5cejwKUahi+EG22EEJkHyBFxuj2N4DnO7IS2rDT7HcCkESPuFwW28UvGVlo9xZwAaC5fXdQx4KqePDJiqgk/j5p4jcc7HGfysHJCe8pNIw3UqtH3RqkMladA6eU7TkWEc9mhfgw4g6c6aMCHB1fQfzbAWtP3RKRWjoMMYbNiNMaiaBe7PjbGWGuPmvrfdZRaXwgg/vsigKZYRVDq4H4mUfA+9APE6B3gTyvnaBtdNAS8DTEm7bQJr2Nx8TDS/rj6akWODtX+eHe
 vzXz6YdT
 GJkTk5hzPAJiNELjhOX14C20fJCDiW1CFEIcaAn4naILvdm5QTpRBF693OJ1gSD/eP6Mp/hKifKxODdbCp1NZWpl1n85MkQD8Qgjd+rTGIFXY5Y0pSXGYcmDYvTrnuEx4A6aoKqupQccqpNtqAXcdiATN2uKhpUQ+2zZYNFACcsOmEjGpPr5oENZQr5RD1KIxCPa/fzhdbPw1IosQhxIhiczb1g==
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


