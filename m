Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31983C87FCC
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 07:40:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDE116B0092; Wed, 30 Jul 2025 03:40:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB5586B0093; Wed, 30 Jul 2025 03:40:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACAF56B0095; Wed, 30 Jul 2025 03:40:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C8CF6B0092
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 03:40:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2EDAE160369
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 07:40:07 +0000 (UTC)
X-FDA: 83720132454.08.4A2210F
Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	by imf27.hostedemail.com (Postfix) with ESMTP id 20C0A40014
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 07:40:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=lcLcTwbs;
	spf=pass (imf27.hostedemail.com: domain of "prvs=2993f5a26=acsjakub@amazon.de" designates 35.83.148.184 as permitted sender) smtp.mailfrom="prvs=2993f5a26=acsjakub@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753861205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oVpHujIKEbwnOnxA22ZIgd8V/890VYrstz1N5qLXglg=;
	b=DrlDGOuPo0vPUEGH4xibM2NaMr+05GM7ueQHfKkBA+HjqAtSM6TOJELn6XGjdNh2AZ6ush
	QdV1uyHPJP2R6ejLS9B0DylsrkRL0/o9mhRk1WWBPAl9Kp8s+iwhlY9428B9IZtqmR6Qs0
	xKHvwOzGJEjQzKO5olv+mSWyWDwQdcI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753861205; a=rsa-sha256;
	cv=none;
	b=TMhOVTEoHhgOUulcu/m6POyaxGz2D33kCw/9nEZ9sB7F7LC2waxcVKopKJ0rfg5M0lB04Q
	JBsh4Q4jHNlWYcjVLkJHzGqNyvHi7FrzWaGlFlaCzAinAwjwRiYSleUVzDWveIEGWrozD1
	unvK0FPZHsaad65U5aVAZZ5lDypnwiA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=lcLcTwbs;
	spf=pass (imf27.hostedemail.com: domain of "prvs=2993f5a26=acsjakub@amazon.de" designates 35.83.148.184 as permitted sender) smtp.mailfrom="prvs=2993f5a26=acsjakub@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1753861205; x=1785397205;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oVpHujIKEbwnOnxA22ZIgd8V/890VYrstz1N5qLXglg=;
  b=lcLcTwbsYIj8Y5aeOQ7PFXdG9BB8+pln9rWDcdjxNKLqajhMpODfrEHa
   Htfx+VDaIWDl5kX16UXpokmhsz3ZCDW3B4o3HYCljyA3WczkmvQBw1k61
   t817hknpBYzoVQyfHJkUsUfREd09Zgzii5iISqDoH+2MGWccWOGb8SMBa
   ZgAO798HtvOqgr4eodvLfsNbiLYMDEcl5LNBxzVlwJuqq28xVgrpsJw7S
   H5n8gDUzi3i9DenakktiFvrLqrniJFnhYuWCC4ben4Xo+okTBrXkk4HUm
   ieMfm6nU6FGoioZurq8KWwe2ZkfroMj6gEEkPnjMbqr3AG0JcKbC//v9J
   w==;
X-CSE-ConnectionGUID: gm7wNxP5RpmoZVw74YYchQ==
X-CSE-MsgGUID: /fip8p6wQ0iB3NhaAyMizA==
X-IronPort-AV: E=Sophos;i="6.16,315,1744070400"; 
   d="scan'208";a="485516"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 07:40:02 +0000
Received: from EX19MTAUWC001.ant.amazon.com [10.0.7.35:23759]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.47.123:2525] with esmtp (Farcaster)
 id 4b8cb275-d069-4bbb-a52f-1eb267c64954; Wed, 30 Jul 2025 07:40:01 +0000 (UTC)
