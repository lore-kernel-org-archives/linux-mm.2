Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC2A9C87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 07:39:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 637DA6B008A; Wed, 30 Jul 2025 03:39:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60F1C6B008C; Wed, 30 Jul 2025 03:39:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 525276B0092; Wed, 30 Jul 2025 03:39:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4275F6B008A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 03:39:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 19706113A88
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 07:39:57 +0000 (UTC)
X-FDA: 83720132034.11.157D1C5
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	by imf23.hostedemail.com (Postfix) with ESMTP id 13567140009
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 07:39:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=iCr0PnO5;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf23.hostedemail.com: domain of "prvs=2993f5a26=acsjakub@amazon.de" designates 52.119.213.150 as permitted sender) smtp.mailfrom="prvs=2993f5a26=acsjakub@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753861195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oVpHujIKEbwnOnxA22ZIgd8V/890VYrstz1N5qLXglg=;
	b=SzMoxcTB2+W8WjaUMUl86SKumMhxWmDevdUtR/kYc2/XffAMh41IKMOL7I169Y6lU2Ygew
	lXKOt9j6VY89Ve4oC+rfaYT7qd5PUBXuVYfuwu/LQ54v1nim4+06gx/4kt8qPHq4Jfe0cI
	v7PpDufTF0/bI2Bz3McWfQjdBLICAFo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753861195; a=rsa-sha256;
	cv=none;
	b=yy1Hramnz3iwtRhW5oL9nqM9BObiyHbnk1RT/AJUuCz/HBmEVqoKtqfhlsEdx9+cnM+p+K
	AmNltVNAAz300+mllIdmtDz5CEj6dxpyJXkSyvF2N5DUdl4njoz0PAb72Teu+RFwqfXOQS
	qboJRcmfDR5bskn6sDXNKHgQaQFEKIs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=iCr0PnO5;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf23.hostedemail.com: domain of "prvs=2993f5a26=acsjakub@amazon.de" designates 52.119.213.150 as permitted sender) smtp.mailfrom="prvs=2993f5a26=acsjakub@amazon.de"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1753861195; x=1785397195;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oVpHujIKEbwnOnxA22ZIgd8V/890VYrstz1N5qLXglg=;
  b=iCr0PnO58ZXRE40SYDr9JLT/7h1/vVYDDMXbRbfsUGI7q3zE7reyOVhD
   u1ZcA+iCJQZW66QedvCGvLYvTzVHKvw/Z/yIUxeN2BHvW19Mo9cQcVFQT
   sI0ywX35V3VG+Hq3HJfRyf+uGdKoyKRHjQ49QzCwFtevUzNiPmZ34ViMP
   HIfSwPcwZXT7vV/9nFwINMrKZa2Kd5WTNcL7yr0ylFp0fItUCRrHUTbAG
   WAIiDURePTPI6DKjqJ5q+zLuJaQl8WbeoE6kD6y9vspd1ZInN1WxW4q/y
   EOjMgrPjDy5gpCqHLdHWxKyhxcnaLM2xmIko2x6HFj1VfEugv29NZqu21
   w==;
X-IronPort-AV: E=Sophos;i="6.16,350,1744070400"; 
   d="scan'208";a="744797884"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 07:39:51 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.21.151:2512]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.6.204:2525] with esmtp (Farcaster)
 id 902956ed-3570-4762-a792-007f85fb3c06; Wed, 30 Jul 2025 07:39:50 +0000 (UTC)
X-Farcaster-Flow-ID: 902956ed-3570-4762-a792-007f85fb3c06
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Wed, 30 Jul 2025 07:39:50 +0000
Received: from dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com
 (172.19.75.107) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Wed, 30 Jul 2025
 07:39:47 +0000
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
Subject: [PATCH v2 6.12.y] mm: khugepaged: fix call hpage_collapse_scan_file() for anonymous vma
Date: Wed, 30 Jul 2025 07:39:45 +0000
Message-ID: <20250730073945.27790-1-acsjakub@amazon.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
X-Originating-IP: [172.19.75.107]
X-ClientProxiedBy: EX19D041UWB001.ant.amazon.com (10.13.139.132) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fkxmyh8cmkn9x5qc6qsm5t8pzqs4nm89
X-Rspamd-Queue-Id: 13567140009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753861194-596767
X-HE-Meta: U2FsdGVkX18OAHi0kFfUFhAP65Oqa8p5zinjNiKDWOD8/Ytq9NDyiPZPFociNuJQcDhjI/cnmjdj+f9yGfCNBsw7JCkVKLJ9I2FW4tFf3Cv4szMP9KBaBr2M6dxhSMpqLvp8GdyW3NweKAyB8MRpPoU47dXq+Ee7B+WckKvVn6ZMyCryhE3NsJ08Sjnw2rRBIhp+t5UpWX4znX7ySBO+AcSCOxC0Kqe8kbjUSqeNhO7P0iniXPLImrfKPJgrCZjFRXEw/Il4Z2kS+y8q0RYBufenICnt2iwZLYTQvrc58vgotdMdYI4q3viIMLiDb3AIpnhjfh7UZsMRlL8R1ZW6sF1DWm0FaYVoTFI06NAzgREpw25pmomlKykHQpIIWwl0wMKULdPUmL2BJlIXX/pl7iThOc1LKV6fU7wpAtIbMjr2ITR4dJKztIHQM1LAZbbx/cQSTvUl5lYmXcrpROhHq2cpsLUUw2611SZpEKm8xCUSL3DiVoCw3E5ca5p3vi4z4z4suQNg/p2d4FPob2NgoTRwxwzSFifdyJ6UaN4HjqdgLQj5Qfr6GJYqO3PebqN4Ver85iVP0gLExmTl4izstDDzLWVuB6Zkhd6inMgO/B5h2AJXshRStMsJpTEQK1afFtkn0LMZbckLLheg1Nl7kG39EvdGGOPicfvZZ6SE1XPlah2DM0pLzk6Vc8zGpC0fe4GVWTy4AMcyo7N+bObKQzTmFk4vC8bCJUL9Wz/Gqd34vHPunMRn1Kc89a7T8ZkBgTRmhamo08MmsMSlHG/8NRi7edGYDXnxO+6fyNWN+YX9pMLAsiSi3QQQafnXogfbC+i1w1wsrkPwReBMLL1L22b1BOIzBAhClCkx2oKBRSmmptCfBcgsZO65h6iYD0u/ETWZ8r8+66QYx+b/kv6d7it9WnicQ+dqCUa4jXkWVxAUfXoyOf0Uessnp5UnlVFhyDz6wow/i/xgFBCc2Rd
 8NGGhL2o
 OxexPygY8dzPShran90R9RFJh8xIAfZccsCqQK3Yn5x2jCx3ZQP8qEdB0U63C9lQ5OMbbtXozNt9TjJdjqkBrhDpQ297cfcVCQG74wNWTwsRcmLF75C9b6ulT0PHwX0Krovxj+k4HooewhM9elZzK0UMb3P7ynOn5QQ61C0cMkOtIak3SiWsRXueYl3soh+O+FGc0D5HXVtmDHnyi0qn/m6EFMDLaQUCc6qYdcuaSFqYNHgu/rU58tA62NWh6N3lrhkJJGMA6c8RqDW1YHtsdjrYC9Iv+CO/67LIgByihL1DFQQ5x7KdI13Gj+vjj5xVpU780JWtvKD1YlLJg/V/lPSE+aA/9QtabPMehnsJ1KjphhxpvOT50O0Ha5DZ3VfWQLjQ+nIFZid0crJq6oVgdnG8tYTYuwIlm2BPlpYQj4bDCoETy1mdzMXycnRkos9lieWxrO8g5PPbvddl7nNfhvwynjsNcph6AhWd7PAKc5GFt5GCILEpK6R55Av4BEr/yyziyjsIDayWdhbeB6j6XzALZvoaSBN9y7Tt0gI77Z/t/6mSvq6Fr5m74atwreyTGBeq3ErgB6Vsov4fUQQDXbQ5R3I9f7dIgVL5AvNbiUqmJ0BlUGu7PgKzM+r4TiQinPh5EymnAuF/AIu0DnrEi8PvU0SR0ivM+Ez/0TAcKOWQW8Nd2FZ5rWPDklGrOODmUrBflcanE2+fj2/1oSFb7LNPPHh1ypk1rIMys5K8z0FmOTyUGEPjUL53cu/eHt2NyyohDNFydXK2FWmg3IFxzUl2e2OsO0bgkdhKlqYMBxRFd4fQ5ZzcWTNRbkB7s9sYIlqiRugADvvngndk6B71Q8KZLrm/apaY3ilT/lyCDSf+Q2e82Ilv8OkW4KqApgAzXnmOTRT/kPcjW4Ko6mcvPUTkVq1HR6C31FrIRuUl2u/x1Cxu5hCUQmY+qr/VRdTczL2kNWzcx3etyGctLnq3uM5Y7sA==
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