X-Farcaster-Flow-ID: 4b8cb275-d069-4bbb-a52f-1eb267c64954
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Wed, 30 Jul 2025 07:40:01 +0000
Received: from dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com
 (172.19.75.107) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Wed, 30 Jul 2025
 07:39:59 +0000
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
Subject: [PATCH v2 6.6.y] mm: khugepaged: fix call hpage_collapse_scan_file() for anonymous vma
Date: Wed, 30 Jul 2025 07:39:56 +0000
Message-ID: <20250730073956.28488-1-acsjakub@amazon.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
X-Originating-IP: [172.19.75.107]
X-ClientProxiedBy: EX19D040UWB002.ant.amazon.com (10.13.138.89) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 20C0A40014
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: ht365rbmey1w3c9tbnkaopa8qcwqoujp
X-HE-Tag: 1753861204-284597
X-HE-Meta: U2FsdGVkX181z4Fwnqw5yagTMSI0OaEouL630pJ4Ap7w9jjwqGQAiKTJ6sRc/zbWW1b+vZ+p1+TMzJUuZSnn2NDsBdyp2wsHisInOr68XJw3GpwAThDu863Cv5Ad+3AT+cHLt2g36e8MTo5GpRUcwd/fhF0Gk2IrgQ4wWqNoM+vmqiP2a7/QVB6QKb3WOjJTGhsSWD0Ki/t/U10CLR2z6E7OJbtE8qcbQ4mgMqrtvXHbKqD9r19qrN9XhpPa6zK9A3Lhdfrhvw+jT7LrBl4iMxXdlhQL2PLNboVMQsa+5O82600mKmo5X09o1sESa65iMzpQl6GW2siwhxJfCUDjY586Wx2V9FR0DiX02VkN2JKRoTMTANZ5/kGYB0PTygB/AceSd0Zpr/U8nKLyXZ7McrNB3lDWnftvNNfwqXdrvmH/7Mmny1DgY6AkicnOutWzOlJ65Wzl8VOrTwwMyJ5MAMmxL72HjG3N69zXuRrCXLIEP32JtkPhvdQBxNsgRZxFkueaZaMUda6wKuI2NG6ismnOsHbVKatbMA55eqQ64bYkKhaSF91fzhuW8xor1ve4MM5Bp/O+gZ+XCjsMFT2ez965pf6KbC8YLnxEyhL7LOQtbgCD8okqKOqnWBmQhCOgxw/wTQDE5OP+QnTrCRwmaOEovxWdg/FjBbMCsQAdFGBr6iGBrbSZLG7djVWr2FplAEUuDACSLcDs9f7TkLz4x+jGgphB7t18VfOOl05ZJoznWV4p/b+imQF02mqyCnicID0TlNpsFr3oADk6zGLxeekcetzYrPEP8yguK6QQiBIZWmGIOB4bXlyAtEAqsoa8z2UQpxw2cvSV3A4HjisN3OVfX52sPccfJFDka0BIcYGjVju4dV2tIlIPmiBPhTh/R2BRH06EpPiFkpzMqLYEy20fvHN3wvGqo7zByst46c6Xp4iYYXJe66LxaaR+fHAguhIDjsXk/wqzOq957sZ
 IC/C8tYT
 Y7HHp/MrhTDzjRHM96mTK63jpx5WObIhekfMZ2TDf96OeVkXh494RBah/gS42bzHvLPAE4mnQqPR7R+Tcfqzg0tH74phCe2LnOfs3+Yw4eiYbk3zXxPRV7hoR2GRoYJv5/4rw8yjCvDVqVNiPWV4vnQIwsLBoF3aVzK3DdN5Z4oN+Bx4padrY0SBLeRx2r5Kitfii5Aa5TDIEYOZZo3QVF0l6eFPleCUqc2D4pgrtw94QNojh32cmP25YZB1s/+qJ0ceDoI8T94WSmG4UODNrR6tBNNaHa4n/nzZio10AttRJI41JM+YHMapTL4BpZ7IzKE08YBPjapo/SfIA44UO7vVzvoPjTVaZD9IsQxi79oTfW7Q3NTMQeh8eZTb0FEbYZ+XIjLg9bdRH6BZI3TY8ez5sYP9i8yyqWThF6frg0Qa2wgU8F3iNPnheuDNwGO6CbAmIIayefdlQaggKkftpGetoVfsaGtpPfIYRVGxSsjOSt5Qht85ACyEV6Ry4DlygHqHjZBLfqFNDpNWoRoi9VmEmWv4pwEen1V5feVojyM39B2zT/+nWShrCH4igvE1sVZM5LsxK1LQ6C9UnyQBs9ZjG6+Mri881esolRBazXea9vbkp8FaHBII/Bd0kXQ7+GYWEsbCYuRJJbpcjUpCE8GbUkkz3QqoHxNFp1JmedJ2MHhHnwxky3n0vWH6w/aDQ2gFxCySM/GoG1CCkkE+4LqiboNnPETg5W6lc4yA86g3HjHsav2LT+onqNmhpbEhK67jnbYBEb6VxpIhx6TN77jhhYm4l1Lg/JdxB42JIvLwYqqvGzNvUoXnQgO6HES7htaJb7+ItNJZeo6Be728NXWwiol7s3WaPY2rw8G/9Dkj/YBjEGYXaOdWqYJHmg+3mpAsBlzcKBQ7uAnYgkvh196/+g+Ywo0PXVKXsgdMXRjcehOT4EGPeN29Oco0SPlpPOezUXvzNl8+IzGnpzwxKtVe05A==
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


